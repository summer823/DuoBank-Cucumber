@API
Feature: PUT /user API endpoint features

  Scenario: The API should require an authentication via API key

    Given the request is not authenticated with a valid API key
    And the request "Content-type" header is set to "application/json"
    When I send a "PUT" request to endpoint "/user"
    Then the response log should be displayed
    Then the response status code should be 401
    Then the response body should have "message" field with value "Invalid or missing API Key. Provide a valid api key with 'api_key' query parameter."


  Scenario Outline: The API should require valid user ID to be included in the request query parameter - negative scenario

    Given the request is authenticated with a valid API key
    And the request "Content-type" header is set to "application/json"
    And the request "id" query parameter is set to "<id>"
    When I send a "PUT" request to endpoint "/user"
    Then the response log should be displayed
    Then the response status code should be 400
    Then the response body should have "message" field with value "Bad request. User id is not provided."
    Examples:
    |id|
    |  |
    |abc|


  Scenario: User with no such ID exists in the DB

    Given the request is authenticated with a valid API key
    And the request "Content-type" header is set to "application/json"
    And the request "id" query parameter is set to "1222"
    When I send a "PUT" request to endpoint "/user"
    Then the response log should be displayed
    Then the response status code should be 404
    Then the response body should have "message" field with value "User not found."

  @today
  Scenario: User information is successfully updated in the database

    Given the request is authenticated with a valid API key
    And the request "Content-type" header is set to "application/json"
    And the request "id" query parameter is set to "12"
    And the request body is set to the following payload
      """
      {
        "firstName": "Bill",
        "lastName": "Clinton",
        "email": "Clinton@mail.com",
      }
      """

    When I send a "PUT" request to endpoint "/user"
    Then the response log should be displayed
    And the response status code should be 200
    And the response "Content-Type" header should be "application/json"
    And the response body should have "message" field with value "User updated successfully"



  Scenario: A field missing from the request body

    Given the request is authenticated with a valid API key
    And the request "Content-type" header is set to "application/json"
    And the request "id" query parameter is set to "12"
    And the request body is set to the following payload
      """
      {
        "lastName": "Clinton",
        "email": "Clinton@mail.com",
      }
      """

    When I send a "PUT" request to endpoint "/user"
    Then the response log should be displayed
    Then the response status code should be 422
    Then the response body should have "message" field with value "Missing or Invalid Required Fields!"



    Scenario: Retrieve modified_at field of the successfully updated user
      Given the request is authenticated with a valid API key
      And the request "Content-type" header is set to "application/json"
      And the request "id" query parameter is set to "12"
      And the request body is set to the following payload
      """
      {
        "firstName": "Mary",
        "lastName": "Clinton",
        "email": "Clinton@mail.com",
      }
      """

      When I send a "PUT" request to endpoint "/user"
    And the response status code should be 200
    Then the request is authenticated with a valid API key
    And the request "Content-type" header is set to "application/json"
    And the request "id" query parameter is set to "12"
      And I send a "GET" request to endpoint "/user"
      And the response log should be displayed
    And the response body should have "modified_at" field with value "2023-08-21 14:43:20"






