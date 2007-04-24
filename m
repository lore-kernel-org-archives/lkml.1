Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbXDXIR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbXDXIR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754094AbXDXIQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:16:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24140 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbXDXIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:16:40 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/15] cfq-iosched: development update
Date: Tue, 24 Apr 2007 10:15:30 +0200
Message-Id: <11774025433719-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.1.1.190.g74474
In-Reply-To: <11774025432481-git-send-email-jens.axboe@oracle.com>
References: <11774025432481-git-send-email-jens.axboe@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

- Implement logic for detecting cooperating processes, so we
  choose the best available queue whenever possible.

- Improve residual slice time accounting.

- Remove dead code: we no longer see async requests coming in on
  sync queues. That part was removed a long time ago. That means
  that we can also remove the difference between cfq_cfqq_sync()
  and cfq_cfqq_class_sync(), they are now indentical. And we can
  kill the on_dispatch array, just make it a counter.

- Allow a process to go into the current list, if it hasn't been
  serviced in this scheduler tick yet.

Possible future improvements including caching the cfqq lookup
in cfq_close_cooperator(), so we don't have to look it up twice.
cfq_get_best_queue() should just use that last decision instead
of doing it again.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/cfq-iosched.c |  381 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 261 insertions(+), 120 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a683d00..3883ba8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -56,13 +56,7 @@ static struct completion *ioc_gone;
 #define ASYNC			(0)
 #define SYNC			(1)
 
-#define cfq_cfqq_dispatched(cfqq)	\
-	((cfqq)->on_dispatch[ASYNC] + (cfqq)->on_dispatch[SYNC])
-
-#define cfq_cfqq_class_sync(cfqq)	((cfqq)->key != CFQ_KEY_ASYNC)
-
-#define cfq_cfqq_sync(cfqq)		\
-	(cfq_cfqq_class_sync(cfqq) || (cfqq)->on_dispatch[SYNC])
+#define cfq_cfqq_sync(cfqq)	((cfqq)->key != CFQ_KEY_ASYNC)
 
 #define sample_valid(samples)	((samples) > 80)
 
