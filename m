Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbXJJAz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbXJJAz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 20:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751632AbXJJAzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 20:55:50 -0400
Received: from mx1.suse.de ([195.135.220.2]:41156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbXJJAzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 20:55:49 -0400
Date: Wed, 10 Oct 2007 02:55:46 +0200
From: Andi Kleen <ak@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/6] scheduler: Remove some unnecessary gotos in sched.c
Message-ID: <20071010005546.GA756@bingen.suse.de>
References: <200710071059.126674000@suse.de> <20071007205954.4053C13E06@wotan.suse.de> <20071009191730.GA8887@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071009191730.GA8887@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2007 at 09:17:31PM +0200, Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > No need to be more spagetti than absolutely necessary.
> > 
> > Replace loops implemented with gotos with real loops. Replace err = 
> > ...; goto x; x: return err; with return ...;
> > 
> > No functional changes.
> 
> this crashes during bootup - removed it for now.

Boots here and also survived LTP and some other tests. 
Hmm; i had an early version that hung because I forgot a break.
Perhaps I forgot quilt refresh. Can you check you have this version? 

-Andi


Remove some unnecessary gotos in sched.c

No need to be more spagetti than absolutely necessary.

Replace loops implemented with gotos with real loops.
Replace err = ...; goto x; x: return err; with return ...; 

