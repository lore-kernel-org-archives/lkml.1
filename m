Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbXFZQVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbXFZQVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 12:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754748AbXFZQVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 12:21:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:13304 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754573AbXFZQVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 12:21:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,464,1175497200"; 
   d="scan'208";a="100307081"
Date: Tue, 26 Jun 2007 09:16:31 -0700
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 04/10] IOVA allocation and management routines
Message-ID: <20070626161631.GB3374@linux-os.sc.intel.com>
Reply-To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com> <20070619213808.663054000@askeshav-devel.jf.intel.com> <20070625230747.2c2d4c11.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625230747.2c2d4c11.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 11:07:47PM -0700, Andrew Morton wrote:
> On Tue, 19 Jun 2007 14:37:05 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:
> 
> All the inlines in this code are pretty pointless: all those functions have
> a single callsite so the compiler inlines them anyway.  If we later add
> more callsites for these functions, they're too big to be inlined.
> 
> inline is usually wrong: don't do it!
Yup, I agree and will follow in future.

> > +
> > +/**
> > + * find_iova - find's an iova for a given pfn
> > + * @iovad - iova domain in question.
> > + * pfn - page frame number
> > + * This function finds and returns an iova belonging to the
> > + * given doamin which matches the given pfn.
> > + */
> > +struct iova *find_iova(struct iova_domain *iovad, unsigned long pfn)
> > +{
> > +	unsigned long flags;
> > +	struct rb_node *node;
> > +
> > +	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> > +	node = iovad->rbroot.rb_node;
> > +	while (node) {
> > +		struct iova *iova = container_of(node, struct iova, node);
> > +
> > +		/* If pfn falls within iova's range, return iova */
> > +		if ((pfn >= iova->pfn_lo) && (pfn <= iova->pfn_hi)) {
> > +			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> > +			return iova;
> > +		}
> > +
> > +		if (pfn < iova->pfn_lo)
> > +			node = node->rb_left;
> > +		else if (pfn > iova->pfn_lo)
> > +			node = node->rb_right;
> > +	}
> > +
> > +	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> > +	return NULL;
> > +}
> 
> So we take the lock, look up an item, then drop the lock then return the
> item we just found.  We took no refcount on it and we didn't do anything to
> keep this object alive.
> 
> Is that a bug, or does the (afacit undocumented) lifecycle management of
> these things take care of it in some manner?  If yes, please reply via an
> add-a-comment patch.

Nope, this is not a bug. Adding a comment patch which explains the same.

> 
> 
> > +/**
> > + * __free_iova - frees the given iova
> > + * @iovad: iova domain in question.
> > + * @iova: iova in question.
> > + * Frees the given iova belonging to the giving domain
> > + */
> > +void
> > +__free_iova(struct iova_domain *iovad, struct iova *iova)
> > +{
> > +	unsigned long flags;
> > +
> > +	if (iova) {
> > +		spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> > +		__cached_rbnode_delete_update(iovad, iova);
> > +		rb_erase(&iova->node, &iovad->rbroot);
> > +		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> > +		free_iova_mem(iova);
> > +	}
> > +}
> 

> Can this really be called with NULL?  If so, under what circumstances? 
> (This reader couldn't work it out from a brief look at the code, so perhaps
> others will not be able to either.  Perhaps a comment is needed)

It was getting called from only one place free_iova().
Below patch address your concern.

> 
> > +/**
> > + * free_iova - finds and frees the iova for a given pfn
> > + * @iovad: - iova domain in question.
> > + * @pfn: - pfn that is allocated previously
> > + * This functions finds an iova for a given pfn and then
> > + * frees the iova from that domain.
> > + */
> > +void
> > +free_iova(struct iova_domain *iovad, unsigned long pfn)
> > +{
> > +	struct iova *iova = find_iova(iovad, pfn);
> > +	__free_iova(iovad, iova);
> > +
> > +}
> > +
> > +/**
> > + * put_iova_domain - destroys the iova doamin
> > + * @iovad: - iova domain in question.
> > + * All the iova's in that domain are destroyed.
> > + */
> > +void put_iova_domain(struct iova_domain *iovad)
> > +{
> > +	struct rb_node *node;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
> > +	node = rb_first(&iovad->rbroot);
> > +	while (node) {
> > +		struct iova *iova = container_of(node, struct iova, node);
> > +		rb_erase(node, &iovad->rbroot);
> > +		free_iova_mem(iova);
> > +		node = rb_first(&iovad->rbroot);
> > +	}
> > +	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
> > +}
> 
> Right, so I suspect what's happening here is that all iova's remain valid
> until their entire domain is destroyed, yes?

Nope. IOVA are valid only for the duration of DMA MAP and DMA UNMAP calls.
In case of Intel-iommu driver, the iova's are valid only for the duration
of __intel_map_singl() and __intel_unmap_single() calls.

