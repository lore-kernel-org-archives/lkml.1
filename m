Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYDZV0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYDZV0a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYDZV0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:26:18 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:52392 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYDZV0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:26:16 -0400
Message-ID: <48139DFC.500@keyaccess.nl>
Date: Sat, 26 Apr 2008 23:26:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 21/54] PNP: add debug when assigning PNP resources
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183928.375529075@ldl.fc.hp.com>
In-Reply-To: <20080425183928.375529075@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25-04-08 20:38, Bjorn Helgaas wrote:

Comments inline:

> This patch adds code to dump PNP resources before and after
> assigning resources and before writing them to the device.
> 
> This is enabled by CONFIG_PNP_DEBUG=y.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> 
> Index: work10/drivers/pnp/base.h
> ===================================================================
> --- work10.orig/drivers/pnp/base.h	2008-04-25 11:14:51.000000000 -0600
> +++ work10/drivers/pnp/base.h	2008-04-25 11:14:57.000000000 -0600
> @@ -16,3 +16,5 @@
>  int pnp_check_mem(struct pnp_dev * dev, int idx);
>  int pnp_check_irq(struct pnp_dev * dev, int idx);
>  int pnp_check_dma(struct pnp_dev * dev, int idx);
> +
> +void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc);
> Index: work10/drivers/pnp/support.c
> ===================================================================
> --- work10.orig/drivers/pnp/support.c	2008-04-25 11:14:48.000000000 -0600
> +++ work10/drivers/pnp/support.c	2008-04-25 11:14:57.000000000 -0600
> @@ -51,3 +51,44 @@
>  	str[6] = hex_asc((id >>  0) & 0xf);
>  	str[7] = '\0';
>  }
> +
> +#ifdef DEBUG
> +void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
> +{
> +	struct resource *res;
> +	int i;
> +
> +	dev_dbg(&dev->dev, "current resources: %s\n", desc);
> +
> +	for (i = 0; i < PNP_MAX_IRQ; i++) {
> +		res = &dev->res.irq_resource[i];
> +		if (!(res->flags & IORESOURCE_UNSET))
> +			dev_dbg(&dev->dev, "  irq %lld flags 0x%lx\n",
> +				(unsigned long long) res->start, res->flags);
> +	}
> +	for (i = 0; i < PNP_MAX_DMA; i++) {
> +		res = &dev->res.dma_resource[i];
> +		if (!(res->flags & IORESOURCE_UNSET))
> +			dev_dbg(&dev->dev, "  dma %lld flags 0x%lx\n",
> +				(unsigned long long) res->start, res->flags);
> +	}
> +	for (i = 0; i < PNP_MAX_PORT; i++) {
> +		res = &dev->res.port_resource[i];
> +		if (!(res->flags & IORESOURCE_UNSET))
> +			dev_dbg(&dev->dev, "  io  0x%llx-0x%llx flags 0x%lx\n",
> +				(unsigned long long) res->start,
> +				(unsigned long long) res->end, res->flags);
> +	}
> +	for (i = 0; i < PNP_MAX_MEM; i++) {
> +		res = &dev->res.mem_resource[i];
> +		if (!(res->flags & IORESOURCE_UNSET))
> +			dev_dbg(&dev->dev, "  mem 0x%llx-0x%llx flags 0x%lx\n",
> +				(unsigned long long) res->start,
> +				(unsigned long long) res->end, res->flags);
> +	}
> +}
> +#else
> +void dbg_pnp_show_resources(struct pnp_dev *dev, char *desc)
> +{
> +}
> +#endif

Not too important, but #ifdef could be inside body.

