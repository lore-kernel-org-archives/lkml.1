Return-Path: <linux-kernel-owner+w=401wt.eu-S965236AbXIKTHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236AbXIKTHx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964939AbXIKTDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:03:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763141AbXIKTDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:03:04 -0400
Date: Tue, 11 Sep 2007 15:02:30 -0400 (EDT)
Message-Id: <20070911.150230.101501522.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 18/27] blk_end_request: changing mmc (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
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

diff -rupN 17-i2o-caller-change/drivers/mmc/card/block.c 18-mmc-caller-change/drivers/mmc/card/block.c
--- 17-i2o-caller-change/drivers/mmc/card/block.c	2007-09-10 17:32:13.000000000 -0400
+++ 18-mmc-caller-change/drivers/mmc/card/block.c	2007-09-10 18:08:53.000000000 -0400
@@ -336,15 +336,7 @@ static int mmc_blk_issue_rq(struct mmc_q
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
 
@@ -374,27 +366,21 @@ static int mmc_blk_issue_rq(struct mmc_q
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
+		ret = __blk_end_request(req, 0, blk_rq_cur_size(req));
 	spin_unlock_irq(&md->lock);
 
 	return 0;
diff -rupN 17-i2o-caller-change/drivers/mmc/card/queue.c 18-mmc-caller-change/drivers/mmc/card/queue.c
--- 17-i2o-caller-change/drivers/mmc/card/queue.c	2007-08-27 21:32:35.000000000 -0400
+++ 18-mmc-caller-change/drivers/mmc/card/queue.c	2007-09-10 18:08:53.000000000 -0400
@@ -93,8 +93,8 @@ static void mmc_request(struct request_q
 		printk(KERN_ERR "MMC: killing requests for dead queue\n");
 		while ((req = elv_next_request(q)) != NULL) {
 			do {
-				ret = end_that_request_chunk(req, 0,
-					req->current_nr_sectors << 9);
+				ret = __blk_end_request(req, 0,
+							blk_rq_cur_size(req));
 			} while (ret);
 		}
 		return;
