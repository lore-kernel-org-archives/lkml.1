Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYBDVTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYBDVTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755991AbYBDVRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:17:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbYBDVRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:17:12 -0500
Message-Id: <20080204211837.219295000@chello.nl>
References: <20080204210258.118479000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 04 Feb 2008 22:03:02 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: tong.n.li@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/8] sched: rt-group: make rt groups scheduling configurable
Content-Disposition: inline; filename=sched-rt-group-config.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the rt group scheduler compile time configurable. 
Enable it by default for cgroup scheduling.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/cgroup_subsys.h |    2 
 init/Kconfig                  |   23 +++++--
 kernel/sched.c                |  130 +++++++++++++++++++++++++++++++-----------
 kernel/sched_rt.c             |   12 +--
 4 files changed, 120 insertions(+), 47 deletions(-)

Index: linux-2.6/include/linux/cgroup_subsys.h
===================================================================
--- linux-2.6.orig/include/linux/cgroup_subsys.h
+++ linux-2.6/include/linux/cgroup_subsys.h
@@ -25,7 +25,7 @@ SUBSYS(ns)
 
 /* */
 
-#ifdef CONFIG_FAIR_CGROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 SUBSYS(cpu_cgroup)
 #endif
 
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -332,25 +332,36 @@ config CPUSETS
 
 	  Say N if unsure.
 
-config FAIR_GROUP_SCHED
-	bool "Fair group CPU scheduler"
+config GROUP_SCHED
+	bool "Group CPU scheduler"
 	default y
 	help
 	  This feature lets CPU scheduler recognize task groups and control CPU
 	  bandwidth allocation to such task groups.
 
+config FAIR_GROUP_SCHED
+	bool "Group scheduling for SCHED_OTHER"
+	depends on GROUP_SCHED
+	default y
+
+config RT_GROUP_SCHED
+	bool "Group scheduling for SCHED_RR/FIFO"
+	depends on EXPERIMENTAL
+	depends on GROUP_SCHED
+	default n
+
 choice
-	depends on FAIR_GROUP_SCHED
+	depends on GROUP_SCHED
 	prompt "Basis for grouping tasks"
-	default FAIR_USER_SCHED
+	default USER_SCHED
 
-config FAIR_USER_SCHED
+config USER_SCHED
 	bool "user id"
 	help
 	  This option will choose userid as the basis for grouping
 	  tasks, thus providing equal CPU bandwidth to each user.
 
-config FAIR_CGROUP_SCHED
+config CGROUP_SCHED
 	bool "Control groups"
  	depends on CGROUPS
  	help
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -155,7 +155,7 @@ struct rt_prio_array {
 	struct list_head queue[MAX_RT_PRIO];
 };
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_GROUP_SCHED
 
 #include <linux/cgroup.h>
 
@@ -165,19 +165,16 @@ static LIST_HEAD(task_groups);
 
 /* task group related information */
 struct task_group {
-#ifdef CONFIG_FAIR_CGROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 	struct cgroup_subsys_state css;
 #endif
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	/* schedulable entities of this group on each cpu */
 	struct sched_entity **se;
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 
-	struct sched_rt_entity **rt_se;
-	struct rt_rq **rt_rq;
-
-	u64 rt_runtime;
-
 	/*
 	 * shares assigned to a task group governs how much of cpu bandwidth
 	 * is allocated to the group. The more shares a group has, the more is
@@ -213,24 +210,36 @@ struct task_group {
 	 *
 	 */
 	unsigned long shares;
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+	struct sched_rt_entity **rt_se;
+	struct rt_rq **rt_rq;
+
+	u64 rt_runtime;
+#endif
 
 	struct rcu_head rcu;
 	struct list_head list;
 };
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 /* Default task group's sched entity on each cpu */
 static DEFINE_PER_CPU(struct sched_entity, init_sched_entity);
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
 
-static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
-static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
-
 static struct sched_entity *init_sched_entity_p[NR_CPUS];
 static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
+static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
+static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
 
 static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
 static struct rt_rq *init_rt_rq_p[NR_CPUS];
