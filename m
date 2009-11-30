Return-Path: <linux-kernel-owner+w=401wt.eu-S1753758AbZK3DBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbZK3DBV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:01:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZK3DBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556AbZK3DAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 02/21] blkio: Introduce the notion of cfq groups
Date: Sun, 29 Nov 2009 21:59:09 -0500
Message-Id: <1259549968-10369-3-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
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
 block/cfq-iosched.c |  109 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 76 insertions(+), 33 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 9adfa48..3baa3f4 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -132,6 +132,7 @@ struct cfq_queue {
 
 	struct cfq_rb_root *service_tree;
 	struct cfq_queue *new_cfqq;
+	struct cfq_group *cfqg;
 };
 
 /*
@@ -153,25 +154,30 @@ enum wl_type_t {
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
  */
 struct cfq_data {
 	struct request_queue *queue;
+	struct cfq_group root_group;
 
 	/*
-	 * rr lists of queues with requests, onle rr for each priority class.
-	 * Counts are embedded in the cfq_rb_root
-	 */
-	struct cfq_rb_root service_trees[2][3];
-	struct cfq_rb_root service_tree_idle;
-	/*
 	 * The priority currently being served
 	 */
 	enum wl_prio_t serving_prio;
 	enum wl_type_t serving_type;
 	unsigned long workload_expires;
+	struct cfq_group *serving_group;
 	bool noidle_tree_requires_idle;
 
 	/*
@@ -240,14 +246,15 @@ struct cfq_data {
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
@@ -317,12 +324,14 @@ static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
 
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
@@ -611,7 +620,8 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 {
 	struct cfq_rb_root *service_tree;
 
-	service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
+	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
+						cfqq_type(cfqq), cfqd);
 
 	/*
 	 * just an approximation, should be ok.
@@ -634,7 +644,8 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_rb_root *service_tree;
 	int left;
 
-	service_tree = service_tree_for(cfqq_prio(cfqq), cfqq_type(cfqq), cfqd);
+	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
+						cfqq_type(cfqq), cfqd);
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
@@ -1070,7 +1081,8 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
 	struct cfq_rb_root *service_tree =
-		service_tree_for(cfqd->serving_prio, cfqd->serving_type, cfqd);
+		service_tree_for(cfqd->serving_group, cfqd->serving_prio,
+					cfqd->serving_type, cfqd);
 
 	if (RB_EMPTY_ROOT(&service_tree->rb))
 		return NULL;
@@ -1222,7 +1234,8 @@ static bool cfq_should_idle(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	 * in their service tree.
 	 */
 	if (!service_tree)
-		service_tree = service_tree_for(prio, cfqq_type(cfqq), cfqd);
+		service_tree = service_tree_for(cfqq->cfqg, prio,
+						cfqq_type(cfqq), cfqd);
 
 	if (service_tree->count == 0)
 		return true;
@@ -1381,8 +1394,9 @@ static void cfq_setup_merge(struct cfq_queue *cfqq, struct cfq_queue *new_cfqq)
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
@@ -1396,10 +1410,10 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
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
@@ -1407,7 +1421,7 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
 
 	for (i = 0; i < 3; ++i) {
 		/* otherwise, select the one with lowest rb_key */
-		queue = cfq_rb_first(service_tree_for(prio, i, cfqd));
+		queue = cfq_rb_first(service_tree_for(cfqg, prio, i, cfqd));
 		if (queue &&
 		    (!key_valid || time_before(queue->rb_key, lowest_key))) {
 			lowest_key = queue->rb_key;
@@ -1419,12 +1433,13 @@ static enum wl_type_t cfq_choose_wl(struct cfq_data *cfqd, enum wl_prio_t prio,
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
@@ -1443,8 +1458,9 @@ static void choose_service_tree(struct cfq_data *cfqd)
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
@@ -1456,9 +1472,10 @@ static void choose_service_tree(struct cfq_data *cfqd)
 
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
@@ -1482,6 +1499,12 @@ static void choose_service_tree(struct cfq_data *cfqd)
 	cfqd->noidle_tree_requires_idle = false;
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
@@ -1539,7 +1562,7 @@ new_queue:
 	 * service tree
 	 */
 	if (!new_cfqq)
-		choose_service_tree(cfqd);
+		cfq_choose_cfqg(cfqd);
 
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
@@ -1568,13 +1591,15 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
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
@@ -2045,14 +2070,26 @@ static void cfq_init_cfqq(struct cfq_data *cfqd, struct cfq_queue *cfqq,
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
@@ -2083,6 +2120,7 @@ retry:
 		if (cfqq) {
 			cfq_init_cfqq(cfqd, cfqq, current->pid, is_sync);
 			cfq_init_prio_data(cfqq, ioc);
+			cfq_link_cfqq_cfqg(cfqq, cfqg);
 			cfq_log_cfqq(cfqd, cfqq, "alloced");
 		} else
 			cfqq = &cfqd->oom_cfqq;
@@ -2935,15 +2973,19 @@ static void *cfq_init_queue(struct request_queue *q)
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
@@ -2960,6 +3002,7 @@ static void *cfq_init_queue(struct request_queue *q)
 	 */
 	cfq_init_cfqq(cfqd, &cfqd->oom_cfqq, 1, 0);
 	atomic_inc(&cfqd->oom_cfqq.ref);
+	cfq_link_cfqq_cfqg(&cfqd->oom_cfqq, &cfqd->root_group);
 
 	INIT_LIST_HEAD(&cfqd->cic_list);
 
-- 
1.6.2.5

