Return-Path: <linux-kernel-owner+w=401wt.eu-S934169AbZLFSDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934169AbZLFSDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934136AbZLFSDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:03:34 -0500
Received: from www.tglx.de ([62.245.132.106]:33136 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934028AbZLFSCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:55 -0500
Message-Id: <20091206111957.651783909@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:02:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 09/23] locking: Implement new raw_spinlock
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline; filename=locking-implement-raw-lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the raw_spin name space is freed up, we can implement
raw_spinlock and the related functions which are used to annotate the
locks which are not converted to sleeping spinlocks in preempt-rt.

A side effect is that only such locks can be used with the low level
lock fsunctions which circumvent lockdep.

For !rt spin_* functions are mapped to the raw_spin* implementations.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/spinlock.h         |  260 +++++++++++++++++++++++++++++----------
 include/linux/spinlock_api_smp.h |   51 ++++---
 include/linux/spinlock_api_up.h  |    2 
 include/linux/spinlock_types.h   |   49 +++++--
 kernel/mutex-debug.h             |   12 -
 kernel/sched.c                   |    2 
 kernel/spinlock.c                |   34 ++---
 lib/spinlock_debug.c             |   24 +--
 8 files changed, 298 insertions(+), 136 deletions(-)

Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -80,7 +80,7 @@
 #include <linux/spinlock_types.h>
 
 /*
- * Pull the __raw*() functions/declarations (UP-nondebug doesnt need them):
+ * Pull the arch_spin*() functions/declarations (UP-nondebug doesnt need them):
  */
 #ifdef CONFIG_SMP
 # include <asm/spinlock.h>
