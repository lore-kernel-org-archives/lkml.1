Return-Path: <linux-kernel-owner+w=401wt.eu-S1763323AbZLPWz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763323AbZLPWz2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbZLPWzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:55:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757134AbZLPWzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:55:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, lizf@cn.fujitsu.com, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 4/4] cfq-iosched: Implement system wide RT and IDLE groups
Date: Wed, 16 Dec 2009 17:53:00 -0500
Message-Id: <1261003980-10115-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
References: <1261003980-10115-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This is the core patch which implements system wide RT and IDLE groups
  and automatically moves idle and RT tasks in those groups irrespective
  of the cgroup they belong to.

  This is just proof of concept patch boot tested only.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  313 +++++++++++++++++++++++++++++++--------------------
 1 files changed, 190 insertions(+), 123 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 8df4fe5..c6235d5 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -178,21 +178,23 @@ struct cfq_group {
 	unsigned int weight;
 	bool on_st;
 
+	/* Group's prio class (RT, BE, IDLE) */
+	enum wl_prio_t prio_class;
+
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
 	/* Per group busy queus average. Useful for workload slice calc. */
-	unsigned int busy_queues_avg[2];
+	unsigned int busy_queues_avg;
 	/*
-	 * rr lists of queues with requests, onle rr for each priority class.
-	 * Counts are embedded in the cfq_rb_root
+	 * rr lists of cfq queues with requests, One service tree each for
+	 * each kind of workload (sync-idle, sync-noidle, async). Counts are
+	 * embedded in the cfq_rb_root.
 	 */
-	struct cfq_rb_root service_trees[2][3];
-	struct cfq_rb_root service_tree_idle;
+	struct cfq_rb_root service_trees[3];
 
 	unsigned long saved_workload_slice;
 	enum wl_type_t saved_workload;
-	enum wl_prio_t saved_serving_prio;
 	struct blkio_group blkg;
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
 	struct hlist_node cfqd_node;
@@ -206,11 +208,11 @@ struct cfq_group {
 struct cfq_data {
 	struct request_queue *queue;
 	/* Root service tree for cfq_groups */
-	struct cfq_rb_root grp_service_tree;
-	struct cfq_group root_group;
+	struct cfq_rb_root grp_service_trees[3];
+	struct cfq_group root_groups[3];
 
 	/*
-	 * The priority currently being served
+	 * The workload currently being served
 	 */
 	enum wl_prio_t serving_prio;
 	enum wl_type_t serving_type;
@@ -290,17 +292,17 @@ struct cfq_data {
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
 
-static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
-					    enum wl_prio_t prio,
-					    enum wl_type_t type)
+static struct cfq_rb_root *
+service_tree_for(struct cfq_group *cfqg, enum wl_type_t type)
 {
 	if (!cfqg)
 		return NULL;
 
-	if (prio == IDLE_WORKLOAD)
-		return &cfqg->service_tree_idle;
+	/* For idle class group, always use first service tree */
+	if (cfqg->prio_class == IDLE_WORKLOAD)
+		return &cfqg->service_trees[0];
 
-	return &cfqg->service_trees[prio][type];
+	return &cfqg->service_trees[type];
 }
 
 enum cfqq_state_flags {
@@ -365,14 +367,9 @@ CFQ_CFQQ_FNS(wait_busy);
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
 /* Traverses through cfq group service trees */
-#define for_each_cfqg_st(cfqg, i, j, st) \
-	for (i = 0; i <= IDLE_WORKLOAD; i++) \
-		for (j = 0, st = i < IDLE_WORKLOAD ? &cfqg->service_trees[i][j]\
-			: &cfqg->service_tree_idle; \
-			(i < IDLE_WORKLOAD && j <= SYNC_WORKLOAD) || \
-			(i == IDLE_WORKLOAD && j == 0); \
-			j++, st = i < IDLE_WORKLOAD ? \
-			&cfqg->service_trees[i][j]: NULL) \
+#define for_each_cfqg_st(cfqg, i, st) \
+	for (i = 0, st = &cfqg->service_trees[i]; \
+		i <= SYNC_WORKLOAD && (st = &cfqg->service_trees[i]); i++) \
 
 
 static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
@@ -394,23 +391,18 @@ static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
 	return SYNC_WORKLOAD;
 }
 
-static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
-					struct cfq_data *cfqd,
-					struct cfq_group *cfqg)
+static inline int
+cfq_group_busy_queues(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	if (wl == IDLE_WORKLOAD)
-		return cfqg->service_tree_idle.count;
-
-	return cfqg->service_trees[wl][ASYNC_WORKLOAD].count
-		+ cfqg->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
-		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
+	return cfqg->service_trees[ASYNC_WORKLOAD].count
+		+ cfqg->service_trees[SYNC_NOIDLE_WORKLOAD].count
+		+ cfqg->service_trees[SYNC_WORKLOAD].count;
 }
 
-static inline int cfqg_busy_async_queues(struct cfq_data *cfqd,
-					struct cfq_group *cfqg)
+static inline int
+cfqg_busy_async_queues(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	return cfqg->service_trees[RT_WORKLOAD][ASYNC_WORKLOAD].count
-		+ cfqg->service_trees[BE_WORKLOAD][ASYNC_WORKLOAD].count;
+	return cfqg->service_trees[ASYNC_WORKLOAD].count;
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
@@ -531,30 +523,30 @@ static void update_min_vdisktime(struct cfq_rb_root *st)
 }
 
 /*
- * get averaged number of queues of RT/BE priority.
- * average is updated, with a formula that gives more weight to higher numbers,
- * to quickly follows sudden increases and decrease slowly
+ * get averaged number of queues in the group. average is updated, with a
+ * formula that gives more weight to higher numbers, to quickly follows sudden
+ * increases and decrease slowly.
  */
 
-static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
-					struct cfq_group *cfqg, bool rt)
+static inline unsigned
+cfq_group_get_avg_queues(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	unsigned min_q, max_q;
 	unsigned mult  = cfq_hist_divisor - 1;
 	unsigned round = cfq_hist_divisor / 2;
-	unsigned busy = cfq_group_busy_queues_wl(rt, cfqd, cfqg);
+	unsigned busy = cfq_group_busy_queues(cfqd, cfqg);
 
-	min_q = min(cfqg->busy_queues_avg[rt], busy);
-	max_q = max(cfqg->busy_queues_avg[rt], busy);
-	cfqg->busy_queues_avg[rt] = (mult * max_q + min_q + round) /
+	min_q = min(cfqg->busy_queues_avg, busy);
+	max_q = max(cfqg->busy_queues_avg, busy);
+	cfqg->busy_queues_avg = (mult * max_q + min_q + round) /
 		cfq_hist_divisor;
-	return cfqg->busy_queues_avg[rt];
+	return cfqg->busy_queues_avg;
 }
 
 static inline unsigned
 cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_service_trees[cfqg->prio_class];
 
 	return cfq_target_latency * cfqg->weight / st->total_weight;
 }
