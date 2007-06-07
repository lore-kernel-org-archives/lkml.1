Return-Path: <linux-kernel-owner+w=401wt.eu-S966919AbXFGXeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966919AbXFGXeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 19:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932404AbXFGXeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 19:34:37 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763659AbXFGXeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 19:34:36 -0400
Date: Thu, 7 Jun 2007 16:34:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: anil.s.keshavamurthy@intel.com
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       asit.k.mallick@intel.com, suresh.b.siddha@intel.com,
       arjan@linux.intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       davem@davemloft.net
Subject: Re: [Intel-IOMMU 05/10] IOVA allocation and management routines
Message-Id: <20070607163417.84f96405.akpm@linux-foundation.org>
In-Reply-To: <20070606190042.741931000@askeshav-devel.jf.intel.com>
References: <20070606185658.138237000@askeshav-devel.jf.intel.com>
	<20070606190042.741931000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Jun 2007 11:57:03 -0700
anil.s.keshavamurthy@intel.com wrote:

> 	This code implements a generic IOVA allocation and 
> management. As per Dave's suggestion we are now allocating
> IO virtual address from Higher DMA limit address rather
> than lower end address and this eliminated the need to preserve
> the IO virtual address for multiple devices sharing the same
> domain virtual address.
> 
> Also this code uses red black trees to store the allocated and
> reserved iova nodes. This showed a good performance improvements
> over previous linear linked list.
> 
> ...
>
> +
> +/**
> + * alloc_iova - allocates an iova
> + * @iovad - iova domain in question
> + * @size - size of page frames to allocate
> + * @limit_pfn - max limit address
> + * This function allocates an iova in the range limit_pfn to IOVA_START_PFN
> + * looking from limit_pfn instead from IOVA_START_PFN.
> + */
> +
> +struct iova *
> +alloc_iova(struct iova_domain *iovad, unsigned long size, unsigned long limit_pfn)

Generally we omit the blank line between the end-of-comment and the
function definition.

> +{
> +	unsigned long flags,flags1;
> +	struct iova *new_iova;
> +	int ret;
> +
> +	new_iova = alloc_iova_mem();
> +	if (!new_iova)
> +		return NULL;
> +
> +	spin_lock_irqsave(&iovad->iova_alloc_lock, flags1);
> +	ret = __alloc_iova_range(iovad, size, limit_pfn, new_iova);
> +
> +	if (ret) {
> +		spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags1);
> +		free_iova_mem(new_iova);
> +		return NULL;
> +	}
> +
> +	/* Insert the new_iova into domain rbtree by holding writer lock */
> +	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> +	iova_insert_rbtree(&iovad->rbroot, new_iova);
> +	__cached_rbnode_insert_update(iovad, limit_pfn, new_iova);
> +	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +
> +	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags1);

spin_unlock_irqrestore() within spin_unlock_irqrestore() is fairly
pointless.  You can just use spin_lock()/spin_unlock() for the innermost
pair.

> +	return new_iova;
> +}
>
> ...
>
> +__is_range_overlap(struct rb_node *node, unsigned long pfn_lo, unsigned long pfn_hi)
> +{
> +	struct iova * iova = container_of(node, struct iova, node);

run checkpatch.pl, please.

> +	if ((pfn_lo <= iova->pfn_hi) && (pfn_hi >= iova->pfn_lo))
> +		return 1;
> +	return 0;
> +}
> +
>
> ...
>
> +struct iova *
> +reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo, unsigned long pfn_hi)
> +{
> +	struct rb_node *node;
> +	unsigned long flags, flags1;
> +	struct iova *iova;
> +	unsigned int overlap = 0;
> +
> +	spin_lock_irqsave(&iovad->iova_alloc_lock, flags);
> +	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags1);
> +	for (node = rb_first(&iovad->rbroot); node; node = rb_next(node)) {
> +		if (__is_range_overlap(node, pfn_lo, pfn_hi)) {
> +			iova = container_of(node, struct iova, node);
> +			__adjust_overlap_range(iova, &pfn_lo, &pfn_hi);
> +			if ((pfn_lo >= iova->pfn_lo) &&
> +				(pfn_hi <= iova->pfn_hi))
> +				goto finish;
> +			overlap = 1;
> +
> +		} else if (overlap)
> +				break;
> +	}
> +
> +	/* We are here either becasue this is the first reserver node
> +	 * or need to insert remaining non overlap addr range
> +	 */
> +	iova = __insert_new_range(iovad, pfn_lo, pfn_hi);
> +finish:
> +
> +	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags1);
> +	spin_unlock_irqrestore(&iovad->iova_alloc_lock, flags);

