Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab0CKOye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 09:54:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932424Ab0CKOyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 09:54:33 -0500
Date: Thu, 11 Mar 2010 15:52:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
Message-ID: <20100311145248.GA12907@redhat.com>
References: <20100309180615.GA11681@redhat.com> <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com> <1268244075.5279.53.camel@twins> <20100310183259.GA23648@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100310183259.GA23648@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Oleg Nesterov wrote:
>
> On 03/10, Peter Zijlstra wrote:
> >
> > Right, so if you refresh these patches, I'll feed them to mingo and they
> > should eventually end up in -linus, how's that? :-)
>
> Great. Will redo/resend tomorrow ;)

That was a great plan, but it doesn't work.

With the recent changes we have even more problems with
cpuset_cpus_allowed_locked(). Not only it misses cpuset_lock() (which
doesn't work anyway and must die imho), it is very wrong to even call
this function from try_to_wakeup() - this can deadlock.

Because task_cs() is protected by task_lock() which is not irq-safe,
and cpuset_cpus_allowed_locked() takes this lock.

We need more changes in cpuset.c. Btw, select_fallback_rq() takes
rcu_read_lock around cpuset_cpus_allowed_locked(). Why? I must have
missed something, but afaics this buys nothing.

>From the previous email:

	On 03/10, Peter Zijlstra wrote:
	>
	> On Wed, 2010-03-10 at 18:30 +0100, Oleg Nesterov wrote:
	> > On 03/10, Peter Zijlstra wrote:
	> > >
	> > > I guess the quick fix is to really bail and always use cpu_online_mask
	> > > in select_fallback_rq().
	> >
	> > Yes, but this breaks cpusets.
	>
	> Arguably, so, but you can also argue that binding a task to a cpu and
	> then unplugging that cpu without first fixing up the affinity is a 'you
	> get to keep both pieces' situation.

Well yes, but still it was supposed the kernel should handle this case
correctly, the task shouldn't escape its cpuset.

However, currently I don't see another option. I think we should fix the
possible deadlocks and kill cpuset_lock/cpuset_cpus_allowed_locked first,
then try to fix cpusets.

See the trivial (uncompiled) patch below. It just states a fact
cpuset_cpus_allowed() logic is broken.

How can we fix this later? Perhaps we can change
cpuset_track_online_cpus(CPU_DEAD) to scan all affected cpusets and
fixup the tasks with the wrong ->cpus_allowed == cpu_possible_mask.

At first glance this should work in try_to_wake_up(p) case, we can't
race with cpuset_change_cpumask()/etc because of TASK_WAKING logic.

But I am not sure how can we fix move_task_off_dead_cpu(). I think
__migrate_task_irq() itself is fine, but if select_fallback_rq() is
called from move_task_off_dead_cpu() nothing protects ->cpus_allowed.
We can race with cpusets, or even with the plain set_cpus_allowed().
Probably nothing really bad can happen, if the resulting cpumask
doesn't have online cpus due to the racing memcpys, we should retry
after __migrate_task_irq() fails. Or we can take cpu_rq(cpu)-lock
around cpumask_copy(p->cpus_allowed, cpu_possible_mask).

sched_exec() seems fine, the task is current and running,
"No more Mr. Nice Guy." case is not possible.

What do you think?

Btw, I think there is a small bug in set_cpus_allowed_ptr(),
wake_up_process(rq->migration_thread) can hit NULL, we should do
wake_up_process(mt).

Oleg.

 include/linux/cpuset.h |   10 ----------
 kernel/cpuset.c        |   29 +----------------------------
 kernel/sched.c         |    9 +++------
 3 files changed, 4 insertions(+), 44 deletions(-)

--- x/include/linux/cpuset.h
+++ x/include/linux/cpuset.h
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
--- x/kernel/cpuset.c
+++ x/kernel/cpuset.c
@@ -2148,7 +2148,7 @@ void cpuset_cpus_allowed(struct task_str
  * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
  * Must be called with callback_mutex held.
  **/
-void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
+static void cpuset_cpus_allowed_locked(struct task_struct *tsk, struct cpumask *pmask)
 {
 	task_lock(tsk);
 	guarantee_online_cpus(task_cs(tsk), pmask);
@@ -2341,33 +2341,6 @@ int __cpuset_node_allowed_hardwall(int n
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
- * cpuset_unlock - release lock on cpuset changes
- *
- * Undo the lock taken in a previous cpuset_lock() call.
- */
-
-void cpuset_unlock(void)
-{
-	mutex_unlock(&callback_mutex);
-}
-
-/**
  * cpuset_mem_spread_node() - On which node to begin search for a page
  *
  * If a task is marked PF_SPREAD_PAGE or PF_SPREAD_SLAB (as for
--- x/kernel/sched.c
+++ x/kernel/sched.c
@@ -2289,10 +2289,9 @@ static int select_fallback_rq(int cpu, s
 
 	/* No more Mr. Nice Guy. */
 	if (dest_cpu >= nr_cpu_ids) {
-		rcu_read_lock();
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		rcu_read_unlock();
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
+		// XXX: take cpu_rq(cpu)->lock ???
+		cpumask_copy(&p->cpus_allowed, cpu_possible_mask);
+		dest_cpu = cpumask_any(cpu_active_mask);
 
 		/*
 		 * Don't tell them about moving exiting tasks or
@@ -5929,7 +5928,6 @@ migration_call(struct notifier_block *nf
 
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
-		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
 		migrate_live_tasks(cpu);
 		rq = cpu_rq(cpu);
 		kthread_stop(rq->migration_thread);
@@ -5943,7 +5941,6 @@ migration_call(struct notifier_block *nf
 		rq->idle->sched_class = &idle_sched_class;
 		migrate_dead_tasks(cpu);
 		raw_spin_unlock_irq(&rq->lock);
-		cpuset_unlock();
 		migrate_nr_uninterruptible(rq);
 		BUG_ON(rq->nr_running != 0);
 		calc_global_load_remove(rq);

