Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbYJWCQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbYJWCQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 22:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbYJWCIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 22:08:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43377 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754426AbYJWCIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 22:08:31 -0400
Message-Id: <20081023020830.282354000@polaris-admin.engr.sgi.com>
References: <20081023020826.051012000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Oct 2008 19:08:46 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 20/35] cpumask: for_each_cpu(): for_each_cpu_mask which takes a pointer From: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline; filename=cpumask:for_each_cpu.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to wean people off handing around cpumask_t's, and have them
pass by pointer instead.  This does for_each_cpu_mask().

We immediately convert core files who were doing
"for_each_cpu_mask(... *mask)" since this is clearer.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/linux/cpumask.h |   25 ++++++++++++++-----------
 kernel/sched.c          |   40 ++++++++++++++++++++--------------------
 kernel/workqueue.c      |    6 +++---
 lib/cpumask.c           |    2 +-
 mm/allocpercpu.c        |    4 ++--
 mm/vmstat.c             |    4 ++--
 6 files changed, 42 insertions(+), 39 deletions(-)

--- linux-2.6.28.orig/include/linux/cpumask.h
+++ linux-2.6.28/include/linux/cpumask.h
@@ -97,8 +97,8 @@
  * void cpumask_onto(dst, orig, relmap)	*dst = orig relative to relmap
  * void cpumask_fold(dst, orig, sz)	dst bits = orig bits mod sz
  *
- * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask using nr_cpu_ids
- * for_each_cpu_mask_and(cpu, mask, and) for-loop cpu over (mask & and).
+ * for_each_cpu(cpu, mask)		for-loop cpu over mask, <= nr_cpu_ids
+ * for_each_cpu_and(cpu, mask, and)	for-loop cpu over (mask & and).
  *
  * int num_online_cpus()		Number of online CPUs
  * int num_possible_cpus()		Number of all possible CPUs
@@ -175,6 +175,9 @@ extern cpumask_t _unused_cpumask_arg_;
 #define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
 #define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
 #define cpumask_of_cpu(cpu) (*cpumask_of(cpu))
+#define for_each_cpu_mask(cpu, mask)	for_each_cpu(cpu, &(mask))
+#define for_each_cpu_mask_and(cpu, mask, and)	\
+		for_each_cpu_and(cpu, &(mask), &(and))
 /* End deprecated region. */
 
 #if NR_CPUS > 1
@@ -443,9 +446,9 @@ extern cpumask_t cpu_mask_all;
 #define cpumask_next_and(n, srcp, andp)	({ (void)(srcp), (void)(andp); 1; })
 #define any_online_cpu(mask)		0
 
-#define for_each_cpu_mask(cpu, mask)		\
+#define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-#define for_each_cpu_mask_and(cpu, mask, and)	\
+#define for_each_cpu_and(cpu, mask, and)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)and)
 
 #else /* NR_CPUS > 1 */
