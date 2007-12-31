Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbXLaOn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbXLaOn7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 09:43:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbXLaOnv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 09:43:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbXLaOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 09:43:48 -0500
Subject: Re: [RFC/PATCH 0/3] sched: hrtick and rt group scheduling
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: balbir@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>
In-Reply-To: <4778F3E5.5010208@linux.vnet.ibm.com>
References: <20071231001137.147986000@chello.nl>
	 <4778F3E5.5010208@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Mon, 31 Dec 2007 15:43:29 +0100
Message-Id: <1199112209.31975.11.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-31 at 19:21 +0530, Balbir Singh wrote:
> Peter Zijlstra wrote:
> > I spend xmas implementing group scheduling for the realtime scheduling classes.
> > Its a tad raw, but seems to work for the trivial test cases I threw at it.
> > 
> 
> Excellent, will test & review and get back.

replacement patch for 3/3

fixes one crash bug in smp load balancing
simplifies the throttling
ensures \Sum tg.rt_ratio <= syctl_sched_rt_ratio


Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -963,6 +963,15 @@ struct sched_rt_entity {
 	struct list_head run_list;
 	unsigned int time_slice;
 	unsigned long timeout;
+	int nr_cpus_allowed;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct sched_rt_entity	*parent;
+	/* rq on which this entity is (to be) queued: */
+	struct rt_rq		*rt_rq;
+	/* rq "owned" by this entity/group: */
+	struct rt_rq		*my_q;
+#endif
 };
 
 struct task_struct {
@@ -1007,7 +1016,6 @@ struct task_struct {
 
 	unsigned int policy;
 	cpumask_t cpus_allowed;
-	int nr_cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -161,6 +161,8 @@ struct rt_prio_array {
 
 struct cfs_rq;
 
+static LIST_HEAD(task_groups);
+
 /* task group related information */
 struct task_group {
 #ifdef CONFIG_FAIR_CGROUP_SCHED
@@ -171,6 +173,11 @@ struct task_group {
 	/* runqueue "owned" by this group on each cpu */
 	struct cfs_rq **cfs_rq;
 
+	struct sched_rt_entity **rt_se;
+	struct rt_rq **rt_rq;
+
+	unsigned int rt_ratio;
+
 	/*
 	 * shares assigned to a task group governs how much of cpu bandwidth
 	 * is allocated to the group. The more shares a group has, the more is
@@ -208,6 +215,7 @@ struct task_group {
 	unsigned long shares;
 
 	struct rcu_head rcu;
+	struct list_head list;
 };
 
 /* Default task group's sched entity on each cpu */
@@ -215,9 +223,15 @@ static DEFINE_PER_CPU(struct sched_entit
 /* Default task group's cfs_rq on each cpu */
 static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
 
+static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
+static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
+
 static struct sched_entity *init_sched_entity_p[NR_CPUS];
 static struct cfs_rq *init_cfs_rq_p[NR_CPUS];
 
+static struct sched_rt_entity *init_sched_rt_entity_p[NR_CPUS];
+static struct rt_rq *init_rt_rq_p[NR_CPUS];
+
 /* task_group_mutex serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
  */
@@ -240,6 +254,9 @@ static void set_se_shares(struct sched_e
 struct task_group init_task_group = {
 	.se	= init_sched_entity_p,
 	.cfs_rq = init_cfs_rq_p,
+
+	.rt_se	= init_sched_rt_entity_p,
+	.rt_rq	= init_rt_rq_p,
 };
 
 #ifdef CONFIG_FAIR_USER_SCHED
@@ -269,10 +286,13 @@ static inline struct task_group *task_gr
 }
 
 /* Change a task's cfs_rq and parent entity if it moves across CPUs/groups */
-static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu)
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu)
 {
 	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
 	p->se.parent = task_group(p)->se[cpu];
+
+	p->rt.rt_rq  = task_group(p)->rt_rq[cpu];
+	p->rt.parent = task_group(p)->rt_se[cpu];
 }
 
 static inline void lock_task_group_list(void)
@@ -297,7 +317,7 @@ static inline void unlock_doms_cur(void)
 
 #else
 
-static inline void set_task_cfs_rq(struct task_struct *p, unsigned int cpu) { }
+static inline void set_task_rq(struct task_struct *p, unsigned int cpu) { }
 static inline void lock_task_group_list(void) { }
 static inline void unlock_task_group_list(void) { }
 static inline void lock_doms_cur(void) { }
@@ -343,13 +363,22 @@ struct cfs_rq {
 struct rt_rq {
 	struct rt_prio_array active;
 	unsigned long rt_nr_running;
+#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+	int highest_prio; /* highest queued rt task prio */
+#endif
 #ifdef CONFIG_SMP
 	unsigned long rt_nr_migratory;
-	int highest_prio; /* highest queued rt task prio */
 	int overloaded;
 #endif
+	int rt_throttled;
 	u64 rt_time;
-	u64 rt_throttled;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rq *rq;
+	struct list_head leaf_rt_rq_list;
+	struct task_group *tg;
+	struct sched_rt_entity *rt_se;
+#endif
 };
 
 #ifdef CONFIG_SMP
@@ -411,12 +440,14 @@ struct rq {
 	u64 nr_switches;
 
 	struct cfs_rq cfs;
+	struct rt_rq rt;
+	u64 rt_period_expire;
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
+	struct list_head leaf_rt_rq_list;
 #endif
-	struct rt_rq rt;
-	u64 rt_period_expire;
 
 	/*
 	 * This is part of a global counter where only the total sum
@@ -613,9 +644,9 @@ const_debug unsigned int sysctl_sched_rt
 
 /*
  * ratio of time -rt tasks may consume.
- * default: 100%
+ * default: 95%
  */
-const_debug unsigned int sysctl_sched_rt_ratio = SCHED_RT_FRAC;
+const_debug unsigned int sysctl_sched_rt_ratio = 62259;
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -1337,7 +1368,7 @@ unsigned long weighted_cpuload(const int
 
 static inline void __set_task_cpu(struct task_struct *p, unsigned int cpu)
 {
-	set_task_cfs_rq(p, cpu);
+	set_task_rq(p, cpu);
 #ifdef CONFIG_SMP
 	/*
 	 * After ->cpu is set up to a new value, task_rq_lock(p, ...) can be
@@ -5272,7 +5303,7 @@ int set_cpus_allowed(struct task_struct 
 		p->sched_class->set_cpus_allowed(p, &new_mask);
 	else {
 		p->cpus_allowed = new_mask;
-		p->nr_cpus_allowed = cpus_weight(new_mask);
+		p->rt.nr_cpus_allowed = cpus_weight(new_mask);
 	}
 
 	/* Can the task run on the task's current CPU? If so, we're done */
@@ -7067,8 +7098,50 @@ static void init_rt_rq(struct rt_rq *rt_
 
 	rt_rq->rt_time = 0;
 	rt_rq->rt_throttled = 0;
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	rt_rq->rq = rq;
+#endif
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
+static void init_tg_cfs_entry(struct rq *rq, struct task_group *tg,
+		struct cfs_rq *cfs_rq, struct sched_entity *se,
+		int cpu, int add)
+{
+	tg->cfs_rq[cpu] = cfs_rq;
+	init_cfs_rq(cfs_rq, rq);
+	cfs_rq->tg = tg;
+	if (add)
+		list_add(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+
+	tg->se[cpu] = se;
+	se->cfs_rq = &rq->cfs;
+	se->my_q = cfs_rq;
+	se->load.weight = tg->shares;
+	se->load.inv_weight = div64_64(1ULL<<32, se->load.weight);
+	se->parent = NULL;
+}
+
+static void init_tg_rt_entry(struct rq *rq, struct task_group *tg,
+		struct rt_rq *rt_rq, struct sched_rt_entity *rt_se,
+		int cpu, int add)
+{
+	tg->rt_rq[cpu] = rt_rq;
+	init_rt_rq(rt_rq, rq);
+	rt_rq->tg = tg;
+	rt_rq->rt_se = rt_se;
+	if (add)
+		list_add(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
+
+	tg->rt_se[cpu] = rt_se;
+	rt_se->rt_rq = &rq->rt;
+	rt_se->my_q = rt_rq;
+	rt_se->parent = NULL;
+	INIT_LIST_HEAD(&rt_se->run_list);
+}
+#endif
+
 void __init sched_init(void)
 {
 	int highest_cpu = 0;
@@ -7087,30 +7160,22 @@ void __init sched_init(void)
 		rq->nr_running = 0;
 		rq->clock = 1;
 		init_cfs_rq(&rq->cfs, rq);
+		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
-		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
-		{
-			struct cfs_rq *cfs_rq = &per_cpu(init_cfs_rq, i);
-			struct sched_entity *se =
-					 &per_cpu(init_sched_entity, i);
-
-			init_cfs_rq_p[i] = cfs_rq;
-			init_cfs_rq(cfs_rq, rq);
-			cfs_rq->tg = &init_task_group;
-			list_add(&cfs_rq->leaf_cfs_rq_list,
-							 &rq->leaf_cfs_rq_list);
-
-			init_sched_entity_p[i] = se;
-			se->cfs_rq = &rq->cfs;
-			se->my_q = cfs_rq;
-			se->load.weight = init_task_group_load;
-			se->load.inv_weight =
-				 div64_64(1ULL<<32, init_task_group_load);
-			se->parent = NULL;
-		}
 		init_task_group.shares = init_task_group_load;
+		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
+		init_tg_cfs_entry(rq, &init_task_group,
+				&per_cpu(init_cfs_rq, i),
+				&per_cpu(init_sched_entity, i), i, 1);
+
+		init_task_group.rt_ratio = sysctl_sched_rt_ratio; /* XXX */
+		INIT_LIST_HEAD(&rq->leaf_rt_rq_list);
+		init_tg_rt_entry(rq, &init_task_group,
+				&per_cpu(init_rt_rq, i),
+				&per_cpu(init_sched_rt_entity, i), i, 1);
+
+		list_add(&init_task_group.list, &task_groups);
 #endif
-		init_rt_rq(&rq->rt, rq);
 		rq->rt_period_expire = 0;
 
 		for (j = 0; j < CPU_LOAD_IDX_MAX; j++)
@@ -7448,12 +7513,36 @@ static int load_balance_monitor(void *un
 }
 #endif	/* CONFIG_SMP */
 
+static void free_sched_group(struct task_group *tg)
+{
+	int i;
+
+	for_each_possible_cpu(i) {
+		if (tg->cfs_rq)
+			kfree(tg->cfs_rq[i]);
+		if (tg->se)
+			kfree(tg->se[i]);
+		if (tg->rt_rq)
+			kfree(tg->rt_rq[i]);
+		if (tg->rt_se)
+			kfree(tg->rt_se[i]);
+	}
+
+	kfree(tg->cfs_rq);
+	kfree(tg->se);
+	kfree(tg->rt_rq);
+	kfree(tg->rt_se);
+	kfree(tg);
+}
+
 /* allocate runqueue etc for a new task group */
 struct task_group *sched_create_group(void)
 {
 	struct task_group *tg;
 	struct cfs_rq *cfs_rq;
 	struct sched_entity *se;
+	struct rt_rq *rt_rq;
+	struct sched_rt_entity *rt_se;
 	struct rq *rq;
 	int i;
 
@@ -7467,100 +7556,89 @@ struct task_group *sched_create_group(vo
 	tg->se = kzalloc(sizeof(se) * NR_CPUS, GFP_KERNEL);
 	if (!tg->se)
 		goto err;
+	tg->rt_rq = kzalloc(sizeof(rt_rq) * NR_CPUS, GFP_KERNEL);
+	if (!tg->rt_rq)
+		goto err;
+	tg->rt_se = kzalloc(sizeof(rt_se) * NR_CPUS, GFP_KERNEL);
+	if (!tg->rt_se)
+		goto err;
+
+	tg->shares = NICE_0_LOAD;
+	tg->rt_ratio = 0; /* XXX */
 
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 
-		cfs_rq = kmalloc_node(sizeof(struct cfs_rq), GFP_KERNEL,
-							 cpu_to_node(i));
+		cfs_rq = kmalloc_node(sizeof(struct cfs_rq),
+				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!cfs_rq)
 			goto err;
 
-		se = kmalloc_node(sizeof(struct sched_entity), GFP_KERNEL,
-							cpu_to_node(i));
+		se = kmalloc_node(sizeof(struct sched_entity),
+				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
 		if (!se)
 			goto err;
 
-		memset(cfs_rq, 0, sizeof(struct cfs_rq));
-		memset(se, 0, sizeof(struct sched_entity));
+		rt_rq = kmalloc_node(sizeof(struct rt_rq),
+				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		if (!rt_rq)
+			goto err;
 
-		tg->cfs_rq[i] = cfs_rq;
-		init_cfs_rq(cfs_rq, rq);
-		cfs_rq->tg = tg;
-
-		tg->se[i] = se;
-		se->cfs_rq = &rq->cfs;
-		se->my_q = cfs_rq;
-		se->load.weight = NICE_0_LOAD;
-		se->load.inv_weight = div64_64(1ULL<<32, NICE_0_LOAD);
-		se->parent = NULL;
-	}
+		rt_se = kmalloc_node(sizeof(struct sched_rt_entity),
+				GFP_KERNEL|__GFP_ZERO, cpu_to_node(i));
+		if (!rt_se)
+			goto err;
 
-	tg->shares = NICE_0_LOAD;
+		init_tg_cfs_entry(rq, tg, cfs_rq, se, i, 0);
+		init_tg_rt_entry(rq, tg, rt_rq, rt_se, i, 0);
+	}
 
 	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		rq = cpu_rq(i);
 		cfs_rq = tg->cfs_rq[i];
 		list_add_rcu(&cfs_rq->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+		rt_rq = tg->rt_rq[i];
+		list_add_rcu(&rt_rq->leaf_rt_rq_list, &rq->leaf_rt_rq_list);
 	}
+	list_add_rcu(&tg->list, &task_groups);
 	unlock_task_group_list();
 
 	return tg;
 
 err:
-	for_each_possible_cpu(i) {
-		if (tg->cfs_rq)
-			kfree(tg->cfs_rq[i]);
-		if (tg->se)
-			kfree(tg->se[i]);
-	}
-	kfree(tg->cfs_rq);
-	kfree(tg->se);
-	kfree(tg);
-
+	free_sched_group(tg);
 	return ERR_PTR(-ENOMEM);
 }
 
 /* rcu callback to free various structures associated with a task group */
-static void free_sched_group(struct rcu_head *rhp)
+static void free_sched_group_rcu(struct rcu_head *rhp)
 {
-	struct task_group *tg = container_of(rhp, struct task_group, rcu);
-	struct cfs_rq *cfs_rq;
-	struct sched_entity *se;
-	int i;
-
 	/* now it should be safe to free those cfs_rqs */
-	for_each_possible_cpu(i) {
-		cfs_rq = tg->cfs_rq[i];
-		kfree(cfs_rq);
-
-		se = tg->se[i];
-		kfree(se);
-	}
-
-	kfree(tg->cfs_rq);
-	kfree(tg->se);
-	kfree(tg);
+	free_sched_group(container_of(rhp, struct task_group, rcu));
 }
 
 /* Destroy runqueue etc associated with a task group */
 void sched_destroy_group(struct task_group *tg)
 {
 	struct cfs_rq *cfs_rq = NULL;
+	struct rt_rq *rt_rq = NULL;
 	int i;
 
 	lock_task_group_list();
 	for_each_possible_cpu(i) {
 		cfs_rq = tg->cfs_rq[i];
 		list_del_rcu(&cfs_rq->leaf_cfs_rq_list);
+		rt_rq = tg->rt_rq[i];
+		list_del_rcu(&rt_rq->leaf_rt_rq_list);
 	}
+	list_del_rcu(&tg->list);
 	unlock_task_group_list();
 
 	BUG_ON(!cfs_rq);
 
 	/* wait for possible concurrent references to cfs_rqs complete */
-	call_rcu(&tg->rcu, free_sched_group);
+	call_rcu(&tg->rcu, free_sched_group_rcu);
 }
 
 /* change task's runqueue when it moves between groups.
@@ -7576,11 +7654,6 @@ void sched_move_task(struct task_struct 
 
 	rq = task_rq_lock(tsk, &flags);
 
-	if (tsk->sched_class != &fair_sched_class) {
-		set_task_cfs_rq(tsk, task_cpu(tsk));
-		goto done;
-	}
-
 	update_rq_clock(rq);
 
 	running = task_current(rq, tsk);
@@ -7592,7 +7665,7 @@ void sched_move_task(struct task_struct 
 			tsk->sched_class->put_prev_task(rq, tsk);
 	}
 
-	set_task_cfs_rq(tsk, task_cpu(tsk));
+	set_task_rq(tsk, task_cpu(tsk));
 
 	if (on_rq) {
 		if (unlikely(running))
@@ -7600,7 +7673,6 @@ void sched_move_task(struct task_struct 
 		enqueue_task(rq, tsk, 0);
 	}
 
-done:
 	task_rq_unlock(rq, &flags);
 }
 
@@ -7685,6 +7757,31 @@ unsigned long sched_group_shares(struct 
 	return tg->shares;
 }
 
+/*
+ * Ensure the total rt_ratio <= sysctl_sched_rt_ratio
+ */
+int sched_group_set_rt_ratio(struct task_group *tg, unsigned long rt_ratio)
+{
+	struct task_group *tgi;
+	unsigned long total = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(tgi, &task_groups, list)
+		total += tgi->rt_ratio;
+	rcu_read_unlock();
+
+	if (total + rt_ratio - tg->rt_ratio > sysctl_sched_rt_ratio)
+		return -EINVAL;
+
+	tg->rt_ratio = rt_ratio;
+	return 0;
+}
+
+unsigned long sched_group_rt_ratio(struct task_group *tg)
+{
+	return tg->rt_ratio;
+}
+
 #endif	/* CONFIG_FAIR_GROUP_SCHED */
 
 #ifdef CONFIG_FAIR_CGROUP_SCHED
@@ -7760,12 +7857,30 @@ static u64 cpu_shares_read_uint(struct c
 	return (u64) tg->shares;
 }
 
+static int cpu_rt_ratio_write_uint(struct cgroup *cgrp, struct cftype *cftype,
+		u64 rt_ratio_val)
+{
+	return sched_group_set_rt_ratio(cgroup_tg(cgrp), rt_ratio_val);
+}
+
+static u64 cpu_rt_ratio_read_uint(struct cgroup *cgrp, struct cftype *cft)
+{
+	struct task_group *tg = cgroup_tg(cgrp);
+
+	return (u64) tg->rt_ratio;
+}
+
 static struct cftype cpu_files[] = {
 	{
 		.name = "shares",
 		.read_uint = cpu_shares_read_uint,
 		.write_uint = cpu_shares_write_uint,
 	},
+	{
+		.name = "rt_ratio",
+		.read_uint = cpu_rt_ratio_read_uint,
+		.write_uint = cpu_rt_ratio_write_uint,
+	},
 };
 
 static int cpu_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cont)
Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -45,47 +45,167 @@ static void update_rt_migration(struct r
 }
 #endif /* CONFIG_SMP */
 
-static int sched_rt_ratio_exceeded(struct rq *rq, struct rt_rq *rt_rq)
+static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
 {
+	return container_of(rt_se, struct task_struct, rt);
+}
+
+static inline int on_rt_rq(struct sched_rt_entity *rt_se)
+{
+	return !list_empty(&rt_se->run_list);
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
+static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
+{
+	if (!rt_rq->tg)
+		return SCHED_RT_FRAC;
+
+	return rt_rq->tg->rt_ratio;
+}
+
+#define for_each_leaf_rt_rq(rt_rq, rq) \
+	list_for_each_entry(rt_rq, &rq->leaf_rt_rq_list, leaf_rt_rq_list)
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return rt_rq->rq;
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	return rt_se->rt_rq;
+}
+
+#define for_each_sched_rt_entity(rt_se) \
+	for (; rt_se; rt_se = rt_se->parent)
+
+static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
+{
+	return rt_se->my_q;
+}
+
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se);
+static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
+
+static void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
+{
+	struct sched_rt_entity *rt_se = rt_rq->rt_se;
+
+	if (rt_se && !on_rt_rq(rt_se) && rt_rq->rt_nr_running) {
+		enqueue_rt_entity(rt_se);
+		resched_task(rq_of_rt_rq(rt_rq)->curr);
+	}
+}
+
+static void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
+{
+	struct sched_rt_entity *rt_se = rt_rq->rt_se;
+
+	if (rt_se && on_rt_rq(rt_se))
+		dequeue_rt_entity(rt_se);
+}
+
+#else
+
+static inline unsigned int sched_rt_ratio(struct rt_rq *rt_rq)
+{
+	return sysctl_sched_rt_ratio;
+}
+
+#define for_each_leaf_rt_rq(rt_rq, rq) \
+	for (rt_rq = &rq->rt; rt_rq; rt_rq = NULL)
+
+static inline struct rq *rq_of_rt_rq(struct rt_rq *rt_rq)
+{
+	return container_of(rt_rq, struct rq, rt);
+}
+
+static inline struct rt_rq *rt_rq_of_se(struct sched_rt_entity *rt_se)
+{
+	struct task_struct *p = rt_task_of(rt_se);
+	struct rq *rq = task_rq(p);
+
+	return &rq->rt;
+}
+
+#define for_each_sched_rt_entity(rt_se) \
+	for (; rt_se; rt_se = NULL)
+
+static inline struct rt_rq *group_rt_rq(struct sched_rt_entity *rt_se)
+{
+	return NULL;
+}
+
+static inline void sched_rt_ratio_enqueue(struct rt_rq *rt_rq)
+{
+}
+
+static inline void sched_rt_ratio_dequeue(struct rt_rq *rt_rq)
+{
+}
+
+#endif
+
+static inline int rt_se_prio(struct sched_rt_entity *rt_se)
+{
+#ifdef CONFIG_FAIR_GROUP_SCHED
+	struct rt_rq *rt_rq = group_rt_rq(rt_se);
+
+	if (rt_rq)
+		return rt_rq->highest_prio;
+#endif
+
+	return rt_task_of(rt_se)->prio;
+}
+
+static int sched_rt_ratio_exceeded(struct rt_rq *rt_rq)
+{
+	unsigned int rt_ratio = sched_rt_ratio(rt_rq);
 	u64 period, ratio;
 
-	if (sysctl_sched_rt_ratio == SCHED_RT_FRAC)
+	if (rt_ratio == SCHED_RT_FRAC)
 		return 0;
 
 	if (rt_rq->rt_throttled)
 		return 1;
 
 	period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
-	ratio = (period * sysctl_sched_rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+	ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
 
 	if (rt_rq->rt_time > ratio) {
-		rt_rq->rt_throttled = rq->clock + period - rt_rq->rt_time;
+		rt_rq->rt_throttled = 1;
+		sched_rt_ratio_dequeue(rt_rq);
 		return 1;
 	}
 
 	return 0;
 }
 
+static void __update_sched_rt_period(struct rt_rq *rt_rq, u64 period)
+{
+	unsigned long rt_ratio = sched_rt_ratio(rt_rq);
+	u64 ratio = (period * rt_ratio) >> SCHED_RT_FRAC_SHIFT;
+
+	rt_rq->rt_time -= min(rt_rq->rt_time, ratio);
+	if (rt_rq->rt_throttled) {
+		rt_rq->rt_throttled = 0;
+		sched_rt_ratio_enqueue(rt_rq);
+	}
+}
+
 static void update_sched_rt_period(struct rq *rq)
 {
-	while (rq->clock > rq->rt_period_expire) {
-		u64 period, ratio;
+	struct rt_rq *rt_rq;
+	u64 period;
 
+	while (rq->clock > rq->rt_period_expire) {
 		period = (u64)sysctl_sched_rt_period * NSEC_PER_MSEC;
-		ratio = (period * sysctl_sched_rt_ratio) >> SCHED_RT_FRAC_SHIFT;
-
-		rq->rt.rt_time -= min(rq->rt.rt_time, ratio);
 		rq->rt_period_expire += period;
-	}
 
-	/*
-	 * When the rt throttle is expired, let them rip.
-	 * (XXX: use hrtick when available)
-	 */
-	if (rq->rt.rt_throttled && rq->clock > rq->rt.rt_throttled) {
-		rq->rt.rt_throttled = 0;
-		if (!sched_rt_ratio_exceeded(rq, &rq->rt))
-			resched_task(rq->curr);
+		for_each_leaf_rt_rq(rt_rq, rq)
+			__update_sched_rt_period(rt_rq, period);
 	}
 }
 
@@ -96,10 +216,11 @@ static void update_sched_rt_period(struc
 static void update_curr_rt(struct rq *rq)
 {
 	struct task_struct *curr = rq->curr;
+	struct sched_rt_entity *rt_se = &curr->rt;
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	u64 delta_exec;
 
-	if (!task_has_rt_policy(curr))
-		return;
+	BUG_ON(!task_has_rt_policy(curr));
 
 	delta_exec = rq->clock - curr->se.exec_start;
 	if (unlikely((s64)delta_exec < 0))
@@ -111,95 +232,184 @@ static void update_curr_rt(struct rq *rq
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
-	rq->rt.rt_time += delta_exec;
-	update_sched_rt_period(rq);
-	if (sched_rt_ratio_exceeded(rq, &rq->rt))
+	rt_rq->rt_time += delta_exec;
+	/*
+	 * might make it a tad more accurate:
+	 *
+	 * update_sched_rt_period(rq);
+	 */
+	if (sched_rt_ratio_exceeded(rt_rq))
 		resched_task(curr);
 }
 
-static inline void inc_rt_tasks(struct task_struct *p, struct rq *rq)
+static inline
+void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	WARN_ON(!rt_task(p));
-	rq->rt.rt_nr_running++;
+	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
+	rt_rq->rt_nr_running++;
+#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+	if (rt_se_prio(rt_se) < rt_rq->highest_prio)
+		rt_rq->highest_prio = rt_se_prio(rt_se);
+#endif
 #ifdef CONFIG_SMP
-	if (p->prio < rq->rt.highest_prio)
-		rq->rt.highest_prio = p->prio;
-	if (p->nr_cpus_allowed > 1)
+	if (rt_se->nr_cpus_allowed > 1) {
+		struct rq *rq = rq_of_rt_rq(rt_rq);
 		rq->rt.rt_nr_migratory++;
+	}
 
-	update_rt_migration(rq);
-#endif /* CONFIG_SMP */
+	update_rt_migration(rq_of_rt_rq(rt_rq));
+#endif
 }
 
-static inline void dec_rt_tasks(struct task_struct *p, struct rq *rq)
+static inline
+void dec_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
 {
-	WARN_ON(!rt_task(p));
-	WARN_ON(!rq->rt.rt_nr_running);
-	rq->rt.rt_nr_running--;
-#ifdef CONFIG_SMP
-	if (rq->rt.rt_nr_running) {
+	WARN_ON(!rt_prio(rt_se_prio(rt_se)));
+	WARN_ON(!rt_rq->rt_nr_running);
+	rt_rq->rt_nr_running--;
+#if defined CONFIG_SMP || defined CONFIG_FAIR_GROUP_SCHED
+	if (rt_rq->rt_nr_running) {
 		struct rt_prio_array *array;
 
-		WARN_ON(p->prio < rq->rt.highest_prio);
-		if (p->prio == rq->rt.highest_prio) {
+		WARN_ON(rt_se_prio(rt_se) < rt_rq->highest_prio);
+		if (rt_se_prio(rt_se) == rt_rq->highest_prio) {
 			/* recalculate */
-			array = &rq->rt.active;
-			rq->rt.highest_prio =
+			array = &rt_rq->active;
+			rt_rq->highest_prio =
 				sched_find_first_bit(array->bitmap);
 		} /* otherwise leave rq->highest prio alone */
 	} else
-		rq->rt.highest_prio = MAX_RT_PRIO;
-	if (p->nr_cpus_allowed > 1)
+		rt_rq->highest_prio = MAX_RT_PRIO;
+#endif
+#ifdef CONFIG_SMP
+	if (rt_se->nr_cpus_allowed > 1) {
+		struct rq *rq = rq_of_rt_rq(rt_rq);
 		rq->rt.rt_nr_migratory--;
+	}
 
-	update_rt_migration(rq);
+	update_rt_migration(rq_of_rt_rq(rt_rq));
 #endif /* CONFIG_SMP */
 }
 
-static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
+static void enqueue_rt_entity(struct sched_rt_entity *rt_se)
 {
-	struct rt_prio_array *array = &rq->rt.active;
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+	struct rt_prio_array *array = &rt_rq->active;
+	struct rt_rq *group_rq = group_rt_rq(rt_se);
 
-	list_add_tail(&p->rt.run_list, array->queue + p->prio);
-	__set_bit(p->prio, array->bitmap);
-	inc_cpu_load(rq, p->se.load.weight);
+	if (group_rq && group_rq->rt_throttled)
+		return;
 
-	inc_rt_tasks(p, rq);
+	list_add_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+	__set_bit(rt_se_prio(rt_se), array->bitmap);
 
-	if (wakeup)
-		p->rt.timeout = 0;
+	inc_rt_tasks(rt_se, rt_rq);
+}
+
+static void dequeue_rt_entity(struct sched_rt_entity *rt_se)
+{
+	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
+	struct rt_prio_array *array = &rt_rq->active;
+
+	list_del_init(&rt_se->run_list);
+	if (list_empty(array->queue + rt_se_prio(rt_se)))
+		__clear_bit(rt_se_prio(rt_se), array->bitmap);
+
+	dec_rt_tasks(rt_se, rt_rq);
+}
+
+/*
+ * Because the prio of an upper entry depends on the lower
+ * entries, we must remove entries top - down.
+ *
+ * XXX: O(1/2 h^2) because we can only walk up, not down the chain.
+ *      doesn't matter much for now, as h=2 for GROUP_SCHED.
+ */
+static void dequeue_rt_stack(struct task_struct *p)
+{
+	struct sched_rt_entity *rt_se, *top_se;
+
+	/*
+	 * dequeue all, top - down.
+	 */
+	do {
+		rt_se = &p->rt;
+		top_se = NULL;
+		for_each_sched_rt_entity(rt_se) {
+			if (on_rt_rq(rt_se))
+				top_se = rt_se;
+		}
+		if (top_se)
+			dequeue_rt_entity(top_se);
+	} while (top_se);
 }
 
 /*
  * Adding/removing a task to/from a priority array:
  */
+static void enqueue_task_rt(struct rq *rq, struct task_struct *p, int wakeup)
+{
+	struct sched_rt_entity *rt_se = &p->rt;
+
+	if (wakeup)
+		rt_se->timeout = 0;
+
+	dequeue_rt_stack(p);
+
+	/*
+	 * enqueue everybody, bottom - up.
+	 */
+	for_each_sched_rt_entity(rt_se)
+		enqueue_rt_entity(rt_se);
+
+	inc_cpu_load(rq, p->se.load.weight);
+}
+
 static void dequeue_task_rt(struct rq *rq, struct task_struct *p, int sleep)
 {
-	struct rt_prio_array *array = &rq->rt.active;
+	struct sched_rt_entity *rt_se = &p->rt;
+	struct rt_rq *rt_rq;
 
 	update_curr_rt(rq);
 
-	list_del(&p->rt.run_list);
-	if (list_empty(array->queue + p->prio))
-		__clear_bit(p->prio, array->bitmap);
-	dec_cpu_load(rq, p->se.load.weight);
+	dequeue_rt_stack(p);
+
+	/*
+	 * re-enqueue all non-empty rt_rq entities.
+	 */
+	for_each_sched_rt_entity(rt_se) {
+		rt_rq = group_rt_rq(rt_se);
+		if (rt_rq && rt_rq->rt_nr_running)
+			enqueue_rt_entity(rt_se);
+	}
 
-	dec_rt_tasks(p, rq);
+	dec_cpu_load(rq, p->se.load.weight);
 }
 
 /*
  * Put task to the end of the run list without the overhead of dequeue
  * followed by enqueue.
  */
+static
+void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
+{
+	struct rt_prio_array *array = &rt_rq->active;
+
+	list_move_tail(&rt_se->run_list, array->queue + rt_se_prio(rt_se));
+}
+
 static void requeue_task_rt(struct rq *rq, struct task_struct *p)
 {
-	struct rt_prio_array *array = &rq->rt.active;
+	struct sched_rt_entity *rt_se = &p->rt;
+	struct rt_rq *rt_rq;
 
-	list_move_tail(&p->rt.run_list, array->queue + p->prio);
+	for_each_sched_rt_entity(rt_se) {
+		rt_rq = rt_rq_of_se(rt_se);
+		requeue_rt_entity(rt_rq, rt_se);
+	}
 }
 
-static void
-yield_task_rt(struct rq *rq)
+static void yield_task_rt(struct rq *rq)
 {
 	requeue_task_rt(rq, rq->curr);
 }
@@ -229,7 +439,7 @@ static int select_task_rq_rt(struct task
 	 * cold cache anyway.
 	 */
 	if (unlikely(rt_task(rq->curr)) &&
-	    (p->nr_cpus_allowed > 1)) {
+	    (p->rt.nr_cpus_allowed > 1)) {
 		int cpu = find_lowest_rq(p);
 
 		return (cpu == -1) ? task_cpu(p) : cpu;
@@ -252,27 +462,51 @@ static void check_preempt_curr_rt(struct
 		resched_task(rq->curr);
 }
 
-static struct task_struct *pick_next_task_rt(struct rq *rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
+						   struct rt_rq *rt_rq)
 {
-	struct rt_prio_array *array = &rq->rt.active;
-	struct task_struct *next;
+	struct rt_prio_array *array = &rt_rq->active;
+	struct sched_rt_entity *next = NULL;
 	struct list_head *queue;
-	struct rt_rq *rt_rq = &rq->rt;
 	int idx;
 
-	if (sched_rt_ratio_exceeded(rq, rt_rq))
-		return NULL;
+	if (sched_rt_ratio_exceeded(rt_rq))
+		goto out;
 
 	idx = sched_find_first_bit(array->bitmap);
-	if (idx >= MAX_RT_PRIO)
-		return NULL;
+	BUG_ON(idx >= MAX_RT_PRIO);
 
 	queue = array->queue + idx;
-	next = list_entry(queue->next, struct task_struct, rt.run_list);
+	next = list_entry(queue->next, struct sched_rt_entity, run_list);
+ out:
+	return next;
+}
 
-	next->se.exec_start = rq->clock;
+static struct task_struct *pick_next_task_rt(struct rq *rq)
+{
+	struct sched_rt_entity *rt_se;
+	struct task_struct *p;
+	struct rt_rq *rt_rq;
 
-	return next;
+ retry:
+	rt_rq = &rq->rt;
+
+	if (unlikely(!rt_rq->rt_nr_running))
+		return NULL;
+
+	if (sched_rt_ratio_exceeded(rt_rq))
+		return NULL;
+
+	do {
+		rt_se = pick_next_rt_entity(rq, rt_rq);
+		if (unlikely(!rt_se))
+			goto retry;
+		rt_rq = group_rt_rq(rt_se);
+	} while (rt_rq);
+
+	p = rt_task_of(rt_se);
+	p->se.exec_start = rq->clock;
+	return p;
 }
 
 static void put_prev_task_rt(struct rq *rq, struct task_struct *p)
@@ -282,6 +516,7 @@ static void put_prev_task_rt(struct rq *
 }
 
 #ifdef CONFIG_SMP
+
 /* Only try algorithms three times */
 #define RT_MAX_TRIES 3
 
@@ -292,7 +527,7 @@ static int pick_rt_task(struct rq *rq, s
 {
 	if (!task_running(rq, p) &&
 	    (cpu < 0 || cpu_isset(cpu, p->cpus_allowed)) &&
-	    (p->nr_cpus_allowed > 1))
+	    (p->rt.nr_cpus_allowed > 1))
 		return 1;
 	return 0;
 }
@@ -300,52 +535,33 @@ static int pick_rt_task(struct rq *rq, s
 /* Return the second highest RT task, NULL otherwise */
 static struct task_struct *pick_next_highest_task_rt(struct rq *rq, int cpu)
 {
-	struct rt_prio_array *array = &rq->rt.active;
-	struct task_struct *next;
-	struct list_head *queue;
+	struct task_struct *next = NULL;
+	struct sched_rt_entity *rt_se;
+	struct rt_prio_array *array;
+	struct rt_rq *rt_rq;
 	int idx;
 
-	if (likely(rq->rt.rt_nr_running < 2))
-		return NULL;
-
-	idx = sched_find_first_bit(array->bitmap);
-	if (unlikely(idx >= MAX_RT_PRIO)) {
-		WARN_ON(1); /* rt_nr_running is bad */
-		return NULL;
-	}
-
-	queue = array->queue + idx;
-	BUG_ON(list_empty(queue));
-
-	next = list_entry(queue->next, struct task_struct, rt.run_list);
-	if (unlikely(pick_rt_task(rq, next, cpu)))
-		goto out;
-
-	if (queue->next->next != queue) {
-		/* same prio task */
-		next = list_entry(queue->next->next, struct task_struct,
-				  rt.run_list);
-		if (pick_rt_task(rq, next, cpu))
-			goto out;
-	}
-
- retry:
-	/* slower, but more flexible */
-	idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
-	if (unlikely(idx >= MAX_RT_PRIO))
-		return NULL;
-
-	queue = array->queue + idx;
-	BUG_ON(list_empty(queue));
-
-	list_for_each_entry(next, queue, rt.run_list) {
-		if (pick_rt_task(rq, next, cpu))
-			goto out;
+	for_each_leaf_rt_rq(rt_rq, rq) {
+		array = &rt_rq->active;
+		idx = sched_find_first_bit(array->bitmap);
+ next_idx:
+		if (idx >= MAX_RT_PRIO)
+			continue;
+		if (next && next->prio < idx)
+			continue;
+		list_for_each_entry(rt_se, array->queue + idx, run_list) {
+			struct task_struct *p = rt_task_of(rt_se);
+			if (pick_rt_task(rq, p, cpu)) {
+				next = p;
+				break;
+			}
+		}
+		if (!next) {
+			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
+			goto next_idx;
+		}
 	}
 
-	goto retry;
-
- out:
 	return next;
 }
 
@@ -774,12 +990,12 @@ static void set_cpus_allowed_rt(struct t
 	 * Update the migration status of the RQ if we have an RT task
 	 * which is running AND changing its weight value.
 	 */
-	if (p->se.on_rq && (weight != p->nr_cpus_allowed)) {
+	if (p->se.on_rq && (weight != p->rt.nr_cpus_allowed)) {
 		struct rq *rq = task_rq(p);
 
-		if ((p->nr_cpus_allowed <= 1) && (weight > 1)) {
+		if ((p->rt.nr_cpus_allowed <= 1) && (weight > 1)) {
 			rq->rt.rt_nr_migratory++;
-		} else if ((p->nr_cpus_allowed > 1) && (weight <= 1)) {
+		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <= 1)) {
 			BUG_ON(!rq->rt.rt_nr_migratory);
 			rq->rt.rt_nr_migratory--;
 		}
@@ -788,7 +1004,7 @@ static void set_cpus_allowed_rt(struct t
 	}
 
 	p->cpus_allowed    = *new_mask;
-	p->nr_cpus_allowed = weight;
+	p->rt.nr_cpus_allowed = weight;
 }
 
 /* Assumes rq->lock is held */
Index: linux-2.6/include/linux/init_task.h
===================================================================
--- linux-2.6.orig/include/linux/init_task.h
+++ linux-2.6/include/linux/init_task.h
@@ -141,12 +141,13 @@ extern struct group_info init_groups;
 	.normal_prio	= MAX_PRIO-20,					\
 	.policy		= SCHED_NORMAL,					\
 	.cpus_allowed	= CPU_MASK_ALL,					\
-	.nr_cpus_allowed = NR_CPUS,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
 	.rt		= {						\
 		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
-		.time_slice	= HZ, },				\
+		.time_slice	= HZ, 					\
+		.nr_cpus_allowed = NR_CPUS,				\
+	},								\
 	.ioprio		= 0,						\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptrace_children= LIST_HEAD_INIT(tsk.ptrace_children),		\
Index: linux-2.6/kernel/fork.c
===================================================================
--- linux-2.6.orig/kernel/fork.c
+++ linux-2.6/kernel/fork.c
@@ -1252,7 +1252,7 @@ static struct task_struct *copy_process(
 	 * parent's CPU). This avoids alot of nasty races.
 	 */
 	p->cpus_allowed = current->cpus_allowed;
-	p->nr_cpus_allowed = current->nr_cpus_allowed;
+	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
 		set_task_cpu(p, smp_processor_id());