ditto

> +	return iova;
> +}
> +
> +/**
> + * copy_reserved_iova - copies the reserved between domains
> + * @from: - source doamin from where to copy
> + * @to: - destination domin where to copy
> + * This function copies reserved iova's from one doamin to
> + * other.
> + */
> +void
> +copy_reserved_iova(struct iova_domain *from, struct iova_domain *to)
> +{
> +	unsigned long flags, flags1;
> +	struct rb_node *node;
> +	spin_lock_irqsave(&from->iova_alloc_lock, flags);
> +	spin_lock_irqsave(&from->iova_rbtree_lock, flags1);

Add a blank line betwee the end-of-locals and the start-of-statements

> +	for (node = rb_first(&from->rbroot); node; node = rb_next(node)) {
> +		struct iova *iova = container_of(node, struct iova, node);
> +		struct iova *new_iova;
> +		new_iova = reserve_iova(to, iova->pfn_lo, iova->pfn_hi);
> +		if (!new_iova)
> +			printk(KERN_ERR "Reserve iova range %lx@%lx failed\n",
> +				iova->pfn_lo, iova->pfn_lo);
> +	}
> +	spin_unlock_irqrestore(&from->iova_rbtree_lock, flags1);
> +	spin_unlock_irqrestore(&from->iova_alloc_lock, flags);

ditto

> +}
> Index: linux-2.6.22-rc3/drivers/pci/iova.h
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6.22-rc3/drivers/pci/iova.h	2007-06-04 12:40:20.000000000 -0700
> @@ -0,0 +1,57 @@
> +/*
> + * Copyright (c) 2006, Intel Corporation.
> + *
> + * This file is released under the GPLv2.
> + *
> + * Copyright (C) 2006 Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> + *
> + */
> +
> +#ifndef _IOVA_H_
> +#define _IOVA_H_
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/rbtree.h>
> +#include <linux/dma-mapping.h>
> +
> +
> +#define PAGE_SHIFT_4K		(12)
> +#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
> +#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
> +#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)

hm.  We can't use the architecture's PAGE_SHIFT and friends here?

> +#define IOVA_START_ADDR		(0x1000)
> +#define IOVA_START_PFN		(IOVA_START_ADDR >> PAGE_SHIFT_4K)
> +
> +#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
> +#define DMA_32BIT_PFN	IOVA_PFN(DMA_32BIT_MASK)
> +#define DMA_64BIT_PFN	IOVA_PFN(DMA_64BIT_MASK)
> +
> +/* iova structure */
> +struct iova {
> +	struct rb_node	node;
> +	unsigned long	pfn_hi; /* IOMMU dish out addr hi */
> +	unsigned long	pfn_lo; /* IOMMU dish out addr lo */
> +};
> +
> +/* holds all the iova translations for a domain */
> +struct iova_domain {
> +	spinlock_t	iova_alloc_lock;/* Lock to protect iova  allocation */
> +	spinlock_t	iova_rbtree_lock; /* Lock to protect update of rbtree */
> +	struct rb_root	rbroot;		/* iova domain rbtree root */
> +	struct rb_node	*cached32_node; /* Save last alloced node to optimize alloc */
> +};
> +
> +struct iova *alloc_iova_mem(void);
> +void free_iova_mem(struct iova *iova);
> +void free_iova(struct iova_domain *iovad, unsigned long pfn);
> +void __free_iova(struct iova_domain *iovad, struct iova *iova);
> +struct iova * alloc_iova(struct iova_domain *iovad, unsigned long size, unsigned long limit_pfn);
> +struct iova * reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo, unsigned long pfn_hi);
> +void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
> +void init_iova_domain(struct iova_domain *iovad);
> +struct iova * find_iova(struct iova_domain *iovad, unsigned long pfn);
> +void put_iova_domain(struct iova_domain *iovad);
> +
> +#endif
> 
> -- 
