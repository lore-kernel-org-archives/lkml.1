Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118AbXJWPQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbXJWPQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751819AbXJWPQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:16:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:6507 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbXJWPQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:16:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,317,1188802800"; 
   d="scan'208";a="304009481"
Date: Tue, 23 Oct 2007 08:04:43 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: David Miller <davem@davemloft.net>
Cc: anil.s.keshavamurthy@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Genericizing iova.[ch]
Message-ID: <20071023150442.GC18751@askeshav-devel.jf.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20071023.010156.41630559.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023.010156.41630559.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2007 at 01:01:56AM -0700, David Miller wrote:
> 
> I would like to potentially move the sparc64 IOMMU code over to using
> the nice new drivers/pci/iova.[ch] code for free area management..
Welcome!! 
> 
> In order to do that we have to detach the IOMMU page size assumptions
> which only really need to exist in the intel-iommu.[ch] code.
> 
> This patch attempts to implement that.
Your patch looks good to me.

Andrew,
	Please queue this patch in your mm tree.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

> 
> diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
> index b3d7031..7f2aec4 100644
> --- a/drivers/pci/intel-iommu.c
> +++ b/drivers/pci/intel-iommu.c
> @@ -1089,7 +1089,7 @@ static void dmar_init_reserved_ranges(void)
>  	int i;
>  	u64 addr, size;
>  
> -	init_iova_domain(&reserved_iova_list);
> +	init_iova_domain(&reserved_iova_list, DMA_32BIT_PFN);
>  
>  	/* IOAPIC ranges shouldn't be accessed by DMA */
>  	iova = reserve_iova(&reserved_iova_list, IOVA_PFN(IOAPIC_RANGE_START),
> @@ -1143,7 +1143,7 @@ static int domain_init(struct dmar_domain *domain, int guest_width)
>  	int adjust_width, agaw;
>  	unsigned long sagaw;
>  
> -	init_iova_domain(&domain->iovad);
> +	init_iova_domain(&domain->iovad, DMA_32BIT_PFN);
>  	spin_lock_init(&domain->mapping_lock);
>  
>  	domain_reserve_special_ranges(domain);
> diff --git a/drivers/pci/intel-iommu.h b/drivers/pci/intel-iommu.h
> index ee88dd2..af8560c 100644
> --- a/drivers/pci/intel-iommu.h
> +++ b/drivers/pci/intel-iommu.h
> @@ -27,6 +27,19 @@
>  #include <linux/io.h>
>  
>  /*
> + * We need a fixed PAGE_SIZE of 4K irrespective of
> + * arch PAGE_SIZE for IOMMU page tables.
> + */
> +#define PAGE_SHIFT_4K		(12)
> +#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
> +#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
> +#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
> +
> +#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
> +#define DMA_32BIT_PFN		IOVA_PFN(DMA_32BIT_MASK)
> +#define DMA_64BIT_PFN		IOVA_PFN(DMA_64BIT_MASK)
> +
> +/*
>   * Intel IOMMU register specification per version 1.0 public spec.
>   */
>  
> diff --git a/drivers/pci/iova.c b/drivers/pci/iova.c
> index a84571c..8de7ab6 100644
> --- a/drivers/pci/iova.c
> +++ b/drivers/pci/iova.c
> @@ -9,19 +9,19 @@
>  #include "iova.h"
>  
>  void
> -init_iova_domain(struct iova_domain *iovad)
> +init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit)
>  {
>  	spin_lock_init(&iovad->iova_alloc_lock);
>  	spin_lock_init(&iovad->iova_rbtree_lock);
>  	iovad->rbroot = RB_ROOT;
>  	iovad->cached32_node = NULL;
> -
> +	iovad->dma_32bit_pfn = pfn_32bit;
>  }
>  
>  static struct rb_node *
>  __get_cached_rbnode(struct iova_domain *iovad, unsigned long *limit_pfn)
>  {
> -	if ((*limit_pfn != DMA_32BIT_PFN) ||
> +	if ((*limit_pfn != iovad->dma_32bit_pfn) ||
>  		(iovad->cached32_node == NULL))
>  		return rb_last(&iovad->rbroot);
>  	else {
> @@ -37,7 +37,7 @@ static void
>  __cached_rbnode_insert_update(struct iova_domain *iovad,
>  	unsigned long limit_pfn, struct iova *new)
>  {
> -	if (limit_pfn != DMA_32BIT_PFN)
> +	if (limit_pfn != iovad->dma_32bit_pfn)
>  		return;
>  	iovad->cached32_node = &new->node;
>  }
> diff --git a/drivers/pci/iova.h b/drivers/pci/iova.h
> index ae3028d..d521b5b 100644
> --- a/drivers/pci/iova.h
> +++ b/drivers/pci/iova.h
> @@ -15,22 +15,9 @@
>  #include <linux/rbtree.h>
>  #include <linux/dma-mapping.h>
>  
> -/*
> - * We need a fixed PAGE_SIZE of 4K irrespective of
> - * arch PAGE_SIZE for IOMMU page tables.
> - */
> -#define PAGE_SHIFT_4K		(12)
> -#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
> -#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
> -#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
> -
>  /* IO virtual address start page frame number */
>  #define IOVA_START_PFN		(1)
>  
> -#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
> -#define DMA_32BIT_PFN	IOVA_PFN(DMA_32BIT_MASK)
> -#define DMA_64BIT_PFN	IOVA_PFN(DMA_64BIT_MASK)
> -
>  /* iova structure */
>  struct iova {
>  	struct rb_node	node;
> @@ -44,6 +31,7 @@ struct iova_domain {
>  	spinlock_t	iova_rbtree_lock; /* Lock to protect update of rbtree */
>  	struct rb_root	rbroot;		/* iova domain rbtree root */
>  	struct rb_node	*cached32_node; /* Save last alloced node */
> +	unsigned long	dma_32bit_pfn;
>  };
>  
>  struct iova *alloc_iova_mem(void);
> @@ -56,7 +44,7 @@ struct iova *alloc_iova(struct iova_domain *iovad, unsigned long size,
>  struct iova *reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
>  	unsigned long pfn_hi);
>  void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
> -void init_iova_domain(struct iova_domain *iovad);
> +void init_iova_domain(struct iova_domain *iovad, unsigned long pfn_32bit);
>  struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn);
>  void put_iova_domain(struct iova_domain *iovad);
>  
