Return-Path: <linux-kernel-owner+w=401wt.eu-S1763513AbYEOSf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763513AbYEOSf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762328AbYEOSfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:35:39 -0400
Received: from nds154-200.nds.lab.novell.com ([151.155.154.200]:54157 "EHLO
	lsg.lab.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761358AbYEOSfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:35:36 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [RFC PATCH 1/3] sched: create sched_balancer container for
	sched_groups
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Sidda <suresh.b.siddha@intel.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Gregory Haskins <ghaskins@novell.com>
Date: Thu, 15 May 2008 12:35:36 -0600
Message-ID: <20080515183535.5323.22119.stgit@lsg>
In-Reply-To: <20080515182832.5323.70102.stgit@lsg>
References: <20080515182832.5323.70102.stgit@lsg>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to add multiple sched_group balancing domains per sched_domains
(later in the series), so we split up the current logic to make it more
fine grained.  This patch does not alter the general logic at all.
However, it does move the initialization of some of the fields to runtime
instead of declared statically in topology.h

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/asm-ia64/topology.h           |    6 --
 include/asm-mips/mach-ip27/topology.h |    3 -
 include/asm-powerpc/topology.h        |    3 -
 include/asm-sh/topology.h             |    3 -
 include/asm-sparc64/topology.h        |    2 -
 include/asm-x86/topology.h            |    2 -
 include/linux/sched.h                 |   15 +++-
 include/linux/topology.h              |    8 --
 kernel/sched.c                        |  125 +++++++++++++++++++++------------
 9 files changed, 89 insertions(+), 78 deletions(-)

diff --git a/include/asm-ia64/topology.h b/include/asm-ia64/topology.h
index 32863b3..6409a70 100644
--- a/include/asm-ia64/topology.h
+++ b/include/asm-ia64/topology.h
@@ -75,9 +75,6 @@ void build_cpu_to_node_map(void);
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 
 /* sched_domains SD_NODE_INIT for IA64 NUMA machines */
@@ -101,9 +98,6 @@ void build_cpu_to_node_map(void);
 				| SD_BALANCE_FORK	\
 				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 64,			\
-	.nr_balance_failed	= 0,			\
 }
 
 #endif /* CONFIG_NUMA */
diff --git a/include/asm-mips/mach-ip27/topology.h b/include/asm-mips/mach-ip27/topology.h
index 7785bec..583c0c6 100644
--- a/include/asm-mips/mach-ip27/topology.h
+++ b/include/asm-mips/mach-ip27/topology.h
@@ -49,9 +49,6 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_BALANCE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 
 #include <asm-generic/topology.h>
diff --git a/include/asm-powerpc/topology.h b/include/asm-powerpc/topology.h
index 100c6fb..182ecb5 100644
--- a/include/asm-powerpc/topology.h
+++ b/include/asm-powerpc/topology.h
@@ -67,9 +67,6 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 				| SD_WAKE_IDLE		\
 				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 
 extern void __init dump_numa_cpu_topology(void);
diff --git a/include/asm-sh/topology.h b/include/asm-sh/topology.h
index 34cdb28..53e090d 100644
--- a/include/asm-sh/topology.h
+++ b/include/asm-sh/topology.h
@@ -24,9 +24,6 @@
 				| SD_BALANCE_EXEC	\
 				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
-	.nr_balance_failed	= 0,			\
 }
 
 #endif
diff --git a/include/asm-sparc64/topology.h b/include/asm-sparc64/topology.h
index 001c040..f9f6c2e 100644
--- a/include/asm-sparc64/topology.h
+++ b/include/asm-sparc64/topology.h
@@ -62,8 +62,6 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 				| SD_BALANCE_EXEC	\
 				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
 }
 
 #else /* CONFIG_NUMA */
diff --git a/include/asm-x86/topology.h b/include/asm-x86/topology.h
index 1f97758..51329c9 100644
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -166,8 +166,6 @@ extern unsigned long node_remap_size[];
 				| SD_BALANCE_FORK	\
 				| SD_SERIALIZE		\
 				| SD_WAKE_BALANCE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
 }
 
 #ifdef CONFIG_X86_64_ACPI_NUMA
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3882650..95e46e3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -762,11 +762,18 @@ struct sched_domain_attr {
 	.relax_domain_level = -1,			\
 }
 
