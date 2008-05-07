Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbYEGPUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbYEGPUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 11:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756563AbYEGPUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 11:20:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755215AbYEGPT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 11:19:57 -0400
Date: Wed, 7 May 2008 08:19:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
In-Reply-To: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org>
 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Linus Torvalds wrote:
> 
> But my preferred option would indeed be just turning it back into a 
> spinlock - and screw latency and BKL preemption - and having the RT people 
> who care deeply just work on removing the BKL in the long run.

Here's a trial balloon patch to do that.

Yanmin - this is not well tested, but the code is fairly obvious, and it 
would be interesting to hear if this fixes the performance regression. 
Because if it doesn't, then it's not the BKL, or something totally 
different is going on.

Now, we should probably also test just converting the thing to a mutex, 
to see if that perhaps also fixes it.

			Linus

---
 arch/mn10300/Kconfig    |   11 ----
 include/linux/hardirq.h |   18 ++++---
 kernel/sched.c          |   27 ++---------
 lib/kernel_lock.c       |  120 +++++++++++++++++++++++++++++++---------------
 4 files changed, 95 insertions(+), 81 deletions(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 6a6409a..e856218 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -186,17 +186,6 @@ config PREEMPT
 	  Say Y here if you are building a kernel for a desktop, embedded
 	  or real-time system.  Say N if you are unsure.
 
-config PREEMPT_BKL
-	bool "Preempt The Big Kernel Lock"
-	depends on PREEMPT
-	default y
-	help
-	  This option reduces the latency of the kernel by making the
-	  big kernel lock preemptible.
-
-	  Say Y here if you are building a kernel for a desktop system.
-	  Say N if you are unsure.
-
 config MN10300_CURRENT_IN_E2
 	bool "Hold current task address in E2 register"
 	default y
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 897f723..181006c 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -72,6 +72,14 @@
 #define in_softirq()		(softirq_count())
 #define in_interrupt()		(irq_count())
 
+#if defined(CONFIG_PREEMPT)
+# define PREEMPT_INATOMIC_BASE kernel_locked()
+# define PREEMPT_CHECK_OFFSET 1
+#else
+# define PREEMPT_INATOMIC_BASE 0
+# define PREEMPT_CHECK_OFFSET 0
+#endif
+
 /*
  * Are we running in atomic context?  WARNING: this macro cannot
  * always detect atomic context; in particular, it cannot know about
@@ -79,17 +87,11 @@
  * used in the general case to determine whether sleeping is possible.
  * Do not use in_atomic() in driver code.
  */
-#define in_atomic()		((preempt_count() & ~PREEMPT_ACTIVE) != 0)
-
-#ifdef CONFIG_PREEMPT
-# define PREEMPT_CHECK_OFFSET 1
-#else
-# define PREEMPT_CHECK_OFFSET 0
-#endif
+#define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_INATOMIC_BASE)
 
 /*
  * Check whether we were atomic before we did preempt_disable():
- * (used by the scheduler)
+ * (used by the scheduler, *after* releasing the kernel lock)
  */
 #define in_atomic_preempt_off() \
 		((preempt_count() & ~PREEMPT_ACTIVE) != PREEMPT_CHECK_OFFSET)
diff --git a/kernel/sched.c b/kernel/sched.c
index 58fb8af..c51b656 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4567,8 +4567,6 @@ EXPORT_SYMBOL(schedule);
 asmlinkage void __sched preempt_schedule(void)
 {
 	struct thread_info *ti = current_thread_info();
-	struct task_struct *task = current;
-	int saved_lock_depth;
 
 	/*
 	 * If there is a non-zero preempt_count or interrupts are disabled,
@@ -4579,16 +4577,7 @@ asmlinkage void __sched preempt_schedule(void)
 
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
-
-		/*
-		 * We keep the big kernel semaphore locked, but we
-		 * clear ->lock_depth so that schedule() doesnt
-		 * auto-release the semaphore:
-		 */
-		saved_lock_depth = task->lock_depth;
-		task->lock_depth = -1;
 		schedule();
-		task->lock_depth = saved_lock_depth;
 		sub_preempt_count(PREEMPT_ACTIVE);
 
 		/*
@@ -4609,26 +4598,15 @@ EXPORT_SYMBOL(preempt_schedule);
 asmlinkage void __sched preempt_schedule_irq(void)
 {
 	struct thread_info *ti = current_thread_info();
-	struct task_struct *task = current;
-	int saved_lock_depth;
 
 	/* Catch callers which need to be fixed */
 	BUG_ON(ti->preempt_count || !irqs_disabled());
 
 	do {
 		add_preempt_count(PREEMPT_ACTIVE);
-
-		/*
-		 * We keep the big kernel semaphore locked, but we
-		 * clear ->lock_depth so that schedule() doesnt
-		 * auto-release the semaphore:
-		 */
-		saved_lock_depth = task->lock_depth;
-		task->lock_depth = -1;
 		local_irq_enable();
 		schedule();
 		local_irq_disable();
-		task->lock_depth = saved_lock_depth;
 		sub_preempt_count(PREEMPT_ACTIVE);
 
 		/*
@@ -5853,8 +5831,11 @@ void __cpuinit init_idle(struct task_struct *idle, int cpu)
 	spin_unlock_irqrestore(&rq->lock, flags);
 
 	/* Set the preempt count _outside_ the spinlocks! */
+#if defined(CONFIG_PREEMPT)
+	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
+#else
 	task_thread_info(idle)->preempt_count = 0;
-
+#endif
 	/*
 	 * The idle tasks have their own, simple scheduling class:
 	 */
diff --git a/lib/kernel_lock.c b/lib/kernel_lock.c
index cd3e825..06722aa 100644
--- a/lib/kernel_lock.c
+++ b/lib/kernel_lock.c
@@ -11,79 +11,121 @@
 #include <linux/semaphore.h>
 
 /*
- * The 'big kernel semaphore'
+ * The 'big kernel lock'
  *
- * This mutex is taken and released recursively by lock_kernel()
+ * This spinlock is taken and released recursively by lock_kernel()
  * and unlock_kernel().  It is transparently dropped and reacquired
  * over schedule().  It is used to protect legacy code that hasn't
  * been migrated to a proper locking design yet.
  *
- * Note: code locked by this semaphore will only be serialized against
- * other code using the same locking facility. The code guarantees that
- * the task remains on the same CPU.
- *
  * Don't use in new code.
  */
-static DECLARE_MUTEX(kernel_sem);
+static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(kernel_flag);
+
 
 /*
- * Re-acquire the kernel semaphore.
+ * Acquire/release the underlying lock from the scheduler.
  *
- * This function is called with preemption off.
+ * This is called with preemption disabled, and should
+ * return an error value if it cannot get the lock and
+ * TIF_NEED_RESCHED gets set.
  *
- * We are executing in schedule() so the code must be extremely careful
- * about recursion, both due to the down() and due to the enabling of
- * preemption. schedule() will re-check the preemption flag after
- * reacquiring the semaphore.
+ * If it successfully gets the lock, it should increment
+ * the preemption count like any spinlock does.
+ *
+ * (This works on UP too - _raw_spin_trylock will never
+ * return false in that case)
  */
 int __lockfunc __reacquire_kernel_lock(void)
 {
-	struct task_struct *task = current;
-	int saved_lock_depth = task->lock_depth;
-
-	BUG_ON(saved_lock_depth < 0);
-
-	task->lock_depth = -1;
-	preempt_enable_no_resched();
-
-	down(&kernel_sem);
-
+	while (!_raw_spin_trylock(&kernel_flag)) {
+		if (test_thread_flag(TIF_NEED_RESCHED))
+			return -EAGAIN;
+		cpu_relax();
+	}
 	preempt_disable();
-	task->lock_depth = saved_lock_depth;
-
 	return 0;
 }
 
 void __lockfunc __release_kernel_lock(void)
 {
-	up(&kernel_sem);
+	_raw_spin_unlock(&kernel_flag);
+	preempt_enable_no_resched();
 }
 
 /*
- * Getting the big kernel semaphore.
+ * These are the BKL spinlocks - we try to be polite about preemption. 
+ * If SMP is not on (ie UP preemption), this all goes away because the
+ * _raw_spin_trylock() will always succeed.
  */
-void __lockfunc lock_kernel(void)
+#ifdef CONFIG_PREEMPT
+static inline void __lock_kernel(void)
 {
-	struct task_struct *task = current;
-	int depth = task->lock_depth + 1;
+	preempt_disable();
+	if (unlikely(!_raw_spin_trylock(&kernel_flag))) {
+		/*
+		 * If preemption was disabled even before this
+		 * was called, there's nothing we can be polite
+		 * about - just spin.
+		 */
+		if (preempt_count() > 1) {
+			_raw_spin_lock(&kernel_flag);
+			return;
+		}
 
-	if (likely(!depth))
 		/*
-		 * No recursion worries - we set up lock_depth _after_
+		 * Otherwise, let's wait for the kernel lock
+		 * with preemption enabled..
 		 */
-		down(&kernel_sem);
+		do {
+			preempt_enable();
+			while (spin_is_locked(&kernel_flag))
+				cpu_relax();
+			preempt_disable();
+		} while (!_raw_spin_trylock(&kernel_flag));
+	}
+}
 
-	task->lock_depth = depth;
+#else
+
+/*
+ * Non-preemption case - just get the spinlock
+ */
+static inline void __lock_kernel(void)
+{
+	_raw_spin_lock(&kernel_flag);
 }
+#endif
 
-void __lockfunc unlock_kernel(void)
+static inline void __unlock_kernel(void)
 {
-	struct task_struct *task = current;
+	/*
+	 * the BKL is not covered by lockdep, so we open-code the
+	 * unlocking sequence (and thus avoid the dep-chain ops):
+	 */
+	_raw_spin_unlock(&kernel_flag);
+	preempt_enable();
+}
 
-	BUG_ON(task->lock_depth < 0);
+/*
+ * Getting the big kernel lock.
+ *
+ * This cannot happen asynchronously, so we only need to
+ * worry about other CPU's.
+ */
+void __lockfunc lock_kernel(void)
+{
+	int depth = current->lock_depth+1;
+	if (likely(!depth))
+		__lock_kernel();
+	current->lock_depth = depth;
+}
 
-	if (likely(--task->lock_depth < 0))
-		up(&kernel_sem);
+void __lockfunc unlock_kernel(void)
+{
+	BUG_ON(current->lock_depth < 0);
+	if (likely(--current->lock_depth < 0))
+		__unlock_kernel();
 }
 
 EXPORT_SYMBOL(lock_kernel);
