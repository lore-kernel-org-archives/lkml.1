Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYIIQJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYIIQJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 12:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756708AbYIIQIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 12:08:55 -0400
Received: from mo10.iij4u.or.jp ([210.138.174.78]:35999 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbYIIQIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 12:08:53 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       Tony Luck <tony.luck@intel.com>
Subject: [PATCH 4/4] swiotlb: convert swiotlb to use is_buffer_dma_capable helper function
Date: Wed, 10 Sep 2008 01:06:49 +0900
Message-Id: <1220976409-8417-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.4.2
In-Reply-To: <1220976409-8417-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1220976409-8417-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220976409-8417-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220976409-8417-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1220976409-8417-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Tony Luck <tony.luck@intel.com>
---
 lib/swiotlb.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index b5f5d11..240a67c 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -274,13 +274,13 @@ cleanup1:
 }
 
 static int
-address_needs_mapping(struct device *hwdev, dma_addr_t addr)
+address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 {
 	dma_addr_t mask = 0xffffffff;
 	/* If the device has a mask, use it, otherwise default to 32 bits */
 	if (hwdev && hwdev->dma_mask)
 		mask = *hwdev->dma_mask;
-	return (addr & ~mask) != 0;
+	return !is_buffer_dma_capable(mask, addr, size);
 }
 
 static int is_swiotlb_buffer(char *addr)
@@ -473,7 +473,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	int order = get_order(size);
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret))) {
+	if (ret && address_needs_mapping(hwdev, virt_to_bus(ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -497,7 +497,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	dev_addr = virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
-	if (address_needs_mapping(hwdev, dev_addr)) {
+	if (address_needs_mapping(hwdev, dev_addr, size)) {
 		printk("hwdev DMA mask = 0x%016Lx, dev_addr = 0x%016Lx\n",
 		       (unsigned long long)*hwdev->dma_mask,
 		       (unsigned long long)dev_addr);
@@ -561,7 +561,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(hwdev, dev_addr) && !swiotlb_force)
+	if (!address_needs_mapping(hwdev, dev_addr, size) && !swiotlb_force)
 		return dev_addr;
 
 	/*
@@ -578,7 +578,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(hwdev, dev_addr))
+	if (address_needs_mapping(hwdev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -721,7 +721,8 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 	for_each_sg(sgl, sg, nelems, i) {
 		addr = SG_ENT_VIRT_ADDRESS(sg);
 		dev_addr = virt_to_bus(addr);
-		if (swiotlb_force || address_needs_mapping(hwdev, dev_addr)) {
+		if (swiotlb_force ||
+		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
-- 
1.5.4.2

