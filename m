Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbZIPKV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbZIPKV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757576AbZIPKV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:21:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:46414 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757446AbZIPKVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:21:20 -0400
Date: Wed, 16 Sep 2009 10:20:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Merge select_task_rq_fair() and sched_balance_self()
Message-ID: <tip-c88d5910890ad35af283344417891344604f0438@git.kernel.org>
Git-Commit-ID: c88d5910890ad35af283344417891344604f0438
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 16 Sep 2009 10:20:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c88d5910890ad35af283344417891344604f0438
Gitweb:     http://git.kernel.org/tip/c88d5910890ad35af283344417891344604f0438
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 10 Sep 2009 13:50:02 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Sep 2009 16:01:05 +0200

sched: Merge select_task_rq_fair() and sched_balance_self()

The problem with wake_idle() is that is doesn't respect things like
cpu_power, which means it doesn't deal well with SMT nor the recent
RT interaction.

To cure this, it needs to do what sched_balance_self() does, which
leads to the possibility of merging select_task_rq_fair() and
sched_balance_self().

Modify sched_balance_self() to:

  - update_shares() when walking up the domain tree,
    (it only called it for the top domain, but it should
     have done this anyway), which allows us to remove
    this ugly bit from try_to_wake_up().

  - do wake_affine() on the smallest domain that contains
    both this (the waking) and the prev (the wakee) cpu for
    WAKE invocations.

Then use the top-down balance steps it had to replace wake_idle().

This leads to the dissapearance of SD_WAKE_BALANCE and
SD_WAKE_IDLE_FAR, with SD_WAKE_IDLE replaced with SD_BALANCE_WAKE.

SD_WAKE_AFFINE needs SD_BALANCE_WAKE to be effective.

Touch all topology bits to replace the old with new SD flags --
platforms might need re-tuning, enabling SD_BALANCE_WAKE
conditionally on a NUMA distance seems like a good additional
feature, magny-core and small nehalem systems would want this
enabled, systems with slow interconnects would not.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/ia64/include/asm/topology.h           |    5 +-
 arch/mips/include/asm/mach-ip27/topology.h |    2 +-
 arch/powerpc/include/asm/topology.h        |    5 +-
 arch/sh/include/asm/topology.h             |    4 +-
 arch/sparc/include/asm/topology_64.h       |    4 +-
 arch/x86/include/asm/topology.h            |    4 +-
 include/linux/sched.h                      |    7 +-
 include/linux/topology.h                   |   16 +--
 kernel/sched.c                             |   41 +-----
 kernel/sched_fair.c                        |  233 ++++++++--------------------
 10 files changed, 84 insertions(+), 237 deletions(-)

diff --git a/arch/ia64/include/asm/topology.h b/arch/ia64/include/asm/topology.h
index 7b4c8c7..cf6053b 100644
--- a/arch/ia64/include/asm/topology.h
+++ b/arch/ia64/include/asm/topology.h
@@ -67,6 +67,7 @@ void build_cpu_to_node_map(void);
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_NEWIDLE	\
 				| SD_BALANCE_EXEC	\
+				| SD_BALANCE_WAKE	\
 				| SD_WAKE_AFFINE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
@@ -91,8 +92,8 @@ void build_cpu_to_node_map(void);
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_FORK	\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_BALANCE_WAKE	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 64,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/mips/include/asm/mach-ip27/topology.h b/arch/mips/include/asm/mach-ip27/topology.h
index 0754723..d833239 100644
--- a/arch/mips/include/asm/mach-ip27/topology.h
+++ b/arch/mips/include/asm/mach-ip27/topology.h
@@ -48,7 +48,7 @@ extern unsigned char __node_distances[MAX_COMPACT_NODES][MAX_COMPACT_NODES];
 	.cache_nice_tries	= 1,			\
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
-				| SD_WAKE_BALANCE,	\
+				| SD_BALANCE_WAKE,	\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
index 054a16d..c634331 100644
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -62,9 +62,8 @@ static inline int pcibus_to_node(struct pci_bus *bus)
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_EXEC	\
 				| SD_BALANCE_NEWIDLE	\
