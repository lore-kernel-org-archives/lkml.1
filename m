Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYAGVqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYAGVqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 16:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbYAGVqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 16:46:22 -0500
Received: from gate.crashing.org ([63.228.1.57]:46944 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556AbYAGVqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 16:46:21 -0500
Subject: [PATCH][POWERPC] Workaround for iommu page alignment
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jan 2008 08:45:59 +1100
Message-Id: <1199742359.6734.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our iommu page size is currently always 4K. That means with our current
code, drivers may do a dma_map_sg() of a 64K page and obtain a dma_addr_t
that is only 4K aligned.

This works fine in most cases except some infiniband HW it seems, where
they tell the HW about the page size and it ignores the low bits of the
DMA address.

This works around it by making our IOMMU code enforce a PAGE_SIZE alignment
for mappings of objects that are page aligned in the first place and whose
size is larger or equal to a page.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Looks like it fell through the holiday cracks ... 

It could still go in 2.6.24 I suppose... If not, put it in 2.6.25 and
we'll backport to stable later.

Index: linux-work/arch/powerpc/kernel/iommu.c
===================================================================
--- linux-work.orig/arch/powerpc/kernel/iommu.c	2007-12-21 10:39:39.000000000 +1100
+++ linux-work/arch/powerpc/kernel/iommu.c	2007-12-21 10:46:18.000000000 +1100
@@ -278,6 +278,7 @@ int iommu_map_sg(struct iommu_table *tbl
 	unsigned long flags;
 	struct scatterlist *s, *outs, *segstart;
 	int outcount, incount, i;
+	unsigned int align;
 	unsigned long handle;
 
 	BUG_ON(direction == DMA_NONE);
@@ -309,7 +310,11 @@ int iommu_map_sg(struct iommu_table *tbl
 		/* Allocate iommu entries for that segment */
 		vaddr = (unsigned long) sg_virt(s);
 		npages = iommu_num_pages(vaddr, slen);
-		entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);
+		align = 0;
+		if (IOMMU_PAGE_SHIFT < PAGE_SHIFT && (vaddr & ~PAGE_MASK) == 0)
+			align = PAGE_SHIFT - IOMMU_PAGE_SHIFT;
+		entry = iommu_range_alloc(tbl, npages, &handle,
+					  mask >> IOMMU_PAGE_SHIFT, align);
 
 		DBG("  - vaddr: %lx, size: %lx\n", vaddr, slen);
 
@@ -572,7 +577,7 @@ dma_addr_t iommu_map_single(struct iommu
 {
 	dma_addr_t dma_handle = DMA_ERROR_CODE;
 	unsigned long uaddr;
-	unsigned int npages;
+	unsigned int npages, align;
 
 	BUG_ON(direction == DMA_NONE);
 
@@ -580,8 +585,13 @@ dma_addr_t iommu_map_single(struct iommu
 	npages = iommu_num_pages(uaddr, size);
 
 	if (tbl) {
+		align = 0;
+		if (IOMMU_PAGE_SHIFT < PAGE_SHIFT &&
+		    ((unsigned long)vaddr & ~PAGE_MASK) == 0)
+			align = PAGE_SHIFT - IOMMU_PAGE_SHIFT;
+
 		dma_handle = iommu_alloc(tbl, vaddr, npages, direction,
-					 mask >> IOMMU_PAGE_SHIFT, 0);
+					 mask >> IOMMU_PAGE_SHIFT, align);
 		if (dma_handle == DMA_ERROR_CODE) {
 			if (printk_ratelimit())  {
 				printk(KERN_INFO "iommu_alloc failed, "


