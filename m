Return-Path: <linux-kernel-owner+w=401wt.eu-S1758108AbYFKU42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758108AbYFKU42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 16:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756915AbYFKUyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 16:54:52 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:7527 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754229AbYFKUys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 16:54:48 -0400
Message-Id: <20080611204917.267412694@mvista.com>
References: <20080611204916.271608740@mvista.com>
User-Agent: quilt/0.46-1
Date: Wed, 11 Jun 2008 13:49:19 -0700
Subject: [PATCH 3/5] mutex debug: add generic blocked_on usage
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Ulrich Drepper <drepper@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
Content-Disposition: inline; filename=blocked_on-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of blocked on type structures. One for mutexes, and one
for rtmutexes, and we also need one for futexes.

Instead of just adding another one to the task struct I combined them all into
a union. Since a waiter can only be blocked on one of the types at any given
time this should be safe.

I also usurped the pi_lock as the lock which protects all the blocked_on types.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 include/linux/sched.h |   36 +++++++++++++++++++++++++++++++-----
 kernel/fork.c         |    2 --
 kernel/mutex-debug.c  |   25 ++++++++++++++++++-------
 kernel/mutex-debug.h  |    4 +++-
 kernel/mutex.c        |    6 +++++-
 5 files changed, 57 insertions(+), 16 deletions(-)

Index: linux-2.6.25/include/linux/sched.h
===================================================================
--- linux-2.6.25.orig/include/linux/sched.h
+++ linux-2.6.25/include/linux/sched.h
@@ -1024,6 +1024,17 @@ struct sched_rt_entity {
 #endif
 };
 
