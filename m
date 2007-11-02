Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXKBEtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXKBEtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 00:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbXKBEtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 00:49:04 -0400
Received: from ozlabs.org ([203.10.76.45]:43812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbXKBEtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 00:49:03 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18218.44089.274628.680088@cargo.ozlabs.ibm.com>
Date: Fri, 2 Nov 2007 15:48:57 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] Restore deterministic CPU accounting on powerpc
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since powerpc started using CONFIG_GENERIC_CLOCKEVENTS, the
deterministic CPU accounting (CONFIG_VIRT_CPU_ACCOUNTING) has been
broken on powerpc, because we end up counting user time twice: once in
timer_interrupt() and once in update_process_times().

This fixes the problem by pulling the code in update_process_times
that updates utime and stime into a separate function called
account_process_tick.  If CONFIG_VIRT_CPU_ACCOUNTING is not defined,
there is a version of account_process_tick in kernel/timer.c that
simply accounts a whole tick to either utime or stime as before.  If
CONFIG_VIRT_CPU_ACCOUNTING is defined, then arch code gets to
implement account_process_tick.

This also lets us simplify the s390 code a bit; it means that the s390
timer interrupt can now call update_process_times even when
CONFIG_VIRT_CPU_ACCOUNTING is turned on, and can just implement a
suitable account_process_tick().

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
I don't know who maintains kernel/timer.c, but I assume it's one of
Ingo, Peter Z. or Thomas.  

In fact the arch bits here don't need to go in at the same time as the
changes to include/linux/sched.h and kernel/timer.c, but could go in
later.  I have included them here so people can see how these changes
help in the VIRT_CPU_ACCOUNTING=y case.  The powerpc changes are
tested, but the s390 changes aren't.

In case it's not obvious, I'd like this (or at least the generic and
powerpc bits) to go in 2.6.24 since it fixes a regression.

 arch/powerpc/kernel/process.c |    4 +++-
 arch/powerpc/kernel/time.c    |   29 +++--------------------------
 arch/s390/kernel/time.c       |    4 ----
 arch/s390/kernel/vtime.c      |    9 ++-------
 include/asm-powerpc/time.h    |    6 ------
 include/asm-ppc/time.h        |    2 --
 include/asm-s390/system.h     |    1 -
 include/linux/sched.h         |    1 +
 kernel/timer.c                |   21 ++++++++++++++-------
 9 files changed, 23 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index b9d8837..eba9332 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -349,9 +349,11 @@ struct task_struct *__switch_to(struct task_struct *prev,
 
 	local_irq_save(flags);
 
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
 	account_system_vtime(current);
-	account_process_vtime(current);
+	account_process_tick(0);
 	calculate_steal_time();
+#endif
 
 	last = _switch(old_thread, new_thread);
 
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 9eb3284..f950336 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -259,31 +259,19 @@ void account_system_vtime(struct task_struct *tsk)
  * user and system time records.
  * Must be called with interrupts disabled.
  */
-void account_process_vtime(struct task_struct *tsk)
+void account_process_tick(int user_tick)
 {
 	cputime_t utime, utimescaled;
 
 	utime = get_paca()->user_time;
 	get_paca()->user_time = 0;
-	account_user_time(tsk, utime);
+	account_user_time(current, utime);
 
 	/* Estimate the scaled utime by scaling the real utime based
 	 * on the last spurr to purr ratio */
 	utimescaled = utime * get_paca()->spurrdelta / get_paca()->purrdelta;
 	get_paca()->spurrdelta = get_paca()->purrdelta = 0;
-	account_user_time_scaled(tsk, utimescaled);
-}
-
-static void account_process_time(struct pt_regs *regs)
-{
-	int cpu = smp_processor_id();
-
-	account_process_vtime(current);
-	run_local_timers();
-	if (rcu_pending(cpu))
-		rcu_check_callbacks(cpu, user_mode(regs));
-	scheduler_tick();
- 	run_posix_cpu_timers(current);
+	account_user_time_scaled(current, utimescaled);
 }
 
 /*
@@ -375,7 +363,6 @@ static void snapshot_purr(void)
 
 #else /* ! CONFIG_VIRT_CPU_ACCOUNTING */
 #define calc_cputime_factors()
-#define account_process_time(regs)	update_process_times(user_mode(regs))
 #define calculate_steal_time()		do { } while (0)
 #endif
 
@@ -599,16 +586,6 @@ void timer_interrupt(struct pt_regs * regs)
 		get_lppaca()->int_dword.fields.decr_int = 0;
 #endif
 
-	/*
-	 * We cannot disable the decrementer, so in the period
-	 * between this cpu's being marked offline in cpu_online_map
-	 * and calling stop-self, it is taking timer interrupts.
-	 * Avoid calling into the scheduler rebalancing code if this
-	 * is the case.
-	 */
-	if (!cpu_is_offline(cpu))
-		account_process_time(regs);
-
 	if (evt->event_handler)
 		evt->event_handler(evt);
 	else
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 48dae49..6c6be1f 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -145,12 +145,8 @@ void account_ticks(u64 time)
 	do_timer(ticks);
 #endif
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-	account_tick_vtime(current);
-#else
 	while (ticks--)
 		update_process_times(user_mode(get_irq_regs()));
-#endif
 
 	s390_do_profile();
 }
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 84ff78d..4251de8 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -32,11 +32,12 @@ static DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
  */
