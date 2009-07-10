Return-Path: <linux-kernel-owner+w=401wt.eu-S1753377AbZGJBMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbZGJBMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZGJBJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:09:27 -0400
Received: from sh.osrg.net ([192.16.179.4]:55371 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZGJBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:09:19 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org
Subject: [PATCH 04/15] swiotlb: remove unnecessary swiotlb_bus_to_virt
Date: Fri, 10 Jul 2009 10:04:53 +0900
Message-Id: <1247187904-31999-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:08:00 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb_bus_to_virt is unncessary; we can use swiotlb_bus_to_phys and
phys_to_virt instead.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/kernel/dma-swiotlb.c |   10 ----------
 lib/swiotlb.c                     |   34 ++++++++++++++++------------------
 2 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index 68ccf11..41534ae 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -24,16 +24,6 @@
 int swiotlb __read_mostly;
 unsigned int ppc_swiotlb_enable;
 
-void *swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t addr)
-{
-	unsigned long pfn = PFN_DOWN(swiotlb_bus_to_phys(hwdev, addr));
-	void *pageaddr = page_address(pfn_to_page(pfn));
-
-	if (pageaddr != NULL)
-		return pageaddr + (addr % PAGE_SIZE);
-	return NULL;
-}
-
 dma_addr_t swiotlb_phys_to_bus(struct device *hwdev, phys_addr_t paddr)
 {
 	return paddr + get_dma_direct_offset(hwdev);
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index dc1cd1f..1a89c84 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -130,11 +130,6 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
-void * __weak swiotlb_bus_to_virt(struct device *hwdev, dma_addr_t address)
-{
-	return phys_to_virt(swiotlb_bus_to_phys(hwdev, address));
-}
-
 int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
 					       dma_addr_t addr, size_t size)
 {
@@ -307,9 +302,10 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
 }
 
-static int is_swiotlb_buffer(char *addr)
+static int is_swiotlb_buffer(phys_addr_t paddr)
 {
-	return addr >= io_tlb_start && addr < io_tlb_end;
+	return paddr >= virt_to_phys(io_tlb_start) &&
+		paddr < virt_to_phys(io_tlb_end);
 }
 
 /*
@@ -582,11 +578,13 @@ EXPORT_SYMBOL(swiotlb_alloc_coherent);
 
 void
 swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
-		      dma_addr_t dma_handle)
+		      dma_addr_t dev_addr)
 {
+	phys_addr_t paddr = swiotlb_bus_to_phys(hwdev, dev_addr);
+
 	WARN_ON(irqs_disabled());
-	if (!is_swiotlb_buffer(vaddr))
-		free_pages((unsigned long) vaddr, get_order(size));
+	if (!is_swiotlb_buffer(paddr))
+		free_pages((unsigned long)vaddr, get_order(size));
 	else
 		/* DMA_TO_DEVICE to avoid memcpy in unmap_single */
 		do_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
@@ -671,19 +669,19 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
 static void unmap_single(struct device *hwdev, dma_addr_t dev_addr,
 			 size_t size, int dir)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	phys_addr_t paddr = swiotlb_bus_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-	if (is_swiotlb_buffer(dma_addr)) {
-		do_unmap_single(hwdev, dma_addr, size, dir);
+	if (is_swiotlb_buffer(paddr)) {
+		do_unmap_single(hwdev, phys_to_virt(paddr), size, dir);
 		return;
 	}
 
 	if (dir != DMA_FROM_DEVICE)
 		return;
 
-	dma_mark_clean(dma_addr, size);
+	dma_mark_clean(phys_to_virt(paddr), size);
 }
 
 void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
@@ -708,19 +706,19 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(hwdev, dev_addr);
+	phys_addr_t paddr = swiotlb_bus_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-	if (is_swiotlb_buffer(dma_addr)) {
-		sync_single(hwdev, dma_addr, size, dir, target);
+	if (is_swiotlb_buffer(paddr)) {
+		sync_single(hwdev, phys_to_virt(paddr), size, dir, target);
 		return;
 	}
 
 	if (dir != DMA_FROM_DEVICE)
 		return;
 
-	dma_mark_clean(dma_addr, size);
+	dma_mark_clean(phys_to_virt(paddr), size);
 }
 
 void
-- 
1.6.0.6

