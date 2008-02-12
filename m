Return-Path: <linux-kernel-owner+w=401wt.eu-S1757404AbYBLXmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbYBLXmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 18:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753083AbYBLXmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 18:42:15 -0500
Received: from mga11.intel.com ([192.55.52.93]:63672 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbYBLXmN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 18:42:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,342,1199692800"; 
   d="scan'208";a="517514990"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4] ACPI: Check for any matching CID when walking namespace.
Date: Tue, 12 Feb 2008 15:38:07 -0800
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A40435C47B@orsmsx415.amr.corp.intel.com>
In-Reply-To: <200801231439.42735.lenb@kernel.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] ACPI: Check for any matching CID when walking namespace.
Thread-Index: Achd98twlSueIdOKScG+knUARrMVOQP2GoPQ
References: <20080123001807.28190.32648.stgit@bluto.andrew> <20080123001822.28190.3147.stgit@bluto.andrew> <200801231439.42735.lenb@kernel.org>
From: "Moore, Robert" <robert.moore@intel.com>
To: "Len Brown" <lenb@kernel.org>,
       "Andrew Patterson" <andrew.patterson@hp.com>
Cc: <linux-pci@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <gregkh@suse.de>, <matthew@wil.cx>,
       "Nguyen, Tom L" <tom.l.nguyen@intel.com>, <linux-acpi@vger.kernel.org>
X-OriginalArrivalTime: 12 Feb 2008 23:38:42.0197 (UTC) FILETIME=[6698BC50:01C86DD0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I've rolled this in:

			/* Walk the CID list */

			found = FALSE;
			for (i = 0; i < cid->count; i++) {
				if (ACPI_STRNCMP (cid->id[i].value,
info->hid,
						sizeof (struct
acpi_compatible_id)) == 0) {

					/* Found a matching CID */

					found = TRUE;
					break;
				}
			}

			ACPI_FREE (cid);
			if (!found) {
				return (AE_OK);
			}
		}
	}

	/* We have a valid device, invoke the user function */

	status = info->user_function (obj_handle, nesting_level,
info->context,
			 return_value);
	return (status);
}


Thanks,
Bob


>-----Original Message-----
>From: Len Brown [mailto:lenb@kernel.org]
>Sent: Wednesday, January 23, 2008 11:40 AM
>To: Andrew Patterson; Moore, Robert
>Cc: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
>gregkh@suse.de; matthew@wil.cx; Nguyen, Tom L;
linux-acpi@vger.kernel.org
>Subject: Re: [PATCH 3/4] ACPI: Check for any matching CID when walking
>namespace.
>
>Right Greg, this is not only an ACPI patch,
>but a patch that touches the ACPICA core.
>Lets get Bob to see if it applies to the latest upstream ACPICA code.
>
>Andrew,
>Do you give Intel permission to accept this patch under
>both licenses on the top of the file, such that we can
>re-distribute it in ACPICA to all the OSs that use ACPICA?
>
>(hey, and check out the spiffy new acpica home page: http://acpica.org/
)
>
>thanks,
>-Len
>
>On Tuesday 22 January 2008 19:18, Andrew Patterson wrote:
>> From: Andrew Patterson <andrew.patterson@hp.com>
>>
>> The callback function acpi_ns_get_device_callback called from
>> acpi_get_devices() will check CID's if the HID does not match.  This
code
>> has a bug where it requires that all CIDs match the HID. Changed the
code
>> so that any CID match will do.
>>
>> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
>> ---
>>
>>  drivers/acpi/namespace/nsxfeval.c |   11 ++++++++---
>>  1 files changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/acpi/namespace/nsxfeval.c
>b/drivers/acpi/namespace/nsxfeval.c
>> index f39fbc6..e562b24 100644
>> --- a/drivers/acpi/namespace/nsxfeval.c
>> +++ b/drivers/acpi/namespace/nsxfeval.c
>> @@ -443,6 +443,7 @@ acpi_ns_get_device_callback(acpi_handle
obj_handle,
>>  	struct acpica_device_id hid;
>>  	struct acpi_compatible_id_list *cid;
>>  	acpi_native_uint i;
>> +	int found;
>>
>>  	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
>>  	if (ACPI_FAILURE(status)) {
>> @@ -496,16 +497,20 @@ acpi_ns_get_device_callback(acpi_handle
obj_handle,
>>
>>  			/* Walk the CID list */
>>
>> +			found = 0;
>>  			for (i = 0; i < cid->count; i++) {
>>  				if (ACPI_STRNCMP(cid->id[i].value,
info->hid,
>>  						 sizeof(struct
>> -
acpi_compatible_id)) !=
>> +
acpi_compatible_id)) ==
>>  				    0) {
>> -					ACPI_FREE(cid);
>> -					return (AE_OK);
>> +					found = 1;
>> +					break;
>>  				}
>>  			}
>>  			ACPI_FREE(cid);
>> +			if (!found) {
>> +				return (AE_OK);
>> +			}
>>  		}
>>  	}
>>
>>
