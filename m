Return-Path: <linux-kernel-owner+w=401wt.eu-S934189AbZLFSDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbZLFSDq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934165AbZLFSDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:38 -0500
Received: from www.tglx.de ([62.245.132.106]:33148 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934108AbZLFSDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:00 -0500
Message-Id: <20091206111957.689810327@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 10/23] locking: Further name space cleanups
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=locking-fixup-namespace.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name space hierarchy for the internal lock functions is now a bit
backwards. raw_spin* functions map to _spin* which use __spin*, while
we would like to have _raw_spin* and __raw_spin*.

_raw_spin* is already used by lock debugging, so rename those funtions
to do_raw_spin* to free up the _raw_spin* name space.

Nu functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rwlock.h           |   32 +++++++++++++++----------------
 include/linux/rwlock_api_smp.h   |   40 +++++++++++++++++++--------------------
 include/linux/spinlock.h         |   20 +++++++++----------
 include/linux/spinlock_api_smp.h |   24 +++++++++++------------
 kernel/sched.c                   |    2 -
 kernel/spinlock.c                |   12 +++++------
 lib/spinlock_debug.c             |    6 ++---
 7 files changed, 68 insertions(+), 68 deletions(-)

Index: linux-2.6-tip/include/linux/rwlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rwlock.h
+++ linux-2.6-tip/include/linux/rwlock.h
@@ -31,25 +31,25 @@ do {								\
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void _raw_read_lock(rwlock_t *lock);
-#define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)
- extern int _raw_read_trylock(rwlock_t *lock);
- extern void _raw_read_unlock(rwlock_t *lock);
- extern void _raw_write_lock(rwlock_t *lock);
-#define _raw_write_lock_flags(lock, flags) _raw_write_lock(lock)
- extern int _raw_write_trylock(rwlock_t *lock);
- extern void _raw_write_unlock(rwlock_t *lock);
+ extern void do_raw_read_lock(rwlock_t *lock);
+#define do_raw_read_lock_flags(lock, flags) do_raw_read_lock(lock)
+ extern int do_raw_read_trylock(rwlock_t *lock);
+ extern void do_raw_read_unlock(rwlock_t *lock);
+ extern void do_raw_write_lock(rwlock_t *lock);
+#define do_raw_write_lock_flags(lock, flags) do_raw_write_lock(lock)
+ extern int do_raw_write_trylock(rwlock_t *lock);
+ extern void do_raw_write_unlock(rwlock_t *lock);
 #else
-# define _raw_read_lock(rwlock)		arch_read_lock(&(rwlock)->raw_lock)
-# define _raw_read_lock_flags(lock, flags) \
+# define do_raw_read_lock(rwlock)		arch_read_lock(&(rwlock)->raw_lock)
+# define do_raw_read_lock_flags(lock, flags) \
 		arch_read_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
-# define _raw_read_unlock(rwlock)	arch_read_unlock(&(rwlock)->raw_lock)
-# define _raw_write_lock(rwlock)	arch_write_lock(&(rwlock)->raw_lock)
-# define _raw_write_lock_flags(lock, flags) \
+# define do_raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
+# define do_raw_read_unlock(rwlock)	arch_read_unlock(&(rwlock)->raw_lock)
+# define do_raw_write_lock(rwlock)	arch_write_lock(&(rwlock)->raw_lock)
+# define do_raw_write_lock_flags(lock, flags) \
 		arch_write_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
-# define _raw_write_unlock(rwlock)	arch_write_unlock(&(rwlock)->raw_lock)
+# define do_raw_write_trylock(rwlock)	arch_write_trylock(&(rwlock)->raw_lock)
+# define do_raw_write_unlock(rwlock)	arch_write_unlock(&(rwlock)->raw_lock)
 #endif
 
 #define read_can_lock(rwlock)		arch_read_can_lock(&(rwlock)->raw_lock)
Index: linux-2.6-tip/include/linux/rwlock_api_smp.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rwlock_api_smp.h
+++ linux-2.6-tip/include/linux/rwlock_api_smp.h
@@ -113,7 +113,7 @@ void __lockfunc _write_unlock_irqrestore
 static inline int __read_trylock(rwlock_t *lock)
 {
 	preempt_disable();
-	if (_raw_read_trylock(lock)) {
+	if (do_raw_read_trylock(lock)) {
 		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
@@ -124,7 +124,7 @@ static inline int __read_trylock(rwlock_
 static inline int __write_trylock(rwlock_t *lock)
 {
 	preempt_disable();
-	if (_raw_write_trylock(lock)) {
+	if (do_raw_write_trylock(lock)) {
 		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
@@ -143,7 +143,7 @@ static inline void __read_lock(rwlock_t 
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
 static inline unsigned long __read_lock_irqsave(rwlock_t *lock)
@@ -153,8 +153,8 @@ static inline unsigned long __read_lock_
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
-			     _raw_read_lock_flags, &flags);
+	LOCK_CONTENDED_FLAGS(lock, do_raw_read_trylock, do_raw_read_lock,
+			     do_raw_read_lock_flags, &flags);
 	return flags;
 }
 
@@ -163,7 +163,7 @@ static inline void __read_lock_irq(rwloc
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
 static inline void __read_lock_bh(rwlock_t *lock)
@@ -171,7 +171,7 @@ static inline void __read_lock_bh(rwlock
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
 static inline unsigned long __write_lock_irqsave(rwlock_t *lock)
@@ -181,8 +181,8 @@ static inline unsigned long __write_lock
 	local_irq_save(flags);
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
-			     _raw_write_lock_flags, &flags);
+	LOCK_CONTENDED_FLAGS(lock, do_raw_write_trylock, do_raw_write_lock,
+			     do_raw_write_lock_flags, &flags);
 	return flags;
 }
 
@@ -191,7 +191,7 @@ static inline void __write_lock_irq(rwlo
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
 static inline void __write_lock_bh(rwlock_t *lock)
@@ -199,14 +199,14 @@ static inline void __write_lock_bh(rwloc
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
 static inline void __write_lock(rwlock_t *lock)
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
 #endif /* CONFIG_PREEMPT */
@@ -214,21 +214,21 @@ static inline void __write_lock(rwlock_t
 static inline void __write_unlock(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
+	do_raw_write_unlock(lock);
 	preempt_enable();
 }
 
 static inline void __read_unlock(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
+	do_raw_read_unlock(lock);
 	preempt_enable();
 }
 
 static inline void __read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
+	do_raw_read_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
 }
@@ -236,7 +236,7 @@ static inline void __read_unlock_irqrest
 static inline void __read_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
+	do_raw_read_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
 }
@@ -244,7 +244,7 @@ static inline void __read_unlock_irq(rwl
 static inline void __read_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
+	do_raw_read_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
@@ -253,7 +253,7 @@ static inline void __write_unlock_irqres
 					     unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
+	do_raw_write_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
 }
@@ -261,7 +261,7 @@ static inline void __write_unlock_irqres
 static inline void __write_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
+	do_raw_write_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
 }
@@ -269,7 +269,7 @@ static inline void __write_unlock_irq(rw
 static inline void __write_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
+	do_raw_write_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -89,13 +89,13 @@
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
-  extern void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
+  extern void _do_raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
 				   struct lock_class_key *key);
 # define raw_spin_lock_init(lock)				\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	__raw_spin_lock_init((lock), #lock, &__key);		\
+	_do_raw_spin_lock_init((lock), #lock, &__key);		\
 } while (0)
 
 #else
@@ -128,28 +128,28 @@ static inline void smp_mb__after_lock(vo
 #define raw_spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void _raw_spin_lock(raw_spinlock_t *lock);
-#define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
- extern int _raw_spin_trylock(raw_spinlock_t *lock);
- extern void _raw_spin_unlock(raw_spinlock_t *lock);
+ extern void do_raw_spin_lock(raw_spinlock_t *lock);
+#define do_raw_spin_lock_flags(lock, flags) do_raw_spin_lock(lock)
+ extern int do_raw_spin_trylock(raw_spinlock_t *lock);
+ extern void do_raw_spin_unlock(raw_spinlock_t *lock);
 #else
-static inline void _raw_spin_lock(raw_spinlock_t *lock)
+static inline void do_raw_spin_lock(raw_spinlock_t *lock)
 {
 	arch_spin_lock(&lock->raw_lock);
 }
 
 static inline void
-_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags)
+do_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags)
 {
 	arch_spin_lock_flags(&lock->raw_lock, *flags);
 }
 
-static inline int _raw_spin_trylock(raw_spinlock_t *lock)
+static inline int do_raw_spin_trylock(raw_spinlock_t *lock)
 {
 	return arch_spin_trylock(&(lock)->raw_lock);
 }
 
-static inline void _raw_spin_unlock(raw_spinlock_t *lock)
+static inline void do_raw_spin_unlock(raw_spinlock_t *lock)
 {
 	arch_spin_unlock(&lock->raw_lock);
 }
Index: linux-2.6-tip/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6-tip/include/linux/spinlock_api_smp.h
@@ -85,7 +85,7 @@ _spin_unlock_irqrestore(raw_spinlock_t *
 static inline int __spin_trylock(raw_spinlock_t *lock)
 {
 	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
+	if (do_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
@@ -109,13 +109,13 @@ static inline unsigned long __spin_lock_
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	/*
 	 * On lockdep we dont want the hand-coded irq-enable of
-	 * _raw_spin_lock_flags() code, because lockdep assumes
+	 * do_raw_spin_lock_flags() code, because lockdep assumes
 	 * that interrupts are not re-enabled during lock-acquire:
 	 */
 #ifdef CONFIG_LOCKDEP
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 #else
-	_raw_spin_lock_flags(lock, &flags);
+	do_raw_spin_lock_flags(lock, &flags);
 #endif
 	return flags;
 }
@@ -125,7 +125,7 @@ static inline void __spin_lock_irq(raw_s
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
 static inline void __spin_lock_bh(raw_spinlock_t *lock)
@@ -133,14 +133,14 @@ static inline void __spin_lock_bh(raw_sp
 	local_bh_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
 static inline void __spin_lock(raw_spinlock_t *lock)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
 #endif /* CONFIG_PREEMPT */
@@ -148,7 +148,7 @@ static inline void __spin_lock(raw_spinl
 static inline void __spin_unlock(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
+	do_raw_spin_unlock(lock);
 	preempt_enable();
 }
 
@@ -156,7 +156,7 @@ static inline void __spin_unlock_irqrest
 					    unsigned long flags)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
+	do_raw_spin_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
 }
@@ -164,7 +164,7 @@ static inline void __spin_unlock_irqrest
 static inline void __spin_unlock_irq(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
+	do_raw_spin_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
 }
@@ -172,7 +172,7 @@ static inline void __spin_unlock_irq(raw
 static inline void __spin_unlock_bh(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
+	do_raw_spin_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
@@ -181,7 +181,7 @@ static inline int __spin_trylock_bh(raw_
 {
 	local_bh_disable();
 	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
+	if (do_raw_spin_trylock(lock)) {
 		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
 		return 1;
 	}
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -6703,7 +6703,7 @@ SYSCALL_DEFINE0(sched_yield)
 	 */
 	__release(rq->lock);
 	spin_release(&rq->lock.dep_map, 1, _THIS_IP_);
-	_raw_spin_unlock(&rq->lock);
+	do_raw_spin_unlock(&rq->lock);
 	preempt_enable_no_resched();
 
 	schedule();
Index: linux-2.6-tip/kernel/spinlock.c
===================================================================
--- linux-2.6-tip.orig/kernel/spinlock.c
+++ linux-2.6-tip/kernel/spinlock.c
@@ -48,7 +48,7 @@ void __lockfunc __##op##_lock(locktype##
 {									\
 	for (;;) {							\
 		preempt_disable();					\
-		if (likely(_raw_##op##_trylock(lock)))			\
+		if (likely(do_raw_##op##_trylock(lock)))		\
 			break;						\
 		preempt_enable();					\
 									\
@@ -67,7 +67,7 @@ unsigned long __lockfunc __##op##_lock_i
 	for (;;) {							\
 		preempt_disable();					\
 		local_irq_save(flags);					\
-		if (likely(_raw_##op##_trylock(lock)))			\
+		if (likely(do_raw_##op##_trylock(lock)))		\
 			break;						\
 		local_irq_restore(flags);				\
 		preempt_enable();					\
@@ -345,7 +345,7 @@ void __lockfunc _spin_lock_nested(raw_sp
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_nested);
 
@@ -357,8 +357,8 @@ unsigned long __lockfunc _spin_lock_irqs
 	local_irq_save(flags);
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_spin_trylock, _raw_spin_lock,
-				_raw_spin_lock_flags, &flags);
+	LOCK_CONTENDED_FLAGS(lock, do_raw_spin_trylock, do_raw_spin_lock,
+				do_raw_spin_lock_flags, &flags);
 	return flags;
 }
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);
@@ -368,7 +368,7 @@ void __lockfunc _spin_lock_nest_lock(raw
 {
 	preempt_disable();
 	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 EXPORT_SYMBOL(_spin_lock_nest_lock);
 
Index: linux-2.6-tip/lib/spinlock_debug.c
===================================================================
--- linux-2.6-tip.orig/lib/spinlock_debug.c
+++ linux-2.6-tip/lib/spinlock_debug.c
@@ -193,13 +193,13 @@ static void __read_lock_debug(rwlock_t *
 }
 #endif
 
-void _raw_read_lock(rwlock_t *lock)
+void do_raw_read_lock(rwlock_t *lock)
 {
 	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
 	arch_read_lock(&lock->raw_lock);
 }
 
-int _raw_read_trylock(rwlock_t *lock)
+int do_raw_read_trylock(rwlock_t *lock)
 {
 	int ret = arch_read_trylock(&lock->raw_lock);
 
@@ -212,7 +212,7 @@ int _raw_read_trylock(rwlock_t *lock)
 	return ret;
 }
 
-void _raw_read_unlock(rwlock_t *lock)
+void do_raw_read_unlock(rwlock_t *lock)
 {
 	RWLOCK_BUG_ON(lock->magic != RWLOCK_MAGIC, lock, "bad magic");
 	arch_read_unlock(&lock->raw_lock);


