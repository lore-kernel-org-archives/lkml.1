Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZKIPWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZKIPWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 10:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756034AbZKIPWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 10:22:20 -0500
Received: from www.tglx.de ([62.245.132.106]:49365 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbZKIPWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 10:22:06 -0500
Message-Id: <20091109151428.504477141@linutronix.de>
User-Agent: quilt/0.47-1
Date: Mon, 09 Nov 2009 15:21:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-arch@vger.kernel.org
Subject: [patch 1/2] locking: Make inlining decision Kconfig based
References: <20091109150033.125758935@linutronix.de>
Content-Disposition: inline; filename=locking-make-inlining-kconfig-based.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 892a7c67 (locking: Allow arch-inlined spinlocks) implements the
selection of which lock functions are inlined based on defines in
arch/.../spinlock.h: #define __always_inline__LOCK_FUNCTION

Despite of the name __always_inline__* the lock functions can be built
out of line depending on config options. Also if the arch does not set
some inline defines the generic code might set them; again depending on
config options.

This makes it unnecessary hard to figure out when and which lock
functions are inlined. Aside of that it makes it way harder and
messier for -rt to manipulate the lock functions.

Convert the inlining decision to CONFIG switches. Each lock function
is inlined depending on CONFIG_INLINE_*. The configs implement the
existing dependencies. The architecture code can select ARCH_INLINE_*
to signal that it wants the corresponding lock function inlined.
ARCH_INLINE_* is necessary as Kconfig ignores "depends on"
restrictions when a config element is selected.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-arch@vger.kernel.org
---
 arch/s390/Kconfig                |   28 +++++
 arch/s390/include/asm/spinlock.h |   29 -----
 include/linux/spinlock_api_smp.h |   75 +++++---------
 init/Kconfig                     |    1 
 kernel/Kconfig.locks             |  199 +++++++++++++++++++++++++++++++++++++++
 kernel/spinlock.c                |   56 +++++-----
 6 files changed, 284 insertions(+), 104 deletions(-)

Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -95,6 +95,34 @@ config S390
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
 	select HAVE_PERF_EVENTS
+	select ARCH_INLINE_SPIN_TRYLOCK
+	select ARCH_INLINE_SPIN_TRYLOCK_BH
+	select ARCH_INLINE_SPIN_LOCK
+	select ARCH_INLINE_SPIN_LOCK_BH
+	select ARCH_INLINE_SPIN_LOCK_IRQ
+	select ARCH_INLINE_SPIN_LOCK_IRQSAVE
+	select ARCH_INLINE_SPIN_UNLOCK
+	select ARCH_INLINE_SPIN_UNLOCK_BH
+	select ARCH_INLINE_SPIN_UNLOCK_IRQ
+	select ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+	select ARCH_INLINE_READ_TRYLOCK
+	select ARCH_INLINE_READ_LOCK
+	select ARCH_INLINE_READ_LOCK_BH
+	select ARCH_INLINE_READ_LOCK_IRQ
+	select ARCH_INLINE_READ_LOCK_IRQSAVE
+	select ARCH_INLINE_READ_UNLOCK
+	select ARCH_INLINE_READ_UNLOCK_BH
+	select ARCH_INLINE_READ_UNLOCK_IRQ
+	select ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+	select ARCH_INLINE_WRITE_TRYLOCK
+	select ARCH_INLINE_WRITE_LOCK
+	select ARCH_INLINE_WRITE_LOCK_BH
+	select ARCH_INLINE_WRITE_LOCK_IRQ
+	select ARCH_INLINE_WRITE_LOCK_IRQSAVE
+	select ARCH_INLINE_WRITE_UNLOCK
+	select ARCH_INLINE_WRITE_UNLOCK_BH
+	select ARCH_INLINE_WRITE_UNLOCK_IRQ
+	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
 
 config SCHED_OMIT_FRAME_POINTER
 	bool
Index: linux-2.6/arch/s390/include/asm/spinlock.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/spinlock.h
+++ linux-2.6/arch/s390/include/asm/spinlock.h
@@ -191,33 +191,4 @@ static inline int __raw_write_trylock(ra
 #define _raw_read_relax(lock)	cpu_relax()
 #define _raw_write_relax(lock)	cpu_relax()
 
-#define __always_inline__spin_lock
-#define __always_inline__read_lock
-#define __always_inline__write_lock
-#define __always_inline__spin_lock_bh
-#define __always_inline__read_lock_bh
-#define __always_inline__write_lock_bh
-#define __always_inline__spin_lock_irq
-#define __always_inline__read_lock_irq
-#define __always_inline__write_lock_irq
-#define __always_inline__spin_lock_irqsave
-#define __always_inline__read_lock_irqsave
-#define __always_inline__write_lock_irqsave
-#define __always_inline__spin_trylock
-#define __always_inline__read_trylock
-#define __always_inline__write_trylock
-#define __always_inline__spin_trylock_bh
-#define __always_inline__spin_unlock
-#define __always_inline__read_unlock
-#define __always_inline__write_unlock
-#define __always_inline__spin_unlock_bh
-#define __always_inline__read_unlock_bh
-#define __always_inline__write_unlock_bh
-#define __always_inline__spin_unlock_irq
-#define __always_inline__read_unlock_irq
-#define __always_inline__write_unlock_irq
-#define __always_inline__spin_unlock_irqrestore
-#define __always_inline__read_unlock_irqrestore
-#define __always_inline__write_unlock_irqrestore
-
 #endif /* __ASM_SPINLOCK_H */
Index: linux-2.6/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6/include/linux/spinlock_api_smp.h
@@ -60,137 +60,118 @@ void __lockfunc _read_unlock_irqrestore(
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
-/*
- * We inline the unlock functions in the nondebug case:
- */
-#if !defined(CONFIG_DEBUG_SPINLOCK) && !defined(CONFIG_PREEMPT)
-#define __always_inline__spin_unlock
-#define __always_inline__read_unlock
-#define __always_inline__write_unlock
-#define __always_inline__spin_unlock_irq
-#define __always_inline__read_unlock_irq
-#define __always_inline__write_unlock_irq
-#endif
-
-#ifndef CONFIG_DEBUG_SPINLOCK
-#ifndef CONFIG_GENERIC_LOCKBREAK
-
-#ifdef __always_inline__spin_lock
+#ifdef CONFIG_INLINE_SPIN_LOCK
 #define _spin_lock(lock) __spin_lock(lock)
 #endif
 
-#ifdef __always_inline__read_lock
+#ifdef CONFIG_INLINE_READ_LOCK
 #define _read_lock(lock) __read_lock(lock)
 #endif
 
-#ifdef __always_inline__write_lock
+#ifdef CONFIG_INLINE_WRITE_LOCK
 #define _write_lock(lock) __write_lock(lock)
 #endif
 
-#ifdef __always_inline__spin_lock_bh
+#ifdef CONFIG_INLINE_SPIN_LOCK_BH
 #define _spin_lock_bh(lock) __spin_lock_bh(lock)
 #endif
 
-#ifdef __always_inline__read_lock_bh
+#ifdef CONFIG_INLINE_READ_LOCK_BH
 #define _read_lock_bh(lock) __read_lock_bh(lock)
 #endif
 
-#ifdef __always_inline__write_lock_bh
+#ifdef CONFIG_INLINE_WRITE_LOCK_BH
 #define _write_lock_bh(lock) __write_lock_bh(lock)
 #endif
 
-#ifdef __always_inline__spin_lock_irq
+#ifdef CONFIG_INLINE_SPIN_LOCK_IRQ
 #define _spin_lock_irq(lock) __spin_lock_irq(lock)
 #endif
 
-#ifdef __always_inline__read_lock_irq
+#ifdef CONFIG_INLINE_READ_LOCK_IRQ
 #define _read_lock_irq(lock) __read_lock_irq(lock)
 #endif
 
-#ifdef __always_inline__write_lock_irq
+#ifdef CONFIG_INLINE_WRITE_LOCK_IRQ
 #define _write_lock_irq(lock) __write_lock_irq(lock)
 #endif
 
-#ifdef __always_inline__spin_lock_irqsave
+#ifdef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
 #define _spin_lock_irqsave(lock) __spin_lock_irqsave(lock)
 #endif
 
-#ifdef __always_inline__read_lock_irqsave
+#ifdef CONFIG_INLINE_READ_LOCK_IRQSAVE
 #define _read_lock_irqsave(lock) __read_lock_irqsave(lock)
 #endif
 
-#ifdef __always_inline__write_lock_irqsave
+#ifdef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
 #define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
 #endif
 
-#endif /* !CONFIG_GENERIC_LOCKBREAK */
-
-#ifdef __always_inline__spin_trylock
+#ifdef CONFIG_INLINE_SPIN_TRYLOCK
 #define _spin_trylock(lock) __spin_trylock(lock)
 #endif
 
-#ifdef __always_inline__read_trylock
+#ifdef CONFIG_INLINE_READ_TRYLOCK
 #define _read_trylock(lock) __read_trylock(lock)
 #endif
 
-#ifdef __always_inline__write_trylock
+#ifdef CONFIG_INLINE_WRITE_TRYLOCK
 #define _write_trylock(lock) __write_trylock(lock)
 #endif
 
-#ifdef __always_inline__spin_trylock_bh
+#ifdef CONFIG_INLINE_SPIN_TRYLOCK_BH
 #define _spin_trylock_bh(lock) __spin_trylock_bh(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock
+#ifdef CONFIG_INLINE_SPIN_UNLOCK
 #define _spin_unlock(lock) __spin_unlock(lock)
 #endif
 
-#ifdef __always_inline__read_unlock
+#ifdef CONFIG_INLINE_READ_UNLOCK
 #define _read_unlock(lock) __read_unlock(lock)
 #endif
 
-#ifdef __always_inline__write_unlock
+#ifdef CONFIG_INLINE_WRITE_UNLOCK
 #define _write_unlock(lock) __write_unlock(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock_bh
+#ifdef CONFIG_INLINE_SPIN_UNLOCK_BH
 #define _spin_unlock_bh(lock) __spin_unlock_bh(lock)
 #endif
 
-#ifdef __always_inline__read_unlock_bh
+#ifdef CONFIG_INLINE_READ_UNLOCK_BH
 #define _read_unlock_bh(lock) __read_unlock_bh(lock)
 #endif
 
-#ifdef __always_inline__write_unlock_bh
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_BH
 #define _write_unlock_bh(lock) __write_unlock_bh(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock_irq
+#ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQ
 #define _spin_unlock_irq(lock) __spin_unlock_irq(lock)
 #endif
 
-#ifdef __always_inline__read_unlock_irq
+#ifdef CONFIG_INLINE_READ_UNLOCK_IRQ
 #define _read_unlock_irq(lock) __read_unlock_irq(lock)
 #endif
 
-#ifdef __always_inline__write_unlock_irq
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQ
 #define _write_unlock_irq(lock) __write_unlock_irq(lock)
 #endif
 
-#ifdef __always_inline__spin_unlock_irqrestore
+#ifdef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
 #define _spin_unlock_irqrestore(lock, flags) __spin_unlock_irqrestore(lock, flags)
 #endif
 
-#ifdef __always_inline__read_unlock_irqrestore
+#ifdef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
 #define _read_unlock_irqrestore(lock, flags) __read_unlock_irqrestore(lock, flags)
 #endif
 
-#ifdef __always_inline__write_unlock_irqrestore
+#ifdef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
 #define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
 #endif
 
-#endif /* CONFIG_DEBUG_SPINLOCK */
-
 static inline int __spin_trylock(spinlock_t *lock)
 {
 	preempt_disable();
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -1210,3 +1210,4 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
+source "kernel/Kconfig.locks"
Index: linux-2.6/kernel/Kconfig.locks
===================================================================
--- /dev/null
+++ linux-2.6/kernel/Kconfig.locks
@@ -0,0 +1,199 @@
+#
+# The ARCH_INLINE foo is necessary because select ignores "depends on"
+#
+config ARCH_INLINE_SPIN_TRYLOCK
+	bool
+
+config ARCH_INLINE_SPIN_TRYLOCK_BH
+	bool
+
+config ARCH_INLINE_SPIN_LOCK
+	bool
+
+config ARCH_INLINE_SPIN_LOCK_BH
+	bool
+
+config ARCH_INLINE_SPIN_LOCK_IRQ
+	bool
+
+config ARCH_INLINE_SPIN_LOCK_IRQSAVE
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK_BH
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK_IRQ
+	bool
+
+config ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+	bool
+
+
+config ARCH_INLINE_READ_TRYLOCK
+	bool
+
+config ARCH_INLINE_READ_LOCK
+	bool
+
+config ARCH_INLINE_READ_LOCK_BH
+	bool
+
+config ARCH_INLINE_READ_LOCK_IRQ
+	bool
+
+config ARCH_INLINE_READ_LOCK_IRQSAVE
+	bool
+
+config ARCH_INLINE_READ_UNLOCK
+	bool
+
+config ARCH_INLINE_READ_UNLOCK_BH
+	bool
+
+config ARCH_INLINE_READ_UNLOCK_IRQ
+	bool
+
+config ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+	bool
+
+
+config ARCH_INLINE_WRITE_TRYLOCK
+	bool
+
+config ARCH_INLINE_WRITE_LOCK
+	bool
+
+config ARCH_INLINE_WRITE_LOCK_BH
+	bool
+
+config ARCH_INLINE_WRITE_LOCK_IRQ
+	bool
+
+config ARCH_INLINE_WRITE_LOCK_IRQSAVE
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK_BH
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK_IRQ
+	bool
+
+config ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	bool
+
+#
+# lock_* functions are inlined when:
+#   - DEBUG_SPINLOCK=n and GENERIC_LOCKBREAK=n and ARCH_INLINE_*LOCK=y
+#
+# trylock_* functions are inlined when:
+#   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
+#
+# unlock and unlock_irq functions are inlined when:
+#   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
+#  or
+#   - DEBUG_SPINLOCK=n and PREEMPT=n
+#
+# unlock_bh and unlock_irqrestore functions are inlined when:
+#   - DEBUG_SPINLOCK=n and ARCH_INLINE_*LOCK=y
+#
+
+config INLINE_SPIN_TRYLOCK
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK
+
+config INLINE_SPIN_TRYLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_TRYLOCK_BH
+
+config INLINE_SPIN_LOCK
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_SPIN_LOCK
+
+config INLINE_SPIN_LOCK_BH
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_SPIN_LOCK_BH
+
+config INLINE_SPIN_LOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_SPIN_LOCK_IRQ
+
+config INLINE_SPIN_LOCK_IRQSAVE
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_SPIN_LOCK_IRQSAVE
+
+config INLINE_SPIN_UNLOCK
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK)
+
+config INLINE_SPIN_UNLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_BH
+
+config INLINE_SPIN_UNLOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_SPIN_UNLOCK_BH)
+
+config INLINE_SPIN_UNLOCK_IRQRESTORE
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_SPIN_UNLOCK_IRQRESTORE
+
+
+config INLINE_READ_TRYLOCK
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_TRYLOCK
+
+config INLINE_READ_LOCK
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_READ_LOCK
+
+config INLINE_READ_LOCK_BH
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_READ_LOCK_BH
+
+config INLINE_READ_LOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_READ_LOCK_IRQ
+
+config INLINE_READ_LOCK_IRQSAVE
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_READ_LOCK_IRQSAVE
+
+config INLINE_READ_UNLOCK
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK)
+
+config INLINE_READ_UNLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_BH
+
+config INLINE_READ_UNLOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_READ_UNLOCK_BH)
+
+config INLINE_READ_UNLOCK_IRQRESTORE
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_READ_UNLOCK_IRQRESTORE
+
+
+config INLINE_WRITE_TRYLOCK
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_TRYLOCK
+
+config INLINE_WRITE_LOCK
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && ARCH_INLINE_WRITE_LOCK
+
+config INLINE_WRITE_LOCK_BH
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_WRITE_LOCK_BH
+
+config INLINE_WRITE_LOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_WRITE_LOCK_IRQ
+
+config INLINE_WRITE_LOCK_IRQSAVE
+	def_bool !DEBUG_SPINLOCK && !GENERIC_LOCKBREAK && \
+       		 ARCH_INLINE_WRITE_LOCK_IRQSAVE
+
+config INLINE_WRITE_UNLOCK
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK)
+
+config INLINE_WRITE_UNLOCK_BH
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_BH
+
+config INLINE_WRITE_UNLOCK_IRQ
+	def_bool !DEBUG_SPINLOCK && (!PREEMPT || ARCH_INLINE_WRITE_UNLOCK_BH)
+
+config INLINE_WRITE_UNLOCK_IRQRESTORE
+	def_bool !DEBUG_SPINLOCK && ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
Index: linux-2.6/kernel/spinlock.c
===================================================================
--- linux-2.6.orig/kernel/spinlock.c
+++ linux-2.6/kernel/spinlock.c
@@ -21,7 +21,7 @@
 #include <linux/debug_locks.h>
 #include <linux/module.h>
 
