Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbXISKxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbXISKxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757045AbXISKxF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:53:05 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbXISKxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:53:01 -0400
Message-Id: <20070919105054.899965000@chello.nl>
References: <20070919104125.286538000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 19 Sep 2007 12:41:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [RFC][PATCH 4/6] implicit vs explicit preempt_disable()
Content-Disposition: inline; filename=preempt-spinlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Decouple preempt_disable() from the locking primitives, so as that we
can test for proper rcu_dereference() context regardless of the locking
model.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/preempt.h |   37 +++++++++++++++++++----
 kernel/sched.c          |   10 +++---
 kernel/spinlock.c       |   76 ++++++++++++++++++++++++------------------------
 lib/kernel_lock.c       |   16 +++++-----
 4 files changed, 82 insertions(+), 57 deletions(-)

Index: linux-2.6/include/linux/preempt.h
===================================================================
--- linux-2.6.orig/include/linux/preempt.h
+++ linux-2.6/include/linux/preempt.h
@@ -30,6 +30,33 @@
 
 asmlinkage void preempt_schedule(void);
 
+#define preempt_check_resched() \
+do { \
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
+		preempt_schedule(); \
+} while (0)
+
+
+#define _preempt_disable() \
+do { \
+	__add_preempt_count(1, 0); \
+	barrier(); \
+} while (0)
+
+#define _preempt_enable_no_resched() \
+do { \
+	barrier(); \
+	__sub_preempt_count(1, 0); \
+} while (0)
+
+#define _preempt_enable() \
+do { \
+	_preempt_enable_no_resched(); \
+	barrier(); \
+	preempt_check_resched(); \
+} while (0)
+
+
 #define preempt_disable() \
 do { \
 	__add_preempt_count(1, 1); \
@@ -42,12 +69,6 @@ do { \
 	__sub_preempt_count(1, 1); \
 } while (0)
 
-#define preempt_check_resched() \
-do { \
-	if (unlikely(test_thread_flag(TIF_NEED_RESCHED))) \
-		preempt_schedule(); \
-} while (0)
-
 #define preempt_enable() \
 do { \
 	preempt_enable_no_resched(); \
@@ -57,6 +78,10 @@ do { \
 
 #else
 
+#define _preempt_disable()		do { } while (0)
+#define _preempt_enable_no_resched()	do { } while (0)
+#define _preempt_enable()		do { } while (0)
+
 #define preempt_disable()		do { } while (0)
 #define preempt_enable_no_resched()	do { } while (0)
 #define preempt_enable()		do { } while (0)
Index: linux-2.6/kernel/spinlock.c
===================================================================
--- linux-2.6.orig/kernel/spinlock.c
+++ linux-2.6/kernel/spinlock.c
@@ -23,39 +23,39 @@
 
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
-	preempt_disable();
+	_preempt_disable();
 	if (_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
 	
-	preempt_enable();
+	_preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL(_spin_trylock);
 
 int __lockfunc _read_trylock(rwlock_t *lock)
 {
-	preempt_disable();
+	_preempt_disable();
 	if (_raw_read_trylock(lock)) {
 		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
 
-	preempt_enable();
+	_preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL(_read_trylock);
 
 int __lockfunc _write_trylock(rwlock_t *lock)
 {
-	preempt_disable();
+	_preempt_disable();
 	if (_raw_write_trylock(lock)) {
 		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
 
-	preempt_enable();
+	_preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL(_write_trylock);
@@ -70,7 +70,7 @@ EXPORT_SYMBOL(_write_trylock);
 
 void __lockfunc _read_lock(rwlock_t *lock)
 {
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
@@ -81,7 +81,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	unsigned long flags;
 
 	local_irq_save(flags);
-	preempt_disable();
+	_preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	/*
 	 * On lockdep we dont want the hand-coded irq-enable of
@@ -100,7 +100,7 @@ EXPORT_SYMBOL(_spin_lock_irqsave);
 void __lockfunc _spin_lock_irq(spinlock_t *lock)
 {
 	local_irq_disable();
-	preempt_disable();
+	_preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
@@ -109,7 +109,7 @@ EXPORT_SYMBOL(_spin_lock_irq);
 void __lockfunc _spin_lock_bh(spinlock_t *lock)
 {
 	local_bh_disable();
-	preempt_disable();
+	_preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
@@ -120,7 +120,7 @@ unsigned long __lockfunc _read_lock_irqs
 	unsigned long flags;
 
 	local_irq_save(flags);
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 	return flags;
@@ -130,7 +130,7 @@ EXPORT_SYMBOL(_read_lock_irqsave);
 void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
@@ -139,7 +139,7 @@ EXPORT_SYMBOL(_read_lock_irq);
 void __lockfunc _read_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
@@ -150,7 +150,7 @@ unsigned long __lockfunc _write_lock_irq
 	unsigned long flags;
 
 	local_irq_save(flags);
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 	return flags;
@@ -160,7 +160,7 @@ EXPORT_SYMBOL(_write_lock_irqsave);
 void __lockfunc _write_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
@@ -169,7 +169,7 @@ EXPORT_SYMBOL(_write_lock_irq);
 void __lockfunc _write_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
@@ -177,7 +177,7 @@ EXPORT_SYMBOL(_write_lock_bh);
 
 void __lockfunc _spin_lock(spinlock_t *lock)
 {
-	preempt_disable();
+	_preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
@@ -186,7 +186,7 @@ EXPORT_SYMBOL(_spin_lock);
 
 void __lockfunc _write_lock(rwlock_t *lock)
 {
-	preempt_disable();
+	_preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
@@ -207,10 +207,10 @@ EXPORT_SYMBOL(_write_lock);
 void __lockfunc _##op##_lock(locktype##_t *lock)			\
 {									\
 	for (;;) {							\
-		preempt_disable();					\
+		_preempt_disable();					\
 		if (likely(_raw_##op##_trylock(lock)))			\
 			break;						\
-		preempt_enable();					\
+		_preempt_enable();					\
 									\
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
@@ -227,12 +227,12 @@ unsigned long __lockfunc _##op##_lock_ir
 	unsigned long flags;						\
 									\
 	for (;;) {							\
-		preempt_disable();					\
+		_preempt_disable();					\
 		local_irq_save(flags);					\
 		if (likely(_raw_##op##_trylock(lock)))			\
 			break;						\
 		local_irq_restore(flags);				\
-		preempt_enable();					\
+		_preempt_enable();					\
 									\
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
@@ -287,7 +287,7 @@ BUILD_LOCK_OPS(write, rwlock);
 
 void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
 {
-	preempt_disable();
+	_preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
@@ -298,7 +298,7 @@ unsigned long __lockfunc _spin_lock_irqs
 	unsigned long flags;
 
 	local_irq_save(flags);
-	preempt_disable();
+	_preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
 	/*
 	 * On lockdep we dont want the hand-coded irq-enable of
@@ -321,7 +321,7 @@ void __lockfunc _spin_unlock(spinlock_t 
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_spin_unlock);
 
@@ -329,7 +329,7 @@ void __lockfunc _write_unlock(rwlock_t *
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_write_unlock);
 
@@ -337,7 +337,7 @@ void __lockfunc _read_unlock(rwlock_t *l
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_read_unlock);
 
@@ -346,7 +346,7 @@ void __lockfunc _spin_unlock_irqrestore(
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_restore(flags);
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_spin_unlock_irqrestore);
 
@@ -355,7 +355,7 @@ void __lockfunc _spin_unlock_irq(spinloc
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_enable();
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_spin_unlock_irq);
 
@@ -363,7 +363,7 @@ void __lockfunc _spin_unlock_bh(spinlock
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 EXPORT_SYMBOL(_spin_unlock_bh);
@@ -373,7 +373,7 @@ void __lockfunc _read_unlock_irqrestore(
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	local_irq_restore(flags);
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_read_unlock_irqrestore);
 
@@ -382,7 +382,7 @@ void __lockfunc _read_unlock_irq(rwlock_
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	local_irq_enable();
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_read_unlock_irq);
 
@@ -390,7 +390,7 @@ void __lockfunc _read_unlock_bh(rwlock_t
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 EXPORT_SYMBOL(_read_unlock_bh);
@@ -400,7 +400,7 @@ void __lockfunc _write_unlock_irqrestore
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	local_irq_restore(flags);
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_write_unlock_irqrestore);
 
@@ -409,7 +409,7 @@ void __lockfunc _write_unlock_irq(rwlock
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	local_irq_enable();
-	preempt_enable();
+	_preempt_enable();
 }
 EXPORT_SYMBOL(_write_unlock_irq);
 
@@ -417,7 +417,7 @@ void __lockfunc _write_unlock_bh(rwlock_
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 EXPORT_SYMBOL(_write_unlock_bh);
@@ -425,13 +425,13 @@ EXPORT_SYMBOL(_write_unlock_bh);
 int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
 	local_bh_disable();
-	preempt_disable();
+	_preempt_disable();
 	if (_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
 
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 	return 0;
 }
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1847,7 +1847,7 @@ asmlinkage void schedule_tail(struct tas
 	finish_task_switch(rq, prev);
 #ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	/* In this case, finish_task_switch does not reenable preemption */
-	preempt_enable();
+	_preempt_enable();
 #endif
 	if (current->set_child_tid)
 		put_user(task_pid_vnr(current), current->set_child_tid);
@@ -3512,7 +3512,7 @@ asmlinkage void __sched schedule(void)
 	int cpu;
 
 need_resched:
-	preempt_disable();
+	_preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
 	rcu_qsctr_inc(cpu);
@@ -3560,7 +3560,7 @@ need_resched_nonpreemptible:
 		rq = cpu_rq(cpu);
 		goto need_resched_nonpreemptible;
 	}
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
 		goto need_resched;
 }
@@ -4605,7 +4605,7 @@ asmlinkage long sys_sched_yield(void)
 	__release(rq->lock);
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
 	_raw_spin_unlock(&rq->lock);
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 
 	schedule();
 
@@ -4661,7 +4661,7 @@ int cond_resched_lock(spinlock_t *lock)
 	if (need_resched() && system_state == SYSTEM_RUNNING) {
 		spin_release(&lock->dep_map, 1, _THIS_IP_);
 		_raw_spin_unlock(lock);
-		preempt_enable_no_resched();
+		_preempt_enable_no_resched();
 		__cond_resched();
 		ret = 1;
 		spin_lock(lock);
Index: linux-2.6/lib/kernel_lock.c
===================================================================
--- linux-2.6.orig/lib/kernel_lock.c
+++ linux-2.6/lib/kernel_lock.c
@@ -44,11 +44,11 @@ int __lockfunc __reacquire_kernel_lock(v
 	BUG_ON(saved_lock_depth < 0);
 
 	task->lock_depth = -1;
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 
 	down(&kernel_sem);
 
-	preempt_disable();
+	_preempt_disable();
 	task->lock_depth = saved_lock_depth;
 
 	return 0;
@@ -121,14 +121,14 @@ int __lockfunc __reacquire_kernel_lock(v
 			return -EAGAIN;
 		cpu_relax();
 	}
-	preempt_disable();
+	_preempt_disable();
 	return 0;
 }
 
 void __lockfunc __release_kernel_lock(void)
 {
 	_raw_spin_unlock(&kernel_flag);
-	preempt_enable_no_resched();
+	_preempt_enable_no_resched();
 }
 
 /*
@@ -139,7 +139,7 @@ void __lockfunc __release_kernel_lock(vo
 #ifdef CONFIG_PREEMPT
 static inline void __lock_kernel(void)
 {
-	preempt_disable();
+	_preempt_disable();
 	if (unlikely(!_raw_spin_trylock(&kernel_flag))) {
 		/*
 		 * If preemption was disabled even before this
@@ -156,10 +156,10 @@ static inline void __lock_kernel(void)
 		 * with preemption enabled..
 		 */
 		do {
-			preempt_enable();
+			_preempt_enable();
 			while (spin_is_locked(&kernel_flag))
 				cpu_relax();
-			preempt_disable();
+			_preempt_disable();
 		} while (!_raw_spin_trylock(&kernel_flag));
 	}
 }
@@ -182,7 +182,7 @@ static inline void __unlock_kernel(void)
 	 * unlocking sequence (and thus avoid the dep-chain ops):
 	 */
 	_raw_spin_unlock(&kernel_flag);
-	preempt_enable();
+	_preempt_enable();
 }
 
 /*

--

