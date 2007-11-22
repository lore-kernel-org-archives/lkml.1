Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbXKVTdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbXKVTdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 14:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXKVTdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 14:33:00 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:58870 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752334AbXKVTc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 14:32:59 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] mmc: Add missing sg_init_table() call
Date: Thu, 22 Nov 2007 20:32:51 +0100
Message-Id: <1195759971-19825-1-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mmc_init_queue only initializes the scatterlists with sg_init_table()
when using a bounce buffer. This leads to a BUG() when CONFIG_DEBUG_SG
is set.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/mmc/card/queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 1b9c9b6..30cd13b 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -180,12 +180,13 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
 		blk_queue_max_segment_size(mq->queue, host->max_seg_size);
 
-		mq->sg = kzalloc(sizeof(struct scatterlist) *
+		mq->sg = kmalloc(sizeof(struct scatterlist) *
 			host->max_phys_segs, GFP_KERNEL);
 		if (!mq->sg) {
 			ret = -ENOMEM;
 			goto cleanup_queue;
 		}
+		sg_init_table(mq->sg, host->max_phys_segs);
 	}
 
 	init_MUTEX(&mq->thread_sem);
-- 
1.5.3.4

