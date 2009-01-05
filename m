Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbZAESAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbZAESAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbZAESAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:00:42 -0500
Received: from 8bytes.org ([88.198.83.132]:38128 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752516AbZAESAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:00:41 -0500
Date: Mon, 5 Jan 2009 19:00:38 +0100
From: Joerg Roedel <joro@8bytes.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] remove map_single and unmap_single in struct dma_mapping_ops
Message-ID: <20090105180038.GD14298@8bytes.org>
References: <1231166848-20149-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-2-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-3-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-5-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-6-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-7-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-8-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1231166848-20149-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231166848-20149-9-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it the right way to implement map_single in terms of map_page? Doing
this you optimize for the map_page case. But a grep in drivers/ shows:

linux/drivers $ grep -r _map_page *|wc -l
126
linux/drivers $ grep -r _map_single *|wc -l
613

There are a lot more users of map_single than of map_page. I think its
better to optimize for the map_single case and implement map_page in
terms of map_single.

Joerg

On Mon, Jan 05, 2009 at 11:47:28PM +0900, FUJITA Tomonori wrote:
> This patch converts dma_map_single and dma_unmap_single to use
> map_page and unmap_page respectively and removes unnecessary
> map_single and unmap_single in struct dma_mapping_ops.
> 
> This leaves intel-iommu's dma_map_single and dma_unmap_single since
> IA64 uses them. They will be removed after the unification.
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  arch/x86/include/asm/dma-mapping.h |   15 ++++++---------
>  arch/x86/kernel/amd_iommu.c        |   15 ---------------
>  arch/x86/kernel/pci-calgary_64.c   |   16 ----------------
>  arch/x86/kernel/pci-gart_64.c      |   19 ++-----------------
>  arch/x86/kernel/pci-nommu.c        |    8 --------
>  arch/x86/kernel/pci-swiotlb_64.c   |    9 ---------
>  drivers/pci/intel-iommu.c          |    2 --
>  7 files changed, 8 insertions(+), 76 deletions(-)
> 
> diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
> index 2f89d2e..a0cb867 100644
> --- a/arch/x86/include/asm/dma-mapping.h
> +++ b/arch/x86/include/asm/dma-mapping.h
> @@ -25,10 +25,6 @@ struct dma_mapping_ops {
>  				dma_addr_t *dma_handle, gfp_t gfp);
>  	void            (*free_coherent)(struct device *dev, size_t size,
>  				void *vaddr, dma_addr_t dma_handle);
> -	dma_addr_t      (*map_single)(struct device *hwdev, phys_addr_t ptr,
> -				size_t size, int direction);
> -	void            (*unmap_single)(struct device *dev, dma_addr_t addr,
> -				size_t size, int direction);
>  	void            (*sync_single_for_cpu)(struct device *hwdev,
>  				dma_addr_t dma_handle, size_t size,
>  				int direction);
> @@ -105,7 +101,9 @@ dma_map_single(struct device *hwdev, void *ptr, size_t size,
>  
>  	BUG_ON(!valid_dma_direction(direction));
>  	kmemcheck_mark_initialized(ptr, size);
> -	return ops->map_single(hwdev, virt_to_phys(ptr), size, direction);
> +	return ops->map_page(hwdev, virt_to_page(ptr),
> +			     (unsigned long)ptr & ~PAGE_MASK, size,
> +			     direction, NULL);
>  }
>  
>  static inline void
> @@ -115,8 +113,8 @@ dma_unmap_single(struct device *dev, dma_addr_t addr, size_t size,
>  	struct dma_mapping_ops *ops = get_dma_ops(dev);
>  
>  	BUG_ON(!valid_dma_direction(direction));
> -	if (ops->unmap_single)
> -		ops->unmap_single(dev, addr, size, direction);
> +	if (ops->unmap_page)
> +		ops->unmap_page(dev, addr, size, direction, NULL);
>  }
>  
>  static inline int
> @@ -223,8 +221,7 @@ static inline dma_addr_t dma_map_page(struct device *dev, struct page *page,
>  	struct dma_mapping_ops *ops = get_dma_ops(dev);
>  
>  	BUG_ON(!valid_dma_direction(direction));
> -	return ops->map_single(dev, page_to_phys(page) + offset,
> -			       size, direction);
> +	return ops->map_page(dev, page, offset, size, direction, NULL);
>  }
>  
>  static inline void dma_unmap_page(struct device *dev, dma_addr_t addr,
> diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
> index 8570441..a5dedb6 100644
> --- a/arch/x86/kernel/amd_iommu.c
> +++ b/arch/x86/kernel/amd_iommu.c
> @@ -1341,13 +1341,6 @@ out:
>  	return addr;
>  }
>  
> -static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
> -			     size_t size, int dir)
> -{
> -	return map_page(dev, pfn_to_page(paddr >> PAGE_SHIFT),
> -			paddr & ~PAGE_MASK, size, dir, NULL);
> -}
> -
>  /*
>   * The exported unmap_single function for dma_ops.
>   */
> @@ -1378,12 +1371,6 @@ static void unmap_page(struct device *dev, dma_addr_t dma_addr, size_t size,
>  	spin_unlock_irqrestore(&domain->lock, flags);
>  }
>  
> -static void unmap_single(struct device *dev, dma_addr_t dma_addr,
> -			 size_t size, int dir)
> -{
> -	return unmap_page(dev, dma_addr, size, dir, NULL);
> -}
> -
>  /*
>   * This is a special map_sg function which is used if we should map a
>   * device which is not handled by an AMD IOMMU in the system.
> @@ -1664,8 +1651,6 @@ static void prealloc_protection_domains(void)
>  static struct dma_mapping_ops amd_iommu_dma_ops = {
>  	.alloc_coherent = alloc_coherent,
>  	.free_coherent = free_coherent,
> -	.map_single = map_single,
> -	.unmap_single = unmap_single,
>  	.map_page = map_page,
>  	.unmap_page = unmap_page,
>  	.map_sg = map_sg,
> diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
> index e33cfcf..756138b 100644
> --- a/arch/x86/kernel/pci-calgary_64.c
> +++ b/arch/x86/kernel/pci-calgary_64.c
> @@ -461,14 +461,6 @@ static dma_addr_t calgary_map_page(struct device *dev, struct page *page,
>  	return iommu_alloc(dev, tbl, vaddr, npages, dir);
>  }
>  
> -static dma_addr_t calgary_map_single(struct device *dev, phys_addr_t paddr,
> -				     size_t size, int direction)
> -{
> -	return calgary_map_page(dev, pfn_to_page(paddr >> PAGE_SHIFT),
> -				paddr & ~PAGE_MASK, size,
> -				direction, NULL);
> -}
> -
>  static void calgary_unmap_page(struct device *dev, dma_addr_t dma_addr,
>  			       size_t size, enum dma_data_direction dir,
>  			       struct dma_attrs *attrs)
> @@ -480,12 +472,6 @@ static void calgary_unmap_page(struct device *dev, dma_addr_t dma_addr,
>  	iommu_free(tbl, dma_addr, npages);
>  }
>  
> -static void calgary_unmap_single(struct device *dev, dma_addr_t dma_handle,
> -				 size_t size, int direction)
> -{
> -	calgary_unmap_page(dev, dma_handle, size, direction, NULL);
> -}
> -
>  static void* calgary_alloc_coherent(struct device *dev, size_t size,
>  	dma_addr_t *dma_handle, gfp_t flag)
>  {
> @@ -535,8 +521,6 @@ static void calgary_free_coherent(struct device *dev, size_t size,
>  static struct dma_mapping_ops calgary_dma_ops = {
>  	.alloc_coherent = calgary_alloc_coherent,
>  	.free_coherent = calgary_free_coherent,
> -	.map_single = calgary_map_single,
> -	.unmap_single = calgary_unmap_single,
>  	.map_sg = calgary_map_sg,
>  	.unmap_sg = calgary_unmap_sg,
>  	.map_page = calgary_map_page,
> diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
> index e49c6dd..9c557c0 100644
> --- a/arch/x86/kernel/pci-gart_64.c
> +++ b/arch/x86/kernel/pci-gart_64.c
> @@ -275,13 +275,6 @@ static dma_addr_t gart_map_page(struct device *dev, struct page *page,
>  	return bus;
>  }
>  
> -static dma_addr_t gart_map_single(struct device *dev, phys_addr_t paddr,
> -				  size_t size, int dir)
> -{
> -	return gart_map_page(dev, pfn_to_page(paddr >> PAGE_SHIFT),
> -			     paddr & ~PAGE_MASK, size, dir, NULL);
> -}
> -
>  /*
>   * Free a DMA mapping.
>   */
> @@ -306,12 +299,6 @@ static void gart_unmap_page(struct device *dev, dma_addr_t dma_addr,
>  	free_iommu(iommu_page, npages);
>  }
>  
> -static void gart_unmap_single(struct device *dev, dma_addr_t dma_addr,
> -			      size_t size, int direction)
> -{
> -	gart_unmap_page(dev, dma_addr, size, direction, NULL);
> -}
> -
>  /*
>   * Wrapper for pci_unmap_single working with scatterlists.
>   */
> @@ -324,7 +311,7 @@ gart_unmap_sg(struct device *dev, struct scatterlist *sg, int nents, int dir)
>  	for_each_sg(sg, s, nents, i) {
>  		if (!s->dma_length || !s->length)
>  			break;
> -		gart_unmap_single(dev, s->dma_address, s->dma_length, dir);
> +		gart_unmap_page(dev, s->dma_address, s->dma_length, dir, NULL);
>  	}
>  }
>  
> @@ -538,7 +525,7 @@ static void
>  gart_free_coherent(struct device *dev, size_t size, void *vaddr,
>  		   dma_addr_t dma_addr)
>  {
> -	gart_unmap_single(dev, dma_addr, size, DMA_BIDIRECTIONAL);
> +	gart_unmap_page(dev, dma_addr, size, DMA_BIDIRECTIONAL, NULL);
>  	free_pages((unsigned long)vaddr, get_order(size));
>  }
>  
> @@ -725,8 +712,6 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
>  }
>  
>  static struct dma_mapping_ops gart_dma_ops = {
> -	.map_single			= gart_map_single,
> -	.unmap_single			= gart_unmap_single,
>  	.map_sg				= gart_map_sg,
>  	.unmap_sg			= gart_unmap_sg,
>  	.map_page			= gart_map_page,
> diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
> index 5a73a82..d42b69c 100644
> --- a/arch/x86/kernel/pci-nommu.c
> +++ b/arch/x86/kernel/pci-nommu.c
> @@ -38,13 +38,6 @@ static dma_addr_t nommu_map_page(struct device *dev, struct page *page,
>  	return bus;
>  }
>  
> -static dma_addr_t nommu_map_single(struct device *hwdev, phys_addr_t paddr,
> -				   size_t size, int direction)
> -{
> -	return nommu_map_page(hwdev, pfn_to_page(paddr >> PAGE_SHIFT),
> -			      paddr & ~PAGE_MASK, size, direction, NULL);
> -}
> -
>  /* Map a set of buffers described by scatterlist in streaming
>   * mode for DMA.  This is the scatter-gather version of the
>   * above pci_map_single interface.  Here the scatter gather list
> @@ -88,7 +81,6 @@ static void nommu_free_coherent(struct device *dev, size_t size, void *vaddr,
>  struct dma_mapping_ops nommu_dma_ops = {
>  	.alloc_coherent = dma_generic_alloc_coherent,
>  	.free_coherent = nommu_free_coherent,
> -	.map_single = nommu_map_single,
>  	.map_sg = nommu_map_sg,
>  	.map_page = nommu_map_page,
>  	.is_phys = 1,
> diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
> index d1c0366..3ae354c 100644
> --- a/arch/x86/kernel/pci-swiotlb_64.c
> +++ b/arch/x86/kernel/pci-swiotlb_64.c
> @@ -38,13 +38,6 @@ int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
>  	return 0;
>  }
>  
> -static dma_addr_t
> -swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
> -			int direction)
> -{
> -	return swiotlb_map_single(hwdev, phys_to_virt(paddr), size, direction);
> -}
> -
>  /* these will be moved to lib/swiotlb.c later on */
>  
>  static dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
> @@ -78,8 +71,6 @@ struct dma_mapping_ops swiotlb_dma_ops = {
>  	.mapping_error = swiotlb_dma_mapping_error,
>  	.alloc_coherent = x86_swiotlb_alloc_coherent,
>  	.free_coherent = swiotlb_free_coherent,
> -	.map_single = swiotlb_map_single_phys,
> -	.unmap_single = swiotlb_unmap_single,
>  	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
>  	.sync_single_for_device = swiotlb_sync_single_for_device,
>  	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index 60258ec..da273e4 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -2582,8 +2582,6 @@ int intel_map_sg(struct device *hwdev, struct scatterlist *sglist, int nelems,
>  static struct dma_mapping_ops intel_dma_ops = {
>  	.alloc_coherent = intel_alloc_coherent,
>  	.free_coherent = intel_free_coherent,
> -	.map_single = intel_map_single,
> -	.unmap_single = intel_unmap_single,
>  	.map_sg = intel_map_sg,
>  	.unmap_sg = intel_unmap_sg,
>  #ifdef CONFIG_X86_64
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
