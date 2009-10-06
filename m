Return-Path: <linux-kernel-owner+w=401wt.eu-S932852AbZJFRez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbZJFRez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932812AbZJFRey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:34:54 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:19677 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932285AbZJFRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:34:52 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Date: Tue, 6 Oct 2009 11:33:24 -0600
User-Agent: KMail/1.9.10
Cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <4AC97C00.7090503@kernel.org>
In-Reply-To: <4AC97C00.7090503@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061133.27546.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 October 2009 10:54:24 pm Yinghai Lu wrote:
> for intel system with multi IOH. we could read peer root resource from PCI conf,
> and don't trust _CRS again for root bus

Ugh.  Are we going to end up with amd_bus.c, intel_bus.c, nvidia_bus.c,
broadcom_bus.c, serverworks_bus.c, etc.?

This is basically a simple PCI host bridge driver, but it's completely
separate from the ACPI pci_root.c driver, and it completely ignores
useful things like multiple domain (_SEG) support and address translation
(_TRA) support.  These are going to be important issues for large x86
machines.

I think this is leading toward an architectural mess.  Yes, we have
issues with _CRS for root bridges.  But ACPI does give us a generic
framework powerful enough to handle everything you're doing here.  In
my opinion, we should fix the implementation issues with that framework
rather than adding platform-specific setup code every time we trip
over something.

I expect that will mean some quirks in pci_root.c, and maybe even some
code similar to pci_root_bus_res() to validate or override what we learn
from _CRS.  But we ought to try for some conceptual integrity in the
design by putting all the putting all the host bridge driver code together.

What is the specific problem solved by this patch?  Does "pci=use_crs"
address any of that problem?  (I know "pci=use_crs" breaks some machines,
and I know it's unacceptable to require users to use it.  But I want to
understand whether the concept is related, and whether you've tripped
over a BIOS defect or a Linux pci_root.c defect.)

Bjorn