-				| SD_WAKE_IDLE		\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_BALANCE_WAKE	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/sh/include/asm/topology.h b/arch/sh/include/asm/topology.h
index b69ee85..dc1531e 100644
--- a/arch/sh/include/asm/topology.h
+++ b/arch/sh/include/asm/topology.h
@@ -21,8 +21,8 @@
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_BALANCE_WAKE	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 	.nr_balance_failed	= 0,			\
diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index e5ea8d3..1d091ab 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -57,8 +57,8 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 	.flags			= SD_LOAD_BALANCE	\
 				| SD_BALANCE_FORK	\
 				| SD_BALANCE_EXEC	\
-				| SD_SERIALIZE		\
-				| SD_WAKE_BALANCE,	\
+				| SD_BALANCE_WAKE	\
+				| SD_SERIALIZE,		\
 	.last_balance		= jiffies,		\
 	.balance_interval	= 1,			\
 }
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 26d06e0..966d58d 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -145,14 +145,12 @@ extern unsigned long node_remap_size[];
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
-				| 1*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3b0ca66..c30bf3d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -803,16 +803,15 @@ enum cpu_idle_type {
 #define SD_BALANCE_NEWIDLE	0x0002	/* Balance when about to become idle */
 #define SD_BALANCE_EXEC		0x0004	/* Balance on exec */
 #define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
-#define SD_WAKE_IDLE		0x0010	/* Wake to idle CPU on task wakeup */
+#define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
-#define SD_WAKE_BALANCE		0x0040	/* Perform balancing at task wakeup */
+
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
 #define SD_POWERSAVINGS_BALANCE	0x0100	/* Balance for power savings */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
-#define SD_WAKE_IDLE_FAR	0x0800	/* Gain latency sacrificing cache hit */
+
 #define SD_PREFER_SIBLING	0x1000	/* Prefer to place tasks in a sibling domain */
-#define SD_BALANCE_WAKE		0x2000  /* Balance on wakeup */
 
 enum powersavings_balance_level {
 	POWERSAVINGS_BALANCE_NONE = 0,  /* No power saving load balance */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 85e8cf7..6a8cd15 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -95,14 +95,12 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
 				| 1*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
@@ -129,13 +127,11 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_WAKE_IDLE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
 				| sd_balance_for_mc_power()		\
 				| sd_power_saving_flags()		\
 				,					\
@@ -163,13 +159,11 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 1*SD_BALANCE_EXEC			\
 				| 1*SD_BALANCE_FORK			\
-				| 1*SD_WAKE_IDLE			\
+				| 1*SD_BALANCE_WAKE			\
 				| 0*SD_WAKE_AFFINE			\
-				| 1*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
-				| 0*SD_WAKE_IDLE_FAR			\
 				| sd_balance_for_package_power()	\
 				| sd_power_saving_flags()		\
 				,					\
@@ -191,14 +185,12 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_NEWIDLE			\
 				| 0*SD_BALANCE_EXEC			\
 				| 0*SD_BALANCE_FORK			\
-				| 0*SD_WAKE_IDLE			\
+				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_WAKE_BALANCE			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_POWERSAVINGS_BALANCE		\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 1*SD_SERIALIZE			\
-				| 1*SD_WAKE_IDLE_FAR			\
 				| 0*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
diff --git a/kernel/sched.c b/kernel/sched.c
index fc6fda8..6c819f3 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -512,14 +512,6 @@ struct root_domain {
 #ifdef CONFIG_SMP
 	struct cpupri cpupri;
 #endif
-#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
-	/*
-	 * Preferred wake up cpu nominated by sched_mc balance that will be
-	 * used when most cpus are idle in the system indicating overall very
-	 * low system utilisation. Triggered at POWERSAVINGS_BALANCE_WAKEUP(2)
-	 */
-	unsigned int sched_mc_preferred_wakeup_cpu;
-#endif
 };
 
 /*
@@ -2315,22 +2307,6 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
 	if (!sched_feat(SYNC_WAKEUPS))
 		sync = 0;
 
-#ifdef CONFIG_SMP
-	if (sched_feat(LB_WAKEUP_UPDATE) && !root_task_group_empty()) {
-		struct sched_domain *sd;
-
-		this_cpu = raw_smp_processor_id();
-		cpu = task_cpu(p);
-
-		for_each_domain(this_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				update_shares(sd);
-				break;
-			}
-		}
-	}
-#endif
-
 	this_cpu = get_cpu();
 
 	smp_wmb();
@@ -3533,11 +3509,6 @@ static inline int check_power_save_busiest_group(struct sd_lb_stats *sds,
 	*imbalance = sds->min_load_per_task;
 	sds->busiest = sds->group_min;
 
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP) {
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu =
-			group_first_cpu(sds->group_leader);
-	}
-
 	return 1;
 
 }
@@ -7850,9 +7821,7 @@ static int sd_degenerate(struct sched_domain *sd)
 	}
 
 	/* Following flags don't use groups */
-	if (sd->flags & (SD_WAKE_IDLE |
-			 SD_WAKE_AFFINE |
-			 SD_WAKE_BALANCE))
+	if (sd->flags & (SD_WAKE_AFFINE))
 		return 0;
 
 	return 1;
@@ -7869,10 +7838,6 @@ sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
 	if (!cpumask_equal(sched_domain_span(sd), sched_domain_span(parent)))
 		return 0;
 
-	/* Does parent contain flags not in child? */
-	/* WAKE_BALANCE is a subset of WAKE_AFFINE */
-	if (cflags & SD_WAKE_AFFINE)
-		pflags &= ~SD_WAKE_BALANCE;
 	/* Flags needing groups don't count if only 1 group in parent */
 	if (parent->groups == parent->groups->next) {
 		pflags &= ~(SD_LOAD_BALANCE |
@@ -8558,10 +8523,10 @@ static void set_domain_attribute(struct sched_domain *sd,
 		request = attr->relax_domain_level;
 	if (request < sd->level) {
 		/* turn off idle balance on this domain */
-		sd->flags &= ~(SD_WAKE_IDLE|SD_BALANCE_NEWIDLE);
+		sd->flags &= ~(SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	} else {
 		/* turn on idle balance on this domain */
-		sd->flags |= (SD_WAKE_IDLE_FAR|SD_BALANCE_NEWIDLE);
+		sd->flags |= (SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	}
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f2eb5b9..09d19f7 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1062,83 +1062,6 @@ static void yield_task_fair(struct rq *rq)
 	se->vruntime = rightmost->vruntime + 1;
 }
 
-/*
- * wake_idle() will wake a task on an idle cpu if task->cpu is
- * not idle and an idle cpu is available.  The span of cpus to
- * search starts with cpus closest then further out as needed,
- * so we always favor a closer, idle cpu.
- * Domains may include CPUs that are not usable for migration,
- * hence we need to mask them out (rq->rd->online)
- *
- * Returns the CPU we should wake onto.
- */
-#if defined(ARCH_HAS_SCHED_WAKE_IDLE)
-
-#define cpu_rd_active(cpu, rq) cpumask_test_cpu(cpu, rq->rd->online)
-
-static int wake_idle(int cpu, struct task_struct *p)
-{
-	struct sched_domain *sd;
-	int i;
-	unsigned int chosen_wakeup_cpu;
-	int this_cpu;
-	struct rq *task_rq = task_rq(p);
-
-	/*
-	 * At POWERSAVINGS_BALANCE_WAKEUP level, if both this_cpu and prev_cpu
-	 * are idle and this is not a kernel thread and this task's affinity
-	 * allows it to be moved to preferred cpu, then just move!
-	 */
-
-	this_cpu = smp_processor_id();
-	chosen_wakeup_cpu =
-		cpu_rq(this_cpu)->rd->sched_mc_preferred_wakeup_cpu;
-
-	if (sched_mc_power_savings >= POWERSAVINGS_BALANCE_WAKEUP &&
-		idle_cpu(cpu) && idle_cpu(this_cpu) &&
-		p->mm && !(p->flags & PF_KTHREAD) &&
-		cpu_isset(chosen_wakeup_cpu, p->cpus_allowed))
-		return chosen_wakeup_cpu;
-
-	/*
-	 * If it is idle, then it is the best cpu to run this task.
-	 *
-	 * This cpu is also the best, if it has more than one task already.
-	 * Siblings must be also busy(in most cases) as they didn't already
-	 * pickup the extra load from this cpu and hence we need not check
-	 * sibling runqueue info. This will avoid the checks and cache miss
-	 * penalities associated with that.
-	 */
-	if (idle_cpu(cpu) || cpu_rq(cpu)->cfs.nr_running > 1)
-		return cpu;
-
-	for_each_domain(cpu, sd) {
-		if ((sd->flags & SD_WAKE_IDLE)
-		    || ((sd->flags & SD_WAKE_IDLE_FAR)
-			&& !task_hot(p, task_rq->clock, sd))) {
-			for_each_cpu_and(i, sched_domain_span(sd),
-					 &p->cpus_allowed) {
-				if (cpu_rd_active(i, task_rq) && idle_cpu(i)) {
-					if (i != task_cpu(p)) {
-						schedstat_inc(p,
-						       se.nr_wakeups_idle);
-					}
-					return i;
-				}
-			}
-		} else {
-			break;
-		}
-	}
-	return cpu;
-}
-#else /* !ARCH_HAS_SCHED_WAKE_IDLE*/
-static inline int wake_idle(int cpu, struct task_struct *p)
-{
-	return cpu;
-}
-#endif
-
 #ifdef CONFIG_SMP
 
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -1225,21 +1148,22 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 
 #endif
 
-static int
-wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
-	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
-	    int idx, unsigned long load, unsigned long this_load,
-	    unsigned int imbalance)
+static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 {
-	struct task_struct *curr = this_rq->curr;
-	struct task_group *tg;
-	unsigned long tl = this_load;
+	struct task_struct *curr = current;
+	unsigned long this_load, load;
+	int idx, this_cpu, prev_cpu;
 	unsigned long tl_per_task;
+	unsigned int imbalance;
+	struct task_group *tg;
 	unsigned long weight;
 	int balanced;
 
-	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
-		return 0;
+	idx	  = sd->wake_idx;
+	this_cpu  = smp_processor_id();
+	prev_cpu  = task_cpu(p);
+	load	  = source_load(prev_cpu, idx);
+	this_load = target_load(this_cpu, idx);
 
 	if (sync && (curr->se.avg_overlap > sysctl_sched_migration_cost ||
 			p->se.avg_overlap > sysctl_sched_migration_cost))
@@ -1254,24 +1178,26 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 		tg = task_group(current);
 		weight = current->se.load.weight;
 
-		tl += effective_load(tg, this_cpu, -weight, -weight);
+		this_load += effective_load(tg, this_cpu, -weight, -weight);
 		load += effective_load(tg, prev_cpu, 0, -weight);
 	}
 
 	tg = task_group(p);
 	weight = p->se.load.weight;
 
+	imbalance = 100 + (sd->imbalance_pct - 100) / 2;
+
 	/*
 	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
-	 * due to the sync cause above having dropped tl to 0, we'll always have
-	 * an imbalance, but there's really nothing you can do about that, so
-	 * that's good too.
+	 * due to the sync cause above having dropped this_load to 0, we'll
+	 * always have an imbalance, but there's really nothing you can do
+	 * about that, so that's good too.
 	 *
 	 * Otherwise check if either cpus are near enough in load to allow this
 	 * task to be woken on this_cpu.
 	 */
-	balanced = !tl ||
-		100*(tl + effective_load(tg, this_cpu, weight, weight)) <=
+	balanced = !this_load ||
+		100*(this_load + effective_load(tg, this_cpu, weight, weight)) <=
 		imbalance*(load + effective_load(tg, prev_cpu, 0, weight));
 
 	/*
@@ -1285,14 +1211,15 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if (balanced || (tl <= load && tl + target_load(prev_cpu, idx) <=
-			tl_per_task)) {
+	if (balanced ||
+	    (this_load <= load &&
+	     this_load + target_load(prev_cpu, idx) <= tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
 		 * there is no bad imbalance.
 		 */
-		schedstat_inc(this_sd, ttwu_move_affine);
+		schedstat_inc(sd, ttwu_move_affine);
 		schedstat_inc(p, se.nr_wakeups_affine);
 
 		return 1;
@@ -1300,72 +1227,6 @@ wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	return 0;
 }
 
-static int sched_balance_self(int cpu, int flag);
-
-static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
-{
-	struct sched_domain *sd, *this_sd = NULL;
-	int prev_cpu, this_cpu, new_cpu;
-	unsigned long load, this_load;
-	struct rq *this_rq;
-	unsigned int imbalance;
-	int idx;
-
-	prev_cpu	= task_cpu(p);
-	this_cpu	= smp_processor_id();
-	this_rq		= cpu_rq(this_cpu);
-	new_cpu		= prev_cpu;
-
-	if (flag != SD_BALANCE_WAKE)
-		return sched_balance_self(this_cpu, flag);
-
-	/*
-	 * 'this_sd' is the first domain that both
-	 * this_cpu and prev_cpu are present in:
-	 */
-	for_each_domain(this_cpu, sd) {
-		if (cpumask_test_cpu(prev_cpu, sched_domain_span(sd))) {
-			this_sd = sd;
-			break;
-		}
-	}
-
-	if (unlikely(!cpumask_test_cpu(this_cpu, &p->cpus_allowed)))
-		goto out;
-
-	/*
-	 * Check for affine wakeup and passive balancing possibilities.
-	 */
-	if (!this_sd)
-		goto out;
-
-	idx = this_sd->wake_idx;
-
-	imbalance = 100 + (this_sd->imbalance_pct - 100) / 2;
-
-	load = source_load(prev_cpu, idx);
-	this_load = target_load(this_cpu, idx);
-
-	if (wake_affine(this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
-				     load, this_load, imbalance))
-		return this_cpu;
-
-	/*
-	 * Start passive balancing when half the imbalance_pct
-	 * limit is reached.
-	 */
-	if (this_sd->flags & SD_WAKE_BALANCE) {
-		if (imbalance*this_load <= 100*load) {
-			schedstat_inc(this_sd, ttwu_move_balance);
-			schedstat_inc(p, se.nr_wakeups_passive);
-			return this_cpu;
-		}
-	}
-
-out:
-	return wake_idle(new_cpu, p);
-}
-
 /*
  * find_idlest_group finds and returns the least busy CPU group within the
  * domain.
@@ -1455,10 +1316,20 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
  *
  * preempt must be disabled.
  */
-static int sched_balance_self(int cpu, int flag)
+static int select_task_rq_fair(struct task_struct *p, int flag, int sync)
 {
 	struct task_struct *t = current;
 	struct sched_domain *tmp, *sd = NULL;
+	int cpu = smp_processor_id();
+	int prev_cpu = task_cpu(p);
+	int new_cpu = cpu;
+	int want_affine = 0;
+
+	if (flag & SD_BALANCE_WAKE) {
+		if (sched_feat(AFFINE_WAKEUPS))
+			want_affine = 1;
+		new_cpu = prev_cpu;
+	}
 
 	for_each_domain(cpu, tmp) {
 		/*
@@ -1466,16 +1337,38 @@ static int sched_balance_self(int cpu, int flag)
 		 */
 		if (tmp->flags & SD_POWERSAVINGS_BALANCE)
 			break;
-		if (tmp->flags & flag)
-			sd = tmp;
-	}
 
-	if (sd)
-		update_shares(sd);
+		switch (flag) {
+		case SD_BALANCE_WAKE:
+			if (!sched_feat(LB_WAKEUP_UPDATE))
+				break;
+		case SD_BALANCE_FORK:
+		case SD_BALANCE_EXEC:
+			if (root_task_group_empty())
+				break;
+			update_shares(tmp);
+		default:
+			break;
+		}
+
+		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
+		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
+
+			if (wake_affine(tmp, p, sync))
+				return cpu;
+
+			want_affine = 0;
+		}
+
+		if (!(tmp->flags & flag))
+			continue;
+
+		sd = tmp;
+	}
 
 	while (sd) {
 		struct sched_group *group;
-		int new_cpu, weight;
+		int weight;
 
 		if (!(sd->flags & flag)) {
 			sd = sd->child;
@@ -1508,7 +1401,7 @@ static int sched_balance_self(int cpu, int flag)
 		/* while loop will break here if sd == NULL */
 	}
 
-	return cpu;
+	return new_cpu;
 }
 #endif /* CONFIG_SMP */
 