@@ -459,13 +462,13 @@ int __any_online_cpu(const cpumask_t *ma
 #define next_cpu(n, src)	__next_cpu((n), &(src))
 #define any_online_cpu(mask) __any_online_cpu(&(mask))
 
-#define for_each_cpu_mask(cpu, mask)			\
+#define for_each_cpu(cpu, mask)				\
 	for ((cpu) = -1;				\
-		(cpu) = next_cpu((cpu), (mask)),	\
+		(cpu) = __next_cpu((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
-#define for_each_cpu_mask_and(cpu, mask, and)				\
+#define for_each_cpu_and(cpu, mask, and)				\
 	for ((cpu) = -1;						\
-		(cpu) = cpumask_next_and((cpu), &(mask), &(and)),	\
+		(cpu) = cpumask_next_and((cpu), (mask), (and)),		\
 		(cpu) < nr_cpu_ids;)
 
 #define num_online_cpus()	cpus_weight(cpu_online_map)
@@ -597,8 +600,8 @@ extern cpumask_t cpu_active_map;
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#define for_each_possible_cpu(cpu) for_each_cpu_mask((cpu), cpu_possible_map)
-#define for_each_online_cpu(cpu)   for_each_cpu_mask((cpu), cpu_online_map)
-#define for_each_present_cpu(cpu)  for_each_cpu_mask((cpu), cpu_present_map)
+#define for_each_possible_cpu(cpu) for_each_cpu((cpu), &cpu_possible_map)
+#define for_each_online_cpu(cpu)   for_each_cpu((cpu), &cpu_online_map)
+#define for_each_present_cpu(cpu)  for_each_cpu((cpu), &cpu_present_map)
 
 #endif /* __LINUX_CPUMASK_H */
--- linux-2.6.28.orig/kernel/sched.c
+++ linux-2.6.28/kernel/sched.c
@@ -1523,7 +1523,7 @@ static int tg_shares_up(struct task_grou
 	struct sched_domain *sd = data;
 	int i;
 
-	for_each_cpu_mask(i, sd->span) {
+	for_each_cpu(i, &sd->span) {
 		rq_weight += tg->cfs_rq[i]->load.weight;
 		shares += tg->cfs_rq[i]->shares;
 	}
@@ -1537,7 +1537,7 @@ static int tg_shares_up(struct task_grou
 	if (!rq_weight)
 		rq_weight = cpus_weight(sd->span) * NICE_0_LOAD;
 
-	for_each_cpu_mask(i, sd->span)
+	for_each_cpu(i, &sd->span)
 		update_group_shares_cpu(tg, i, shares, rq_weight);
 
 	return 0;
@@ -2074,7 +2074,7 @@ find_idlest_group(struct sched_domain *s
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
+		for_each_cpu(i, &group->cpumask) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2116,7 +2116,7 @@ find_idlest_cpu(struct sched_group *grou
 	/* Traverse only the allowed CPUs */
 	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu_mask_nr(i, *tmp) {
+	for_each_cpu(i, tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -3134,7 +3134,7 @@ find_busiest_group(struct sched_domain *
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
+		for_each_cpu(i, &group->cpumask) {
 			struct rq *rq;
 
 			if (!cpu_isset(i, *cpus))
@@ -3413,7 +3413,7 @@ find_busiest_queue(struct sched_group *g
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask_nr(i, group->cpumask) {
+	for_each_cpu(i, &group->cpumask) {
 		unsigned long wl;
 
 		if (!cpu_isset(i, *cpus))
@@ -3955,7 +3955,7 @@ static void run_rebalance_domains(struct
 		int balance_cpu;
 
 		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask_nr(balance_cpu, cpus) {
+		for_each_cpu(balance_cpu, &cpus) {
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -6935,7 +6935,7 @@ init_sched_build_groups(const cpumask_t 
 
 	cpus_clear(*covered);
 
-	for_each_cpu_mask_nr(i, *span) {
+	for_each_cpu(i, span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
@@ -6946,7 +6946,7 @@ init_sched_build_groups(const cpumask_t 
 		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask_nr(j, *span) {
+		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
@@ -7146,7 +7146,7 @@ static void init_numa_sched_groups_power
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask_nr(j, sg->cpumask) {
+		for_each_cpu(j, &sg->cpumask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j);
@@ -7171,7 +7171,7 @@ static void free_sched_groups(const cpum
 {
 	int cpu, i;
 
-	for_each_cpu_mask_nr(cpu, *cpu_map) {
+	for_each_cpu(cpu, cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7418,7 +7418,7 @@ static int __build_sched_domains(const c
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
@@ -7485,7 +7485,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7502,7 +7502,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		SCHED_CPUMASK_VAR(this_core_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7569,7 +7569,7 @@ static int __build_sched_domains(const c
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask_nr(j, *nodemask) {
+		for_each_cpu(j, nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
@@ -7615,21 +7615,21 @@ static int __build_sched_domains(const c
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = &per_cpu(cpu_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = &per_cpu(core_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = &per_cpu(phys_domains, i);
 
 		init_sched_groups_power(i, sd);
@@ -7649,7 +7649,7 @@ static int __build_sched_domains(const c
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i);
@@ -7732,7 +7732,7 @@ static void detach_destroy_domains(const
 
 	unregister_sched_domain_sysctl();
 
-	for_each_cpu_mask_nr(i, *cpu_map)
+	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map, &tmpmask);
--- linux-2.6.28.orig/kernel/workqueue.c
+++ linux-2.6.28/kernel/workqueue.c
@@ -415,7 +415,7 @@ void flush_workqueue(struct workqueue_st
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -546,7 +546,7 @@ static void wait_on_work(struct work_str
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -906,7 +906,7 @@ void destroy_workqueue(struct workqueue_
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu(cpu, cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
  	cpu_maps_update_done();
 
--- linux-2.6.28.orig/lib/cpumask.c
+++ linux-2.6.28/lib/cpumask.c
@@ -28,7 +28,7 @@ int __any_online_cpu(const cpumask_t *ma
 {
 	int cpu;
 
-	for_each_cpu_mask(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		if (cpu_online(cpu))
 			break;
 	}
--- linux-2.6.28.orig/mm/allocpercpu.c
+++ linux-2.6.28/mm/allocpercpu.c
@@ -34,7 +34,7 @@ static void percpu_depopulate(void *__pd
 static void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
 	int cpu;
-	for_each_cpu_mask_nr(cpu, *mask)
+	for_each_cpu(cpu, mask)
 		percpu_depopulate(__pdata, cpu);
 }
 
@@ -86,7 +86,7 @@ static int __percpu_populate_mask(void *
 	int cpu;
 
 	cpus_clear(populated);
-	for_each_cpu_mask_nr(cpu, *mask)
+	for_each_cpu(cpu, mask)
 		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
 			__percpu_depopulate_mask(__pdata, &populated);
 			return -ENOMEM;
--- linux-2.6.28.orig/mm/vmstat.c
+++ linux-2.6.28/mm/vmstat.c
@@ -20,14 +20,14 @@
 DEFINE_PER_CPU(struct vm_event_state, vm_event_states) = {{0}};
 EXPORT_PER_CPU_SYMBOL(vm_event_states);
 
-static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
+static void sum_vm_events(unsigned long *ret, const cpumask_t *cpumask)
 {
 	int cpu;
 	int i;
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask_nr(cpu, *cpumask) {
+	for_each_cpu(cpu, cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)

-- 
