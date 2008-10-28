Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbYJ1Ku7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbYJ1Ku7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:50:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbYJ1Kuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:50:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47846 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbYJ1Kut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:50:49 -0400
Date: Tue, 28 Oct 2008 11:50:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20081028105027.GA26035@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jiri Kosina (1):
      sched: fix documentation reference for sched_min_granularity_ns

Li Zefan (1):
      sched: add CONFIG_SMP consistency

Mike Galbraith (1):
      sched: weaken sync hint

Peter Zijlstra (4):
      sched: fix a find_busiest_group buglet
      sched: more accurate min_vruntime accounting
      sched: re-instate vruntime based wakeup preemption
      sched: virtual time buddy preemption


 Documentation/scheduler/sched-design-CFS.txt |    2 +-
 include/linux/sched.h                        |   12 +-
 kernel/sched.c                               |    3 +-
 kernel/sched_fair.c                          |  169 +++++++++++++++++++-------
 kernel/sched_idletask.c                      |    5 +-
 kernel/sched_rt.c                            |    5 +-
 6 files changed, 139 insertions(+), 57 deletions(-)

diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 9d8eb55..eb471c7 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -92,7 +92,7 @@ other HZ detail.  Thus the CFS scheduler has no notion of "timeslices" in the
 way the previous scheduler had, and has no heuristics whatsoever.  There is
 only one central tunable (you have to switch on CONFIG_SCHED_DEBUG):
 
-   /proc/sys/kernel/sched_granularity_ns
+   /proc/sys/kernel/sched_min_granularity_ns
 
 which can be used to tune the scheduler from "desktop" (i.e., low latencies) to
 "server" (i.e., good batching) workloads.  It defaults to a setting suitable
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 8478f33..b483f39 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -936,7 +936,6 @@ struct sched_class {
 	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
 	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
 	void (*yield_task) (struct rq *rq);
-	int  (*select_task_rq)(struct task_struct *p, int sync);
 
 	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
 
@@ -944,6 +943,8 @@ struct sched_class {
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
 
 #ifdef CONFIG_SMP
+	int  (*select_task_rq)(struct task_struct *p, int sync);
+
 	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
 			struct rq *busiest, unsigned long max_load_move,
 			struct sched_domain *sd, enum cpu_idle_type idle,
@@ -955,16 +956,17 @@ struct sched_class {
 	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
 	void (*post_schedule) (struct rq *this_rq);
 	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
-#endif
 
-	void (*set_curr_task) (struct rq *rq);
-	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_new) (struct rq *rq, struct task_struct *p);
 	void (*set_cpus_allowed)(struct task_struct *p,
 				 const cpumask_t *newmask);
 
 	void (*rq_online)(struct rq *rq);
 	void (*rq_offline)(struct rq *rq);
+#endif
+
+	void (*set_curr_task) (struct rq *rq);
+	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
+	void (*task_new) (struct rq *rq, struct task_struct *p);
 
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
 			       int running);
diff --git a/kernel/sched.c b/kernel/sched.c
index 6625c3c..e8819bc 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -386,7 +386,6 @@ struct cfs_rq {
 
 	u64 exec_clock;
 	u64 min_vruntime;
-	u64 pair_start;
 
 	struct rb_root tasks_timeline;
 	struct rb_node *rb_leftmost;
@@ -3344,7 +3343,7 @@ small_imbalance:
 		} else
 			this_load_per_task = cpu_avg_load_per_task(this_cpu);
 
-		if (max_load - this_load + 2*busiest_load_per_task >=
+		if (max_load - this_load + busiest_load_per_task >=
 					busiest_load_per_task * imbn) {
 			*imbalance = busiest_load_per_task;
 			return busiest;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 9573c33..ce514af 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -143,6 +143,49 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
 	return se->parent;
 }
 
+/* return depth at which a sched entity is present in the hierarchy */
+static inline int depth_se(struct sched_entity *se)
+{
+	int depth = 0;
+
+	for_each_sched_entity(se)
+		depth++;
+
+	return depth;
+}
+
+static void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+	int se_depth, pse_depth;
+
+	/*
+	 * preemption test can be made between sibling entities who are in the
+	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
+	 * both tasks until we find their ancestors who are siblings of common
+	 * parent.
+	 */
+
+	/* First walk up until both entities are at same depth */
+	se_depth = depth_se(*se);
+	pse_depth = depth_se(*pse);
+
+	while (se_depth > pse_depth) {
+		se_depth--;
+		*se = parent_entity(*se);
+	}
+
+	while (pse_depth > se_depth) {
+		pse_depth--;
+		*pse = parent_entity(*pse);
+	}
+
+	while (!is_same_group(*se, *pse)) {
+		*se = parent_entity(*se);
+		*pse = parent_entity(*pse);
+	}
+}
+
 #else	/* CONFIG_FAIR_GROUP_SCHED */
 
 static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
@@ -193,6 +236,11 @@ static inline struct sched_entity *parent_entity(struct sched_entity *se)
 	return NULL;
 }
 
