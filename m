Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbYDEBOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbYDEBOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYDEBLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:18 -0400
Received: from relay1.sgi.com ([192.48.171.29]:57946 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751735AbYDEBLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:04 -0400
Message-Id: <20080405011102.652920000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:11 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] cpumask: reduce stack usage in SD_x_INIT initializers
Content-Disposition: inline; filename=kernel_sched_c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Remove empty cpumask_t (and all non-zero/non-null) variables
    in SD_*_INIT macros.  Use memset(0) to clear.  Also, don't
    inline the initializer functions to save on stack space in
    build_sched_domains().

  * Merge change to include/linux/topology.h that uses the new
    node_to_cpumask_ptr function in the nr_cpus_node macro into
    this patch.

Depends on:
	[mm-patch]: asm-generic-add-node_to_cpumask_ptr-macro.patch
	[sched-devel]: sched: add new set_cpus_allowed_ptr function

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>

Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/topology.h |    5 
 include/linux/topology.h   |   46 -----
 kernel/sched.c             |  368 ++++++++++++++++++++++++++++++---------------
 3 files changed, 256 insertions(+), 163 deletions(-)

--- linux-2.6.x86.orig/include/asm-x86/topology.h
+++ linux-2.6.x86/include/asm-x86/topology.h
@@ -155,10 +155,6 @@ extern unsigned long node_remap_size[];
 
 /* sched_domains SD_NODE_INIT for NUMAQ machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
 	.min_interval		= 8,			\
 	.max_interval		= 32,			\
 	.busy_factor		= 32,			\
@@ -176,7 +172,6 @@ extern unsigned long node_remap_size[];
 				| SD_WAKE_BALANCE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 
 #ifdef CONFIG_X86_64_ACPI_NUMA
--- linux-2.6.x86.orig/include/linux/topology.h
+++ linux-2.6.x86/include/linux/topology.h
@@ -38,16 +38,15 @@
 #endif
 
 #ifndef nr_cpus_node
-#define nr_cpus_node(node)							\
-	({									\
-		cpumask_t __tmp__;						\
-		__tmp__ = node_to_cpumask(node);				\
-		cpus_weight(__tmp__);						\
+#define nr_cpus_node(node)				\
+	({						\
+		node_to_cpumask_ptr(__tmp__, node);	\
+		cpus_weight(*__tmp__);			\
 	})
 #endif
 
-#define for_each_node_with_cpus(node)						\
-	for_each_online_node(node)						\
+#define for_each_node_with_cpus(node)			\
+	for_each_online_node(node)			\
 		if (nr_cpus_node(node))
 
 void arch_update_cpu_topology(void);
@@ -80,7 +79,9 @@ void arch_update_cpu_topology(void);
  * by defining their own arch-specific initializer in include/asm/topology.h.
  * A definition there will automagically override these default initializers
  * and allow arch-specific performance tuning of sched_domains.
+ * (Only non-zero and non-null fields need be specified.)
  */
+
 #ifdef CONFIG_SCHED_SMT
 /* MCD - Do we really need this?  It is always on if CONFIG_SCHED_SMT is,
  * so can't we drop this in favor of CONFIG_SCHED_SMT?
@@ -89,20 +90,10 @@ void arch_update_cpu_topology(void);
 /* Common values for SMT siblings */
 #ifndef SD_SIBLING_INIT
 #define SD_SIBLING_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
 	.min_interval		= 1,			\
 	.max_interval		= 2,			\
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 110,			\
-	.cache_nice_tries	= 0,			\
-	.busy_idx		= 0,			\
-	.idle_idx		= 0,			\
-	.newidle_idx		= 0,			\
-	.wake_idx		= 0,			\
-	.forkexec_idx		= 0,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_FORK	\
@@ -112,7 +103,6 @@ void arch_update_cpu_topology(void);
 				| SD_SHARE_CPUPOWER,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -121,18 +111,12 @@ void arch_update_cpu_topology(void);
 /* Common values for MC siblings. for now mostly derived from SD_CPU_INIT */
 #ifndef SD_MC_INIT
 #define SD_MC_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
 	.min_interval		= 1,			\
 	.max_interval		= 4,			\
 	.busy_factor		= 64,			\
 	.imbalance_pct		= 125,			\
 	.cache_nice_tries	= 1,			\
 	.busy_idx		= 2,			\