@@ -89,30 +89,30 @@
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
-  extern void __spin_lock_init(spinlock_t *lock, const char *name,
-			       struct lock_class_key *key);
-# define spin_lock_init(lock)					\
+  extern void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
+				   struct lock_class_key *key);
+# define raw_spin_lock_init(lock)				\
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	__spin_lock_init((lock), #lock, &__key);		\
+	__raw_spin_lock_init((lock), #lock, &__key);		\
 } while (0)
 
 #else
-# define spin_lock_init(lock)					\
-	do { *(lock) = __SPIN_LOCK_UNLOCKED(lock); } while (0)
+# define raw_spin_lock_init(lock)				\
+	do { *(lock) = __RAW_SPIN_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
-#define spin_is_locked(lock)	arch_spin_is_locked(&(lock)->raw_lock)
+#define raw_spin_is_locked(lock)	arch_spin_is_locked(&(lock)->raw_lock)
 
 #ifdef CONFIG_GENERIC_LOCKBREAK
-#define spin_is_contended(lock) ((lock)->break_lock)
+#define raw_spin_is_contended(lock) ((lock)->break_lock)
 #else
 
 #ifdef arch_spin_is_contended
-#define spin_is_contended(lock)	arch_spin_is_contended(&(lock)->raw_lock)
+#define raw_spin_is_contended(lock)	arch_spin_is_contended(&(lock)->raw_lock)
 #else
-#define spin_is_contended(lock)	(((void)(lock), 0))
+#define raw_spin_is_contended(lock)	(((void)(lock), 0))
 #endif /*arch_spin_is_contended*/
 #endif
 
@@ -122,22 +122,37 @@ static inline void smp_mb__after_lock(vo
 #endif
 
 /**
- * spin_unlock_wait - wait until the spinlock gets unlocked
+ * raw_spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
  */
-#define spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
+#define raw_spin_unlock_wait(lock)	arch_spin_unlock_wait(&(lock)->raw_lock)
 
 #ifdef CONFIG_DEBUG_SPINLOCK
- extern void _raw_spin_lock(spinlock_t *lock);
+ extern void _raw_spin_lock(raw_spinlock_t *lock);
 #define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
- extern int _raw_spin_trylock(spinlock_t *lock);
- extern void _raw_spin_unlock(spinlock_t *lock);
+ extern int _raw_spin_trylock(raw_spinlock_t *lock);
+ extern void _raw_spin_unlock(raw_spinlock_t *lock);
 #else
-# define _raw_spin_lock(lock)		arch_spin_lock(&(lock)->raw_lock)
-# define _raw_spin_lock_flags(lock, flags) \
-		arch_spin_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_spin_trylock(lock)	arch_spin_trylock(&(lock)->raw_lock)
-# define _raw_spin_unlock(lock)		arch_spin_unlock(&(lock)->raw_lock)
+static inline void _raw_spin_lock(raw_spinlock_t *lock)
+{
+	arch_spin_lock(&lock->raw_lock);
+}
+
+static inline void
+_raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long *flags)
+{
+	arch_spin_lock_flags(&lock->raw_lock, *flags);
+}
+
+static inline int _raw_spin_trylock(raw_spinlock_t *lock)
+{
+	return arch_spin_trylock(&(lock)->raw_lock);
+}
+
+static inline void _raw_spin_unlock(raw_spinlock_t *lock)
+{
+	arch_spin_unlock(&lock->raw_lock);
+}
 #endif
 
 /*
@@ -146,38 +161,38 @@ static inline void smp_mb__after_lock(vo
  * various methods are defined as nops in the case they are not
  * required.
  */
-#define spin_trylock(lock)		__cond_lock(lock, _spin_trylock(lock))
+#define raw_spin_trylock(lock)		__cond_lock(lock, _spin_trylock(lock))
 
-#define spin_lock(lock)			_spin_lock(lock)
+#define raw_spin_lock(lock)		_spin_lock(lock)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
-# define spin_lock_nest_lock(lock, nest_lock)				\
+# define raw_spin_lock_nested(lock, subclass) _spin_lock_nested(lock, subclass)
+# define raw_spin_lock_nest_lock(lock, nest_lock)			\
 	 do {								\
 		 typecheck(struct lockdep_map *, &(nest_lock)->dep_map);\
 		 _spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
 	 } while (0)
 #else
-# define spin_lock_nested(lock, subclass) _spin_lock(lock)
-# define spin_lock_nest_lock(lock, nest_lock) _spin_lock(lock)
+# define raw_spin_lock_nested(lock, subclass)		_spin_lock(lock)
+# define raw_spin_lock_nest_lock(lock, nest_lock)	_spin_lock(lock)
 #endif
 
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 
-#define spin_lock_irqsave(lock, flags)			\
+#define raw_spin_lock_irqsave(lock, flags)			\
 	do {						\
 		typecheck(unsigned long, flags);	\
 		flags = _spin_lock_irqsave(lock);	\
 	} while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-#define spin_lock_irqsave_nested(lock, flags, subclass)			\
+#define raw_spin_lock_irqsave_nested(lock, flags, subclass)		\
 	do {								\
 		typecheck(unsigned long, flags);			\
 		flags = _spin_lock_irqsave_nested(lock, subclass);	\
 	} while (0)
 #else
-#define spin_lock_irqsave_nested(lock, flags, subclass)			\
+#define raw_spin_lock_irqsave_nested(lock, flags, subclass)		\
 	do {								\
 		typecheck(unsigned long, flags);			\
 		flags = _spin_lock_irqsave(lock);			\
@@ -186,45 +201,178 @@ static inline void smp_mb__after_lock(vo
 
 #else
 
-#define spin_lock_irqsave(lock, flags)			\
+#define raw_spin_lock_irqsave(lock, flags)		\
 	do {						\
 		typecheck(unsigned long, flags);	\
 		_spin_lock_irqsave(lock, flags);	\
 	} while (0)
 
-#define spin_lock_irqsave_nested(lock, flags, subclass)	\
-	spin_lock_irqsave(lock, flags)
+#define raw_spin_lock_irqsave_nested(lock, flags, subclass)	\
+	raw_spin_lock_irqsave(lock, flags)
 
 #endif
 
-#define spin_lock_irq(lock)		_spin_lock_irq(lock)
-#define spin_lock_bh(lock)		_spin_lock_bh(lock)
-#define spin_unlock(lock)		_spin_unlock(lock)
-#define spin_unlock_irq(lock)		_spin_unlock_irq(lock)
-
-#define spin_unlock_irqrestore(lock, flags)		\
-	do {						\
-		typecheck(unsigned long, flags);	\
+#define raw_spin_lock_irq(lock)	_spin_lock_irq(lock)
+#define raw_spin_lock_bh(lock)		_spin_lock_bh(lock)
+#define raw_spin_unlock(lock)		_spin_unlock(lock)
+#define raw_spin_unlock_irq(lock)	_spin_unlock_irq(lock)
+
+#define raw_spin_unlock_irqrestore(lock, flags)		\
+	do {							\
+		typecheck(unsigned long, flags);		\
 		_spin_unlock_irqrestore(lock, flags);	\
 	} while (0)
-#define spin_unlock_bh(lock)		_spin_unlock_bh(lock)
+#define raw_spin_unlock_bh(lock)	_spin_unlock_bh(lock)
 
-#define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
+#define raw_spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
 
-#define spin_trylock_irq(lock) \
+#define raw_spin_trylock_irq(lock) \
 ({ \
 	local_irq_disable(); \
-	spin_trylock(lock) ? \
+	raw_spin_trylock(lock) ? \
 	1 : ({ local_irq_enable(); 0;  }); \
 })
 
-#define spin_trylock_irqsave(lock, flags) \
+#define raw_spin_trylock_irqsave(lock, flags) \
 ({ \
 	local_irq_save(flags); \
-	spin_trylock(lock) ? \
+	raw_spin_trylock(lock) ? \
 	1 : ({ local_irq_restore(flags); 0; }); \
 })
 
+/**
+ * raw_spin_can_lock - would raw_spin_trylock() succeed?
+ * @lock: the spinlock in question.
+ */
+#define raw_spin_can_lock(lock)	(!raw_spin_is_locked(lock))
+
+/* Include rwlock functions */
+#include <linux/rwlock.h>
+
+/*
+ * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+# include <linux/spinlock_api_smp.h>
+#else
+# include <linux/spinlock_api_up.h>
+#endif
+
+/*
+ * Map the spin_lock functions to the raw variants for PREEMPT_RT=n
+ */
+
+static inline raw_spinlock_t *spinlock_check(spinlock_t *lock)
+{
+	return &lock->rlock;
+}
+
+#define spin_lock_init(_lock)				\
+do {							\
+	spinlock_check(_lock);				\
+	raw_spin_lock_init(&(_lock)->rlock);		\
+} while (0)
+
+static inline void spin_lock(spinlock_t *lock)
+{
+	raw_spin_lock(&lock->rlock);
+}
+
+static inline void spin_lock_bh(spinlock_t *lock)
+{
+	raw_spin_lock_bh(&lock->rlock);
+}
+
+static inline int spin_trylock(spinlock_t *lock)
+{
+	return raw_spin_trylock(&lock->rlock);
+}
+
+#define spin_lock_nested(lock, subclass)			\
+do {								\
+	raw_spin_lock_nested(spinlock_check(lock), subclass);	\
+} while (0)
+
+#define spin_lock_nest_lock(lock, nest_lock)				\
+do {									\
+	raw_spin_lock_nest_lock(spinlock_check(lock), nest_lock);	\
+} while (0)
+
+static inline void spin_lock_irq(spinlock_t *lock)
+{
+	raw_spin_lock_irq(&lock->rlock);
+}
+
+#define spin_lock_irqsave(lock, flags)				\
+do {								\
+	raw_spin_lock_irqsave(spinlock_check(lock), flags);	\
+} while (0)
+
+#define spin_lock_irqsave_nested(lock, flags, subclass)			\
+do {									\
+	raw_spin_lock_irqsave_nested(spinlock_check(lock), flags, subclass); \
+} while (0)
+
+static inline void spin_unlock(spinlock_t *lock)
+{
+	raw_spin_unlock(&lock->rlock);
+}
+
+static inline void spin_unlock_bh(spinlock_t *lock)
+{
+	raw_spin_unlock_bh(&lock->rlock);
+}
+
+static inline void spin_unlock_irq(spinlock_t *lock)
+{
+	raw_spin_unlock_irq(&lock->rlock);
+}
+
+static inline void spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+{
+	raw_spin_unlock_irqrestore(&lock->rlock, flags);
+}
+
+static inline int spin_trylock_bh(spinlock_t *lock)
+{
+	return raw_spin_trylock_bh(&lock->rlock);
+}
+
+static inline int spin_trylock_irq(spinlock_t *lock)
+{
+	return raw_spin_trylock_irq(&lock->rlock);
+}
+
+#define spin_trylock_irqsave(lock, flags)			\
+({								\
+	raw_spin_trylock_irqsave(spinlock_check(lock), flags); \
+})
+
+static inline void spin_unlock_wait(spinlock_t *lock)
+{
+	raw_spin_unlock_wait(&lock->rlock);
+}
+
+static inline int spin_is_locked(spinlock_t *lock)
+{
+	return raw_spin_is_locked(&lock->rlock);
+}
+
+static inline int spin_is_contended(spinlock_t *lock)
+{
+	return raw_spin_is_contended(&lock->rlock);
+}
+
+static inline int spin_can_lock(spinlock_t *lock)
+{
+	return raw_spin_can_lock(&lock->rlock);
+}
+
+static inline void assert_spin_locked(spinlock_t *lock)
+{
+	assert_raw_spin_locked(&lock->rlock);
+}
+
 /*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
@@ -242,22 +390,4 @@ extern int _atomic_dec_and_lock(atomic_t
 #define atomic_dec_and_lock(atomic, lock) \
 		__cond_lock(lock, _atomic_dec_and_lock(atomic, lock))
 
-/**
- * spin_can_lock - would spin_trylock() succeed?
- * @lock: the spinlock in question.
- */
-#define spin_can_lock(lock)	(!spin_is_locked(lock))
-
-/* Include rwlock functions */
-#include <linux/rwlock.h>
-
-/*
- * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-# include <linux/spinlock_api_smp.h>
-#else
-# include <linux/spinlock_api_up.h>
-#endif
-
 #endif /* __LINUX_SPINLOCK_H */
Index: linux-2.6-tip/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6-tip/include/linux/spinlock_api_smp.h
@@ -17,26 +17,29 @@
 
 int in_lock_functions(unsigned long addr);
 
-#define assert_spin_locked(x)	BUG_ON(!spin_is_locked(x))
+#define assert_raw_spin_locked(x)	BUG_ON(!raw_spin_is_locked(x))
 
-void __lockfunc _spin_lock(spinlock_t *lock)		__acquires(lock);
-void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
+void __lockfunc _spin_lock(raw_spinlock_t *lock)	__acquires(lock);
+void __lockfunc _spin_lock_nested(raw_spinlock_t *lock, int subclass)
 							__acquires(lock);
-void __lockfunc _spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *map)
+void __lockfunc
+_spin_lock_nest_lock(raw_spinlock_t *lock, struct lockdep_map *map)
 							__acquires(lock);
-void __lockfunc _spin_lock_bh(spinlock_t *lock)		__acquires(lock);
-void __lockfunc _spin_lock_irq(spinlock_t *lock)	__acquires(lock);
+void __lockfunc _spin_lock_bh(raw_spinlock_t *lock)	__acquires(lock);
+void __lockfunc _spin_lock_irq(raw_spinlock_t *lock)	__acquires(lock);
 
-unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
+unsigned long __lockfunc _spin_lock_irqsave(raw_spinlock_t *lock)
 							__acquires(lock);
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
+unsigned long __lockfunc
+_spin_lock_irqsave_nested(raw_spinlock_t *lock, int subclass)
 							__acquires(lock);
-int __lockfunc _spin_trylock(spinlock_t *lock);
-int __lockfunc _spin_trylock_bh(spinlock_t *lock);
-void __lockfunc _spin_unlock(spinlock_t *lock)		__releases(lock);
-void __lockfunc _spin_unlock_bh(spinlock_t *lock)	__releases(lock);
-void __lockfunc _spin_unlock_irq(spinlock_t *lock)	__releases(lock);
-void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+int __lockfunc _spin_trylock(raw_spinlock_t *lock);
+int __lockfunc _spin_trylock_bh(raw_spinlock_t *lock);
+void __lockfunc _spin_unlock(raw_spinlock_t *lock)	__releases(lock);
+void __lockfunc _spin_unlock_bh(raw_spinlock_t *lock)	__releases(lock);
+void __lockfunc _spin_unlock_irq(raw_spinlock_t *lock)	__releases(lock);
+void __lockfunc
+_spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 							__releases(lock);
 
 #ifdef CONFIG_INLINE_SPIN_LOCK
@@ -79,7 +82,7 @@ void __lockfunc _spin_unlock_irqrestore(
 #define _spin_unlock_irqrestore(lock, flags) __spin_unlock_irqrestore(lock, flags)
 #endif
 
-static inline int __spin_trylock(spinlock_t *lock)
+static inline int __spin_trylock(raw_spinlock_t *lock)
 {
 	preempt_disable();
 	if (_raw_spin_trylock(lock)) {
@@ -97,7 +100,7 @@ static inline int __spin_trylock(spinloc
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
-static inline unsigned long __spin_lock_irqsave(spinlock_t *lock)
+static inline unsigned long __spin_lock_irqsave(raw_spinlock_t *lock)
 {
 	unsigned long flags;
 
@@ -117,7 +120,7 @@ static inline unsigned long __spin_lock_
 	return flags;
 }
 
-static inline void __spin_lock_irq(spinlock_t *lock)
+static inline void __spin_lock_irq(raw_spinlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
@@ -125,7 +128,7 @@ static inline void __spin_lock_irq(spinl
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-static inline void __spin_lock_bh(spinlock_t *lock)
+static inline void __spin_lock_bh(raw_spinlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
@@ -133,7 +136,7 @@ static inline void __spin_lock_bh(spinlo
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-static inline void __spin_lock(spinlock_t *lock)
+static inline void __spin_lock(raw_spinlock_t *lock)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
@@ -142,14 +145,14 @@ static inline void __spin_lock(spinlock_
 
 #endif /* CONFIG_PREEMPT */
 
-static inline void __spin_unlock(spinlock_t *lock)
+static inline void __spin_unlock(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	preempt_enable();
 }
 
-static inline void __spin_unlock_irqrestore(spinlock_t *lock,
+static inline void __spin_unlock_irqrestore(raw_spinlock_t *lock,
 					    unsigned long flags)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
@@ -158,7 +161,7 @@ static inline void __spin_unlock_irqrest
 	preempt_enable();
 }
 
-static inline void __spin_unlock_irq(spinlock_t *lock)
+static inline void __spin_unlock_irq(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
@@ -166,7 +169,7 @@ static inline void __spin_unlock_irq(spi
 	preempt_enable();
 }
 
-static inline void __spin_unlock_bh(spinlock_t *lock)
+static inline void __spin_unlock_bh(raw_spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
@@ -174,7 +177,7 @@ static inline void __spin_unlock_bh(spin
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
 
-static inline int __spin_trylock_bh(spinlock_t *lock)
+static inline int __spin_trylock_bh(raw_spinlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
Index: linux-2.6-tip/include/linux/spinlock_api_up.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_api_up.h
+++ linux-2.6-tip/include/linux/spinlock_api_up.h
@@ -16,7 +16,7 @@
 
 #define in_lock_functions(ADDR)		0
 
-#define assert_spin_locked(lock)	do { (void)(lock); } while (0)
+#define assert_raw_spin_locked(lock)	do { (void)(lock); } while (0)
 
 /*
  * In the UP-nondebug case there's no real locking going on, so the
Index: linux-2.6-tip/include/linux/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_types.h
+++ linux-2.6-tip/include/linux/spinlock_types.h
@@ -17,7 +17,7 @@
 
 #include <linux/lockdep.h>
 
-typedef struct {
+typedef struct raw_spinlock {
 	arch_spinlock_t raw_lock;
 #ifdef CONFIG_GENERIC_LOCKBREAK
 	unsigned int break_lock;
@@ -29,7 +29,7 @@ typedef struct {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif
-} spinlock_t;
+} raw_spinlock_t;
 
 #define SPINLOCK_MAGIC		0xdead4ead
 
@@ -42,17 +42,44 @@ typedef struct {
 #endif
 
 #ifdef CONFIG_DEBUG_SPINLOCK
-# define __SPIN_LOCK_UNLOCKED(lockname)					\
-	(spinlock_t)	{	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
-				.magic = SPINLOCK_MAGIC,		\
-				.owner = SPINLOCK_OWNER_INIT,		\
-				.owner_cpu = -1,			\
-				SPIN_DEP_MAP_INIT(lockname) }
+# define SPIN_DEBUG_INIT(lockname)		\
+	.magic = SPINLOCK_MAGIC,		\
+	.owner_cpu = -1,			\
+	.owner = SPINLOCK_OWNER_INIT,
 #else
-# define __SPIN_LOCK_UNLOCKED(lockname) \
-	(spinlock_t)	{	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
-				SPIN_DEP_MAP_INIT(lockname) }
+# define SPIN_DEBUG_INIT(lockname)
+#endif
+
+#define __RAW_SPIN_LOCK_INITIALIZER(lockname)	\
+	{					\
+	.raw_lock = __ARCH_SPIN_LOCK_UNLOCKED,	\
+	SPIN_DEBUG_INIT(lockname)		\
+	SPIN_DEP_MAP_INIT(lockname) }
+
+#define __RAW_SPIN_LOCK_UNLOCKED(lockname)	\
+	(raw_spinlock_t) __RAW_SPIN_LOCK_INITIALIZER(lockname)
+
+#define DEFINE_RAW_SPINLOCK(x)	raw_spinlock_t x = __RAW_SPIN_LOCK_UNLOCKED(x)
+
+typedef struct spinlock {
+	union {
+		struct raw_spinlock rlock;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define LOCK_PADSIZE (offsetof(struct raw_spinlock, dep_map))
+		struct {
+			u8 __padding[LOCK_PADSIZE];
+			struct lockdep_map dep_map;
+		};
 #endif
+	};
+} spinlock_t;
+
+#define __SPIN_LOCK_INITIALIZER(lockname) \
+	{ { .rlock = __RAW_SPIN_LOCK_INITIALIZER(lockname) } }
+
+#define __SPIN_LOCK_UNLOCKED(lockname) \
+	(spinlock_t ) __SPIN_LOCK_INITIALIZER(lockname)
 
 /*
  * SPIN_LOCK_UNLOCKED defeats lockdep state tracking and is hence
Index: linux-2.6-tip/kernel/mutex-debug.h
===================================================================
--- linux-2.6-tip.orig/kernel/mutex-debug.h
+++ linux-2.6-tip/kernel/mutex-debug.h
@@ -43,13 +43,13 @@ static inline void mutex_clear_owner(str
 							\
 		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
 		local_irq_save(flags);			\
-		arch_spin_lock(&(lock)->raw_lock);	\
+		arch_spin_lock(&(lock)->rlock.raw_lock);\
 		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
 	} while (0)
 
-#define spin_unlock_mutex(lock, flags)			\
-	do {						\
-		arch_spin_unlock(&(lock)->raw_lock);	\
-		local_irq_restore(flags);		\
-		preempt_check_resched();		\
+#define spin_unlock_mutex(lock, flags)				\
+	do {							\
+		arch_spin_unlock(&(lock)->rlock.raw_lock);	\
+		local_irq_restore(flags);			\
+		preempt_check_resched();			\
 	} while (0)
Index: linux-2.6-tip/kernel/sched.c
===================================================================
--- linux-2.6-tip.orig/kernel/sched.c
+++ linux-2.6-tip/kernel/sched.c
@@ -883,7 +883,7 @@ static inline void finish_lock_switch(st
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
 	/* this is a valid case when another task releases the spinlock */
-	rq->lock.owner = current;
+	rq->lock.rlock.owner = current;
 #endif
 	/*
 	 * If we are tracking spinlock dependencies then we have to
Index: linux-2.6-tip/kernel/spinlock.c
===================================================================
--- linux-2.6-tip.orig/kernel/spinlock.c
+++ linux-2.6-tip/kernel/spinlock.c
@@ -32,6 +32,8 @@
  * include/linux/spinlock_api_smp.h
  */
 #else
+#define raw_read_can_lock(l)	read_can_lock(l)
+#define raw_write_can_lock(l)	write_can_lock(l)
 /*
  * We build the __lock_function inlines here. They are too large for
  * inlining all over the place, but here is only one user per function
@@ -52,7 +54,7 @@ void __lockfunc __##op##_lock(locktype##
 									\
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+		while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
 			arch_##op##_relax(&lock->raw_lock);		\
 	}								\
 	(lock)->break_lock = 0;						\
@@ -72,7 +74,7 @@ unsigned long __lockfunc __##op##_lock_i
 									\
 		if (!(lock)->break_lock)				\
 			(lock)->break_lock = 1;				\
-		while (!op##_can_lock(lock) && (lock)->break_lock)	\
+		while (!raw_##op##_can_lock(lock) && (lock)->break_lock)\
 			arch_##op##_relax(&lock->raw_lock);		\
 	}								\
 	(lock)->break_lock = 0;						\
@@ -107,14 +109,14 @@ void __lockfunc __##op##_lock_bh(locktyp
  *         __[spin|read|write]_lock_irqsave()
  *         __[spin|read|write]_lock_bh()
  */
-BUILD_LOCK_OPS(spin, spinlock);
+BUILD_LOCK_OPS(spin, raw_spinlock);
 BUILD_LOCK_OPS(read, rwlock);
 BUILD_LOCK_OPS(write, rwlock);
 
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK
-int __lockfunc _spin_trylock(spinlock_t *lock)
+int __lockfunc _spin_trylock(raw_spinlock_t *lock)
 {
 	return __spin_trylock(lock);
 }
@@ -122,7 +124,7 @@ EXPORT_SYMBOL(_spin_trylock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
-int __lockfunc _spin_trylock_bh(spinlock_t *lock)
+int __lockfunc _spin_trylock_bh(raw_spinlock_t *lock)
 {
 	return __spin_trylock_bh(lock);
 }
@@ -130,7 +132,7 @@ EXPORT_SYMBOL(_spin_trylock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK
-void __lockfunc _spin_lock(spinlock_t *lock)
+void __lockfunc _spin_lock(raw_spinlock_t *lock)
 {
 	__spin_lock(lock);
 }
@@ -138,7 +140,7 @@ EXPORT_SYMBOL(_spin_lock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
-unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
+unsigned long __lockfunc _spin_lock_irqsave(raw_spinlock_t *lock)
 {
 	return __spin_lock_irqsave(lock);
 }
@@ -146,7 +148,7 @@ EXPORT_SYMBOL(_spin_lock_irqsave);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
-void __lockfunc _spin_lock_irq(spinlock_t *lock)
+void __lockfunc _spin_lock_irq(raw_spinlock_t *lock)
 {
 	__spin_lock_irq(lock);
 }
@@ -154,7 +156,7 @@ EXPORT_SYMBOL(_spin_lock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_LOCK_BH
-void __lockfunc _spin_lock_bh(spinlock_t *lock)
+void __lockfunc _spin_lock_bh(raw_spinlock_t *lock)
 {
 	__spin_lock_bh(lock);
 }
@@ -162,7 +164,7 @@ EXPORT_SYMBOL(_spin_lock_bh);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK
-void __lockfunc _spin_unlock(spinlock_t *lock)
+void __lockfunc _spin_unlock(raw_spinlock_t *lock)
 {
 	__spin_unlock(lock);
 }
@@ -170,7 +172,7 @@ EXPORT_SYMBOL(_spin_unlock);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
-void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+void __lockfunc _spin_unlock_irqrestore(raw_spinlock_t *lock, unsigned long flags)
 {
 	__spin_unlock_irqrestore(lock, flags);
 }
@@ -178,7 +180,7 @@ EXPORT_SYMBOL(_spin_unlock_irqrestore);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
-void __lockfunc _spin_unlock_irq(spinlock_t *lock)
+void __lockfunc _spin_unlock_irq(raw_spinlock_t *lock)
 {
 	__spin_unlock_irq(lock);
 }
@@ -186,7 +188,7 @@ EXPORT_SYMBOL(_spin_unlock_irq);
 #endif
 
 #ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
-void __lockfunc _spin_unlock_bh(spinlock_t *lock)
+void __lockfunc _spin_unlock_bh(raw_spinlock_t *lock)
 {
 	__spin_unlock_bh(lock);
 }
@@ -339,7 +341,7 @@ EXPORT_SYMBOL(_write_unlock_bh);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
+void __lockfunc _spin_lock_nested(raw_spinlock_t *lock, int subclass)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
@@ -347,7 +349,7 @@ void __lockfunc _spin_lock_nested(spinlo
 }
 EXPORT_SYMBOL(_spin_lock_nested);
 
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock,
+unsigned long __lockfunc _spin_lock_irqsave_nested(raw_spinlock_t *lock,
 						   int subclass)
 {
 	unsigned long flags;
@@ -361,7 +363,7 @@ unsigned long __lockfunc _spin_lock_irqs
 }
 EXPORT_SYMBOL(_spin_lock_irqsave_nested);
 
-void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
+void __lockfunc _spin_lock_nest_lock(raw_spinlock_t *lock,
 				     struct lockdep_map *nest_lock)
 {
 	preempt_disable();
Index: linux-2.6-tip/lib/spinlock_debug.c
===================================================================
--- linux-2.6-tip.orig/lib/spinlock_debug.c
+++ linux-2.6-tip/lib/spinlock_debug.c
@@ -13,8 +13,8 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 
-void __spin_lock_init(spinlock_t *lock, const char *name,
-		      struct lock_class_key *key)
+void __raw_spin_lock_init(raw_spinlock_t *lock, const char *name,
+			  struct lock_class_key *key)
 {
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	/*
@@ -29,7 +29,7 @@ void __spin_lock_init(spinlock_t *lock, 
 	lock->owner_cpu = -1;
 }
 
-EXPORT_SYMBOL(__spin_lock_init);
+EXPORT_SYMBOL(__raw_spin_lock_init);
 
 void __rwlock_init(rwlock_t *lock, const char *name,
 		   struct lock_class_key *key)
@@ -49,7 +49,7 @@ void __rwlock_init(rwlock_t *lock, const
 
 EXPORT_SYMBOL(__rwlock_init);
 
-static void spin_bug(spinlock_t *lock, const char *msg)
+static void spin_bug(raw_spinlock_t *lock, const char *msg)
 {
 	struct task_struct *owner = NULL;
 
@@ -73,7 +73,7 @@ static void spin_bug(spinlock_t *lock, c
 #define SPIN_BUG_ON(cond, lock, msg) if (unlikely(cond)) spin_bug(lock, msg)
 
 static inline void
-debug_spin_lock_before(spinlock_t *lock)
+debug_spin_lock_before(raw_spinlock_t *lock)
 {
 	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
 	SPIN_BUG_ON(lock->owner == current, lock, "recursion");
@@ -81,16 +81,16 @@ debug_spin_lock_before(spinlock_t *lock)
 							lock, "cpu recursion");
 }
 
-static inline void debug_spin_lock_after(spinlock_t *lock)
+static inline void debug_spin_lock_after(raw_spinlock_t *lock)
 {
 	lock->owner_cpu = raw_smp_processor_id();
 	lock->owner = current;
 }
 
-static inline void debug_spin_unlock(spinlock_t *lock)
+static inline void debug_spin_unlock(raw_spinlock_t *lock)
 {
 	SPIN_BUG_ON(lock->magic != SPINLOCK_MAGIC, lock, "bad magic");
-	SPIN_BUG_ON(!spin_is_locked(lock), lock, "already unlocked");
+	SPIN_BUG_ON(!raw_spin_is_locked(lock), lock, "already unlocked");
 	SPIN_BUG_ON(lock->owner != current, lock, "wrong owner");
 	SPIN_BUG_ON(lock->owner_cpu != raw_smp_processor_id(),
 							lock, "wrong CPU");
@@ -98,7 +98,7 @@ static inline void debug_spin_unlock(spi
 	lock->owner_cpu = -1;
 }
 
-static void __spin_lock_debug(spinlock_t *lock)
+static void __spin_lock_debug(raw_spinlock_t *lock)
 {
 	u64 i;
 	u64 loops = loops_per_jiffy * HZ;
@@ -125,7 +125,7 @@ static void __spin_lock_debug(spinlock_t
 	}
 }
 
-void _raw_spin_lock(spinlock_t *lock)
+void _raw_spin_lock(raw_spinlock_t *lock)
 {
 	debug_spin_lock_before(lock);
 	if (unlikely(!arch_spin_trylock(&lock->raw_lock)))
@@ -133,7 +133,7 @@ void _raw_spin_lock(spinlock_t *lock)
 	debug_spin_lock_after(lock);
 }
 
-int _raw_spin_trylock(spinlock_t *lock)
+int _raw_spin_trylock(raw_spinlock_t *lock)
 {
 	int ret = arch_spin_trylock(&lock->raw_lock);
 
@@ -148,7 +148,7 @@ int _raw_spin_trylock(spinlock_t *lock)
 	return ret;
 }
 
-void _raw_spin_unlock(spinlock_t *lock)
+void _raw_spin_unlock(raw_spinlock_t *lock)
 {
 	debug_spin_unlock(lock);
 	arch_spin_unlock(&lock->raw_lock);