@@ -79,6 +73,7 @@ struct cfq_data {
 	struct list_head busy_rr;
 	struct list_head cur_rr;
 	struct list_head idle_rr;
+	unsigned long cur_rr_tick;
 	unsigned int busy_queues;
 
 	/*
@@ -98,11 +93,12 @@ struct cfq_data {
 	struct cfq_queue *active_queue;
 	struct cfq_io_context *active_cic;
 	int cur_prio, cur_end_prio;
+	unsigned long prio_time;
 	unsigned int dispatch_slice;
 
 	struct timer_list idle_class_timer;
 
-	sector_t last_sector;
+	sector_t last_position;
 	unsigned long last_end_request;
 
 	/*
@@ -117,6 +113,9 @@ struct cfq_data {
 	unsigned int cfq_slice_idle;
 
 	struct list_head cic_list;
+
+	sector_t new_seek_mean;
+	u64 new_seek_total;
 };
 
 /*
@@ -133,6 +132,8 @@ struct cfq_queue {
 	unsigned int key;
 	/* member of the rr/busy/cur/idle cfqd list */
 	struct list_head cfq_list;
+	/* in what tick we were last serviced */
+	unsigned long rr_tick;
 	/* sorted list of pending requests */
 	struct rb_root sort_list;
 	/* if fifo isn't expired, next request to serve */
@@ -148,10 +149,11 @@ struct cfq_queue {
 
 	unsigned long slice_end;
 	unsigned long service_last;
+	unsigned long slice_start;
 	long slice_resid;
 
-	/* number of requests that are on the dispatch list */
-	int on_dispatch[2];
+	/* number of requests that are on the dispatch list or inside driver */
+	int dispatched;
 
 	/* io prio of this group */
 	unsigned short ioprio, org_ioprio;
@@ -159,6 +161,8 @@ struct cfq_queue {
 
 	/* various state flags, see below */
 	unsigned int flags;
+
+	sector_t last_request_pos;
 };
 
 enum cfqq_state_flags {
@@ -259,6 +263,8 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * easily introduce oscillations.
 	 */
 	cfqq->slice_resid = 0;
+
+	cfqq->slice_start = jiffies;
 }
 
 /*
@@ -307,7 +313,7 @@ cfq_choose_req(struct cfq_data *cfqd, struct request *rq1, struct request *rq2)
 	s1 = rq1->sector;
 	s2 = rq2->sector;
 
-	last = cfqd->last_sector;
+	last = cfqd->last_position;
 
 	/*
 	 * by definition, 1KiB is 2 sectors
@@ -398,39 +404,42 @@ cfq_find_next_rq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	return cfq_choose_req(cfqd, next, prev);
 }
 
-static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
+/*
+ * This function finds out where to insert a BE queue in the service hierarchy
+ */
+static void cfq_resort_be_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+				int preempted)
 {
-	struct cfq_data *cfqd = cfqq->cfqd;
 	struct list_head *list, *n;
 	struct cfq_queue *__cfqq;
+	int add_tail = 0;
 
 	/*
-	 * Resorting requires the cfqq to be on the RR list already.
+	 * if cfqq has requests in flight, don't allow it to be
+	 * found in cfq_set_active_queue before it has finished them.
+	 * this is done to increase fairness between a process that
+	 * has lots of io pending vs one that only generates one
+	 * sporadically or synchronously
 	 */
-	if (!cfq_cfqq_on_rr(cfqq))
-		return;
-
-	list_del(&cfqq->cfq_list);
-
-	if (cfq_class_rt(cfqq))
+	if (cfqq->dispatched)
+		list = &cfqd->busy_rr;
+	else if (cfqq->ioprio == (cfqd->cur_prio + 1) &&
+		 cfq_cfqq_sync(cfqq) &&
+		 (time_before(cfqd->prio_time, cfqq->service_last) ||
+		  cfq_cfqq_queue_new(cfqq) || preempted)) {
 		list = &cfqd->cur_rr;
-	else if (cfq_class_idle(cfqq))
-		list = &cfqd->idle_rr;
-	else {
+		add_tail = 1;
+	} else
+		list = &cfqd->rr_list[cfqq->ioprio];
+
+	if (!cfq_cfqq_sync(cfqq) || add_tail) {
 		/*
-		 * if cfqq has requests in flight, don't allow it to be
-		 * found in cfq_set_active_queue before it has finished them.
-		 * this is done to increase fairness between a process that
-		 * has lots of io pending vs one that only generates one
-		 * sporadically or synchronously
+		 * async queue always goes to the end. this wont be overly
+		 * unfair to writes, as the sort of the sync queue wont be
+		 * allowed to pass the async queue again.
 		 */
-		if (cfq_cfqq_dispatched(cfqq))
-			list = &cfqd->busy_rr;
-		else
-			list = &cfqd->rr_list[cfqq->ioprio];
-	}
-
-	if (preempted || cfq_cfqq_queue_new(cfqq)) {
+		list_add_tail(&cfqq->cfq_list, list);
+	} else if (preempted || cfq_cfqq_queue_new(cfqq)) {
 		/*
 		 * If this queue was preempted or is new (never been serviced),
 		 * let it be added first for fairness but beind other new
@@ -444,14 +453,7 @@ static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 
 			n = n->next;
 		}
-		list_add_tail(&cfqq->cfq_list, n);
-	} else if (!cfq_cfqq_class_sync(cfqq)) {
-		/*
-		 * async queue always goes to the end. this wont be overly
-		 * unfair to writes, as the sort of the sync queue wont be
-		 * allowed to pass the async queue again.
-		 */
-		list_add_tail(&cfqq->cfq_list, list);
+		list_add(&cfqq->cfq_list, n);
 	} else {
 		/*
 		 * sort by last service, but don't cross a new or async
@@ -461,17 +463,54 @@ static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
 		 */
 		n = list;
 		while ((n = n->prev) != list) {
-			struct cfq_queue *__cfqq = list_entry_cfqq(n);
+			struct cfq_queue *__c = list_entry_cfqq(n);
 
-			if (!cfq_cfqq_class_sync(cfqq) || !__cfqq->service_last)
+			if (!cfq_cfqq_sync(__c) || !__c->service_last)
 				break;
-			if (time_before(__cfqq->service_last, cfqq->service_last))
+			if (time_before(__c->service_last, cfqq->service_last))
 				break;
 		}
 		list_add(&cfqq->cfq_list, n);
 	}
 }
 
+static void cfq_resort_rr_list(struct cfq_queue *cfqq, int preempted)
+{
+	struct cfq_data *cfqd = cfqq->cfqd;
+	struct list_head *n;
+
+	/*
+	 * Resorting requires the cfqq to be on the RR list already.
+	 */
+	if (!cfq_cfqq_on_rr(cfqq))
+		return;
+
+	list_del(&cfqq->cfq_list);
+
+	if (cfq_class_rt(cfqq)) {
+		/*
+		 * At to the front of the current list, but behind other
+		 * RT queues.
+		 */
+		n = &cfqd->cur_rr;
+		while (n->next != &cfqd->cur_rr)
+			if (!cfq_class_rt(cfqq))
+				break;
+
+		list_add(&cfqq->cfq_list, n);
+	} else if (cfq_class_idle(cfqq)) {
+		/*
+		 * IDLE goes to the tail of the idle list
+		 */
+		list_add_tail(&cfqq->cfq_list, &cfqd->idle_rr);
+	} else {
+		/*
+		 * So we get here, ergo the queue is a regular best-effort queue
+		 */
+		cfq_resort_be_queue(cfqd, cfqq, preempted);
+	}
+}
+
 /*
  * add to busy list of queues for service, trying to be fair in ordering
  * the pending list according to last request service
@@ -573,6 +612,8 @@ static void cfq_activate_request(request_queue_t *q, struct request *rq)
 	 */
 	if (!cfqd->hw_tag && cfqd->rq_in_driver > 4)
 		cfqd->hw_tag = 1;
+
+	cfqd->last_position = rq->hard_sector + rq->hard_nr_sectors;
 }
 
 static void cfq_deactivate_request(request_queue_t *q, struct request *rq)
@@ -678,6 +719,7 @@ __cfq_set_active_queue(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		cfq_clear_cfqq_must_alloc_slice(cfqq);
 		cfq_clear_cfqq_fifo_expire(cfqq);
 		cfq_mark_cfqq_slice_new(cfqq);
+		cfqq->rr_tick = cfqd->cur_rr_tick;
 	}
 
 	cfqd->active_queue = cfqq;
@@ -780,10 +822,46 @@ static int cfq_get_next_prio_level(struct cfq_data *cfqd)
 		cfqd->cur_end_prio = 0;
 	}
 