@@ -568,8 +560,7 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 		 * interested queues (we consider only the ones with the same
 		 * priority class in the cfq group)
 		 */
-		unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,
-						cfq_class_rt(cfqq));
+		unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg);
 		unsigned sync_slice = cfqd->cfq_slice[1];
 		unsigned expect_latency = sync_slice * iq;
 		unsigned group_slice = cfq_group_slice(cfqd, cfqq->cfqg);
@@ -817,7 +808,7 @@ __cfq_group_service_tree_add(struct cfq_rb_root *st, struct cfq_group *cfqg)
 static void
 cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_service_trees[cfqg->prio_class];
 	struct cfq_group *__cfqg;
 	struct rb_node *n;
 
@@ -845,7 +836,7 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 static void
 cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_service_trees[cfqg->prio_class];
 
 	if (st->active == &cfqg->rb_node)
 		st->active = NULL;
@@ -897,10 +888,9 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 				struct cfq_queue *cfqq)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+	struct cfq_rb_root *st = &cfqd->grp_service_trees[cfqg->prio_class];
 	unsigned int used_sl, charge_sl;
-	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg)
-			- cfqg->service_tree_idle.count;
+	int nr_sync = cfqg->nr_cfqq - cfqg_busy_async_queues(cfqd, cfqg);
 
 	BUG_ON(nr_sync < 0);
 	used_sl = charge_sl = cfq_cfqq_slice_usage(cfqq);
