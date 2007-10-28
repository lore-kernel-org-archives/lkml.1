Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbXJ1RRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbXJ1RRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 13:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXJ1RR2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 13:17:28 -0400
Received: from xenotime.net ([66.160.160.81]:41098 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751150AbXJ1RR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 13:17:27 -0400
Date: Sun, 28 Oct 2007 10:17:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Barak Fargoun" <barak@neocleus.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <gregkh@suse.de>
Subject: Re: [PATCH] Align PCI memory regions to page size (4K)
Message-Id: <20071028101724.e56da3ce.rdunlap@xenotime.net>
In-Reply-To: <9392A06CB0FDC847B3A530B3DC174E7B03C96EFC@mse10be1.mse10.exchange.ms>
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96EFC@mse10be1.mse10.exchange.ms>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 11:00:38 -0400 Barak Fargoun wrote:

> Add a boot parameter ('pci-mem-align') which forces PCI memory regions
> to be aligned to 4K. 
> 
>  
> 
> This is very useful when developing an hypervisor, since in case we want
> to let native domains direct access to specific hardware, we don't want
> PCI devices to share their memory region page with other devices. In Xen
> for example, PCI devices mmio resources are mapped by remapping complete
> pages (by Intel VT-d & the Neocleus pass-through patch for Xen).
> 

Hi,
This patch is oddly double-spaced and space-stuffed (spaces instead
of tabs).  Likely a mail client doing this.  It's usually a
good idea to send patches to yourself to make sure that they will
apply cleanly with 'patch' before unloading them on someone else.


> 
> Signed-off-by: Barak Fargoun     (barak@neocleus.com)
> 
> ---
> 
> Kernel version: 2.6.18
> 
> ---
> 
> diff -r 840b9df48b6a drivers/pci/bus.c
> 
> --- a/drivers/pci/bus.c   Tue Aug 07 09:37:41 2007 +0100
> 
> +++ b/drivers/pci/bus.c                Sun Oct 28 08:40:52 2007 -0400
> 
> @@ -16,6 +16,8 @@
> 
>  #include <linux/init.h>
> 
>  
> 
>  #include "pci.h"
> 
> +
> 
> +extern int pci_mem_align;
> 
>  
> 
>  /**
> 
>   * pci_bus_alloc_resource - allocate a resource from a parent bus
> 
> @@ -43,6 +45,15 @@ pci_bus_alloc_resource(struct pci_bus *b
> 
>                 int i, ret = -ENOMEM;
> 
>  
> 
>                 type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
> 
> +
> 
> +             /* if the boot parameter 'pci-mem-align' was specified,
> then we need to 
> 
> +                             align the memory addresses, at page size
> alignment  */
> 
> +             if (pci_mem_align)
> 
> +             {
> 
> +                             /* we change only alignments which are
> smaller than page size */
> 
> +                             if (align < (PAGE_SIZE-1))
> 
> +                                             align = PAGE_SIZE - 1;
> 
> +             }
> 
>  
> 
>                 for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
> 
>                                 struct resource *r = bus->resource[i];
> 
> diff -r 840b9df48b6a drivers/pci/quirks.c
> 
> --- a/drivers/pci/quirks.c              Tue Aug 07 09:37:41 2007 +0100
> 
> +++ b/drivers/pci/quirks.c           Sun Oct 28 08:40:52 2007 -0400
> 
> @@ -22,6 +22,54 @@
> 
>  #include <linux/delay.h>
> 
>  #include <linux/acpi.h>
> 
>  #include "pci.h"
> 
> +
> 
> +/* a global flag, which signals if we should align PCI mem windows to
> 4K */
> 
> +int pci_mem_align = 0;
> 
> +
> 
> +/* this function is called, if the 'pci-mem-align' was specified as a
> boot
> 
> +                             parameter. Used to force the kernel to
> align PCI mem windows to 4k */
> 
> +static int __init set_pci_mem_align(char *str)
> 
> +{
> 
> +             pci_mem_align = 1;
> 
> +             return 1;
> 
> +}
> 
> +__setup("pci-mem-align", set_pci_mem_align);
> 
> +
> 
> +/*         
> 
> +             This quirk function enables us to force all memory
> resources which are 
> 
> +                             assigned to PCI devices, to be aligned at
> a page size. This 
> 
> +                             fetaurs helps us in xen when running
> native domains
> 
> +*/
> 
> +static void __devinit quirk_xen_align_mem_resources(struct pci_dev
> *dev)
> 
> +{
> 
> +             int i;
> 
> +             struct resource *r;
> 
> +
> 
> +             /* if the boot parameter 'pci-mem-align' wasn't specified,
> then no need
> 
> +                             to align the memory addresses */
> 
> +             if (pci_mem_align == 0)
> 
> +                             return;
> 
> +
> 
> +             for (i=0; i < DEVICE_COUNT_RESOURCE; ++i) {
> 
> +                             r = &dev->resource[i];
> 
> +
> 
> +                             if (r == NULL)
> 
> +                                             continue;
> 
> +
> 
> +                             /* we need to adjust only memory resources
> */
> 
> +                             if (r->flags & IORESOURCE_MEM) {
> 
> +                                             /* align the start address
> in page size alignment alignment (round up) */
> 
> +                                             resource_size_t old_start
> = r->start;
> 
> +                                             r->start = (r->start +
> (PAGE_SIZE-1))  & (~(PAGE_SIZE-1));
> 
> +
> 
> +                                             /* update the end address,
> so that the region size will not be 
> 
> +                                                             affected
> */
> 
> +                                             r->end = r->end -
> (old_start - r->start);
> 
> +                             }
> 
> +             }
> 
> +}
> 
> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID,
> quirk_xen_align_mem_resources);
> 
> +
> 
>  
> 
>  /* The Mellanox Tavor device gives false positive parity errors
> 
>   * Mark this device with a broken_parity_status, to allow
> 
>  
> 
> 


---
~Randy