-void account_tick_vtime(struct task_struct *tsk)
+void account_process_tick(int user_tick)
 {
 	cputime_t cputime;
 	__u64 timer, clock;
 	int rcu_user_flag;
+	struct task_struct *tsk = current;
 
 	timer = S390_lowcore.last_update_timer;
 	clock = S390_lowcore.last_update_clock;
@@ -64,12 +65,6 @@ void account_tick_vtime(struct task_struct *tsk)
 		S390_lowcore.steal_clock -= cputime << 12;
 		account_steal_time(tsk, cputime);
 	}
-
-	run_local_timers();
-	if (rcu_pending(smp_processor_id()))
-		rcu_check_callbacks(smp_processor_id(), rcu_user_flag);
-	scheduler_tick();
- 	run_posix_cpu_timers(tsk);
 }
 
 /*
diff --git a/include/asm-powerpc/time.h b/include/asm-powerpc/time.h
index f058955..0ff93bf 100644
--- a/include/asm-powerpc/time.h
+++ b/include/asm-powerpc/time.h
@@ -231,12 +231,6 @@ struct cpu_usage {
 
 DECLARE_PER_CPU(struct cpu_usage, cpu_usage_array);
 
-#ifdef CONFIG_VIRT_CPU_ACCOUNTING
-extern void account_process_vtime(struct task_struct *tsk);
-#else
-#define account_process_vtime(tsk)		do { } while (0)
-#endif
-
 #if defined(CONFIG_VIRT_CPU_ACCOUNTING)
 extern void calculate_steal_time(void);
 extern void snapshot_timebases(void);
diff --git a/include/asm-ppc/time.h b/include/asm-ppc/time.h
index 81dbcd4..3715490 100644
--- a/include/asm-ppc/time.h
+++ b/include/asm-ppc/time.h
@@ -153,8 +153,6 @@ extern __inline__ unsigned binary_tbl(void) {
 
 unsigned mulhwu_scale_factor(unsigned, unsigned);
 
-#define account_process_vtime(tsk)		do { } while (0)
-#define calculate_steal_time()			do { } while (0)
 #define snapshot_timebases()			do { } while (0)
 
 #endif /* __ASM_TIME_H__ */
diff --git a/include/asm-s390/system.h b/include/asm-s390/system.h
index d866d33..3e39db1 100644
--- a/include/asm-s390/system.h
+++ b/include/asm-s390/system.h
@@ -99,7 +99,6 @@ static inline void restore_access_regs(unsigned int *acrs)
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 extern void account_vtime(struct task_struct *);
-extern void account_tick_vtime(struct task_struct *);
 extern void account_system_vtime(struct task_struct *);
 #else
 #define account_vtime(x) do { /* empty */ } while (0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 155d743..4d87b21 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -254,6 +254,7 @@ long io_schedule_timeout(long timeout);
 
 extern void cpu_init (void);
 extern void trap_init(void);
+extern void account_process_tick(int user);
 extern void update_process_times(int user);
 extern void scheduler_tick(void);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index fb4e67d..8054f6d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -817,6 +817,19 @@ unsigned long next_timer_interrupt(void)
 
 #endif
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+void account_process_tick(int user_tick)
+{
+	if (user_tick) {
+		account_user_time(p, jiffies_to_cputime(1));
+		account_user_time_scaled(p, jiffies_to_cputime(1));
+	} else {
+		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
+		account_system_time_scaled(p, jiffies_to_cputime(1));
+	}
+}
+#endif
+
 /*
  * Called from the timer interrupt handler to charge one tick to the current
  * process.  user_tick is 1 if the tick is user time, 0 for system.
@@ -827,13 +840,7 @@ void update_process_times(int user_tick)
 	int cpu = smp_processor_id();
 
 	/* Note: this timer irq context must be accounted for as well. */
-	if (user_tick) {
-		account_user_time(p, jiffies_to_cputime(1));
-		account_user_time_scaled(p, jiffies_to_cputime(1));
-	} else {
-		account_system_time(p, HARDIRQ_OFFSET, jiffies_to_cputime(1));
-		account_system_time_scaled(p, jiffies_to_cputime(1));
-	}
+	account_process_tick(user_tick);
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
