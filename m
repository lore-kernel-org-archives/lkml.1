Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbZJEK3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbZJEK3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 06:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932451AbZJEK3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 06:29:31 -0400
Received: from bosmailout11.eigbox.net ([66.96.188.11]:43644 "EHLO
	bosmailout11.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447AbZJEK3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 06:29:30 -0400
X-Greylist: delayed 2526 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 06:29:30 EDT
X-EN-OrigOutIP: 10.20.18.9
X-EN-IMPSID: oxlQ1c0010BkY8i0000000
Message-ID: <4AC9C043.1010802@jaysonking.com>
Date: Mon, 05 Oct 2009 04:45:39 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Con Kolivas <kernel@kolivas.org>
Subject: [PATCH 1/4] fix scaled & unscaled cputime accounting
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

[upstream commit 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4]

The utimescaled / stimescaled fields in the task structure and the
global cpustat should be set on all architectures. On s390 the calls
to account_user_time_scaled and account_system_time_scaled never have
been added. In addition system time that is accounted as guest time
to the user time of a process is accounted to the scaled system time
instead of the scaled user time.
To fix the bugs and to prevent future forgetfulness this patch merges
account_system_time_scaled into account_system_time and
account_user_time_scaled into account_user_time.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Michael Neuling <mikey@neuling.org>
Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
  arch/ia64/kernel/time.c     |   12 +++------
  arch/powerpc/kernel/time.c  |    7 +----
  arch/s390/kernel/vtime.c    |   10 ++++----
  include/linux/kernel_stat.h |    6 +---
  kernel/sched.c              |   41 +++++++++++++---------------------
  kernel/time/tick-sched.c    |    5 ++--
  kernel/timer.c              |   12 ++++-----
  7 files changed, 37 insertions(+), 56 deletions(-)

diff -udrNp linux-2.6.27.orig/arch/ia64/kernel/time.c linux-2.6.27/arch/ia64/kernel/time.c
--- linux-2.6.27.orig/arch/ia64/kernel/time.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/arch/ia64/kernel/time.c	2009-10-02 05:08:10.543580236 -0500
@@ -93,13 +93,11 @@ void ia64_account_on_switch(struct task_
  	now = ia64_get_itc();

  	delta_stime = cycle_to_cputime(pi->ac_stime + (now - pi->ac_stamp));
-	account_system_time(prev, 0, delta_stime);
-	account_system_time_scaled(prev, delta_stime);
+	account_system_time(prev, 0, delta_stime, delta_stime);

  	if (pi->ac_utime) {
  		delta_utime = cycle_to_cputime(pi->ac_utime);
-		account_user_time(prev, delta_utime);
-		account_user_time_scaled(prev, delta_utime);
+		account_user_time(prev, delta_utime, delta_utime);
  	}

  	pi->ac_stamp = ni->ac_stamp = now;
@@ -122,8 +120,7 @@ void account_system_vtime(struct task_st
  	now = ia64_get_itc();

  	delta_stime = cycle_to_cputime(ti->ac_stime + (now - ti->ac_stamp));
-	account_system_time(tsk, 0, delta_stime);
-	account_system_time_scaled(tsk, delta_stime);
+	account_system_time(tsk, 0, delta_stime, delta_stime);
  	ti->ac_stime = 0;

  	ti->ac_stamp = now;
@@ -143,8 +140,7 @@ void account_process_tick(struct task_st

  	if (ti->ac_utime) {
  		delta_utime = cycle_to_cputime(ti->ac_utime);
-		account_user_time(p, delta_utime);
-		account_user_time_scaled(p, delta_utime);
+		account_user_time(p, delta_utime, delta_utime);
  		ti->ac_utime = 0;
  	}
  }
diff -udrNp linux-2.6.27.orig/arch/powerpc/kernel/time.c linux-2.6.27/arch/powerpc/kernel/time.c
--- linux-2.6.27.orig/arch/powerpc/kernel/time.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/arch/powerpc/kernel/time.c	2009-10-02 05:08:10.543580236 -0500
@@ -258,8 +258,7 @@ void account_system_vtime(struct task_st
  		delta += sys_time;
  		get_paca()->system_time = 0;
  	}
-	account_system_time(tsk, 0, delta);
-	account_system_time_scaled(tsk, deltascaled);
+	account_system_time(tsk, 0, delta, deltascaled);
  	per_cpu(cputime_last_delta, smp_processor_id()) = delta;
  	per_cpu(cputime_scaled_last_delta, smp_processor_id()) = deltascaled;
  	local_irq_restore(flags);
@@ -277,10 +276,8 @@ void account_process_tick(struct task_st

  	utime = get_paca()->user_time;
  	get_paca()->user_time = 0;
-	account_user_time(tsk, utime);
-
  	utimescaled = cputime_to_scaled(utime);
-	account_user_time_scaled(tsk, utimescaled);
+	account_user_time(tsk, utime, utimescaled);
  }

  /*
diff -udrNp linux-2.6.27.orig/arch/s390/kernel/vtime.c linux-2.6.27/arch/s390/kernel/vtime.c
--- linux-2.6.27.orig/arch/s390/kernel/vtime.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/arch/s390/kernel/vtime.c	2009-10-02 05:08:10.543580236 -0500
@@ -51,12 +51,12 @@ void account_process_tick(struct task_st
  	rcu_user_flag = cputime != 0;
  	S390_lowcore.user_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_user_time(tsk, cputime);
+	account_user_time(tsk, cputime, cputime);

  	cputime =  S390_lowcore.system_timer >> 12;
  	S390_lowcore.system_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_system_time(tsk, HARDIRQ_OFFSET, cputime);
+	account_system_time(tsk, HARDIRQ_OFFSET, cputime, cputime);

  	cputime = S390_lowcore.steal_clock;
  	if ((__s64) cputime > 0) {
@@ -83,12 +83,12 @@ void account_vtime(struct task_struct *t
  	cputime = S390_lowcore.user_timer >> 12;
  	S390_lowcore.user_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_user_time(tsk, cputime);
+	account_user_time(tsk, cputime, cputime);

  	cputime =  S390_lowcore.system_timer >> 12;
  	S390_lowcore.system_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_system_time(tsk, 0, cputime);
+	account_system_time(tsk, 0, cputime, cputime);
  }

  /*
@@ -108,7 +108,7 @@ void account_system_vtime(struct task_st
  	cputime =  S390_lowcore.system_timer >> 12;
  	S390_lowcore.system_timer -= cputime << 12;
  	S390_lowcore.steal_clock -= cputime << 12;
-	account_system_time(tsk, 0, cputime);
+	account_system_time(tsk, 0, cputime, cputime);
  }
  EXPORT_SYMBOL_GPL(account_system_vtime);

diff -udrNp linux-2.6.27.orig/include/linux/kernel_stat.h linux-2.6.27/include/linux/kernel_stat.h
--- linux-2.6.27.orig/include/linux/kernel_stat.h	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/include/linux/kernel_stat.h	2009-10-02 05:08:10.543580236 -0500
@@ -52,10 +52,8 @@ static inline int kstat_irqs(int irq)
  	return sum;
  }

-extern void account_user_time(struct task_struct *, cputime_t);
-extern void account_user_time_scaled(struct task_struct *, cputime_t);
-extern void account_system_time(struct task_struct *, int, cputime_t);
-extern void account_system_time_scaled(struct task_struct *, cputime_t);
+extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
+extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
  extern void account_steal_time(struct task_struct *, cputime_t);

  #endif /* _LINUX_KERNEL_STAT_H */
diff -udrNp linux-2.6.27.orig/kernel/sched.c linux-2.6.27/kernel/sched.c
--- linux-2.6.27.orig/kernel/sched.c	2009-10-02 05:07:46.098579687 -0500
+++ linux-2.6.27/kernel/sched.c	2009-10-02 05:08:10.545579395 -0500
@@ -4063,13 +4063,17 @@ unsigned long long task_sched_runtime(st
   * Account user cpu time to a process.
   * @p: the process that the cpu time gets accounted to
   * @cputime: the cpu time spent in user space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
   */
-void account_user_time(struct task_struct *p, cputime_t cputime)
+void account_user_time(struct task_struct *p, cputime_t cputime,
+		       cputime_t cputime_scaled)
  {
  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
  	cputime64_t tmp;

+	/* Add user time to process. */
  	p->utime = cputime_add(p->utime, cputime);
+	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);

  	/* Add user time to cpustat. */
  	tmp = cputime_to_cputime64(cputime);
@@ -4085,50 +4089,48 @@ void account_user_time(struct task_struc
   * Account guest cpu time to a process.
   * @p: the process that the cpu time gets accounted to
   * @cputime: the cpu time spent in virtual machine since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
   */
-static void account_guest_time(struct task_struct *p, cputime_t cputime)
+static void account_guest_time(struct task_struct *p, cputime_t cputime,
+			       cputime_t cputime_scaled)
  {
  	cputime64_t tmp;
  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;

  	tmp = cputime_to_cputime64(cputime);

+	/* Add guest time to process. */
  	p->utime = cputime_add(p->utime, cputime);
+	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
  	p->gtime = cputime_add(p->gtime, cputime);

+	/* Add guest time to cpustat. */
  	cpustat->user = cputime64_add(cpustat->user, tmp);
  	cpustat->guest = cputime64_add(cpustat->guest, tmp);
  }

  /*
- * Account scaled user cpu time to a process.
- * @p: the process that the cpu time gets accounted to
- * @cputime: the cpu time spent in user space since the last update
- */
-void account_user_time_scaled(struct task_struct *p, cputime_t cputime)
-{
-	p->utimescaled = cputime_add(p->utimescaled, cputime);
-}
-
-/*
   * Account system cpu time to a process.
   * @p: the process that the cpu time gets accounted to
   * @hardirq_offset: the offset to subtract from hardirq_count()
   * @cputime: the cpu time spent in kernel space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
   */
  void account_system_time(struct task_struct *p, int hardirq_offset,
-			 cputime_t cputime)
+			 cputime_t cputime, cputime_t cputime_scaled)
  {
  	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
  	struct rq *rq = this_rq();
  	cputime64_t tmp;

  	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0)) {
-		account_guest_time(p, cputime);
+		account_guest_time(p, cputime, cputime_scaled);
  		return;
  	}

+	/* Add system time to process. */
  	p->stime = cputime_add(p->stime, cputime);
+	p->stimescaled = cputime_add(p->stimescaled, cputime_scaled);

  	/* Add system time to cpustat. */
  	tmp = cputime_to_cputime64(cputime);
@@ -4147,17 +4149,6 @@ void account_system_time(struct task_str
  }

  /*
- * Account scaled system cpu time to a process.
- * @p: the process that the cpu time gets accounted to
- * @hardirq_offset: the offset to subtract from hardirq_count()
- * @cputime: the cpu time spent in kernel space since the last update
- */
-void account_system_time_scaled(struct task_struct *p, cputime_t cputime)
-{
-	p->stimescaled = cputime_add(p->stimescaled, cputime);
-}
-
-/*
   * Account for involuntary wait time.
   * @p: the process from which the cpu time has been stolen
   * @steal: the cpu time spent in involuntary wait
diff -udrNp linux-2.6.27.orig/kernel/time/tick-sched.c linux-2.6.27/kernel/time/tick-sched.c
--- linux-2.6.27.orig/kernel/time/tick-sched.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/kernel/time/tick-sched.c	2009-10-02 05:08:10.546579540 -0500
@@ -378,6 +378,7 @@ void tick_nohz_restart_sched_tick(void)
  	int cpu = smp_processor_id();
  	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
  	unsigned long ticks;
+	cputime_t cputime;
  	ktime_t now;

  	local_irq_disable();
@@ -410,8 +411,8 @@ void tick_nohz_restart_sched_tick(void)
  	 */
  	if (ticks && ticks < LONG_MAX) {
  		add_preempt_count(HARDIRQ_OFFSET);
-		account_system_time(current, HARDIRQ_OFFSET,
-				    jiffies_to_cputime(ticks));
+		cputime = jiffies_to_cputime(ticks);
+		account_system_time(current, HARDIRQ_OFFSET, cputime, cputime);
  		sub_preempt_count(HARDIRQ_OFFSET);
  	}

diff -udrNp linux-2.6.27.orig/kernel/timer.c linux-2.6.27/kernel/timer.c
--- linux-2.6.27.orig/kernel/timer.c	2009-10-02 05:07:46.108579580 -0500
+++ linux-2.6.27/kernel/timer.c	2009-10-02 05:08:10.546579540 -0500
@@ -954,13 +954,11 @@ void account_process_tick(struct task_st
  {
  	cputime_t one_jiffy = jiffies_to_cputime(1);

-	if (user_tick) {
-		account_user_time(p, one_jiffy);
-		account_user_time_scaled(p, cputime_to_scaled(one_jiffy));
-	} else {
-		account_system_time(p, HARDIRQ_OFFSET, one_jiffy);
-		account_system_time_scaled(p, cputime_to_scaled(one_jiffy));
-	}
+	if (user_tick)
+		account_user_time(p, one_jiffy, cputime_to_scaled(one_jiffy));
+	else
+		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
+				    cputime_to_scaled(one_jiffy));
  }
  #endif


