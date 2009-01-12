Return-Path: <linux-kernel-owner+w=401wt.eu-S1756980AbZALTbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbZALTbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbZALTat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:30:49 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:59931
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755306AbZALTar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:30:47 -0500
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 14:30:47 EST
From: Gregory Haskins <ghaskins@novell.com>
Subject: [git pull] fixes for tip/sched/rt
To: mingo@elte.hu
Cc: rostedt@home.goodmis.org, peterz@infradead.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2009 14:23:11 -0500
Message-ID: <20090112192200.4511.6357.stgit@dev.haskins.net>
In-Reply-To: <20090112144548.GA14016@elte.hu>
References: <20090112144548.GA14016@elte.hu>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0a6d4e1dc9154c4376358663d74060d1e33d203e:
  Ingo Molnar (1):
        Merge branch 'sched/latest' of git://git.kernel.org/.../ghaskins/linux-2.6-hacks into sched/rt

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.git sched/latest

Gregory Haskins (1):
      sched: fix build error in kernel/sched_rt.c when RT_GROUP_SCHED && !SMP

 kernel/sched.c    |    4 +
 kernel/sched_rt.c |  223 +++++++++++++++++++++++++++++++----------------------
 2 files changed, 136 insertions(+), 91 deletions(-)

---------------------------

sched: fix build error in kernel/sched_rt.c when RT_GROUP_SCHED && !SMP

Ingo found a build error in the scheduler when RT_GROUP_SCHED was
enabled, but SMP was not.  This patch rearranges the code such
that it is a little more streamlined and compiles under all permutations
of SMP, UP and RT_GROUP_SCHED.  It was boot tested on my 4-way x86_64
and it still passes preempt-test.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 kernel/sched.c    |    4 +
 kernel/sched_rt.c |  223 +++++++++++++++++++++++++++++++----------------------
 2 files changed, 136 insertions(+), 91 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index dd1a146..2b703f1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -466,7 +466,9 @@ struct rt_rq {
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
+#ifdef CONFIG_SMP
 		int next; /* next highest */
+#endif
 	} highest_prio;
 #endif
 #ifdef CONFIG_SMP
@@ -8267,8 +8269,10 @@ static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
 
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	rt_rq->highest_prio.curr = MAX_RT_PRIO;
+#ifdef CONFIG_SMP
 	rt_rq->highest_prio.next = MAX_RT_PRIO;
 #endif
+#endif
 #ifdef CONFIG_SMP
 	rt_rq->rt_nr_migratory = 0;
 	rt_rq->overloaded = 0;
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 18c7b5b..c9bcdc5 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -3,6 +3,40 @@
  * policies)
  */
 
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
+{
+	return container_of(rt_se, struct task_struct, rt);
+}
+
+#ifdef CONFIG_RT_GROUP_SCHED
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return rt_rq->rq;
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	return rt_se->rt_rq;
+}
+
+#else /* CONFIG_RT_GROUP_SCHED */
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return container_of(rt_rq, struct rq, rt);
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	struct task_struct *p = rt_task_of(rt_se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->rt;
+}
+
+#endif /* CONFIG_RT_GROUP_SCHED */
+
 #ifdef CONFIG_SMP
 
 static inline int rt_overloaded(struct rq *rq)
@@ -37,19 +71,35 @@ static inline void rt_clear_overload(struct rq *rq)
 	cpumask_clear_cpu(rq->cpu, rq->rd->rto_mask);
 }
 
