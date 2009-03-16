Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbZCPCct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbZCPCct (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbZCPC3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:29:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:44312 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbZCPC3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:29:21 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/17] block: reorganize request fetching functions
Date: Mon, 16 Mar 2009 11:28:53 +0900
Message-Id: <1237170540-19130-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1237170540-19130-1-git-send-email-tj@kernel.org>
References: <1237170540-19130-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 16 Mar 2009 02:29:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: code reorganization

elv_next_request() and elv_dequeue_request() are public block layer
interface than actual elevator implementation.  They mostly deal with
how requests interact with block layer and low level drivers at the
beginning of rqeuest processing whereas __elv_next_request() is the
actual eleveator request fetching interface.

Move the two functions to blk-core.c.  This prepares for further
interface cleanup.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c |   95 ++++++++++++++++++++++++++++++++++++++++
 block/blk.h      |   37 ++++++++++++++++
 block/elevator.c |  128 ------------------------------------------------------
 3 files changed, 132 insertions(+), 128 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fd9dec3..0d97fbe 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1702,6 +1702,101 @@ unsigned int blk_rq_cur_bytes(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_rq_cur_bytes);
 
+struct request *elv_next_request(struct request_queue *q)
+{
+	struct request *rq;
+	int ret;
+
+	while ((rq = __elv_next_request(q)) != NULL) {
+		if (!(rq->cmd_flags & REQ_STARTED)) {
+			/*
+			 * This is the first time the device driver
+			 * sees this request (possibly after
+			 * requeueing).  Notify IO scheduler.
+			 */
+			if (blk_sorted_rq(rq))
+				elv_activate_rq(q, rq);
+
+			/*
+			 * just mark as started even if we don't start
+			 * it, a request that has been delayed should
+			 * not be passed by new incoming requests
+			 */
+			rq->cmd_flags |= REQ_STARTED;
+			trace_block_rq_issue(q, rq);
+		}
+
+		if (!q->boundary_rq || q->boundary_rq == rq) {
+			q->end_sector = rq_end_sector(rq);
+			q->boundary_rq = NULL;
+		}
+
+		if (rq->cmd_flags & REQ_DONTPREP)
+			break;
+
+		if (q->dma_drain_size && rq->data_len) {
+			/*
+			 * make sure space for the drain appears we
+			 * know we can do this because max_hw_segments
+			 * has been adjusted to be one fewer than the
+			 * device can handle
+			 */
+			rq->nr_phys_segments++;
+		}
+
+		if (!q->prep_rq_fn)
+			break;
+
+		ret = q->prep_rq_fn(q, rq);
+		if (ret == BLKPREP_OK) {
+			break;
+		} else if (ret == BLKPREP_DEFER) {
+			/*
+			 * the request may have been (partially) prepped.
+			 * we need to keep this request in the front to
+			 * avoid resource deadlock.  REQ_STARTED will
+			 * prevent other fs requests from passing this one.
+			 */
+			if (q->dma_drain_size && rq->data_len &&
+			    !(rq->cmd_flags & REQ_DONTPREP)) {
+				/*
+				 * remove the space for the drain we added
+				 * so that we don't add it again
+				 */
+				--rq->nr_phys_segments;
+			}
+
+			rq = NULL;
+			break;
+		} else if (ret == BLKPREP_KILL) {
+			rq->cmd_flags |= REQ_QUIET;
+			__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
+		} else {
+			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
+			break;
+		}
+	}
+
+	return rq;
+}
+EXPORT_SYMBOL(elv_next_request);
+
+void elv_dequeue_request(struct request_queue *q, struct request *rq)
+{
+	BUG_ON(list_empty(&rq->queuelist));
+	BUG_ON(ELV_ON_HASH(rq));
+
+	list_del_init(&rq->queuelist);
+
+	/*
+	 * the time frame between a request being removed from the lists
+	 * and to it is freed is accounted as io that is in progress at
+	 * the driver side.
+	 */
+	if (blk_account_rq(rq))
+		q->in_flight++;
+}
+
 /**
  * __end_that_request_first - end I/O on a request
  * @req:      the request being processed
diff --git a/block/blk.h b/block/blk.h
index 0dce92c..3979fd1 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -43,6 +43,43 @@ static inline void blk_clear_rq_complete(struct request *rq)
 	clear_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
 }
 
+/*
+ * Internal elevator interface
+ */
+#define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
+
+static inline struct request *__elv_next_request(struct request_queue *q)
+{
+	struct request *rq;
+
+	while (1) {
+		while (!list_empty(&q->queue_head)) {
+			rq = list_entry_rq(q->queue_head.next);
+			if (blk_do_ordered(q, &rq))
+				return rq;
+		}
+
+		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
+			return NULL;
+	}
+}
+
+static inline void elv_activate_rq(struct request_queue *q, struct request *rq)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e->ops->elevator_activate_req_fn)
+		e->ops->elevator_activate_req_fn(q, rq);
+}
+
+static inline void elv_deactivate_rq(struct request_queue *q, struct request *rq)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e->ops->elevator_deactivate_req_fn)
+		e->ops->elevator_deactivate_req_fn(q, rq);
+}
+
 #ifdef CONFIG_FAIL_IO_TIMEOUT
 int blk_should_fake_timeout(struct request_queue *);
 ssize_t part_timeout_show(struct device *, struct device_attribute *, char *);
