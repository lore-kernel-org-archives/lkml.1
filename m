Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZG0VI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZG0VI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZG0VIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:08:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:59079 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZG0VIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:08:54 -0400
Cc: linuxppc-dev@lists.ozlabs.org, galak@kernel.crashing.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Message-Id: <B388F2F2-C68F-4464-A63A-4D541DF5E9C9@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1248405855-15546-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH 5/5] powerpc: use asm-generic/dma-mapping-common.h
Date: Mon, 27 Jul 2009 16:08:46 -0500
References: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1248405855-15546-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 23, 2009, at 10:24 PM, FUJITA Tomonori wrote:

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Fujita,

Since you're removing all the uses of it, you should probably remove  
PPC_NEED_DMA_SYNC_OPS from arch/powerpc/Kconfig:

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 0603b6c..fb3f4ff 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -307,10 +307,6 @@ config SWIOTLB
           platforms where the size of a physical address is larger
           than the bus address.  Not all platforms support this.

-config PPC_NEED_DMA_SYNC_OPS
-       def_bool y
-       depends on (NOT_COHERENT_CACHE || SWIOTLB)
-
  config HOTPLUG_CPU
         bool "Support for enabling/disabling CPUs"
         depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES ||  
PPC_PMAC)

Otherwise, this looks good to me.

I also think you want an ACK from Ben - making this switch does add  
slight overhead to platforms that don't need sync ops, but I think  
it's worth it.  IIRC, it was Ben who asked for the optimization of  
NEED_DMA_SYNC_OPS, so I'd like him to weigh in here.

Cheers,
Becky