+struct sched_balancer {
+	struct sched_group *groups;
+	unsigned long last_exec;      /* init to jiffies. units in jiffies */
+	unsigned long interval;	      /* initialise to 1. units in ms. */
+	unsigned long *interval_reset; /* value to reset interval to */
+	unsigned int nr_failed;       /* initialise to 0 */
+};
+
 struct sched_domain {
 	/* These fields must be setup */
 	struct sched_domain *parent;	/* top domain must be null terminated */
 	struct sched_domain *child;	/* bottom domain must be null terminated */
-	struct sched_group *groups;	/* the balancing groups of the domain */
 	cpumask_t span;			/* span of all CPUs in this domain */
 	int first_cpu;			/* cache of the first cpu in this domain */
 	unsigned long min_interval;	/* Minimum balance interval ms */
@@ -782,10 +789,8 @@ struct sched_domain {
 	int flags;			/* See SD_* */
 	enum sched_domain_level level;
 
-	/* Runtime fields. */
-	unsigned long last_balance;	/* init to jiffies. units in jiffies */
-	unsigned int balance_interval;	/* initialise to 1. units in ms. */
-	unsigned int nr_balance_failed; /* initialise to 0 */
+	/* Balancer data */
+	struct sched_balancer group_balancer;
 
 #ifdef CONFIG_SCHEDSTATS
 	/* load_balance() stats */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 4bb7074..8e60655 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -101,8 +101,6 @@ void arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_WAKE_IDLE		\
 				| SD_SHARE_CPUPOWER,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
 }
 #endif
 #endif /* CONFIG_SCHED_SMT */
@@ -126,8 +124,6 @@ void arch_update_cpu_topology(void);
 				| SD_WAKE_AFFINE	\
 				| SD_SHARE_PKG_RESOURCES\
 				| BALANCE_FOR_MC_POWER,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
 }
 #endif
 #endif /* CONFIG_SCHED_MC */
@@ -151,8 +147,6 @@ void arch_update_cpu_topology(void);
 				| SD_BALANCE_EXEC	\
 				| SD_WAKE_AFFINE	\
 				| BALANCE_FOR_PKG_POWER,\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 1,			\
 }
 #endif
 
@@ -167,8 +161,6 @@ void arch_update_cpu_topology(void);
 	.idle_idx		= 3,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_SERIALIZE,	\
-	.last_balance		= jiffies,		\
-	.balance_interval	= 64,			\
 }
 
 #ifdef CONFIG_NUMA
diff --git a/kernel/sched.c b/kernel/sched.c
index 6947d6b..a8e0bd3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2282,7 +2282,9 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 static struct sched_group *
 find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 {
-	struct sched_group *idlest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_balancer *balancer = &sd->group_balancer;
+	struct sched_group *first_group = balancer->groups;
+	struct sched_group *idlest = NULL, *this = NULL, *group = first_group;
 	unsigned long min_load = ULONG_MAX, this_load = 0;
 	int load_idx = sd->forkexec_idx;
 	int imbalance = 100 + (sd->imbalance_pct-100)/2;
@@ -2322,7 +2324,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 			min_load = avg_load;
 			idlest = group;
 		}
-	} while (group = group->next, group != sd->groups);
+	} while (group = group->next, group != first_group);
 
 	if (!idlest || 100*this_load < imbalance*min_load)
 		return NULL;
