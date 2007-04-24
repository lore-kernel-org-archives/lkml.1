Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbXDXIVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbXDXIVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbXDXIUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:20:45 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41242 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590AbXDXIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:40 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/15] cfq-iosched: rework the whole round-robin list concept
Date: Tue, 24 Apr 2007 10:15:32 +0200
Message-Id: <11774025433141-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Drawing on some inspiration from the CFS CPU scheduler design, overhaul
the pending cfq_queue concept list management. Currently CFQ uses a
doubly linked list per priority level for sorting and service uses.
Kill those lists and maintain an rbtree of cfq_queue's, sorted by when
to service them.

This unfortunately means that the ionice levels aren't as strong
anymore, will work on improving those later. We only scale the slice
time now, not the number of times we service. This means that latency
is better (for all priority levels), but that the distinction between
the highest and lower levels aren't as big.

The diffstat speaks for itself.

 cfq-iosched.c |  363 +++++++++++++++++---------------------------------
 1 file changed, 125 insertions(+), 238 deletions(-)

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |  361 +++++++++++++++++---------------------------------
 1 files changed, 123 insertions(+), 238 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 04fea76..ad29a99 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -26,7 +26,16 @@ static int cfq_slice_async = HZ / 25;
 static const int cfq_slice_async_rq = 2;
 static int cfq_slice_idle = HZ / 125;
 
+/*
+ * grace period before allowing idle class to get disk access
+ */
 #define CFQ_IDLE_GRACE		(HZ / 10)
+
+/*
+ * below this threshold, we consider thinktime immediate
+ */
+#define CFQ_MIN_TT		(2)
+
 #define CFQ_SLICE_SCALE		(5)
 
 #define CFQ_KEY_ASYNC		(0)
