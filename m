Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbXKAIdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbXKAIdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 04:33:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXKAIdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 04:33:33 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57786 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753415AbXKAIdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 04:33:32 -0400
Date: Thu, 1 Nov 2007 01:32:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Gary Hade <gary.hade@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] x86: check boundary in count/setup_resource called by
 get_current_resources
Message-Id: <20071101013239.992840bd.akpm@linux-foundation.org>
In-Reply-To: <200711010120.30410.yinghai.lu@sun.com>
References: <200711010120.30410.yinghai.lu@sun.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Nov 2007 01:20:29 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:

> [PATCH] x86: check boundary in count/setup_resource called by get_current_resources
> 
> need to check info->res_num less than PCI_BUS_NUM_RESOURCES, so
> info->bus->resource[info->res_num] = res will not beyond of bus resource array
> when acpi resutrn too many resource entries.
> 

Isn't this a bit of a problem?  It sounds like PCI_BUS_NUM_RESOURCES is to
small for that system?  If so, some sort of dynamic allocation might be
needed.

> 
> Index: linux-2.6/arch/x86/pci/acpi.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/acpi.c
> +++ linux-2.6/arch/x86/pci/acpi.c
> @@ -77,9 +77,13 @@ count_resource(struct acpi_resource *acp
>  	struct acpi_resource_address64 addr;
>  	acpi_status status;
>  
> +	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> +		return AE_OK;
> +
>  	status = resource_to_addr(acpi_res, &addr);
>  	if (ACPI_SUCCESS(status))
>  		info->res_num++;
> +
>  	return AE_OK;
>  }

grump.  I don't know why people like a blank line before `return': it's
just a waste of screen space.  And the surrounding code in
arch/x86/pci/acpi.c doesn't do this either.

> @@ -93,6 +97,9 @@ setup_resource(struct acpi_resource *acp
>  	unsigned long flags;
>  	struct resource *root;
>  
> +	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> +		return AE_OK;

And should we really be silently ignoring this problem?  Should we at least
report it?

>  	status = resource_to_addr(acpi_res, &addr);
>  	if (!ACPI_SUCCESS(status))
>  		return AE_OK;
>  
