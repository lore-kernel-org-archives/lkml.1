Return-Path: <linux-kernel-owner+w=401wt.eu-S934201AbZLFSDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934201AbZLFSDv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934140AbZLFSDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:49 -0500
Received: from www.tglx.de ([62.245.132.106]:33165 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934081AbZLFSDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:03:06 -0500
Message-Id: <20091206111957.728312176@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:46 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 11/23] locking: Cleanup the name space completely
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=locking-fixup-namespace-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the name space hierarchy of locking functions consistent:
     raw_spin* -> _raw_spin* -> __raw_spin*

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rwlock.h           |   50 +++++-----
 include/linux/rwlock_api_smp.h   |  113 +++++++++++-----------
 include/linux/spinlock.h         |   37 ++++---
 include/linux/spinlock_api_smp.h |   77 +++++++--------
 include/linux/spinlock_api_up.h  |   64 ++++++-------
 kernel/spinlock.c                |  192 +++++++++++++++++++--------------------
 6 files changed, 273 insertions(+), 260 deletions(-)

Index: linux-2.6-tip/include/linux/rwlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rwlock.h
+++ linux-2.6-tip/include/linux/rwlock.h
@@ -40,7 +40,7 @@ do {								\
  extern int do_raw_write_trylock(rwlock_t *lock);
  extern void do_raw_write_unlock(rwlock_t *lock);
 #else
-# define do_raw_read_lock(rwlock)		arch_read_lock(&(rwlock)->raw_lock)
+# define do_raw_read_lock(rwlock)	arch_read_lock(&(rwlock)->raw_lock)
 # define do_raw_read_lock_flags(lock, flags) \
 		arch_read_lock_flags(&(lock)->raw_lock, *(flags))
 # define do_raw_read_trylock(rwlock)	arch_read_trylock(&(rwlock)->raw_lock)
@@ -60,23 +60,23 @@ do {								\
  * regardless of whether CONFIG_SMP or CONFIG_PREEMPT are set. The various
  * methods are defined as nops in the case they are not required.
  */
-#define read_trylock(lock)		__cond_lock(lock, _read_trylock(lock))
-#define write_trylock(lock)		__cond_lock(lock, _write_trylock(lock))
+#define read_trylock(lock)	__cond_lock(lock, _raw_read_trylock(lock))
+#define write_trylock(lock)	__cond_lock(lock, _raw_write_trylock(lock))
 
-#define write_lock(lock)		_write_lock(lock)
-#define read_lock(lock)			_read_lock(lock)
+#define write_lock(lock)	_raw_write_lock(lock)
+#define read_lock(lock)		_raw_read_lock(lock)
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 
 #define read_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		flags = _read_lock_irqsave(lock);	\
+		flags = _raw_read_lock_irqsave(lock);	\
 	} while (0)
 #define write_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		flags = _write_lock_irqsave(lock);	\
+		flags = _raw_write_lock_irqsave(lock);	\
 	} while (0)
 
 #else
@@ -84,38 +84,38 @@ do {								\
 #define read_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_read_lock_irqsave(lock, flags);	\
+		_raw_read_lock_irqsave(lock, flags);	\
 	} while (0)
 #define write_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_write_lock_irqsave(lock, flags);	\
+		_raw_write_lock_irqsave(lock, flags);	\
 	} while (0)
 
 #endif
 
-#define read_lock_irq(lock)		_read_lock_irq(lock)
-#define read_lock_bh(lock)		_read_lock_bh(lock)
-#define write_lock_irq(lock)		_write_lock_irq(lock)
-#define write_lock_bh(lock)		_write_lock_bh(lock)
-#define read_unlock(lock)		_read_unlock(lock)
-#define write_unlock(lock)		_write_unlock(lock)
-#define read_unlock_irq(lock)		_read_unlock_irq(lock)
-#define write_unlock_irq(lock)		_write_unlock_irq(lock)
-
-#define read_unlock_irqrestore(lock, flags)		\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		_read_unlock_irqrestore(lock, flags);	\
+#define read_lock_irq(lock)		_raw_read_lock_irq(lock)
+#define read_lock_bh(lock)		_raw_read_lock_bh(lock)
+#define write_lock_irq(lock)		_raw_write_lock_irq(lock)
+#define write_lock_bh(lock)		_raw_write_lock_bh(lock)
+#define read_unlock(lock)		_raw_read_unlock(lock)
+#define write_unlock(lock)		_raw_write_unlock(lock)
+#define read_unlock_irq(lock)		_raw_read_unlock_irq(lock)
+#define write_unlock_irq(lock)		_raw_write_unlock_irq(lock)
+
+#define read_unlock_irqrestore(lock, flags)			\
+	do {							\
+		typecheck(unsigned long, flags);		\
+		_raw_read_unlock_irqrestore(lock, flags);	\
 	} while (0)
-#define read_unlock_bh(lock)		_read_unlock_bh(lock)
+#define read_unlock_bh(lock)		_raw_read_unlock_bh(lock)
 
 #define write_unlock_irqrestore(lock, flags)		\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_write_unlock_irqrestore(lock, flags);	\
+		_raw_write_unlock_irqrestore(lock, flags);	\
 	} while (0)
