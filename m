Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbZHJIPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbZHJIPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 04:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZHJIPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 04:15:51 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:34509 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZHJIPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 04:15:50 -0400
Date: Mon, 10 Aug 2009 10:15:39 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>,
       Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [Patch/RFC 3/4] spinlock: allow inlined spinlocks
Message-ID: <20090810081539.GC31234@osiris.boeblingen.de.ibm.com>
References: <20090810081324.GA30276@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090810081324.GA30276@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

This patch adds a new Kconfig entry that allows to have inline spinlock
code instead of the out of line version we have currently.
In order to allow inline spinlocks an architecture must select
HAVE_SPINLOCK_INLINE_SUPPORT since it looks like some architectures
make special assumption on the stack layout.

The conversion is quite trivial:

A standard spinlock function like this

void __lockfunc _spin_lock(spinlock_t *lock)
{
...
}
EXPORT_SYMBOL(_spin_lock);

gets converted to

LOCKFUNC void _spin_lock(spinlock_t *lock)
{
...
}
SPIN_EXPORT_SYMBOL(_spin_lock);

where LOCKFUNC and SPIN_EXPORT_SYMBOL get expanded dependent
on CONFIG_SPINLOCK_INLINE:

#ifdef CONFIG_SPINLOCK_INLINE

#define LOCKFUNC		 static inline
#define SPIN_EXPORT_SYMBOL(func)

#else /* CONFIG_SPINLOCK_INLINE */

#define LOCKFUNC		 __lockfunc
#define SPIN_EXPORT_SYMBOL(func) EXPORT_SYMBOL(func)

#endif /* CONFIG_SPINLOCK_INLINE */

In case CONFIG_SPINLOCK_INLINE is not set the header file will be used only
by kernel/spinlock.c and the usual C functions will be generated.
Otherwise normal inline functions will be generated.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/spinlock_api_smp.h |   11 ++
 include/linux/spinlock_smp.h     |  160 ++++++++++++++++++++-------------------
 kernel/spinlock.c                |    2 
 lib/Kconfig.debug                |   14 +++
 4 files changed, 109 insertions(+), 78 deletions(-)

Index: linux-2.6/include/linux/spinlock_smp.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_smp.h
+++ linux-2.6/include/linux/spinlock_smp.h
@@ -1,7 +1,7 @@
 #ifndef __LINUX_SPINLOCK_SMP_H
 #define __LINUX_SPINLOCK_SMP_H
 
-#if !defined(IN_SPINLOCK_C)
+#if !defined(IN_SPINLOCK_C) && !defined(__LINUX_SPINLOCK_API_SMP_H)
 # error "please don't include this file directly"
 #endif
 
@@ -17,7 +17,19 @@
  *
  */
 