@@ -3129,7 +3131,7 @@ int can_migrate_task(struct task_struct *p, struct rq *rq, int this_cpu,
 	 */
 
 	if (!task_hot(p, rq->clock, sd) ||
-			sd->nr_balance_failed > sd->cache_nice_tries) {
+	    sd->group_balancer.nr_failed > sd->cache_nice_tries) {
 #ifdef CONFIG_SCHEDSTATS
 		if (task_hot(p, rq->clock, sd)) {
 			schedstat_inc(sd, lb_hot_gained[idle]);
@@ -3290,7 +3292,8 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
 		   int *sd_idle, const cpumask_t *cpus, int *balance)
 {
-	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
+	struct sched_group *first_group = sd->group_balancer.groups;
+	struct sched_group *busiest = NULL, *this = NULL, *group = first_group;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
 	unsigned long max_pull;
 	unsigned long busiest_load_per_task, busiest_nr_running;
@@ -3458,7 +3461,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 group_next:
 #endif
 		group = group->next;
-	} while (group != sd->groups);
+	} while (group != first_group);
 
 	if (!busiest || this_load >= max_load || busiest_nr_running == 0)
 		goto out_balanced;
@@ -3630,6 +3633,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
 			int *balance, cpumask_t *cpus)
 {
+	struct sched_balancer *balancer = &sd->group_balancer;
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
 	unsigned long imbalance;
@@ -3707,9 +3711,9 @@ redo:
 
 	if (!ld_moved) {
 		schedstat_inc(sd, lb_failed[idle]);
-		sd->nr_balance_failed++;
+		balancer->nr_failed++;
 
-		if (unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2)) {
+		if (unlikely(balancer->nr_failed > sd->cache_nice_tries+2)) {
 
 			spin_lock_irqsave(&busiest->lock, flags);
 
@@ -3735,14 +3739,14 @@ redo:
 			 * We've kicked active balancing, reset the failure
 			 * counter.
 			 */
-			sd->nr_balance_failed = sd->cache_nice_tries+1;
+			balancer->nr_failed = sd->cache_nice_tries+1;
 		}
 	} else
-		sd->nr_balance_failed = 0;
+		balancer->nr_failed = 0;
 
 	if (likely(!active_balance)) {
 		/* We were unbalanced, so reset the balancing interval */
-		sd->balance_interval = sd->min_interval;
+		balancer->interval = *balancer->interval_reset;
 	} else {
 		/*
 		 * If we've begun active balancing, start to back off. This
@@ -3750,8 +3754,8 @@ redo:
 		 * is only 1 task on the busy runqueue (because we don't call
 		 * move_tasks).
 		 */
-		if (sd->balance_interval < sd->max_interval)
-			sd->balance_interval *= 2;
+		if (balancer->interval < sd->max_interval)
+			balancer->interval *= 2;
 	}
 
 	if (!ld_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
@@ -3763,13 +3767,13 @@ redo:
 out_balanced:
 	schedstat_inc(sd, lb_balanced[idle]);
 
-	sd->nr_balance_failed = 0;
+	balancer->nr_failed = 0;
 
 out_one_pinned:
 	/* tune up the balancing interval */
-	if ((all_pinned && sd->balance_interval < MAX_PINNED_INTERVAL) ||
-			(sd->balance_interval < sd->max_interval))
-		sd->balance_interval *= 2;
+	if ((all_pinned && balancer->interval < MAX_PINNED_INTERVAL) ||
+			(balancer->interval < sd->max_interval))
+		balancer->interval *= 2;
 
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
@@ -3793,6 +3797,7 @@ static int
 load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
 			cpumask_t *cpus)
 {
+	struct sched_balancer *balancer = &sd->group_balancer;
 	struct sched_group *group;
 	struct rq *busiest = NULL;
 	unsigned long imbalance;
@@ -3855,7 +3860,7 @@ redo:
 		    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 			return -1;
 	} else
-		sd->nr_balance_failed = 0;
+		balancer->nr_failed = 0;
 
 	return ld_moved;
 
@@ -3864,7 +3869,7 @@ out_balanced:
 	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
 	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
 		return -1;
-	sd->nr_balance_failed = 0;
+	balancer->nr_failed = 0;
 
 	return 0;
 }
@@ -3881,6 +3886,7 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 	cpumask_t tmpmask;
 
 	for_each_domain(this_cpu, sd) {
+		struct sched_balancer *balancer = &sd->group_balancer;
 		unsigned long interval;
 
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3891,9 +3897,9 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 			pulled_task = load_balance_newidle(this_cpu, this_rq,
 							   sd, &tmpmask);
 
-		interval = msecs_to_jiffies(sd->balance_interval);
-		if (time_after(next_balance, sd->last_balance + interval))
-			next_balance = sd->last_balance + interval;
+		interval = msecs_to_jiffies(balancer->interval);
+		if (time_after(next_balance, balancer->last_exec + interval))
+			next_balance = balancer->last_exec + interval;
 		if (pulled_task)
 			break;
 	}
