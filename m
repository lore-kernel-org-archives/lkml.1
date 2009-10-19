Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbZJSUVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbZJSUVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 16:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757333AbZJSUVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 16:21:47 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:43514 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZJSUVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 16:21:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=L2hS0rGf8bLFtplY/2bNJDzCXek2dCKfWNxZaLRGztzznAHY7Ew6ywuZ2/8BeNxyPt
         dspPuXwtYZ7IIb+lTry9wa17gCMSp58ZKYqVcgzBJ0OYS+Y/e8cRqIJ8jYEdar2OL3et
         rFxXlVtBd2RXmM1WPRaPaqNxqIW+ftS/F5HiU=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [RFC PATCH 5/5] cfq-iosched: fairness for sync no-idle queues
Date: Mon, 19 Oct 2009 22:21:43 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910192221.43562.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently no-idle queues in cfq are not serviced fairly:
even if they can only dispatch a small number of requests at a time,
they have to compete with idling queues to be serviced, experiencing
large latencies.

We should notice, instead, that no-idle queues are the ones that would
benefit most from having low latency, in fact they are any of:
* processes with large think times (e.g. interactive ones like file
  managers)
* seeky (e.g. programs faulting in their code at startup)
* or marked as no-idle from upper levels, to improve latencies of those
  requests.

This patch improves the fairness and latency for those queues, by:
* separating sync idle, sync no-idle and async queues in separate
  service_trees, for each priority
* service all no-idle queues together
* and idling when the last no-idle queue has been serviced, to
  anticipate for more no-idle work
* the timeslices allotted for idle and no-idle service_trees are
  computed proportionally to the number of processes in each set.

Servicing all no-idle queues together should have a performance boost
for NCQ-capable drives, without compromising fairness.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |  166 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 141 insertions(+), 25 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index c6dbefc..1fe1a2c 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -127,6 +127,12 @@ enum wl_prio_t {
 	RT_WL = 1
 };
 
+enum wl_type_t {
+	ASYNC_WL = 0,
+	SYNC_NOIDLE_WL = 1,
+	SYNC_WL = 2
+};
+
 /*
  * Per block device queue structure
  */
