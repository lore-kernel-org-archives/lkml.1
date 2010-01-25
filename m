Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140Ab0AYWW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140Ab0AYWW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 17:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754111Ab0AYWW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 17:22:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:11626 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab0AYWW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 17:22:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=H5A4CKR8fujIvFeFnU05IfxffjRRcQ573Mnwy5xdPDMI9c9F/nyxB8Cb2eNshFP6D
	1uQDYhPrz7JxFaNUwt2Yw==
Date: Mon, 25 Jan 2010 14:22:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alex Chiang <achiang@hp.com>
cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/12] ACPI: processor: refactor internal
 map_lsapic_id()
In-Reply-To: <20100125214129.28510.72412.stgit@bob.kio>
Message-ID: <alpine.DEB.2.00.1001251421440.27862@chino.kir.corp.google.com>
References: <20100125213221.28510.74078.stgit@bob.kio> <20100125214129.28510.72412.stgit@bob.kio>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010, Alex Chiang wrote:

> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index 9213f95..ec5989c 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -83,27 +83,17 @@ static int map_lsapic_id(struct acpi_subtable_header *entry,
>  {
>  	struct acpi_madt_local_sapic *lsapic =
>  		(struct acpi_madt_local_sapic *)entry;
> -	u32 tmp = (lsapic->id << 8) | lsapic->eid;
>  
> -	/* Only check enabled APICs*/
>  	if (!(lsapic->lapic_flags & ACPI_MADT_ENABLED))
>  		return 0;
>  
> -	/* Device statement declaration type */
>  	if (device_declaration) {
> -		if (entry->length < 16)
> -			printk(KERN_ERR PREFIX
> -			    "Invalid LSAPIC with Device type processor (SAPIC ID %#x)\n",
> -			    tmp);

Why drop this error message?

> -		else if (lsapic->uid == acpi_id)
> -			goto found;
> -	/* Processor statement declaration type */
> -	} else if (lsapic->processor_id == acpi_id)
> -		goto found;
> +		if ((entry->length < 16) || (lsapic->uid != acpi_id))
> +			return 0;
> +	} else if (lsapic->processor_id != acpi_id)
> +		return 0;
>  
> -	return 0;
> -found:
> -	*apic_id = tmp;
> +	*apic_id = (lsapic->id << 8) | lsapic->eid;
>  	return 1;
>  }
>  