+	cfqd->cur_rr_tick++;
+	cfqd->prio_time = jiffies;
 	return prio;
 }
 
-static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
+static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
+					  struct request *rq)
+{
+	if (rq->sector >= cfqd->last_position)
+		return rq->sector - cfqd->last_position;
+	else
+		return cfqd->last_position - rq->sector;
+}
+
+static struct cfq_queue *cfq_get_best_queue(struct cfq_data *cfqd)
+{
+	struct cfq_queue *cfqq = NULL, *__cfqq;
+	sector_t best = -1, dist;
+
+	list_for_each_entry(__cfqq, &cfqd->cur_rr, cfq_list) {
+		if (!__cfqq->next_rq || !cfq_cfqq_sync(__cfqq))
+			continue;
+
+		dist = cfq_dist_from_last(cfqd, __cfqq->next_rq);
+		if (dist < best) {
+			best = dist;
+			cfqq = __cfqq;
+		}
+	}
+
+	/*
+	 * Only async queue(s) available, grab first entry
+	 */
+	if (!cfqq)
+		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
+
+	return cfqq;
+}
+
+static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = NULL;
 
@@ -793,7 +871,7 @@ static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
 		 * empty, get next prio level and grab first entry then if any
 		 * are spliced
 		 */
-		cfqq = list_entry_cfqq(cfqd->cur_rr.next);
+		cfqq = cfq_get_best_queue(cfqd);
 	} else if (!list_empty(&cfqd->busy_rr)) {
 		/*
 		 * If no new queues are available, check if the busy list has
@@ -814,49 +892,128 @@ static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
 			mod_timer(&cfqd->idle_class_timer, end);
 	}
 
+	return cfqq;
+}
+
+static struct cfq_queue *cfq_set_active_queue(struct cfq_data *cfqd)
+{
+	struct cfq_queue *cfqq;
+
+	do {
+		long prio;
+
+		cfqq = cfq_get_next_queue(cfqd);
+		if (!cfqq)
+			break;
+
+		prio = cfq_prio_to_slice(cfqd, cfqq);
+		if (cfqq->slice_resid > -prio)
+			break;
+
+		cfqq->slice_resid += prio;
+		list_del_init(&cfqq->cfq_list);
+		list_add_tail(&cfqq->cfq_list, &cfqd->rr_list[cfqq->ioprio]);
+		cfqq = NULL;
+	} while (1);
+
 	__cfq_set_active_queue(cfqd, cfqq);
 	return cfqq;
 }
 
-#define CIC_SEEKY(cic) ((cic)->seek_mean > (128 * 1024))
+static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
+{
+	struct cfq_io_context *cic = cfqd->active_cic;
+
+	if (!sample_valid(cic->seek_samples))
+		return 0;
+
+	return cfq_dist_from_last(cfqd, rq) <= cic->seek_mean;
+}
+
+static struct cfq_queue *__cfq_close_cooperator(struct cfq_data *cfqd,
+						struct cfq_queue *cur_cfqq,
+						struct list_head *list)
+{
+	struct cfq_queue *cfqq;
+
+	list_for_each_entry(cfqq, list, cfq_list) {
+		if (cfqq == cur_cfqq || !cfq_cfqq_sync(cfqq))
+			continue;
+
+		BUG_ON(!cfqq->next_rq);
+
+		if (cfq_rq_close(cfqd, cfqq->next_rq))
+			return cfqq;
+	}
+
+	return NULL;
+}
+
+static int cfq_close_cooperator(struct cfq_data *cfqd,
+				struct cfq_queue *cur_cfqq)
+{
+	struct cfq_queue *cfqq;
+
+	if (!cfqd->busy_queues)
+		return 0;
+
+	/*
+	 * check cur_rr and same-prio rr_list for candidates
+	 */
+	cfqq = __cfq_close_cooperator(cfqd, cur_cfqq, &cfqd->cur_rr);
+	if (cfqq)
+		return 1;
+
+	cfqq = __cfq_close_cooperator(cfqd, cur_cfqq, &cfqd->rr_list[cur_cfqq->ioprio]);
+	if (cfqq && (cfqq->rr_tick == cfqd->cur_rr_tick))
+		cfqq = NULL;
+
+	return cfqq != NULL;
+}
+
+#define CIC_SEEKY(cic) ((cic)->seek_mean > (8 * 1024))
 
