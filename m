Return-Path: <linux-kernel-owner+w=401wt.eu-S1759092AbZEYHhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759092AbZEYHhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755707AbZEYHdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:33:13 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38666 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919AbZEYHbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:15 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/13] block: change the tag sync vs async restriction logic
Date: Mon, 25 May 2009 09:30:58 +0200
Message-Id: <1243236668-3398-16-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make them fully share the tag space, but disallow async requests using
the last any two slots.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-barrier.c    |    2 +-
 block/blk-tag.c        |   15 +++++++++------
 block/elevator.c       |   10 +++++-----
 include/linux/blkdev.h |    7 ++++++-
 4 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 20b4111..3716ba5 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -221,7 +221,7 @@ static inline bool start_ordered(struct request_queue *q, struct request **rqp)
 	} else
 		skip |= QUEUE_ORDSEQ_PREFLUSH;
 
-	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && q->in_flight)
+	if ((q->ordered & QUEUE_ORDERED_BY_DRAIN) && queue_in_flight(q))
 		rq = NULL;
 	else
 		skip |= QUEUE_ORDSEQ_DRAIN;
diff --git a/block/blk-tag.c b/block/blk-tag.c
index 3c518e3..e9a7501 100644
--- a/block/blk-tag.c
+++ b/block/blk-tag.c
@@ -336,7 +336,7 @@ EXPORT_SYMBOL(blk_queue_end_tag);
 int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 {
 	struct blk_queue_tag *bqt = q->queue_tags;
-	unsigned max_depth, offset;
+	unsigned max_depth;
 	int tag;
 
 	if (unlikely((rq->cmd_flags & REQ_QUEUED))) {
@@ -355,13 +355,16 @@ int blk_queue_start_tag(struct request_queue *q, struct request *rq)
 	 * to starve sync IO on behalf of flooding async IO.
 	 */
 	max_depth = bqt->max_depth;
-	if (rq_is_sync(rq))
-		offset = 0;
-	else
-		offset = max_depth >> 2;
+	if (!rq_is_sync(rq) && max_depth > 1) {
+		max_depth -= 2;
+		if (!max_depth)
+			max_depth = 1;
+		if (q->in_flight[0] > max_depth)
+			return 1;
+	}
 
 	do {
-		tag = find_next_zero_bit(bqt->tag_map, max_depth, offset);
+		tag = find_first_zero_bit(bqt->tag_map, max_depth);
 		if (tag >= max_depth)
 			return 1;
 
diff --git a/block/elevator.c b/block/elevator.c
index c7143fb..6261b24 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -555,7 +555,7 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 	 * in_flight count again
 	 */
 	if (blk_account_rq(rq)) {
-		q->in_flight--;
+		q->in_flight[rq_is_sync(rq)]--;
 		if (blk_sorted_rq(rq))
 			elv_deactivate_rq(q, rq);
 	}
@@ -697,7 +697,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 
 	if (unplug_it && blk_queue_plugged(q)) {
 		int nrq = q->rq.count[BLK_RW_SYNC] + q->rq.count[BLK_RW_ASYNC]
-			- q->in_flight;
+			- queue_in_flight(q);
 
 		if (nrq >= q->unplug_thresh)
 			__generic_unplug_device(q);
@@ -861,7 +861,7 @@ void elv_dequeue_request(struct request_queue *q, struct request *rq)
 	 * the driver side.
 	 */
 	if (blk_account_rq(rq))
-		q->in_flight++;
+		q->in_flight[rq_is_sync(rq)]++;
 }
 
 int elv_queue_empty(struct request_queue *q)
@@ -934,7 +934,7 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 	 * request is released from the driver, io must be done
 	 */
 	if (blk_account_rq(rq)) {
-		q->in_flight--;
+		q->in_flight[rq_is_sync(rq)]--;
 		if (blk_sorted_rq(rq) && q->elv_ops.elevator_completed_req_fn)
 			elv_call_completed_req_fn(q, rq);
 	}
@@ -949,7 +949,7 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 		if (!list_empty(&q->queue_head))
 			next = list_entry_rq(q->queue_head.next);
 
-		if (!q->in_flight &&
+		if (!queue_in_flight(q) &&
 		    blk_ordered_cur_seq(q) == QUEUE_ORDSEQ_DRAIN &&
 		    (!next || blk_ordered_req_seq(next) > QUEUE_ORDSEQ_DRAIN)) {
 			blk_ordered_complete_seq(q, QUEUE_ORDSEQ_DRAIN, 0);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4d6db9f..ca322da 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -416,7 +416,7 @@ struct request_queue
 	struct list_head	tag_busy_list;
 
 	unsigned int		nr_sorted;
-	unsigned int		in_flight;
+	unsigned int		in_flight[2];
 
 	unsigned int		rq_timeout;
 	struct timer_list	timeout;
@@ -528,6 +528,11 @@ static inline void queue_flag_clear_unlocked(unsigned int flag,
 	__clear_bit(flag, &q->queue_flags);
 }
 
+static inline int queue_in_flight(struct request_queue *q)
+{
+	return q->in_flight[0] + q->in_flight[1];
+}
+
 static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 {
 	WARN_ON_ONCE(!queue_is_locked(q));
-- 
1.6.3.rc0.1.gf800

