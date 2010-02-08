Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0BHKLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 05:11:43 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44616 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab0BHKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 05:11:41 -0500
Subject: Re: [RFC][PATCH] PERF_COUNT_SW_RUNNABLE_TASKS: measure and act
 upon parallellism
From: Peter Zijlstra <peterz@infradead.org>
To: highguy@gmail.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       efault@gmx.de, andrea@suse.de, tglx@linutronix.de,
       akpm@linux-foundation.org, Tejun Heo <tj@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
References: <1265542259-5596-1-git-send-email-HIGHGuY@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Feb 2010 11:00:45 +0100
Message-ID: <1265623245.1853.33.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-07 at 12:30 +0100, highguy@gmail.com wrote:

> Here's an initial RFC patch for the parallallism
> events for perf_events.

OK, so you managed to rub me totally the wrong way with posting this
yesterday:
 - you send me each patch twice
 - you used the horrible git sendmail default of --chain-reply-to
   (some day I'll write a script that will detect and auto-bounce
    series sent to me like that)
 - you failed to provide a changelog for any of the patches
 - some subjects were long enough to be a changelog

Please don't do that again ;-)

Anyway, it did get me thinking, how about something like the below?

(compile tested only, we probably want a different name than CLONE_SEM,
but I failed at coming up with anything better, CLONE_FRED?)

---
 include/linux/sched.h |   11 ++++++++++
 kernel/exit.c         |    5 ++++
 kernel/fork.c         |   24 ++++++++++++++++++++++
 kernel/sched.c        |   53 ++++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 92 insertions(+), 1 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b1b8d84..580c623 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -9,6 +9,7 @@
 #define CLONE_FS	0x00000200	/* set if fs info shared between processes */
 #define CLONE_FILES	0x00000400	/* set if open files shared between processes */
 #define CLONE_SIGHAND	0x00000800	/* set if signal handlers and blocked signals shared */
+#define CLONE_SEM	0x00001000	/* set if */
 #define CLONE_PTRACE	0x00002000	/* set if we want to let tracing continue on the child too */
 #define CLONE_VFORK	0x00004000	/* set if the parent wants the child to wake it up on mm_release */
 #define CLONE_PARENT	0x00008000	/* set if we want to have the same parent as the cloner */
@@ -1214,6 +1215,13 @@ struct sched_rt_entity {
 
 struct rcu_node;
 
+struct task_sem {
+	raw_spinlock_t		lock;
+	unsigned int		count;
+	struct list_head	wait_list;
+	atomic_t		ref;
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1235,6 +1243,9 @@ struct task_struct {
 	struct sched_entity se;
 	struct sched_rt_entity rt;
 
+	struct task_sem *sem;
+	struct list_head sem_waiter;
+
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
 	struct hlist_head preempt_notifiers;
diff --git a/kernel/exit.c b/kernel/exit.c
index 546774a..f8b9ab3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -991,6 +991,11 @@ NORET_TYPE void do_exit(long code)
 	 */
 	perf_event_exit_task(tsk);
 
+	if (unlikely(tsk->sem) && atomic_dec_and_test(&tsk->sem->ref)) {
+		kfree(tsk->sem);
+		tsk->sem = NULL;
+	}
+
 	exit_notify(tsk, group_dead);
 #ifdef CONFIG_NUMA
 	mpol_put(tsk->mempolicy);
diff --git a/kernel/fork.c b/kernel/fork.c
index f88bd98..cea102c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -989,6 +989,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
+	if ((clone_flags & (CLONE_VFORK|CLONE_SEM)) == (CLONE_VFORK|CLONE_SEM))
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * Thread groups must share signals as well, and detached threads
 	 * can only be started up within the thread group.
@@ -1023,6 +1026,27 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	if (!p)
 		goto fork_out;
 
+	if (clone_flags & CLONE_SEM) {
+		INIT_LIST_HEAD(&p->sem_waiter);
+		if (!current->sem) {
+			struct task_sem *sem = 
+				kmalloc(sizeof(struct task_sem), GFP_KERNEL);
+
+			if (!sem)
+				goto bad_fork_free;
+
+			raw_spin_lock_init(&sem->lock);
+			sem->count = 0; /* current is running */
+			INIT_LIST_HEAD(&sem->wait_list);
+			atomic_set(&sem->ref, 2);
+
+			current->sem = sem;
+			p->sem = sem;
+		} else
+			atomic_inc(&current->sem->ref);
+	} else if (current->sem)
+		p->sem = NULL;
+
 	ftrace_graph_init_task(p);
 
 	rt_mutex_init_task(p);
diff --git a/kernel/sched.c b/kernel/sched.c
index de9f9d4..9cd6144 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2247,6 +2247,48 @@ void task_oncpu_function_call(struct task_struct *p,
 	preempt_enable();
 }
 
+static void task_up(struct rq *rq, struct task_struct *p)
+{
+	struct task_struct *waiter = NULL;
+	struct task_sem *sem = p->sem;
+
+	raw_spin_lock(&sem->lock);
+	sem->count++;
+	if (sem->count > 0 && !list_empty(&sem->wait_list)) {
+		waiter = list_first_entry(&sem->wait_list, 
+				struct task_struct, sem_waiter);
+
+		list_del_init(&waiter->sem_waiter);
+	}
+	raw_spin_unlock(&sem->lock);
+
+	if (waiter) {
+		raw_spin_unlock(&rq->lock);
+		wake_up_process(waiter);
+		raw_spin_lock(&rq->lock);
+	}
+}
+
+static int task_down(struct task_struct *p)
+{
+	struct task_sem *sem = p->sem;
+	int ret = 0;
+
+	raw_spin_lock(&sem->lock);
+	if (sem->count > 0) {
+		sem->count--;
+	} else {
+		WARN_ON_ONCE(!list_empty(&p->sem_waiter));
+
+		list_add_tail(&p->sem_waiter, &sem->wait_list);
+		__set_task_state(p, TASK_UNINTERRUPTIBLE);
+		ret = 1;
+	}
+	raw_spin_unlock(&sem->lock);
+
+	return ret;
+}
+
 #ifdef CONFIG_SMP
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
@@ -2357,7 +2399,12 @@ static int try_to_wake_up(struct task_struct *p, unsigned int state,
 #ifdef CONFIG_SMP
 	if (unlikely(task_running(rq, p)))
 		goto out_activate;
+#endif
 
+	if (unlikely(p->sem) && task_down(p))
+		goto out;
+
+#ifdef CONFIG_SMP
 	/*
 	 * In order to handle concurrent wakeups and release the rq->lock
 	 * we put the task in TASK_WAKING state.
@@ -3671,8 +3718,12 @@ need_resched_nonpreemptible:
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev)))
 			prev->state = TASK_RUNNING;
-		else
+		else {
 			deactivate_task(rq, prev, 1);
+
+			if (unlikely(prev->sem))
+				task_up(rq, prev);
+		}
 		switch_count = &prev->nvcsw;
 	}
 


