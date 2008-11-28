Return-Path: <linux-kernel-owner+w=401wt.eu-S1755174AbYK1EdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbYK1EdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYK1EcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:32:22 -0500
Received: from hera.kernel.org ([140.211.167.34]:45255 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052AbYK1EcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:32:21 -0500
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] block: simplify empty barrier implementation
Date: Fri, 28 Nov 2008 13:32:06 +0900
Message-Id: <1227846727-24980-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227846727-24980-1-git-send-email-tj@kernel.org>
References: <1227846727-24980-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 04:32:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Empty barrier required special handling in __elv_next_request() to
complete it without letting the low level driver see it.

With previous changes, barrier code is now flexible enough to skip the
BAR step using the same barrier sequence selection mechanism.  Drop
the special handling and mask off q->ordered from start_ordered().

Remove blk_empty_barrier() test which now has no user.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-barrier.c    |   16 ++++++++++------
 block/elevator.c       |    8 --------
 include/linux/blkdev.h |    1 -
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index b03d880..c63044e 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -162,6 +162,14 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	q->ordered = q->next_ordered;
 	q->ordseq |= QUEUE_ORDSEQ_STARTED;
 
+	/*
+	 * For an empty barrier, there's no actual BAR request, which
+	 * in turn makes POSTFLUSH unnecessary.  Mask them off.
+	 */
+	if (!rq->hard_nr_sectors)
+		q->ordered &= ~(QUEUE_ORDERED_DO_BAR |
+				QUEUE_ORDERED_DO_POSTFLUSH);
+
 	/* stash away the original request */
 	elv_dequeue_request(q, rq);
 	q->orig_bar_rq = rq;
@@ -171,13 +179,9 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	 * Queue ordered sequence.  As we stack them at the head, we
 	 * need to queue in reverse order.  Note that we rely on that
 	 * no fs request uses ELEVATOR_INSERT_FRONT and thus no fs
-	 * request gets inbetween ordered sequence. If this request is
-	 * an empty barrier, we don't need to do a postflush ever since
-	 * there will be no data written between the pre and post flush.
-	 * Hence a single flush will suffice.
+	 * request gets inbetween ordered sequence.
 	 */
-	if ((q->ordered & QUEUE_ORDERED_DO_POSTFLUSH) &&
-	    !blk_empty_barrier(q->orig_bar_rq)) {
+	if (q->ordered & QUEUE_ORDERED_DO_POSTFLUSH) {
 		queue_flush(q, QUEUE_ORDERED_DO_POSTFLUSH);
 		rq = &q->post_flush_rq;
 	} else
diff --git a/block/elevator.c b/block/elevator.c
index 3b45d26..5562782 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -749,14 +749,6 @@ struct request *elv_next_request(struct request_queue *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
-		/*
-		 * Kill the empty barrier place holder, the driver must
-		 * not ever see it.
-		 */
-		if (blk_empty_barrier(rq)) {
-			__blk_end_request(rq, 0, blk_rq_bytes(rq));
-			continue;
-		}
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0234726..10616b2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -596,7 +596,6 @@ enum {
 #define blk_fua_rq(rq)		((rq)->cmd_flags & REQ_FUA)
 #define blk_discard_rq(rq)	((rq)->cmd_flags & REQ_DISCARD)
 #define blk_bidi_rq(rq)		((rq)->next_rq != NULL)
-#define blk_empty_barrier(rq)	(blk_barrier_rq(rq) && blk_fs_request(rq) && !(rq)->hard_nr_sectors)
 /* rq->queuelist of dequeued request must be list_empty() */
 #define blk_queued_rq(rq)	(!list_empty(&(rq)->queuelist))
 
-- 
1.5.6

