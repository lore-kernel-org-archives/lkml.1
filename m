Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbZFJVGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbZFJVGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762192AbZFJVFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:05:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36879 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762174AbZFJVFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:05:48 -0400
Date: Wed, 10 Jun 2009 23:05:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] sched/core updates for v2.6.31
Message-ID: <20090610210537.GA14847@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

 Thanks,

	Ingo

------------------>
David Rientjes (1):
      sched: emit thread info flags with stack trace

Gautham R Shenoy (3):
      sched: Nominate idle load balancer from a semi-idle package.
      sched: Nominate a power-efficient ilb in select_nohz_balancer()
      sched: Replace first_cpu() with cpumask_first() in ILB nomination code

GeunSik Lim (2):
      ftrace: fix typo about map of kernel priority in ftrace.txt file.
      sched: fix typo in sched-rt-group.txt file

Ingo Molnar (1):
      sched: properly define the sched_group::cpumask and sched_domain::span fields

Johannes Weiner (1):
      wait: don't use __wake_up_common()

Miao Xie (1):
      sched: use group_first_cpu() instead of cpumask_first(sched_group_cpus())

Paul Turner (1):
      sched: remove redundant hierarchy walk in check_preempt_wakeup

Peter Zijlstra (2):
      sched: remove extra call overhead for schedule()
      sched: rt: document the risk of small values in the bandwidth settings

Thomas Gleixner (2):
      sched, timers: move calc_load() to scheduler
      sched, timers: cleanup avenrun users

Vaidyanathan Srinivasan (1):
      sched: Don't export sched_mc_power_savings on multi-socket single core system


 Documentation/scheduler/sched-rt-group.txt |   20 ++-
 Documentation/trace/ftrace.txt             |   15 ++-
 arch/x86/include/asm/topology.h            |    3 +-
 fs/proc/loadavg.c                          |   18 +--
 include/linux/sched.h                      |   28 +++-
 include/linux/wait.h                       |    2 -
 kernel/mutex.c                             |    4 +-
 kernel/sched.c                             |  279 ++++++++++++++++++++++++----
 kernel/sched_fair.c                        |   13 +-
 kernel/sched_idletask.c                    |    3 +-
 kernel/time/timekeeping.c                  |    2 +-
 kernel/timer.c                             |   86 +--------
 kernel/wait.c                              |    2 +-
 13 files changed, 325 insertions(+), 150 deletions(-)

diff --git a/Documentation/scheduler/sched-rt-group.txt b/Documentation/scheduler/sched-rt-group.txt
index 5ba4d3f..1df7f9c 100644
--- a/Documentation/scheduler/sched-rt-group.txt
+++ b/Documentation/scheduler/sched-rt-group.txt
@@ -4,6 +4,7 @@
 CONTENTS
 ========
 
+0. WARNING
 1. Overview
   1.1 The problem
   1.2 The solution
@@ -14,6 +15,23 @@ CONTENTS
 3. Future plans
 
 
+0. WARNING
+==========
+
+ Fiddling with these settings can result in an unstable system, the knobs are
+ root only and assumes root knows what he is doing.
+
+Most notable:
+
+ * very small values in sched_rt_period_us can result in an unstable
+   system when the period is smaller than either the available hrtimer
+   resolution, or the time it takes to handle the budget refresh itself.
+
+ * very small values in sched_rt_runtime_us can result in an unstable
+   system when the runtime is so small the system has difficulty making
+   forward progress (NOTE: the migration thread and kstopmachine both
+   are real-time processes).
+
 1. Overview
 ===========
 
@@ -169,7 +187,7 @@ get their allocated time.
 
 Implementing SCHED_EDF might take a while to complete. Priority Inheritance is
 the biggest challenge as the current linux PI infrastructure is geared towards