No functional changes.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux-2.6-sched-devel/kernel/sched.c
===================================================================
--- linux-2.6-sched-devel.orig/kernel/sched.c
+++ linux-2.6-sched-devel/kernel/sched.c
@@ -555,16 +555,13 @@ static inline void finish_lock_switch(st
 static inline struct rq *__task_rq_lock(struct task_struct *p)
 	__acquires(rq->lock)
 {
-	struct rq *rq;
-
-repeat_lock_task:
-	rq = task_rq(p);
-	spin_lock(&rq->lock);
-	if (unlikely(rq != task_rq(p))) {
+	for (;;) {
+		struct rq *rq = task_rq(p);
+		spin_lock(&rq->lock);
+		if (likely(rq == task_rq(p)))
+			return rq;
 		spin_unlock(&rq->lock);
-		goto repeat_lock_task;
 	}
-	return rq;
 }
 
 /*
@@ -577,15 +574,14 @@ static struct rq *task_rq_lock(struct ta
 {
 	struct rq *rq;
 
-repeat_lock_task:
-	local_irq_save(*flags);
-	rq = task_rq(p);
-	spin_lock(&rq->lock);
-	if (unlikely(rq != task_rq(p))) {
+	for (;;) {
+		local_irq_save(*flags);
+		rq = task_rq(p);
+		spin_lock(&rq->lock);
+		if (likely(rq == task_rq(p)))
+			return rq;
 		spin_unlock_irqrestore(&rq->lock, *flags);
-		goto repeat_lock_task;
 	}
-	return rq;
 }
 
 static void __task_rq_unlock(struct rq *rq)
@@ -1076,69 +1072,71 @@ void wait_task_inactive(struct task_stru
 	int running, on_rq;
 	struct rq *rq;
 
-repeat:
-	/*
-	 * We do the initial early heuristics without holding
-	 * any task-queue locks at all. We'll only try to get
-	 * the runqueue lock when things look like they will
-	 * work out!
-	 */
-	rq = task_rq(p);
+	for (;;) {
+		/*
+		 * We do the initial early heuristics without holding
+		 * any task-queue locks at all. We'll only try to get
+		 * the runqueue lock when things look like they will
+		 * work out!
+		 */
+		rq = task_rq(p);
 
-	/*
-	 * If the task is actively running on another CPU
-	 * still, just relax and busy-wait without holding
-	 * any locks.
-	 *
-	 * NOTE! Since we don't hold any locks, it's not
-	 * even sure that "rq" stays as the right runqueue!
-	 * But we don't care, since "task_running()" will
-	 * return false if the runqueue has changed and p
-	 * is actually now running somewhere else!
-	 */
-	while (task_running(rq, p))
-		cpu_relax();
+		/*
+		 * If the task is actively running on another CPU
+		 * still, just relax and busy-wait without holding
+		 * any locks.
+		 *
+		 * NOTE! Since we don't hold any locks, it's not
+		 * even sure that "rq" stays as the right runqueue!
+		 * But we don't care, since "task_running()" will
+		 * return false if the runqueue has changed and p
+		 * is actually now running somewhere else!
+		 */
+		while (task_running(rq, p))
+			cpu_relax();
 
-	/*
-	 * Ok, time to look more closely! We need the rq
-	 * lock now, to be *sure*. If we're wrong, we'll
-	 * just go back and repeat.
-	 */
-	rq = task_rq_lock(p, &flags);
-	running = task_running(rq, p);
-	on_rq = p->se.on_rq;
-	task_rq_unlock(rq, &flags);
+		/*
+		 * Ok, time to look more closely! We need the rq
+		 * lock now, to be *sure*. If we're wrong, we'll
+		 * just go back and repeat.
+		 */
+		rq = task_rq_lock(p, &flags);
+		running = task_running(rq, p);
+		on_rq = p->se.on_rq;
+		task_rq_unlock(rq, &flags);
 
-	/*
-	 * Was it really running after all now that we
-	 * checked with the proper locks actually held?
-	 *
-	 * Oops. Go back and try again..
-	 */
-	if (unlikely(running)) {
-		cpu_relax();
-		goto repeat;
-	}
+		/*
+		 * Was it really running after all now that we
+		 * checked with the proper locks actually held?
+		 *
+		 * Oops. Go back and try again..
+		 */
+		if (unlikely(running)) {
+			cpu_relax();
+			continue;
+		}
 
-	/*
-	 * It's not enough that it's not actively running,
-	 * it must be off the runqueue _entirely_, and not
-	 * preempted!
-	 *
-	 * So if it wa still runnable (but just not actively
-	 * running right now), it's preempted, and we should
-	 * yield - it could be a while.
-	 */
-	if (unlikely(on_rq)) {
-		schedule_timeout_uninterruptible(1);
-		goto repeat;
-	}
+		/*
+		 * It's not enough that it's not actively running,
+		 * it must be off the runqueue _entirely_, and not
+		 * preempted!
+		 *
+		 * So if it wa still runnable (but just not actively
+		 * running right now), it's preempted, and we should
+		 * yield - it could be a while.
+		 */
+		if (unlikely(on_rq)) {
+			schedule_timeout_uninterruptible(1);
+			continue;
+		}
 
-	/*
-	 * Ahh, all good. It wasn't running, and it wasn't
-	 * runnable, which means that it will never become
-	 * running in the future either. We're all done!
-	 */
+		/*
+		 * Ahh, all good. It wasn't running, and it wasn't
+		 * runnable, which means that it will never become
+		 * running in the future either. We're all done!
+		 */
+		break;
+	}
 }
 
 /***
@@ -1229,7 +1227,7 @@ find_idlest_group(struct sched_domain *s
 
 		/* Skip over this group if it has no CPUs allowed */
 		if (!cpus_intersects(group->cpumask, p->cpus_allowed))
-			goto nextgroup;
+			continue;
 
 		local_group = cpu_isset(this_cpu, group->cpumask);
 
@@ -1257,9 +1255,7 @@ find_idlest_group(struct sched_domain *s
 			min_load = avg_load;
 			idlest = group;
 		}
-nextgroup:
-		group = group->next;
-	} while (group != sd->groups);
+	} while (group = group->next, group != sd->groups);
 
 	if (!idlest || 100*this_load < imbalance*min_load)
 		return NULL;
@@ -3510,27 +3506,30 @@ asmlinkage void __sched preempt_schedule
 	if (likely(ti->preempt_count || irqs_disabled()))
 		return;
 
