Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYCZNSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYCZNSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYCZNS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:18:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753972AbYCZNS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:18:29 -0400
Message-ID: <47EA4CB1.8070609@redhat.com>
Date: Wed, 26 Mar 2008 10:16:33 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, kvm-devel@lists.sourceforge.net, avi@qumranet.com,
       amit.shah@qumranet.com
Subject: Re: [PATCH 0/20] dma_ops for i386
References: <1206480999-21767-1-git-send-email-gcosta@redhat.com> <20080326070616.GI18301@elte.hu> <20080326124929.GA12602@elte.hu> <20080326130417.GA13602@elte.hu>
In-Reply-To: <20080326130417.GA13602@elte.hu>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
>> what i came up is the prototype 32-bit fix below - this works on 
>> 32-bit but breaks 64-bit because we pass in physical addresses instead 
>> of virtual direct addresses.
>>
>> i'll fix the 64-bit side but that means materially touching all the 
>> dma_mapping_ops instantiations materially on the 64-bit side - not 
>> really something we wanted to do :-/
> 
> the full fix ended up being the one below. It's not that bad - and 
> gart_64.c looks even a bit cleaner. Still, it needs careful review.
> 
> 	Ingo
> 
> --------------->
> Subject: x86: dma-ops on highmem fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/pci-base_32.c    |    4 ++--
>  arch/x86/kernel/pci-calgary_64.c |    3 ++-
>  arch/x86/kernel/pci-dma_64.c     |    2 +-
>  arch/x86/kernel/pci-gart_64.c    |   15 +++++++--------
>  arch/x86/kernel/pci-nommu_64.c   |    4 ++--
>  arch/x86/kernel/pci-swiotlb_64.c |    9 ++++++++-
>  include/asm-x86/dma-mapping.h    |   10 ++++++----
>  7 files changed, 28 insertions(+), 19 deletions(-)
> 
> Index: linux-x86.q/arch/x86/kernel/pci-base_32.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/pci-base_32.c
> +++ linux-x86.q/arch/x86/kernel/pci-base_32.c
> @@ -4,12 +4,12 @@
>  #include <linux/dma-mapping.h>
>  #include <asm/dma-mapping.h>
>  
> -static dma_addr_t pci32_map_single(struct device *dev, void *ptr,
> +static dma_addr_t pci32_map_single(struct device *dev, phys_addr_t ptr,
>  				   size_t size, int direction)
>  {
>  	WARN_ON(size == 0);
>  	flush_write_buffers();
> -	return virt_to_phys(ptr);
> +	return ptr;
>  }
>  
>  static int pci32_dma_map_sg(struct device *dev, struct scatterlist *sglist,
> Index: linux-x86.q/arch/x86/kernel/pci-calgary_64.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/pci-calgary_64.c
> +++ linux-x86.q/arch/x86/kernel/pci-calgary_64.c
> @@ -470,10 +470,11 @@ error:
>  	return 0;
>  }
>  
> -static dma_addr_t calgary_map_single(struct device *dev, void *vaddr,
> +static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
>  	size_t size, int direction)
>  {
>  	dma_addr_t dma_handle = bad_dma_address;
> +	void *vaddr = phys_to_virt(paddr);
>  	unsigned long uaddr;
>  	unsigned int npages;
>  	struct iommu_table *tbl = find_iommu_table(dev);
> Index: linux-x86.q/arch/x86/kernel/pci-dma_64.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/pci-dma_64.c
> +++ linux-x86.q/arch/x86/kernel/pci-dma_64.c
> @@ -141,7 +141,7 @@ dma_alloc_coherent(struct device *dev, s
>  	}
>  
>  	if (dma_ops->map_simple) {
> -		*dma_handle = dma_ops->map_simple(dev, memory,
> +		*dma_handle = dma_ops->map_simple(dev, virt_to_phys(memory),
>  					      size,
>  					      PCI_DMA_BIDIRECTIONAL);
>  		if (*dma_handle != bad_dma_address)
> Index: linux-x86.q/arch/x86/kernel/pci-gart_64.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/pci-gart_64.c
> +++ linux-x86.q/arch/x86/kernel/pci-gart_64.c
> @@ -264,9 +264,9 @@ static dma_addr_t dma_map_area(struct de
>  }
>  
>  static dma_addr_t
> -gart_map_simple(struct device *dev, char *buf, size_t size, int dir)
> +gart_map_simple(struct device *dev, phys_addr_t paddr, size_t size, int dir)
>  {
> -	dma_addr_t map = dma_map_area(dev, virt_to_bus(buf), size, dir);
> +	dma_addr_t map = dma_map_area(dev, paddr, size, dir);
>  
>  	flush_gart();
>  
> @@ -275,18 +275,17 @@ gart_map_simple(struct device *dev, char
>  
>  /* Map a single area into the IOMMU */
>  static dma_addr_t
> -gart_map_single(struct device *dev, void *addr, size_t size, int dir)
> +gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
>  {
> -	unsigned long phys_mem, bus;
> +	unsigned long bus;
>  
>  	if (!dev)
>  		dev = &fallback_dev;
>  
> -	phys_mem = virt_to_phys(addr);
> -	if (!need_iommu(dev, phys_mem, size))
> -		return phys_mem;
> +	if (!need_iommu(dev, paddr, size))
> +		return paddr;
>  
> -	bus = gart_map_simple(dev, addr, size, dir);
> +	bus = gart_map_simple(dev, paddr, size, dir);
>  
>  	return bus;
>  }
> Index: linux-x86.q/arch/x86/kernel/pci-nommu_64.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/pci-nommu_64.c
> +++ linux-x86.q/arch/x86/kernel/pci-nommu_64.c
> @@ -26,10 +26,10 @@ check_addr(char *name, struct device *hw
>  }
>  
>  static dma_addr_t
> -nommu_map_single(struct device *hwdev, void *ptr, size_t size,
> +nommu_map_single(struct device *hwdev, phys_addr_t paddr, size_t size,
>  	       int direction)
>  {
> -	dma_addr_t bus = virt_to_bus(ptr);
> +	dma_addr_t bus = paddr;
>  	if (!check_addr("map_single", hwdev, bus, size))
>  				return bad_dma_address;
>  	return bus;
> Index: linux-x86.q/arch/x86/kernel/pci-swiotlb_64.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/pci-swiotlb_64.c
> +++ linux-x86.q/arch/x86/kernel/pci-swiotlb_64.c
> @@ -11,11 +11,18 @@
>  
>  int swiotlb __read_mostly;
>  
> +static dma_addr_t
> +swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
> +			int direction)
> +{
> +	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
> +}
> +
>  const struct dma_mapping_ops swiotlb_dma_ops = {
>  	.mapping_error = swiotlb_dma_mapping_error,
>  	.alloc_coherent = swiotlb_alloc_coherent,
>  	.free_coherent = swiotlb_free_coherent,
> -	.map_single = swiotlb_map_single,
> +	.map_single = swiotlb_map_single_phys,
>  	.unmap_single = swiotlb_unmap_single,
>  	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
>  	.sync_single_for_device = swiotlb_sync_single_for_device,
> Index: linux-x86.q/include/asm-x86/dma-mapping.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/dma-mapping.h
> +++ linux-x86.q/include/asm-x86/dma-mapping.h
> @@ -16,10 +16,10 @@ struct dma_mapping_ops {
>  				dma_addr_t *dma_handle, gfp_t gfp);
>  	void            (*free_coherent)(struct device *dev, size_t size,
>  				void *vaddr, dma_addr_t dma_handle);
> -	dma_addr_t      (*map_single)(struct device *hwdev, void *ptr,
> +	dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
>  				size_t size, int direction);
>  	/* like map_single, but doesn't check the device mask */
> -	dma_addr_t      (*map_simple)(struct device *hwdev, char *ptr,
> +	dma_addr_t      (*map_simple)(struct device *hwdev, phys_addr_t ptr,
>  				size_t size, int direction);
>  	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
>  				size_t size, int direction);
> @@ -73,7 +73,7 @@ dma_map_single(struct device *hwdev, voi
>  	       int direction)
>  {
>  	BUG_ON(!valid_dma_direction(direction));
> -	return dma_ops->map_single(hwdev, ptr, size, direction);
> +	return dma_ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
>  }
>  
>  static inline void
> @@ -174,7 +174,9 @@ static inline dma_addr_t dma_map_page(st
>  				      size_t offset, size_t size,
>  				      int direction)
>  {
> -	return dma_map_single(dev, page_address(page)+offset, size, direction);
> +	BUG_ON(!valid_dma_direction(direction));
> +	return dma_ops->map_single(dev, page_to_phys(page)+offset,
> +				   size, direction);
>  }
>  
>  static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
It looks all good to me.
I'll give a shot in my systems to see if it goes okay.
