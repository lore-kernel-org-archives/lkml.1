Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZHaRI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZHaRI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZHaRI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:08:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:32955 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbZHaRIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:08:53 -0400
Date: Mon, 31 Aug 2009 17:08:07 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: mingo@redhat.com, torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       schwidefsky@de.ibm.com, ehrhardt@linux.vnet.ibm.com, arnd@arndb.de,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       zippel@linux-m68k.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com, paulus@samba.org, horsth@linux.vnet.ibm.com,
       davem@davemloft.net, benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, mingo@elte.hu, nickpiggin@yahoo.com.au
Reply-To: mingo@redhat.com, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, schwidefsky@de.ibm.com,
       ehrhardt@linux.vnet.ibm.com, arnd@arndb.de, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, tglx@linutronix.de, zippel@linux-m68k.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, paulus@samba.org,
       horsth@linux.vnet.ibm.com, davem@davemloft.net,
       benh@kernel.crashing.org, geert@linux-m68k.org,
       linux-arch@vger.kernel.org, nickpiggin@yahoo.com.au, mingo@elte.hu
In-Reply-To: <20090831124418.375299024@de.ibm.com>
References: <20090831124418.375299024@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Allow arch-inlined spinlocks
Message-ID: <tip-892a7c67c12da63fa4b51728bbe5b982356a090a@git.kernel.org>
Git-Commit-ID: 892a7c67c12da63fa4b51728bbe5b982356a090a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 17:08:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  892a7c67c12da63fa4b51728bbe5b982356a090a
Gitweb:     http://git.kernel.org/tip/892a7c67c12da63fa4b51728bbe5b982356a090a
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:37 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 18:08:50 +0200

locking: Allow arch-inlined spinlocks

This allows an architecture to specify per lock variant if the
locking code should be kept out-of-line or inlined.

If an architecure wants out-of-line locking code no change is
needed. To force inlining of e.g. spin_lock() the line:

  #define __always_inline__spin_lock

needs to be added to arch/<...>/include/asm/spinlock.h

If CONFIG_DEBUG_SPINLOCK or CONFIG_GENERIC_LOCKBREAK are
defined the per architecture defines are (partly) ignored and
still out-of-line spinlock code will be generated.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Horst Hartmann <horsth@linux.vnet.ibm.com>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: <linux-arch@vger.kernel.org>
LKML-Reference: <20090831124418.375299024@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/spinlock_api_smp.h |  119 ++++++++++++++++++++++++++++++++++++++
 kernel/spinlock.c                |   56 ++++++++++++++++++
 2 files changed, 175 insertions(+), 0 deletions(-)

diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index 6b108f5..1a411e3 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -60,6 +60,125 @@ void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
+#ifndef CONFIG_DEBUG_SPINLOCK
+#ifndef CONFIG_GENERIC_LOCKBREAK
+
+#ifdef __always_inline__spin_lock
+#define _spin_lock(lock) __spin_lock(lock)
+#endif
+
+#ifdef __always_inline__read_lock
+#define _read_lock(lock) __read_lock(lock)
+#endif
+
+#ifdef __always_inline__write_lock
+#define _write_lock(lock) __write_lock(lock)
+#endif
+
+#ifdef __always_inline__spin_lock_bh
+#define _spin_lock_bh(lock) __spin_lock_bh(lock)
+#endif
+
+#ifdef __always_inline__read_lock_bh
+#define _read_lock_bh(lock) __read_lock_bh(lock)
+#endif
+
+#ifdef __always_inline__write_lock_bh
+#define _write_lock_bh(lock) __write_lock_bh(lock)
+#endif
+
+#ifdef __always_inline__spin_lock_irq
+#define _spin_lock_irq(lock) __spin_lock_irq(lock)
+#endif
+
+#ifdef __always_inline__read_lock_irq
+#define _read_lock_irq(lock) __read_lock_irq(lock)
+#endif
+
+#ifdef __always_inline__write_lock_irq
+#define _write_lock_irq(lock) __write_lock_irq(lock)
+#endif
+
+#ifdef __always_inline__spin_lock_irqsave
+#define _spin_lock_irqsave(lock) __spin_lock_irqsave(lock)
+#endif
+
+#ifdef __always_inline__read_lock_irqsave
+#define _read_lock_irqsave(lock) __read_lock_irqsave(lock)
+#endif
+
+#ifdef __always_inline__write_lock_irqsave
+#define _write_lock_irqsave(lock) __write_lock_irqsave(lock)
+#endif
+
+#endif /* !CONFIG_GENERIC_LOCKBREAK */
+
+#ifdef __always_inline__spin_trylock
+#define _spin_trylock(lock) __spin_trylock(lock)
+#endif
+
+#ifdef __always_inline__read_trylock
+#define _read_trylock(lock) __read_trylock(lock)
+#endif
+
+#ifdef __always_inline__write_trylock
+#define _write_trylock(lock) __write_trylock(lock)
+#endif
+
+#ifdef __always_inline__spin_trylock_bh
+#define _spin_trylock_bh(lock) __spin_trylock_bh(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock
+#define _spin_unlock(lock) __spin_unlock(lock)
+#endif
+
+#ifdef __always_inline__read_unlock
+#define _read_unlock(lock) __read_unlock(lock)
+#endif
+
+#ifdef __always_inline__write_unlock
+#define _write_unlock(lock) __write_unlock(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock_bh
+#define _spin_unlock_bh(lock) __spin_unlock_bh(lock)
+#endif
+
+#ifdef __always_inline__read_unlock_bh
+#define _read_unlock_bh(lock) __read_unlock_bh(lock)
+#endif
+
+#ifdef __always_inline__write_unlock_bh
+#define _write_unlock_bh(lock) __write_unlock_bh(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock_irq
+#define _spin_unlock_irq(lock) __spin_unlock_irq(lock)
+#endif
+
+#ifdef __always_inline__read_unlock_irq
+#define _read_unlock_irq(lock) __read_unlock_irq(lock)
+#endif
+
+#ifdef __always_inline__write_unlock_irq
+#define _write_unlock_irq(lock) __write_unlock_irq(lock)
+#endif
+
+#ifdef __always_inline__spin_unlock_irqrestore
+#define _spin_unlock_irqrestore(lock, flags) __spin_unlock_irqrestore(lock, flags)
+#endif
+
+#ifdef __always_inline__read_unlock_irqrestore
+#define _read_unlock_irqrestore(lock, flags) __read_unlock_irqrestore(lock, flags)
+#endif
+
+#ifdef __always_inline__write_unlock_irqrestore
+#define _write_unlock_irqrestore(lock, flags) __write_unlock_irqrestore(lock, flags)
+#endif
+
+#endif /* CONFIG_DEBUG_SPINLOCK */
+
 static inline int __spin_trylock(spinlock_t *lock)
 {
 	preempt_disable();
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 2c000f5..5ddab73 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -21,23 +21,29 @@
 #include <linux/debug_locks.h>
 #include <linux/module.h>
 
+#ifndef _spin_trylock
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
 	return __spin_trylock(lock);
 }
 EXPORT_SYMBOL(_spin_trylock);
+#endif
 
+#ifndef _read_trylock
 int __lockfunc _read_trylock(rwlock_t *lock)
 {
 	return __read_trylock(lock);
 }
 EXPORT_SYMBOL(_read_trylock);
+#endif
 
+#ifndef _write_trylock
 int __lockfunc _write_trylock(rwlock_t *lock)
 {
 	return __write_trylock(lock);
 }
 EXPORT_SYMBOL(_write_trylock);
+#endif
 
 /*
  * If lockdep is enabled then we use the non-preemption spin-ops
@@ -46,77 +52,101 @@ EXPORT_SYMBOL(_write_trylock);
  */
 #if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
+#ifndef _read_lock
 void __lockfunc _read_lock(rwlock_t *lock)
 {
 	__read_lock(lock);
 }
 EXPORT_SYMBOL(_read_lock);
+#endif
 
+#ifndef _spin_lock_irqsave
 unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 {
 	return __spin_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irqsave);
+#endif
 
