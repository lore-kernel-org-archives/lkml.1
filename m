Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbYLVSb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbYLVSb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 13:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbYLVS25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 13:28:57 -0500
Received: from gw.goop.org ([64.81.55.164]:44723 "EHLO abulafia.goop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752945AbYLVS2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 13:28:55 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 9] swiotlb: add hwdev to swiotlb_phys_to_bus
X-Mercurial-Node: f23dfdb3b879fba62dd061f6a65f4adc00288816
Message-Id: <f23dfdb3b879fba62dd0.1229970365@abulafia.goop.org>
In-Reply-To: <patchbomb.1229970362@abulafia.goop.org>
Date: Mon, 22 Dec 2008 10:26:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>,
       Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures need it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/pci-swiotlb_64.c |    2 -
 include/linux/swiotlb.h          |    3 +-
 lib/swiotlb.c                    |   45 +++++++++++++++-----------------------
 3 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -23,7 +23,7 @@
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
-dma_addr_t swiotlb_phys_to_bus(phys_addr_t paddr)
+dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
 }
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -27,7 +27,8 @@
 extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
 extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
-extern dma_addr_t swiotlb_phys_to_bus(phys_addr_t address);
+extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
+				      phys_addr_t address);
 extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
 
 extern int swiotlb_arch_range_needs_mapping(void *ptr, size_t size);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -125,7 +125,7 @@
 	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
 }
 
-dma_addr_t __weak swiotlb_phys_to_bus(phys_addr_t paddr)
+dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr;
 }
@@ -135,9 +135,10 @@
 	return baddr;
 }
 
-static dma_addr_t swiotlb_virt_to_bus(volatile void *address)
+static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
+				      volatile void *address)
 {
-	return swiotlb_phys_to_bus(virt_to_phys(address));
+	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
 static void *swiotlb_bus_to_virt(dma_addr_t address)
@@ -153,27 +154,15 @@
 static void swiotlb_print_info(unsigned long bytes)
 {
 	phys_addr_t pstart, pend;
-	dma_addr_t bstart, bend;
 
 	pstart = virt_to_phys(io_tlb_start);
 	pend = virt_to_phys(io_tlb_end);
 
-	bstart = swiotlb_phys_to_bus(pstart);
-	bend = swiotlb_phys_to_bus(pend);
-
 	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
 	       bytes >> 20, io_tlb_start, io_tlb_end);
-	if (pstart != bstart || pend != bend)
-		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx"
-		       " bus %#llx - %#llx\n",
-		       (unsigned long long)pstart,
-		       (unsigned long long)pend,
-		       (unsigned long long)bstart,
-		       (unsigned long long)bend);
-	else
-		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
-		       (unsigned long long)pstart,
-		       (unsigned long long)pend);
+	printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
+	       (unsigned long long)pstart,
+	       (unsigned long long)pend);
 }
 
 /*
@@ -351,7 +340,7 @@
 	unsigned long max_slots;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = swiotlb_virt_to_bus(io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_bus(hwdev, io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 
@@ -528,7 +517,9 @@
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(ret), size)) {
+	if (ret &&
+	    !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(hwdev, ret),
+				   size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -549,7 +540,7 @@
 	}
 
 	memset(ret, 0, size);
-	dev_addr = swiotlb_virt_to_bus(ret);
+	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
 	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
@@ -609,7 +600,7 @@
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 			 int dir, struct dma_attrs *attrs)
 {
-	dma_addr_t dev_addr = swiotlb_virt_to_bus(ptr);
+	dma_addr_t dev_addr = swiotlb_virt_to_bus(hwdev, ptr);
 	void *map;
 
 	BUG_ON(dir == DMA_NONE);
@@ -631,7 +622,7 @@
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = swiotlb_virt_to_bus(map);
+	dev_addr = swiotlb_virt_to_bus(hwdev, map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -778,7 +769,7 @@
 
 	for_each_sg(sgl, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dev_addr = swiotlb_virt_to_bus(addr);
+		dev_addr = swiotlb_virt_to_bus(hwdev, addr);
 		if (range_needs_mapping(sg_virt(sg), sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
@@ -791,7 +782,7 @@
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-			sg->dma_address = swiotlb_virt_to_bus(map);
+			sg->dma_address = swiotlb_virt_to_bus(hwdev, map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
@@ -879,7 +870,7 @@
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == swiotlb_virt_to_bus(io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_bus(hwdev, io_tlb_overflow_buffer));
 }
 
 /*
@@ -891,7 +882,7 @@
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return swiotlb_virt_to_bus(io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_bus(hwdev, io_tlb_end - 1) <= mask;
 }
 
 EXPORT_SYMBOL(swiotlb_map_single);