+static inline void
+find_matching_se(struct sched_entity **se, struct sched_entity **pse)
+{
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 
@@ -223,6 +271,27 @@ static inline s64 entity_key(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	return se->vruntime - cfs_rq->min_vruntime;
 }
 
+static void update_min_vruntime(struct cfs_rq *cfs_rq)
+{
+	u64 vruntime = cfs_rq->min_vruntime;
+
+	if (cfs_rq->curr)
+		vruntime = cfs_rq->curr->vruntime;
+
+	if (cfs_rq->rb_leftmost) {
+		struct sched_entity *se = rb_entry(cfs_rq->rb_leftmost,
+						   struct sched_entity,
+						   run_node);
+
+		if (vruntime == cfs_rq->min_vruntime)
+			vruntime = se->vruntime;
+		else
+			vruntime = min_vruntime(vruntime, se->vruntime);
+	}
+
+	cfs_rq->min_vruntime = max_vruntime(cfs_rq->min_vruntime, vruntime);
+}
+
 /*
  * Enqueue an entity into the rb-tree:
  */
@@ -256,15 +325,8 @@ static void __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	 * Maintain a cache of leftmost tree entries (it is frequently
 	 * used):
 	 */
-	if (leftmost) {
+	if (leftmost)
 		cfs_rq->rb_leftmost = &se->run_node;
-		/*
-		 * maintain cfs_rq->min_vruntime to be a monotonic increasing
-		 * value tracking the leftmost vruntime in the tree.
-		 */
-		cfs_rq->min_vruntime =
-			max_vruntime(cfs_rq->min_vruntime, se->vruntime);
-	}
 
 	rb_link_node(&se->run_node, parent, link);
 	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
@@ -274,18 +336,9 @@ static void __dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
 	if (cfs_rq->rb_leftmost == &se->run_node) {
 		struct rb_node *next_node;
-		struct sched_entity *next;
 
 		next_node = rb_next(&se->run_node);
 		cfs_rq->rb_leftmost = next_node;
-
-		if (next_node) {
-			next = rb_entry(next_node,
-					struct sched_entity, run_node);
-			cfs_rq->min_vruntime =
-				max_vruntime(cfs_rq->min_vruntime,
-					     next->vruntime);
-		}
 	}
 
 	if (cfs_rq->next == se)
@@ -424,6 +477,7 @@ __update_curr(struct cfs_rq *cfs_rq, struct sched_entity *curr,
 	schedstat_add(cfs_rq, exec_clock, delta_exec);
 	delta_exec_weighted = calc_delta_fair(delta_exec, curr);
 	curr->vruntime += delta_exec_weighted;
+	update_min_vruntime(cfs_rq);
 }
 
 static void update_curr(struct cfs_rq *cfs_rq)
@@ -613,13 +667,7 @@ static void check_spread(struct cfs_rq *cfs_rq, struct sched_entity *se)
 static void
 place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 {
-	u64 vruntime;
-
-	if (first_fair(cfs_rq)) {
-		vruntime = min_vruntime(cfs_rq->min_vruntime,
-				__pick_next_entity(cfs_rq)->vruntime);
-	} else
-		vruntime = cfs_rq->min_vruntime;
+	u64 vruntime = cfs_rq->min_vruntime;
 
 	/*
 	 * The 'current' period is already promised to the current tasks,
@@ -696,6 +744,7 @@ dequeue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int sleep)
 	if (se != cfs_rq->curr)
 		__dequeue_entity(cfs_rq, se);
 	account_entity_dequeue(cfs_rq, se);
+	update_min_vruntime(cfs_rq);
 }
 
 /*
@@ -742,16 +791,14 @@ set_next_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	se->prev_sum_exec_runtime = se->sum_exec_runtime;
 }
 
+static int
+wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se);
+
 static struct sched_entity *
 pick_next(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
-	struct rq *rq = rq_of(cfs_rq);
-	u64 pair_slice = rq->clock - cfs_rq->pair_start;
-
-	if (!cfs_rq->next || pair_slice > sysctl_sched_min_granularity) {
-		cfs_rq->pair_start = rq->clock;
+	if (!cfs_rq->next || wakeup_preempt_entity(cfs_rq->next, se) == 1)
 		return se;
-	}
 
 	return cfs_rq->next;
 }
@@ -1122,10 +1169,9 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
-	if (!sync && sched_feat(SYNC_WAKEUPS) &&
-	    curr->se.avg_overlap < sysctl_sched_migration_cost &&
-	    p->se.avg_overlap < sysctl_sched_migration_cost)
-		sync = 1;
+	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
+			p->se.avg_overlap > sysctl_sched_migration_cost))
+		sync = 0;
 
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
@@ -1244,13 +1290,42 @@ static unsigned long wakeup_gran(struct sched_entity *se)
 	 * More easily preempt - nice tasks, while not making it harder for
 	 * + nice tasks.
 	 */
-	if (sched_feat(ASYM_GRAN))
-		gran = calc_delta_mine(gran, NICE_0_LOAD, &se->load);
+	if (!sched_feat(ASYM_GRAN) || se->load.weight > NICE_0_LOAD)
+		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
 
 	return gran;
 }
 
 /*
+ * Should 'se' preempt 'curr'.
+ *
+ *             |s1
+ *        |s2
+ *   |s3
+ *         g
+ *      |<--->|c
+ *
+ *  w(c, s1) = -1
+ *  w(c, s2) =  0
+ *  w(c, s3) =  1
+ *
+ */
+static int
+wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
+{
+	s64 gran, vdiff = curr->vruntime - se->vruntime;
+
+	if (vdiff <= 0)
+		return -1;
+
+	gran = wakeup_gran(curr);
+	if (vdiff > gran)
+		return 1;
+
+	return 0;
+}
+
+/*
  * Preempt the current task with a newly woken task if needed:
  */
 static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
@@ -1258,7 +1333,6 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
-	s64 delta_exec;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -1296,9 +1370,19 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 		return;
 	}
 