-the limited static priority levels 0-139. With deadline scheduling you need to
+the limited static priority levels 0-99. With deadline scheduling you need to
 do deadline inheritance (since priority is inversely proportional to the
 deadline delta (deadline - now).
 
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index fd9a3e6..e362f50 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -518,9 +518,18 @@ priority with zero (0) being the highest priority and the nice
 values starting at 100 (nice -20). Below is a quick chart to map
 the kernel priority to user land priorities.
 
-  Kernel priority: 0 to 99    ==> user RT priority 99 to 0
-  Kernel priority: 100 to 139 ==> user nice -20 to 19
-  Kernel priority: 140        ==> idle task priority
+   Kernel Space                     User Space
+ ===============================================================
+   0(high) to  98(low)     user RT priority 99(high) to 1(low)
+                           with SCHED_RR or SCHED_FIFO
+ ---------------------------------------------------------------
+  99                       sched_priority is not used in scheduling
+                           decisions(it must be specified as 0)
+ ---------------------------------------------------------------
+ 100(high) to 139(low)     user nice -20(high) to 19(low)
+ ---------------------------------------------------------------
+ 140                       idle task priority
+ ---------------------------------------------------------------
 
 The task states are:
 
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index f44b49a..066ef59 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -203,7 +203,8 @@ struct pci_bus;
 void x86_pci_root_bus_res_quirks(struct pci_bus *b);
 
 #ifdef CONFIG_SMP
-#define mc_capable()	(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids)
+#define mc_capable()	((boot_cpu_data.x86_max_cores > 1) && \
+			(cpumask_weight(cpu_core_mask(0)) != nr_cpu_ids))
 #define smt_capable()			(smp_num_siblings > 1)
 #endif
 
diff --git a/fs/proc/loadavg.c b/fs/proc/loadavg.c
index 9bca39c..1afa4dd 100644
--- a/fs/proc/loadavg.c
+++ b/fs/proc/loadavg.c
@@ -12,20 +12,14 @@
 
 static int loadavg_proc_show(struct seq_file *m, void *v)
 {
-	int a, b, c;
-	unsigned long seq;
+	unsigned long avnrun[3];
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		a = avenrun[0] + (FIXED_1/200);
-		b = avenrun[1] + (FIXED_1/200);
-		c = avenrun[2] + (FIXED_1/200);
-	} while (read_seqretry(&xtime_lock, seq));
+	get_avenrun(avnrun, FIXED_1/200, 0);
 
-	seq_printf(m, "%d.%02d %d.%02d %d.%02d %ld/%d %d\n",
-		LOAD_INT(a), LOAD_FRAC(a),
-		LOAD_INT(b), LOAD_FRAC(b),
-		LOAD_INT(c), LOAD_FRAC(c),
+	seq_printf(m, "%lu.%02lu %lu.%02lu %lu.%02lu %ld/%d %d\n",
+		LOAD_INT(avnrun[0]), LOAD_FRAC(avnrun[0]),
+		LOAD_INT(avnrun[1]), LOAD_FRAC(avnrun[1]),
+		LOAD_INT(avnrun[2]), LOAD_FRAC(avnrun[2]),
 		nr_running(), nr_threads,
 		task_active_pid_ns(current)->last_pid);
 	return 0;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index b4c38bc..dbb1043 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -116,6 +116,7 @@ struct fs_struct;
  *    11 bit fractions.
  */
 extern unsigned long avenrun[];		/* Load averages */
+extern void get_avenrun(unsigned long *loads, unsigned long offset, int shift);
 
 #define FSHIFT		11		/* nr of bits of precision */
 #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
@@ -135,8 +136,8 @@ DECLARE_PER_CPU(unsigned long, process_counts);
 extern int nr_processes(void);
 extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
-extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
+extern void calc_global_load(void);
 
 extern unsigned long get_parent_ip(unsigned long addr);
 
@@ -838,7 +839,17 @@ struct sched_group {
 	 */
 	u32 reciprocal_cpu_power;
 
-	unsigned long cpumask[];
+	/*
+	 * The CPUs this group covers.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 *
+	 * It is also be embedded into static data structures at build
+	 * time. (See 'struct static_sched_group' in kernel/sched.c)
+	 */
+	unsigned long cpumask[0];
 };
 
 static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
@@ -924,8 +935,17 @@ struct sched_domain {
 	char *name;
 #endif
 
-	/* span of all CPUs in this domain */
-	unsigned long span[];
+	/*
+	 * Span of all CPUs in this domain.
+	 *
+	 * NOTE: this field is variable length. (Allocated dynamically
+	 * by attaching extra space to the end of the structure,
+	 * depending on how many CPUs the kernel has booted up with)
+	 *
+	 * It is also be embedded into static data structures at build
+	 * time. (See 'struct static_sched_domain' in kernel/sched.c)
+	 */
+	unsigned long span[0];
 };
 
 static inline struct cpumask *sched_domain_span(struct sched_domain *sd)
diff --git a/include/linux/wait.h b/include/linux/wait.h
index bc02463..6788e1a 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -132,8 +132,6 @@ static inline void __remove_wait_queue(wait_queue_head_t *head,
 	list_del(&old->task_list);
 }
 
-void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
-			int nr_exclusive, int sync, void *key);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr,
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 507cf2b..6ca5fe9 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -249,7 +249,9 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 
 		/* didnt get the lock, go to sleep: */
 		spin_unlock_mutex(&lock->wait_lock, flags);
