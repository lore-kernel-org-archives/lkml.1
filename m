Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbZLKBjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbZLKBjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 20:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762165AbZLKBjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 20:39:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:48462 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761644AbZLKBjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 20:39:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,378,1257148800"; 
   d="scan'208";a="577664821"
Message-Id: <20091211013056.305998000@intel.com>
References: <20091211012748.267627000@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Dec 2009 17:27:49 -0800
From: venkatesh.pallipadi@intel.com
To: Peter Zijlstra <peterz@infradead.org>, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] sched: Change the nohz ilb logic from pull to push model
Content-Disposition: inline; filename=0001-sched-Change-the-nohz-ilb-logic-from-pull-to-push-m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the new push model, all idle CPUs indeed go into nohz mode. There is
still the concept of idle load balancer. Busy CPU kicks the nohz
balancer when any of the nohz CPUs need idle load balancing.
The kickee CPU does the idle load balancing on behalf of all idle CPUs
instead of the normal idle balance.

This addresses two problems with the current nohz ilb logic
* the balancer will continue to have periodic ticks and wakeup
  frequently, even though it may not have any rebalancing to do on
  behalf of any of the idle CPUs.
* On x86 and CPUs that have APIC timer stoppage on idle CPUs, this
  periodic wakeup can result in an additional interrupt on a CPU
  doing the timer broadcast.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 include/linux/sched.h    |    7 +-
 kernel/sched.c           |  256 ++++++++++++++++++++++++++++------------------
 kernel/time/tick-sched.c |    8 +--
 3 files changed, 160 insertions(+), 111 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..15c05c2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -266,13 +266,10 @@ extern void task_rq_unlock_wait(struct task_struct *p);
 
 extern cpumask_var_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
-extern int select_nohz_load_balancer(int cpu);
+extern void select_nohz_load_balancer(int stop_tick);
 extern int get_nohz_load_balancer(void);
 #else
-static inline int select_nohz_load_balancer(int cpu)
-{
-	return 0;
-}
+static inline void select_nohz_load_balancer(int stop_tick) { }
 #endif
 
 /*
diff --git a/kernel/sched.c b/kernel/sched.c
index 3c11ae0..aea2e32 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -536,7 +536,7 @@ struct rq {
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 #ifdef CONFIG_NO_HZ
 	unsigned long last_tick_seen;
-	unsigned char in_nohz_recently;
+	unsigned char nohz_balance_kick;
 #endif
 	/* capture load from *all* tasks on this cpu: */
 	struct load_weight load;
@@ -4507,12 +4507,45 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 }
 
 #ifdef CONFIG_NO_HZ
+
+/*
+ * idle load balancing details
+ * - One of the idle CPUs nominates itself as idle load_balancer, while
+ *   entering idle.
+ * - With previous logic, this idle load balancer CPU will not go into
+ *   tickless mode when it is idle and does the idle load balancing for
+ *   all the idle CPUs.
+ * - With new logic, this idle load balancer CPU will also go into
+ *   tickless mode when it is idle, just like all other idle CPUs
+ * - When one of the busy CPUs notice that there may be an idle rebalancing
+ *   needed, they will kick the idle load balancer, which then does idle
+ *   load balancing for all the idle CPUs.
+ * - As idle load balancing looks at the load of all the CPUs, not all busy
+ *   CPUs need to do this idle load balancer kick.
+ * - first_pick_cpu is the one of the busy CPUs which will kick
+ *   idle load balancer when it has more than one process active. This
+ *   eliminates the need for idle load balancing altogether when we have
+ *   only one running process in the system (common case).
+ * - If there are more than one busy CPU, idle load balancer may have
+ *   to run for active_load_balance to happen (i.e., two busy CPUs are
+ *   SMT or core siblings and can run better if they move to different
+ *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
+ *   which will kick idle load balancer as soon as it has any load.
+ * - With previous logic, idle load balancer used to run at every tick.
+ *   With new logic, idle load balancer tracks the rq->next_balance for all
+ *   the idle CPUs and does idle load balancing only when needed.
+ */
 static struct {
 	atomic_t load_balancer;
-	cpumask_var_t cpu_mask;
-	cpumask_var_t ilb_grp_nohz_mask;
+	atomic_t first_pick_cpu;
+	atomic_t second_pick_cpu;
+	cpumask_var_t idle_cpus_mask;
+	cpumask_var_t tmp_nohz_mask;
+	unsigned long next_balance;	/* in jiffy units */
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
+	.first_pick_cpu = ATOMIC_INIT(-1),
+	.second_pick_cpu = ATOMIC_INIT(-1),
 };
 
 int get_nohz_load_balancer(void)
