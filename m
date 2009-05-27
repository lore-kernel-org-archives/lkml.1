Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbZE0TFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbZE0TFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 15:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757326AbZE0TFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 15:05:36 -0400
Received: from gate.crashing.org ([63.228.1.57]:49615 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756903AbZE0TFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 15:05:35 -0400
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <0628DF07-E085-4CC8-ADFC-1B0798343159@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
In-Reply-To: <1242990702.22654.253.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH V2 2/3] powerpc: Add support for swiotlb on 32-bit
Date: Wed, 27 May 2009 14:05:08 -0500
References: <1242340949-16369-1-git-send-email-beckyb@kernel.crashing.org> <1242340949-16369-2-git-send-email-beckyb@kernel.crashing.org> <20090519142656T.fujita.tomonori@lab.ntt.co.jp> <19E48A70-3332-423C-ACAD-390F940EE81C@kernel.crashing.org> <4A1592CF.8000208@goop.org> <E6DAA792-9923-4B76-9759-6955AABE3EAB@kernel.crashing.org> <1242990702.22654.253.camel@zakaz.uk.xensource.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22, 2009, at 6:11 AM, Ian Campbell wrote:
>
>
> BTW do you need swiotlb_bus_to_virt to be __weak or is the fact that  
> it
> is implemented in terms of swiotlb_bus_to_phys sufficient?

The default one in swiotlb calls phys_to_virt on the result of  
swiotlb_bus_to_phys, which only works on lowmem.

