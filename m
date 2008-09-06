Return-Path: <linux-kernel-owner+w=401wt.eu-S1755179AbYIFXxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbYIFXxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 19:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbYIFXuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 19:50:46 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59399 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753039AbYIFXuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 19:50:39 -0400
Message-Id: <20080906235037.880702000@polaris-admin.engr.sgi.com>
References: <20080906235036.891970000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Sat, 06 Sep 2008 16:50:43 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: davej@codemonkey.org.uk, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jes Sorensen <jes@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [RFC 07/13] sched: Reduce stack size requirements in kernel/sched.c
Content-Disposition: inline; filename=stack-hogs-kernel_sched_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Make the following changes to kernel/sched.c functions:

    - use node_to_cpumask_ptr in place of node_to_cpumask
    - use get_cpumask_var for temporary cpumask_t variables
    - use alloc_cpumask_ptr where available

  * Remove special code for SCHED_CPUMASK_ALLOC and use CPUMASK_ALLOC
    from linux/cpumask.h.

  * The resultant stack savings are:

    ====== Stack (-l 100)

	1 - initial
	2 - stack-hogs-kernel_sched_c
	'.' is less than the limit(100)

       .1.    .2.    ..final..
      2216  -1536 680   -69%  __build_sched_domains
      1592  -1592   .  -100%  move_task_off_dead_cpu
      1096  -1096   .  -100%  sched_balance_self
      1032  -1032   .  -100%  sched_setaffinity
       616   -616   .  -100%  rebalance_domains
       552   -552   .  -100%  free_sched_groups
       512   -512   .  -100%  cpu_to_allnodes_group
      7616  -6936 680   -91%  Totals


Applies to linux-2.6.tip/master.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 kernel/sched.c |  151 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 81 insertions(+), 70 deletions(-)

--- linux-2.6.tip.orig/kernel/sched.c
+++ linux-2.6.tip/kernel/sched.c
@@ -70,6 +70,7 @@
 #include <linux/bootmem.h>
 #include <linux/debugfs.h>
 #include <linux/ctype.h>
+#include <linux/cpumask_ptr.h>
 #include <linux/ftrace.h>
 #include <trace/sched.h>
 
@@ -117,6 +118,12 @@
  */
 #define RUNTIME_INF	((u64)~0ULL)
 
+/*
+ * temp cpumask variables
+ */
+static DEFINE_PER_CPUMASK(temp_cpumask_1);
+static DEFINE_PER_CPUMASK(temp_cpumask_2);
+
 #ifdef CONFIG_SMP
 /*
  * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
@@ -2141,7 +2148,11 @@ static int sched_balance_self(int cpu, i
 {
 	struct task_struct *t = current;
 	struct sched_domain *tmp, *sd = NULL;
+	cpumask_ptr span;
+	cpumask_ptr tmpmask;
 
+	get_cpumask_var(span, temp_cpumask_1);
+	get_cpumask_var(tmpmask, temp_cpumask_2);
 	for_each_domain(cpu, tmp) {
 		/*
 		 * If power savings logic is enabled for a domain, stop there.
@@ -2156,7 +2167,6 @@ static int sched_balance_self(int cpu, i
 		update_shares(sd);
 
 	while (sd) {
-		cpumask_t span, tmpmask;
 		struct sched_group *group;
 		int new_cpu, weight;
 
@@ -2165,14 +2175,14 @@ static int sched_balance_self(int cpu, i
 			continue;
 		}
 
-		span = sd->span;
+		*span = sd->span;
 		group = find_idlest_group(sd, t, cpu);
 		if (!group) {
 			sd = sd->child;
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, t, cpu, &tmpmask);
+		new_cpu = find_idlest_cpu(group, t, cpu, tmpmask);
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
@@ -2182,7 +2192,7 @@ static int sched_balance_self(int cpu, i
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
 		sd = NULL;
-		weight = cpus_weight(span);
+		weight = cpus_weight(*span);
 		for_each_domain(cpu, tmp) {
 			if (weight <= cpus_weight(tmp->span))
 				break;
@@ -2192,6 +2202,9 @@ static int sched_balance_self(int cpu, i
 		/* while loop will break here if sd == NULL */
 	}
 