-static int cfq_arm_slice_timer(struct cfq_data *cfqd)
+static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq = cfqd->active_queue;
 	struct cfq_io_context *cic;
 	unsigned long sl;
 
 	WARN_ON(!RB_EMPTY_ROOT(&cfqq->sort_list));
+	WARN_ON(cfq_cfqq_slice_new(cfqq));
 
 	/*
 	 * idle is disabled, either manually or by past process history
 	 */
-	if (!cfqd->cfq_slice_idle)
-		return 0;
-	if (!cfq_cfqq_idle_window(cfqq))
-		return 0;
+	if (!cfqd->cfq_slice_idle || !cfq_cfqq_idle_window(cfqq))
+		return;
+
 	/*
 	 * task has exited, don't wait
 	 */
 	cic = cfqd->active_cic;
 	if (!cic || !cic->ioc->task)
-		return 0;
+		return;
+
+	/*
+	 * See if this prio level has a good candidate
+	 */
+	if (cfq_close_cooperator(cfqd, cfqq))
+		return;
 
 	cfq_mark_cfqq_must_dispatch(cfqq);
 	cfq_mark_cfqq_wait_request(cfqq);
 
-	sl = min(cfqq->slice_end - 1, (unsigned long) cfqd->cfq_slice_idle);
-
 	/*
 	 * we don't want to idle for seeks, but we do want to allow
 	 * fair distribution of slice time for a process doing back-to-back
 	 * seeks. so allow a little bit of time for him to submit a new rq
 	 */
+	sl = cfqd->cfq_slice_idle;
 	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
 		sl = min(sl, msecs_to_jiffies(2));
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
-	return 1;
 }
 
 static void cfq_dispatch_insert(request_queue_t *q, struct request *rq)
@@ -864,7 +1021,7 @@ static void cfq_dispatch_insert(request_queue_t *q, struct request *rq)
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
 
 	cfq_remove_request(rq);
-	cfqq->on_dispatch[rq_is_sync(rq)]++;
+	cfqq->dispatched++;
 	elv_dispatch_sort(q, rq);
 }
 
