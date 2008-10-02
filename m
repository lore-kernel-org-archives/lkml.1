Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbYJBP7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbYJBP7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 11:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYJBP7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 11:59:24 -0400
Received: from nebensachen.de ([195.34.83.29]:34519 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbYJBP7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 11:59:23 -0400
X-Hashcash: 1:20:081002:jens.axboe@oracle.com::+FKURLWennqJ8PTH:00000000000000000000000000000000000000001iZ/
X-Hashcash: 1:20:081002:linux-kernel@vger.kernel.org::ONAKJB8AUQBwrC3V:000000000000000000000000000000000J7DV
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Block: Fix handling of stopped queues and a plugging issue
Date: Thu, 02 Oct 2008 17:59:18 +0200
Message-ID: <87zllnound.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that ->request_fn() really isn't called on queues that are
supposed to be stopped. While at it, don't remove the plug in
__blk_run_queue() unconditionally since this might lead to system hangs.

Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
---
Applies to your devel tree.

 block/blk-core.c |    6 +++---
 block/elevator.c |   12 +++++++-----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2d053b5..ecc5443 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -404,14 +404,14 @@ EXPORT_SYMBOL(blk_sync_queue);
  */
 void __blk_run_queue(struct request_queue *q)
 {
-	blk_remove_plug(q);
-
 	/*
 	 * Only recurse once to avoid overrunning the stack, let the unplug
 	 * handling reinvoke the handler shortly if we already got there.
 	 */
-	if (!elv_queue_empty(q))
+	if (!elv_queue_empty(q) && likely(!blk_queue_stopped(q))) {
+		blk_remove_plug(q);
 		blk_invoke_request_fn(q);
+	}
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
diff --git a/block/elevator.c b/block/elevator.c
index 0451892..43a4257 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -611,8 +611,10 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		 *   with anything.  There's no point in delaying queue
 		 *   processing.
 		 */
-		blk_remove_plug(q);
-		q->request_fn(q);
+		if (likely(!blk_queue_stopped(q))) {
+			blk_remove_plug(q);
+			q->request_fn(q);
+		}
 		break;
 
 	case ELEVATOR_INSERT_SORT:
@@ -950,7 +952,8 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 		    blk_ordered_cur_seq(q) == QUEUE_ORDSEQ_DRAIN &&
 		    blk_ordered_req_seq(first_rq) > QUEUE_ORDSEQ_DRAIN) {
 			blk_ordered_complete_seq(q, QUEUE_ORDSEQ_DRAIN, 0);
-			q->request_fn(q);
+			if (likely(!blk_queue_stopped(q)))
+				q->request_fn(q);
 		}
 	}
 }
@@ -1109,8 +1112,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
 	elv_drain_elevator(q);
 
 	while (q->rq.elvpriv) {
-		blk_remove_plug(q);
-		q->request_fn(q);
+		blk_start_queueing(q);
 		spin_unlock_irq(q->queue_lock);
 		msleep(10);
 		spin_lock_irq(q->queue_lock);
