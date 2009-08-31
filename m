Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZHaRIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZHaRIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 13:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbZHaRIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 13:08:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:32934 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZHaRIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 13:08:37 -0400
Date: Mon, 31 Aug 2009 17:07:54 GMT
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
In-Reply-To: <20090831124417.859022429@de.ibm.com>
References: <20090831124417.859022429@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking: Move spinlock function bodies to header file
Message-ID: <tip-69d0ee7377eef808e34ba5542b554ec97244b871@git.kernel.org>
Git-Commit-ID: 69d0ee7377eef808e34ba5542b554ec97244b871
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 31 Aug 2009 17:07:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  69d0ee7377eef808e34ba5542b554ec97244b871
Gitweb:     http://git.kernel.org/tip/69d0ee7377eef808e34ba5542b554ec97244b871
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Mon, 31 Aug 2009 14:43:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 31 Aug 2009 18:08:50 +0200

locking: Move spinlock function bodies to header file

Move spinlock function bodies to header file by creating a
static inline version of each variant. Use the inline version
on the out-of-line code.

This shouldn't make any difference besides that the spinlock
code can now be used to generate inlined spinlock code.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
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
LKML-Reference: <20090831124417.859022429@de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/spinlock.h         |   18 ++--
 include/linux/spinlock_api_smp.h |  263 ++++++++++++++++++++++++++++++++++++++
 kernel/spinlock.c                |  174 ++++---------------------
 3 files changed, 300 insertions(+), 155 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 4be57ab..da76a06 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -143,15 +143,6 @@ static inline void smp_mb__after_lock(void) { smp_mb(); }
  */
 #define spin_unlock_wait(lock)	__raw_spin_unlock_wait(&(lock)->raw_lock)
 
-/*
- * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
- */
-#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
-# include <linux/spinlock_api_smp.h>
-#else
-# include <linux/spinlock_api_up.h>
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK
  extern void _raw_spin_lock(spinlock_t *lock);
 #define _raw_spin_lock_flags(lock, flags) _raw_spin_lock(lock)
@@ -380,4 +371,13 @@ extern int _atomic_dec_and_lock(atomic_t *atomic, spinlock_t *lock);
  */
 #define spin_can_lock(lock)	(!spin_is_locked(lock))
 
+/*
+ * Pull the _spin_*()/_read_*()/_write_*() functions/declarations:
+ */
+#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
+# include <linux/spinlock_api_smp.h>
+#else
+# include <linux/spinlock_api_up.h>
+#endif
+
 #endif /* __LINUX_SPINLOCK_H */
diff --git a/include/linux/spinlock_api_smp.h b/include/linux/spinlock_api_smp.h
index d79845d..6b108f5 100644
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -60,4 +60,267 @@ void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 							__releases(lock);
 
