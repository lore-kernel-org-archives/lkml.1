Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYLSFMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYLSFMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:12:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYLSFLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:31 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42908 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 05/11] swiotlb: Create virt to/from dma_addr and phys_to_dma_addr funcs
Date: Thu, 18 Dec 2008 23:11:16 -0600
Message-Id: <1229663480-10757-6-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use these instead of virt to/from bus macros - those have
been deprecated on some architectures.  Set up a weak definition
that defaults to the old behavior of calling virt_to_bus/bus_to_virt.
Add hwdev pointer as an argument - some architectures support
a per-device offset that is needed to get the bus address, and need
the hwdev pointer to get to that information.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   51 ++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index ef09b4c..ed4f44a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -33,10 +33,27 @@
 #include <linux/bootmem.h>
 #include <linux/iommu-helper.h>
 
+
+inline dma_addr_t __weak
+virt_to_dma_addr(struct device *hwdev, void *addr)
+{
+	return virt_to_bus(addr);
+}
+inline void *__weak
+dma_addr_to_virt(struct device *hwdev, dma_addr_t addr)
+{
+	return bus_to_virt(addr);
+}
+inline dma_addr_t __weak
+phys_to_dma_addr(struct device *hwdev, phys_addr_t addr)
+{
+	return (dma_addr_t)addr;
+}
+
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_BUS_ADDRESS(hwdev, sg)	virt_to_bus(sg_virt(sg))
+#define SG_ENT_BUS_ADDRESS(hwdev, sg) phys_to_dma_addr(hwdev, sg_phys(sg))
 
 /*
  * Maximum allowable number of contiguous slabs to map,
@@ -302,7 +319,7 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
+	start_dma_addr = virt_to_dma_addr(hwdev, io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	max_slots = mask + 1
@@ -475,7 +492,9 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && !is_buffer_dma_capable(dma_mask, virt_to_bus(ret), size)) {
+	if (ret && !is_buffer_dma_capable(dma_mask,
+					  virt_to_dma_addr(hwdev, ret),
+					  size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -496,7 +515,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	}
 
 	memset(ret, 0, size);
-	dev_addr = virt_to_bus(ret);
+	dev_addr = virt_to_dma_addr(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
 	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
@@ -556,7 +575,7 @@ dma_addr_t
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 			 int dir, struct dma_attrs *attrs)
 {
-	dma_addr_t dev_addr = virt_to_bus(ptr);
+	dma_addr_t dev_addr = virt_to_dma_addr(hwdev, ptr);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -578,7 +597,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = virt_to_bus(map);
+	dev_addr = virt_to_dma_addr(hwdev, map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -608,7 +627,7 @@ void
 swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 			   size_t size, int dir, struct dma_attrs *attrs)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -638,7 +657,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -669,7 +688,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr) + offset;
+	char *dma_addr = dma_addr_to_virt(hwdev, dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -725,7 +744,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		addr = sg_virt(sg);
-		dev_addr = virt_to_bus(addr);
+		dev_addr = virt_to_dma_addr(hwdev, addr);
 		if (swiotlb_force ||
 		    swiotlb_addr_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
@@ -738,7 +757,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-			sg->dma_address = virt_to_bus(map);
+			sg->dma_address = virt_to_dma_addr(hwdev, map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
@@ -769,7 +788,8 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
-			unmap_single(hwdev, bus_to_virt(sg->dma_address),
+			unmap_single(hwdev,
+				     dma_addr_to_virt(hwdev, sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(sg_virt(sg), sg->dma_length);
@@ -802,7 +822,8 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_BUS_ADDRESS(hwdev, sg))
-			sync_single(hwdev, bus_to_virt(sg->dma_address),
+			sync_single(hwdev,
+				    dma_addr_to_virt(hwdev, sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(sg_virt(sg), sg->dma_length);
@@ -826,7 +847,7 @@ swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == virt_to_bus(io_tlb_overflow_buffer));
+	return dma_addr == virt_to_dma_addr(hwdev, io_tlb_overflow_buffer);
 }
 
 /*
@@ -838,7 +859,7 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return virt_to_bus(io_tlb_end - 1) <= mask;
+	return virt_to_dma_addr(hwdev, io_tlb_end - 1) <= mask;
 }
 
 EXPORT_SYMBOL(swiotlb_map_single);
-- 
1.5.6.5