> Index: work10/drivers/pnp/manager.c
> ===================================================================
> --- work10.orig/drivers/pnp/manager.c	2008-04-25 11:14:55.000000000 -0600
> +++ work10/drivers/pnp/manager.c	2008-04-25 11:14:57.000000000 -0600
> @@ -28,20 +28,25 @@
>  		return 1;
>  	}
>  
> -	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO))
> -		return 1;
> -
>  	start = &dev->res.port_resource[idx].start;
>  	end = &dev->res.port_resource[idx].end;
>  	flags = &dev->res.port_resource[idx].flags;
>  
> +	/* check if this resource has been manually set, if so skip */
> +	if (!(dev->res.port_resource[idx].flags & IORESOURCE_AUTO)) {
> +		dev_dbg(&dev->dev, "  io %d already set to 0x%llx-0x%llx "
> +			"flags 0x%x\n", idx, (unsigned long long) *start,
> +			(unsigned long long) *end, (int) *flags);

I wanted to ask/comment why you're casting the flags to int though. It's an 
unsigned long, both in the resource and by type here. Ie, 0x%lx and no 
casting? (I btw also like %#lx better then the explicit 0x, but that doesn't 
really matter).

> +		return 1;
> +	}
> +
>  	/* set the initial values */
>  	*flags |= rule->flags | IORESOURCE_IO;
>  	*flags &= ~IORESOURCE_UNSET;
>  
>  	if (!rule->size) {
>  		*flags |= IORESOURCE_DISABLED;
> +		dev_dbg(&dev->dev, "  io %d disabled\n", idx);
>  		return 1;	/* skip disabled resource requests */
>  	}
>  
> @@ -52,9 +57,13 @@
>  	while (!pnp_check_port(dev, idx)) {
>  		*start += rule->align;
>  		*end = *start + rule->size - 1;
> -		if (*start > rule->max || !rule->align)
> +		if (*start > rule->max || !rule->align) {
> +			dev_dbg(&dev->dev, "  couldn't assign io %d\n", idx);
>  			return 0;
> +		}
>  	}
> +	dev_dbg(&dev->dev, "  assign io  %d 0x%llx-0x%llx\n", idx,
> +		(unsigned long long) *start, (unsigned long long) *end);
>  	return 1;
>  }
>  
> @@ -69,14 +78,18 @@
>  		return 1;
>  	}
>  
> -	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO))
> -		return 1;
> -
>  	start = &dev->res.mem_resource[idx].start;
>  	end = &dev->res.mem_resource[idx].end;
>  	flags = &dev->res.mem_resource[idx].flags;
>  
> +	/* check if this resource has been manually set, if so skip */
> +	if (!(dev->res.mem_resource[idx].flags & IORESOURCE_AUTO)) {
> +		dev_dbg(&dev->dev, "  mem %d already set to 0x%llx-0x%llx "
> +			"flags 0x%x\n", idx, (unsigned long long) *start,
> +			(unsigned long long) *end, (int) *flags);

Ditto.

> +		return 1;
> +	}
> +
>  	/* set the initial values */
>  	*flags |= rule->flags | IORESOURCE_MEM;
>  	*flags &= ~IORESOURCE_UNSET;
> @@ -93,6 +106,7 @@
>  
>  	if (!rule->size) {
>  		*flags |= IORESOURCE_DISABLED;
> +		dev_dbg(&dev->dev, "  mem %d disabled\n", idx);
>  		return 1;	/* skip disabled resource requests */
>  	}
>  
> @@ -103,9 +117,13 @@
>  	while (!pnp_check_mem(dev, idx)) {
>  		*start += rule->align;
>  		*end = *start + rule->size - 1;
> -		if (*start > rule->max || !rule->align)
> +		if (*start > rule->max || !rule->align) {
> +			dev_dbg(&dev->dev, "  couldn't assign mem %d\n", idx);
>  			return 0;
> +		}
>  	}
> +	dev_dbg(&dev->dev, "  assign mem %d 0x%llx-0x%llx\n", idx,
> +		(unsigned long long) *start, (unsigned long long) *end);
>  	return 1;
>  }
>  
> @@ -126,20 +144,24 @@
>  		return 1;
>  	}
>  
> -	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO))
> -		return 1;
> -
>  	start = &dev->res.irq_resource[idx].start;
>  	end = &dev->res.irq_resource[idx].end;
>  	flags = &dev->res.irq_resource[idx].flags;
>  
> +	/* check if this resource has been manually set, if so skip */
> +	if (!(dev->res.irq_resource[idx].flags & IORESOURCE_AUTO)) {
> +		dev_dbg(&dev->dev, "  irq %d already set to %d flags 0x%x\n",
> +			idx, (int) *start, (int) *flags);

Ditto.

> +		return 1;
> +	}
> +
>  	/* set the initial values */
>  	*flags |= rule->flags | IORESOURCE_IRQ;
>  	*flags &= ~IORESOURCE_UNSET;
>  
>  	if (bitmap_empty(rule->map, PNP_IRQ_NR)) {
>  		*flags |= IORESOURCE_DISABLED;
> +		dev_dbg(&dev->dev, "  irq %d disabled\n", idx);
>  		return 1;	/* skip disabled resource requests */
>  	}
>  
> @@ -147,15 +169,20 @@
>  	*start = find_next_bit(rule->map, PNP_IRQ_NR, 16);
>  	if (*start < PNP_IRQ_NR) {
>  		*end = *start;
> +		dev_dbg(&dev->dev, "  assign irq %d %d\n", idx, (int) *start);
>  		return 1;
>  	}
>  	for (i = 0; i < 16; i++) {
>  		if (test_bit(xtab[i], rule->map)) {
>  			*start = *end = xtab[i];
> -			if (pnp_check_irq(dev, idx))
> +			if (pnp_check_irq(dev, idx)) {
> +				dev_dbg(&dev->dev, "  assign irq %d %d\n", idx,
> +					(int) *start);
>  				return 1;
> +			}
>  		}
>  	}
> +	dev_dbg(&dev->dev, "  couldn't assign irq %d\n", idx);
>  	return 0;
>  }
>  
> @@ -175,14 +202,17 @@
>  		return;
>  	}
>  
> -	/* check if this resource has been manually set, if so skip */
> -	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO))
> -		return;
> -
>  	start = &dev->res.dma_resource[idx].start;
>  	end = &dev->res.dma_resource[idx].end;
>  	flags = &dev->res.dma_resource[idx].flags;
>  
> +	/* check if this resource has been manually set, if so skip */
> +	if (!(dev->res.dma_resource[idx].flags & IORESOURCE_AUTO)) {
> +		dev_dbg(&dev->dev, "  dma %d already set to %d flags 0x%x\n",
> +			idx, (int) *start, (int) *flags);

... and ditto.

Rene