@@ -918,7 +908,6 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 		cfqg->saved_workload_slice = cfqd->workload_expires
 						- jiffies;
 		cfqg->saved_workload = cfqd->serving_type;
-		cfqg->saved_serving_prio = cfqd->serving_prio;
 	} else
 		cfqg->saved_workload_slice = 0;
 
@@ -948,7 +937,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
 	struct cfq_group *cfqg = NULL;
 	void *key = cfqd;
-	int i, j;
+	int i;
 	struct cfq_rb_root *st;
 	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
 	unsigned int major, minor;
@@ -966,9 +955,10 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
 		goto done;
 
 	cfqg->weight = blkcg->weight;
-	for_each_cfqg_st(cfqg, i, j, st)
+	for_each_cfqg_st(cfqg, i, st)
 		*st = CFQ_RB_ROOT;
 	RB_CLEAR_NODE(&cfqg->rb_node);
+	cfqg->prio_class = BE_WORKLOAD;
 
 	/*
 	 * Take the initial reference that will be released on destroy
@@ -999,12 +989,35 @@ static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
 	struct cgroup *cgroup;
 	struct cfq_group *cfqg = NULL;
+	struct task_struct *tsk = current;
+	int ioprio_class = IOPRIO_CLASS_NONE;
+
+	/*
+	 * If task belongs to RT or IDLE class, statically assign it to root
+	 * rt or idle group respectively.
+	 */
+	if (tsk->io_context)
+		ioprio_class = IOPRIO_PRIO_CLASS(tsk->io_context->ioprio);
+
+	if (ioprio_class == IOPRIO_CLASS_NONE)
+		/*
+		 * no prio set, inherit CPU scheduling settings
+		 */
+		ioprio_class = task_nice_ioclass(tsk);
+
+	switch (ioprio_class) {
+	case IOPRIO_CLASS_RT:
+		return &cfqd->root_groups[RT_WORKLOAD];
+	case IOPRIO_CLASS_IDLE:
+		return &cfqd->root_groups[IDLE_WORKLOAD];
+	}
 
+	/* Its a BE class task. Find alloc group */
 	rcu_read_lock();
 	cgroup = task_cgroup(current, blkio_subsys_id);
 	cfqg = cfq_find_alloc_cfqg(cfqd, cgroup, create);
 	if (!cfqg && create)
-		cfqg = &cfqd->root_group;
+		cfqg = &cfqd->root_groups[BE_WORKLOAD];
 	rcu_read_unlock();
 	return cfqg;
 }
