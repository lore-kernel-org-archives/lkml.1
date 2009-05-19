Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZESF13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZESF13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 01:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbZESF1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 01:27:21 -0400
Received: from sh.osrg.net ([192.16.179.4]:44599 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbZESF1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 01:27:20 -0400
Date: Tue, 19 May 2009 14:27:12 +0900
To: beckyb@kernel.crashing.org
Cc: linuxppc-dev@ozlabs.org, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org>
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org>
	<1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090519142656T.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 19 May 2009 14:27:12 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC'ed linux-kernel

On Thu, 14 May 2009 17:42:28 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> This patch includes the basic infrastructure to use swiotlb
> bounce buffering on 32-bit powerpc.  It is not yet enabled on
> any platforms.  Probably the most interesting bit is the
> addition of addr_needs_map to dma_ops - we need this as
> a dma_op because the decision of whether or not an addr
> can be mapped by a device is device-specific.
> 
> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
> ---
>  arch/powerpc/Kconfig                   |   12 ++-
>  arch/powerpc/include/asm/dma-mapping.h |   11 ++
>  arch/powerpc/include/asm/swiotlb.h     |   27 +++++
>  arch/powerpc/kernel/Makefile           |    1 +
>  arch/powerpc/kernel/dma-swiotlb.c      |  163 ++++++++++++++++++++++++++++++++
>  arch/powerpc/kernel/dma.c              |    2 +-
>  arch/powerpc/kernel/setup_32.c         |    6 +
>  arch/powerpc/kernel/setup_64.c         |    6 +
>  8 files changed, 226 insertions(+), 2 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/swiotlb.h
>  create mode 100644 arch/powerpc/kernel/dma-swiotlb.c
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index a0d1146..54e519a 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -296,9 +296,19 @@ config IOMMU_VMERGE
>  config IOMMU_HELPER
>  	def_bool PPC64
>  
> +config SWIOTLB
> +	bool "SWIOTLB support"
> +	default n
> +	select IOMMU_HELPER
> +	---help---
> +	  Support for IO bounce buffering for systems without an IOMMU.
> +	  This allows us to DMA to the full physical address space on
> +	  platforms where the size of a physical address is larger
> +	  than the bus address.  Not all platforms support this.
> +
>  config PPC_NEED_DMA_SYNC_OPS
>  	def_bool y
> -	depends on NOT_COHERENT_CACHE
> +	depends on (NOT_COHERENT_CACHE || SWIOTLB)
>  
>  config HOTPLUG_CPU
>  	bool "Support for enabling/disabling CPUs"
> diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/include/asm/dma-mapping.h
> index c69f2b5..71bbc17 100644
> --- a/arch/powerpc/include/asm/dma-mapping.h
> +++ b/arch/powerpc/include/asm/dma-mapping.h
> @@ -15,9 +15,18 @@
>  #include <linux/scatterlist.h>
>  #include <linux/dma-attrs.h>
>  #include <asm/io.h>
> +#include <asm/swiotlb.h>
>  
>  #define DMA_ERROR_CODE		(~(dma_addr_t)0x0)
>  
> +/* Some dma direct funcs must be visible for use in other dma_ops */
> +extern void *dma_direct_alloc_coherent(struct device *dev, size_t size,
> +				       dma_addr_t *dma_handle, gfp_t flag);
> +extern void dma_direct_free_coherent(struct device *dev, size_t size,
> +				     void *vaddr, dma_addr_t dma_handle);
> +
> +extern unsigned long get_dma_direct_offset(struct device *dev);
> +
>  #ifdef CONFIG_NOT_COHERENT_CACHE
>  /*
>   * DMA-consistent mapping functions for PowerPCs that don't support
> @@ -76,6 +85,8 @@ struct dma_mapping_ops {
>  				dma_addr_t dma_address, size_t size,
>  				enum dma_data_direction direction,
>  				struct dma_attrs *attrs);
> +	int		(*addr_needs_map)(struct device *dev, dma_addr_t addr,
> +				size_t size);
>  #ifdef CONFIG_PPC_NEED_DMA_SYNC_OPS
>  	void            (*sync_single_range_for_cpu)(struct device *hwdev,
>  				dma_addr_t dma_handle, unsigned long offset,
> diff --git a/arch/powerpc/include/asm/swiotlb.h b/arch/powerpc/include/asm/swiotlb.h
> new file mode 100644
> index 0000000..30891d6
> --- /dev/null
> +++ b/arch/powerpc/include/asm/swiotlb.h
> @@ -0,0 +1,27 @@
> +/*
> + * Copyright (C) 2009 Becky Bruce, Freescale Semiconductor
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + */
> +
> +#ifndef __ASM_SWIOTLB_H
> +#define __ASM_SWIOTLB_H
> +
> +#include <linux/swiotlb.h>
> +
> +extern struct dma_mapping_ops swiotlb_dma_ops;
> +extern struct dma_mapping_ops swiotlb_pci_dma_ops;
> +
> +int swiotlb_arch_address_needs_mapping(struct device *, dma_addr_t,
> +				       size_t size);
> +
> +static inline void dma_mark_clean(void *addr, size_t size) {}
> +
> +extern unsigned int ppc_swiotlb_enable;
> +int __init swiotlb_setup_bus_notifier(void);
> +
> +#endif /* __ASM_SWIOTLB_H */
> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 71901fb..34c0a95 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -82,6 +82,7 @@ obj-$(CONFIG_SMP)		+= smp.o
>  obj-$(CONFIG_KPROBES)		+= kprobes.o
>  obj-$(CONFIG_PPC_UDBG_16550)	+= legacy_serial.o udbg_16550.o
>  obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
> +obj-$(CONFIG_SWIOTLB)		+= dma-swiotlb.o
>  
>  pci64-$(CONFIG_PPC64)		+= pci_dn.o isa-bridge.o
>  obj-$(CONFIG_PCI)		+= pci_$(CONFIG_WORD_SIZE).o $(pci64-y) \
> diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
> new file mode 100644
> index 0000000..68ccf11
> --- /dev/null
> +++ b/arch/powerpc/kernel/dma-swiotlb.c
> @@ -0,0 +1,163 @@
> +/*
> + * Contains routines needed to support swiotlb for ppc.
> + *
> + * Copyright (C) 2009 Becky Bruce, Freescale Semiconductor
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + *
> + */
> +
> +#include <linux/dma-mapping.h>
> +#include <linux/pfn.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/pci.h>
> +
> +#include <asm/machdep.h>
> +#include <asm/swiotlb.h>
> +#include <asm/dma.h>
> +#include <asm/abs_addr.h>
> +
> +int swiotlb __read_mostly;
> +unsigned int ppc_swiotlb_enable;
> +
> +void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t addr)
> +{
> +	unsigned long pfn = PFN_DOWN(swiotlb_bus_to_phys(hwdev, addr));
> +	void *pageaddr = page_address(pfn_to_page(pfn));
> +
> +	if (pageaddr != NULL)
> +		return pageaddr + (addr % PAGE_SIZE);
> +	return NULL;
> +}
> +
> +dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
> +{
> +	return paddr + get_dma_direct_offset(hwdev);
> +}
> +
> +phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
> +
> +{
> +	return baddr - get_dma_direct_offset(hwdev);
> +}
> +
> +/*
> + * Determine if an address needs bounce buffering via swiotlb.
> + * Going forward I expect the swiotlb code to generalize on using
> + * a dma_ops->addr_needs_map, and this function will move from here to the
> + * generic swiotlb code.
> + */
> +int
> +swiotlb_arch_address_needs_mapping(struct device *hwdev, dma_addr_t addr,
> +				   size_t size)
> +{
> +	struct dma_mapping_ops *dma_ops = get_dma_ops(hwdev);
> +
> +	BUG_ON(!dma_ops);
> +	return dma_ops->addr_needs_map(hwdev, addr, size);
> +}
> +
> +/*
> + * Determine if an address is reachable by a pci device, or if we must bounce.
> + */
> +static int
> +swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
> +{
> +	u64 mask = dma_get_mask(hwdev);
> +	dma_addr_t max;
> +	struct pci_controller *hose;
> +	struct pci_dev *pdev = to_pci_dev(hwdev);
> +
> +	hose = pci_bus_to_host(pdev->bus);
> +	max = hose->dma_window_base_cur + hose->dma_window_size;
> +
> +	/* check that we're within mapped pci window space */
> +	if ((addr + size > max) | (addr < hose->dma_window_base_cur))
> +		return 1;
> +
> +	return !is_buffer_dma_capable(mask, addr, size);
> +}
> +
> +static int
> +swiotlb_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
> +{
> +	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
> +}

I think that swiotlb_pci_addr_needs_map and swiotlb_addr_needs_map
don't need swiotlb_arch_range_needs_mapping() since

- swiotlb_arch_range_needs_mapping() is always used with
swiotlb_arch_address_needs_mapping().

- swiotlb_arch_address_needs_mapping() uses is_buffer_dma_capable()
and powerpc doesn't overwrite swiotlb_arch_address_needs_mapping()


Do I miss something?

Anyway, we need to fix swiotlb checking code to if an area is
DMA-capable or not.

swiotlb_arch_address_needs_mapping() calls is_buffer_dma_capable() in
dma-mapping.h but it should not. It should live in an arch-specific
place such as arch's dma-mapping.h or something since
is_buffer_dma_capable() is arch-specific. I didn't know that
is_buffer_dma_capable() is arch-specific when I added it to the
generic place.

If we have something like in arch/{x86|ia64|powerpc}/dma-mapping.h:

static inline int is_buffer_dma_capable(struct device *dev, dma_addr_t addr, size_t size)

then we don't need two checking functions, address_needs_mapping and
range_needs_mapping.

But I guess the bad thing is that we can't the arch abstraction due to
dom0 support.
