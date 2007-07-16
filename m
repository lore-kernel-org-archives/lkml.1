Return-Path: <linux-kernel-owner+w=401wt.eu-S1758944AbXGPE7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbXGPE7n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 00:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbXGPE7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 00:59:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbXGPE7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 00:59:35 -0400
Date: Mon, 16 Jul 2007 06:59:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [rfc][patch 1/2] spinlock: lockbreak cleanups
Message-ID: <20070716045932.GA19914@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These patches are not exactly complete yet (haven't tested many config
combinations or converted other architectures), but I want to post it
now to get consensus on whether and how to clean up the lockbreak stuff
in particular.

It gets in the way because ticket spinlocks shouldn't be just repeating
the low-level trylock to lock, because that never gives the locker a
ticket, so the FIFO order is ruined.

So RFC.

---

The break_lock data structure and code for spinlocks is quite nasty.
Not only does it double the size of a spinlock but it changes locking to
a potentially less optimal trylock.

Put all of that under CONFIG_GENERIC_LOCKBREAK, and introduce a
__raw_spin_is_contended that uses the lock data itself to determine whether
there are waiters on the lock, to be used if CONFIG_GENERIC_LOCKBREAK is
not set.

Rename need_lockbreak to spin_needbreak, make it use spin_is_contended to
decouple it from the spinlock implementation, and make it typesafe (rwlocks
do not have any need_lockbreak sites -- why do they even get bloated up
with that break_lock then?).

After this, we can no longer spin on any locks with preempt enabled
(unless that is done in arch code), but that (and spinning with
interrupts enabled) is hackish anyway: if the lock happens to be
called under a preempt or interrupt disabled section, then it is just
going to have the same problems. The real fix is to keep critical
sections short, and introduce fairer locks if there are starvation
issues.

---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1598,26 +1598,16 @@ extern int cond_resched_softirq(void);
 
 /*
  * Does a critical section need to be broken due to another
- * task waiting?:
+ * task waiting?: (technically does not depend on CONFIG_PREEMPT,
+ * but a general need for low latency)
  */
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_SMP)
-# define need_lockbreak(lock) ((lock)->break_lock)
+#ifdef CONFIG_PREEMPT
+# define spin_needbreak(lock)	spin_is_contended(lock)
 #else
-# define need_lockbreak(lock) 0
+# define spin_needbreak(lock)	0
 #endif
 
 /*
- * Does a critical section need to be broken due to another
- * task waiting or preemption being signalled:
- */
-static inline int lock_need_resched(spinlock_t *lock)
-{
-	if (need_lockbreak(lock) || need_resched())
-		return 1;
-	return 0;
-}
-
-/*
  * Reevaluate whether the task has signals pending delivery.
  * Wake the task if so.
  * This is required every time the blocked sigset_t changes.
Index: linux-2.6/include/linux/spinlock.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock.h
+++ linux-2.6/include/linux/spinlock.h
@@ -120,6 +120,12 @@ do {								\
 
 #define spin_is_locked(lock)	__raw_spin_is_locked(&(lock)->raw_lock)
 
+#ifdef CONFIG_GENERIC_LOCKBREAK
+#define spin_is_contended(lock) ((lock)->break_lock)
+#else
+#define spin_is_contended(lock)	__raw_spin_is_contended(&(lock)->raw_lock)
+#endif
+
 /**
  * spin_unlock_wait - wait until the spinlock gets unlocked
  * @lock: the spinlock in question.
Index: linux-2.6/fs/jbd/checkpoint.c
===================================================================
--- linux-2.6.orig/fs/jbd/checkpoint.c
+++ linux-2.6/fs/jbd/checkpoint.c
@@ -347,7 +347,8 @@ restart:
 				break;
 			}
 			retry = __process_buffer(journal, jh, bhs,&batch_count);
-			if (!retry && lock_need_resched(&journal->j_list_lock)){
+			if (!retry && (need_resched() ||
+				spin_needbreak(&journal->j_list_lock))) {
 				spin_unlock(&journal->j_list_lock);
 				retry = 1;
 				break;
Index: linux-2.6/fs/jbd/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd/commit.c
+++ linux-2.6/fs/jbd/commit.c
@@ -265,7 +265,7 @@ write_out_data:
 			put_bh(bh);
 		}
 
-		if (lock_need_resched(&journal->j_list_lock)) {
+		if (need_resched() || spin_needbreak(&journal->j_list_lock)) {
 			spin_unlock(&journal->j_list_lock);
 			goto write_out_data;
 		}
Index: linux-2.6/fs/jbd2/checkpoint.c
===================================================================
--- linux-2.6.orig/fs/jbd2/checkpoint.c
+++ linux-2.6/fs/jbd2/checkpoint.c
@@ -347,7 +347,8 @@ restart:
 				break;
 			}
 			retry = __process_buffer(journal, jh, bhs,&batch_count);
-			if (!retry && lock_need_resched(&journal->j_list_lock)){
+			if (!retry && (need_resched() ||
+				spin_needbreak(&journal->j_list_lock))) {
 				spin_unlock(&journal->j_list_lock);
 				retry = 1;
 				break;
Index: linux-2.6/fs/jbd2/commit.c
===================================================================
--- linux-2.6.orig/fs/jbd2/commit.c
+++ linux-2.6/fs/jbd2/commit.c
@@ -265,7 +265,7 @@ write_out_data:
 			put_bh(bh);
 		}
 
-		if (lock_need_resched(&journal->j_list_lock)) {
+		if (need_resched() || spin_needbreak(&journal->j_list_lock)) {
 			spin_unlock(&journal->j_list_lock);
 			goto write_out_data;
 		}
Index: linux-2.6/include/linux/spinlock_up.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_up.h
+++ linux-2.6/include/linux/spinlock_up.h
@@ -64,6 +64,8 @@ static inline void __raw_spin_unlock(raw
 # define __raw_spin_trylock(lock)	({ (void)(lock); 1; })
 #endif /* DEBUG_SPINLOCK */
 