-need_resched:
-	add_preempt_count(PREEMPT_ACTIVE);
-	/*
-	 * We keep the big kernel semaphore locked, but we
-	 * clear ->lock_depth so that schedule() doesnt
-	 * auto-release the semaphore:
-	 */
+	do {
+		add_preempt_count(PREEMPT_ACTIVE);
+
+		/*
+		 * We keep the big kernel semaphore locked, but we
+		 * clear ->lock_depth so that schedule() doesnt
+		 * auto-release the semaphore:
+		 */
 #ifdef CONFIG_PREEMPT_BKL
-	saved_lock_depth = task->lock_depth;
-	task->lock_depth = -1;
+		saved_lock_depth = task->lock_depth;
+		task->lock_depth = -1;
 #endif
-	schedule();
+		schedule();
 #ifdef CONFIG_PREEMPT_BKL
-	task->lock_depth = saved_lock_depth;
+		task->lock_depth = saved_lock_depth;
 #endif
-	sub_preempt_count(PREEMPT_ACTIVE);
+		sub_preempt_count(PREEMPT_ACTIVE);
 
-	/* we could miss a preemption opportunity between schedule and now */
-	barrier();
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
-		goto need_resched;
+		/*
+		 * Check again in case we missed a preemption opportunity
+		 * between schedule and now.
+		 */
+		barrier();
+	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
 }
 EXPORT_SYMBOL(preempt_schedule);
 
@@ -3550,29 +3549,32 @@ asmlinkage void __sched preempt_schedule
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
-need_resched:
-	add_preempt_count(PREEMPT_ACTIVE);
-	/*
-	 * We keep the big kernel semaphore locked, but we
-	 * clear ->lock_depth so that schedule() doesnt
-	 * auto-release the semaphore:
-	 */
+	do {
+		add_preempt_count(PREEMPT_ACTIVE);
+
+		/*
+		 * We keep the big kernel semaphore locked, but we
+		 * clear ->lock_depth so that schedule() doesnt
+		 * auto-release the semaphore:
+		 */
 #ifdef CONFIG_PREEMPT_BKL
-	saved_lock_depth = task->lock_depth;
-	task->lock_depth = -1;
+		saved_lock_depth = task->lock_depth;
+		task->lock_depth = -1;
 #endif
-	local_irq_enable();
-	schedule();
-	local_irq_disable();
+		local_irq_enable();
+		schedule();
+		local_irq_disable();
 #ifdef CONFIG_PREEMPT_BKL
-	task->lock_depth = saved_lock_depth;
+		task->lock_depth = saved_lock_depth;
 #endif
-	sub_preempt_count(PREEMPT_ACTIVE);
+		sub_preempt_count(PREEMPT_ACTIVE);
 
-	/* we could miss a preemption opportunity between schedule and now */
-	barrier();
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
-		goto need_resched;
+		/*
+		 * Check again in case we missed a preemption opportunity
+		 * between schedule and now.
+		 */
+		barrier();
+	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
 }
 
 #endif /* CONFIG_PREEMPT */