@@ -69,10 +78,9 @@ struct cfq_data {
 	/*
 	 * rr list of queues with requests and the count of them
 	 */
-	struct list_head rr_list[CFQ_PRIO_LISTS];
+	struct rb_root service_tree;
 	struct list_head cur_rr;
 	struct list_head idle_rr;
-	unsigned long cur_rr_tick;
 	unsigned int busy_queues;
 
 	/*
@@ -91,8 +99,6 @@ struct cfq_data {
 
 	struct cfq_queue *active_queue;
 	struct cfq_io_context *active_cic;
-	int cur_prio, cur_end_prio;
-	unsigned long prio_time;
 	unsigned int dispatch_slice;
 
 	struct timer_list idle_class_timer;
@@ -131,8 +137,10 @@ struct cfq_queue {
 	unsigned int key;
 	/* member of the rr/busy/cur/idle cfqd list */
 	struct list_head cfq_list;
-	/* in what tick we were last serviced */
-	unsigned long rr_tick;
+	/* service_tree member */
+	struct rb_node rb_node;
+	/* service_tree key */
+	unsigned long rb_key;
 	/* sorted list of pending requests */
 	struct rb_root sort_list;
 	/* if fifo isn't expired, next request to serve */
@@ -147,8 +155,6 @@ struct cfq_queue {
 	struct list_head fifo;
 
 	unsigned long slice_end;
-	unsigned long service_last;
-	unsigned long slice_start;
 	long slice_resid;
 
 	/* number of requests that are on the dispatch list or inside driver */
@@ -240,30 +246,26 @@ static inline pid_t cfq_queue_pid(struct task_struct *task, int rw, int is_sync)
  * if a queue is marked sync and has sync io queued. A sync queue with async
  * io only, should not get full sync slice length.
  */
-static inline int
-cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+static inline int cfq_prio_slice(struct cfq_data *cfqd, int sync,
+				 unsigned short prio)
 {
-	const int base_slice = cfqd->cfq_slice[cfq_cfqq_sync(cfqq)];
+	const int base_slice = cfqd->cfq_slice[sync];
 
-	WARN_ON(cfqq->ioprio >= IOPRIO_BE_NR);
+	WARN_ON(prio >= IOPRIO_BE_NR);
+
+	return base_slice + (base_slice/CFQ_SLICE_SCALE * (4 - prio));
+}
 
-	return base_slice + (base_slice/CFQ_SLICE_SCALE * (4 - cfqq->ioprio));
+static inline int
+cfq_prio_to_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
+{
+	return cfq_prio_slice(cfqd, cfq_cfqq_sync(cfqq), cfqq->ioprio);
 }
 
 static inline void
 cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	cfqq->slice_end = cfq_prio_to_slice(cfqd, cfqq) + jiffies;
-	cfqq->slice_end += cfqq->slice_resid;
-
-	/*
-	 * Don't carry over residual for more than one slice, we only want
-	 * to slightly correct the fairness. Carrying over forever would
-	 * easily introduce oscillations.
-	 */
-	cfqq->slice_resid = 0;
-
-	cfqq->slice_start = jiffies;
 }
 
 /*
@@ -403,33 +405,50 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return cfq_choose_req(cfqd, next, prev);
 }
 
-/*
- * This function finds out where to insert a BE queue in the service hierarchy
- */
-static void cfq_resort_be_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq,
-				int preempted)
+static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
+				      struct cfq_queue *cfqq)
 {
-	if (!cfq_cfqq_sync(cfqq))
-		list_add_tail(&cfqq->cfq_list, &cfqd->rr_list[cfqq->ioprio]);
-	else {
-		struct list_head *n = &cfqd->rr_list[cfqq->ioprio];
+	/*
+	 * just an approximation, should be ok.
+	 */
+	return ((cfqd->busy_queues - 1) * cfq_prio_slice(cfqd, 1, 0));
+}
+
+static void cfq_service_tree_add(struct cfq_data *cfqd,
+				    struct cfq_queue *cfqq)
+{
+	struct rb_node **p = &cfqd->service_tree.rb_node;
+	struct rb_node *parent = NULL;
+	struct cfq_queue *__cfqq;
+	unsigned long rb_key;
+
+	rb_key = cfq_slice_offset(cfqd, cfqq) + jiffies;
+	rb_key += cfqq->slice_resid;
+	cfqq->slice_resid = 0;
 
+	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
 		/*
-		 * sort by last service, but don't cross a new or async
-		 * queue. we don't cross a new queue because it hasn't
-		 * been service before, and we don't cross an async
-		 * queue because it gets added to the end on expire.
+		 * same position, nothing more to do
 		 */
-		while ((n = n->prev) != &cfqd->rr_list[cfqq->ioprio]) {
-			struct cfq_queue *__c = list_entry_cfqq(n);
+		if (rb_key == cfqq->rb_key)
+			return;
 
-			if (!cfq_cfqq_sync(__c) || !__c->service_last)
-				break;
-			if (time_before(__c->service_last, cfqq->service_last))
-				break;
-		}
-		list_add(&cfqq->cfq_list, n);
+		rb_erase(&cfqq->rb_node, &cfqd->service_tree);
 	}
+
+	while (*p) {
+		parent = *p;
+		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
+
+		if (rb_key < __cfqq->rb_key)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	cfqq->rb_key = rb_key;
+	rb_link_node(&cfqq->rb_node, parent, p);
+	rb_insert_color(&cfqq->rb_node, &cfqd->service_tree);
 }
 
 static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
@@ -443,7 +462,7 @@ static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 	if (!cfq_cfqq_on_rr(cfqq))
 		return;
 
-	list_del(&cfqq->cfq_list);
+	list_del_init(&cfqq->cfq_list);
 
 	if (cfq_class_rt(cfqq)) {
 		/*
@@ -465,7 +484,7 @@ static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 		/*
 		 * So we get here, ergo the queue is a regular best-effort queue
 		 */
-		cfq_resort_be_queue(cfqd, cfqq, preempted);
+		cfq_service_tree_add(cfqd, cfqq);
 	}
 }
 
@@ -490,6 +509,11 @@ cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	cfq_clear_cfqq_on_rr(cfqq);
 	list_del_init(&cfqq->cfq_list);
 
+	if (!RB_EMPTY_NODE(&cfqq->rb_node)) {
+		rb_erase(&cfqq->rb_node, &cfqd->service_tree);
+		RB_CLEAR_NODE(&cfqq->rb_node);
+	}
+
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
 }
@@ -678,7 +702,6 @@ __cfq_set_active_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		cfq_clear_cfqq_fifo_expire(cfqq);
 		cfq_mark_cfqq_slice_new(cfqq);
 		cfq_clear_cfqq_queue_new(cfqq);
