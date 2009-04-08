Return-Path: <linux-kernel-owner+w=401wt.eu-S932961AbZDHOM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961AbZDHOM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933372AbZDHOKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:41 -0400
Received: from gate.crashing.org ([63.228.1.57]:59961 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765997AbZDHOKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:38 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: beckyb@kernel.crashing.org
Subject: [PATCH 5/7] swiotlb: Rename unmap_single to do_unmap_single
Date: Wed,  8 Apr 2009 09:09:19 -0500
Message-Id: <1239199761-22886-6-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

Previously, swiotlb_unmap_page and swiotlb_unmap_sg were
duplicating very similar code.  Refactor that code into a
new unmap_single and unmap_single use do_unmap_single.

Note that the swiotlb_unmap_sg code was previously doing
a complicated comparison to determine if an addresses needed
to be unmapped where a simple is_swiotlb_buffer() call
would have sufficed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 lib/swiotlb.c |   42 +++++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d81afab..2bde54a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -482,7 +482,7 @@ found:
  * dma_addr is the kernel virtual address of the bounce buffer to unmap.
  */
 static void
-unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
+do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 {
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
@@ -591,7 +591,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		       (unsigned long long)dev_addr);
 
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
+		do_unmap_single(hwdev, ret, size, DMA_TO_DEVICE);
 		return NULL;
 	}
 	*dma_handle = dev_addr;
@@ -608,7 +608,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 		free_pages((unsigned long) vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
-		unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
+		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
 
@@ -688,17 +688,29 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
  * After this call, reads by the cpu to the buffer are guaranteed to see
  * whatever the device wrote there.
  */
-void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
-			size_t size, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+			 size_t size, int dir)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
-		unmap_single(hwdev, dma_addr, size, dir);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+
+	if (is_swiotlb_buffer(dma_addr)) {
+		do_unmap_single(hwdev, dma_addr, size, dir);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(dma_addr, size);
+}
+
+void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			size_t size, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
+{
+	unmap_single(hwdev, dev_addr, size, dir);
 }
 EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
 
@@ -850,13 +862,9 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	BUG_ON(dir == DMA_NONE);
 
-	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
-				     sg->dma_length, dir);
-		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
-	}
+	for_each_sg(sgl, sg, nelems, i)
+		unmap_single(hwdev, sg->dma_address, sg->dma_length, dir);
+
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
-- 
1.6.0.6

