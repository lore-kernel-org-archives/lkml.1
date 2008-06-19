Return-Path: <linux-kernel-owner+w=401wt.eu-S1758734AbYFSPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758734AbYFSPPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 11:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbYFSPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 11:15:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37194 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752977AbYFSPPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 11:15:07 -0400
Date: Thu, 19 Jun 2008 17:14:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler fixes
Message-ID: <20080619151450.GA10024@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest scheduler fixes git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

Thanks,

	Ingo

------------------>
Bharath Ravi (1):
      sched, delay accounting: fix incorrect delay time when constantly waiting on runqueue

Dario Faggioli (1):
      sched: NULL pointer dereference while setting sched_rt_period_us

Max Krasnyansky (1):
      sched: CPU hotplug events must not destroy scheduler domains created by the cpusets

Peter Zijlstra (3):
      sched: rt-group: fix hierarchy
      sched: rt-group: heirarchy aware throttle
      sched: rt-group: fix RR buglet

Rabin Vincent (1):
      sched: fix defined-but-unused warning

 kernel/cpuset.c      |    6 ++++
 kernel/sched.c       |   27 +++++++++++++++++++-
 kernel/sched_rt.c    |   63 ++++++++++++++++++++++++++++---------------------
 kernel/sched_stats.h |    6 ++++
 4 files changed, 73 insertions(+), 29 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 039baa4..bceb895 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1890,6 +1890,12 @@ static void common_cpu_mem_hotplug_unplug(void)
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 	scan_for_empty_cpusets(&top_cpuset);
 
