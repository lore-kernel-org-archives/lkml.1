Return-Path: <linux-kernel-owner+w=401wt.eu-S1754097AbZJZVp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbZJZVp3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZJZVp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:45:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:40711 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZJZVpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=es7SFII78KK5N/Ahu1tB11rCmhmikO17gwXsZYq5LGA55hd0Ccx5uooDPSNYqyQx2g
         WOLbApw3xKJ3izqeKmR7yXimk3FpTjcNRkb/KxdoOyMOiP54LOANc0rVvO1JIdtCLyOj
         NVEoFADDddTEKvLmMwR6VXYSoKo9POUtOa7BU=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 5/5] cfq-iosched: fairness for sync no-idle queues
Date: Mon, 26 Oct 2009 22:45:29 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910262245.29793.czoccolo@gmail.com>
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
 block/cfq-iosched.c |  200 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 168 insertions(+), 32 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3fa65ea..6e9b395 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -134,7 +134,7 @@ struct cfq_queue {
 };
 
 /*
- * Index in the service_trees.
+ * First index in the service_trees.
  * IDLE is handled separately, so it has negative index
  */
 enum wl_prio_t {
@@ -144,6 +144,16 @@ enum wl_prio_t {
 };
 
 /*
+ * Second index in the service_trees.
+ */
+enum wl_type_t {
+	ASYNC_WORKLOAD = 0,
+	SYNC_NOIDLE_WORKLOAD = 1,
+	SYNC_WORKLOAD = 2
+};
+
+
+/*
  * Per block device queue structure
  */
 struct cfq_data {
@@ -153,12 +163,14 @@ struct cfq_data {
 	 * rr lists of queues with requests, onle rr for each priority class.
 	 * Counts are embedded in the cfq_rb_root
 	 */
-	struct cfq_rb_root service_trees[2];
+	struct cfq_rb_root service_trees[2][3];
 	struct cfq_rb_root service_tree_idle;
 	/*
 	 * The priority currently being served
 	 */
 	enum wl_prio_t serving_prio;
+	enum wl_type_t serving_type;
+	unsigned long workload_expires;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -221,12 +233,13 @@ struct cfq_data {
 };
 
 static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
+					    enum wl_type_t type,
 					    struct cfq_data *cfqd)
 {
 	if (prio == IDLE_WORKLOAD)
 		return &cfqd->service_tree_idle;
 
-	return &cfqd->service_trees[prio];
+	return &cfqd->service_trees[prio][type];
 }
 
 enum cfqq_state_flags {
@@ -282,12 +295,24 @@ static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
 	return BE_WORKLOAD;
 }
 
+
+static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
+{
+	if (!cfq_cfqq_sync(cfqq))
+		return ASYNC_WORKLOAD;
+	if (!cfq_cfqq_idle_window(cfqq))
+		return SYNC_NOIDLE_WORKLOAD;
+	return SYNC_WORKLOAD;
+}
+
 static inline int cfq_busy_queues_wl(enum wl_prio_t wl, struct cfq_data *cfqd)
 {
 	if (wl == IDLE_WORKLOAD)
 		return cfqd->service_tree_idle.count;
 
-	return cfqd->service_trees[wl].count;
+	return cfqd->service_trees[wl][ASYNC_WORKLOAD].count
+		+ cfqd->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
+		+ cfqd->service_trees[wl][SYNC_WORKLOAD].count;
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
@@ -597,7 +622,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_rb_root *service_tree;
 	int left;
 
-	service_tree = service_tree_for(cfqq_prio(cfqq), cfqd);
+	service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
@@ -1030,7 +1055,7 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_prio, cfqd);
+		service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd);
 
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
@@ -1165,7 +1190,7 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	enum wl_prio_t prio = cfqq_prio(cfqq);
-	struct cfq_rb_root *service_tree;
+	struct cfq_rb_root *service_tree = cfqq->service_tree;
 
 	/* We never do for idle class queues. */
 	if (prio == IDLE_WORKLOAD)
@@ -1179,7 +1204,9 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	service_tree = service_tree_for(prio, cfqd);
+	if (!service_tree)
+		service_tree = service_tree_for(prio, cfqq_type(cfqq), cfqd);
+
 	if (service_tree->count == 0)
 		return true;
 
@@ -1233,14 +1260,20 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 
 	cfq_mark_cfqq_wait_request(cfqq);
 
-	/*
-	 * we don't want to idle for seeks, but we do want to allow
-	 * fair distribution of slice time for a process doing back-to-back
-	 * seeks. so allow a little bit of time for him to submit a new rq
-	 */
 	sl = cfqd->cfq_slice_idle;
-	if (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq))
+	/* are we servicing noidle tree, and there are more queues?
+	 * non-rotational or NCQ: no idle
+	 * non-NCQ rotational : very small idle, to allow
+	 *     fair distribution of slice time for a process doing back-to-back
+	 *     seeks.
+	 */
+	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
+	    service_tree_for(cfqd->serving_prio, SYNC_NOIDLE_WORKLOAD, cfqd)
+		->count > 0) {
+		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
+			return;
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
+	}
 
 	mod_timer(&cfqd->idle_slice_timer, jiffies + sl);
 	cfq_log_cfqq(cfqd, cfqq, "arm_idle: %lu", sl);
