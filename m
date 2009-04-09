Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbZDIPm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbZDIPm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 11:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754274AbZDIPmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 11:42:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38981 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbZDIPmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 11:42:10 -0400
Date: Thu, 9 Apr 2009 17:41:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] scheduler fixes
Message-ID: <20090409154148.GA19921@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-fixes-for-linus

 Thanks,

	Ingo

------------------>
Bharata B Rao (2):
      cpuacct: make cpuacct hierarchy walk in cpuacct_charge() safe when rcupreempt is used -v2
      cpuacct: add per-cgroup utime/stime statistics

Gautham R Shenoy (1):
      sched: Print sched_group::__cpu_power in sched_domain_debug

Hidetoshi Seto (1):
      posixtimers, sched: Fix posix clock monotonicity

Ingo Molnar (1):
      sched: refresh MAINTAINERS entry

Nathan Lynch (1):
      sched: do not count frozen tasks toward load

Rusty Russell (1):
      sched_rt: don't allocate cpumask in fastpath


 Documentation/cgroups/cpuacct.txt |   18 ++++
 MAINTAINERS                       |    4 +-
 include/linux/sched.h             |    3 +-
 kernel/posix-cpu-timers.c         |    7 +-
 kernel/sched.c                    |  160 +++++++++++++++++++++++++++++++++----
 kernel/sched_cpupri.c             |    5 +-
 kernel/sched_rt.c                 |   15 +---
 7 files changed, 178 insertions(+), 34 deletions(-)

diff --git a/Documentation/cgroups/cpuacct.txt b/Documentation/cgroups/cpuacct.txt
index bb775fb..8b93094 100644
--- a/Documentation/cgroups/cpuacct.txt
+++ b/Documentation/cgroups/cpuacct.txt
@@ -30,3 +30,21 @@ The above steps create a new group g1 and move the current shell
 process (bash) into it. CPU time consumed by this bash and its children
 can be obtained from g1/cpuacct.usage and the same is accumulated in
 /cgroups/cpuacct.usage also.
+
+cpuacct.stat file lists a few statistics which further divide the
+CPU time obtained by the cgroup into user and system times. Currently
+the following statistics are supported:
+
+user: Time spent by tasks of the cgroup in user mode.
+system: Time spent by tasks of the cgroup in kernel mode.
+
+user and system are in USER_HZ unit.
+
+cpuacct controller uses percpu_counter interface to collect user and
+system times. This has two side effects:
+
+- It is theoretically possible to see wrong values for user and system times.
+  This is because percpu_counter_read() on 32bit systems isn't safe
+  against concurrent writes.
+- It is possible to see slightly outdated values for user and system times
+  due to the batch processing nature of percpu_counter.
diff --git a/MAINTAINERS b/MAINTAINERS
index c3b2159..718b50a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3873,8 +3873,8 @@ S:	Maintained
 SCHEDULER
 P:	Ingo Molnar
 M:	mingo@elte.hu
-P:	Robert Love    [the preemptible kernel bits]
-M:	rml@tech9.net
+P:	Peter Zijlstra
+M:	peterz@infradead.org
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 98e1fe5..b4c38bc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -205,7 +205,8 @@ extern unsigned long long time_sync_thresh;
 #define task_is_stopped_or_traced(task)	\
 			((task->state & (__TASK_STOPPED | __TASK_TRACED)) != 0)
 #define task_contributes_to_load(task)	\
-				((task->state & TASK_UNINTERRUPTIBLE) != 0)
+				((task->state & TASK_UNINTERRUPTIBLE) != 0 && \
+				 (task->flags & PF_FROZEN) == 0)
 
 #define __set_task_state(tsk, state_value)		\
 	do { (tsk)->state = (state_value); } while (0)
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 8e5d9a6..6f7b869 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -224,7 +224,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 		cpu->cpu = virt_ticks(p);
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = p->se.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = task_sched_runtime(p);
 		break;
 	}
 	return 0;
@@ -305,18 +305,19 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 {
 	struct task_cputime cputime;
 
-	thread_group_cputime(p, &cputime);
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
 		return -EINVAL;
 	case CPUCLOCK_PROF:
+		thread_group_cputime(p, &cputime);
 		cpu->cpu = cputime_add(cputime.utime, cputime.stime);
 		break;
 	case CPUCLOCK_VIRT:
+		thread_group_cputime(p, &cputime);
 		cpu->cpu = cputime.utime;
 		break;
 	case CPUCLOCK_SCHED:
-		cpu->sched = cputime.sum_exec_runtime + task_delta_exec(p);
+		cpu->sched = thread_group_sched_runtime(p);
 		break;
 	}
 	return 0;
diff --git a/kernel/sched.c b/kernel/sched.c
index 6cc1fd5..5724508 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1418,10 +1418,22 @@ iter_move_one_task(struct rq *this_rq, int this_cpu, struct rq *busiest,
 		   struct rq_iterator *iterator);
 #endif
 
