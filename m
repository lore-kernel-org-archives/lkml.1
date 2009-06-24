Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbZFXOxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbZFXOxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbZFXOx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:53:26 -0400
Received: from www.tglx.de ([62.245.132.106]:54769 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364AbZFXOxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:53:25 -0400
Date: Wed, 24 Jun 2009 16:51:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Larry Finger <Larry.Finger@lwfinger.net>, Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
In-Reply-To: <1245845787.3093.3.camel@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0906241643510.2767@localhost.localdomain>
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Jaswinder Singh Rajput wrote:
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/pci/acpi.c |   16 ++++++++++------
>  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
> index 16c3fda..0bc015f 100644
> --- a/arch/x86/pci/acpi.c
> +++ b/arch/x86/pci/acpi.c
> @@ -69,6 +69,9 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
>  	struct resource *root;
>  	int max_root_bus_resources = PCI_BUS_NUM_RESOURCES;
>  
> +	if (info->res_num >= PCI_BUS_NUM_RESOURCES)
> +		return AE_OK;
> +
>  	status = resource_to_addr(acpi_res, &addr);
>  	if (!ACPI_SUCCESS(status))
>  		return AE_OK;
> @@ -94,17 +97,18 @@ setup_resource(struct acpi_resource *acpi_res, void *data)
>  	if (bus_has_transparent_bridge(info->bus))
>  		max_root_bus_resources -= 3;
>  	if (info->res_num >= max_root_bus_resources) {
> -		printk(KERN_WARNING "PCI: Failed to allocate 0x%lx-0x%lx "
> -			"from %s for %s due to _CRS returning more than "
> -			"%d resource descriptors\n", (unsigned long) res->start,
> -			(unsigned long) res->end, root->name, info->name,
> -			max_root_bus_resources);
> +		pr_warning("PCI: Failed to allocate 0x%lx-0x%lx "
> +			   "from %s for %s due to _CRS returning more than "
> +			   "%d resource descriptors\n",
> +			   (unsigned long)res->start, (unsigned long)res->end,
> +			   root->name, info->name, max_root_bus_resources);

Can you please avoid mixing cleanup patches with bug fixes ? I almost
did not see the line below.

> +		info->bus->resource[info->res_num] = res;

Storing the resource in defeats the purpose of the original patch,
which makes sure that we do _NOT_ use the last 3 slots of the resource
array for a root bus with a transparent bridge.

>  		info->res_num++;

This is the real bug. info->res_num should not be incremented when we
run out of resources already.

>  		return AE_OK;

Thanks,

	tglx
