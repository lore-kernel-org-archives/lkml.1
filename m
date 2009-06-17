Return-Path: <linux-kernel-owner+w=401wt.eu-S1760469AbZFQSge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469AbZFQSge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbZFQSgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:36:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:46523 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760134AbZFQSgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:36:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,239,1243839600"; 
   d="scan'208";a="155705381"
Message-Id: <20090617182740.962696000@intel.com>
References: <20090617182649.604970000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 11:26:50 -0700
From: venkatesh.pallipadi@intel.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 1/2] RFC sched: Change the nohz ilb logic from pull to push model
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
* On x86 and CPUs that have APIC timer stoppage on idle CPUs, this periodic
  wakeup can result in an additional interrupt on a CPU doing the timer
  broadcast.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c |  168 +++++++++++++++++++++++++++-----------------------------
 1 files changed, 80 insertions(+), 88 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 80636ed..22fe762 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -627,6 +627,10 @@ struct rq {
 	struct list_head migration_queue;
 #endif
 
+#ifdef CONFIG_NO_HZ
+	unsigned char nohz_balance_kick:1;
+#endif
+
 	/* calc_load related fields */
 	unsigned long calc_load_update;
 	long calc_load_active;
@@ -4409,6 +4413,7 @@ static struct {
 	atomic_t load_balancer;
 	cpumask_var_t cpu_mask;
 	cpumask_var_t ilb_grp_nohz_mask;
+	unsigned long next_balance; /* units in jiffies */
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
 };
@@ -4476,7 +4481,7 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
 	return 1;
 }
 /**
- * find_new_ilb - Finds the optimum idle load balancer for nomination.
+ * find_new_power_opt_ilb - Finds the optimum idle load balancer for nomination.
  * @cpu:	The cpu which is nominating a new idle_load_balancer.
  *
  * Returns:	Returns the id of the idle load balancer if it exists,
@@ -4487,7 +4492,7 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
  * completely idle packages/cores just for the purpose of idle load balancing
  * when there are other idle cpu's which are better suited for that job.
  */
-static int find_new_ilb(int cpu)
+static int find_new_power_opt_ilb(int cpu)
 {
 	struct sched_domain *sd;
 	struct sched_group *ilb_group;
@@ -4519,12 +4524,12 @@ static int find_new_ilb(int cpu)
 	}
 
 out_done:
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
-static inline int find_new_ilb(int call_cpu)
+static inline int find_new_power_opt_ilb(int call_cpu)
 {
-	return cpumask_first(nohz.cpu_mask);
+	return nr_cpu_ids;
 }
 #endif
 