+/* Time spent by the tasks of the cpu accounting group executing in ... */
+enum cpuacct_stat_index {
+	CPUACCT_STAT_USER,	/* ... user mode */
+	CPUACCT_STAT_SYSTEM,	/* ... kernel mode */
+
+	CPUACCT_STAT_NSTATS,
+};
+
 #ifdef CONFIG_CGROUP_CPUACCT
 static void cpuacct_charge(struct task_struct *tsk, u64 cputime);
+static void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, cputime_t val);
 #else
 static inline void cpuacct_charge(struct task_struct *tsk, u64 cputime) {}
+static inline void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, cputime_t val) {}
 #endif
 
 static inline void inc_cpu_load(struct rq *rq, unsigned long load)
@@ -4511,9 +4523,25 @@ DEFINE_PER_CPU(struct kernel_stat, kstat);
 EXPORT_PER_CPU_SYMBOL(kstat);
 
 /*
- * Return any ns on the sched_clock that have not yet been banked in
+ * Return any ns on the sched_clock that have not yet been accounted in
  * @p in case that task is currently running.
+ *
+ * Called with task_rq_lock() held on @rq.
  */
+static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
+{
+	u64 ns = 0;
+
+	if (task_current(rq, p)) {
+		update_rq_clock(rq);
+		ns = rq->clock - p->se.exec_start;
+		if ((s64)ns < 0)
+			ns = 0;
+	}
+
+	return ns;
+}
+
 unsigned long long task_delta_exec(struct task_struct *p)
 {
 	unsigned long flags;
@@ -4521,16 +4549,49 @@ unsigned long long task_delta_exec(struct task_struct *p)
 	u64 ns = 0;
 
 	rq = task_rq_lock(p, &flags);
+	ns = do_task_delta_exec(p, rq);
+	task_rq_unlock(rq, &flags);
 
-	if (task_current(rq, p)) {
-		u64 delta_exec;
+	return ns;
+}
 
-		update_rq_clock(rq);
-		delta_exec = rq->clock - p->se.exec_start;
-		if ((s64)delta_exec > 0)
-			ns = delta_exec;
-	}
+/*
+ * Return accounted runtime for the task.
+ * In case the task is currently running, return the runtime plus current's
+ * pending runtime that have not been accounted yet.
+ */
+unsigned long long task_sched_runtime(struct task_struct *p)
+{
+	unsigned long flags;
+	struct rq *rq;
+	u64 ns = 0;
+
+	rq = task_rq_lock(p, &flags);
+	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	task_rq_unlock(rq, &flags);
+
+	return ns;
+}
+
+/*
+ * Return sum_exec_runtime for the thread group.
+ * In case the task is currently running, return the sum plus current's
+ * pending runtime that have not been accounted yet.
+ *
+ * Note that the thread group might have other running tasks as well,
+ * so the return value not includes other pending runtime that other
+ * running tasks might have.
+ */
+unsigned long long thread_group_sched_runtime(struct task_struct *p)
+{
+	struct task_cputime totals;
+	unsigned long flags;
+	struct rq *rq;
+	u64 ns;
 
+	rq = task_rq_lock(p, &flags);
+	thread_group_cputime(p, &totals);
+	ns = totals.sum_exec_runtime + do_task_delta_exec(p, rq);
 	task_rq_unlock(rq, &flags);
 
 	return ns;
@@ -4559,6 +4620,8 @@ void account_user_time(struct task_struct *p, cputime_t cputime,
 		cpustat->nice = cputime64_add(cpustat->nice, tmp);
 	else
 		cpustat->user = cputime64_add(cpustat->user, tmp);
+
+	cpuacct_update_stats(p, CPUACCT_STAT_USER, cputime);
 	/* Account for user time used */
 	acct_update_integrals(p);
 }
@@ -4620,6 +4683,8 @@ void account_system_time(struct task_struct *p, int hardirq_offset,
 	else
 		cpustat->system = cputime64_add(cpustat->system, tmp);
 
+	cpuacct_update_stats(p, CPUACCT_STAT_SYSTEM, cputime);
+
 	/* Account for system time used */
 	acct_update_integrals(p);
 }
@@ -7302,7 +7367,8 @@ static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
 		cpumask_or(groupmask, groupmask, sched_group_cpus(group));
 
 		cpulist_scnprintf(str, sizeof(str), sched_group_cpus(group));
-		printk(KERN_CONT " %s", str);
+		printk(KERN_CONT " %s (__cpu_power = %d)", str,
+						group->__cpu_power);
 
 		group = group->next;
 	} while (group != sd->groups);
@@ -9925,6 +9991,7 @@ struct cpuacct {
 	struct cgroup_subsys_state css;
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 *cpuusage;
+	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
 	struct cpuacct *parent;
 };
 
@@ -9949,20 +10016,32 @@ static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
+	int i;
 
 	if (!ca)
-		return ERR_PTR(-ENOMEM);
+		goto out;
 
 	ca->cpuusage = alloc_percpu(u64);
