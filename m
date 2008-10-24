Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbYJXRDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbYJXRDs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753605AbYJXRDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:03:39 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:59650 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbYJXRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:03:38 -0400
Date: Fri, 24 Oct 2008 13:02:58 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] Disable ioat channel only on platforms where ile driver
 can load
In-reply-to: <20081022233451.GA28775@linux-os.sc.intel.com>
X-X-Sender: lenb@localhost.localdomain
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Henroid, Andrew D" <andrew.d.henroid@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <alpine.LFD.1.10.0810241302510.3056@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
 <e8b529091b2ab65f5a4783e292c2b472e309116e.1223706853.git.len.brown@intel.com>
 <20081011083347.GA31918@elte.hu>
 <alpine.LFD.1.10.0810161805360.3026@localhost.localdomain>
 <48FE07AE.4010203@linux.intel.com>
 <7E82351C108FA840AB1866AC776AEC4637CD27F3@orsmsx505.amr.corp.intel.com>
 <48FED3FA.6040703@linux.intel.com>
 <20081022233451.GA28775@linux-os.sc.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

applied to acpi-test

thanks,
-len

On Wed, 22 Oct 2008, Venki Pallipadi wrote:

> On Wed, Oct 22, 2008 at 12:19:22AM -0700, Andi Kleen wrote:
> > Pallipadi, Venkatesh wrote:
> > >
> > >>> +#if CONFIG_I7300_IDLE_IOAT_CHANNEL
> > >>> +     device->common.chancnt--;
> > >>> +#endif
> > >> I still think this lone decrement looks fishy. Can there please be some
> > >> explanation how it exactly relates to the i7300 idle driver, where the
> > >> matching increment is, etc.?
> > >
> > > No. This is not a increment/decrement thing. It is basically telling other
> > > Users of IOAT that they have one IOAT channel less that they can use.
> > > The last IOAT channel is used by i7300 idle driver to get the throttling to
> > > work.
> > 
> > Ok then it should be made conditional on the i7300 actually be available
> > in the system?  It looks like you do it always no matter what chipset is in there.
> 
> Does the patch below look OK?
> 
> Thanks,
> Venki
> 
> Based on input from Andi Kleen:
> share the platform detection code with ioat_dma and disable the channel in
> dma engine only for specific platforms.
> 
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> 
> ---
>  drivers/dma/ioat_dma.c     |    5 ++
>  drivers/idle/i7300_idle.c  |   72 +--------------------------------------
>  include/linux/i7300_idle.h |   83 +++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 89 insertions(+), 71 deletions(-)
> 
> Index: linux-acpi-2.6/drivers/idle/i7300_idle.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/idle/i7300_idle.c	2008-10-22 11:42:04.000000000 -0700
> +++ linux-acpi-2.6/drivers/idle/i7300_idle.c	2008-10-22 11:42:46.000000000 -0700
> @@ -25,6 +25,7 @@
>  #include <linux/delay.h>
>  #include <linux/debugfs.h>
>  #include <linux/stop_machine.h>
> +#include <linux/i7300_idle.h>
>  
>  #include <asm/idle.h>
>  
> @@ -505,77 +506,8 @@ static struct notifier_block i7300_idle_
>  	.notifier_call = i7300_idle_notifier,
>  };
>  
> -/*
> - * I/O AT controls (PCI bus 0 device 8 function 0)
> - * DIMM controls (PCI bus 0 device 16 function 1)
> - */
> -#define IOAT_BUS 0
> -#define IOAT_DEVFN PCI_DEVFN(8, 0)
> -#define MEMCTL_BUS 0
> -#define MEMCTL_DEVFN PCI_DEVFN(16, 1)
> -
> -struct fbd_ioat {
> -	unsigned int vendor;
> -	unsigned int ioat_dev;
> -};
> -
> -/*
> - * The i5000 chip-set has the same hooks as the i7300
> - * but support is disabled by default because this driver
> - * has not been validated on that platform.
> - */
> -#define SUPPORT_I5000 0
> -
> -static const struct fbd_ioat fbd_ioat_list[] = {
> -	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB},
> -#if SUPPORT_I5000
> -	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT},
> -#endif
> -	{0, 0}
> -};
> -
> -/* table of devices that work with this driver */
> -static const struct pci_device_id pci_tbl[] = {
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_FBD_CNB) },
> -#if SUPPORT_I5000
> -	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
> -#endif
> -	{ } /* Terminating entry */
> -};
> -
>  MODULE_DEVICE_TABLE(pci, pci_tbl);
>  
> -/* Check for known platforms with I/O-AT */
> -static int __init i7300_idle_platform_probe(void)
> -{
> -	int i;
> -
> -	fbd_dev = pci_get_bus_and_slot(MEMCTL_BUS, MEMCTL_DEVFN);
> -	if (!fbd_dev)
> -		return -ENODEV;
> -
> -	for (i = 0; pci_tbl[i].vendor != 0; i++) {
> -		if (fbd_dev->vendor == pci_tbl[i].vendor &&
> -		    fbd_dev->device == pci_tbl[i].device) {
> -			break;
> -		}
> -	}
> -	if (pci_tbl[i].vendor == 0)
> -		return -ENODEV;
> -
> -	ioat_dev = pci_get_bus_and_slot(IOAT_BUS, IOAT_DEVFN);
> -	if (!ioat_dev)
> -		return -ENODEV;
> -
> -	for (i = 0; fbd_ioat_list[i].vendor != 0; i++) {
> -		if (ioat_dev->vendor == fbd_ioat_list[i].vendor &&
> -		    ioat_dev->device == fbd_ioat_list[i].ioat_dev) {
> -			return 0;
> -		}
> -	}
> -	return -ENODEV;
> -}
> -
>  int stats_open_generic(struct inode *inode, struct file *fp)
>  {
>  	fp->private_data = inode->i_private;
> @@ -617,7 +549,7 @@ static int __init i7300_idle_init(void)
>  	cpus_clear(idle_cpumask);
>  	total_us = 0;
>  
> -	if (i7300_idle_platform_probe())
> +	if (i7300_idle_platform_probe(&fbd_dev, &ioat_dev))
>  		return -ENODEV;
>  
>  	if (i7300_idle_thrt_save())
> Index: linux-acpi-2.6/include/linux/i7300_idle.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-acpi-2.6/include/linux/i7300_idle.h	2008-10-22 11:42:46.000000000 -0700
> @@ -0,0 +1,83 @@
> +
> +#ifndef I7300_IDLE_H
> +#define I7300_IDLE_H
> +
> +#include <linux/pci.h>
> +
> +/*
> + * I/O AT controls (PCI bus 0 device 8 function 0)
> + * DIMM controls (PCI bus 0 device 16 function 1)
> + */
> +#define IOAT_BUS 0
> +#define IOAT_DEVFN PCI_DEVFN(8, 0)
> +#define MEMCTL_BUS 0
> +#define MEMCTL_DEVFN PCI_DEVFN(16, 1)
> +
> +struct fbd_ioat {
> +	unsigned int vendor;
> +	unsigned int ioat_dev;
> +};
> +
> +/*
> + * The i5000 chip-set has the same hooks as the i7300
> + * but support is disabled by default because this driver
> + * has not been validated on that platform.
> + */
> +#define SUPPORT_I5000 0
> +
> +static const struct fbd_ioat fbd_ioat_list[] = {
> +	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_CNB},
> +#if SUPPORT_I5000
> +	{PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT},
> +#endif
> +	{0, 0}
> +};
> +
> +/* table of devices that work with this driver */
> +static const struct pci_device_id pci_tbl[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_FBD_CNB) },
> +#if SUPPORT_I5000
> +	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5000_ERR) },
> +#endif
> +	{ } /* Terminating entry */
> +};
> +
> +/* Check for known platforms with I/O-AT */
> +static inline int i7300_idle_platform_probe(struct pci_dev **fbd_dev,
> +						struct pci_dev **ioat_dev)
> +{
> +	int i;
> +	struct pci_dev *memdev, *dmadev;
> +
> +	memdev = pci_get_bus_and_slot(MEMCTL_BUS, MEMCTL_DEVFN);
> +	if (!memdev)
> +		return -ENODEV;
> +
> +	for (i = 0; pci_tbl[i].vendor != 0; i++) {
> +		if (memdev->vendor == pci_tbl[i].vendor &&
> +		    memdev->device == pci_tbl[i].device) {
> +			break;
> +		}
> +	}
> +	if (pci_tbl[i].vendor == 0)
> +		return -ENODEV;
> +
> +	dmadev = pci_get_bus_and_slot(IOAT_BUS, IOAT_DEVFN);
> +	if (!dmadev)
> +		return -ENODEV;
> +
> +	for (i = 0; fbd_ioat_list[i].vendor != 0; i++) {
> +		if (dmadev->vendor == fbd_ioat_list[i].vendor &&
> +		    dmadev->device == fbd_ioat_list[i].ioat_dev) {
> +			if (fbd_dev)
> +				*fbd_dev = memdev;
> +			if (ioat_dev)
> +				*ioat_dev = dmadev;
> +
> +			return 0;
> +		}
> +	}
> +	return -ENODEV;
> +}
> +
> +#endif
> Index: linux-acpi-2.6/drivers/dma/ioat_dma.c
> ===================================================================
> --- linux-acpi-2.6.orig/drivers/dma/ioat_dma.c	2008-10-22 11:42:04.000000000 -0700
> +++ linux-acpi-2.6/drivers/dma/ioat_dma.c	2008-10-22 11:42:46.000000000 -0700
> @@ -33,6 +33,7 @@
>  #include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/workqueue.h>
> +#include <linux/i7300_idle.h>
>  #include "ioatdma.h"
>  #include "ioatdma_registers.h"
>  #include "ioatdma_hw.h"
> @@ -172,7 +173,9 @@ static int ioat_dma_enumerate_channels(s
>  	xfercap = (xfercap_scale == 0 ? -1 : (1UL << xfercap_scale));
>  
>  #if CONFIG_I7300_IDLE_IOAT_CHANNEL
> -	device->common.chancnt--;
> +	if (i7300_idle_platform_probe(NULL, NULL) == 0) {
> +		device->common.chancnt--;
> +	}
>  #endif
>  	for (i = 0; i < device->common.chancnt; i++) {
>  		ioat_chan = kzalloc(sizeof(*ioat_chan), GFP_KERNEL);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
