Return-Path: <linux-kernel-owner+w=401wt.eu-S934104AbZLFSCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934104AbZLFSCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 13:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934092AbZLFSCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 13:02:25 -0500
Received: from www.tglx.de ([62.245.132.106]:33029 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934078AbZLFSCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 13:02:17 -0500
Message-Id: <20091206111957.370028725@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 06 Dec 2009 18:01:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux-Arch <linux-arch@vger.kernel.org>
Subject: [patch 02/23] locking: Split rwlock from spinlock headers
References: <20091206110944.492100233@linutronix.de>
Content-Disposition: inline;
	filename=locking-split-rwlock-h-from-spinlock-h.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the rwlock defines and inlines into separate header files. This
makes the selection for -rt easier.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/rwlock.h         |  127 +++++++++++++++++++++++++++++++++++++++++
 include/linux/rwlock_types.h   |   56 ++++++++++++++++++
 include/linux/spinlock.h       |  100 ++------------------------------
 include/linux/spinlock_types.h |   43 +------------
 4 files changed, 197 insertions(+), 129 deletions(-)

Index: linux-2.6-tip/include/linux/rwlock.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/include/linux/rwlock.h
@@ -0,0 +1,127 @@
+#ifndef __LINUX_RWLOCK_H
+#define __LINUX_RWLOCK_H
+
+#ifndef __LINUX_SPINLOCK_H
+# error "please don't include this file directly"
+#endif
+
+/*
+ * rwlock related methods
+ *
+ * split out from spinlock.h
+ *
+ * portions Copyright 2005, Red Hat, Inc., Ingo Molnar
+ * Released under the General Public License (GPL).
+ */
+
+extern int __lockfunc generic__raw_read_trylock(raw_rwlock_t *lock);
+
+#ifdef CONFIG_DEBUG_SPINLOCK
+  extern void __rwlock_init(rwlock_t *lock, const char *name,
+			    struct lock_class_key *key);
+# define rwlock_init(lock)					\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	__rwlock_init((lock), #lock, &__key);			\
+} while (0)
+#else
+# define rwlock_init(lock)					\
+	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
+#endif
+
+#ifdef CONFIG_DEBUG_SPINLOCK
+ extern void _raw_read_lock(rwlock_t *lock);
+#define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)
+ extern int _raw_read_trylock(rwlock_t *lock);
+ extern void _raw_read_unlock(rwlock_t *lock);
+ extern void _raw_write_lock(rwlock_t *lock);
+#define _raw_write_lock_flags(lock, flags) _raw_write_lock(lock)
+ extern int _raw_write_trylock(rwlock_t *lock);
+ extern void _raw_write_unlock(rwlock_t *lock);
+#else
+# define _raw_read_lock(rwlock)		__raw_read_lock(&(rwlock)->raw_lock)
+# define _raw_read_lock_flags(lock, flags) \
+		__raw_read_lock_flags(&(lock)->raw_lock, *(flags))
+# define _raw_read_trylock(rwlock)	__raw_read_trylock(&(rwlock)->raw_lock)
+# define _raw_read_unlock(rwlock)	__raw_read_unlock(&(rwlock)->raw_lock)
+# define _raw_write_lock(rwlock)	__raw_write_lock(&(rwlock)->raw_lock)
+# define _raw_write_lock_flags(lock, flags) \
+		__raw_write_lock_flags(&(lock)->raw_lock, *(flags))
+# define _raw_write_trylock(rwlock)	__raw_write_trylock(&(rwlock)->raw_lock)
+# define _raw_write_unlock(rwlock)	__raw_write_unlock(&(rwlock)->raw_lock)
+#endif
+
+#define read_can_lock(rwlock)		__raw_read_can_lock(&(rwlock)->raw_lock)
+#define write_can_lock(rwlock)		__raw_write_can_lock(&(rwlock)->raw_lock)
+
+/*
+ * Define the various rw_lock methods.  Note we define these
+ * regardless of whether CONFIG_SMP or CONFIG_PREEMPT are set. The various
+ * methods are defined as nops in the case they are not required.
+ */
+#define read_trylock(lock)		__cond_lock(lock, _read_trylock(lock))
+#define write_trylock(lock)		__cond_lock(lock, _write_trylock(lock))
+
+#define write_lock(lock)		_write_lock(lock)
+#define read_lock(lock)			_read_lock(lock)
+
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _read_lock_irqsave(lock);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		flags = _write_lock_irqsave(lock);	\
+	} while (0)
+
+#else
+
+#define read_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_read_lock_irqsave(lock, flags);	\
+	} while (0)
+#define write_lock_irqsave(lock, flags)			\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_write_lock_irqsave(lock, flags);	\
+	} while (0)
+
+#endif
+
+#define read_lock_irq(lock)		_read_lock_irq(lock)
+#define read_lock_bh(lock)		_read_lock_bh(lock)
+#define write_lock_irq(lock)		_write_lock_irq(lock)
+#define write_lock_bh(lock)		_write_lock_bh(lock)
+#define read_unlock(lock)		_read_unlock(lock)
+#define write_unlock(lock)		_write_unlock(lock)
+#define read_unlock_irq(lock)		_read_unlock_irq(lock)
+#define write_unlock_irq(lock)		_write_unlock_irq(lock)
+
+#define read_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_read_unlock_irqrestore(lock, flags);	\
+	} while (0)
+#define read_unlock_bh(lock)		_read_unlock_bh(lock)
+
+#define write_unlock_irqrestore(lock, flags)		\
+	do {						\
+		typecheck(unsigned long, flags);	\
+		_write_unlock_irqrestore(lock, flags);	\
+	} while (0)
+#define write_unlock_bh(lock)		_write_unlock_bh(lock)
+
+#define write_trylock_irqsave(lock, flags) \
+({ \
+	local_irq_save(flags); \
+	write_trylock(lock) ? \
+	1 : ({ local_irq_restore(flags); 0; }); \
+})
+
+#endif /* __LINUX_RWLOCK_H */
Index: linux-2.6-tip/include/linux/rwlock_types.h
===================================================================
--- /dev/null
+++ linux-2.6-tip/include/linux/rwlock_types.h
@@ -0,0 +1,56 @@
+#ifndef __LINUX_RWLOCK_TYPES_H
+#define __LINUX_RWLOCK_TYPES_H
+
+/*
+ * include/linux/rwlock_types.h - generic rwlock type definitions
+ *				  and initializers
+ *
+ * portions Copyright 2005, Red Hat, Inc., Ingo Molnar
+ * Released under the General Public License (GPL).
+ */
+typedef struct {
+	raw_rwlock_t raw_lock;
+#ifdef CONFIG_GENERIC_LOCKBREAK
+	unsigned int break_lock;
+#endif
+#ifdef CONFIG_DEBUG_SPINLOCK
+	unsigned int magic, owner_cpu;
+	void *owner;
+#endif
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+} rwlock_t;
+
+#define RWLOCK_MAGIC		0xdeaf1eed
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+# define RW_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
+#else
+# define RW_DEP_MAP_INIT(lockname)
+#endif
+
+#ifdef CONFIG_DEBUG_SPINLOCK
+#define __RW_LOCK_UNLOCKED(lockname)					\
+	(rwlock_t)	{	.raw_lock = __RAW_RW_LOCK_UNLOCKED,	\
+				.magic = RWLOCK_MAGIC,			\
+				.owner = SPINLOCK_OWNER_INIT,		\
+				.owner_cpu = -1,			\
+				RW_DEP_MAP_INIT(lockname) }
+#else
+#define __RW_LOCK_UNLOCKED(lockname) \
+	(rwlock_t)	{	.raw_lock = __RAW_RW_LOCK_UNLOCKED,	\
+				RW_DEP_MAP_INIT(lockname) }
+#endif
+
+/*
+ * RW_LOCK_UNLOCKED defeat lockdep state tracking and is hence
+ * deprecated.
+ *
+ * Please use DEFINE_RWLOCK() or __RW_LOCK_UNLOCKED() as appropriate.
+ */
+#define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
+
+#define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
+
+#endif /* __LINUX_RWLOCK_TYPES_H */
Index: linux-2.6-tip/include/linux/spinlock.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock.h
+++ linux-2.6-tip/include/linux/spinlock.h
@@ -103,20 +103,6 @@ do {								\
 	do { *(lock) = __SPIN_LOCK_UNLOCKED(lock); } while (0)
 #endif
 
-#ifdef CONFIG_DEBUG_SPINLOCK
-  extern void __rwlock_init(rwlock_t *lock, const char *name,
-			    struct lock_class_key *key);
-# define rwlock_init(lock)					\
-do {								\
-	static struct lock_class_key __key;			\
-								\
-	__rwlock_init((lock), #lock, &__key);			\
-} while (0)
-#else
-# define rwlock_init(lock)					\
-	do { *(lock) = __RW_LOCK_UNLOCKED(lock); } while (0)
-#endif
-
 #define spin_is_locked(lock)	__raw_spin_is_locked(&(lock)->raw_lock)
 
 #ifdef CONFIG_GENERIC_LOCKBREAK
@@ -146,43 +132,21 @@ static inline void smp_mb__after_lock(vo
 #define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
  extern int _raw_spin_trylock(spinlock_t *lock);
  extern void _raw_spin_unlock(spinlock_t *lock);
- extern void _raw_read_lock(rwlock_t *lock);
-#define _raw_read_lock_flags(lock, flags) _raw_read_lock(lock)
- extern int _raw_read_trylock(rwlock_t *lock);
- extern void _raw_read_unlock(rwlock_t *lock);
- extern void _raw_write_lock(rwlock_t *lock);
-#define _raw_write_lock_flags(lock, flags) _raw_write_lock(lock)
- extern int _raw_write_trylock(rwlock_t *lock);
- extern void _raw_write_unlock(rwlock_t *lock);
 #else
 # define _raw_spin_lock(lock)		__raw_spin_lock(&(lock)->raw_lock)
 # define _raw_spin_lock_flags(lock, flags) \
 		__raw_spin_lock_flags(&(lock)->raw_lock, *(flags))
 # define _raw_spin_trylock(lock)	__raw_spin_trylock(&(lock)->raw_lock)
 # define _raw_spin_unlock(lock)		__raw_spin_unlock(&(lock)->raw_lock)
-# define _raw_read_lock(rwlock)		__raw_read_lock(&(rwlock)->raw_lock)
-# define _raw_read_lock_flags(lock, flags) \
-		__raw_read_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_read_trylock(rwlock)	__raw_read_trylock(&(rwlock)->raw_lock)
-# define _raw_read_unlock(rwlock)	__raw_read_unlock(&(rwlock)->raw_lock)
-# define _raw_write_lock(rwlock)	__raw_write_lock(&(rwlock)->raw_lock)
-# define _raw_write_lock_flags(lock, flags) \
-		__raw_write_lock_flags(&(lock)->raw_lock, *(flags))
-# define _raw_write_trylock(rwlock)	__raw_write_trylock(&(rwlock)->raw_lock)
-# define _raw_write_unlock(rwlock)	__raw_write_unlock(&(rwlock)->raw_lock)
 #endif
 
-#define read_can_lock(rwlock)		__raw_read_can_lock(&(rwlock)->raw_lock)
-#define write_can_lock(rwlock)		__raw_write_can_lock(&(rwlock)->raw_lock)
-
 /*
- * Define the various spin_lock and rw_lock methods.  Note we define these
- * regardless of whether CONFIG_SMP or CONFIG_PREEMPT are set. The various
- * methods are defined as nops in the case they are not required.
+ * Define the various spin_lock methods.  Note we define these
+ * regardless of whether CONFIG_SMP or CONFIG_PREEMPT are set. The
+ * various methods are defined as nops in the case they are not
+ * required.
  */
 #define spin_trylock(lock)		__cond_lock(lock, _spin_trylock(lock))
-#define read_trylock(lock)		__cond_lock(lock, _read_trylock(lock))
-#define write_trylock(lock)		__cond_lock(lock, _write_trylock(lock))
 
 #define spin_lock(lock)			_spin_lock(lock)
 
@@ -198,9 +162,6 @@ static inline void smp_mb__after_lock(vo
 # define spin_lock_nest_lock(lock, nest_lock) _spin_lock(lock)
 #endif
 
-#define write_lock(lock)		_write_lock(lock)
-#define read_lock(lock)			_read_lock(lock)
-
 #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
 
 #define spin_lock_irqsave(lock, flags)			\
@@ -208,16 +169,6 @@ static inline void smp_mb__after_lock(vo
 		typecheck(unsigned long, flags);	\
 		flags = _spin_lock_irqsave(lock);	\
 	} while (0)
-#define read_lock_irqsave(lock, flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		flags = _read_lock_irqsave(lock);	\
-	} while (0)
-#define write_lock_irqsave(lock, flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		flags = _write_lock_irqsave(lock);	\
-	} while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define spin_lock_irqsave_nested(lock, flags, subclass)			\
@@ -240,16 +191,7 @@ static inline void smp_mb__after_lock(vo
 		typecheck(unsigned long, flags);	\
 		_spin_lock_irqsave(lock, flags);	\
 	} while (0)
-#define read_lock_irqsave(lock, flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		_read_lock_irqsave(lock, flags);	\
-	} while (0)
-#define write_lock_irqsave(lock, flags)			\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		_write_lock_irqsave(lock, flags);	\
-	} while (0)
+
 #define spin_lock_irqsave_nested(lock, flags, subclass)	\
 	spin_lock_irqsave(lock, flags)
 
