Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZCMFEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZCMFEM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 01:04:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbZCMFDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 01:03:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:59739 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbZCMFDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 01:03:30 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/14] block: kill blk_start_queueing()
Date: Fri, 13 Mar 2009 14:02:46 +0900
Message-Id: <1236920578-2179-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1236920578-2179-1-git-send-email-tj@kernel.org>
References: <1236920578-2179-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 05:03:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: removal of mostly duplicate interface function

blk_start_queueing() is identical to __blk_run_queue() except that it
doesn't check for recursion.  None of the current users depends on
blk_start_queueing() running request_fn directly.  Replace usages of
blk_start_queueing() with [__]blk_run_queue() and kill it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/as-iosched.c     |    6 +-----
 block/blk-core.c       |   28 ++--------------------------
 block/cfq-iosched.c    |   10 +++-------
 block/elevator.c       |    7 +++----
 drivers/ide/ide-park.c |    7 ++-----
 include/linux/blkdev.h |    1 -
 6 files changed, 11 insertions(+), 48 deletions(-)

diff --git a/block/as-iosched.c b/block/as-iosched.c
index 631f6f4..da8e272 100644
--- a/block/as-iosched.c
+++ b/block/as-iosched.c
@@ -1315,12 +1315,8 @@ static void as_merged_requests(struct request_queue *q, struct request *req,
 static void as_work_handler(struct work_struct *work)
 {
 	struct as_data *ad = container_of(work, struct as_data, antic_work);
-	struct request_queue *q = ad->q;
-	unsigned long flags;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_start_queueing(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_run_queue(ad->q);
 }
 
 static int as_may_queue(struct request_queue *q, int rw)
diff --git a/block/blk-core.c b/block/blk-core.c
index 95dc76f..7c2d836 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -433,9 +433,7 @@ EXPORT_SYMBOL(__blk_run_queue);
  *
  * Description:
  *    Invoke request handling on this queue, if it has pending work to do.
- *    May be used to restart queueing when a request has completed. Also
- *    See @blk_start_queueing.
- *
+ *    May be used to restart queueing when a request has completed.
  */
 void blk_run_queue(struct request_queue *q)
 {
@@ -893,28 +891,6 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 EXPORT_SYMBOL(blk_get_request);
 
 /**
- * blk_start_queueing - initiate dispatch of requests to device
- * @q:		request queue to kick into gear
- *
- * This is basically a helper to remove the need to know whether a queue
- * is plugged or not if someone just wants to initiate dispatch of requests
- * for this queue. Should be used to start queueing on a device outside
- * of ->request_fn() context. Also see @blk_run_queue.
- *
- * The queue lock must be held with interrupts disabled.
- */
-void blk_start_queueing(struct request_queue *q)
-{
-	if (!blk_queue_plugged(q)) {
-		if (unlikely(blk_queue_stopped(q)))
-			return;
-		q->request_fn(q);
-	} else
-		__generic_unplug_device(q);
-}
-EXPORT_SYMBOL(blk_start_queueing);
-
-/**
  * blk_requeue_request - put a request back on queue
  * @q:		request queue where request should be inserted
  * @rq:		request to be inserted
@@ -982,7 +958,7 @@ void blk_insert_request(struct request_queue *q, struct request *rq,
 
 	drive_stat_acct(rq, 1);
 	__elv_add_request(q, rq, where, 0);
-	blk_start_queueing(q);
+	__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 EXPORT_SYMBOL(blk_insert_request);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 664ebfd..8190db8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1900,7 +1900,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		if (cfq_cfqq_wait_request(cfqq)) {
 			cfq_mark_cfqq_must_dispatch(cfqq);
 			del_timer(&cfqd->idle_slice_timer);
-			blk_start_queueing(cfqd->queue);
+			__blk_run_queue(cfqd->queue);
 		}
 	} else if (cfq_should_preempt(cfqd, cfqq, rq)) {
 		/*
@@ -1911,7 +1911,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		 */
 		cfq_preempt_queue(cfqd, cfqq);
 		cfq_mark_cfqq_must_dispatch(cfqq);
-		blk_start_queueing(cfqd->queue);
+		__blk_run_queue(cfqd->queue);
 	}
 }
 
@@ -2143,12 +2143,8 @@ static void cfq_kick_queue(struct work_struct *work)
 {
 	struct cfq_data *cfqd =
 		container_of(work, struct cfq_data, unplug_work);
-	struct request_queue *q = cfqd->queue;
-	unsigned long flags;
 
-	spin_lock_irqsave(q->queue_lock, flags);
-	blk_start_queueing(q);
-	spin_unlock_irqrestore(q->queue_lock, flags);
+	blk_run_queue(cfqd->queue);
 }
 
 /*
diff --git a/block/elevator.c b/block/elevator.c
index 98259ed..fca4436 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -618,8 +618,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		 *   with anything.  There's no point in delaying queue
 		 *   processing.
 		 */
-		blk_remove_plug(q);
-		blk_start_queueing(q);
+		__blk_run_queue(q);
 		break;
 
 	case ELEVATOR_INSERT_SORT:
@@ -946,7 +945,7 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 		    blk_ordered_cur_seq(q) == QUEUE_ORDSEQ_DRAIN &&
 		    (!next || blk_ordered_req_seq(next) > QUEUE_ORDSEQ_DRAIN)) {
 			blk_ordered_complete_seq(q, QUEUE_ORDSEQ_DRAIN, 0);
-			blk_start_queueing(q);
+			__blk_run_queue(q);
 		}
 	}
 }
@@ -1107,7 +1106,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	elv_drain_elevator(q);
 
 	while (q->rq.elvpriv) {
-		blk_start_queueing(q);
+		__blk_run_queue(q);
 		spin_unlock_irq(q->queue_lock);
 		msleep(10);
 		spin_lock_irq(q->queue_lock);
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index c875a95..5f121f7 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -24,11 +24,8 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 			start_queue = 1;
 		spin_unlock_irq(&hwif->lock);
 
-		if (start_queue) {
-			spin_lock_irq(q->queue_lock);
-			blk_start_queueing(q);
-			spin_unlock_irq(q->queue_lock);
-		}
+		if (start_queue)
+			blk_run_queue(q);
 		return;
 	}
 	spin_unlock_irq(&hwif->lock);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 465d6ba..4c05bb9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -775,7 +775,6 @@ extern void blk_sync_queue(struct request_queue *q);
 extern void __blk_stop_queue(struct request_queue *q);
 extern void __blk_run_queue(struct request_queue *);
 extern void blk_run_queue(struct request_queue *);
-extern void blk_start_queueing(struct request_queue *);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
-- 
1.6.0.2