@@ -4317,10 +4319,10 @@ asmlinkage long sys_sched_setparam(pid_t
 asmlinkage long sys_sched_getscheduler(pid_t pid)
 {
 	struct task_struct *p;
-	int retval = -EINVAL;
+	int retval;
 
 	if (pid < 0)
-		goto out_nounlock;
+		return -EINVAL;
 
 	retval = -ESRCH;
 	read_lock(&tasklist_lock);
@@ -4331,8 +4333,6 @@ asmlinkage long sys_sched_getscheduler(p
 			retval = p->policy;
 	}
 	read_unlock(&tasklist_lock);
-
-out_nounlock:
 	return retval;
 }
 
@@ -4345,10 +4345,10 @@ asmlinkage long sys_sched_getparam(pid_t
 {
 	struct sched_param lp;
 	struct task_struct *p;
-	int retval = -EINVAL;
+	int retval;
 
 	if (!param || pid < 0)
-		goto out_nounlock;
+		return -EINVAL;
 
 	read_lock(&tasklist_lock);
 	p = find_process_by_pid(pid);
@@ -4368,7 +4368,6 @@ asmlinkage long sys_sched_getparam(pid_t
 	 */
 	retval = copy_to_user(param, &lp, sizeof(*param)) ? -EFAULT : 0;
 
-out_nounlock:
 	return retval;
 
 out_unlock:
@@ -4724,11 +4723,11 @@ long sys_sched_rr_get_interval(pid_t pid
 {
 	struct task_struct *p;
 	unsigned int time_slice;
-	int retval = -EINVAL;
+	int retval;
 	struct timespec t;
 
 	if (pid < 0)
-		goto out_nounlock;
+		return -EINVAL;
 
 	retval = -ESRCH;
 	read_lock(&tasklist_lock);
@@ -4756,8 +4755,8 @@ long sys_sched_rr_get_interval(pid_t pid
 	read_unlock(&tasklist_lock);
 	jiffies_to_timespec(time_slice, &t);
 	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
-out_nounlock:
 	return retval;
+
 out_unlock:
 	read_unlock(&tasklist_lock);
 	return retval;
@@ -5063,35 +5062,34 @@ static void move_task_off_dead_cpu(int d
 	struct rq *rq;
 	int dest_cpu;
 
-restart:
-	/* On same node? */
-	mask = node_to_cpumask(cpu_to_node(dead_cpu));
-	cpus_and(mask, mask, p->cpus_allowed);
-	dest_cpu = any_online_cpu(mask);
-
-	/* On any allowed CPU? */
-	if (dest_cpu == NR_CPUS)
-		dest_cpu = any_online_cpu(p->cpus_allowed);
-
-	/* No more Mr. Nice Guy. */
-	if (dest_cpu == NR_CPUS) {
-		rq = task_rq_lock(p, &flags);
-		cpus_setall(p->cpus_allowed);
-		dest_cpu = any_online_cpu(p->cpus_allowed);
-		task_rq_unlock(rq, &flags);
+	do {
+		/* On same node? */
+		mask = node_to_cpumask(cpu_to_node(dead_cpu));
+		cpus_and(mask, mask, p->cpus_allowed);
+		dest_cpu = any_online_cpu(mask);
+
+		/* On any allowed CPU? */
+		if (dest_cpu == NR_CPUS)
+			dest_cpu = any_online_cpu(p->cpus_allowed);
+
+		/* No more Mr. Nice Guy. */
+		if (dest_cpu == NR_CPUS) {
+			rq = task_rq_lock(p, &flags);
+			cpus_setall(p->cpus_allowed);
+			dest_cpu = any_online_cpu(p->cpus_allowed);
+			task_rq_unlock(rq, &flags);
 
-		/*
-		 * Don't tell them about moving exiting tasks or
-		 * kernel threads (both mm NULL), since they never
-		 * leave kernel.
-		 */
-		if (p->mm && printk_ratelimit())
-			printk(KERN_INFO "process %d (%s) no "
-			       "longer affine to cpu%d\n",
-			       p->pid, p->comm, dead_cpu);
-	}
-	if (!__migrate_task(p, dead_cpu, dest_cpu))
-		goto restart;
+			/*
+			 * Don't tell them about moving exiting tasks or
+			 * kernel threads (both mm NULL), since they never
+			 * leave kernel.
+			 */
+			if (p->mm && printk_ratelimit())
+				printk(KERN_INFO "process %d (%s) no "
+				       "longer affine to cpu%d\n",
+				       p->pid, p->comm, dead_cpu);
+		}
+	} while (!__migrate_task(p, dead_cpu, dest_cpu));
 }
 
 /*
@@ -5906,24 +5904,23 @@ static void init_numa_sched_groups_power
 
 	if (!sg)
 		return;
-next_sg:
-	for_each_cpu_mask(j, sg->cpumask) {
-		struct sched_domain *sd;
+	do {
+		for_each_cpu_mask(j, sg->cpumask) {
+			struct sched_domain *sd;
 
-		sd = &per_cpu(phys_domains, j);
-		if (j != first_cpu(sd->groups->cpumask)) {
-			/*
-			 * Only add "power" once for each
-			 * physical package.
-			 */
-			continue;
-		}
+			sd = &per_cpu(phys_domains, j);
+			if (j != first_cpu(sd->groups->cpumask)) {
+				/*
+				 * Only add "power" once for each
+				 * physical package.
+				 */
+				continue;
+			}
 
-		sg_inc_cpu_power(sg, sd->groups->__cpu_power);
-	}
-	sg = sg->next;
-	if (sg != group_head)
-		goto next_sg;
+			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
+		}
+		sg = sg->next;
+	} while (sg != group_head);
 }
 #endif
 
