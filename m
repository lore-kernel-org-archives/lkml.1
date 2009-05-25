Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbZEYHm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbZEYHm7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752153AbZEYHhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:37:37 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38667 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZEYHbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:12 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 06/13] block: move elevator ops into the queue
Date: Mon, 25 May 2009 09:30:54 +0200
Message-Id: <1243236668-3398-12-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/elevator.c       |   83 ++++++++++++++++++-----------------------------
 include/linux/blkdev.h |    1 +
 2 files changed, 33 insertions(+), 51 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 7073a90..fdb0675 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -65,10 +65,9 @@ DEFINE_TRACE(block_rq_issue);
 static int elv_iosched_allow_merge(struct request *rq, struct bio *bio)
 {
 	struct request_queue *q = rq->q;
-	struct elevator_queue *e = q->elevator;
 
-	if (e->ops->elevator_allow_merge_fn)
-		return e->ops->elevator_allow_merge_fn(q, rq, bio);
+	if (q->elv_ops.elevator_allow_merge_fn)
+		return q->elv_ops.elevator_allow_merge_fn(q, rq, bio);
 
 	return 1;
 }
@@ -185,6 +184,7 @@ static void *elevator_init_queue(struct request_queue *q,
 static void elevator_attach(struct request_queue *q, struct elevator_queue *eq,
 			   void *data)
 {
+	q->elv_ops = *eq->ops;
 	q->elevator = eq;
 	eq->elevator_data = data;
 }
@@ -312,18 +312,14 @@ EXPORT_SYMBOL(elevator_exit);
 
 static void elv_activate_rq(struct request_queue *q, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_activate_req_fn)
-		e->ops->elevator_activate_req_fn(q, rq);
+	if (q->elv_ops.elevator_activate_req_fn)
+		q->elv_ops.elevator_activate_req_fn(q, rq);
 }
 
 static void elv_deactivate_rq(struct request_queue *q, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_deactivate_req_fn)
-		e->ops->elevator_deactivate_req_fn(q, rq);
+	if (q->elv_ops.elevator_deactivate_req_fn)
+		q->elv_ops.elevator_deactivate_req_fn(q, rq);
 }
 
 static inline void __elv_rqhash_del(struct request *rq)
@@ -495,7 +491,6 @@ EXPORT_SYMBOL(elv_dispatch_add_tail);
 
 int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 {
-	struct elevator_queue *e = q->elevator;
 	struct request *__rq;
 	int ret;
 
@@ -522,18 +517,16 @@ int elv_merge(struct request_queue *q, struct request **req, struct bio *bio)
 		return ELEVATOR_BACK_MERGE;
 	}
 
-	if (e->ops->elevator_merge_fn)
-		return e->ops->elevator_merge_fn(q, req, bio);
+	if (q->elv_ops.elevator_merge_fn)
+		return q->elv_ops.elevator_merge_fn(q, req, bio);
 
 	return ELEVATOR_NO_MERGE;
 }
 
 void elv_merged_request(struct request_queue *q, struct request *rq, int type)
 {
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_merged_fn)
-		e->ops->elevator_merged_fn(q, rq, type);
+	if (q->elv_ops.elevator_merged_fn)
+		q->elv_ops.elevator_merged_fn(q, rq, type);
 
 	if (type == ELEVATOR_BACK_MERGE)
 		elv_rqhash_reposition(q, rq);
@@ -544,10 +537,8 @@ void elv_merged_request(struct request_queue *q, struct request *rq, int type)
 void elv_merge_requests(struct request_queue *q, struct request *rq,
 			     struct request *next)
 {
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_merge_req_fn)
-		e->ops->elevator_merge_req_fn(q, rq, next);
+	if (q->elv_ops.elevator_merge_req_fn)
+		q->elv_ops.elevator_merge_req_fn(q, rq, next);
 
 	elv_rqhash_reposition(q, rq);
 	elv_rqhash_del(q, next);
