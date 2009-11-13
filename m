Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZKMRlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZKMRlB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 12:41:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbZKMRkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 12:40:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639AbZKMRkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 12:40:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, vgoyal@redhat.com, akpm@linux-foundation.org,
       riel@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, czoccolo@gmail.com
Subject: [PATCH 01/16] blkio: Introduce the notion of cfq groups
Date: Fri, 13 Nov 2009 12:40:00 -0500
Message-Id: <1258134015-21632-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
References: <1258134015-21632-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o This patch introduce the notion of cfq groups. Soon we will can have multiple
  groups of different weights in the system.

o Various service trees (prioclass and workload type trees), will become per
  cfq group. So hierarchy looks as follows.

			cfq_groups
			   |
			workload type
			   |
		        cfq queue

o When an scheduling decision has to be taken, first we select the cfq group
  then workload with-in the group and then cfq queue with-in the workload
  type.

o This patch just makes various workload service tree per cfq group and
  introduce the function to be able to choose a group for scheduling.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |  114 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 79 insertions(+), 35 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 1bcbd8c..aebb205 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -132,6 +132,7 @@ struct cfq_queue {
 
 	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
+	struct cfq_group *cfqg;
 };
 
 /*
@@ -153,6 +154,15 @@ enum wl_type_t {
 	SYNC_WORKLOAD = 2
 };
 
+/* This is per cgroup per device grouping structure */
+struct cfq_group {
+	/*
+	 * rr lists of queues with requests, onle rr for each priority class.
+	 * Counts are embedded in the cfq_rb_root
+	 */
+	struct cfq_rb_root service_trees[2][3];
+	struct cfq_rb_root service_tree_idle;
+};
 
 /*
  * Per block device queue structure
@@ -160,18 +170,15 @@ enum wl_type_t {
 struct cfq_data {
 	struct request_queue *queue;
 
-	/*
-	 * rr lists of queues with requests, onle rr for each priority class.
-	 * Counts are embedded in the cfq_rb_root
-	 */
-	struct cfq_rb_root service_trees[2][3];
-	struct cfq_rb_root service_tree_idle;
+	struct cfq_group root_group;
+
 	/*
 	 * The priority currently being served
 	 */
 	enum wl_prio_t serving_prio;
 	enum wl_type_t serving_type;
 	unsigned long workload_expires;
+	struct cfq_group *serving_group;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -233,14 +240,15 @@ struct cfq_data {
 	unsigned long last_end_sync_rq;
 };
 
-static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
+static struct cfq_rb_root *service_tree_for(struct cfq_group *cfqg,
+					    enum wl_prio_t prio,
 					    enum wl_type_t type,
 					    struct cfq_data *cfqd)
 {
 	if (prio == IDLE_WORKLOAD)
-		return &cfqd->service_tree_idle;
+		return &cfqg->service_tree_idle;
 
-	return &cfqd->service_trees[prio][type];
+	return &cfqg->service_trees[prio][type];
 }
 
 enum cfqq_state_flags {
@@ -308,12 +316,14 @@ static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
 
 static inline int cfq_busy_queues_wl(enum wl_prio_t wl, struct cfq_data *cfqd)
 {
+	struct cfq_group *cfqg = &cfqd->root_group;
+
 	if (wl == IDLE_WORKLOAD)
-		return cfqd->service_tree_idle.count;
+		return cfqg->service_tree_idle.count;
 
-	return cfqd->service_trees[wl][ASYNC_WORKLOAD].count
-		+ cfqd->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
-		+ cfqd->service_trees[wl][SYNC_WORKLOAD].count;
+	return cfqg->service_trees[wl][ASYNC_WORKLOAD].count
+		+ cfqg->service_trees[wl][SYNC_NOIDLE_WORKLOAD].count
+		+ cfqg->service_trees[wl][SYNC_WORKLOAD].count;
 }
 
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
@@ -621,7 +631,8 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_rb_root *service_tree;
 	int left;
 
-	service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
+	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
+						cfqq_type(cfqq), cfqd);
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
@@ -1057,7 +1068,8 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd);
+		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
+					cfqd->serving_type, cfqd);
 
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
@@ -1209,7 +1221,8 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * in their service tree.
 	 */
 	if (!service_tree)
