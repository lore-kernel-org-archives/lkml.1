Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbYK1EdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbYK1EdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 23:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYK1EcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 23:32:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:45254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYK1EcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 23:32:18 -0500
From: Tejun Heo <tj@kernel.org>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/6] block: make barrier completion more robust
Date: Fri, 28 Nov 2008 13:32:05 +0900
Message-Id: <1227846727-24980-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1227846727-24980-1-git-send-email-tj@kernel.org>
References: <1227846727-24980-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Nov 2008 04:32:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Barrier completion had the following assumptions.

* start_ordered() couldn't finish the whole sequence properly.  If all
  actions are to be skipped, q->ordseq is set correctly but the actual
  completion was never triggered thus hanging the barrier request.

* Drain completion in elv_complete_request() assumed that there's
  always at least one request in the queue when drain completes.

Both assumptions are true but these assumptions need to be removed to
improve empty barrier implementation.  This patch makes the following
changes.

* Make start_ordered() use blk_ordered_complete_seq() to mark skipped
  steps complete and notify __elv_next_request() that it should fetch
  the next request if the whole barrier has completed inside
  start_ordered().

* Make drain completion path in elv_complete_request() check whether
  the queue is empty.  Empty queue also indicates drain completion.

* While at it, convert 0/1 return from blk_do_ordered() to false/true.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-barrier.c    |   45 +++++++++++++++++++++++++++------------------
 block/elevator.c       |   10 +++++++---
 include/linux/blkdev.h |    4 ++--
 3 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 1efabf8..b03d880 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -88,7 +88,7 @@ unsigned blk_ordered_req_seq(struct request *rq)
 		return QUEUE_ORDSEQ_DONE;
 }
 
-void blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
+bool blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
 {
 	struct request *rq;
 
@@ -99,7 +99,7 @@ void blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
 	q->ordseq |= seq;
 
 	if (blk_ordered_cur_seq(q) != QUEUE_ORDSEQ_DONE)
-		return;
+		return false;
 
 	/*
 	 * Okay, sequence complete.
@@ -109,6 +109,8 @@ void blk_ordered_complete_seq(struct request_queue *q, unsigned seq, int error)
 
 	if (__blk_end_request(rq, q->orderr, blk_rq_bytes(rq)))
 		BUG();
+
+	return true;
 }
 
 static void pre_flush_end_io(struct request *rq, int error)
@@ -151,9 +153,11 @@ static void queue_flush(struct request_queue *q, unsigned which)
 	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 }
 
-static inline struct request *start_ordered(struct request_queue *q,
-					    struct request *rq)
+static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 {
+	struct request *rq = *rqp;
+	unsigned skip = 0;
+
 	q->orderr = 0;
 	q->ordered = q->next_ordered;
 	q->ordseq |= QUEUE_ORDSEQ_STARTED;
@@ -177,7 +181,7 @@ static inline struct request *start_ordered(struct request_queue *q,
 		queue_flush(q, QUEUE_ORDERED_DO_POSTFLUSH);
 		rq = &q->post_flush_rq;
 	} else
-		q->ordseq |= QUEUE_ORDSEQ_POSTFLUSH;
+		skip |= QUEUE_ORDSEQ_POSTFLUSH;
 
 	if (q->ordered & QUEUE_ORDERED_DO_BAR) {
 		rq = &q->bar_rq;
@@ -193,35 +197,40 @@ static inline struct request *start_ordered(struct request_queue *q,
 
 		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 	} else
-		q->ordseq |= QUEUE_ORDSEQ_BAR;
+		skip |= QUEUE_ORDSEQ_BAR;
 
 	if (q->ordered & QUEUE_ORDERED_DO_PREFLUSH) {
 		queue_flush(q, QUEUE_ORDERED_DO_PREFLUSH);
 		rq = &q->pre_flush_rq;
 	} else
-		q->ordseq |= QUEUE_ORDSEQ_PREFLUSH;
+		skip |= QUEUE_ORDSEQ_PREFLUSH;
 
 	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && q->in_flight)
 		rq = NULL;
 	else
-		q->ordseq |= QUEUE_ORDSEQ_DRAIN;
+		skip |= QUEUE_ORDSEQ_DRAIN;
+
+	*rqp = rq;
 
-	return rq;
+	/*
+	 * Complete skipped sequences.  If whole sequence is complete,
+	 * return false to tell elevator that this request is gone.
+	 */
+	return !blk_ordered_complete_seq(q, skip, 0);
 }
 