-		__schedule();
+		preempt_enable_no_resched();
+		schedule();
+		preempt_disable();
 		spin_lock_mutex(&lock->wait_lock, flags);
 	}
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 26efa47..228acae 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -630,6 +630,10 @@ struct rq {
 	struct list_head migration_queue;
 #endif
 
+	/* calc_load related fields */
+	unsigned long calc_load_update;
+	long calc_load_active;
+
 #ifdef CONFIG_SCHED_HRTICK
 #ifdef CONFIG_SMP
 	int hrtick_csd_pending;
@@ -1728,6 +1732,8 @@ static void cfs_rq_set_shares(struct cfs_rq *cfs_rq, unsigned long shares)
 }
 #endif
 
+static void calc_load_account_active(struct rq *this_rq);
+
 #include "sched_stats.h"
 #include "sched_idletask.c"
 #include "sched_fair.c"
@@ -2856,19 +2862,72 @@ unsigned long nr_iowait(void)
 	return sum;
 }
 
-unsigned long nr_active(void)
+/* Variables and functions for calc_load */
+static atomic_long_t calc_load_tasks;
+static unsigned long calc_load_update;
+unsigned long avenrun[3];
+EXPORT_SYMBOL(avenrun);
+
+/**
+ * get_avenrun - get the load average array
+ * @loads:	pointer to dest load array
+ * @offset:	offset to add
+ * @shift:	shift count to shift the result left
+ *
+ * These values are estimates at best, so no need for locking.
+ */
+void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
 {
-	unsigned long i, running = 0, uninterruptible = 0;
+	loads[0] = (avenrun[0] + offset) << shift;
+	loads[1] = (avenrun[1] + offset) << shift;
+	loads[2] = (avenrun[2] + offset) << shift;
+}
 
-	for_each_online_cpu(i) {
-		running += cpu_rq(i)->nr_running;
-		uninterruptible += cpu_rq(i)->nr_uninterruptible;
-	}
+static unsigned long
+calc_load(unsigned long load, unsigned long exp, unsigned long active)
+{
+	load *= exp;
+	load += active * (FIXED_1 - exp);
+	return load >> FSHIFT;
+}
 
