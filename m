Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbZIYSux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbZIYSux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 14:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751897AbZIYSuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 14:50:52 -0400
Received: from www17.your-server.de ([213.133.104.17]:52035 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZIYSuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 14:50:52 -0400
X-Greylist: delayed 1597 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2009 14:50:51 EDT
Subject: Re: [PATCH] acpi: fix null pointer deference of hardware_id string
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <lenb@kernel.org>, linux-acpi <linux-acpi@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <1250133125.4044.19.camel@minggr.sh.intel.com>
References: <1250133125.4044.19.camel@minggr.sh.intel.com>
Content-Type: text/plain
Date: Fri, 25 Sep 2009 20:24:13 +0200
Message-Id: <1253903053.26639.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 13.08.2009, 11:12 +0800 schrieb Lin Ming:
> From: Lin Ming <ming.m.lin@intel.com>
> Date: Thu, 13 Aug 2009 11:04:47 +0800

Another month, another git repository...

Are there any reasons why the patch below didn't land in linus' git
tree?

> Subject: [PATCH] acpi: fix null pointer deference of hardware_id string
> 
> This regression was caused by commit ed44482
> "ACPICA: Major update for acpi_get_object_info external interface"
> 
> Don't need to set hardware_id string \0 terminated here,
> acpi_get_object_info already handles it.
> 
> Tested-by: Thomas Meyer <thomas@m3y3r.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  drivers/char/agp/hp-agp.c         |    6 ++++--
>  drivers/pci/hotplug/acpiphp_ibm.c |    1 -
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
> index 7bead4c..d83c4a8 100644
> --- a/drivers/char/agp/hp-agp.c
> +++ b/drivers/char/agp/hp-agp.c
> @@ -492,8 +492,10 @@ zx1_gart_probe (acpi_handle obj, u32 depth, void *context, void **ret)
>  		status = acpi_get_object_info(handle, &info);
>  		if (ACPI_SUCCESS(status)) {
>  			/* TBD check _CID also */
> -			info->hardware_id.string[sizeof(info->hardware_id.length)-1] = '\0';
> -			match = (strcmp(info->hardware_id.string, "HWP0001") == 0);
> +			if (info->valid & ACPI_VALID_HID)
> +				match = !strcmp(info->hardware_id.string, "HWP0001");
> +			else
> +				match = 0;
>  			kfree(info);
>  			if (match) {
>  				status = hp_acpi_csr_space(handle, &sba_hpa, &length);
> diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
> index a9d926b..e7be66d 100644
> --- a/drivers/pci/hotplug/acpiphp_ibm.c
> +++ b/drivers/pci/hotplug/acpiphp_ibm.c
> @@ -406,7 +406,6 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
>  			__func__, status);
>  		return retval;
>  	}
> -	info->hardware_id.string[sizeof(info->hardware_id.length) - 1] = '\0';
>  
>  	if (info->current_status && (info->valid & ACPI_VALID_HID) &&
>  			(!strcmp(info->hardware_id.string, IBM_HARDWARE_ID1) ||
> 
> 

