Return-Path: <linux-kernel-owner+w=401wt.eu-S1753986AbYLSFL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbYLSFL5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYLSFLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:30 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42912 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 09/11] swiotlb: add swiotlb_map/unmap_page
Date: Thu, 18 Dec 2008 23:11:20 -0600
Message-Id: <1229663480-10757-10-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, change swiotlb_map/unmap_single to call the page
versions by converting the arguments into a page address and
offset.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 include/linux/swiotlb.h |   10 +++++++
 lib/swiotlb.c           |   63 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 53 insertions(+), 20 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index f4d1be3..ecb5eac 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -79,6 +79,16 @@ swiotlb_sync_single_range_for_device(struct device *hwdev, dma_addr_t dev_addr,
 				     unsigned long offset, size_t size,
 				     enum dma_data_direction dir);
 
+extern dma_addr_t
+swiotlb_map_page_attrs(struct device *dev, struct page *page,
+		       unsigned long offset, size_t size,
+		       enum dma_data_direction direction,
+		       struct dma_attrs *attrs);
+
+extern void
+swiotlb_unmap_page_attrs(struct device *hwdev, dma_addr_t dev_addr, size_t size,
+			 enum dma_data_direction dir, struct dma_attrs *attrs);
+
 extern int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index fc906d5..166aa78 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -606,19 +606,17 @@ swiotlb_full(struct device *dev, size_t size, enum dma_data_direction dir,
 	}
 }
 
-/*
- * Map a single buffer of the indicated size for DMA in streaming mode.  The
- * physical address to use is returned.
- *
- * Once the device is given the dma address, the device owns this memory until
- * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
- */
-dma_addr_t
-swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 enum dma_data_direction dir, struct dma_attrs *attrs)
+dma_addr_t swiotlb_map_page_attrs(struct device *hwdev, struct page *page,
+				  unsigned long offset, size_t size,
+				  enum dma_data_direction dir,
+				  struct dma_attrs *attrs)
 {
-	dma_addr_t dev_addr = virt_to_dma_addr(hwdev, ptr);
+	dma_addr_t dev_addr;
 	void *map;
+	phys_addr_t phys;
+
+	phys = page_to_phys(page) + offset;
+	dev_addr = phys_to_dma_addr(hwdev, phys);
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -633,7 +631,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(hwdev, virt_to_phys(ptr), size, dir);
+	map = map_single(hwdev, phys, size, dir);
 	if (!map) {
 		swiotlb_full(hwdev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
@@ -646,9 +644,40 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	 */
 	if (swiotlb_addr_needs_mapping(hwdev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
-
 	return dev_addr;
 }
+EXPORT_SYMBOL(swiotlb_map_page_attrs);
+
+void swiotlb_unmap_page_attrs(struct device *hwdev, dma_addr_t dev_addr,
+			      size_t size, enum dma_data_direction dir,
+			      struct dma_attrs *attrs)
+{
+	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr);
+
+	BUG_ON(dir == DMA_NONE);
+	if (is_swiotlb_buffer(dma_addr))
+		unmap_single(hwdev, dma_addr, size, dir);
+	else if (dir == DMA_FROM_DEVICE)
+		dma_mark_clean(dma_addr, size);
+
+}
+EXPORT_SYMBOL(swiotlb_unmap_page_attrs);
+
+/*
+ * Map a single buffer of the indicated size for DMA in streaming mode.  The
+ * physical address to use is returned.
+ *
+ * Once the device is given the dma address, the device owns this memory until
+ * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
+ */
+dma_addr_t
+swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
+			 enum dma_data_direction dir, struct dma_attrs *attrs)
+{
+	return swiotlb_map_page_attrs(hwdev, virt_to_page(ptr),
+				      (unsigned long)ptr % PAGE_SIZE,
+				      size, dir, attrs);
+}
 EXPORT_SYMBOL(swiotlb_map_single_attrs);
 
 dma_addr_t
@@ -671,13 +700,7 @@ swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 			   size_t size, enum dma_data_direction dir,
 			   struct dma_attrs *attrs)
 {
-	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr);
-
-	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
-		unmap_single(hwdev, dma_addr, size, dir);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+	return swiotlb_unmap_page_attrs(hwdev, dev_addr, size, dir, attrs);
 }
 EXPORT_SYMBOL(swiotlb_unmap_single_attrs);
 
-- 
1.5.6.5