@@ -1013,7 +1026,7 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 {
 	/* Currently, all async queues are mapped to root group */
 	if (!cfq_cfqq_sync(cfqq))
-		cfqg = &cfqq->cfqd->root_group;
+		cfqg = &cfqq->cfqd->root_groups[cfqq_prio(cfqq)];
 
 	cfqq->cfqg = cfqg;
 	/* cfqq reference on cfqg */
@@ -1023,12 +1036,12 @@ static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
 static void cfq_put_cfqg(struct cfq_group *cfqg)
 {
 	struct cfq_rb_root *st;
-	int i, j;
+	int i;
 
 	BUG_ON(atomic_read(&cfqg->ref) <= 0);
 	if (!atomic_dec_and_test(&cfqg->ref))
 		return;
-	for_each_cfqg_st(cfqg, i, j, st)
+	for_each_cfqg_st(cfqg, i, st)
 		BUG_ON(!RB_EMPTY_ROOT(&st->rb) || st->active != NULL);
 	kfree(cfqg);
 }
@@ -1090,7 +1103,28 @@ void cfq_unlink_blkio_group(void *key, struct blkio_group *blkg)
 #else /* GROUP_IOSCHED */
 static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
 {
-	return &cfqd->root_group;
+	struct task_struct *tsk = current;
+	int ioprio_class;
+
+	/*
+	 * If task belongs to RT or IDLE class, statically assign it to root
+	 * rt or idle group respectively.
+	 */
+	ioprio_class = IOPRIO_PRIO_CLASS(tsk->io_context->ioprio);
+	if (ioprio_class == IOPRIO_CLASS_NONE)
+		/*
+		 * no prio set, inherit CPU scheduling settings
+		 */
+		ioprio_class = task_nice_ioclass(tsk);
+
+	switch (ioprio_class) {
+	case IOPRIO_CLASS_RT:
+		return &cfqd->root_groups[RT_WORKLOAD];
+	case IOPRIO_CLASS_IDLE:
+		return &cfqd->root_groups[IDLE_WORKLOAD];
+	}
+
+	return &cfqd->root_groups[BE_WORKLOAD];
 }
 static inline void
 cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg) {
@@ -1118,22 +1152,46 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	int new_cfqq = 1;
 	int group_changed = 0;
 
+	/* Check if cfqq's group changed because of cfqq prio class changes */
+	if (cfqq->cfqg && cfqq_prio(cfqq) != cfqq->cfqg->prio_class) {
+		/*
+		 * Move cfqq to new group of right ioprio class. This movement
+		 * happens in root group as we don't have any information
+		 * about submitting task context hence cgroup here.
+		 *
+		 * TODO: when prio class is changed, make sure to drop the ioc
+		 * reference to cfqq so that a new queue is setup for new
+		 * request and this queue will complete IO in root group
+		 */
+		if (!RB_EMPTY_NODE(&cfqq->rb_node))
+			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
+
+		if (cfqq->orig_cfqg) {
+			cfq_put_cfqg(cfqq->orig_cfqg);
+			cfqq->orig_cfqg = NULL;
+		}
+
+		cfqq->cfqg = &cfqd->root_groups[cfqq_prio(cfqq)];
+		group_changed = 1;
+	}
+
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
+	/* Handle group movement because of cfqq workload type changes */
 	if (!cfqd->cfq_group_isolation
-	    && cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD
-	    && cfqq->cfqg && cfqq->cfqg != &cfqd->root_group) {
+	    && cfqq_type(cfqq) == SYNC_NOIDLE_WORKLOAD && cfqq->cfqg
+	    && cfqq->cfqg != &cfqd->root_groups[cfqq_prio(cfqq)]) {
 		/* Move this cfq to root group */
 		cfq_log_cfqq(cfqd, cfqq, "moving to root group");
 		if (!RB_EMPTY_NODE(&cfqq->rb_node))
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 		cfqq->orig_cfqg = cfqq->cfqg;
-		cfqq->cfqg = &cfqd->root_group;
-		atomic_inc(&cfqd->root_group.ref);
+		cfqq->cfqg = &cfqd->root_groups[cfqq_prio(cfqq)];
+		atomic_inc(&cfqd->root_groups[cfqq_prio(cfqq)].ref);
 		group_changed = 1;
 	} else if (!cfqd->cfq_group_isolation
 		   && cfqq_type(cfqq) == SYNC_WORKLOAD && cfqq->orig_cfqg) {
 		/* cfqq is sequential now needs to go to its original group */
-		BUG_ON(cfqq->cfqg != &cfqd->root_group);
+		BUG_ON(cfqq->cfqg != &cfqd->root_groups[cfqq_prio(cfqq)]);
 		if (!RB_EMPTY_NODE(&cfqq->rb_node))
 			cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 		cfq_put_cfqg(cfqq->cfqg);
@@ -1144,8 +1202,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	}
 #endif
 
-	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
-						cfqq_type(cfqq));
+	service_tree = service_tree_for(cfqq->cfqg, cfqq_type(cfqq));
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
@@ -1557,6 +1614,8 @@ static void
 __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		    bool timed_out)
 {
+	struct cfq_group *cfqg = cfqq->cfqg;
+
 	cfq_log_cfqq(cfqd, cfqq, "slice expired t=%d", timed_out);
 
 	if (cfq_cfqq_wait_request(cfqq))
@@ -1583,8 +1642,9 @@ __cfq_slice_expired(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	if (cfqq == cfqd->active_queue)
 		cfqd->active_queue = NULL;
 
-	if (&cfqq->cfqg->rb_node == cfqd->grp_service_tree.active)
-		cfqd->grp_service_tree.active = NULL;
+	/* Do not rely on cfqq->cfqg as after resort, cfqq might change group */
+	if (&cfqg->rb_node == cfqd->grp_service_trees[cfqg->prio_class].active)
+		cfqd->grp_service_trees[cfqg->prio_class].active = NULL;
 
 	if (cfqd->active_cic) {
 		put_io_context(cfqd->active_cic->ioc);
@@ -1607,8 +1667,7 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
-					cfqd->serving_type);
+		service_tree_for(cfqd->serving_group, cfqd->serving_type);
 
 	if (!cfqd->rq_queued)
 		return NULL;
@@ -1625,7 +1684,7 @@ static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 {
 	struct cfq_group *cfqg;
 	struct cfq_queue *cfqq;
-	int i, j;
+	int i;
 	struct cfq_rb_root *st;
 
 	if (!cfqd->rq_queued)
@@ -1635,7 +1694,7 @@ static struct cfq_queue *cfq_get_next_queue_forced(struct cfq_data *cfqd)
 	if (!cfqg)
 		return NULL;
 
-	for_each_cfqg_st(cfqg, i, j, st)
+	for_each_cfqg_st(cfqg, i, st)
 		if ((cfqq = cfq_rb_first(st)) != NULL)
 			return cfqq;
 	return NULL;
@@ -1954,8 +2013,8 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
-static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
-				struct cfq_group *cfqg, enum wl_prio_t prio)
+static enum wl_type_t
+cfq_choose_wl(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	struct cfq_queue *queue;
 	int i;
@@ -1965,7 +2024,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
 
 	for (i = 0; i <= SYNC_WORKLOAD; ++i) {
 		/* select the one with lowest rb_key */
-		queue = cfq_rb_first(service_tree_for(cfqg, prio, i));
+		queue = cfq_rb_first(service_tree_for(cfqg, i));
 		if (queue &&
 		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
 			lowest_key = queue->rb_key;
@@ -1984,19 +2043,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	struct cfq_rb_root *st;
 	unsigned group_slice;
 
-	if (!cfqg) {
-		cfqd->serving_prio = IDLE_WORKLOAD;
-		cfqd->workload_expires = jiffies + 1;
-		return;
-	}
-
-	/* Choose next priority. RT > BE > IDLE */
-	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_prio = RT_WORKLOAD;
-	else if (cfq_group_busy_queues_wl(BE_WORKLOAD, cfqd, cfqg))
-		cfqd->serving_prio = BE_WORKLOAD;
-	else {
-		cfqd->serving_prio = IDLE_WORKLOAD;
+	if (cfqg->prio_class == IOPRIO_CLASS_IDLE) {
 		cfqd->workload_expires = jiffies + 1;
 		return;
 	}
@@ -2006,7 +2053,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 * (SYNC, SYNC_NOIDLE, ASYNC), and to compute a workload
 	 * expiration time
 	 */
-	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
+	st = service_tree_for(cfqg, cfqd->serving_type);
 	count = st->count;
 
 	/*
@@ -2016,9 +2063,8 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	/* otherwise select new workload type */
-	cfqd->serving_type =
-		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio);
-	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type);
+	cfqd->serving_type = cfq_choose_wl(cfqd, cfqg);
+	st = service_tree_for(cfqg, cfqd->serving_type);
 	count = st->count;
 
 	/*
@@ -2028,9 +2074,8 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 */
 	group_slice = cfq_group_slice(cfqd, cfqg);
 
-	slice = group_slice * count /
-		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
-		      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
+	slice = group_slice * count / max_t(unsigned, cfqg->busy_queues_avg,
+			cfq_group_busy_queues(cfqd, cfqg));
 
 	if (cfqd->serving_type == ASYNC_WORKLOAD) {
 		unsigned int tmp;
@@ -2060,14 +2105,19 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd)
 {
-	struct cfq_rb_root *st = &cfqd->grp_service_tree;
-	struct cfq_group *cfqg;
+	struct cfq_rb_root *st;
+	struct cfq_group *cfqg = NULL;
+	int i;
+
+	for (i = 0; i <= IDLE_WORKLOAD; i++) {
+		st = &cfqd->grp_service_trees[i];
+		if (RB_EMPTY_ROOT(&st->rb))
+			continue;
+		cfqg = cfq_rb_first_group(st);
+		st->active = &cfqg->rb_node;
+		update_min_vdisktime(st);
+	}
 
-	if (RB_EMPTY_ROOT(&st->rb))
-		return NULL;
-	cfqg = cfq_rb_first_group(st);
-	st->active = &cfqg->rb_node;
-	update_min_vdisktime(st);
 	return cfqg;
 }
 
@@ -2077,11 +2127,20 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 
 	cfqd->serving_group = cfqg;
 
+	if (!cfqg) {
+		/*
+		 * Nothing to dispatch. Mark workload as expired so that next
+		 * time we choose a fresh workload
+		 */
+		cfqd->serving_type = SYNC_NOIDLE_WORKLOAD;
+		cfqd->workload_expires = jiffies - 1;
+		return;
+	}
+
 	/* Restore the workload type data */
 	if (cfqg->saved_workload_slice) {
 		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
 		cfqd->serving_type = cfqg->saved_workload;
-		cfqd->serving_prio = cfqg->saved_serving_prio;
 	} else
 		cfqd->workload_expires = jiffies - 1;
 
@@ -3651,7 +3710,7 @@ static void cfq_exit_queue(struct elevator_queue *e)
 
 	cfq_put_async_queues(cfqd);
 	cfq_release_cfq_groups(cfqd);
-	blkiocg_del_blkio_group(&cfqd->root_group.blkg);
+	blkiocg_del_blkio_group(&cfqd->root_groups[BE_WORKLOAD].blkg);
 
 	spin_unlock_irq(q->queue_lock);
 
@@ -3672,27 +3731,35 @@ static void *cfq_init_queue(struct request_queue *q)
 	if (!cfqd)
 		return NULL;
 
-	/* Init root service tree */
-	cfqd->grp_service_tree = CFQ_RB_ROOT;
+	/* Init root service trees */
+	for (i = 0; i <= IDLE_WORKLOAD; i++)
+		cfqd->grp_service_trees[i] = CFQ_RB_ROOT;
 
 	/* Init root group */
-	cfqg = &cfqd->root_group;
-	for_each_cfqg_st(cfqg, i, j, st)
-		*st = CFQ_RB_ROOT;
-	RB_CLEAR_NODE(&cfqg->rb_node);
+	for (i = 0; i <= IDLE_WORKLOAD; i++) {
+		cfqg = &cfqd->root_groups[i];
+		for_each_cfqg_st(cfqg, j, st)
+			*st = CFQ_RB_ROOT;
+		RB_CLEAR_NODE(&cfqg->rb_node);
 
-	/* Give preference to root group over other groups */
-	cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
+		/* Give preference to root group over other groups */
+		cfqg->weight = 2*BLKIO_WEIGHT_DEFAULT;
+		cfqg->prio_class = i;
 
 #ifdef CONFIG_CFQ_GROUP_IOSCHED
-	/*
-	 * Take a reference to root group which we never drop. This is just
-	 * to make sure that cfq_put_cfqg() does not try to kfree root group
-	 */
-	atomic_set(&cfqg->ref, 1);
-	blkiocg_add_blkio_group(&blkio_root_cgroup, &cfqg->blkg, (void *)cfqd,
-					0);
+		/*
+		 * Take a reference to root group which we never drop. This is
+		 * just to make sure that cfq_put_cfqg() does not try to
+		 * kfree root group.
+		 */
+		atomic_set(&cfqg->ref, 1);
+
+		/* TODO: Fix it to add RT and IDLE groups also to root group */
+		if (cfqg->prio_class == BE_WORKLOAD)
+			blkiocg_add_blkio_group(&blkio_root_cgroup,
+						&cfqg->blkg, (void *)cfqd, 0);
 #endif
+	}
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
 	 * zeroed cfqd on alloc), but better be safe in case someone decides
@@ -3708,7 +3775,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 */
 	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
 	atomic_inc(&cfqd->oom_cfqq.ref);
-	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
+	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_groups[BE_WORKLOAD]);
 
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
-- 
1.6.2.5

