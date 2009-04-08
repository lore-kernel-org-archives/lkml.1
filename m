Return-Path: <linux-kernel-owner+w=401wt.eu-S1754994AbZDHOLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbZDHOLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbZDHOKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:10:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:59960 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372AbZDHOKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:10:38 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, jeremy@goop.org,
       fujita.tomonori@lab.ntt.co.jp, ian.campbell@citrix.com
Cc: beckyb@kernel.crashing.org
Subject: [PATCH 6/7] swiotlb: Use swiotlb_sync_single instead of duplicating code
Date: Wed,  8 Apr 2009 09:09:20 -0500
Message-Id: <1239199761-22886-7-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1239199761-22886-6-git-send-email-galak@kernel.crashing.org>
References: <1239199761-22886-1-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-2-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-3-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-4-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-5-git-send-email-galak@kernel.crashing.org>
 <1239199761-22886-6-git-send-email-galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Becky Bruce <beckyb@kernel.crashing.org>

Right now both swiotlb_sync_single_range and swiotlb_sync_sg
were duplicating the code in swiotlb_sync_single.  Just call it
instead.  Also rearrange the sync_single code for readability.

Note that the swiotlb_sync_sg code was previously doing
a complicated comparison to determine if an addresses needed
to be unmapped where a simple is_swiotlb_buffer() call
would have sufficed.

Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 lib/swiotlb.c |   30 ++++++++++++------------------
 1 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 2bde54a..d912f06 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -731,10 +731,16 @@ swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
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
@@ -761,13 +767,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
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
@@ -890,15 +890,9 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
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
1.6.0.6