@@ -4534,24 +4539,42 @@ int get_nohz_load_balancer(void)
 }
 
 /*
+ * Kick a CPU to do the nohz balancing, if it is time for it. We pick the
+ * nohz_load_balancer CPU (if there is one) otherwise fallback to any idle
+ * CPU (if there is one).
+ */
+static void nohz_balancer_kick(int cpu)
+{
+	int ilb_cpu;
+	unsigned long now = jiffies;
+
+	if (time_before(now, nohz.next_balance))
+		return;
+
+	ilb_cpu = get_nohz_load_balancer();
+	if (ilb_cpu < 0) {
+		ilb_cpu = cpumask_first(nohz.cpu_mask);
+		if (ilb_cpu >= nr_cpu_ids)
+			return;
+	}
+
+	cpu_rq(ilb_cpu)->nohz_balance_kick = 1;
+	resched_cpu(ilb_cpu);
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
+ * ilb CPU in future, when there is a need for idle load balancing on
+ * behalf of all idle CPUs.
  */
 int select_nohz_load_balancer(int stop_tick)
 {
@@ -4576,34 +4599,26 @@ int select_nohz_load_balancer(int stop_tick)
 
 		cpumask_set_cpu(cpu, nohz.cpu_mask);
 
-		/* time for ilb owner also to sleep */
-		if (cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
-			if (atomic_read(&nohz.load_balancer) == cpu)
-				atomic_set(&nohz.load_balancer, -1);
-			return 0;
-		}
-
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
+				return 0;
+
 			/*
-			 * Check to see if there is a more power-efficient
-			 * ilb.
+			 * Now that, I am the load_balancer, check whether we
+			 * need to find a power optimal load balancer instead
 			 */
-			new_ilb = find_new_ilb(cpu);
+			if (!(sched_smt_power_savings ||
+			      sched_mc_power_savings))
+				return 0;
+
+			new_ilb = find_new_power_opt_ilb(cpu);
 			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
 				atomic_set(&nohz.load_balancer, -1);
 				resched_cpu(new_ilb);
-				return 0;
 			}
-			return 1;
 		}
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
@@ -4699,8 +4714,6 @@ out:
 
 /*
  * run_rebalance_domains is triggered when needed from the scheduler tick.
- * In CONFIG_NO_HZ case, the idle load balance owner will do the
- * rebalancing for all the cpus for whom scheduler ticks are stopped.
  */
 static void run_rebalance_domains(struct softirq_action *h)
 {
@@ -4710,15 +4723,23 @@ static void run_rebalance_domains(struct softirq_action *h)
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
 
@@ -4740,9 +4761,11 @@ static void run_rebalance_domains(struct softirq_action *h)
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
@@ -4751,57 +4774,17 @@ static inline int on_null_domain(int cpu)
 
 /*
  * Trigger the SCHED_SOFTIRQ if it is time to do periodic load balancing.
- *
- * In case of CONFIG_NO_HZ, this is the place where we nominate a new
- * idle load balancing owner or decide to stop the periodic load balancing,
- * if the whole system is idle.
  */
 static inline void trigger_load_balance(struct rq *rq, int cpu)
 {
-#ifdef CONFIG_NO_HZ
-	/*
-	 * If we were in the nohz mode recently and busy at the current
-	 * scheduler tick, then check if we need to nominate new idle
-	 * load balancer.
-	 */
-	if (rq->in_nohz_recently && !rq->idle_at_tick) {
-		rq->in_nohz_recently = 0;
-
-		if (atomic_read(&nohz.load_balancer) == cpu) {
-			cpumask_clear_cpu(cpu, nohz.cpu_mask);
-			atomic_set(&nohz.load_balancer, -1);
-		}
-
-		if (atomic_read(&nohz.load_balancer) == -1) {
-			int ilb = find_new_ilb(cpu);
-
-			if (ilb < nr_cpu_ids)
-				resched_cpu(ilb);
-		}
-	}
-
-	/*
-	 * If this cpu is idle and doing idle load balancing for all the
-	 * cpus with ticks stopped, is it time for that to stop?
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) == cpu &&
-	    cpumask_weight(nohz.cpu_mask) == num_online_cpus()) {
-		resched_cpu(cpu);
-		return;
-	}
-
-	/*
-	 * If this cpu is idle and the idle load balancing is done by
-	 * someone else, then no need raise the SCHED_SOFTIRQ
-	 */
-	if (rq->idle_at_tick && atomic_read(&nohz.load_balancer) != cpu &&
-	    cpumask_test_cpu(cpu, nohz.cpu_mask))
-		return;
-#endif
 	/* Don't need to rebalance while attached to NULL domain */
 	if (time_after_eq(jiffies, rq->next_balance) &&
 	    likely(!on_null_domain(cpu)))
 		raise_softirq(SCHED_SOFTIRQ);
+#ifdef CONFIG_NO_HZ
+	else if (rq->nr_running && likely(!on_null_domain(cpu)))
+		nohz_balancer_kick(cpu);
+#endif
 }
 
 #else	/* CONFIG_SMP */
@@ -5346,8 +5329,17 @@ need_resched_nonpreemptible:
 		prev->sched_class->pre_schedule(rq, prev);
 #endif
 
-	if (unlikely(!rq->nr_running))
+	if (unlikely(!rq->nr_running)) {
+#ifdef CONFIG_NO_HZ
+		if (rq->nohz_balance_kick) {
+			spin_unlock_irq(&rq->lock);
+			nohz_idle_balance(cpu, rq);
+			rq->nohz_balance_kick = 0;
+			spin_lock_irq(&rq->lock);
+		} else
+#endif
 		idle_balance(cpu, rq);
+	}
 
 	put_prev_task(rq, prev);
 	next = pick_next_task(rq);
-- 
1.6.0.6

-- 