-		cfqq->rr_tick = cfqd->cur_rr_tick;
 	}
 
 	cfqd->active_queue = cfqq;
@@ -726,114 +749,19 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, int preempted,
 		__cfq_slice_expired(cfqd, cfqq, preempted, timed_out);
 }
 
-/*
- * 0
- * 0,1
- * 0,1,2
- * 0,1,2,3
- * 0,1,2,3,4
- * 0,1,2,3,4,5
- * 0,1,2,3,4,5,6
- * 0,1,2,3,4,5,6,7
- */
-static int cfq_get_next_prio_level(struct cfq_data *cfqd)
-{
-	int prio, wrap;
-
-	prio = -1;
-	wrap = 0;
-	do {
-		int p;
-
-		for (p = cfqd->cur_prio; p <= cfqd->cur_end_prio; p++) {
-			if (!list_empty(&cfqd->rr_list[p])) {
-				prio = p;
-				break;
-			}
-		}
-
-		if (prio != -1)
-			break;
-		cfqd->cur_prio = 0;
-		if (++cfqd->cur_end_prio == CFQ_PRIO_LISTS) {
-			cfqd->cur_end_prio = 0;
-			if (wrap)
-				break;
-			wrap = 1;
-		}
-	} while (1);
-
-	if (unlikely(prio == -1))
-		return -1;
-
-	BUG_ON(prio >= CFQ_PRIO_LISTS);
-
-	list_splice_init(&cfqd->rr_list[prio], &cfqd->cur_rr);
-
-	cfqd->cur_prio = prio + 1;
-	if (cfqd->cur_prio > cfqd->cur_end_prio) {
-		cfqd->cur_end_prio = cfqd->cur_prio;
-		cfqd->cur_prio = 0;
-	}
-	if (cfqd->cur_end_prio == CFQ_PRIO_LISTS) {
-		cfqd->cur_prio = 0;
-		cfqd->cur_end_prio = 0;
-	}
-
-	cfqd->cur_rr_tick++;
-	cfqd->prio_time = jiffies;
-	return prio;
-}
-
-static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
-					  struct request *rq)
-{
-	if (rq->sector >= cfqd->last_position)
-		return rq->sector - cfqd->last_position;
-	else
-		return cfqd->last_position - rq->sector;
-}
-
-static struct cfq_queue *cfq_get_best_queue(struct cfq_data *cfqd)
-{
-	struct cfq_queue *cfqq = NULL, *__cfqq;
-	sector_t best = -1, first = -1, dist;
-
-	list_for_each_entry(__cfqq, &cfqd->cur_rr, cfq_list) {
-		if (!__cfqq->next_rq || !cfq_cfqq_sync(__cfqq))
-			continue;
-
-		dist = cfq_dist_from_last(cfqd, __cfqq->next_rq);
-		if (first == -1)
-			first = dist;
-		if (dist < best) {
-			best = dist;
-			cfqq = __cfqq;
-		}
-	}
-
-	/*
-	 * Only async queue(s) available, grab first entry. Do the same
-	 * if the difference between the first and best isn't more than
-	 * twice, to obey fairness.
-	 */
-	if (!cfqq || (best && first != best && ((first / best) < 4)))
-		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
-
-	return cfqq;
-}
-
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = NULL;
 
