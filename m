Return-Path: <linux-kernel-owner+w=401wt.eu-S937756AbZDDB7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937756AbZDDB7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937438AbZDDB5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:57:52 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64899 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765234AbZDDB5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:57:50 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 5/7] swiotlb: (re)Create swiotlb_unmap_single
Date: Fri,  3 Apr 2009 20:56:47 -0500
Message-Id: <1238810209-24499-6-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1238810209-24499-5-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-2-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-3-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-4-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-5-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This mirrors the current swiotlb_sync_single() setup
where the swiotlb_unmap_single() function is static to this
file and contains the logic required to determine if we need
to call actual sync_single.  Previously, swiotlb_unmap_page
and swiotlb_unmap_sg were duplicating very similar code.
The duplicated code has also been reformatted for
readability.

Note that the swiotlb_unmap_sg code was previously doing
a complicated comparison to determine if an addresses needed
to be unmapped where a simple is_swiotlb_buffer() call
would have sufficed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   36 +++++++++++++++++++++++-------------
 1 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index af2ec25..602315b 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -688,17 +688,30 @@ EXPORT_SYMBOL_GPL(swiotlb_map_page);
  * After this call, reads by the cpu to the buffer are guaranteed to see
  * whatever the device wrote there.
  */
-void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
-			size_t size, enum dma_data_direction dir,
-			struct dma_attrs *attrs)
+static void
+swiotlb_unmap_single(struct device *hwdev, dma_addr_t dev_addr,
+		     size_t size, int dir)
 {
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
+
+	if (is_swiotlb_buffer(dma_addr)) {
 		unmap_single(hwdev, dma_addr, size, dir);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(dma_addr, size);
+}
+
+void swiotlb_unmap_page(struct device *hwdev, dma_addr_t dev_addr,
+			size_t size, enum dma_data_direction dir,
+			struct dma_attrs *attrs)
+{
+	swiotlb_unmap_single(hwdev, dev_addr, size, dir);
 }
 EXPORT_SYMBOL_GPL(swiotlb_unmap_page);
 
@@ -850,13 +863,10 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	BUG_ON(dir == DMA_NONE);
 
-	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
-				     sg->dma_length, dir);
-		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
-	}
+	for_each_sg(sgl, sg, nelems, i)
+		swiotlb_unmap_single(hwdev, sg->dma_address, sg->dma_length,
+				     dir);
+
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
 
-- 
1.5.6.6

