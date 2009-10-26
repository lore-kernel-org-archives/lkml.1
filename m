Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZJZVou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZJZVou (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbZJZVot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:44:49 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59957 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZJZVot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=J0IntrZEU3cQoAMFyUTVZruhm3epMgcVz9Yt4efVBhgvzpKWBgN8a3fQvtKRsAGeHH
         Ihxr/nbkWvznUUuDMcQ+4h3aop+NiPIKIN1+W+6mICpQnjpMm1sO8fdazmUJ36q/b0jw
         MgzTFlpPbJC/yAbTVUSSb1fePkMx6e4hydof0=
From: Corrado Zoccolo <czoccolo@gmail.com>
To: "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 3/5] cfq-iosched: reimplement priorities using different service trees
Date: Mon, 26 Oct 2009 22:44:51 +0100
User-Agent: KMail/1.11.4 (Linux/2.6.32cz; KDE/4.2.4; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910262244.51965.czoccolo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use different service trees for different priority classes.
This allows a simplification in the service tree insertion code, that no
longer has to consider priority while walking the tree.

Signed-off-by: Corrado Zoccolo <czoccolo@gmail.com>
---
 block/cfq-iosched.c |  114 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 80 insertions(+), 34 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b707573..4da42cd 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -134,15 +134,31 @@ struct cfq_queue {
 };
 
 /*
+ * Index in the service_trees.
+ * IDLE is handled separately, so it has negative index
+ */
+enum wl_prio_t {
+	IDLE_WORKLOAD = -1,
+	BE_WORKLOAD = 0,
+	RT_WORKLOAD = 1
+};
+
+/*
  * Per block device queue structure
  */
 struct cfq_data {
 	struct request_queue *queue;
 
 	/*
-	 * rr list of queues with requests and the count of them
+	 * rr lists of queues with requests, onle rr for each priority class.
+	 * Counts are embedded in the cfq_rb_root
+	 */
+	struct cfq_rb_root service_trees[2];
+	struct cfq_rb_root service_tree_idle;
+	/*
+	 * The priority currently being served
 	 */
-	struct cfq_rb_root service_tree;
+	enum wl_prio_t serving_prio;
 
 	/*
 	 * Each priority tree is sorted by next_request position.  These
@@ -152,7 +168,6 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
-	unsigned int busy_rt_queues;
 	unsigned int busy_queues_avg[2];
 
 	int rq_in_driver[2];
@@ -205,6 +220,15 @@ struct cfq_data {
 	unsigned long last_end_sync_rq;
 };
 
+static struct cfq_rb_root *service_tree_for(enum wl_prio_t prio,
+					    struct cfq_data *cfqd)
+{
+	if (prio == IDLE_WORKLOAD)
+		return &cfqd->service_tree_idle;
+
+	return &cfqd->service_trees[prio];
+}
+
 enum cfqq_state_flags {
 	CFQ_CFQQ_FLAG_on_rr = 0,	/* on round-robin busy list */
 	CFQ_CFQQ_FLAG_wait_request,	/* waiting for a request */
@@ -249,6 +273,23 @@ CFQ_CFQQ_FNS(coop);
 #define cfq_log(cfqd, fmt, args...)	\
 	blk_add_trace_msg((cfqd)->queue, "cfq " fmt, ##args)
 
+static inline enum wl_prio_t cfqq_prio(struct cfq_queue *cfqq)
+{
+	if (cfq_class_idle(cfqq))
+		return IDLE_WORKLOAD;
+	if (cfq_class_rt(cfqq))
+		return RT_WORKLOAD;
+	return BE_WORKLOAD;
+}
+
+static inline int cfq_busy_queues_wl(enum wl_prio_t wl, struct cfq_data *cfqd)
+{
+	if (wl == IDLE_WORKLOAD)
+		return cfqd->service_tree_idle.count;
+
+	return cfqd->service_trees[wl].count;
+}
+
 static void cfq_dispatch_insert(struct request_queue *, struct request *);
 static struct cfq_queue *cfq_get_queue(struct cfq_data *, bool,
 				       struct io_context *, gfp_t);
@@ -332,10 +373,7 @@ cfq_get_avg_queues(struct cfq_data *cfqd, bool rt) {
 	unsigned min_q, max_q;
 	unsigned mult  = cfq_hist_divisor - 1;
 	unsigned round = cfq_hist_divisor / 2;
-	unsigned busy = cfqd->busy_rt_queues;
-
-	if (!rt)
-		busy = cfqd->busy_queues - cfqd->busy_rt_queues;
+	unsigned busy = cfq_busy_queues_wl(rt, cfqd);
 
 	min_q = min(cfqd->busy_queues_avg[rt], busy);
 	max_q = max(cfqd->busy_queues_avg[rt], busy);
@@ -546,7 +584,7 @@ static unsigned long cfq_slice_offset(struct cfq_data *cfqd,
 }
 
 /*
- * The cfqd->service_tree holds all pending cfq_queue's that have
+ * The cfqd->service_trees holds all pending cfq_queue's that have
  * requests waiting to be processed. It is sorted in the order that
  * we will service the queues.
  */
@@ -556,9 +594,10 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct rb_node **p, *parent;
 	struct cfq_queue *__cfqq;
 	unsigned long rb_key;
-	struct cfq_rb_root *service_tree = &cfqd->service_tree;
+	struct cfq_rb_root *service_tree;
 	int left;
 
+	service_tree = service_tree_for(cfqq_prio(cfqq), cfqd);
 	if (cfq_class_idle(cfqq)) {
 		rb_key = CFQ_IDLE_DELAY;
 		parent = rb_last(&service_tree->rb);
@@ -587,7 +626,8 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		/*
 		 * same position, nothing more to do
 		 */
-		if (rb_key == cfqq->rb_key)
+		if (rb_key == cfqq->rb_key &&
+		    cfqq->service_tree == service_tree)
 			return;
 
 		cfq_rb_erase(&cfqq->rb_node, cfqq->service_tree);
@@ -605,25 +645,14 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 		__cfqq = rb_entry(parent, struct cfq_queue, rb_node);
 
 		/*
-		 * sort RT queues first, we always want to give
-		 * preference to them. IDLE queues goes to the back.
-		 * after that, sort on the next service time.
+		 * sort by key, that represents service time.
 		 */
-		if (cfq_class_rt(cfqq) > cfq_class_rt(__cfqq))
-			n = &(*p)->rb_left;
-		else if (cfq_class_rt(cfqq) < cfq_class_rt(__cfqq))
-			n = &(*p)->rb_right;
-		else if (cfq_class_idle(cfqq) < cfq_class_idle(__cfqq))
-			n = &(*p)->rb_left;
-		else if (cfq_class_idle(cfqq) > cfq_class_idle(__cfqq))
-			n = &(*p)->rb_right;
-		else if (time_before(rb_key, __cfqq->rb_key))
+		if (time_before(rb_key, __cfqq->rb_key))
 			n = &(*p)->rb_left;
-		else
+		else {
 			n = &(*p)->rb_right;
-
-		if (n == &(*p)->rb_right)
 			left = 0;
+		}
 
 		p = n;
 	}
@@ -722,8 +751,7 @@ static void cfq_add_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
-	if (cfq_class_rt(cfqq))
-		cfqd->busy_rt_queues++;
+
 	cfq_resort_rr_list(cfqd, cfqq);
 }
 
@@ -748,8 +776,6 @@ static void cfq_del_cfqq_rr(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
-	if (cfq_class_rt(cfqq))
-		cfqd->busy_rt_queues--;
 }
 
 /*
@@ -1003,10 +1029,12 @@ static inline void cfq_slice_expired(struct cfq_data *cfqd, bool timed_out)
  */
 static struct cfq_queue *cfq_get_next_queue(struct cfq_data *cfqd)
 {
-	if (RB_EMPTY_ROOT(&cfqd->service_tree.rb))
-		return NULL;
+	struct cfq_rb_root *service_tree =
+		service_tree_for(cfqd->serving_prio, cfqd);
 
-	return cfq_rb_first(&cfqd->service_tree);
+	if (RB_EMPTY_ROOT(&service_tree->rb))
+		return NULL;
+	return cfq_rb_first(service_tree);
 }
 
 /*
@@ -1123,6 +1151,10 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 	if (CFQQ_SEEKY(cfqq))
 		return NULL;
 
+	/* we don't want to mix processes with different characteristics */
+	if (cfqq->service_tree != cur_cfqq->service_tree)
+		return NULL;
+
 	return cfqq;
 }
 
@@ -1336,6 +1368,14 @@ static struct cfq_queue *cfq_select_queue(struct cfq_data *cfqd)
 expire:
 	cfq_slice_expired(cfqd, 0);
 new_queue:
+	if (!new_cfqq) {
+		if (cfq_busy_queues_wl(RT_WORKLOAD, cfqd))
+			cfqd->serving_prio = RT_WORKLOAD;
+		else if (cfq_busy_queues_wl(BE_WORKLOAD, cfqd))
+			cfqd->serving_prio = BE_WORKLOAD;
+		else
+			cfqd->serving_prio = IDLE_WORKLOAD;
+	}
 	cfqq = cfq_set_active_queue(cfqd, new_cfqq);
 keep_queue:
 	return cfqq;
@@ -1362,8 +1402,12 @@ static int cfq_forced_dispatch(struct cfq_data *cfqd)
 {
 	struct cfq_queue *cfqq;
 	int dispatched = 0;
+	int i;
+	for (i = 0; i < 2; ++i)
+		while ((cfqq = cfq_rb_first(&cfqd->service_trees[i])) != NULL)
+			dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
-	while ((cfqq = cfq_rb_first(&cfqd->service_tree)) != NULL)
+	while ((cfqq = cfq_rb_first(&cfqd->service_tree_idle)) != NULL)
 		dispatched += __cfq_forced_dispatch_cfqq(cfqq);
 
 	cfq_slice_expired(cfqd, 0);
@@ -2698,7 +2742,9 @@ static void *cfq_init_queue(struct request_queue *q)
 	if (!cfqd)
 		return NULL;
 
-	cfqd->service_tree = CFQ_RB_ROOT;
+	for (i = 0; i < 2; ++i)
+		cfqd->service_trees[i] = CFQ_RB_ROOT;
+	cfqd->service_tree_idle = CFQ_RB_ROOT;
 
 	/*
 	 * Not strictly needed (since RB_ROOT just clears the node and we
-- 
1.6.2.5


