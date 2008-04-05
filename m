Return-Path: <linux-kernel-owner+w=401wt.eu-S1751838AbYDEBLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838AbYDEBLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 21:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbYDEBLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 21:11:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56561 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579AbYDEBLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 21:11:03 -0400
Message-Id: <20080405011101.534396000@polaris-admin.engr.sgi.com>
References: <20080405011100.720014000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 04 Apr 2008 18:11:04 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 04/12] sched: Remove fixed NR_CPUS sized arrays in kernel_sched_c v2
Content-Disposition: inline; filename=nr_cpus-in-kernel_sched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Change fixed size arrays to per_cpu variables or dynamically allocated
   arrays in sched_init() and sched_init_smp().

     (1) static struct sched_entity *init_sched_entity_p[NR_CPUS];
     (1) static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
     (1) static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
     (1) static struct rt_rq *init_rt_rq_p[NR_CPUS];
	 static struct sched_group **sched_group_nodes_bycpu[NR_CPUS];

     (1) - these arrays are allocated via alloc_bootmem_low()

 * Change sched_domain_debug_one() to use cpulist_scnprintf instead of
   cpumask_scnprintf.  This reduces the output buffer required and improves
   readability when large NR_CPU count machines arrive.

 * In sched_create_group() we allocate new arrays based on nr_cpu_ids.

Based on:
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
    +   x86/latest          .../x86/linux-2.6-x86.git
    +   sched-devel/latest  .../mingo/linux-2.6-sched-devel.git

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Travis <travis@sgi.com>
---
v2: Removed reference to cpumask_scnprintf_len().
---
 kernel/sched.c |   80 +++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 28 deletions(-)

--- linux-2.6.x86.orig/kernel/sched.c
+++ linux-2.6.x86/kernel/sched.c
@@ -68,6 +68,7 @@
 #include <linux/hrtimer.h>
 #include <linux/ftrace.h>
 #include <linux/tick.h>
+#include <linux/bootmem.h>
 
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
@@ -278,17 +279,11 @@ struct task_group {
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
-
-static struct sched_entity *init_sched_entity_p[NR_CPUS];
-static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
 #endif
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
-
-static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
-static struct rt_rq *init_rt_rq_p[NR_CPUS];
 #endif
 
 /* task_group_lock serializes add/remove of task groups and also changes to
@@ -312,17 +307,7 @@ static int init_task_group_load = INIT_T
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
-struct task_group init_task_group = {
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	.se	= init_sched_entity_p,
-	.cfs_rq = init_cfs_rq_p,
-#endif
-
-#ifdef CONFIG_RT_GROUP_SCHED
-	.rt_se	= init_sched_rt_entity_p,
-	.rt_rq	= init_rt_rq_p,
-#endif
-};
+struct task_group init_task_group;
 
 /* return group to which a task belongs */
 static inline struct task_group *task_group(struct task_struct *p)
@@ -3754,7 +3739,7 @@ static inline void trigger_load_balance(
 			 */
 			int ilb = first_cpu(nohz.cpu_mask);
 
-			if (ilb != NR_CPUS)
+			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
 		}
 	}
@@ -5729,11 +5714,11 @@ static void move_task_off_dead_cpu(int d
 		dest_cpu = any_online_cpu(mask);
 
 		/* On any allowed CPU? */
-		if (dest_cpu == NR_CPUS)
+		if (dest_cpu >= nr_cpu_ids)
 			dest_cpu = any_online_cpu(p->cpus_allowed);
 
 		/* No more Mr. Nice Guy. */
-		if (dest_cpu == NR_CPUS) {
+		if (dest_cpu >= nr_cpu_ids) {
 			cpumask_t cpus_allowed = cpuset_cpus_allowed_locked(p);
 			/*
 			 * Try to stay on the same cpuset, where the
@@ -6188,9 +6173,9 @@ static int sched_domain_debug_one(struct
 {
 	struct sched_group *group = sd->groups;
 	cpumask_t groupmask;
-	char str[NR_CPUS];
+	char str[256];
 
-	cpumask_scnprintf(str, NR_CPUS, sd->span);
+	cpulist_scnprintf(str, sizeof(str), sd->span);
 	cpus_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
@@ -6243,7 +6228,7 @@ static int sched_domain_debug_one(struct
 
 		cpus_or(groupmask, groupmask, group->cpumask);
 
-		cpumask_scnprintf(str, NR_CPUS, group->cpumask);
+		cpulist_scnprintf(str, sizeof(str), group->cpumask);
 		printk(KERN_CONT " %s", str);
 
 		group = group->next;
@@ -6637,7 +6622,7 @@ cpu_to_phys_group(int cpu, const cpumask
  * gets dynamically allocated.
  */
 static DEFINE_PER_CPU(struct sched_domain, node_domains);
-static struct sched_group **sched_group_nodes_bycpu[NR_CPUS];
+static struct sched_group ***sched_group_nodes_bycpu;
 
 static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
 static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
@@ -7280,6 +7265,11 @@ void __init sched_init_smp(void)
 {
 	cpumask_t non_isolated_cpus;
 
+#if defined(CONFIG_NUMA)
+	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
+								GFP_KERNEL);
+	BUG_ON(sched_group_nodes_bycpu == NULL);
+#endif
 	get_online_cpus();
 	arch_init_sched_domains(&cpu_online_map);
 	non_isolated_cpus = cpu_possible_map;
@@ -7297,6 +7287,11 @@ void __init sched_init_smp(void)
 #else
 void __init sched_init_smp(void)
 {
+#if defined(CONFIG_NUMA)
+	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
+								GFP_KERNEL);
+	BUG_ON(sched_group_nodes_bycpu == NULL);
+#endif
 	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */
@@ -7393,6 +7388,35 @@ static void init_tg_rt_entry(struct rq *
 void __init sched_init(void)
 {
 	int i, j;
+	unsigned long alloc_size = 0, ptr;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+	alloc_size += 2 * nr_cpu_ids * sizeof(void **);
+#endif
+	/*
+	 * As sched_init() is called before page_alloc is setup,
+	 * we use alloc_bootmem().
+	 */
+	if (alloc_size) {
+		ptr = (unsigned long)alloc_bootmem_low(alloc_size);
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		init_task_group.se = (struct sched_entity **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+
+		init_task_group.cfs_rq = (struct cfs_rq **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+		init_task_group.rt_se = (struct sched_rt_entity **)ptr;
+		ptr += nr_cpu_ids * sizeof(void **);
+
+		init_task_group.rt_rq = (struct rt_rq **)ptr;
+#endif
+	}
 
 #ifdef CONFIG_SMP
 	init_defrootdomain();
@@ -7643,10 +7667,10 @@ static int alloc_fair_sched_group(struct
 	struct rq *rq;
 	int i;
 
-	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * NR_CPUS, GFP_KERNEL);
+	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->cfs_rq)
 		goto err;
-	tg->se = kzalloc(sizeof(se) * NR_CPUS, GFP_KERNEL);
+	tg->se = kzalloc(sizeof(se) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->se)
 		goto err;
 
@@ -7728,10 +7752,10 @@ static int alloc_rt_sched_group(struct t
 	struct rq *rq;
 	int i;
 
-	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
+	tg->rt_rq = kzalloc(sizeof(rt_rq) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->rt_rq)
 		goto err;
-	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
+	tg->rt_se = kzalloc(sizeof(rt_se) * nr_cpu_ids, GFP_KERNEL);
 	if (!tg->rt_se)
 		goto err;
 

-- 