@@ -576,8 +567,10 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 void elv_drain_elevator(struct request_queue *q)
 {
 	static int printed;
-	while (q->elevator->ops->elevator_dispatch_fn(q, 1))
+
+	while (q->elv_ops.elevator_dispatch_fn(q, 1))
 		;
+
 	if (q->nr_sorted == 0)
 		return;
 	if (printed++ < 10) {
@@ -662,7 +655,7 @@ void elv_insert(struct request_queue *q, struct request *rq, int where)
 		 * rq cannot be accessed after calling
 		 * elevator_add_req_fn.
 		 */
-		q->elevator->ops->elevator_add_req_fn(q, rq);
+		q->elv_ops.elevator_add_req_fn(q, rq);
 		break;
 
 	case ELEVATOR_INSERT_REQUEUE:
@@ -770,7 +763,7 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 				return rq;
 		}
 
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+		if (!q->elv_ops.elevator_dispatch_fn(q, 0))
 			return NULL;
 	}
 }
@@ -872,13 +865,11 @@ void elv_dequeue_request(struct request_queue *q, struct request *rq)
 
 int elv_queue_empty(struct request_queue *q)
 {
-	struct elevator_queue *e = q->elevator;
-
 	if (!list_empty(&q->queue_head))
 		return 0;
 
-	if (e->ops->elevator_queue_empty_fn)
-		return e->ops->elevator_queue_empty_fn(q);
+	if (q->elv_ops.elevator_queue_empty_fn)
+		return q->elv_ops.elevator_queue_empty_fn(q);
 
 	return 1;
 }
@@ -886,28 +877,24 @@ EXPORT_SYMBOL(elv_queue_empty);
 
 struct request *elv_latter_request(struct request_queue *q, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
+	if (q->elv_ops.elevator_latter_req_fn)
+		return q->elv_ops.elevator_latter_req_fn(q, rq);
 
-	if (e->ops->elevator_latter_req_fn)
-		return e->ops->elevator_latter_req_fn(q, rq);
 	return NULL;
 }
 
 struct request *elv_former_request(struct request_queue *q, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
+	if (q->elv_ops.elevator_former_req_fn)
+		return q->elv_ops.elevator_former_req_fn(q, rq);
 
-	if (e->ops->elevator_former_req_fn)
-		return e->ops->elevator_former_req_fn(q, rq);
 	return NULL;
 }
 
 int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 {
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_set_req_fn)
-		return e->ops->elevator_set_req_fn(q, rq, gfp_mask);
+	if (q->elv_ops.elevator_set_req_fn)
+		return q->elv_ops.elevator_set_req_fn(q, rq, gfp_mask);
 
 	rq->elevator_private = NULL;
 	return 0;
@@ -915,18 +902,14 @@ int elv_set_request(struct request_queue *q, struct request *rq, gfp_t gfp_mask)
 
 void elv_put_request(struct request_queue *q, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_put_req_fn)
-		e->ops->elevator_put_req_fn(rq);
+	if (q->elv_ops.elevator_put_req_fn)
+		q->elv_ops.elevator_put_req_fn(rq);
 }
 
 int elv_may_queue(struct request_queue *q, int rw)
 {
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_may_queue_fn)
-		return e->ops->elevator_may_queue_fn(q, rw);
+	if (q->elv_ops.elevator_may_queue_fn)
+		return q->elv_ops.elevator_may_queue_fn(q, rw);
 
 	return ELV_MQUEUE_MAY;
 }
@@ -946,15 +929,13 @@ EXPORT_SYMBOL(elv_abort_queue);
 
 void elv_completed_request(struct request_queue *q, struct request *rq)
 {
-	struct elevator_queue *e = q->elevator;
-
 	/*
 	 * request is released from the driver, io must be done
 	 */
 	if (blk_account_rq(rq)) {
 		q->in_flight--;
-		if (blk_sorted_rq(rq) && e->ops->elevator_completed_req_fn)
-			e->ops->elevator_completed_req_fn(q, rq);
+		if (blk_sorted_rq(rq) && q->elv_ops.elevator_completed_req_fn)
+			q->elv_ops.elevator_completed_req_fn(q, rq);
 	}
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c00f050..4d6db9f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -326,6 +326,7 @@ struct request_queue
 	struct list_head	queue_head;
 	struct request		*last_merge;
 	struct elevator_queue	*elevator;
+	struct elevator_ops	elv_ops;
 
 	/*
 	 * the queue request freelist, one for reads and one for writes
-- 
1.6.3.rc0.1.gf800

