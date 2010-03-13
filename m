Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563Ab0CMTaU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:30:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab0CMTaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:30:14 -0500
Date: Sat, 13 Mar 2010 20:28:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
Message-ID: <20100313192823.GA21462@redhat.com>
References: <20100309180615.GA11681@redhat.com> <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com> <1268244075.5279.53.camel@twins> <20100310183259.GA23648@redhat.com> <20100311145248.GA12907@redhat.com> <1268321759.5037.113.camel@laptop> <20100311161909.GA16008@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20100311161909.GA16008@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 03/11, Oleg Nesterov wrote:
>
> > > @@ -2289,10 +2289,9 @@ static int select_fallback_rq(int cpu, s
> > >
> > >  	/* No more Mr. Nice Guy. */
> > >  	if (dest_cpu >= nr_cpu_ids) {
> > > -		rcu_read_lock();
> > > -		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
> > > -		rcu_read_unlock();
> > > -		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
> > > +		// XXX: take cpu_rq(cpu)->lock ???
> > > +		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
> > > +		dest_cpu = cpumask_any(cpu_active_mask);
> >
> >
> > Right, this seems safe.
>
> OK, I'll try to read this code a bit more and then send this patch.

No, it is not safe :/

Peter, I seem to see the simple fix for the discussed cpuset problems,
but it turns out sched.c has more problems evem without cpusets.

I'll try to send the whole series on Monday, but perhaps you can look
at the attached compile-tested patches (especially 2 and 3) to quickly
correct me if the 3rd one is wrong.

The subsequent fix in cpuset.c depends on the locking rules enforced
by 2-3.

Oleg.


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="1_KILL_CPUSET_LOCK.patch"

[PATCH 1/5] kill the broken and deadlockable cpuset_lock/cpuset_cpus_allowed_locked code

This patch just states the fact the cpusets/cpuhotplug interaction is
broken and removes the deadlockable code which only pretends to work.

- cpuset_lock() doesn't really work. It is needed for
  cpuset_cpus_allowed_locked() but we can't take this lock in
  try_to_wake_up()->select_fallback_rq() path.

- cpuset_lock() is deadlockable. Suppose that a task T bound to CPU takes
  callback_mutex. If cpu_down(CPU) happens before T drops callback_mutex
  stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
  cpuset_lock() and hangs forever because CPU is already dead and thus
  T can't be scheduled.

- cpuset_cpus_allowed_locked() is deadlockable as well. It takes task_lock()
  which is not irq-safe, but try_to_wake_up() can be called from irq.

Kill them, and change select_fallback_rq() to use cpu_possible_mask, like
we currently do without CONFIG_CPUSETS.

Also, with or without this patch, with or without CONFIG_CPUSETS,
move_task_off_dead_cpu() and sched_exec() are wrong, the play with
->cpus_allowed lockless and can race with set_cpus_allowed() pathes.

The subsequent patches try to to fix these problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cpuset.h |   13 -------------
 kernel/cpuset.c        |   27 +--------------------------
 kernel/sched.c         |   10 +++-------
 3 files changed, 4 insertions(+), 46 deletions(-)

--- 34-rc1/include/linux/cpuset.h~1_KILL_CPUSET_LOCK	2009-06-17 14:11:26.000000000 +0200
+++ 34-rc1/include/linux/cpuset.h	2010-03-11 18:17:58.000000000 +0100
@@ -21,8 +21,6 @@ extern int number_of_cpusets;	/* How man
 extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern void cpuset_cpus_allowed_locked(struct task_struct *p,
-				       struct cpumask *mask);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -69,9 +67,6 @@ struct seq_file;
 extern void cpuset_task_status_allowed(struct seq_file *m,
 					struct task_struct *task);
 
-extern void cpuset_lock(void);
-extern void cpuset_unlock(void);
-
 extern int cpuset_mem_spread_node(void);
 
 static inline int cpuset_do_page_mem_spread(void)
@@ -105,11 +100,6 @@ static inline void cpuset_cpus_allowed(s
 {
 	cpumask_copy(mask, cpu_possible_mask);
 }
-static inline void cpuset_cpus_allowed_locked(struct task_struct *p,
-					      struct cpumask *mask)
-{
-	cpumask_copy(mask, cpu_possible_mask);
-}
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
@@ -157,9 +147,6 @@ static inline void cpuset_task_status_al
 {
 }
 
-static inline void cpuset_lock(void) {}
-static inline void cpuset_unlock(void) {}
-
 static inline int cpuset_mem_spread_node(void)
 {
 	return 0;
--- 34-rc1/kernel/cpuset.c~1_KILL_CPUSET_LOCK	2009-12-18 19:05:38.000000000 +0100
+++ 34-rc1/kernel/cpuset.c	2010-03-11 18:20:47.000000000 +0100
@@ -2140,19 +2140,10 @@ void __init cpuset_init_smp(void)
 void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 {
 	mutex_lock(&callback_mutex);
-	cpuset_cpus_allowed_locked(tsk, pmask);
-	mutex_unlock(&callback_mutex);
-}
-
-/**
- * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
- * Must be called with callback_mutex held.
- **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
-{
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), pmask);
 	task_unlock(tsk);
+	mutex_unlock(&callback_mutex);
 }
 
 void cpuset_init_current_mems_allowed(void)
@@ -2341,22 +2332,6 @@ int __cpuset_node_allowed_hardwall(int n
 }
 
 /**
- * cpuset_lock - lock out any changes to cpuset structures
- *
- * The out of memory (oom) code needs to mutex_lock cpusets
- * from being changed while it scans the tasklist looking for a
- * task in an overlapping cpuset.  Expose callback_mutex via this
- * cpuset_lock() routine, so the oom code can lock it, before
- * locking the task list.  The tasklist_lock is a spinlock, so
- * must be taken inside callback_mutex.
- */
-
-void cpuset_lock(void)
-{
-	mutex_lock(&callback_mutex);
-}
-
-/**
  * cpuset_unlock - release lock on cpuset changes
  *
  * Undo the lock taken in a previous cpuset_lock() call.
--- 34-rc1/kernel/sched.c~1_KILL_CPUSET_LOCK	2010-03-11 13:11:50.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-13 19:48:15.000000000 +0100
@@ -2288,11 +2288,9 @@ static int select_fallback_rq(int cpu, s
 		return dest_cpu;
 
 	/* No more Mr. Nice Guy. */
-	if (dest_cpu >= nr_cpu_ids) {
-		rcu_read_lock();
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		rcu_read_unlock();
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
+	if (unlikely(dest_cpu >= nr_cpu_ids)) {
+		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+		dest_cpu = cpumask_any(cpu_active_mask);
 
 		/*
 		 * Don't tell them about moving exiting tasks or
@@ -5929,7 +5927,6 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -5943,7 +5940,6 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		raw_spin_unlock_irq(&rq->lock);
-		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2_MTODC_TAKE_RQ_LOCK.patch"

[PATCH 2/5] change move_task_off_dead_cpu() to take rq->lock around select_fallback_rq()

move_task_off_dead_cpu()->select_fallback_rq() reads/updates ->cpus_allowed
lockless. We can race with set_cpus_allowed() running in parallel.

Change it to take rq->lock around select_fallback_rq(). Note that it is not
trivial to move this spin_lock() into select_fallback_rq(), we must recheck
the task was not migrated after we take the lock and other callers do not
need this lock.

We can't race with other callers of select_fallback_rq() which rely on
TASK_WAKING, try_to_wake_up() and wake_up_new_task(), they must protect
themselves against cpu hotplug anyway.

Also, change it to not assume irqs are disabled and absorb __migrate_task_irq().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/sched.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- 34-rc1/kernel/sched.c~2_MTODC_TAKE_RQ_LOCK	2010-03-13 19:48:15.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-13 19:50:57.000000000 +0100
@@ -5509,29 +5509,28 @@ static int migration_thread(void *data)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-
-static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
-{
-	int ret;
-
-	local_irq_disable();
-	ret = __migrate_task(p, src_cpu, dest_cpu);
-	local_irq_enable();
-	return ret;
-}
-
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	int dest_cpu;
-
+	struct rq *rq = cpu_rq(dead_cpu);
+	int migrated, dest_cpu;
+	unsigned long flags;
 again:
-	dest_cpu = select_fallback_rq(dead_cpu, p);
+	local_irq_save(flags);
+	raw_spin_lock(&rq->lock);
+	migrated = (task_cpu(p) != dead_cpu);
+	if (!migrated)
+		dest_cpu = select_fallback_rq(dead_cpu, p);
+	raw_spin_unlock(&rq->lock);
+
+	if (!migrated)
+		migrated = __migrate_task(p, dead_cpu, dest_cpu);
+	local_irq_restore(flags);
 
 	/* It can have affinity changed while we were choosing. */
-	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
+	if (unlikely(!migrated))
 		goto again;
 }
 

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="3_SCHED_EXEC_DONT_FALLBACK.patch"

[PATCH 3/5] sched_exec() should use select_fallback_rq() logic

sched_exec()->select_task_rq() reads/updates ->cpus_allowed lockless.
This can race with other CPUs updating our ->cpus_allowed, and this
looks meaningless to me.

The task is current and running, it must have online cpus in ->cpus_allowed,
the fallback mode is bogus. And, if ->sched_class returns the "wrong" cpu,
this likely means we raced with set_cpus_allowed() which was called
for reason, why should sched_exec() retry and call ->select_task_rq()
again?

Change the code to call sched_class->select_task_rq() directly and do
nothing if the returned cpu is wrong after re-checking under rq->lock.

>From now select_fallback_rq() is always called with either rq-lock or
TASK_WAKING held.

TODO: update the comments.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---


--- 34-rc1/kernel/sched.c~3_SCHED_EXEC_DONT_FALLBACK	2010-03-13 19:50:57.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-13 19:51:11.000000000 +0100
@@ -3123,9 +3123,8 @@ void sched_exec(void)
 	unsigned long flags;
 	struct rq *rq;
 
-again:
 	this_cpu = get_cpu();
-	dest_cpu = select_task_rq(p, SD_BALANCE_EXEC, 0);
+	dest_cpu = p->sched_class->select_task_rq(p, SD_BALANCE_EXEC, 0);
 	if (dest_cpu == this_cpu) {
 		put_cpu();
 		return;
@@ -3133,18 +3132,12 @@ again:
 
 	rq = task_rq_lock(p, &flags);
 	put_cpu();
-
 	/*
 	 * select_task_rq() can race against ->cpus_allowed
 	 */
-	if (!cpumask_test_cpu(dest_cpu, &p->cpus_allowed)
-	    || unlikely(!cpu_active(dest_cpu))) {
-		task_rq_unlock(rq, &flags);
-		goto again;
-	}
-
-	/* force the process onto the specified CPU */
-	if (migrate_task(p, dest_cpu, &req)) {
+	if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed) &&
+	    likely(cpu_active(dest_cpu)) &&
+	    migrate_task(p, dest_cpu, &req)) {
 		/* Need to wait for migration thread (might exit: take ref). */
 		struct task_struct *mt = rq->migration_thread;
 

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="4_CPU_DOWN_AFFINITY.patch"

[PATCH 4/5] _cpu_down: don't play with current->cpus_allowed

_cpu_down() changes the current task's affinity and then recovers it at
the end. The problems are well known: we can't restore old_allowed if it
was bound to the now-dead-cpu, and we can race with the userspace which
can change cpu-affinity during unplug.

_cpu_down() should not play with current->cpus_allowed at all. Instead,
take_cpu_down() can migrate the caller of _cpu_down() after __cpu_disable()
removes the dying cpu from cpu_online_mask.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 +
 kernel/sched.c        |    2 +-
 kernel/cpu.c          |   18 ++++++------------
 3 files changed, 8 insertions(+), 13 deletions(-)

--- 34-rc1/include/linux/sched.h~4_CPU_DOWN_AFFINITY	2010-03-13 17:05:55.000000000 +0100
+++ 34-rc1/include/linux/sched.h	2010-03-13 19:53:22.000000000 +0100
@@ -1843,6 +1843,7 @@ extern void sched_clock_idle_sleep_event
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
+extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
--- 34-rc1/kernel/sched.c~4_CPU_DOWN_AFFINITY	2010-03-13 19:51:11.000000000 +0100
+++ 34-rc1/kernel/sched.c	2010-03-13 19:53:22.000000000 +0100
@@ -5505,7 +5505,7 @@ static int migration_thread(void *data)
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
-static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
 	int migrated, dest_cpu;
--- 34-rc1/kernel/cpu.c~4_CPU_DOWN_AFFINITY	2010-03-13 17:05:55.000000000 +0100
+++ 34-rc1/kernel/cpu.c	2010-03-13 19:53:22.000000000 +0100
@@ -163,6 +163,7 @@ static inline void check_for_tasks(int c
 }
 
 struct take_cpu_down_param {
+	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -171,6 +172,7 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -181,6 +183,8 @@ static int __ref take_cpu_down(void *_pa
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
 				param->hcpu);
 
+	if (task_cpu(param->caller) == cpu)
+		move_task_off_dead_cpu(cpu, param->caller);
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
@@ -191,10 +195,10 @@ static int __ref take_cpu_down(void *_pa
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_var_t old_allowed;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
+		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -205,9 +209,6 @@ static int __ref _cpu_down(unsigned int 
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
-
 	cpu_hotplug_begin();
 	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
@@ -224,10 +225,6 @@ static int __ref _cpu_down(unsigned int 
 		goto out_release;
 	}
 
-	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current, cpu_active_mask);
-
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		set_cpu_active(cpu, true);
@@ -236,7 +233,7 @@ static int __ref _cpu_down(unsigned int 
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -254,8 +251,6 @@ static int __ref _cpu_down(unsigned int 
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -263,7 +258,6 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
 	return err;
 }
 

--J2SCkAp4GZ/dPZZf--

