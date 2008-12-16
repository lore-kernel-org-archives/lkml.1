Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYLPUUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYLPUUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 15:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755743AbYLPUSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 15:18:49 -0500
Received: from gw.goop.org ([64.81.55.164]:45893 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbYLPUSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 15:18:47 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 06 of 14] swiotlb: allow architectures to override
	phys<->bus<->phys conversions
X-Mercurial-Node: 08df95f21a40099f889080aa9965c15cbd02ae09
Message-Id: <08df95f21a40099f8890.1229458650@abulafia.goop.org>
In-Reply-To: <patchbomb.1229458644@abulafia.goop.org>
Date: Tue, 16 Dec 2008 12:17:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jan Beulich <jbeulich@novell.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <ian.campbell@citrix.com>

Architectures may need to override these conversions. Implement a
__weak hook point containing the default implementation.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/linux/swiotlb.h |    3 ++
 lib/swiotlb.c           |   52 ++++++++++++++++++++++++++++++++---------------
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -27,6 +27,9 @@
 extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
 extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
+extern dma_addr_t swiotlb_phys_to_bus(phys_addr_t address);
+extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -125,6 +125,26 @@
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
+dma_addr_t __weak swiotlb_phys_to_bus(phys_addr_t paddr)
+{
+	return paddr;
+}
+
+phys_addr_t __weak swiotlb_bus_to_phys(dma_addr_t baddr)
+{
+	return baddr;
+}
+
+static dma_addr_t swiotlb_virt_to_bus(volatile void *address)
+{
+	return swiotlb_phys_to_bus(virt_to_phys(address));
+}
+
+static void *swiotlb_bus_to_virt(dma_addr_t address)
+{
+	return phys_to_virt(swiotlb_bus_to_phys(address));
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -168,7 +188,7 @@
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 
 	printk(KERN_INFO "Placing software IO TLB between 0x%lx - 0x%lx\n",
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	       swiotlb_virt_to_bus(io_tlb_start), swiotlb_virt_to_bus(io_tlb_end));
 }
 
 void __init
@@ -250,7 +270,7 @@
 
 	printk(KERN_INFO "Placing %luMB software IO TLB between 0x%lx - "
 	       "0x%lx\n", bytes >> 20,
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	       swiotlb_virt_to_bus(io_tlb_start), swiotlb_virt_to_bus(io_tlb_end));
 
 	return 0;
 
@@ -298,7 +318,7 @@
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_bus(io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
@@ -471,7 +491,7 @@
 	int order = get_order(size);
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && !address_needs_mapping(hwdev, virt_to_bus(ret), size)) {
+	if (ret && !address_needs_mapping(hwdev, swiotlb_virt_to_bus(ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -492,7 +512,7 @@
 	}
 
 	memset(ret, 0, size);
-	dev_addr = virt_to_bus(ret);
+	dev_addr = swiotlb_virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
 	if (!address_needs_mapping(hwdev, dev_addr, size)) {
@@ -552,7 +572,7 @@
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 			 int dir, struct dma_attrs *attrs)
 {
-	dma_addr_t dev_addr = virt_to_bus(ptr);
+	dma_addr_t dev_addr = swiotlb_virt_to_bus(ptr);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -573,7 +593,7 @@
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = virt_to_bus(map);
+	dev_addr = swiotlb_virt_to_bus(map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -603,7 +623,7 @@
 swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 			   size_t size, int dir, struct dma_attrs *attrs)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -633,7 +653,7 @@
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -664,7 +684,7 @@
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr) + offset;
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -720,7 +740,7 @@
 
 	for_each_sg(sgl, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dev_addr = virt_to_bus(addr);
+		dev_addr = swiotlb_virt_to_bus(addr);
 		if (swiotlb_force ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
@@ -733,7 +753,7 @@
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-			sg->dma_address = virt_to_bus(map);
+			sg->dma_address = swiotlb_virt_to_bus(map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
@@ -764,7 +784,7 @@
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			unmap_single(hwdev, bus_to_virt(sg->dma_address),
+			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
@@ -797,7 +817,7 @@
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, bus_to_virt(sg->dma_address),
+			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
 			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
@@ -821,7 +841,7 @@
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == virt_to_bus(io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_bus(io_tlb_overflow_buffer));
 }
 
 /*
@@ -833,7 +853,7 @@
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return virt_to_bus(io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_bus(io_tlb_end - 1) <= mask;
 }
 
 EXPORT_SYMBOL(swiotlb_map_single);


