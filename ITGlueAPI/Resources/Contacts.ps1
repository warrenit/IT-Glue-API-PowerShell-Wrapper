function Get-ITGlueContacts {

    [CmdletBinding(DefaultParameterSetName=”index”)]
    Param (
        [Parameter()]
            [Nullable[Int]]$country_id = $null,

        [Parameter(ParameterSetName="index")]
            [String]$filter_first_name = "",
            [String]$filter_last_name = "",
            [String]$filter_title = "",
            [Nullable[Int]]$filter_contact_type_id = $null,
            [String]$filter_important = "",

            [ValidateSet( "name",  "id", `
                        "-name", "-id")]
            [String]$sort = "",

            [Nullable[Int]]$page_number = $null,
            [Nullable[int]]$page_size = $null,

        [Parameter(ParameterSetName="show")]
            [Nullable[Int]]$id = $null
    )

    $resource_uri = "/contacts/${id}"
    if($organization_id) {
        $resource_uri = "/organizations/${organization_id}/relationships" + $resource_uri
    }

    if($PSCmdlet.ParameterSetName -eq "index") {
        $body = @{
                "filter[name]" = $filter_name
                "filter[iso]" = $filter_iso
                "sort" = $sort
        }
        if($filter_country_id) {
            $body += @{"filter[country_id]" = $filter_country_id}
        }
        if($page_number) {
            $body += @{"page[number]" = $page_number}
        }
        if($page_size) {
            $body += @{"page[size]" = $page_size}
        }
    }


    $ITGlue_Headers.Add("x-api-key", (New-Object System.Management.Automation.PSCredential 'N/A', $ITGlue_API_Key).GetNetworkCredential().Password)
    $rest_output = Invoke-RestMethod -method "GET" -uri ($ITGlue_Base_URI + $resource_uri) -headers $ITGlue_Headers `
                                     -body $body -ErrorAction Stop -ErrorVariable $web_error
    $ITGlue_Headers.Remove('x-api-key') >$null # Quietly clean up scope so the API key doesn't persist

    $data = @{}
    $data = $rest_output 
    return $data
}