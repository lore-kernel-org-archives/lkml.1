Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbXKCMM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbXKCMM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 08:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752975AbXKCMMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 08:12:22 -0400
Received: from ozlabs.org ([203.10.76.45]:55852 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbXKCMMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 08:12:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18220.26005.778223.84644@cargo.ozlabs.ibm.com>
Date: Sat, 3 Nov 2007 23:12:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
CC: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH v2] Restore deterministic CPU accounting on powerpc
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
account_process_tick now takes the task_struct * as an argument.
Tested both with and without CONFIG_VIRT_CPU_ACCOUNTING.

 arch/powerpc/kernel/process.c |    2 +-
 arch/powerpc/kernel/time.c    |   25 +------------------------
 arch/s390/kernel/time.c       |    4 ----
 arch/s390/kernel/vtime.c      |    8 +-------
 include/linux/sched.h         |    1 +
 kernel/timer.c                |   21 ++++++++++++++-------
 6 files changed, 18 insertions(+), 43 deletions(-)

diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index b9d8837..41e13f4 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -350,7 +350,7 @@ struct task_struct *__switch_to(struct task_struct *prev,
 	local_irq_save(flags);
 
 	account_system_vtime(current);
-	account_process_vtime(current);
+	account_process_tick(current, 0);
 	calculate_steal_time();
 
 	last = _switch(old_thread, new_thread);
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 9eb3284..a70dfb7 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -259,7 +259,7 @@ void account_system_vtime(struct task_struct *tsk)
  * user and system time records.
  * Must be called with interrupts disabled.
  */
-void account_process_vtime(struct task_struct *tsk)
+void account_process_tick(struct task_struct *tsk, int user_tick)
 {
 	cputime_t utime, utimescaled;
 
@@ -274,18 +274,6 @@ void account_process_vtime(struct task_struct *tsk)
 	account_user_time_scaled(tsk, utimescaled);
 }
 
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
-}
-
 /*
  * Stuff for accounting stolen time.
  */
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
index 84ff78d..c5f05b3 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -32,7 +32,7 @@ static DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
  * Update process times based on virtual cpu times stored by entry.S
  * to the lowcore fields user_timer, system_timer & steal_clock.
  */
-void account_tick_vtime(struct task_struct *tsk)
+void account_process_tick(struct task_struct *tsk, int user_tick)
 {
 	cputime_t cputime;
 	__u64 timer, clock;
@@ -64,12 +64,6 @@ void account_tick_vtime(struct task_struct *tsk)
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
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 155d743..8001528 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -254,6 +254,7 @@ long io_schedule_timeout(long timeout);
 
 extern void cpu_init (void);
 extern void trap_init(void);
+extern void account_process_tick(struct task_struct *task, int user);
 extern void update_process_times(int user);
 extern void scheduler_tick(void);
 
diff --git a/kernel/timer.c b/kernel/timer.c
index fb4e67d..ada3183 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -817,6 +817,19 @@ unsigned long next_timer_interrupt(void)
 
 #endif
 
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+void account_process_tick(struct task_struct *p, int user_tick)
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
+	account_process_tick(p, user_tick);
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