@@ -1344,6 +1377,106 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
+static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
+				    bool prio_changed)
+{
+	struct cfq_queue *queue;
+	int i;
+	bool key_valid = false;
+	unsigned long lowest_key = 0;
+	enum wl_type_t cur_best = SYNC_NOIDLE_WORKLOAD;
+
+	if (prio_changed) {
+		/*
+		 * When priorities switched, we prefer starting
+		 * from SYNC_NOIDLE (first choice), or just SYNC
+		 * over ASYNC
+		 */
+		if (service_tree_for(prio, cur_best, cfqd)->count)
+			return cur_best;
+		cur_best = SYNC_WORKLOAD;
+		if (service_tree_for(prio, cur_best, cfqd)->count)
+			return cur_best;
+
+		return ASYNC_WORKLOAD;
+	}
+
+	for (i = 0; i < 3; ++i) {
+		/* otherwise, select the one with lowest rb_key */
+		queue = cfq_rb_first(service_tree_for(prio, i, cfqd));
+		if (queue &&
+		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
+			lowest_key = queue->rb_key;
+			cur_best = i;
+			key_valid = true;
+		}
+	}
+
+	return cur_best;
+}
+
+static void choose_service_tree(struct cfq_data *cfqd)
+{
+	enum wl_prio_t previous_prio = cfqd->serving_prio;
+	bool prio_changed;
+	unsigned slice;
+	unsigned count;
+
+	/* Choose next priority. RT > BE > IDLE */
+	if (cfq_busy_queues_wl(RT_WORKLOAD, cfqd))
+		cfqd->serving_prio = RT_WORKLOAD;
+	else if (cfq_busy_queues_wl(BE_WORKLOAD, cfqd))
+		cfqd->serving_prio = BE_WORKLOAD;
+	else {
+		cfqd->serving_prio = IDLE_WORKLOAD;
+		cfqd->workload_expires = jiffies + 1;
+		return;
+	}
+
+	/*
+	 * For RT and BE, we have to choose also the type
+	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
+	 * expiration time
+	 */
+	prio_changed = (cfqd->serving_prio != previous_prio);
+	count = service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd)
+		->count;
+
+	/*
+	 * If priority didn't change, check workload expiration,
+	 * and that we still have other queues ready
+	 */
+	if (!prio_changed && count &&
+	    !time_after(jiffies, cfqd->workload_expires))
+		return;
+
+	/* otherwise select new workload type */
+	cfqd->serving_type =
+		cfq_choose_wl(cfqd, cfqd->serving_prio, prio_changed);
+	count = service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd)
+		->count;
+
+	/*
+	 * the workload slice is computed as a fraction of target latency
+	 * proportional to the number of queues in that workload, over
+	 * all the queues in the same priority class
+	 */
+	slice = cfq_target_latency * count /
+		max_t(unsigned, cfqd->busy_queues_avg[cfqd->serving_prio],
+		      cfq_busy_queues_wl(cfqd->serving_prio, cfqd));
+
+	if (cfqd->serving_type == ASYNC_WORKLOAD)
+		/* async workload slice is scaled down according to
+		 * the sync/async slice ratio. */
+		slice = slice * cfqd->cfq_slice[0] / cfqd->cfq_slice[1];
+	else
+		/* sync workload slice is at least 2 * cfq_slice_idle */
+		slice = max(slice, 2 * cfqd->cfq_slice_idle);
+
+	slice = max_t(unsigned, slice, CFQ_MIN_TT);
+	cfqd->workload_expires = jiffies + slice;
+}
+
 /*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
@@ -1396,14 +1529,13 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 expire:
 	cfq_slice_expired(cfqd, 0);
 new_queue:
-	if (!new_cfqq) {
-		if (cfq_busy_queues_wl(RT_WORKLOAD, cfqd))
-			cfqd->serving_prio = RT_WORKLOAD;
-		else if (cfq_busy_queues_wl(BE_WORKLOAD, cfqd))
-			cfqd->serving_prio = BE_WORKLOAD;
-		else
-			cfqd->serving_prio = IDLE_WORKLOAD;
-	}
+	/*
+	 * Current queue expired. Check if we have to switch to a new
+	 * service tree
+	 */
+	if (!new_cfqq)
+		choose_service_tree(cfqd);
+
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
 	return cfqq;
@@ -1430,10 +1562,12 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
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
@@ -2216,13 +2350,10 @@ cfq_update_idle_window(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	enable_idle = old_idle = cfq_cfqq_idle_window(cfqq);
 
 	if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
-	    (!cfqd->cfq_latency && cfqd->hw_tag && CFQQ_SEEKY(cfqq)))
+	    (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
 	else if (sample_valid(cic->ttime_samples)) {
-		unsigned int slice_idle = cfqd->cfq_slice_idle;
-		if (sample_valid(cfqq->seek_samples) && CFQQ_SEEKY(cfqq))
-			slice_idle = msecs_to_jiffies(CFQ_MIN_TT);
-		if (cic->ttime_mean > slice_idle)
+		if (cic->ttime_mean > cfqd->cfq_slice_idle)
 			enable_idle = 0;
 		else
 			enable_idle = 1;
@@ -2260,6 +2391,10 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 	if (cfq_class_idle(cfqq))
 		return true;
 
+	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD
+	    && new_cfqq->service_tree == cfqq->service_tree)
+		return true;
+
 	/*
 	 * if the new request is sync, but the currently running queue is
 	 * not, let the sync request have priority.
@@ -2764,14 +2899,15 @@ static void cfq_exit_queue(struct elevator_queue *e)
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