diff --git a/block/elevator.c b/block/elevator.c
index fca4436..fd17605 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -53,7 +53,6 @@ static const int elv_hash_shift = 6;
 		(hash_long(ELV_HASH_BLOCK((sec)), elv_hash_shift))
 #define ELV_HASH_ENTRIES	(1 << elv_hash_shift)
 #define rq_hash_key(rq)		((rq)->sector + (rq)->nr_sectors)
-#define ELV_ON_HASH(rq)		(!hlist_unhashed(&(rq)->hash))
 
 DEFINE_TRACE(block_rq_insert);
 DEFINE_TRACE(block_rq_issue);
@@ -310,22 +309,6 @@ void elevator_exit(struct elevator_queue *e)
 }
 EXPORT_SYMBOL(elevator_exit);
 
-static void elv_activate_rq(struct request_queue *q, struct request *rq)
-{
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_activate_req_fn)
-		e->ops->elevator_activate_req_fn(q, rq);
-}
-
-static void elv_deactivate_rq(struct request_queue *q, struct request *rq)
-{
-	struct elevator_queue *e = q->elevator;
-
-	if (e->ops->elevator_deactivate_req_fn)
-		e->ops->elevator_deactivate_req_fn(q, rq);
-}
-
 static inline void __elv_rqhash_del(struct request *rq)
 {
 	hlist_del_init(&rq->hash);
@@ -733,117 +716,6 @@ void elv_add_request(struct request_queue *q, struct request *rq, int where,
 }
 EXPORT_SYMBOL(elv_add_request);
 
-static inline struct request *__elv_next_request(struct request_queue *q)
-{
-	struct request *rq;
-
-	while (1) {
-		while (!list_empty(&q->queue_head)) {
-			rq = list_entry_rq(q->queue_head.next);
-			if (blk_do_ordered(q, &rq))
-				return rq;
-		}
-
-		if (!q->elevator->ops->elevator_dispatch_fn(q, 0))
-			return NULL;
-	}
-}
-
-struct request *elv_next_request(struct request_queue *q)
-{
-	struct request *rq;
-	int ret;
-
-	while ((rq = __elv_next_request(q)) != NULL) {
-		if (!(rq->cmd_flags & REQ_STARTED)) {
-			/*
-			 * This is the first time the device driver
-			 * sees this request (possibly after
-			 * requeueing).  Notify IO scheduler.
-			 */
-			if (blk_sorted_rq(rq))
-				elv_activate_rq(q, rq);
-
-			/*
-			 * just mark as started even if we don't start
-			 * it, a request that has been delayed should
-			 * not be passed by new incoming requests
-			 */
-			rq->cmd_flags |= REQ_STARTED;
-			trace_block_rq_issue(q, rq);
-		}
-
-		if (!q->boundary_rq || q->boundary_rq == rq) {
-			q->end_sector = rq_end_sector(rq);
-			q->boundary_rq = NULL;
-		}
-
-		if (rq->cmd_flags & REQ_DONTPREP)
-			break;
-
-		if (q->dma_drain_size && rq->data_len) {
-			/*
-			 * make sure space for the drain appears we
-			 * know we can do this because max_hw_segments
-			 * has been adjusted to be one fewer than the
-			 * device can handle
-			 */
-			rq->nr_phys_segments++;
-		}
-
-		if (!q->prep_rq_fn)
-			break;
-
-		ret = q->prep_rq_fn(q, rq);
-		if (ret == BLKPREP_OK) {
-			break;
-		} else if (ret == BLKPREP_DEFER) {
-			/*
-			 * the request may have been (partially) prepped.
-			 * we need to keep this request in the front to
-			 * avoid resource deadlock.  REQ_STARTED will
-			 * prevent other fs requests from passing this one.
-			 */
-			if (q->dma_drain_size && rq->data_len &&
-			    !(rq->cmd_flags & REQ_DONTPREP)) {
-				/*
-				 * remove the space for the drain we added
-				 * so that we don't add it again
-				 */
-				--rq->nr_phys_segments;
-			}
-
-			rq = NULL;
-			break;
-		} else if (ret == BLKPREP_KILL) {
-			rq->cmd_flags |= REQ_QUIET;
-			__blk_end_request(rq, -EIO, blk_rq_bytes(rq));
-		} else {
-			printk(KERN_ERR "%s: bad return=%d\n", __func__, ret);
-			break;
-		}
-	}
-
-	return rq;
-}
-EXPORT_SYMBOL(elv_next_request);
-
-void elv_dequeue_request(struct request_queue *q, struct request *rq)
-{
-	BUG_ON(list_empty(&rq->queuelist));
-	BUG_ON(ELV_ON_HASH(rq));
-
-	list_del_init(&rq->queuelist);
-
-	/*
-	 * the time frame between a request being removed from the lists
-	 * and to it is freed is accounted as io that is in progress at
-	 * the driver side.
-	 */
-	if (blk_account_rq(rq))
-		q->in_flight++;
-}
-
 int elv_queue_empty(struct request_queue *q)
 {
 	struct elevator_queue *e = q->elevator;
-- 
1.6.0.2