-	delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
-	if (delta_exec > wakeup_gran(pse))
-		resched_task(curr);
+	find_matching_se(&se, &pse);
+
+	while (se) {
+		BUG_ON(!pse);
+
+		if (wakeup_preempt_entity(se, pse) == 1) {
+			resched_task(curr);
+			break;
+		}
+
+		se = parent_entity(se);
+		pse = parent_entity(pse);
+	}
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
@@ -1594,9 +1678,6 @@ static const struct sched_class fair_sched_class = {
 	.enqueue_task		= enqueue_task_fair,
 	.dequeue_task		= dequeue_task_fair,
 	.yield_task		= yield_task_fair,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_fair,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_wakeup,
 
@@ -1604,6 +1685,8 @@ static const struct sched_class fair_sched_class = {
 	.put_prev_task		= put_prev_task_fair,
 
 #ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_fair,
+
 	.load_balance		= load_balance_fair,
 	.move_one_task		= move_one_task_fair,
 #endif
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index dec4cca..8a21a2e 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -105,9 +105,6 @@ static const struct sched_class idle_sched_class = {
 
 	/* dequeue is not valid, we print a debug message there: */
 	.dequeue_task		= dequeue_task_idle,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_idle,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_idle,
 
@@ -115,6 +112,8 @@ static const struct sched_class idle_sched_class = {
 	.put_prev_task		= put_prev_task_idle,
 
 #ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_idle,
+
 	.load_balance		= load_balance_idle,
 	.move_one_task		= move_one_task_idle,
 #endif
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index b446dc8..d9ba9d5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -1504,9 +1504,6 @@ static const struct sched_class rt_sched_class = {
 	.enqueue_task		= enqueue_task_rt,
 	.dequeue_task		= dequeue_task_rt,
 	.yield_task		= yield_task_rt,
-#ifdef CONFIG_SMP
-	.select_task_rq		= select_task_rq_rt,
-#endif /* CONFIG_SMP */
 
 	.check_preempt_curr	= check_preempt_curr_rt,
 
@@ -1514,6 +1511,8 @@ static const struct sched_class rt_sched_class = {
 	.put_prev_task		= put_prev_task_rt,
 
 #ifdef CONFIG_SMP
+	.select_task_rq		= select_task_rq_rt,
+
 	.load_balance		= load_balance_rt,
 	.move_one_task		= move_one_task_rt,
 	.set_cpus_allowed       = set_cpus_allowed_rt,
