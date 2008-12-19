Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYLSFN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYLSFN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 00:13:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYLSFLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 00:11:33 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:42902 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYLSFL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 00:11:28 -0500
From: Becky Bruce <beckyb@kernel.crashing.org>
To: mingo@elte.hu, jeremy@goop.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       ian.campbell@citrix.com, jbeulich@novell.com, joerg.roedel@amd.com,
       benh@kernel.crashing.org, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 02/11] swiotlb: Allow arch to provide address_needs_mapping
Date: Thu, 18 Dec 2008 23:11:13 -0600
Message-Id: <1229663480-10757-3-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081218210231.GB24271@elte.hu>
References: <20081218210231.GB24271@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename it swiotlb_addr_needs_mapping and make it weak
so architectures can override it if needed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 3d9ac10..9b89a9d 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -272,8 +272,8 @@ cleanup1:
 	return -ENOMEM;
 }
 
-static int
-address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
+int __weak
+swiotlb_addr_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 {
 	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
 }
@@ -562,7 +562,8 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(hwdev, dev_addr, size) && !swiotlb_force)
+	if (!swiotlb_addr_needs_mapping(hwdev, dev_addr, size) &&
+	    !swiotlb_force)
 		return dev_addr;
 
 	/*
@@ -579,7 +580,7 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	/*
 	 * Ensure that the address returned is DMA'ble
 	 */
-	if (address_needs_mapping(hwdev, dev_addr, size))
+	if (swiotlb_addr_needs_mapping(hwdev, dev_addr, size))
 		panic("map_single: bounce buffer is not DMA'ble");
 
 	return dev_addr;
@@ -723,7 +724,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		addr = sg_virt(sg);
 		dev_addr = virt_to_bus(addr);
 		if (swiotlb_force ||
-		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
+		    swiotlb_addr_needs_mapping(hwdev, dev_addr, sg->length)) {
 			void *map = map_single(hwdev, addr, sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
-- 
1.5.6.5

