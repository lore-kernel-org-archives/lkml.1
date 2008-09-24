Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYIXLww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYIXLww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbYIXLwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:52:18 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47978 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528AbYIXLwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:52:16 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, joerg.roedel@amd.com,
       fujita.tomonori@lab.ntt.co.jp
Subject: [PATCH 2/3] revert "x86: make GART to respect device's dma_mask about virtual mappings"
Date: Wed, 24 Sep 2008 20:48:36 +0900
Message-Id: <1222256917-14321-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1222256917-14321-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1222256917-14321-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1222256917-14321-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts:

commit bee44f294efd8417f5e68553778a6cc957af1547
Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date:   Fri Sep 12 19:42:35 2008 +0900

    x86: make GART to respect device's dma_mask about virtual mappings

I wrote the above commit to fix a GART alloc_coherent regression, that
can't handle a device having dma_masks > 24bit < 32bits, introduced by
the alloc_coherent rewrite:

http://lkml.org/lkml/2008/8/12/200

After the alloc_coherent rewrite, GART alloc_coherent tried to
allocate pages with GFP_DMA32. If GART got an address that a device
can't access to, GART mapped the address to a virtual I/O address. But
GART mapping mechanism didn't take account of dma mask, so GART could
use a virtual I/O address that the device can't access to again.

The above commit modified GART mapping mechanism to take care of dma
mask. But Andi pointed out, "The GART is somewhere in the 4GB range so
you cannot use it to map anything < 4GB. Also GART is pretty small."

http://lkml.org/lkml/2008/9/12/43

That means it's possible that GART doesn't have virtual I/O address
space that a device can access to. The above commit (to modify GART
mapping mechanism to take care of dma mask) can't fix the regression
reliably so let's avoid making GART more complicated.

We need a solution that always works for dma_masks > 24bit <
32bits. That's how GART worked before the alloc_coherent rewrite.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/x86/kernel/pci-gart_64.c |   39 +++++++++++----------------------------
 1 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 9e390f1..7e08e46 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -83,34 +83,23 @@ static unsigned long next_bit;  /* protected by iommu_bitmap_lock */
 static int need_flush;		/* global flush state. set for each gart wrap */
 
 static unsigned long alloc_iommu(struct device *dev, int size,
-				 unsigned long align_mask, u64 dma_mask)
+				 unsigned long align_mask)
 {
 	unsigned long offset, flags;
 	unsigned long boundary_size;
 	unsigned long base_index;
-	unsigned long limit;
 
 	base_index = ALIGN(iommu_bus_base & dma_get_seg_boundary(dev),
 			   PAGE_SIZE) >> PAGE_SHIFT;
 	boundary_size = ALIGN((unsigned long long)dma_get_seg_boundary(dev) + 1,
 			      PAGE_SIZE) >> PAGE_SHIFT;
 
-	limit = iommu_device_max_index(iommu_pages,
-				       DIV_ROUND_UP(iommu_bus_base, PAGE_SIZE),
-				       dma_mask >> PAGE_SHIFT);
-
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
-
-	if (limit <= next_bit) {
-		need_flush = 1;
-		next_bit = 0;
-	}
-
-	offset = iommu_area_alloc(iommu_gart_bitmap, limit, next_bit,
+	offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, next_bit,
 				  size, base_index, boundary_size, align_mask);
-	if (offset == -1 && next_bit) {
+	if (offset == -1) {
 		need_flush = 1;
-		offset = iommu_area_alloc(iommu_gart_bitmap, limit, 0,
+		offset = iommu_area_alloc(iommu_gart_bitmap, iommu_pages, 0,
 					  size, base_index, boundary_size,
 					  align_mask);
 	}
@@ -239,14 +228,12 @@ nonforced_iommu(struct device *dev, unsigned long addr, size_t size)
  * Caller needs to check if the iommu is needed and flush.
  */
 static dma_addr_t dma_map_area(struct device *dev, dma_addr_t phys_mem,
-			       size_t size, int dir, unsigned long align_mask,
-			       u64 dma_mask)
+				size_t size, int dir, unsigned long align_mask)
 {
 	unsigned long npages = iommu_num_pages(phys_mem, size);
-	unsigned long iommu_page;
+	unsigned long iommu_page = alloc_iommu(dev, npages, align_mask);
 	int i;
 
-	iommu_page = alloc_iommu(dev, npages, align_mask, dma_mask);
 	if (iommu_page == -1) {
 		if (!nonforced_iommu(dev, phys_mem, size))
 			return phys_mem;
@@ -276,7 +263,7 @@ gart_map_single(struct device *dev, phys_addr_t paddr, size_t size, int dir)
 	if (!need_iommu(dev, paddr, size))
 		return paddr;
 
-	bus = dma_map_area(dev, paddr, size, dir, 0, dma_get_mask(dev));
+	bus = dma_map_area(dev, paddr, size, dir, 0);
 	flush_gart();
 
 	return bus;
@@ -327,7 +314,6 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 {
 	struct scatterlist *s;
 	int i;
-	u64 dma_mask = dma_get_mask(dev);
 
 #ifdef CONFIG_IOMMU_DEBUG
 	printk(KERN_DEBUG "dma_map_sg overflow\n");
@@ -337,8 +323,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 		unsigned long addr = sg_phys(s);
 
 		if (nonforced_iommu(dev, addr, s->length)) {
-			addr = dma_map_area(dev, addr, s->length, dir, 0,
-					    dma_mask);
+			addr = dma_map_area(dev, addr, s->length, dir, 0);
 			if (addr == bad_dma_address) {
 				if (i > 0)
 					gart_unmap_sg(dev, sg, i, dir);
@@ -360,16 +345,14 @@ static int __dma_map_cont(struct device *dev, struct scatterlist *start,
 			  int nelems, struct scatterlist *sout,
 			  unsigned long pages)
 {
-	unsigned long iommu_start;
-	unsigned long iommu_page;
+	unsigned long iommu_start = alloc_iommu(dev, pages, 0);
+	unsigned long iommu_page = iommu_start;
 	struct scatterlist *s;
 	int i;
 
-	iommu_start = alloc_iommu(dev, pages, 0, dma_get_mask(dev));
 	if (iommu_start == -1)
 		return -1;
 
-	iommu_page = iommu_start;
 	for_each_sg(start, s, nelems, i) {
 		unsigned long pages, addr;
 		unsigned long phys_addr = s->dma_address;
@@ -522,7 +505,7 @@ gart_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_addr,
 	align_mask = (1UL << get_order(size)) - 1;
 
 	*dma_addr = dma_map_area(dev, paddr, size, DMA_BIDIRECTIONAL,
-				 align_mask, dma_mask);
+				 align_mask);
 	flush_gart();
 
 	if (*dma_addr != bad_dma_address)
-- 
1.5.4.2

