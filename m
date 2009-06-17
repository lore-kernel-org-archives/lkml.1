Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbZFQSgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbZFQSgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760170AbZFQSgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:36:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:56439 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760107AbZFQSgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:36:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,239,1243839600"; 
   d="scan'208";a="423176693"
Message-Id: <20090617182741.107659000@intel.com>
References: <20090617182649.604970000@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 17 Jun 2009 11:26:51 -0700
From: venkatesh.pallipadi@intel.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Gautham R Shenoy <ego@in.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 2/2] RFC sched: Scale the nohz_tracker logic by making it per NUMA node
Content-Disposition: inline; filename=0002-sched-Scale-the-nohz_tracker-logic-by-making-it-per.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having one idle CPU doing the rebalancing for all the idle CPUs in
nohz mode does not scale well with increasing number of cores and
sockets. Make the nohz_tracker per NUMA node. This results in multiple
idle load balancing happening at NUMA node level and idle load balancer
only does the rebalance domain among all the other nohz CPUs in that
NUMA node.

This addresses the below problem with the current nohz ilb logic
* The lone balancer may end up spending a lot of time doing the balancing on
  behalf of nohz CPUs, especially with increasing number of sockets and
  cores in the platform.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 kernel/sched.c |  162 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 124 insertions(+), 38 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 22fe762..49d3bb7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4408,16 +4408,74 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 	double_unlock_balance(busiest_rq, target_rq);
 }
 