@@ -257,16 +199,8 @@ static inline void smp_mb__after_lock(vo
 
 #define spin_lock_irq(lock)		_spin_lock_irq(lock)
 #define spin_lock_bh(lock)		_spin_lock_bh(lock)
-#define read_lock_irq(lock)		_read_lock_irq(lock)
-#define read_lock_bh(lock)		_read_lock_bh(lock)
-#define write_lock_irq(lock)		_write_lock_irq(lock)
-#define write_lock_bh(lock)		_write_lock_bh(lock)
 #define spin_unlock(lock)		_spin_unlock(lock)
-#define read_unlock(lock)		_read_unlock(lock)
-#define write_unlock(lock)		_write_unlock(lock)
 #define spin_unlock_irq(lock)		_spin_unlock_irq(lock)
-#define read_unlock_irq(lock)		_read_unlock_irq(lock)
-#define write_unlock_irq(lock)		_write_unlock_irq(lock)
 
 #define spin_unlock_irqrestore(lock, flags)		\
 	do {						\
@@ -275,20 +209,6 @@ static inline void smp_mb__after_lock(vo
 	} while (0)
 #define spin_unlock_bh(lock)		_spin_unlock_bh(lock)
 
-#define read_unlock_irqrestore(lock, flags)		\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		_read_unlock_irqrestore(lock, flags);	\
-	} while (0)
-#define read_unlock_bh(lock)		_read_unlock_bh(lock)
-
-#define write_unlock_irqrestore(lock, flags)		\
-	do {						\
-		typecheck(unsigned long, flags);	\
-		_write_unlock_irqrestore(lock, flags);	\
-	} while (0)
-#define write_unlock_bh(lock)		_write_unlock_bh(lock)
-
 #define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
 
 #define spin_trylock_irq(lock) \
@@ -305,13 +225,6 @@ static inline void smp_mb__after_lock(vo
 	1 : ({ local_irq_restore(flags); 0; }); \
 })
 