+#endif
 
 /* task_group_mutex serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
@@ -240,6 +249,7 @@ static DEFINE_MUTEX(task_group_mutex);
 /* doms_cur_mutex serializes access to doms_cur[] array */
 static DEFINE_MUTEX(doms_cur_mutex);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
 /* kernel thread that runs rebalance_shares() periodically */
 static struct task_struct *lb_monitor_task;
@@ -247,19 +257,24 @@ static int load_balance_monitor(void *un
 #endif
 
 static void set_se_shares(struct sched_entity *se, unsigned long shares);
+#endif
 
 /* Default task group.
  *	Every task in system belong to this group at bootup.
  */
 struct task_group init_task_group = {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	.se	= init_sched_entity_p,
 	.cfs_rq = init_cfs_rq_p,
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 	.rt_se	= init_sched_rt_entity_p,
 	.rt_rq	= init_rt_rq_p,
+#endif
 };
 
-#ifdef CONFIG_FAIR_USER_SCHED
+#ifdef CONFIG_USER_SCHED
 # define INIT_TASK_GROUP_LOAD	(2*NICE_0_LOAD)
 #else
 # define INIT_TASK_GROUP_LOAD	NICE_0_LOAD
@@ -274,9 +289,9 @@ static inline struct task_group *task_gr
 {
 	struct task_group *tg;
 
-#ifdef CONFIG_FAIR_USER_SCHED
+#ifdef CONFIG_USER_SCHED
 	tg = p->user->tg;
-#elif defined(CONFIG_FAIR_CGROUP_SCHED)
+#elif defined(CONFIG_CGROUP_SCHED)
 	tg = container_of(task_subsys_state(p, cpu_cgroup_subsys_id),
 				struct task_group, css);
 #else
@@ -288,11 +303,15 @@ static inline struct task_group *task_gr
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
 static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
 	p->rt.parent = task_group(p)->rt_se[cpu];
+#endif
 }
 
 static inline void lock_task_group_list(void)
@@ -323,7 +342,7 @@ static inline void unlock_task_group_lis
 static inline void lock_doms_cur(void) { }
 static inline void unlock_doms_cur(void) { }
 
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+#endif	/* CONFIG_GROUP_SCHED */
 
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
@@ -363,7 +382,7 @@ struct cfs_rq {
 struct rt_rq {
 	struct rt_prio_array active;
 	unsigned long rt_nr_running;
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	int highest_prio; /* highest queued rt task prio */
 #endif
 #ifdef CONFIG_SMP
@@ -373,7 +392,7 @@ struct rt_rq {
 	int rt_throttled;
 	u64 rt_time;
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 	unsigned long rt_nr_boosted;
 
 	struct rq *rq;
@@ -449,6 +468,8 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 	struct list_head leaf_rt_rq_list;
 #endif
 
@@ -7108,7 +7129,7 @@ static void init_rt_rq(struct rt_rq *rt_
 	/* delimiter for bitsearch: */
 	__set_bit(MAX_RT_PRIO, array->bitmap);
 
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	rt_rq->highest_prio = MAX_RT_PRIO;
 #endif
 #ifdef CONFIG_SMP
@@ -7119,7 +7140,7 @@ static void init_rt_rq(struct rt_rq *rt_
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 	rt_rq->rt_nr_boosted = 0;
 	rt_rq->rq = rq;
 #endif
@@ -7143,7 +7164,9 @@ static void init_tg_cfs_entry(struct rq 
 	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
 	se->parent = NULL;
 }
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 static void init_tg_rt_entry(struct rq *rq, struct task_group *tg,
 		struct rt_rq *rt_rq, struct sched_rt_entity *rt_se,
 		int cpu, int add)
@@ -7172,7 +7195,7 @@ void __init sched_init(void)
 	init_defrootdomain();
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_GROUP_SCHED
 	list_add(&init_task_group.list, &task_groups);
 #endif
 
@@ -7193,6 +7216,8 @@ void __init sched_init(void)
 				&per_cpu(init_cfs_rq, i),
 				&per_cpu(init_sched_entity, i), i, 1);
 
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 		init_task_group.rt_runtime =
 			sysctl_sched_rt_runtime * NSEC_PER_USEC;
 		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
@@ -7385,9 +7410,9 @@ void set_curr_task(int cpu, struct task_
 
 #endif
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_GROUP_SCHED
 
-#ifdef CONFIG_SMP
+#if defined CONFIG_FAIR_GROUP_SCHED && defined CONFIG_SMP
 /*
  * distribute shares of all task groups among their schedulable entities,
  * to reflect load distribution across cpus.
@@ -7543,20 +7568,28 @@ static void free_sched_group(struct task
 	int i;
 
 	for_each_possible_cpu(i) {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 		if (tg->cfs_rq)
 			kfree(tg->cfs_rq[i]);
 		if (tg->se)
 			kfree(tg->se[i]);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 		if (tg->rt_rq)
 			kfree(tg->rt_rq[i]);
 		if (tg->rt_se)
 			kfree(tg->rt_se[i]);
+#endif
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	kfree(tg->cfs_rq);
 	kfree(tg->se);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 	kfree(tg->rt_rq);
 	kfree(tg->rt_se);
+#endif
 	kfree(tg);
 }
 
@@ -7564,10 +7597,14 @@ static void free_sched_group(struct task
 struct task_group *sched_create_group(void)
 {
 	struct task_group *tg;
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 	struct rt_rq *rt_rq;
 	struct sched_rt_entity *rt_se;
+#endif
 	struct rq *rq;
 	int i;
 
@@ -7575,12 +7612,18 @@ struct task_group *sched_create_group(vo
 	if (!tg)
 		return ERR_PTR(-ENOMEM);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	tg->cfs_rq = kzalloc(sizeof(cfs_rq) * NR_CPUS, GFP_KERNEL);
 	if (!tg->cfs_rq)
 		goto err;
 	tg->se = kzalloc(sizeof(se) * NR_CPUS, GFP_KERNEL);
 	if (!tg->se)
 		goto err;
+
+	tg->shares = NICE_0_LOAD;
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
 	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
 	if (!tg->rt_rq)
 		goto err;
@@ -7588,12 +7631,13 @@ struct task_group *sched_create_group(vo
 	if (!tg->rt_se)
 		goto err;
 
-	tg->shares = NICE_0_LOAD;
 	tg->rt_runtime = 0;
+#endif
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 		cfs_rq = kmalloc_node(sizeof(struct cfs_rq),
 				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!cfs_rq)
@@ -7604,6 +7648,10 @@ struct task_group *sched_create_group(vo
 		if (!se)
 			goto err;
 
+		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
+#endif
+
+#ifdef CONFIG_RT_GROUP_SCHED
 		rt_rq = kmalloc_node(sizeof(struct rt_rq),
 				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!rt_rq)
@@ -7614,17 +7662,21 @@ struct task_group *sched_create_group(vo
 		if (!rt_se)
 			goto err;
 
-		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
 		init_tg_rt_entry(rq, tg, rt_rq, rt_se, i, 0);
+#endif
 	}
 
 	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
+#ifdef CONFIG_FAIR_GROUP_SCHED
 		cfs_rq = tg->cfs_rq[i];
 		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 		rt_rq = tg->rt_rq[i];
 		list_add_rcu(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
+#endif
 	}
 	list_add_rcu(&tg->list, &task_groups);
 	unlock_task_group_list();
@@ -7646,22 +7698,20 @@ static void free_sched_group_rcu(struct 
 /* Destroy runqueue etc associated with a task group */
 void sched_destroy_group(struct task_group *tg)
 {
-	struct cfs_rq *cfs_rq = NULL;
-	struct rt_rq *rt_rq = NULL;
 	int i;
 
 	lock_task_group_list();
 	for_each_possible_cpu(i) {
-		cfs_rq = tg->cfs_rq[i];
-		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
-		rt_rq = tg->rt_rq[i];
-		list_del_rcu(&rt_rq->leaf_rt_rq_list);
+#ifdef CONFIG_FAIR_GROUP_SCHED
+		list_del_rcu(&tg->cfs_rq[i]->leaf_cfs_rq_list);
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
+		list_del_rcu(&tg->rt_rq[i]->leaf_rt_rq_list);
+#endif
 	}
 	list_del_rcu(&tg->list);
 	unlock_task_group_list();
 
-	BUG_ON(!cfs_rq);
-
 	/* wait for possible concurrent references to cfs_rqs complete */
 	call_rcu(&tg->rcu, free_sched_group_rcu);
 }
@@ -7701,6 +7751,7 @@ void sched_move_task(struct task_struct 
 	task_rq_unlock(rq, &flags);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 /* rq->lock to be locked by caller */
 static void set_se_shares(struct sched_entity *se, unsigned long shares)
 {
@@ -7781,7 +7832,9 @@ unsigned long sched_group_shares(struct 
 {
 	return tg->shares;
 }
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 /*
  * Ensure that the real time constraints are schedulable.
  */
@@ -7853,9 +7906,10 @@ long sched_group_rt_runtime(struct task_
 	do_div(rt_runtime_us, NSEC_PER_USEC);
 	return rt_runtime_us;
 }
-#endif	/* CONFIG_FAIR_GROUP_SCHED */
+#endif
+#endif	/* CONFIG_GROUP_SCHED */
 
-#ifdef CONFIG_FAIR_CGROUP_SCHED
+#ifdef CONFIG_CGROUP_SCHED
 
 /* return corresponding task_group object of a cgroup */
 static inline struct task_group *cgroup_tg(struct cgroup *cgrp)
@@ -7915,6 +7969,7 @@ cpu_cgroup_attach(struct cgroup_subsys *
 	sched_move_task(tsk);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static int cpu_shares_write_uint(struct cgroup *cgrp, struct cftype *cftype,
 				u64 shareval)
 {
@@ -7927,7 +7982,9 @@ static u64 cpu_shares_read_uint(struct c
 
 	return (u64) tg->shares;
 }
+#endif
 
+#ifdef CONFIG_RT_GROUP_SCHED
 static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
 				struct file *file,
 				const char __user *userbuf,
@@ -7972,18 +8029,23 @@ static ssize_t cpu_rt_runtime_read(struc
 
 	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
+#endif
 
 static struct cftype cpu_files[] = {
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	{
 		.name = "shares",
 		.read_uint = cpu_shares_read_uint,
 		.write_uint = cpu_shares_write_uint,
 	},
+#endif
+#ifdef CONFIG_RT_GROUP_SCHED
 	{
 		.name = "rt_runtime_us",
 		.read = cpu_rt_runtime_read,
 		.write = cpu_rt_runtime_write,
 	},
+#endif
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
@@ -8002,7 +8064,7 @@ struct cgroup_subsys cpu_cgroup_subsys =
 	.early_init	= 1,
 };
 
-#endif	/* CONFIG_FAIR_CGROUP_SCHED */
+#endif	/* CONFIG_CGROUP_SCHED */
 
 #ifdef CONFIG_CGROUP_CPUACCT
 
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -55,7 +55,7 @@ static inline int on_rt_rq(struct sched_
 	return !list_empty(&rt_se->run_list);
 }
 
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 
 static inline u64 sched_rt_runtime(struct rt_rq *rt_rq)
 {
@@ -177,7 +177,7 @@ static inline int rt_rq_throttled(struct
 
 static inline int rt_se_prio(struct sched_rt_entity *rt_se)
 {
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 	struct rt_rq *rt_rq = group_rt_rq(rt_se);
 
 	if (rt_rq)
@@ -269,7 +269,7 @@ void inc_rt_tasks(struct sched_rt_entity
 {
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	rt_rq->rt_nr_running++;
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_se_prio(rt_se) < rt_rq->highest_prio)
 		rt_rq->highest_prio = rt_se_prio(rt_se);
 #endif
@@ -281,7 +281,7 @@ void inc_rt_tasks(struct sched_rt_entity
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 	if (rt_se_boosted(rt_se))
 		rt_rq->rt_nr_boosted++;
 #endif
@@ -293,7 +293,7 @@ void dec_rt_tasks(struct sched_rt_entity
 	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
 	WARN_ON(!rt_rq->rt_nr_running);
 	rt_rq->rt_nr_running--;
-#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	if (rt_rq->rt_nr_running) {
 		struct rt_prio_array *array;
 
@@ -315,7 +315,7 @@ void dec_rt_tasks(struct sched_rt_entity
 
 	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif /* CONFIG_SMP */
-#ifdef CONFIG_FAIR_GROUP_SCHED
+#ifdef CONFIG_RT_GROUP_SCHED
 	if (rt_se_boosted(rt_se))
 		rt_rq->rt_nr_boosted--;
 

--