> ---
>  arch/x86/pci/Makefile    |    1 
>  arch/x86/pci/amd_bus.c   |   45 +++++++++--------------
>  arch/x86/pci/bus_numa.h  |   26 +++++++++++++
>  arch/x86/pci/intel_bus.c |   90 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 135 insertions(+), 27 deletions(-)
> 
> Index: linux-2.6/arch/x86/pci/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/Makefile
> +++ linux-2.6/arch/x86/pci/Makefile
> @@ -15,3 +15,4 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
>  
>  obj-y				+= common.o early.o
>  obj-y				+= amd_bus.o
> +obj-$(CONFIG_X86_64)		+= intel_bus.o
> Index: linux-2.6/arch/x86/pci/intel_bus.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/pci/intel_bus.c
> @@ -0,0 +1,90 @@
> +/*
> + * to read io range from IOH pci conf, need to do it after mmconfig is there
> + */
> +
> +#include <linux/delay.h>
> +#include <linux/dmi.h>
> +#include <linux/pci.h>
> +#include <linux/init.h>
> +#include <asm/pci_x86.h>
> +
> +#include "bus_numa.h"
> +
> +static inline void print_ioh_resources(struct pci_root_info *info)
> +{
> +	int res_num;
> +	int busnum;
> +	int i;
> +
> +	printk(KERN_DEBUG "IOH bus: [%02x, %02x]\n",
> +			info->bus_min, info->bus_max);
> +	res_num = info->res_num;
> +	busnum = info->bus_min;
> +	for (i = 0; i < res_num; i++) {
> +		struct resource *res;
> +
> +		res = &info->res[i];
> +		printk(KERN_DEBUG "IOH bus: %02x index %x %s: [%llx, %llx]\n",
> +			busnum, i,
> +			(res->flags & IORESOURCE_IO) ? "io port" :
> +							"mmio",
> +			res->start, res->end);
> +	}
> +}
> +
> +#define IOH_LIO			0x108
> +#define IOH_LMMIOL		0x10c
> +#define IOH_LMMIOH		0x110
> +#define IOH_LMMIOH_BASEU	0x114
> +#define IOH_LMMIOH_LIMITU	0x118
> +#define IOH_LCFGBUS		0x11c
> +
> +static void __devinit pci_root_bus_res(struct pci_dev *dev)
> +{
> +	u16 word;
> +	u32 dword;
> +	struct pci_root_info *info;
> +	u16 io_base, io_end;
> +	u32 mmiol_base, mmiol_end;
> +	u64 mmioh_base, mmioh_end;
> +	int bus_base, bus_end;
> +
> +	if (pci_root_num >= PCI_ROOT_NR) {
> +		printk(KERN_DEBUG "intel_bus.c: PCI_ROOT_NR is too small\n");
> +		return;
> +	}
> +
> +	info = &pci_root_info[pci_root_num];
> +	pci_root_num++;
> +
> +	pci_read_config_word(dev, IOH_LCFGBUS, &word);
> +	bus_base = (word & 0xff);
> +	bus_end = (word & 0xff00) >> 8;
> +	sprintf(info->name, "PCI Bus #%02x", bus_base);
> +	info->bus_min = bus_base;
> +	info->bus_max = bus_end;
> +
> +	pci_read_config_word(dev, IOH_LIO, &word);
> +	io_base = (word & 0xf0) << (12 - 4);
> +	io_end = (word & 0xf000) | 0xfff;
> +	update_res(info, io_base, io_end, IORESOURCE_IO, 0);
> +
> +	pci_read_config_dword(dev, IOH_LMMIOL, &dword);
> +	mmiol_base = (dword & 0xff00) << (24 - 8);
> +	mmiol_end = (dword & 0xff000000) | 0xffffff;
> +	update_res(info, mmiol_base, mmiol_end, IORESOURCE_MEM, 0);
> +
> +	pci_read_config_dword(dev, IOH_LMMIOH, &dword);
> +	mmioh_base = ((u64)(dword & 0xfc00)) << (26 - 10);
> +	mmioh_end = ((u64)(dword & 0xfc000000) | 0x3ffffff);
> +	pci_read_config_dword(dev, IOH_LMMIOH_BASEU, &dword);
> +	mmioh_base |= ((u64)(dword & 0x7ffff)) << 32;
> +	pci_read_config_dword(dev, IOH_LMMIOH_LIMITU, &dword);
> +	mmioh_end |= ((u64)(dword & 0x7ffff)) << 32;
> +	update_res(info, mmioh_base, mmioh_end, IORESOURCE_MEM, 0);
> +
> +	print_ioh_resources(info);
> +}
> +
> +/* intel IOH */
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x342e, pci_root_bus_res);
> Index: linux-2.6/arch/x86/pci/amd_bus.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/pci/amd_bus.c
> +++ linux-2.6/arch/x86/pci/amd_bus.c
> @@ -10,6 +10,8 @@
>  #include <linux/cpumask.h>
>  #endif
>  
> +#include "bus_numa.h"
> +
>  /*
>   * This discovers the pcibus <-> node mapping on AMD K8.
>   * also get peer root bus resource for io,mmio
> @@ -17,25 +19,9 @@
>  
>  #ifdef CONFIG_X86_64
>  
> -/*
> - * sub bus (transparent) will use entres from 3 to store extra from root,
> - * so need to make sure have enought slot there, increase PCI_BUS_NUM_RESOURCES?
> - */
> -#define RES_NUM 16
> -struct pci_root_info {
> -	char name[12];
> -	unsigned int res_num;
> -	struct resource res[RES_NUM];
> -	int bus_min;
> -	int bus_max;
> -	int node;
> -	int link;
> -};
> -
> -/* 4 at this time, it may become to 32 */
> -#define PCI_ROOT_NR 4
> -static int pci_root_num;
> -static struct pci_root_info pci_root_info[PCI_ROOT_NR];
> +int pci_root_num;
> +struct pci_root_info pci_root_info[PCI_ROOT_NR];
> +static int found_all_numa_early;
>  
>  void x86_pci_root_bus_res_quirks(struct pci_bus *b)
>  {
> @@ -48,8 +34,11 @@ void x86_pci_root_bus_res_quirks(struct
>  	    b->resource[1] != &iomem_resource)
>  		return;
>  
> -	/* if only one root bus, don't need to anything */
> -	if (pci_root_num < 2)
> +	if (!pci_root_num)
> +		return;
> +
> +	/* for amd, if only one root bus, don't need to do anything */
> +	if (pci_root_num < 2 && found_all_numa_early)
>  		return;
>  
>  	for (i = 0; i < pci_root_num; i++) {
> @@ -130,12 +119,15 @@ static void __init update_range(struct r
>  	}
>  }
>  
> -static void __init update_res(struct pci_root_info *info, size_t start,
> +void __init update_res(struct pci_root_info *info, size_t start,
>  			      size_t end, unsigned long flags, int merge)
>  {
>  	int i;
>  	struct resource *res;
>  
> +	if (start > end)
> +		return;
> +
>  	if (!merge)
>  		goto addit;
>  
> @@ -230,7 +222,6 @@ static int __init early_fill_mp_bus_info
>  	int j;
>  	unsigned uninitialized_var(bus);
>  	unsigned uninitialized_var(slot);
> -	int found;
>  	int node;
>  	int link;
>  	int def_node;
> @@ -247,7 +238,7 @@ static int __init early_fill_mp_bus_info
>  	if (!early_pci_allowed())
>  		return -1;
>  
> -	found = 0;
> +	found_all_numa_early = 0;
>  	for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
>  		u32 id;
>  		u16 device;
> @@ -261,12 +252,12 @@ static int __init early_fill_mp_bus_info
>  		device = (id>>16) & 0xffff;
>  		if (pci_probes[i].vendor == vendor &&
>  		    pci_probes[i].device == device) {
> -			found = 1;
> +			found_all_numa_early = 1;
>  			break;
>  		}
>  	}
>  
> -	if (!found)
> +	if (!found_all_numa_early)
>  		return 0;
>  
>  	pci_root_num = 0;
> @@ -490,7 +481,7 @@ static int __init early_fill_mp_bus_info
>  		info = &pci_root_info[i];
>  		res_num = info->res_num;
>  		busnum = info->bus_min;
> -		printk(KERN_DEBUG "bus: [%02x,%02x] on node %x link %x\n",
> +		printk(KERN_DEBUG "bus: [%02x, %02x] on node %x link %x\n",
>  		       info->bus_min, info->bus_max, info->node, info->link);
>  		for (j = 0; j < res_num; j++) {
>  			res = &info->res[j];
> Index: linux-2.6/arch/x86/pci/bus_numa.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/arch/x86/pci/bus_numa.h
> @@ -0,0 +1,26 @@
> +#ifdef CONFIG_X86_64
> +
> +/*
> + * sub bus (transparent) will use entres from 3 to store extra from
> + * root, so need to make sure we have enought slot there, Should we
> + * increase PCI_BUS_NUM_RESOURCES?
> + */
> +#define RES_NUM 16
> +struct pci_root_info {
> +	char name[12];
> +	unsigned int res_num;
> +	struct resource res[RES_NUM];
> +	int bus_min;
> +	int bus_max;
> +	int node;
> +	int link;
> +};
> +
> +/* 4 at this time, it may become to 32 */
> +#define PCI_ROOT_NR 4
> +extern int pci_root_num;
> +extern struct pci_root_info pci_root_info[PCI_ROOT_NR];
> +
> +extern void update_res(struct pci_root_info *info, size_t start,
> +			      size_t end, unsigned long flags, int merge);
> +#endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


