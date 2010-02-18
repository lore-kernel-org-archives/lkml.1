Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670Ab0BRQoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 11:44:39 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:37749 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758659Ab0BRQod (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 18 Feb 2010 11:44:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       chrisw@sous-sol.org, iommu@lists.linux-foundation.org,
       dwmw2@infradead.org, alex.williamson@hp.com
Cc: jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 05/10] swiotlb: Make internal bookkeeping functions have 'do_' prefix.
Date: Thu, 18 Feb 2010 11:27:01 -0500
Message-Id: <1266510426-6815-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1266510426-6815-5-git-send-email-konrad.wilk@oracle.com>
References: <1266510426-6815-1-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-2-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-3-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-4-git-send-email-konrad.wilk@oracle.com>
 <1266510426-6815-5-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B7D6E35.01C8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions that operate on io_tlb_list/io_tlb_start/io_tlb_orig_addr
have the prefix 'do_' now.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 0eb64d7..9085eab 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -60,8 +60,8 @@ enum dma_sync_target {
 int swiotlb_force;
 
 /*
- * Used to do a quick range check in unmap_single and
- * sync_single_*, to see if the memory was in fact allocated by this
+ * Used to do a quick range check in do_unmap_single and
+ * do_sync_single_*, to see if the memory was in fact allocated by this
  * API.
  */
 static char *io_tlb_start, *io_tlb_end;
@@ -394,7 +394,7 @@ static void swiotlb_bounce(phys_addr_t phys, char *dma_addr, size_t size,
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
+do_map_single(struct device *hwdev, phys_addr_t phys, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -540,7 +540,7 @@ do_unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 }
 
 static void
-sync_single(struct device *hwdev, char *dma_addr, size_t size,
+do_sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
@@ -589,10 +589,10 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	if (!ret) {
 		/*
 		 * We are either out of memory or the device can't DMA
-		 * to GFP_DMA memory; fall back on map_single(), which
+		 * to GFP_DMA memory; fall back on do_map_single(), which
 		 * will grab memory from the lowest available address range.
 		 */
-		ret = map_single(hwdev, 0, size, DMA_FROM_DEVICE);
+		ret = do_map_single(hwdev, 0, size, DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
@@ -626,7 +626,7 @@ swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 	if (!is_swiotlb_buffer(paddr))
 		free_pages((unsigned long)vaddr, get_order(size));
 	else
-		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
+		/* DMA_TO_DEVICE to avoid memcpy in do_unmap_single */
 		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
 }
 EXPORT_SYMBOL(swiotlb_free_coherent);
@@ -682,7 +682,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(dev, phys, size, dir);
+	map = do_map_single(dev, phys, size, dir);
 	if (!map) {
 		swiotlb_full(dev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
@@ -759,7 +759,7 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	BUG_ON(dir == DMA_NONE);
 
 	if (is_swiotlb_buffer(paddr)) {
-		sync_single(hwdev, phys_to_virt(paddr), size, dir, target);
+		do_sync_single(hwdev, phys_to_virt(paddr), size, dir, target);
 		return;
 	}
 
@@ -847,7 +847,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 		if (swiotlb_force ||
 		    !dma_capable(hwdev, dev_addr, sg->length)) {
-			void *map = map_single(hwdev, sg_phys(sg),
+			void *map = do_map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
-- 
1.6.2.5