-	.idle_idx		= 0,			\
-	.newidle_idx		= 0,			\
 	.wake_idx		= 1,			\
 	.forkexec_idx		= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
@@ -144,7 +128,6 @@ void arch_update_cpu_topology(void);
 				| BALANCE_FOR_MC_POWER,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -152,10 +135,6 @@ void arch_update_cpu_topology(void);
 /* Common values for CPUs */
 #ifndef SD_CPU_INIT
 #define SD_CPU_INIT (struct sched_domain) {		\
-	.span			= CPU_MASK_NONE,	\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
 	.min_interval		= 1,			\
 	.max_interval		= 4,			\
 	.busy_factor		= 64,			\
@@ -174,16 +153,11 @@ void arch_update_cpu_topology(void);
 				| BALANCE_FOR_PKG_POWER,\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 #endif
 
 /* sched_domains SD_ALLNODES_INIT for NUMA machines */
 #define SD_ALLNODES_INIT (struct sched_domain) {	\
-	.span			= CPU_MASK_NONE,	\
-	.parent			= NULL,			\
-	.child			= NULL,			\
-	.groups			= NULL,			\
 	.min_interval		= 64,			\
 	.max_interval		= 64*num_online_cpus(),	\
 	.busy_factor		= 128,			\
@@ -191,14 +165,10 @@ void arch_update_cpu_topology(void);
 	.cache_nice_tries	= 1,			\
 	.busy_idx		= 3,			\
 	.idle_idx		= 3,			\
-	.newidle_idx		= 0, /* unused */	\
-	.wake_idx		= 0, /* unused */	\
-	.forkexec_idx		= 0, /* unused */	\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_SERIALIZE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 64,			\
-	.nr_balance_failed	= 0,			\
 }
 
 #ifdef CONFIG_NUMA
