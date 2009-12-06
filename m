Return-Path: <linux-kernel-owner+w=401wt.eu-S934299AbZLFSEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299AbZLFSEz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934247AbZLFSEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:04:07 -0500
Received: from www.tglx.de ([62.245.132.106]:33244 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934097AbZLFSDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:35 -0500
Message-Id: <20091206111957.957879911@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:03:17 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 17/23] sched: Convert pi_lock to raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=sched-convert-pi-lock-to-core-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/init_task.h |    2 -
 include/linux/sched.h     |    2 -
 kernel/exit.c             |    2 -
 kernel/fork.c             |    4 +--
 kernel/futex.c            |   38 +++++++++++++++---------------
 kernel/rtmutex-debug.c    |    4 +--
 kernel/rtmutex.c          |   58 +++++++++++++++++++++++-----------------------
 kernel/sched.c            |   12 ++++-----
 8 files changed, 61 insertions(+), 61 deletions(-)

Index: linux-2.6-tip/include/linux/init_task.h
===================================================================
--- linux-2.6-tip.orig/include/linux/init_task.h
+++ linux-2.6-tip/include/linux/init_task.h
@@ -165,7 +165,7 @@ extern struct cred init_cred;
 	.journal_info	= NULL,						\
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
-	.pi_lock	= __SPIN_LOCK_UNLOCKED(tsk.pi_lock),		\
+	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(tsk.pi_lock),	\
 	.timer_slack_ns = 50000, /* 50 usec default slack */		\
 	.pids = {							\
 		[PIDTYPE_PID]  = INIT_PID_LINK(PIDTYPE_PID),		\
Index: linux-2.6-tip/include/linux/sched.h
===================================================================
--- linux-2.6-tip.orig/include/linux/sched.h
+++ linux-2.6-tip/include/linux/sched.h
@@ -1411,7 +1411,7 @@ struct task_struct {
 #endif
 
 	/* Protection of the PI data structures: */
-	spinlock_t pi_lock;
+	raw_spinlock_t pi_lock;
 
 #ifdef CONFIG_RT_MUTEXES
 	/* PI waiters blocked on a rt_mutex held by this task */
Index: linux-2.6-tip/kernel/exit.c
===================================================================
--- linux-2.6-tip.orig/kernel/exit.c
+++ linux-2.6-tip/kernel/exit.c
@@ -933,7 +933,7 @@ NORET_TYPE void do_exit(long code)
 	 * an exiting task cleaning up the robust pi futexes.
 	 */
 	smp_mb();
-	spin_unlock_wait(&tsk->pi_lock);
+	raw_spin_unlock_wait(&tsk->pi_lock);
 
 	if (unlikely(in_atomic()))
 		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
Index: linux-2.6-tip/kernel/fork.c
===================================================================
--- linux-2.6-tip.orig/kernel/fork.c
+++ linux-2.6-tip/kernel/fork.c
@@ -937,9 +937,9 @@ SYSCALL_DEFINE1(set_tid_address, int __u
 
 static void rt_mutex_init_task(struct task_struct *p)
 {
-	spin_lock_init(&p->pi_lock);
+	raw_spin_lock_init(&p->pi_lock);
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init(&p->pi_waiters, &p->pi_lock);
+	plist_head_init_raw(&p->pi_waiters, &p->pi_lock);
 	p->pi_blocked_on = NULL;
 #endif
 }
Index: linux-2.6-tip/kernel/futex.c
===================================================================
--- linux-2.6-tip.orig/kernel/futex.c
+++ linux-2.6-tip/kernel/futex.c
@@ -397,9 +397,9 @@ static void free_pi_state(struct futex_p
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
-		spin_lock_irq(&pi_state->owner->pi_lock);
+		raw_spin_lock_irq(&pi_state->owner->pi_lock);
 		list_del_init(&pi_state->list);
-		spin_unlock_irq(&pi_state->owner->pi_lock);
+		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex, pi_state->owner);
 	}
@@ -464,18 +464,18 @@ void exit_pi_state_list(struct task_stru
 	 * pi_state_list anymore, but we have to be careful
 	 * versus waiters unqueueing themselves:
 	 */
-	spin_lock_irq(&curr->pi_lock);
+	raw_spin_lock_irq(&curr->pi_lock);
 	while (!list_empty(head)) {
 
 		next = head->next;
 		pi_state = list_entry(next, struct futex_pi_state, list);
 		key = pi_state->key;
 		hb = hash_futex(&key);
-		spin_unlock_irq(&curr->pi_lock);
+		raw_spin_unlock_irq(&curr->pi_lock);
 
 		spin_lock(&hb->lock);
 
-		spin_lock_irq(&curr->pi_lock);
+		raw_spin_lock_irq(&curr->pi_lock);
 		/*
 		 * We dropped the pi-lock, so re-check whether this
 		 * task still owns the PI-state:
@@ -489,15 +489,15 @@ void exit_pi_state_list(struct task_stru
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
 		pi_state->owner = NULL;
-		spin_unlock_irq(&curr->pi_lock);
+		raw_spin_unlock_irq(&curr->pi_lock);
 
 		rt_mutex_unlock(&pi_state->pi_mutex);
 
 		spin_unlock(&hb->lock);
 
-		spin_lock_irq(&curr->pi_lock);
+		raw_spin_lock_irq(&curr->pi_lock);
 	}
-	spin_unlock_irq(&curr->pi_lock);
+	raw_spin_unlock_irq(&curr->pi_lock);
 }
 
 static int
@@ -552,7 +552,7 @@ lookup_pi_state(u32 uval, struct futex_h
 	 * change of the task flags, we do this protected by
 	 * p->pi_lock:
 	 */
-	spin_lock_irq(&p->pi_lock);
+	raw_spin_lock_irq(&p->pi_lock);
 	if (unlikely(p->flags & PF_EXITING)) {
 		/*
 		 * The task is on the way out. When PF_EXITPIDONE is
@@ -561,7 +561,7 @@ lookup_pi_state(u32 uval, struct futex_h
 		 */
 		int ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;
 
-		spin_unlock_irq(&p->pi_lock);
+		raw_spin_unlock_irq(&p->pi_lock);
 		put_task_struct(p);
 		return ret;
 	}
@@ -580,7 +580,7 @@ lookup_pi_state(u32 uval, struct futex_h
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &p->pi_state_list);
 	pi_state->owner = p;
-	spin_unlock_irq(&p->pi_lock);
+	raw_spin_unlock_irq(&p->pi_lock);
 
 	put_task_struct(p);
 
@@ -788,16 +788,16 @@ static int wake_futex_pi(u32 __user *uad
 		}
 	}
 
-	spin_lock_irq(&pi_state->owner->pi_lock);
+	raw_spin_lock_irq(&pi_state->owner->pi_lock);
 	WARN_ON(list_empty(&pi_state->list));
 	list_del_init(&pi_state->list);
-	spin_unlock_irq(&pi_state->owner->pi_lock);
+	raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 
-	spin_lock_irq(&new_owner->pi_lock);
+	raw_spin_lock_irq(&new_owner->pi_lock);
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &new_owner->pi_state_list);
 	pi_state->owner = new_owner;
-	spin_unlock_irq(&new_owner->pi_lock);
+	raw_spin_unlock_irq(&new_owner->pi_lock);
 
 	spin_unlock(&pi_state->pi_mutex.wait_lock);
 	rt_mutex_unlock(&pi_state->pi_mutex);
@@ -1523,18 +1523,18 @@ retry:
 	 * itself.
 	 */
 	if (pi_state->owner != NULL) {
-		spin_lock_irq(&pi_state->owner->pi_lock);
+		raw_spin_lock_irq(&pi_state->owner->pi_lock);
 		WARN_ON(list_empty(&pi_state->list));
 		list_del_init(&pi_state->list);
-		spin_unlock_irq(&pi_state->owner->pi_lock);
+		raw_spin_unlock_irq(&pi_state->owner->pi_lock);
 	}
 
 	pi_state->owner = newowner;
 
-	spin_lock_irq(&newowner->pi_lock);
+	raw_spin_lock_irq(&newowner->pi_lock);
 	WARN_ON(!list_empty(&pi_state->list));
 	list_add(&pi_state->list, &newowner->pi_state_list);
-	spin_unlock_irq(&newowner->pi_lock);
+	raw_spin_unlock_irq(&newowner->pi_lock);
 	return 0;
 
 	/*
Index: linux-2.6-tip/kernel/rtmutex-debug.c
===================================================================
--- linux-2.6-tip.orig/kernel/rtmutex-debug.c
+++ linux-2.6-tip/kernel/rtmutex-debug.c
@@ -37,8 +37,8 @@ do {								\
 	if (rt_trace_on) {					\
 		rt_trace_on = 0;				\
 		console_verbose();				\
-		if (spin_is_locked(&current->pi_lock))		\
-			spin_unlock(&current->pi_lock);		\
+		if (raw_spin_is_locked(&current->pi_lock))	\
+			raw_spin_unlock(&current->pi_lock);	\
 	}							\
 } while (0)
 
Index: linux-2.6-tip/kernel/rtmutex.c
===================================================================
--- linux-2.6-tip.orig/kernel/rtmutex.c
+++ linux-2.6-tip/kernel/rtmutex.c
@@ -138,9 +138,9 @@ static void rt_mutex_adjust_prio(struct 
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	__rt_mutex_adjust_prio(task);
-	spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 }
 
 /*
@@ -195,7 +195,7 @@ static int rt_mutex_adjust_prio_chain(st
 	/*
 	 * Task can not go away as we did a get_task() before !
 	 */
-	spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
 	/*
@@ -232,7 +232,7 @@ static int rt_mutex_adjust_prio_chain(st
 
 	lock = waiter->lock;
 	if (!spin_trylock(&lock->wait_lock)) {
-		spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		cpu_relax();
 		goto retry;
 	}
@@ -253,13 +253,13 @@ static int rt_mutex_adjust_prio_chain(st
 	plist_add(&waiter->list_entry, &lock->wait_list);
 
 	/* Release the task */
-	spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	put_task_struct(task);
 
 	/* Grab the next task */
 	task = rt_mutex_owner(lock);
 	get_task_struct(task);
-	spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
 		/* Boost the owner */
@@ -277,7 +277,7 @@ static int rt_mutex_adjust_prio_chain(st
 		__rt_mutex_adjust_prio(task);
 	}
 
-	spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	top_waiter = rt_mutex_top_waiter(lock);
 	spin_unlock(&lock->wait_lock);
@@ -288,7 +288,7 @@ static int rt_mutex_adjust_prio_chain(st
 	goto again;
 
  out_unlock_pi:
-	spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
  out_put_task:
 	put_task_struct(task);
 
@@ -313,9 +313,9 @@ static inline int try_to_steal_lock(stru
 	if (pendowner == task)
 		return 1;
 
-	spin_lock_irqsave(&pendowner->pi_lock, flags);
+	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
 	if (task->prio >= pendowner->prio) {
-		spin_unlock_irqrestore(&pendowner->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 		return 0;
 	}
 
@@ -325,7 +325,7 @@ static inline int try_to_steal_lock(stru
 	 * priority.
 	 */
 	if (likely(!rt_mutex_has_waiters(lock))) {
-		spin_unlock_irqrestore(&pendowner->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 		return 1;
 	}
 
@@ -333,7 +333,7 @@ static inline int try_to_steal_lock(stru
 	next = rt_mutex_top_waiter(lock);
 	plist_del(&next->pi_list_entry, &pendowner->pi_waiters);
 	__rt_mutex_adjust_prio(pendowner);
-	spin_unlock_irqrestore(&pendowner->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 
 	/*
 	 * We are going to steal the lock and a waiter was
@@ -350,10 +350,10 @@ static inline int try_to_steal_lock(stru
 	 * might be task:
 	 */
 	if (likely(next->task != task)) {
-		spin_lock_irqsave(&task->pi_lock, flags);
+		raw_spin_lock_irqsave(&task->pi_lock, flags);
 		plist_add(&next->pi_list_entry, &task->pi_waiters);
 		__rt_mutex_adjust_prio(task);
-		spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 	}
 	return 1;
 }
@@ -420,7 +420,7 @@ static int task_blocks_on_rt_mutex(struc
 	unsigned long flags;
 	int chain_walk = 0, res;
 
-	spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
 	__rt_mutex_adjust_prio(task);
 	waiter->task = task;
 	waiter->lock = lock;
@@ -434,17 +434,17 @@ static int task_blocks_on_rt_mutex(struc
 
 	task->pi_blocked_on = waiter;
 
-	spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	if (waiter == rt_mutex_top_waiter(lock)) {
-		spin_lock_irqsave(&owner->pi_lock, flags);
+		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 		plist_del(&top_waiter->pi_list_entry, &owner->pi_waiters);
 		plist_add(&waiter->pi_list_entry, &owner->pi_waiters);
 
 		__rt_mutex_adjust_prio(owner);
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
-		spin_unlock_irqrestore(&owner->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 	else if (debug_rt_mutex_detect_deadlock(waiter, detect_deadlock))
 		chain_walk = 1;
@@ -483,7 +483,7 @@ static void wakeup_next_waiter(struct rt
 	struct task_struct *pendowner;
 	unsigned long flags;
 
-	spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock_irqsave(&current->pi_lock, flags);
 
 	waiter = rt_mutex_top_waiter(lock);
 	plist_del(&waiter->list_entry, &lock->wait_list);
@@ -500,7 +500,7 @@ static void wakeup_next_waiter(struct rt
 
 	rt_mutex_set_owner(lock, pendowner, RT_MUTEX_OWNER_PENDING);
 
-	spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	/*
 	 * Clear the pi_blocked_on variable and enqueue a possible
@@ -509,7 +509,7 @@ static void wakeup_next_waiter(struct rt
 	 * waiter with higher priority than pending-owner->normal_prio
 	 * is blocked on the unboosted (pending) owner.
 	 */
-	spin_lock_irqsave(&pendowner->pi_lock, flags);
+	raw_spin_lock_irqsave(&pendowner->pi_lock, flags);
 
 	WARN_ON(!pendowner->pi_blocked_on);
 	WARN_ON(pendowner->pi_blocked_on != waiter);
@@ -523,7 +523,7 @@ static void wakeup_next_waiter(struct rt
 		next = rt_mutex_top_waiter(lock);
 		plist_add(&next->pi_list_entry, &pendowner->pi_waiters);
 	}
-	spin_unlock_irqrestore(&pendowner->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&pendowner->pi_lock, flags);
 
 	wake_up_process(pendowner);
 }
@@ -541,15 +541,15 @@ static void remove_waiter(struct rt_mute
 	unsigned long flags;
 	int chain_walk = 0;
 
-	spin_lock_irqsave(&current->pi_lock, flags);
+	raw_spin_lock_irqsave(&current->pi_lock, flags);
 	plist_del(&waiter->list_entry, &lock->wait_list);
 	waiter->task = NULL;
 	current->pi_blocked_on = NULL;
-	spin_unlock_irqrestore(&current->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&current->pi_lock, flags);
 
 	if (first && owner != current) {
 
-		spin_lock_irqsave(&owner->pi_lock, flags);
+		raw_spin_lock_irqsave(&owner->pi_lock, flags);
 
 		plist_del(&waiter->pi_list_entry, &owner->pi_waiters);
 
@@ -564,7 +564,7 @@ static void remove_waiter(struct rt_mute
 		if (owner->pi_blocked_on)
 			chain_walk = 1;
 
-		spin_unlock_irqrestore(&owner->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&owner->pi_lock, flags);
 	}
 
 	WARN_ON(!plist_node_empty(&waiter->pi_list_entry));
@@ -592,15 +592,15 @@ void rt_mutex_adjust_pi(struct task_stru
 	struct rt_mutex_waiter *waiter;
 	unsigned long flags;
 
-	spin_lock_irqsave(&task->pi_lock, flags);
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
 
 	waiter = task->pi_blocked_on;
 	if (!waiter || waiter->list_entry.prio == task->prio) {
-		spin_unlock_irqrestore(&task->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 		return;
 	}
 
-	spin_unlock_irqrestore(&task->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
 
 	/* gets dropped in rt_mutex_adjust_prio_chain()! */
 	get_task_struct(task);
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6346,7 +6346,7 @@ recheck:
 	 * make sure no PI-waiters arrive (or leave) while we are
 	 * changing the priority of the task:
 	 */
-	spin_lock_irqsave(&p->pi_lock, flags);
+	raw_spin_lock_irqsave(&p->pi_lock, flags);
 	/*
 	 * To be able to change p->policy safely, the apropriate
 	 * runqueue lock must be held.
@@ -6356,7 +6356,7 @@ recheck:
 	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
 		policy = oldpolicy = -1;
 		__task_rq_unlock(rq);
-		spin_unlock_irqrestore(&p->pi_lock, flags);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 		goto recheck;
 	}
 	update_rq_clock(rq);
@@ -6380,7 +6380,7 @@ recheck:
 		check_class_changed(rq, p, prev_class, oldprio, running);
 	}
 	__task_rq_unlock(rq);
-	spin_unlock_irqrestore(&p->pi_lock, flags);
+	raw_spin_unlock_irqrestore(&p->pi_lock, flags);
 
 	rt_mutex_adjust_pi(p);
 
@@ -9619,7 +9619,7 @@ void __init sched_init(void)
 #endif
 
 #ifdef CONFIG_RT_MUTEXES
-	plist_head_init(&init_task.pi_waiters, &init_task.pi_lock);
+	plist_head_init_raw(&init_task.pi_waiters, &init_task.pi_lock);
 #endif
 
 	/*
@@ -9744,13 +9744,13 @@ void normalize_rt_tasks(void)
 			continue;
 		}
 
-		spin_lock(&p->pi_lock);
+		raw_spin_lock(&p->pi_lock);
 		rq = __task_rq_lock(p);
 
 		normalize_task(rq, p);
 
 		__task_rq_unlock(rq);
-		spin_unlock(&p->pi_lock);
+		raw_spin_unlock(&p->pi_lock);
 	} while_each_thread(g, p);
 
 	read_unlock_irqrestore(&tasklist_lock, flags);