-#ifndef _spin_trylock
+#ifndef CONFIG_INLINE_SPIN_TRYLOCK
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
 	return __spin_trylock(lock);
@@ -29,7 +29,7 @@ int __lockfunc _spin_trylock(spinlock_t 
 EXPORT_SYMBOL(_spin_trylock);
 #endif
 
-#ifndef _read_trylock
+#ifndef CONFIG_INLINE_READ_TRYLOCK
 int __lockfunc _read_trylock(rwlock_t *lock)
 {
 	return __read_trylock(lock);
@@ -37,7 +37,7 @@ int __lockfunc _read_trylock(rwlock_t *l
 EXPORT_SYMBOL(_read_trylock);
 #endif
 
-#ifndef _write_trylock
+#ifndef CONFIG_INLINE_WRITE_TRYLOCK
 int __lockfunc _write_trylock(rwlock_t *lock)
 {
 	return __write_trylock(lock);
@@ -52,7 +52,7 @@ EXPORT_SYMBOL(_write_trylock);
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
-#ifndef _read_lock
+#ifndef CONFIG_INLINE_READ_LOCK
 void __lockfunc _read_lock(rwlock_t *lock)
 {
 	__read_lock(lock);
@@ -60,7 +60,7 @@ void __lockfunc _read_lock(rwlock_t *loc
 EXPORT_SYMBOL(_read_lock);
 #endif
 
-#ifndef _spin_lock_irqsave
+#ifndef CONFIG_INLINE_SPIN_LOCK_IRQSAVE
 unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 {
 	return __spin_lock_irqsave(lock);
@@ -68,7 +68,7 @@ unsigned long __lockfunc _spin_lock_irqs
 EXPORT_SYMBOL(_spin_lock_irqsave);
 #endif
 
-#ifndef _spin_lock_irq
+#ifndef CONFIG_INLINE_SPIN_LOCK_IRQ
 void __lockfunc _spin_lock_irq(spinlock_t *lock)
 {
 	__spin_lock_irq(lock);
@@ -76,7 +76,7 @@ void __lockfunc _spin_lock_irq(spinlock_
 EXPORT_SYMBOL(_spin_lock_irq);
 #endif
 
-#ifndef _spin_lock_bh
+#ifndef CONFIG_INLINE_SPIN_LOCK_BH
 void __lockfunc _spin_lock_bh(spinlock_t *lock)
 {
 	__spin_lock_bh(lock);
@@ -84,7 +84,7 @@ void __lockfunc _spin_lock_bh(spinlock_t
 EXPORT_SYMBOL(_spin_lock_bh);
 #endif
 
-#ifndef _read_lock_irqsave
+#ifndef CONFIG_INLINE_READ_LOCK_IRQSAVE
 unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
 {
 	return __read_lock_irqsave(lock);
@@ -92,7 +92,7 @@ unsigned long __lockfunc _read_lock_irqs
 EXPORT_SYMBOL(_read_lock_irqsave);
 #endif
 
-#ifndef _read_lock_irq
+#ifndef CONFIG_INLINE_READ_LOCK_IRQ
 void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
 	__read_lock_irq(lock);
@@ -100,7 +100,7 @@ void __lockfunc _read_lock_irq(rwlock_t 
 EXPORT_SYMBOL(_read_lock_irq);
 #endif
 
-#ifndef _read_lock_bh
+#ifndef CONFIG_INLINE_READ_LOCK_BH
 void __lockfunc _read_lock_bh(rwlock_t *lock)
 {
 	__read_lock_bh(lock);
@@ -108,7 +108,7 @@ void __lockfunc _read_lock_bh(rwlock_t *
 EXPORT_SYMBOL(_read_lock_bh);
 #endif
 
-#ifndef _write_lock_irqsave
+#ifndef CONFIG_INLINE_WRITE_LOCK_IRQSAVE
 unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
 {
 	return __write_lock_irqsave(lock);
@@ -116,7 +116,7 @@ unsigned long __lockfunc _write_lock_irq
 EXPORT_SYMBOL(_write_lock_irqsave);
 #endif
 
-#ifndef _write_lock_irq
+#ifndef CONFIG_INLINE_WRITE_LOCK_IRQ
 void __lockfunc _write_lock_irq(rwlock_t *lock)
 {
 	__write_lock_irq(lock);
@@ -124,7 +124,7 @@ void __lockfunc _write_lock_irq(rwlock_t
 EXPORT_SYMBOL(_write_lock_irq);
 #endif
 
-#ifndef _write_lock_bh
+#ifndef CONFIG_INLINE_WRITE_LOCK_BH
 void __lockfunc _write_lock_bh(rwlock_t *lock)
 {
 	__write_lock_bh(lock);
@@ -132,7 +132,7 @@ void __lockfunc _write_lock_bh(rwlock_t 
 EXPORT_SYMBOL(_write_lock_bh);
 #endif
 
-#ifndef _spin_lock
+#ifndef CONFIG_INLINE_SPIN_LOCK
 void __lockfunc _spin_lock(spinlock_t *lock)
 {
 	__spin_lock(lock);
@@ -140,7 +140,7 @@ void __lockfunc _spin_lock(spinlock_t *l
 EXPORT_SYMBOL(_spin_lock);
 #endif
 
-#ifndef _write_lock
+#ifndef CONFIG_INLINE_WRITE_LOCK
 void __lockfunc _write_lock(rwlock_t *lock)
 {
 	__write_lock(lock);
@@ -272,7 +272,7 @@ EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
-#ifndef _spin_unlock
+#ifndef CONFIG_INLINE_SPIN_UNLOCK
 void __lockfunc _spin_unlock(spinlock_t *lock)
 {
 	__spin_unlock(lock);
@@ -280,7 +280,7 @@ void __lockfunc _spin_unlock(spinlock_t 
 EXPORT_SYMBOL(_spin_unlock);
 #endif
 
-#ifndef _write_unlock
+#ifndef CONFIG_INLINE_WRITE_UNLOCK
 void __lockfunc _write_unlock(rwlock_t *lock)
 {
 	__write_unlock(lock);
@@ -288,7 +288,7 @@ void __lockfunc _write_unlock(rwlock_t *
 EXPORT_SYMBOL(_write_unlock);
 #endif
 
-#ifndef _read_unlock
+#ifndef CONFIG_INLINE_READ_UNLOCK
 void __lockfunc _read_unlock(rwlock_t *lock)
 {
 	__read_unlock(lock);
@@ -296,7 +296,7 @@ void __lockfunc _read_unlock(rwlock_t *l
 EXPORT_SYMBOL(_read_unlock);
 #endif
 
-#ifndef _spin_unlock_irqrestore
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE
 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
 	__spin_unlock_irqrestore(lock, flags);
@@ -304,7 +304,7 @@ void __lockfunc _spin_unlock_irqrestore(
 EXPORT_SYMBOL(_spin_unlock_irqrestore);
 #endif
 
-#ifndef _spin_unlock_irq
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_IRQ
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
 	__spin_unlock_irq(lock);
@@ -312,7 +312,7 @@ void __lockfunc _spin_unlock_irq(spinloc
 EXPORT_SYMBOL(_spin_unlock_irq);
 #endif
 
-#ifndef _spin_unlock_bh
+#ifndef CONFIG_INLINE_SPIN_UNLOCK_BH
 void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 {
 	__spin_unlock_bh(lock);
@@ -320,7 +320,7 @@ void __lockfunc _spin_unlock_bh(spinlock
 EXPORT_SYMBOL(_spin_unlock_bh);
 #endif
 
-#ifndef _read_unlock_irqrestore
+#ifndef CONFIG_INLINE_READ_UNLOCK_IRQRESTORE
 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__read_unlock_irqrestore(lock, flags);
@@ -328,7 +328,7 @@ void __lockfunc _read_unlock_irqrestore(
 EXPORT_SYMBOL(_read_unlock_irqrestore);
 #endif
 
-#ifndef _read_unlock_irq
+#ifndef CONFIG_INLINE_READ_UNLOCK_IRQ
 void __lockfunc _read_unlock_irq(rwlock_t *lock)
 {
 	__read_unlock_irq(lock);
@@ -336,7 +336,7 @@ void __lockfunc _read_unlock_irq(rwlock_
 EXPORT_SYMBOL(_read_unlock_irq);
 #endif
 
-#ifndef _read_unlock_bh
+#ifndef CONFIG_INLINE_READ_UNLOCK_BH
 void __lockfunc _read_unlock_bh(rwlock_t *lock)
 {
 	__read_unlock_bh(lock);
@@ -344,7 +344,7 @@ void __lockfunc _read_unlock_bh(rwlock_t
 EXPORT_SYMBOL(_read_unlock_bh);
 #endif
 
-#ifndef _write_unlock_irqrestore
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__write_unlock_irqrestore(lock, flags);
@@ -352,7 +352,7 @@ void __lockfunc _write_unlock_irqrestore
 EXPORT_SYMBOL(_write_unlock_irqrestore);
 #endif
 
-#ifndef _write_unlock_irq
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_IRQ
 void __lockfunc _write_unlock_irq(rwlock_t *lock)
 {
 	__write_unlock_irq(lock);
@@ -360,7 +360,7 @@ void __lockfunc _write_unlock_irq(rwlock
 EXPORT_SYMBOL(_write_unlock_irq);
 #endif
 
-#ifndef _write_unlock_bh
+#ifndef CONFIG_INLINE_WRITE_UNLOCK_BH
 void __lockfunc _write_unlock_bh(rwlock_t *lock)
 {
 	__write_unlock_bh(lock);
@@ -368,7 +368,7 @@ void __lockfunc _write_unlock_bh(rwlock_
 EXPORT_SYMBOL(_write_unlock_bh);
 #endif
 
-#ifndef _spin_trylock_bh
+#ifndef CONFIG_INLINE_SPIN_TRYLOCK_BH
 int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
 	return __spin_trylock_bh(lock);