@@ -4052,10 +4058,12 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 	cpumask_t tmp;
 
 	for_each_domain(cpu, sd) {
+		struct sched_balancer *balancer = &sd->group_balancer;
+
 		if (!(sd->flags & SD_LOAD_BALANCE))
 			continue;
 
-		interval = sd->balance_interval;
+		interval = balancer->interval;
 		if (idle != CPU_IDLE)
 			interval *= sd->busy_factor;
 
@@ -4073,7 +4081,7 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 				goto out;
 		}
 
-		if (time_after_eq(jiffies, sd->last_balance + interval)) {
+		if (time_after_eq(jiffies, balancer->last_exec + interval)) {
 			if (load_balance(cpu, rq, sd, idle, &balance, &tmp)) {
 				/*
 				 * We've pulled tasks over so either we're no
@@ -4082,13 +4090,13 @@ static void rebalance_domains(int cpu, enum cpu_idle_type idle)
 				 */
 				idle = CPU_NOT_IDLE;
 			}
-			sd->last_balance = jiffies;
+			balancer->last_exec = jiffies;
 		}
 		if (need_serialize)
 			spin_unlock(&balancing);
 out:
-		if (time_after(next_balance, sd->last_balance + interval)) {
-			next_balance = sd->last_balance + interval;
+		if (time_after(next_balance, balancer->last_exec + interval)) {
+			next_balance = balancer->last_exec + interval;
 			update_next_balance = 1;
 		}
 
@@ -6611,7 +6619,8 @@ void __init migration_init(void)
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 				  cpumask_t *groupmask)
 {
-	struct sched_group *group = sd->groups;
+	struct sched_group *first_group = sd->group_balancer.groups;
+	struct sched_group *group = first_group;
 	char str[256];
 
 	cpulist_scnprintf(str, sizeof(str), sd->span);
@@ -6671,7 +6680,7 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
-	} while (group != sd->groups);
+	} while (group != first_group);
 	printk(KERN_CONT "\n");
 
 	if (!cpus_equal(sd->span, *groupmask))
@@ -6717,6 +6726,8 @@ static void sched_domain_debug(struct sched_domain *sd, int cpu)
 
 static int sd_degenerate(struct sched_domain *sd)
 {
+	struct sched_group *first_group = sd->group_balancer.groups;
+
 	if (cpus_weight(sd->span) == 1)
 		return 1;
 
@@ -6727,7 +6738,7 @@ static int sd_degenerate(struct sched_domain *sd)
 			 SD_BALANCE_EXEC |
 			 SD_SHARE_CPUPOWER |
 			 SD_SHARE_PKG_RESOURCES)) {
-		if (sd->groups != sd->groups->next)
+		if (first_group != first_group->next)
 			return 0;
 	}
 
