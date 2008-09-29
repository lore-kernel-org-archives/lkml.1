Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYI2SNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYI2SNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYI2SDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:37 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36481 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753979AbYI2SCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:53 -0400
Message-Id: <20080929180252.588122000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:08 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 18/31] cpumask: clean sched files
Content-Disposition: inline; filename=clean-sched
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 include/linux/sched.h |   18 +-
 kernel/sched.c        |  450 +++++++++++++++++++++++---------------------------
 kernel/sched_cpupri.c |    6 
 kernel/sched_cpupri.h |    8 
 kernel/sched_fair.c   |    2 
 kernel/sched_rt.c     |   50 ++---
 6 files changed, 252 insertions(+), 282 deletions(-)

--- struct-cpumasks.orig/include/linux/sched.h
+++ struct-cpumasks/include/linux/sched.h
@@ -248,7 +248,7 @@ extern void init_idle_bootup_task(struct
 
 extern int runqueue_is_locked(void);
 
-extern cpumask_t nohz_cpu_mask;
+extern cpumask_map_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
 extern int select_nohz_load_balancer(int cpu);
 #else
@@ -866,7 +866,7 @@ struct sched_domain {
 #endif
 };
 
-extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+extern void partition_sched_domains(int ndoms_new, cpumask_t doms_new,
 				    struct sched_domain_attr *dattr_new);
 extern int arch_reinit_sched_domains(void);
 
@@ -875,7 +875,7 @@ extern int arch_reinit_sched_domains(voi
 struct sched_domain_attr;
 
 static inline void
-partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+partition_sched_domains(int ndoms_new, cpumask_t doms_new,
 			struct sched_domain_attr *dattr_new)
 {
 }
@@ -960,7 +960,7 @@ struct sched_class {
 	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
 	void (*task_new) (struct rq *rq, struct task_struct *p);
 	void (*set_cpus_allowed)(struct task_struct *p,
-				 const cpumask_t newmask);
+				 const_cpumask_t newmask);
 
 	void (*rq_online)(struct rq *rq);
 	void (*rq_offline)(struct rq *rq);
@@ -1105,7 +1105,7 @@ struct task_struct {
 #endif
 
 	unsigned int policy;
-	cpumask_t cpus_allowed;
+	cpumask_map_t cpus_allowed;
 
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
@@ -1583,10 +1583,10 @@ extern cputime_t task_gtime(struct task_
 
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed(struct task_struct *p,
-				const cpumask_t new_mask);
+				const_cpumask_t new_mask);
 #else
 static inline int set_cpus_allowed(struct task_struct *p,
-				       const cpumask_t new_mask)
+				       const_cpumask_t new_mask)
 {
 	if (!cpu_isset(0, new_mask))
 		return -EINVAL;
@@ -2377,8 +2377,8 @@ __trace_special(void *__tr, void *__data
 }
 #endif
 
-extern long sched_setaffinity(pid_t pid, const cpumask_t *new_mask);
-extern long sched_getaffinity(pid_t pid, cpumask_t *mask);
+extern long sched_setaffinity(pid_t pid, const_cpumask_t new_mask);
+extern long sched_getaffinity(pid_t pid, cpumask_t mask);
 
 extern int sched_mc_power_savings, sched_smt_power_savings;
 
--- struct-cpumasks.orig/kernel/sched.c
+++ struct-cpumasks/kernel/sched.c
@@ -54,6 +54,7 @@
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/percpu.h>
+#include <linux/cpumask_alloc.h>
 #include <linux/kthread.h>
 #include <linux/seq_file.h>
 #include <linux/sysctl.h>
@@ -481,14 +482,14 @@ struct rt_rq {
  */
 struct root_domain {
 	atomic_t refcount;
-	cpumask_t span;
-	cpumask_t online;
+	cpumask_map_t span;
+	cpumask_map_t online;
 
 	/*
 	 * The "RT overload" flag: it gets set if a CPU has more than
 	 * one runnable RT task.
 	 */
-	cpumask_t rto_mask;
+	cpumask_map_t rto_mask;
 	atomic_t rto_count;
 #ifdef CONFIG_SMP
 	struct cpupri cpupri;
@@ -2102,16 +2103,16 @@ find_idlest_group(struct sched_domain *s
  */
 static int
 find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
-		cpumask_t *tmp)
+		cpumask_t tmp)
 {
 	unsigned long load, min_load = ULONG_MAX;
 	int idlest = -1;
 	int i;
 
 	/* Traverse only the allowed CPUs */
-	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
+	cpus_and(tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu(i, *tmp) {
+	for_each_cpu(i, tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -2138,6 +2139,7 @@ static int sched_balance_self(int cpu, i
 {
 	struct task_struct *t = current;
 	struct sched_domain *tmp, *sd = NULL;
+	cpumask_var_t span, tmpmask;
 
 	for_each_domain(cpu, tmp) {
 		/*
@@ -2153,7 +2155,6 @@ static int sched_balance_self(int cpu, i
 		update_shares(sd);
 
 	while (sd) {
-		cpumask_t span, tmpmask;
 		struct sched_group *group;
 		int new_cpu, weight;
 
@@ -2162,14 +2163,14 @@ static int sched_balance_self(int cpu, i
 			continue;
 		}
 
-		span = sd->span;
+		cpus_copy(span, sd->span);
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
@@ -3081,7 +3082,7 @@ static int move_one_task(struct rq *this
 static struct sched_group *
 find_busiest_group(struct sched_domain *sd, int this_cpu,
 		   unsigned long *imbalance, enum cpu_idle_type idle,
-		   int *sd_idle, const cpumask_t *cpus, int *balance)
+		   int *sd_idle, const_cpumask_t cpus, int *balance)
 {
 	struct sched_group *busiest = NULL, *this = NULL, *group = sd->groups;
 	unsigned long max_load, avg_load, total_load, this_load, total_pwr;
@@ -3132,7 +3133,7 @@ find_busiest_group(struct sched_domain *
 		for_each_cpu(i, group->cpumask) {
 			struct rq *rq;
 
-			if (!cpu_isset(i, *cpus))
+			if (!cpu_isset(i, cpus))
 				continue;
 
 			rq = cpu_rq(i);
@@ -3402,7 +3403,7 @@ ret:
  */
 static struct rq *
 find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
-		   unsigned long imbalance, const cpumask_t *cpus)
+		   unsigned long imbalance, const_cpumask_t cpus)
 {
 	struct rq *busiest = NULL, *rq;
 	unsigned long max_load = 0;
@@ -3411,7 +3412,7 @@ find_busiest_queue(struct sched_group *g
 	for_each_cpu(i, group->cpumask) {
 		unsigned long wl;
 
-		if (!cpu_isset(i, *cpus))
+		if (!cpu_isset(i, cpus))
 			continue;
 
 		rq = cpu_rq(i);
@@ -3441,7 +3442,7 @@ find_busiest_queue(struct sched_group *g
  */
 static int load_balance(int this_cpu, struct rq *this_rq,
 			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *balance, cpumask_t *cpus)
+			int *balance, cpumask_t cpus)
 {
 	int ld_moved, all_pinned = 0, active_balance = 0, sd_idle = 0;
 	struct sched_group *group;
@@ -3449,7 +3450,7 @@ static int load_balance(int this_cpu, st
 	struct rq *busiest;
 	unsigned long flags;
 
-	cpus_setall(*cpus);
+	cpus_setall(cpus);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3509,8 +3510,8 @@ redo:
 
 		/* All tasks on this runqueue were pinned by CPU affinity */
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), *cpus);
-			if (!cpus_empty(*cpus))
+			cpu_clear(cpu_of(busiest), cpus);
+			if (!cpus_empty(cpus))
 				goto redo;
 			goto out_balanced;
 		}
@@ -3602,7 +3603,7 @@ out:
  */
 static int
 load_balance_newidle(int this_cpu, struct rq *this_rq, struct sched_domain *sd,
-			cpumask_t *cpus)
+			cpumask_t cpus)
 {
 	struct sched_group *group;
 	struct rq *busiest = NULL;
@@ -3611,7 +3612,7 @@ load_balance_newidle(int this_cpu, struc
 	int sd_idle = 0;
 	int all_pinned = 0;
 
-	cpus_setall(*cpus);
+	cpus_setall(cpus);
 
 	/*
 	 * When power savings policy is enabled for the parent domain, idle
@@ -3655,8 +3656,8 @@ redo:
 		double_unlock_balance(this_rq, busiest);
 
 		if (unlikely(all_pinned)) {
-			cpu_clear(cpu_of(busiest), *cpus);
-			if (!cpus_empty(*cpus))
+			cpu_clear(cpu_of(busiest), cpus);
+			if (!cpus_empty(cpus))
 				goto redo;
 		}
 	}
@@ -3691,7 +3692,7 @@ static void idle_balance(int this_cpu, s
 	struct sched_domain *sd;
 	int pulled_task = -1;
 	unsigned long next_balance = jiffies + HZ;
-	cpumask_t tmpmask;
+	cpumask_var_t tmpmask;
 
 	for_each_domain(this_cpu, sd) {
 		unsigned long interval;
@@ -3702,7 +3703,7 @@ static void idle_balance(int this_cpu, s
 		if (sd->flags & SD_BALANCE_NEWIDLE)
 			/* If we've pulled tasks over stop searching: */
 			pulled_task = load_balance_newidle(this_cpu, this_rq,
-							   sd, &tmpmask);
+							   sd, tmpmask);
 
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
@@ -3773,7 +3774,7 @@ static void active_load_balance(struct r
 #ifdef CONFIG_NO_HZ
 static struct {
 	atomic_t load_balancer;
-	cpumask_t cpu_mask;
+	cpumask_map_t cpu_mask;
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
 	.cpu_mask = CPU_MASK_NONE,
@@ -3862,7 +3863,7 @@ static void rebalance_domains(int cpu, e
 	unsigned long next_balance = jiffies + 60*HZ;
 	int update_next_balance = 0;
 	int need_serialize;
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 
 	for_each_domain(cpu, sd) {
 		if (!(sd->flags & SD_LOAD_BALANCE))
@@ -3887,7 +3888,7 @@ static void rebalance_domains(int cpu, e
 		}
 
 		if (time_after_eq(jiffies, sd->last_balance + interval)) {
-			if (load_balance(cpu, rq, sd, idle, &balance, &tmp)) {
+			if (load_balance(cpu, rq, sd, idle, &balance, tmp)) {
 				/*
 				 * We've pulled tasks over so either we're no
 				 * longer idle, or one of our SMT siblings is
@@ -3945,10 +3946,11 @@ static void run_rebalance_domains(struct
 	 */
 	if (this_rq->idle_at_tick &&
 	    atomic_read(&nohz.load_balancer) == this_cpu) {
-		cpumask_t cpus = nohz.cpu_mask;
+		cpumask_var_t cpus;
 		struct rq *rq;
 		int balance_cpu;
 
+		cpus_copy(cpus, nohz.cpu_mask);
 		cpu_clear(this_cpu, cpus);
 		for_each_cpu(balance_cpu, cpus) {
 			/*
@@ -5416,16 +5418,17 @@ out_unlock:
 	return retval;
 }
 
-long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
+long sched_setaffinity(pid_t pid, const_cpumask_t in_mask)
 {
-	cpumask_t cpus_allowed;
-	cpumask_t new_mask = *in_mask;
+	cpumask_var_t cpus_allowed;
+	cpumask_var_t new_mask;
 	struct task_struct *p;
 	int retval;
 
 	get_online_cpus();
 	read_lock(&tasklist_lock);
 
+	cpus_copy(new_mask, in_mask);
 	p = find_process_by_pid(pid);
 	if (!p) {
 		read_unlock(&tasklist_lock);
@@ -5450,20 +5453,20 @@ long sched_setaffinity(pid_t pid, const 
 	if (retval)
 		goto out_unlock;
 
-	cpuset_cpus_allowed(p, &cpus_allowed);
+	cpuset_cpus_allowed(p, cpus_allowed);
 	cpus_and(new_mask, new_mask, cpus_allowed);
  again:
-	retval = set_cpus_allowed(p, &new_mask);
+	retval = set_cpus_allowed(p, new_mask);
 
 	if (!retval) {
-		cpuset_cpus_allowed(p, &cpus_allowed);
+		cpuset_cpus_allowed(p, cpus_allowed);
 		if (!cpus_subset(new_mask, cpus_allowed)) {
 			/*
 			 * We must have raced with a concurrent cpuset
 			 * update. Just reset the cpus_allowed to the
 			 * cpuset's cpus_allowed
 			 */
-			new_mask = cpus_allowed;
+			cpus_copy(new_mask, cpus_allowed);
 			goto again;
 		}
 	}
@@ -5474,12 +5477,12 @@ out_unlock:
 }
 
 static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, unsigned len,
-			     cpumask_t *new_mask)
+			     cpumask_t new_mask)
 {
-	if (len < sizeof(cpumask_t)) {
-		memset(new_mask, 0, sizeof(cpumask_t));
-	} else if (len > sizeof(cpumask_t)) {
-		len = sizeof(cpumask_t);
+	if (len < cpumask_size()) {
+		memset(new_mask, 0, cpumask_size());
+	} else if (len > cpumask_size()) {
+		len = cpumask_size();
 	}
 	return copy_from_user(new_mask, user_mask_ptr, len) ? -EFAULT : 0;
 }
@@ -5493,17 +5496,17 @@ static int get_user_cpu_mask(unsigned lo
 asmlinkage long sys_sched_setaffinity(pid_t pid, unsigned int len,
 				      unsigned long __user *user_mask_ptr)
 {
-	cpumask_t new_mask;
+	cpumask_var_t new_mask;
 	int retval;
 
-	retval = get_user_cpu_mask(user_mask_ptr, len, &new_mask);
+	retval = get_user_cpu_mask(user_mask_ptr, len, new_mask);
 	if (retval)
 		return retval;
 
-	return sched_setaffinity(pid, &new_mask);
+	return sched_setaffinity(pid, new_mask);
 }
 
-long sched_getaffinity(pid_t pid, cpumask_t *mask)
+long sched_getaffinity(pid_t pid, cpumask_t mask)
 {
 	struct task_struct *p;
 	int retval;
@@ -5520,7 +5523,7 @@ long sched_getaffinity(pid_t pid, cpumas
 	if (retval)
 		goto out_unlock;
 
-	cpus_and(*mask, p->cpus_allowed, cpu_online_map);
+	cpus_and(mask, p->cpus_allowed, cpu_online_map);
 
 out_unlock:
 	read_unlock(&tasklist_lock);
@@ -5539,19 +5542,19 @@ asmlinkage long sys_sched_getaffinity(pi
 				      unsigned long __user *user_mask_ptr)
 {
 	int ret;
-	cpumask_t mask;
+	cpumask_var_t mask;
 
-	if (len < sizeof(cpumask_t))
+	if (len < cpumask_size())
 		return -EINVAL;
 
-	ret = sched_getaffinity(pid, &mask);
+	ret = sched_getaffinity(pid, mask);
 	if (ret < 0)
 		return ret;
 
-	if (copy_to_user(user_mask_ptr, &mask, sizeof(cpumask_t)))
+	if (copy_to_user(user_mask_ptr, mask, cpumask_size()))
 		return -EFAULT;
 
-	return sizeof(cpumask_t);
+	return cpumask_size();
 }
 
 /**
@@ -5886,7 +5889,7 @@ void __cpuinit init_idle(struct task_str
 	idle->se.exec_start = sched_clock();
 
 	idle->prio = idle->normal_prio = MAX_PRIO;
-	idle->cpus_allowed = cpumask_of_cpu(cpu);
+	cpus_copy(idle->cpus_allowed, cpumask_of_cpu(cpu));
 	__set_task_cpu(idle, cpu);
 
 	spin_lock_irqsave(&rq->lock, flags);
@@ -5915,7 +5918,7 @@ void __cpuinit init_idle(struct task_str
  * which do not switch off the HZ timer nohz_cpu_mask should
  * always be CPU_MASK_NONE.
  */
-cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
+cpumask_map_t nohz_cpu_mask = CPU_MASK_NONE;
 
 /*
  * Increase the granularity value when there are more CPUs,
@@ -5970,7 +5973,7 @@ static inline void sched_init_granularit
  * task must not exit() & deallocate itself prematurely. The
  * call is not atomic; no spinlocks may be held.
  */
-int set_cpus_allowed(struct task_struct *p, const cpumask_t new_mask)
+int set_cpus_allowed(struct task_struct *p, const_cpumask_t new_mask)
 {
 	struct migration_req req;
 	unsigned long flags;
@@ -5992,15 +5995,15 @@ int set_cpus_allowed(struct task_struct 
 	if (p->sched_class->set_cpus_allowed)
 		p->sched_class->set_cpus_allowed(p, new_mask);
 	else {
-		p->cpus_allowed = *new_mask;
-		p->rt.nr_cpus_allowed = cpus_weight(*new_mask);
+		cpus_copy(p->cpus_allowed, new_mask);
+		p->rt.nr_cpus_allowed = cpus_weight(new_mask);
 	}
 
 	/* Can the task run on the task's current CPU? If so, we're done */
-	if (cpu_isset(task_cpu(p), *new_mask))
+	if (cpu_isset(task_cpu(p), new_mask))
 		goto out;
 
-	if (migrate_task(p, any_online_cpu(*new_mask), &req)) {
+	if (migrate_task(p, any_online_cpu(new_mask), &req)) {
 		/* Need help from migration thread: drop lock and wait. */
 		task_rq_unlock(rq, &flags);
 		wake_up_process(rq->migration_thread);
@@ -6141,14 +6144,15 @@ static int __migrate_task_irq(struct tas
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	unsigned long flags;
-	cpumask_t mask;
+	cpumask_var_t mask;
 	struct rq *rq;
 	int dest_cpu;
+	cpumask_var_t cpus_allowed;
 
 	do {
 		/* On same node? */
-		mask = node_to_cpumask(cpu_to_node(dead_cpu);
-		cpus_and(mask, mask, p->cpus_allowed);
+		cpus_and(mask, node_to_cpumask(cpu_to_node(dead_cpu)),
+							p->cpus_allowed);
 		dest_cpu = any_online_cpu(mask);
 
 		/* On any allowed CPU? */
@@ -6157,9 +6161,7 @@ static void move_task_off_dead_cpu(int d
 
 		/* No more Mr. Nice Guy. */
 		if (dest_cpu >= nr_cpu_ids) {
-			cpumask_t cpus_allowed;
-
-			cpuset_cpus_allowed_locked(p, &cpus_allowed);
+			cpuset_cpus_allowed_locked(p, cpus_allowed);
 			/*
 			 * Try to stay on the same cpuset, where the
 			 * current cpuset may be a subset of all cpus.
@@ -6168,7 +6170,7 @@ static void move_task_off_dead_cpu(int d
 			 * called within calls to cpuset_lock/cpuset_unlock.
 			 */
 			rq = task_rq_lock(p, &flags);
-			p->cpus_allowed = cpus_allowed;
+			cpus_copy(p->cpus_allowed, cpus_allowed);
 			dest_cpu = any_online_cpu(p->cpus_allowed);
 			task_rq_unlock(rq, &flags);
 
@@ -6667,13 +6669,13 @@ static inline const char *sd_level_to_st
 }
 
 static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
-				  cpumask_t *groupmask)
+				  cpumask_t groupmask)
 {
 	struct sched_group *group = sd->groups;
 	char str[256];
 
 	cpulist_scnprintf(str, sizeof(str), sd->span);
-	cpus_clear(*groupmask);
+	cpus_clear(groupmask);
 
 	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
 
@@ -6718,13 +6720,13 @@ static int sched_domain_debug_one(struct
 			break;
 		}
 
-		if (cpus_intersects(*groupmask, group->cpumask)) {
+		if (cpus_intersects(groupmask, group->cpumask)) {
 			printk(KERN_CONT "\n");
 			printk(KERN_ERR "ERROR: repeated CPUs\n");
 			break;
 		}
 
-		cpus_or(*groupmask, *groupmask, group->cpumask);
+		cpus_or(groupmask, groupmask, group->cpumask);
 
 		cpulist_scnprintf(str, sizeof(str), group->cpumask);
 		printk(KERN_CONT " %s", str);
@@ -6733,10 +6735,10 @@ static int sched_domain_debug_one(struct
 	} while (group != sd->groups);
 	printk(KERN_CONT "\n");
 
-	if (!cpus_equal(sd->span, *groupmask))
+	if (!cpus_equal(sd->span, groupmask))
 		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
 
-	if (sd->parent && !cpus_subset(*groupmask, sd->parent->span))
+	if (sd->parent && !cpus_subset(groupmask, sd->parent->span))
 		printk(KERN_ERR "ERROR: parent span is not a superset "
 			"of domain->span\n");
 	return 0;
@@ -6744,7 +6746,7 @@ static int sched_domain_debug_one(struct
 
 static void sched_domain_debug(struct sched_domain *sd, int cpu)
 {
-	cpumask_t *groupmask;
+	cpumask_var_t groupmask;
 	int level = 0;
 
 	if (!sd) {
@@ -6754,8 +6756,7 @@ static void sched_domain_debug(struct sc
 
 	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
 
-	groupmask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
-	if (!groupmask) {
+	if (!cpumask_alloc(&groupmask)) {
 		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
 		return;
 	}
@@ -6768,7 +6769,7 @@ static void sched_domain_debug(struct sc
 		if (!sd)
 			break;
 	}
-	kfree(groupmask);
+	cpumask_free(&groupmask);
 }
 #else /* !CONFIG_SCHED_DEBUG */
 # define sched_domain_debug(sd, cpu) do { } while (0)
@@ -6921,7 +6922,7 @@ cpu_attach_domain(struct sched_domain *s
 }
 
 /* cpus with isolated domains */
-static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
+static cpumask_map_t cpu_isolated_map = CPU_MASK_NONE;
 
 /* Setup the mask of cpus configured for isolated domains */
 static int __init isolated_cpu_setup(char *str)
@@ -6950,33 +6951,33 @@ __setup("isolcpus=", isolated_cpu_setup)
  * and ->cpu_power to 0.
  */
 static void
-init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
-			int (*group_fn)(int cpu, const cpumask_t *cpu_map,
+init_sched_build_groups(const_cpumask_t span, const_cpumask_t cpu_map,
+			int (*group_fn)(int cpu, const_cpumask_t cpu_map,
 					struct sched_group **sg,
-					cpumask_t *tmpmask),
-			cpumask_t *covered, cpumask_t *tmpmask)
+					cpumask_t tmpmask),
+			cpumask_t covered, cpumask_t tmpmask)
 {
 	struct sched_group *first = NULL, *last = NULL;
 	int i;
 
-	cpus_clear(*covered);
+	cpus_clear(covered);
 
-	for_each_cpu(i, *span) {
+	for_each_cpu(i, span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
 
-		if (cpu_isset(i, *covered))
+		if (cpu_isset(i, covered))
 			continue;
 
 		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu(j, *span) {
+		for_each_cpu(j, span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
-			cpu_set(j, *covered);
+			cpu_set(j, covered);
 			cpu_set(j, sg->cpumask);
 		}
 		if (!first)
@@ -7041,23 +7042,23 @@ static int find_next_best_node(int node,
  * should be one that prevents unnecessary balancing, but also spreads tasks
  * out optimally.
  */
-static void sched_domain_node_span(int node, cpumask_t *span)
+static void sched_domain_node_span(int node, cpumask_t span)
 {
 	nodemask_t used_nodes;
-	const cpumask_t nodemask = node_to_cpumask(node);
+	const_cpumask_t nodemask = node_to_cpumask(node);
 	int i;
 
-	cpus_clear(*span);
+	cpus_clear(span);
 	nodes_clear(used_nodes);
 
-	cpus_or(*span, *span, *nodemask);
+	cpus_or(span, span, nodemask);
 	node_set(node, used_nodes);
 
 	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
 		int next_node = find_next_best_node(node, &used_nodes);
 
 		nodemask = node_to_cpumask(next_node);
-		cpus_or(*span, *span, *nodemask);
+		cpus_or(span, span, nodemask);
 	}
 }
 #endif /* CONFIG_NUMA */
@@ -7072,8 +7073,8 @@ static DEFINE_PER_CPU(struct sched_domai
 static DEFINE_PER_CPU(struct sched_group, sched_group_cpus);
 
 static int
-cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		 cpumask_t *unused)
+cpu_to_cpu_group(int cpu, const_cpumask_t cpu_map, struct sched_group **sg,
+		 cpumask_t unused)
 {
 	if (sg)
 		*sg = &per_cpu(sched_group_cpus, cpu);
@@ -7091,22 +7092,22 @@ static DEFINE_PER_CPU(struct sched_group
 
 #if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *mask)
+cpu_to_core_group(int cpu, const_cpumask_t cpu_map, struct sched_group **sg,
+		  cpumask_t mask)
 {
 	int group;
 
-	*mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(*mask, *mask, *cpu_map);
-	group = cpus_first(*mask);
+	cpus_copy(mask, per_cpu(cpu_sibling_map, cpu));
+	cpus_and(mask, mask, cpu_map);
+	group = cpus_first(mask);
 	if (sg)
 		*sg = &per_cpu(sched_group_core, group);
 	return group;
 }
 #elif defined(CONFIG_SCHED_MC)
 static int
-cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *unused)
+cpu_to_core_group(int cpu, const_cpumask_t cpu_map, struct sched_group **sg,
+		  cpumask_t unused)
 {
 	if (sg)
 		*sg = &per_cpu(sched_group_core, cpu);
@@ -7118,18 +7119,16 @@ static DEFINE_PER_CPU(struct sched_domai
 static DEFINE_PER_CPU(struct sched_group, sched_group_phys);
 
 static int
-cpu_to_phys_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
-		  cpumask_t *mask)
+cpu_to_phys_group(int cpu, const_cpumask_t cpu_map, struct sched_group **sg,
+		  cpumask_t mask)
 {
 	int group;
 #ifdef CONFIG_SCHED_MC
-	*mask = cpu_coregroup_map(cpu);
-	cpus_and(*mask, *mask, *cpu_map);
-	group = cpus_first(*mask);
+	cpus_and(mask, cpu_coregroup_map(cpu), cpu_map);
+	group = cpus_first(mask);
 #elif defined(CONFIG_SCHED_SMT)
-	*mask = per_cpu(cpu_sibling_map, cpu);
-	cpus_and(*mask, *mask, *cpu_map);
-	group = cpus_first(*mask);
+	cpus_and(mask, per_cpu(cpu_sibling_map, cpu), cpu_map);
+	group = cpus_first(mask);
 #else
 	group = cpu;
 #endif
@@ -7150,14 +7149,13 @@ static struct sched_group ***sched_group
 static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
 static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
 
-static int cpu_to_allnodes_group(int cpu, const cpumask_t *cpu_map,
-				 struct sched_group **sg, cpumask_t *nodemask)
+static int cpu_to_allnodes_group(int cpu, const_cpumask_t cpu_map,
+				 struct sched_group **sg, cpumask_t nodemask)
 {
 	int group;
 
-	nodemask = node_to_cpumask(cpu_to_node(cpu));
-	cpus_and(*nodemask, *nodemask, *cpu_map);
-	group = cpus_first(*nodemask);
+	cpus_and(nodemask, node_to_cpumask(cpu_to_node(cpu)), cpu_map);
+	group = cpus_first(nodemask);
 
 	if (sg)
 		*sg = &per_cpu(sched_group_allnodes, group);
@@ -7193,11 +7191,11 @@ static void init_numa_sched_groups_power
 
 #ifdef CONFIG_NUMA
 /* Free memory allocated for various sched_group structures */
-static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+static void free_sched_groups(const_cpumask_t cpu_map, cpumask_t nodemask)
 {
 	int cpu, i;
 
-	for_each_cpu(cpu, *cpu_map) {
+	for_each_cpu(cpu, cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7207,9 +7205,8 @@ static void free_sched_groups(const cpum
 		for (i = 0; i < nr_node_ids; i++) {
 			struct sched_group *oldsg, *sg = sched_group_nodes[i];
 
-			*nodemask = node_to_cpumask(i);
-			cpus_and(*nodemask, *nodemask, *cpu_map);
-			if (cpus_empty(*nodemask))
+			cpus_and(nodemask, node_to_cpumask(i), cpu_map);
+			if (cpus_empty(nodemask))
 				continue;
 
 			if (sg == NULL)
@@ -7227,7 +7224,7 @@ next_sg:
 	}
 }
 #else /* !CONFIG_NUMA */
-static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+static void free_sched_groups(const_cpumask_t cpu_map, cpumask_t nodemask)
 {
 }
 #endif /* CONFIG_NUMA */
@@ -7316,34 +7313,21 @@ SD_INIT_FUNC(CPU)
  * if the amount of space is significant.
  */
 struct allmasks {
-	cpumask_t tmpmask;			/* make this one first */
+	cpumask_map_t tmpmask;			/* make this one first */
 	union {
-		cpumask_t nodemask;
-		cpumask_t this_sibling_map;
-		cpumask_t this_core_map;
+		cpumask_map_t nodemask;
+		cpumask_map_t this_sibling_map;
+		cpumask_map_t this_core_map;
 	};
-	cpumask_t send_covered;
+	cpumask_map_t send_covered;
 
 #ifdef CONFIG_NUMA
-	cpumask_t domainspan;
-	cpumask_t covered;
-	cpumask_t notcovered;
+	cpumask_map_t domainspan;
+	cpumask_map_t covered;
+	cpumask_map_t notcovered;
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
@@ -7383,17 +7367,23 @@ static void set_domain_attribute(struct 
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
  */
-static int __build_sched_domains(const cpumask_t *cpu_map,
+static int __build_sched_domains(const_cpumask_t cpu_map,
 				 struct sched_domain_attr *attr)
 {
 	int i;
 	struct root_domain *rd;
-	SCHED_CPUMASK_DECLARE(allmasks);
-	cpumask_t *tmpmask;
+	CPUMASK_ALLOC(allmasks);
+ 	CPUMASK_PTR(tmpmask, allmasks);
 #ifdef CONFIG_NUMA
 	struct sched_group **sched_group_nodes = NULL;
 	int sd_allnodes = 0;
 
+	/* check if scratch cpumask space gotten */
+	if (!allmasks) {
+		printk(KERN_WARNING "Cannot alloc cpumask array\n");
+		return -ENOMEM;
+	}
+
 	/*
 	 * Allocate the per-node list of sched groups
 	 */
@@ -7401,6 +7391,7 @@ static int __build_sched_domains(const c
 				    GFP_KERNEL);
 	if (!sched_group_nodes) {
 		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		CPUMASK_FREE(allmasks);
 		return -ENOMEM;
 	}
 #endif
@@ -7411,45 +7402,30 @@ static int __build_sched_domains(const c
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
-		printk(KERN_WARNING "Cannot alloc cpumask array\n");
-		kfree(rd);
-#ifdef CONFIG_NUMA
-		kfree(sched_group_nodes);
-#endif
-		return -ENOMEM;
-	}
-#endif
-	tmpmask = (cpumask_t *)allmasks;
-
-
 #ifdef CONFIG_NUMA
-	sched_group_nodes_bycpu[cpus_first(*cpu_map)] = sched_group_nodes;
+	sched_group_nodes_bycpu[cpus_first(cpu_map)] = sched_group_nodes;
 #endif
 
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = NULL, *p;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
 
-		*nodemask = node_to_cpumask(cpu_to_node(i));
-		cpus_and(*nodemask, *nodemask, *cpu_map);
+		cpus_and(nodemask, node_to_cpumask(cpu_to_node(i)), cpu_map);
 
 #ifdef CONFIG_NUMA
-		if (cpus_weight(*cpu_map) >
-				SD_NODES_PER_DOMAIN*cpus_weight(*nodemask)) {
+		if (cpus_weight(cpu_map) >
+				SD_NODES_PER_DOMAIN*cpus_weight(nodemask)) {
 			sd = &per_cpu(allnodes_domains, i);
 			SD_INIT(sd, ALLNODES);
 			set_domain_attribute(sd, attr);
-			sd->span = *cpu_map;
+			cpus_copy(sd->span, cpu_map);
 			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
 			p = sd;
 			sd_allnodes = 1;
@@ -7459,18 +7435,18 @@ static int __build_sched_domains(const c
 		sd = &per_cpu(node_domains, i);
 		SD_INIT(sd, NODE);
 		set_domain_attribute(sd, attr);
-		sched_domain_node_span(cpu_to_node(i), &sd->span);
+		sched_domain_node_span(cpu_to_node(i), sd->span);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
-		cpus_and(sd->span, sd->span, *cpu_map);
+		cpus_and(sd->span, sd->span, cpu_map);
 #endif
 
 		p = sd;
 		sd = &per_cpu(phys_domains, i);
 		SD_INIT(sd, CPU);
 		set_domain_attribute(sd, attr);
-		sd->span = *nodemask;
+		cpus_copy(sd->span, nodemask);
 		sd->parent = p;
 		if (p)
 			p->child = sd;
@@ -7481,8 +7457,7 @@ static int __build_sched_domains(const c
 		sd = &per_cpu(core_domains, i);
 		SD_INIT(sd, MC);
 		set_domain_attribute(sd, attr);
-		sd->span = cpu_coregroup_map(i);
-		cpus_and(sd->span, sd->span, *cpu_map);
+		cpus_and(sd->span, cpu_coregroup_map(i), cpu_map);
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7493,8 +7468,7 @@ static int __build_sched_domains(const c
 		sd = &per_cpu(cpu_domains, i);
 		SD_INIT(sd, SIBLING);
 		set_domain_attribute(sd, attr);
-		sd->span = per_cpu(cpu_sibling_map, i);
-		cpus_and(sd->span, sd->span, *cpu_map);
+		cpus_and(sd->span, per_cpu(cpu_sibling_map, i), cpu_map);
 		sd->parent = p;
 		p->child = sd;
 		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
@@ -7503,13 +7477,13 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
-		*this_sibling_map = per_cpu(cpu_sibling_map, i);
-		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
-		if (i != cpus_first(*this_sibling_map))
+	for_each_cpu(i, cpu_map) {
+		CPUMASK_PTR(this_sibling_map, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
+
+		cpus_and(this_sibling_map, per_cpu(cpu_sibling_map, i),
+								cpu_map);
+		if (i != cpus_first(this_sibling_map))
 			continue;
 
 		init_sched_build_groups(this_sibling_map, cpu_map,
@@ -7520,13 +7494,12 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu(i, *cpu_map) {
-		SCHED_CPUMASK_VAR(this_core_map, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
-
-		*this_core_map = cpu_coregroup_map(i);
-		cpus_and(*this_core_map, *this_core_map, *cpu_map);
-		if (i != cpus_first(*this_core_map))
+	for_each_cpu(i, cpu_map) {
+		CPUMASK_PTR(this_core_map, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
+
+		cpus_and(this_core_map, cpu_coregroup_map(i), cpu_map);
+		if (i != cpus_first(this_core_map))
 			continue;
 
 		init_sched_build_groups(this_core_map, cpu_map,
@@ -7537,12 +7510,11 @@ static int __build_sched_domains(const c
 
 	/* Set up physical groups */
 	for (i = 0; i < nr_node_ids; i++) {
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
-		*nodemask = node_to_cpumask(i);
-		cpus_and(*nodemask, *nodemask, *cpu_map);
-		if (cpus_empty(*nodemask))
+		cpus_and(nodemask, node_to_cpumask(i), cpu_map);
+		if (cpus_empty(nodemask))
 			continue;
 
 		init_sched_build_groups(nodemask, cpu_map,
@@ -7553,7 +7525,7 @@ static int __build_sched_domains(const c
 #ifdef CONFIG_NUMA
 	/* Set up node groups */
 	if (sd_allnodes) {
-		SCHED_CPUMASK_VAR(send_covered, allmasks);
+		CPUMASK_PTR(send_covered, allmasks);
 
 		init_sched_build_groups(cpu_map, cpu_map,
 					&cpu_to_allnodes_group,
@@ -7563,22 +7535,21 @@ static int __build_sched_domains(const c
 	for (i = 0; i < nr_node_ids; i++) {
 		/* Set up node groups */
 		struct sched_group *sg, *prev;
-		SCHED_CPUMASK_VAR(nodemask, allmasks);
-		SCHED_CPUMASK_VAR(domainspan, allmasks);
-		SCHED_CPUMASK_VAR(covered, allmasks);
+		CPUMASK_PTR(nodemask, allmasks);
+		CPUMASK_PTR(domainspan, allmasks);
+		CPUMASK_PTR(covered, allmasks);
 		int j;
 
-		*nodemask = node_to_cpumask(i);
-		cpus_clear(*covered);
+		cpus_clear(covered);
 
-		cpus_and(*nodemask, *nodemask, *cpu_map);
-		if (cpus_empty(*nodemask)) {
+		cpus_and(nodemask, node_to_cpumask(i), cpu_map);
+		if (cpus_empty(nodemask)) {
 			sched_group_nodes[i] = NULL;
 			continue;
 		}
 
 		sched_domain_node_span(i, domainspan);
-		cpus_and(*domainspan, *domainspan, *cpu_map);
+		cpus_and(domainspan, domainspan, cpu_map);
 
 		sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
 		if (!sg) {
@@ -7587,31 +7558,30 @@ static int __build_sched_domains(const c
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu(j, *nodemask) {
+		for_each_cpu(j, nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
 			sd->groups = sg;
 		}
 		sg->__cpu_power = 0;
-		sg->cpumask = *nodemask;
+		cpus_copy(sg->cpumask, nodemask);
 		sg->next = sg;
-		cpus_or(*covered, *covered, *nodemask);
+		cpus_or(covered, covered, nodemask);
 		prev = sg;
 
 		for (j = 0; j < nr_node_ids; j++) {
-			SCHED_CPUMASK_VAR(notcovered, allmasks);
+			CPUMASK_PTR(notcovered, allmasks);
 			int n = (i + j) % nr_node_ids;
-			const cpumask_t pnodemask = node_to_cpumask(n);
 
-			cpus_complement(*notcovered, *covered);
-			cpus_and(*tmpmask, *notcovered, *cpu_map);
-			cpus_and(*tmpmask, *tmpmask, *domainspan);
-			if (cpus_empty(*tmpmask))
+			cpus_complement(notcovered, covered);
+			cpus_and(tmpmask, notcovered, cpu_map);
+			cpus_and(tmpmask, tmpmask, domainspan);
+			if (cpus_empty(tmpmask))
 				break;
 
-			cpus_and(*tmpmask, *tmpmask, *pnodemask);
-			if (cpus_empty(*tmpmask))
+			cpus_and(tmpmask, tmpmask, node_to_cpumask(n));
+			if (cpus_empty(tmpmask))
 				continue;
 
 			sg = kmalloc_node(sizeof(struct sched_group),
@@ -7622,9 +7592,9 @@ static int __build_sched_domains(const c
 				goto error;
 			}
 			sg->__cpu_power = 0;
-			sg->cpumask = *tmpmask;
+			cpus_copy(sg->cpumask, tmpmask);
 			sg->next = prev->next;
-			cpus_or(*covered, *covered, *tmpmask);
+			cpus_or(covered, covered, tmpmask);
 			prev->next = sg;
 			prev = sg;
 		}
@@ -7633,21 +7603,21 @@ static int __build_sched_domains(const c
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = &per_cpu(cpu_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = &per_cpu(core_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd = &per_cpu(phys_domains, i);
 
 		init_sched_groups_power(i, sd);
@@ -7660,14 +7630,14 @@ static int __build_sched_domains(const c
 	if (sd_allnodes) {
 		struct sched_group *sg;
 
-		cpu_to_allnodes_group(cpus_first(*cpu_map), cpu_map, &sg,
+		cpu_to_allnodes_group(cpus_first(cpu_map), cpu_map, &sg,
 								tmpmask);
 		init_numa_sched_groups_power(sg);
 	}
 #endif
 
 	/* Attach the domains */
-	for_each_cpu(i, *cpu_map) {
+	for_each_cpu(i, cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i);
@@ -7679,23 +7649,23 @@ static int __build_sched_domains(const c
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
 
-static int build_sched_domains(const cpumask_t *cpu_map)
+static int build_sched_domains(const_cpumask_t cpu_map)
 {
 	return __build_sched_domains(cpu_map, NULL);
 }
 
-static cpumask_t *doms_cur;	/* current sched domains */
+static cpumask_t doms_cur;	/* current sched domains */
 static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
 static struct sched_domain_attr *dattr_cur;
 				/* attribues of custom domains in 'doms_cur' */
@@ -7705,7 +7675,7 @@ static struct sched_domain_attr *dattr_c
  * cpumask_t) fails, then fallback to a single sched domain,
  * as determined by the single cpumask_t fallback_doms.
  */
-static cpumask_t fallback_doms;
+static cpumask_map_t fallback_doms;
 
 void __attribute__((weak)) arch_update_cpu_topology(void)
 {
@@ -7716,16 +7686,16 @@ void __attribute__((weak)) arch_update_c
  * For now this just excludes isolated cpus, but could be used to
  * exclude other special cases in the future.
  */
-static int arch_init_sched_domains(const cpumask_t *cpu_map)
+static int arch_init_sched_domains(const_cpumask_t cpu_map)
 {
 	int err;
 
 	arch_update_cpu_topology();
 	ndoms_cur = 1;
-	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	doms_cur = kmalloc(cpumask_size(), GFP_KERNEL);
 	if (!doms_cur)
-		doms_cur = &fallback_doms;
-	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+		doms_cur = fallback_doms;
+	cpus_andnot(doms_cur, cpu_map, cpu_isolated_map);
 	dattr_cur = NULL;
 	err = build_sched_domains(doms_cur);
 	register_sched_domain_sysctl();
@@ -7733,8 +7703,8 @@ static int arch_init_sched_domains(const
 	return err;
 }
 
-static void arch_destroy_sched_domains(const cpumask_t *cpu_map,
-				       cpumask_t *tmpmask)
+static void arch_destroy_sched_domains(const_cpumask_t cpu_map,
+				       cpumask_t tmpmask)
 {
 	free_sched_groups(cpu_map, tmpmask);
 }
@@ -7743,17 +7713,17 @@ static void arch_destroy_sched_domains(c
  * Detach sched domains from a group of cpus specified in cpu_map
  * These cpus will now be attached to the NULL domain
  */
-static void detach_destroy_domains(const cpumask_t *cpu_map)
+static void detach_destroy_domains(const_cpumask_t cpu_map)
 {
-	cpumask_t tmpmask;
+	cpumask_var_t tmpmask;
 	int i;
 
 	unregister_sched_domain_sysctl();
 
-	for_each_cpu(i, *cpu_map)
+	for_each_cpu(i, cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
-	arch_destroy_sched_domains(cpu_map, &tmpmask);
+	arch_destroy_sched_domains(cpu_map, tmpmask);
 }
 
 /* handle null as "default" */
@@ -7797,7 +7767,7 @@ static int dattrs_equal(struct sched_dom
  *
  * Call with hotplug lock held
  */
-void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+void partition_sched_domains(int ndoms_new, cpumask_t doms_new,
 			     struct sched_domain_attr *dattr_new)
 {
 	int i, j, n;
@@ -7812,7 +7782,7 @@ void partition_sched_domains(int ndoms_n
 	/* Destroy deleted domains */
 	for (i = 0; i < ndoms_cur; i++) {
 		for (j = 0; j < n; j++) {
-			if (cpus_equal(doms_cur[i], doms_new[j])
+			if (cpus_equal(&doms_cur[i], &doms_new[j])
 			    && dattrs_equal(dattr_cur, i, dattr_new, j))
 				goto match1;
 		}
@@ -7824,15 +7794,15 @@ match1:
 
 	if (doms_new == NULL) {
 		ndoms_cur = 0;
-		doms_new = &fallback_doms;
-		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		doms_new = fallback_doms;
+		cpus_andnot(doms_new, cpu_online_map, cpu_isolated_map);
 		dattr_new = NULL;
 	}
 
 	/* Build new domains */
 	for (i = 0; i < ndoms_new; i++) {
 		for (j = 0; j < ndoms_cur; j++) {
-			if (cpus_equal(doms_new[i], doms_cur[j])
+			if (cpus_equal(&doms_new[i], &doms_cur[j])
 			    && dattrs_equal(dattr_new, i, dattr_cur, j))
 				goto match2;
 		}
@@ -7844,7 +7814,7 @@ match2:
 	}
 
 	/* Remember the new sched domains */
-	if (doms_cur != &fallback_doms)
+	if (doms_cur != fallback_doms)
 		kfree(doms_cur);
 	kfree(dattr_cur);	/* kfree(NULL) is safe */
 	doms_cur = doms_new;
@@ -7984,7 +7954,7 @@ static int update_runtime(struct notifie
 
 void __init sched_init_smp(void)
 {
-	cpumask_t non_isolated_cpus;
+	cpumask_var_t non_isolated_cpus;
 
 #if defined(CONFIG_NUMA)
 	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
@@ -7993,7 +7963,7 @@ void __init sched_init_smp(void)
 #endif
 	get_online_cpus();
 	mutex_lock(&sched_domains_mutex);
-	arch_init_sched_domains(&cpu_online_map);
+	arch_init_sched_domains(cpu_online_map);
 	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
@@ -8011,7 +7981,7 @@ void __init sched_init_smp(void)
 	init_hrtick();
 
 	/* Move init over to a non-isolated CPU */
-	if (set_cpus_allowed(current, &non_isolated_cpus) < 0)
+	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
 		BUG();
 	sched_init_granularity();
 }
--- struct-cpumasks.orig/kernel/sched_cpupri.c
+++ struct-cpumasks/kernel/sched_cpupri.c
@@ -67,14 +67,14 @@ static int convert_prio(int prio)
  * Returns: (int)bool - CPUs were found
  */
 int cpupri_find(struct cpupri *cp, struct task_struct *p,
-		cpumask_t *lowest_mask)
+		cpumask_t lowest_mask)
 {
 	int                  idx      = 0;
 	int                  task_pri = convert_prio(p->prio);
 
 	for_each_cpupri_active(cp->pri_active, idx) {
 		struct cpupri_vec *vec  = &cp->pri_to_cpu[idx];
-		cpumask_t mask;
+		cpumask_var_t mask;
 
 		if (idx >= task_pri)
 			break;
@@ -84,7 +84,7 @@ int cpupri_find(struct cpupri *cp, struc
 		if (cpus_empty(mask))
 			continue;
 
-		*lowest_mask = mask;
+		cpus_copy(lowest_mask, mask);
 		return 1;
 	}
 
--- struct-cpumasks.orig/kernel/sched_cpupri.h
+++ struct-cpumasks/kernel/sched_cpupri.h
@@ -12,9 +12,9 @@
 /* values 2-101 are RT priorities 0-99 */
 
 struct cpupri_vec {
-	spinlock_t lock;
-	int        count;
-	cpumask_t  mask;
+	spinlock_t     lock;
+	int            count;
+	cpumask_map_t  mask;
 };
 
 struct cpupri {
@@ -25,7 +25,7 @@ struct cpupri {
 
 #ifdef CONFIG_SMP
 int  cpupri_find(struct cpupri *cp,
-		 struct task_struct *p, cpumask_t *lowest_mask);
+		 struct task_struct *p, cpumask_t lowest_mask);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
 void cpupri_init(struct cpupri *cp);
 #else
--- struct-cpumasks.orig/kernel/sched_fair.c
+++ struct-cpumasks/kernel/sched_fair.c
@@ -956,7 +956,7 @@ static void yield_task_fair(struct rq *r
 #if defined(ARCH_HAS_SCHED_WAKE_IDLE)
 static int wake_idle(int cpu, struct task_struct *p)
 {
-	cpumask_t tmp;
+	cpumask_var_t tmp;
 	struct sched_domain *sd;
 	int i;
 
--- struct-cpumasks.orig/kernel/sched_rt.c
+++ struct-cpumasks/kernel/sched_rt.c
@@ -139,14 +139,14 @@ static int rt_se_boosted(struct sched_rt
 }
 
 #ifdef CONFIG_SMP
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const_cpumask_t sched_rt_period_mask(void)
 {
-	return cpu_rq(smp_processor_id())->rd->span;
+	return (const_cpumask_t)cpu_rq(smp_processor_id())->rd->span;
 }
 #else
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const_cpumask_t sched_rt_period_mask(void)
 {
-	return cpu_online_map;
+	return (const_cpumask_t)cpu_online_map;
 }
 #endif
 
@@ -212,9 +212,9 @@ static inline int rt_rq_throttled(struct
 	return rt_rq->rt_throttled;
 }
 
-static inline cpumask_t sched_rt_period_mask(void)
+static inline const_cpumask_t sched_rt_period_mask(void)
 {
-	return cpu_online_map;
+	return (const_cpumask_t)cpu_online_map;
 }
 
 static inline
@@ -429,12 +429,12 @@ static inline int balance_runtime(struct
 static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 {
 	int i, idle = 1;
-	cpumask_t span;
+	cpumask_var_t span;
 
 	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
-	span = sched_rt_period_mask();
+	cpus_copy(span, sched_rt_period_mask());
 	for_each_cpu(i, span) {
 		int enqueue = 0;
 		struct rt_rq *rt_rq = sched_rt_period_rt_rq(rt_b, i);
@@ -805,16 +805,16 @@ static int select_task_rq_rt(struct task
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	cpumask_t mask;
+	cpumask_var_t mask;
 
 	if (rq->curr->rt.nr_cpus_allowed == 1)
 		return;
 
 	if (p->rt.nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, &mask))
+	    && cpupri_find(&rq->rd->cpupri, p, mask))
 		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
+	if (!cpupri_find(&rq->rd->cpupri, rq->curr, mask))
 		return;
 
 	/*
@@ -956,18 +956,18 @@ static struct task_struct *pick_next_hig
 	return next;
 }
 
-static DEFINE_PER_CPU(cpumask_t, local_cpu_mask);
+static DEFINE_PER_CPU(cpumask_map_t, local_cpu_mask);
 
-static inline int pick_optimal_cpu(int this_cpu, cpumask_t *mask)
+static inline int pick_optimal_cpu(int this_cpu, const_cpumask_t mask)
 {
 	int first;
 
 	/* "this_cpu" is cheaper to preempt than a remote processor */
-	if ((this_cpu != -1) && cpu_isset(this_cpu, *mask))
+	if ((this_cpu != -1) && cpu_isset(this_cpu, mask))
 		return this_cpu;
 
-	first = cpus_first(*mask);
-	if (first != NR_CPUS)
+	first = cpus_first(mask);
+	if (first != nr_cpu_ids)
 		return first;
 
 	return -1;
@@ -976,9 +976,10 @@ static inline int pick_optimal_cpu(int t
 static int find_lowest_rq(struct task_struct *task)
 {
 	struct sched_domain *sd;
-	cpumask_t *lowest_mask = &__get_cpu_var(local_cpu_mask);
+	cpumask_t lowest_mask = __get_cpu_var(local_cpu_mask);
 	int this_cpu = smp_processor_id();
 	int cpu      = task_cpu(task);
+	cpumask_var_t domain_mask;
 
 	if (task->rt.nr_cpus_allowed == 1)
 		return -1; /* No other targets possible */
@@ -991,7 +992,7 @@ static int find_lowest_rq(struct task_st
 	 * I guess we might want to change cpupri_find() to ignore those
 	 * in the first place.
 	 */
-	cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
+	cpus_and(lowest_mask, lowest_mask, cpu_active_map);
 
 	/*
 	 * At this point we have built a mask of cpus representing the
@@ -1001,7 +1002,7 @@ static int find_lowest_rq(struct task_st
 	 * We prioritize the last cpu that the task executed on since
 	 * it is most likely cache-hot in that location.
 	 */
-	if (cpu_isset(cpu, *lowest_mask))
+	if (cpu_isset(cpu, lowest_mask))
 		return cpu;
 
 	/*
@@ -1013,13 +1014,12 @@ static int find_lowest_rq(struct task_st
 
 	for_each_domain(cpu, sd) {
 		if (sd->flags & SD_WAKE_AFFINE) {
-			cpumask_t domain_mask;
 			int       best_cpu;
 
-			cpus_and(domain_mask, sd->span, *lowest_mask);
+			cpus_and(domain_mask, sd->span, lowest_mask);
 
 			best_cpu = pick_optimal_cpu(this_cpu,
-						    &domain_mask);
+						    domain_mask);
 			if (best_cpu != -1)
 				return best_cpu;
 		}
@@ -1308,9 +1308,9 @@ move_one_task_rt(struct rq *this_rq, int
 }
 
 static void set_cpus_allowed_rt(struct task_struct *p,
-				const cpumask_t *new_mask)
+				const_cpumask_t new_mask)
 {
-	int weight = cpus_weight(*new_mask);
+	int weight = cpus_weight(new_mask);
 
 	BUG_ON(!rt_task(p));
 
@@ -1331,7 +1331,7 @@ static void set_cpus_allowed_rt(struct t
 		update_rt_migration(rq);
 	}
 
-	p->cpus_allowed    = *new_mask;
+	cpus_copy(p->cpus_allowed, new_mask);
 	p->rt.nr_cpus_allowed = weight;
 }
 

-- 