-	if (!list_empty(&cfqd->cur_rr) || cfq_get_next_prio_level(cfqd) != -1) {
+	if (!list_empty(&cfqd->cur_rr)) {
 		/*
-		 * if current list is non-empty, grab first entry. if it is
-		 * empty, get next prio level and grab first entry then if any
-		 * are spliced
+		 * if current list is non-empty, grab first entry.
 		 */
-		cfqq = cfq_get_best_queue(cfqd);
+		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
+	} else if (!RB_EMPTY_ROOT(&cfqd->service_tree)) {
+		struct rb_node *n = rb_first(&cfqd->service_tree);
+
+		cfqq = rb_entry(n, struct cfq_queue, rb_node);
 	} else if (!list_empty(&cfqd->idle_rr)) {
 		/*
 		 * if we have idle queues and no rt or be queues had pending
@@ -855,27 +783,20 @@ static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
 
-	do {
-		long prio;
-
-		cfqq = cfq_get_next_queue(cfqd);
-		if (!cfqq)
-			break;
-
-		prio = cfq_prio_to_slice(cfqd, cfqq);
-		if (cfqq->slice_resid > -prio)
-			break;
-
-		cfqq->slice_resid += prio;
-		list_del_init(&cfqq->cfq_list);
-		list_add_tail(&cfqq->cfq_list, &cfqd->rr_list[cfqq->ioprio]);
-		cfqq = NULL;
-	} while (1);
-
+	cfqq = cfq_get_next_queue(cfqd);
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
 
+static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
+					  struct request *rq)
+{
+	if (rq->sector >= cfqd->last_position)
+		return rq->sector - cfqd->last_position;
+	else
+		return cfqd->last_position - rq->sector;
+}
+
 static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
 {
 	struct cfq_io_context *cic = cfqd->active_cic;
@@ -886,45 +807,15 @@ static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
 	return cfq_dist_from_last(cfqd, rq) <= cic->seek_mean;
 }
 
-static struct cfq_queue *__cfq_close_cooperator(struct cfq_data *cfqd,
-						struct cfq_queue *cur_cfqq,
-						struct list_head *list)
-{
-	struct cfq_queue *cfqq;
-
-	list_for_each_entry(cfqq, list, cfq_list) {
-		if (cfqq == cur_cfqq || !cfq_cfqq_sync(cfqq))
-			continue;
-
-		BUG_ON(!cfqq->next_rq);
-
-		if (cfq_rq_close(cfqd, cfqq->next_rq))
-			return cfqq;
-	}
-
-	return NULL;
-}
-
-static int cfq_close_cooperator(struct cfq_data *cfqd,
-				struct cfq_queue *cur_cfqq)
+static int cfq_close_cooperator(struct cfq_data *cfq_data,
+				struct cfq_queue *cfqq)
 {
-	struct cfq_queue *cfqq;
-
-	if (!cfqd->busy_queues)
-		return 0;
-
 	/*
-	 * check cur_rr and same-prio rr_list for candidates
+	 * We should notice if some of the queues are cooperating, eg
+	 * working closely on the same area of the disk. In that case,
+	 * we can group them together and don't waste time idling.
 	 */
-	cfqq = __cfq_close_cooperator(cfqd, cur_cfqq, &cfqd->cur_rr);
-	if (cfqq)
-		return 1;
-
-	cfqq = __cfq_close_cooperator(cfqd, cur_cfqq, &cfqd->rr_list[cur_cfqq->ioprio]);
-	if (cfqq && (cfqq->rr_tick == cfqd->cur_rr_tick))
-		cfqq = NULL;
-
-	return cfqq != NULL;
+	return 0;
 }
 
 #define CIC_SEEKY(cic) ((cic)->seek_mean > (8 * 1024))
@@ -968,7 +859,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 */
 	sl = cfqd->cfq_slice_idle;
 	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
-		sl = min(sl, msecs_to_jiffies(2));
+		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 }
@@ -1109,31 +1000,41 @@ __cfq_dispatch_requests(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return dispatched;
 }
 
-static int
-cfq_forced_dispatch_cfqqs(struct list_head *list)
+static inline int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
+{
+	int dispatched = 0;
+
+	while (cfqq->next_rq) {
+		cfq_dispatch_insert(cfqq->cfqd->queue, cfqq->next_rq);
+		dispatched++;
+	}
+
+	BUG_ON(!list_empty(&cfqq->fifo));
+	return dispatched;
+}
+
+static int cfq_forced_dispatch_cfqqs(struct list_head *list)
 {
 	struct cfq_queue *cfqq, *next;
 	int dispatched;
 
 	dispatched = 0;
-	list_for_each_entry_safe(cfqq, next, list, cfq_list) {
-		while (cfqq->next_rq) {
-			cfq_dispatch_insert(cfqq->cfqd->queue, cfqq->next_rq);
-			dispatched++;
-		}
-		BUG_ON(!list_empty(&cfqq->fifo));
-	}
+	list_for_each_entry_safe(cfqq, next, list, cfq_list)
+		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
 	return dispatched;
 }
 
