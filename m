Return-Path: <linux-kernel-owner+w=401wt.eu-S1762091AbYDYOVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762091AbYDYOVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbYDYOVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:21:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50338 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690AbYDYOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:21:12 -0400
Message-Id: <20080425142109.849234027@goodmis.org>
References: <20080425130908.140707404@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 09:09:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
       linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <clark.williams@gmail.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jon Masters <jonathan@jonmasters.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH RT 3/6] map tasks to reader locks held
Content-Disposition: inline; filename=multi-reader-account.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch keeps track of all reader locks that are held for a task.
The max depth is currently set to 5. A task may own the same lock
multiple times for read without affecting this limit. It is bad programming
practice to hold more than 5 different locks for read at the same time
anyway so this should not be a problem. The 5 lock limit should be way
more than enough.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/sched.h |   14 ++++++++++
 kernel/fork.c         |    4 +++
 kernel/rtmutex.c      |   66 ++++++++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 80 insertions(+), 4 deletions(-)

Index: linux-2.6.24.4-rt4/include/linux/sched.h
===================================================================
--- linux-2.6.24.4-rt4.orig/include/linux/sched.h	2008-03-25 16:41:48.000000000 -0400
+++ linux-2.6.24.4-rt4/include/linux/sched.h	2008-03-25 22:55:46.000000000 -0400
@@ -1005,6 +1005,14 @@ struct sched_entity {
 #endif
 };
 