+static inline int __spin_trylock(spinlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_spin_trylock(lock)) {
+		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline int __read_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_read_trylock(lock)) {
+		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+static inline int __write_trylock(rwlock_t *lock)
+{
+	preempt_disable();
+	if (_raw_write_trylock(lock)) {
+		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable();
+	return 0;
+}
+
+/*
+ * If lockdep is enabled then we use the non-preemption spin-ops
+ * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
+ * not re-enabled during lock-acquire (which the preempt-spin-ops do):
+ */
+#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
+
+static inline void __read_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __spin_lock_irqsave(spinlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	/*
+	 * On lockdep we dont want the hand-coded irq-enable of
+	 * _raw_spin_lock_flags() code, because lockdep assumes
+	 * that interrupts are not re-enabled during lock-acquire:
+	 */
+#ifdef CONFIG_LOCKDEP
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+#else
+	_raw_spin_lock_flags(lock, &flags);
+#endif
+	return flags;
+}
+
+static inline void __spin_lock_irq(spinlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline void __spin_lock_bh(spinlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline unsigned long __read_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
+			     _raw_read_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __read_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline void __read_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+}
+
+static inline unsigned long __write_lock_irqsave(rwlock_t *lock)
+{
+	unsigned long flags;
+
+	local_irq_save(flags);
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
+			     _raw_write_lock_flags, &flags);
+	return flags;
+}
+
+static inline void __write_lock_irq(rwlock_t *lock)
+{
+	local_irq_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __write_lock_bh(rwlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+static inline void __spin_lock(spinlock_t *lock)
+{
+	preempt_disable();
+	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+}
+
+static inline void __write_lock(rwlock_t *lock)
+{
+	preempt_disable();
+	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
+	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+}
+
+#endif /* CONFIG_PREEMPT */
+
+static inline void __spin_unlock(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __write_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __read_unlock(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable();
+}
+
+static inline void __spin_unlock_irqrestore(spinlock_t *lock,
+					    unsigned long flags)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __spin_unlock_irq(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __spin_unlock_bh(spinlock_t *lock)
+{
+	spin_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_spin_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline void __read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __read_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __read_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_read_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline void __write_unlock_irqrestore(rwlock_t *lock,
+					     unsigned long flags)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_restore(flags);
+	preempt_enable();
+}
+
+static inline void __write_unlock_irq(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	local_irq_enable();
+	preempt_enable();
+}
+
+static inline void __write_unlock_bh(rwlock_t *lock)
+{
+	rwlock_release(&lock->dep_map, 1, _RET_IP_);
+	_raw_write_unlock(lock);
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+}
+
+static inline int __spin_trylock_bh(spinlock_t *lock)
+{
+	local_bh_disable();
+	preempt_disable();
+	if (_raw_spin_trylock(lock)) {
+		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
+		return 1;
+	}
+	preempt_enable_no_resched();
+	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	return 0;
+}
+
 #endif /* __LINUX_SPINLOCK_API_SMP_H */
diff --git a/kernel/spinlock.c b/kernel/spinlock.c
index 7932653..2c000f5 100644
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -23,40 +23,19 @@
 
 int __lockfunc _spin_trylock(spinlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-	
-	preempt_enable();
-	return 0;
+	return __spin_trylock(lock);
 }
 EXPORT_SYMBOL(_spin_trylock);
 
 int __lockfunc _read_trylock(rwlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_read_trylock(lock)) {
-		rwlock_acquire_read(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable();
-	return 0;
+	return __read_trylock(lock);
 }
 EXPORT_SYMBOL(_read_trylock);
 
 int __lockfunc _write_trylock(rwlock_t *lock)
 {
-	preempt_disable();
-	if (_raw_write_trylock(lock)) {
-		rwlock_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable();
-	return 0;
+	return __write_trylock(lock);
 }
 EXPORT_SYMBOL(_write_trylock);
 
@@ -69,129 +48,74 @@ EXPORT_SYMBOL(_write_trylock);
 
 void __lockfunc _read_lock(rwlock_t *lock)
 {
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock(lock);
 }
 EXPORT_SYMBOL(_read_lock);
 
 unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	/*
-	 * On lockdep we dont want the hand-coded irq-enable of
-	 * _raw_spin_lock_flags() code, because lockdep assumes
-	 * that interrupts are not re-enabled during lock-acquire:
-	 */
-#ifdef CONFIG_LOCKDEP
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
-#else
-	_raw_spin_lock_flags(lock, &flags);
-#endif
-	return flags;
+	return __spin_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irqsave);
 
 void __lockfunc _spin_lock_irq(spinlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_lock_irq);
 
 void __lockfunc _spin_lock_bh(spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_lock_bh);
 
 unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_read_trylock, _raw_read_lock,
-			     _raw_read_lock_flags, &flags);
-	return flags;
+	return __read_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_read_lock_irqsave);
 
 void __lockfunc _read_lock_irq(rwlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock_irq(lock);
 }
 EXPORT_SYMBOL(_read_lock_irq);
 
 void __lockfunc _read_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire_read(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_read_trylock, _raw_read_lock);
+	__read_lock_bh(lock);
 }
 EXPORT_SYMBOL(_read_lock_bh);
 
 unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
-
-	local_irq_save(flags);
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED_FLAGS(lock, _raw_write_trylock, _raw_write_lock,
-			     _raw_write_lock_flags, &flags);
-	return flags;
+	return __write_lock_irqsave(lock);
 }
 EXPORT_SYMBOL(_write_lock_irqsave);
 
 void __lockfunc _write_lock_irq(rwlock_t *lock)
 {
-	local_irq_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock_irq(lock);
 }
 EXPORT_SYMBOL(_write_lock_irq);
 
 void __lockfunc _write_lock_bh(rwlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock_bh(lock);
 }
 EXPORT_SYMBOL(_write_lock_bh);
 
 void __lockfunc _spin_lock(spinlock_t *lock)
 {
-	preempt_disable();
-	spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
+	__spin_lock(lock);
 }
-
 EXPORT_SYMBOL(_spin_lock);
 
 void __lockfunc _write_lock(rwlock_t *lock)
 {
-	preempt_disable();
-	rwlock_acquire(&lock->dep_map, 0, 0, _RET_IP_);
-	LOCK_CONTENDED(lock, _raw_write_trylock, _raw_write_lock);
+	__write_lock(lock);
 }
-
 EXPORT_SYMBOL(_write_lock);
 
 #else /* CONFIG_PREEMPT: */
@@ -320,121 +244,79 @@ EXPORT_SYMBOL(_spin_lock_nest_lock);
 
 void __lockfunc _spin_unlock(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	preempt_enable();
+	__spin_unlock(lock);
 }
 EXPORT_SYMBOL(_spin_unlock);
 
 void __lockfunc _write_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable();
+	__write_unlock(lock);
 }
 EXPORT_SYMBOL(_write_unlock);
 
 void __lockfunc _read_unlock(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable();
+	__read_unlock(lock);
 }
 EXPORT_SYMBOL(_read_unlock);
 
 void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__spin_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_spin_unlock_irqrestore);
 
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__spin_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_irq);
 
 void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 {
-	spin_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_spin_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__spin_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_unlock_bh);
 
 void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__read_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_read_unlock_irqrestore);
 
 void __lockfunc _read_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__read_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_read_unlock_irq);
 
 void __lockfunc _read_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_read_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__read_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_read_unlock_bh);
 
 void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_restore(flags);
-	preempt_enable();
+	__write_unlock_irqrestore(lock, flags);
 }
 EXPORT_SYMBOL(_write_unlock_irqrestore);
 
 void __lockfunc _write_unlock_irq(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	local_irq_enable();
-	preempt_enable();
+	__write_unlock_irq(lock);
 }
 EXPORT_SYMBOL(_write_unlock_irq);
 
 void __lockfunc _write_unlock_bh(rwlock_t *lock)
 {
-	rwlock_release(&lock->dep_map, 1, _RET_IP_);
-	_raw_write_unlock(lock);
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
+	__write_unlock_bh(lock);
 }
 EXPORT_SYMBOL(_write_unlock_bh);
 
 int __lockfunc _spin_trylock_bh(spinlock_t *lock)
 {
-	local_bh_disable();
-	preempt_disable();
-	if (_raw_spin_trylock(lock)) {
-		spin_acquire(&lock->dep_map, 0, 1, _RET_IP_);
-		return 1;
-	}
-
-	preempt_enable_no_resched();
-	local_bh_enable_ip((unsigned long)__builtin_return_address(0));
-	return 0;
+	return __spin_trylock_bh(lock);
 }
 EXPORT_SYMBOL(_spin_trylock_bh);
 
