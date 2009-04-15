Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbZDONL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbZDONL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759354AbZDONKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:10:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:34992 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbZDONKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:10:41 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/5] block: fix queue bounce limit setting
Date: Wed, 15 Apr 2009 22:10:25 +0900
Message-Id: <1239801027-9201-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239801027-9201-1-git-send-email-tj@kernel.org>
References: <1239801027-9201-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 13:10:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: don't set GFP_DMA in q->bounce_gfp unnecessarily

All DMA address limits are expressed in terms of the last addressable
unit (byte or page) instead of one plus that.  However, when
determining bounce_gfp for 64bit machines in blk_queue_bounce_limit(),
it compares the specified limit against 0x100000000UL to determine
whether it's below 4G ending up falsely setting GFP_DMA in
q->bounce_gfp.

As DMA zone is very small on x86_64, this makes larger SG_IO transfers
very eager to trigger OOM killer.  Fix it.  While at it, rename the
parameter to @dma_mask for clarity and convert comment to proper
winged style.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-settings.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 69c42ad..57af728 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -156,26 +156,28 @@ EXPORT_SYMBOL(blk_queue_make_request);
 
 /**
  * blk_queue_bounce_limit - set bounce buffer limit for queue
- * @q:  the request queue for the device
- * @dma_addr:   bus address limit
+ * @q: the request queue for the device
+ * @dma_mask: the maximum address the device can handle
  *
  * Description:
  *    Different hardware can have different requirements as to what pages
  *    it can do I/O directly to. A low level driver can call
  *    blk_queue_bounce_limit to have lower memory pages allocated as bounce
- *    buffers for doing I/O to pages residing above @dma_addr.
+ *    buffers for doing I/O to pages residing above @dma_mask.
  **/
-void blk_queue_bounce_limit(struct request_queue *q, u64 dma_addr)
+void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
 {
-	unsigned long b_pfn = dma_addr >> PAGE_SHIFT;
+	unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
 	int dma = 0;
 
 	q->bounce_gfp = GFP_NOIO;
 #if BITS_PER_LONG == 64
-	/* Assume anything <= 4GB can be handled by IOMMU.
-	   Actually some IOMMUs can handle everything, but I don't
-	   know of a way to test this here. */
-	if (b_pfn < (min_t(u64, 0x100000000UL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
+	/*
+	 * Assume anything <= 4GB can be handled by IOMMU.  Actually
+	 * some IOMMUs can handle everything, but I don't know of a
+	 * way to test this here.
+	 */
+	if (b_pfn < (min_t(u64, 0xffffffffUL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
 	q->bounce_pfn = max_low_pfn;
 #else
-- 
1.6.0.2