-static void update_rt_migration(struct rq *rq)
+static void update_rt_migration(struct rt_rq *rt_rq)
 {
-	if (rq->rt.rt_nr_migratory && (rq->rt.rt_nr_running > 1)) {
-		if (!rq->rt.overloaded) {
-			rt_set_overload(rq);
-			rq->rt.overloaded = 1;
+	if (rt_rq->rt_nr_migratory && (rt_rq->rt_nr_running > 1)) {
+		if (!rt_rq->overloaded) {
+			rt_set_overload(rq_of_rt_rq(rt_rq));
+			rt_rq->overloaded = 1;
 		}
-	} else if (rq->rt.overloaded) {
-		rt_clear_overload(rq);
-		rq->rt.overloaded = 0;
+	} else if (rt_rq->overloaded) {
+		rt_clear_overload(rq_of_rt_rq(rt_rq));
+		rt_rq->overloaded = 0;
 	}
 }
 
+static void inc_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	if (rt_se->nr_cpus_allowed > 1)
+		rt_rq->rt_nr_migratory++;
+
+	update_rt_migration(rt_rq);
+}
+
+static void dec_rt_migration(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	if (rt_se->nr_cpus_allowed > 1)
+		rt_rq->rt_nr_migratory--;
+
+	update_rt_migration(rt_rq);
+}
+
 static void enqueue_pushable_task(struct rq *rq, struct task_struct *p)
 {
 	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
@@ -66,14 +116,11 @@ static void dequeue_pushable_task(struct rq *rq, struct task_struct *p)
 
 #define enqueue_pushable_task(rq, p) do { } while (0)
 #define dequeue_pushable_task(rq, p) do { } while (0)
+#define inc_rt_migration(se, rq) do { } while (0)
+#define dec_rt_migration(se, rq) do { } while (0)
 
 #endif /* CONFIG_SMP */
 
-static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
-{
-	return container_of(rt_se, struct task_struct, rt);
-}
-
 static inline int on_rt_rq(struct sched_rt_entity *rt_se)
 {
 	return !list_empty(&rt_se->run_list);
@@ -97,16 +144,6 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	list_for_each_entry_rcu(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
 
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	return rt_rq->rq;
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	return rt_se->rt_rq;
-}
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = rt_se->parent)
 
@@ -194,19 +231,6 @@ static inline u64 sched_rt_period(struct rt_rq *rt_rq)
 #define for_each_leaf_rt_rq(rt_rq, rq) \
 	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
 
-static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
-{
-	return container_of(rt_rq, struct rq, rt);
-}
-
-static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
-{
-	struct task_struct *p = rt_task_of(rt_se);
-	struct rq *rq = task_rq(p);
-
-	return &rq->rt;
-}
-
 #define for_each_sched_rt_entity(rt_se) \
 	for (; rt_se; rt_se = NULL)
 
@@ -565,7 +589,7 @@ static void update_curr_rt(struct rq *rq)
 	}
 }
 
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+#if defined CONFIG_SMP
 
 static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu);
 
@@ -580,31 +604,29 @@ static inline int next_prio(struct rq *rq)
 }
 #endif
 