+#ifndef _spin_lock_irq
 void __lockfunc _spin_lock_irq(spinlock_t *lock)
 {
 	__spin_lock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irq);
+#endif
 
+#ifndef _spin_lock_bh
 void __lockfunc _spin_lock_bh(spinlock_t *lock)
 {
 	__spin_lock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_lock_bh);
+#endif
 
+#ifndef _read_lock_irqsave
 unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
 {
 	return __read_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
+#endif
 
+#ifndef _read_lock_irq
 void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
 	__read_lock_irq(lock);
 }
 EXPORT_SYMBOL(_read_lock_irq);
+#endif
 
+#ifndef _read_lock_bh
 void __lockfunc _read_lock_bh(rwlock_t *lock)
 {
 	__read_lock_bh(lock);
 }
 EXPORT_SYMBOL(_read_lock_bh);
+#endif
 
+#ifndef _write_lock_irqsave
 unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
 {
 	return __write_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
+#endif
 
+#ifndef _write_lock_irq
 void __lockfunc _write_lock_irq(rwlock_t *lock)
 {
 	__write_lock_irq(lock);
 }
 EXPORT_SYMBOL(_write_lock_irq);
+#endif
 
+#ifndef _write_lock_bh
 void __lockfunc _write_lock_bh(rwlock_t *lock)
 {
 	__write_lock_bh(lock);
 }
 EXPORT_SYMBOL(_write_lock_bh);
+#endif
 
+#ifndef _spin_lock
 void __lockfunc _spin_lock(spinlock_t *lock)
 {
 	__spin_lock(lock);
 }
 EXPORT_SYMBOL(_spin_lock);
+#endif
 
+#ifndef _write_lock
 void __lockfunc _write_lock(rwlock_t *lock)
 {
 	__write_lock(lock);
 }
 EXPORT_SYMBOL(_write_lock);
+#endif
 
 #else /* CONFIG_PREEMPT: */
 
@@ -242,83 +272,109 @@ EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 #endif
 
+#ifndef _spin_unlock
 void __lockfunc _spin_unlock(spinlock_t *lock)
 {
 	__spin_unlock(lock);
 }
 EXPORT_SYMBOL(_spin_unlock);
+#endif
 
+#ifndef _write_unlock
 void __lockfunc _write_unlock(rwlock_t *lock)
 {
 	__write_unlock(lock);
 }
 EXPORT_SYMBOL(_write_unlock);
+#endif
 
+#ifndef _read_unlock
 void __lockfunc _read_unlock(rwlock_t *lock)
 {
 	__read_unlock(lock);
 }
 EXPORT_SYMBOL(_read_unlock);
+#endif
 
+#ifndef _spin_unlock_irqrestore
 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
 	__spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_spin_unlock_irqrestore);
+#endif
 
+#ifndef _spin_unlock_irq
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
 	__spin_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_irq);
+#endif
 
+#ifndef _spin_unlock_bh
 void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 {
 	__spin_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_bh);
+#endif
 
+#ifndef _read_unlock_irqrestore
 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__read_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_read_unlock_irqrestore);
+#endif
 
+#ifndef _read_unlock_irq
 void __lockfunc _read_unlock_irq(rwlock_t *lock)
 {
 	__read_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_read_unlock_irq);
+#endif
 
+#ifndef _read_unlock_bh
 void __lockfunc _read_unlock_bh(rwlock_t *lock)
 {
 	__read_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_read_unlock_bh);
+#endif
 
+#ifndef _write_unlock_irqrestore
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
 	__write_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_write_unlock_irqrestore);
+#endif
 
+#ifndef _write_unlock_irq
 void __lockfunc _write_unlock_irq(rwlock_t *lock)
 {
 	__write_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_write_unlock_irq);
+#endif
 
+#ifndef _write_unlock_bh
 void __lockfunc _write_unlock_bh(rwlock_t *lock)
 {
 	__write_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_write_unlock_bh);
+#endif
 
+#ifndef _spin_trylock_bh
 int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
 	return __spin_trylock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_trylock_bh);
+#endif
 
 notrace int in_lock_functions(unsigned long addr)
 {