+	put_cpumask_var(span, temp_cpumask_1);
+	put_cpumask_var(tmpmask, temp_cpumask_2);
+
 	return cpu;
 }
 
@@ -3865,8 +3878,9 @@ static void rebalance_domains(int cpu, e
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
 	int need_serialize;
-	cpumask_t tmp;
+	cpumask_ptr tmp;
 
+	get_cpumask_var(tmp, temp_cpumask_1);
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
@@ -3890,7 +3904,7 @@ static void rebalance_domains(int cpu, e
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance, &tmp)) {
+			if (load_balance(cpu, rq, sd, idle, &balance, tmp)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -3924,6 +3938,8 @@ out:
 	 */
 	if (likely(update_next_balance))
 		rq->next_balance = next_balance;
+
+	put_cpumask_var(tmp, temp_cpumask_1);
 }
 
 /*
@@ -5384,11 +5400,14 @@ out_unlock:
 
 long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
 {
-	cpumask_t cpus_allowed;
-	cpumask_t new_mask = *in_mask;
+	cpumask_ptr cpus_allowed;
+	cpumask_ptr new_mask;
 	struct task_struct *p;
 	int retval;
 
+	get_cpumask_var(cpus_allowed, temp_cpumask_1);
+	get_cpumask_var(new_mask, temp_cpumask_2);
+	*new_mask = *in_mask;
 	get_online_cpus();
 	read_lock(&tasklist_lock);
 
@@ -5416,24 +5435,26 @@ long sched_setaffinity(pid_t pid, const 
 	if (retval)
 		goto out_unlock;
 
-	cpuset_cpus_allowed(p, &cpus_allowed);
-	cpus_and(new_mask, new_mask, cpus_allowed);
+	cpuset_cpus_allowed(p, cpus_allowed);
+	cpus_and(*new_mask, *new_mask, *cpus_allowed);
  again:
-	retval = set_cpus_allowed_ptr(p, &new_mask);
+	retval = set_cpus_allowed_ptr(p, new_mask);
 
 	if (!retval) {
-		cpuset_cpus_allowed(p, &cpus_allowed);
-		if (!cpus_subset(new_mask, cpus_allowed)) {
+		cpuset_cpus_allowed(p, cpus_allowed);
+		if (!cpus_subset(*new_mask, *cpus_allowed)) {
 			/*
 			 * We must have raced with a concurrent cpuset
 			 * update. Just reset the cpus_allowed to the
 			 * cpuset's cpus_allowed
 			 */
-			new_mask = cpus_allowed;
+			*new_mask = *cpus_allowed;
 			goto again;
 		}
 	}
 out_unlock:
+	put_cpumask_var(cpus_allowed, temp_cpumask_1);
+	put_cpumask_var(new_mask, temp_cpumask_2);
 	put_task_struct(p);
 	put_online_cpus();
 	return retval;
