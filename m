Return-Path: <linux-kernel-owner+w=401wt.eu-S933595AbZDHOOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933595AbZDHOOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765439AbZDHOKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:35395 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765994AbZDHOKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:49 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: beckyb@kernel.crashing.org
Subject: [PATCH 7/7] swiotlb: Change swiotlb_bus_to[phys,virt] prototypes
Date: Wed,  8 Apr 2009 09:09:21 -0500
Message-Id: <1239199761-22886-8-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239199761-22886-7-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-6-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-7-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

Add a hwdev argument that is needed on some architectures
in order to access a per-device offset that is taken into
account when producing a physical address (also needed to
get from bus address to virtual address because the physical
address is an intermediate step).

Also make swiotlb_bus_to_virt weak so architectures can
override it.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/x86/kernel/pci-swiotlb.c |    2 +-
 include/linux/swiotlb.h       |    3 ++-
 lib/swiotlb.c                 |   10 +++++-----
 3 files changed, 8 insertions(+), 7 deletions(-)

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
index ac9ff54..cb1a663 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -29,7 +29,8 @@ extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
 
 extern dma_addr_t swiotlb_phys_to_bus(struct device *hwdev,
 				      phys_addr_t address);
-extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
+extern phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
+				       dma_addr_t address);
 
 extern int swiotlb_arch_range_needs_mapping(phys_addr_t paddr, size_t size);
 
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index d912f06..bffe6d7 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -129,7 +129,7 @@ dma_addr_t __weak swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 	return paddr;
 }
 
-phys_addr_t __weak swiotlb_bus_to_phys(dma_addr_t baddr)
+phys_addr_t __weak swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 {
 	return baddr;
 }
@@ -140,9 +140,9 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
-static void *swiotlb_bus_to_virt(dma_addr_t address)
+void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
 {
-	return phys_to_virt(swiotlb_bus_to_phys(address));
+	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
 }
 
 int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
@@ -691,7 +691,7 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			 size_t size, int dir)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -728,7 +728,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-- 
1.6.0.6

