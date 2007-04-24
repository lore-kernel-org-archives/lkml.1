Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbXDXIUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbXDXIUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXDXIUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41272 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031037AbXDXIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:43 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 8/15] cfq-iosched: style cleanups and comments
Date: Tue, 24 Apr 2007 10:15:36 +0200
Message-Id: <11774025432951-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |   66 ++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e6cc77f..f86ff4d 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -222,7 +222,7 @@ CFQ_CFQQ_FNS(slice_new);
 
 static struct cfq_queue *cfq_find_cfq_hash(struct cfq_data *, unsigned int, unsigned short);
 static void cfq_dispatch_insert(request_queue_t *, struct request *);
-static struct cfq_queue *cfq_get_queue(struct cfq_data *cfqd, unsigned int key, struct task_struct *tsk, gfp_t gfp_mask);
+static struct cfq_queue *cfq_get_queue(struct cfq_data *, unsigned int, struct task_struct *, gfp_t);
 
 /*
  * scheduler run of queue, if there are requests pending and no one in the
@@ -389,6 +389,9 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
 	}
 }
 
+/*
+ * The below is leftmost cache rbtree addon
+ */
 static struct rb_node *cfq_rb_first(struct cfq_rb_root *root)
 {
 	if (root->left)
@@ -442,13 +445,18 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 	return ((cfqd->busy_queues - 1) * cfq_prio_slice(cfqd, 1, 0));
 }
 
+/*
+ * The cfqd->service_tree holds all pending cfq_queue's that have
+ * requests waiting to be processed. It is sorted in the order that
+ * we will service the queues.
+ */
 static void cfq_service_tree_add(struct cfq_data *cfqd,
 				    struct cfq_queue *cfqq)
 {
 	struct rb_node **p = &cfqd->service_tree.rb.rb_node;
 	struct rb_node *parent = NULL;
 	unsigned long rb_key;
-	int left = 1;
+	int left;
 
 	rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
 	rb_key += cfqq->slice_resid;
@@ -464,6 +472,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 		cfq_rb_erase(&cfqq->rb_node, &cfqd->service_tree);
 	}
 
+	left = 1;
 	while (*p) {
 		struct cfq_queue *__cfqq;
 		struct rb_node **n;
@@ -503,17 +512,16 @@ static void cfq_service_tree_add(struct cfq_data *cfqd,
 	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree.rb);
 }
 
+/*
+ * Update cfqq's position in the service tree.
+ */
 static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 {
-	struct cfq_data *cfqd = cfqq->cfqd;
-
 	/*
 	 * Resorting requires the cfqq to be on the RR list already.
 	 */
-	if (!cfq_cfqq_on_rr(cfqq))
-		return;
-
-	cfq_service_tree_add(cfqd, cfqq);
+	if (cfq_cfqq_on_rr(cfqq))
+		cfq_service_tree_add(cfqq->cfqd, cfqq);
 }
 
 /*
@@ -530,6 +538,10 @@ cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_resort_rr_list(cfqq, 0);
 }
 
+/*
+ * Called when the cfqq no longer has requests pending, remove it from
+ * the service tree.
+ */
 static inline void
 cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
@@ -648,8 +660,7 @@ static void cfq_remove_request(struct request *rq)
 	}
 }
 
-static int
-cfq_merge(request_queue_t *q, struct request **req, struct bio *bio)
+static int cfq_merge(request_queue_t *q, struct request **req, struct bio *bio)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct request *__rq;
@@ -775,6 +786,10 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, int preempted,
 		__cfq_slice_expired(cfqd, cfqq, preempted, timed_out);
 }
 
+/*
+ * Get next queue for service. Unless we have a queue preemption,
+ * we'll simply select the first cfqq in the service tree.
+ */
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = NULL;
@@ -786,10 +801,11 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
 	} else if (!RB_EMPTY_ROOT(&cfqd->service_tree.rb)) {
 		struct rb_node *n = cfq_rb_first(&cfqd->service_tree);
-		unsigned long end;
 
 		cfqq = rb_entry(n, struct cfq_queue, rb_node);
 		if (cfq_class_idle(cfqq)) {
+			unsigned long end;
+
 			/*
 			 * if we have idle queues and no rt or be queues had
 			 * pending requests, either allow immediate service if
@@ -807,6 +823,9 @@ static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 	return cfqq;
 }
 
+/*
+ * Get and set a new active queue for service.
+ */
 static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
@@ -892,6 +911,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 }
 
+/*
+ * Move request from internal lists to the request queue dispatch list.
+ */
 static void cfq_dispatch_insert(request_queue_t *q, struct request *rq)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
@@ -938,7 +960,8 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 }
 
 /*
- * get next queue for service
+ * Select a queue for service. If we have a current active queue,
+ * check whether to continue servicing it, or retrieve and set a new one.
  */
 static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 {
@@ -979,6 +1002,10 @@ keep_queue:
 	return cfqq;
 }
 
+/*
+ * Dispatch some requests from cfqq, moving them to the request queue
+ * dispatch list.
+ */
 static int
 __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			int max_dispatch)
@@ -1053,6 +1080,10 @@ static int cfq_forced_dispatch_cfqqs(struct list_head *list)
 	return dispatched;
 }
 
+/*
+ * Drain our current requests. Used for barriers and when switching
+ * io schedulers on-the-fly.
+ */
 static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
 	int dispatched = 0;
@@ -1218,10 +1249,6 @@ static void __cfq_exit_single_io_context(struct cfq_data *cfqd,
 	}
 }
 
-
-/*
- * Called with interrupts disabled
- */
 static void cfq_exit_single_io_context(struct cfq_io_context *cic)
 {
 	struct cfq_data *cfqd = cic->key;
@@ -1235,6 +1262,10 @@ static void cfq_exit_single_io_context(struct cfq_io_context *cic)
 	}
 }
 
+/*
+ * The process that ioc belongs to has exited, we need to clean up
+ * and put the internal structures we have that belongs to that process.
+ */
 static void cfq_exit_io_context(struct io_context *ioc)
 {
 	struct cfq_io_context *__cic;
@@ -1421,6 +1452,9 @@ out:
 	return cfqq;
 }
 
+/*
+ * We drop cfq io contexts lazily, so we may find a dead one.
+ */
 static void
 cfq_drop_dead_cic(struct io_context *ioc, struct cfq_io_context *cic)
 {
-- 
1.5.1.1.190.g74474