@@ -6107,15 +6128,19 @@ static int __migrate_task_irq(struct tas
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	unsigned long flags;
-	cpumask_t mask;
+	cpumask_ptr mask;
+	cpumask_ptr cpus_allowed;
 	struct rq *rq;
 	int dest_cpu;
 
+	get_cpumask_var(mask, temp_cpumask_1);
+	get_cpumask_var(cpus_allowed, temp_cpumask_2);
 	do {
 		/* On same node? */
-		mask = node_to_cpumask(cpu_to_node(dead_cpu));
-		cpus_and(mask, mask, p->cpus_allowed);
-		dest_cpu = any_online_cpu(mask);
+		node_to_cpumask_ptr(pnodemask, cpu_to_node(dead_cpu));
+		*mask = *pnodemask;
+		cpus_and(*mask, *mask, p->cpus_allowed);
+		dest_cpu = any_online_cpu(*mask);
 
 		/* On any allowed CPU? */
 		if (dest_cpu >= nr_cpu_ids)
@@ -6123,9 +6148,8 @@ static void move_task_off_dead_cpu(int d
 
 		/* No more Mr. Nice Guy. */
 		if (dest_cpu >= nr_cpu_ids) {
-			cpumask_t cpus_allowed;
+			cpuset_cpus_allowed_locked(p, cpus_allowed);
 
-			cpuset_cpus_allowed_locked(p, &cpus_allowed);
 			/*
 			 * Try to stay on the same cpuset, where the
 			 * current cpuset may be a subset of all cpus.
@@ -6134,7 +6158,7 @@ static void move_task_off_dead_cpu(int d
 			 * called within calls to cpuset_lock/cpuset_unlock.
 			 */
 			rq = task_rq_lock(p, &flags);
-			p->cpus_allowed = cpus_allowed;
+			p->cpus_allowed = *cpus_allowed;
 			dest_cpu = any_online_cpu(p->cpus_allowed);
 			task_rq_unlock(rq, &flags);
 
@@ -6150,6 +6174,9 @@ static void move_task_off_dead_cpu(int d
 			}
 		}
 	} while (!__migrate_task_irq(p, dead_cpu, dest_cpu));
+
+	put_cpumask_var(mask, temp_cpumask_1);
+	put_cpumask_var(cpus_allowed, temp_cpumask_2);
 }
 
 /*
@@ -6710,7 +6737,7 @@ static int sched_domain_debug_one(struct
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
-	cpumask_t *groupmask;
+	cpumask_ptr groupmask;
 	int level = 0;
 
 	if (!sd) {
@@ -6720,7 +6747,7 @@ static void sched_domain_debug(struct sc
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
-	groupmask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	alloc_cpumask_ptr(&groupmask);
 	if (!groupmask) {
 		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
 		return;
@@ -6734,7 +6761,7 @@ static void sched_domain_debug(struct sc
 		if (!sd)
 			break;
 	}
-	kfree(groupmask);
+	free_cpumask_ptr(groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -7120,9 +7147,9 @@ static int cpu_to_allnodes_group(int cpu
 				 struct sched_group **sg, cpumask_t *nodemask)
 {
 	int group;
+	node_to_cpumask_ptr(pnodemask, cpu_to_node(cpu));
 
-	*nodemask = node_to_cpumask(cpu_to_node(cpu));
-	cpus_and(*nodemask, *nodemask, *cpu_map);
+	cpus_and(*nodemask, *pnodemask, *cpu_map);
 	group = first_cpu(*nodemask);
 
 	if (sg)
@@ -7172,9 +7199,9 @@ static void free_sched_groups(const cpum
 
 		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+			node_to_cpumask_ptr(pnodemask, i);
 
-			*nodemask = node_to_cpumask(i);
-			cpus_and(*nodemask, *nodemask, *cpu_map);
+			cpus_and(*nodemask, *pnodemask, *cpu_map);
 			if (cpus_empty(*nodemask))
 				continue;
 
@@ -7297,19 +7324,6 @@ struct allmasks {
 #endif
 };
 
-#if	NR_CPUS > 128
-#define	SCHED_CPUMASK_ALLOC		1
-#define	SCHED_CPUMASK_FREE(v)		kfree(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
-#else
-#define	SCHED_CPUMASK_ALLOC		0
-#define	SCHED_CPUMASK_FREE(v)
-#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
-#endif
-
-#define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
-			((unsigned long)(a) + offsetof(struct allmasks, v))
-
 static int default_relax_domain_level = -1;
 
 static int __init setup_relax_domain_level(char *str)
@@ -7354,8 +7368,9 @@ static int __build_sched_domains(const c
 {
 	int i;
 	struct root_domain *rd;
-	SCHED_CPUMASK_DECLARE(allmasks);
-	cpumask_t *tmpmask;
+	CPUMASK_ALLOC(allmasks);
+	CPUMASK_PTR(tmpmask, allmasks);
+
 #ifdef CONFIG_NUMA
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
@@ -7367,6 +7382,7 @@ static int __build_sched_domains(const c
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		CPUMASK_FREE(allmasks);
 		return -ENOMEM;
 	}
 #endif
@@ -7377,13 +7393,11 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_NUMA
 		kfree(sched_group_nodes);
 #endif
+		CPUMASK_FREE(allmasks);
 		return -ENOMEM;
 	}
 
-#if SCHED_CPUMASK_ALLOC
-	/* get space for all scratch cpumask variables */
-	allmasks = kmalloc(sizeof(*allmasks), GFP_KERNEL);
-	if (!allmasks) {
+	if (allmasks == NULL) {
 		printk(KERN_WARNING "Cannot alloc cpumask array\n");
 		kfree(rd);
 #ifdef CONFIG_NUMA
@@ -7391,9 +7405,6 @@ static int __build_sched_domains(const c
 #endif
 		return -ENOMEM;
 	}
-#endif
-	tmpmask = (cpumask_t *)allmasks;
-
 
 #ifdef CONFIG_NUMA
 	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
@@ -7404,10 +7415,10 @@ static int __build_sched_domains(const c
 	 */
 	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		node_to_cpumask_ptr(pnodemask, cpu_to_node(i));
 
-		*nodemask = node_to_cpumask(cpu_to_node(i));
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpus_and(*nodemask, *pnodemask, *cpu_map);
 
 #ifdef CONFIG_NUMA
 		if (cpus_weight(*cpu_map) >
@@ -7470,8 +7481,8 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
 	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(this_sibling_map, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
 		*this_sibling_map = per_cpu(cpu_sibling_map, i);
 		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
@@ -7487,8 +7498,8 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
 	for_each_cpu_mask_nr(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_core_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(this_core_map, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
 		*this_core_map = cpu_coregroup_map(i);
 		cpus_and(*this_core_map, *this_core_map, *cpu_map);
@@ -7503,11 +7514,11 @@ static int __build_sched_domains(const c
 
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
+		node_to_cpumask_ptr(pnodemask, i);
 
-		*nodemask = node_to_cpumask(i);
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpus_and(*nodemask, *pnodemask, *cpu_map);
 		if (cpus_empty(*nodemask))
 			continue;
 
@@ -7519,7 +7530,7 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
 	if (sd_allnodes) {
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
 		init_sched_build_groups(cpu_map, cpu_map,
 					&cpu_to_allnodes_group,
@@ -7529,15 +7540,15 @@ static int __build_sched_domains(const c
 	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(domainspan, allmasks);
-		SCHED_CPUMASK_VAR(covered, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		CPUMASK_PTR(domainspan, allmasks);
+		CPUMASK_PTR(covered, allmasks);
+		node_to_cpumask_ptr(pnodemask, i);
 		int j;
 
-		*nodemask = node_to_cpumask(i);
 		cpus_clear(*covered);
 
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpus_and(*nodemask, *pnodemask, *cpu_map);
 		if (cpus_empty(*nodemask)) {
 			sched_group_nodes[i] = NULL;
 			continue;
@@ -7566,7 +7577,7 @@ static int __build_sched_domains(const c
 		prev = sg;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			SCHED_CPUMASK_VAR(notcovered, allmasks);
+			CPUMASK_PTR(notcovered, allmasks);
 			int n = (i + j) % nr_node_ids;
 			node_to_cpumask_ptr(pnodemask, n);
 
@@ -7645,13 +7656,13 @@ static int __build_sched_domains(const c
 		cpu_attach_domain(sd, rd, i);
 	}
 
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	CPUMASK_FREE(allmasks);
 	return 0;
 
 #ifdef CONFIG_NUMA
 error:
 	free_sched_groups(cpu_map, tmpmask);
-	SCHED_CPUMASK_FREE((void *)allmasks);
+	CPUMASK_FREE(allmasks);
 	return -ENOMEM;
 #endif
 }

-- 