--- linux-2.6.x86.orig/kernel/sched.c
+++ linux-2.6.x86/kernel/sched.c
@@ -1900,17 +1900,17 @@ find_idlest_group(struct sched_domain *s
  * find_idlest_cpu - find the idlest cpu among the cpus in group.
  */
 static int
-find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
+find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
+		cpumask_t *tmp)
 {
-	cpumask_t tmp;
 	unsigned long load, min_load = ULONG_MAX;
 	int idlest = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
-	cpus_and(tmp, group->cpumask, p->cpus_allowed);
+	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu_mask(i, tmp) {
+	for_each_cpu_mask(i, *tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -1949,7 +1949,7 @@ static int sched_balance_self(int cpu, i
 	}
 
 	while (sd) {
-		cpumask_t span;
+		cpumask_t span, tmpmask;
 		struct sched_group *group;
 		int new_cpu, weight;
 
@@ -1965,7 +1965,7 @@ static int sched_balance_self(int cpu, i
 			continue;
 		}
 
-		new_cpu = find_idlest_cpu(group, t, cpu);
+		new_cpu = find_idlest_cpu(group, t, cpu, &tmpmask);
 		if (new_cpu == -1 || new_cpu == cpu) {
 			/* Now try balancing at a lower domain level of cpu */
 			sd = sd->child;
@@ -2852,7 +2852,7 @@ static int move_one_task(struct rq *this
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, cpumask_t *cpus, int *balance)
+		   int *sd_idle, const cpumask_t *cpus, int *balance)
 {
 	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
@@ -3153,7 +3153,7 @@ ret:
  */
 static struct rq *
 find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, cpumask_t *cpus)
+		   unsigned long imbalance, const cpumask_t *cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -3192,15 +3192,16 @@ find_busiest_queue(struct sched_group *g
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance)
+			int *balance, cpumask_t *cpus)
 {
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
 	struct rq *busiest;
-	cpumask_t cpus = CPU_MASK_ALL;
 	unsigned long flags;
 
+	cpus_setall(*cpus);
+
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
 	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -3215,7 +3216,7 @@ static int load_balance(int this_cpu, st
 
 redo:
 	group = find_busiest_group(sd, this_cpu, &imbalance, idle, &sd_idle,
-				   &cpus, balance);
+				   cpus, balance);
 
 	if (*balance == 0)
 		goto out_balanced;
@@ -3225,7 +3226,7 @@ redo:
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(group, idle, imbalance, &cpus);
+	busiest = find_busiest_queue(group, idle, imbalance, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[idle]);
 		goto out_balanced;
@@ -3258,8 +3259,8 @@ redo:
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), cpus);
-			if (!cpus_empty(cpus))
+			cpu_clear(cpu_of(busiest), *cpus);
+			if (!cpus_empty(*cpus))
 				goto redo;
 			goto out_balanced;
 		}
@@ -3344,7 +3345,8 @@ out_one_pinned:
  * this_rq is locked.
  */
 static int
-load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd)
+load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
+			cpumask_t *cpus)
 {
 	struct sched_group *group;
 	struct rq *busiest = NULL;
@@ -3352,7 +3354,8 @@ load_balance_newidle(int this_cpu, struc
 	int ld_moved = 0;
 	int sd_idle = 0;
 	int all_pinned = 0;
-	cpumask_t cpus = CPU_MASK_ALL;
+
+	cpus_setall(*cpus);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3367,14 +3370,13 @@ load_balance_newidle(int this_cpu, struc
 	schedstat_inc(sd, lb_count[CPU_NEWLY_IDLE]);
 redo:
 	group = find_busiest_group(sd, this_cpu, &imbalance, CPU_NEWLY_IDLE,
-				   &sd_idle, &cpus, NULL);
+				   &sd_idle, cpus, NULL);
 	if (!group) {
 		schedstat_inc(sd, lb_nobusyg[CPU_NEWLY_IDLE]);
 		goto out_balanced;
 	}
 
-	busiest = find_busiest_queue(group, CPU_NEWLY_IDLE, imbalance,
-				&cpus);
+	busiest = find_busiest_queue(group, CPU_NEWLY_IDLE, imbalance, cpus);
 	if (!busiest) {
 		schedstat_inc(sd, lb_nobusyq[CPU_NEWLY_IDLE]);
 		goto out_balanced;
@@ -3396,8 +3398,8 @@ redo:
 		spin_unlock(&busiest->lock);
 
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), cpus);
-			if (!cpus_empty(cpus))
+			cpu_clear(cpu_of(busiest), *cpus);
+			if (!cpus_empty(*cpus))
 				goto redo;
 		}
 	}