>
> ---
> arch/powerpc/Kconfig                   |    2 +-
> arch/powerpc/include/asm/dma-mapping.h |  242  
> +-------------------------------
> 2 files changed, 7 insertions(+), 237 deletions(-)
>
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index d00131c..0603b6c 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -120,7 +120,7 @@ config PPC
> 	select HAVE_KRETPROBES
> 	select HAVE_ARCH_TRACEHOOK
> 	select HAVE_LMB
> -	select HAVE_DMA_ATTRS if PPC64
> +	select HAVE_DMA_ATTRS
> 	select USE_GENERIC_SMP_HELPERS if SMP
> 	select HAVE_OPROFILE
> 	select HAVE_SYSCALL_WRAPPERS if PPC64
> diff --git a/arch/powerpc/include/asm/dma-mapping.h b/arch/powerpc/ 
> include/asm/dma-mapping.h
> index 8ca2b51..91217e4 100644
> --- a/arch/powerpc/include/asm/dma-mapping.h
> +++ b/arch/powerpc/include/asm/dma-mapping.h
> @@ -14,6 +14,7 @@
> #include <linux/mm.h>
> #include <linux/scatterlist.h>
> #include <linux/dma-attrs.h>
> +#include <linux/dma-debug.h>
> #include <asm/io.h>
> #include <asm/swiotlb.h>
>
> @@ -89,6 +90,11 @@ static inline void set_dma_ops(struct device  
> *dev, struct dma_map_ops *ops)
> 	dev->archdata.dma_ops = ops;
> }
>
> +/* this will be removed soon */
> +#define flush_write_buffers()
> +
> +#include <asm-generic/dma-mapping-common.h>
> +
> static inline int dma_supported(struct device *dev, u64 mask)
> {
> 	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> @@ -117,87 +123,6 @@ static inline int dma_set_mask(struct device  
> *dev, u64 dma_mask)
> 	return 0;
> }
>
> -/*
> - * map_/unmap_single actually call through to map/unmap_page now  
> that all the
> - * dma_map_ops have been converted over. We just have to get the  
> page and
> - * offset to pass through to map_page
> - */
> -static inline dma_addr_t dma_map_single_attrs(struct device *dev,
> -					      void *cpu_addr,
> -					      size_t size,
> -					      enum dma_data_direction direction,
> -					      struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	return dma_ops->map_page(dev, virt_to_page(cpu_addr),
> -				 (unsigned long)cpu_addr % PAGE_SIZE, size,
> -				 direction, attrs);
> -}
> -
> -static inline void dma_unmap_single_attrs(struct device *dev,
> -					  dma_addr_t dma_addr,
> -					  size_t size,
> -					  enum dma_data_direction direction,
> -					  struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	dma_ops->unmap_page(dev, dma_addr, size, direction, attrs);
> -}
> -
> -static inline dma_addr_t dma_map_page_attrs(struct device *dev,
> -					    struct page *page,
> -					    unsigned long offset, size_t size,
> -					    enum dma_data_direction direction,
> -					    struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	return dma_ops->map_page(dev, page, offset, size, direction, attrs);
> -}
> -
> -static inline void dma_unmap_page_attrs(struct device *dev,
> -					dma_addr_t dma_address,
> -					size_t size,
> -					enum dma_data_direction direction,
> -					struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	dma_ops->unmap_page(dev, dma_address, size, direction, attrs);
> -}
> -
> -static inline int dma_map_sg_attrs(struct device *dev, struct  
> scatterlist *sg,
> -				   int nents, enum dma_data_direction direction,
> -				   struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -	return dma_ops->map_sg(dev, sg, nents, direction, attrs);
> -}
> -
> -static inline void dma_unmap_sg_attrs(struct device *dev,
> -				      struct scatterlist *sg,
> -				      int nhwentries,
> -				      enum dma_data_direction direction,
> -				      struct dma_attrs *attrs)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -	dma_ops->unmap_sg(dev, sg, nhwentries, direction, attrs);
> -}
> -
> static inline void *dma_alloc_coherent(struct device *dev, size_t  
> size,
> 				       dma_addr_t *dma_handle, gfp_t flag)
> {
> @@ -216,161 +141,6 @@ static inline void dma_free_coherent(struct  
> device *dev, size_t size,
> 	dma_ops->free_coherent(dev, size, cpu_addr, dma_handle);
> }
>
> -static inline dma_addr_t dma_map_single(struct device *dev, void  
> *cpu_addr,
> -					size_t size,
> -					enum dma_data_direction direction)
> -{
> -	return dma_map_single_attrs(dev, cpu_addr, size, direction, NULL);
> -}
> -
> -static inline void dma_unmap_single(struct device *dev, dma_addr_t  
> dma_addr,
> -				    size_t size,
> -				    enum dma_data_direction direction)
> -{
> -	dma_unmap_single_attrs(dev, dma_addr, size, direction, NULL);
> -}
> -
> -static inline dma_addr_t dma_map_page(struct device *dev, struct  
> page *page,
> -				      unsigned long offset, size_t size,
> -				      enum dma_data_direction direction)
> -{
> -	return dma_map_page_attrs(dev, page, offset, size, direction, NULL);
> -}
> -
> -static inline void dma_unmap_page(struct device *dev, dma_addr_t  
> dma_address,
> -				  size_t size,
> -				  enum dma_data_direction direction)
> -{
> -	dma_unmap_page_attrs(dev, dma_address, size, direction, NULL);
> -}
> -
> -static inline int dma_map_sg(struct device *dev, struct scatterlist  
> *sg,
> -			     int nents, enum dma_data_direction direction)
> -{
> -	return dma_map_sg_attrs(dev, sg, nents, direction, NULL);
> -}
> -
> -static inline void dma_unmap_sg(struct device *dev, struct  
> scatterlist *sg,
> -				int nhwentries,
> -				enum dma_data_direction direction)
> -{
> -	dma_unmap_sg_attrs(dev, sg, nhwentries, direction, NULL);
> -}
> -
> -#ifdef CONFIG_PPC_NEED_DMA_SYNC_OPS
> -static inline void dma_sync_single_for_cpu(struct device *dev,
> -		dma_addr_t dma_handle, size_t size,
> -		enum dma_data_direction direction)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	if (dma_ops->sync_single_range_for_cpu)
> -		dma_ops->sync_single_range_for_cpu(dev, dma_handle, 0,
> -					   size, direction);
> -}
> -
> -static inline void dma_sync_single_for_device(struct device *dev,
> -		dma_addr_t dma_handle, size_t size,
> -		enum dma_data_direction direction)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	if (dma_ops->sync_single_range_for_device)
> -		dma_ops->sync_single_range_for_device(dev, dma_handle,
> -					      0, size, direction);
> -}
> -
> -static inline void dma_sync_sg_for_cpu(struct device *dev,
> -		struct scatterlist *sgl, int nents,
> -		enum dma_data_direction direction)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	if (dma_ops->sync_sg_for_cpu)
> -		dma_ops->sync_sg_for_cpu(dev, sgl, nents, direction);
> -}
> -
> -static inline void dma_sync_sg_for_device(struct device *dev,
> -		struct scatterlist *sgl, int nents,
> -		enum dma_data_direction direction)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	if (dma_ops->sync_sg_for_device)
> -		dma_ops->sync_sg_for_device(dev, sgl, nents, direction);
> -}
> -
> -static inline void dma_sync_single_range_for_cpu(struct device *dev,
> -		dma_addr_t dma_handle, unsigned long offset, size_t size,
> -		enum dma_data_direction direction)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	if (dma_ops->sync_single_range_for_cpu)
> -		dma_ops->sync_single_range_for_cpu(dev, dma_handle,
> -					   offset, size, direction);
> -}
> -
> -static inline void dma_sync_single_range_for_device(struct device  
> *dev,
> -		dma_addr_t dma_handle, unsigned long offset, size_t size,
> -		enum dma_data_direction direction)
> -{
> -	struct dma_map_ops *dma_ops = get_dma_ops(dev);
> -
> -	BUG_ON(!dma_ops);
> -
> -	if (dma_ops->sync_single_range_for_device)
> -		dma_ops->sync_single_range_for_device(dev, dma_handle, offset,
> -					      size, direction);
> -}
> -#else /* CONFIG_PPC_NEED_DMA_SYNC_OPS */
> -static inline void dma_sync_single_for_cpu(struct device *dev,
> -		dma_addr_t dma_handle, size_t size,
> -		enum dma_data_direction direction)
> -{
> -}
> -
> -static inline void dma_sync_single_for_device(struct device *dev,
> -		dma_addr_t dma_handle, size_t size,
> -		enum dma_data_direction direction)
> -{
> -}
> -
> -static inline void dma_sync_sg_for_cpu(struct device *dev,
> -		struct scatterlist *sgl, int nents,
> -		enum dma_data_direction direction)
> -{
> -}
> -
> -static inline void dma_sync_sg_for_device(struct device *dev,
> -		struct scatterlist *sgl, int nents,
> -		enum dma_data_direction direction)
> -{
> -}
> -
> -static inline void dma_sync_single_range_for_cpu(struct device *dev,
> -		dma_addr_t dma_handle, unsigned long offset, size_t size,
> -		enum dma_data_direction direction)
> -{
> -}
> -
> -static inline void dma_sync_single_range_for_device(struct device  
> *dev,
> -		dma_addr_t dma_handle, unsigned long offset, size_t size,
> -		enum dma_data_direction direction)
> -{
> -}
> -#endif
> -
> static inline int dma_mapping_error(struct device *dev, dma_addr_t  
> dma_addr)
> {
> #ifdef CONFIG_PPC64
> -- 
> 1.6.0.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

