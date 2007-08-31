Return-Path: <linux-kernel-owner+w=401wt.eu-S1762909AbXHaWna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762909AbXHaWna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 18:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756903AbXHaWnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 18:43:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634AbXHaWnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 18:43:11 -0400
Date: Fri, 31 Aug 2007 18:42:43 -0400 (EDT)
Message-Id: <20070831.184243.74567713.k-ueda@ct.jp.nec.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, jens.axboe@oracle.com, mike.miller@hp.com,
       grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 4/7] blk_end_request: cciss/cpqarray/xsysace change
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes "odd" drivers to use blk_end_request().
The drivers are cciss, cpqarray and xsysace.


cciss and cpqarray directly call bio_endio() and disk_stat_add()
when completing request.  But those can be replaced with
__end_that_request_first().
After the replacement, request completion procedures of those drivers
become like the following:
    o end_that_request_first()
    o add_disk_randomness()
    o end_that_request_last()
This can be converted to blk_end_request() by following
the rule (a) mentioned in the patch subject
"[PATCH 3/7] blk_end_request: changing "normal" drivers".


xsysace driver has a state machine in it.
It calls end_that_request_first() and end_that_request_last()
from different states. (ACE_FSM_STATE_REQ_TRANSFER and
ACE_FSM_STATE_REQ_COMPLETE, respectively.)
However, those states are consecutive and without any interruption
inbetween.
So we can just follow the standard conversion rule (a) mentioned in
the patch subject "[PATCH 3/7] blk_end_request: changing "normal" drivers".

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 cciss.c    |   26 +++-----------------------
 cpqarray.c |   28 ++--------------------------
 xsysace.c  |    5 +----
 3 files changed, 6 insertions(+), 53 deletions(-)

diff -rupN 03-normal-caller-change/drivers/block/cciss.c 04-other-caller-change/drivers/block/cciss.c
--- 03-normal-caller-change/drivers/block/cciss.c	2007-08-13 00:25:24.000000000 -0400
+++ 04-other-caller-change/drivers/block/cciss.c	2007-08-23 17:54:19.000000000 -0400
@@ -1187,18 +1187,6 @@ static int cciss_ioctl(struct inode *ino
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int status)
-{
-	while (bio) {
-		struct bio *xbh = bio->bi_next;
-		int nr_sectors = bio_sectors(bio);
-
-		bio->bi_next = NULL;
-		bio_endio(bio, nr_sectors << 9, status ? 0 : -EIO);
-		bio = xbh;
-	}
-}
-
 static void cciss_check_queues(ctlr_info_t *h)
 {
 	int start_queue = h->next_to_run;
@@ -1264,21 +1252,14 @@ static void cciss_softirq_done(struct re
 		pci_unmap_page(h->pdev, temp64.val, cmd->SG[i].Len, ddir);
 	}
 
-	complete_buffers(rq->bio, (rq->errors == 0));
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
-
 #ifdef CCISS_DEBUG
 	printk("Done with %p\n", rq);
 #endif				/* CCISS_DEBUG */
 
-	add_disk_randomness(rq->rq_disk);
+	if (blk_end_request(rq, (rq->errors == 0), blk_rq_size(rq)))
+		BUG();
+
 	spin_lock_irqsave(&h->lock, flags);
-	end_that_request_last(rq, (rq->errors == 0));
 	cmd_free(h, cmd, 1);
 	cciss_check_queues(h);
 	spin_unlock_irqrestore(&h->lock, flags);
@@ -2504,7 +2485,6 @@ after_error_processing:
 	}
 	cmd->rq->data_len = 0;
 	cmd->rq->completion_data = cmd;
-	blk_add_trace_rq(cmd->rq->q, cmd->rq, BLK_TA_COMPLETE);
 	blk_complete_request(cmd->rq);
 }
 
diff -rupN 03-normal-caller-change/drivers/block/cpqarray.c 04-other-caller-change/drivers/block/cpqarray.c
--- 03-normal-caller-change/drivers/block/cpqarray.c	2007-08-13 00:25:24.000000000 -0400
+++ 04-other-caller-change/drivers/block/cpqarray.c	2007-08-23 17:54:19.000000000 -0400
@@ -166,7 +166,6 @@ static void start_io(ctlr_info_t *h);
 
 static inline void addQ(cmdlist_t **Qptr, cmdlist_t *c);
 static inline cmdlist_t *removeQ(cmdlist_t **Qptr, cmdlist_t *c);
-static inline void complete_buffers(struct bio *bio, int ok);
 static inline void complete_command(cmdlist_t *cmd, int timeout);
 
 static irqreturn_t do_ida_intr(int irq, void *dev_id);
@@ -978,20 +977,6 @@ static void start_io(ctlr_info_t *h)
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int ok)
-{
-	struct bio *xbh;
-	while(bio) {
-		int nr_sectors = bio_sectors(bio);
-
-		xbh = bio->bi_next;
-		bio->bi_next = NULL;
-		
-		bio_endio(bio, nr_sectors << 9, ok ? 0 : -EIO);
-
-		bio = xbh;
-	}
-}
 /*
  * Mark all buffers that cmd was responsible for
  */
@@ -1029,18 +1014,9 @@ static inline void complete_command(cmdl
                 pci_unmap_page(hba[cmd->ctlr]->pci_dev, cmd->req.sg[i].addr,
 				cmd->req.sg[i].size, ddir);
 
-	complete_buffers(rq->bio, ok);
-
-	if (blk_fs_request(rq)) {
-		const int rw = rq_data_dir(rq);
-
-		disk_stat_add(rq->rq_disk, sectors[rw], rq->nr_sectors);
-	}
-
-	add_disk_randomness(rq->rq_disk);
-
 	DBGPX(printk("Done with %p\n", rq););
-	end_that_request_last(rq, ok ? 1 : -EIO);
+	if (__blk_end_request(rq, ok, blk_rq_size(rq)))
+		BUG();
 }
 
 /*
diff -rupN 03-normal-caller-change/drivers/block/xsysace.c 04-other-caller-change/drivers/block/xsysace.c
--- 03-normal-caller-change/drivers/block/xsysace.c	2007-08-22 18:54:04.000000000 -0400
+++ 04-other-caller-change/drivers/block/xsysace.c	2007-08-23 17:54:19.000000000 -0400
@@ -696,7 +696,7 @@ static void ace_fsm_dostate(struct ace_d
 
 		/* bio finished; is there another one? */
 		i = ace->req->current_nr_sectors;
-		if (end_that_request_first(ace->req, 1, i)) {
+		if (__blk_end_request(ace->req, 1, i)) {
 			/* dev_dbg(ace->dev, "next block; h=%li c=%i\n",
 			 *      ace->req->hard_nr_sectors,
 			 *      ace->req->current_nr_sectors);
@@ -711,9 +711,6 @@ static void ace_fsm_dostate(struct ace_d
 		break;
 
 	case ACE_FSM_STATE_REQ_COMPLETE:
-		/* Complete the block request */
-		blkdev_dequeue_request(ace->req);
-		end_that_request_last(ace->req, 1);
 		ace->req = NULL;
 
 		/* Finished request; go to idle state */