-int blk_do_ordered(struct request_queue *q, struct request **rqp)
+bool blk_do_ordered(struct request_queue *q, struct request **rqp)
 {
 	struct request *rq = *rqp;
 	const int is_barrier = blk_fs_request(rq) && blk_barrier_rq(rq);
 
 	if (!q->ordseq) {
 		if (!is_barrier)
-			return 1;
+			return true;
 
-		if (q->next_ordered != QUEUE_ORDERED_NONE) {
-			*rqp = start_ordered(q, rq);
-			return 1;
-		} else {
+		if (q->next_ordered != QUEUE_ORDERED_NONE)
+			return start_ordered(q, rqp);
+		else {
 			/*
 			 * Queue ordering not supported.  Terminate
 			 * with prejudice.
@@ -231,7 +240,7 @@ int blk_do_ordered(struct request_queue *q, struct request **rqp)
 					      blk_rq_bytes(rq)))
 				BUG();
 			*rqp = NULL;
-			return 0;
+			return false;
 		}
 	}
 
@@ -242,7 +251,7 @@ int blk_do_ordered(struct request_queue *q, struct request **rqp)
 	/* Special requests are not subject to ordering rules. */
 	if (!blk_fs_request(rq) &&
 	    rq != &q->pre_flush_rq && rq != &q->post_flush_rq)
-		return 1;
+		return true;
 
 	if (q->ordered & QUEUE_ORDERED_BY_TAG) {
 		/* Ordered by tag.  Blocking the next barrier is enough. */
@@ -255,7 +264,7 @@ int blk_do_ordered(struct request_queue *q, struct request **rqp)
 			*rqp = NULL;
 	}
 
-	return 1;
+	return true;
 }
 
 static void bio_end_empty_barrier(struct bio *bio, int err)
diff --git a/block/elevator.c b/block/elevator.c
index a6951f7..3b45d26 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -938,10 +938,14 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 	 * drained for flush sequence.
 	 */
 	if (unlikely(q->ordseq)) {
-		struct request *first_rq = list_entry_rq(q->queue_head.next);
-		if (q->in_flight == 0 &&
+		struct request *next = NULL;
+
+		if (!list_empty(&q->queue_head))
+			next = list_entry_rq(q->queue_head.next);
+
+		if (!q->in_flight &&
 		    blk_ordered_cur_seq(q) == QUEUE_ORDSEQ_DRAIN &&
-		    blk_ordered_req_seq(first_rq) > QUEUE_ORDSEQ_DRAIN) {
+		    (!next || blk_ordered_req_seq(next) > QUEUE_ORDSEQ_DRAIN)) {
 			blk_ordered_complete_seq(q, QUEUE_ORDSEQ_DRAIN, 0);
 			blk_start_queueing(q);
 		}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 076620d..0234726 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,10 +865,10 @@ extern void blk_queue_rq_timed_out(struct request_queue *, rq_timed_out_fn *);
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(struct request_queue *, unsigned, prepare_flush_fn *);
-extern int blk_do_ordered(struct request_queue *, struct request **);
+extern bool blk_do_ordered(struct request_queue *, struct request **);
 extern unsigned blk_ordered_cur_seq(struct request_queue *);
 extern unsigned blk_ordered_req_seq(struct request *);
-extern void blk_ordered_complete_seq(struct request_queue *, unsigned, int);
+extern bool blk_ordered_complete_seq(struct request_queue *, unsigned, int);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
 extern void blk_dump_rq_flags(struct request *, char *);
-- 
1.5.6