-		service_tree = service_tree_for(prio, cfqq_type(cfqq), cfqd);
+		service_tree = service_tree_for(cfqq->cfqg, prio,
+						cfqq_type(cfqq), cfqd);
 
 	if (service_tree->count == 0)
 		return true;
@@ -1222,6 +1235,7 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	struct cfq_queue *cfqq = cfqd->active_queue;
 	struct cfq_io_context *cic;
 	unsigned long sl;
+	struct cfq_rb_root *st;
 
 	/*
 	 * SSD device without seek penalty, disable idling. But only do so
@@ -1271,9 +1285,9 @@ static void cfq_arm_slice_timer(struct cfq_data *cfqd)
 	 *     fair distribution of slice time for a process doing back-to-back
 	 *     seeks.
 	 */
-	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD &&
-	    service_tree_for(cfqd->serving_prio, SYNC_NOIDLE_WORKLOAD, cfqd)
-		->count > 0) {
+	st = service_tree_for(cfqq->cfqg, cfqd->serving_prio,
+				SYNC_NOIDLE_WORKLOAD, cfqd);
+	if (cfqd->serving_type == SYNC_NOIDLE_WORKLOAD && st->count > 0) {
 		if (blk_queue_nonrot(cfqd->queue) || cfqd->hw_tag)
 			return;
 		sl = min(sl, msecs_to_jiffies(CFQ_MIN_TT));
@@ -1381,8 +1395,9 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
 	}
 }
 
-static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
-				    bool prio_changed)
+static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd,
+				struct cfq_group *cfqg, enum wl_prio_t prio,
+				bool prio_changed)
 {
 	struct cfq_queue *queue;
 	int i;
@@ -1396,10 +1411,10 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
 		 * from SYNC_NOIDLE (first choice), or just SYNC
 		 * over ASYNC
 		 */
-		if (service_tree_for(prio, cur_best, cfqd)->count)
+		if (service_tree_for(cfqg, prio, cur_best, cfqd)->count)
 			return cur_best;
 		cur_best = SYNC_WORKLOAD;
-		if (service_tree_for(prio, cur_best, cfqd)->count)
+		if (service_tree_for(cfqg, prio, cur_best, cfqd)->count)
 			return cur_best;
 
 		return ASYNC_WORKLOAD;
@@ -1407,7 +1422,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
 
 	for (i = 0; i < 3; ++i) {
 		/* otherwise, select the one with lowest rb_key */
-		queue = cfq_rb_first(service_tree_for(prio, i, cfqd));
+		queue = cfq_rb_first(service_tree_for(cfqg, prio, i, cfqd));
 		if (queue &&
 		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
 			lowest_key = queue->rb_key;
@@ -1419,12 +1434,13 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
 	return cur_best;
 }
 
-static void choose_service_tree(struct cfq_data *cfqd)
+static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 {
 	enum wl_prio_t previous_prio = cfqd->serving_prio;
 	bool prio_changed;
 	unsigned slice;
 	unsigned count;
+	struct cfq_rb_root *st;
 
 	/* Choose next priority. RT > BE > IDLE */
 	if (cfq_busy_queues_wl(RT_WORKLOAD, cfqd))
@@ -1443,8 +1459,9 @@ static void choose_service_tree(struct cfq_data *cfqd)
 	 * expiration time
 	 */
 	prio_changed = (cfqd->serving_prio != previous_prio);
-	count = service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd)
-		->count;
+	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
+				cfqd);
+	count = st->count;
 
 	/*
 	 * If priority didn't change, check workload expiration,
@@ -1456,9 +1473,10 @@ static void choose_service_tree(struct cfq_data *cfqd)
 
 	/* otherwise select new workload type */
 	cfqd->serving_type =
-		cfq_choose_wl(cfqd, cfqd->serving_prio, prio_changed);
-	count = service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd)
-		->count;
+		cfq_choose_wl(cfqd, cfqg, cfqd->serving_prio, prio_changed);
+	st = service_tree_for(cfqg, cfqd->serving_prio, cfqd->serving_type,
+				cfqd);
+	count = st->count;
 
 	/*
 	 * the workload slice is computed as a fraction of target latency
@@ -1481,6 +1499,12 @@ static void choose_service_tree(struct cfq_data *cfqd)
 	cfqd->workload_expires = jiffies + slice;
 }
 
+static void cfq_choose_cfqg(struct cfq_data *cfqd)
+{
+	cfqd->serving_group = &cfqd->root_group;
+	choose_service_tree(cfqd, &cfqd->root_group);
+}
+
 /*
  * Select a queue for service. If we have a current active queue,
  * check whether to continue servicing it, or retrieve and set a new one.
@@ -1538,7 +1562,7 @@ new_queue:
 	 * service tree
 	 */
 	if (!new_cfqq)