@@ -4567,17 +4600,17 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
  */
 static inline int is_semi_idle_group(struct sched_group *ilb_group)
 {
-	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
+	cpumask_and(nohz.tmp_nohz_mask, nohz.idle_cpus_mask,
 					sched_group_cpus(ilb_group));
 
 	/*
 	 * A sched_group is semi-idle when it has atleast one busy cpu
 	 * and atleast one idle cpu.
 	 */
-	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
+	if (cpumask_empty(nohz.tmp_nohz_mask))
 		return 0;
 
-	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
+	if (cpumask_equal(nohz.tmp_nohz_mask, sched_group_cpus(ilb_group)))
 		return 0;
 
 	return 1;
@@ -4610,7 +4643,7 @@ static int find_new_ilb(int cpu)
 	 * Optimize for the case when we have no idle CPUs or only one
 	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
 	 */
-	if (cpumask_weight(nohz.cpu_mask) < 2)
+	if (cpumask_weight(nohz.idle_cpus_mask) < 2)
 		goto out_done;
 
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
@@ -4618,7 +4651,7 @@ static int find_new_ilb(int cpu)
 
 		do {
 			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.ilb_grp_nohz_mask);
+				return cpumask_first(nohz.tmp_nohz_mask);
 
 			ilb_group = ilb_group->next;
 
@@ -4626,45 +4659,61 @@ static int find_new_ilb(int cpu)
 	}
 
 out_done:
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
 static inline int find_new_ilb(int call_cpu)
 {
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #endif
 
 /*
+ * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
+ * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
+ * CPU (if there is one).
+*/
+static void nohz_balancer_kick(int cpu)
+{
+	int ilb_cpu;
+
+	nohz.next_balance++;
+
+	ilb_cpu = get_nohz_load_balancer();
+	if (ilb_cpu < 0) {
+		ilb_cpu = cpumask_first(nohz.idle_cpus_mask);
+		if (ilb_cpu >= nr_cpu_ids)
+			return;
+	}
+
+	if (!cpu_rq(ilb_cpu)->nohz_balance_kick) {
+		cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
+		resched_cpu(ilb_cpu);
+	}
+	return;
+}
+
+/*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
- * load balancing on behalf of all those cpus. If all the cpus in the system
- * go into this tickless mode, then there will be no ilb owner (as there is
- * no need for one) and all the cpus will sleep till the next wakeup event
- * arrives...
+ * load balancing on behalf of all those cpus.
  *
- * For the ilb owner, tick is not stopped. And this tick will be used
- * for idle load balancing. ilb owner will still be part of
- * nohz.cpu_mask..
+ * When the ilb owner becomes busy, we will not have new ilb owner until some
+ * idle CPU wakes up and goes back to idle or some busy CPU tries to kick
+ * idle load balancing by kicking one of the idle CPUs.
  *
- * While stopping the tick, this cpu will become the ilb owner if there
- * is no other owner. And will be the owner till that cpu becomes busy
- * or if all cpus in the system stop their ticks at which point
- * there is no need for ilb owner.
- *
- * When the ilb owner becomes busy, it nominates another owner, during the
- * next busy scheduler_tick()
+ * Ticks are stopped for the ilb owner as well, with busy CPU kicking this
+ * ilb owner CPU in future (when there is a need for idle load balancing on
+ * behalf of all idle CPUs).
  */
-int select_nohz_load_balancer(int stop_tick)
+void select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
 
 	if (stop_tick) {
-		cpu_rq(cpu)->in_nohz_recently = 1;
-
 		if (!cpu_active(cpu)) {
 			if (atomic_read(&nohz.load_balancer) != cpu)
-				return 0;
+				return;
 
 			/*
 			 * If we are going offline and still the leader,
@@ -4673,28 +4722,20 @@ int select_nohz_load_balancer(int stop_tick)
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
 
-			return 0;
+			return;
 		}
 
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
-
-		/* time for ilb owner also to sleep */
-		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
-			if (atomic_read(&nohz.load_balancer) == cpu)
-				atomic_set(&nohz.load_balancer, -1);
-			return 0;
-		}
+		cpumask_set_cpu(cpu, nohz.idle_cpus_mask);
+		atomic_cmpxchg(&nohz.first_pick_cpu, cpu, -1);
+		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, -1);
 
 		if (atomic_read(&nohz.load_balancer) == -1) {
-			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
-				return 1;
-		} else if (atomic_read(&nohz.load_balancer) == cpu) {
 			int new_ilb;
 
-			if (!(sched_smt_power_savings ||
-						sched_mc_power_savings))
-				return 1;
+			/* make me the ilb owner */
+			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) != -1)
+				return;
+
 			/*
 			 * Check to see if there is a more power-efficient
 			 * ilb.
@@ -4703,21 +4744,18 @@ int select_nohz_load_balancer(int stop_tick)
 			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
 				atomic_set(&nohz.load_balancer, -1);
 				resched_cpu(new_ilb);
-				return 0;
 			}
-			return 1;
 		}
 	} else {
-		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
-			return 0;
+		if (!cpumask_test_cpu(cpu, nohz.idle_cpus_mask))
+			return;
 
-		cpumask_clear_cpu(cpu, nohz.cpu_mask);
+		cpumask_clear_cpu(cpu, nohz.idle_cpus_mask);
 
 		if (atomic_read(&nohz.load_balancer) == cpu)
 			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
 				BUG();
 	}
-	return 0;
 }
 #endif
 
@@ -4801,8 +4839,6 @@ out:
 
 /*
  * run_rebalance_domains is triggered when needed from the scheduler tick.
- * In CONFIG_NO_HZ case, the idle load balance owner will do the
- * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
 static void run_rebalance_domains(struct softirq_action *h)
 {
@@ -4812,19 +4848,27 @@ static void run_rebalance_domains(struct softirq_action *h)
 						CPU_IDLE : CPU_NOT_IDLE;
 
 	rebalance_domains(this_cpu, idle);
+}
 
 #ifdef CONFIG_NO_HZ
+/*
+ * In CONFIG_NO_HZ case, the idle balance kickee will do the
+ * rebalancing for all the cpus for whom scheduler ticks are stopped.
+ */
+static void nohz_idle_balance(int this_cpu, struct rq *this_rq)
+{
+	rebalance_domains(this_cpu, CPU_IDLE);
+
 	/*
 	 * If this cpu is the owner for idle load balancing, then do the
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	if (this_rq->idle_at_tick &&
-	    atomic_read(&nohz.load_balancer) == this_cpu) {
+	if (this_rq->nohz_balance_kick) {
 		struct rq *rq;
 		int balance_cpu;
 
-		for_each_cpu(balance_cpu, nohz.cpu_mask) {
+		for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
 			if (balance_cpu == this_cpu)
 				continue;
 
@@ -4842,68 +4886,68 @@ static void run_rebalance_domains(struct softirq_action *h)
 			if (time_after(this_rq->next_balance, rq->next_balance))
 				this_rq->next_balance = rq->next_balance;
 		}
+		nohz.next_balance = this_rq->next_balance;
+		this_rq->nohz_balance_kick = 0;
 	}
-#endif
 }
+#endif
 
 static inline int on_null_domain(int cpu)
 {
 	return !rcu_dereference(cpu_rq(cpu)->sd);
 }
-
 /*
- * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
- *
- * In case of CONFIG_NO_HZ, this is the place where we nominate a new
- * idle load balancing owner or decide to stop the periodic load balancing,
- * if the whole system is idle.
+ * Current heuristic for kicking the idle load balancer
+ * - first_pick_cpu is the one of the busy CPUs. It will kick
+ *   idle load balancer when it has more than one process active. This
+ *   eliminates the need for idle load balancing altogether when we have
+ *   only one running process in the system (common case).
+ * - If there are more than one busy CPU, idle load balancer may have
+ *   to run for active_load_balance to happen (i.e., two busy CPUs are
+ *   SMT or core siblings and can run better if they move to different
+ *   physical CPUs). So, second_pick_cpu is the second of the busy CPUs
+ *   which will kick idle load balancer as soon as it has any load.
  */
-static inline void trigger_load_balance(struct rq *rq, int cpu)
+static inline int nohz_kick_needed(struct rq *rq, int cpu)
 {
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If we were in the nohz mode recently and busy at the current
-	 * scheduler tick, then check if we need to nominate new idle
-	 * load balancer.
-	 */
-	if (rq->in_nohz_recently && !rq->idle_at_tick) {
-		rq->in_nohz_recently = 0;
+	unsigned long now = jiffies;
+	int ret;
 
-		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpumask_clear_cpu(cpu, nohz.cpu_mask);
-			atomic_set(&nohz.load_balancer, -1);
-		}
+	if (time_before(now, nohz.next_balance))
+		return 0;
 
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			int ilb = find_new_ilb(cpu);
+	if (!rq->nr_running)
+		return 0;
 
-			if (ilb < nr_cpu_ids)
-				resched_cpu(ilb);
+	ret = atomic_cmpxchg(&nohz.first_pick_cpu, -1, cpu);
+	if (ret == -1 || ret == cpu) {
+		atomic_cmpxchg(&nohz.second_pick_cpu, cpu, -1);
+		if (rq->nr_running > 1)
+			return 1;
+	} else {
+		ret = atomic_cmpxchg(&nohz.second_pick_cpu, -1, cpu);
+		if (ret == -1 || ret == cpu) {
+			if (rq->nr_running)
+				return 1;
 		}
 	}
 
-	/*
-	 * If this cpu is idle and doing idle load balancing for all the
-	 * cpus with ticks stopped, is it time for that to stop?
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
-		resched_cpu(cpu);
-		return;
-	}
+	return 0;
+}
 
-	/*
-	 * If this cpu is idle and the idle load balancing is done by
-	 * someone else, then no need raise the SCHED_SOFTIRQ
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpumask_test_cpu(cpu, nohz.cpu_mask))
-		return;
-#endif
+/*
+ * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
+ */
+static inline void trigger_load_balance(struct rq *rq, int cpu)
+{
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
+#ifdef CONFIG_NO_HZ
+	else if (nohz_kick_needed(rq, cpu) && likely(!on_null_domain(cpu)))
+		nohz_balancer_kick(cpu);
+#endif
 }
 
 #else	/* CONFIG_SMP */
@@ -5446,8 +5490,19 @@ need_resched_nonpreemptible:
 
 	pre_schedule(rq, prev);
 
-	if (unlikely(!rq->nr_running))
+	if (unlikely(!rq->nr_running)) {
+#ifdef CONFIG_NO_HZ
+		if (rq->nohz_balance_kick) {
+			spin_unlock_irq(&rq->lock);
+			nohz_idle_balance(cpu, rq);
+			spin_lock_irq(&rq->lock);
+		} else {
+			idle_balance(cpu, rq);
+		}
+#else
 		idle_balance(cpu, rq);
+#endif
+	}
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
@@ -9521,6 +9576,9 @@ void __init sched_init(void)
 		rq->push_cpu = 0;
 		rq->cpu = i;
 		rq->online = 0;
+#ifdef CONFIG_NO_HZ
+		rq->nohz_balance_kick = 0;
+#endif
 		rq->migration_thread = NULL;
 		INIT_LIST_HEAD(&rq->migration_queue);
 		rq_attach_root(rq, &def_root_domain);
@@ -9568,8 +9626,8 @@ void __init sched_init(void)
 	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
-	zalloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
+	alloc_cpumask_var(&nohz.tmp_nohz_mask, GFP_NOWAIT);
 #endif
 	zalloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 89aed59..bfb615b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -326,13 +326,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 		 * the scheduler tick in nohz_restart_sched_tick.
 		 */
 		if (!ts->tick_stopped) {
-			if (select_nohz_load_balancer(1)) {
-				/*
-				 * sched tick not stopped!
-				 */
-				cpumask_clear_cpu(cpu, nohz_cpu_mask);
-				goto out;
-			}
+			select_nohz_load_balancer(1);
 
 			ts->idle_tick = hrtimer_get_expires(&ts->sched_timer);
 			ts->tick_stopped = 1;
-- 
1.6.0.6

-- 

