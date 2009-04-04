Return-Path: <linux-kernel-owner+w=401wt.eu-S937523AbZDDB61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937523AbZDDB61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765249AbZDDB5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:57:37 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64863 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761233AbZDDB5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:57:35 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 7/7] swiotlb: Change swiotlb_bus_to[phys,virt] prototypes
Date: Fri,  3 Apr 2009 20:56:49 -0500
Message-Id: <1238810209-24499-8-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1238810209-24499-7-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-2-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-3-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-4-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-5-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-6-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-7-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a hwdev argument that is needed on some architectures
in order to access a per-device offset that is taken into
account when producing a physical address (also needed to
get from bus address to virtual address because the physical
address is an intermediate step).

Also make swiotlb_bus_to_virt weak so architectures can
override it.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
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
index c0f185a..d006f6d 100644
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
@@ -692,7 +692,7 @@ static void
 swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 		     size_t size, int dir)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
@@ -729,7 +729,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-- 
1.5.6.6