+enum lock_waiter_type {
+	MUTEX_WAITER = 1,
+};
+
+struct lock_waiter_state {
+	enum lock_waiter_type lock_type;
+	union {
+		struct mutex_waiter *mutex_blocked_on;
+	};
+};
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1201,7 +1212,7 @@ struct task_struct {
 /* Protection of (de-)allocation: mm, files, fs, tty, keyrings */
 	spinlock_t alloc_lock;
 
-	/* Protection of the PI data structures: */
+	/* Protects blocked_on field and PI waiters list. */
 	spinlock_t pi_lock;
 
 #ifdef CONFIG_RT_MUTEXES
@@ -1211,10 +1222,12 @@ struct task_struct {
 	struct rt_mutex_waiter *pi_blocked_on;
 #endif
 
-#ifdef CONFIG_DEBUG_MUTEXES
-	/* mutex deadlock detection */
-	struct mutex_waiter *blocked_on;
-#endif
+	/*
+	 * Deadlock detection and priority inheritance handling,
+	 * and any other out of line mutex operations
+	 */
+	struct lock_waiter_state *blocked_on;
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 	unsigned int irq_events;
 	int hardirqs_enabled;
@@ -1306,6 +1319,19 @@ struct task_struct {
 #endif
 };
 
+
+/*
+ * set_blocked_on - Set the blocked on field in the task struct.
+ */
+static inline void
+set_blocked_on(struct task_struct *p, struct lock_waiter_state *blocked_on)
+{
+	spin_lock(&p->pi_lock);
+	p->blocked_on = blocked_on;
+	spin_unlock(&p->pi_lock);
+}
+
+
 /*
  * Priority of a process goes from 0..MAX_PRIO-1, valid RT
  * priority is 0..MAX_RT_PRIO-1, and SCHED_NORMAL/SCHED_BATCH
Index: linux-2.6.25/kernel/fork.c
===================================================================
--- linux-2.6.25.orig/kernel/fork.c
+++ linux-2.6.25/kernel/fork.c
@@ -1028,9 +1028,7 @@ static struct task_struct *copy_process(
 	p->lockdep_recursion = 0;
 #endif
 
-#ifdef CONFIG_DEBUG_MUTEXES
 	p->blocked_on = NULL; /* not blocked yet */
-#endif
 
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	sched_fork(p, clone_flags);
Index: linux-2.6.25/kernel/mutex-debug.c
===================================================================
--- linux-2.6.25.orig/kernel/mutex-debug.c
+++ linux-2.6.25/kernel/mutex-debug.c
@@ -52,23 +52,34 @@ void debug_mutex_free_waiter(struct mute
 	memset(waiter, MUTEX_DEBUG_FREE, sizeof(*waiter));
 }
 
-void debug_mutex_add_waiter(struct mutex *lock, struct mutex_waiter *waiter,
-			    struct thread_info *ti)
+void
+debug_mutex_add_waiter(struct mutex *lock,
+		       struct lock_waiter_state *lock_waiter,
+		       struct thread_info *ti)
 {
+	struct task_struct *task = ti->task;
+
 	SMP_DEBUG_LOCKS_WARN_ON(!spin_is_locked(&lock->wait_lock));
 
 	/* Mark the current thread as blocked on the lock: */
-	ti->task->blocked_on = waiter;
-	waiter->lock = lock;
+	lock_waiter->mutex_blocked_on->lock = lock;
+	set_blocked_on(task, lock_waiter);
 }
 
 void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 			 struct thread_info *ti)
 {
+	struct task_struct *task = ti->task;
+
+	spin_lock(&task->pi_lock);
+
 	DEBUG_LOCKS_WARN_ON(list_empty(&waiter->list));
-	DEBUG_LOCKS_WARN_ON(waiter->task != ti->task);
-	DEBUG_LOCKS_WARN_ON(ti->task->blocked_on != waiter);
-	ti->task->blocked_on = NULL;
+	DEBUG_LOCKS_WARN_ON(waiter->task != task);
+	DEBUG_LOCKS_WARN_ON(task->blocked_on == NULL);
+	DEBUG_LOCKS_WARN_ON(task->blocked_on->mutex_blocked_on != waiter);
+
+	task->blocked_on = NULL;
+	spin_unlock(&task->pi_lock);
 
 	list_del_init(&waiter->list);
 	waiter->task = NULL;
Index: linux-2.6.25/kernel/mutex-debug.h
===================================================================
--- linux-2.6.25.orig/kernel/mutex-debug.h
+++ linux-2.6.25/kernel/mutex-debug.h
@@ -25,10 +25,12 @@ extern void debug_mutex_lock_common(stru
 				    struct mutex_waiter *waiter);
 extern void debug_mutex_wake_waiter(struct mutex *lock,
 				    struct mutex_waiter *waiter);
+
 extern void debug_mutex_free_waiter(struct mutex_waiter *waiter);
 extern void debug_mutex_add_waiter(struct mutex *lock,
-				   struct mutex_waiter *waiter,
+				   struct lock_waiter_state *lock_waiter,
 				   struct thread_info *ti);
+
 extern void mutex_remove_waiter(struct mutex *lock, struct mutex_waiter *waiter,
 				struct thread_info *ti);
 extern void debug_mutex_unlock(struct mutex *lock);
Index: linux-2.6.25/kernel/mutex.c
===================================================================
--- linux-2.6.25.orig/kernel/mutex.c
+++ linux-2.6.25/kernel/mutex.c
@@ -130,12 +130,16 @@ __mutex_lock_common(struct mutex *lock, 
 	struct mutex_waiter waiter;
 	unsigned int old_val;
 	unsigned long flags;
+#ifdef CONFIG_DEBUG_MUTEXES
+	struct lock_waiter_state lock_waiter = {
+		.lock_type = MUTEX_WAITER, { .mutex_blocked_on = &waiter} };
+#endif
 
 	spin_lock_mutex(&lock->wait_lock, flags);
 
 	debug_mutex_lock_common(lock, &waiter);
 	mutex_acquire(&lock->dep_map, subclass, 0, ip);
-	debug_mutex_add_waiter(lock, &waiter, task_thread_info(task));
+	debug_mutex_add_waiter(lock, &lock_waiter, task_thread_info(task));
 
 	/* add waiting tasks to the end of the waitqueue (FIFO): */
 	list_add_tail(&waiter.list, &lock->wait_list);

-- 
