Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbXHHEWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbXHHEWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:22:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751083AbXHHEWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:22:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:55781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbXHHEWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:22:36 -0400
Date: Wed, 8 Aug 2007 06:22:34 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-arch@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 1/2] spinlock: lockbreak cleanup
Message-ID: <20070808042234.GE11018@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


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

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1741,26 +1741,16 @@ extern int cond_resched_softirq(void);
 
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
@@ -4500,19 +4500,15 @@ EXPORT_SYMBOL(cond_resched);
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
@@ -514,8 +514,7 @@ again:
 		if (progress >= 32) {
 			progress = 0;
 			if (need_resched() ||
-			    need_lockbreak(src_ptl) ||
-			    need_lockbreak(dst_ptl))
+			    spin_needbreak(src_ptl) || spin_needbreak(dst_ptl))
 				break;
 		}
 		if (pte_none(*src_pte)) {
@@ -854,7 +853,7 @@ unsigned long unmap_vmas(struct mmu_gath
 			tlb_finish_mmu(*tlbp, tlb_start, start);
 
 			if (need_resched() ||
-				(i_mmap_lock && need_lockbreak(i_mmap_lock))) {
+				(i_mmap_lock && spin_needbreak(i_mmap_lock))) {
 				if (i_mmap_lock) {
 					*tlbp = NULL;
 					goto out;
@@ -1860,8 +1859,7 @@ again:
 
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
@@ -74,6 +74,11 @@ config ISA
 config SBUS
 	bool
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config RWSEM_GENERIC_SPINLOCK
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
Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -91,6 +91,11 @@ config GENERIC_IRQ_PROBE
 	bool
 	default y
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
Index: linux-2.6/arch/i386/Kconfig
===================================================================
--- linux-2.6.orig/arch/i386/Kconfig
+++ linux-2.6/arch/i386/Kconfig
@@ -14,6 +14,11 @@ config X86_32
 	  486, 586, Pentiums, and various instruction-set-compatible chips by
 	  AMD, Cyrix, and others.
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config GENERIC_TIME
 	bool
 	default y
Index: linux-2.6/arch/ia64/Kconfig
===================================================================
--- linux-2.6.orig/arch/ia64/Kconfig
+++ linux-2.6/arch/ia64/Kconfig
@@ -42,6 +42,11 @@ config MMU
 config SWIOTLB
        bool
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 	default y
Index: linux-2.6/arch/m32r/Kconfig
===================================================================
--- linux-2.6.orig/arch/m32r/Kconfig
+++ linux-2.6/arch/m32r/Kconfig
@@ -215,6 +215,11 @@ config IRAM_SIZE
 # Define implied options from the CPU selection here
 #
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	depends on M32R
Index: linux-2.6/arch/mips/Kconfig
===================================================================
--- linux-2.6.orig/arch/mips/Kconfig
+++ linux-2.6/arch/mips/Kconfig
@@ -647,6 +647,11 @@ source "arch/mips/philips/pnx8550/common
 
 endmenu
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 	default y
Index: linux-2.6/arch/parisc/Kconfig
===================================================================
--- linux-2.6.orig/arch/parisc/Kconfig
+++ linux-2.6/arch/parisc/Kconfig
@@ -19,6 +19,11 @@ config MMU
 config STACK_GROWSUP
 	def_bool y
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
Index: linux-2.6/arch/sparc64/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc64/Kconfig
+++ linux-2.6/arch/sparc64/Kconfig
@@ -196,6 +196,11 @@ config US2E_FREQ
 	  If in doubt, say N.
 
 # Global things across all Sun machines.
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 