-	if (unlikely((long)uninterruptible < 0))
-		uninterruptible = 0;
+/*
+ * calc_load - update the avenrun load estimates 10 ticks after the
+ * CPUs have updated calc_load_tasks.
+ */
+void calc_global_load(void)
+{
+	unsigned long upd = calc_load_update + 10;
+	long active;
 
-	return running + uninterruptible;
+	if (time_before(jiffies, upd))
+		return;
+
+	active = atomic_long_read(&calc_load_tasks);
+	active = active > 0 ? active * FIXED_1 : 0;
+
+	avenrun[0] = calc_load(avenrun[0], EXP_1, active);
+	avenrun[1] = calc_load(avenrun[1], EXP_5, active);
+	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
+
+	calc_load_update += LOAD_FREQ;
+}
+
+/*
+ * Either called from update_cpu_load() or from a cpu going idle
+ */
+static void calc_load_account_active(struct rq *this_rq)
+{
+	long nr_active, delta;
+
+	nr_active = this_rq->nr_running;
+	nr_active += (long) this_rq->nr_uninterruptible;
+
+	if (nr_active != this_rq->calc_load_active) {
+		delta = nr_active - this_rq->calc_load_active;
+		this_rq->calc_load_active = nr_active;
+		atomic_long_add(delta, &calc_load_tasks);
+	}
 }
 
 /*
@@ -2899,6 +2958,11 @@ static void update_cpu_load(struct rq *this_rq)
 			new_load += scale-1;
 		this_rq->cpu_load[i] = (old_load*(scale-1) + new_load) >> i;
 	}
+
+	if (time_after_eq(jiffies, this_rq->calc_load_update)) {
+		this_rq->calc_load_update += LOAD_FREQ;
+		calc_load_account_active(this_rq);
+	}
 }
 
 #ifdef CONFIG_SMP
@@ -4240,10 +4304,126 @@ static void active_load_balance(struct rq *busiest_rq, int busiest_cpu)
 static struct {
 	atomic_t load_balancer;
 	cpumask_var_t cpu_mask;
+	cpumask_var_t ilb_grp_nohz_mask;
 } nohz ____cacheline_aligned = {
 	.load_balancer = ATOMIC_INIT(-1),
 };
 
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+/**
+ * lowest_flag_domain - Return lowest sched_domain containing flag.
+ * @cpu:	The cpu whose lowest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the lowest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the lowest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *lowest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd;
+
+	for_each_domain(cpu, sd)
+		if (sd && (sd->flags & flag))
+			break;
+
+	return sd;
+}
+
+/**
+ * for_each_flag_domain - Iterates over sched_domains containing the flag.
+ * @cpu:	The cpu whose domains we're iterating over.
+ * @sd:		variable holding the value of the power_savings_sd
+ *		for cpu.
+ * @flag:	The flag to filter the sched_domains to be iterated.
+ *
+ * Iterates over all the scheduler domains for a given cpu that has the 'flag'
+ * set, starting from the lowest sched_domain to the highest.
+ */
+#define for_each_flag_domain(cpu, sd, flag) \
+	for (sd = lowest_flag_domain(cpu, flag); \
+		(sd && (sd->flags & flag)); sd = sd->parent)
+
+/**
+ * is_semi_idle_group - Checks if the given sched_group is semi-idle.
+ * @ilb_group:	group to be checked for semi-idleness
+ *
+ * Returns:	1 if the group is semi-idle. 0 otherwise.
+ *
+ * We define a sched_group to be semi idle if it has atleast one idle-CPU
+ * and atleast one non-idle CPU. This helper function checks if the given
+ * sched_group is semi-idle or not.
+ */
+static inline int is_semi_idle_group(struct sched_group *ilb_group)
+{
+	cpumask_and(nohz.ilb_grp_nohz_mask, nohz.cpu_mask,
+					sched_group_cpus(ilb_group));
+
+	/*
+	 * A sched_group is semi-idle when it has atleast one busy cpu
+	 * and atleast one idle cpu.
+	 */
+	if (cpumask_empty(nohz.ilb_grp_nohz_mask))
+		return 0;
+
+	if (cpumask_equal(nohz.ilb_grp_nohz_mask, sched_group_cpus(ilb_group)))
+		return 0;
+
+	return 1;
+}
+/**
+ * find_new_ilb - Finds the optimum idle load balancer for nomination.
+ * @cpu:	The cpu which is nominating a new idle_load_balancer.
+ *
+ * Returns:	Returns the id of the idle load balancer if it exists,
+ *		Else, returns >= nr_cpu_ids.
+ *
+ * This algorithm picks the idle load balancer such that it belongs to a
+ * semi-idle powersavings sched_domain. The idea is to try and avoid
+ * completely idle packages/cores just for the purpose of idle load balancing
+ * when there are other idle cpu's which are better suited for that job.
+ */
+static int find_new_ilb(int cpu)
+{
+	struct sched_domain *sd;
+	struct sched_group *ilb_group;
+
+	/*
+	 * Have idle load balancer selection from semi-idle packages only
+	 * when power-aware load balancing is enabled
+	 */
+	if (!(sched_smt_power_savings || sched_mc_power_savings))
+		goto out_done;
+
+	/*
+	 * Optimize for the case when we have no idle CPUs or only one
+	 * idle CPU. Don't walk the sched_domain hierarchy in such cases
+	 */
+	if (cpumask_weight(nohz.cpu_mask) < 2)
+		goto out_done;
+
+	for_each_flag_domain(cpu, sd, SD_POWERSAVINGS_BALANCE) {
+		ilb_group = sd->groups;
+
+		do {
+			if (is_semi_idle_group(ilb_group))
+				return cpumask_first(nohz.ilb_grp_nohz_mask);
+
+			ilb_group = ilb_group->next;
+
+		} while (ilb_group != sd->groups);
+	}
+
+out_done:
+	return cpumask_first(nohz.cpu_mask);
+}
+#else /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */
+static inline int find_new_ilb(int call_cpu)
+{
+	return cpumask_first(nohz.cpu_mask);
+}
+#endif
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
@@ -4298,8 +4478,24 @@ int select_nohz_load_balancer(int stop_tick)
 			/* make me the ilb owner */
 			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
 				return 1;