-#define write_trylock_irqsave(lock, flags) \
-({ \
-	local_irq_save(flags); \
-	write_trylock(lock) ? \
-	1 : ({ local_irq_restore(flags); 0; }); \
-})
-
 /*
  * Pull the atomic_t declaration:
  * (asm-mips/atomic.h needs above definitions)
@@ -335,6 +248,9 @@ extern int _atomic_dec_and_lock(atomic_t
  */
 #define spin_can_lock(lock)	(!spin_is_locked(lock))
 
+/* Include rwlock functions */
+#include <linux/rwlock.h>
+
 /*
  * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
  */
Index: linux-2.6-tip/include/linux/spinlock_types.h
===================================================================
--- linux-2.6-tip.orig/include/linux/spinlock_types.h
+++ linux-2.6-tip/include/linux/spinlock_types.h
@@ -33,22 +33,6 @@ typedef struct {
 
 #define SPINLOCK_MAGIC		0xdead4ead
 
-typedef struct {
-	raw_rwlock_t raw_lock;
-#ifdef CONFIG_GENERIC_LOCKBREAK
-	unsigned int break_lock;
-#endif
-#ifdef CONFIG_DEBUG_SPINLOCK
-	unsigned int magic, owner_cpu;
-	void *owner;
-#endif
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-	struct lockdep_map dep_map;
-#endif
-} rwlock_t;
-
-#define RWLOCK_MAGIC		0xdeaf1eed
-
 #define SPINLOCK_OWNER_INIT	((void *)-1L)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -57,12 +41,6 @@ typedef struct {
 # define SPIN_DEP_MAP_INIT(lockname)
 #endif
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define RW_DEP_MAP_INIT(lockname)	.dep_map = { .name = #lockname }
-#else
-# define RW_DEP_MAP_INIT(lockname)
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK
 # define __SPIN_LOCK_UNLOCKED(lockname)					\
 	(spinlock_t)	{	.raw_lock = __RAW_SPIN_LOCK_UNLOCKED,	\
@@ -70,31 +48,22 @@ typedef struct {
 				.owner = SPINLOCK_OWNER_INIT,		\
 				.owner_cpu = -1,			\
 				SPIN_DEP_MAP_INIT(lockname) }
-#define __RW_LOCK_UNLOCKED(lockname)					\
-	(rwlock_t)	{	.raw_lock = __RAW_RW_LOCK_UNLOCKED,	\
-				.magic = RWLOCK_MAGIC,			\
-				.owner = SPINLOCK_OWNER_INIT,		\
-				.owner_cpu = -1,			\
-				RW_DEP_MAP_INIT(lockname) }
 #else
 # define __SPIN_LOCK_UNLOCKED(lockname) \
 	(spinlock_t)	{	.raw_lock = __RAW_SPIN_LOCK_UNLOCKED,	\
 				SPIN_DEP_MAP_INIT(lockname) }
-#define __RW_LOCK_UNLOCKED(lockname) \
-	(rwlock_t)	{	.raw_lock = __RAW_RW_LOCK_UNLOCKED,	\
-				RW_DEP_MAP_INIT(lockname) }
 #endif
 
 /*
- * SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED defeat lockdep state tracking and
- * are hence deprecated.
- * Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
- * __SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate.
+ * SPIN_LOCK_UNLOCKED defeats lockdep state tracking and is hence
+ * deprecated.
+ * Please use DEFINE_SPINLOCK() or __SPIN_LOCK_UNLOCKED() as
+ * appropriate.
  */
 #define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
-#define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
 
 #define DEFINE_SPINLOCK(x)	spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
-#define DEFINE_RWLOCK(x)	rwlock_t x = __RW_LOCK_UNLOCKED(x)
+
+#include <linux/rwlock_types.h>
 
 #endif /* __LINUX_SPINLOCK_TYPES_H */