-#define write_unlock_bh(lock)		_write_unlock_bh(lock)
+#define write_unlock_bh(lock)		_raw_write_unlock_bh(lock)
 
 #define write_trylock_irqsave(lock, flags) \
 ({ \
Index: linux-2.6-tip/include/linux/rwlock_api_smp.h
===================================================================
--- linux-2.6-tip.orig/include/linux/rwlock_api_smp.h
+++ linux-2.6-tip/include/linux/rwlock_api_smp.h
@@ -15,102 +15,106 @@
  * Released under the General Public License (GPL).
  */
 
-void __lockfunc _read_lock(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _write_lock(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _read_lock_bh(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _write_lock_bh(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _read_lock_irq(rwlock_t *lock)		__acquires(lock);
-void __lockfunc _write_lock_irq(rwlock_t *lock)		__acquires(lock);
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
+void __lockfunc _raw_read_lock(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _raw_write_lock(rwlock_t *lock)		__acquires(lock);
+void __lockfunc _raw_read_lock_bh(rwlock_t *lock)	__acquires(lock);
+void __lockfunc _raw_write_lock_bh(rwlock_t *lock)	__acquires(lock);
+void __lockfunc _raw_read_lock_irq(rwlock_t *lock)	__acquires(lock);
+void __lockfunc _raw_write_lock_irq(rwlock_t *lock)	__acquires(lock);
+unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
-int __lockfunc _read_trylock(rwlock_t *lock);
-int __lockfunc _write_trylock(rwlock_t *lock);
-void __lockfunc _read_unlock(rwlock_t *lock)		__releases(lock);
-void __lockfunc _write_unlock(rwlock_t *lock)		__releases(lock);
-void __lockfunc _read_unlock_bh(rwlock_t *lock)		__releases(lock);
-void __lockfunc _write_unlock_bh(rwlock_t *lock)	__releases(lock);
-void __lockfunc _read_unlock_irq(rwlock_t *lock)	__releases(lock);
-void __lockfunc _write_unlock_irq(rwlock_t *lock)	__releases(lock);
-void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+int __lockfunc _raw_read_trylock(rwlock_t *lock);
+int __lockfunc _raw_write_trylock(rwlock_t *lock);
+void __lockfunc _raw_read_unlock(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_write_unlock(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)	__releases(lock);
+void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)	__releases(lock);
+void __lockfunc
+_raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
-void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+void __lockfunc
+_raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
 #ifdef CONFIG_INLINE_READ_LOCK
-#define _read_lock(lock) __read_lock(lock)
+#define _raw_read_lock(lock) __raw_read_lock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK
-#define _write_lock(lock) __write_lock(lock)
+#define _raw_write_lock(lock) __raw_write_lock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_BH
-#define _read_lock_bh(lock) __read_lock_bh(lock)
+#define _raw_read_lock_bh(lock) __raw_read_lock_bh(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK_BH
-#define _write_lock_bh(lock) __write_lock_bh(lock)
+#define _raw_write_lock_bh(lock) __raw_write_lock_bh(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_IRQ
-#define _read_lock_irq(lock) __read_lock_irq(lock)
+#define _raw_read_lock_irq(lock) __raw_read_lock_irq(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK_IRQ
-#define _write_lock_irq(lock) __write_lock_irq(lock)
+#define _raw_write_lock_irq(lock) __raw_write_lock_irq(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_LOCK_IRQSAVE
-#define _read_lock_irqsave(lock) __read_lock_irqsave(lock)
+#define _raw_read_lock_irqsave(lock) __raw_read_lock_irqsave(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-#define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
+#define _raw_write_lock_irqsave(lock) __raw_write_lock_irqsave(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_TRYLOCK
-#define _read_trylock(lock) __read_trylock(lock)
+#define _raw_read_trylock(lock) __raw_read_trylock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_TRYLOCK
-#define _write_trylock(lock) __write_trylock(lock)
+#define _raw_write_trylock(lock) __raw_write_trylock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK
-#define _read_unlock(lock) __read_unlock(lock)
+#define _raw_read_unlock(lock) __raw_read_unlock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK
-#define _write_unlock(lock) __write_unlock(lock)
+#define _raw_write_unlock(lock) __raw_write_unlock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK_BH
-#define _read_unlock_bh(lock) __read_unlock_bh(lock)
+#define _raw_read_unlock_bh(lock) __raw_read_unlock_bh(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK_BH
-#define _write_unlock_bh(lock) __write_unlock_bh(lock)
+#define _raw_write_unlock_bh(lock) __raw_write_unlock_bh(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK_IRQ
-#define _read_unlock_irq(lock) __read_unlock_irq(lock)
+#define _raw_read_unlock_irq(lock) __raw_read_unlock_irq(lock)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQ
-#define _write_unlock_irq(lock) __write_unlock_irq(lock)
+#define _raw_write_unlock_irq(lock) __raw_write_unlock_irq(lock)
 #endif
 
 #ifdef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
-#define _read_unlock_irqrestore(lock, flags) __read_unlock_irqrestore(lock, flags)
+#define _raw_read_unlock_irqrestore(lock, flags) \
+	__raw_read_unlock_irqrestore(lock, flags)
 #endif
 
 #ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
-#define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
+#define _raw_write_unlock_irqrestore(lock, flags) \
+	__raw_write_unlock_irqrestore(lock, flags)
 #endif
 
-static inline int __read_trylock(rwlock_t *lock)
+static inline int __raw_read_trylock(rwlock_t *lock)
 {
 	preempt_disable();
 	if (do_raw_read_trylock(lock)) {
@@ -121,7 +125,7 @@ static inline int __read_trylock(rwlock_
 	return 0;
 }
 
-static inline int __write_trylock(rwlock_t *lock)
+static inline int __raw_write_trylock(rwlock_t *lock)
 {
 	preempt_disable();
 	if (do_raw_write_trylock(lock)) {
@@ -139,14 +143,14 @@ static inline int __write_trylock(rwlock
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
-static inline void __read_lock(rwlock_t *lock)
+static inline void __raw_read_lock(rwlock_t *lock)
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
-static inline unsigned long __read_lock_irqsave(rwlock_t *lock)
+static inline unsigned long __raw_read_lock_irqsave(rwlock_t *lock)
 {
 	unsigned long flags;
 
@@ -158,7 +162,7 @@ static inline unsigned long __read_lock_
 	return flags;
 }
 
-static inline void __read_lock_irq(rwlock_t *lock)
+static inline void __raw_read_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
@@ -166,7 +170,7 @@ static inline void __read_lock_irq(rwloc
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
-static inline void __read_lock_bh(rwlock_t *lock)
+static inline void __raw_read_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
@@ -174,7 +178,7 @@ static inline void __read_lock_bh(rwlock
 	LOCK_CONTENDED(lock, do_raw_read_trylock, do_raw_read_lock);
 }
 
-static inline unsigned long __write_lock_irqsave(rwlock_t *lock)
+static inline unsigned long __raw_write_lock_irqsave(rwlock_t *lock)
 {
 	unsigned long flags;
 
@@ -186,7 +190,7 @@ static inline unsigned long __write_lock
 	return flags;
 }
 
-static inline void __write_lock_irq(rwlock_t *lock)
+static inline void __raw_write_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
@@ -194,7 +198,7 @@ static inline void __write_lock_irq(rwlo
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
-static inline void __write_lock_bh(rwlock_t *lock)
+static inline void __raw_write_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
@@ -202,7 +206,7 @@ static inline void __write_lock_bh(rwloc
 	LOCK_CONTENDED(lock, do_raw_write_trylock, do_raw_write_lock);
 }
 
-static inline void __write_lock(rwlock_t *lock)
+static inline void __raw_write_lock(rwlock_t *lock)
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -211,21 +215,22 @@ static inline void __write_lock(rwlock_t
 
 #endif /* CONFIG_PREEMPT */
 
-static inline void __write_unlock(rwlock_t *lock)
+static inline void __raw_write_unlock(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
 	preempt_enable();
 }
 
-static inline void __read_unlock(rwlock_t *lock)
+static inline void __raw_read_unlock(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
 	preempt_enable();
 }
 
-static inline void __read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+static inline void
+__raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
@@ -233,7 +238,7 @@ static inline void __read_unlock_irqrest
 	preempt_enable();
 }
 
-static inline void __read_unlock_irq(rwlock_t *lock)
+static inline void __raw_read_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
@@ -241,7 +246,7 @@ static inline void __read_unlock_irq(rwl
 	preempt_enable();
 }
 
-static inline void __read_unlock_bh(rwlock_t *lock)
+static inline void __raw_read_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_read_unlock(lock);
@@ -249,7 +254,7 @@ static inline void __read_unlock_bh(rwlo
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 
-static inline void __write_unlock_irqrestore(rwlock_t *lock,
+static inline void __raw_write_unlock_irqrestore(rwlock_t *lock,
 					     unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
@@ -258,7 +263,7 @@ static inline void __write_unlock_irqres
 	preempt_enable();
 }
 
-static inline void __write_unlock_irq(rwlock_t *lock)
+static inline void __raw_write_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
@@ -266,7 +271,7 @@ static inline void __write_unlock_irq(rw
 	preempt_enable();
 }
 
-static inline void __write_unlock_bh(rwlock_t *lock)
+static inline void __raw_write_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_write_unlock(lock);
Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -161,20 +161,22 @@ static inline void do_raw_spin_unlock(ra
  * various methods are defined as nops in the case they are not
  * required.
  */
-#define raw_spin_trylock(lock)		__cond_lock(lock, _spin_trylock(lock))
+#define raw_spin_trylock(lock)	__cond_lock(lock, _raw_spin_trylock(lock))
 
-#define raw_spin_lock(lock)		_spin_lock(lock)
+#define raw_spin_lock(lock)	_raw_spin_lock(lock)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define raw_spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
+# define raw_spin_lock_nested(lock, subclass) \
+	_raw_spin_lock_nested(lock, subclass)
+
 # define raw_spin_lock_nest_lock(lock, nest_lock)			\
 	 do {								\
 		 typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
-		 _spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
+		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
-# define raw_spin_lock_nested(lock, subclass)		_spin_lock(lock)
-# define raw_spin_lock_nest_lock(lock, nest_lock)	_spin_lock(lock)
+# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
+# define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
 #endif
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
@@ -182,20 +184,20 @@ static inline void do_raw_spin_unlock(ra
 #define raw_spin_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		flags = _spin_lock_irqsave(lock);	\
+		flags = _raw_spin_lock_irqsave(lock);	\
 	} while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define raw_spin_lock_irqsave_nested(lock, flags, subclass)		\
 	do {								\
 		typecheck(unsigned long, flags);			\
-		flags = _spin_lock_irqsave_nested(lock, subclass);	\
+		flags = _raw_spin_lock_irqsave_nested(lock, subclass);	\
 	} while (0)
 #else
 #define raw_spin_lock_irqsave_nested(lock, flags, subclass)		\
 	do {								\
 		typecheck(unsigned long, flags);			\
-		flags = _spin_lock_irqsave(lock);			\
+		flags = _raw_spin_lock_irqsave(lock);			\
 	} while (0)
 #endif
 
@@ -204,7 +206,7 @@ static inline void do_raw_spin_unlock(ra
 #define raw_spin_lock_irqsave(lock, flags)		\
 	do {						\
 		typecheck(unsigned long, flags);	\
-		_spin_lock_irqsave(lock, flags);	\
+		_raw_spin_lock_irqsave(lock, flags);	\
 	} while (0)
 
 #define raw_spin_lock_irqsave_nested(lock, flags, subclass)	\
@@ -212,19 +214,20 @@ static inline void do_raw_spin_unlock(ra
 
 #endif
 
-#define raw_spin_lock_irq(lock)	_spin_lock_irq(lock)
-#define raw_spin_lock_bh(lock)		_spin_lock_bh(lock)
-#define raw_spin_unlock(lock)		_spin_unlock(lock)
-#define raw_spin_unlock_irq(lock)	_spin_unlock_irq(lock)
+#define raw_spin_lock_irq(lock)		_raw_spin_lock_irq(lock)
+#define raw_spin_lock_bh(lock)		_raw_spin_lock_bh(lock)
+#define raw_spin_unlock(lock)		_raw_spin_unlock(lock)
+#define raw_spin_unlock_irq(lock)	_raw_spin_unlock_irq(lock)
 
 #define raw_spin_unlock_irqrestore(lock, flags)		\
 	do {							\
 		typecheck(unsigned long, flags);		\
-		_spin_unlock_irqrestore(lock, flags);	\
+		_raw_spin_unlock_irqrestore(lock, flags);	\
 	} while (0)
-#define raw_spin_unlock_bh(lock)	_spin_unlock_bh(lock)
+#define raw_spin_unlock_bh(lock)	_raw_spin_unlock_bh(lock)
 
-#define raw_spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
+#define raw_spin_trylock_bh(lock) \
+	__cond_lock(lock, _raw_spin_trylock_bh(lock))
 
 #define raw_spin_trylock_irq(lock) \
 ({ \
Index: linux-2.6-tip/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6-tip/include/linux/spinlock_api_smp.h
@@ -19,70 +19,71 @@ int in_lock_functions(unsigned long addr
 
 #define assert_raw_spin_locked(x)	BUG_ON(!raw_spin_is_locked(x))
 
-void __lockfunc _spin_lock(raw_spinlock_t *lock)	__acquires(lock);
-void __lockfunc _spin_lock_nested(raw_spinlock_t *lock, int subclass)
-							__acquires(lock);
+void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)		__acquires(lock);
+void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
+								__acquires(lock);
 void __lockfunc
-_spin_lock_nest_lock(raw_spinlock_t *lock, struct lockdep_map *map)
-							__acquires(lock);
-void __lockfunc _spin_lock_bh(raw_spinlock_t *lock)	__acquires(lock);
-void __lockfunc _spin_lock_irq(raw_spinlock_t *lock)	__acquires(lock);
+_raw_spin_lock_nest_lock(raw_spinlock_t *lock, struct lockdep_map *map)
+								__acquires(lock);
+void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)		__acquires(lock);
+void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
+								__acquires(lock);
 
-unsigned long __lockfunc _spin_lock_irqsave(raw_spinlock_t *lock)
-							__acquires(lock);
+unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
+								__acquires(lock);
 unsigned long __lockfunc
-_spin_lock_irqsave_nested(raw_spinlock_t *lock, int subclass)
-							__acquires(lock);
-int __lockfunc _spin_trylock(raw_spinlock_t *lock);
-int __lockfunc _spin_trylock_bh(raw_spinlock_t *lock);
-void __lockfunc _spin_unlock(raw_spinlock_t *lock)	__releases(lock);
-void __lockfunc _spin_unlock_bh(raw_spinlock_t *lock)	__releases(lock);
-void __lockfunc _spin_unlock_irq(raw_spinlock_t *lock)	__releases(lock);
+_raw_spin_lock_irqsave_nested(raw_spinlock_t *lock, int subclass)
+								__acquires(lock);
+int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock);
+int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock);
+void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)		__releases(lock);
+void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)	__releases(lock);
+void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)	__releases(lock);
 void __lockfunc
-_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
-							__releases(lock);
+_raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
+								__releases(lock);
 
 #ifdef CONFIG_INLINE_SPIN_LOCK
-#define _spin_lock(lock) __spin_lock(lock)
+#define _raw_spin_lock(lock) __raw_spin_lock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_LOCK_BH
-#define _spin_lock_bh(lock) __spin_lock_bh(lock)
+#define _raw_spin_lock_bh(lock) __raw_spin_lock_bh(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_LOCK_IRQ
-#define _spin_lock_irq(lock) __spin_lock_irq(lock)
+#define _raw_spin_lock_irq(lock) __raw_spin_lock_irq(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
-#define _spin_lock_irqsave(lock) __spin_lock_irqsave(lock)
+#define _raw_spin_lock_irqsave(lock) __raw_spin_lock_irqsave(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_TRYLOCK
-#define _spin_trylock(lock) __spin_trylock(lock)
+#define _raw_spin_trylock(lock) __raw_spin_trylock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_TRYLOCK_BH
-#define _spin_trylock_bh(lock) __spin_trylock_bh(lock)
+#define _raw_spin_trylock_bh(lock) __raw_spin_trylock_bh(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK
-#define _spin_unlock(lock) __spin_unlock(lock)
+#define _raw_spin_unlock(lock) __raw_spin_unlock(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_BH
-#define _spin_unlock_bh(lock) __spin_unlock_bh(lock)
+#define _raw_spin_unlock_bh(lock) __raw_spin_unlock_bh(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-#define _spin_unlock_irq(lock) __spin_unlock_irq(lock)
+#define _raw_spin_unlock_irq(lock) __raw_spin_unlock_irq(lock)
 #endif
 
 #ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-#define _spin_unlock_irqrestore(lock, flags) __spin_unlock_irqrestore(lock, flags)
+#define _raw_spin_unlock_irqrestore(lock, flags) __raw_spin_unlock_irqrestore(lock, flags)
 #endif
 
-static inline int __spin_trylock(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
 	preempt_disable();
 	if (do_raw_spin_trylock(lock)) {
@@ -100,7 +101,7 @@ static inline int __spin_trylock(raw_spi
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
-static inline unsigned long __spin_lock_irqsave(raw_spinlock_t *lock)
+static inline unsigned long __raw_spin_lock_irqsave(raw_spinlock_t *lock)
 {
 	unsigned long flags;
 
@@ -120,7 +121,7 @@ static inline unsigned long __spin_lock_
 	return flags;
 }
 
-static inline void __spin_lock_irq(raw_spinlock_t *lock)
+static inline void __raw_spin_lock_irq(raw_spinlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
@@ -128,7 +129,7 @@ static inline void __spin_lock_irq(raw_s
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
-static inline void __spin_lock_bh(raw_spinlock_t *lock)
+static inline void __raw_spin_lock_bh(raw_spinlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
@@ -136,7 +137,7 @@ static inline void __spin_lock_bh(raw_sp
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
 
-static inline void __spin_lock(raw_spinlock_t *lock)
+static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -145,14 +146,14 @@ static inline void __spin_lock(raw_spinl
 
 #endif /* CONFIG_PREEMPT */
 
-static inline void __spin_unlock(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
 	preempt_enable();
 }
 
-static inline void __spin_unlock_irqrestore(raw_spinlock_t *lock,
+static inline void __raw_spin_unlock_irqrestore(raw_spinlock_t *lock,
 					    unsigned long flags)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
@@ -161,7 +162,7 @@ static inline void __spin_unlock_irqrest
 	preempt_enable();
 }
 
-static inline void __spin_unlock_irq(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock_irq(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
@@ -169,7 +170,7 @@ static inline void __spin_unlock_irq(raw
 	preempt_enable();
 }
 
-static inline void __spin_unlock_bh(raw_spinlock_t *lock)
+static inline void __raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	do_raw_spin_unlock(lock);
@@ -177,7 +178,7 @@ static inline void __spin_unlock_bh(raw_
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 
-static inline int __spin_trylock_bh(raw_spinlock_t *lock)
+static inline int __raw_spin_trylock_bh(raw_spinlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
Index: linux-2.6-tip/include/linux/spinlock_api_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_api_up.h
+++ linux-2.6-tip/include/linux/spinlock_api_up.h
@@ -40,7 +40,8 @@
   do { preempt_enable(); __release(lock); (void)(lock); } while (0)
 
 #define __UNLOCK_BH(lock) \
-  do { preempt_enable_no_resched(); local_bh_enable(); __release(lock); (void)(lock); } while (0)
+  do { preempt_enable_no_resched(); local_bh_enable(); \
+	  __release(lock); (void)(lock); } while (0)
 
 #define __UNLOCK_IRQ(lock) \
   do { local_irq_enable(); __UNLOCK(lock); } while (0)
@@ -48,34 +49,37 @@
 #define __UNLOCK_IRQRESTORE(lock, flags) \
   do { local_irq_restore(flags); __UNLOCK(lock); } while (0)
 
-#define _spin_lock(lock)			__LOCK(lock)
-#define _spin_lock_nested(lock, subclass)	__LOCK(lock)
-#define _read_lock(lock)			__LOCK(lock)
-#define _write_lock(lock)			__LOCK(lock)
-#define _spin_lock_bh(lock)			__LOCK_BH(lock)
-#define _read_lock_bh(lock)			__LOCK_BH(lock)
-#define _write_lock_bh(lock)			__LOCK_BH(lock)
-#define _spin_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _read_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _write_lock_irq(lock)			__LOCK_IRQ(lock)
-#define _spin_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(lock, flags)
-#define _read_lock_irqsave(lock, flags)		__LOCK_IRQSAVE(lock, flags)
-#define _write_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
-#define _spin_trylock(lock)			({ __LOCK(lock); 1; })
-#define _read_trylock(lock)			({ __LOCK(lock); 1; })
-#define _write_trylock(lock)			({ __LOCK(lock); 1; })
-#define _spin_trylock_bh(lock)			({ __LOCK_BH(lock); 1; })
-#define _spin_unlock(lock)			__UNLOCK(lock)
-#define _read_unlock(lock)			__UNLOCK(lock)
-#define _write_unlock(lock)			__UNLOCK(lock)
-#define _spin_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _write_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _read_unlock_bh(lock)			__UNLOCK_BH(lock)
-#define _spin_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _read_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _write_unlock_irq(lock)			__UNLOCK_IRQ(lock)
-#define _spin_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
-#define _read_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
-#define _write_unlock_irqrestore(lock, flags)	__UNLOCK_IRQRESTORE(lock, flags)
+#define _raw_spin_lock(lock)			__LOCK(lock)
+#define _raw_spin_lock_nested(lock, subclass)	__LOCK(lock)
+#define _raw_read_lock(lock)			__LOCK(lock)
+#define _raw_write_lock(lock)			__LOCK(lock)
+#define _raw_spin_lock_bh(lock)			__LOCK_BH(lock)
+#define _raw_read_lock_bh(lock)			__LOCK_BH(lock)
+#define _raw_write_lock_bh(lock)		__LOCK_BH(lock)
+#define _raw_spin_lock_irq(lock)		__LOCK_IRQ(lock)
+#define _raw_read_lock_irq(lock)		__LOCK_IRQ(lock)
+#define _raw_write_lock_irq(lock)		__LOCK_IRQ(lock)
+#define _raw_spin_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
+#define _raw_read_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
+#define _raw_write_lock_irqsave(lock, flags)	__LOCK_IRQSAVE(lock, flags)
+#define _raw_spin_trylock(lock)			({ __LOCK(lock); 1; })
+#define _raw_read_trylock(lock)			({ __LOCK(lock); 1; })
+#define _raw_write_trylock(lock)			({ __LOCK(lock); 1; })
+#define _raw_spin_trylock_bh(lock)		({ __LOCK_BH(lock); 1; })
+#define _raw_spin_unlock(lock)			__UNLOCK(lock)
+#define _raw_read_unlock(lock)			__UNLOCK(lock)
+#define _raw_write_unlock(lock)			__UNLOCK(lock)
+#define _raw_spin_unlock_bh(lock)		__UNLOCK_BH(lock)
+#define _raw_write_unlock_bh(lock)		__UNLOCK_BH(lock)
+#define _raw_read_unlock_bh(lock)		__UNLOCK_BH(lock)
+#define _raw_spin_unlock_irq(lock)		__UNLOCK_IRQ(lock)
+#define _raw_read_unlock_irq(lock)		__UNLOCK_IRQ(lock)
+#define _raw_write_unlock_irq(lock)		__UNLOCK_IRQ(lock)
+#define _raw_spin_unlock_irqrestore(lock, flags) \
+					__UNLOCK_IRQRESTORE(lock, flags)
+#define _raw_read_unlock_irqrestore(lock, flags) \
+					__UNLOCK_IRQRESTORE(lock, flags)
+#define _raw_write_unlock_irqrestore(lock, flags) \
+					__UNLOCK_IRQRESTORE(lock, flags)
 
 #endif /* __LINUX_SPINLOCK_API_UP_H */
Index: linux-2.6-tip/kernel/spinlock.c
===================================================================
--- linux-2.6-tip.orig/kernel/spinlock.c
+++ linux-2.6-tip/kernel/spinlock.c
@@ -44,7 +44,7 @@
  * towards that other CPU that it should break the lock ASAP.
  */
 #define BUILD_LOCK_OPS(op, locktype)					\
-void __lockfunc __##op##_lock(locktype##_t *lock)			\
+void __lockfunc __raw_##op##_lock(locktype##_t *lock)			\
 {									\
 	for (;;) {							\
 		preempt_disable();					\
@@ -60,7 +60,7 @@ void __lockfunc __##op##_lock(locktype##
 	(lock)->break_lock = 0;						\
 }									\
 									\
-unsigned long __lockfunc __##op##_lock_irqsave(locktype##_t *lock)	\
+unsigned long __lockfunc __raw_##op##_lock_irqsave(locktype##_t *lock)	\
 {									\
 	unsigned long flags;						\
 									\
@@ -81,12 +81,12 @@ unsigned long __lockfunc __##op##_lock_i
 	return flags;							\
 }									\
 									\
-void __lockfunc __##op##_lock_irq(locktype##_t *lock)			\
+void __lockfunc __raw_##op##_lock_irq(locktype##_t *lock)		\
 {									\
-	_##op##_lock_irqsave(lock);					\
+	_raw_##op##_lock_irqsave(lock);					\
 }									\
 									\
-void __lockfunc __##op##_lock_bh(locktype##_t *lock)			\
+void __lockfunc __raw_##op##_lock_bh(locktype##_t *lock)		\
 {									\
 	unsigned long flags;						\
 									\
@@ -95,7 +95,7 @@ void __lockfunc __##op##_lock_bh(locktyp
 	/* irq-disabling. We use the generic preemption-aware	*/	\
 	/* function:						*/	\
 	/**/								\
-	flags = _##op##_lock_irqsave(lock);				\
+	flags = _raw_##op##_lock_irqsave(lock);				\
 	local_bh_disable();						\
 	local_irq_restore(flags);					\
 }									\
@@ -116,240 +116,240 @@ BUILD_LOCK_OPS(write, rwlock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK
-int __lockfunc _spin_trylock(raw_spinlock_t *lock)
+int __lockfunc _raw_spin_trylock(raw_spinlock_t *lock)
 {
-	return __spin_trylock(lock);
+	return __raw_spin_trylock(lock);
 }
-EXPORT_SYMBOL(_spin_trylock);
+EXPORT_SYMBOL(_raw_spin_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
-int __lockfunc _spin_trylock_bh(raw_spinlock_t *lock)
+int __lockfunc _raw_spin_trylock_bh(raw_spinlock_t *lock)
 {
-	return __spin_trylock_bh(lock);
+	return __raw_spin_trylock_bh(lock);
 }
-EXPORT_SYMBOL(_spin_trylock_bh);
+EXPORT_SYMBOL(_raw_spin_trylock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK
-void __lockfunc _spin_lock(raw_spinlock_t *lock)
+void __lockfunc _raw_spin_lock(raw_spinlock_t *lock)
 {
-	__spin_lock(lock);
+	__raw_spin_lock(lock);
 }
-EXPORT_SYMBOL(_spin_lock);
+EXPORT_SYMBOL(_raw_spin_lock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
-unsigned long __lockfunc _spin_lock_irqsave(raw_spinlock_t *lock)
+unsigned long __lockfunc _raw_spin_lock_irqsave(raw_spinlock_t *lock)
 {
-	return __spin_lock_irqsave(lock);
+	return __raw_spin_lock_irqsave(lock);
 }
-EXPORT_SYMBOL(_spin_lock_irqsave);
+EXPORT_SYMBOL(_raw_spin_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
-void __lockfunc _spin_lock_irq(raw_spinlock_t *lock)
+void __lockfunc _raw_spin_lock_irq(raw_spinlock_t *lock)
 {
-	__spin_lock_irq(lock);
+	__raw_spin_lock_irq(lock);
 }
-EXPORT_SYMBOL(_spin_lock_irq);
+EXPORT_SYMBOL(_raw_spin_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_BH
-void __lockfunc _spin_lock_bh(raw_spinlock_t *lock)
+void __lockfunc _raw_spin_lock_bh(raw_spinlock_t *lock)
 {
-	__spin_lock_bh(lock);
+	__raw_spin_lock_bh(lock);
 }
-EXPORT_SYMBOL(_spin_lock_bh);
+EXPORT_SYMBOL(_raw_spin_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK
-void __lockfunc _spin_unlock(raw_spinlock_t *lock)
+void __lockfunc _raw_spin_unlock(raw_spinlock_t *lock)
 {
-	__spin_unlock(lock);
+	__raw_spin_unlock(lock);
 }
-EXPORT_SYMBOL(_spin_unlock);
+EXPORT_SYMBOL(_raw_spin_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-void __lockfunc _spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
+void __lockfunc _raw_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 {
-	__spin_unlock_irqrestore(lock, flags);
+	__raw_spin_unlock_irqrestore(lock, flags);
 }
-EXPORT_SYMBOL(_spin_unlock_irqrestore);
+EXPORT_SYMBOL(_raw_spin_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-void __lockfunc _spin_unlock_irq(raw_spinlock_t *lock)
+void __lockfunc _raw_spin_unlock_irq(raw_spinlock_t *lock)
 {
-	__spin_unlock_irq(lock);
+	__raw_spin_unlock_irq(lock);
 }
-EXPORT_SYMBOL(_spin_unlock_irq);
+EXPORT_SYMBOL(_raw_spin_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
-void __lockfunc _spin_unlock_bh(raw_spinlock_t *lock)
+void __lockfunc _raw_spin_unlock_bh(raw_spinlock_t *lock)
 {
-	__spin_unlock_bh(lock);
+	__raw_spin_unlock_bh(lock);
 }
-EXPORT_SYMBOL(_spin_unlock_bh);
+EXPORT_SYMBOL(_raw_spin_unlock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_READ_TRYLOCK
-int __lockfunc _read_trylock(rwlock_t *lock)
+int __lockfunc _raw_read_trylock(rwlock_t *lock)
 {
-	return __read_trylock(lock);
+	return __raw_read_trylock(lock);
 }
-EXPORT_SYMBOL(_read_trylock);
+EXPORT_SYMBOL(_raw_read_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK
-void __lockfunc _read_lock(rwlock_t *lock)
+void __lockfunc _raw_read_lock(rwlock_t *lock)
 {
-	__read_lock(lock);
+	__raw_read_lock(lock);
 }
-EXPORT_SYMBOL(_read_lock);
+EXPORT_SYMBOL(_raw_read_lock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
+unsigned long __lockfunc _raw_read_lock_irqsave(rwlock_t *lock)
 {
-	return __read_lock_irqsave(lock);
+	return __raw_read_lock_irqsave(lock);
 }
-EXPORT_SYMBOL(_read_lock_irqsave);
+EXPORT_SYMBOL(_raw_read_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_IRQ
-void __lockfunc _read_lock_irq(rwlock_t *lock)
+void __lockfunc _raw_read_lock_irq(rwlock_t *lock)
 {
-	__read_lock_irq(lock);
+	__raw_read_lock_irq(lock);
 }
-EXPORT_SYMBOL(_read_lock_irq);
+EXPORT_SYMBOL(_raw_read_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_READ_LOCK_BH
-void __lockfunc _read_lock_bh(rwlock_t *lock)
+void __lockfunc _raw_read_lock_bh(rwlock_t *lock)
 {
-	__read_lock_bh(lock);
+	__raw_read_lock_bh(lock);
 }
-EXPORT_SYMBOL(_read_lock_bh);
+EXPORT_SYMBOL(_raw_read_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK
-void __lockfunc _read_unlock(rwlock_t *lock)
+void __lockfunc _raw_read_unlock(rwlock_t *lock)
 {
-	__read_unlock(lock);
+	__raw_read_unlock(lock);
 }
-EXPORT_SYMBOL(_read_unlock);
+EXPORT_SYMBOL(_raw_read_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
-void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+void __lockfunc _raw_read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	__read_unlock_irqrestore(lock, flags);
+	__raw_read_unlock_irqrestore(lock, flags);
 }
-EXPORT_SYMBOL(_read_unlock_irqrestore);
+EXPORT_SYMBOL(_raw_read_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_IRQ
-void __lockfunc _read_unlock_irq(rwlock_t *lock)
+void __lockfunc _raw_read_unlock_irq(rwlock_t *lock)
 {
-	__read_unlock_irq(lock);
+	__raw_read_unlock_irq(lock);
 }
-EXPORT_SYMBOL(_read_unlock_irq);
+EXPORT_SYMBOL(_raw_read_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_READ_UNLOCK_BH
-void __lockfunc _read_unlock_bh(rwlock_t *lock)
+void __lockfunc _raw_read_unlock_bh(rwlock_t *lock)
 {
-	__read_unlock_bh(lock);
+	__raw_read_unlock_bh(lock);
 }
-EXPORT_SYMBOL(_read_unlock_bh);
+EXPORT_SYMBOL(_raw_read_unlock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_TRYLOCK
-int __lockfunc _write_trylock(rwlock_t *lock)
+int __lockfunc _raw_write_trylock(rwlock_t *lock)
 {
-	return __write_trylock(lock);
+	return __raw_write_trylock(lock);
 }
-EXPORT_SYMBOL(_write_trylock);
+EXPORT_SYMBOL(_raw_write_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK
-void __lockfunc _write_lock(rwlock_t *lock)
+void __lockfunc _raw_write_lock(rwlock_t *lock)
 {
-	__write_lock(lock);
+	__raw_write_lock(lock);
 }
-EXPORT_SYMBOL(_write_lock);
+EXPORT_SYMBOL(_raw_write_lock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+unsigned long __lockfunc _raw_write_lock_irqsave(rwlock_t *lock)
 {
-	return __write_lock_irqsave(lock);
+	return __raw_write_lock_irqsave(lock);
 }
-EXPORT_SYMBOL(_write_lock_irqsave);
+EXPORT_SYMBOL(_raw_write_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
-void __lockfunc _write_lock_irq(rwlock_t *lock)
+void __lockfunc _raw_write_lock_irq(rwlock_t *lock)
 {
-	__write_lock_irq(lock);
+	__raw_write_lock_irq(lock);
 }
-EXPORT_SYMBOL(_write_lock_irq);
+EXPORT_SYMBOL(_raw_write_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_LOCK_BH
-void __lockfunc _write_lock_bh(rwlock_t *lock)
+void __lockfunc _raw_write_lock_bh(rwlock_t *lock)
 {
-	__write_lock_bh(lock);
+	__raw_write_lock_bh(lock);
 }
-EXPORT_SYMBOL(_write_lock_bh);
+EXPORT_SYMBOL(_raw_write_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK
-void __lockfunc _write_unlock(rwlock_t *lock)
+void __lockfunc _raw_write_unlock(rwlock_t *lock)
 {
-	__write_unlock(lock);
+	__raw_write_unlock(lock);
 }
-EXPORT_SYMBOL(_write_unlock);
+EXPORT_SYMBOL(_raw_write_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
-void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+void __lockfunc _raw_write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	__write_unlock_irqrestore(lock, flags);
+	__raw_write_unlock_irqrestore(lock, flags);
 }
-EXPORT_SYMBOL(_write_unlock_irqrestore);
+EXPORT_SYMBOL(_raw_write_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQ
-void __lockfunc _write_unlock_irq(rwlock_t *lock)
+void __lockfunc _raw_write_unlock_irq(rwlock_t *lock)
 {
-	__write_unlock_irq(lock);
+	__raw_write_unlock_irq(lock);
 }
-EXPORT_SYMBOL(_write_unlock_irq);
+EXPORT_SYMBOL(_raw_write_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_WRITE_UNLOCK_BH
-void __lockfunc _write_unlock_bh(rwlock_t *lock)
+void __lockfunc _raw_write_unlock_bh(rwlock_t *lock)
 {
-	__write_unlock_bh(lock);
+	__raw_write_unlock_bh(lock);
 }
-EXPORT_SYMBOL(_write_unlock_bh);
+EXPORT_SYMBOL(_raw_write_unlock_bh);
 #endif
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-void __lockfunc _spin_lock_nested(raw_spinlock_t *lock, int subclass)
+void __lockfunc _raw_spin_lock_nested(raw_spinlock_t *lock, int subclass)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
-EXPORT_SYMBOL(_spin_lock_nested);
+EXPORT_SYMBOL(_raw_spin_lock_nested);
 
-unsigned long __lockfunc _spin_lock_irqsave_nested(raw_spinlock_t *lock,
+unsigned long __lockfunc _raw_spin_lock_irqsave_nested(raw_spinlock_t *lock,
 						   int subclass)
 {
 	unsigned long flags;
@@ -361,16 +361,16 @@ unsigned long __lockfunc _spin_lock_irqs
 				do_raw_spin_lock_flags, &flags);
 	return flags;
 }
-EXPORT_SYMBOL(_spin_lock_irqsave_nested);
+EXPORT_SYMBOL(_raw_spin_lock_irqsave_nested);
 
-void __lockfunc _spin_lock_nest_lock(raw_spinlock_t *lock,
+void __lockfunc _raw_spin_lock_nest_lock(raw_spinlock_t *lock,
 				     struct lockdep_map *nest_lock)
 {
 	preempt_disable();
 	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
 	LOCK_CONTENDED(lock, do_raw_spin_trylock, do_raw_spin_lock);
 }
-EXPORT_SYMBOL(_spin_lock_nest_lock);
+EXPORT_SYMBOL(_raw_spin_lock_nest_lock);
 
 #endif
 