@@ -136,10 +142,12 @@ struct cfq_data {
 	/*
 	 * rr list of queues with requests and the count of them
 	 */
-	struct cfq_rb_root service_trees[2];
+	struct cfq_rb_root service_trees[2][3];
 	struct cfq_rb_root service_tree_idle;
 
 	enum wl_prio_t serving_prio;
+	enum wl_type_t serving_type;
+	unsigned long workload_expires;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -202,10 +210,11 @@ struct cfq_data {
 };
 
 static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
+					enum wl_type_t type,
 					struct cfq_data *cfqd)
 {
 	return prio == IDLE_WL ? &cfqd->service_tree_idle :
-		&cfqd->service_trees[prio];
+		&cfqd->service_trees[prio][type];
 }
 
 enum cfqq_state_flags {
@@ -252,10 +261,16 @@ CFQ_CFQQ_FNS(coop);
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
+#define CIC_SEEK_THR	(8 * 1024)
+#define CIC_SEEKY(cic)	((cic)->seek_mean > CIC_SEEK_THR)
+#define CFQQ_SEEKY(cfqq) (!cfqq->cic || CIC_SEEKY(cfqq->cic))
+
 static inline int cfq_busy_queues_wl(enum wl_prio_t wl, struct cfq_data *cfqd)
 {
 	return wl == IDLE_WL ? cfqd->service_tree_idle.count :
-		cfqd->service_trees[wl].count;
+		cfqd->service_trees[wl][ASYNC_WL].count
+		+ cfqd->service_trees[wl][SYNC_NOIDLE_WL].count
+		+ cfqd->service_trees[wl][SYNC_WL].count;
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
@@ -350,7 +365,7 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
 	if (cfqd->cfq_latency) {
 		unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
-		unsigned process_thr = cfqd->cfq_target_latency
+		unsigned process_thr = cfq_target_latency
 			/ cfqd->cfq_slice[1];
 		if (iq > process_thr) {
 			unsigned low_slice = 2 * slice * cfqd->cfq_slice_idle
@@ -564,7 +579,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 			rb_key += jiffies;
 	} else if (!add_front) {
 		enum wl_prio_t prio = cfq_class_rt(cfqq) ? RT_WL : BE_WL;
-		service_tree = service_tree_for(prio, cfqd);
+		enum wl_type_t type = cfq_cfqq_sync(cfqq) ? SYNC_WL : ASYNC_WL;
+		if (type == SYNC_WL && (CFQQ_SEEKY(cfqq) ||
+					!cfq_cfqq_idle_window(cfqq)))
+			type = SYNC_NOIDLE_WL;
+		service_tree = service_tree_for(prio, type, cfqd);
 		/*
 		 * Get our rb key offset. Subtract any residual slice
 		 * value carried from last service. A negative resid
@@ -576,7 +595,11 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		cfqq->slice_resid = 0;
 	} else {
 		enum wl_prio_t prio = cfq_class_rt(cfqq) ? RT_WL : BE_WL;
-		service_tree = service_tree_for(prio, cfqd);
+		enum wl_type_t type = cfq_cfqq_sync(cfqq) ? SYNC_WL : ASYNC_WL;
+		if (type == SYNC_WL && (CFQQ_SEEKY(cfqq) ||
+					!cfq_cfqq_idle_window(cfqq)))
+			type = SYNC_NOIDLE_WL;
+		service_tree = service_tree_for(prio, type, cfqd);
 		rb_key = -HZ;
 		__cfqq = cfq_rb_first(service_tree);
 		rb_key += __cfqq ? __cfqq->rb_key : jiffies;
@@ -990,7 +1013,7 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_prio, cfqd);
+		service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd);
 
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
@@ -1022,9 +1045,6 @@ static inline sector_t cfq_dist_from_last(struct cfq_data *cfqd,
 		return cfqd->last_position - blk_rq_pos(rq);
 }
 
-#define CIC_SEEK_THR	8 * 1024
-#define CIC_SEEKY(cic)	((cic)->seek_mean > CIC_SEEK_THR)
-
 static inline int cfq_rq_close(struct cfq_data *cfqd, struct request *rq)
 {
 	struct cfq_io_context *cic = cfqd->active_cic;
@@ -1128,8 +1148,14 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	if (cfq_cfqq_idle_window(cfqq))
 		return true;
 	{
-		enum wl_prio_t prio = cfq_class_rt(cfqq) ? RT_WL : BE_WL;
-		struct cfq_rb_root *service_tree = service_tree_for(prio, cfqd);
+		struct cfq_rb_root *service_tree = cfqq->service_tree;
+		if (!service_tree) {
+			enum wl_prio_t prio =
+				cfq_class_rt(cfqq) ? RT_WL : BE_WL;
+			enum wl_type_t type =
+				cfq_cfqq_sync(cfqq) ? SYNC_NOIDLE_WL : ASYNC_WL;
+			service_tree = service_tree_for(prio, type, cfqd);
+		}
 		return service_tree->count == 0 ||
 			(service_tree->count == 1
 			 && cfq_rb_first(service_tree) == cfqq);
@@ -1183,14 +1209,20 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 
 	cfq_mark_cfqq_wait_request(cfqq);
 
-	/*
-	 * we don't want to idle for seeks, but we do want to allow
-	 * fair distribution of slice time for a process doing back-to-back
-	 * seeks. so allow a little bit of time for him to submit a new rq
-	 */
 	sl = cfqd->cfq_slice_idle;
-	if (sample_valid(cic->seek_samples) && CIC_SEEKY(cic))
+	/* are we servicing noidle tree, and there are more queues?
+	 * non-rotational or NCQ: no idle
+	 * non-NCQ rotational : very small idle, to allow
+	 *     fair distribution of slice time for a process doing back-to-back
+	 *     seeks.
+	 */
+	if (cfqd->serving_type == SYNC_NOIDLE_WL &&
+	    service_tree_for(cfqd->serving_prio, SYNC_NOIDLE_WL, cfqd)
+		->count > 0) {
+		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
+			return;
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
+	}
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
@@ -1248,6 +1280,29 @@ cfq_prio_to_maxrq(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	return 2 * (base_rq + base_rq * (CFQ_PRIO_LISTS - 1 - cfqq->ioprio));
 }
 
+enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio)
+{
+	struct cfq_queue *queues[3];
+	int i;
+	unsigned long lowest_key = 0;
+	enum wl_type_t cur_best = SYNC_NOIDLE_WL;
+	for (i = 0; i < 3; ++i) {
+		queues[i] = cfq_rb_first(service_tree_for(prio, i, cfqd));
+		if (queues[i]) {
+			lowest_key = queues[i]->rb_key;
+			cur_best = i;
+		}
+	}
+	for (i = 0; i < 3; ++i) {
+		if (queues[i] && time_before(queues[i]->rb_key, lowest_key)) {
+			lowest_key = queues[i]->rb_key;
+			cur_best = i;
+		}
+	}
+
+	return cur_best;
+}
+
 /*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
@@ -1298,13 +1353,67 @@ expire:
 	cfq_slice_expired(cfqd, 0);
 new_queue:
 	if (!new_cfqq) {
+		enum wl_prio_t previous_prio = cfqd->serving_prio;
+
 		if (cfq_busy_queues_wl(RT_WL, cfqd))
 			cfqd->serving_prio = RT_WL;
 		else if (cfq_busy_queues_wl(BE_WL, cfqd))
 			cfqd->serving_prio = BE_WL;
-		else
+		else {
 			cfqd->serving_prio = IDLE_WL;
+			cfqd->workload_expires = jiffies + 1;
+		}
+
+		if (cfqd->serving_prio != IDLE_WL) {
+			int counts[] = {
+				service_tree_for(cfqd->serving_prio,
+						 ASYNC_WL, cfqd)->count,
+				service_tree_for(cfqd->serving_prio,
+						 SYNC_NOIDLE_WL, cfqd)->count,
+				service_tree_for(cfqd->serving_prio,
+						 SYNC_WL, cfqd)->count
+			};
+			int nonzero_counts = !!counts[0] + !!counts[1]
+				+ !!counts[2];
+
+			if (previous_prio != cfqd->serving_prio ||
+			    (nonzero_counts == 1)) {
+				cfqd->serving_type = counts[1] ? SYNC_NOIDLE_WL
+					: counts[2] ? SYNC_WL : ASYNC_WL;
+			} else {
+				if (!counts[cfqd->serving_type] ||
+				    time_after(jiffies, cfqd->workload_expires))
+					cfqd->serving_type = cfq_choose_wl
+						(cfqd, cfqd->serving_prio);
+				else
+					goto same_wl;
+			}
+
+			{
+				unsigned slice = cfq_target_latency;
+				slice = slice * counts[cfqd->serving_type] /
+					max_t(unsigned, cfqd->busy_queues_avg
+						[cfqd->serving_prio],
+					      counts[SYNC_WL] +
+						counts[SYNC_NOIDLE_WL] +
+						counts[ASYNC_WL]);
+
+				if (cfqd->serving_type == ASYNC_WL)
+					slice = max(1U, slice
+						* cfqd->cfq_slice[0]
+						/ cfqd->cfq_slice[1]);
+				else {
+					unsigned slice_min =
+						2 * cfqd->cfq_slice_idle;
+					slice = max(slice, slice_min);
+					slice = max_t(unsigned, slice,
+						      CFQ_MIN_TT);
+				}
+				cfqd->workload_expires = jiffies + slice;
+			}
+		}
 	}
+ same_wl:
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
 	return cfqq;
@@ -1331,10 +1440,12 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
-	int i;
+	int i, j;
 	for (i = 0; i < 2; ++i)
-		while ((cfqq = cfq_rb_first(&cfqd->service_trees[i])) != NULL)
-			dispatched += __cfq_forced_dispatch_cfqq(cfqq);
+		for (j = 0; j < 3; ++j)
+			while ((cfqq = cfq_rb_first(&cfqd->service_trees[i][j]))
+				!= NULL)
+				dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
 	while ((cfqq = cfq_rb_first(&cfqd->service_tree_idle)) != NULL)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
@@ -2086,7 +2197,7 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfqd->cfq_latency && cfqd->hw_tag && CIC_SEEKY(cic)))
+	    (sample_valid(cic->seek_samples) && CIC_SEEKY(cic)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
 		unsigned int slice_idle = cfqd->cfq_slice_idle;
@@ -2130,6 +2241,10 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (cfq_class_idle(cfqq))
 		return true;
 
+	if (cfqd->serving_type == SYNC_NOIDLE_WL
+	    && new_cfqq->service_tree == cfqq->service_tree)
+		return true;
+
 	/*
 	 * if the new request is sync, but the currently running queue is
 	 * not, let the sync request have priority.
@@ -2577,14 +2692,15 @@ static void cfq_exit_queue(struct elevator_queue *e)
 static void *cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
-	int i;
+	int i, j;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
 		return NULL;
 
 	for (i = 0; i < 2; ++i)
-		cfqd->service_trees[i] = CFQ_RB_ROOT;
+		for (j = 0; j < 3; ++j)
+			cfqd->service_trees[i][j] = CFQ_RB_ROOT;
 	cfqd->service_tree_idle = CFQ_RB_ROOT;
 
 	/*
-- 
1.6.2.5


