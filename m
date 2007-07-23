Return-Path: <linux-kernel-owner+w=401wt.eu-S933726AbXGWSje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933726AbXGWSje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764062AbXGWSik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:38:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:54069 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761758AbXGWSig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:38:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,571,1175497200"; 
   d="scan'208";a="253702824"
Date: Mon, 23 Jul 2007 11:38:34 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: mingo@elte.hu
cc: linux-kernel@vger.kernel.org
Subject: [RFC] scheduler: improve SMP fairness in CFS
Message-ID: <Pine.LNX.4.64.0707231123080.3239@tongli.jf.intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends CFS to achieve better fairness for SMPs. For example, 
with 10 tasks (same priority) on 8 CPUs, it enables each task to receive 
equal CPU time (80%). The code works on top of CFS and provides SMP 
fairness at a coarser time grainularity; local on each CPU, it relies on 
CFS to provide fine-grained fairness and good interactivity.

The code is based on the distributed weighted round-robin (DWRR) 
algorithm. It keeps two RB trees on each CPU: one is the original cfs_rq, 
referred to as active, and one is a new cfs_rq, called round-expired. Each 
CPU keeps a round number, initially zero. The scheduler works exactly the 
same way as in CFS, but only runs tasks from the active tree. Each task is 
assigned a round slice, equal to its weight times a system constant (e.g., 
100ms), controlled by sysctl_base_round_slice. When a task uses up its 
round slice, it moves to the round-expired tree on the same CPU and stops 
running. Thus, at any time on each CPU, the active tree contains all tasks 
that are running in the current round, while tasks in round-expired have 
all finished the current round and await to start the next round. When an 
active tree becomes empty, it calls idle_balance() to grab tasks of the 
same round from other CPUs. If none can be moved over, it switches its 
active and round-expired trees, thus unleashing round-expired tasks and 
advancing the local round number by one. An invariant it maintains is that 
the round numbers of any two CPUs in the system differ by at most one. 
This property ensures fairness across CPUs. The variable 
sysctl_base_round_slice controls fairness-performance tradeoffs: a smaller 
value leads to better cross-CPU fairness at the potential cost of 
performance; on the other hand, the larger the value is, the closer the 
system behavior is to the default CFS without the patch.

Any comments and suggestions would be highly appreciated.

Thanks,

   tong

Signed-off-by: Tong Li <tong.n.li@intel.com>
---
  include/linux/sched.h |    5
  kernel/sched.c | 577 ++++++++++++++++++++++++++++++++++++++++++--------
  kernel/sched_debug.c  |    8
  kernel/sched_fair.c   |  124 ++++++++--
  kernel/sysctl.c       |   13 +
  5 files changed, 604 insertions(+), 123 deletions(-)