+	/*
+	 * Scheduler destroys domains on hotplug events.
+	 * Rebuild them based on the current settings.
+	 */
+	rebuild_sched_domains();
+
 	cgroup_unlock();
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index eaf6751..4a3cb06 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1127,6 +1127,7 @@ static enum hrtimer_restart hrtick(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+#ifdef CONFIG_SMP
 static void hotplug_hrtick_disable(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
@@ -1182,6 +1183,7 @@ static void init_hrtick(void)
 {
 	hotcpu_notifier(hotplug_hrtick, 0);
 }
+#endif /* CONFIG_SMP */
 
 static void init_rq_hrtick(struct rq *rq)
 {
@@ -7236,6 +7238,18 @@ void __attribute__((weak)) arch_update_cpu_topology(void)
 }
 
 /*
+ * Free current domain masks.
+ * Called after all cpus are attached to NULL domain.
+ */
+static void free_sched_domains(void)
+{
+	ndoms_cur = 0;
+	if (doms_cur != &fallback_doms)
+		kfree(doms_cur);
+	doms_cur = &fallback_doms;
+}
+
+/*
  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
@@ -7382,6 +7396,7 @@ int arch_reinit_sched_domains(void)
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
 	detach_destroy_domains(&cpu_online_map);
+	free_sched_domains();
 	err = arch_init_sched_domains(&cpu_online_map);
 	mutex_unlock(&sched_domains_mutex);
 	put_online_cpus();
@@ -7467,6 +7482,7 @@ static int update_sched_domains(struct notifier_block *nfb,
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		detach_destroy_domains(&cpu_online_map);
+		free_sched_domains();
 		return NOTIFY_OK;
 
 	case CPU_UP_CANCELED:
@@ -7485,8 +7501,16 @@ static int update_sched_domains(struct notifier_block *nfb,
 		return NOTIFY_DONE;
 	}
 
+#ifndef CONFIG_CPUSETS
+	/*
+	 * Create default domain partitioning if cpusets are disabled.
+	 * Otherwise we let cpusets rebuild the domains based on the
+	 * current setup.
+	 */
+
 	/* The hotplug lock is already held by cpu_up/cpu_down */
 	arch_init_sched_domains(&cpu_online_map);
+#endif
 
 	return NOTIFY_OK;
 }
@@ -7626,7 +7650,6 @@ static void init_tg_rt_entry(struct task_group *tg, struct rt_rq *rt_rq,
 	else
 		rt_se->rt_rq = parent->my_q;
 
-	rt_se->rt_rq = &rq->rt;
 	rt_se->my_q = rt_rq;
 	rt_se->parent = parent;
 	INIT_LIST_HEAD(&rt_se->run_list);
@@ -8348,7 +8371,7 @@ static unsigned long to_ratio(u64 period, u64 runtime)
 #ifdef CONFIG_CGROUP_SCHED
 static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
-	struct task_group *tgi, *parent = tg->parent;
+	struct task_group *tgi, *parent = tg ? tg->parent : NULL;
 	unsigned long total = 0;
 
 	if (!parent) {
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 3432d57..1dad5bb 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -449,13 +449,19 @@ void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 #endif
 }
 
-static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+static void __enqueue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
 	struct rt_rq *group_rq = group_rt_rq(rt_se);
 
-	if (group_rq && rt_rq_throttled(group_rq))
+	/*
+	 * Don't enqueue the group if its throttled, or when empty.
+	 * The latter is a consequence of the former when a child group
+	 * get throttled and the current group doesn't have any other
+	 * active members.
+	 */
+	if (group_rq && (rt_rq_throttled(group_rq) || !group_rq->rt_nr_running))
 		return;
 
 	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
@@ -464,7 +470,7 @@ static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
 	inc_rt_tasks(rt_se, rt_rq);
 }
 
-static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
+static void __dequeue_rt_entity(struct sched_rt_entity *rt_se)
 {
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	struct rt_prio_array *array = &rt_rq->active;
@@ -480,11 +486,10 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
  * Because the prio of an upper entry depends on the lower
  * entries, we must remove entries top - down.
  */
-static void dequeue_rt_stack(struct task_struct *p)
+static void dequeue_rt_stack(struct sched_rt_entity *rt_se)
 {
-	struct sched_rt_entity *rt_se, *back = NULL;
+	struct sched_rt_entity *back = NULL;
 
-	rt_se = &p->rt;
 	for_each_sched_rt_entity(rt_se) {
 		rt_se->back = back;
 		back = rt_se;
@@ -492,7 +497,26 @@ static void dequeue_rt_stack(struct task_struct *p)
 
 	for (rt_se = back; rt_se; rt_se = rt_se->back) {
 		if (on_rt_rq(rt_se))
-			dequeue_rt_entity(rt_se);
+			__dequeue_rt_entity(rt_se);
+	}
+}
+
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
+{
+	dequeue_rt_stack(rt_se);
+	for_each_sched_rt_entity(rt_se)
+		__enqueue_rt_entity(rt_se);
+}
+
+static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
+{
+	dequeue_rt_stack(rt_se);
+
+	for_each_sched_rt_entity(rt_se) {
+		struct rt_rq *rt_rq = group_rt_rq(rt_se);
+
+		if (rt_rq && rt_rq->rt_nr_running)
+			__enqueue_rt_entity(rt_se);
 	}
 }
 
@@ -506,32 +530,15 @@ static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
 	if (wakeup)
 		rt_se->timeout = 0;
 
-	dequeue_rt_stack(p);
-
-	/*
-	 * enqueue everybody, bottom - up.
-	 */
-	for_each_sched_rt_entity(rt_se)
-		enqueue_rt_entity(rt_se);
+	enqueue_rt_entity(rt_se);
 }
 
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 {
 	struct sched_rt_entity *rt_se = &p->rt;
-	struct rt_rq *rt_rq;
 
 	update_curr_rt(rq);
-
-	dequeue_rt_stack(p);
-
-	/*
-	 * re-enqueue all non-empty rt_rq entities.
-	 */
-	for_each_sched_rt_entity(rt_se) {
-		rt_rq = group_rt_rq(rt_se);
-		if (rt_rq && rt_rq->rt_nr_running)
-			enqueue_rt_entity(rt_se);
-	}
+	dequeue_rt_entity(rt_se);
 }
 
 /*
@@ -542,8 +549,10 @@ static
 void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
 {
 	struct rt_prio_array *array = &rt_rq->active;
+	struct list_head *queue = array->queue + rt_se_prio(rt_se);
 
-	list_move_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	if (on_rt_rq(rt_se))
+		list_move_tail(&rt_se->run_list, queue);
 }
 
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)
diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
index a38878e..80179ef 100644
--- a/kernel/sched_stats.h
+++ b/kernel/sched_stats.h
@@ -198,6 +198,9 @@ static inline void sched_info_queued(struct task_struct *t)
 /*
  * Called when a process ceases being the active-running process, either
  * voluntarily or involuntarily.  Now we can calculate how long we ran.
+ * Also, if the process is still in the TASK_RUNNING state, call
+ * sched_info_queued() to mark that it has now again started waiting on
+ * the runqueue.
  */
 static inline void sched_info_depart(struct task_struct *t)
 {
@@ -206,6 +209,9 @@ static inline void sched_info_depart(struct task_struct *t)
 
 	t->sched_info.cpu_time += delta;
 	rq_sched_info_depart(task_rq(t), delta);
+
+	if (t->state == TASK_RUNNING)
+		sched_info_queued(t);
 }
 
 /*