-		} else if (atomic_read(&nohz.load_balancer) == cpu)
+		} else if (atomic_read(&nohz.load_balancer) == cpu) {
+			int new_ilb;
+
+			if (!(sched_smt_power_savings ||
+						sched_mc_power_savings))
+				return 1;
+			/*
+			 * Check to see if there is a more power-efficient
+			 * ilb.
+			 */
+			new_ilb = find_new_ilb(cpu);
+			if (new_ilb < nr_cpu_ids && new_ilb != cpu) {
+				atomic_set(&nohz.load_balancer, -1);
+				resched_cpu(new_ilb);
+				return 0;
+			}
 			return 1;
+		}
 	} else {
 		if (!cpumask_test_cpu(cpu, nohz.cpu_mask))
 			return 0;
@@ -4468,15 +4664,7 @@ static inline void trigger_load_balance(struct rq *rq, int cpu)
 		}
 
 		if (atomic_read(&nohz.load_balancer) == -1) {
-			/*
-			 * simple selection for now: Nominate the
-			 * first cpu in the nohz list to be the next
-			 * ilb owner.
-			 *
-			 * TBD: Traverse the sched domains and nominate
-			 * the nearest cpu in the nohz.cpu_mask.
-			 */
-			int ilb = cpumask_first(nohz.cpu_mask);
+			int ilb = find_new_ilb(cpu);
 
 			if (ilb < nr_cpu_ids)
 				resched_cpu(ilb);
@@ -5007,13 +5195,15 @@ pick_next_task(struct rq *rq)
 /*
  * schedule() is the main scheduler function.
  */
-asmlinkage void __sched __schedule(void)
+asmlinkage void __sched schedule(void)
 {
 	struct task_struct *prev, *next;
 	unsigned long *switch_count;
 	struct rq *rq;
 	int cpu;
 
+need_resched:
+	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	rcu_qsctr_inc(cpu);
@@ -5070,15 +5260,9 @@ need_resched_nonpreemptible:
 
 	if (unlikely(reacquire_kernel_lock(current) < 0))
 		goto need_resched_nonpreemptible;
-}
 
-asmlinkage void __sched schedule(void)
-{
-need_resched:
-	preempt_disable();
-	__schedule();
 	preempt_enable_no_resched();
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
+	if (need_resched())
 		goto need_resched;
 }
 EXPORT_SYMBOL(schedule);
@@ -5221,7 +5405,7 @@ EXPORT_SYMBOL(default_wake_function);
  * started to run but is not in state TASK_RUNNING. try_to_wake_up() returns
  * zero in this (rare) case, and we handle it by continuing to scan the queue.
  */
-void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+static void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
 			int nr_exclusive, int sync, void *key)
 {
 	wait_queue_t *curr, *next;
@@ -6490,8 +6674,9 @@ void sched_show_task(struct task_struct *p)
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	free = stack_not_used(p);
 #endif
-	printk(KERN_CONT "%5lu %5d %6d\n", free,
-		task_pid_nr(p), task_pid_nr(p->real_parent));
+	printk(KERN_CONT "%5lu %5d %6d 0x%08lx\n", free,
+		task_pid_nr(p), task_pid_nr(p->real_parent),
+		(unsigned long)task_thread_info(p)->flags);
 
 	show_stack(p, NULL);
 }
@@ -6970,6 +7155,14 @@ static void migrate_dead_tasks(unsigned int dead_cpu)
 
 	}
 }
+
+/*
+ * remove the tasks which were accounted by rq from calc_load_tasks.
+ */
+static void calc_global_load_remove(struct rq *rq)
+{
+	atomic_long_sub(rq->calc_load_active, &calc_load_tasks);
+}
 #endif /* CONFIG_HOTPLUG_CPU */
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
@@ -7204,6 +7397,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		/* Update our root-domain */
 		rq = cpu_rq(cpu);
 		spin_lock_irqsave(&rq->lock, flags);