diff -uprN linux-2.6.23-rc1/include/linux/sched.h linux-2.6.23-rc1-dwrr/include/linux/sched.h
--- linux-2.6.23-rc1/include/linux/sched.h	2007-07-22 18:42:28.000000000 -0700
+++ linux-2.6.23-rc1-dwrr/include/linux/sched.h	2007-07-22 18:52:34.000000000 -0700
@@ -887,7 +887,7 @@ struct sched_entity {
  	s64			fair_key;
  	struct load_weight	load;		/* for load-balancing */
  	struct rb_node		run_node;
-	unsigned int		on_rq;
+	struct cfs_rq           *on_rq; /* NULL, active, or round-expired */

  	u64			wait_start_fair;
  	u64			wait_start;
@@ -906,6 +906,8 @@ struct sched_entity {
  	s64			sum_sleep_runtime;
  	unsigned long		wait_runtime_overruns;
  	unsigned long		wait_runtime_underruns;
+        /* How long it has run in the current round. */
+        u64                     round_slice_used;
  #ifdef CONFIG_FAIR_GROUP_SCHED
  	struct sched_entity	*parent;
  	/* rq on which this entity is (to be) queued: */
@@ -1382,6 +1384,7 @@ extern unsigned int sysctl_sched_stat_gr
  extern unsigned int sysctl_sched_runtime_limit;
  extern unsigned int sysctl_sched_child_runs_first;
  extern unsigned int sysctl_sched_features;
+extern u64 sysctl_sched_base_round_slice;

  #ifdef CONFIG_RT_MUTEXES
  extern int rt_mutex_getprio(struct task_struct *p);
diff -uprN linux-2.6.23-rc1/kernel/sched.c linux-2.6.23-rc1-dwrr/kernel/sched.c
--- linux-2.6.23-rc1/kernel/sched.c	2007-07-22 18:42:28.000000000 -0700
+++ linux-2.6.23-rc1-dwrr/kernel/sched.c	2007-07-22 23:05:54.000000000 -0700
@@ -184,17 +184,20 @@ struct cfs_rq {
  	u64 exec_clock;
  	s64 wait_runtime;
  	u64 sleeper_bonus;
+        u64 round;      /* round number of this cfs_rq */
  	unsigned long wait_runtime_overruns, wait_runtime_underruns;
+        u64 wait_start_fair, wait_start; /* Used to track wait times of
+                                            round-expired tasks. */

  	struct rb_root tasks_timeline;
  	struct rb_node *rb_leftmost;
  	struct rb_node *rb_load_balance_curr;
+	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */
  #ifdef CONFIG_FAIR_GROUP_SCHED
  	/* 'curr' points to currently running entity on this cfs_rq.
  	 * It is set to NULL otherwise (i.e when none are currently running).
  	 */
  	struct sched_entity *curr;
-	struct rq *rq;	/* cpu runqueue to which this cfs_rq is attached */

  	/* leaf cfs_rqs are those that hold tasks (lowest schedulable entity in
  	 * a hierarchy). Non-leaf lrqs hold other higher schedulable entities
@@ -239,7 +242,7 @@ struct rq {
  	unsigned long nr_load_updates;
  	u64 nr_switches;

-	struct cfs_rq cfs;
+        struct cfs_rq *active, *round_expired, cfs[2];
  #ifdef CONFIG_FAIR_GROUP_SCHED
  	struct list_head leaf_cfs_rq_list; /* list of leaf cfs_rq on this cpu */
  #endif
@@ -301,6 +304,11 @@ struct rq {
  	struct lock_class_key rq_lock_key;
  };

+/* highest round number in the system */
+__cacheline_aligned u64 dwrr_highest_round = 0;
+ /* lock protecting dwrr_highest_round */
+DEFINE_RWLOCK(dwrr_highest_lock);
+
  static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
  static DEFINE_MUTEX(sched_hotcpu_mutex);

@@ -400,7 +408,7 @@ unsigned long long cpu_clock(int cpu)
  /* Change a task's ->cfs_rq if it moves across CPUs */
  static inline void set_task_cfs_rq(struct task_struct *p)
  {
-	p->se.cfs_rq = &task_rq(p)->cfs;
+        p->se.cfs_rq = task_rq(p)->active;
  }
  #else
  static inline void set_task_cfs_rq(struct task_struct *p)
@@ -415,6 +423,19 @@ static inline void set_task_cfs_rq(struc
  # define finish_arch_switch(prev)	do { } while (0)
  #endif

+static inline void dwrr_update_idle(struct task_struct *p, struct rq *rq)
+{
+        unsigned long flags;
+
+        if (rt_task(p))
+                return;
+
+        read_lock_irqsave(&dwrr_highest_lock, flags);
+        rq->active->round = dwrr_highest_round;
+        read_unlock_irqrestore(&dwrr_highest_lock, flags);
+        rq->round_expired->round = rq->active->round + 1;
+}
+
  #ifndef __ARCH_WANT_UNLOCKED_CTXSW
  static inline int task_running(struct rq *rq, struct task_struct *p)
  {
@@ -841,7 +862,7 @@ static int balance_tasks(struct rq *this

  static void set_load_weight(struct task_struct *p)
  {
-	task_rq(p)->cfs.wait_runtime -= p->se.wait_runtime;
+        task_rq(p)->active->wait_runtime -= p->se.wait_runtime;
  	p->se.wait_runtime = 0;

  	if (task_has_rt_policy(p)) {
@@ -868,14 +889,14 @@ enqueue_task(struct rq *rq, struct task_
  {
  	sched_info_queued(p);
  	p->sched_class->enqueue_task(rq, p, wakeup, now);
-	p->se.on_rq = 1;
+        p->se.on_rq = rq->active;
  }

  static void
  dequeue_task(struct rq *rq, struct task_struct *p, int sleep, u64 now)
  {
  	p->sched_class->dequeue_task(rq, p, sleep, now);
-	p->se.on_rq = 0;
+	p->se.on_rq = NULL;
  }

  /*
@@ -933,9 +954,13 @@ static void activate_task(struct rq *rq,

  	if (p->state == TASK_UNINTERRUPTIBLE)
  		rq->nr_uninterruptible--;
+        if (rq->curr == rq->idle)
+                dwrr_update_idle(p, rq);

  	enqueue_task(rq, p, wakeup, now);
  	inc_nr_running(p, rq, now);
+        if (wakeup)
+                p->se.round_slice_used = 0;
  }

  /*
@@ -958,12 +983,14 @@ static inline void activate_idle_task(st
  static void deactivate_task(struct rq *rq, struct task_struct *p, int sleep)
  {
  	u64 now = rq_clock(rq);
+        struct cfs_rq *on_rq = p->se.on_rq;

  	if (p->state == TASK_UNINTERRUPTIBLE)
  		rq->nr_uninterruptible++;

  	dequeue_task(rq, p, sleep, now);
-	dec_nr_running(p, rq, now);
+        if (on_rq != rq->round_expired)
+                dec_nr_running(p, rq, now);
  }

  /**
@@ -998,8 +1025,8 @@ void set_task_cpu(struct task_struct *p,
  	u64 clock_offset, fair_clock_offset;

  	clock_offset = old_rq->clock - new_rq->clock;
-	fair_clock_offset = old_rq->cfs.fair_clock -
-						 new_rq->cfs.fair_clock;
+	fair_clock_offset = old_rq->active->fair_clock -
+						 new_rq->active->fair_clock;
  	if (p->se.wait_start)
  		p->se.wait_start -= clock_offset;
  	if (p->se.wait_start_fair)
@@ -1061,7 +1088,8 @@ migrate_task(struct task_struct *p, int
  void wait_task_inactive(struct task_struct *p)
  {
  	unsigned long flags;
-	int running, on_rq;
+	int running;
+	struct cfs_rq *on_rq;
  	struct rq *rq;

  repeat:
@@ -1209,6 +1237,8 @@ find_idlest_group(struct sched_domain *s
  	unsigned long min_load = ULONG_MAX, this_load = 0;
  	int load_idx = sd->forkexec_idx;
  	int imbalance = 100 + (sd->imbalance_pct-100)/2;
+        int found_highest_cpu, this_group_ok = 0;
+        struct rq *rq;

  	do {
  		unsigned long load, avg_load;
@@ -1224,7 +1254,16 @@ find_idlest_group(struct sched_domain *s
  		/* Tally up the load of all CPUs in the group */
  		avg_load = 0;

+		found_highest_cpu = 0;
  		for_each_cpu_mask(i, group->cpumask) {
+                        rq = cpu_rq(i);
+                        if (cpu_isset(i, p->cpus_allowed) &&
+                                (rq->active->round == dwrr_highest_round
+                                        || rq->curr == rq->idle)) {
+                                if (local_group)
+                                        this_group_ok = 1;
+                                found_highest_cpu = 1;
+                        }
  			/* Bias balancing toward cpus of our domain */
  			if (local_group)
  				load = source_load(i, load_idx);
@@ -1238,6 +1277,16 @@ find_idlest_group(struct sched_domain *s
  		avg_load = sg_div_cpu_power(group,
  				avg_load * SCHED_LOAD_SCALE);

+                if (!found_highest_cpu && !rt_task(p)) {
+                        if (local_group) {
+                                this_load = avg_load;
+                                this = group;
+                        }
+                        /* If the group doesn't contain a highest round CPU
+                         * or an idle CPU, skip it. */
+                        goto nextgroup;
+                }
+
  		if (local_group) {
  			this_load = avg_load;
  			this = group;
@@ -1249,7 +1298,8 @@ nextgroup:
  		group = group->next;
  	} while (group != sd->groups);

-	if (!idlest || 100*this_load < imbalance*min_load)
+        if (!idlest || (100*this_load < imbalance*min_load &&
+                                (rt_task(p) || this_group_ok)))
  		return NULL;
  	return idlest;
  }
@@ -1264,6 +1314,7 @@ find_idlest_cpu(struct sched_group *grou
  	unsigned long load, min_load = ULONG_MAX;
  	int idlest = -1;
  	int i;
+	struct rq *rq;

  	/* Traverse only the allowed CPUs */
  	cpus_and(tmp, group->cpumask, p->cpus_allowed);
@@ -1271,6 +1322,11 @@ find_idlest_cpu(struct sched_group *grou
  	for_each_cpu_mask(i, tmp) {
  		load = weighted_cpuload(i);

+                rq = cpu_rq(i);
+                if (!rt_task(p) && rq->curr != rq->idle &&
+                                rq->active->round != dwrr_highest_round)
+                        continue;
+
  		if (load < min_load || (load == min_load && i == this_cpu)) {
  			min_load = load;
  			idlest = i;
@@ -1281,7 +1337,7 @@ find_idlest_cpu(struct sched_group *grou
  }

  /*
- * sched_balance_self: balance the current task (running on cpu) in domains
+ * sched_balance_task: balance the given task (running on cpu) in domains
   * that have the 'flag' flag set. In practice, this is SD_BALANCE_FORK and
   * SD_BALANCE_EXEC.
   *
@@ -1291,16 +1347,15 @@ find_idlest_cpu(struct sched_group *grou
   *
   * preempt must be disabled.
   */
-static int sched_balance_self(int cpu, int flag)
+static int sched_balance_task(int cpu, struct task_struct *t, int flag)
  {
-	struct task_struct *t = current;
  	struct sched_domain *tmp, *sd = NULL;

  	for_each_domain(cpu, tmp) {
  		/*
  		 * If power savings logic is enabled for a domain, stop there.
  		 */
-		if (tmp->flags & SD_POWERSAVINGS_BALANCE)
+                if (t == current && (tmp->flags & SD_POWERSAVINGS_BALANCE))
  			break;
  		if (tmp->flags & flag)
  			sd = tmp;
@@ -1417,10 +1472,17 @@ static int try_to_wake_up(struct task_st
  	struct rq *rq;
  #ifdef CONFIG_SMP
  	struct sched_domain *sd, *this_sd = NULL;
-	unsigned long load, this_load;
-	int new_cpu;
+        unsigned long load, this_load, irqflags = 0;
+        int old_cpu, new_cpu, highest_locked;
+        struct rq *new_rq;
+
+dwrr_start:
+        highest_locked = 0;
+        if (!rt_task(p)) {
+                read_lock_irqsave(&dwrr_highest_lock, irqflags);
+                highest_locked = 1;
+        }
  #endif
-
  	rq = task_rq_lock(p, &flags);
  	old_state = p->state;
  	if (!(old_state & state))
@@ -1433,8 +1495,20 @@ static int try_to_wake_up(struct task_st
  	this_cpu = smp_processor_id();

  #ifdef CONFIG_SMP
-	if (unlikely(task_running(rq, p)))
-		goto out_activate;
+        if (unlikely(task_running(rq, p))) {
+                if (rt_task(p) || rq->active->round == dwrr_highest_round)
+                        goto out_activate;
+                else {
+                        /* wait until p is not running */
+                        task_rq_unlock(rq, &flags);
+                        if (highest_locked)
+                                read_unlock_irqrestore(&dwrr_highest_lock,
+                                                irqflags);
+                        while (task_running(rq, p))
+                                cpu_relax();
+                        goto dwrr_start;
+                }
+        }

  	new_cpu = cpu;

@@ -1511,6 +1585,19 @@ static int try_to_wake_up(struct task_st
  	new_cpu = cpu; /* Could not wake to this_cpu. Wake to cpu instead */
  out_set_cpu:
  	new_cpu = wake_idle(new_cpu, p);
+        if (highest_locked) {
+                old_cpu = new_cpu;
+                if (!rt_task(p) && !idle_cpu(new_cpu) &&
+                        cpu_rq(new_cpu)->active->round != dwrr_highest_round) {
+                        /* Need to find a highest round cpu. This is similar
+                           to what's done in fork. */
+                        new_cpu = sched_balance_task(old_cpu, p,
+                                        SD_BALANCE_FORK);
+                        BUG_ON(new_cpu == -1);
+                }
+
+                new_rq = cpu_rq(new_cpu);
+        }
  	if (new_cpu != cpu) {
  		set_task_cpu(p, new_cpu);
  		task_rq_unlock(rq, &flags);
@@ -1545,6 +1632,10 @@ out_running:
  	p->state = TASK_RUNNING;
  out:
  	task_rq_unlock(rq, &flags);
+#ifdef CONFIG_SMP
+        if (highest_locked)
+                read_unlock_irqrestore(&dwrr_highest_lock, irqflags);
+#endif

  	return success;
  }
@@ -1590,7 +1681,8 @@ static void __sched_fork(struct task_str
  	p->se.wait_runtime_underruns	= 0;

  	INIT_LIST_HEAD(&p->run_list);
-	p->se.on_rq = 0;
+        p->se.on_rq                     = NULL;
+        p->se.round_slice_used          = 0;

  	/*
  	 * We mark the process as running here, but have not actually
@@ -1611,7 +1703,10 @@ void sched_fork(struct task_struct *p, i
  	__sched_fork(p);

  #ifdef CONFIG_SMP
-	cpu = sched_balance_self(cpu, SD_BALANCE_FORK);
+        /* Non-RT tasks will do sched_balance_task() in wake_up_new_task()
+         * to ensure they start on the "right" CPUs. */
+        if (rt_task(p))
+                cpu = sched_balance_task(cpu, current, SD_BALANCE_FORK);
  #endif
  	__set_task_cpu(p, cpu);

@@ -1651,14 +1746,37 @@ void fastcall wake_up_new_task(struct ta
  {
  	unsigned long flags;
  	struct rq *rq;
-	int this_cpu;
+        int cpu, this_cpu;
+#ifdef CONFIG_SMP
+	unsigned long irqflags = 0;
+	int new_cpu, highest_locked = 0;

+        if (!rt_task(p)) {
+                read_lock_irqsave(&dwrr_highest_lock, irqflags);
+                highest_locked = 1;
+        }
+#endif
  	rq = task_rq_lock(p, &flags);
  	BUG_ON(p->state != TASK_RUNNING);
  	this_cpu = smp_processor_id(); /* parent's CPU */
+        cpu = task_cpu(p);

  	p->prio = effective_prio(p);

+#ifdef CONFIG_SMP
+        if (highest_locked) {
+                new_cpu = sched_balance_task(cpu, p, SD_BALANCE_FORK);
+                BUG_ON(new_cpu == -1);
+                if (new_cpu != cpu) {
+                        cpu = new_cpu;
+                        set_task_cpu(p, cpu);
+                        task_rq_unlock(rq, &flags);
+                        rq = task_rq_lock(p, &flags);
+                        BUG_ON(this_cpu != smp_processor_id());
+                }
+        }
+#endif
+
  	if (!sysctl_sched_child_runs_first || (clone_flags & CLONE_VM) ||
  			task_cpu(p) != this_cpu || !current->se.on_rq) {
  		activate_task(rq, p, 0);
@@ -1671,6 +1789,10 @@ void fastcall wake_up_new_task(struct ta
  	}
  	check_preempt_curr(rq, p);
  	task_rq_unlock(rq, &flags);
+#ifdef CONFIG_SMP
+        if (highest_locked)
+                read_unlock_irqrestore(&dwrr_highest_lock, irqflags);
+#endif
  }

  /**
@@ -2046,7 +2168,13 @@ out:
  void sched_exec(void)
  {
  	int new_cpu, this_cpu = get_cpu();
-	new_cpu = sched_balance_self(this_cpu, SD_BALANCE_EXEC);
+
+        new_cpu = this_cpu;
+        if (unlikely(!cpu_isset(this_cpu, current->cpus_allowed)))
+                new_cpu = any_online_cpu(current->cpus_allowed);
+        else if (rt_task(current))
+                new_cpu = sched_balance_task(this_cpu, current,
+                                                SD_BALANCE_EXEC);
  	put_cpu();
  	if (new_cpu != this_cpu)
  		sched_migrate_task(current, new_cpu);
@@ -2070,6 +2198,25 @@ static void pull_task(struct rq *src_rq,
  }

  /*
+ * pull_expired_task - move a task from a remote round-expired runqueue to
+ * the local runqueue.
+ * Both runqueues must be locked.
+ */
+static void pull_expired_task(struct rq *src_rq, struct task_struct *p,
+                      struct rq *this_rq, int this_cpu)
+{
+        u64 now = rq_clock(src_rq);
+        dequeue_task(src_rq, p, 0, now);
+        set_task_cpu(p, this_cpu);
+        activate_task(this_rq, p, 0);
+        /*
+         * Note that idle threads have a prio of MAX_PRIO, for this test
+         * to be always true for them.
+         */
+        check_preempt_curr(this_rq, p);
+}
+
+/*
   * can_migrate_task - may task p from runqueue rq be migrated to this_cpu?
   */
  static
@@ -2089,6 +2236,8 @@ int can_migrate_task(struct task_struct

  	if (task_running(rq, p))
  		return 0;
+        if (p->se.on_rq == rq->round_expired)
+                return 0;

  	/*
  	 * Aggressive migration if too many balance attempts have failed:
@@ -2099,6 +2248,72 @@ int can_migrate_task(struct task_struct
  	return 1;
  }

+/*
+ * can_migrate_expired_task - may task p from round expired runqueue rq be
+ * migrated to this_cpu?
+ */
+static
+int can_migrate_expired_task(struct task_struct *p, struct rq *rq,
+                             int this_cpu)
+{
+        /*
+         * We do not migrate tasks that are:
+         * 1) running (obviously), or
+         * 2) cannot be migrated to this CPU due to cpus_allowed.
+         */
+        if (!cpu_isset(this_cpu, p->cpus_allowed))
+                return 0;
+
+        /*
+         * p could still be the current running task on rq between the time
+         * it was moved to the round_expired queue and the time schedule()
+         * is called to switch it out.
+         */
+        if (task_running(rq, p))
+                return 0;
+
+        return 1;
+}
+
+static int move_round_expired_tasks(struct rq *this_rq, int this_cpu,
+                      struct rq *src_rq, unsigned long max_nr_move)
+{
+        int pulled = 0;
+        struct cfs_rq *src_cfs_rq;
+        struct task_struct *p;
+        struct rq_iterator cfs_rq_iterator;
+
+        if (max_nr_move == 0 || !src_rq->round_expired->nr_running)
+                goto out;
+
+        src_cfs_rq = src_rq->round_expired;
+        cfs_rq_iterator.start = load_balance_start_fair;
+        cfs_rq_iterator.next = load_balance_next_fair;
+
+        p = cfs_rq_iterator.start(src_cfs_rq);
+next:
+        if (!p)
+                goto out;
+
+        if (!can_migrate_expired_task(p, src_rq, this_cpu)) {
+                p = cfs_rq_iterator.next(src_cfs_rq);
+                goto next;
+        }
+
+        pull_expired_task(src_rq, p, this_rq, this_cpu);
+        pulled++;
+
+        /*
+         * We only want to steal up to the prescribed number of tasks.
+         */
+        if (pulled < max_nr_move) {
+                p = cfs_rq_iterator.next(src_cfs_rq);
+                goto next;
+        }
+out:
+        return pulled;
+}
+
  static int balance_tasks(struct rq *this_rq, int this_cpu, struct rq *busiest,
  		      unsigned long max_nr_move, unsigned long max_load_move,
  		      struct sched_domain *sd, enum cpu_idle_type idle,
@@ -2106,7 +2321,7 @@ static int balance_tasks(struct rq *this
  		      int this_best_prio, int best_prio, int best_prio_seen,
  		      struct rq_iterator *iterator)
  {
-	int pulled = 0, pinned = 0, skip_for_load;
+	int pulled = 0, pinned = 0;
  	struct task_struct *p;
  	long rem_load_move = max_load_move;

@@ -2122,18 +2337,8 @@ static int balance_tasks(struct rq *this
  next:
  	if (!p)
  		goto out;
-	/*
-	 * To help distribute high priority tasks accross CPUs we don't
-	 * skip a task if it will be the highest priority task (i.e. smallest
-	 * prio value) on its new queue regardless of its load weight
-	 */
-	skip_for_load = (p->se.load.weight >> 1) > rem_load_move +
-							 SCHED_LOAD_SCALE_FUZZ;
-	if (skip_for_load && p->prio < this_best_prio)
-		skip_for_load = !best_prio_seen && p->prio == best_prio;
-	if (skip_for_load ||
-	    !can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {

+        if (!can_migrate_task(p, busiest, this_cpu, sd, idle, &pinned)) {
  		best_prio_seen |= p->prio == best_prio;
  		p = iterator->next(iterator->arg);
  		goto next;
@@ -2218,6 +2423,10 @@ find_busiest_group(struct sched_domain *
  	unsigned long min_nr_running = ULONG_MAX;
  	struct sched_group *group_min = NULL, *group_leader = NULL;
  #endif
+        struct rq *this_rq = cpu_rq(this_cpu);
+        unsigned long nr_moved = 0;
+        int found_highest_cpu, highest_cpu = -1, this_group_ok;
+        struct sched_group *highest_group = NULL;

  	max_load = this_load = total_load = total_pwr = 0;
  	busiest_load_per_task = busiest_nr_running = 0;
@@ -2244,6 +2453,8 @@ find_busiest_group(struct sched_domain *
  		/* Tally up the load of all CPUs in the group */
  		sum_weighted_load = sum_nr_running = avg_load = 0;

+                found_highest_cpu = 0;
+                this_group_ok = 0;
  		for_each_cpu_mask(i, group->cpumask) {
  			struct rq *rq;

@@ -2252,6 +2463,17 @@ find_busiest_group(struct sched_domain *

  			rq = cpu_rq(i);

+                        if (idle == CPU_NEWLY_IDLE && !nr_moved &&
+                            this_rq->active->round == dwrr_highest_round &&
+                            rq->active->round + 1 == dwrr_highest_round) {
+                                double_lock_balance(this_rq, rq);
+                                nr_moved = move_round_expired_tasks(this_rq,
+                                     this_cpu, rq,
+                                     (rq->round_expired->nr_running + 1)/2);
+                                spin_unlock(&rq->lock);
+                        } else if (rq->active->round == dwrr_highest_round)
+                                found_highest_cpu = 1;
+
  			if (*sd_idle && rq->nr_running)
  				*sd_idle = 0;

@@ -2269,7 +2491,27 @@ find_busiest_group(struct sched_domain *
  			avg_load += load;
  			sum_nr_running += rq->nr_running;
  			sum_weighted_load += weighted_cpuload(i);
-		}
+                        if (found_highest_cpu && !local_group &&
+                                        rq->active->nr_running >= 2) {
+                                this_group_ok = 1;
+                                if (highest_cpu == -1) {
+                                        highest_cpu = i;
+                                        highest_group = group;
+                                }
+                        }
+		}
+                if (!found_highest_cpu ||
+                           (idle == CPU_NEWLY_IDLE && !this_group_ok)) {
+                        if (local_group) {
+                                avg_load = sg_div_cpu_power(group,
+                                             avg_load * SCHED_LOAD_SCALE);
+                                this_load = avg_load;
+                                this = group;
+                                this_nr_running = sum_nr_running;
+                                this_load_per_task = sum_weighted_load;
+                        }
+                        goto dwrr_group_next;
+                }

  		/*
  		 * First idle cpu or the first cpu(busiest) in this sched group
@@ -2361,6 +2603,7 @@ find_busiest_group(struct sched_domain *
  		}
  group_next:
  #endif
+dwrr_group_next:
  		group = group->next;
  	} while (group != sd->groups);

@@ -2429,6 +2672,9 @@ small_imbalance:
  		if (max_load - this_load + SCHED_LOAD_SCALE_FUZZ >=
  					busiest_load_per_task * imbn) {
  			*imbalance = busiest_load_per_task;
+                        if (idle == CPU_NEWLY_IDLE &&
+                                (*imbalance == 0 || highest_cpu == -1))
+                                goto ret;
  			return busiest;
  		}

@@ -2479,10 +2725,20 @@ out_balanced:

  	if (this == group_leader && group_leader != group_min) {
  		*imbalance = min_load_per_task;
+                if (idle == CPU_NEWLY_IDLE &&
+                                (*imbalance == 0 || highest_cpu == -1))
+                        goto ret;
  		return group_min;
  	}
  #endif
  ret:
+        if (idle == CPU_NEWLY_IDLE && highest_cpu != -1) {
+                /* No enough imbalance, so we force one task to be moved
+                 * over to the newly idle cpu to ensure SMP fairness. */
+                *imbalance = LONG_MAX; /* signifies forced migration */
+                BUG_ON(!highest_group);
+                return highest_group;
+        }
  	*imbalance = 0;
  	return NULL;
  }
@@ -2509,6 +2765,10 @@ find_busiest_queue(struct sched_group *g

  		if (rq->nr_running == 1 && wl > imbalance)
  			continue;
+                if (idle == CPU_NEWLY_IDLE && rq->nr_running == 1)
+                        continue;
+                if (rq->active->round != dwrr_highest_round)
+                        continue;

  		if (wl > max_load) {
  			max_load = wl;
@@ -2545,6 +2805,18 @@ static int load_balance(int this_cpu, st
  	cpumask_t cpus = CPU_MASK_ALL;
  	unsigned long flags;

+        /* Only CPUs in the highest round perform load balancing and this is
+         * the common case. */
+        if (this_rq->active->round < dwrr_highest_round && !idle_cpu(this_cpu))
+                return 0;
+
+        read_lock_irqsave(&dwrr_highest_lock, flags);
+        if (this_rq->active->round < dwrr_highest_round
+                        && !idle_cpu(this_cpu)) {
+                read_unlock_irqrestore(&dwrr_highest_lock, flags);
+                return 0;
+        }
+
  	/*
  	 * When power savings policy is enabled for the parent domain, idle
  	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -2615,32 +2887,11 @@ redo:
  		sd->nr_balance_failed++;

  		if (unlikely(sd->nr_balance_failed > sd->cache_nice_tries+2)) {
-
-			spin_lock_irqsave(&busiest->lock, flags);
-
-			/* don't kick the migration_thread, if the curr
-			 * task on busiest cpu can't be moved to this_cpu
-			 */
-			if (!cpu_isset(this_cpu, busiest->curr->cpus_allowed)) {
-				spin_unlock_irqrestore(&busiest->lock, flags);
-				all_pinned = 1;
-				goto out_one_pinned;
-			}
-
-			if (!busiest->active_balance) {
-				busiest->active_balance = 1;
-				busiest->push_cpu = this_cpu;
-				active_balance = 1;
-			}
-			spin_unlock_irqrestore(&busiest->lock, flags);
-			if (active_balance)
-				wake_up_process(busiest->migration_thread);
-
-			/*
-			 * We've kicked active balancing, reset the failure
-			 * counter.
-			 */
-			sd->nr_balance_failed = sd->cache_nice_tries+1;
+			/* Don't do active balance---DWRR controls when
+			 * load balancing is necessary to ensure SMP 
+			 * fairness. */
+                        all_pinned = 1;
+                        goto out_one_pinned;
  		}
  	} else
  		sd->nr_balance_failed = 0;
@@ -2660,8 +2911,11 @@ redo:
  	}

  	if (!nr_moved && !sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE)) {
+                read_unlock_irqrestore(&dwrr_highest_lock, flags);
  		return -1;
+	}
+        read_unlock_irqrestore(&dwrr_highest_lock, flags);
  	return nr_moved;

  out_balanced:
@@ -2676,8 +2930,11 @@ out_one_pinned:
  		sd->balance_interval *= 2;

  	if (!sd_idle && sd->flags & SD_SHARE_CPUPOWER &&
-	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE))
+	    !test_sd_parent(sd, SD_POWERSAVINGS_BALANCE)) {
+                read_unlock_irqrestore(&dwrr_highest_lock, flags);
  		return -1;
+	}
+        read_unlock_irqrestore(&dwrr_highest_lock, flags);
  	return 0;
  }

@@ -2699,6 +2956,7 @@ load_balance_newidle(int this_cpu, struc
  	int all_pinned = 0;
  	cpumask_t cpus = CPU_MASK_ALL;

+	BUG_ON(this_rq->active->round != dwrr_highest_round);
  	/*
  	 * When power savings policy is enabled for the parent domain, idle
  	 * sibling can pick up load irrespective of busy siblings. In this case,
@@ -2722,7 +2980,11 @@ redo:
  				&cpus);
  	if (!busiest) {
  		schedstat_inc(sd, lb_nobusyq[CPU_NEWLY_IDLE]);
-		goto out_balanced;
+                /* find_busiest_group() found a busy group but
+                 * find_busiest_queue failed because tasks on the busiest
+                 * queue have exited. Let's re-search to find the next
+                 * busiest group. */
+                goto redo;
  	}

  	BUG_ON(busiest == this_rq);
@@ -2745,6 +3007,17 @@ redo:
  				goto redo;
  		}
  	}
+        else {
+		/* 
+		 * Two cases we may get here: (1) we found the busiest
+		 * queue but all its tasks have exited; (2) the busiest
+		 * queue we found has only one, but high load task. In
+		 * both cases, we should re-search for the busiest queue.
+		 */
+                cpu_clear(cpu_of(busiest), cpus);
+                if (!cpus_empty(cpus))
+                        goto redo;
+        }

  	if (!nr_moved) {
  		schedstat_inc(sd, lb_failed[CPU_NEWLY_IDLE]);
@@ -2790,7 +3063,7 @@ static void idle_balance(int this_cpu, s
  		interval = msecs_to_jiffies(sd->balance_interval);
  		if (time_after(next_balance, sd->last_balance + interval))
  			next_balance = sd->last_balance + interval;
-		if (pulled_task)
+		if (pulled_task > 0)
  			break;
  	}
  	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
@@ -2815,6 +3088,7 @@ static void active_load_balance(struct r
  	int target_cpu = busiest_rq->push_cpu;
  	struct sched_domain *sd;
  	struct rq *target_rq;
+        unsigned long flags;

  	/* Is there any task to move? */
  	if (busiest_rq->nr_running <= 1)
@@ -2829,6 +3103,17 @@ static void active_load_balance(struct r
  	 */
  	BUG_ON(busiest_rq == target_rq);

+        preempt_disable();
+        spin_unlock(&busiest_rq->lock);
+        /*
+         * The read lock is necessary for getting the correct
+         * dwrr_highest_round value for target cpu that is potentially idle.
+         * It must be acquired before the rq locks to avoid deadlock.
+         */
+        read_lock_irqsave(&dwrr_highest_lock, flags);
+        spin_lock(&busiest_rq->lock);
+        preempt_enable();
+
  	/* move a task from busiest_rq to target_rq */
  	double_lock_balance(busiest_rq, target_rq);

@@ -2850,6 +3135,7 @@ static void active_load_balance(struct r
  			schedstat_inc(sd, alb_failed);
  	}
  	spin_unlock(&target_rq->lock);
+	read_unlock_irqrestore(&dwrr_highest_lock, flags);
  }

  #ifdef CONFIG_NO_HZ
@@ -3329,7 +3615,7 @@ pick_next_task(struct rq *rq, struct tas
  	 * Optimization: we know that if all tasks are in
  	 * the fair class we can call that function directly:
  	 */
-	if (likely(rq->nr_running == rq->cfs.nr_running)) {
+        if (likely(rq->nr_running == rq->active->nr_running)) {
  		p = fair_sched_class.pick_next_task(rq, now);
  		if (likely(p))
  			return p;
@@ -3375,6 +3661,10 @@ need_resched_nonpreemptible:
  	spin_lock_irq(&rq->lock);
  	clear_tsk_need_resched(prev);

+        /* prev was inserted into round_expired. */
+        if (prev->se.on_rq == rq->round_expired)
+                dec_nr_running(prev, rq, __rq_clock(rq));
+
  	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
  		if (unlikely((prev->state & TASK_INTERRUPTIBLE) &&
  				unlikely(signal_pending(prev)))) {
@@ -3385,13 +3675,80 @@ need_resched_nonpreemptible:
  		switch_count = &prev->nvcsw;
  	}

-	if (unlikely(!rq->nr_running))
-		idle_balance(cpu, rq);
-
-	now = __rq_clock(rq);
+        now = 0;
+        if (unlikely(!rq->nr_running)) {
+                unsigned long flags = 0;
+                int write_unlocked = 0;
+                if (rq->active->round == dwrr_highest_round) {
+                        preempt_disable();
+                        spin_unlock(&rq->lock);
+                        write_lock_irqsave(&dwrr_highest_lock, flags);
+                        spin_lock(&rq->lock);
+                        preempt_enable();
+                        if (rq->active->round != dwrr_highest_round ||
+                                rq->nr_running) {
+                                write_unlocked = 1;
+                                write_unlock_irqrestore(&dwrr_highest_lock,
+                                                flags);
+                        } else
+                                idle_balance(cpu, rq);
+                } else
+                        write_unlocked = 1;
+
+                if (!rq->nr_running) {
+                        if (unlikely(!rq->round_expired->nr_running)) {
+                                if (!write_unlocked)
+                                        write_unlock_irqrestore(
+                                                &dwrr_highest_lock, flags);
+                                goto switch_tasks;
+                        } else {
+                                /* Switch active and round_expired. */
+                                struct cfs_rq *cfs_rq = rq->active;
+                                rq->active = rq->round_expired;
+                                rq->active->fair_clock = cfs_rq->fair_clock;
+                                rq->active->exec_clock = cfs_rq->exec_clock;
+                                rq->active->sleeper_bonus =
+                                        cfs_rq->sleeper_bonus;
+                                rq->active->wait_runtime_overruns =
+                                        cfs_rq->wait_runtime_overruns;
+                                rq->active->wait_runtime_underruns =
+                                        cfs_rq->wait_runtime_underruns;
+                                rq->round_expired = cfs_rq;
+                                rq->round_expired->round =
+                                        rq->active->round + 1;
+                                rq->nr_running = rq->active->nr_running;
+                                update_load_add(&rq->ls.load,
+                                                rq->active->load.weight);
+                                if (rq->active->round > dwrr_highest_round)
+                                        dwrr_highest_round = rq->active->round;
+                                /* Since we bypassed enqueue_entity(), each
+                                 * task's wait_start and wait_start_fair
+                                 * were not set properly. For all tasks, 
+				 * they should equal now. Record it in rq. */
+                                now = __rq_clock(rq);
+                                rq->active->wait_start_fair =
+                                        rq->active->fair_clock;
+                                rq->active->wait_start = now;
+                                if (!write_unlocked)
+                                        write_unlock_irqrestore(
+                                                &dwrr_highest_lock, flags);
+                        }
+                } 
+		else if (!write_unlocked)
+                        write_unlock_irqrestore(&dwrr_highest_lock, flags);
+        }
+
+switch_tasks:
+        if (!now)
+                now = __rq_clock(rq);
  	prev->sched_class->put_prev_task(rq, prev, now);
  	next = pick_next_task(rq, prev, now);

+        if (next == rq->idle) {
+                rq->active->round = 0;
+                rq->round_expired->round = 1;
+        }
+
  	sched_info_switch(prev, next);

  	if (likely(prev != next)) {
@@ -3831,7 +4188,8 @@ EXPORT_SYMBOL(sleep_on_timeout);
  void rt_mutex_setprio(struct task_struct *p, int prio)
  {
  	unsigned long flags;
-	int oldprio, on_rq;
+	int oldprio;
+        struct cfs_rq *on_rq;
  	struct rq *rq;
  	u64 now;

@@ -3842,7 +4200,8 @@ void rt_mutex_setprio(struct task_struct

  	oldprio = p->prio;
  	on_rq = p->se.on_rq;
-	if (on_rq)
+        if (on_rq == rq->active ||
+                        (on_rq == rq->round_expired && rt_prio(prio)))
  		dequeue_task(rq, p, 0, now);

  	if (rt_prio(prio))
@@ -3852,8 +4211,11 @@ void rt_mutex_setprio(struct task_struct

  	p->prio = prio;

-	if (on_rq) {
+        if (on_rq == rq->active ||
+                        (on_rq == rq->round_expired && rt_prio(prio))) {
  		enqueue_task(rq, p, 0, now);
+                if (on_rq == rq->round_expired)
+                        inc_nr_running(p, rq, now);
  		/*
  		 * Reschedule if we are currently running on this runqueue and
  		 * our priority decreased, or if we are not currently running on
@@ -3873,7 +4235,8 @@ void rt_mutex_setprio(struct task_struct

  void set_user_nice(struct task_struct *p, long nice)
  {
-	int old_prio, delta, on_rq;
+	int old_prio, delta;
+        struct cfs_rq *on_rq;
  	unsigned long flags;
  	struct rq *rq;
  	u64 now;
@@ -3897,7 +4260,7 @@ void set_user_nice(struct task_struct *p
  		goto out_unlock;
  	}
  	on_rq = p->se.on_rq;
-	if (on_rq) {
+        if (on_rq == rq->active) {
  		dequeue_task(rq, p, 0, now);
  		dec_load(rq, p, now);
  	}
@@ -3908,7 +4271,7 @@ void set_user_nice(struct task_struct *p
  	p->prio = effective_prio(p);
  	delta = p->prio - old_prio;

-	if (on_rq) {
+        if (on_rq == rq->active) {
  		enqueue_task(rq, p, 0, now);
  		inc_load(rq, p, now);
  		/*
@@ -4066,7 +4429,8 @@ __setscheduler(struct rq *rq, struct tas
  int sched_setscheduler(struct task_struct *p, int policy,
  		       struct sched_param *param)
  {
-	int retval, oldprio, oldpolicy = -1, on_rq;
+	int retval, oldprio, oldpolicy = -1;
+        struct cfs_rq *on_rq;
  	unsigned long flags;
  	struct rq *rq;

@@ -4885,7 +5249,9 @@ EXPORT_SYMBOL_GPL(set_cpus_allowed);
  static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
  {
  	struct rq *rq_dest, *rq_src;
-	int ret = 0, on_rq;
+        struct cfs_rq *on_rq;
+        int ret = 0, highest_locked = 0;
+        unsigned long flags = 0;

  	if (unlikely(cpu_is_offline(dest_cpu)))
  		return ret;
@@ -4893,6 +5259,23 @@ static int __migrate_task(struct task_st
  	rq_src = cpu_rq(src_cpu);
  	rq_dest = cpu_rq(dest_cpu);

+        /* If we move a task to an idle rq_dest, we'll need to acquire
+         * dwrr_highest_read_lock so that we can correctly update the idle
+         * cpu's round number. We could acquire the lock only if rq_dest is
+         * idle, but a subtle case is that rq_dest is busy now but later
+         * becomes idle when we enqueue a task to it. Thus, we
+         * conservatively acquire the lock regardless of the state of
+         * rq_dest. */
+
+        if (!rt_task(p)) {
+                read_lock_irqsave(&dwrr_highest_lock, flags);
+                highest_locked = 1;
+                if (cpu_isset(src_cpu, p->cpus_allowed) &&
+                        rq_dest->curr != rq_dest->idle &&
+                        rq_dest->active->round != dwrr_highest_round)
+                        goto out_dwrr;
+        }
+
  	double_rq_lock(rq_src, rq_dest);
  	/* Already moved. */
  	if (task_cpu(p) != src_cpu)
@@ -4912,6 +5295,9 @@ static int __migrate_task(struct task_st
  	ret = 1;
  out:
  	double_rq_unlock(rq_src, rq_dest);
+out_dwrr:
+        if (highest_locked)
+                read_unlock_irqrestore(&dwrr_highest_lock, flags);
  	return ret;
  }

@@ -5842,6 +6228,8 @@ static int build_sched_domains(const cpu
  				SD_NODES_PER_DOMAIN*cpus_weight(nodemask)) {
  			sd = &per_cpu(allnodes_domains, i);
  			*sd = SD_ALLNODES_INIT;
+                        sd->flags |= (SD_BALANCE_NEWIDLE | SD_BALANCE_FORK
+                                        | SD_BALANCE_EXEC);
  			sd->span = *cpu_map;
  			cpu_to_allnodes_group(i, cpu_map, &sd->groups);
  			p = sd;
@@ -5851,6 +6239,7 @@ static int build_sched_domains(const cpu

  		sd = &per_cpu(node_domains, i);
  		*sd = SD_NODE_INIT;
+                sd->flags |= SD_BALANCE_NEWIDLE;
  		sd->span = sched_domain_node_span(cpu_to_node(i));
  		sd->parent = p;
  		if (p)
@@ -5861,6 +6250,7 @@ static int build_sched_domains(const cpu
  		p = sd;
  		sd = &per_cpu(phys_domains, i);
  		*sd = SD_CPU_INIT;
+                sd->flags |= SD_BALANCE_FORK;
  		sd->span = nodemask;
  		sd->parent = p;
  		if (p)
@@ -5871,6 +6261,7 @@ static int build_sched_domains(const cpu
  		p = sd;
  		sd = &per_cpu(core_domains, i);
  		*sd = SD_MC_INIT;
+                sd->flags |= SD_BALANCE_FORK;
  		sd->span = cpu_coregroup_map(i);
  		cpus_and(sd->span, sd->span, *cpu_map);
  		sd->parent = p;
@@ -5882,6 +6273,7 @@ static int build_sched_domains(const cpu
  		p = sd;
  		sd = &per_cpu(cpu_domains, i);
  		*sd = SD_SIBLING_INIT;
+                sd->flags |= SD_BALANCE_FORK;
  		sd->span = cpu_sibling_map[i];
  		cpus_and(sd->span, sd->span, *cpu_map);
  		sd->parent = p;
@@ -6271,13 +6663,18 @@ int in_sched_functions(unsigned long add
  		&& addr < (unsigned long)__sched_text_end);
  }

-static inline void init_cfs_rq(struct cfs_rq *cfs_rq, struct rq *rq)
+static inline void init_cfs_rq(struct rq *rq)
  {
-	cfs_rq->tasks_timeline = RB_ROOT;
-	cfs_rq->fair_clock = 1;
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	cfs_rq->rq = rq;
-#endif
+        rq->active = rq->cfs;
+        rq->round_expired = rq->cfs + 1;
+        rq->active->tasks_timeline = RB_ROOT;
+        rq->active->fair_clock = 1;
+        rq->active->round = 0;
+        rq->round_expired->tasks_timeline = RB_ROOT;
+        rq->round_expired->fair_clock = 1;
+        rq->round_expired->round = 1;
+        rq->active->rq = rq;
+        rq->round_expired->rq = rq;
  }

  void __init sched_init(void)
@@ -6302,10 +6699,10 @@ void __init sched_init(void)
  		lockdep_set_class(&rq->lock, &rq->rq_lock_key);
  		rq->nr_running = 0;
  		rq->clock = 1;
-		init_cfs_rq(&rq->cfs, rq);
+		init_cfs_rq(rq);
  #ifdef CONFIG_FAIR_GROUP_SCHED
  		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
-		list_add(&rq->cfs.leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
+                list_add(&rq->active->leaf_cfs_rq_list, &rq->leaf_cfs_rq_list);
  #endif
  		rq->ls.load_update_last = now;
  		rq->ls.load_update_start = now;
@@ -6394,7 +6791,7 @@ void normalize_rt_tasks(void)
  	struct task_struct *g, *p;
  	unsigned long flags;
  	struct rq *rq;
-	int on_rq;
+        struct cfs_rq *on_rq;

  	read_lock_irq(&tasklist_lock);
  	do_each_thread(g, p) {
@@ -6406,7 +6803,7 @@ void normalize_rt_tasks(void)
  		p->se.sleep_start		= 0;
  		p->se.sleep_start_fair		= 0;
  		p->se.block_start		= 0;
-		task_rq(p)->cfs.fair_clock	= 0;
+                task_rq(p)->active->fair_clock	= 0;
  		task_rq(p)->clock		= 0;

  		if (!rt_task(p)) {
diff -uprN linux-2.6.23-rc1/kernel/sched_debug.c linux-2.6.23-rc1-dwrr/kernel/sched_debug.c
--- linux-2.6.23-rc1/kernel/sched_debug.c	2007-07-22 18:42:28.000000000 -0700
+++ linux-2.6.23-rc1-dwrr/kernel/sched_debug.c	2007-07-22 21:37:19.000000000 -0700
@@ -40,7 +40,7 @@ print_task(struct seq_file *m, struct rq
  		      "%15Ld %15Ld %15Ld %15Ld %15Ld\n",
  		p->comm, p->pid,
  		(long long)p->se.fair_key,
-		(long long)(p->se.fair_key - rq->cfs.fair_clock),
+		(long long)(p->se.fair_key - rq->active->fair_clock),
  		(long long)p->se.wait_runtime,
  		(long long)(p->nvcsw + p->nivcsw),
  		p->prio,
@@ -72,6 +72,11 @@ static void print_rq(struct seq_file *m,
  		if (!p->se.on_rq || task_cpu(p) != rq_cpu)
  			continue;

+                if (p->se.on_rq == rq->active)
+                        SEQ_printf(m, "[active] ");
+                else
+                        SEQ_printf(m, "[expired] ");
+
  		print_task(m, rq, p, now);
  	} while_each_thread(g, p);

@@ -114,6 +119,7 @@ void print_cfs_rq(struct seq_file *m, in
  	P(wait_runtime_overruns);
  	P(wait_runtime_underruns);
  	P(sleeper_bonus);
+	P(round);
  #undef P

  	print_cfs_rq_runtime_sum(m, cpu, cfs_rq);
diff -uprN linux-2.6.23-rc1/kernel/sched_fair.c linux-2.6.23-rc1-dwrr/kernel/sched_fair.c
--- linux-2.6.23-rc1/kernel/sched_fair.c	2007-07-22 18:42:28.000000000 -0700
+++ linux-2.6.23-rc1-dwrr/kernel/sched_fair.c	2007-07-22 21:58:05.000000000 -0700
@@ -62,6 +62,14 @@ unsigned int sysctl_sched_stat_granulari
  unsigned int sysctl_sched_runtime_limit __read_mostly;

  /*
+ * DWRR base round slice. For each sched_entity, its round slice equals its
+ * normalized weight (i.e., weight/NICE_0_LOAD) multipled by the base round
+ * slice and controls how long it runs in a round.
+ * (default: 30 msec, units: nanoseconds)
+ */
+u64 sysctl_sched_base_round_slice __read_mostly = 30000000;
+
+/*
   * Debugging: various feature bits
   */
  enum {
@@ -87,14 +95,14 @@ extern struct sched_class fair_sched_cla
   * CFS operations on generic schedulable entities:
   */

-#ifdef CONFIG_FAIR_GROUP_SCHED
-
  /* cpu runqueue to which this cfs_rq is attached */
  static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
  {
  	return cfs_rq->rq;
  }

+#ifdef CONFIG_FAIR_GROUP_SCHED
+
  /* currently running entity (if any) on this cfs_rq */
  static inline struct sched_entity *cfs_rq_curr(struct cfs_rq *cfs_rq)
  {
@@ -112,11 +120,6 @@ set_cfs_rq_curr(struct cfs_rq *cfs_rq, s

  #else	/* CONFIG_FAIR_GROUP_SCHED */

-static inline struct rq *rq_of(struct cfs_rq *cfs_rq)
-{
-	return container_of(cfs_rq, struct rq, cfs);
-}
-
  static inline struct sched_entity *cfs_rq_curr(struct cfs_rq *cfs_rq)
  {
  	struct rq *rq = rq_of(cfs_rq);
@@ -139,6 +142,12 @@ static inline struct task_struct *task_o
  	return container_of(se, struct task_struct, se);
  }

+static inline u64 weight_to_round_slice(unsigned long weight)
+{
+        /* Nice 0 receives round slice of sysctl_sched_base_round_slice;
+         * others proportional to their weight. */
+        return (weight * sysctl_sched_base_round_slice) >> NICE_0_SHIFT;
+}

  /**************************************************************
   * Scheduling class tree data structure manipulation methods:
@@ -150,6 +159,7 @@ static inline struct task_struct *task_o
  static inline void
  __enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se)
  {
+        struct rq *rq = rq_of(cfs_rq);
  	struct rb_node **link = &cfs_rq->tasks_timeline.rb_node;
  	struct rb_node *parent = NULL;
  	struct sched_entity *entry;
@@ -185,7 +195,9 @@ __enqueue_entity(struct cfs_rq *cfs_rq,
  	rb_insert_color(&se->run_node, &cfs_rq->tasks_timeline);
  	update_load_add(&cfs_rq->load, se->load.weight);
  	cfs_rq->nr_running++;
-	se->on_rq = 1;
+        se->on_rq = cfs_rq;
+        if (cfs_rq == rq->round_expired)
+                se->wait_runtime = 0;
  }

  static inline void
@@ -196,7 +208,7 @@ __dequeue_entity(struct cfs_rq *cfs_rq,
  	rb_erase(&se->run_node, &cfs_rq->tasks_timeline);
  	update_load_sub(&cfs_rq->load, se->load.weight);
  	cfs_rq->nr_running--;
-	se->on_rq = 0;
+	se->on_rq = NULL;
  }

  static inline struct rb_node *first_fair(struct cfs_rq *cfs_rq)
@@ -340,6 +352,7 @@ static void update_curr(struct cfs_rq *c
  	delta_exec = (unsigned long)(now - curr->exec_start);

  	curr->delta_exec += delta_exec;
+        curr->round_slice_used += delta_exec;

  	if (unlikely(curr->delta_exec > sysctl_sched_stat_granularity)) {
  		__update_curr(cfs_rq, curr, now);
@@ -383,13 +396,19 @@ calc_weighted(unsigned long delta, unsig
  static void
  update_stats_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
  {
+        struct rq *rq = rq_of(cfs_rq);
  	s64 key;

+        /* Are we enqueueing a round-expired task? */
+        if (cfs_rq == rq->round_expired)
+                /* Flag wait_start as invalid and re-compute it when
+                 * the task moves back to active. */
+                se->wait_start = ULLONG_MAX;
  	/*
  	 * Are we enqueueing a waiting task? (for current tasks
  	 * a dequeue/enqueue event is a NOP)
  	 */
-	if (se != cfs_rq_curr(cfs_rq))
+	else if (se != cfs_rq_curr(cfs_rq))
  		update_stats_wait_start(cfs_rq, se, now);
  	/*
  	 * Update the key:
@@ -445,8 +464,19 @@ update_stats_wait_end(struct cfs_rq *cfs
  {
  	unsigned long delta_fair;

-	delta_fair = (unsigned long)min((u64)(2*sysctl_sched_runtime_limit),
+        if (se->on_rq == rq_of(cfs_rq)->round_expired)
+                delta_fair = 0;
+        else {
+                if (se->wait_start == ULLONG_MAX) {
+                        /* First time here since se was moved from
+                         * round-expired to active. */
+                        se->wait_start_fair = cfs_rq->wait_start_fair;
+                        se->wait_start = cfs_rq->wait_start;
+                }
+                delta_fair = (unsigned long)min(
+                        (u64)(2*sysctl_sched_runtime_limit),
  			(u64)(cfs_rq->fair_clock - se->wait_start_fair));
+	}

  	se->delta_fair_run += delta_fair;
  	if (unlikely(abs(se->delta_fair_run) >=
@@ -462,7 +492,7 @@ update_stats_wait_end(struct cfs_rq *cfs
  static inline void
  update_stats_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se, u64 now)
  {
-	update_curr(cfs_rq, now);
+        update_curr(rq_of(cfs_rq)->active, now);
  	/*
  	 * Mark the end of the wait period if dequeueing a
  	 * waiting task:
@@ -585,12 +615,14 @@ static void
  enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se,
  	       int wakeup, u64 now)
  {
+        struct rq *rq = rq_of(cfs_rq);
+
  	/*
  	 * Update the fair clock.
  	 */
-	update_curr(cfs_rq, now);
+        update_curr(rq->active, now);

-	if (wakeup)
+        if (cfs_rq == rq->active && wakeup)
  		enqueue_sleeper(cfs_rq, se, now);

  	update_stats_enqueue(cfs_rq, se, now);
@@ -626,15 +658,22 @@ static void
  __check_preempt_curr_fair(struct cfs_rq *cfs_rq, struct sched_entity *se,
  			  struct sched_entity *curr, unsigned long granularity)
  {
-	s64 __delta = curr->fair_key - se->fair_key;
+        s64 __delta = 0;
+        struct rq *rq = rq_of(cfs_rq);
+
+        if (se)
+                __delta = curr->fair_key - se->fair_key;

  	/*
  	 * Take scheduling granularity into account - do not
  	 * preempt the current task unless the best task has
-	 * a larger than sched_granularity fairness advantage:
-	 */
-	if (__delta > niced_granularity(curr, granularity))
-		resched_task(rq_of(cfs_rq)->curr);
+         * a larger than sched_granularity fairness advantage.
+         * Always preempt the current task if it's been moved
+         * to round_expired.
+         */
+        if (__delta > niced_granularity(curr, granularity)
+                        || curr->on_rq == rq->round_expired)
+                resched_task(rq->curr);
  }

  static inline void
@@ -664,6 +703,8 @@ static struct sched_entity *pick_next_en
  static void
  put_prev_entity(struct cfs_rq *cfs_rq, struct sched_entity *prev, u64 now)
  {
+        struct rq *rq = rq_of(cfs_rq);
+
  	/*
  	 * If still on the runqueue then deactivate_task()
  	 * was not called and update_curr() has to be done:
@@ -673,7 +714,7 @@ put_prev_entity(struct cfs_rq *cfs_rq, s

  	update_stats_curr_end(cfs_rq, prev, now);

-	if (prev->on_rq)
+        if (prev->on_rq == rq->active)
  		update_stats_wait_start(cfs_rq, prev, now);
  	set_cfs_rq_curr(cfs_rq, NULL);
  }
@@ -683,20 +724,37 @@ static void entity_tick(struct cfs_rq *c
  	struct rq *rq = rq_of(cfs_rq);
  	struct sched_entity *next;
  	u64 now = __rq_clock(rq);
+        u64 round_slice;
+
+        if (curr->on_rq == rq->round_expired) {
+                /* Task is in round expired but was not scheduled yet. */
+                set_tsk_need_resched(rq_of(cfs_rq)->curr);
+                return;
+        }

  	/*
  	 * Dequeue and enqueue the task to update its
  	 * position within the tree:
  	 */
  	dequeue_entity(cfs_rq, curr, 0, now);
-	enqueue_entity(cfs_rq, curr, 0, now);
+
+        /* Check if the task has used up its entitled round slice. */
+        round_slice = weight_to_round_slice(curr->load.weight);
+        if (curr->round_slice_used >= round_slice) {
+                curr->round_slice_used -= round_slice;
+                enqueue_entity(rq->round_expired, curr, 0, now);
+        } else
+                enqueue_entity(cfs_rq, curr, 0, now);

  	/*
  	 * Reschedule if another task tops the current one.
  	 */
-	next = __pick_next_entity(cfs_rq);
-	if (next == curr)
-		return;
+        if (cfs_rq->nr_running) {
+                next = __pick_next_entity(cfs_rq);
+                if (next == curr)
+                        return;
+        } else
+                next = NULL;

  	__check_preempt_curr_fair(cfs_rq, next, curr, sysctl_sched_granularity);
  }
@@ -734,7 +792,7 @@ static inline struct cfs_rq *group_cfs_r
  static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
  {
  	/* A later patch will take group into account */
-	return &cpu_rq(this_cpu)->cfs;
+	return cpu_rq(this_cpu)->active;
  }

  /* Iterate thr' all leaf cfs_rq's on a runqueue */
@@ -757,7 +815,7 @@ static inline int is_same_group(struct t

  static inline struct cfs_rq *task_cfs_rq(struct task_struct *p)
  {
-	return &task_rq(p)->cfs;
+        return task_rq(p)->active;
  }

  static inline struct cfs_rq *cfs_rq_of(struct sched_entity *se)
@@ -765,7 +823,7 @@ static inline struct cfs_rq *cfs_rq_of(s
  	struct task_struct *p = task_of(se);
  	struct rq *rq = task_rq(p);

-	return &rq->cfs;
+	return rq->active;
  }

  /* runqueue "owned" by this group */
@@ -776,11 +834,11 @@ static inline struct cfs_rq *group_cfs_r

  static inline struct cfs_rq *cpu_cfs_rq(struct cfs_rq *cfs_rq, int this_cpu)
  {
-	return &cpu_rq(this_cpu)->cfs;
+        return cpu_rq(this_cpu)->active;
  }

  #define for_each_leaf_cfs_rq(rq, cfs_rq) \
-		for (cfs_rq = &rq->cfs; cfs_rq; cfs_rq = NULL)
+                for (cfs_rq = rq->active; cfs_rq; cfs_rq = NULL)

  static inline int is_same_group(struct task_struct *curr, struct task_struct *p)
  {
@@ -820,7 +878,7 @@ dequeue_task_fair(struct rq *rq, struct
  	struct sched_entity *se = &p->se;

  	for_each_sched_entity(se) {
-		cfs_rq = cfs_rq_of(se);
+                cfs_rq = se->on_rq;
  		dequeue_entity(cfs_rq, se, sleep, now);
  		/* Don't dequeue parent if it has other entities besides us */
  		if (cfs_rq->load.weight)
@@ -836,6 +894,8 @@ static void yield_task_fair(struct rq *r
  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
  	u64 now = __rq_clock(rq);

+        if (p->se.on_rq == rq->round_expired)
+                return;
  	/*
  	 * Dequeue and enqueue the task to update its
  	 * position within the tree:
@@ -872,7 +932,7 @@ static void check_preempt_curr_fair(stru

  static struct task_struct *pick_next_task_fair(struct rq *rq, u64 now)
  {
-	struct cfs_rq *cfs_rq = &rq->cfs;
+        struct cfs_rq *cfs_rq = rq->active;
  	struct sched_entity *se;

  	if (unlikely(!cfs_rq->nr_running))
@@ -1073,6 +1133,8 @@ static void task_new_fair(struct rq *rq,

  	__enqueue_entity(cfs_rq, se);
  	inc_nr_running(p, rq, now);
+        if (rq->curr == rq->idle)
+                dwrr_update_idle(p, rq);
  }

  #ifdef CONFIG_FAIR_GROUP_SCHED
diff -uprN linux-2.6.23-rc1/kernel/sysctl.c linux-2.6.23-rc1-dwrr/kernel/sysctl.c
--- linux-2.6.23-rc1/kernel/sysctl.c	2007-07-22 18:42:28.000000000 -0700
+++ linux-2.6.23-rc1-dwrr/kernel/sysctl.c	2007-07-22 21:59:46.000000000 -0700
@@ -217,6 +217,8 @@ static unsigned long min_sched_granulari
  static unsigned long max_sched_granularity_ns = 1000000000;	/* 1 second */
  static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
  static unsigned long max_wakeup_granularity_ns = 1000000000;	/* 1 second */
+static unsigned long min_sched_base_round_slice = NSEC_PER_TICK * 4;
+static unsigned long max_sched_base_round_slice = ULONG_MAX;
  #endif

  static ctl_table kern_table[] = {
@@ -276,6 +278,17 @@ static ctl_table kern_table[] = {
  		.extra1		= &min_sched_granularity_ns,
  		.extra2		= &max_sched_granularity_ns,
  	},
+        {
+                .ctl_name       = CTL_UNNUMBERED,
+                .procname       = "sched_base_round_slice",
+                .data           = &sysctl_sched_base_round_slice,
+                .maxlen         = sizeof(unsigned long),
+                .mode           = 0644,
+                .proc_handler   = &proc_doulongvec_minmax,
+                .strategy       = &sysctl_intvec,
+                .extra1         = &min_sched_base_round_slice,
+                .extra2         = &max_sched_base_round_slice,
+        },
  	{
  		.ctl_name	= CTL_UNNUMBERED,
  		.procname	= "sched_child_runs_first",
