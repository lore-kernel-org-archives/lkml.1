Return-Path: <linux-kernel-owner+w=401wt.eu-S1764916AbXGKNgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764916AbXGKNgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 09:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763251AbXGKNfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 09:35:23 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:17090 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762354AbXGKNfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 09:35:18 -0400
From: muli@il.ibm.com
To: ak@suse.de
Cc: linux-kernel@vger.kernel.org, muli@il.ibm.com, jdmason@kudzu.us
Subject: [PATCH 2/4] x86-64:  Calgary - tighten up the bitmap locking
Date: Wed, 11 Jul 2007 16:35:12 +0300
Message-Id: <11841609142004-git-send-email-muli@il.ibm.com>
X-Mailer: git-send-email 1.5.2
In-Reply-To: <11841609141802-git-send-email-muli@il.ibm.com>
References: <11841609143732-git-send-email-muli@il.ibm.com>
 <11841609141802-git-send-email-muli@il.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Muli Ben-Yehuda <muli@il.ibm.com>

Currently the IOMMU table's lock protects both the bitmap and access
to the hardware's TCE table. Access to the TCE table is synchronized
through the bitmap; therefore, only hold the lock while modifying the
bitmap. This gives a yummy 10-15% reduction in CPU utilization for
netperf on a large SMP machine.

Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
---
 arch/x86_64/kernel/pci-calgary.c |   40 ++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 23 deletions(-)

diff --git a/arch/x86_64/kernel/pci-calgary.c b/arch/x86_64/kernel/pci-calgary.c
index f589c2d..28ce2b3 100644
--- a/arch/x86_64/kernel/pci-calgary.c
+++ b/arch/x86_64/kernel/pci-calgary.c
@@ -235,6 +235,7 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 	unsigned long index;
 	unsigned long end;
 	unsigned long badbit;
+	unsigned long flags;
 
 	index = start_addr >> PAGE_SHIFT;
 
@@ -246,6 +247,8 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 	if (end > tbl->it_size) /* don't go off the table */
 		end = tbl->it_size;
 
+	spin_lock_irqsave(&tbl->it_lock, flags);
+
 	badbit = verify_bit_range(tbl->it_map, 0, index, end);
 	if (badbit != ~0UL) {
 		if (printk_ratelimit())
@@ -255,15 +258,20 @@ static void iommu_range_reserve(struct iommu_table *tbl,
 	}
 
 	set_bit_string(tbl->it_map, index, npages);
+
+	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static unsigned long iommu_range_alloc(struct iommu_table *tbl,
 	unsigned int npages)
 {
+	unsigned long flags;
 	unsigned long offset;
 
 	BUG_ON(npages == 0);
 
+	spin_lock_irqsave(&tbl->it_lock, flags);
+
 	offset = find_next_zero_string(tbl->it_map, tbl->it_hint,
 				       tbl->it_size, npages);
 	if (offset == ~0UL) {
@@ -272,6 +280,7 @@ static unsigned long iommu_range_alloc(struct iommu_table *tbl,
 					       tbl->it_size, npages);
 		if (offset == ~0UL) {
 			printk(KERN_WARNING "Calgary: IOMMU full.\n");
+			spin_unlock_irqrestore(&tbl->it_lock, flags);
 			if (panic_on_overflow)
 				panic("Calgary: fix the allocator.\n");
 			else
@@ -283,17 +292,17 @@ static unsigned long iommu_range_alloc(struct iommu_table *tbl,
 	tbl->it_hint = offset + npages;
 	BUG_ON(tbl->it_hint > tbl->it_size);
 
+	spin_unlock_irqrestore(&tbl->it_lock, flags);
+
 	return offset;
 }
 
 static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *vaddr,
 	unsigned int npages, int direction)
 {
-	unsigned long entry, flags;
+	unsigned long entry;
 	dma_addr_t ret = bad_dma_address;
 
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	entry = iommu_range_alloc(tbl, npages);
 
 	if (unlikely(entry == bad_dma_address))
@@ -306,12 +315,9 @@ static dma_addr_t iommu_alloc(struct iommu_table *tbl, void *vaddr,
 	tce_build(tbl, entry, npages, (unsigned long)vaddr & PAGE_MASK,
 		  direction);
 
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
-
 	return ret;
 
 error:
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 	printk(KERN_WARNING "Calgary: failed to allocate %u pages in "
 	       "iommu %p\n", npages, tbl);
 	return bad_dma_address;
@@ -323,6 +329,7 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned long entry;
 	unsigned long badbit;
 	unsigned long badend;
+	unsigned long flags;
 
 	/* were we called with bad_dma_address? */
 	badend = bad_dma_address + (EMERGENCY_PAGES * PAGE_SIZE);
@@ -339,6 +346,8 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 
 	tce_free(tbl, entry, npages);
 
+	spin_lock_irqsave(&tbl->it_lock, flags);
+
 	badbit = verify_bit_range(tbl->it_map, 1, entry, entry + npages);
 	if (badbit != ~0UL) {
 		if (printk_ratelimit())
@@ -348,18 +357,14 @@ static void __iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	}
 
 	__clear_bit_string(tbl->it_map, entry, npages);
+
+	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static void iommu_free(struct iommu_table *tbl, dma_addr_t dma_addr,
 	unsigned int npages)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	__iommu_free(tbl, dma_addr, npages);
-
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static inline struct iommu_table *find_iommu_table(struct device *dev)
@@ -404,17 +409,12 @@ static void __calgary_unmap_sg(struct iommu_table *tbl,
 void calgary_unmap_sg(struct device *dev, struct scatterlist *sglist,
 		      int nelems, int direction)
 {
-	unsigned long flags;
 	struct iommu_table *tbl = find_iommu_table(dev);
 
 	if (!translate_phb(to_pci_dev(dev)))
 		return;
 
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	__calgary_unmap_sg(tbl, sglist, nelems, direction);
-
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 }
 
 static int calgary_nontranslate_map_sg(struct device* dev,
@@ -435,7 +435,6 @@ int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	int nelems, int direction)
 {
 	struct iommu_table *tbl = find_iommu_table(dev);
-	unsigned long flags;
 	unsigned long vaddr;
 	unsigned int npages;
 	unsigned long entry;
@@ -444,8 +443,6 @@ int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 	if (!translate_phb(to_pci_dev(dev)))
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
-	spin_lock_irqsave(&tbl->it_lock, flags);
-
 	for (i = 0; i < nelems; i++ ) {
 		struct scatterlist *s = &sg[i];
 		BUG_ON(!s->page);
@@ -469,8 +466,6 @@ int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		s->dma_length = s->length;
 	}
 
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
-
 	return nelems;
 error:
 	__calgary_unmap_sg(tbl, sg, nelems, direction);
@@ -478,7 +473,6 @@ error:
 		sg[i].dma_address = bad_dma_address;
 		sg[i].dma_length = 0;
 	}
-	spin_unlock_irqrestore(&tbl->it_lock, flags);
 	return 0;
 }
 
-- 
1.5.2

