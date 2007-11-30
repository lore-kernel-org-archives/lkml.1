Return-Path: <linux-kernel-owner+w=401wt.eu-S1763398AbXK3Xc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763398AbXK3Xc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 18:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763033AbXK3XcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 18:32:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763006AbXK3XcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 18:32:06 -0500
Date: Fri, 30 Nov 2007 18:31:48 -0500 (EST)
Message-Id: <20071130.183148.123924838.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com
Subject: [PATCH 17/28] blk_end_request: changing mmc (take 3)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts mmc to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/mmc/card/block.c |   24 +++++-------------------
 drivers/mmc/card/queue.c |    4 ++--
 2 files changed, 7 insertions(+), 21 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/mmc/card/block.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/mmc/card/block.c
+++ 2.6.24-rc3-mm2/drivers/mmc/card/block.c
@@ -348,15 +348,7 @@ static int mmc_blk_issue_rq(struct mmc_q
 		 * A block was successfully transferred.
 		 */
 		spin_lock_irq(&md->lock);
-		ret = end_that_request_chunk(req, 1, brq.data.bytes_xfered);
-		if (!ret) {
-			/*
-			 * The whole request completed successfully.
-			 */
-			add_disk_randomness(req->rq_disk);
-			blkdev_dequeue_request(req);
-			end_that_request_last(req, 1);
-		}
+		ret = __blk_end_request(req, 1, brq.data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	} while (ret);
 
@@ -386,27 +378,21 @@ static int mmc_blk_issue_rq(struct mmc_q
 			else
 				bytes = blocks << 9;
 			spin_lock_irq(&md->lock);
-			ret = end_that_request_chunk(req, 1, bytes);
+			ret = __blk_end_request(req, 1, bytes);
 			spin_unlock_irq(&md->lock);
 		}
 	} else if (rq_data_dir(req) != READ &&
 		   (card->host->caps & MMC_CAP_MULTIWRITE)) {
 		spin_lock_irq(&md->lock);
-		ret = end_that_request_chunk(req, 1, brq.data.bytes_xfered);
+		ret = __blk_end_request(req, 1, brq.data.bytes_xfered);
 		spin_unlock_irq(&md->lock);
 	}
 
 	mmc_release_host(card->host);
 
 	spin_lock_irq(&md->lock);
-	while (ret) {
-		ret = end_that_request_chunk(req, 0,
-				req->current_nr_sectors << 9);
-	}
-
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, 0);
+	while (ret)
+		ret = __blk_end_request(req, 0, blk_rq_cur_bytes(req));
 	spin_unlock_irq(&md->lock);
 
 	return 0;
Index: 2.6.24-rc3-mm2/drivers/mmc/card/queue.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/mmc/card/queue.c
+++ 2.6.24-rc3-mm2/drivers/mmc/card/queue.c
@@ -94,8 +94,8 @@ static void mmc_request(struct request_q
 		printk(KERN_ERR "MMC: killing requests for dead queue\n");
 		while ((req = elv_next_request(q)) != NULL) {
 			do {
-				ret = end_that_request_chunk(req, 0,
-					req->current_nr_sectors << 9);
+				ret = __blk_end_request(req, 0,
+							blk_rq_cur_bytes(req));
 			} while (ret);
 		}
 		return;