@@ -885,13 +1042,13 @@ static inline struct request *cfq_check_fifo(struct cfq_queue *cfqq)
 	if (list_empty(&cfqq->fifo))
 		return NULL;
 
-	fifo = cfq_cfqq_class_sync(cfqq);
+	fifo = cfq_cfqq_sync(cfqq);
 	rq = rq_entry_fifo(cfqq->fifo.next);
 
-	if (time_after(jiffies, rq->start_time + cfqd->cfq_fifo_expire[fifo]))
-		return rq;
+	if (time_before(jiffies, rq->start_time + cfqd->cfq_fifo_expire[fifo]))
+		return NULL;
 
-	return NULL;
+	return rq;
 }
 
 static inline int
@@ -916,23 +1073,26 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 		goto new_queue;
 
 	/*
-	 * slice has expired
+	 * The active queue has run out of time, expire it and select new.
 	 */
-	if (!cfq_cfqq_must_dispatch(cfqq) && cfq_slice_used(cfqq))
+	if (cfq_slice_used(cfqq))
 		goto expire;
 
 	/*
-	 * if queue has requests, dispatch one. if not, check if
-	 * enough slice is left to wait for one
+	 * The active queue has requests and isn't expired, allow it to
+	 * dispatch.
 	 */
 	if (!RB_EMPTY_ROOT(&cfqq->sort_list))
 		goto keep_queue;
-	else if (cfq_cfqq_slice_new(cfqq) || cfq_cfqq_dispatched(cfqq)) {
+
+	/*
+	 * No requests pending. If the active queue still has requests in
+	 * flight or is idling for a new request, allow either of these
+	 * conditions to happen (or time out) before selecting a new queue.
+	 */
+	if (cfqq->dispatched || timer_pending(&cfqd->idle_slice_timer)) {
 		cfqq = NULL;
 		goto keep_queue;
-	} else if (cfq_cfqq_class_sync(cfqq)) {
-		if (cfq_arm_slice_timer(cfqd))
-			return NULL;
 	}
 
 expire:
@@ -1033,7 +1193,7 @@ static int
 cfq_dispatch_requests(request_queue_t *q, int force)
 {
 	struct cfq_data *cfqd = q->elevator->elevator_data;
-	struct cfq_queue *cfqq, *prev_cfqq;
+	struct cfq_queue *cfqq;
 	int dispatched;
 
 	if (!cfqd->busy_queues)
@@ -1043,23 +1203,19 @@ cfq_dispatch_requests(request_queue_t *q, int force)
 		return cfq_forced_dispatch(cfqd);
 
 	dispatched = 0;
-	prev_cfqq = NULL;
 	while ((cfqq = cfq_select_queue(cfqd)) != NULL) {
 		int max_dispatch;
 
 		if (cfqd->busy_queues > 1) {
 			/*
-			 * Don't repeat dispatch from the previous queue.
-			 */
-			if (prev_cfqq == cfqq)
-				break;
-
-			/*
 			 * So we have dispatched before in this round, if the
 			 * next queue has idling enabled (must be sync), don't
-			 * allow it service until the previous have continued.
+			 * allow it service until the previous have completed.
 			 */
-			if (cfqd->rq_in_driver && cfq_cfqq_idle_window(cfqq))
+			if (cfqd->rq_in_driver && cfq_cfqq_idle_window(cfqq) &&
+			    dispatched)
+				break;
+			if (cfqq->dispatched >= cfqd->cfq_quantum)
 				break;
 		}
 
@@ -1072,7 +1228,6 @@ cfq_dispatch_requests(request_queue_t *q, int force)
 			max_dispatch = 1;
 
 		dispatched += __cfq_dispatch_requests(cfqd, cfqq, max_dispatch);
-		prev_cfqq = cfqq;
 	}
 
 	return dispatched;
@@ -1514,7 +1669,8 @@ cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_io_context *cic)
 }
 
 static void
