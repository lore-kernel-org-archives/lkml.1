Return-Path: <linux-kernel-owner+w=401wt.eu-S1752880AbZGJBKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbZGJBKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZGJBJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:09:12 -0400
Received: from sh.osrg.net ([192.16.179.4]:55335 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZGJBJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:09:07 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org
Subject: [PATCH 10/15] powerpc: remove unncesary swiotlb_arch_address_needs_mapping
Date: Fri, 10 Jul 2009 10:04:59 +0900
Message-Id: <1247187904-31999-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:08:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swiotlb doesn't use swiotlb_arch_address_needs_mapping(); it uses
dma_capalbe(). We can remove unnecessary
swiotlb_arch_address_needs_mapping().

We can remove swiotlb_addr_needs_map() and is_buffer_dma_capable() in
swiotlb_pci_addr_needs_map() too; dma_capable() handles the features
that both provide.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/powerpc/kernel/dma-swiotlb.c |   27 +--------------------------
 1 files changed, 1 insertions(+), 26 deletions(-)

diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index 41534ae..a3bbe02 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -36,28 +36,11 @@ phys_addr_t swiotlb_bus_to_phys(struct device *hwdev, dma_addr_t baddr)
 }
 
 /*
- * Determine if an address needs bounce buffering via swiotlb.
- * Going forward I expect the swiotlb code to generalize on using
- * a dma_ops->addr_needs_map, and this function will move from here to the
- * generic swiotlb code.
- */
-int
-swiotlb_arch_address_needs_mapping(struct device *hwdev, dma_addr_t addr,
-				   size_t size)
-{
-	struct dma_mapping_ops *dma_ops = get_dma_ops(hwdev);
-
-	BUG_ON(!dma_ops);
-	return dma_ops->addr_needs_map(hwdev, addr, size);
-}
-
-/*
  * Determine if an address is reachable by a pci device, or if we must bounce.
  */
 static int
 swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
 {
-	u64 mask = dma_get_mask(hwdev);
 	dma_addr_t max;
 	struct pci_controller *hose;
 	struct pci_dev *pdev = to_pci_dev(hwdev);
@@ -69,16 +52,9 @@ swiotlb_pci_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
 	if ((addr + size > max) | (addr < hose->dma_window_base_cur))
 		return 1;
 
-	return !is_buffer_dma_capable(mask, addr, size);
-}
-
-static int
-swiotlb_addr_needs_map(struct device *hwdev, dma_addr_t addr, size_t size)
-{
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
+	return 0;
 }
 
-
 /*
  * At the moment, all platforms that use this code only require
  * swiotlb to be used if we're operating on HIGHMEM.  Since
@@ -94,7 +70,6 @@ struct dma_mapping_ops swiotlb_dma_ops = {
 	.dma_supported = swiotlb_dma_supported,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
-	.addr_needs_map = swiotlb_addr_needs_map,
 	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
 	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
-- 
1.6.0.6

