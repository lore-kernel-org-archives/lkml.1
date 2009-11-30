Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbZK3DDk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbZK3DDk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 22:03:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZK3DBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 22:01:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbZK3DAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 22:00:50 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Cc: nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, vgoyal@redhat.com,
       czoccolo@gmail.com, Alan.Brunelle@hp.com
Subject: [PATCH 08/21] blkio: Implement per cfq group latency target and busy queue avg
Date: Sun, 29 Nov 2009 21:59:15 -0500
Message-Id: <1259549968-10369-9-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o So far we had 300ms soft target latency system wide. Now with the
  introduction of cfq groups, divide that latency by number of groups so
  that one can come up with group target latency which will be helpful
  in determining the workload slice with-in group and also the dynamic
  slice length of the cfq queue.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |   65 +++++++++++++++++++++++++++++++++++---------------
 1 files changed, 45 insertions(+), 20 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index fbb6bf5..6466393 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -81,6 +81,7 @@ struct cfq_rb_root {
 	unsigned count;
 	u64 min_vdisktime;
 	struct rb_node *active;
+	unsigned total_weight;
 };
 #define CFQ_RB_ROOT	(struct cfq_rb_root) { RB_ROOT, NULL, 0, 0, }
 
@@ -171,6 +172,8 @@ struct cfq_group {
 	/* number of cfqq currently on this group */
 	int nr_cfqq;
 
+	/* Per group busy queus average. Useful for workload slice calc. */
+	unsigned int busy_queues_avg[2];
 	/*
 	 * rr lists of queues with requests, onle rr for each priority class.
 	 * Counts are embedded in the cfq_rb_root
@@ -187,6 +190,8 @@ struct cfq_data {
 	/* Root service tree for cfq_groups */
 	struct cfq_rb_root grp_service_tree;
 	struct cfq_group root_group;
+	/* Number of active cfq groups on group service tree */
+	int nr_groups;
 
 	/*
 	 * The priority currently being served
@@ -205,7 +210,6 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
-	unsigned int busy_queues_avg[2];
 
 	int rq_in_driver[2];
 	int sync_flight;
@@ -351,10 +355,10 @@ static enum wl_type_t cfqq_type(struct cfq_queue *cfqq)
 	return SYNC_WORKLOAD;
 }
 
-static inline int cfq_busy_queues_wl(enum wl_prio_t wl, struct cfq_data *cfqd)
+static inline int cfq_group_busy_queues_wl(enum wl_prio_t wl,
+					struct cfq_data *cfqd,
+					struct cfq_group *cfqg)
 {
-	struct cfq_group *cfqg = &cfqd->root_group;
-
 	if (wl == IDLE_WORKLOAD)
 		return cfqg->service_tree_idle.count;
 
@@ -486,18 +490,27 @@ static void update_min_vdisktime(struct cfq_rb_root *st)
  * to quickly follows sudden increases and decrease slowly
  */
 
-static inline unsigned cfq_get_avg_queues(struct cfq_data *cfqd, bool rt)
+static inline unsigned cfq_group_get_avg_queues(struct cfq_data *cfqd,
+					struct cfq_group *cfqg, bool rt)
 {
 	unsigned min_q, max_q;
 	unsigned mult  = cfq_hist_divisor - 1;
 	unsigned round = cfq_hist_divisor / 2;
-	unsigned busy = cfq_busy_queues_wl(rt, cfqd);
+	unsigned busy = cfq_group_busy_queues_wl(rt, cfqd, cfqg);
 
-	min_q = min(cfqd->busy_queues_avg[rt], busy);
-	max_q = max(cfqd->busy_queues_avg[rt], busy);
-	cfqd->busy_queues_avg[rt] = (mult * max_q + min_q + round) /
+	min_q = min(cfqg->busy_queues_avg[rt], busy);
+	max_q = max(cfqg->busy_queues_avg[rt], busy);
+	cfqg->busy_queues_avg[rt] = (mult * max_q + min_q + round) /
 		cfq_hist_divisor;
-	return cfqd->busy_queues_avg[rt];
+	return cfqg->busy_queues_avg[rt];
+}
+
+static inline unsigned
+cfq_group_slice(struct cfq_data *cfqd, struct cfq_group *cfqg)
+{
+	struct cfq_rb_root *st = &cfqd->grp_service_tree;
+
+	return cfq_target_latency * cfqg->weight / st->total_weight;
 }
 
 static inline void
@@ -505,12 +518,17 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 {
 	unsigned slice = cfq_prio_to_slice(cfqd, cfqq);
 	if (cfqd->cfq_latency) {
-		/* interested queues (we consider only the ones with the same
-		 * priority class) */
-		unsigned iq = cfq_get_avg_queues(cfqd, cfq_class_rt(cfqq));
+		/*
+		 * interested queues (we consider only the ones with the same
+		 * priority class in the cfq group)
+		 */
+		unsigned iq = cfq_group_get_avg_queues(cfqd, cfqq->cfqg,
+						cfq_class_rt(cfqq));
 		unsigned sync_slice = cfqd->cfq_slice[1];
 		unsigned expect_latency = sync_slice * iq;
-		if (expect_latency > cfq_target_latency) {
+		unsigned group_slice = cfq_group_slice(cfqd, cfqq->cfqg);
+
+		if (expect_latency > group_slice) {
 			unsigned base_low_slice = 2 * cfqd->cfq_slice_idle;
 			/* scale low_slice according to IO priority
 			 * and sync vs async */
@@ -518,7 +536,7 @@ cfq_set_prio_slice(struct cfq_data *cfqd, struct cfq_queue *cfqq)
 				min(slice, base_low_slice * slice / sync_slice);
 			/* the adapted slice value is scaled to fit all iqs
 			 * into the target latency */
-			slice = max(slice * cfq_target_latency / expect_latency,
+			slice = max(slice * group_slice / expect_latency,
 				    low_slice);
 		}
 	}
@@ -778,6 +796,8 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
 
 	__cfq_group_service_tree_add(st, cfqg);
 	cfqg->on_st = true;
+	cfqd->nr_groups++;
+	st->total_weight += cfqg->weight;
 }
 
 static void
@@ -796,6 +816,8 @@ cfq_group_service_tree_del(struct cfq_data *cfqd, struct cfq_group *cfqg)
 		return;
 
 	cfqg->on_st = false;
+	cfqd->nr_groups--;
+	st->total_weight -= cfqg->weight;
 	if (!RB_EMPTY_NODE(&cfqg->rb_node))
 		cfq_rb_erase(&cfqg->rb_node, st);
 }
@@ -1641,6 +1663,7 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	unsigned slice;
 	unsigned count;
 	struct cfq_rb_root *st;
+	unsigned group_slice;
 
 	if (!cfqg) {
 		cfqd->serving_prio = IDLE_WORKLOAD;
@@ -1649,9 +1672,9 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	}
 
 	/* Choose next priority. RT > BE > IDLE */
-	if (cfq_busy_queues_wl(RT_WORKLOAD, cfqd))
+	if (cfq_group_busy_queues_wl(RT_WORKLOAD, cfqd, cfqg))
 		cfqd->serving_prio = RT_WORKLOAD;
-	else if (cfq_busy_queues_wl(BE_WORKLOAD, cfqd))
+	else if (cfq_group_busy_queues_wl(BE_WORKLOAD, cfqd, cfqg))
 		cfqd->serving_prio = BE_WORKLOAD;
 	else {
 		cfqd->serving_prio = IDLE_WORKLOAD;
@@ -1689,9 +1712,11 @@ static void choose_service_tree(struct cfq_data *cfqd, struct cfq_group *cfqg)
 	 * proportional to the number of queues in that workload, over
 	 * all the queues in the same priority class
 	 */
-	slice = cfq_target_latency * count /
-		max_t(unsigned, cfqd->busy_queues_avg[cfqd->serving_prio],
-		      cfq_busy_queues_wl(cfqd->serving_prio, cfqd));
+	group_slice = cfq_group_slice(cfqd, cfqg);
+
+	slice = group_slice * count /
+		max_t(unsigned, cfqg->busy_queues_avg[cfqd->serving_prio],
+		      cfq_group_busy_queues_wl(cfqd->serving_prio, cfqd, cfqg));
 
 	if (cfqd->serving_type == ASYNC_WORKLOAD)
 		/* async workload slice is scaled down according to
-- 
1.6.2.5

