Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYKMTgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYKMTgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752994AbYKMTeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:08 -0500
Received: from gw.goop.org ([64.81.55.164]:34377 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYKMTeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:03 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 05 of 38] swiotlb: allow architectures to override
	virt<->bus<->virt conversions
X-Mercurial-Node: 472ba94d2e2313c8bda52af6d15c5eed3da6c7ce
Message-Id: <472ba94d2e2313c8bda5.1226603403@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:03 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Architectures may need to override these conversions. Implement a
__weak hook point containing the default implementation.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/swiotlb.h |    3 +++
 lib/swiotlb.c           |   42 ++++++++++++++++++++++++++----------------
 2 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -27,6 +27,9 @@
 extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
 extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
+extern unsigned long __weak swiotlb_virt_to_bus(volatile void *address);
+extern void * __weak swiotlb_bus_to_virt(unsigned long address);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -125,6 +125,16 @@
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
+unsigned long __weak swiotlb_virt_to_bus(volatile void *address)
+{
+	return virt_to_bus(address);
+}
+
+void * __weak swiotlb_bus_to_virt(unsigned long address)
+{
+	return bus_to_virt(address);
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -168,7 +178,7 @@
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 
 	printk(KERN_INFO "Placing software IO TLB between 0x%lx - 0x%lx\n",
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	       swiotlb_virt_to_bus(io_tlb_start), swiotlb_virt_to_bus(io_tlb_end));
 }
 
 void __init
@@ -250,7 +260,7 @@
 
 	printk(KERN_INFO "Placing %luMB software IO TLB between 0x%lx - "
 	       "0x%lx\n", bytes >> 20,
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	       swiotlb_virt_to_bus(io_tlb_start), swiotlb_virt_to_bus(io_tlb_end));
 
 	return 0;
 
@@ -298,7 +308,7 @@
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_bus(io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	max_slots = mask + 1
@@ -467,7 +477,7 @@
 	int order = get_order(size);
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret), size)) {
+	if (ret && address_needs_mapping(hwdev, swiotlb_virt_to_bus(ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -488,7 +498,7 @@
 	}
 
 	memset(ret, 0, size);
-	dev_addr = virt_to_bus(ret);
+	dev_addr = swiotlb_virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
 	if (address_needs_mapping(hwdev, dev_addr, size)) {
@@ -548,7 +558,7 @@
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 			 int dir, struct dma_attrs *attrs)
 {
-	dma_addr_t dev_addr = virt_to_bus(ptr);
+	dma_addr_t dev_addr = swiotlb_virt_to_bus(ptr);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -569,7 +579,7 @@
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = virt_to_bus(map);
+	dev_addr = swiotlb_virt_to_bus(map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -599,7 +609,7 @@
 swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 			   size_t size, int dir, struct dma_attrs *attrs)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -629,7 +639,7 @@
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -660,7 +670,7 @@
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr) + offset;
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -716,7 +726,7 @@
 
 	for_each_sg(sgl, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dev_addr = virt_to_bus(addr);
+		dev_addr = swiotlb_virt_to_bus(addr);
 		if (swiotlb_force ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
@@ -729,7 +739,7 @@
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-			sg->dma_address = virt_to_bus(map);
+			sg->dma_address = swiotlb_virt_to_bus(map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
@@ -760,7 +770,7 @@
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			unmap_single(hwdev, bus_to_virt(sg->dma_address),
+			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
@@ -793,7 +803,7 @@
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, bus_to_virt(sg->dma_address),
+			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
@@ -817,7 +827,7 @@
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == virt_to_bus(io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_bus(io_tlb_overflow_buffer));
 }
 
 /*
@@ -829,7 +839,7 @@
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return virt_to_bus(io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_bus(io_tlb_end - 1) <= mask;
 }
 
 EXPORT_SYMBOL(swiotlb_map_single);


