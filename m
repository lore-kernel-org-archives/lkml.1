Return-Path: <linux-kernel-owner+w=401wt.eu-S1762290AbYDYOV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762290AbYDYOV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758164AbYDYOVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:21:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756840AbYDYOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:21:12 -0400
Message-Id: <20080425142109.654703208@goodmis.org>
References: <20080425130908.140707404@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 25 Apr 2008 09:09:10 -0400
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
Subject: [PATCH RT 2/6] implement rwlocks management
Content-Disposition: inline; filename=rwlocks-multiple-readers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the managment for rwlocks to have multiple readers.
Like the rwsems, it does not do PI boosting on readers when a writer
is blocked.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 include/linux/rt_lock.h  |    5 -
 include/linux/spinlock.h |    2 
 kernel/rt.c              |   56 ++--------------
 kernel/rtmutex.c         |  158 ++++++++++++++++++++++++++++++++++-------------
 kernel/rtmutex_common.h  |    4 +
 5 files changed, 129 insertions(+), 96 deletions(-)

Index: linux-2.6.24.4-rt4/include/linux/rt_lock.h
===================================================================
--- linux-2.6.24.4-rt4.orig/include/linux/rt_lock.h	2008-03-25 21:39:23.000000000 -0400
+++ linux-2.6.24.4-rt4/include/linux/rt_lock.h	2008-03-25 22:54:24.000000000 -0400
@@ -87,8 +87,7 @@ struct rw_semaphore {
  * rwlocks - an RW semaphore plus lock-break field:
  */
 typedef struct {
-	struct rt_mutex		lock;
-	int			read_depth;
+	struct rw_mutex	owners;
 	unsigned int		break_lock;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map	dep_map;
@@ -96,7 +95,7 @@ typedef struct {
 } rwlock_t;
 
 #define __RW_LOCK_UNLOCKED(name) (rwlock_t) \
-	{ .lock = __RT_SPIN_INITIALIZER(name),	\
+	{ .owners.mutex = __RT_SPIN_INITIALIZER(name.owners.mutex),	\
 	  RW_DEP_MAP_INIT(name) }
 #else /* !PREEMPT_RT */
 
Index: linux-2.6.24.4-rt4/include/linux/spinlock.h
===================================================================
--- linux-2.6.24.4-rt4.orig/include/linux/spinlock.h	2008-03-25 16:41:48.000000000 -0400
+++ linux-2.6.24.4-rt4/include/linux/spinlock.h	2008-03-25 22:54:24.000000000 -0400
@@ -266,7 +266,7 @@ do {							\
 
 #ifdef CONFIG_PREEMPT_RT
 # define rt_read_can_lock(rwl)	(!rt_mutex_is_locked(&(rwl)->lock))
-# define rt_write_can_lock(rwl)	(!rt_mutex_is_locked(&(rwl)->lock))
+# define rt_write_can_lock(rwl)	((rwl)->owners.owner == NULL)
 #else
  extern int rt_rwlock_can_lock_never_call_on_non_rt(rwlock_t *rwlock);
 # define rt_read_can_lock(rwl)	rt_rwlock_can_lock_never_call_on_non_rt(rwl)
Index: linux-2.6.24.4-rt4/kernel/rt.c
===================================================================
--- linux-2.6.24.4-rt4.orig/kernel/rt.c	2008-03-25 21:38:23.000000000 -0400
+++ linux-2.6.24.4-rt4/kernel/rt.c	2008-03-25 22:54:24.000000000 -0400
@@ -165,7 +165,7 @@ EXPORT_SYMBOL(_mutex_unlock);
  */
 int __lockfunc rt_write_trylock(rwlock_t *rwlock)
 {
-	int ret = rt_mutex_trylock(&rwlock->lock);
+	int ret = rt_mutex_down_write_trylock(&rwlock->owners);
 
 	if (ret)
 		rwlock_acquire(&rwlock->dep_map, 0, 1, _RET_IP_);
@@ -183,23 +183,9 @@ EXPORT_SYMBOL(rt_write_trylock_irqsave);
 
 int __lockfunc rt_read_trylock(rwlock_t *rwlock)
 {
-	struct rt_mutex *lock = &rwlock->lock;
-	unsigned long flags;
 	int ret;
 
-	/*
-	 * Read locks within the self-held write lock succeed.
-	 */
-	spin_lock_irqsave(&lock->wait_lock, flags);
-	if (rt_mutex_real_owner(lock) == current) {
-		spin_unlock_irqrestore(&lock->wait_lock, flags);
-		rwlock->read_depth++;
-		rwlock_acquire_read(&rwlock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-	spin_unlock_irqrestore(&lock->wait_lock, flags);
-
-	ret = rt_mutex_trylock(lock);
+	ret = rt_mutex_down_read_trylock(&rwlock->owners);
 	if (ret)
 		rwlock_acquire_read(&rwlock->dep_map, 0, 1, _RET_IP_);
 
@@ -210,27 +196,14 @@ EXPORT_SYMBOL(rt_read_trylock);
 void __lockfunc rt_write_lock(rwlock_t *rwlock)
 {
 	rwlock_acquire(&rwlock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_RT(rwlock, rt_mutex_trylock, __rt_spin_lock);
+	LOCK_CONTENDED_RT_RW(rwlock, rt_mutex_down_write_trylock, rt_rwlock_write_lock);
 }
 EXPORT_SYMBOL(rt_write_lock);
 
 void __lockfunc rt_read_lock(rwlock_t *rwlock)
 {
-	unsigned long flags;
-	struct rt_mutex *lock = &rwlock->lock;
-
 	rwlock_acquire_read(&rwlock->dep_map, 0, 0, _RET_IP_);
-	/*
-	 * Read locks within the write lock succeed.
-	 */
-	spin_lock_irqsave(&lock->wait_lock, flags);
-	if (rt_mutex_real_owner(lock) == current) {
-		spin_unlock_irqrestore(&lock->wait_lock, flags);
-		rwlock->read_depth++;
-		return;
-	}
-	spin_unlock_irqrestore(&lock->wait_lock, flags);
-	LOCK_CONTENDED_RT(rwlock, rt_mutex_trylock, __rt_spin_lock);
+	LOCK_CONTENDED_RT_RW(rwlock, rt_mutex_down_read_trylock, rt_rwlock_read_lock);
 }
 
 EXPORT_SYMBOL(rt_read_lock);
@@ -239,28 +212,14 @@ void __lockfunc rt_write_unlock(rwlock_t
 {
 	/* NOTE: we always pass in '1' for nested, for simplicity */
 	rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
-	__rt_spin_unlock(&rwlock->lock);
+	rt_rwlock_write_unlock(&rwlock->owners);
 }
 EXPORT_SYMBOL(rt_write_unlock);
 
 void __lockfunc rt_read_unlock(rwlock_t *rwlock)
 {
-	struct rt_mutex *lock = &rwlock->lock;
-	unsigned long flags;
-
 	rwlock_release(&rwlock->dep_map, 1, _RET_IP_);
-	// TRACE_WARN_ON(lock->save_state != 1);
-	/*
-	 * Read locks within the self-held write lock succeed.
-	 */
-	spin_lock_irqsave(&lock->wait_lock, flags);
-	if (rt_mutex_real_owner(lock) == current && rwlock->read_depth) {
-		spin_unlock_irqrestore(&lock->wait_lock, flags);
-		rwlock->read_depth--;
-		return;
-	}
-	spin_unlock_irqrestore(&lock->wait_lock, flags);
-	__rt_spin_unlock(&rwlock->lock);
+	rt_rwlock_read_unlock(&rwlock->owners);
 }
 EXPORT_SYMBOL(rt_read_unlock);
 
@@ -289,8 +248,7 @@ void __rt_rwlock_init(rwlock_t *rwlock, 
 	debug_check_no_locks_freed((void *)rwlock, sizeof(*rwlock));
 	lockdep_init_map(&rwlock->dep_map, name, key, 0);
 #endif
-	__rt_mutex_init(&rwlock->lock, name);
-	rwlock->read_depth = 0;
+	rt_mutex_rwsem_init(&rwlock->owners, name);
 }
 EXPORT_SYMBOL(__rt_rwlock_init);
 
Index: linux-2.6.24.4-rt4/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.4-rt4.orig/kernel/rtmutex.c	2008-03-25 22:39:14.000000000 -0400
+++ linux-2.6.24.4-rt4/kernel/rtmutex.c	2008-03-25 22:54:24.000000000 -0400
@@ -1072,12 +1072,12 @@ try_to_take_rw_write(struct rw_mutex *rw
 }
 
 static void
-rt_read_slowlock(struct rw_mutex *rwm)
+rt_read_slowlock(struct rw_mutex *rwm, int mtx)
 {
 	struct rt_mutex_waiter waiter;
 	struct rt_mutex *mutex = &rwm->mutex;
 	int saved_lock_depth = -1;
-	unsigned long flags;
+	unsigned long saved_state = -1, state, flags;
 
 	spin_lock_irqsave(&mutex->wait_lock, flags);
 	init_lists(mutex);
@@ -1096,13 +1096,19 @@ rt_read_slowlock(struct rw_mutex *rwm)
 
 	init_lists(mutex);
 
-	/*
-	 * We drop the BKL here before we go into the wait loop to avoid a
-	 * possible deadlock in the scheduler.
-	 */
-	if (unlikely(current->lock_depth >= 0))
-		saved_lock_depth = rt_release_bkl(mutex, flags);
-	set_current_state(TASK_UNINTERRUPTIBLE);
+	if (mtx) {
+		/*
+		 * We drop the BKL here before we go into the wait loop to avoid a
+		 * possible deadlock in the scheduler.
+		 */
+		if (unlikely(current->lock_depth >= 0))
+			saved_lock_depth = rt_release_bkl(mutex, flags);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+	} else {
+		/* Spin lock must preserve BKL */
+		saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
+		saved_lock_depth = current->lock_depth;
+	}
 
 	for (;;) {
 		unsigned long saved_flags;
@@ -1125,21 +1131,36 @@ rt_read_slowlock(struct rw_mutex *rwm)
 		}
 		saved_flags = current->flags & PF_NOSCHED;
 		current->flags &= ~PF_NOSCHED;
+		if (!mtx)
+			current->lock_depth = -1;
 
 		spin_unlock_irqrestore(&mutex->wait_lock, flags);
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		if (waiter.task)
+		if (!mtx || waiter.task)
 			schedule_rt_mutex(mutex);
 
 		spin_lock_irqsave(&mutex->wait_lock, flags);
 
 		current->flags |= saved_flags;
-		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (mtx)
+			set_current_state(TASK_UNINTERRUPTIBLE);
+		else {
+			current->lock_depth = saved_lock_depth;
+			state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
+			if (unlikely(state == TASK_RUNNING))
+				saved_state = TASK_RUNNING;
+		}
 	}
 
-	set_current_state(TASK_RUNNING);
+	if (mtx)
+		set_current_state(TASK_RUNNING);
+	else {
+		state = xchg(&current->state, saved_state);
+		if (unlikely(state == TASK_RUNNING))
+			current->state = TASK_RUNNING;
+	}
 
 	if (unlikely(waiter.task))
 		remove_waiter(mutex, &waiter, flags);
@@ -1152,7 +1173,7 @@ rt_read_slowlock(struct rw_mutex *rwm)
 	spin_unlock_irqrestore(&mutex->wait_lock, flags);
 
 	/* Must we reaquire the BKL? */
-	if (unlikely(saved_lock_depth >= 0))
+	if (mtx && unlikely(saved_lock_depth >= 0))
 		rt_reacquire_bkl(saved_lock_depth);
 
 	debug_rt_mutex_free_waiter(&waiter);
@@ -1160,7 +1181,8 @@ rt_read_slowlock(struct rw_mutex *rwm)
 
 static inline void
 rt_read_fastlock(struct rw_mutex *rwm,
-		 void fastcall (*slowfn)(struct rw_mutex *rwm))
+		 void fastcall (*slowfn)(struct rw_mutex *rwm, int mtx),
+		 int mtx)
 {
 retry:
 	if (likely(rt_rwlock_cmpxchg(rwm, NULL, current))) {
@@ -1176,12 +1198,17 @@ retry:
 			goto retry;
 		}
 	} else
-		slowfn(rwm);
+		slowfn(rwm, mtx);
 }
 
 void fastcall rt_mutex_down_read(struct rw_mutex *rwm)
 {
-	rt_read_fastlock(rwm, rt_read_slowlock);
+	rt_read_fastlock(rwm, rt_read_slowlock, 1);
+}
+
+void fastcall rt_rwlock_read_lock(struct rw_mutex *rwm)
+{
+	rt_read_fastlock(rwm, rt_read_slowlock, 0);
 }
 
 
@@ -1231,12 +1258,12 @@ int __sched rt_mutex_down_read_trylock(s
 }
 
 static void
-rt_write_slowlock(struct rw_mutex *rwm)
+rt_write_slowlock(struct rw_mutex *rwm, int mtx)
 {
 	struct rt_mutex *mutex = &rwm->mutex;
 	struct rt_mutex_waiter waiter;
 	int saved_lock_depth = -1;
-	unsigned long flags;
+	unsigned long flags, saved_state = -1, state;
 
 	debug_rt_mutex_init_waiter(&waiter);
 	waiter.task = NULL;
@@ -1253,13 +1280,19 @@ rt_write_slowlock(struct rw_mutex *rwm)
 	}
 	update_rw_mutex_owner(rwm);
 
-	/*
-	 * We drop the BKL here before we go into the wait loop to avoid a
-	 * possible deadlock in the scheduler.
-	 */
-	if (unlikely(current->lock_depth >= 0))
-		saved_lock_depth = rt_release_bkl(mutex, flags);
-	set_current_state(TASK_UNINTERRUPTIBLE);
+	if (mtx) {
+		/*
+		 * We drop the BKL here before we go into the wait loop to avoid a
+		 * possible deadlock in the scheduler.
+		 */
+		if (unlikely(current->lock_depth >= 0))
+			saved_lock_depth = rt_release_bkl(mutex, flags);
+		set_current_state(TASK_UNINTERRUPTIBLE);
+	} else {
+		/* Spin locks must preserve the BKL */
+		saved_lock_depth = current->lock_depth;
+		saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
+	}
 
 	for (;;) {
 		unsigned long saved_flags;
@@ -1282,21 +1315,36 @@ rt_write_slowlock(struct rw_mutex *rwm)
 		}
 		saved_flags = current->flags & PF_NOSCHED;
 		current->flags &= ~PF_NOSCHED;
+		if (!mtx)
+			current->lock_depth = -1;
 
 		spin_unlock_irqrestore(&mutex->wait_lock, flags);
 
 		debug_rt_mutex_print_deadlock(&waiter);
 
-		if (waiter.task)
+		if (!mtx || waiter.task)
 			schedule_rt_mutex(mutex);
 
 		spin_lock_irqsave(&mutex->wait_lock, flags);
 
 		current->flags |= saved_flags;
-		set_current_state(TASK_UNINTERRUPTIBLE);
+		if (mtx)
+			set_current_state(TASK_UNINTERRUPTIBLE);
+		else {
+			current->lock_depth = saved_lock_depth;
+			state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
+			if (unlikely(state == TASK_RUNNING))
+				saved_state = TASK_RUNNING;
+		}
 	}
 
-	set_current_state(TASK_RUNNING);
+	if (mtx)
+		set_current_state(TASK_RUNNING);
+	else {
+		state = xchg(&current->state, saved_state);
+		if (unlikely(state == TASK_RUNNING))
+			current->state = TASK_RUNNING;
+	}
 
 	if (unlikely(waiter.task))
 		remove_waiter(mutex, &waiter, flags);
@@ -1308,7 +1356,7 @@ rt_write_slowlock(struct rw_mutex *rwm)
 	spin_unlock_irqrestore(&mutex->wait_lock, flags);
 
 	/* Must we reaquire the BKL? */
-	if (unlikely(saved_lock_depth >= 0))
+	if (mtx && unlikely(saved_lock_depth >= 0))
 		rt_reacquire_bkl(saved_lock_depth);
 
 	WARN_ON(atomic_read(&rwm->count));
@@ -1319,7 +1367,8 @@ rt_write_slowlock(struct rw_mutex *rwm)
 
 static inline void
 rt_write_fastlock(struct rw_mutex *rwm,
-		  void fastcall (*slowfn)(struct rw_mutex *rwm))
+		  void fastcall (*slowfn)(struct rw_mutex *rwm, int mtx),
+		  int mtx)
 {
 	unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
 
@@ -1327,12 +1376,17 @@ rt_write_fastlock(struct rw_mutex *rwm,
 		rt_mutex_deadlock_account_lock(&rwm->mutex, current);
 		WARN_ON(atomic_read(&rwm->count));
 	} else
-		slowfn(rwm);
+		slowfn(rwm, mtx);
 }
 
 void fastcall rt_mutex_down_write(struct rw_mutex *rwm)
 {
-	rt_write_fastlock(rwm, rt_write_slowlock);
+	rt_write_fastlock(rwm, rt_write_slowlock, 1);
+}
+
+void fastcall rt_rwlock_write_lock(struct rw_mutex *rwm)
+{
+	rt_write_fastlock(rwm, rt_write_slowlock, 0);
 }
 
 static int
@@ -1373,10 +1427,11 @@ int fastcall rt_mutex_down_write_trylock
 }
 
 static void fastcall noinline __sched
-rt_read_slowunlock(struct rw_mutex *rwm)
+rt_read_slowunlock(struct rw_mutex *rwm, int mtx)
 {
 	struct rt_mutex *mutex = &rwm->mutex;
 	unsigned long flags;
+	int savestate = !mtx;
 	struct rt_mutex_waiter *waiter;
 
 	spin_lock_irqsave(&mutex->wait_lock, flags);
@@ -1436,7 +1491,7 @@ rt_read_slowunlock(struct rw_mutex *rwm)
 	 * will steal the lock from the reader. This is the
 	 * only time we can have a reader pending on a lock.
 	 */
-	wakeup_next_waiter(mutex, 0);
+	wakeup_next_waiter(mutex, savestate);
 
  out:
 	spin_unlock_irqrestore(&mutex->wait_lock, flags);
@@ -1447,7 +1502,8 @@ rt_read_slowunlock(struct rw_mutex *rwm)
 
 static inline void
 rt_read_fastunlock(struct rw_mutex *rwm,
-		   void fastcall (*slowfn)(struct rw_mutex *rwm))
+		   void fastcall (*slowfn)(struct rw_mutex *rwm, int mtx),
+		   int mtx)
 {
 	WARN_ON(!atomic_read(&rwm->count));
 	WARN_ON(!rwm->owner);
@@ -1455,20 +1511,26 @@ rt_read_fastunlock(struct rw_mutex *rwm,
 	if (likely(rt_rwlock_cmpxchg(rwm, current, NULL)))
 		rt_mutex_deadlock_account_unlock(current);
 	else
-		slowfn(rwm);
+		slowfn(rwm, mtx);
 }
 
 void fastcall rt_mutex_up_read(struct rw_mutex *rwm)
 {
-	rt_read_fastunlock(rwm, rt_read_slowunlock);
+	rt_read_fastunlock(rwm, rt_read_slowunlock, 1);
+}
+
+void fastcall rt_rwlock_read_unlock(struct rw_mutex *rwm)
+{
+	rt_read_fastunlock(rwm, rt_read_slowunlock, 0);
 }
 
 static void fastcall noinline __sched
-rt_write_slowunlock(struct rw_mutex *rwm)
+rt_write_slowunlock(struct rw_mutex *rwm, int mtx)
 {
 	struct rt_mutex *mutex = &rwm->mutex;
 	struct rt_mutex_waiter *waiter;
 	struct task_struct *pendowner;
+	int savestate = !mtx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mutex->wait_lock, flags);
@@ -1499,7 +1561,7 @@ rt_write_slowunlock(struct rw_mutex *rwm
 
 	waiter = rt_mutex_top_waiter(mutex);
 	pendowner = waiter->task;
-	wakeup_next_waiter(mutex, 0);
+	wakeup_next_waiter(mutex, savestate);
 
 	/* another writer is next? */
 	if (waiter->write_lock) {
@@ -1535,7 +1597,10 @@ rt_write_slowunlock(struct rw_mutex *rwm
 		waiter->task = NULL;
 		reader->pi_blocked_on = NULL;
 
-		wake_up_process(reader);
+		if (savestate)
+			wake_up_process_mutex(reader);
+		else
+			wake_up_process(reader);
 
 		if (rt_mutex_has_waiters(mutex))
 			waiter = rt_mutex_top_waiter(mutex);
@@ -1565,7 +1630,9 @@ rt_write_slowunlock(struct rw_mutex *rwm
 
 static inline void
 rt_write_fastunlock(struct rw_mutex *rwm,
-		   void fastcall (*slowfn)(struct rw_mutex *rwm))
+		    void fastcall (*slowfn)(struct rw_mutex *rwm,
+					    int mtx),
+		    int mtx)
 {
 	unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
 
@@ -1573,12 +1640,17 @@ rt_write_fastunlock(struct rw_mutex *rwm
 	if (likely(rt_rwlock_cmpxchg(rwm, (struct task_struct *)val, NULL)))
 		rt_mutex_deadlock_account_unlock(current);
 	else
-		slowfn(rwm);
+		slowfn(rwm, mtx);
 }
 
 void fastcall rt_mutex_up_write(struct rw_mutex *rwm)
 {
-	rt_write_fastunlock(rwm, rt_write_slowunlock);
+	rt_write_fastunlock(rwm, rt_write_slowunlock, 1);
+}
+
+void fastcall rt_rwlock_write_unlock(struct rw_mutex *rwm)
+{
+	rt_write_fastunlock(rwm, rt_write_slowunlock, 0);
 }
 
 void rt_mutex_rwsem_init(struct rw_mutex *rwm, const char *name)
Index: linux-2.6.24.4-rt4/kernel/rtmutex_common.h
===================================================================
--- linux-2.6.24.4-rt4.orig/kernel/rtmutex_common.h	2008-03-25 21:45:43.000000000 -0400
+++ linux-2.6.24.4-rt4/kernel/rtmutex_common.h	2008-03-25 22:54:24.000000000 -0400
@@ -166,6 +166,10 @@ extern void rt_mutex_down_write(struct r
 extern int rt_mutex_down_read_trylock(struct rw_mutex *rwm);
 extern void rt_mutex_down_read(struct rw_mutex *rwm);
 extern void rt_mutex_rwsem_init(struct rw_mutex *rwm, const char *name);
+extern void rt_rwlock_write_lock(struct rw_mutex *rwm);
+extern void rt_rwlock_read_lock(struct rw_mutex *rwm);
+extern void rt_rwlock_write_unlock(struct rw_mutex *rwm);
+extern void rt_rwlock_read_unlock(struct rw_mutex *rwm);
 
 #endif /* CONFIG_PREEMPT_RT */
 

-- 
