Return-Path: <linux-kernel-owner+w=401wt.eu-S937443AbZDDB6G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937443AbZDDB6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:58:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764836AbZDDB5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:57:36 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:64864 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686AbZDDB5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:57:35 -0400
From: Becky Bruce <beckyb@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 6/7] swiotlb: Use swiotlb_sync_single instead of duplicating code
Date: Fri,  3 Apr 2009 20:56:48 -0500
Message-Id: <1238810209-24499-7-git-send-email-beckyb@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.6
In-Reply-To: <1238810209-24499-6-git-send-email-beckyb@kernel.crashing.org>
References: <1238810209-24499-1-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-2-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-3-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-4-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-5-git-send-email-beckyb@kernel.crashing.org>
 <1238810209-24499-6-git-send-email-beckyb@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now both swiotlb_sync_single_range and swiotlb_sync_sg
were duplicating the code in swiotlb_sync_single.  Just call it
instead.  Also rearrange the sync_single code for readability.

Note that the swiotlb_sync_sg code was previously doing
a complicated comparison to determine if an addresses needed
to be unmapped where a simple is_swiotlb_buffer() call
would have sufficed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
---
 lib/swiotlb.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 602315b..c0f185a 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -732,10 +732,16 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
+
+	if (is_swiotlb_buffer(dma_addr)) {
 		sync_single(hwdev, dma_addr, size, dir, target);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+		return;
+	}
+
+	if (dir != DMA_FROM_DEVICE)
+		return;
+
+	dma_mark_clean(dma_addr, size);
 }
 
 void
@@ -762,13 +768,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
-
-	BUG_ON(dir == DMA_NONE);
-	if (is_swiotlb_buffer(dma_addr))
-		sync_single(hwdev, dma_addr, size, dir, target);
-	else if (dir == DMA_FROM_DEVICE)
-		dma_mark_clean(dma_addr, size);
+	swiotlb_sync_single(hwdev, dev_addr + offset, size, dir, target);
 }
 
 void
@@ -892,15 +892,9 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	struct scatterlist *sg;
 	int i;
 
-	BUG_ON(dir == DMA_NONE);
-
-	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != swiotlb_phys_to_bus(hwdev, sg_phys(sg)))
-			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
+	for_each_sg(sgl, sg, nelems, i)
+		swiotlb_sync_single(hwdev, sg->dma_address,
 				    sg->dma_length, dir, target);
-		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
-	}
 }
 
 void
-- 
1.5.6.6

