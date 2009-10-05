Return-Path: <linux-kernel-owner+w=401wt.eu-S932577AbZJEK3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbZJEK3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932565AbZJEK3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:29:45 -0400
Received: from bosmailout02.eigbox.net ([66.96.187.2]:54297 "EHLO
	bosmailout02.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932564AbZJEK3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:29:44 -0400
X-Greylist: delayed 2533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 06:29:44 EDT
X-EN-OrigOutIP: 10.20.18.15
X-EN-IMPSID: oxlX1c0040KWaAJ0000000
Message-ID: <4AC9C053.7000201@jaysonking.com>
Date: Mon, 05 Oct 2009 04:45:55 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Con Kolivas <kernel@kolivas.org>
Subject: [PATCH 2/4] idle cputime accounting
References: <4AC9B97B.6070900@jaysonking.com>
In-Reply-To: <4AC9B97B.6070900@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 67.67.11.191
X-EN-OrigHost: adsl-67-67-11-191.dsl.okcyok.swbell.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

[upstream commit 79741dd35713ff4f6fd0eafd59fa94e8a4ba922d]

The cpu time spent by the idle process actually doing something is
currently accounted as idle time. This is plain wrong, the architectures
that support VIRT_CPU_ACCOUNTING=y can do better: distinguish between the
time spent doing nothing and the time spent by idle doing work. The first
is accounted with account_idle_time and the second with account_system_time.
The architectures that use the account_xxx_time interface directly and not
the account_xxx_ticks interface now need to do the check for the idle
process in their arch code. In particular to improve the system vs true
idle time accounting the arch code needs to measure the true idle time
instead of just testing for the idle process.
To improve the tick based accounting as well we would need an architecture
primitive that can tell us if the pt_regs of the interrupted context
points to the magic instruction that halts the cpu.

In addition idle time is no more added to the stime of the idle process.
This field now contains the system time of the idle process as it should
be. On systems without VIRT_CPU_ACCOUNTING this will always be zero as
every tick that occurs while idle is running will be accounted as idle
time.

This patch contains the necessary common code changes to be able to
distinguish idle system time and true idle time. The architectures with
support for VIRT_CPU_ACCOUNTING need some changes to exploit this.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
  arch/ia64/kernel/time.c       |   10 +++-
  arch/powerpc/kernel/process.c |    1
  arch/powerpc/kernel/time.c    |   13 ++++-
  arch/s390/kernel/vtime.c      |   20 ++++++--
  arch/x86/xen/time.c           |   10 +---
  include/linux/kernel_stat.h   |    7 ++
  include/linux/sched.h         |    1
  kernel/sched.c                |   80 +++++++++++++++++++++++++-------
  kernel/time/tick-sched.c      |   13 ++---
  kernel/timer.c                |   13 -----
  10 files changed, 114 insertions(+), 54 deletions(-)

diff -udrNp linux-2.6.27.orig/arch/ia64/kernel/time.c linux-2.6.27/arch/ia64/kernel/time.c
--- linux-2.6.27.orig/arch/ia64/kernel/time.c	2009-10-02 05:14:01.394580063 -0500
+++ linux-2.6.27/arch/ia64/kernel/time.c	2009-10-02 05:14:10.681580244 -0500
@@ -93,7 +93,10 @@ void ia64_account_on_switch(struct task_
  	now = ia64_get_itc();

  	delta_stime = cycle_to_cputime(pi->ac_stime + (now - pi->ac_stamp));
-	account_system_time(prev, 0, delta_stime, delta_stime);
+	if (idle_task(smp_processor_id()) != prev)
+		account_system_time(prev, 0, delta_stime, delta_stime);
+	else
+		account_idle_time(delta_stime);

  	if (pi->ac_utime) {
  		delta_utime = cycle_to_cputime(pi->ac_utime);
@@ -120,7 +123,10 @@ void account_system_vtime(struct task_st
  	now = ia64_get_itc();

  	delta_stime = cycle_to_cputime(ti->ac_stime + (now - ti->ac_stamp));
-	account_system_time(tsk, 0, delta_stime, delta_stime);
+	if (irq_count() || idle_task(smp_processor_id()) != tsk)
+		account_system_time(tsk, 0, delta_stime, delta_stime);
+	else
+		account_idle_time(delta_stime);
  	ti->ac_stime = 0;

  	ti->ac_stamp = now;
diff -udrNp linux-2.6.27.orig/arch/powerpc/kernel/process.c linux-2.6.27/arch/powerpc/kernel/process.c
--- linux-2.6.27.orig/arch/powerpc/kernel/process.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/arch/powerpc/kernel/process.c	2009-10-02 05:14:10.681580244 -0500
@@ -33,6 +33,7 @@
  #include <linux/mqueue.h>
  #include <linux/hardirq.h>
  #include <linux/utsname.h>
+#include <linux/kernel_stat.h>

  #include <asm/pgtable.h>
  #include <asm/uaccess.h>
diff -udrNp linux-2.6.27.orig/arch/powerpc/kernel/time.c linux-2.6.27/arch/powerpc/kernel/time.c
--- linux-2.6.27.orig/arch/powerpc/kernel/time.c	2009-10-02 05:14:01.395580055 -0500
+++ linux-2.6.27/arch/powerpc/kernel/time.c	2009-10-02 05:14:10.681580244 -0500
@@ -258,7 +258,10 @@ void account_system_vtime(struct task_st
  		delta += sys_time;
  		get_paca()->system_time = 0;
  	}
-	account_system_time(tsk, 0, delta, deltascaled);
+	if (in_irq() || idle_task(smp_processor_id()) != tsk)
+		account_system_time(tsk, 0, delta, deltascaled);
+	else
+		account_idle_time(delta);
  	per_cpu(cputime_last_delta, smp_processor_id()) = delta;
  	per_cpu(cputime_scaled_last_delta, smp_processor_id()) = deltascaled;
  	local_irq_restore(flags);
@@ -337,8 +340,12 @@ void calculate_steal_time(void)
  	tb = mftb();
  	purr = mfspr(SPRN_PURR);
  	stolen = (tb - pme->tb) - (purr - pme->purr);
-	if (stolen > 0)
-		account_steal_time(current, stolen);
+	if (stolen > 0) {
+		if (idle_task(smp_processor_id()) != current)
+			account_steal_time(stolen);
+		else
+			account_idle_time(stolen);
+	}
  	pme->tb = tb;
  	pme->purr = purr;
  }
diff -udrNp linux-2.6.27.orig/arch/s390/kernel/vtime.c linux-2.6.27/arch/s390/kernel/vtime.c
--- linux-2.6.27.orig/arch/s390/kernel/vtime.c	2009-10-02 05:14:01.395580055 -0500
+++ linux-2.6.27/arch/s390/kernel/vtime.c	2009-10-02 05:14:10.681580244 -0500
@@ -56,13 +56,19 @@ void account_process_tick(struct task_st
  	cputime =  S390_lowcore.system_timer >> 12;
  	S390_lowcore.system_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_system_time(tsk, HARDIRQ_OFFSET, cputime, cputime);
+	if (idle_task(smp_processor_id()) != current)
+		account_system_time(tsk, HARDIRQ_OFFSET, cputime, cputime);
+	else
+		account_idle_time(cputime);

  	cputime = S390_lowcore.steal_clock;
  	if ((__s64) cputime > 0) {
  		cputime >>= 12;
  		S390_lowcore.steal_clock -= cputime << 12;
-		account_steal_time(tsk, cputime);
+		if (idle_task(smp_processor_id()) != current)
+			account_steal_time(cputime);
+		else
+			account_idle_time(cputime);
  	}
  }

@@ -88,7 +94,10 @@ void account_vtime(struct task_struct *t
  	cputime =  S390_lowcore.system_timer >> 12;
  	S390_lowcore.system_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_system_time(tsk, 0, cputime, cputime);
+	if (idle_task(smp_processor_id()) != current)
+		account_system_time(tsk, 0, cputime, cputime);
+	else
+		account_idle_time(cputime);
  }

  /*
@@ -108,7 +117,10 @@ void account_system_vtime(struct task_st
  	cputime =  S390_lowcore.system_timer >> 12;
  	S390_lowcore.system_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_system_time(tsk, 0, cputime, cputime);
+	if (in_irq() || idle_task(smp_processor_id()) != current)
+		account_system_time(tsk, 0, cputime, cputime);
+	else
+		account_idle_time(cputime);
  }
  EXPORT_SYMBOL_GPL(account_system_vtime);

diff -udrNp linux-2.6.27.orig/arch/x86/xen/time.c linux-2.6.27/arch/x86/xen/time.c
--- linux-2.6.27.orig/arch/x86/xen/time.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/arch/x86/xen/time.c	2009-10-02 05:14:10.682578869 -0500
@@ -134,8 +134,7 @@ static void do_stolen_accounting(void)
  	*snap = state;

  	/* Add the appropriate number of ticks of stolen time,
-	   including any left-overs from last time.  Passing NULL to
-	   account_steal_time accounts the time as stolen. */
+	   including any left-overs from last time. */
  	stolen = runnable + offline + __get_cpu_var(residual_stolen);

  	if (stolen < 0)
@@ -143,11 +142,10 @@ static void do_stolen_accounting(void)

  	ticks = iter_div_u64_rem(stolen, NS_PER_TICK, &stolen);
  	__get_cpu_var(residual_stolen) = stolen;
-	account_steal_time(NULL, ticks);
+	account_steal_ticks(ticks);

  	/* Add the appropriate number of ticks of blocked time,
-	   including any left-overs from last time.  Passing idle to
-	   account_steal_time accounts the time as idle/wait. */
+	   including any left-overs from last time. */
  	blocked += __get_cpu_var(residual_blocked);

  	if (blocked < 0)
@@ -155,7 +153,7 @@ static void do_stolen_accounting(void)

  	ticks = iter_div_u64_rem(blocked, NS_PER_TICK, &blocked);
  	__get_cpu_var(residual_blocked) = blocked;
-	account_steal_time(idle_task(smp_processor_id()), ticks);
+	account_idle_ticks(ticks);
  }

  /*
diff -udrNp linux-2.6.27.orig/include/linux/kernel_stat.h linux-2.6.27/include/linux/kernel_stat.h
--- linux-2.6.27.orig/include/linux/kernel_stat.h	2009-10-02 05:14:01.395580055 -0500
+++ linux-2.6.27/include/linux/kernel_stat.h	2009-10-02 05:14:10.682578869 -0500
@@ -54,6 +54,11 @@ static inline int kstat_irqs(int irq)

  extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
  extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
-extern void account_steal_time(struct task_struct *, cputime_t);
+extern void account_steal_time(cputime_t);
+extern void account_idle_time(cputime_t);
+
+extern void account_process_tick(struct task_struct *, int user);
+extern void account_steal_ticks(unsigned long ticks);
+extern void account_idle_ticks(unsigned long ticks);

  #endif /* _LINUX_KERNEL_STAT_H */
diff -udrNp linux-2.6.27.orig/include/linux/sched.h linux-2.6.27/include/linux/sched.h
--- linux-2.6.27.orig/include/linux/sched.h	2009-10-02 05:13:37.625579260 -0500
+++ linux-2.6.27/include/linux/sched.h	2009-10-02 05:14:10.683578564 -0500
@@ -285,7 +285,6 @@ long io_schedule_timeout(long timeout);

  extern void cpu_init (void);
  extern void trap_init(void);
-extern void account_process_tick(struct task_struct *task, int user);
  extern void update_process_times(int user);
  extern void scheduler_tick(void);
  extern void hrtick_resched(void);
diff -udrNp linux-2.6.27.orig/kernel/sched.c linux-2.6.27/kernel/sched.c
--- linux-2.6.27.orig/kernel/sched.c	2009-10-02 05:14:01.397579337 -0500
+++ linux-2.6.27/kernel/sched.c	2009-10-02 05:14:10.685578724 -0500
@@ -4120,7 +4120,6 @@ void account_system_time(struct task_str
  			 cputime_t cputime, cputime_t cputime_scaled)
  {
  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	struct rq *rq = this_rq();
  	cputime64_t tmp;

  	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
@@ -4138,37 +4137,84 @@ void account_system_time(struct task_str
  		cpustat->irq = cputime64_add(cpustat->irq, tmp);
  	else if (softirq_count())
  		cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
-	else if (p != rq->idle)
-		cpustat->system = cputime64_add(cpustat->system, tmp);
-	else if (atomic_read(&rq->nr_iowait) > 0)
-		cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
  	else
-		cpustat->idle = cputime64_add(cpustat->idle, tmp);
+		cpustat->system = cputime64_add(cpustat->system, tmp);
+
  	/* Account for system time used */
  	acct_update_integrals(p);
  }

  /*
   * Account for involuntary wait time.
- * @p: the process from which the cpu time has been stolen
   * @steal: the cpu time spent in involuntary wait
   */
-void account_steal_time(struct task_struct *p, cputime_t steal)
+void account_steal_time(cputime_t cputime)
  {
  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
-	cputime64_t tmp = cputime_to_cputime64(steal);
+	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+
+	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
+}
+
+/*
+ * Account for idle time.
+ * @cputime: the cpu time spent in idle wait
+ */
+void account_idle_time(cputime_t cputime)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t cputime64 = cputime_to_cputime64(cputime);
  	struct rq *rq = this_rq();

-	if (p == rq->idle) {
-		p->stime = cputime_add(p->stime, steal);
-		if (atomic_read(&rq->nr_iowait) > 0)
-			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
-		else
-			cpustat->idle = cputime64_add(cpustat->idle, tmp);
-	} else
-		cpustat->steal = cputime64_add(cpustat->steal, tmp);
+	if (atomic_read(&rq->nr_iowait) > 0)
+		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
+	else
+		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
+}
+
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+
+/*
+ * Account a single tick of cpu time.
+ * @p: the process that the cpu time gets accounted to
+ * @user_tick: indicates if the tick is a user or a system tick
+ */
+void account_process_tick(struct task_struct *p, int user_tick)
+{
+	cputime_t one_jiffy = jiffies_to_cputime(1);
+	cputime_t one_jiffy_scaled = cputime_to_scaled(one_jiffy);
+	struct rq *rq = this_rq();
+
+	if (user_tick)
+		account_user_time(p, one_jiffy, one_jiffy_scaled);
+	else if (p != rq->idle)
+		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
+				    one_jiffy_scaled);
+	else
+		account_idle_time(one_jiffy);
+}
+
+/*
+ * Account multiple ticks of steal time.
+ * @p: the process from which the cpu time has been stolen
+ * @ticks: number of stolen ticks
+ */
+void account_steal_ticks(unsigned long ticks)
+{
+	account_steal_time(jiffies_to_cputime(ticks));
+}
+
+/*
+ * Account multiple ticks of idle time.
+ * @ticks: number of stolen ticks
+ */
+void account_idle_ticks(unsigned long ticks)
+{
+	account_idle_time(jiffies_to_cputime(ticks));
  }

+#endif
+
  /*
   * Use precise platform statistics if available:
   */
diff -udrNp linux-2.6.27.orig/kernel/time/tick-sched.c linux-2.6.27/kernel/time/tick-sched.c
--- linux-2.6.27.orig/kernel/time/tick-sched.c	2009-10-02 05:14:01.397579337 -0500
+++ linux-2.6.27/kernel/time/tick-sched.c	2009-10-02 05:14:10.685578724 -0500
@@ -377,8 +377,9 @@ void tick_nohz_restart_sched_tick(void)
  {
  	int cpu = smp_processor_id();
  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
  	unsigned long ticks;
-	cputime_t cputime;
+#endif
  	ktime_t now;

  	local_irq_disable();
@@ -400,6 +401,7 @@ void tick_nohz_restart_sched_tick(void)
  	tick_do_update_jiffies64(now);
  	cpu_clear(cpu, nohz_cpu_mask);

+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
  	/*
  	 * We stopped the tick in idle. Update process times would miss the
  	 * time we slept as update_process_times does only a 1 tick
@@ -409,12 +411,9 @@ void tick_nohz_restart_sched_tick(void)
  	/*
  	 * We might be one off. Do not randomly account a huge number of ticks!
  	 */
-	if (ticks && ticks < LONG_MAX) {
-		add_preempt_count(HARDIRQ_OFFSET);
-		cputime = jiffies_to_cputime(ticks);
-		account_system_time(current, HARDIRQ_OFFSET, cputime, cputime);
-		sub_preempt_count(HARDIRQ_OFFSET);
-	}
+	if (ticks && ticks < LONG_MAX)
+		account_idle_ticks(ticks);
+#endif

  	touch_softlockup_watchdog();
  	/*
diff -udrNp linux-2.6.27.orig/kernel/timer.c linux-2.6.27/kernel/timer.c
--- linux-2.6.27.orig/kernel/timer.c	2009-10-02 05:14:01.398579345 -0500
+++ linux-2.6.27/kernel/timer.c	2009-10-02 05:14:10.686578642 -0500
@@ -949,19 +949,6 @@ unsigned long get_next_timer_interrupt(u
  }
  #endif

-#ifndef CONFIG_VIRT_CPU_ACCOUNTING
-void account_process_tick(struct task_struct *p, int user_tick)
-{
-	cputime_t one_jiffy = jiffies_to_cputime(1);
-
-	if (user_tick)
-		account_user_time(p, one_jiffy, cputime_to_scaled(one_jiffy));
-	else
-		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
-				    cputime_to_scaled(one_jiffy));
-}
-#endif
-
  /*
   * Called from the timer interrupt handler to charge one tick to the current
   * process.  user_tick is 1 if the tick is user time, 0 for system.

