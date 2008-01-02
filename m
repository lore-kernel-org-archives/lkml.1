Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYABUmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYABUmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756201AbYABUm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:42:28 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:30000 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYABUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:42:27 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Linux 2.6.23.12
Date: Wed, 2 Jan 2008 13:42:23 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>
References: <20071218224559.GA12696@kroah.com> <20071218224635.GB12696@kroah.com>
In-Reply-To: <20071218224635.GB12696@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801021342.23763.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below was put in 2.6.23.12 as a fix for
http://bugzilla.kernel.org/show_bug.cgi?id=9514.  It apparently
does make 9514 go away, but only by coincidence.  There are a
couple other ideas about fixing 9514.  My proposed patch is
attached in the bugzilla.

The .12 patch reduces the number of resources we reserve from
24 to 8 ioport regions and from 12 to 4 mmio regions per PNP device.
It also removes a warning about regions we ignore.

Obviously, we want to reserve ALL the regions for PNP devices,
and Thomas is working on a patch for that (which I hope will be
ready for 2.6.25).  But in the meantime, the .12 patch makes it
more likely that we will have resource conflicts with PNP devices.

http://bugzilla.kernel.org/show_bug.cgi?id=9630 appears to be
such a conflict.

I think the patch below should be removed from the stable series.

Bjorn

On Tuesday 18 December 2007 03:46:36 pm Greg Kroah-Hartman wrote:
> diff --git a/Makefile b/Makefile
> index ada10d5..96c3f02 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1,7 +1,7 @@
>  VERSION = 2
>  PATCHLEVEL = 6
>  SUBLEVEL = 23
> -EXTRAVERSION = .11
> +EXTRAVERSION = .12
>  NAME = Arr Matey! A Hairy Bilge Rat!
>  
>  # *DOCUMENTATION*
> diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
> index 5abf5ea..0e3b8d0 100644
> --- a/drivers/pnp/pnpacpi/rsparser.c
> +++ b/drivers/pnp/pnpacpi/rsparser.c
> @@ -82,11 +82,9 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_resource_table *res,
>  	while (!(res->irq_resource[i].flags & IORESOURCE_UNSET) &&
>  	       i < PNP_MAX_IRQ)
>  		i++;
> -	if (i >= PNP_MAX_IRQ) {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of IRQ "
> -				"resources: %d \n", PNP_MAX_IRQ);
> +	if (i >= PNP_MAX_IRQ)
>  		return;
> -	}
> +
>  	res->irq_resource[i].flags = IORESOURCE_IRQ;	// Also clears _UNSET flag
>  	res->irq_resource[i].flags |= irq_flags(triggering, polarity);
>  	irq = acpi_register_gsi(gsi, triggering, polarity);
> @@ -165,9 +163,6 @@ static void pnpacpi_parse_allocated_dmaresource(struct pnp_resource_table *res,
>  		}
>  		res->dma_resource[i].start = dma;
>  		res->dma_resource[i].end = dma;
> -	} else {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of DMA "
> -				"resources: %d \n", PNP_MAX_DMA);
>  	}
>  }
>  
> @@ -189,9 +184,6 @@ static void pnpacpi_parse_allocated_ioresource(struct pnp_resource_table *res,
>  		}
>  		res->port_resource[i].start = io;
>  		res->port_resource[i].end = io + len - 1;
> -	} else {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of IO "
> -				"resources: %d \n", PNP_MAX_PORT);
>  	}
>  }
>  
> @@ -215,9 +207,6 @@ static void pnpacpi_parse_allocated_memresource(struct pnp_resource_table *res,
>  
>  		res->mem_resource[i].start = mem;
>  		res->mem_resource[i].end = mem + len - 1;
> -	} else {
> -		printk(KERN_ERR "pnpacpi: exceeded the max number of mem "
> -				"resources: %d\n", PNP_MAX_MEM);
>  	}
>  }
>  
> diff --git a/include/linux/pnp.h b/include/linux/pnp.h
> index 62decab..16b46aa 100644
> --- a/include/linux/pnp.h
> +++ b/include/linux/pnp.h
> @@ -13,8 +13,8 @@
>  #include <linux/errno.h>
>  #include <linux/mod_devicetable.h>
>  
> -#define PNP_MAX_PORT		24
> -#define PNP_MAX_MEM		12
> +#define PNP_MAX_PORT		8
> +#define PNP_MAX_MEM		4
>  #define PNP_MAX_IRQ		2
>  #define PNP_MAX_DMA		2
>  #define PNP_NAME_LEN		50