-int __lockfunc _spin_trylock(spinlock_t *lock)
+#ifdef CONFIG_SPINLOCK_INLINE
+
+#define LOCKFUNC		 static inline
+#define SPIN_EXPORT_SYMBOL(func)
+
+#else /* CONFIG_SPINLOCK_INLINE */
+
+#define LOCKFUNC		 __lockfunc
+#define SPIN_EXPORT_SYMBOL(func) EXPORT_SYMBOL(func)
+
+#endif /* CONFIG_SPINLOCK_INLINE */
+
+LOCKFUNC int _spin_trylock(spinlock_t *lock)
 {
 	preempt_disable();
 	if (_raw_spin_trylock(lock)) {
@@ -28,9 +40,9 @@ int __lockfunc _spin_trylock(spinlock_t 
 	preempt_enable();
 	return 0;
 }
-EXPORT_SYMBOL(_spin_trylock);
+SPIN_EXPORT_SYMBOL(_spin_trylock);
 
-int __lockfunc _read_trylock(rwlock_t *lock)
+LOCKFUNC int _read_trylock(rwlock_t *lock)
 {
 	preempt_disable();
 	if (_raw_read_trylock(lock)) {
@@ -41,9 +53,9 @@ int __lockfunc _read_trylock(rwlock_t *l
 	preempt_enable();
 	return 0;
 }
-EXPORT_SYMBOL(_read_trylock);
+SPIN_EXPORT_SYMBOL(_read_trylock);
 
-int __lockfunc _write_trylock(rwlock_t *lock)
+LOCKFUNC int _write_trylock(rwlock_t *lock)
 {
 	preempt_disable();
 	if (_raw_write_trylock(lock)) {
@@ -54,7 +66,7 @@ int __lockfunc _write_trylock(rwlock_t *
 	preempt_enable();
 	return 0;
 }
-EXPORT_SYMBOL(_write_trylock);
+SPIN_EXPORT_SYMBOL(_write_trylock);
 
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
@@ -63,15 +75,15 @@ EXPORT_SYMBOL(_write_trylock);
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
-void __lockfunc _read_lock(rwlock_t *lock)
+LOCKFUNC void _read_lock(rwlock_t *lock)
 {
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
-EXPORT_SYMBOL(_read_lock);
+SPIN_EXPORT_SYMBOL(_read_lock);
 
-unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
+LOCKFUNC unsigned long _spin_lock_irqsave(spinlock_t *lock)
 {
 	unsigned long flags;
 
@@ -90,27 +102,27 @@ unsigned long __lockfunc _spin_lock_irqs
 #endif
 	return flags;
 }
-EXPORT_SYMBOL(_spin_lock_irqsave);
+SPIN_EXPORT_SYMBOL(_spin_lock_irqsave);
 
-void __lockfunc _spin_lock_irq(spinlock_t *lock)
+LOCKFUNC void _spin_lock_irq(spinlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-EXPORT_SYMBOL(_spin_lock_irq);
+SPIN_EXPORT_SYMBOL(_spin_lock_irq);
 
-void __lockfunc _spin_lock_bh(spinlock_t *lock)
+LOCKFUNC void _spin_lock_bh(spinlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-EXPORT_SYMBOL(_spin_lock_bh);
+SPIN_EXPORT_SYMBOL(_spin_lock_bh);
 
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
+LOCKFUNC unsigned long _read_lock_irqsave(rwlock_t *lock)
 {
 	unsigned long flags;
 
@@ -121,27 +133,27 @@ unsigned long __lockfunc _read_lock_irqs
 			     _raw_read_lock_flags, &flags);
 	return flags;
 }
-EXPORT_SYMBOL(_read_lock_irqsave);
+SPIN_EXPORT_SYMBOL(_read_lock_irqsave);
 
-void __lockfunc _read_lock_irq(rwlock_t *lock)
+LOCKFUNC void _read_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
-EXPORT_SYMBOL(_read_lock_irq);
+SPIN_EXPORT_SYMBOL(_read_lock_irq);
 
-void __lockfunc _read_lock_bh(rwlock_t *lock)
+LOCKFUNC void _read_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
 }
-EXPORT_SYMBOL(_read_lock_bh);
+SPIN_EXPORT_SYMBOL(_read_lock_bh);
 
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+LOCKFUNC unsigned long _write_lock_irqsave(rwlock_t *lock)
 {
 	unsigned long flags;
 
@@ -152,43 +164,43 @@ unsigned long __lockfunc _write_lock_irq
 			     _raw_write_lock_flags, &flags);
 	return flags;
 }
-EXPORT_SYMBOL(_write_lock_irqsave);
+SPIN_EXPORT_SYMBOL(_write_lock_irqsave);
 
-void __lockfunc _write_lock_irq(rwlock_t *lock)
+LOCKFUNC void _write_lock_irq(rwlock_t *lock)
 {
 	local_irq_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
-EXPORT_SYMBOL(_write_lock_irq);
+SPIN_EXPORT_SYMBOL(_write_lock_irq);
 
-void __lockfunc _write_lock_bh(rwlock_t *lock)
+LOCKFUNC void _write_lock_bh(rwlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
-EXPORT_SYMBOL(_write_lock_bh);
+SPIN_EXPORT_SYMBOL(_write_lock_bh);
 
-void __lockfunc _spin_lock(spinlock_t *lock)
+LOCKFUNC void _spin_lock(spinlock_t *lock)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
 
-EXPORT_SYMBOL(_spin_lock);
+SPIN_EXPORT_SYMBOL(_spin_lock);
 
-void __lockfunc _write_lock(rwlock_t *lock)
+LOCKFUNC void _write_lock(rwlock_t *lock)
 {
 	preempt_disable();
 	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
 }
 
-EXPORT_SYMBOL(_write_lock);
+SPIN_EXPORT_SYMBOL(_write_lock);
 
 #else /* CONFIG_PREEMPT: */
 
@@ -201,7 +213,7 @@ EXPORT_SYMBOL(_write_lock);
  */
 
 #define BUILD_LOCK_OPS(op, locktype)					\
-void __lockfunc _##op##_lock(locktype##_t *lock)			\
+LOCKFUNC void _##op##_lock(locktype##_t *lock)				\
 {									\
 	for (;;) {							\
 		preempt_disable();					\
@@ -216,10 +228,9 @@ void __lockfunc _##op##_lock(locktype##_
 	}								\
 	(lock)->break_lock = 0;						\
 }									\
+SPIN_EXPORT_SYMBOL(_##op##_lock);					\
 									\
-EXPORT_SYMBOL(_##op##_lock);						\
-									\
-unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)	\
+LOCKFUNC unsigned long _##op##_lock_irqsave(locktype##_t *lock)		\
 {									\
 	unsigned long flags;						\
 									\
@@ -239,17 +250,15 @@ unsigned long __lockfunc _##op##_lock_ir
 	(lock)->break_lock = 0;						\
 	return flags;							\
 }									\
+SPIN_EXPORT_SYMBOL(_##op##_lock_irqsave);				\
 									\
-EXPORT_SYMBOL(_##op##_lock_irqsave);					\
-									\
-void __lockfunc _##op##_lock_irq(locktype##_t *lock)			\
+LOCKFUNC void _##op##_lock_irq(locktype##_t *lock)			\
 {									\
 	_##op##_lock_irqsave(lock);					\
 }									\
+SPIN_EXPORT_SYMBOL(_##op##_lock_irq);					\
 									\
-EXPORT_SYMBOL(_##op##_lock_irq);					\
-									\
-void __lockfunc _##op##_lock_bh(locktype##_t *lock)			\
+LOCKFUNC void _##op##_lock_bh(locktype##_t *lock)			\
 {									\
 	unsigned long flags;						\
 									\
@@ -262,8 +271,7 @@ void __lockfunc _##op##_lock_bh(locktype
 	local_bh_disable();						\
 	local_irq_restore(flags);					\
 }									\
-									\
-EXPORT_SYMBOL(_##op##_lock_bh)
+SPIN_EXPORT_SYMBOL(_##op##_lock_bh)
 
 /*
  * Build preemption-friendly versions of the following
@@ -282,15 +290,15 @@ BUILD_LOCK_OPS(write, rwlock);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
-void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
+LOCKFUNC void _spin_lock_nested(spinlock_t *lock, int subclass)
 {
 	preempt_disable();
 	spin_acquire(&lock->dep_map, subclass, 0, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-EXPORT_SYMBOL(_spin_lock_nested);
+SPIN_EXPORT_SYMBOL(_spin_lock_nested);
 
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
+LOCKFUNC unsigned long _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
 {
 	unsigned long flags;
 
@@ -301,125 +309,125 @@ unsigned long __lockfunc _spin_lock_irqs
 				_raw_spin_lock_flags, &flags);
 	return flags;
 }
-EXPORT_SYMBOL(_spin_lock_irqsave_nested);
+SPIN_EXPORT_SYMBOL(_spin_lock_irqsave_nested);
 
-void __lockfunc _spin_lock_nest_lock(spinlock_t *lock,
-				     struct lockdep_map *nest_lock)
+LOCKFUNC void _spin_lock_nest_lock(spinlock_t *lock,
+				   struct lockdep_map *nest_lock)
 {
 	preempt_disable();
 	spin_acquire_nest(&lock->dep_map, 0, 0, nest_lock, _RET_IP_);
 	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
 }
-EXPORT_SYMBOL(_spin_lock_nest_lock);
+SPIN_EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
-void __lockfunc _spin_unlock(spinlock_t *lock)
+LOCKFUNC void _spin_unlock(spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	preempt_enable();
 }
-EXPORT_SYMBOL(_spin_unlock);
+SPIN_EXPORT_SYMBOL(_spin_unlock);
 
-void __lockfunc _write_unlock(rwlock_t *lock)
+LOCKFUNC void _write_unlock(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	preempt_enable();
 }
-EXPORT_SYMBOL(_write_unlock);
+SPIN_EXPORT_SYMBOL(_write_unlock);
 
-void __lockfunc _read_unlock(rwlock_t *lock)
+LOCKFUNC void _read_unlock(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	preempt_enable();
 }
-EXPORT_SYMBOL(_read_unlock);
+SPIN_EXPORT_SYMBOL(_read_unlock);
 
-void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+LOCKFUNC void _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
 }
-EXPORT_SYMBOL(_spin_unlock_irqrestore);
+SPIN_EXPORT_SYMBOL(_spin_unlock_irqrestore);
 
-void __lockfunc _spin_unlock_irq(spinlock_t *lock)
+LOCKFUNC void _spin_unlock_irq(spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
 }
-EXPORT_SYMBOL(_spin_unlock_irq);
+SPIN_EXPORT_SYMBOL(_spin_unlock_irq);
 
-void __lockfunc _spin_unlock_bh(spinlock_t *lock)
+LOCKFUNC void _spin_unlock_bh(spinlock_t *lock)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
-EXPORT_SYMBOL(_spin_unlock_bh);
+SPIN_EXPORT_SYMBOL(_spin_unlock_bh);
 
-void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+LOCKFUNC void _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
 }
-EXPORT_SYMBOL(_read_unlock_irqrestore);
+SPIN_EXPORT_SYMBOL(_read_unlock_irqrestore);
 
-void __lockfunc _read_unlock_irq(rwlock_t *lock)
+LOCKFUNC void _read_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
 }
-EXPORT_SYMBOL(_read_unlock_irq);
+SPIN_EXPORT_SYMBOL(_read_unlock_irq);
 
-void __lockfunc _read_unlock_bh(rwlock_t *lock)
+LOCKFUNC void _read_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
-EXPORT_SYMBOL(_read_unlock_bh);
+SPIN_EXPORT_SYMBOL(_read_unlock_bh);
 
-void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+LOCKFUNC void _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	local_irq_restore(flags);
 	preempt_enable();
 }
-EXPORT_SYMBOL(_write_unlock_irqrestore);
+SPIN_EXPORT_SYMBOL(_write_unlock_irqrestore);
 
-void __lockfunc _write_unlock_irq(rwlock_t *lock)
+LOCKFUNC void _write_unlock_irq(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	local_irq_enable();
 	preempt_enable();
 }
-EXPORT_SYMBOL(_write_unlock_irq);
+SPIN_EXPORT_SYMBOL(_write_unlock_irq);
 
-void __lockfunc _write_unlock_bh(rwlock_t *lock)
+LOCKFUNC void _write_unlock_bh(rwlock_t *lock)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
 	preempt_enable_no_resched();
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 }
-EXPORT_SYMBOL(_write_unlock_bh);
+SPIN_EXPORT_SYMBOL(_write_unlock_bh);
 
-int __lockfunc _spin_trylock_bh(spinlock_t *lock)
+LOCKFUNC int _spin_trylock_bh(spinlock_t *lock)
 {
 	local_bh_disable();
 	preempt_disable();
@@ -432,6 +440,6 @@ int __lockfunc _spin_trylock_bh(spinlock
 	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
 	return 0;
 }
-EXPORT_SYMBOL(_spin_trylock_bh);
+SPIN_EXPORT_SYMBOL(_spin_trylock_bh);
 
 #endif /* __LINUX_SPINLOCK_SMP_H */
Index: linux-2.6/include/linux/spinlock_api_smp.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_api_smp.h
+++ linux-2.6/include/linux/spinlock_api_smp.h
@@ -15,9 +15,11 @@
  * Released under the General Public License (GPL).
  */
 
-int in_lock_functions(unsigned long addr);
+#ifdef CONFIG_SPINLOCK_INLINE
 
-#define assert_spin_locked(x)	BUG_ON(!spin_is_locked(x))
+#include <linux/spinlock_smp.h>
+
+#else
 
 void __lockfunc _spin_lock(spinlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_nested(spinlock_t *lock, int subclass)
@@ -59,5 +61,10 @@ void __lockfunc _read_unlock_irqrestore(
 							__releases(lock);
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
+#endif
+
+int in_lock_functions(unsigned long addr);
+
+#define assert_spin_locked(x)	BUG_ON(!spin_is_locked(x))
 
 #endif /* __LINUX_SPINLOCK_API_SMP_H */
Index: linux-2.6/kernel/spinlock.c
===================================================================
--- linux-2.6.orig/kernel/spinlock.c
+++ linux-2.6/kernel/spinlock.c
@@ -26,7 +26,9 @@
 /*
  * Pull the spinlock/rwlock implementations.
  */
+#ifndef CONFIG_SPINLOCK_INLINE
 #include <linux/spinlock_smp.h>
+#endif
 
 notrace int in_lock_functions(unsigned long addr)
 {
Index: linux-2.6/lib/Kconfig.debug
===================================================================
--- linux-2.6.orig/lib/Kconfig.debug
+++ linux-2.6/lib/Kconfig.debug
@@ -879,6 +879,20 @@ config SYSCTL_SYSCALL_CHECK
 	  to properly maintain and use. This enables checks that help
 	  you to keep things correct.
 
+config HAVE_SPINLOCK_INLINE_SUPPORT
+	bool
+
+config SPINLOCK_INLINE
+	bool "Inline spinlock code"
+	depends on HAVE_SPINLOCK_INLINE_SUPPORT
+	depends on !DEBUG_SPINLOCK
+	depends on SMP
+	help
+	  Select this option if you want to have inline spinlocks instead of
+	  an out of line implementation.
+	  This will generate a larger kernel image. On some architectures this
+	  increases performance.
+
 source mm/Kconfig.debug
 source kernel/trace/Kconfig
 
