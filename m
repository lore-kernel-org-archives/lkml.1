Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZE1BLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZE1BLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 21:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760416AbZE1BK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 21:10:57 -0400
Received: from sh.osrg.net ([192.16.179.4]:56491 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760583AbZE1BK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 21:10:56 -0400
Date: Thu, 28 May 2009 10:10:43 +0900
To: rolandd@cisco.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] IB/mthca: replace dma_sync_single with
 dma_sync_single_for_cpu
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090528100943L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 28 May 2009 10:10:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This replaces dma_sync_single() with dma_sync_single_for_cpu() because
dma_sync_single() is an obsolete API; include/linux/dma-mapping.h says:

/* Backwards compat, remove in 2.7.x */
#define dma_sync_single		dma_sync_single_for_cpu
#define dma_sync_sg		dma_sync_sg_for_cpu

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/infiniband/hw/mthca/mthca_mr.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_mr.c b/drivers/infiniband/hw/mthca/mthca_mr.c
index 882e6b7..44c98df 100644
--- a/drivers/infiniband/hw/mthca/mthca_mr.c
+++ b/drivers/infiniband/hw/mthca/mthca_mr.c
@@ -355,7 +355,8 @@ static void mthca_arbel_write_mtt_seg(struct mthca_dev *dev,
 	for (i = 0; i < list_len; ++i)
 		mtts[i] = cpu_to_be64(buffer_list[i] | MTHCA_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, dma_handle, list_len * sizeof (u64), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(&dev->pdev->dev, dma_handle,
+				list_len * sizeof (u64), DMA_TO_DEVICE);
 }
 
 int mthca_write_mtt(struct mthca_dev *dev, struct mthca_mtt *mtt,
@@ -807,8 +808,8 @@ int mthca_arbel_map_phys_fmr(struct ib_fmr *ibfmr, u64 *page_list,
 		fmr->mem.arbel.mtts[i] = cpu_to_be64(page_list[i] |
 						     MTHCA_MTT_FLAG_PRESENT);
 
-	dma_sync_single(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
-			list_len * sizeof(u64), DMA_TO_DEVICE);
+	dma_sync_single_for_cpu(&dev->pdev->dev, fmr->mem.arbel.dma_handle,
+				list_len * sizeof(u64), DMA_TO_DEVICE);
 
 	fmr->mem.arbel.mpt->key    = cpu_to_be32(key);
 	fmr->mem.arbel.mpt->lkey   = cpu_to_be32(key);
-- 
1.6.0.6