-	if (!ca->cpuusage) {
-		kfree(ca);
-		return ERR_PTR(-ENOMEM);
-	}
+	if (!ca->cpuusage)
+		goto out_free_ca;
+
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+		if (percpu_counter_init(&ca->cpustat[i], 0))
+			goto out_free_counters;
 
 	if (cgrp->parent)
 		ca->parent = cgroup_ca(cgrp->parent);
 
 	return &ca->css;
+
+out_free_counters:
+	while (--i >= 0)
+		percpu_counter_destroy(&ca->cpustat[i]);
+	free_percpu(ca->cpuusage);
+out_free_ca:
+	kfree(ca);
+out:
+	return ERR_PTR(-ENOMEM);
 }
 
 /* destroy an existing cpu accounting group */
@@ -9970,7 +10049,10 @@ static void
 cpuacct_destroy(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	struct cpuacct *ca = cgroup_ca(cgrp);
+	int i;
 
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++)
+		percpu_counter_destroy(&ca->cpustat[i]);
 	free_percpu(ca->cpuusage);
 	kfree(ca);
 }
@@ -10057,6 +10139,25 @@ static int cpuacct_percpu_seq_read(struct cgroup *cgroup, struct cftype *cft,
 	return 0;
 }
 
+static const char *cpuacct_stat_desc[] = {
+	[CPUACCT_STAT_USER] = "user",
+	[CPUACCT_STAT_SYSTEM] = "system",
+};
+
+static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
+		struct cgroup_map_cb *cb)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int i;
+
+	for (i = 0; i < CPUACCT_STAT_NSTATS; i++) {
+		s64 val = percpu_counter_read(&ca->cpustat[i]);
+		val = cputime64_to_clock_t(val);
+		cb->fill(cb, cpuacct_stat_desc[i], val);
+	}
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -10067,7 +10168,10 @@ static struct cftype files[] = {
 		.name = "usage_percpu",
 		.read_seq_string = cpuacct_percpu_seq_read,
 	},
-
+	{
+		.name = "stat",
+		.read_map = cpuacct_stats_show,
+	},
 };
 
 static int cpuacct_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -10089,12 +10193,38 @@ static void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 		return;
 
 	cpu = task_cpu(tsk);
+
+	rcu_read_lock();
+
 	ca = task_ca(tsk);
 
 	for (; ca; ca = ca->parent) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
+
+	rcu_read_unlock();
+}
+
+/*
+ * Charge the system/user time to the task's accounting group.
+ */
+static void cpuacct_update_stats(struct task_struct *tsk,
+		enum cpuacct_stat_index idx, cputime_t val)
+{
+	struct cpuacct *ca;
+
+	if (unlikely(!cpuacct_subsys.active))
+		return;
+
+	rcu_read_lock();
+	ca = task_ca(tsk);
+
+	do {
+		percpu_counter_add(&ca->cpustat[idx], val);
+		ca = ca->parent;
+	} while (ca);
+	rcu_read_unlock();
 }
 
 struct cgroup_subsys cpuacct_subsys = {
diff --git a/kernel/sched_cpupri.c b/kernel/sched_cpupri.c
index 1e00bfa..cdd3c89 100644
--- a/kernel/sched_cpupri.c
+++ b/kernel/sched_cpupri.c
@@ -55,7 +55,7 @@ static int convert_prio(int prio)
  * cpupri_find - find the best (lowest-pri) CPU in the system
  * @cp: The cpupri context
  * @p: The task
- * @lowest_mask: A mask to fill in with selected CPUs
+ * @lowest_mask: A mask to fill in with selected CPUs (or NULL)
  *
  * Note: This function returns the recommended CPUs as calculated during the
  * current invokation.  By the time the call returns, the CPUs may have in
@@ -81,7 +81,8 @@ int cpupri_find(struct cpupri *cp, struct task_struct *p,
 		if (cpumask_any_and(&p->cpus_allowed, vec->mask) >= nr_cpu_ids)
 			continue;
 
-		cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
+		if (lowest_mask)
+			cpumask_and(lowest_mask, &p->cpus_allowed, vec->mask);
 		return 1;
 	}
 
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 299d012..f2c66f8 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -948,20 +948,15 @@ static int select_task_rq_rt(struct task_struct *p, int sync)
 
 static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 {
-	cpumask_var_t mask;
-
 	if (rq->curr->rt.nr_cpus_allowed == 1)
 		return;
 
-	if (!alloc_cpumask_var(&mask, GFP_ATOMIC))
-		return;
-
 	if (p->rt.nr_cpus_allowed != 1
-	    && cpupri_find(&rq->rd->cpupri, p, mask))
-		goto free;
+	    && cpupri_find(&rq->rd->cpupri, p, NULL))
+		return;
 
-	if (!cpupri_find(&rq->rd->cpupri, rq->curr, mask))
-		goto free;
+	if (!cpupri_find(&rq->rd->cpupri, rq->curr, NULL))
+		return;
 
 	/*
 	 * There appears to be other cpus that can accept
@@ -970,8 +965,6 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 	 */
 	requeue_task_rt(rq, p, 1);
 	resched_task(rq->curr);
-free:
-	free_cpumask_var(mask);
 }
 
 #endif /* CONFIG_SMP */