@@ -6744,6 +6755,7 @@ static int
 sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 {
 	unsigned long cflags = sd->flags, pflags = parent->flags;
+	struct sched_group *parent_group = parent->group_balancer.groups;
 
 	if (sd_degenerate(parent))
 		return 1;
@@ -6756,7 +6768,7 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	if (cflags & SD_WAKE_AFFINE)
 		pflags &= ~SD_WAKE_BALANCE;
 	/* Flags needing groups don't count if only 1 group in parent */
-	if (parent->groups == parent->groups->next) {
+	if (parent_group == parent_group->next) {
 		pflags &= ~(SD_LOAD_BALANCE |
 				SD_BALANCE_NEWIDLE |
 				SD_BALANCE_FORK |
@@ -7122,10 +7134,10 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 		return;
 	do {
 		for_each_cpu_mask_nr(j, sg->cpumask) {
-			struct sched_domain *sd;
+			struct sched_domain *sd = &per_cpu(phys_domains, j);;
+			struct sched_group *group = sd->group_balancer.groups;
 
-			sd = &per_cpu(phys_domains, j);
-			if (j != first_cpu(sd->groups->cpumask)) {
+			if (j != first_cpu(group->cpumask)) {
 				/*
 				 * Only add "power" once for each
 				 * physical package.
@@ -7133,7 +7145,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 				continue;
 			}
 
-			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
+			sg_inc_cpu_power(sg, group->__cpu_power);
 		}
 		sg = sg->next;
 	} while (sg != group_head);
@@ -7199,15 +7211,16 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 {
 	struct sched_domain *child;
 	struct sched_group *group;
+	struct sched_group *first_group = sd->group_balancer.groups;
 
-	WARN_ON(!sd || !sd->groups);
+	WARN_ON(!sd || !first_group);
 
-	if (cpu != first_cpu(sd->groups->cpumask))
+	if (cpu != first_cpu(first_group->cpumask))
 		return;
 
 	child = sd->child;
 
-	sd->groups->__cpu_power = 0;
+	first_group->__cpu_power = 0;
 
 	/*
 	 * For perf policy, if the groups in child domain share resources
@@ -7219,18 +7232,18 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
 		       (child->flags &
 			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
-		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
+		sg_inc_cpu_power(first_group, SCHED_LOAD_SCALE);
 		return;
 	}
 
 	/*
 	 * add cpu_power of each child group to this groups cpu_power
 	 */
-	group = child->groups;
+	group = child->group_balancer.groups;
 	do {
-		sg_inc_cpu_power(sd->groups, group->__cpu_power);
+		sg_inc_cpu_power(first_group, group->__cpu_power);
 		group = group->next;
-	} while (group != child->groups);
+	} while (group != child->group_balancer.groups);
 }
 
 /*
@@ -7323,6 +7336,15 @@ static void set_domain_attribute(struct sched_domain *sd,
 	}
 }
 
+static void init_sched_balancer(struct sched_balancer *balancer,
+				unsigned long *interval_reset)
+{
+	balancer->last_exec = jiffies;
+	balancer->interval = *interval_reset;
+	balancer->interval_reset = interval_reset;
+	balancer->nr_failed = 0;
+}
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -7395,7 +7417,9 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 			set_domain_attribute(sd, attr);
 			sd->span = *cpu_map;
 			sd->first_cpu = first_cpu(sd->span);
-			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
+			cpu_to_allnodes_group(i, cpu_map,
+					      &sd->group_balancer.groups,
+					      tmpmask);
 			p = sd;
 			sd_allnodes = 1;
 		} else
@@ -7421,7 +7445,8 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		sd->parent = p;
 		if (p)
 			p->child = sd;
-		cpu_to_phys_group(i, cpu_map, &sd->groups, tmpmask);
+		cpu_to_phys_group(i, cpu_map, &sd->group_balancer.groups,
+				  tmpmask);
 
 #ifdef CONFIG_SCHED_MC
 		p = sd;
@@ -7433,7 +7458,8 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
-		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
+		cpu_to_core_group(i, cpu_map, &sd->group_balancer.groups,
+				  tmpmask);
 #endif
 
 #ifdef CONFIG_SCHED_SMT
@@ -7446,7 +7472,8 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		cpus_and(sd->span, sd->span, *cpu_map);
 		sd->parent = p;
 		p->child = sd;
-		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
+		cpu_to_cpu_group(i, cpu_map, &sd->group_balancer.groups,
+				 tmpmask);
 #endif
 	}
 
@@ -7540,7 +7567,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
-			sd->groups = sg;
+			sd->group_balancer.groups = sg;
 		}
 		sg->__cpu_power = 0;
 		sg->cpumask = *nodemask;
@@ -7626,6 +7653,12 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 		sd = &per_cpu(phys_domains, i);
 #endif
 		cpu_attach_domain(sd, rd, i);
+
+		/* Initialize the balancers */
+		for_each_domain(i, sd) {
+			init_sched_balancer(&sd->group_balancer,
+					    &sd->min_interval);
+		}
 	}
 
 	SCHED_CPUMASK_FREE((void *)allmasks);

