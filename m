Return-Path: <linux-kernel-owner+w=401wt.eu-S1755738AbZCXVpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738AbZCXVpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbZCXVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:44:27 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:34829 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbZCXVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:44:25 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com,
       jeremy@goop.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 3/5] swiotlb: swiotlb_bus_to_virt/phys prototype changes
Date: Tue, 24 Mar 2009 16:28:44 -0500
Message-Id: <1237930126-6741-4-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org>
References: <1237930126-6741-1-git-send-email-beckyb@kernel.crashing.org>
 <1237930126-6741-2-git-send-email-beckyb@kernel.crashing.org>
 <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make these functions take the hwdev as an argument because on some
platforms it contains a per-device offset that is used to convert
from bus addresses to/from other types of addresses.

Also, make these weak so architectures can override the default
behavior (for example, by adding an offset in the hwdev).

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 arch/x86/kernel/pci-swiotlb.c |    2 +-
 include/linux/swiotlb.h       |    4 +++-
 lib/swiotlb.c                 |   31 +++++++++++++++++++------------
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/pci-swiotlb.c b/arch/x86/kernel/pci-swiotlb.c
index 34f12e9..887388a 100644
--- a/arch/x86/kernel/pci-swiotlb.c
+++ b/arch/x86/kernel/pci-swiotlb.c
@@ -28,7 +28,7 @@ dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 	return paddr;
 }
 
-phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
+phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 {
 	return baddr;
 }
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index ac9ff54..a27bca3 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -29,7 +29,9 @@ extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
 extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 				      phys_addr_t address);
-extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
+extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
+				       dma_addr_t address);
+extern void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address);
 
 extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 62f5f75..c152f17 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -129,20 +129,20 @@ dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 	return paddr;
 }
 
-phys_addr_t __weak swiotlb_bus_to_phys(dma_addr_t baddr)
+phys_addr_t __weak swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 {
 	return baddr;
 }
 
-static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
+dma_addr_t __weak swiotlb_virt_to_bus(struct device *hwdev,
 				      volatile void *address)
 {
 	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
-static void *swiotlb_bus_to_virt(dma_addr_t address)
+void __weak *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 {
-	return phys_to_virt(swiotlb_bus_to_phys(address));
+	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
 }
 
 int __weak swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size)
@@ -687,7 +687,7 @@ void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
 			size_t size, enum dma_data_direction dir,
 			struct dma_attrs *attrs)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -711,7 +711,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -744,7 +744,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -847,10 +847,14 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
-				     sg->dma_length, dir);
+			unmap_single(
+				hwdev,
+				swiotlb_bus_to_virt(hwdev, sg->dma_address),
+				sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
+			dma_mark_clean(
+				swiotlb_bus_to_virt(hwdev, sg->dma_address),
+				sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -881,10 +885,13 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
+			sync_single(hwdev,
+				    swiotlb_bus_to_virt(hwdev, sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
+			dma_mark_clean(
+				swiotlb_bus_to_virt(hwdev, sg->dma_address),
+				sg->dma_length);
 	}
 }
 
-- 
1.5.6.6

