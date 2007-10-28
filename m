Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbXJ1TxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbXJ1TxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 15:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbXJ1Tw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 15:52:57 -0400
Received: from outbound.mse10.exchange.ms ([216.52.164.190]:19652 "EHLO
	outbound.mse10.exchange.ms" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752206AbXJ1Tw4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 15:52:56 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Align PCI memory regions to page size (4K) - Fix
Date: Sun, 28 Oct 2007 15:53:20 -0400
Message-ID: <9392A06CB0FDC847B3A530B3DC174E7B03C96F36@mse10be1.mse10.exchange.ms>
In-reply-to: <20071028193104.GA13956@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Align PCI memory regions to page size (4K) - Fix
Thread-Index: AcgZmXayHQqKAuZPQJO8RPtw3jxeqwAAcXRQ
References: <9392A06CB0FDC847B3A530B3DC174E7B03C96F1D@mse10be1.mse10.exchange.ms> <20071028193104.GA13956@suse.de>
From: "Barak Fargoun" <barak@neocleus.com>
To: "Greg KH" <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Guy Zana" <guy@neocleus.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Regarding all the technical stuff (documentation, coding style, etc.) -
I thought I did it correctly :( I will fix it ASAP, 
and send an update when I will finish it.

About your question: today, some of the hypervisors are using linux
kernel as their domain-0 (e.g. Xen). In order
to implement direct hardware access for these native domains (e.g.
running windows in a virtual machine above Xen),
the PCI memory regions should be aligned at-least at the page-level (so,
a virtual machine - can't see data of other
devices which may not be assigned to it). So, for that reason, we wanted
a boot parameter to let us force the kernel
to align PCI memory regions at-least at a PAGE_SIZE alignment. It is
very useful for hypervisors which are developed 
at Linux environment (e.g.: Xen).

I hope I made myself clear.

Barak

-----Original Message-----
From: Greg KH [mailto:gregkh@suse.de] 
Sent: Sunday, October 28, 2007 21:31 PM
To: Barak Fargoun
Cc: linux-kernel@vger.kernel.org; linux-pci@atrey.karlin.mff.cuni.cz;
Guy Zana
Subject: Re: [PATCH] Align PCI memory regions to page size (4K) - Fix

On Sun, Oct 28, 2007 at 01:27:27PM -0400, Barak Fargoun wrote:
> Sorry, my mail client corrupted the previous mail containing the
patch... it should be ok now...
> 
> Add a boot parameter (?pci-mem-align?) which forces PCI memory regions
> to be aligned to 4K. 
> 
> This is very useful when developing an hypervisor, since in case we
> want to let native domains direct access to specific hardware, we
> don?t want PCI devices to share their memory region page with other
> devices. In Xen for example, PCI devices mmio resources are mapped by
> remapping complete pages (by Intel VT-d & the Neocleus pass-through
> patch for Xen).
> 
> Signed-off-by: Barak Fargoun???? (barak@neocleus.com)
> ---
> Kernel version: 2.6.18	(since this is the kernel version used
in Xen for Dom-0)
> ---
> diff -r 840b9df48b6a drivers/pci/bus.c
> --- a/drivers/pci/bus.c	Tue Aug 07 09:37:41 2007 +0100
> +++ b/drivers/pci/bus.c	Sun Oct 28 08:40:52 2007 -0400
> @@ -16,6 +16,8 @@
>  #include <linux/init.h>
>  
>  #include "pci.h"
> +
> +extern int pci_mem_align;

Please don't declare externs in a .c file, put it in a header file.

>  /**
>   * pci_bus_alloc_resource - allocate a resource from a parent bus
> @@ -43,6 +45,15 @@ pci_bus_alloc_resource(struct pci_bus *b
>  	int i, ret = -ENOMEM;
>  
>  	type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
> +
> +	/* if the boot parameter 'pci-mem-align' was specified, then we
need to 
> +		align the memory addresses, at page size alignment  */
> +	if (pci_mem_align)
> +	{
> +		/* we change only alignments which are smaller than page
size */
> +		if (align < (PAGE_SIZE-1))
> +			align = PAGE_SIZE - 1;
> +	}

Please follow the proper coding style rules as documented in
Documentation/CodingStyle.  Also running the script scrips/checkpatch.pl
would have pointed this out.

>  
>  	for (i = 0; i < PCI_BUS_NUM_RESOURCES; i++) {
>  		struct resource *r = bus->resource[i];
> diff -r 840b9df48b6a drivers/pci/quirks.c
> --- a/drivers/pci/quirks.c	Tue Aug 07 09:37:41 2007 +0100
> +++ b/drivers/pci/quirks.c	Sun Oct 28 08:40:52 2007 -0400
> @@ -22,6 +22,54 @@
>  #include <linux/delay.h>
>  #include <linux/acpi.h>
>  #include "pci.h"
> +
> +/* a global flag, which signals if we should align PCI mem windows to
4K */
> +int pci_mem_align = 0;
> +
> +/* this function is called, if the 'pci-mem-align' was specified as a
boot
> +		parameter. Used to force the kernel to align PCI mem
windows to 4k */

All command line paramaters need to be documented in the Documentation
directory.

> +static int __init set_pci_mem_align(char *str)
> +{
> +	pci_mem_align = 1;
> +	return 1;
> +}
> +__setup("pci-mem-align", set_pci_mem_align);
> +
> +/*	
> +	This quirk function enables us to force all memory resources
which are 
> +		assigned to PCI devices, to be aligned at a page size.
This 
> +		fetaurs helps us in xen when running native domains

Trailing spaces are not allowed :(

> +*/
> +static void __devinit quirk_xen_align_mem_resources(struct pci_dev
*dev)
> +{
> +	int i;
> +	struct resource *r;
> +
> +	/* if the boot parameter 'pci-mem-align' wasn't specified, then
no need
> +		to align the memory addresses */
> +	if (pci_mem_align == 0)
> +		return;
> +
> +	for (i=0; i < DEVICE_COUNT_RESOURCE; ++i) {
> +		r = &dev->resource[i];
> +
> +		if (r == NULL)
> +			continue;
> +
> +		/* we need to adjust only memory resources */
> +		if (r->flags & IORESOURCE_MEM) {
> +			/* align the start address in page size
alignment alignment (round up) */
> +			resource_size_t old_start = r->start;
> +			r->start = (r->start + (PAGE_SIZE-1))  &
(~(PAGE_SIZE-1));
> +
> +			/* update the end address, so that the region
size will not be 
> +				affected */
> +			r->end = r->end - (old_start - r->start);
> +		}
> +	}
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID,
quirk_xen_align_mem_resources);

Now for the main reason.  I really don't understand why this is needed.
Is it only for virtual machines?  Are there drivers in the kernel tree
today that need this functionality?  What breaks if you do not align
these resources?

thanks,

greg k-h