-		choose_service_tree(cfqd);
+		cfq_choose_cfqg(cfqd);
 
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
@@ -1567,13 +1591,15 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
 	int i, j;
+	struct cfq_group *cfqg = &cfqd->root_group;
+
 	for (i = 0; i < 2; ++i)
 		for (j = 0; j < 3; ++j)
-			while ((cfqq = cfq_rb_first(&cfqd->service_trees[i][j]))
+			while ((cfqq = cfq_rb_first(&cfqg->service_trees[i][j]))
 				!= NULL)
 				dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
-	while ((cfqq = cfq_rb_first(&cfqd->service_tree_idle)) != NULL)
+	while ((cfqq = cfq_rb_first(&cfqg->service_tree_idle)) != NULL)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
 	cfq_slice_expired(cfqd, 0);
@@ -2044,14 +2070,26 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	cfqq->pid = pid;
 }
 
+static void cfq_link_cfqq_cfqg(struct cfq_queue *cfqq, struct cfq_group *cfqg)
+{
+	cfqq->cfqg = cfqg;
+}
+
+static struct cfq_group *cfq_get_cfqg(struct cfq_data *cfqd, int create)
+{
+	return &cfqd->root_group;
+}
+
 static struct cfq_queue *
 cfq_find_alloc_queue(struct cfq_data *cfqd, bool is_sync,
 		     struct io_context *ioc, gfp_t gfp_mask)
 {
 	struct cfq_queue *cfqq, *new_cfqq = NULL;
 	struct cfq_io_context *cic;
+	struct cfq_group *cfqg;
 
 retry:
+	cfqg = cfq_get_cfqg(cfqd, 1);
 	cic = cfq_cic_lookup(cfqd, ioc);
 	/* cic always exists here */
 	cfqq = cic_to_cfqq(cic, is_sync);
@@ -2082,6 +2120,7 @@ retry:
 		if (cfqq) {
 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 			cfq_init_prio_data(cfqq, ioc);
+			cfq_link_cfqq_cfqg(cfqq, cfqg);
 			cfq_log_cfqq(cfqd, cfqq, "alloced");
 		} else
 			cfqq = &cfqd->oom_cfqq;
@@ -2914,15 +2953,19 @@ static void *cfq_init_queue(struct request_queue *q)
 {
 	struct cfq_data *cfqd;
 	int i, j;
+	struct cfq_group *cfqg;
 
 	cfqd = kmalloc_node(sizeof(*cfqd), GFP_KERNEL | __GFP_ZERO, q->node);
 	if (!cfqd)
 		return NULL;
 
+	/* Init root group */
+	cfqg = &cfqd->root_group;
+
 	for (i = 0; i < 2; ++i)
 		for (j = 0; j < 3; ++j)
-			cfqd->service_trees[i][j] = CFQ_RB_ROOT;
-	cfqd->service_tree_idle = CFQ_RB_ROOT;
+			cfqg->service_trees[i][j] = CFQ_RB_ROOT;
+	cfqg->service_tree_idle = CFQ_RB_ROOT;
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
@@ -2939,6 +2982,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 */
 	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
 	atomic_inc(&cfqd->oom_cfqq.ref);
+	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
-- 
1.6.2.5