-static int
-cfq_forced_dispatch(struct cfq_data *cfqd)
+static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
-	int i, dispatched = 0;
+	int dispatched = 0;
+	struct rb_node *n;
+
+	while ((n = rb_first(&cfqd->service_tree)) != NULL) {
+		struct cfq_queue *cfqq = rb_entry(n, struct cfq_queue, rb_node);
 
-	for (i = 0; i < CFQ_PRIO_LISTS; i++)
-		dispatched += cfq_forced_dispatch_cfqqs(&cfqd->rr_list[i]);
+		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+	}
 
 	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->cur_rr);
 	dispatched += cfq_forced_dispatch_cfqqs(&cfqd->idle_rr);
@@ -1145,8 +1046,7 @@ cfq_forced_dispatch(struct cfq_data *cfqd)
 	return dispatched;
 }
 
-static int
-cfq_dispatch_requests(request_queue_t *q, int force)
+static int cfq_dispatch_requests(request_queue_t *q, int force)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
 	struct cfq_queue *cfqq;
@@ -1216,7 +1116,6 @@ static void cfq_put_queue(struct cfq_queue *cfqq)
 	/*
 	 * it's on the empty list and still hashed
 	 */
-	list_del(&cfqq->cfq_list);
 	hlist_del(&cfqq->cfq_hash);
 	kmem_cache_free(cfq_pool, cfqq);
 }
@@ -1385,8 +1284,6 @@ static void cfq_init_prio_data(struct cfq_queue *cfqq)
 	 */
 	cfqq->org_ioprio = cfqq->ioprio;
 	cfqq->org_ioprio_class = cfqq->ioprio_class;
-
-	cfq_resort_rr_list(cfqq, 0);
 	cfq_clear_cfqq_prio_changed(cfqq);
 }
 
@@ -1472,6 +1369,7 @@ retry:
 
 		INIT_HLIST_NODE(&cfqq->cfq_hash);
 		INIT_LIST_HEAD(&cfqq->cfq_list);
+		RB_CLEAR_NODE(&cfqq->rb_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
 		cfqq->key = key;
@@ -1746,7 +1644,8 @@ static void cfq_preempt_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * so we know that it will be selected next.
 	 */
 	BUG_ON(!cfq_cfqq_on_rr(cfqq));
-	list_move(&cfqq->cfq_list, &cfqd->cur_rr);
+	list_del_init(&cfqq->cfq_list);
+	list_add(&cfqq->cfq_list, &cfqd->cur_rr);
 
 	cfqq->slice_end = 0;
 	cfq_mark_cfqq_slice_new(cfqq);
@@ -1828,13 +1727,10 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
 	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
 	cfqq->dispatched--;
-	cfqq->service_last = now;
 
 	if (!cfq_class_idle(cfqq))
 		cfqd->last_end_request = now;
 
-	cfq_resort_rr_list(cfqq, 0);
-
 	if (sync)
 		RQ_CIC(rq)->last_end_request = now;
 
@@ -1863,9 +1759,6 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
  */
 static void cfq_prio_boost(struct cfq_queue *cfqq)
 {
-	const int ioprio_class = cfqq->ioprio_class;
-	const int ioprio = cfqq->ioprio;
-
 	if (has_fs_excl()) {
 		/*
 		 * boost idle prio on transactions that would lock out other
@@ -1884,12 +1777,6 @@ static void cfq_prio_boost(struct cfq_queue *cfqq)
 		if (cfqq->ioprio != cfqq->org_ioprio)
 			cfqq->ioprio = cfqq->org_ioprio;
 	}
-
-	/*
-	 * refile between round-robin lists if we moved the priority class
-	 */
-	if ((ioprio_class != cfqq->ioprio_class || ioprio != cfqq->ioprio))
-		cfq_resort_rr_list(cfqq, 0);
 }
 
 static inline int __cfq_may_queue(struct cfq_queue *cfqq)
@@ -2127,9 +2014,7 @@ static void *cfq_init_queue(request_queue_t *q)
 
 	memset(cfqd, 0, sizeof(*cfqd));
 
-	for (i = 0; i < CFQ_PRIO_LISTS; i++)
-		INIT_LIST_HEAD(&cfqd->rr_list[i]);
-
+	cfqd->service_tree = RB_ROOT;
 	INIT_LIST_HEAD(&cfqd->cur_rr);
 	INIT_LIST_HEAD(&cfqd->idle_rr);
 	INIT_LIST_HEAD(&cfqd->cic_list);
-- 
1.5.1.1.190.g74474

