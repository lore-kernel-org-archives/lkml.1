Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbXFZGIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbXFZGIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbXFZGIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:08:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33231 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751922AbXFZGIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:08:06 -0400
Date: Mon, 25 Jun 2007 23:07:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 04/10] IOVA allocation and management routines
Message-Id: <20070625230747.2c2d4c11.akpm@linux-foundation.org>
In-Reply-To: <20070619213808.663054000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	<20070619213808.663054000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:37:05 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

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
> Changes from previous posting:
> 1) Fixed mostly coding style issues
> 

All the inlines in this code are pretty pointless: all those functions have
a single callsite so the compiler inlines them anyway.  If we later add
more callsites for these functions, they're too big to be inlined.

inline is usually wrong: don't do it!

> +
> +/**
> + * find_iova - find's an iova for a given pfn
> + * @iovad - iova domain in question.
> + * pfn - page frame number
> + * This function finds and returns an iova belonging to the
> + * given doamin which matches the given pfn.
> + */
> +struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn)
> +{
> +	unsigned long flags;
> +	struct rb_node *node;
> +
> +	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> +	node = iovad->rbroot.rb_node;
> +	while (node) {
> +		struct iova *iova = container_of(node, struct iova, node);
> +
> +		/* If pfn falls within iova's range, return iova */
> +		if ((pfn >= iova->pfn_lo) && (pfn <= iova->pfn_hi)) {
> +			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +			return iova;
> +		}
> +
> +		if (pfn < iova->pfn_lo)
> +			node = node->rb_left;
> +		else if (pfn > iova->pfn_lo)
> +			node = node->rb_right;
> +	}
> +
> +	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +	return NULL;
> +}

So we take the lock, look up an item, then drop the lock then return the
item we just found.  We took no refcount on it and we didn't do anything to
keep this object alive.

Is that a bug, or does the (afacit undocumented) lifecycle management of
these things take care of it in some manner?  If yes, please reply via an
add-a-comment patch.


> +/**
> + * __free_iova - frees the given iova
> + * @iovad: iova domain in question.
> + * @iova: iova in question.
> + * Frees the given iova belonging to the giving domain
> + */
> +void
> +__free_iova(struct iova_domain *iovad, struct iova *iova)
> +{
> +	unsigned long flags;
> +
> +	if (iova) {
> +		spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> +		__cached_rbnode_delete_update(iovad, iova);
> +		rb_erase(&iova->node, &iovad->rbroot);
> +		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +		free_iova_mem(iova);
> +	}
> +}

Can this really be called with NULL?  If so, under what circumstances? 
(This reader couldn't work it out from a brief look at the code, so perhaps
others will not be able to either.  Perhaps a comment is needed)

> +/**
> + * free_iova - finds and frees the iova for a given pfn
> + * @iovad: - iova domain in question.
> + * @pfn: - pfn that is allocated previously
> + * This functions finds an iova for a given pfn and then
> + * frees the iova from that domain.
> + */
> +void
> +free_iova(struct iova_domain *iovad, unsigned long pfn)
> +{
> +	struct iova *iova = find_iova(iovad, pfn);
> +	__free_iova(iovad, iova);
> +
> +}
> +
> +/**
> + * put_iova_domain - destroys the iova doamin
> + * @iovad: - iova domain in question.
> + * All the iova's in that domain are destroyed.
> + */
> +void put_iova_domain(struct iova_domain *iovad)
> +{
> +	struct rb_node *node;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> +	node = rb_first(&iovad->rbroot);
> +	while (node) {
> +		struct iova *iova = container_of(node, struct iova, node);
> +		rb_erase(node, &iovad->rbroot);
> +		free_iova_mem(iova);
> +		node = rb_first(&iovad->rbroot);
> +	}
> +	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> +}

Right, so I suspect what's happening here is that all iova's remain valid
until their entire domain is destroyed, yes?

What is the upper bound to the memory consumpotion here, and what provides
it?

Again, some code comments about these design issues are appropriate.

> +/*
> + * We need a fixed PAGE_SIZE of 4K irrespective of
> + * arch PAGE_SIZE for IOMMU page tables.
> + */
> +#define PAGE_SHIFT_4K		(12)
> +#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
> +#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
> +#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)

Am still wondering why we cannot use PAGE_SIZE, PAGE_SHIFT, etc here.

> +#define IOVA_START_ADDR		(0x1000)

What determined that address?  (Needs comment)

> +#define IOVA_START_PFN		(IOVA_START_ADDR >> PAGE_SHIFT_4K)
> +
> +#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)

So I'm looking at this and wondering "what type does addr have"?

If it's unsigned long then perhaps we have a problem on x86_32 PAE.  Maybe
we don't support x86_32 PAE, but still, I'd have thought that the
appropriate type here is dma_addr_t.

But alas, it was needlessly implemented as a macro, so the reader cannot
tell.

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
> +	struct rb_node	*cached32_node; /* Save last alloced node */
> +};
> +
> +struct iova *alloc_iova_mem(void);
> +void free_iova_mem(struct iova *iova);
> +void free_iova(struct iova_domain *iovad, unsigned long pfn);
> +void __free_iova(struct iova_domain *iovad, struct iova *iova);
> +struct iova * alloc_iova(struct iova_domain *iovad, unsigned long size,
> +	unsigned long limit_pfn);
> +struct iova * reserve_iova(struct iova_domain *iovad, unsigned long pfn_lo,
> +	unsigned long pfn_hi);
> +void copy_reserved_iova(struct iova_domain *from, struct iova_domain *to);
> +void init_iova_domain(struct iova_domain *iovad);
> +struct iova * find_iova(struct iova_domain *iovad, unsigned long pfn);
> +void put_iova_domain(struct iova_domain *iovad);
> +
> +#endif
> 