+#define __raw_spin_is_contended(lock)	(((void)(lock), 0))
+
 #define __raw_read_can_lock(lock)	(((void)(lock), 1))
 #define __raw_write_can_lock(lock)	(((void)(lock), 1))
 
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -4805,19 +4805,15 @@ EXPORT_SYMBOL(cond_resched);
  */
 int cond_resched_lock(spinlock_t *lock)
 {
+	int resched = need_resched() && system_state == SYSTEM_RUNNING;
 	int ret = 0;
 
-	if (need_lockbreak(lock)) {
+	if (spin_needbreak(lock) || resched) {
 		spin_unlock(lock);
-		cpu_relax();
-		ret = 1;
-		spin_lock(lock);
-	}
-	if (need_resched() && system_state == SYSTEM_RUNNING) {
-		spin_release(&lock->dep_map, 1, _THIS_IP_);
-		_raw_spin_unlock(lock);
-		preempt_enable_no_resched();
-		__cond_resched();
+		if (resched && need_resched())
+			__cond_resched();
+		else
+			cpu_relax();
 		ret = 1;
 		spin_lock(lock);
 	}
Index: linux-2.6/mm/memory.c
===================================================================
--- linux-2.6.orig/mm/memory.c
+++ linux-2.6/mm/memory.c
@@ -516,8 +516,7 @@ again:
 		if (progress >= 32) {
 			progress = 0;
 			if (need_resched() ||
-			    need_lockbreak(src_ptl) ||
-			    need_lockbreak(dst_ptl))
+			    spin_needbreak(src_ptl) || spin_needbreak(dst_ptl))
 				break;
 		}
 		if (pte_none(*src_pte)) {
@@ -856,7 +855,7 @@ unsigned long unmap_vmas(struct mmu_gath
 			tlb_finish_mmu(*tlbp, tlb_start, start);
 
 			if (need_resched() ||
-				(i_mmap_lock && need_lockbreak(i_mmap_lock))) {
+				(i_mmap_lock && spin_needbreak(i_mmap_lock))) {
 				if (i_mmap_lock) {
 					*tlbp = NULL;
 					goto out;
@@ -1838,8 +1837,7 @@ again:
 
 	restart_addr = zap_page_range(vma, start_addr,
 					end_addr - start_addr, details);
-	need_break = need_resched() ||
-			need_lockbreak(details->i_mmap_lock);
+	need_break = need_resched() || spin_needbreak(details->i_mmap_lock);
 
 	if (restart_addr >= end_addr) {
 		/* We have now completed this vma: mark it so */
Index: linux-2.6/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86_64/Kconfig
+++ linux-2.6/arch/x86_64/Kconfig
@@ -32,6 +32,11 @@ config GENERIC_TIME_VSYSCALL
 	bool
 	default y
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config ZONE_DMA32
 	bool
 	default y
Index: linux-2.6/include/linux/spinlock_types.h
===================================================================
--- linux-2.6.orig/include/linux/spinlock_types.h
+++ linux-2.6/include/linux/spinlock_types.h
@@ -19,7 +19,7 @@
 
 typedef struct {
 	raw_spinlock_t raw_lock;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_SMP)
+#ifdef CONFIG_GENERIC_LOCKBREAK
 	unsigned int break_lock;
 #endif
 #ifdef CONFIG_DEBUG_SPINLOCK
@@ -35,7 +35,7 @@ typedef struct {
 
 typedef struct {
 	raw_rwlock_t raw_lock;
-#if defined(CONFIG_PREEMPT) && defined(CONFIG_SMP)
+#ifdef CONFIG_GENERIC_LOCKBREAK
 	unsigned int break_lock;
 #endif
 #ifdef CONFIG_DEBUG_SPINLOCK
Index: linux-2.6/kernel/spinlock.c
===================================================================
--- linux-2.6.orig/kernel/spinlock.c
+++ linux-2.6/kernel/spinlock.c
@@ -65,8 +65,7 @@ EXPORT_SYMBOL(_write_trylock);
  * even on CONFIG_PREEMPT, because lockdep assumes that interrupts are
  * not re-enabled during lock-acquire (which the preempt-spin-ops do):
  */
-#if !defined(CONFIG_PREEMPT) || !defined(CONFIG_SMP) || \
-	defined(CONFIG_DEBUG_LOCK_ALLOC)
+#if !defined(CONFIG_GENERIC_LOCKBREAK) || defined(CONFIG_DEBUG_LOCK_ALLOC)
 
 void __lockfunc _read_lock(rwlock_t *lock)
 {