+		rq->calc_load_update = calc_load_update;
+		rq->calc_load_active = 0;
 		if (rq->rd) {
 			BUG_ON(!cpumask_test_cpu(cpu, rq->rd->span));
 
@@ -7243,7 +7438,7 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
-
+		calc_global_load_remove(rq);
 		/*
 		 * No need to migrate the tasks: it was best-effort if
 		 * they didn't take sched_hotcpu_mutex. Just wake up
@@ -7753,8 +7948,9 @@ int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
 
 /*
  * The cpus mask in sched_group and sched_domain hangs off the end.
- * FIXME: use cpumask_var_t or dynamic percpu alloc to avoid wasting space
- * for nr_cpu_ids < CONFIG_NR_CPUS.
+ *
+ * ( See the the comments in include/linux/sched.h:struct sched_group
+ *   and struct sched_domain. )
  */
 struct static_sched_group {
 	struct sched_group sg;
@@ -7875,7 +8071,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j).sd;
-			if (j != cpumask_first(sched_group_cpus(sd->groups))) {
+			if (j != group_first_cpu(sd->groups)) {
 				/*
 				 * Only add "power" once for each
 				 * physical package.
@@ -7953,7 +8149,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
 
 	WARN_ON(!sd || !sd->groups);
 
-	if (cpu != cpumask_first(sched_group_cpus(sd->groups)))
+	if (cpu != group_first_cpu(sd->groups))
 		return;
 
 	child = sd->child;
@@ -8938,6 +9134,8 @@ void __init sched_init(void)
 		rq = cpu_rq(i);
 		spin_lock_init(&rq->lock);
 		rq->nr_running = 0;
+		rq->calc_load_active = 0;
+		rq->calc_load_update = jiffies + LOAD_FREQ;
 		init_cfs_rq(&rq->cfs, rq);
 		init_rt_rq(&rq->rt, rq);
 #ifdef CONFIG_FAIR_GROUP_SCHED
@@ -9045,6 +9243,9 @@ void __init sched_init(void)
 	 * when this runqueue becomes "idle".
 	 */
 	init_idle(current, smp_processor_id());
+
+	calc_load_update = jiffies + LOAD_FREQ;
+
 	/*
 	 * During early bootup we pretend to be a normal task:
 	 */
@@ -9055,6 +9256,7 @@ void __init sched_init(void)
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
 	alloc_bootmem_cpumask_var(&nohz.cpu_mask);
+	alloc_bootmem_cpumask_var(&nohz.ilb_grp_nohz_mask);
 #endif
 	alloc_bootmem_cpumask_var(&cpu_isolated_map);
 #endif /* SMP */
@@ -9800,6 +10002,13 @@ static int sched_rt_global_constraints(void)
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
+	/*
+	 * There's always some RT tasks in the root group
+	 * -- migration, kstopmachine etc..
+	 */
+	if (sysctl_sched_rt_runtime == 0)
+		return -EBUSY;
+
 	spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
 	for_each_possible_cpu(i) {
 		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3816f21..5f9650e 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1487,17 +1487,10 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 
 	find_matching_se(&se, &pse);
 
-	while (se) {
-		BUG_ON(!pse);
+	BUG_ON(!pse);
 
-		if (wakeup_preempt_entity(se, pse) == 1) {
-			resched_task(curr);
-			break;
-		}
-
-		se = parent_entity(se);
-		pse = parent_entity(pse);
-	}
+	if (wakeup_preempt_entity(se, pse) == 1)
+		resched_task(curr);
 }
 
 static struct task_struct *pick_next_task_fair(struct rq *rq)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 8a21a2e..499672c 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -22,7 +22,8 @@ static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int sy
 static struct task_struct *pick_next_task_idle(struct rq *rq)
 {
 	schedstat_inc(rq, sched_goidle);
-
+	/* adjust the active tasks as we might go into a long sleep */
+	calc_load_account_active(rq);
 	return rq->idle;
 }
 
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 687dff4..52a8bf8 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -22,7 +22,7 @@
 
 /*
  * This read-write spinlock protects us from races in SMP while
- * playing with xtime and avenrun.
+ * playing with xtime.
  */
 __cacheline_aligned_in_smp DEFINE_SEQLOCK(xtime_lock);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index cffffad..a26ed29 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1123,47 +1123,6 @@ void update_process_times(int user_tick)
 }
 
 /*
- * Nr of active tasks - counted in fixed-point numbers
- */
-static unsigned long count_active_tasks(void)
-{
-	return nr_active() * FIXED_1;
-}
-
-/*
- * Hmm.. Changed this, as the GNU make sources (load.c) seems to
- * imply that avenrun[] is the standard name for this kind of thing.
- * Nothing else seems to be standardized: the fractional size etc
- * all seem to differ on different machines.
- *
- * Requires xtime_lock to access.
- */
-unsigned long avenrun[3];
-
-EXPORT_SYMBOL(avenrun);
-
-/*
- * calc_load - given tick count, update the avenrun load estimates.
- * This is called while holding a write_lock on xtime_lock.
- */
-static inline void calc_load(unsigned long ticks)
-{
-	unsigned long active_tasks; /* fixed-point */
-	static int count = LOAD_FREQ;
-
-	count -= ticks;
-	if (unlikely(count < 0)) {
-		active_tasks = count_active_tasks();
-		do {
-			CALC_LOAD(avenrun[0], EXP_1, active_tasks);
-			CALC_LOAD(avenrun[1], EXP_5, active_tasks);
-			CALC_LOAD(avenrun[2], EXP_15, active_tasks);
-			count += LOAD_FREQ;
-		} while (count < 0);
-	}
-}
-
-/*
  * This function runs timers and the timer-tq in bottom half context.
  */
 static void run_timer_softirq(struct softirq_action *h)
@@ -1187,16 +1146,6 @@ void run_local_timers(void)
 }
 
 /*
- * Called by the timer interrupt. xtime_lock must already be taken
- * by the timer IRQ!
- */
-static inline void update_times(unsigned long ticks)
-{
-	update_wall_time();
-	calc_load(ticks);
-}
-
-/*
  * The 64-bit jiffies value is not atomic - you MUST NOT read it
  * without sampling the sequence number in xtime_lock.
  * jiffies is defined in the linker script...
@@ -1205,7 +1154,8 @@ static inline void update_times(unsigned long ticks)
 void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
-	update_times(ticks);
+	update_wall_time();
+	calc_global_load();
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
@@ -1406,37 +1356,17 @@ int do_sysinfo(struct sysinfo *info)
 {
 	unsigned long mem_total, sav_total;
 	unsigned int mem_unit, bitcount;
-	unsigned long seq;
+	struct timespec tp;
 
 	memset(info, 0, sizeof(struct sysinfo));
 
-	do {
-		struct timespec tp;
-		seq = read_seqbegin(&xtime_lock);
-
-		/*
-		 * This is annoying.  The below is the same thing
-		 * posix_get_clock_monotonic() does, but it wants to
-		 * take the lock which we want to cover the loads stuff
-		 * too.
-		 */
-
-		getnstimeofday(&tp);
-		tp.tv_sec += wall_to_monotonic.tv_sec;
-		tp.tv_nsec += wall_to_monotonic.tv_nsec;
-		monotonic_to_bootbased(&tp);
-		if (tp.tv_nsec - NSEC_PER_SEC >= 0) {
-			tp.tv_nsec = tp.tv_nsec - NSEC_PER_SEC;
-			tp.tv_sec++;
-		}
-		info->uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
+	ktime_get_ts(&tp);
+	monotonic_to_bootbased(&tp);
+	info->uptime = tp.tv_sec + (tp.tv_nsec ? 1 : 0);
 
-		info->loads[0] = avenrun[0] << (SI_LOAD_SHIFT - FSHIFT);
-		info->loads[1] = avenrun[1] << (SI_LOAD_SHIFT - FSHIFT);
-		info->loads[2] = avenrun[2] << (SI_LOAD_SHIFT - FSHIFT);
+	get_avenrun(info->loads, 0, SI_LOAD_SHIFT - FSHIFT);
 
-		info->procs = nr_threads;
-	} while (read_seqretry(&xtime_lock, seq));
+	info->procs = nr_threads;
 
 	si_meminfo(info);
 	si_swapinfo(info);
diff --git a/kernel/wait.c b/kernel/wait.c
index 42a2dbc..ea7c3b4 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -154,7 +154,7 @@ void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
 	if (!list_empty(&wait->task_list))
 		list_del_init(&wait->task_list);
 	else if (waitqueue_active(q))
-		__wake_up_common(q, mode, 1, 0, key);
+		__wake_up_locked_key(q, mode, key);
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 EXPORT_SYMBOL(abort_exclusive_wait);