+#ifdef CONFIG_PREEMPT_RT
+struct rw_mutex;
+struct reader_lock_struct {
+	struct rw_mutex *lock;
+	int count;
+};
+
+#endif
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1226,6 +1234,12 @@ struct task_struct {
 #endif
 
 #define MAX_PREEMPT_TRACE 25
+#define MAX_RWLOCK_DEPTH 5
+
+#ifdef CONFIG_PREEMPT_RT
+	int reader_lock_count;
+	struct reader_lock_struct owned_read_locks[MAX_RWLOCK_DEPTH];
+#endif
 
 #ifdef CONFIG_PREEMPT_TRACE
 	unsigned long preempt_trace_eip[MAX_PREEMPT_TRACE];
Index: linux-2.6.24.4-rt4/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.4-rt4.orig/kernel/rtmutex.c	2008-03-25 22:54:24.000000000 -0400
+++ linux-2.6.24.4-rt4/kernel/rtmutex.c	2008-03-25 22:55:46.000000000 -0400
@@ -968,6 +968,8 @@ static int try_to_take_rw_read(struct rw
 	struct rt_mutex *mutex = &rwm->mutex;
 	struct rt_mutex_waiter *waiter;
 	struct task_struct *mtxowner;
+	int reader_count, i;
+	int incr = 1;
 
 	assert_spin_locked(&mutex->wait_lock);
 
@@ -978,6 +980,16 @@ static int try_to_take_rw_read(struct rw
 	if (unlikely(rt_rwlock_writer(rwm)))
 		return 0;
 
+	/* check to see if we don't already own this lock */
+	for (i = current->reader_lock_count - 1; i >= 0; i--) {
+		if (current->owned_read_locks[i].lock == rwm) {
+			rt_rwlock_set_owner(rwm, RT_RW_READER, 0);
+			current->owned_read_locks[i].count++;
+			incr = 0;
+			goto taken;
+		}
+	}
+
 	/* A writer is not the owner, but is a writer waiting */
 	mtxowner = rt_mutex_owner(mutex);
 
@@ -1031,6 +1043,14 @@ static int try_to_take_rw_read(struct rw
 	/* RT_RW_READER forces slow paths */
 	rt_rwlock_set_owner(rwm, RT_RW_READER, 0);
  taken:
+	if (incr) {
+		reader_count = current->reader_lock_count++;
+		if (likely(reader_count < MAX_RWLOCK_DEPTH)) {
+			current->owned_read_locks[reader_count].lock = rwm;
+			current->owned_read_locks[reader_count].count = 1;
+		} else
+			WARN_ON_ONCE(1);
+	}
 	rt_mutex_deadlock_account_lock(mutex, current);
 	atomic_inc(&rwm->count);
 	return 1;
@@ -1184,10 +1204,13 @@ rt_read_fastlock(struct rw_mutex *rwm,
 		 void fastcall (*slowfn)(struct rw_mutex *rwm, int mtx),
 		 int mtx)
 {
-retry:
+ retry:
 	if (likely(rt_rwlock_cmpxchg(rwm, NULL, current))) {
+		int reader_count;
+
 		rt_mutex_deadlock_account_lock(&rwm->mutex, current);
 		atomic_inc(&rwm->count);
+		smp_mb();
 		/*
 		 * It is possible that the owner was zeroed
 		 * before we incremented count. If owner is not
@@ -1197,6 +1220,13 @@ retry:
 			atomic_dec(&rwm->count);
 			goto retry;
 		}
+
+		reader_count = current->reader_lock_count++;
+		if (likely(reader_count < MAX_RWLOCK_DEPTH)) {
+			current->owned_read_locks[reader_count].lock = rwm;
+			current->owned_read_locks[reader_count].count = 1;
+		} else
+			WARN_ON_ONCE(1);
 	} else
 		slowfn(rwm, mtx);
 }
@@ -1236,6 +1266,8 @@ rt_read_fasttrylock(struct rw_mutex *rwm
 {
 retry:
 	if (likely(rt_rwlock_cmpxchg(rwm, NULL, current))) {
+		int reader_count;
+
 		rt_mutex_deadlock_account_lock(&rwm->mutex, current);
 		atomic_inc(&rwm->count);
 		/*
@@ -1247,6 +1279,13 @@ retry:
 			atomic_dec(&rwm->count);
 			goto retry;
 		}
+
+		reader_count = current->reader_lock_count++;
+		if (likely(reader_count < MAX_RWLOCK_DEPTH)) {
+			current->owned_read_locks[reader_count].lock = rwm;
+			current->owned_read_locks[reader_count].count = 1;
+		} else
+			WARN_ON_ONCE(1);
 		return 1;
 	} else
 		return slowfn(rwm);
@@ -1430,9 +1469,10 @@ static void fastcall noinline __sched
 rt_read_slowunlock(struct rw_mutex *rwm, int mtx)
 {
 	struct rt_mutex *mutex = &rwm->mutex;
+	struct rt_mutex_waiter *waiter;
 	unsigned long flags;
 	int savestate = !mtx;
-	struct rt_mutex_waiter *waiter;
+	int i;
 
 	spin_lock_irqsave(&mutex->wait_lock, flags);
 
@@ -1447,6 +1487,18 @@ rt_read_slowunlock(struct rw_mutex *rwm,
 	 */
 	mark_rt_rwlock_check(rwm);
 
+	for (i = current->reader_lock_count - 1; i >= 0; i--) {
+		if (current->owned_read_locks[i].lock == rwm) {
+			current->owned_read_locks[i].count--;
+			if (!current->owned_read_locks[i].count) {
+				current->reader_lock_count--;
+				WARN_ON_ONCE(i != current->reader_lock_count);
+			}
+			break;
+		}
+	}
+	WARN_ON_ONCE(i < 0);
+
 	/*
 	 * If there are more readers, let the last one do any wakeups.
 	 * Also check to make sure the owner wasn't cleared when two
@@ -1508,9 +1560,15 @@ rt_read_fastunlock(struct rw_mutex *rwm,
 	WARN_ON(!atomic_read(&rwm->count));
 	WARN_ON(!rwm->owner);
 	atomic_dec(&rwm->count);
-	if (likely(rt_rwlock_cmpxchg(rwm, current, NULL)))
+	if (likely(rt_rwlock_cmpxchg(rwm, current, NULL))) {
+		int reader_count = --current->reader_lock_count;
 		rt_mutex_deadlock_account_unlock(current);
-	else
+		if (unlikely(reader_count < 0)) {
+			    reader_count = 0;
+			    WARN_ON_ONCE(1);
+		}
+		WARN_ON_ONCE(current->owned_read_locks[reader_count].lock != rwm);
+	} else
 		slowfn(rwm, mtx);
 }
 
Index: linux-2.6.24.4-rt4/kernel/fork.c
===================================================================
--- linux-2.6.24.4-rt4.orig/kernel/fork.c	2008-03-25 16:41:48.000000000 -0400
+++ linux-2.6.24.4-rt4/kernel/fork.c	2008-03-25 22:55:46.000000000 -0400
@@ -1206,6 +1206,10 @@ static struct task_struct *copy_process(
 	p->lock_count = 0;
 #endif
 
+#ifdef CONFIG_PREEMPT_RT
+	p->reader_lock_count = 0;
+#endif
+
 	if (pid != &init_struct_pid) {
 		retval = -ENOMEM;
 		pid = alloc_pid(task_active_pid_ns(p));

-- 