@@ -3431,6 +3433,7 @@ static void idle_balance(int this_cpu, s
 	struct sched_domain *sd;
 	int pulled_task = -1;
 	unsigned long next_balance = jiffies + HZ;
+	cpumask_t tmpmask;
 
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -3440,8 +3443,8 @@ static void idle_balance(int this_cpu, s
 
 		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
-			pulled_task = load_balance_newidle(this_cpu,
-								this_rq, sd);
+			pulled_task = load_balance_newidle(this_cpu, this_rq,
+							   sd, &tmpmask);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
@@ -3600,6 +3603,7 @@ static void rebalance_domains(int cpu, e
 	/* Earliest time when we have to do rebalance again */
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
+	cpumask_t tmp;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3623,7 +3627,7 @@ static void rebalance_domains(int cpu, e
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance)) {
+			if (load_balance(cpu, rq, sd, idle, &balance, &tmp)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -5000,7 +5004,7 @@ long sched_setaffinity(pid_t pid, const 
 	cpuset_cpus_allowed(p, &cpus_allowed);
 	cpus_and(new_mask, new_mask, cpus_allowed);
  again:
-	retval = set_cpus_allowed(p, new_mask);
+	retval = set_cpus_allowed_ptr(p, &new_mask);
 
 	if (!retval) {
 		cpuset_cpus_allowed(p, &cpus_allowed);
@@ -5758,7 +5762,7 @@ static void move_task_off_dead_cpu(int d
  */
 static void migrate_nr_uninterruptible(struct rq *rq_src)
 {
-	struct rq *rq_dest = cpu_rq(any_online_cpu(CPU_MASK_ALL));
+	struct rq *rq_dest = cpu_rq(any_online_cpu(*CPU_MASK_ALL_PTR));
 	unsigned long flags;
 
 	local_irq_save(flags);
@@ -6172,14 +6176,14 @@ void __init migration_init(void)
 
 #ifdef CONFIG_SCHED_DEBUG
 
-static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level)
+static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
+				  cpumask_t *groupmask)
 {
 	struct sched_group *group = sd->groups;
-	cpumask_t groupmask;
 	char str[256];
 
 	cpulist_scnprintf(str, sizeof(str), sd->span);
-	cpus_clear(groupmask);
+	cpus_clear(*groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
@@ -6223,13 +6227,13 @@ static int sched_domain_debug_one(struct
 			break;
 		}
 
-		if (cpus_intersects(groupmask, group->cpumask)) {
+		if (cpus_intersects(*groupmask, group->cpumask)) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: repeated CPUs\n");
 			break;
 		}
 
-		cpus_or(groupmask, groupmask, group->cpumask);
+		cpus_or(*groupmask, *groupmask, group->cpumask);
 
 		cpulist_scnprintf(str, sizeof(str), group->cpumask);
 		printk(KERN_CONT " %s", str);
@@ -6238,10 +6242,10 @@ static int sched_domain_debug_one(struct
 	} while (group != sd->groups);
 	printk(KERN_CONT "\n");
 
-	if (!cpus_equal(sd->span, groupmask))
+	if (!cpus_equal(sd->span, *groupmask))
 		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
 
-	if (sd->parent && !cpus_subset(groupmask, sd->parent->span))
+	if (sd->parent && !cpus_subset(*groupmask, sd->parent->span))
 		printk(KERN_ERR "ERROR: parent span is not a superset "
 			"of domain->span\n");
 	return 0;
@@ -6249,6 +6253,7 @@ static int sched_domain_debug_one(struct
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
+	cpumask_t *groupmask;
 	int level = 0;
 
 	if (!sd) {
@@ -6258,14 +6263,21 @@ static void sched_domain_debug(struct sc
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
+	groupmask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (!groupmask) {
+		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
+		return;
+	}
+
 	for (;;) {
-		if (sched_domain_debug_one(sd, cpu, level))
+		if (sched_domain_debug_one(sd, cpu, level, groupmask))
 			break;
 		level++;
 		sd = sd->parent;
 		if (!sd)
 			break;
 	}
+	kfree(groupmask);
 }
 #else
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -6435,30 +6447,33 @@ cpu_attach_domain(struct sched_domain *s
  * and ->cpu_power to 0.
  */
 static void
-init_sched_build_groups(cpumask_t span, const cpumask_t *cpu_map,
+init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
 			int (*group_fn)(int cpu, const cpumask_t *cpu_map,
-					struct sched_group **sg))
+					struct sched_group **sg,
+					cpumask_t *tmpmask),
+			cpumask_t *covered, cpumask_t *tmpmask)
 {
 	struct sched_group *first = NULL, *last = NULL;
-	cpumask_t covered = CPU_MASK_NONE;
 	int i;
 
-	for_each_cpu_mask(i, span) {
+	cpus_clear(*covered);
+
+	for_each_cpu_mask(i, *span) {
 		struct sched_group *sg;
-		int group = group_fn(i, cpu_map, &sg);
+		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
 
-		if (cpu_isset(i, covered))
+		if (cpu_isset(i, *covered))
 			continue;
 
-		sg->cpumask = CPU_MASK_NONE;
+		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask(j, span) {
-			if (group_fn(j, cpu_map, NULL) != group)
+		for_each_cpu_mask(j, *span) {
+			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
-			cpu_set(j, covered);
+			cpu_set(j, *covered);
 			cpu_set(j, sg->cpumask);
 		}
 		if (!first)
@@ -6556,7 +6571,8 @@ static DEFINE_PER_CPU(struct sched_domai
 static DEFINE_PER_CPU(struct sched_group, sched_group_cpus);
 
 static int
-cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg)
+cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		 cpumask_t *unused)
 {
 	if (sg)
 		*sg = &per_cpu(sched_group_cpus, cpu);
@@ -6574,19 +6590,22 @@ static DEFINE_PER_CPU(struct sched_group
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg)
+cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		  cpumask_t *mask)
 {
 	int group;
-	cpumask_t mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(mask, mask, *cpu_map);
-	group = first_cpu(mask);
+
+	*mask = per_cpu(cpu_sibling_map, cpu);
+	cpus_and(*mask, *mask, *cpu_map);
+	group = first_cpu(*mask);
 	if (sg)
 		*sg = &per_cpu(sched_group_core, group);
 	return group;
 }
 #elif defined(CONFIG_SCHED_MC)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg)
+cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		  cpumask_t *unused)
 {
 	if (sg)
 		*sg = &per_cpu(sched_group_core, cpu);
@@ -6598,17 +6617,18 @@ static DEFINE_PER_CPU(struct sched_domai
 static DEFINE_PER_CPU(struct sched_group, sched_group_phys);
 
 static int
-cpu_to_phys_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg)
+cpu_to_phys_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		  cpumask_t *mask)
 {
 	int group;
 #ifdef CONFIG_SCHED_MC
-	cpumask_t mask = *cpu_coregroup_map(cpu);
-	cpus_and(mask, mask, *cpu_map);
-	group = first_cpu(mask);
+	*mask = *cpu_coregroup_map(cpu);
+	cpus_and(*mask, *mask, *cpu_map);
+	group = first_cpu(*mask);
 #elif defined(CONFIG_SCHED_SMT)
-	cpumask_t mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(mask, mask, *cpu_map);
-	group = first_cpu(mask);
+	*mask = per_cpu(cpu_sibling_map, cpu);
+	cpus_and(*mask, *mask, *cpu_map);
+	group = first_cpu(*mask);
 #else
 	group = cpu;
 #endif
@@ -6630,13 +6650,13 @@ static DEFINE_PER_CPU(struct sched_domai
 static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
 
 static int cpu_to_allnodes_group(int cpu, const cpumask_t *cpu_map,
-				 struct sched_group **sg)
+				 struct sched_group **sg, cpumask_t *nodemask)
 {
-	cpumask_t nodemask = node_to_cpumask(cpu_to_node(cpu));
 	int group;
 
-	cpus_and(nodemask, nodemask, *cpu_map);
-	group = first_cpu(nodemask);
+	*nodemask = node_to_cpumask(cpu_to_node(cpu));
+	cpus_and(*nodemask, *nodemask, *cpu_map);
+	group = first_cpu(*nodemask);
 
 	if (sg)
 		*sg = &per_cpu(sched_group_allnodes, group);
@@ -6672,7 +6692,7 @@ static void init_numa_sched_groups_power
 
 #ifdef CONFIG_NUMA
 /* Free memory allocated for various sched_group structures */
-static void free_sched_groups(const cpumask_t *cpu_map)
+static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 {
 	int cpu, i;
 
@@ -6684,11 +6704,11 @@ static void free_sched_groups(const cpum
 			continue;
 
 		for (i = 0; i < MAX_NUMNODES; i++) {
-			cpumask_t nodemask = node_to_cpumask(i);
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
 
-			cpus_and(nodemask, nodemask, *cpu_map);
-			if (cpus_empty(nodemask))
+			*nodemask = node_to_cpumask(i);
+			cpus_and(*nodemask, *nodemask, *cpu_map);
+			if (cpus_empty(*nodemask))
 				continue;
 
 			if (sg == NULL)
@@ -6706,7 +6726,7 @@ next_sg:
 	}
 }
 #else
-static void free_sched_groups(const cpumask_t *cpu_map)
+static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 {
 }
 #endif
@@ -6764,6 +6784,65 @@ static void init_sched_groups_power(int 
 }
 
 /*
+ * Initializers for schedule domains
+ * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
+ */
+
+#define	SD_INIT(sd, type)	sd_init_##type(sd)
+#define SD_INIT_FUNC(type)	\
+static noinline void sd_init_##type(struct sched_domain *sd)	\
+{								\
+	memset(sd, 0, sizeof(*sd));				\
+	*sd = SD_##type##_INIT;					\
+}
+
+SD_INIT_FUNC(CPU)
+#ifdef CONFIG_NUMA
+ SD_INIT_FUNC(ALLNODES)
+ SD_INIT_FUNC(NODE)
+#endif
+#ifdef CONFIG_SCHED_SMT
+ SD_INIT_FUNC(SIBLING)
+#endif
+#ifdef CONFIG_SCHED_MC
+ SD_INIT_FUNC(MC)
+#endif
+
+/*
+ * To minimize stack usage kmalloc room for cpumasks and share the
+ * space as the usage in build_sched_domains() dictates.  Used only
+ * if the amount of space is significant.
+ */
+struct allmasks {
+	cpumask_t tmpmask;			/* make this one first */
+	union {
+		cpumask_t nodemask;
+		cpumask_t this_sibling_map;
+		cpumask_t this_core_map;
+	};
+	cpumask_t send_covered;
+
+#ifdef CONFIG_NUMA
+	cpumask_t domainspan;
+	cpumask_t covered;
+	cpumask_t notcovered;
+#endif
+};
+
+#if	NR_CPUS > 128
+#define	SCHED_CPUMASK_ALLOC		1
+#define	SCHED_CPUMASK_FREE(v)		kfree(v)
+#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+#else
+#define	SCHED_CPUMASK_ALLOC		0
+#define	SCHED_CPUMASK_FREE(v)
+#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+#endif
+
+#define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
+			((unsigned long)(a) + offsetof(struct allmasks, v))
+
+/*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
@@ -6771,6 +6850,8 @@ static int build_sched_domains(const cpu
 {
 	int i;
 	struct root_domain *rd;
+	SCHED_CPUMASK_DECLARE(allmasks);
+	cpumask_t *tmpmask;
 #ifdef CONFIG_NUMA
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
@@ -6784,38 +6865,60 @@ static int build_sched_domains(const cpu
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
 		return -ENOMEM;
 	}
-	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
 #endif
 
 	rd = alloc_rootdomain();
 	if (!rd) {
 		printk(KERN_WARNING "Cannot alloc root domain\n");
+#ifdef CONFIG_NUMA
+		kfree(sched_group_nodes);
+#endif
 		return -ENOMEM;
 	}
 
+#if SCHED_CPUMASK_ALLOC
+	/* get space for all scratch cpumask variables */
+	allmasks = kmalloc(sizeof(*allmasks), GFP_KERNEL);
+	if (!allmasks) {
+		printk(KERN_WARNING "Cannot alloc cpumask array\n");
+		kfree(rd);
+#ifdef CONFIG_NUMA
+		kfree(sched_group_nodes);
+#endif
+		return -ENOMEM;
+	}
+#endif
+	tmpmask = (cpumask_t *)allmasks;
+
+
+#ifdef CONFIG_NUMA
+	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
+#endif
+
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
 	for_each_cpu_mask(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
-		cpumask_t nodemask = node_to_cpumask(cpu_to_node(i));
+		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
-		cpus_and(nodemask, nodemask, *cpu_map);
+		*nodemask = node_to_cpumask(cpu_to_node(i));
+		cpus_and(*nodemask, *nodemask, *cpu_map);
 
 #ifdef CONFIG_NUMA
 		if (cpus_weight(*cpu_map) >
-				SD_NODES_PER_DOMAIN*cpus_weight(nodemask)) {
+				SD_NODES_PER_DOMAIN*cpus_weight(*nodemask)) {
 			sd = &per_cpu(allnodes_domains, i);
-			*sd = SD_ALLNODES_INIT;
+			SD_INIT(sd, ALLNODES);
 			sd->span = *cpu_map;
-			cpu_to_allnodes_group(i, cpu_map, &sd->groups);
+			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
 		} else
 			p = NULL;
 
 		sd = &per_cpu(node_domains, i);
-		*sd = SD_NODE_INIT;
+		SD_INIT(sd, NODE);
 		sd->span = sched_domain_node_span(cpu_to_node(i));
 		sd->parent = p;
 		if (p)
@@ -6825,94 +6928,114 @@ static int build_sched_domains(const cpu
 
 		p = sd;
 		sd = &per_cpu(phys_domains, i);
-		*sd = SD_CPU_INIT;
-		sd->span = nodemask;
+		SD_INIT(sd, CPU);
+		sd->span = *nodemask;
 		sd->parent = p;
 		if (p)
 			p->child = sd;
-		cpu_to_phys_group(i, cpu_map, &sd->groups);
+		cpu_to_phys_group(i, cpu_map, &sd->groups, tmpmask);
 
 #ifdef CONFIG_SCHED_MC
 		p = sd;
 		sd = &per_cpu(core_domains, i);
-		*sd = SD_MC_INIT;
+		SD_INIT(sd, MC);
 		sd->span = *cpu_coregroup_map(i);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
-		cpu_to_core_group(i, cpu_map, &sd->groups);
+		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
 		p = sd;
 		sd = &per_cpu(cpu_domains, i);
-		*sd = SD_SIBLING_INIT;
+		SD_INIT(sd, SIBLING);
 		sd->span = per_cpu(cpu_sibling_map, i);
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
-		cpu_to_cpu_group(i, cpu_map, &sd->groups);
+		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
 #endif
 	}
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
 	for_each_cpu_mask(i, *cpu_map) {
-		cpumask_t this_sibling_map = per_cpu(cpu_sibling_map, i);
-		cpus_and(this_sibling_map, this_sibling_map, *cpu_map);
-		if (i != first_cpu(this_sibling_map))
+		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
+
+		*this_sibling_map = per_cpu(cpu_sibling_map, i);
+		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
+		if (i != first_cpu(*this_sibling_map))
 			continue;
 
 		init_sched_build_groups(this_sibling_map, cpu_map,
-					&cpu_to_cpu_group);
+					&cpu_to_cpu_group,
+					send_covered, tmpmask);
 	}
 #endif
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
 	for_each_cpu_mask(i, *cpu_map) {
-		cpumask_t this_core_map = *cpu_coregroup_map(i);
-		cpus_and(this_core_map, this_core_map, *cpu_map);
-		if (i != first_cpu(this_core_map))
+		SCHED_CPUMASK_VAR(this_core_map, allmasks);
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
+
+		*this_core_map = *cpu_coregroup_map(i);
+		cpus_and(*this_core_map, *this_core_map, *cpu_map);
+		if (i != first_cpu(*this_core_map))
 			continue;
+
 		init_sched_build_groups(this_core_map, cpu_map,
-					&cpu_to_core_group);
+					&cpu_to_core_group,
+					send_covered, tmpmask);
 	}
 #endif
 
 	/* Set up physical groups */
 	for (i = 0; i < MAX_NUMNODES; i++) {
-		cpumask_t nodemask = node_to_cpumask(i);
+		SCHED_CPUMASK_VAR(nodemask, allmasks);
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
-		cpus_and(nodemask, nodemask, *cpu_map);
-		if (cpus_empty(nodemask))
+		*nodemask = node_to_cpumask(i);
+		cpus_and(*nodemask, *nodemask, *cpu_map);
+		if (cpus_empty(*nodemask))
 			continue;
 
-		init_sched_build_groups(nodemask, cpu_map, &cpu_to_phys_group);
+		init_sched_build_groups(nodemask, cpu_map,
+					&cpu_to_phys_group,
+					send_covered, tmpmask);
 	}
 
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
-	if (sd_allnodes)
-		init_sched_build_groups(*cpu_map, cpu_map,
-					&cpu_to_allnodes_group);
+	if (sd_allnodes) {
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
+
+		init_sched_build_groups(cpu_map, cpu_map,
+					&cpu_to_allnodes_group,
+					send_covered, tmpmask);
+	}
 
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
-		cpumask_t nodemask = node_to_cpumask(i);
-		cpumask_t domainspan;
-		cpumask_t covered = CPU_MASK_NONE;
+		SCHED_CPUMASK_VAR(nodemask, allmasks);
+		SCHED_CPUMASK_VAR(domainspan, allmasks);
+		SCHED_CPUMASK_VAR(covered, allmasks);
 		int j;
 
-		cpus_and(nodemask, nodemask, *cpu_map);
-		if (cpus_empty(nodemask)) {
+		*nodemask = node_to_cpumask(i);
+		cpus_clear(*covered);
+
+		cpus_and(*nodemask, *nodemask, *cpu_map);
+		if (cpus_empty(*nodemask)) {
 			sched_group_nodes[i] = NULL;
 			continue;
 		}
 
-		domainspan = sched_domain_node_span(i);
-		cpus_and(domainspan, domainspan, *cpu_map);
+		*domainspan = sched_domain_node_span(i);
+		cpus_and(*domainspan, *domainspan, *cpu_map);
 
 		sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
 		if (!sg) {
@@ -6921,31 +7044,31 @@ static int build_sched_domains(const cpu
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask(j, nodemask) {
+		for_each_cpu_mask(j, *nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
-		sg->cpumask = nodemask;
+		sg->cpumask = *nodemask;
 		sg->next = sg;
-		cpus_or(covered, covered, nodemask);
+		cpus_or(*covered, *covered, *nodemask);
 		prev = sg;
 
 		for (j = 0; j < MAX_NUMNODES; j++) {
-			cpumask_t tmp, notcovered;
+			SCHED_CPUMASK_VAR(notcovered, allmasks);
 			int n = (i + j) % MAX_NUMNODES;
 			node_to_cpumask_ptr(pnodemask, n);
 
-			cpus_complement(notcovered, covered);
-			cpus_and(tmp, notcovered, *cpu_map);
-			cpus_and(tmp, tmp, domainspan);
-			if (cpus_empty(tmp))
+			cpus_complement(*notcovered, *covered);
+			cpus_and(*tmpmask, *notcovered, *cpu_map);
+			cpus_and(*tmpmask, *tmpmask, *domainspan);
+			if (cpus_empty(*tmpmask))
 				break;
 
-			cpus_and(tmp, tmp, *pnodemask);
-			if (cpus_empty(tmp))
+			cpus_and(*tmpmask, *tmpmask, *pnodemask);
+			if (cpus_empty(*tmpmask))
 				continue;
 
 			sg = kmalloc_node(sizeof(struct sched_group),
@@ -6956,9 +7079,9 @@ static int build_sched_domains(const cpu
 				goto error;
 			}
 			sg->__cpu_power = 0;
-			sg->cpumask = tmp;
+			sg->cpumask = *tmpmask;
 			sg->next = prev->next;
-			cpus_or(covered, covered, tmp);
+			cpus_or(*covered, *covered, *tmpmask);
 			prev->next = sg;
 			prev = sg;
 		}
@@ -6994,7 +7117,8 @@ static int build_sched_domains(const cpu
 	if (sd_allnodes) {
 		struct sched_group *sg;
 
-		cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map, &sg);
+		cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map, &sg,
+								tmpmask);
 		init_numa_sched_groups_power(sg);
 	}
 #endif
@@ -7012,11 +7136,13 @@ static int build_sched_domains(const cpu
 		cpu_attach_domain(sd, rd, i);
 	}
 
+	SCHED_CPUMASK_FREE((void *)allmasks);
 	return 0;
 
 #ifdef CONFIG_NUMA
 error:
-	free_sched_groups(cpu_map);
+	free_sched_groups(cpu_map, tmpmask);
+	SCHED_CPUMASK_FREE((void *)allmasks);
 	return -ENOMEM;
 #endif
 }
@@ -7056,9 +7182,10 @@ static int arch_init_sched_domains(const
 	return err;
 }
 
-static void arch_destroy_sched_domains(const cpumask_t *cpu_map)
+static void arch_destroy_sched_domains(const cpumask_t *cpu_map,
+				       cpumask_t *tmpmask)
 {
-	free_sched_groups(cpu_map);
+	free_sched_groups(cpu_map, tmpmask);
 }
 
 /*
@@ -7067,6 +7194,7 @@ static void arch_destroy_sched_domains(c
  */
 static void detach_destroy_domains(const cpumask_t *cpu_map)
 {
+	cpumask_t tmpmask;
 	int i;
 
 	unregister_sched_domain_sysctl();
@@ -7074,7 +7202,7 @@ static void detach_destroy_domains(const
 	for_each_cpu_mask(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
-	arch_destroy_sched_domains(cpu_map);
+	arch_destroy_sched_domains(cpu_map, &tmpmask);
 }
 
 /*
@@ -7282,7 +7410,7 @@ void __init sched_init_smp(void)
 	hotcpu_notifier(update_sched_domains, 0);
 
 	/* Move init over to a non-isolated CPU */
-	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
+	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
 }

-- 
