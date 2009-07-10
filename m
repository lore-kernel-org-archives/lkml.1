Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbZGJBMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbZGJBMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbZGJBJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:09:25 -0400
Received: from sh.osrg.net ([192.16.179.4]:55373 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042AbZGJBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:09:19 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       fujita.tomonori@lab.ntt.co.jp, beckyb@kernel.crashing.org
Subject: [PATCH 09/15] swiotlb: use dma_capable()
Date: Fri, 10 Jul 2009 10:04:58 +0900
Message-Id: <1247187904-31999-10-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 10 Jul 2009 10:08:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This converts swiotlb to use dma_capable() instead of
swiotlb_arch_address_needs_mapping() and is_buffer_dma_capable().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 lib/swiotlb.c |   24 +++++-------------------
 1 files changed, 5 insertions(+), 19 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 1a89c84..a0faeb0 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -130,12 +130,6 @@ static dma_addr_t swiotlb_virt_to_bus(struct device *hwdev,
 	return swiotlb_phys_to_bus(hwdev, virt_to_phys(address));
 }
 
-int __weak swiotlb_arch_address_needs_mapping(struct device *hwdev,
-					       dma_addr_t addr, size_t size)
-{
-	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
-}
-
 static void swiotlb_print_info(unsigned long bytes)
 {
 	phys_addr_t pstart, pend;
@@ -296,12 +290,6 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static inline int
-address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
-{
-	return swiotlb_arch_address_needs_mapping(hwdev, addr, size);
-}
-
 static int is_swiotlb_buffer(phys_addr_t paddr)
 {
 	return paddr >= virt_to_phys(io_tlb_start) &&
@@ -538,9 +526,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret &&
-	    !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(hwdev, ret),
-				   size)) {
+	if (ret && swiotlb_virt_to_bus(hwdev, ret) + size > dma_mask) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 */
@@ -562,7 +548,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = swiotlb_virt_to_bus(hwdev, ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
+	if (dev_addr + size > dma_mask) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)dma_mask,
 		       (unsigned long long)dev_addr);
@@ -634,7 +620,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(dev, dev_addr, size) && !swiotlb_force)
+	if (dma_capable(dev, dev_addr, size) && !swiotlb_force)
 		return dev_addr;
 
 	/*
@@ -651,7 +637,7 @@ dma_addr_t swiotlb_map_page(struct device *dev, struct page *page,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(dev, dev_addr, size))
+	if (!dma_capable(dev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -798,7 +784,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		dma_addr_t dev_addr = swiotlb_phys_to_bus(hwdev, paddr);
 
 		if (swiotlb_force ||
-		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
+		    !dma_capable(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, sg_phys(sg),
 					       sg->length, dir);
 			if (!map) {
-- 
1.6.0.6

