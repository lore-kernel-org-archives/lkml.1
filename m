Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYAWTkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYAWTkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 14:40:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbYAWTk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 14:40:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:39367 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751727AbYAWTkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 14:40:25 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Patterson <andrew.patterson@hp.com>, robert.moore@intel.com
Subject: Re: [PATCH 3/4] ACPI: Check for any matching CID when walking namespace.
Date: Wed, 23 Jan 2008 14:39:42 -0500
User-Agent: KMail/1.9.5
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de,
       matthew@wil.cx, tom.l.nguyen@intel.com, linux-acpi@vger.kernel.org
References: <20080123001807.28190.32648.stgit@bluto.andrew> <20080123001822.28190.3147.stgit@bluto.andrew>
In-Reply-To: <20080123001822.28190.3147.stgit@bluto.andrew>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231439.42735.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right Greg, this is not only an ACPI patch, 
but a patch that touches the ACPICA core.
Lets get Bob to see if it applies to the latest upstream ACPICA code.

Andrew,
Do you give Intel permission to accept this patch under
both licenses on the top of the file, such that we can
re-distribute it in ACPICA to all the OSs that use ACPICA?

(hey, and check out the spiffy new acpica home page: http://acpica.org/ )

thanks,
-Len

On Tuesday 22 January 2008 19:18, Andrew Patterson wrote:
> From: Andrew Patterson <andrew.patterson@hp.com>
> 
> The callback function acpi_ns_get_device_callback called from
> acpi_get_devices() will check CID's if the HID does not match.  This code
> has a bug where it requires that all CIDs match the HID. Changed the code
> so that any CID match will do.
> 
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
> ---
> 
>  drivers/acpi/namespace/nsxfeval.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/acpi/namespace/nsxfeval.c b/drivers/acpi/namespace/nsxfeval.c
> index f39fbc6..e562b24 100644
> --- a/drivers/acpi/namespace/nsxfeval.c
> +++ b/drivers/acpi/namespace/nsxfeval.c
> @@ -443,6 +443,7 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
>  	struct acpica_device_id hid;
>  	struct acpi_compatible_id_list *cid;
>  	acpi_native_uint i;
> +	int found;
>  
>  	status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
>  	if (ACPI_FAILURE(status)) {
> @@ -496,16 +497,20 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
>  
>  			/* Walk the CID list */
>  
> +			found = 0;
>  			for (i = 0; i < cid->count; i++) {
>  				if (ACPI_STRNCMP(cid->id[i].value, info->hid,
>  						 sizeof(struct
> -							acpi_compatible_id)) !=
> +							acpi_compatible_id)) ==
>  				    0) {
> -					ACPI_FREE(cid);
> -					return (AE_OK);
> +					found = 1;
> +					break;
>  				}
>  			}
>  			ACPI_FREE(cid);
> +			if (!found) {
> +				return (AE_OK);
> +			}
>  		}
>  	}
>  
> 
