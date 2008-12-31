Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYLaIiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYLaIiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 03:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbYLaIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 03:37:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61750 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756209AbYLaIh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 03:37:57 -0500
Message-ID: <495B2F2C.7060303@cn.fujitsu.com>
Date: Wed, 31 Dec 2008 16:37:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Mike Travis <travis@sgi.com>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/6] cpuset: convert cpuset->cpus_allowed to cpumask_var_t
References: <495B2EA6.7010808@cn.fujitsu.com> <495B2EC2.9090305@cn.fujitsu.com> <495B2EE7.4040406@cn.fujitsu.com> <495B2EFB.302@cn.fujitsu.com> <495B2F19.7040806@cn.fujitsu.com>
In-Reply-To: <495B2F19.7040806@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use new cpumask API

This patch mainly does the following things:
- change cs->cpus_allowed from cpumask_t to cpumask_var_t
- call alloc_bootmem_cpumask_var() for top_cpuset in cpuset_init_early()
- call alloc_cpumask_var() for other cpusets
- replace cpus_xxx() to cpumask_xxx()

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |  100 +++++++++++++++++++++++++++++++++----------------------
 1 files changed, 60 insertions(+), 40 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 480932a..25df51f 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -84,7 +84,7 @@ struct cpuset {
 	struct cgroup_subsys_state css;
 
 	unsigned long flags;		/* "unsigned long" so bitops work */
-	cpumask_t cpus_allowed;		/* CPUs allowed to tasks in cpuset */
+	cpumask_var_t cpus_allowed;	/* CPUs allowed to tasks in cpuset */
 	nodemask_t mems_allowed;	/* Memory Nodes allowed to tasks */
 
 	struct cpuset *parent;		/* my parent */
@@ -195,8 +195,6 @@ static int cpuset_mems_generation;
 
 static struct cpuset top_cpuset = {
 	.flags = ((1 << CS_CPU_EXCLUSIVE) | (1 << CS_MEM_EXCLUSIVE)),
-	.cpus_allowed = CPU_MASK_ALL,
-	.mems_allowed = NODE_MASK_ALL,
 };
 
 /*
@@ -278,7 +276,7 @@ static struct file_system_type cpuset_fs_type = {
 };
 
 /*
- * Return in *pmask the portion of a cpusets's cpus_allowed that
+ * Return in pmask the portion of a cpusets's cpus_allowed that
  * are online.  If none are online, walk up the cpuset hierarchy
  * until we find one that does have some online cpus.  If we get
  * all the way to the top and still haven't found any online cpus,
@@ -293,13 +291,13 @@ static struct file_system_type cpuset_fs_type = {
 
 static void guarantee_online_cpus(const struct cpuset *cs, cpumask_t *pmask)
 {
-	while (cs && !cpus_intersects(cs->cpus_allowed, cpu_online_map))
+	while (cs && !cpumask_intersects(cs->cpus_allowed, cpu_online_mask))
 		cs = cs->parent;
 	if (cs)
-		cpus_and(*pmask, cs->cpus_allowed, cpu_online_map);
+		cpumask_and(pmask, cs->cpus_allowed, cpu_online_mask);
 	else
-		*pmask = cpu_online_map;
-	BUG_ON(!cpus_intersects(*pmask, cpu_online_map));
+		cpumask_copy(pmask, cpu_online_mask);
+	BUG_ON(!cpumask_intersects(pmask, cpu_online_mask));
 }
 
 /*
@@ -409,7 +407,7 @@ void cpuset_update_task_memory_state(void)
 
 static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
 {
-	return	cpus_subset(p->cpus_allowed, q->cpus_allowed) &&
+	return	cpumask_subset(p->cpus_allowed, q->cpus_allowed) &&
 		nodes_subset(p->mems_allowed, q->mems_allowed) &&
 		is_cpu_exclusive(p) <= is_cpu_exclusive(q) &&
 		is_mem_exclusive(p) <= is_mem_exclusive(q);
@@ -421,7 +419,19 @@ static int is_cpuset_subset(const struct cpuset *p, const struct cpuset *q)
  */
 static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
 {
-	return kmemdup(cs, sizeof(*cs), GFP_KERNEL);
+	struct cpuset *trial;
+
+	trial = kmemdup(cs, sizeof(*cs), GFP_KERNEL);
+	if (!trial)
+		return NULL;
+
+	if (!alloc_cpumask_var(&trial->cpus_allowed, GFP_KERNEL)) {
+		kfree(trial);
+		return NULL;
+	}
+	cpumask_copy(trial->cpus_allowed, cs->cpus_allowed);
+
+	return trial;
 }
 
 /**
@@ -430,6 +440,7 @@ static struct cpuset *alloc_trial_cpuset(const struct cpuset *cs)
  */
 static void free_trial_cpuset(struct cpuset *trial)
 {
+	free_cpumask_var(trial->cpus_allowed);
 	kfree(trial);
 }
 
@@ -482,7 +493,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 		c = cgroup_cs(cont);
 		if ((is_cpu_exclusive(trial) || is_cpu_exclusive(c)) &&
 		    c != cur &&
-		    cpus_intersects(trial->cpus_allowed, c->cpus_allowed))
+		    cpumask_intersects(trial->cpus_allowed, c->cpus_allowed))
 			return -EINVAL;
 		if ((is_mem_exclusive(trial) || is_mem_exclusive(c)) &&
 		    c != cur &&
@@ -492,7 +503,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
 
 	/* Cpusets with tasks can't have empty cpus_allowed or mems_allowed */
 	if (cgroup_task_count(cur->css.cgroup)) {
-		if (cpus_empty(trial->cpus_allowed) ||
+		if (cpumask_empty(trial->cpus_allowed) ||
 		    nodes_empty(trial->mems_allowed)) {
 			return -ENOSPC;
 		}
@@ -507,7 +518,7 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
  */
 static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
 {
-	return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
+	return cpumask_intersects(a->cpus_allowed, b->cpus_allowed);
 }
 
 static void
@@ -532,7 +543,7 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
 		cp = list_first_entry(&q, struct cpuset, stack_list);
 		list_del(q.next);
 
-		if (cpus_empty(cp->cpus_allowed))
+		if (cpumask_empty(cp->cpus_allowed))
 			continue;
 
 		if (is_sched_load_balance(cp))
@@ -627,7 +638,7 @@ static int generate_sched_domains(cpumask_t **domains,
 			*dattr = SD_ATTR_INIT;
 			update_domain_attr_tree(dattr, &top_cpuset);
 		}
-		*doms = top_cpuset.cpus_allowed;
+		cpumask_copy(doms, top_cpuset.cpus_allowed);
 
 		ndoms = 1;
 		goto done;
@@ -646,7 +657,7 @@ static int generate_sched_domains(cpumask_t **domains,
 		cp = list_first_entry(&q, struct cpuset, stack_list);
 		list_del(q.next);
 
-		if (cpus_empty(cp->cpus_allowed))
+		if (cpumask_empty(cp->cpus_allowed))
 			continue;
 
 		/*
@@ -739,7 +750,7 @@ restart:
 			struct cpuset *b = csa[j];
 
 			if (apn == b->pn) {
-				cpus_or(*dp, *dp, b->cpus_allowed);
+				cpumask_or(dp, dp, b->cpus_allowed);
 				if (dattr)
 					update_domain_attr_tree(dattr + nslot, b);
 
@@ -848,7 +859,7 @@ void rebuild_sched_domains(void)
 static int cpuset_test_cpumask(struct task_struct *tsk,
 			       struct cgroup_scanner *scan)
 {
-	return !cpus_equal(tsk->cpus_allowed,
+	return !cpumask_equal(&tsk->cpus_allowed,
 			(cgroup_cs(scan->cg))->cpus_allowed);
 }
 
@@ -866,7 +877,7 @@ static int cpuset_test_cpumask(struct task_struct *tsk,
 static void cpuset_change_cpumask(struct task_struct *tsk,
 				  struct cgroup_scanner *scan)
 {
-	set_cpus_allowed_ptr(tsk, &((cgroup_cs(scan->cg))->cpus_allowed));
+	set_cpus_allowed_ptr(tsk, ((cgroup_cs(scan->cg))->cpus_allowed));
 }
 
 /**
@@ -916,13 +927,13 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	 * with tasks have cpus.
 	 */
 	if (!*buf) {
-		cpus_clear(trialcs->cpus_allowed);
+		cpumask_clear(trialcs->cpus_allowed);
 	} else {
-		retval = cpulist_parse(buf, &trialcs->cpus_allowed);
+		retval = cpulist_parse(buf, trialcs->cpus_allowed);
 		if (retval < 0)
 			return retval;
 
-		if (!cpus_subset(trialcs->cpus_allowed, cpu_online_map))
+		if (!cpumask_subset(trialcs->cpus_allowed, cpu_online_mask))
 			return -EINVAL;
 	}
 	retval = validate_change(cs, trialcs);
@@ -930,7 +941,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		return retval;
 
 	/* Nothing to do if the cpus didn't change */
-	if (cpus_equal(cs->cpus_allowed, trialcs->cpus_allowed))
+	if (cpumask_equal(cs->cpus_allowed, trialcs->cpus_allowed))
 		return 0;
 
 	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
@@ -940,7 +951,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 	is_load_balanced = is_sched_load_balance(trialcs);
 
 	mutex_lock(&callback_mutex);
-	cs->cpus_allowed = trialcs->cpus_allowed;
+	cpumask_copy(cs->cpus_allowed, trialcs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	/*
@@ -1028,7 +1039,7 @@ static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)
 	cpuset_being_rebound = cs;		/* causes mpol_dup() rebind */
 
 	fudge = 10;				/* spare mmarray[] slots */
-	fudge += cpus_weight(cs->cpus_allowed);	/* imagine one fork-bomb/cpu */
+	fudge += cpumask_weight(cs->cpus_allowed);/* imagine 1 fork-bomb/cpu */
 	retval = -ENOMEM;
 
 	/*
@@ -1176,7 +1187,8 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
 
 	if (val != cs->relax_domain_level) {
 		cs->relax_domain_level = val;
-		if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
+		if (!cpumask_empty(cs->cpus_allowed) &&
+		    is_sched_load_balance(cs))
 			async_rebuild_sched_domains();
 	}
 
@@ -1219,7 +1231,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 	cs->flags = trialcs->flags;
 	mutex_unlock(&callback_mutex);
 
-	if (!cpus_empty(trialcs->cpus_allowed) && balance_flag_changed)
+	if (!cpumask_empty(trialcs->cpus_allowed) && balance_flag_changed)
 		async_rebuild_sched_domains();
 
 out:
@@ -1340,12 +1352,12 @@ static int cpuset_can_attach(struct cgroup_subsys *ss,
 	struct cpuset *cs = cgroup_cs(cont);
 	int ret = 0;
 
-	if (cpus_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
+	if (cpumask_empty(cs->cpus_allowed) || nodes_empty(cs->mems_allowed))
 		return -ENOSPC;
 
 	if (tsk->flags & PF_THREAD_BOUND) {
 		mutex_lock(&callback_mutex);
-		if (!cpus_equal(tsk->cpus_allowed, cs->cpus_allowed))
+		if (!cpumask_equal(&tsk->cpus_allowed, cs->cpus_allowed))
 			ret = -EINVAL;
 		mutex_unlock(&callback_mutex);
 
@@ -1534,7 +1546,7 @@ static int cpuset_sprintf_cpulist(char *page, struct cpuset *cs)
 	int ret;
 
 	mutex_lock(&callback_mutex);
-	ret = cpulist_scnprintf(page, PAGE_SIZE, &cs->cpus_allowed);
+	ret = cpulist_scnprintf(page, PAGE_SIZE, cs->cpus_allowed);
 	mutex_unlock(&callback_mutex);
 
 	return ret;
@@ -1773,7 +1785,7 @@ static void cpuset_post_clone(struct cgroup_subsys *ss,
 	parent_cs = cgroup_cs(parent);
 
 	cs->mems_allowed = parent_cs->mems_allowed;
-	cs->cpus_allowed = parent_cs->cpus_allowed;
+	cpumask_copy(cs->cpus_allowed, parent_cs->cpus_allowed);
 	return;
 }
 
@@ -1799,6 +1811,10 @@ static struct cgroup_subsys_state *cpuset_create(
 	cs = kmalloc(sizeof(*cs), GFP_KERNEL);
 	if (!cs)
 		return ERR_PTR(-ENOMEM);
+	if (!alloc_cpumask_var(&cs->cpus_allowed, GFP_KERNEL)) {
+		kfree(cs);
+		return ERR_PTR(-ENOMEM);
+	}
 
 	cpuset_update_task_memory_state();
 	cs->flags = 0;
@@ -1807,7 +1823,7 @@ static struct cgroup_subsys_state *cpuset_create(
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
 	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
-	cpus_clear(cs->cpus_allowed);
+	cpumask_clear(cs->cpus_allowed);
 	nodes_clear(cs->mems_allowed);
 	cs->mems_generation = cpuset_mems_generation++;
 	fmeter_init(&cs->fmeter);
@@ -1834,6 +1850,7 @@ static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 		update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
 
 	number_of_cpusets--;
+	free_cpumask_var(cs->cpus_allowed);
 	kfree(cs);
 }
 
@@ -1857,6 +1874,8 @@ struct cgroup_subsys cpuset_subsys = {
 
 int __init cpuset_init_early(void)
 {
+	alloc_bootmem_cpumask_var(&top_cpuset.cpus_allowed);
+
 	top_cpuset.mems_generation = cpuset_mems_generation++;
 	return 0;
 }
@@ -1872,7 +1891,7 @@ int __init cpuset_init(void)
 {
 	int err = 0;
 
-	cpus_setall(top_cpuset.cpus_allowed);
+	cpumask_setall(top_cpuset.cpus_allowed);
 	nodes_setall(top_cpuset.mems_allowed);
 
 	fmeter_init(&top_cpuset.fmeter);
@@ -1958,7 +1977,7 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
 	 * has online cpus, so can't be empty).
 	 */
 	parent = cs->parent;
-	while (cpus_empty(parent->cpus_allowed) ||
+	while (cpumask_empty(parent->cpus_allowed) ||
 			nodes_empty(parent->mems_allowed))
 		parent = parent->parent;
 
@@ -1999,7 +2018,7 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 		}
 
 		/* Continue past cpusets with all cpus, mems online */
-		if (cpus_subset(cp->cpus_allowed, cpu_online_map) &&
+		if (cpumask_subset(cp->cpus_allowed, cpu_online_mask) &&
 		    nodes_subset(cp->mems_allowed, node_states[N_HIGH_MEMORY]))
 			continue;
 
@@ -2007,13 +2026,14 @@ static void scan_for_empty_cpusets(struct cpuset *root)
 
 		/* Remove offline cpus and mems from this cpuset. */
 		mutex_lock(&callback_mutex);
-		cpus_and(cp->cpus_allowed, cp->cpus_allowed, cpu_online_map);
+		cpumask_and(cp->cpus_allowed, cp->cpus_allowed,
+			    cpu_online_mask);
 		nodes_and(cp->mems_allowed, cp->mems_allowed,
 						node_states[N_HIGH_MEMORY]);
 		mutex_unlock(&callback_mutex);
 
 		/* Move tasks from the empty cpuset to a parent */
-		if (cpus_empty(cp->cpus_allowed) ||
+		if (cpumask_empty(cp->cpus_allowed) ||
 		     nodes_empty(cp->mems_allowed))
 			remove_tasks_in_empty_cpuset(cp);
 		else {
@@ -2054,7 +2074,7 @@ static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
 	}
 
 	cgroup_lock();
-	top_cpuset.cpus_allowed = cpu_online_map;
+	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
 	scan_for_empty_cpusets(&top_cpuset);
 	ndoms = generate_sched_domains(&doms, &attr);
 	cgroup_unlock();
@@ -2099,7 +2119,7 @@ static int cpuset_track_online_nodes(struct notifier_block *self,
 
 void __init cpuset_init_smp(void)
 {
-	top_cpuset.cpus_allowed = cpu_online_map;
+	cpumask_copy(top_cpuset.cpus_allowed, cpu_online_mask);
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotcpu_notifier(cpuset_track_online_cpus, 0);
@@ -2111,7 +2131,7 @@ void __init cpuset_init_smp(void)
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
  * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
  *
- * Description: Returns the cpumask_t cpus_allowed of the cpuset
+ * Description: Returns the cpumask_var_t cpus_allowed of the cpuset
  * attached to the specified @tsk.  Guaranteed to return some non-empty
  * subset of cpu_online_map, even if this means going outside the
  * tasks cpuset.
-- 
1.5.4.rc3