-static inline
-void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
+static void
+inc_rt_prio(struct rt_rq *rt_rq, int prio)
 {
-	int prio = rt_se_prio(rt_se);
-#ifdef CONFIG_SMP
-	struct rq *rq = rq_of_rt_rq(rt_rq);
-#endif
+	int prev_prio = rt_rq->highest_prio.curr;
 
-	WARN_ON(!rt_prio(prio));
-	rt_rq->rt_nr_running++;
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
-	if (prio < rt_rq->highest_prio.curr) {
+	if (prio < prev_prio)
+		rt_rq->highest_prio.curr = prio;
+
+#ifdef CONFIG_SMP
+	if (prio < prev_prio) {
+		struct rq *rq = rq_of_rt_rq(rt_rq);
 
 		/*
 		 * If the new task is higher in priority than anything on the
-		 * run-queue, we have a new high that must be published to
-		 * the world.  We also know that the previous high becomes
-		 * our next-highest.
+		 * run-queue, we know that the previous high becomes our
+		 * next-highest.
 		 */
-		rt_rq->highest_prio.next = rt_rq->highest_prio.curr;
-		rt_rq->highest_prio.curr = prio;
-#ifdef CONFIG_SMP
+		rt_rq->highest_prio.next = prev_prio;
+
 		if (rq->online)
 			cpupri_set(&rq->rd->cpupri, rq->cpu, prio);
-#endif
+
 	} else if (prio == rt_rq->highest_prio.curr)
 		/*
 		 * If the next task is equal in priority to the highest on
@@ -616,67 +638,86 @@ void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 		/*
 		 * Otherwise, we need to recompute next-highest
 		 */
-		rt_rq->highest_prio.next = next_prio(rq);
-#endif
-#ifdef CONFIG_SMP
-	if (rt_se->nr_cpus_allowed > 1)
-		rq->rt.rt_nr_migratory++;
-
-	update_rt_migration(rq);
-#endif
-#ifdef CONFIG_RT_GROUP_SCHED
-	if (rt_se_boosted(rt_se))
-		rt_rq->rt_nr_boosted++;
-
-	if (rt_rq->tg)
-		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
-#else
-	start_rt_bandwidth(&def_rt_bandwidth);
+		rt_rq->highest_prio.next = next_prio(rq_of_rt_rq(rt_rq));
 #endif
 }
 
-static inline
-void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+static void
+dec_rt_prio(struct rt_rq *rt_rq, int prio)
 {
+	int prev_prio = rt_rq->highest_prio.curr;
+
 #ifdef CONFIG_SMP
 	struct rq *rq = rq_of_rt_rq(rt_rq);
-	int highest_prio = rt_rq->highest_prio.curr;
 #endif
 
-	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
-	WARN_ON(!rt_rq->rt_nr_running);
-	rt_rq->rt_nr_running--;
-#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_rq->rt_nr_running) {
-		int prio = rt_se_prio(rt_se);
 
-		WARN_ON(prio < rt_rq->highest_prio.curr);
+		WARN_ON(prio < prev_prio);
 
 		/*
-		 * This may have been our highest or next-highest priority
-		 * task and therefore we may have some recomputation to do
+		 * This may have been our highest task, and therefore
+		 * we may have some recomputation to do
 		 */
-		if (prio == rt_rq->highest_prio.curr) {
+		if (prio == prev_prio) {
 			struct rt_prio_array *array = &rt_rq->active;
 
 			rt_rq->highest_prio.curr =
 				sched_find_first_bit(array->bitmap);
 		}
 
-		if (prio <= rt_rq->highest_prio.next)
-			rt_rq->highest_prio.next = next_prio(rq);
 	} else
 		rt_rq->highest_prio.curr = MAX_RT_PRIO;
-#endif
+
 #ifdef CONFIG_SMP
-	if (rt_se->nr_cpus_allowed > 1)
-		rq->rt.rt_nr_migratory--;
+	if (rt_rq->rt_nr_running && (prio <= rt_rq->highest_prio.next))
+		rt_rq->highest_prio.next = next_prio(rq);
 
-	if (rq->online && rt_rq->highest_prio.curr != highest_prio)
+	if (rq->online && rt_rq->highest_prio.curr != prev_prio)
 		cpupri_set(&rq->rd->cpupri, rq->cpu, rt_rq->highest_prio.curr);
+#endif
+
+}
+
+#else
+
+#define inc_rt_prio(rt_rq, prio) do { } while (0)
+#define dec_rt_prio(rt_rq, prio) do { } while (0)
+
+#endif /* CONFIG_SMP || CONFIG_RT_GROUP_SCHED */
+
+static inline
+void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	int prio = rt_se_prio(rt_se);
+
+	WARN_ON(!rt_prio(prio));
+	rt_rq->rt_nr_running++;
+
+	inc_rt_prio(rt_rq, prio);
+	inc_rt_migration(rt_se, rt_rq);
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	if (rt_se_boosted(rt_se))
+		rt_rq->rt_nr_boosted++;
+
+	if (rt_rq->tg)
+		start_rt_bandwidth(&rt_rq->tg->rt_bandwidth);
+#else
+	start_rt_bandwidth(&def_rt_bandwidth);
+#endif
+}
+
+static inline
+void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
+{
+	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
+	WARN_ON(!rt_rq->rt_nr_running);
+	rt_rq->rt_nr_running--;
+
+	dec_rt_prio(rt_rq, rt_se_prio(rt_se));
+	dec_rt_migration(rt_se, rt_rq);
 
-	update_rt_migration(rq);
-#endif /* CONFIG_SMP */
 #ifdef CONFIG_RT_GROUP_SCHED
 	if (rt_se_boosted(rt_se))
 		rt_rq->rt_nr_boosted--;
@@ -1451,7 +1492,7 @@ static void set_cpus_allowed_rt(struct task_struct *p,
 			rq->rt.rt_nr_migratory--;
 		}
 
-		update_rt_migration(rq);
+		update_rt_migration(&rq->rt);
 	}
 
 	cpumask_copy(&p->cpus_allowed, new_mask);