-#ifdef CONFIG_NO_HZ
-static struct {
+struct nohz_tracker {
 	atomic_t load_balancer;
 	cpumask_var_t cpu_mask;
-	cpumask_var_t ilb_grp_nohz_mask;
+	cpumask_var_t tmp_nohz_mask;
 	unsigned long next_balance; /* units in jiffies */
-} nohz ____cacheline_aligned = {
-	.load_balancer = ATOMIC_INIT(-1),
 };
 
+#ifdef CONFIG_NO_HZ
+static DEFINE_PER_CPU(struct nohz_tracker *, cpu_node_nohz_ptr);
+static struct nohz_tracker **nohz_tracker_ptrs;
+
+int alloc_node_nohz_tracker(void)
+{
+	int i, j;
+
+	/* Do all the allocations only once per boot */
+	if (nohz_tracker_ptrs)
+		return 0;
+
+	nohz_tracker_ptrs = kcalloc(nr_node_ids, sizeof(struct nohz_tracker *),
+				    GFP_KERNEL);
+	if (!nohz_tracker_ptrs) {
+		printk(KERN_WARNING "Can not alloc nohz trackers\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < nr_node_ids; i++) {
+		nohz_tracker_ptrs[i] = kmalloc_node(sizeof(struct nohz_tracker),
+						    GFP_KERNEL, i);
+		if (!nohz_tracker_ptrs[i]) {
+			printk(KERN_WARNING "Can not alloc domain group for "
+				"node %d\n", i);
+			goto free_ret;
+		}
+
+		if (!alloc_cpumask_var_node(&nohz_tracker_ptrs[i]->cpu_mask,
+					    GFP_KERNEL, i)) {
+			kfree(nohz_tracker_ptrs[i]);
+			goto free_ret;
+		}
+
+		if (!alloc_cpumask_var_node(&nohz_tracker_ptrs[i]->tmp_nohz_mask,
+					    GFP_KERNEL, i)) {
+			free_cpumask_var(nohz_tracker_ptrs[i]->cpu_mask);
+			kfree(nohz_tracker_ptrs[i]);
+			goto free_ret;
+		}
+		atomic_set(&nohz_tracker_ptrs[i]->load_balancer, -1);
+	}
+
+	return 0;
+
+free_ret:
+	for (j = 0; j < i; j++) {
+		free_cpumask_var(nohz_tracker_ptrs[j]->tmp_nohz_mask);
+		free_cpumask_var(nohz_tracker_ptrs[j]->cpu_mask);
+		kfree(nohz_tracker_ptrs[j]);
+	}
+
+	kfree(nohz_tracker_ptrs);
+
+	for_each_online_cpu(i)
+		per_cpu(cpu_node_nohz_ptr, i) = NULL;
+
+	nohz_tracker_ptrs = NULL;
+	return -ENOMEM;
+}
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 /**
  * lowest_flag_domain - Return lowest sched_domain containing flag.
@@ -4456,6 +4514,7 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
 /**
  * is_semi_idle_group - Checks if the given sched_group is semi-idle.
  * @ilb_group:	group to be checked for semi-idleness
+ * @node_nohz: nohz_tracker for the node
  *
  * Returns:	1 if the group is semi-idle. 0 otherwise.
  *
@@ -4463,19 +4522,20 @@ static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
  * and atleast one non-idle CPU. This helper function checks if the given
  * sched_group is semi-idle or not.
  */
-static inline int is_semi_idle_group(struct sched_group *ilb_group)
+static inline int is_semi_idle_group(struct sched_group *ilb_group,
+				struct nohz_tracker *node_nohz)
 {
-	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
+	cpumask_and(node_nohz->tmp_nohz_mask, node_nohz->cpu_mask,
 					sched_group_cpus(ilb_group));
 
 	/*
 	 * A sched_group is semi-idle when it has atleast one busy cpu
 	 * and atleast one idle cpu.
 	 */
-	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
+	if (cpumask_empty(node_nohz->tmp_nohz_mask))
 		return 0;
 
-	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
+	if (cpumask_equal(node_nohz->tmp_nohz_mask, sched_group_cpus(ilb_group)))
 		return 0;
 
 	return 1;
@@ -4483,6 +4543,7 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
 /**
  * find_new_power_opt_ilb - Finds the optimum idle load balancer for nomination.
  * @cpu:	The cpu which is nominating a new idle_load_balancer.
+ * @node_nohz:	nohz_tracker for the node
  *
  * Returns:	Returns the id of the idle load balancer if it exists,
  *		Else, returns >= nr_cpu_ids.
@@ -4492,7 +4553,7 @@ static inline int is_semi_idle_group(struct sched_group *ilb_group)
  * completely idle packages/cores just for the purpose of idle load balancing
  * when there are other idle cpu's which are better suited for that job.
  */
-static int find_new_power_opt_ilb(int cpu)
+static int find_new_power_opt_ilb(int cpu, struct nohz_tracker *node_nohz)
 {
 	struct sched_domain *sd;
 	struct sched_group *ilb_group;
@@ -4508,15 +4569,15 @@ static int find_new_power_opt_ilb(int cpu)
 	 * Optimize for the case when we have no idle CPUs or only one
 	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
 	 */
-	if (cpumask_weight(nohz.cpu_mask) < 2)
+	if (cpumask_weight(node_nohz->cpu_mask) < 2)
 		goto out_done;
 
 	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
 		ilb_group = sd->groups;
 
 		do {
-			if (is_semi_idle_group(ilb_group))
-				return cpumask_first(nohz.ilb_grp_nohz_mask);
+			if (is_semi_idle_group(ilb_group, node_nohz))
+				return cpumask_first(node_nohz->tmp_nohz_mask);
 
 			ilb_group = ilb_group->next;
 
@@ -4527,15 +4588,26 @@ out_done:
 	return nr_cpu_ids;
 }
 #else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
-static inline int find_new_power_opt_ilb(int call_cpu)
+static inline int find_new_power_opt_ilb(int call_cpu,
+						struct nohz_tracker *node_nohz)
 {
 	return nr_cpu_ids;
 }
 #endif
 
+static int get_nohz_load_balancer_node(struct nohz_tracker *node_nohz)
+{
+	if (!node_nohz)
+		return -1;
+
+	return atomic_read(&node_nohz->load_balancer);
+}
+
 int get_nohz_load_balancer(void)
 {
-	return atomic_read(&nohz.load_balancer);
+	int cpu = smp_processor_id();
+	struct nohz_tracker *node_nohz = per_cpu(cpu_node_nohz_ptr, cpu);
+	return get_nohz_load_balancer_node(node_nohz);
 }
 
 /*
@@ -4547,13 +4619,17 @@ static void nohz_balancer_kick(int cpu)
 {
 	int ilb_cpu;
 	unsigned long now = jiffies;
+	struct nohz_tracker *node_nohz = per_cpu(cpu_node_nohz_ptr, cpu);
+
+	if (!node_nohz)
+		return;
 
-	if (time_before(now, nohz.next_balance))
+	if (time_before(now, node_nohz->next_balance))
 		return;
 
-	ilb_cpu = get_nohz_load_balancer();
+	ilb_cpu = get_nohz_load_balancer_node(node_nohz);
 	if (ilb_cpu < 0) {
-		ilb_cpu = cpumask_first(nohz.cpu_mask);
+		ilb_cpu = cpumask_first(node_nohz->cpu_mask);
 		if (ilb_cpu >= nr_cpu_ids)
 			return;
 	}
@@ -4579,31 +4655,35 @@ static void nohz_balancer_kick(int cpu)
 int select_nohz_load_balancer(int stop_tick)
 {
 	int cpu = smp_processor_id();
+	struct nohz_tracker *node_nohz = per_cpu(cpu_node_nohz_ptr, cpu);
+
+	if (!node_nohz)
+		return 0;
 
 	if (stop_tick) {
 		cpu_rq(cpu)->in_nohz_recently = 1;
 
 		if (!cpu_active(cpu)) {
-			if (atomic_read(&nohz.load_balancer) != cpu)
+			if (atomic_read(&node_nohz->load_balancer) != cpu)
 				return 0;
 
 			/*
 			 * If we are going offline and still the leader,
 			 * give up!
 			 */
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+			if (atomic_cmpxchg(&node_nohz->load_balancer, cpu, -1) != cpu)
 				BUG();
 
 			return 0;
 		}
 
-		cpumask_set_cpu(cpu, nohz.cpu_mask);
+		cpumask_set_cpu(cpu, node_nohz->cpu_mask);
 
-		if (atomic_read(&nohz.load_balancer) == -1) {
+		if (atomic_read(&node_nohz->load_balancer) == -1) {
 			int new_ilb;
 
 			/* make me the ilb owner */
-			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) != -1) 
+			if (atomic_cmpxchg(&node_nohz->load_balancer, -1, cpu) != -1) 
 				return 0;
 
 			/*
@@ -4614,20 +4694,20 @@ int select_nohz_load_balancer(int stop_tick)
 			      sched_mc_power_savings))
 				return 0;
 
-			new_ilb = find_new_power_opt_ilb(cpu);
+			new_ilb = find_new_power_opt_ilb(cpu, node_nohz);
 			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
-				atomic_set(&nohz.load_balancer, -1);
+				atomic_set(&node_nohz->load_balancer, -1);
 				resched_cpu(new_ilb);
 			}
 		}
 	} else {
-		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
+		if (!cpumask_test_cpu(cpu, node_nohz->cpu_mask))
 			return 0;
 
-		cpumask_clear_cpu(cpu, nohz.cpu_mask);
+		cpumask_clear_cpu(cpu, node_nohz->cpu_mask);
 
-		if (atomic_read(&nohz.load_balancer) == cpu)
-			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+		if (atomic_read(&node_nohz->load_balancer) == cpu)
+			if (atomic_cmpxchg(&node_nohz->load_balancer, cpu, -1) != cpu)
 				BUG();
 	}
 	return 0;
@@ -4732,6 +4812,8 @@ static void run_rebalance_domains(struct softirq_action *h)
  */
 static void nohz_idle_balance(int this_cpu, struct rq *this_rq)
 {
+	struct nohz_tracker *node_nohz = per_cpu(cpu_node_nohz_ptr, this_cpu);
+
 	rebalance_domains(this_cpu, CPU_IDLE);
 
 	/*
@@ -4739,11 +4821,11 @@ static void nohz_idle_balance(int this_cpu, struct rq *this_rq)
 	 * balancing on behalf of the other idle cpus whose ticks are
 	 * stopped.
 	 */
-	if (this_rq->nohz_balance_kick) {
+	if (this_rq->nohz_balance_kick && node_nohz) {
 		struct rq *rq;
 		int balance_cpu;
 
-		for_each_cpu(balance_cpu, nohz.cpu_mask) {
+		for_each_cpu(balance_cpu, node_nohz->cpu_mask) {
 			if (balance_cpu == this_cpu)
 				continue;
 
@@ -4761,7 +4843,7 @@ static void nohz_idle_balance(int this_cpu, struct rq *this_rq)
 			if (time_after(this_rq->next_balance, rq->next_balance))
 				this_rq->next_balance = rq->next_balance;
 		}
-		nohz.next_balance = this_rq->next_balance;
+		node_nohz->next_balance = this_rq->next_balance;
 		this_rq->nohz_balance_kick = 0;
 	}
 }
@@ -8615,6 +8697,14 @@ static int __build_sched_domains(const struct cpumask *cpu_map,
 	}
 #endif
 
+	if (alloc_node_nohz_tracker())
+		goto error;
+
+	for_each_cpu(i, cpu_map) {
+		per_cpu(cpu_node_nohz_ptr, i) =
+					nohz_tracker_ptrs[cpu_to_node(i)];
+	}
+
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
 	for_each_cpu(i, cpu_map) {
@@ -8692,12 +8782,12 @@ free_sched_groups:
 #endif
 	goto free_tmpmask;
 
-#ifdef CONFIG_NUMA
 error:
+#ifdef CONFIG_NUMA
 	free_sched_groups(cpu_map, tmpmask);
 	free_rootdomain(rd);
-	goto free_tmpmask;
 #endif
+	goto free_tmpmask;
 }
 
 static int build_sched_domains(const struct cpumask *cpu_map)
@@ -9386,10 +9476,6 @@ void __init sched_init(void)
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
 	alloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
-#ifdef CONFIG_NO_HZ
-	alloc_cpumask_var(&nohz.cpu_mask, GFP_NOWAIT);
-	alloc_cpumask_var(&nohz.ilb_grp_nohz_mask, GFP_NOWAIT);
-#endif
 	alloc_cpumask_var(&cpu_isolated_map, GFP_NOWAIT);
 #endif /* SMP */
 
-- 
1.6.0.6

-- 

