Return-Path: <linux-kernel-owner+w=401wt.eu-S1757235AbZAEPAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbZAEPAp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755860AbZAEO7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 09:59:48 -0500
Received: from mo10.iij4u.or.jp ([210.138.174.78]:58528 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbZAEO7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 09:59:46 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: tony.luck@intel.com, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] remove IA64 and X86 duplicated swiotlb code
Date: Mon,  5 Jan 2009 23:59:03 +0900
Message-Id: <1231167543-20259-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231167543-20259-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1231167543-20259-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231167543-20259-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1231167543-20259-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds swiotlb_map_page and swiotlb_unmap_page to lib/swiotlb.c and
remove IA64 and X86's swiotlb_map_page and swiotlb_unmap_page.

This also removes unnecessary swiotlb_map_single, swiotlb_map_single_attrs,
swiotlb_unmap_single and swiotlb_unmap_single_attrs.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/kernel/pci-swiotlb.c   |   16 -------------
 arch/x86/kernel/pci-swiotlb_64.c |   17 --------------
 include/linux/swiotlb.h          |   21 +++++-----------
 lib/swiotlb.c                    |   46 ++++++++++++++------------------------
 4 files changed, 24 insertions(+), 76 deletions(-)

diff --git a/arch/ia64/kernel/pci-swiotlb.c b/arch/ia64/kernel/pci-swiotlb.c
index 6bf8f66..e6b2ec9 100644
--- a/arch/ia64/kernel/pci-swiotlb.c
+++ b/arch/ia64/kernel/pci-swiotlb.c
@@ -16,22 +16,6 @@ EXPORT_SYMBOL(swiotlb);
 /* Set this to 1 if there is a HW IOMMU in the system */
 int iommu_detected __read_mostly;
 
-static dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
-				   unsigned long offset, size_t size,
-				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
-{
-	return swiotlb_map_single_attrs(dev, page_address(page) + offset, size,
-					dir, attrs);
-}
-
-static void swiotlb_unmap_page(struct device *dev, dma_addr_t dma_handle,
-			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
-{
-	swiotlb_unmap_single_attrs(dev, dma_handle, size, dir, attrs);
-}
-
 struct dma_map_ops swiotlb_dma_ops = {
 	.alloc_coherent = swiotlb_alloc_coherent,
 	.free_coherent = swiotlb_free_coherent,
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 3f0d992..5e32c4f 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -38,23 +38,6 @@ int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
 	return 0;
 }
 
-/* these will be moved to lib/swiotlb.c later on */
-
-static dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
-				   unsigned long offset, size_t size,
-				   enum dma_data_direction dir,
-				   struct dma_attrs *attrs)
-{
-	return swiotlb_map_single(dev, page_address(page) + offset, size, dir);
-}
-
-static void swiotlb_unmap_page(struct device *dev, dma_addr_t dma_handle,
-			       size_t size, enum dma_data_direction dir,
-			       struct dma_attrs *attrs)
-{
-	swiotlb_unmap_single(dev, dma_handle, size, dir);
-}
-
 static void *x86_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 					dma_addr_t *dma_handle, gfp_t flags)
 {
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 0567c3d..493dc17 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -41,20 +41,13 @@ extern void
 swiotlb_free_coherent(struct device *hwdev, size_t size,
 		      void *vaddr, dma_addr_t dma_handle);
 
-extern dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir);
-
-extern void
-swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
-		     size_t size, int dir);
-
-extern dma_addr_t
-swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 int dir, struct dma_attrs *attrs);
-
-extern void
-swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
-			   size_t size, int dir, struct dma_attrs *attrs);
+extern dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
+				   unsigned long offset, size_t size,
+				   enum dma_data_direction dir,
+				   struct dma_attrs *attrs);
+extern void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			       size_t size, enum dma_data_direction dir,
+			       struct dma_attrs *attrs);
 
 extern int
 swiotlb_map_sg(struct device *hwdev, struct scatterlist *sg, int nents,
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d047de9..ec7922b 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -636,11 +636,14 @@ swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
  * Once the device is given the dma address, the device owns this memory until
  * either swiotlb_unmap_single or swiotlb_dma_sync_single is performed.
  */
-dma_addr_t
-swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
-			 int dir, struct dma_attrs *attrs)
-{
-	dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, ptr);
+dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
+			    unsigned long offset, size_t size,
+			    enum dma_data_direction dir,
+			    struct dma_attrs *attrs)
+{
+	phys_addr_t phys = page_to_phys(page) + offset;
+	void *ptr = page_address(page) + offset;
+	dma_addr_t dev_addr = swiotlb_phys_to_bus(dev, phys);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -649,37 +652,30 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(hwdev, dev_addr, size) &&
+	if (!address_needs_mapping(dev, dev_addr, size) &&
 	    !range_needs_mapping(ptr, size))
 		return dev_addr;
 
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(hwdev, virt_to_phys(ptr), size, dir);
+	map = map_single(dev, phys, size, dir);
 	if (!map) {
-		swiotlb_full(hwdev, size, dir, 1);
+		swiotlb_full(dev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = swiotlb_virt_to_bus(hwdev, map);
+	dev_addr = swiotlb_virt_to_bus(dev, map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(hwdev, dev_addr, size))
+	if (address_needs_mapping(dev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
 }
-EXPORT_SYMBOL(swiotlb_map_single_attrs);
-
-dma_addr_t
-swiotlb_map_single(struct device *hwdev, void *ptr, size_t size, int dir)
-{
-	return swiotlb_map_single_attrs(hwdev, ptr, size, dir, NULL);
-}
-EXPORT_SYMBOL(swiotlb_map_single);
+EXPORT_SYMBOL_GPL(swiotlb_map_page);
 
 /*
  * Unmap a single streaming mode DMA translation.  The dma_addr and size must
@@ -689,9 +685,9 @@ EXPORT_SYMBOL(swiotlb_map_single);
  * After this call, reads by the cpu to the buffer are guaranteed to see
  * whatever the device wrote there.
  */
-void
-swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
-			   size_t size, int dir, struct dma_attrs *attrs)
+void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			size_t size, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
@@ -701,15 +697,7 @@ swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 	else if (dir == DMA_FROM_DEVICE)
 		dma_mark_clean(dma_addr, size);
 }
-EXPORT_SYMBOL(swiotlb_unmap_single_attrs);
-
-void
-swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr, size_t size,
-		     int dir)
-{
-	return swiotlb_unmap_single_attrs(hwdev, dev_addr, size, dir, NULL);
-}
-EXPORT_SYMBOL(swiotlb_unmap_single);
+EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
 
 /*
  * Make physical memory consistent for a single streaming mode DMA translation
-- 
1.6.0.6