-cfq_update_io_seektime(struct cfq_io_context *cic, struct request *rq)
+cfq_update_io_seektime(struct cfq_data *cfqd, struct cfq_io_context *cic,
+		       struct request *rq)
 {
 	sector_t sdist;
 	u64 total;
@@ -1524,6 +1680,11 @@ cfq_update_io_seektime(struct cfq_io_context *cic, struct request *rq)
 	else
 		sdist = cic->last_request_pos - rq->sector;
 
+	if (!cic->seek_samples) {
+		cfqd->new_seek_total = (7*cic->seek_total + (u64)256*sdist) / 8;
+		cfqd->new_seek_mean = cfqd->new_seek_total / 256;
+	}
+
 	/*
 	 * Don't allow the seek distance to get too large from the
 	 * odd fragment, pagein, etc
@@ -1574,13 +1735,16 @@ static int
 cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 		   struct request *rq)
 {
-	struct cfq_queue *cfqq = cfqd->active_queue;
-	sector_t dist;
+	struct cfq_queue *cfqq;
 
-	if (cfq_class_idle(new_cfqq))
+	cfqq = cfqd->active_queue;
+	if (!cfqq)
 		return 0;
 
-	if (!cfqq)
+	if (cfq_slice_used(cfqq))
+		return 1;
+
+	if (cfq_class_idle(new_cfqq))
 		return 0;
 
 	if (cfq_class_idle(cfqq))
@@ -1607,12 +1771,7 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	 * if this request is as-good as one we would expect from the
 	 * current cfqq, let it preempt
 	 */
-	if (rq->sector > cfqd->last_sector)
-		dist = rq->sector - cfqd->last_sector;
-	else
-		dist = cfqd->last_sector - rq->sector;
-
-	if (dist <= cfqd->active_cic->seek_mean)
+	if (cfq_rq_close(cfqd, rq))
 		return 1;
 
 	return 0;
@@ -1656,28 +1815,12 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->next_rq = cfq_choose_req(cfqd, cfqq->next_rq, rq);
 	BUG_ON(!cfqq->next_rq);
 
-	/*
-	 * we never wait for an async request and we don't allow preemption
-	 * of an async request. so just return early
-	 */
-	if (!rq_is_sync(rq)) {
-		/*
-		 * sync process issued an async request, if it's waiting
-		 * then expire it and kick rq handling.
-		 */
-		if (cic == cfqd->active_cic &&
-		    del_timer(&cfqd->idle_slice_timer)) {
-			cfq_slice_expired(cfqd, 0, 0);
-			blk_start_queueing(cfqd->queue);
-		}
-		return;
-	}
-
 	cfq_update_io_thinktime(cfqd, cic);
-	cfq_update_io_seektime(cic, rq);
+	cfq_update_io_seektime(cfqd, cic, rq);
 	cfq_update_idle_window(cfqd, cfqq, cic);
 
 	cic->last_request_pos = rq->sector + rq->nr_sectors;
+	cfqq->last_request_pos = cic->last_request_pos;
 
 	if (cfqq == cfqd->active_queue) {
 		/*
@@ -1726,13 +1869,11 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
 	now = jiffies;
 
 	WARN_ON(!cfqd->rq_in_driver);
-	WARN_ON(!cfqq->on_dispatch[sync]);
+	WARN_ON(!cfqq->dispatched);
 	cfqd->rq_in_driver--;
-	cfqq->on_dispatch[sync]--;
+	cfqq->dispatched--;
 	cfqq->service_last = now;
 
-	cfqd->last_sector = rq->hard_sector + rq->hard_nr_sectors;
-
 	if (!cfq_class_idle(cfqq))
 		cfqd->last_end_request = now;
 
@@ -1752,11 +1893,12 @@ static void cfq_completed_request(request_queue_t *q, struct request *rq)
 		}
 		if (cfq_slice_used(cfqq))
 			cfq_slice_expired(cfqd, 0, 1);
-		else if (sync && RB_EMPTY_ROOT(&cfqq->sort_list)) {
-			if (!cfq_arm_slice_timer(cfqd))
-				cfq_schedule_dispatch(cfqd);
-		}
+		else if (sync && RB_EMPTY_ROOT(&cfqq->sort_list))
+			cfq_arm_slice_timer(cfqd);
 	}
+
+	if (!cfqd->rq_in_driver)
+		cfq_schedule_dispatch(cfqd);
 }
 
 /*
@@ -2101,7 +2243,6 @@ fail:
 /*
  * sysfs parts below -->
  */
-
 static ssize_t
 cfq_var_show(unsigned int var, char *page)
 {
-- 
1.5.1.1.190.g74474