> 
> What is the upper bound to the memory consumpotion here, and what provides
> it?
As explained above, iova are freed and reused again during the DMA map calls.

> 
> Again, some code comments about these design issues are appropriate.
> 
> > +/*
> > + * We need a fixed PAGE_SIZE of 4K irrespective of
> > + * arch PAGE_SIZE for IOMMU page tables.
> > + */
> > +#define PAGE_SHIFT_4K		(12)
> > +#define PAGE_SIZE_4K		(1UL << PAGE_SHIFT_4K)
> > +#define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
> > +#define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
> 
> Am still wondering why we cannot use PAGE_SIZE, PAGE_SHIFT, etc here.
VT-d hardware(a.k.a Intel IOMMU hardware) page table size is always
4K irrespective of the OS PAGE_SIZE. We want to use the same code for 
IA64 too where the OS PAGE_SIZE may not be 4K size and hence
had to define here for IOMMU.

> 
> > +#define IOVA_START_ADDR		(0x1000)
> 
> What determined that address?  (Needs comment)
Fixed. Please see bleow patch.

> 
> > +#define IOVA_START_PFN		(IOVA_START_ADDR >> PAGE_SHIFT_4K)
> > +
> > +#define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
> 
> So I'm looking at this and wondering "what type does addr have"?
> 
> If it's unsigned long then perhaps we have a problem on x86_32 PAE.  Maybe
> we don't support x86_32 PAE, but still, I'd have thought that the
> appropriate type here is dma_addr_t.
Yup that is correct. We don;t support x86_32.
> 
> But alas, it was needlessly implemented as a macro, so the reader cannot
> tell.
I am in the process of making the same code base to work for
IA64 architecure too and in this process I will do more cleanup.

Thanks.

Please apply the below patch as a fix the existing patch.


signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

---
 drivers/pci/iova.c |   22 ++++++++++++++--------
 drivers/pci/iova.h |    4 ++--
 2 files changed, 16 insertions(+), 10 deletions(-)

Index: linux-2.6.22-rc4-mm2/drivers/pci/iova.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/iova.c	2007-06-26 07:50:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/iova.c	2007-06-26 08:25:23.000000000 -0700
@@ -166,6 +166,7 @@
 	unsigned long flags;
 	struct rb_node *node;
 
+	/* Take the lock so that no other thread is manipulating the rbtree */
 	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
 	node = iovad->rbroot.rb_node;
 	while (node) {
@@ -174,6 +175,12 @@
 		/* If pfn falls within iova's range, return iova */
 		if ((pfn >= iova->pfn_lo) && (pfn <= iova->pfn_hi)) {
 			spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+			/* We are not holding the lock while this iova
+			 * is referenced by the caller as the same thread
+			 * which called this function also calls __free_iova()
+			 * and it is by desing that only one thread can possibly
+			 * reference a particular iova and hence no conflict.
+			 */
 			return iova;
 		}
 
@@ -198,13 +205,11 @@
 {
 	unsigned long flags;
 
-	if (iova) {
-		spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
-		__cached_rbnode_delete_update(iovad, iova);
-		rb_erase(&iova->node, &iovad->rbroot);
-		spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
-		free_iova_mem(iova);
-	}
+	spin_lock_irqsave(&iovad->iova_rbtree_lock, flags);
+	__cached_rbnode_delete_update(iovad, iova);
+	rb_erase(&iova->node, &iovad->rbroot);
+	spin_unlock_irqrestore(&iovad->iova_rbtree_lock, flags);
+	free_iova_mem(iova);
 }
 
 /**
@@ -218,7 +223,8 @@
 free_iova(struct iova_domain *iovad, unsigned long pfn)
 {
 	struct iova *iova = find_iova(iovad, pfn);
-	__free_iova(iovad, iova);
+	if (iova)
+		__free_iova(iovad, iova);
 
 }
 
Index: linux-2.6.22-rc4-mm2/drivers/pci/iova.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/pci/iova.h	2007-06-26 07:50:34.000000000 -0700
+++ linux-2.6.22-rc4-mm2/drivers/pci/iova.h	2007-06-26 08:28:05.000000000 -0700
@@ -24,8 +24,8 @@
 #define PAGE_MASK_4K		(((u64)-1) << PAGE_SHIFT_4K)
 #define PAGE_ALIGN_4K(addr)	(((addr) + PAGE_SIZE_4K - 1) & PAGE_MASK_4K)
 
-#define IOVA_START_ADDR		(0x1000)
-#define IOVA_START_PFN		(IOVA_START_ADDR >> PAGE_SHIFT_4K)
+/* IO virtual address start page frame number */
+#define IOVA_START_PFN		(1)
 
 #define IOVA_PFN(addr)		((addr) >> PAGE_SHIFT_4K)
 #define DMA_32BIT_PFN	IOVA_PFN(DMA_32BIT_MASK)
> 