>
>
> I have an appointment all afternoon and it's a bank holiday on Monday
> but here is my WIP patch as an example of what I'm thinking. Obviously
> some cleanups are still very much required:
>      * The Xen specific stuff in arch/x86/include/asm/dma-mapping.h
>        clearly needs to be properly abstracted away (I just stuck it
>        there for testing).
>      * swiotlb_phys_to_bus and swiotlb_bus_to_phys need to move to
>        arch/*/include/asm/dma-mapping.h instead of being __weak
>      * Maybe swiotlb_bus_to_virt can become static again.
>      * Need to finish auditing the handful of non-swiotlb users of
>        is_buffer_dma_capable.
>      * It might be possible to implement swiolb_dma_mapping_error
>        and/or swiotlb_dma_supported in terms of dma_map_range.
>      * Minor detail: it doesn't actually work at the moment ;-)

Minor detail :)

I'm in the same boat- been offline most of the week and will continue  
to be offline (I'm sneaking in an hour here to read emails!!!!) until  
sometime next week.   I'm in the middle of a big lab construction and  
move project.  I'll take a look as soon as I can - thanks!

-Becky

>
>
> Ian.
>
> diff --git a/arch/ia64/include/asm/dma-mapping.h b/arch/ia64/include/ 
> asm/dma-mapping.h
> index 36c0009..026667f 100644
> --- a/arch/ia64/include/asm/dma-mapping.h
> +++ b/arch/ia64/include/asm/dma-mapping.h
> @@ -174,4 +174,12 @@ dma_cache_sync (struct device *dev, void  
> *vaddr, size_t size,
>
> #define dma_is_consistent(d, h)	(1)	/* all we do is coherent  
> memory... */
>
> +static inline dma_addr_t dma_map_range(struct device *dev, u64 mask,
> +				       phys_addr_t addr, size_t size)
> +{
> +	if (addr + size <= mask)
> +		return addr;
> +	return 0;
> +}
> +
> #endif /* _ASM_IA64_DMA_MAPPING_H */
> diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/ 
> asm/dma-mapping.h
> index 916cbb6..b2813ab 100644
> --- a/arch/x86/include/asm/dma-mapping.h
> +++ b/arch/x86/include/asm/dma-mapping.h
> @@ -309,4 +309,20 @@ static inline void dma_free_coherent(struct  
> device *dev, size_t size,
> 		ops->free_coherent(dev, size, vaddr, bus);
> }
>
> +static inline dma_addr_t dma_map_range(struct device *dev, u64 mask,
> +				       phys_addr_t addr, size_t size)
> +{
> +	dma_addr_t dma_addr;
> +#ifdef CONFIG_XEN
> +	extern int xen_range_needs_mapping(phys_addr_t paddr, size_t size);
> +	if (xen_pv_domain() && xen_range_needs_mapping(addr, size))
> +		return 0;
> +#endif
> +
> +	dma_addr = swiotlb_phys_to_bus(dev, addr);
> +	if (dma_addr + size <= mask)
> +		return 0;
> +	return dma_addr;
> +}
> +
> #endif
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 2fffc22..c2b4196 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -145,8 +145,8 @@ again:
> 	if (!page)
> 		return NULL;
>
> -	addr = page_to_phys(page);
> -	if (!is_buffer_dma_capable(dma_mask, addr, size)) {
> +	addr = dma_map_range(dev, dma_mask, page_to_phys(page), size);
> +	if (!(addr == 0)) {
> 		__free_pages(page, get_order(size));
>
> 		if (dma_mask < DMA_BIT_MASK(32) && !(flag & GFP_DMA)) {
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci- 
> gart_64.c
> index 1e8920d..6a55770 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -191,13 +191,13 @@ static inline int
> need_iommu(struct device *dev, unsigned long addr, size_t size)
> {
> 	return force_iommu ||
> -		!is_buffer_dma_capable(*dev->dma_mask, addr, size);
> +		dma_map_range(dev, *dev->dma_mask, addr, size) == 0;
> }
>
> static inline int
> nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
> {
> -	return !is_buffer_dma_capable(*dev->dma_mask, addr, size);
> +	return dma_map_range(dev, *dev->dma_mask, addr, size) == 0;
> }
>
> /* Map a single continuous physical area into the IOMMU.
> diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> index 71d412a..712ce59 100644
> --- a/arch/x86/kernel/pci-nommu.c
> +++ b/arch/x86/kernel/pci-nommu.c
> @@ -12,13 +12,13 @@
> #include <asm/dma.h>
>
> static int
> -check_addr(char *name, struct device *hwdev, dma_addr_t bus, size_t  
> size)
> +check_addr(char *name, struct device *hwdev, phys_addr_t phys,  
> size_t size)
> {
> -	if (hwdev && !is_buffer_dma_capable(*hwdev->dma_mask, bus, size)) {
> +	if (hwdev && dma_map_range(hwdev, *hwdev->dma_mask, phys, size) ==  
> 0) {
> 		if (*hwdev->dma_mask >= DMA_BIT_MASK(32))
> 			printk(KERN_ERR
> 			    "nommu_%s: overflow %Lx+%zu of device mask %Lx\n",
> -				name, (long long)bus, size,
> +				name, (long long)phys, size,
> 				(long long)*hwdev->dma_mask);
> 		return 0;
> 	}
> @@ -30,12 +30,12 @@ static dma_addr_t nommu_map_page(struct device  
> *dev, struct page *page,
> 				 enum dma_data_direction dir,
> 				 struct dma_attrs *attrs)
> {
> -	dma_addr_t bus = page_to_phys(page) + offset;
> +	phys_addr_t phys = page_to_phys(page) + offset;
> 	WARN_ON(size == 0);
> -	if (!check_addr("map_single", dev, bus, size))
> +	if (!check_addr("map_single", dev, phys, size))
> 		return bad_dma_address;
> 	flush_write_buffers();
> -	return bus;
> +	return phys;
> }
>
> /* Map a set of buffers described by scatterlist in streaming
> diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
> index 8083b6a..85dafa1 100644
> --- a/include/linux/dma-mapping.h
> +++ b/include/linux/dma-mapping.h
> @@ -96,11 +96,6 @@ static inline int is_device_dma_capable(struct  
> device *dev)
> 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;
> }
>
> -static inline int is_buffer_dma_capable(u64 mask, dma_addr_t addr,  
> size_t size)
> -{
> -	return addr + size <= mask;
> -}
> -
> #ifdef CONFIG_HAS_DMA
> #include <asm/dma-mapping.h>
> #else
> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
> index cec5f62..4fd5185 100644
> --- a/lib/swiotlb.c
> +++ b/lib/swiotlb.c
> @@ -147,17 +147,6 @@ void * __weak swiotlb_bus_to_virt(struct device  
> *hwdev, dma_addr_t address)
> 	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
> }
>
> -int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
> -					       dma_addr_t addr, size_t size)
> -{
> -	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
> -}
> -
> -int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr,  
> size_t size)
> -{
> -	return 0;
> -}
> -
> static void swiotlb_print_info(unsigned long bytes)
> {
> 	phys_addr_t pstart, pend;
> @@ -318,17 +307,6 @@ cleanup1:
> 	return -ENOMEM;
> }
>
> -static inline int
> -address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t  
> size)
> -{
> -	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
> -}
> -
> -static inline int range_needs_mapping(phys_addr_t paddr, size_t size)
> -{
> -	return swiotlb_force || swiotlb_arch_range_needs_mapping(paddr,  
> size);
> -}
> -
> static int is_swiotlb_buffer(char *addr)
> {
> 	return addr >= io_tlb_start && addr < io_tlb_end;
> @@ -555,18 +533,17 @@ void *
> swiotlb_alloc_coherent(struct device *hwdev, size_t size,
> 		       dma_addr_t *dma_handle, gfp_t flags)
> {
> -	dma_addr_t dev_addr;
> +	phys_addr_t phys;
> 	void *ret;
> 	int order = get_order(size);
> 	u64 dma_mask = DMA_BIT_MASK(32);
> +	dma_addr_t dma_addr;
>
> 	if (hwdev && hwdev->coherent_dma_mask)
> 		dma_mask = hwdev->coherent_dma_mask;
>
> 	ret = (void *)__get_free_pages(flags, order);
> -	if (ret &&
> -	    !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(hwdev,  
> ret),
> -				   size)) {
> +	if (ret && dma_map_range(hwdev, dma_mask, virt_to_phys(ret), size)  
> == 0) {
> 		/*
> 		 * The allocated memory isn't reachable by the device.
> 		 */
> @@ -585,19 +562,20 @@ swiotlb_alloc_coherent(struct device *hwdev,  
> size_t size,
> 	}
>
> 	memset(ret, 0, size);
> -	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
> +	phys = virt_to_phys(ret);
>
> 	/* Confirm address can be DMA'd by device */
> -	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
> -		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
> +	dma_addr = dma_map_range(hwdev, dma_mask, phys, size);
> +	if (dma_addr == 0) {
> +		printk("hwdev DMA mask = 0x%016Lx, physical addr = 0x%016Lx\n",
> 		       (unsigned long long)dma_mask,
> -		       (unsigned long long)dev_addr);
> +		       (unsigned long long)phys);
>
> 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
> 		do_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
> 		return NULL;
> 	}
> -	*dma_handle = dev_addr;
> +	*dma_handle = dma_addr;
> 	return ret;
> }
> EXPORT_SYMBOL(swiotlb_alloc_coherent);
> @@ -649,7 +627,7 @@ dma_addr_t swiotlb_map_page(struct device *dev,  
> struct page *page,
> 			    struct dma_attrs *attrs)
> {
> 	phys_addr_t phys = page_to_phys(page) + offset;
> -	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
> +	dma_addr_t dma_addr;
> 	void *map;
>
> 	BUG_ON(dir == DMA_NONE);
> @@ -658,9 +636,9 @@ dma_addr_t swiotlb_map_page(struct device *dev,  
> struct page *page,
> 	 * we can safely return the device addr and not worry about bounce
> 	 * buffering it.
> 	 */
> -	if (!address_needs_mapping(dev, dev_addr, size) &&
> -	    !range_needs_mapping(phys, size))
> -		return dev_addr;
> +	dma_addr = dma_map_range(dev, dma_get_mask(dev), phys, size);
> +	if (dma_addr && !swiotlb_force)
> +		return dma_addr;
>
> 	/*
> 	 * Oh well, have to allocate and map a bounce buffer.
> @@ -671,15 +649,14 @@ dma_addr_t swiotlb_map_page(struct device  
> *dev, struct page *page,
> 		map = io_tlb_overflow_buffer;
> 	}
>
> -	dev_addr = swiotlb_virt_to_bus(dev, map);
> -
> 	/*
> 	 * Ensure that the address returned is DMA'ble
> 	 */
> -	if (address_needs_mapping(dev, dev_addr, size))
> +	dma_addr = dma_map_range(dev, dma_get_mask(dev),  
> virt_to_phys(map), size);
> +	if (dma_addr == 0)
> 		panic("map_single: bounce buffer is not DMA'ble");
>
> -	return dev_addr;
> +	return dma_addr;
> }
> EXPORT_SYMBOL_GPL(swiotlb_map_page);
>
> @@ -820,10 +797,8 @@ swiotlb_map_sg_attrs(struct device *hwdev,  
> struct scatterlist *sgl, int nelems,
>
> 	for_each_sg(sgl, sg, nelems, i) {
> 		phys_addr_t paddr = sg_phys(sg);
> -		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
> -
> -		if (range_needs_mapping(paddr, sg->length) ||
> -		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
> +		dma_addr_t dma_addr = dma_map_range(hwdev, dma_get_mask(hwdev),  
> paddr, sg->length);
> +		if (dma_addr == 0 || swiotlb_force) {
> 			void *map = map_single(hwdev, sg_phys(sg),
> 					       sg->length, dir);
> 			if (!map) {
> @@ -835,9 +810,9 @@ swiotlb_map_sg_attrs(struct device *hwdev,  
> struct scatterlist *sgl, int nelems,
> 				sgl[0].dma_length = 0;
> 				return 0;
> 			}
> -			sg->dma_address = swiotlb_virt_to_bus(hwdev, map);
> -		} else
> -			sg->dma_address = dev_addr;
> +			dma_addr = dma_map_range(hwdev, dma_get_mask(hwdev),  
> virt_to_phys(map), sg->length);
> +		}
> +		sg->dma_address = dma_addr;
> 		sg->dma_length = sg->length;
> 	}
> 	return nelems;
>

