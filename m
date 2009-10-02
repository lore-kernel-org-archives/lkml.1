Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZJBUks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZJBUks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 16:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbZJBUkr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 16:40:47 -0400
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:24298 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758122AbZJBUkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 16:40:35 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Oct 2009 16:40:34 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:Content-Type;
  b=Z9WAyEDnxInAH7JmA6Mqfkx2xALvY0L1wU0P9SfEOV3j+hV58Nu0heZdPi8lDyF7DzaKqiZ3XLCC3na08oJ0KP5/ijC0xRQ6YdO3fL04w+jqZpRTGAkVvGxj5vJc1wlwoU9a8KYGtNXlUcczo7xfuEH2kn8uWk1l0vixtb/r3Go=  ;
X-YMail-OSG: aD3ZOxIVM1nUyYqnjt9OQp2Gv6opcXrPBuF5udYUIgQs3Imi1R662qQxFaKWnYRfBQGaH3cdFgsJnK58W2QDnAb3_RuiGtJgLhYdwZOMrqvhYMO.F_rg8Dx5be6foqAhZHnoo10iIWVNx_Sh6Z1rS6_EZ3m4mnxT4.Eb8O6sjXZX_YPHUG6JrtZn1PlwkQyW75M.ZwtvvLw96yzILmpAf6LdImw0p6HR5zJzj6RaUT5NUVjQROIaYyrGKptMZWPUN1rvWJVwKw2fll23WUVkOdJf.iEIMp66juNh9eo5dH6PzlTILYzw4twDTmU_I3Ts12IbCnaZOoivHXvZlFt4ppxRKUtBjiabsXHNOWV7dHB9VCYsfhGLo1SEkto.mA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4AC6638E.3020803@sbcglobal.net>
Date: Fri, 02 Oct 2009 15:33:18 -0500
From: Jayson King <jaysonk@sbcglobal.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090825)
MIME-Version: 1.0
To: kernel@kolivas.org, LKML <linux-kernel@vger.kernel.org>
Subject: backporting BFS to 2.6.27
Content-Type: multipart/mixed;
 boundary="------------090708080309010601040509"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090708080309010601040509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello, Con & LKML

I have started a backport of sched-bfs 300 to kernel 2.6.27.35. I
originally thought of two different ways to do it. Either pull in
mainline patches from .28 ~ .31 until bfs applies cleanly, or change bfs
enough to apply to .27 without needing many mainline patches. The latter
approach seemed to be cleaner. I started by comparing the .31 sched.c to
.27.35 sched.c and applied those backward changes to sched_bfs.c.

I did also apply 3 mainline patches to .27.35, because I couldn't decide
what to do about reverting the account_* functions which bfs changes.
These patches are 457533a7, 79741dd3, and f5f293a4.

The kernel compiles, but it panics:

Kernel alive
Kernel really alive
PANIC: early exception 0e rip 10:ffffffff810ad10b error 0 cr2 18.

There's no stack trace but that address is in __kmalloc.

Can you or others give a hint of what might be going wrong or what I can do?

I've attached the .27'ized patches mentioned above as well as the .27
sched-bfs patch. These patches apply to 2.6.27.35 in order:

linux-2.6.27-457533a7.patch
linux-2.6.27-79741dd3.patch
linux-2.6.27-f5f293a4.patch
2.6.27-sched-bfs-300.patch

Attached also is the .config file.

Thanks.

(if replying from LKML please CC replies to me)

Jayson





--------------090708080309010601040509
Content-Type: text/plain;
 name="linux-2.6.27-457533a7.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.27-457533a7.patch"

commit 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Wed Dec 31 15:11:37 2008 +0100

    [PATCH] fix scaled & unscaled cputime accounting
    
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
 


--------------090708080309010601040509
Content-Type: text/plain;
 name="linux-2.6.27-79741dd3.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.27-79741dd3.patch"

commit 79741dd35713ff4f6fd0eafd59fa94e8a4ba922d
Author: Martin Schwidefsky <schwidefsky@de.ibm.com>
Date:   Wed Dec 31 15:11:38 2008 +0100

    [PATCH] idle cputime accounting
    
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


--------------090708080309010601040509
Content-Type: text/plain;
 name="linux-2.6.27-f5f293a4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.27-f5f293a4.patch"

commit f5f293a4e3d0a0c52cec31de6762c95050156516
Author: Eric Dumazet <dada1@cosmosbay.com>
Date:   Wed Apr 29 14:44:49 2009 +0200

    sched: account system time properly
    
    Andrew Gallatin reported that IRQ and SOFTIRQ times were
    sometime not reported correctly on recent kernels, and even
    bisected to commit 457533a7d3402d1d91fbc125c8bd1bd16dcd3cd4
    ([PATCH] fix scaled & unscaled cputime accounting) as the first
    bad commit.
    
    Further analysis pointed that commit
    79741dd35713ff4f6fd0eafd59fa94e8a4ba922d ([PATCH] idle cputime
    accounting) was the real cause of the problem.
    
    account_process_tick() was not taking into account timer IRQ
    interrupting the idle task servicing a hard or soft irq.
    
    On mostly idle cpu, irqs were thus not accounted and top or
    mpstat could tell user/admin that cpu was 100 % idle, 0.00 %
    irq, 0.00 % softirq, while it was not.
    
    [ Impact: fix occasionally incorrect CPU statistics in top/mpstat ]
    
    Reported-by: Andrew Gallatin <gallatin@myri.com>
    Re-reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
    Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
    Cc: rick.jones2@hp.com
    Cc: brice@myri.com
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
    LKML-Reference: <49F84BC1.7080602@cosmosbay.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff -udrNp linux-2.6.27.orig/kernel/sched.c linux-2.6.27/kernel/sched.c
--- linux-2.6.27.orig/kernel/sched.c	2009-10-02 05:14:57.590579107 -0500
+++ linux-2.6.27/kernel/sched.c	2009-10-02 05:15:19.947578991 -0500
@@ -4187,7 +4187,7 @@ void account_process_tick(struct task_st
 
 	if (user_tick)
 		account_user_time(p, one_jiffy, one_jiffy_scaled);
-	else if (p != rq->idle)
+	else if ((p != rq->idle) || (irq_count() != HARDIRQ_OFFSET))
 		account_system_time(p, HARDIRQ_OFFSET, one_jiffy,
 				    one_jiffy_scaled);
 	else


--------------090708080309010601040509
Content-Type: text/plain;
 name="2.6.27-sched-bfs-300.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="2.6.27-sched-bfs-300.patch"

The Brain Fuck Scheduler v0.300 by Con Kolivas.
backported to kernel 2.6.27.35

---
 Documentation/sysctl/kernel.txt |   26 
 Makefile                        |    2 
 fs/pipe.c                       |    4 
 fs/proc/base.c                  |    2 
 include/linux/init_task.h       |   15 
 include/linux/ioprio.h          |    2 
 include/linux/sched.h           |  184 -
 init/Kconfig                    |   56 
 init/main.c                     |    2 
 kernel/Makefile                 |    4 
 kernel/delayacct.c              |    2 
 kernel/exit.c                   |    3 
 kernel/fork.c                   |    1 
 kernel/kthread.c                |    3 
 kernel/posix-cpu-timers.c       |   20 
 kernel/sched_bfs.c              | 5835 ++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                 |  139 
 kernel/timer.c                  |    3 
 kernel/trace/trace.c            |    4 
 kernel/workqueue.c              |    2 
 mm/oom_kill.c                   |    2 
 21 files changed, 5942 insertions(+), 369 deletions(-)

diff -udrNp linux-2.6.27.orig/Documentation/sysctl/kernel.txt linux-2.6.27/Documentation/sysctl/kernel.txt
--- linux-2.6.27.orig/Documentation/sysctl/kernel.txt	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/Documentation/sysctl/kernel.txt	2009-10-02 15:16:42.014299333 -0500
@@ -25,6 +25,7 @@ show up in /proc/sys/kernel:
 - domainname
 - hostname
 - hotplug
+- iso_cpu
 - java-appletviewer           [ binfmt_java, obsolete ]
 - java-interpreter            [ binfmt_java, obsolete ]
 - kstack_depth_to_print       [ X86 only ]
@@ -44,6 +45,7 @@ show up in /proc/sys/kernel:
 - randomize_va_space
 - real-root-dev               ==> Documentation/initrd.txt
 - reboot-cmd                  [ SPARC only ]
+- rr_interval
 - rtsig-max
 - rtsig-nr
 - sem
@@ -165,6 +167,16 @@ Default value is "/sbin/hotplug".
 
 ==============================================================
 
+iso_cpu:
+
+This sets the percentage cpu that the unprivileged SCHED_ISO tasks can
+run effectively at realtime priority, averaged over a rolling five
+seconds over the -whole- system, meaning all cpus.
+
+Set to 70 (percent) by default.
+
+==============================================================
+
 l2cr: (PPC only)
 
 This flag controls the L2 cache of G3 processor boards. If
@@ -317,6 +329,20 @@ rebooting. ???
 
 ==============================================================
 
+rr_interval:
+
+This is the smallest duration that any cpu process scheduling unit
+will run for. Increasing this value can increase throughput of cpu
+bound tasks substantially but at the expense of increased latencies
+overall. Conversely decreasing it will decrease average and maximum
+latencies but at the expense of throughput. This value is in
+milliseconds and the default value chosen depends on the number of
+cpus available at scheduler initialisation with a minimum of 6.
+
+Valid values are from 1-5000.
+
+==============================================================
+
 rtsig-max & rtsig-nr:
 
 The file rtsig-max can be used to tune the maximum number
diff -udrNp linux-2.6.27.orig/fs/pipe.c linux-2.6.27/fs/pipe.c
--- linux-2.6.27.orig/fs/pipe.c	2009-10-02 15:15:59.887298916 -0500
+++ linux-2.6.27/fs/pipe.c	2009-10-02 15:16:43.245298543 -0500
@@ -42,10 +42,6 @@ void pipe_wait(struct pipe_inode_info *p
 {
 	DEFINE_WAIT(wait);
 
-	/*
-	 * Pipes are system-local resources, so sleeping on them
-	 * is considered a noninteractive wait:
-	 */
 	prepare_to_wait(&pipe->wait, &wait, TASK_INTERRUPTIBLE);
 	if (pipe->inode)
 		mutex_unlock(&pipe->inode->i_mutex);
diff -udrNp linux-2.6.27.orig/fs/proc/base.c linux-2.6.27/fs/proc/base.c
--- linux-2.6.27.orig/fs/proc/base.c	2009-10-02 15:15:59.888298582 -0500
+++ linux-2.6.27/fs/proc/base.c	2009-10-02 15:16:43.245298543 -0500
@@ -340,7 +340,7 @@ static int proc_pid_wchan(struct task_st
 static int proc_pid_schedstat(struct task_struct *task, char *buffer)
 {
 	return sprintf(buffer, "%llu %llu %lu\n",
-			task->sched_info.cpu_time,
+			task->sched_time,
 			task->sched_info.run_delay,
 			task->sched_info.pcount);
 }
diff -udrNp linux-2.6.27.orig/include/linux/init_task.h linux-2.6.27/include/linux/init_task.h
--- linux-2.6.27.orig/include/linux/init_task.h	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/include/linux/init_task.h	2009-10-02 15:16:43.246298502 -0500
@@ -124,21 +124,16 @@ extern struct group_info init_groups;
 	.usage		= ATOMIC_INIT(2),				\
 	.flags		= PF_KTHREAD,					\
 	.lock_depth	= -1,						\
-	.prio		= MAX_PRIO-20,					\
+	.prio		= NORMAL_PRIO,					\
 	.static_prio	= MAX_PRIO-20,					\
-	.normal_prio	= MAX_PRIO-20,					\
+	.normal_prio	= NORMAL_PRIO,					\
+	.deadline	= 0,						\
 	.policy		= SCHED_NORMAL,					\
 	.cpus_allowed	= CPU_MASK_ALL,					\
 	.mm		= NULL,						\
 	.active_mm	= &init_mm,					\
-	.se		= {						\
-		.group_node 	= LIST_HEAD_INIT(tsk.se.group_node),	\
-	},								\
-	.rt		= {						\
-		.run_list	= LIST_HEAD_INIT(tsk.rt.run_list),	\
-		.time_slice	= HZ, 					\
-		.nr_cpus_allowed = NR_CPUS,				\
-	},								\
+	.run_list	= LIST_HEAD_INIT(tsk.run_list),			\
+	.time_slice	= HZ,					\
 	.tasks		= LIST_HEAD_INIT(tsk.tasks),			\
 	.ptraced	= LIST_HEAD_INIT(tsk.ptraced),			\
 	.ptrace_entry	= LIST_HEAD_INIT(tsk.ptrace_entry),		\
diff -udrNp linux-2.6.27.orig/include/linux/ioprio.h linux-2.6.27/include/linux/ioprio.h
--- linux-2.6.27.orig/include/linux/ioprio.h	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/include/linux/ioprio.h	2009-10-02 15:16:43.246298502 -0500
@@ -73,7 +73,7 @@ static inline int task_nice_ioprio(struc
  */
 static inline int task_nice_ioclass(struct task_struct *task)
 {
-	if (task->policy == SCHED_IDLE)
+	if (task->policy == SCHED_IDLEPRIO)
 		return IOPRIO_CLASS_IDLE;
 	else if (task->policy == SCHED_FIFO || task->policy == SCHED_RR)
 		return IOPRIO_CLASS_RT;
diff -udrNp linux-2.6.27.orig/include/linux/sched.h linux-2.6.27/include/linux/sched.h
--- linux-2.6.27.orig/include/linux/sched.h	2009-10-02 15:16:11.114298215 -0500
+++ linux-2.6.27/include/linux/sched.h	2009-10-02 15:18:56.468298843 -0500
@@ -36,8 +36,11 @@
 #define SCHED_FIFO		1
 #define SCHED_RR		2
 #define SCHED_BATCH		3
-/* SCHED_ISO: reserved but not implemented yet */
-#define SCHED_IDLE		5
+#define SCHED_ISO		4
+#define SCHED_IDLEPRIO		5
+
+#define SCHED_MAX		(SCHED_IDLEPRIO)
+#define SCHED_RANGE(policy)	((policy) <= SCHED_MAX)
 
 #ifdef __KERNEL__
 
@@ -137,13 +140,10 @@ extern unsigned long nr_active(void);
 extern unsigned long nr_iowait(void);
 
 struct seq_file;
-struct cfs_rq;
 struct task_group;
 #ifdef CONFIG_SCHED_DEBUG
 extern void proc_sched_show_task(struct task_struct *p, struct seq_file *m);
 extern void proc_sched_set_task(struct task_struct *p);
-extern void
-print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq);
 #else
 static inline void
 proc_sched_show_task(struct task_struct *p, struct seq_file *m)
@@ -152,10 +152,6 @@ proc_sched_show_task(struct task_struct 
 static inline void proc_sched_set_task(struct task_struct *p)
 {
 }
-static inline void
-print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
-{
-}
 #endif
 
 extern unsigned long long time_sync_thresh;
@@ -247,7 +243,7 @@ extern asmlinkage void schedule_tail(str
 extern void init_idle(struct task_struct *idle, int cpu);
 extern void init_idle_bootup_task(struct task_struct *idle);
 
-extern int runqueue_is_locked(void);
+extern int grunqueue_is_locked(void);
 
 extern cpumask_t nohz_cpu_mask;
 #if defined(CONFIG_SMP) && defined(CONFIG_NO_HZ)
@@ -892,141 +888,6 @@ struct uts_namespace;
 struct rq;
 struct sched_domain;
 
-struct sched_class {
-	const struct sched_class *next;
-
-	void (*enqueue_task) (struct rq *rq, struct task_struct *p, int wakeup);
-	void (*dequeue_task) (struct rq *rq, struct task_struct *p, int sleep);
-	void (*yield_task) (struct rq *rq);
-	int  (*select_task_rq)(struct task_struct *p, int sync);
-
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
-
-	struct task_struct * (*pick_next_task) (struct rq *rq);
-	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
-
-#ifdef CONFIG_SMP
-	unsigned long (*load_balance) (struct rq *this_rq, int this_cpu,
-			struct rq *busiest, unsigned long max_load_move,
-			struct sched_domain *sd, enum cpu_idle_type idle,
-			int *all_pinned, int *this_best_prio);
-
-	int (*move_one_task) (struct rq *this_rq, int this_cpu,
-			      struct rq *busiest, struct sched_domain *sd,
-			      enum cpu_idle_type idle);
-	void (*pre_schedule) (struct rq *this_rq, struct task_struct *task);
-	void (*post_schedule) (struct rq *this_rq);
-	void (*task_wake_up) (struct rq *this_rq, struct task_struct *task);
-#endif
-
-	void (*set_curr_task) (struct rq *rq);
-	void (*task_tick) (struct rq *rq, struct task_struct *p, int queued);
-	void (*task_new) (struct rq *rq, struct task_struct *p);
-	void (*set_cpus_allowed)(struct task_struct *p,
-				 const cpumask_t *newmask);
-
-	void (*rq_online)(struct rq *rq);
-	void (*rq_offline)(struct rq *rq);
-
-	void (*switched_from) (struct rq *this_rq, struct task_struct *task,
-			       int running);
-	void (*switched_to) (struct rq *this_rq, struct task_struct *task,
-			     int running);
-	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
-			     int oldprio, int running);
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	void (*moved_group) (struct task_struct *p);
-#endif
-};
-
-struct load_weight {
-	unsigned long weight, inv_weight;
-};
-
-/*
- * CFS stats for a schedulable entity (task, task-group etc)
- *
- * Current field usage histogram:
- *
- *     4 se->block_start
- *     4 se->run_node
- *     4 se->sleep_start
- *     6 se->load.weight
- */
-struct sched_entity {
-	struct load_weight	load;		/* for load-balancing */
-	struct rb_node		run_node;
-	struct list_head	group_node;
-	unsigned int		on_rq;
-
-	u64			exec_start;
-	u64			sum_exec_runtime;
-	u64			vruntime;
-	u64			prev_sum_exec_runtime;
-
-	u64			last_wakeup;
-	u64			avg_overlap;
-
-#ifdef CONFIG_SCHEDSTATS
-	u64			wait_start;
-	u64			wait_max;
-	u64			wait_count;
-	u64			wait_sum;
-
-	u64			sleep_start;
-	u64			sleep_max;
-	s64			sum_sleep_runtime;
-
-	u64			block_start;
-	u64			block_max;
-	u64			exec_max;
-	u64			slice_max;
-
-	u64			nr_migrations;
-	u64			nr_migrations_cold;
-	u64			nr_failed_migrations_affine;
-	u64			nr_failed_migrations_running;
-	u64			nr_failed_migrations_hot;
-	u64			nr_forced_migrations;
-	u64			nr_forced2_migrations;
-
-	u64			nr_wakeups;
-	u64			nr_wakeups_sync;
-	u64			nr_wakeups_migrate;
-	u64			nr_wakeups_local;
-	u64			nr_wakeups_remote;
-	u64			nr_wakeups_affine;
-	u64			nr_wakeups_affine_attempts;
-	u64			nr_wakeups_passive;
-	u64			nr_wakeups_idle;
-#endif
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-	struct sched_entity	*parent;
-	/* rq on which this entity is (to be) queued: */
-	struct cfs_rq		*cfs_rq;
-	/* rq "owned" by this entity/group: */
-	struct cfs_rq		*my_q;
-#endif
-};
-
-struct sched_rt_entity {
-	struct list_head run_list;
-	unsigned int time_slice;
-	unsigned long timeout;
-	int nr_cpus_allowed;
-
-	struct sched_rt_entity *back;
-#ifdef CONFIG_RT_GROUP_SCHED
-	struct sched_rt_entity	*parent;
-	/* rq on which this entity is (to be) queued: */
-	struct rt_rq		*rt_rq;
-	/* rq "owned" by this entity/group: */
-	struct rt_rq		*my_q;
-#endif
-};
-
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1036,17 +897,16 @@ struct task_struct {
 
 	int lock_depth;		/* BKL lock depth */
 
-#ifdef CONFIG_SMP
-#ifdef __ARCH_WANT_UNLOCKED_CTXSW
 	int oncpu;
-#endif
-#endif
-
 	int prio, static_prio, normal_prio;
+	int time_slice, first_time_slice;
+	unsigned long deadline;
+	struct list_head run_list;
 	unsigned int rt_priority;
-	const struct sched_class *sched_class;
-	struct sched_entity se;
-	struct sched_rt_entity rt;
+	u64 last_ran;
+	u64 sched_time; /* sched_clock time spent running */
+
+	unsigned long rt_timeout;
 
 #ifdef CONFIG_PREEMPT_NOTIFIERS
 	/* list of struct preempt_notifier: */
@@ -1069,6 +929,9 @@ struct task_struct {
 
 	unsigned int policy;
 	cpumask_t cpus_allowed;
+#ifdef CONFIG_HOTPLUG_CPU
+	cpumask_t unplugged_mask;
+#endif
 
 #ifdef CONFIG_PREEMPT_RCU
 	int rcu_read_lock_nesting;
@@ -1129,6 +992,7 @@ struct task_struct {
 	int __user *clear_child_tid;		/* CLONE_CHILD_CLEARTID */
 
 	cputime_t utime, stime, utimescaled, stimescaled;
+	unsigned long utime_pc, stime_pc;
 	cputime_t gtime;
 	cputime_t prev_utime, prev_stime;
 	unsigned long nvcsw, nivcsw; /* context switch counts */
@@ -1320,11 +1184,14 @@ struct task_struct {
  * priority to a value higher than any user task. Note:
  * MAX_RT_PRIO must not be smaller than MAX_USER_RT_PRIO.
  */
-
+#define PRIO_RANGE		(40)
 #define MAX_USER_RT_PRIO	100
 #define MAX_RT_PRIO		MAX_USER_RT_PRIO
-
-#define MAX_PRIO		(MAX_RT_PRIO + 40)
+#define MAX_PRIO		(MAX_RT_PRIO + PRIO_RANGE)
+#define ISO_PRIO		(MAX_RT_PRIO)
+#define NORMAL_PRIO		(MAX_RT_PRIO + 1)
+#define IDLE_PRIO		(MAX_RT_PRIO + 2)
+#define PRIO_LIMIT		((IDLE_PRIO) + 1)
 #define DEFAULT_PRIO		(MAX_RT_PRIO + 20)
 
 static inline int rt_prio(int prio)
@@ -1592,11 +1459,7 @@ extern unsigned long long
 task_sched_runtime(struct task_struct *task);
 
 /* sched_exec is called by processes performing an exec */
-#ifdef CONFIG_SMP
-extern void sched_exec(void);
-#else
 #define sched_exec()   {}
-#endif
 
 extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
@@ -1740,6 +1603,7 @@ extern void wake_up_new_task(struct task
  static inline void kick_process(struct task_struct *tsk) { }
 #endif
 extern void sched_fork(struct task_struct *p, int clone_flags);
+extern void sched_exit(struct task_struct *p);
 extern void sched_dead(struct task_struct *p);
 
 extern int in_group_p(gid_t);
diff -udrNp linux-2.6.27.orig/init/Kconfig linux-2.6.27/init/Kconfig
--- linux-2.6.27.orig/init/Kconfig	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/init/Kconfig	2009-10-02 15:16:43.247298473 -0500
@@ -323,62 +323,6 @@ config CPUSETS
 config HAVE_UNSTABLE_SCHED_CLOCK
 	bool
 
-config GROUP_SCHED
-	bool "Group CPU scheduler"
-	depends on EXPERIMENTAL
-	default n
-	help
-	  This feature lets CPU scheduler recognize task groups and control CPU
-	  bandwidth allocation to such task groups.
-
-config FAIR_GROUP_SCHED
-	bool "Group scheduling for SCHED_OTHER"
-	depends on GROUP_SCHED
-	default GROUP_SCHED
-
-config RT_GROUP_SCHED
-	bool "Group scheduling for SCHED_RR/FIFO"
-	depends on EXPERIMENTAL
-	depends on GROUP_SCHED
-	default n
-	help
-	  This feature lets you explicitly allocate real CPU bandwidth
-	  to users or control groups (depending on the "Basis for grouping tasks"
-	  setting below. If enabled, it will also make it impossible to
-	  schedule realtime tasks for non-root users until you allocate
-	  realtime bandwidth for them.
-	  See Documentation/sched-rt-group.txt for more information.
-
-choice
-	depends on GROUP_SCHED
-	prompt "Basis for grouping tasks"
-	default USER_SCHED
-
-config USER_SCHED
-	bool "user id"
-	help
-	  This option will choose userid as the basis for grouping
-	  tasks, thus providing equal CPU bandwidth to each user.
-
-config CGROUP_SCHED
-	bool "Control groups"
- 	depends on CGROUPS
- 	help
-	  This option allows you to create arbitrary task groups
-	  using the "cgroup" pseudo filesystem and control
-	  the cpu bandwidth allocated to each such task group.
-	  Refer to Documentation/cgroups.txt for more information
-	  on "cgroup" pseudo filesystem.
-
-endchoice
-
-config CGROUP_CPUACCT
-	bool "Simple CPU accounting cgroup subsystem"
-	depends on CGROUPS
-	help
-	  Provides a simple Resource Controller for monitoring the
-	  total CPU consumed by the tasks in a cgroup
-
 config RESOURCE_COUNTERS
 	bool "Resource counters"
 	help
diff -udrNp linux-2.6.27.orig/init/main.c linux-2.6.27/init/main.c
--- linux-2.6.27.orig/init/main.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/init/main.c	2009-10-02 15:16:43.247298473 -0500
@@ -800,6 +800,8 @@ static int noinline init_post(void)
 	system_state = SYSTEM_RUNNING;
 	numa_default_policy();
 
+	printk(KERN_INFO"Running BFS CPU scheduler v0.300 by Con Kolivas.\n");
+
 	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) < 0)
 		printk(KERN_WARNING "Warning: unable to open an initial console.\n");
 
diff -udrNp linux-2.6.27.orig/kernel/delayacct.c linux-2.6.27/kernel/delayacct.c
--- linux-2.6.27.orig/kernel/delayacct.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/kernel/delayacct.c	2009-10-02 15:16:43.247298473 -0500
@@ -127,7 +127,7 @@ int __delayacct_add_tsk(struct taskstats
 	 */
 	t1 = tsk->sched_info.pcount;
 	t2 = tsk->sched_info.run_delay;
-	t3 = tsk->sched_info.cpu_time;
+	t3 = tsk->sched_time;
 
 	d->cpu_count += t1;
 
diff -udrNp linux-2.6.27.orig/kernel/exit.c linux-2.6.27/kernel/exit.c
--- linux-2.6.27.orig/kernel/exit.c	2009-10-02 15:15:59.923298964 -0500
+++ linux-2.6.27/kernel/exit.c	2009-10-02 15:16:43.247298473 -0500
@@ -122,7 +122,7 @@ static void __exit_signal(struct task_st
 		sig->inblock += task_io_get_inblock(tsk);
 		sig->oublock += task_io_get_oublock(tsk);
 		task_io_accounting_add(&sig->ioac, &tsk->ioac);
-		sig->sum_sched_runtime += tsk->se.sum_exec_runtime;
+		sig->sum_sched_runtime += tsk->sched_time;
 		sig = NULL; /* Marker for below. */
 	}
 
@@ -193,6 +193,7 @@ repeat:
 			leader->exit_state = EXIT_DEAD;
 	}
 
+	sched_exit(p);
 	write_unlock_irq(&tasklist_lock);
 	release_thread(p);
 	call_rcu(&p->rcu, delayed_put_task_struct);
diff -udrNp linux-2.6.27.orig/kernel/fork.c linux-2.6.27/kernel/fork.c
--- linux-2.6.27.orig/kernel/fork.c	2009-10-02 15:15:59.923298964 -0500
+++ linux-2.6.27/kernel/fork.c	2009-10-02 15:16:43.248298346 -0500
@@ -1156,7 +1156,6 @@ static struct task_struct *copy_process(
 	 * parent's CPU). This avoids alot of nasty races.
 	 */
 	p->cpus_allowed = current->cpus_allowed;
-	p->rt.nr_cpus_allowed = current->rt.nr_cpus_allowed;
 	if (unlikely(!cpu_isset(task_cpu(p), p->cpus_allowed) ||
 			!cpu_online(task_cpu(p))))
 		set_task_cpu(p, smp_processor_id());
diff -udrNp linux-2.6.27.orig/kernel/kthread.c linux-2.6.27/kernel/kthread.c
--- linux-2.6.27.orig/kernel/kthread.c	2009-10-02 15:15:59.925298737 -0500
+++ linux-2.6.27/kernel/kthread.c	2009-10-02 15:16:43.248298346 -0500
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 #include <linux/mutex.h>
 
-#define KTHREAD_NICE_LEVEL (-5)
+#define KTHREAD_NICE_LEVEL (0)
 
 static DEFINE_SPINLOCK(kthread_create_lock);
 static LIST_HEAD(kthread_create_list);
@@ -179,7 +179,6 @@ void kthread_bind(struct task_struct *k,
 	wait_task_inactive(k, 0);
 	set_task_cpu(k, cpu);
 	k->cpus_allowed = cpumask_of_cpu(cpu);
-	k->rt.nr_cpus_allowed = 1;
 	k->flags |= PF_THREAD_BOUND;
 }
 EXPORT_SYMBOL(kthread_bind);
diff -udrNp linux-2.6.27.orig/kernel/Makefile linux-2.6.27/kernel/Makefile
--- linux-2.6.27.orig/kernel/Makefile	2009-10-02 15:15:59.920298812 -0500
+++ linux-2.6.27/kernel/Makefile	2009-10-02 15:16:43.248298346 -0500
@@ -2,7 +2,7 @@
 # Makefile for the linux kernel.
 #
 
-obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
+obj-y     = sched_bfs.o fork.o exec_domain.o panic.o printk.o \
 	    cpu.o exit.o itimer.o time.o softirq.o resource.o \
 	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
@@ -93,7 +93,7 @@ ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_P
 # me.  I suspect most platforms don't need this, but until we know that for sure
 # I turn this off for IA-64 only.  Andreas Schwab says it's also needed on m68k
 # to get a correct value for the wait-channel (WCHAN in ps). --davidm
-CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
+CFLAGS_sched_bfs.o := $(PROFILING) -fno-omit-frame-pointer
 endif
 
 $(obj)/configs.o: $(obj)/config_data.h
diff -udrNp linux-2.6.27.orig/kernel/posix-cpu-timers.c linux-2.6.27/kernel/posix-cpu-timers.c
--- linux-2.6.27.orig/kernel/posix-cpu-timers.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/kernel/posix-cpu-timers.c	2009-10-02 15:16:43.248298346 -0500
@@ -248,7 +248,7 @@ static int cpu_clock_sample_group_locked
 		cpu->sched = p->signal->sum_sched_runtime;
 		/* Add in each other live thread.  */
 		while ((t = next_thread(t)) != p) {
-			cpu->sched += t->se.sum_exec_runtime;
+			cpu->sched += t->sched_time;
 		}
 		cpu->sched += sched_ns(p);
 		break;
@@ -466,7 +466,7 @@ static void cleanup_timers(struct list_h
 void posix_cpu_timers_exit(struct task_struct *tsk)
 {
 	cleanup_timers(tsk->cpu_timers,
-		       tsk->utime, tsk->stime, tsk->se.sum_exec_runtime);
+		       tsk->utime, tsk->stime, tsk->sched_time);
 
 }
 void posix_cpu_timers_exit_group(struct task_struct *tsk)
@@ -474,7 +474,7 @@ void posix_cpu_timers_exit_group(struct 
 	cleanup_timers(tsk->signal->cpu_timers,
 		       cputime_add(tsk->utime, tsk->signal->utime),
 		       cputime_add(tsk->stime, tsk->signal->stime),
-		     tsk->se.sum_exec_runtime + tsk->signal->sum_sched_runtime);
+		     tsk->sched_time + tsk->signal->sum_sched_runtime);
 }
 
 
@@ -535,7 +535,7 @@ static void process_timer_rebalance(stru
 		nsleft = max_t(unsigned long long, nsleft, 1);
 		do {
 			if (likely(!(t->flags & PF_EXITING))) {
-				ns = t->se.sum_exec_runtime + nsleft;
+				ns = t->sched_time + nsleft;
 				if (t->it_sched_expires == 0 ||
 				    t->it_sched_expires > ns) {
 					t->it_sched_expires = ns;
@@ -1004,7 +1004,7 @@ static void check_thread_timers(struct t
 		struct cpu_timer_list *t = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || tsk->se.sum_exec_runtime < t->expires.sched) {
+		if (!--maxfire || tsk->sched_time < t->expires.sched) {
 			tsk->it_sched_expires = t->expires.sched;
 			break;
 		}
@@ -1020,7 +1020,7 @@ static void check_thread_timers(struct t
 		unsigned long *soft = &sig->rlim[RLIMIT_RTTIME].rlim_cur;
 
 		if (hard != RLIM_INFINITY &&
-		    tsk->rt.timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
+		    tsk->rt_timeout > DIV_ROUND_UP(hard, USEC_PER_SEC/HZ)) {
 			/*
 			 * At the hard limit, we just die.
 			 * No need to calculate anything else now.
@@ -1028,7 +1028,7 @@ static void check_thread_timers(struct t
 			__group_send_sig_info(SIGKILL, SEND_SIG_PRIV, tsk);
 			return;
 		}
-		if (tsk->rt.timeout > DIV_ROUND_UP(*soft, USEC_PER_SEC/HZ)) {
+		if (tsk->rt_timeout > DIV_ROUND_UP(*soft, USEC_PER_SEC/HZ)) {
 			/*
 			 * At the soft limit, send a SIGXCPU every second.
 			 */
@@ -1081,7 +1081,7 @@ static void check_process_timers(struct 
 	do {
 		utime = cputime_add(utime, t->utime);
 		stime = cputime_add(stime, t->stime);
-		sum_sched_runtime += t->se.sum_exec_runtime;
+		sum_sched_runtime += t->sched_time;
 		t = next_thread(t);
 	} while (t != tsk);
 	ptime = cputime_add(utime, stime);
@@ -1240,7 +1240,7 @@ static void check_process_timers(struct 
 				t->it_virt_expires = ticks;
 			}
 
-			sched = t->se.sum_exec_runtime + sched_left;
+			sched = t->sched_time + sched_left;
 			if (sched_expires && (t->it_sched_expires == 0 ||
 					      t->it_sched_expires > sched)) {
 				t->it_sched_expires = sched;
@@ -1332,7 +1332,7 @@ void run_posix_cpu_timers(struct task_st
 
 	if (UNEXPIRED(prof) && UNEXPIRED(virt) &&
 	    (tsk->it_sched_expires == 0 ||
-	     tsk->se.sum_exec_runtime < tsk->it_sched_expires))
+	     tsk->sched_time < tsk->it_sched_expires))
 		return;
 
 #undef	UNEXPIRED
diff -udrNp linux-2.6.27.orig/kernel/sched_bfs.c linux-2.6.27/kernel/sched_bfs.c
--- linux-2.6.27.orig/kernel/sched_bfs.c	1969-12-31 18:00:00.000000000 -0600
+++ linux-2.6.27/kernel/sched_bfs.c	2009-10-02 15:16:43.251298137 -0500
@@ -0,0 +1,5835 @@
+/*
+ *  kernel/sched_bfs.c, was sched.c
+ *
+ *  Kernel scheduler and related syscalls
+ *
+ *  Copyright (C) 1991-2002  Linus Torvalds
+ *
+ *  1996-12-23  Modified by Dave Grothe to fix bugs in semaphores and
+ *		make semaphores SMP safe
+ *  1998-11-19	Implemented schedule_timeout() and related stuff
+ *		by Andrea Arcangeli
+ *  2002-01-04	New ultra-scalable O(1) scheduler by Ingo Molnar:
+ *		hybrid priority-list and round-robin design with
+ *		an array-switch method of distributing timeslices
+ *		and per-CPU runqueues.  Cleanups and useful suggestions
+ *		by Davide Libenzi, preemptible kernel bits by Robert Love.
+ *  2003-09-03	Interactivity tuning by Con Kolivas.
+ *  2004-04-02	Scheduler domains code by Nick Piggin
+ *  2007-04-15  Work begun on replacing all interactivity tuning with a
+ *              fair scheduling design by Con Kolivas.
+ *  2007-05-05  Load balancing (smp-nice) and other improvements
+ *              by Peter Williams
+ *  2007-05-06  Interactivity improvements to CFS by Mike Galbraith
+ *  2007-07-01  Group scheduling enhancements by Srivatsa Vaddagiri
+ *  2007-11-29  RT balancing improvements by Steven Rostedt, Gregory Haskins,
+ *              Thomas Gleixner, Mike Kravetz
+ *  now		Brainfuck deadline scheduling policy by Con Kolivas deletes
+ *              a whole lot of those previous things.
+ */
+
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/nmi.h>
+#include <linux/init.h>
+#include <asm/uaccess.h>
+#include <linux/highmem.h>
+#include <linux/smp_lock.h>
+#include <asm/mmu_context.h>
+#include <linux/interrupt.h>
+#include <linux/capability.h>
+#include <linux/completion.h>
+#include <linux/kernel_stat.h>
+#include <linux/debug_locks.h>
+#include <linux/security.h>
+#include <linux/notifier.h>
+#include <linux/profile.h>
+#include <linux/freezer.h>
+#include <linux/vmalloc.h>
+#include <linux/blkdev.h>
+#include <linux/delay.h>
+#include <linux/smp.h>
+#include <linux/threads.h>
+#include <linux/timer.h>
+#include <linux/rcupdate.h>
+#include <linux/cpu.h>
+#include <linux/cpuset.h>
+#include <linux/cpumask.h>
+#include <linux/percpu.h>
+#include <linux/kthread.h>
+#include <linux/seq_file.h>
+#include <linux/syscalls.h>
+#include <linux/times.h>
+#include <linux/tsacct_kern.h>
+#include <linux/kprobes.h>
+#include <linux/delayacct.h>
+#include <linux/reciprocal_div.h>
+#include <linux/log2.h>
+#include <linux/ftrace.h>
+
+#include <asm/tlb.h>
+#include <asm/unistd.h>
+
+#define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
+#define rt_task(p)		rt_prio((p)->prio)
+#define rt_queue(rq)		rt_prio((rq)->rq_prio)
+#define batch_task(p)		(unlikely((p)->policy == SCHED_BATCH))
+#define is_rt_policy(policy)	((policy) == SCHED_FIFO || \
+					(policy) == SCHED_RR)
+#define has_rt_policy(p)	unlikely(is_rt_policy((p)->policy))
+#define idleprio_task(p)	unlikely((p)->policy == SCHED_IDLEPRIO)
+#define iso_task(p)		unlikely((p)->policy == SCHED_ISO)
+#define iso_queue(rq)		unlikely((rq)->rq_policy == SCHED_ISO)
+#define ISO_PERIOD		((5 * HZ * num_online_cpus()) + 1)
+
+/*
+ * Convert user-nice values [ -20 ... 0 ... 19 ]
+ * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
+ * and back.
+ */
+#define NICE_TO_PRIO(nice)	(MAX_RT_PRIO + (nice) + 20)
+#define PRIO_TO_NICE(prio)	((prio) - MAX_RT_PRIO - 20)
+#define TASK_NICE(p)		PRIO_TO_NICE((p)->static_prio)
+
+/*
+ * 'User priority' is the nice value converted to something we
+ * can work with better when scaling various scheduler parameters,
+ * it's a [ 0 ... 39 ] range.
+ */
+#define USER_PRIO(p)		((p)-MAX_RT_PRIO)
+#define TASK_USER_PRIO(p)	USER_PRIO((p)->static_prio)
+#define MAX_USER_PRIO		(USER_PRIO(MAX_PRIO))
+#define SCHED_PRIO(p)		((p)+MAX_RT_PRIO)
+
+/* Some helpers for converting to/from various scales.*/
+#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define MS_TO_NS(TIME)		((TIME) * 1000000)
+#define MS_TO_US(TIME)		((TIME) * 1000)
+
+#ifdef CONFIG_SMP
+/*
+ * Divide a load by a sched group cpu_power : (load / sg->__cpu_power)
+ * Since cpu_power is a 'constant', we can use a reciprocal divide.
+ */
+static inline u32 sg_div_cpu_power(const struct sched_group *sg, u32 load)
+{
+	return reciprocal_divide(load, sg->reciprocal_cpu_power);
+}
+
+/*
+ * Each time a sched group cpu_power is changed,
+ * we must compute its reciprocal value
+ */
+static inline void sg_inc_cpu_power(struct sched_group *sg, u32 val)
+{
+	sg->__cpu_power += val;
+	sg->reciprocal_cpu_power = reciprocal_value(sg->__cpu_power);
+}
+#endif
+
+/*
+ * This is the time all tasks within the same priority round robin.
+ * Value is in ms and set to a minimum of 6ms. Scales with number of cpus.
+ * Tunable via /proc interface.
+ */
+int rr_interval __read_mostly = 6;
+
+/*
+ * sched_iso_cpu - sysctl which determines the cpu percentage SCHED_ISO tasks
+ * are allowed to run five seconds as real time tasks. This is the total over
+ * all online cpus.
+ */
+int sched_iso_cpu __read_mostly = 70;
+
+/*
+ * The relative length of deadline for each priority(nice) level.
+ */
+int prio_ratios[PRIO_RANGE] __read_mostly;
+
+/*
+ * The quota handed out to tasks of all priority levels when refilling their
+ * time_slice.
+ */
+static inline unsigned long timeslice(void)
+{
+	return MS_TO_US(rr_interval);
+}
+
+/*
+ * The global runqueue data that all CPUs work off. All data is protected
+ * by grq.lock.
+ */
+struct global_rq {
+	spinlock_t lock;
+	unsigned long nr_running;
+	unsigned long nr_uninterruptible;
+	unsigned long long nr_switches;
+	struct list_head queue[PRIO_LIMIT];
+	DECLARE_BITMAP(prio_bitmap, PRIO_LIMIT + 1);
+	unsigned long iso_ticks;
+	unsigned short iso_refractory;
+#ifdef CONFIG_SMP
+	unsigned long qnr; /* queued not running */
+	cpumask_t cpu_idle_map;
+#endif
+};
+
+/* There can be only one */
+static struct global_rq grq;
+
+/*
+ * This is the main, per-CPU runqueue data structure.
+ * This data should only be modified by the local cpu.
+ */
+struct rq {
+#ifdef CONFIG_SMP
+#ifdef CONFIG_NO_HZ
+	unsigned char in_nohz_recently;
+#endif
+#endif
+
+	struct task_struct *curr, *idle;
+	struct mm_struct *prev_mm;
+
+	/* Stored data about rq->curr to work outside grq lock */
+	unsigned long rq_deadline;
+	unsigned int rq_policy;
+	int rq_time_slice;
+	u64 rq_last_ran;
+	int rq_prio;
+
+	/* Accurate timekeeping data */
+	u64 timekeep_clock;
+	unsigned long user_pc, nice_pc, irq_pc, softirq_pc, system_pc,
+			iowait_pc, idle_pc;
+	atomic_t nr_iowait;
+
+	int cpu;		/* cpu of this runqueue */
+	int online;
+
+#ifdef CONFIG_SMP
+	struct root_domain *rd;
+	struct sched_domain *sd;
+	unsigned long *cpu_locality; /* CPU relative cache distance */
+
+	struct list_head migration_queue;
+#endif
+
+	u64 clock;
+#ifdef CONFIG_SCHEDSTATS
+
+	/* latency stats */
+	struct sched_info rq_sched_info;
+
+	/* sys_sched_yield() stats */
+	unsigned int yld_exp_empty;
+	unsigned int yld_act_empty;
+	unsigned int yld_both_empty;
+	unsigned int yld_count;
+
+	/* schedule() stats */
+	unsigned int sched_switch;
+	unsigned int sched_count;
+	unsigned int sched_goidle;
+
+	/* try_to_wake_up() stats */
+	unsigned int ttwu_count;
+	unsigned int ttwu_local;
+
+	/* BKL stats */
+	unsigned int bkl_count;
+#endif
+};
+
+static DEFINE_PER_CPU(struct rq, runqueues) ____cacheline_aligned_in_smp;
+static DEFINE_MUTEX(sched_hotcpu_mutex);
+
+#ifdef CONFIG_SMP
+
+/*
+ * We add the notion of a root-domain which will be used to define per-domain
+ * variables. Each exclusive cpuset essentially defines an island domain by
+ * fully partitioning the member cpus from any other cpuset. Whenever a new
+ * exclusive cpuset is created, we also create and attach a new root-domain
+ * object.
+ *
+ */
+struct root_domain {
+	atomic_t refcount;
+	cpumask_t span;
+	cpumask_t online;
+
+	/*
+	 * The "RT overload" flag: it gets set if a CPU has more than
+	 * one runnable RT task.
+	 */
+	cpumask_t rto_mask;
+	atomic_t rto_count;
+};
+
+/*
+ * By default the system creates a single root-domain with all cpus as
+ * members (mimicking the global state we have today).
+ */
+static struct root_domain def_root_domain;
+#endif
+
+static inline int cpu_of(struct rq *rq)
+{
+#ifdef CONFIG_SMP
+	return rq->cpu;
+#else
+	return 0;
+#endif
+}
+
+/*
+ * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
+ * See detach_destroy_domains: synchronize_sched for details.
+ *
+ * The domain tree of any CPU may only be accessed from within
+ * preempt-disabled sections.
+ */
+#define for_each_domain(cpu, __sd) \
+	for (__sd = rcu_dereference(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+
+#define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
+#define this_rq()		(&__get_cpu_var(runqueues))
+#define task_rq(p)		cpu_rq(task_cpu(p))
+#define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
+
+#include "sched_stats.h"
+
+#ifndef prepare_arch_switch
+# define prepare_arch_switch(next)	do { } while (0)
+#endif
+#ifndef finish_arch_switch
+# define finish_arch_switch(prev)	do { } while (0)
+#endif
+
+/*
+ * All common locking functions performed on grq.lock. rq->clock is local to
+ * the cpu accessing it so it can be modified just with interrupts disabled,
+ * but looking up task_rq must be done under grq.lock to be safe.
+ */
+static inline void update_rq_clock(struct rq *rq)
+{
+	rq->clock = sched_clock_cpu(cpu_of(rq));
+}
+
+static inline int task_running(struct task_struct *p)
+{
+	return (!!p->oncpu);
+}
+
+static inline void grq_lock(void)
+	__acquires(grq.lock)
+{
+	spin_lock(&grq.lock);
+}
+
+static inline void grq_unlock(void)
+	__releases(grq.lock)
+{
+	spin_unlock(&grq.lock);
+}
+
+static inline void grq_lock_irq(void)
+	__acquires(grq.lock)
+{
+	spin_lock_irq(&grq.lock);
+}
+
+static inline void time_lock_grq(struct rq *rq)
+	__acquires(grq.lock)
+{
+	update_rq_clock(rq);
+	grq_lock();
+}
+
+static inline void grq_unlock_irq(void)
+	__releases(grq.lock)
+{
+	spin_unlock_irq(&grq.lock);
+}
+
+static inline void grq_lock_irqsave(unsigned long *flags)
+	__acquires(grq.lock)
+{
+	spin_lock_irqsave(&grq.lock, *flags);
+}
+
+static inline void grq_unlock_irqrestore(unsigned long *flags)
+	__releases(grq.lock)
+{
+	spin_unlock_irqrestore(&grq.lock, *flags);
+}
+
+static inline struct rq
+*task_grq_lock(struct task_struct *p, unsigned long *flags)
+	__acquires(grq.lock)
+{
+	grq_lock_irqsave(flags);
+	return task_rq(p);
+}
+
+static inline struct rq
+*time_task_grq_lock(struct task_struct *p, unsigned long *flags)
+	__acquires(grq.lock)
+{
+	struct rq *rq = task_grq_lock(p, flags);
+	update_rq_clock(rq);
+	return rq;
+}
+
+static inline struct rq
+*task_grq_lock_irq(struct task_struct *p)
+	__acquires(grq.lock)
+{
+	grq_lock_irq();
+	return task_rq(p);
+}
+
+static inline void
+time_task_grq_lock_irq(struct task_struct *p)
+	__acquires(grq.lock)
+{
+	struct rq *rq = task_grq_lock_irq(p);
+	update_rq_clock(rq);
+}
+
+static inline void
+task_grq_unlock_irq(void)
+	__releases(grq.lock)
+{
+	grq_unlock_irq();
+}
+
+static inline void task_grq_unlock(unsigned long *flags)
+	__releases(grq.lock)
+{
+	grq_unlock_irqrestore(flags);
+}
+
+/**
+ * grunqueue_is_locked
+ *
+ * Returns true if the global runqueue is locked.
+ * This interface allows printk to be called with the runqueue lock
+ * held and know whether or not it is OK to wake up the klogd.
+ */
+inline int grunqueue_is_locked(void)
+{
+	return spin_is_locked(&grq.lock);
+}
+
+static inline void time_grq_lock(struct rq *rq, unsigned long *flags)
+	__acquires(grq.lock)
+{
+	local_irq_save(*flags);
+	time_lock_grq(rq);
+}
+
+static inline struct rq *__task_grq_lock(struct task_struct *p)
+	__acquires(grq.lock)
+{
+	grq_lock();
+	return task_rq(p);
+}
+
+static inline void __task_grq_unlock(void)
+	__releases(grq.lock)
+{
+	grq_unlock();
+}
+
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
+static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+{
+}
+
+static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+{
+#ifdef CONFIG_DEBUG_SPINLOCK
+	/* this is a valid case when another task releases the spinlock */
+	grq.lock.owner = current;
+#endif
+	/*
+	 * If we are tracking spinlock dependencies then we have to
+	 * fix up the runqueue lock - which gets 'carried over' from
+	 * prev into current:
+	 */
+	spin_acquire(&grq.lock.dep_map, 0, 0, _THIS_IP_);
+
+	grq_unlock_irq();
+}
+
+#else /* __ARCH_WANT_UNLOCKED_CTXSW */
+
+static inline void prepare_lock_switch(struct rq *rq, struct task_struct *next)
+{
+#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	grq_unlock_irq();
+#else
+	grq_unlock();
+#endif
+}
+
+static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
+{
+	smp_wmb();
+#ifndef __ARCH_WANT_INTERRUPTS_ON_CTXSW
+	local_irq_enable();
+#endif
+}
+#endif /* __ARCH_WANT_UNLOCKED_CTXSW */
+
+/*
+ * A task that is queued but not running will be on the grq run list.
+ * A task that is not running or queued will not be on the grq run list.
+ * A task that is currently running will have ->oncpu set but not on the
+ * grq run list.
+ */
+static inline int task_queued(struct task_struct *p)
+{
+	return (!list_empty(&p->run_list));
+}
+
+/*
+ * Removing from the global runqueue. Enter with grq locked.
+ */
+static void dequeue_task(struct task_struct *p)
+{
+	list_del_init(&p->run_list);
+	if (list_empty(grq.queue + p->prio))
+		__clear_bit(p->prio, grq.prio_bitmap);
+}
+
+static inline void reset_first_time_slice(struct task_struct *p)
+{
+	if (unlikely(p->first_time_slice))
+		p->first_time_slice = 0;
+}
+
+static int idleprio_suitable(struct task_struct *p)
+{
+	return (!freezing(p) && !signal_pending(p) &&
+		!(task_contributes_to_load(p)) && !(p->flags & (PF_EXITING)));
+}
+
+static int isoprio_suitable(void)
+{
+	return !grq.iso_refractory;
+}
+
+/*
+ * Adding to the global runqueue. Enter with grq locked.
+ */
+static void enqueue_task(struct task_struct *p)
+{
+	if (!rt_task(p)) {
+		/* Check it hasn't gotten rt from PI */
+		if ((idleprio_task(p) && idleprio_suitable(p)) ||
+		   (iso_task(p) && isoprio_suitable()))
+			p->prio = p->normal_prio;
+		else
+			p->prio = NORMAL_PRIO;
+	}
+	__set_bit(p->prio, grq.prio_bitmap);
+	list_add_tail(&p->run_list, grq.queue + p->prio);
+	sched_info_queued(p);
+}
+
+/* Only idle task does this as a real time task*/
+static inline void enqueue_task_head(struct task_struct *p)
+{
+	__set_bit(p->prio, grq.prio_bitmap);
+	list_add(&p->run_list, grq.queue + p->prio);
+	sched_info_queued(p);
+}
+
+static inline void requeue_task(struct task_struct *p)
+{
+	sched_info_queued(p);
+}
+
+static inline int pratio(struct task_struct *p)
+{
+	return prio_ratios[TASK_USER_PRIO(p)];
+}
+
+/*
+ * task_timeslice - all tasks of all priorities get the exact same timeslice
+ * length. CPU distribution is handled by giving different deadlines to
+ * tasks of different priorities.
+ */
+static inline int task_timeslice(struct task_struct *p)
+{
+	return (rr_interval * pratio(p) / 100);
+}
+
+#ifdef CONFIG_SMP
+static inline void inc_qnr(void)
+{
+	grq.qnr++;
+}
+
+static inline void dec_qnr(void)
+{
+	grq.qnr--;
+}
+
+static inline int queued_notrunning(void)
+{
+	return grq.qnr;
+}
+
+static inline void set_cpuidle_map(unsigned long cpu)
+{
+	cpu_set(cpu, grq.cpu_idle_map);
+}
+
+static inline void clear_cpuidle_map(unsigned long cpu)
+{
+	cpu_clear(cpu, grq.cpu_idle_map);
+}
+
+static int suitable_idle_cpus(struct task_struct *p)
+{
+	return (cpus_intersects(p->cpus_allowed, grq.cpu_idle_map));
+}
+
+static inline void resched_suitable_idle(struct task_struct *p)
+{
+	cpumask_t tmp;
+
+	cpus_and(tmp, p->cpus_allowed, grq.cpu_idle_map);
+
+	if (!cpus_empty(tmp))
+		wake_up_idle_cpu(first_cpu(tmp));
+}
+
+/*
+ * The cpu cache locality difference between CPUs is used to determine how far
+ * to offset the virtual deadline. "One" difference in locality means that one
+ * timeslice difference is allowed longer for the cpu local tasks. This is
+ * enough in the common case when tasks are up to 2* number of CPUs to keep
+ * tasks within their shared cache CPUs only. See sched_init_smp for how
+ * locality is determined.
+ */
+static inline int
+cache_distance(struct rq *task_rq, struct rq *rq, struct task_struct *p)
+{
+	return rq->cpu_locality[task_rq->cpu] * task_timeslice(p);
+}
+#else /* CONFIG_SMP */
+static inline void inc_qnr(void)
+{
+}
+
+static inline void dec_qnr(void)
+{
+}
+
+static inline int queued_notrunning(void)
+{
+	return grq.nr_running;
+}
+
+static inline void set_cpuidle_map(unsigned long cpu)
+{
+}
+
+static inline void clear_cpuidle_map(unsigned long cpu)
+{
+}
+
+/* Always called from a busy cpu on UP */
+static inline int suitable_idle_cpus(struct task_struct *p)
+{
+	return 0;
+}
+
+static inline void resched_suitable_idle(struct task_struct *p)
+{
+}
+
+static inline int
+cache_distance(struct rq *task_rq, struct rq *rq, struct task_struct *p)
+{
+	return 0;
+}
+#endif /* CONFIG_SMP */
+
+/*
+ * activate_idle_task - move idle task to the _front_ of runqueue.
+ */
+static inline void activate_idle_task(struct task_struct *p)
+{
+	enqueue_task_head(p);
+	grq.nr_running++;
+	inc_qnr();
+}
+
+static inline int normal_prio(struct task_struct *p)
+{
+	if (has_rt_policy(p))
+		return MAX_RT_PRIO - 1 - p->rt_priority;
+	if (idleprio_task(p))
+		return IDLE_PRIO;
+	if (iso_task(p))
+		return ISO_PRIO;
+	return NORMAL_PRIO;
+}
+
+/*
+ * Calculate the current priority, i.e. the priority
+ * taken into account by the scheduler. This value might
+ * be boosted by RT tasks as it will be RT if the task got
+ * RT-boosted. If not then it returns p->normal_prio.
+ */
+static int effective_prio(struct task_struct *p)
+{
+	p->normal_prio = normal_prio(p);
+	/*
+	 * If we are RT tasks or we were boosted to RT priority,
+	 * keep the priority unchanged. Otherwise, update priority
+	 * to the normal priority:
+	 */
+	if (!rt_prio(p->prio))
+		return p->normal_prio;
+	return p->prio;
+}
+
+/*
+ * activate_task - move a task to the runqueue. Enter with grq locked. The rq
+ * doesn't really matter but gives us the local clock.
+ */
+static void activate_task(struct task_struct *p, struct rq *rq)
+{
+	u64 now;
+
+	update_rq_clock(rq);
+	now = rq->clock;
+
+	/*
+	 * Sleep time is in units of nanosecs, so shift by 20 to get a
+	 * milliseconds-range estimation of the amount of time that the task
+	 * spent sleeping:
+	 */
+	if (unlikely(prof_on == SLEEP_PROFILING)) {
+		if (p->state == TASK_UNINTERRUPTIBLE)
+			profile_hits(SLEEP_PROFILING, (void *)get_wchan(p),
+				     (now - p->last_ran) >> 20);
+	}
+
+	p->prio = effective_prio(p);
+	if (task_contributes_to_load(p))
+		grq.nr_uninterruptible--;
+	enqueue_task(p);
+	grq.nr_running++;
+	inc_qnr();
+}
+
+/*
+ * deactivate_task - If it's running, it's not on the grq and we can just
+ * decrement the nr_running.
+ */
+static inline void deactivate_task(struct task_struct *p)
+{
+	if (task_contributes_to_load(p))
+		grq.nr_uninterruptible++;
+	grq.nr_running--;
+}
+
+#ifdef CONFIG_SMP
+void set_task_cpu(struct task_struct *p, unsigned int cpu)
+{
+	/*
+	 * After ->cpu is set up to a new value, task_grq_lock(p, ...) can be
+	 * successfuly executed on another CPU. We must ensure that updates of
+	 * per-task data have been completed by this moment.
+	 */
+	smp_wmb();
+	task_thread_info(p)->cpu = cpu;
+}
+#endif
+
+/*
+ * Move a task off the global queue and take it to a cpu for it will
+ * become the running task.
+ */
+static inline void take_task(struct rq *rq, struct task_struct *p)
+{
+	set_task_cpu(p, rq->cpu);
+	dequeue_task(p);
+	dec_qnr();
+}
+
+/*
+ * Returns a descheduling task to the grq runqueue unless it is being
+ * deactivated.
+ */
+static inline void return_task(struct task_struct *p, int deactivate)
+{
+	if (deactivate)
+		deactivate_task(p);
+	else {
+		inc_qnr();
+		enqueue_task(p);
+	}
+}
+
+/*
+ * resched_task - mark a task 'to be rescheduled now'.
+ *
+ * On UP this means the setting of the need_resched flag, on SMP it
+ * might also involve a cross-CPU call to trigger the scheduler on
+ * the target CPU.
+ */
+#ifdef CONFIG_SMP
+
+#ifndef tsk_is_polling
+#define tsk_is_polling(t) test_tsk_thread_flag(t, TIF_POLLING_NRFLAG)
+#endif
+
+static void resched_task(struct task_struct *p)
+{
+	int cpu;
+
+	assert_spin_locked(&grq.lock);
+
+	if (unlikely(test_tsk_thread_flag(p, TIF_NEED_RESCHED)))
+		return;
+
+	set_tsk_thread_flag(p, TIF_NEED_RESCHED);
+
+	cpu = task_cpu(p);
+	if (cpu == smp_processor_id())
+		return;
+
+	/* NEED_RESCHED must be visible before we test polling */
+	smp_mb();
+	if (!tsk_is_polling(p))
+		smp_send_reschedule(cpu);
+}
+
+#else
+static inline void resched_task(struct task_struct *p)
+{
+	assert_spin_locked(&grq.lock);
+	set_tsk_need_resched(p);
+}
+#endif
+
+/**
+ * task_curr - is this task currently executing on a CPU?
+ * @p: the task in question.
+ */
+inline int task_curr(const struct task_struct *p)
+{
+	return cpu_curr(task_cpu(p)) == p;
+}
+
+#ifdef CONFIG_SMP
+struct migration_req {
+	struct list_head list;
+
+	struct task_struct *task;
+	int dest_cpu;
+
+	struct completion done;
+};
+
+/*
+ * wait_task_inactive - wait for a thread to unschedule.
+ *
+ * If @match_state is nonzero, it's the @p->state value just checked and
+ * not expected to change.  If it changes, i.e. @p might have woken up,
+ * then return zero.  When we succeed in waiting for @p to be off its CPU,
+ * we return a positive number (its total switch count).  If a second call
+ * a short while later returns the same number, the caller can be sure that
+ * @p has remained unscheduled the whole time.
+ *
+ * The caller must ensure that the task *will* unschedule sometime soon,
+ * else this function might spin for a *long* time. This function can't
+ * be called with interrupts off, or it may introduce deadlock with
+ * smp_call_function() if an IPI is sent by the same process we are
+ * waiting to become inactive.
+ */
+unsigned long wait_task_inactive(struct task_struct *p, long match_state)
+{
+	unsigned long flags;
+	int running, on_rq;
+	unsigned long ncsw;
+	struct rq *rq;
+
+	for (;;) {
+		/*
+		 * We do the initial early heuristics without holding
+		 * any task-queue locks at all. We'll only try to get
+		 * the runqueue lock when things look like they will
+		 * work out! In the unlikely event rq is dereferenced
+		 * since we're lockless, grab it again.
+		 */
+retry_rq:
+		rq = task_rq(p);
+		if (unlikely(!rq))
+			goto retry_rq;
+
+		/*
+		 * If the task is actively running on another CPU
+		 * still, just relax and busy-wait without holding
+		 * any locks.
+		 *
+		 * NOTE! Since we don't hold any locks, it's not
+		 * even sure that "rq" stays as the right runqueue!
+		 * But we don't care, since this will return false
+		 * if the runqueue has changed and p is actually now
+		 * running somewhere else!
+		 */
+		while (task_running(p) && p == rq->curr) {
+			if (match_state && unlikely(p->state != match_state))
+				return 0;
+			cpu_relax();
+		}
+
+		/*
+		 * Ok, time to look more closely! We need the grq
+		 * lock now, to be *sure*. If we're wrong, we'll
+		 * just go back and repeat.
+		 */
+		rq = task_grq_lock(p, &flags);
+		running = task_running(p);
+		on_rq = task_queued(p);
+		ncsw = 0;
+		if (!match_state || p->state == match_state) {
+			ncsw = p->nivcsw + p->nvcsw;
+			if (unlikely(!ncsw))
+				ncsw = 1;
+		}
+		task_grq_unlock(&flags);
+
+		/*
+		 * If it changed from the expected state, bail out now.
+		 */
+		if (unlikely(!ncsw))
+			break;
+
+		/*
+		 * Was it really running after all now that we
+		 * checked with the proper locks actually held?
+		 *
+		 * Oops. Go back and try again..
+		 */
+		if (unlikely(running)) {
+			cpu_relax();
+			continue;
+		}
+
+		/*
+		 * It's not enough that it's not actively running,
+		 * it must be off the runqueue _entirely_, and not
+		 * preempted!
+		 *
+		 * So if it wa still runnable (but just not actively
+		 * running right now), it's preempted, and we should
+		 * yield - it could be a while.
+		 */
+		if (unlikely(on_rq)) {
+			schedule_timeout_uninterruptible(1);
+			continue;
+		}
+
+		/*
+		 * Ahh, all good. It wasn't running, and it wasn't
+		 * runnable, which means that it will never become
+		 * running in the future either. We're all done!
+		 */
+		break;
+	}
+
+	return ncsw;
+}
+
+/***
+ * kick_process - kick a running thread to enter/exit the kernel
+ * @p: the to-be-kicked thread
+ *
+ * Cause a process which is running on another CPU to enter
+ * kernel-mode, without any delay. (to get signals handled.)
+ *
+ * NOTE: this function doesnt have to take the runqueue lock,
+ * because all it wants to ensure is that the remote task enters
+ * the kernel. If the IPI races and the task has been migrated
+ * to another CPU then no harm is done and the purpose has been
+ * achieved as well.
+ */
+void kick_process(struct task_struct *p)
+{
+	int cpu;
+
+	preempt_disable();
+	cpu = task_cpu(p);
+	if ((cpu != smp_processor_id()) && task_curr(p))
+		smp_send_reschedule(cpu);
+	preempt_enable();
+}
+#endif
+
+#define rq_idle(rq)	((rq)->rq_prio == PRIO_LIMIT)
+#define task_idle(p)	((p)->prio == PRIO_LIMIT)
+
+/*
+ * RT tasks preempt purely on priority. SCHED_NORMAL tasks preempt on the
+ * basis of earlier deadlines. SCHED_BATCH, ISO and IDLEPRIO don't preempt
+ * between themselves, they cooperatively multitask.
+ */
+static inline int task_preempts_curr(struct task_struct *p, struct rq *rq)
+{
+	if (p->prio < rq->rq_prio)
+		return 1;
+	if (p->policy == SCHED_NORMAL) {
+		unsigned long p_deadline = p->deadline +
+			cache_distance(task_rq(p), rq, p);
+
+		if ((p->prio == rq->rq_prio &&
+		    time_before(p_deadline, rq->rq_deadline)))
+			return 1;
+	}
+	return 0;
+}
+
+/*
+ * Wake up *any* suitable cpu to schedule this task.
+ */
+static void try_preempt(struct task_struct *p, struct rq *this_rq)
+{
+	unsigned long latest_deadline, cpu;
+	struct rq *highest_prio_rq;
+	int highest_prio;
+	cpumask_t tmp;
+
+	cpus_and(tmp, cpu_online_map, p->cpus_allowed);
+
+	/* Use this_rq as fallback */
+	if (likely(cpu_isset(this_rq->cpu, tmp))) {
+		highest_prio_rq = this_rq;
+		/* If this_rq is idle, use that. */
+		if (rq_idle(highest_prio_rq))
+			goto found_rq;
+	} else
+		highest_prio_rq = cpu_rq(any_online_cpu(tmp));
+	latest_deadline = highest_prio_rq->rq_deadline;
+	highest_prio = highest_prio_rq->rq_prio;
+
+	for_each_cpu_mask_nr(cpu, tmp) {
+		struct rq *rq;
+		int rq_prio;
+
+		rq = cpu_rq(cpu);
+
+		if (rq_idle(rq)) {
+			/* found an idle rq, use that one */
+			highest_prio_rq = rq;
+			goto found_rq;
+		}
+
+		rq_prio = rq->rq_prio;
+		if (rq_prio > highest_prio || (rq_prio == highest_prio &&
+		    time_after(rq->rq_deadline, latest_deadline))) {
+			highest_prio = rq_prio;
+			latest_deadline = rq->rq_deadline;
+			highest_prio_rq = rq;
+		}
+	}
+
+	if (!task_preempts_curr(p, highest_prio_rq))
+		return;
+found_rq:
+	resched_task(highest_prio_rq->curr);
+	return;
+}
+
+/***
+ * try_to_wake_up - wake up a thread
+ * @p: the to-be-woken-up thread
+ * @state: the mask of task states that can be woken
+ * @sync: do a synchronous wakeup?
+ *
+ * Put it on the run-queue if it's not already there. The "current"
+ * thread is always on the run-queue (except when the actual
+ * re-schedule is in progress), and as such you're allowed to do
+ * the simpler "current->state = TASK_RUNNING" to mark yourself
+ * runnable without the overhead of this.
+ *
+ * returns failure only if the task is already active.
+ */
+static int try_to_wake_up(struct task_struct *p, unsigned int state, int sync)
+{
+	unsigned long flags;
+	int success = 0;
+	struct rq *rq;
+
+	/* This barrier is undocumented, probably for p->state? くそ */
+	smp_wmb();
+
+	/*
+	 * No need to do time_lock_grq as we only need to update the rq clock
+	 * if we activate the task
+	 */
+	rq = task_grq_lock(p, &flags);
+
+	/* state is a volatile long, どうして、分からない */
+	if (!((unsigned int)p->state & state))
+		goto out_unlock;
+
+	if (task_queued(p) || task_running(p))
+		goto out_running;
+
+	activate_task(p, rq);
+	/*
+	 * Sync wakeups (i.e. those types of wakeups where the waker
+	 * has indicated that it will leave the CPU in short order)
+	 * don't trigger a preemption if there are no idle cpus,
+	 * instead waiting for current to deschedule.
+	 */
+	if (!sync || (sync && suitable_idle_cpus(p)))
+		try_preempt(p, rq);
+	success = 1;
+
+out_running:
+	trace_mark(kernel_sched_wakeup,
+		"pid %d state %ld ## rq %p task %p rq->curr %p",
+		p->pid, p->state, rq, p, rq->curr);
+	p->state = TASK_RUNNING;
+out_unlock:
+	task_grq_unlock(&flags);
+	return success;
+}
+
+/**
+ * wake_up_process - Wake up a specific process
+ * @p: The process to be woken up.
+ *
+ * Attempt to wake up the nominated process and move it to the set of runnable
+ * processes.  Returns 1 if the process was woken up, 0 if it was already
+ * running.
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+int wake_up_process(struct task_struct *p)
+{
+	return try_to_wake_up(p, TASK_ALL, 0);
+}
+EXPORT_SYMBOL(wake_up_process);
+
+int wake_up_state(struct task_struct *p, unsigned int state)
+{
+	return try_to_wake_up(p, state, 0);
+}
+
+/*
+ * Perform scheduler related setup for a newly forked process p.
+ * p is forked by current.
+ */
+void sched_fork(struct task_struct *p, int clone_flags)
+{
+	int cpu = get_cpu();
+	struct rq *rq;
+
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+	INIT_HLIST_HEAD(&p->preempt_notifiers);
+#endif
+	/*
+	 * We mark the process as running here, but have not actually
+	 * inserted it onto the runqueue yet. This guarantees that
+	 * nobody will actually run it, and a signal or other external
+	 * event cannot wake it up and insert it on the runqueue either.
+	 */
+	p->state = TASK_RUNNING;
+	set_task_cpu(p, cpu);
+
+	/* Should be reset in fork.c but done here for ease of bfs patching */
+	p->sched_time = p->stime_pc = p->utime_pc = 0;
+
+	/*
+	 * Make sure we do not leak PI boosting priority to the child:
+	 */
+	p->prio = current->normal_prio;
+
+	INIT_LIST_HEAD(&p->run_list);
+#if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
+	if (unlikely(sched_info_on()))
+		memset(&p->sched_info, 0, sizeof(p->sched_info));
+#endif
+
+	p->oncpu = 0;
+
+#ifdef CONFIG_PREEMPT
+	/* Want to start with kernel preemption disabled. */
+	task_thread_info(p)->preempt_count = 1;
+#endif
+	if (unlikely(p->policy == SCHED_FIFO))
+		goto out;
+	/*
+	 * Share the timeslice between parent and child, thus the
+	 * total amount of pending timeslices in the system doesn't change,
+	 * resulting in more scheduling fairness. If it's negative, it won't
+	 * matter since that's the same as being 0. current's time_slice is
+	 * actually in rq_time_slice when it's running.
+	 */
+	rq = task_grq_lock_irq(current);
+	if (likely(rq->rq_time_slice > 0)) {
+		rq->rq_time_slice /= 2;
+		/*
+		 * The remainder of the first timeslice might be recovered by
+		 * the parent if the child exits early enough.
+		 */
+		p->first_time_slice = 1;
+	}
+	p->time_slice = rq->rq_time_slice;
+	task_grq_unlock_irq();
+out:
+	put_cpu();
+}
+
+/*
+ * wake_up_new_task - wake up a newly created task for the first time.
+ *
+ * This function will do some initial scheduler statistics housekeeping
+ * that must be done for every newly created context, then puts the task
+ * on the runqueue and wakes it.
+ */
+void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
+{
+	struct task_struct *parent;
+	unsigned long flags;
+	struct rq *rq;
+
+	rq = task_grq_lock(p, &flags); ;
+	parent = p->parent;
+	BUG_ON(p->state != TASK_RUNNING);
+	set_task_cpu(p, task_cpu(parent));
+	activate_task(p, rq);
+	trace_mark(kernel_sched_wakeup_new,
+		"pid %d state %ld ## rq %p task %p rq->curr %p",
+		p->pid, p->state, rq, p, rq->curr);
+	if (!(clone_flags & CLONE_VM) && rq->curr == parent &&
+		!suitable_idle_cpus(p)) {
+		/*
+		 * The VM isn't cloned, so we're in a good position to
+		 * do child-runs-first in anticipation of an exec. This
+		 * usually avoids a lot of COW overhead.
+		 */
+			resched_task(parent);
+	} else
+		try_preempt(p, rq);
+	task_grq_unlock(&flags);
+}
+
+/*
+ * Potentially available exiting-child timeslices are
+ * retrieved here - this way the parent does not get
+ * penalised for creating too many threads.
+ *
+ * (this cannot be used to 'generate' timeslices
+ * artificially, because any timeslice recovered here
+ * was given away by the parent in the first place.)
+ */
+void sched_exit(struct task_struct *p)
+{
+	struct task_struct *parent;
+	unsigned long flags;
+	struct rq *rq;
+
+	if (p->first_time_slice) {
+		int *par_tslice, *p_tslice;
+
+		parent = p->parent;
+		rq = task_grq_lock(parent, &flags);
+		par_tslice = &parent->time_slice;
+		p_tslice = &p->time_slice;
+
+		/* The real time_slice of the "curr" task is on the rq var.*/
+		if (p == rq->curr)
+			p_tslice = &rq->rq_time_slice;
+		else if (parent == task_rq(parent)->curr)
+			par_tslice = &rq->rq_time_slice;
+
+		*par_tslice += *p_tslice;
+		if (unlikely(*par_tslice > timeslice()))
+			*par_tslice = timeslice();
+		task_grq_unlock(&flags);
+	}
+}
+
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+
+/**
+ * preempt_notifier_register - tell me when current is being being preempted & rescheduled
+ * @notifier: notifier struct to register
+ */
+void preempt_notifier_register(struct preempt_notifier *notifier)
+{
+	hlist_add_head(&notifier->link, &current->preempt_notifiers);
+}
+EXPORT_SYMBOL_GPL(preempt_notifier_register);
+
+/**
+ * preempt_notifier_unregister - no longer interested in preemption notifications
+ * @notifier: notifier struct to unregister
+ *
+ * This is safe to call from within a preemption notifier.
+ */
+void preempt_notifier_unregister(struct preempt_notifier *notifier)
+{
+	hlist_del(&notifier->link);
+}
+EXPORT_SYMBOL_GPL(preempt_notifier_unregister);
+
+static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
+{
+	struct preempt_notifier *notifier;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+		notifier->ops->sched_in(notifier, raw_smp_processor_id());
+}
+
+static void
+fire_sched_out_preempt_notifiers(struct task_struct *curr,
+				 struct task_struct *next)
+{
+	struct preempt_notifier *notifier;
+	struct hlist_node *node;
+
+	hlist_for_each_entry(notifier, node, &curr->preempt_notifiers, link)
+		notifier->ops->sched_out(notifier, next);
+}
+
+#else /* !CONFIG_PREEMPT_NOTIFIERS */
+
+static void fire_sched_in_preempt_notifiers(struct task_struct *curr)
+{
+}
+
+static void
+fire_sched_out_preempt_notifiers(struct task_struct *curr,
+				 struct task_struct *next)
+{
+}
+
+#endif /* CONFIG_PREEMPT_NOTIFIERS */
+
+/**
+ * prepare_task_switch - prepare to switch tasks
+ * @rq: the runqueue preparing to switch
+ * @next: the task we are going to switch to.
+ *
+ * This is called with the rq lock held and interrupts off. It must
+ * be paired with a subsequent finish_task_switch after the context
+ * switch.
+ *
+ * prepare_task_switch sets up locking and calls architecture specific
+ * hooks.
+ */
+static inline void
+prepare_task_switch(struct rq *rq, struct task_struct *prev,
+		    struct task_struct *next)
+{
+	fire_sched_out_preempt_notifiers(prev, next);
+	prepare_lock_switch(rq, next);
+	prepare_arch_switch(next);
+}
+
+/**
+ * finish_task_switch - clean up after a task-switch
+ * @rq: runqueue associated with task-switch
+ * @prev: the thread we just switched away from.
+ *
+ * finish_task_switch must be called after the context switch, paired
+ * with a prepare_task_switch call before the context switch.
+ * finish_task_switch will reconcile locking set up by prepare_task_switch,
+ * and do any other architecture-specific cleanup actions.
+ *
+ * Note that we may have delayed dropping an mm in context_switch(). If
+ * so, we finish that here outside of the runqueue lock.  (Doing it
+ * with the lock held can cause deadlocks; see schedule() for
+ * details.)
+ */
+static inline void finish_task_switch(struct rq *rq, struct task_struct *prev)
+	__releases(grq.lock)
+{
+	struct mm_struct *mm = rq->prev_mm;
+	long prev_state;
+
+	rq->prev_mm = NULL;
+
+	/*
+	 * A task struct has one reference for the use as "current".
+	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
+	 * schedule one last time. The schedule call will never return, and
+	 * the scheduled task must drop that reference.
+	 * The test for TASK_DEAD must occur while the runqueue locks are
+	 * still held, otherwise prev could be scheduled on another cpu, die
+	 * there before we look at prev->state, and then the reference would
+	 * be dropped twice.
+	 *		Manfred Spraul <manfred@colorfullife.com>
+	 */
+	prev_state = prev->state;
+	finish_arch_switch(prev);
+	finish_lock_switch(rq, prev);
+
+	fire_sched_in_preempt_notifiers(current);
+	if (mm)
+		mmdrop(mm);
+	if (unlikely(prev_state == TASK_DEAD)) {
+		/*
+		 * Remove function-return probe instances associated with this
+		 * task and put them back on the free list.
+	 	 */
+		kprobe_flush_task(prev);
+		put_task_struct(prev);
+	}
+}
+
+/**
+ * schedule_tail - first thing a freshly forked thread must call.
+ * @prev: the thread we just switched away from.
+ */
+asmlinkage void schedule_tail(struct task_struct *prev)
+	__releases(grq.lock)
+{
+	struct rq *rq = this_rq();
+
+	finish_task_switch(rq, prev);
+#ifdef __ARCH_WANT_UNLOCKED_CTXSW
+	/* In this case, finish_task_switch does not reenable preemption */
+	preempt_enable();
+#endif
+	if (current->set_child_tid)
+		put_user(current->pid, current->set_child_tid);
+}
+
+/*
+ * context_switch - switch to the new MM and the new
+ * thread's register state.
+ */
+static inline void
+context_switch(struct rq *rq, struct task_struct *prev,
+	       struct task_struct *next)
+{
+	struct mm_struct *mm, *oldmm;
+
+	prepare_task_switch(rq, prev, next);
+	trace_mark(kernel_sched_schedule,
+		"prev_pid %d next_pid %d prev_state %ld "
+		"## rq %p prev %p next %p",
+		prev->pid, next->pid, prev->state,
+		rq, prev, next);
+	mm = next->mm;
+	oldmm = prev->active_mm;
+	/*
+	 * For paravirt, this is coupled with an exit in switch_to to
+	 * combine the page table reload and the switch backend into
+	 * one hypercall.
+	 */
+	arch_enter_lazy_cpu_mode();
+
+	if (unlikely(!mm)) {
+		next->active_mm = oldmm;
+		atomic_inc(&oldmm->mm_count);
+		enter_lazy_tlb(oldmm, next);
+	} else
+		switch_mm(oldmm, mm, next);
+
+	if (unlikely(!prev->mm)) {
+		prev->active_mm = NULL;
+		rq->prev_mm = oldmm;
+	}
+	/*
+	 * Since the runqueue lock will be released by the next
+	 * task (which is an invalid locking op but in the case
+	 * of the scheduler it's an obvious special-case), so we
+	 * do an early lockdep release here:
+	 */
+#ifndef __ARCH_WANT_UNLOCKED_CTXSW
+	spin_release(&grq.lock.dep_map, 1, _THIS_IP_);
+#endif
+
+	/* Here we just switch the register state and the stack. */
+	switch_to(prev, next, prev);
+
+	barrier();
+	/*
+	 * this_rq must be evaluated again because prev may have moved
+	 * CPUs since it called schedule(), thus the 'rq' on its stack
+	 * frame will be invalid.
+	 */
+	finish_task_switch(this_rq(), prev);
+}
+
+/*
+ * nr_running, nr_uninterruptible and nr_context_switches:
+ *
+ * externally visible scheduler statistics: current number of runnable
+ * threads, current number of uninterruptible-sleeping threads, total
+ * number of context switches performed since bootup. All are measured
+ * without grabbing the grq lock but the occasional inaccurate result
+ * doesn't matter so long as it's positive.
+ */
+unsigned long nr_running(void)
+{
+	long nr = grq.nr_running;
+
+	if (unlikely(nr < 0))
+		nr = 0;
+	return (unsigned long)nr;
+}
+
+unsigned long nr_uninterruptible(void)
+{
+	unsigned long nu = grq.nr_uninterruptible;
+
+	if (unlikely(nu < 0))
+		nu = 0;
+	return nu;
+}
+
+unsigned long long nr_context_switches(void)
+{
+	long long ns = grq.nr_switches;
+
+	/* This is of course impossible */
+	if (unlikely(ns < 0))
+		ns = 1;
+	return (long long)ns;
+}
+
+unsigned long nr_iowait(void)
+{
+	unsigned long i, sum = 0;
+
+	for_each_possible_cpu(i)
+		sum += atomic_read(&cpu_rq(i)->nr_iowait);
+
+	return sum;
+}
+
+unsigned long nr_active(void)
+{
+	return nr_running() + nr_uninterruptible();
+}
+
+DEFINE_PER_CPU(struct kernel_stat, kstat);
+
+EXPORT_PER_CPU_SYMBOL(kstat);
+
+/*
+ * On each tick, see what percentage of that tick was attributed to each
+ * component and add the percentage to the _pc values. Once a _pc value has
+ * accumulated one tick's worth, account for that. This means the total
+ * percentage of load components will always be 100 per tick.
+ */
+static void pc_idle_time(struct rq *rq, unsigned long pc)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t tmp = cputime_to_cputime64(jiffies_to_cputime(1));
+
+	if (atomic_read(&rq->nr_iowait) > 0) {
+		rq->iowait_pc += pc;
+		if (rq->iowait_pc >= 100) {
+			rq->iowait_pc %= 100;
+			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
+		}
+	} else {
+		rq->idle_pc += pc;
+		if (rq->idle_pc >= 100) {
+			rq->idle_pc %= 100;
+			cpustat->idle = cputime64_add(cpustat->idle, tmp);
+		}
+	}
+}
+
+static void
+pc_system_time(struct rq *rq, struct task_struct *p, int hardirq_offset,
+	       unsigned long pc, unsigned long ns)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime_t one_jiffy = jiffies_to_cputime(1);
+	cputime_t one_jiffy_scaled = cputime_to_scaled(one_jiffy);
+	cputime64_t tmp = cputime_to_cputime64(one_jiffy);
+
+	p->stime_pc += pc;
+	if (p->stime_pc >= 100) {
+		p->stime_pc -= 100;
+		p->stime = cputime_add(p->stime, one_jiffy);
+		p->stimescaled = cputime_add(p->stimescaled, one_jiffy_scaled);
+		acct_update_integrals(p);
+	}
+	p->sched_time += ns;
+
+	if (hardirq_count() - hardirq_offset)
+		rq->irq_pc += pc;
+	else if (softirq_count()) {
+		rq->softirq_pc += pc;
+		if (rq->softirq_pc >= 100) {
+			rq->softirq_pc %= 100;
+			cpustat->softirq = cputime64_add(cpustat->softirq, tmp);
+		}
+	} else {
+		rq->system_pc += pc;
+		if (rq->system_pc >= 100) {
+			rq->system_pc %= 100;
+			cpustat->system = cputime64_add(cpustat->system, tmp);
+		}
+	}
+}
+
+static void pc_user_time(struct rq *rq, struct task_struct *p,
+			 unsigned long pc, unsigned long ns)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime_t one_jiffy = jiffies_to_cputime(1);
+	cputime_t one_jiffy_scaled = cputime_to_scaled(one_jiffy);
+	cputime64_t tmp = cputime_to_cputime64(one_jiffy);
+
+	p->utime_pc += pc;
+	if (p->utime_pc >= 100) {
+		p->utime_pc -= 100;
+		p->utime = cputime_add(p->utime, one_jiffy);
+		p->utimescaled = cputime_add(p->utimescaled, one_jiffy_scaled);
+		acct_update_integrals(p);
+	}
+	p->sched_time += ns;
+
+	if (TASK_NICE(p) > 0 || idleprio_task(p)) {
+		rq->nice_pc += pc;
+		if (rq->nice_pc >= 100) {
+			rq->nice_pc %= 100;
+			cpustat->nice = cputime64_add(cpustat->nice, tmp);
+		}
+	} else {
+		rq->user_pc += pc;
+		if (rq->user_pc >= 100) {
+			rq->user_pc %= 100;
+			cpustat->user = cputime64_add(cpustat->user, tmp);
+		}
+	}
+}
+
+/* Convert nanoseconds to percentage of one tick. */
+#define NS_TO_PC(NS)	(NS * 100 / JIFFIES_TO_NS(1))
+
+/*
+ * This is called on clock ticks and on context switches.
+ * Bank in p->sched_time the ns elapsed since the last tick or switch.
+ * CPU scheduler quota accounting is also performed here in microseconds.
+ * The value returned from sched_clock() occasionally gives bogus values so
+ * some sanity checking is required. Time is supposed to be banked all the
+ * time so default to half a tick to make up for when sched_clock reverts
+ * to just returning jiffies, and for hardware that can't do tsc.
+ */
+static void
+update_cpu_clock(struct rq *rq, struct task_struct *p, int tick)
+{
+	long time_diff = rq->clock - rq->rq_last_ran;
+	long account_ns = rq->clock - rq->timekeep_clock;
+	struct task_struct *idle = rq->idle;
+	unsigned long account_pc;
+
+	/*
+	 * There should be less than or equal to one jiffy worth, and not
+	 * negative/overflow. time_diff is only used for internal scheduler
+	 * time_slice accounting.
+	 */
+	if (time_diff <= 0)
+		time_diff = JIFFIES_TO_NS(1) / 2;
+	else if (time_diff > JIFFIES_TO_NS(1))
+		time_diff = JIFFIES_TO_NS(1);
+
+	if (unlikely(account_ns < 0))
+		account_ns = 0;
+
+	account_pc = NS_TO_PC(account_ns);
+
+	if (tick) {
+		int user_tick = user_mode(get_irq_regs());
+
+		/* Accurate tick timekeeping */
+		if (user_tick)
+			pc_user_time(rq, p, account_pc, account_ns);
+		else if (p != idle || (irq_count() != HARDIRQ_OFFSET))
+			pc_system_time(rq, p, HARDIRQ_OFFSET,
+				       account_pc, account_ns);
+		else
+			pc_idle_time(rq, account_pc);
+	} else {
+		/* Accurate subtick timekeeping */
+		if (p == idle)
+			pc_idle_time(rq, account_pc);
+		else
+			pc_user_time(rq, p, account_pc, account_ns);
+	}
+
+	/* time_slice accounting is done in usecs to avoid overflow on 32bit */
+	if (rq->rq_policy != SCHED_FIFO && p != idle)
+		rq->rq_time_slice -= time_diff / 1000;
+	rq->rq_last_ran = rq->timekeep_clock = rq->clock;
+}
+
+/*
+ * Return accounted runtime for the task.
+ * In case the task is currently running, return the runtime plus current's
+ * pending runtime that have not been accounted yet.
+ */
+unsigned long long task_sched_runtime(struct task_struct *p)
+{
+	unsigned long flags;
+	u64 ns, delta_exec;
+	struct rq *rq;
+
+	rq = task_grq_lock(p, &flags);
+	ns = p->sched_time;
+	if (p == rq->curr) {
+		update_rq_clock(rq);
+		delta_exec = rq->clock - rq->rq_last_ran;
+		if ((s64)delta_exec > 0)
+			ns += delta_exec;
+	}
+	task_grq_unlock(&flags);
+
+	return ns;
+}
+
+/* Compatibility crap for removal */
+void account_user_time(struct task_struct *p, cputime_t cputime,
+		       cputime_t cputime_scaled)
+{
+}
+
+void account_idle_time(cputime_t cputime)
+{
+}
+
+/*
+ * Account guest cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @cputime: the cpu time spent in virtual machine since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ */
+static void account_guest_time(struct task_struct *p, cputime_t cputime,
+			       cputime_t cputime_scaled)
+{
+	cputime64_t tmp;
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+
+	tmp = cputime_to_cputime64(cputime);
+
+	/* Add guest time to process. */
+	p->utime = cputime_add(p->utime, cputime);
+	p->utimescaled = cputime_add(p->utimescaled, cputime_scaled);
+	p->gtime = cputime_add(p->gtime, cputime);
+
+	/* Add guest time to cpustat. */
+	cpustat->user = cputime64_add(cpustat->user, tmp);
+	cpustat->guest = cputime64_add(cpustat->guest, tmp);
+}
+
+/*
+ * Account system cpu time to a process.
+ * @p: the process that the cpu time gets accounted to
+ * @hardirq_offset: the offset to subtract from hardirq_count()
+ * @cputime: the cpu time spent in kernel space since the last update
+ * @cputime_scaled: cputime scaled by cpu frequency
+ * This is for guest only now.
+ */
+void account_system_time(struct task_struct *p, int hardirq_offset,
+			 cputime_t cputime, cputime_t cputime_scaled)
+{
+
+	if ((p->flags & PF_VCPU) && (irq_count() - hardirq_offset == 0))
+		account_guest_time(p, cputime, cputime_scaled);
+}
+
+/*
+ * Account for involuntary wait time.
+ * @steal: the cpu time spent in involuntary wait
+ */
+void account_steal_time(cputime_t cputime)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+
+	cpustat->steal = cputime64_add(cpustat->steal, cputime64);
+}
+
+/*
+ * Account for idle time.
+ * @cputime: the cpu time spent in idle wait
+ */
+static void account_idle_times(cputime_t cputime)
+{
+	struct cpu_usage_stat *cpustat = &kstat_this_cpu.cpustat;
+	cputime64_t cputime64 = cputime_to_cputime64(cputime);
+	struct rq *rq = this_rq();
+
+	if (atomic_read(&rq->nr_iowait) > 0)
+		cpustat->iowait = cputime64_add(cpustat->iowait, cputime64);
+	else
+		cpustat->idle = cputime64_add(cpustat->idle, cputime64);
+}
+
+#ifndef CONFIG_VIRT_CPU_ACCOUNTING
+
+void account_process_tick(struct task_struct *p, int user_tick)
+{
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
+	account_idle_times(jiffies_to_cputime(ticks));
+}
+#endif
+
+/*
+ * Functions to test for when SCHED_ISO tasks have used their allocated
+ * quota as real time scheduling and convert them back to SCHED_NORMAL.
+ * Where possible, the data is tested lockless, to avoid grabbing grq_lock
+ * because the occasional inaccurate result won't matter. However the
+ * tick data is only ever modified under lock. iso_refractory is only simply
+ * set to 0 or 1 so it's not worth grabbing the lock yet again for that.
+ */
+static void set_iso_refractory(void)
+{
+	grq.iso_refractory = 1;
+}
+
+static void clear_iso_refractory(void)
+{
+	grq.iso_refractory = 0;
+}
+
+/*
+ * Test if SCHED_ISO tasks have run longer than their alloted period as RT
+ * tasks and set the refractory flag if necessary. There is 10% hysteresis
+ * for unsetting the flag.
+ */
+static unsigned int test_ret_isorefractory(struct rq *rq)
+{
+	if (likely(!grq.iso_refractory)) {
+		if (grq.iso_ticks / ISO_PERIOD > sched_iso_cpu)
+			set_iso_refractory();
+	} else {
+		if (grq.iso_ticks / ISO_PERIOD < (sched_iso_cpu * 90 / 100))
+			clear_iso_refractory();
+	}
+	return grq.iso_refractory;
+}
+
+static void iso_tick(void)
+{
+	grq_lock();
+	grq.iso_ticks += 100;
+	grq_unlock();
+}
+
+/* No SCHED_ISO task was running so decrease rq->iso_ticks */
+static inline void no_iso_tick(void)
+{
+	if (grq.iso_ticks) {
+		grq_lock();
+		grq.iso_ticks = grq.iso_ticks * (ISO_PERIOD - 1) / ISO_PERIOD;
+		grq_unlock();
+	}
+}
+
+static int rq_running_iso(struct rq *rq)
+{
+	return rq->rq_prio == ISO_PRIO;
+}
+
+/* This manages tasks that have run out of timeslice during a scheduler_tick */
+static void task_running_tick(struct rq *rq)
+{
+	struct task_struct *p;
+
+	/*
+	 * If a SCHED_ISO task is running we increment the iso_ticks. In
+	 * order to prevent SCHED_ISO tasks from causing starvation in the
+	 * presence of true RT tasks we account those as iso_ticks as well.
+	 */
+	if ((rt_queue(rq) || (iso_queue(rq) && !grq.iso_refractory))) {
+		if (grq.iso_ticks <= (ISO_PERIOD * 100) - 100)
+			iso_tick();
+	} else
+		no_iso_tick();
+
+	if (iso_queue(rq)) {
+		if (unlikely(test_ret_isorefractory(rq))) {
+			if (rq_running_iso(rq)) {
+				/*
+				 * SCHED_ISO task is running as RT and limit
+				 * has been hit. Force it to reschedule as
+				 * SCHED_NORMAL by zeroing its time_slice
+				 */
+				rq->rq_time_slice = 0;
+			}
+		}
+	}
+
+	/* SCHED_FIFO tasks never run out of timeslice. */
+	if (rq_idle(rq) || rq->rq_time_slice > 0 || rq->rq_policy == SCHED_FIFO)
+		return;
+
+	/* p->time_slice <= 0. We only modify task_struct under grq lock */
+	grq_lock();
+	p = rq->curr;
+	requeue_task(p);
+	set_tsk_need_resched(p);
+	grq_unlock();
+}
+
+void wake_up_idle_cpu(int cpu);
+
+/*
+ * This function gets called by the timer code, with HZ frequency.
+ * We call it with interrupts disabled. The data modified is all
+ * local to struct rq so we don't need to grab grq lock.
+ */
+void scheduler_tick(void)
+{
+	int cpu = smp_processor_id();
+	struct rq *rq = cpu_rq(cpu);
+
+	sched_clock_tick();
+	update_rq_clock(rq);
+	update_cpu_clock(rq, rq->curr, 1);
+	if (!rq_idle(rq))
+		task_running_tick(rq);
+	else
+		no_iso_tick();
+}
+
+#if defined(CONFIG_PREEMPT) && (defined(CONFIG_DEBUG_PREEMPT) || \
+				defined(CONFIG_PREEMPT_TRACER))
+
+static inline unsigned long get_parent_ip(unsigned long addr)
+{
+	if (in_lock_functions(addr)) {
+		addr = CALLER_ADDR2;
+		if (in_lock_functions(addr))
+			addr = CALLER_ADDR3;
+	}
+	return addr;
+}
+
+void __kprobes add_preempt_count(int val)
+{
+#ifdef CONFIG_DEBUG_PREEMPT
+	/*
+	 * Underflow?
+	 */
+	if (DEBUG_LOCKS_WARN_ON((preempt_count() < 0)))
+		return;
+#endif
+	preempt_count() += val;
+#ifdef CONFIG_DEBUG_PREEMPT
+	/*
+	 * Spinlock count overflowing soon?
+	 */
+	DEBUG_LOCKS_WARN_ON((preempt_count() & PREEMPT_MASK) >=
+				PREEMPT_MASK - 10);
+#endif
+	if (preempt_count() == val)
+		trace_preempt_off(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+}
+EXPORT_SYMBOL(add_preempt_count);
+
+void __kprobes sub_preempt_count(int val)
+{
+#ifdef CONFIG_DEBUG_PREEMPT
+	/*
+	 * Underflow?
+	 */
+	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+		return;
+	/*
+	 * Is the spinlock portion underflowing?
+	 */
+	if (DEBUG_LOCKS_WARN_ON((val < PREEMPT_MASK) &&
+			!(preempt_count() & PREEMPT_MASK)))
+		return;
+#endif
+
+	if (preempt_count() == val)
+		trace_preempt_on(CALLER_ADDR0, get_parent_ip(CALLER_ADDR1));
+	preempt_count() -= val;
+}
+EXPORT_SYMBOL(sub_preempt_count);
+#endif
+
+/*
+ * Deadline is "now" in jiffies + (offset by priority). Setting the deadline
+ * is the key to everything. It distributes cpu fairly amongst tasks of the
+ * same nice value, it proportions cpu according to nice level, it means the
+ * task that last woke up the longest ago has the earliest deadline, thus
+ * ensuring that interactive tasks get low latency on wake up.
+ */
+static inline int prio_deadline_diff(struct task_struct *p)
+{
+	return (pratio(p) * rr_interval * HZ / 1000 / 100) ? : 1;
+}
+
+static inline int longest_deadline(void)
+{
+	return (prio_ratios[39] * rr_interval * HZ / 1000 / 100);
+}
+
+/*
+ * SCHED_IDLEPRIO tasks still have a deadline set, but offset by nice +19.
+ * This allows nice levels to work between IDLEPRIO tasks and gives a
+ * deadline longer than nice +19 for when they're scheduled as SCHED_NORMAL
+ * tasks.
+ */
+static inline void time_slice_expired(struct task_struct *p)
+{
+	reset_first_time_slice(p);
+	p->time_slice = timeslice();
+	p->deadline = jiffies + prio_deadline_diff(p);
+	if (idleprio_task(p))
+		p->deadline += longest_deadline();
+}
+
+static inline void check_deadline(struct task_struct *p)
+{
+	if (p->time_slice <= 0)
+		time_slice_expired(p);
+}
+
+/*
+ * O(n) lookup of all tasks in the global runqueue. The real brainfuck
+ * of lock contention and O(n). It's not really O(n) as only the queued,
+ * but not running tasks are scanned, and is O(n) queued in the worst case
+ * scenario only because the right task can be found before scanning all of
+ * them.
+ * Tasks are selected in this order:
+ * Real time tasks are selected purely by their static priority and in the
+ * order they were queued, so the lowest value idx, and the first queued task
+ * of that priority value is chosen.
+ * If no real time tasks are found, the SCHED_ISO priority is checked, and
+ * all SCHED_ISO tasks have the same priority value, so they're selected by
+ * the earliest deadline value.
+ * If no SCHED_ISO tasks are found, SCHED_NORMAL tasks are selected by the
+ * earliest deadline.
+ * Finally if no SCHED_NORMAL tasks are found, SCHED_IDLEPRIO tasks are
+ * selected by the earliest deadline.
+ */
+static inline struct
+task_struct *earliest_deadline_task(struct rq *rq, struct task_struct *idle)
+{
+	unsigned long dl, earliest_deadline = 0; /* Initialise to silence compiler */
+	struct task_struct *p, *edt;
+	unsigned int cpu = rq->cpu;
+	struct list_head *queue;
+	int idx = 0;
+
+	edt = idle;
+retry:
+	idx = find_next_bit(grq.prio_bitmap, PRIO_LIMIT, idx);
+	if (idx >= PRIO_LIMIT)
+		goto out;
+	queue = &grq.queue[idx];
+	list_for_each_entry(p, queue, run_list) {
+		/* Make sure cpu affinity is ok */
+		if (!cpu_isset(cpu, p->cpus_allowed))
+			continue;
+		if (idx < MAX_RT_PRIO) {
+			/* We found an rt task */
+			edt = p;
+			goto out_take;
+		}
+
+		/*
+		 * No rt task, select the earliest deadline task now.
+		 * On the 1st run the 2nd condition is never used, so
+		 * there is no need to initialise earliest_deadline
+		 * before. Normalise all old deadlines to now.
+		 */
+		dl = p->deadline + cache_distance(task_rq(p), rq, p);
+		if (time_before(dl, jiffies))
+			dl = jiffies;
+
+		if (edt == idle ||
+		    time_before(dl, earliest_deadline)) {
+			earliest_deadline = dl;
+			edt = p;
+		}
+	}
+	if (edt == idle) {
+		if (++idx < PRIO_LIMIT)
+			goto retry;
+		goto out;
+	}
+out_take:
+	take_task(rq, edt);
+out:
+	return edt;
+}
+
+/*
+ * Print scheduling while atomic bug:
+ */
+static noinline void __schedule_bug(struct task_struct *prev)
+{
+	struct pt_regs *regs = get_irq_regs();
+
+	printk(KERN_ERR "BUG: scheduling while atomic: %s/%d/0x%08x\n",
+		prev->comm, prev->pid, preempt_count());
+
+	debug_show_held_locks(prev);
+	print_modules();
+	if (irqs_disabled())
+		print_irqtrace_events(prev);
+
+	if (regs)
+		show_regs(regs);
+	else
+		dump_stack();
+}
+
+/*
+ * Various schedule()-time debugging checks and statistics:
+ */
+static inline void schedule_debug(struct task_struct *prev)
+{
+	/*
+	 * Test if we are atomic. Since do_exit() needs to call into
+	 * schedule() atomically, we ignore that path for now.
+	 * Otherwise, whine if we are scheduling when we should not be.
+	 */
+	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
+		__schedule_bug(prev);
+
+	profile_hit(SCHED_PROFILING, __builtin_return_address(0));
+
+	schedstat_inc(this_rq(), sched_count);
+#ifdef CONFIG_SCHEDSTATS
+	if (unlikely(prev->lock_depth >= 0)) {
+		schedstat_inc(this_rq(), bkl_count);
+		schedstat_inc(prev, sched_info.bkl_count);
+	}
+#endif
+}
+
+static inline void set_rq_task(struct rq *rq, struct task_struct *p)
+{
+	rq->rq_time_slice = p->time_slice;
+	rq->rq_deadline = p->deadline;
+	rq->rq_last_ran = p->last_ran;
+	rq->rq_policy = p->policy;
+	rq->rq_prio = p->prio;
+}
+
+static void reset_rq_task(struct rq *rq, struct task_struct *p)
+{
+	rq->rq_policy = p->policy;
+	rq->rq_prio = p->prio;
+}
+
+/*
+ * schedule() is the main scheduler function.
+ */
+asmlinkage void __sched schedule(void)
+{
+	struct task_struct *prev, *next, *idle;
+	unsigned long *switch_count;
+	int deactivate, cpu;
+	struct rq *rq;
+	u64 now;
+
+need_resched:
+	preempt_disable();
+
+	cpu = smp_processor_id();
+	rq = cpu_rq(cpu);
+	idle = rq->idle;
+	rcu_qsctr_inc(cpu);
+	prev = rq->curr;
+	switch_count = &prev->nivcsw;
+
+	release_kernel_lock(prev);
+need_resched_nonpreemptible:
+
+	deactivate = 0;
+	schedule_debug(prev);
+
+	local_irq_disable();
+	update_rq_clock(rq);
+	now = rq->clock;
+	update_cpu_clock(rq, prev, 0);
+
+	grq_lock();
+	clear_tsk_need_resched(prev);
+
+	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
+		if (unlikely(signal_pending_state(prev->state, prev)))
+			prev->state = TASK_RUNNING;
+		else
+			deactivate = 1;
+		switch_count = &prev->nvcsw;
+	}
+
+	if (prev != idle) {
+		/* Update all the information stored on struct rq */
+		prev->time_slice = rq->rq_time_slice;
+		prev->deadline = rq->rq_deadline;
+		check_deadline(prev);
+		return_task(prev, deactivate);
+		/* Task changed affinity off this cpu */
+		if (unlikely(!cpus_intersects(prev->cpus_allowed,
+		    cpumask_of_cpu(cpu))))
+		    	resched_suitable_idle(prev);
+	}
+
+	if (likely(queued_notrunning())) {
+		next = earliest_deadline_task(rq, idle);
+	} else {
+		next = idle;
+		schedstat_inc(rq, sched_goidle);
+	}
+
+	prefetch(next);
+	prefetch_stack(next);
+
+	if (task_idle(next))
+		set_cpuidle_map(cpu);
+	else
+		clear_cpuidle_map(cpu);
+
+	prev->last_ran = now;
+
+	if (likely(prev != next)) {
+		sched_info_switch(prev, next);
+
+		set_rq_task(rq, next);
+		grq.nr_switches++;
+		prev->oncpu = 0;
+		next->oncpu = 1;
+		rq->curr = next;
+		++*switch_count;
+
+		context_switch(rq, prev, next); /* unlocks the grq */
+		/*
+		 * the context switch might have flipped the stack from under
+		 * us, hence refresh the local variables.
+		 */
+		cpu = smp_processor_id();
+		rq = cpu_rq(cpu);
+		idle = rq->idle;
+	} else
+		grq_unlock_irq();
+
+	if (unlikely(reacquire_kernel_lock(current) < 0))
+		goto need_resched_nonpreemptible;
+	preempt_enable_no_resched();
+	if (unlikely(test_thread_flag(TIF_NEED_RESCHED)))
+ 		goto need_resched;
+}
+EXPORT_SYMBOL(schedule);
+
+#ifdef CONFIG_PREEMPT
+/*
+ * this is the entry point to schedule() from in-kernel preemption
+ * off of preempt_enable. Kernel preemptions off return from interrupt
+ * occur there and call schedule directly.
+ */
+asmlinkage void __sched preempt_schedule(void)
+{
+	struct thread_info *ti = current_thread_info();
+
+	/*
+	 * If there is a non-zero preempt_count or interrupts are disabled,
+	 * we do not want to preempt the current task. Just return..
+	 */
+	if (likely(ti->preempt_count || irqs_disabled()))
+		return;
+
+	do {
+		add_preempt_count(PREEMPT_ACTIVE);
+		schedule();
+		sub_preempt_count(PREEMPT_ACTIVE);
+
+		/*
+		 * Check again in case we missed a preemption opportunity
+		 * between schedule and now.
+		 */
+		barrier();
+	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+}
+EXPORT_SYMBOL(preempt_schedule);
+
+/*
+ * this is the entry point to schedule() from kernel preemption
+ * off of irq context.
+ * Note, that this is called and return with irqs disabled. This will
+ * protect us against recursive calling from irq.
+ */
+asmlinkage void __sched preempt_schedule_irq(void)
+{
+	struct thread_info *ti = current_thread_info();
+
+	/* Catch callers which need to be fixed */
+	BUG_ON(ti->preempt_count || !irqs_disabled());
+
+	do {
+		add_preempt_count(PREEMPT_ACTIVE);
+		local_irq_enable();
+		schedule();
+		local_irq_disable();
+		sub_preempt_count(PREEMPT_ACTIVE);
+
+		/*
+		 * Check again in case we missed a preemption opportunity
+		 * between schedule and now.
+		 */
+		barrier();
+	} while (unlikely(test_thread_flag(TIF_NEED_RESCHED)));
+}
+
+#endif /* CONFIG_PREEMPT */
+
+int default_wake_function(wait_queue_t *curr, unsigned mode, int sync,
+			  void *key)
+{
+	return try_to_wake_up(curr->private, mode, sync);
+}
+EXPORT_SYMBOL(default_wake_function);
+
+/*
+ * The core wakeup function.  Non-exclusive wakeups (nr_exclusive == 0) just
+ * wake everything up.  If it's an exclusive wakeup (nr_exclusive == small +ve
+ * number) then we wake all the non-exclusive tasks and one exclusive task.
+ *
+ * There are circumstances in which we can try to wake a task which has already
+ * started to run but is not in state TASK_RUNNING.  try_to_wake_up() returns
+ * zero in this (rare) case, and we handle it by continuing to scan the queue.
+ */
+void __wake_up_common(wait_queue_head_t *q, unsigned int mode,
+			     int nr_exclusive, int sync, void *key)
+{
+	struct list_head *tmp, *next;
+
+	list_for_each_safe(tmp, next, &q->task_list) {
+		wait_queue_t *curr = list_entry(tmp, wait_queue_t, task_list);
+		unsigned flags = curr->flags;
+
+		if (curr->func(curr, mode, sync, key) &&
+				(flags & WQ_FLAG_EXCLUSIVE) && !--nr_exclusive)
+			break;
+	}
+}
+
+/**
+ * __wake_up - wake up threads blocked on a waitqueue.
+ * @q: the waitqueue
+ * @mode: which threads
+ * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ * @key: is directly passed to the wakeup function
+ *
+ * It may be assumed that this function implies a write memory barrier before
+ * changing the task state if and only if any tasks are woken up.
+ */
+void __wake_up(wait_queue_head_t *q, unsigned int mode,
+			int nr_exclusive, void *key)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_common(q, mode, nr_exclusive, 0, key);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL(__wake_up);
+
+/*
+ * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
+ */
+void __wake_up_locked(wait_queue_head_t *q, unsigned int mode)
+{
+	__wake_up_common(q, mode, 1, 0, NULL);
+}
+
+/**
+ * __wake_up_sync - wake up threads blocked on a waitqueue.
+ * @q: the waitqueue
+ * @mode: which threads
+ * @nr_exclusive: how many wake-one or wake-many threads to wake up
+ *
+ * The sync wakeup differs that the waker knows that it will schedule
+ * away soon, so while the target thread will be woken up, it will not
+ * be migrated to another CPU - ie. the two threads are 'synchronised'
+ * with each other. This can prevent needless bouncing between CPUs.
+ *
+ * On UP it can prevent extra preemption.
+ */
+void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
+{
+	unsigned long flags;
+	int sync = 1;
+
+	if (unlikely(!q))
+		return;
+
+	if (unlikely(!nr_exclusive))
+		sync = 0;
+
+	spin_lock_irqsave(&q->lock, flags);
+	__wake_up_common(q, mode, nr_exclusive, sync, NULL);
+	spin_unlock_irqrestore(&q->lock, flags);
+}
+EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
+
+void complete(struct completion *x)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	x->done++;
+	__wake_up_common(&x->wait, TASK_NORMAL, 1, 0, NULL);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+}
+EXPORT_SYMBOL(complete);
+
+void complete_all(struct completion *x)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&x->wait.lock, flags);
+	x->done += UINT_MAX/2;
+	__wake_up_common(&x->wait, TASK_NORMAL, 0, 0, NULL);
+	spin_unlock_irqrestore(&x->wait.lock, flags);
+}
+EXPORT_SYMBOL(complete_all);
+
+static inline long __sched
+do_wait_for_common(struct completion *x, long timeout, int state)
+{
+	if (!x->done) {
+		DECLARE_WAITQUEUE(wait, current);
+
+		wait.flags |= WQ_FLAG_EXCLUSIVE;
+		__add_wait_queue_tail(&x->wait, &wait);
+		do {
+			if ((state == TASK_INTERRUPTIBLE &&
+			     signal_pending(current)) ||
+			    (state == TASK_KILLABLE &&
+			     fatal_signal_pending(current))) {
+				timeout = -ERESTARTSYS;
+				break;
+			}
+			__set_current_state(state);
+			spin_unlock_irq(&x->wait.lock);
+			timeout = schedule_timeout(timeout);
+			spin_lock_irq(&x->wait.lock);
+		} while (!x->done && timeout);
+		__remove_wait_queue(&x->wait, &wait);
+		if (!x->done)
+			return timeout;
+	}
+	x->done--;
+	return timeout ?: 1;
+}
+
+static long __sched
+wait_for_common(struct completion *x, long timeout, int state)
+{
+	might_sleep();
+
+	spin_lock_irq(&x->wait.lock);
+	timeout = do_wait_for_common(x, timeout, state);
+	spin_unlock_irq(&x->wait.lock);
+	return timeout;
+}
+
+void __sched wait_for_completion(struct completion *x)
+{
+	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion);
+
+unsigned long __sched
+wait_for_completion_timeout(struct completion *x, unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_UNINTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_timeout);
+
+int __sched wait_for_completion_interruptible(struct completion *x)
+{
+	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
+	if (t == -ERESTARTSYS)
+		return t;
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_completion_interruptible);
+
+unsigned long __sched
+wait_for_completion_interruptible_timeout(struct completion *x,
+					  unsigned long timeout)
+{
+	return wait_for_common(x, timeout, TASK_INTERRUPTIBLE);
+}
+EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
+
+int __sched wait_for_completion_killable(struct completion *x)
+{
+	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
+	if (t == -ERESTARTSYS)
+		return t;
+	return 0;
+}
+EXPORT_SYMBOL(wait_for_completion_killable);
+
+/**
+ *	try_wait_for_completion - try to decrement a completion without blocking
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if a decrement cannot be done without blocking
+ *		 1 if a decrement succeeded.
+ *
+ *	If a completion is being used as a counting completion,
+ *	attempt to decrement the counter without blocking. This
+ *	enables us to avoid waiting if the resource the completion
+ *	is protecting is not available.
+ */
+bool try_wait_for_completion(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	else
+		x->done--;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+EXPORT_SYMBOL(try_wait_for_completion);
+
+/**
+ *	completion_done - Test to see if a completion has any waiters
+ *	@x:	completion structure
+ *
+ *	Returns: 0 if there are waiters (wait_for_completion() in progress)
+ *		 1 if there are no waiters.
+ *
+ */
+bool completion_done(struct completion *x)
+{
+	int ret = 1;
+
+	spin_lock_irq(&x->wait.lock);
+	if (!x->done)
+		ret = 0;
+	spin_unlock_irq(&x->wait.lock);
+	return ret;
+}
+EXPORT_SYMBOL(completion_done);
+
+static long __sched
+sleep_on_common(wait_queue_head_t *q, int state, long timeout)
+{
+	unsigned long flags;
+	wait_queue_t wait;
+
+	init_waitqueue_entry(&wait, current);
+
+	__set_current_state(state);
+
+	spin_lock_irqsave(&q->lock, flags);
+	__add_wait_queue(q, &wait);
+	spin_unlock(&q->lock);
+	timeout = schedule_timeout(timeout);
+	spin_lock_irq(&q->lock);
+	__remove_wait_queue(q, &wait);
+	spin_unlock_irqrestore(&q->lock, flags);
+
+	return timeout;
+}
+
+void __sched interruptible_sleep_on(wait_queue_head_t *q)
+{
+	sleep_on_common(q, TASK_INTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+}
+EXPORT_SYMBOL(interruptible_sleep_on);
+
+long __sched
+interruptible_sleep_on_timeout(wait_queue_head_t *q, long timeout)
+{
+	return sleep_on_common(q, TASK_INTERRUPTIBLE, timeout);
+}
+EXPORT_SYMBOL(interruptible_sleep_on_timeout);
+
+void __sched sleep_on(wait_queue_head_t *q)
+{
+	sleep_on_common(q, TASK_UNINTERRUPTIBLE, MAX_SCHEDULE_TIMEOUT);
+}
+EXPORT_SYMBOL(sleep_on);
+
+long __sched sleep_on_timeout(wait_queue_head_t *q, long timeout)
+{
+	return sleep_on_common(q, TASK_UNINTERRUPTIBLE, timeout);
+}
+EXPORT_SYMBOL(sleep_on_timeout);
+
+#ifdef CONFIG_RT_MUTEXES
+
+/*
+ * rt_mutex_setprio - set the current priority of a task
+ * @p: task
+ * @prio: prio value (kernel-internal form)
+ *
+ * This function changes the 'effective' priority of a task. It does
+ * not touch ->normal_prio like __setscheduler().
+ *
+ * Used by the rt_mutex code to implement priority inheritance logic.
+ */
+void rt_mutex_setprio(struct task_struct *p, int prio)
+{
+	unsigned long flags;
+	int queued, oldprio;
+	struct rq *rq;
+
+	BUG_ON(prio < 0 || prio > MAX_PRIO);
+
+	rq = time_task_grq_lock(p, &flags);
+
+	oldprio = p->prio;
+	queued = task_queued(p);
+	if (queued)
+		dequeue_task(p);
+	p->prio = prio;
+	if (task_running(p) && prio > oldprio)
+		resched_task(p);
+	if (queued) {
+		enqueue_task(p);
+		try_preempt(p, rq);
+	}
+
+	task_grq_unlock(&flags);
+}
+
+#endif
+
+/*
+ * Adjust the deadline for when the priority is to change, before it's
+ * changed.
+ */
+static inline void adjust_deadline(struct task_struct *p, int new_prio)
+{
+	p->deadline += (prio_ratios[USER_PRIO(new_prio)] - pratio(p)) *
+			rr_interval * HZ / 1000 / 100;
+}
+
+void set_user_nice(struct task_struct *p, long nice)
+{
+	int queued, new_static;
+	unsigned long flags;
+	struct rq *rq;
+
+	if (TASK_NICE(p) == nice || nice < -20 || nice > 19)
+		return;
+	new_static = NICE_TO_PRIO(nice);
+	/*
+	 * We have to be careful, if called from sys_setpriority(),
+	 * the task might be in the middle of scheduling on another CPU.
+	 */
+	rq = time_task_grq_lock(p, &flags);
+	/*
+	 * The RT priorities are set via sched_setscheduler(), but we still
+	 * allow the 'normal' nice value to be set - but as expected
+	 * it wont have any effect on scheduling until the task is
+	 * not SCHED_NORMAL/SCHED_BATCH:
+	 */
+	if (has_rt_policy(p)) {
+		p->static_prio = new_static;
+		goto out_unlock;
+	}
+	queued = task_queued(p);
+	/*
+	 * If p is actually running, we don't need to do anything when
+	 * changing the priority because the grq is unaffected.
+	 */
+	if (queued)
+		dequeue_task(p);
+
+	adjust_deadline(p, new_static);
+	p->static_prio = new_static;
+	p->prio = effective_prio(p);
+
+	if (queued) {
+		enqueue_task(p);
+		try_preempt(p, rq);
+	}
+
+	/* Just resched the task, schedule() will know what to do. */
+	if (task_running(p)) {
+		resched_task(p);
+		reset_rq_task(rq, p);
+	}
+out_unlock:
+	task_grq_unlock(&flags);
+}
+EXPORT_SYMBOL(set_user_nice);
+
+/*
+ * can_nice - check if a task can reduce its nice value
+ * @p: task
+ * @nice: nice value
+ */
+int can_nice(const struct task_struct *p, const int nice)
+{
+	/* convert nice value [19,-20] to rlimit style value [1,40] */
+	int nice_rlim = 20 - nice;
+
+	return (nice_rlim <= p->signal->rlim[RLIMIT_NICE].rlim_cur ||
+		capable(CAP_SYS_NICE));
+}
+
+#ifdef __ARCH_WANT_SYS_NICE
+
+/*
+ * sys_nice - change the priority of the current process.
+ * @increment: priority increment
+ *
+ * sys_setpriority is a more generic, but much slower function that
+ * does similar things.
+ */
+SYSCALL_DEFINE1(nice, int, increment)
+{
+	long nice, retval;
+
+	/*
+	 * Setpriority might change our priority at the same moment.
+	 * We don't have to worry. Conceptually one call occurs first
+	 * and we have a single winner.
+	 */
+	if (increment < -40)
+		increment = -40;
+	if (increment > 40)
+		increment = 40;
+
+	nice = PRIO_TO_NICE(current->static_prio) + increment;
+	if (nice < -20)
+		nice = -20;
+	if (nice > 19)
+		nice = 19;
+
+	if (increment < 0 && !can_nice(current, nice))
+		return -EPERM;
+
+	retval = security_task_setnice(current, nice);
+	if (retval)
+		return retval;
+
+	set_user_nice(current, nice);
+	return 0;
+}
+
+#endif
+
+/**
+ * task_prio - return the priority value of a given task.
+ * @p: the task in question.
+ *
+ * This is the priority value as seen by users in /proc.
+ * RT tasks are offset by -100. Normal tasks are centered
+ * around 1, value goes from 0 (SCHED_ISO) up to 82 (nice +19
+ * SCHED_IDLEPRIO).
+ */
+int task_prio(const struct task_struct *p)
+{
+	int delta, prio = p->prio - MAX_RT_PRIO;
+
+	/* rt tasks and iso tasks */
+	if (prio <= 0)
+		goto out;
+
+	delta = (p->deadline - jiffies) * 40 / longest_deadline();
+	if (delta > 0 && delta <= 80)
+		prio += delta;
+out:
+	return prio;
+}
+
+/**
+ * task_nice - return the nice value of a given task.
+ * @p: the task in question.
+ */
+int task_nice(const struct task_struct *p)
+{
+	return TASK_NICE(p);
+}
+EXPORT_SYMBOL_GPL(task_nice);
+
+/**
+ * idle_cpu - is a given cpu idle currently?
+ * @cpu: the processor in question.
+ */
+int idle_cpu(int cpu)
+{
+	return cpu_curr(cpu) == cpu_rq(cpu)->idle;
+}
+
+/**
+ * idle_task - return the idle task for a given cpu.
+ * @cpu: the processor in question.
+ */
+struct task_struct *idle_task(int cpu)
+{
+	return cpu_rq(cpu)->idle;
+}
+
+/**
+ * find_process_by_pid - find a process with a matching PID value.
+ * @pid: the pid in question.
+ */
+static inline struct task_struct *find_process_by_pid(pid_t pid)
+{
+	return pid ? find_task_by_vpid(pid) : current;
+}
+
+/* Actually do priority change: must hold grq lock. */
+static void
+__setscheduler(struct task_struct *p, struct rq *rq, int policy, int prio)
+{
+	BUG_ON(task_queued(p));
+
+	p->policy = policy;
+	p->rt_priority = prio;
+	p->normal_prio = normal_prio(p);
+	/* we are holding p->pi_lock already */
+	p->prio = rt_mutex_getprio(p);
+	/*
+	 * Reschedule if running. schedule() will know if it can continue
+	 * running or not.
+	 */
+	if (task_running(p)) {
+		resched_task(p);
+		reset_rq_task(rq, p);
+	}
+}
+
+static int __sched_setscheduler(struct task_struct *p, int policy,
+		       struct sched_param *param, bool user)
+{
+	struct sched_param zero_param = { .sched_priority = 0 };
+	int queued, retval, oldprio, oldpolicy = -1;
+	unsigned long flags, rlim_rtprio = 0;
+	struct rq *rq;
+
+	/* may grab non-irq protected spin_locks */
+	BUG_ON(in_interrupt());
+
+	if (is_rt_policy(policy) && !capable(CAP_SYS_NICE)) {
+		unsigned long lflags;
+
+		if (!lock_task_sighand(p, &lflags))
+			return -ESRCH;
+		rlim_rtprio = p->signal->rlim[RLIMIT_RTPRIO].rlim_cur;
+		unlock_task_sighand(p, &lflags);
+		if (rlim_rtprio)
+			goto recheck;
+		/*
+		 * If the caller requested an RT policy without having the
+		 * necessary rights, we downgrade the policy to SCHED_ISO.
+		 * We also set the parameter to zero to pass the checks.
+		 */
+		policy = SCHED_ISO;
+		param = &zero_param;
+	}
+recheck:
+	/* double check policy once rq lock held */
+	if (policy < 0)
+		policy = oldpolicy = p->policy;
+	else if (!SCHED_RANGE(policy))
+		return -EINVAL;
+	/*
+	 * Valid priorities for SCHED_FIFO and SCHED_RR are
+	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL and
+	 * SCHED_BATCH is 0.
+	 */
+	if (param->sched_priority < 0 ||
+	    (p->mm && param->sched_priority > MAX_USER_RT_PRIO-1) ||
+	    (!p->mm && param->sched_priority > MAX_RT_PRIO-1))
+		return -EINVAL;
+	if (is_rt_policy(policy) != (param->sched_priority != 0))
+		return -EINVAL;
+
+	/*
+	 * Allow unprivileged RT tasks to decrease priority:
+	 */
+	if (user && !capable(CAP_SYS_NICE)) {
+		if (is_rt_policy(policy)) {
+			/* can't set/change the rt policy */
+			if (policy != p->policy && !rlim_rtprio)
+				return -EPERM;
+
+			/* can't increase priority */
+			if (param->sched_priority > p->rt_priority &&
+			    param->sched_priority > rlim_rtprio)
+				return -EPERM;
+		} else {
+			switch (p->policy) {
+				/*
+				 * Can only downgrade policies but not back to
+				 * SCHED_NORMAL
+				 */
+				case SCHED_ISO:
+					if (policy == SCHED_ISO)
+						goto out;
+					if (policy == SCHED_NORMAL)
+						return -EPERM;
+					break;
+				case SCHED_BATCH:
+					if (policy == SCHED_BATCH)
+						goto out;
+					if (policy != SCHED_IDLEPRIO)
+					    	return -EPERM;
+					break;
+				case SCHED_IDLEPRIO:
+					if (policy == SCHED_IDLEPRIO)
+						goto out;
+					return -EPERM;
+				default:
+					break;
+			}
+		}
+
+		/* can't change other user's priorities */
+		if ((current->euid != p->euid) &&
+		    (current->euid != p->uid))
+			return -EPERM;
+	}
+
+	retval = security_task_setscheduler(p, policy, param);
+	if (retval)
+		return retval;
+	/*
+	 * make sure no PI-waiters arrive (or leave) while we are
+	 * changing the priority of the task:
+	 */
+	spin_lock_irqsave(&p->pi_lock, flags);
+	/*
+	 * To be able to change p->policy safely, the apropriate
+	 * runqueue lock must be held.
+	 */
+	rq = __task_grq_lock(p);
+	/* recheck policy now with rq lock held */
+	if (unlikely(oldpolicy != -1 && oldpolicy != p->policy)) {
+		__task_grq_unlock();
+		spin_unlock_irqrestore(&p->pi_lock, flags);
+		policy = oldpolicy = -1;
+		goto recheck;
+	}
+	update_rq_clock(rq);
+	queued = task_queued(p);
+	if (queued)
+		dequeue_task(p);
+	oldprio = p->prio;
+	__setscheduler(p, rq, policy, param->sched_priority);
+	if (queued) {
+		enqueue_task(p);
+		try_preempt(p, rq);
+	}
+	__task_grq_unlock();
+	spin_unlock_irqrestore(&p->pi_lock, flags);
+
+	rt_mutex_adjust_pi(p);
+out:
+	return 0;
+}
+
+/**
+ * sched_setscheduler - change the scheduling policy and/or RT priority of a thread.
+ * @p: the task in question.
+ * @policy: new policy.
+ * @param: structure containing the new RT priority.
+ *
+ * NOTE that the task may be already dead.
+ */
+int sched_setscheduler(struct task_struct *p, int policy,
+		       struct sched_param *param)
+{
+	return __sched_setscheduler(p, policy, param, true);
+}
+
+EXPORT_SYMBOL_GPL(sched_setscheduler);
+
+/**
+ * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread from kernelspace.
+ * @p: the task in question.
+ * @policy: new policy.
+ * @param: structure containing the new RT priority.
+ *
+ * Just like sched_setscheduler, only don't bother checking if the
+ * current context has permission.  For example, this is needed in
+ * stop_machine(): we create temporary high priority worker threads,
+ * but our caller might not have that capability.
+ */
+int sched_setscheduler_nocheck(struct task_struct *p, int policy,
+			       struct sched_param *param)
+{
+	return __sched_setscheduler(p, policy, param, false);
+}
+
+static int
+do_sched_setscheduler(pid_t pid, int policy, struct sched_param __user *param)
+{
+	struct sched_param lparam;
+	struct task_struct *p;
+	int retval;
+
+	if (!param || pid < 0)
+		return -EINVAL;
+	if (copy_from_user(&lparam, param, sizeof(struct sched_param)))
+		return -EFAULT;
+
+	rcu_read_lock();
+	retval = -ESRCH;
+	p = find_process_by_pid(pid);
+	if (p != NULL)
+		retval = sched_setscheduler(p, policy, &lparam);
+	rcu_read_unlock();
+
+	return retval;
+}
+
+/**
+ * sys_sched_setscheduler - set/change the scheduler policy and RT priority
+ * @pid: the pid in question.
+ * @policy: new policy.
+ * @param: structure containing the new RT priority.
+ */
+asmlinkage long sys_sched_setscheduler(pid_t pid, int policy,
+				       struct sched_param __user *param)
+{
+	/* negative values for policy are not valid */
+	if (policy < 0)
+		return -EINVAL;
+
+	return do_sched_setscheduler(pid, policy, param);
+}
+
+/**
+ * sys_sched_setparam - set/change the RT priority of a thread
+ * @pid: the pid in question.
+ * @param: structure containing the new RT priority.
+ */
+SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
+{
+	return do_sched_setscheduler(pid, -1, param);
+}
+
+/**
+ * sys_sched_getscheduler - get the policy (scheduling class) of a thread
+ * @pid: the pid in question.
+ */
+SYSCALL_DEFINE1(sched_getscheduler, pid_t, pid)
+{
+	struct task_struct *p;
+	int retval = -EINVAL;
+
+	if (pid < 0)
+		goto out_nounlock;
+
+	retval = -ESRCH;
+	read_lock(&tasklist_lock);
+	p = find_process_by_pid(pid);
+	if (p) {
+		retval = security_task_getscheduler(p);
+		if (!retval)
+			retval = p->policy;
+	}
+	read_unlock(&tasklist_lock);
+
+out_nounlock:
+	return retval;
+}
+
+/**
+ * sys_sched_getscheduler - get the RT priority of a thread
+ * @pid: the pid in question.
+ * @param: structure containing the RT priority.
+ */
+SYSCALL_DEFINE2(sched_getparam, pid_t, pid, struct sched_param __user *, param)
+{
+	struct sched_param lp;
+	struct task_struct *p;
+	int retval = -EINVAL;
+
+	if (!param || pid < 0)
+		goto out_nounlock;
+
+	read_lock(&tasklist_lock);
+	p = find_process_by_pid(pid);
+	retval = -ESRCH;
+	if (!p)
+		goto out_unlock;
+
+	retval = security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	lp.sched_priority = p->rt_priority;
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * This one might sleep, we cannot do it with a spinlock held ...
+	 */
+	retval = copy_to_user(param, &lp, sizeof(*param)) ? -EFAULT : 0;
+
+out_nounlock:
+	return retval;
+
+out_unlock:
+	read_unlock(&tasklist_lock);
+	return retval;
+}
+
+long sched_setaffinity(pid_t pid, const cpumask_t *in_mask)
+{
+	cpumask_t cpus_allowed;
+	cpumask_t new_mask = *in_mask;
+	struct task_struct *p;
+	int retval;
+
+	get_online_cpus();
+	read_lock(&tasklist_lock);
+
+	p = find_process_by_pid(pid);
+	if (!p) {
+		read_unlock(&tasklist_lock);
+		put_online_cpus();
+		return -ESRCH;
+	}
+
+	/*
+	 * It is not safe to call set_cpus_allowed with the
+	 * tasklist_lock held. We will bump the task_struct's
+	 * usage count and then drop tasklist_lock.
+	 */
+	get_task_struct(p);
+	read_unlock(&tasklist_lock);
+
+	retval = -EPERM;
+	if ((current->euid != p->euid) && (current->euid != p->uid) &&
+			!capable(CAP_SYS_NICE))
+		goto out_unlock;
+
+	retval = security_task_setscheduler(p, 0, NULL);
+	if (retval)
+		goto out_unlock;
+
+	cpuset_cpus_allowed(p, &cpus_allowed);
+	cpus_and(new_mask, new_mask, cpus_allowed);
+ again:
+	retval = set_cpus_allowed_ptr(p, &new_mask);
+
+	if (!retval) {
+		cpuset_cpus_allowed(p, &cpus_allowed);
+		if (!cpus_subset(new_mask, cpus_allowed)) {
+			/*
+			 * We must have raced with a concurrent cpuset
+			 * update. Just reset the cpus_allowed to the
+			 * cpuset's cpus_allowed
+			 */
+			new_mask = cpus_allowed;
+			goto again;
+		}
+	}
+out_unlock:
+	put_task_struct(p);
+	put_online_cpus();
+	return retval;
+}
+
+static int get_user_cpu_mask(unsigned long __user *user_mask_ptr, unsigned len,
+			     cpumask_t *new_mask)
+{
+	if (len < sizeof(cpumask_t)) {
+		memset(new_mask, 0, sizeof(cpumask_t));
+	} else if (len > sizeof(cpumask_t)) {
+		len = sizeof(cpumask_t);
+	}
+	return copy_from_user(new_mask, user_mask_ptr, len) ? -EFAULT : 0;
+}
+
+/**
+ * sys_sched_setaffinity - set the cpu affinity of a process
+ * @pid: pid of the process
+ * @len: length in bytes of the bitmask pointed to by user_mask_ptr
+ * @user_mask_ptr: user-space pointer to the new cpu mask
+ */
+SYSCALL_DEFINE3(sched_setaffinity, pid_t, pid, unsigned int, len,
+		unsigned long __user *, user_mask_ptr)
+{
+	cpumask_t new_mask;
+	int retval;
+
+	retval = get_user_cpu_mask(user_mask_ptr, len, &new_mask);
+	if (retval)
+		return retval;
+
+	return sched_setaffinity(pid, &new_mask);
+}
+
+long sched_getaffinity(pid_t pid, cpumask_t *mask)
+{
+	struct task_struct *p;
+	int retval;
+
+	mutex_lock(&sched_hotcpu_mutex);
+	read_lock(&tasklist_lock);
+
+	retval = -ESRCH;
+	p = find_process_by_pid(pid);
+	if (!p)
+		goto out_unlock;
+
+	retval = security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	cpus_and(*mask, p->cpus_allowed, cpu_online_map);
+
+out_unlock:
+	read_unlock(&tasklist_lock);
+	mutex_unlock(&sched_hotcpu_mutex);
+	if (retval)
+		return retval;
+
+	return 0;
+}
+
+/**
+ * sys_sched_getaffinity - get the cpu affinity of a process
+ * @pid: pid of the process
+ * @len: length in bytes of the bitmask pointed to by user_mask_ptr
+ * @user_mask_ptr: user-space pointer to hold the current cpu mask
+ */
+SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
+		unsigned long __user *, user_mask_ptr)
+{
+	int ret;
+	cpumask_t mask;
+
+	if (len < sizeof(cpumask_t))
+		return -EINVAL;
+
+	ret = sched_getaffinity(pid, &mask);
+	if (ret < 0)
+		return ret;
+
+	if (copy_to_user(user_mask_ptr, &mask, sizeof(cpumask_t)))
+		return -EFAULT;
+
+	return sizeof(cpumask_t);
+}
+
+/**
+ * sys_sched_yield - yield the current processor to other threads.
+ *
+ * This function yields the current CPU to other tasks. It does this by
+ * refilling the timeslice, resetting the deadline and scheduling away.
+ */
+SYSCALL_DEFINE0(sched_yield)
+{
+	struct task_struct *p;
+
+	p = current;
+	time_task_grq_lock_irq(p);
+	schedstat_inc(this_rq(), yld_count);
+	time_slice_expired(p);
+	requeue_task(p);
+
+	/*
+	 * Since we are going to call schedule() anyway, there's
+	 * no need to preempt or enable interrupts:
+	 */
+	__release(grq.lock);
+	spin_release(&grq.lock.dep_map, 1, _THIS_IP_);
+	_raw_spin_unlock(&grq.lock);
+	preempt_enable_no_resched();
+
+	schedule();
+
+	return 0;
+}
+
+static void __cond_resched(void)
+{
+#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+	__might_sleep(__FILE__, __LINE__);
+#endif
+	/*
+	 * The BKS might be reacquired before we have dropped
+	 * PREEMPT_ACTIVE, which could trigger a second
+	 * cond_resched() call.
+	 */
+	do {
+		add_preempt_count(PREEMPT_ACTIVE);
+		schedule();
+		sub_preempt_count(PREEMPT_ACTIVE);
+	} while (need_resched());
+}
+
+int __sched _cond_resched(void)
+{
+	if (need_resched() && !(preempt_count() & PREEMPT_ACTIVE) &&
+					system_state == SYSTEM_RUNNING) {
+		__cond_resched();
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(_cond_resched);
+
+/*
+ * cond_resched_lock() - if a reschedule is pending, drop the given lock,
+ * call schedule, and on return reacquire the lock.
+ *
+ * This works OK both with and without CONFIG_PREEMPT.  We do strange low-level
+ * operations here to prevent schedule() from being called twice (once via
+ * spin_unlock(), once by hand).
+ */
+int cond_resched_lock(spinlock_t *lock)
+{
+	int resched = need_resched() && system_state == SYSTEM_RUNNING;
+	int ret = 0;
+
+	if (spin_needbreak(lock) || resched) {
+		spin_unlock(lock);
+		if (resched && need_resched())
+			__cond_resched();
+		else
+			cpu_relax();
+		ret = 1;
+		spin_lock(lock);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(cond_resched_lock);
+
+int __sched cond_resched_softirq(void)
+{
+	BUG_ON(!in_softirq());
+
+	if (need_resched() && system_state == SYSTEM_RUNNING) {
+		local_bh_enable();
+		__cond_resched();
+		local_bh_disable();
+		return 1;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(cond_resched_softirq);
+
+/**
+ * yield - yield the current processor to other threads.
+ *
+ * This is a shortcut for kernel-space yielding - it marks the
+ * thread runnable and calls sys_sched_yield().
+ */
+void __sched yield(void)
+{
+	set_current_state(TASK_RUNNING);
+	sys_sched_yield();
+}
+EXPORT_SYMBOL(yield);
+
+/*
+ * This task is about to go to sleep on IO.  Increment rq->nr_iowait so
+ * that process accounting knows that this is a task in IO wait state.
+ *
+ * But don't do that if it is a deliberate, throttling IO wait (this task
+ * has set its backing_dev_info: the queue against which it should throttle)
+ */
+void __sched io_schedule(void)
+{
+	struct rq *rq = &__raw_get_cpu_var(runqueues);
+
+	delayacct_blkio_start();
+	atomic_inc(&rq->nr_iowait);
+	schedule();
+	atomic_dec(&rq->nr_iowait);
+	delayacct_blkio_end();
+}
+EXPORT_SYMBOL(io_schedule);
+
+long __sched io_schedule_timeout(long timeout)
+{
+	struct rq *rq = &__raw_get_cpu_var(runqueues);
+	long ret;
+
+	delayacct_blkio_start();
+	atomic_inc(&rq->nr_iowait);
+	ret = schedule_timeout(timeout);
+	atomic_dec(&rq->nr_iowait);
+	delayacct_blkio_end();
+	return ret;
+}
+
+/**
+ * sys_sched_get_priority_max - return maximum RT priority.
+ * @policy: scheduling class.
+ *
+ * this syscall returns the maximum rt_priority that can be used
+ * by a given scheduling class.
+ */
+SYSCALL_DEFINE1(sched_get_priority_max, int, policy)
+{
+	int ret = -EINVAL;
+
+	switch (policy) {
+	case SCHED_FIFO:
+	case SCHED_RR:
+		ret = MAX_USER_RT_PRIO-1;
+		break;
+	case SCHED_NORMAL:
+	case SCHED_BATCH:
+	case SCHED_ISO:
+	case SCHED_IDLEPRIO:
+		ret = 0;
+		break;
+	}
+	return ret;
+}
+
+/**
+ * sys_sched_get_priority_min - return minimum RT priority.
+ * @policy: scheduling class.
+ *
+ * this syscall returns the minimum rt_priority that can be used
+ * by a given scheduling class.
+ */
+SYSCALL_DEFINE1(sched_get_priority_min, int, policy)
+{
+	int ret = -EINVAL;
+
+	switch (policy) {
+	case SCHED_FIFO:
+	case SCHED_RR:
+		ret = 1;
+		break;
+	case SCHED_NORMAL:
+	case SCHED_BATCH:
+	case SCHED_ISO:
+	case SCHED_IDLEPRIO:
+		ret = 0;
+		break;
+	}
+	return ret;
+}
+
+/**
+ * sys_sched_rr_get_interval - return the default timeslice of a process.
+ * @pid: pid of the process.
+ * @interval: userspace pointer to the timeslice value.
+ *
+ * this syscall writes the default timeslice value of a given process
+ * into the user-space timespec buffer. A value of '0' means infinity.
+ */
+SYSCALL_DEFINE2(sched_rr_get_interval, pid_t, pid,
+		struct timespec __user *, interval)
+{
+	struct task_struct *p;
+	int retval = -EINVAL;
+	struct timespec t;
+
+	if (pid < 0)
+		goto out_nounlock;
+
+	retval = -ESRCH;
+	read_lock(&tasklist_lock);
+	p = find_process_by_pid(pid);
+	if (!p)
+		goto out_unlock;
+
+	retval = security_task_getscheduler(p);
+	if (retval)
+		goto out_unlock;
+
+	t = ns_to_timespec(p->policy == SCHED_FIFO ? 0 :
+			   MS_TO_NS(task_timeslice(p)));
+	read_unlock(&tasklist_lock);
+	retval = copy_to_user(interval, &t, sizeof(t)) ? -EFAULT : 0;
+out_nounlock:
+	return retval;
+out_unlock:
+	read_unlock(&tasklist_lock);
+	return retval;
+}
+
+static const char stat_nam[] = TASK_STATE_TO_CHAR_STR;
+
+void sched_show_task(struct task_struct *p)
+{
+	unsigned long free = 0;
+	unsigned state;
+
+	state = p->state ? __ffs(p->state) + 1 : 0;
+	printk(KERN_INFO "%-13.13s %c", p->comm,
+		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
+#if BITS_PER_LONG == 32
+	if (state == TASK_RUNNING)
+		printk(KERN_CONT " running  ");
+	else
+		printk(KERN_CONT " %08lx ", thread_saved_pc(p));
+#else
+	if (state == TASK_RUNNING)
+		printk(KERN_CONT "  running task    ");
+	else
+		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
+#endif
+#ifdef CONFIG_DEBUG_STACK_USAGE
+	{
+		unsigned long *n = end_of_stack(p);
+		while (!*n)
+			n++;
+		free = (unsigned long)n - (unsigned long)end_of_stack(p);
+	}
+#endif
+	printk(KERN_CONT "%5lu %5d %6d\n", free,
+		task_pid_nr(p), task_pid_nr(p->real_parent));
+
+	show_stack(p, NULL);
+}
+
+void show_state_filter(unsigned long state_filter)
+{
+	struct task_struct *g, *p;
+
+#if BITS_PER_LONG == 32
+	printk(KERN_INFO
+		"  task                PC stack   pid father\n");
+#else
+	printk(KERN_INFO
+		"  task                        PC stack   pid father\n");
+#endif
+	read_lock(&tasklist_lock);
+	do_each_thread(g, p) {
+		/*
+		 * reset the NMI-timeout, listing all files on a slow
+		 * console might take alot of time:
+		 */
+		touch_nmi_watchdog();
+		if (!state_filter || (p->state & state_filter))
+			sched_show_task(p);
+	} while_each_thread(g, p);
+
+	touch_all_softlockup_watchdogs();
+
+	read_unlock(&tasklist_lock);
+	/*
+	 * Only show locks if all tasks are dumped:
+	 */
+	if (state_filter == -1)
+		debug_show_all_locks();
+}
+
+/**
+ * init_idle - set up an idle thread for a given CPU
+ * @idle: task in question
+ * @cpu: cpu the idle task belongs to
+ *
+ * NOTE: this function does not set the idle thread's NEED_RESCHED
+ * flag, to make booting more robust.
+ */
+void init_idle(struct task_struct *idle, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long flags;
+
+	time_grq_lock(rq, &flags);
+	idle->last_ran = rq->clock;
+	idle->state = TASK_RUNNING;
+	/* Setting prio to illegal value shouldn't matter when never queued */
+	idle->prio = PRIO_LIMIT;
+	set_rq_task(rq, idle);
+	idle->cpus_allowed = cpumask_of_cpu(cpu);
+	set_task_cpu(idle, cpu);
+	rq->curr = rq->idle = idle;
+	idle->oncpu = 1;
+	set_cpuidle_map(cpu);
+#ifdef CONFIG_HOTPLUG_CPU
+	idle->unplugged_mask = CPU_MASK_NONE;
+#endif
+	grq_unlock_irqrestore(&flags);
+
+	/* Set the preempt count _outside_ the spinlocks! */
+#if defined(CONFIG_PREEMPT) && !defined(CONFIG_PREEMPT_BKL)
+	task_thread_info(idle)->preempt_count = (idle->lock_depth >= 0);
+#else
+	task_thread_info(idle)->preempt_count = 0;
+#endif
+}
+
+/*
+ * In a system that switches off the HZ timer nohz_cpu_mask
+ * indicates which cpus entered this state. This is used
+ * in the rcu update to wait only for active cpus. For system
+ * which do not switch off the HZ timer nohz_cpu_mask should
+ * always be CPU_MASK_NONE.
+ */
+cpumask_t nohz_cpu_mask = CPU_MASK_NONE;
+
+#ifdef CONFIG_SMP
+#ifdef CONFIG_NO_HZ
+static struct {
+	atomic_t load_balancer;
+	cpumask_t cpu_mask;
+} nohz ____cacheline_aligned = {
+	.load_balancer = ATOMIC_INIT(-1),
+	.cpu_mask = CPU_MASK_NONE,
+};
+
+/*
+ * This routine will try to nominate the ilb (idle load balancing)
+ * owner among the cpus whose ticks are stopped. ilb owner will do the idle
+ * load balancing on behalf of all those cpus. If all the cpus in the system
+ * go into this tickless mode, then there will be no ilb owner (as there is
+ * no need for one) and all the cpus will sleep till the next wakeup event
+ * arrives...
+ *
+ * For the ilb owner, tick is not stopped. And this tick will be used
+ * for idle load balancing. ilb owner will still be part of
+ * nohz.cpu_mask..
+ *
+ * While stopping the tick, this cpu will become the ilb owner if there
+ * is no other owner. And will be the owner till that cpu becomes busy
+ * or if all cpus in the system stop their ticks at which point
+ * there is no need for ilb owner.
+ *
+ * When the ilb owner becomes busy, it nominates another owner, during the
+ * next busy scheduler_tick()
+ */
+int select_nohz_load_balancer(int stop_tick)
+{
+	int cpu = smp_processor_id();
+
+	if (stop_tick) {
+		cpu_set(cpu, nohz.cpu_mask);
+		cpu_rq(cpu)->in_nohz_recently = 1;
+
+		/*
+		 * If we are going offline and still the leader, give up!
+		 */
+		if (!cpu_active(cpu) &&
+		    atomic_read(&nohz.load_balancer) == cpu) {
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+				BUG();
+			return 0;
+		}
+
+		/* time for ilb owner also to sleep */
+		if (cpus_weight(nohz.cpu_mask) == num_online_cpus()) {
+			if (atomic_read(&nohz.load_balancer) == cpu)
+				atomic_set(&nohz.load_balancer, -1);
+			return 0;
+		}
+
+		if (atomic_read(&nohz.load_balancer) == -1) {
+			/* make me the ilb owner */
+			if (atomic_cmpxchg(&nohz.load_balancer, -1, cpu) == -1)
+				return 1;
+		} else if (atomic_read(&nohz.load_balancer) == cpu)
+			return 1;
+	} else {
+		if (!cpu_isset(cpu, nohz.cpu_mask))
+			return 0;
+
+		cpu_clear(cpu, nohz.cpu_mask);
+
+		if (atomic_read(&nohz.load_balancer) == cpu)
+			if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
+				BUG();
+	}
+	return 0;
+}
+
+/*
+ * When add_timer_on() enqueues a timer into the timer wheel of an
+ * idle CPU then this timer might expire before the next timer event
+ * which is scheduled to wake up that CPU. In case of a completely
+ * idle system the next event might even be infinite time into the
+ * future. wake_up_idle_cpu() ensures that the CPU is woken up and
+ * leaves the inner idle loop so the newly added timer is taken into
+ * account when the CPU goes back to idle and evaluates the timer
+ * wheel for the next timer event.
+ */
+void wake_up_idle_cpu(int cpu)
+{
+	struct task_struct *idle;
+	struct rq *rq;
+
+	if (cpu == smp_processor_id())
+		return;
+
+	rq = cpu_rq(cpu);
+	idle = rq->idle;
+
+	/*
+	 * This is safe, as this function is called with the timer
+	 * wheel base lock of (cpu) held. When the CPU is on the way
+	 * to idle and has not yet set rq->curr to idle then it will
+	 * be serialised on the timer wheel base lock and take the new
+	 * timer into account automatically.
+	 */
+	if (unlikely(rq->curr != idle))
+		return;
+
+	/*
+	 * We can set TIF_RESCHED on the idle task of the other CPU
+	 * lockless. The worst case is that the other CPU runs the
+	 * idle task through an additional NOOP schedule()
+	 */
+	set_tsk_thread_flag(idle, TIF_NEED_RESCHED);
+
+	/* NEED_RESCHED must be visible before we test polling */
+	smp_mb();
+	if (!tsk_is_polling(idle))
+		smp_send_reschedule(cpu);
+}
+
+#endif /* CONFIG_NO_HZ */
+
+/*
+ * Change a given task's CPU affinity. Migrate the thread to a
+ * proper CPU and schedule it away if the CPU it's executing on
+ * is removed from the allowed bitmask.
+ *
+ * NOTE: the caller must have a valid reference to the task, the
+ * task must not exit() & deallocate itself prematurely. The
+ * call is not atomic; no spinlocks may be held.
+ */
+int set_cpus_allowed_ptr(struct task_struct *p, const cpumask_t *new_mask)
+{
+	unsigned long flags;
+	int running_wrong = 0;
+	int queued = 0;
+	struct rq *rq;
+	int ret = 0;
+
+	rq = task_grq_lock(p, &flags);
+	if (!cpus_intersects(*new_mask, cpu_online_map)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current &&
+		     !cpus_equal(p->cpus_allowed, *new_mask))) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	queued = task_queued(p);
+
+	p->cpus_allowed = *new_mask;
+
+	/* Can the task run on the task's current CPU? If so, we're done */
+	if (cpu_isset(task_cpu(p), *new_mask))
+		goto out;
+
+	if (task_running(p)) {
+		/* Task is running on the wrong cpu now, reschedule it. */
+		set_tsk_need_resched(p);
+		running_wrong = 1;
+	} else
+		set_task_cpu(p, any_online_cpu(*new_mask));
+
+out:
+	if (queued)
+		try_preempt(p, rq);
+	task_grq_unlock(&flags);
+
+	if (running_wrong)
+		_cond_resched();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(set_cpus_allowed_ptr);
+
+#ifdef CONFIG_HOTPLUG_CPU
+/* Schedules idle task to be the next runnable task on current CPU.
+ * It does so by boosting its priority to highest possible.
+ * Used by CPU offline code.
+ */
+void sched_idle_next(void)
+{
+	int this_cpu = smp_processor_id();
+	struct rq *rq = cpu_rq(this_cpu);
+	struct task_struct *idle = rq->idle;
+	unsigned long flags;
+
+	/* cpu has to be offline */
+	BUG_ON(cpu_online(this_cpu));
+
+	/*
+	 * Strictly not necessary since rest of the CPUs are stopped by now
+	 * and interrupts disabled on the current cpu.
+	 */
+	time_grq_lock(rq, &flags);
+
+	__setscheduler(idle, rq, SCHED_FIFO, MAX_RT_PRIO - 1);
+
+	activate_idle_task(idle);
+	set_tsk_need_resched(rq->curr);
+
+	grq_unlock_irqrestore(&flags);
+}
+
+/*
+ * Ensures that the idle task is using init_mm right before its cpu goes
+ * offline.
+ */
+void idle_task_exit(void)
+{
+	struct mm_struct *mm = current->active_mm;
+
+	BUG_ON(cpu_online(smp_processor_id()));
+
+	if (mm != &init_mm)
+		switch_mm(mm, &init_mm, current);
+	mmdrop(mm);
+}
+
+#endif /* CONFIG_HOTPLUG_CPU */
+
+#if defined(CONFIG_SCHED_DEBUG) && defined(CONFIG_SYSCTL)
+
+static struct ctl_table sd_ctl_dir[] = {
+	{
+		.procname	= "sched_domain",
+		.mode		= 0555,
+	},
+	{0, },
+};
+
+static struct ctl_table sd_ctl_root[] = {
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= sd_ctl_dir,
+	},
+	{0, },
+};
+
+static struct ctl_table *sd_alloc_ctl_entry(int n)
+{
+	struct ctl_table *entry =
+		kcalloc(n, sizeof(struct ctl_table), GFP_KERNEL);
+
+	return entry;
+}
+
+static void sd_free_ctl_entry(struct ctl_table **tablep)
+{
+	struct ctl_table *entry;
+
+	/*
+	 * In the intermediate directories, both the child directory and
+	 * procname are dynamically allocated and could fail but the mode
+	 * will always be set. In the lowest directory the names are
+	 * static strings and all have proc handlers.
+	 */
+	for (entry = *tablep; entry->mode; entry++) {
+		if (entry->child)
+			sd_free_ctl_entry(&entry->child);
+		if (entry->proc_handler == NULL)
+			kfree(entry->procname);
+	}
+
+	kfree(*tablep);
+	*tablep = NULL;
+}
+
+static void
+set_table_entry(struct ctl_table *entry,
+		const char *procname, void *data, int maxlen,
+		mode_t mode, proc_handler *proc_handler)
+{
+	entry->procname = procname;
+	entry->data = data;
+	entry->maxlen = maxlen;
+	entry->mode = mode;
+	entry->proc_handler = proc_handler;
+}
+
+static struct ctl_table *
+sd_alloc_ctl_domain_table(struct sched_domain *sd)
+{
+	struct ctl_table *table = sd_alloc_ctl_entry(12);
+
+	if (table == NULL)
+		return NULL;
+
+	set_table_entry(&table[0], "min_interval", &sd->min_interval,
+		sizeof(long), 0644, proc_doulongvec_minmax);
+	set_table_entry(&table[1], "max_interval", &sd->max_interval,
+		sizeof(long), 0644, proc_doulongvec_minmax);
+	set_table_entry(&table[2], "busy_idx", &sd->busy_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[3], "idle_idx", &sd->idle_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[4], "newidle_idx", &sd->newidle_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[5], "wake_idx", &sd->wake_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[6], "forkexec_idx", &sd->forkexec_idx,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[7], "busy_factor", &sd->busy_factor,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[9], "cache_nice_tries",
+		&sd->cache_nice_tries,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	set_table_entry(&table[10], "flags", &sd->flags,
+		sizeof(int), 0644, proc_dointvec_minmax);
+	/* &table[11] is terminator */
+
+	return table;
+}
+
+static ctl_table *sd_alloc_ctl_cpu_table(int cpu)
+{
+	struct ctl_table *entry, *table;
+	struct sched_domain *sd;
+	int domain_num = 0, i;
+	char buf[32];
+
+	for_each_domain(cpu, sd)
+		domain_num++;
+	entry = table = sd_alloc_ctl_entry(domain_num + 1);
+	if (table == NULL)
+		return NULL;
+
+	i = 0;
+	for_each_domain(cpu, sd) {
+		snprintf(buf, 32, "domain%d", i);
+		entry->procname = kstrdup(buf, GFP_KERNEL);
+		entry->mode = 0555;
+		entry->child = sd_alloc_ctl_domain_table(sd);
+		entry++;
+		i++;
+	}
+	return table;
+}
+
+static struct ctl_table_header *sd_sysctl_header;
+static void register_sched_domain_sysctl(void)
+{
+	int i, cpu_num = num_online_cpus();
+	struct ctl_table *entry = sd_alloc_ctl_entry(cpu_num + 1);
+	char buf[32];
+
+	WARN_ON(sd_ctl_dir[0].child);
+	sd_ctl_dir[0].child = entry;
+
+	if (entry == NULL)
+		return;
+
+	for_each_online_cpu(i) {
+		snprintf(buf, 32, "cpu%d", i);
+		entry->procname = kstrdup(buf, GFP_KERNEL);
+		entry->mode = 0555;
+		entry->child = sd_alloc_ctl_cpu_table(i);
+		entry++;
+	}
+
+	WARN_ON(sd_sysctl_header);
+	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
+}
+
+/* may be called multiple times per register */
+static void unregister_sched_domain_sysctl(void)
+{
+	if (sd_sysctl_header)
+		unregister_sysctl_table(sd_sysctl_header);
+	sd_sysctl_header = NULL;
+	if (sd_ctl_dir[0].child)
+		sd_free_ctl_entry(&sd_ctl_dir[0].child);
+}
+#else
+static void register_sched_domain_sysctl(void)
+{
+}
+static void unregister_sched_domain_sysctl(void)
+{
+}
+#endif
+
+static void set_rq_online(struct rq *rq)
+{
+	if (!rq->online) {
+		cpu_set(rq->cpu, rq->rd->online);
+		rq->online = 1;
+	}
+}
+
+static void set_rq_offline(struct rq *rq)
+{
+	if (rq->online) {
+		cpu_clear(rq->cpu, rq->rd->online);
+		rq->online = 0;
+	}
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+/*
+ * This cpu is going down, so walk over the tasklist and find tasks that can
+ * only run on this cpu and remove their affinity. Store their value in
+ * unplugged_mask so it can be restored once their correct cpu is online. No
+ * need to do anything special since they'll just move on next reschedule if
+ * they're running.
+ */
+static void remove_cpu(unsigned long cpu)
+{
+	struct task_struct *p, *t;
+
+	read_lock(&tasklist_lock);
+
+	do_each_thread(t, p) {
+		cpumask_t cpus_remaining;
+
+		cpus_and(cpus_remaining, p->cpus_allowed, cpu_online_map);
+		cpu_clear(cpu, cpus_remaining);
+		if (cpus_empty(cpus_remaining)) {
+			p->unplugged_mask = p->cpus_allowed;
+			p->cpus_allowed = cpu_possible_map;
+		}
+	} while_each_thread(t, p);
+
+	read_unlock(&tasklist_lock);
+}
+
+/*
+ * This cpu is coming up so add it to the cpus_allowed.
+ */
+static void add_cpu(unsigned long cpu)
+{
+	struct task_struct *p, *t;
+
+	read_lock(&tasklist_lock);
+
+	do_each_thread(t, p) {
+		/* Have we taken all the cpus from the unplugged_mask back */
+		if (cpus_empty(p->unplugged_mask))
+			continue;
+
+		/* Was this cpu in the unplugged_mask mask */
+		if (cpu_isset(cpu, p->unplugged_mask)) {
+			cpu_set(cpu, p->cpus_allowed);
+			if (cpus_subset(p->unplugged_mask, p->cpus_allowed)) {
+				/*
+				 * Have we set more than the unplugged_mask?
+				 * If so, that means we have remnants set from
+				 * the unplug/plug cycle and need to remove
+				 * them. Then clear the unplugged_mask as we've
+				 * set all the cpus back.
+				 */
+				p->cpus_allowed = p->unplugged_mask;
+				cpus_clear(p->unplugged_mask);
+			}
+		}
+	} while_each_thread(t, p);
+
+	read_unlock(&tasklist_lock);
+}
+#else
+static void add_cpu(unsigned long cpu)
+{
+}
+#endif
+
+/*
+ * migration_call - callback that gets triggered when a CPU is added.
+ */
+static int __cpuinit
+migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
+{
+	struct task_struct *idle;
+	int cpu = (long)hcpu;
+	unsigned long flags;
+	struct rq *rq;
+
+	switch (action) {
+
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		break;
+
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		/* Update our root-domain */
+		rq = cpu_rq(cpu);
+		grq_lock_irqsave(&flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+
+			set_rq_online(rq);
+		}
+		add_cpu(cpu);
+		grq_unlock_irqrestore(&flags);
+		break;
+
+#ifdef CONFIG_HOTPLUG_CPU
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		break;
+
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		cpuset_lock(); /* around calls to cpuset_cpus_allowed_lock() */
+		rq = cpu_rq(cpu);
+		idle = rq->idle;
+		/* Idle task back to normal (off runqueue, low prio) */
+		grq_lock_irq();
+		remove_cpu(cpu);
+		return_task(idle, 1);
+		idle->static_prio = MAX_PRIO;
+		__setscheduler(idle, rq, SCHED_NORMAL, 0);
+		idle->prio = PRIO_LIMIT;
+		set_rq_task(rq, idle);
+		update_rq_clock(rq);
+		grq_unlock_irq();
+		cpuset_unlock();
+		break;
+
+	case CPU_DYING:
+	case CPU_DYING_FROZEN:
+		rq = cpu_rq(cpu);
+		grq_lock_irqsave(&flags);
+		if (rq->rd) {
+			BUG_ON(!cpu_isset(cpu, rq->rd->span));
+			set_rq_offline(rq);
+		}
+		grq_unlock_irqrestore(&flags);
+		break;
+#endif
+	}
+	return NOTIFY_OK;
+}
+
+/* Register at highest priority so that task migration (migrate_all_tasks)
+ * happens before everything else.
+ */
+static struct notifier_block __cpuinitdata migration_notifier = {
+	.notifier_call = migration_call,
+	.priority = 10
+};
+
+int __init migration_init(void)
+{
+	void *cpu = (void *)(long)smp_processor_id();
+	int err;
+
+	/* Start one for the boot CPU: */
+	err = migration_call(&migration_notifier, CPU_UP_PREPARE, cpu);
+	BUG_ON(err == NOTIFY_BAD);
+	migration_call(&migration_notifier, CPU_ONLINE, cpu);
+	register_cpu_notifier(&migration_notifier);
+
+	return 0;
+}
+early_initcall(migration_init);
+#endif
+
+/*
+ * sched_domains_mutex serialises calls to arch_init_sched_domains,
+ * detach_destroy_domains and partition_sched_domains.
+ */
+static DEFINE_MUTEX(sched_domains_mutex);
+
+#ifdef CONFIG_SMP
+
+#ifdef CONFIG_SCHED_DEBUG
+
+static inline const char *sd_level_to_string(enum sched_domain_level lvl)
+{
+	switch (lvl) {
+	case SD_LV_NONE:
+			return "NONE";
+	case SD_LV_SIBLING:
+			return "SIBLING";
+	case SD_LV_MC:
+			return "MC";
+	case SD_LV_CPU:
+			return "CPU";
+	case SD_LV_NODE:
+			return "NODE";
+	case SD_LV_ALLNODES:
+			return "ALLNODES";
+	case SD_LV_MAX:
+			return "MAX";
+
+	}
+	return "MAX";
+}
+
+static int sched_domain_debug_one(struct sched_domain *sd, int cpu, int level,
+				  cpumask_t *groupmask)
+{
+	struct sched_group *group = sd->groups;
+	char str[256];
+
+	cpulist_scnprintf(str, sizeof(str), sd->span);
+	cpus_clear(*groupmask);
+
+	printk(KERN_DEBUG "%*s domain %d: ", level, "", level);
+
+	if (!(sd->flags & SD_LOAD_BALANCE)) {
+		printk("does not load-balance\n");
+		if (sd->parent)
+			printk(KERN_ERR "ERROR: !SD_LOAD_BALANCE domain"
+					" has parent");
+		return -1;
+	}
+
+	printk(KERN_CONT "span %s level %s\n",
+		str, sd_level_to_string(sd->level));
+
+	if (!cpu_isset(cpu, sd->span)) {
+		printk(KERN_ERR "ERROR: domain->span does not contain "
+				"CPU%d\n", cpu);
+	}
+	if (!cpu_isset(cpu, group->cpumask)) {
+		printk(KERN_ERR "ERROR: domain->groups does not contain"
+				" CPU%d\n", cpu);
+	}
+
+	printk(KERN_DEBUG "%*s groups:", level + 1, "");
+	do {
+		if (!group) {
+			printk("\n");
+			printk(KERN_ERR "ERROR: group is NULL\n");
+			break;
+		}
+
+		if (!group->__cpu_power) {
+			printk(KERN_CONT "\n");
+			printk(KERN_ERR "ERROR: domain->cpu_power not "
+					"set\n");
+			break;
+		}
+
+		if (!cpus_weight(group->cpumask)) {
+			printk(KERN_CONT "\n");
+			printk(KERN_ERR "ERROR: empty group\n");
+			break;
+		}
+
+		if (cpus_intersects(*groupmask, group->cpumask)) {
+			printk(KERN_CONT "\n");
+			printk(KERN_ERR "ERROR: repeated CPUs\n");
+			break;
+		}
+
+		cpus_or(*groupmask, *groupmask, group->cpumask);
+
+		cpulist_scnprintf(str, sizeof(str), group->cpumask);
+		printk(KERN_CONT " %s", str);
+
+		group = group->next;
+	} while (group != sd->groups);
+	printk(KERN_CONT "\n");
+
+	if (!cpus_equal(sd->span, *groupmask))
+		printk(KERN_ERR "ERROR: groups don't span domain->span\n");
+
+	if (sd->parent && !cpus_subset(*groupmask, sd->parent->span))
+		printk(KERN_ERR "ERROR: parent span is not a superset "
+			"of domain->span\n");
+	return 0;
+}
+
+static void sched_domain_debug(struct sched_domain *sd, int cpu)
+{
+	cpumask_t *groupmask;
+	int level = 0;
+
+	if (!sd) {
+		printk(KERN_DEBUG "CPU%d attaching NULL sched-domain.\n", cpu);
+		return;
+	}
+
+	printk(KERN_DEBUG "CPU%d attaching sched-domain:\n", cpu);
+
+	groupmask = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (!groupmask) {
+		printk(KERN_DEBUG "Cannot load-balance (out of memory)\n");
+		return;
+	}
+
+	for (;;) {
+		if (sched_domain_debug_one(sd, cpu, level, groupmask))
+			break;
+		level++;
+		sd = sd->parent;
+		if (!sd)
+			break;
+	}
+	kfree(groupmask);
+}
+#else /* !CONFIG_SCHED_DEBUG */
+# define sched_domain_debug(sd, cpu) do { } while (0)
+#endif /* CONFIG_SCHED_DEBUG */
+
+static int sd_degenerate(struct sched_domain *sd)
+{
+	if (cpus_weight(sd->span) == 1)
+		return 1;
+
+	/* Following flags need at least 2 groups */
+	if (sd->flags & (SD_LOAD_BALANCE |
+			 SD_BALANCE_NEWIDLE |
+			 SD_BALANCE_FORK |
+			 SD_BALANCE_EXEC |
+			 SD_SHARE_CPUPOWER |
+			 SD_SHARE_PKG_RESOURCES)) {
+		if (sd->groups != sd->groups->next)
+			return 0;
+	}
+
+	/* Following flags don't use groups */
+	if (sd->flags & (SD_WAKE_IDLE |
+			 SD_WAKE_AFFINE |
+			 SD_WAKE_BALANCE))
+		return 0;
+
+	return 1;
+}
+
+static int
+sd_parent_degenerate(struct sched_domain *sd, struct sched_domain *parent)
+{
+	unsigned long cflags = sd->flags, pflags = parent->flags;
+
+	if (sd_degenerate(parent))
+		return 1;
+
+	if (!cpus_equal(sd->span, parent->span))
+		return 0;
+
+	/* Does parent contain flags not in child? */
+	/* WAKE_BALANCE is a subset of WAKE_AFFINE */
+	if (cflags & SD_WAKE_AFFINE)
+		pflags &= ~SD_WAKE_BALANCE;
+	/* Flags needing groups don't count if only 1 group in parent */
+	if (parent->groups == parent->groups->next) {
+		pflags &= ~(SD_LOAD_BALANCE |
+				SD_BALANCE_NEWIDLE |
+				SD_BALANCE_FORK |
+				SD_BALANCE_EXEC |
+				SD_SHARE_CPUPOWER |
+				SD_SHARE_PKG_RESOURCES);
+	}
+	if (~cflags & pflags)
+		return 0;
+
+	return 1;
+}
+
+static void rq_attach_root(struct rq *rq, struct root_domain *rd)
+{
+	unsigned long flags;
+
+	grq_lock_irqsave(&flags);
+
+	if (rq->rd) {
+		struct root_domain *old_rd = rq->rd;
+
+		if (cpu_isset(rq->cpu, old_rd->online))
+			set_rq_offline(rq);
+
+		cpu_clear(rq->cpu, old_rd->span);
+
+		if (atomic_dec_and_test(&old_rd->refcount))
+			kfree(old_rd);
+	}
+
+	atomic_inc(&rd->refcount);
+	rq->rd = rd;
+
+	cpu_set(rq->cpu, rd->span);
+	if (cpu_isset(rq->cpu, cpu_online_map))
+		set_rq_online(rq);
+
+	grq_unlock_irqrestore(&flags);
+}
+
+static void init_rootdomain(struct root_domain *rd)
+{
+	memset(rd, 0, sizeof(*rd));
+
+	cpus_clear(rd->span);
+	cpus_clear(rd->online);
+}
+
+static void init_defrootdomain(void)
+{
+	init_rootdomain(&def_root_domain);
+
+	atomic_set(&def_root_domain.refcount, 1);
+}
+
+static struct root_domain *alloc_rootdomain(void)
+{
+	struct root_domain *rd;
+
+	rd = kmalloc(sizeof(*rd), GFP_KERNEL);
+	if (!rd)
+		return NULL;
+
+	init_rootdomain(rd);
+
+	return rd;
+}
+
+/*
+ * Attach the domain 'sd' to 'cpu' as its base domain. Callers must
+ * hold the hotplug lock.
+ */
+static void
+cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+	struct sched_domain *tmp;
+
+	/* Remove the sched domains which do not contribute to scheduling. */
+	for (tmp = sd; tmp; tmp = tmp->parent) {
+		struct sched_domain *parent = tmp->parent;
+		if (!parent)
+			break;
+		if (sd_parent_degenerate(tmp, parent)) {
+			tmp->parent = parent->parent;
+			if (parent->parent)
+				parent->parent->child = tmp;
+		}
+	}
+
+	if (sd && sd_degenerate(sd)) {
+		sd = sd->parent;
+		if (sd)
+			sd->child = NULL;
+	}
+
+	sched_domain_debug(sd, cpu);
+
+	rq_attach_root(rq, rd);
+	rcu_assign_pointer(rq->sd, sd);
+}
+
+/* cpus with isolated domains */
+static cpumask_t cpu_isolated_map = CPU_MASK_NONE;
+
+/* Setup the mask of cpus configured for isolated domains */
+static int __init isolated_cpu_setup(char *str)
+{
+	static int __initdata ints[NR_CPUS];
+	int i;
+
+	str = get_options(str, ARRAY_SIZE(ints), ints);
+	cpus_clear(cpu_isolated_map);
+	for (i = 1; i <= ints[0]; i++)
+		if (ints[i] < NR_CPUS)
+			cpu_set(ints[i], cpu_isolated_map);
+	return 1;
+}
+
+__setup("isolcpus=", isolated_cpu_setup);
+
+/*
+ * init_sched_build_groups takes the cpumask we wish to span, and a pointer
+ * to a function which identifies what group(along with sched group) a CPU
+ * belongs to. The return value of group_fn must be a >= 0 and < NR_CPUS
+ * (due to the fact that we keep track of groups covered with a cpumask_t).
+ *
+ * init_sched_build_groups will build a circular linked list of the groups
+ * covered by the given span, and will set each group's ->cpumask correctly,
+ * and ->cpu_power to 0.
+ */
+static void
+init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
+			int (*group_fn)(int cpu, const cpumask_t *cpu_map,
+					struct sched_group **sg,
+					cpumask_t *tmpmask),
+			cpumask_t *covered, cpumask_t *tmpmask)
+{
+	struct sched_group *first = NULL, *last = NULL;
+	int i;
+
+	cpus_clear(*covered);
+
+	for_each_cpu_mask_nr(i, *span) {
+		struct sched_group *sg;
+		int group = group_fn(i, cpu_map, &sg, tmpmask);
+		int j;
+
+		if (cpu_isset(i, *covered))
+			continue;
+
+		cpus_clear(sg->cpumask);
+		sg->__cpu_power = 0;
+
+		for_each_cpu_mask_nr(j, *span) {
+			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
+				continue;
+
+			cpu_set(j, *covered);
+			cpu_set(j, sg->cpumask);
+		}
+		if (!first)
+			first = sg;
+		if (last)
+			last->next = sg;
+		last = sg;
+	}
+	last->next = first;
+}
+
+#define SD_NODES_PER_DOMAIN 16
+
+#ifdef CONFIG_NUMA
+
+/**
+ * find_next_best_node - find the next node to include in a sched_domain
+ * @node: node whose sched_domain we're building
+ * @used_nodes: nodes already in the sched_domain
+ *
+ * Find the next node to include in a given scheduling domain. Simply
+ * finds the closest node not already in the @used_nodes map.
+ *
+ * Should use nodemask_t.
+ */
+static int find_next_best_node(int node, nodemask_t *used_nodes)
+{
+	int i, n, val, min_val, best_node = 0;
+
+	min_val = INT_MAX;
+
+	for (i = 0; i < nr_node_ids; i++) {
+		/* Start at @node */
+		n = (node + i) % nr_node_ids;
+
+		if (!nr_cpus_node(n))
+			continue;
+
+		/* Skip already used nodes */
+		if (node_isset(n, *used_nodes))
+			continue;
+
+		/* Simple min distance search */
+		val = node_distance(node, n);
+
+		if (val < min_val) {
+			min_val = val;
+			best_node = n;
+		}
+	}
+
+	node_set(best_node, *used_nodes);
+	return best_node;
+}
+
+/**
+ * sched_domain_node_span - get a cpumask for a node's sched_domain
+ * @node: node whose cpumask we're constructing
+ * @span: resulting cpumask
+ *
+ * Given a node, construct a good cpumask for its sched_domain to span. It
+ * should be one that prevents unnecessary balancing, but also spreads tasks
+ * out optimally.
+ */
+static void sched_domain_node_span(int node, cpumask_t *span)
+{
+	nodemask_t used_nodes;
+	node_to_cpumask_ptr(nodemask, node);
+	int i;
+
+	cpus_clear(*span);
+	nodes_clear(used_nodes);
+
+	cpus_or(*span, *span, *nodemask);
+	node_set(node, used_nodes);
+
+	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
+		int next_node = find_next_best_node(node, &used_nodes);
+
+		node_to_cpumask_ptr_next(nodemask, next_node);
+		cpus_or(*span, *span, *nodemask);
+	}
+}
+#endif /* CONFIG_NUMA */
+
+int sched_smt_power_savings = 0, sched_mc_power_savings = 0;
+
+/*
+ * SMT sched-domains:
+ */
+#ifdef CONFIG_SCHED_SMT
+static DEFINE_PER_CPU(struct sched_domain, cpu_domains);
+static DEFINE_PER_CPU(struct sched_group, sched_group_cpus);
+
+static int
+cpu_to_cpu_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		 cpumask_t *unused)
+{
+	if (sg)
+		*sg = &per_cpu(sched_group_cpus, cpu);
+	return cpu;
+}
+#endif /* CONFIG_SCHED_SMT */
+
+/*
+ * multi-core sched-domains:
+ */
+#ifdef CONFIG_SCHED_MC
+static DEFINE_PER_CPU(struct sched_domain, core_domains);
+static DEFINE_PER_CPU(struct sched_group, sched_group_core);
+#endif /* CONFIG_SCHED_MC */
+
+#if defined(CONFIG_SCHED_MC) && defined(CONFIG_SCHED_SMT)
+static int
+cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		  cpumask_t *mask)
+{
+	int group;
+
+	*mask = per_cpu(cpu_sibling_map, cpu);
+	cpus_and(*mask, *mask, *cpu_map);
+	group = first_cpu(*mask);
+	if (sg)
+		*sg = &per_cpu(sched_group_core, group);
+	return group;
+}
+#elif defined(CONFIG_SCHED_MC)
+static int
+cpu_to_core_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		  cpumask_t *unused)
+{
+	if (sg)
+		*sg = &per_cpu(sched_group_core, cpu);
+	return cpu;
+}
+#endif
+
+static DEFINE_PER_CPU(struct sched_domain, phys_domains);
+static DEFINE_PER_CPU(struct sched_group, sched_group_phys);
+
+static int
+cpu_to_phys_group(int cpu, const cpumask_t *cpu_map, struct sched_group **sg,
+		  cpumask_t *mask)
+{
+	int group;
+#ifdef CONFIG_SCHED_MC
+	*mask = cpu_coregroup_map(cpu);
+	cpus_and(*mask, *mask, *cpu_map);
+	group = first_cpu(*mask);
+#elif defined(CONFIG_SCHED_SMT)
+	*mask = per_cpu(cpu_sibling_map, cpu);
+	cpus_and(*mask, *mask, *cpu_map);
+	group = first_cpu(*mask);
+#else
+	group = cpu;
+#endif
+	if (sg)
+		*sg = &per_cpu(sched_group_phys, group);
+	return group;
+}
+
+#ifdef CONFIG_NUMA
+/*
+ * The init_sched_build_groups can't handle what we want to do with node
+ * groups, so roll our own. Now each node has its own list of groups which
+ * gets dynamically allocated.
+ */
+static DEFINE_PER_CPU(struct sched_domain, node_domains);
+static struct sched_group ***sched_group_nodes_bycpu;
+
+static DEFINE_PER_CPU(struct sched_domain, allnodes_domains);
+static DEFINE_PER_CPU(struct sched_group, sched_group_allnodes);
+
+static int cpu_to_allnodes_group(int cpu, const cpumask_t *cpu_map,
+				 struct sched_group **sg, cpumask_t *nodemask)
+{
+	int group;
+
+	*nodemask = node_to_cpumask(cpu_to_node(cpu));
+	cpus_and(*nodemask, *nodemask, *cpu_map);
+	group = first_cpu(*nodemask);
+
+	if (sg)
+		*sg = &per_cpu(sched_group_allnodes, group);
+	return group;
+}
+
+static void init_numa_sched_groups_power(struct sched_group *group_head)
+{
+	struct sched_group *sg = group_head;
+	int j;
+
+	if (!sg)
+		return;
+	do {
+		for_each_cpu_mask_nr(j, sg->cpumask) {
+			struct sched_domain *sd;
+
+			sd = &per_cpu(phys_domains, j);
+			if (j != first_cpu(sd->groups->cpumask)) {
+				/*
+				 * Only add "power" once for each
+				 * physical package.
+				 */
+				continue;
+			}
+
+			sg_inc_cpu_power(sg, sd->groups->__cpu_power);
+		}
+		sg = sg->next;
+	} while (sg != group_head);
+}
+#endif /* CONFIG_NUMA */
+
+#ifdef CONFIG_NUMA
+/* Free memory allocated for various sched_group structures */
+static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+{
+	int cpu, i;
+
+	for_each_cpu_mask_nr(cpu, *cpu_map) {
+		struct sched_group **sched_group_nodes
+			= sched_group_nodes_bycpu[cpu];
+
+		if (!sched_group_nodes)
+			continue;
+
+		for (i = 0; i < nr_node_ids; i++) {
+			struct sched_group *oldsg, *sg = sched_group_nodes[i];
+
+			*nodemask = node_to_cpumask(i);
+			cpus_and(*nodemask, *nodemask, *cpu_map);
+			if (cpus_empty(*nodemask))
+				continue;
+
+			if (sg == NULL)
+				continue;
+			sg = sg->next;
+next_sg:
+			oldsg = sg;
+			sg = sg->next;
+			kfree(oldsg);
+			if (oldsg != sched_group_nodes[i])
+				goto next_sg;
+		}
+		kfree(sched_group_nodes);
+		sched_group_nodes_bycpu[cpu] = NULL;
+	}
+}
+#else /* !CONFIG_NUMA */
+static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
+{
+}
+#endif /* CONFIG_NUMA */
+
+/*
+ * Initialise sched groups cpu_power.
+ *
+ * cpu_power indicates the capacity of sched group, which is used while
+ * distributing the load between different sched groups in a sched domain.
+ * Typically cpu_power for all the groups in a sched domain will be same unless
+ * there are asymmetries in the topology. If there are asymmetries, group
+ * having more cpu_power will pickup more load compared to the group having
+ * less cpu_power.
+ *
+ * cpu_power will be a multiple of SCHED_LOAD_SCALE. This multiple represents
+ * the maximum number of tasks a group can handle in the presence of other idle
+ * or lightly loaded groups in the same sched domain.
+ */
+static void init_sched_groups_power(int cpu, struct sched_domain *sd)
+{
+	struct sched_domain *child;
+	struct sched_group *group;
+
+	WARN_ON(!sd || !sd->groups);
+
+	if (cpu != first_cpu(sd->groups->cpumask))
+		return;
+
+	child = sd->child;
+
+	sd->groups->__cpu_power = 0;
+
+	/*
+	 * For perf policy, if the groups in child domain share resources
+	 * (for example cores sharing some portions of the cache hierarchy
+	 * or SMT), then set this domain groups cpu_power such that each group
+	 * can handle only one task, when there are other idle groups in the
+	 * same sched domain.
+	 */
+	if (!child || (!(sd->flags & SD_POWERSAVINGS_BALANCE) &&
+		       (child->flags &
+			(SD_SHARE_CPUPOWER | SD_SHARE_PKG_RESOURCES)))) {
+		sg_inc_cpu_power(sd->groups, SCHED_LOAD_SCALE);
+		return;
+	}
+
+	/*
+	 * add cpu_power of each child group to this groups cpu_power
+	 */
+	group = child->groups;
+	do {
+		sg_inc_cpu_power(sd->groups, group->__cpu_power);
+		group = group->next;
+	} while (group != child->groups);
+}
+
+/*
+ * Initialisers for schedule domains
+ * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
+ */
+
+#define	SD_INIT(sd, type)	sd_init_##type(sd)
+#define SD_INIT_FUNC(type)	\
+static noinline void sd_init_##type(struct sched_domain *sd)	\
+{								\
+	memset(sd, 0, sizeof(*sd));				\
+	*sd = SD_##type##_INIT;					\
+	sd->level = SD_LV_##type;				\
+}
+
+SD_INIT_FUNC(CPU)
+#ifdef CONFIG_NUMA
+ SD_INIT_FUNC(ALLNODES)
+ SD_INIT_FUNC(NODE)
+#endif
+#ifdef CONFIG_SCHED_SMT
+ SD_INIT_FUNC(SIBLING)
+#endif
+#ifdef CONFIG_SCHED_MC
+ SD_INIT_FUNC(MC)
+#endif
+
+/*
+ * To minimize stack usage kmalloc room for cpumasks and share the
+ * space as the usage in build_sched_domains() dictates.  Used only
+ * if the amount of space is significant.
+ */
+struct allmasks {
+	cpumask_t tmpmask;			/* make this one first */
+	union {
+		cpumask_t nodemask;
+		cpumask_t this_sibling_map;
+		cpumask_t this_core_map;
+	};
+	cpumask_t send_covered;
+
+#ifdef CONFIG_NUMA
+	cpumask_t domainspan;
+	cpumask_t covered;
+	cpumask_t notcovered;
+#endif
+};
+
+#if	NR_CPUS > 128
+#define	SCHED_CPUMASK_ALLOC		1
+#define	SCHED_CPUMASK_FREE(v)		kfree(v)
+#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks *v
+#else
+#define	SCHED_CPUMASK_ALLOC		0
+#define	SCHED_CPUMASK_FREE(v)
+#define	SCHED_CPUMASK_DECLARE(v)	struct allmasks _v, *v = &_v
+#endif
+
+#define	SCHED_CPUMASK_VAR(v, a) 	cpumask_t *v = (cpumask_t *) \
+			((unsigned long)(a) + offsetof(struct allmasks, v))
+
+static int default_relax_domain_level = -1;
+
+static int __init setup_relax_domain_level(char *str)
+{
+	unsigned long val;
+
+	val = simple_strtoul(str, NULL, 0);
+	if (val < SD_LV_MAX)
+		default_relax_domain_level = val;
+
+	return 1;
+}
+__setup("relax_domain_level=", setup_relax_domain_level);
+
+static void set_domain_attribute(struct sched_domain *sd,
+				 struct sched_domain_attr *attr)
+{
+	int request;
+
+	if (!attr || attr->relax_domain_level < 0) {
+		if (default_relax_domain_level < 0)
+			return;
+		else
+			request = default_relax_domain_level;
+	} else
+		request = attr->relax_domain_level;
+	if (request < sd->level) {
+		/* turn off idle balance on this domain */
+		sd->flags &= ~(SD_WAKE_IDLE|SD_BALANCE_NEWIDLE);
+	} else {
+		/* turn on idle balance on this domain */
+		sd->flags |= (SD_WAKE_IDLE_FAR|SD_BALANCE_NEWIDLE);
+	}
+}
+
+/*
+ * Build sched domains for a given set of cpus and attach the sched domains
+ * to the individual cpus
+ */
+static int __build_sched_domains(const cpumask_t *cpu_map,
+				 struct sched_domain_attr *attr)
+{
+	int i;
+	struct root_domain *rd;
+	SCHED_CPUMASK_DECLARE(allmasks);
+	cpumask_t *tmpmask;
+#ifdef CONFIG_NUMA
+	struct sched_group **sched_group_nodes = NULL;
+	int sd_allnodes = 0;
+
+	/*
+	 * Allocate the per-node list of sched groups
+	 */
+	sched_group_nodes = kcalloc(nr_node_ids, sizeof(struct sched_group *),
+				    GFP_KERNEL);
+	if (!sched_group_nodes) {
+		printk(KERN_WARNING "Can not alloc sched group node list\n");
+		return -ENOMEM;
+	}
+#endif
+
+	rd = alloc_rootdomain();
+	if (!rd) {
+		printk(KERN_WARNING "Cannot alloc root domain\n");
+#ifdef CONFIG_NUMA
+		kfree(sched_group_nodes);
+#endif
+		return -ENOMEM;
+	}
+
+#if SCHED_CPUMASK_ALLOC
+	/* get space for all scratch cpumask variables */
+	allmasks = kmalloc(sizeof(*allmasks), GFP_KERNEL);
+	if (!allmasks) {
+		printk(KERN_WARNING "Cannot alloc cpumask array\n");
+		kfree(rd);
+#ifdef CONFIG_NUMA
+		kfree(sched_group_nodes);
+#endif
+		return -ENOMEM;
+	}
+#endif
+	tmpmask = (cpumask_t *)allmasks;
+
+
+#ifdef CONFIG_NUMA
+	sched_group_nodes_bycpu[first_cpu(*cpu_map)] = sched_group_nodes;
+#endif
+
+	/*
+	 * Set up domains for cpus specified by the cpu_map.
+	 */
+	for_each_cpu_mask_nr(i, *cpu_map) {
+		struct sched_domain *sd = NULL, *p;
+		SCHED_CPUMASK_VAR(nodemask, allmasks);
+
+		*nodemask = node_to_cpumask(cpu_to_node(i));
+		cpus_and(*nodemask, *nodemask, *cpu_map);
+
+#ifdef CONFIG_NUMA
+		if (cpus_weight(*cpu_map) >
+				SD_NODES_PER_DOMAIN*cpus_weight(*nodemask)) {
+			sd = &per_cpu(allnodes_domains, i);
+			SD_INIT(sd, ALLNODES);
+			set_domain_attribute(sd, attr);
+			sd->span = *cpu_map;
+			cpu_to_allnodes_group(i, cpu_map, &sd->groups, tmpmask);
+			p = sd;
+			sd_allnodes = 1;
+		} else
+			p = NULL;
+
+		sd = &per_cpu(node_domains, i);
+		SD_INIT(sd, NODE);
+		set_domain_attribute(sd, attr);
+		sched_domain_node_span(cpu_to_node(i), &sd->span);
+		sd->parent = p;
+		if (p)
+			p->child = sd;
+		cpus_and(sd->span, sd->span, *cpu_map);
+#endif
+
+		p = sd;
+		sd = &per_cpu(phys_domains, i);
+		SD_INIT(sd, CPU);
+		set_domain_attribute(sd, attr);
+		sd->span = *nodemask;
+		sd->parent = p;
+		if (p)
+			p->child = sd;
+		cpu_to_phys_group(i, cpu_map, &sd->groups, tmpmask);
+
+#ifdef CONFIG_SCHED_MC
+		p = sd;
+		sd = &per_cpu(core_domains, i);
+		SD_INIT(sd, MC);
+		set_domain_attribute(sd, attr);
+		sd->span = cpu_coregroup_map(i);
+		cpus_and(sd->span, sd->span, *cpu_map);
+		sd->parent = p;
+		p->child = sd;
+		cpu_to_core_group(i, cpu_map, &sd->groups, tmpmask);
+#endif
+
+#ifdef CONFIG_SCHED_SMT
+		p = sd;
+		sd = &per_cpu(cpu_domains, i);
+		SD_INIT(sd, SIBLING);
+		set_domain_attribute(sd, attr);
+		sd->span = per_cpu(cpu_sibling_map, i);
+		cpus_and(sd->span, sd->span, *cpu_map);
+		sd->parent = p;
+		p->child = sd;
+		cpu_to_cpu_group(i, cpu_map, &sd->groups, tmpmask);
+#endif
+	}
+
+#ifdef CONFIG_SCHED_SMT
+	/* Set up CPU (sibling) groups */
+	for_each_cpu_mask_nr(i, *cpu_map) {
+		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
+
+		*this_sibling_map = per_cpu(cpu_sibling_map, i);
+		cpus_and(*this_sibling_map, *this_sibling_map, *cpu_map);
+		if (i != first_cpu(*this_sibling_map))
+			continue;
+
+		init_sched_build_groups(this_sibling_map, cpu_map,
+					&cpu_to_cpu_group,
+					send_covered, tmpmask);
+	}
+#endif
+
+#ifdef CONFIG_SCHED_MC
+	/* Set up multi-core groups */
+	for_each_cpu_mask_nr(i, *cpu_map) {
+		SCHED_CPUMASK_VAR(this_core_map, allmasks);
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
+
+		*this_core_map = cpu_coregroup_map(i);
+		cpus_and(*this_core_map, *this_core_map, *cpu_map);
+		if (i != first_cpu(*this_core_map))
+			continue;
+
+		init_sched_build_groups(this_core_map, cpu_map,
+					&cpu_to_core_group,
+					send_covered, tmpmask);
+	}
+#endif
+
+	/* Set up physical groups */
+	for (i = 0; i < nr_node_ids; i++) {
+		SCHED_CPUMASK_VAR(nodemask, allmasks);
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
+
+		*nodemask = node_to_cpumask(i);
+		cpus_and(*nodemask, *nodemask, *cpu_map);
+		if (cpus_empty(*nodemask))
+			continue;
+
+		init_sched_build_groups(nodemask, cpu_map,
+					&cpu_to_phys_group,
+					send_covered, tmpmask);
+	}
+
+#ifdef CONFIG_NUMA
+	/* Set up node groups */
+	if (sd_allnodes) {
+		SCHED_CPUMASK_VAR(send_covered, allmasks);
+
+		init_sched_build_groups(cpu_map, cpu_map,
+					&cpu_to_allnodes_group,
+					send_covered, tmpmask);
+	}
+
+	for (i = 0; i < nr_node_ids; i++) {
+		/* Set up node groups */
+		struct sched_group *sg, *prev;
+		SCHED_CPUMASK_VAR(nodemask, allmasks);
+		SCHED_CPUMASK_VAR(domainspan, allmasks);
+		SCHED_CPUMASK_VAR(covered, allmasks);
+		int j;
+
+		*nodemask = node_to_cpumask(i);
+		cpus_clear(*covered);
+
+		cpus_and(*nodemask, *nodemask, *cpu_map);
+		if (cpus_empty(*nodemask)) {
+			sched_group_nodes[i] = NULL;
+			continue;
+		}
+
+		sched_domain_node_span(i, domainspan);
+		cpus_and(*domainspan, *domainspan, *cpu_map);
+
+		sg = kmalloc_node(sizeof(struct sched_group), GFP_KERNEL, i);
+		if (!sg) {
+			printk(KERN_WARNING "Can not alloc domain group for "
+				"node %d\n", i);
+			goto error;
+		}
+		sched_group_nodes[i] = sg;
+		for_each_cpu_mask_nr(j, *nodemask) {
+			struct sched_domain *sd;
+
+			sd = &per_cpu(node_domains, j);
+			sd->groups = sg;
+		}
+		sg->__cpu_power = 0;
+		sg->cpumask = *nodemask;
+		sg->next = sg;
+		cpus_or(*covered, *covered, *nodemask);
+		prev = sg;
+
+		for (j = 0; j < nr_node_ids; j++) {
+			SCHED_CPUMASK_VAR(notcovered, allmasks);
+			int n = (i + j) % nr_node_ids;
+			node_to_cpumask_ptr(pnodemask, n);
+
+			cpus_complement(*notcovered, *covered);
+			cpus_and(*tmpmask, *notcovered, *cpu_map);
+			cpus_and(*tmpmask, *tmpmask, *domainspan);
+			if (cpus_empty(*tmpmask))
+				break;
+
+			cpus_and(*tmpmask, *tmpmask, *pnodemask);
+			if (cpus_empty(*tmpmask))
+				continue;
+
+			sg = kmalloc_node(sizeof(struct sched_group),
+					  GFP_KERNEL, i);
+			if (!sg) {
+				printk(KERN_WARNING
+				"Can not alloc domain group for node %d\n", j);
+				goto error;
+			}
+			sg->__cpu_power = 0;
+			sg->cpumask = *tmpmask;
+			sg->next = prev->next;
+			cpus_or(*covered, *covered, *tmpmask);
+			prev->next = sg;
+			prev = sg;
+		}
+	}
+#endif
+
+	/* Calculate CPU power for physical packages and nodes */
+#ifdef CONFIG_SCHED_SMT
+	for_each_cpu_mask_nr(i, *cpu_map) {
+		struct sched_domain *sd = &per_cpu(cpu_domains, i);
+
+		init_sched_groups_power(i, sd);
+	}
+#endif
+#ifdef CONFIG_SCHED_MC
+	for_each_cpu_mask_nr(i, *cpu_map) {
+		struct sched_domain *sd = &per_cpu(core_domains, i);
+
+		init_sched_groups_power(i, sd);
+	}
+#endif
+
+	for_each_cpu_mask_nr(i, *cpu_map) {
+		struct sched_domain *sd = &per_cpu(phys_domains, i);
+
+		init_sched_groups_power(i, sd);
+	}
+
+#ifdef CONFIG_NUMA
+	for (i = 0; i < nr_node_ids; i++)
+		init_numa_sched_groups_power(sched_group_nodes[i]);
+
+	if (sd_allnodes) {
+		struct sched_group *sg;
+
+		cpu_to_allnodes_group(first_cpu(*cpu_map), cpu_map, &sg,
+								tmpmask);
+		init_numa_sched_groups_power(sg);
+	}
+#endif
+
+	/* Attach the domains */
+	for_each_cpu_mask_nr(i, *cpu_map) {
+		struct sched_domain *sd;
+#ifdef CONFIG_SCHED_SMT
+		sd = &per_cpu(cpu_domains, i);
+#elif defined(CONFIG_SCHED_MC)
+		sd = &per_cpu(core_domains, i);
+#else
+		sd = &per_cpu(phys_domains, i);
+#endif
+		cpu_attach_domain(sd, rd, i);
+	}
+
+	SCHED_CPUMASK_FREE((void *)allmasks);
+	return 0;
+
+#ifdef CONFIG_NUMA
+error:
+	free_sched_groups(cpu_map, tmpmask);
+	SCHED_CPUMASK_FREE((void *)allmasks);
+	return -ENOMEM;
+#endif
+}
+
+static int build_sched_domains(const cpumask_t *cpu_map)
+{
+	return __build_sched_domains(cpu_map, NULL);
+}
+
+static cpumask_t *doms_cur;	/* current sched domains */
+static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
+static struct sched_domain_attr *dattr_cur;
+				/* attribues of custom domains in 'doms_cur' */
+
+/*
+ * Special case: If a kmalloc of a doms_cur partition (array of
+ * cpumask_t) fails, then fallback to a single sched domain,
+ * as determined by the single cpumask_t fallback_doms.
+ */
+static cpumask_t fallback_doms;
+
+void __attribute__((weak)) arch_update_cpu_topology(void)
+{
+}
+
+/*
+ * Set up scheduler domains and groups. Callers must hold the hotplug lock.
+ * For now this just excludes isolated cpus, but could be used to
+ * exclude other special cases in the future.
+ */
+static int arch_init_sched_domains(const cpumask_t *cpu_map)
+{
+	int err;
+
+	arch_update_cpu_topology();
+	ndoms_cur = 1;
+	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (!doms_cur)
+		doms_cur = &fallback_doms;
+	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
+	dattr_cur = NULL;
+	err = build_sched_domains(doms_cur);
+	register_sched_domain_sysctl();
+
+	return err;
+}
+
+static void arch_destroy_sched_domains(const cpumask_t *cpu_map,
+				       cpumask_t *tmpmask)
+{
+	free_sched_groups(cpu_map, tmpmask);
+}
+
+/*
+ * Detach sched domains from a group of cpus specified in cpu_map
+ * These cpus will now be attached to the NULL domain
+ */
+static void detach_destroy_domains(const cpumask_t *cpu_map)
+{
+	cpumask_t tmpmask;
+	int i;
+
+	unregister_sched_domain_sysctl();
+
+	for_each_cpu_mask_nr(i, *cpu_map)
+		cpu_attach_domain(NULL, &def_root_domain, i);
+	synchronize_sched();
+	arch_destroy_sched_domains(cpu_map, &tmpmask);
+}
+
+/* handle null as "default" */
+static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
+			struct sched_domain_attr *new, int idx_new)
+{
+	struct sched_domain_attr tmp;
+
+	/* fast path */
+	if (!new && !cur)
+		return 1;
+
+	tmp = SD_ATTR_INIT;
+	return !memcmp(cur ? (cur + idx_cur) : &tmp,
+			new ? (new + idx_new) : &tmp,
+			sizeof(struct sched_domain_attr));
+}
+
+/*
+ * Partition sched domains as specified by the 'ndoms_new'
+ * cpumasks in the array doms_new[] of cpumasks. This compares
+ * doms_new[] to the current sched domain partitioning, doms_cur[].
+ * It destroys each deleted domain and builds each new domain.
+ *
+ * 'doms_new' is an array of cpumask_t's of length 'ndoms_new'.
+ * The masks don't intersect (don't overlap.) We should setup one
+ * sched domain for each mask. CPUs not in any of the cpumasks will
+ * not be load balanced. If the same cpumask appears both in the
+ * current 'doms_cur' domains and in the new 'doms_new', we can leave
+ * it as it is.
+ *
+ * The passed in 'doms_new' should be kmalloc'd. This routine takes
+ * ownership of it and will kfree it when done with it. If the caller
+ * failed the kmalloc call, then it can pass in doms_new == NULL,
+ * and partition_sched_domains() will fallback to the single partition
+ * 'fallback_doms', it also forces the domains to be rebuilt.
+ *
+ * If doms_new==NULL it will be replaced with cpu_online_map.
+ * ndoms_new==0 is a special case for destroying existing domains.
+ * It will not create the default domain.
+ *
+ * Call with hotplug lock held
+ */
+void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
+			     struct sched_domain_attr *dattr_new)
+{
+	int i, j, n;
+
+	mutex_lock(&sched_domains_mutex);
+
+	/* always unregister in case we don't destroy any domains */
+	unregister_sched_domain_sysctl();
+
+	n = doms_new ? ndoms_new : 0;
+
+	/* Destroy deleted domains */
+	for (i = 0; i < ndoms_cur; i++) {
+		for (j = 0; j < n; j++) {
+			if (cpus_equal(doms_cur[i], doms_new[j])
+			    && dattrs_equal(dattr_cur, i, dattr_new, j))
+				goto match1;
+		}
+		/* no match - a current sched domain not in new doms_new[] */
+		detach_destroy_domains(doms_cur + i);
+match1:
+		;
+	}
+
+	if (doms_new == NULL) {
+		ndoms_cur = 0;
+		doms_new = &fallback_doms;
+		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+		dattr_new = NULL;
+	}
+
+	/* Build new domains */
+	for (i = 0; i < ndoms_new; i++) {
+		for (j = 0; j < ndoms_cur; j++) {
+			if (cpus_equal(doms_new[i], doms_cur[j])
+			    && dattrs_equal(dattr_new, i, dattr_cur, j))
+				goto match2;
+		}
+		/* no match - add a new doms_new */
+		__build_sched_domains(doms_new + i,
+					dattr_new ? dattr_new + i : NULL);
+match2:
+		;
+	}
+
+	/* Remember the new sched domains */
+	if (doms_cur != &fallback_doms)
+		kfree(doms_cur);
+	kfree(dattr_cur);	/* kfree(NULL) is safe */
+	doms_cur = doms_new;
+	dattr_cur = dattr_new;
+	ndoms_cur = ndoms_new;
+
+	register_sched_domain_sysctl();
+
+	mutex_unlock(&sched_domains_mutex);
+}
+
+#if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
+int arch_reinit_sched_domains(void)
+{
+	get_online_cpus();
+
+	/* Destroy domains first to force the rebuild */
+	partition_sched_domains(0, NULL, NULL);
+
+	rebuild_sched_domains();
+	put_online_cpus();
+
+	return 0;
+}
+
+static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
+{
+	int ret;
+
+	if (buf[0] != '0' && buf[0] != '1')
+		return -EINVAL;
+
+	if (smt)
+		sched_smt_power_savings = (buf[0] == '1');
+	else
+		sched_mc_power_savings = (buf[0] == '1');
+
+	ret = arch_reinit_sched_domains();
+
+	return ret ? ret : count;
+}
+
+#ifdef CONFIG_SCHED_MC
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
+					   char *page)
+{
+	return sprintf(page, "%u\n", sched_mc_power_savings);
+}
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
+					    const char *buf, size_t count)
+{
+	return sched_power_savings_store(buf, count, 0);
+}
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
+			 sched_mc_power_savings_show,
+			 sched_mc_power_savings_store);
+#endif
+
+#ifdef CONFIG_SCHED_SMT
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
+					    char *page)
+{
+	return sprintf(page, "%u\n", sched_smt_power_savings);
+}
+static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
+					     const char *buf, size_t count)
+{
+	return sched_power_savings_store(buf, count, 1);
+}
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
+		   sched_smt_power_savings_show,
+		   sched_smt_power_savings_store);
+#endif
+
+int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
+{
+	int err = 0;
+
+#ifdef CONFIG_SCHED_SMT
+	if (smt_capable())
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_smt_power_savings.attr);
+#endif
+#ifdef CONFIG_SCHED_MC
+	if (!err && mc_capable())
+		err = sysfs_create_file(&cls->kset.kobj,
+					&attr_sched_mc_power_savings.attr);
+#endif
+	return err;
+}
+#endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
+
+#ifndef CONFIG_CPUSETS
+/*
+ * Add online and remove offline CPUs from the scheduler domains.
+ * When cpusets are enabled they take over this function.
+ */
+static int update_sched_domains(struct notifier_block *nfb,
+				unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+		partition_sched_domains(1, NULL, NULL);
+		return NOTIFY_OK;
+
+	default:
+		return NOTIFY_DONE;
+	}
+}
+#endif
+
+static int update_runtime(struct notifier_block *nfb,
+				unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case CPU_DOWN_PREPARE:
+	case CPU_DOWN_PREPARE_FROZEN:
+		return NOTIFY_OK;
+
+	case CPU_DOWN_FAILED:
+	case CPU_DOWN_FAILED_FROZEN:
+	case CPU_ONLINE:
+	case CPU_ONLINE_FROZEN:
+		return NOTIFY_OK;
+
+	default:
+		return NOTIFY_DONE;
+	}
+}
+
+void __init sched_init_smp(void)
+{
+	struct sched_domain *sd;
+	int cpu;
+
+	cpumask_t non_isolated_cpus;
+
+#if defined(CONFIG_NUMA)
+	sched_group_nodes_bycpu = kzalloc(nr_cpu_ids * sizeof(void **),
+								GFP_KERNEL);
+	BUG_ON(sched_group_nodes_bycpu == NULL);
+#endif
+	get_online_cpus();
+	mutex_lock(&sched_domains_mutex);
+	arch_init_sched_domains(&cpu_online_map);
+	cpus_andnot(non_isolated_cpus, cpu_possible_map, cpu_isolated_map);
+	if (cpus_empty(non_isolated_cpus))
+		cpu_set(smp_processor_id(), non_isolated_cpus);
+	mutex_unlock(&sched_domains_mutex);
+	put_online_cpus();
+
+#ifndef CONFIG_CPUSETS
+	/* XXX: Theoretical race here - CPU may be hotplugged now */
+	hotcpu_notifier(update_sched_domains, 0);
+#endif
+
+	/* RT runtime code needs to handle some hotplug events */
+	hotcpu_notifier(update_runtime, 0);
+
+	/* Move init over to a non-isolated CPU */
+	if (set_cpus_allowed_ptr(current, &non_isolated_cpus) < 0)
+		BUG();
+
+	/*
+	 * Assume that every added cpu gives us slightly less overall latency
+	 * allowing us to increase the base rr_interval, but in a non linear
+	 * fashion.
+	 */
+	rr_interval *= 1 + ilog2(num_online_cpus());
+
+	/*
+	 * Set up the relative cache distance of each online cpu from each
+	 * other in a simple array for quick lookup. Locality is determined
+	 * by the closest sched_domain that CPUs are separated by. CPUs with
+	 * shared cache in SMT and MC are treated as local. Separate CPUs
+	 * (within the same package or physically) within the same node are
+	 * treated as not local. CPUs not even in the same domain (different
+	 * nodes) are treated as very distant.
+	 */
+	for_each_online_cpu(cpu) {
+		for_each_domain(cpu, sd) {
+			struct rq *rq = cpu_rq(cpu);
+			unsigned long locality;
+			int other_cpu;
+
+			if (sd->level <= SD_LV_MC)
+				locality = 0;
+			else if (sd->level <= SD_LV_NODE)
+				locality = 1;
+			else
+				continue;
+
+			for_each_cpu_mask_nr(other_cpu, sd->span) {
+				if (locality < rq->cpu_locality[other_cpu])
+					rq->cpu_locality[other_cpu] = locality;
+			}
+		}
+	}
+}
+#else
+void __init sched_init_smp(void)
+{
+}
+#endif /* CONFIG_SMP */
+
+int in_sched_functions(unsigned long addr)
+{
+	return in_lock_functions(addr) ||
+		(addr >= (unsigned long)__sched_text_start
+		&& addr < (unsigned long)__sched_text_end);
+}
+
+void __init sched_init(void)
+{
+	int i;
+	int highest_cpu = 0;
+
+	prio_ratios[0] = 100;
+	for (i = 1 ; i < PRIO_RANGE ; i++)
+		prio_ratios[i] = prio_ratios[i - 1] * 11 / 10;
+
+	spin_lock_init(&grq.lock);
+#ifdef CONFIG_SMP
+	init_defrootdomain();
+	cpus_clear(grq.cpu_idle_map);
+	grq.qnr = 0;
+#endif
+	for_each_possible_cpu(i) {
+		struct rq *rq;
+
+		rq = cpu_rq(i);
+		rq->rq_deadline = 0;
+		rq->rq_prio = 0;
+		rq->cpu = i;
+		rq->user_pc = rq->nice_pc = rq->softirq_pc = rq->system_pc =
+			      rq->iowait_pc = rq->idle_pc = 0;
+#ifdef CONFIG_SMP
+		rq->sd = NULL;
+		rq->rd = NULL;
+		rq->online = 0;
+		INIT_LIST_HEAD(&rq->migration_queue);
+		rq_attach_root(rq, &def_root_domain);
+#endif
+		atomic_set(&rq->nr_iowait, 0);
+		highest_cpu = i;
+	}
+	grq.iso_ticks = grq.nr_running = grq.nr_uninterruptible = 0;
+	for (i = 0; i < PRIO_LIMIT; i++)
+		INIT_LIST_HEAD(grq.queue + i);
+	bitmap_zero(grq.prio_bitmap, PRIO_LIMIT);
+	/* delimiter for bitsearch */
+	__set_bit(PRIO_LIMIT, grq.prio_bitmap);
+
+#ifdef CONFIG_SMP
+	nr_cpu_ids = highest_cpu + 1;
+	for_each_possible_cpu(i) {
+		struct rq *rq = cpu_rq(i);
+		int j;
+
+		rq->cpu_locality = kmalloc(nr_cpu_ids * sizeof(unsigned long), GFP_NOWAIT);
+		for_each_possible_cpu(j) {
+			if (i == j)
+				rq->cpu_locality[j] = 0;
+			else
+				rq->cpu_locality[j] = 4;
+		}
+	}
+#endif
+
+#ifdef CONFIG_PREEMPT_NOTIFIERS
+	INIT_HLIST_HEAD(&init_task.preempt_notifiers);
+#endif
+
+#ifdef CONFIG_RT_MUTEXES
+	plist_head_init(&init_task.pi_waiters, &init_task.pi_lock);
+#endif
+
+	/*
+	 * The boot idle thread does lazy MMU switching as well:
+	 */
+	atomic_inc(&init_mm.mm_count);
+	enter_lazy_tlb(&init_mm, current);
+
+	/*
+	 * Make us the idle thread. Technically, schedule() should not be
+	 * called from this thread, however somewhere below it might be,
+	 * but because we are the idle thread, we just pick up running again
+	 * when this runqueue becomes "idle".
+	 */
+	init_idle(current, smp_processor_id());
+}
+
+#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
+void __might_sleep(char *file, int line)
+{
+#ifdef in_atomic
+	static unsigned long prev_jiffy;	/* ratelimiting */
+
+	if ((in_atomic() || irqs_disabled()) &&
+	    system_state == SYSTEM_RUNNING && !oops_in_progress) {
+		if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
+			return;
+		prev_jiffy = jiffies;
+		printk(KERN_ERR "BUG: sleeping function called from invalid"
+				" context at %s:%d\n", file, line);
+		printk("in_atomic():%d, irqs_disabled():%d\n",
+			in_atomic(), irqs_disabled());
+		debug_show_held_locks(current);
+		if (irqs_disabled())
+			print_irqtrace_events(current);
+		dump_stack();
+	}
+#endif
+}
+EXPORT_SYMBOL(__might_sleep);
+#endif
+
+#ifdef CONFIG_MAGIC_SYSRQ
+void normalize_rt_tasks(void)
+{
+	struct task_struct *g, *p;
+	unsigned long flags;
+	struct rq *rq;
+	int queued;
+
+	read_lock_irq(&tasklist_lock);
+
+	do_each_thread(g, p) {
+		if (!rt_task(p) && !iso_task(p))
+			continue;
+
+		spin_lock_irqsave(&p->pi_lock, flags);
+		rq = __task_grq_lock(p);
+		update_rq_clock(rq);
+
+		queued = task_queued(p);
+		if (queued)
+			dequeue_task(p);
+		__setscheduler(p, rq, SCHED_NORMAL, 0);
+		if (queued) {
+			enqueue_task(p);
+			try_preempt(p, rq);
+		}
+
+		__task_grq_unlock();
+		spin_unlock_irqrestore(&p->pi_lock, flags);
+	} while_each_thread(g, p);
+
+	read_unlock_irq(&tasklist_lock);
+}
+#endif /* CONFIG_MAGIC_SYSRQ */
+
+#ifdef CONFIG_IA64
+/*
+ * These functions are only useful for the IA64 MCA handling.
+ *
+ * They can only be called when the whole system has been
+ * stopped - every CPU needs to be quiescent, and no scheduling
+ * activity can take place. Using them for anything else would
+ * be a serious bug, and as a result, they aren't even visible
+ * under any other configuration.
+ */
+
+/**
+ * curr_task - return the current task for a given cpu.
+ * @cpu: the processor in question.
+ *
+ * ONLY VALID WHEN THE WHOLE SYSTEM IS STOPPED!
+ */
+struct task_struct *curr_task(int cpu)
+{
+	return cpu_curr(cpu);
+}
+
+/**
+ * set_curr_task - set the current task for a given cpu.
+ * @cpu: the processor in question.
+ * @p: the task pointer to set.
+ *
+ * Description: This function must only be used when non-maskable interrupts
+ * are serviced on a separate stack.  It allows the architecture to switch the
+ * notion of the current task on a cpu in a non-blocking manner.  This function
+ * must be called with all CPU's synchronised, and interrupts disabled, the
+ * and caller must save the original value of the current task (see
+ * curr_task() above) and restore that value before reenabling interrupts and
+ * re-starting the system.
+ *
+ * ONLY VALID WHEN THE WHOLE SYSTEM IS STOPPED!
+ */
+void set_curr_task(int cpu, struct task_struct *p)
+{
+	cpu_curr(cpu) = p;
+}
+
+#endif
+
+/*
+ * Use precise platform statistics if available:
+ */
+#ifdef CONFIG_VIRT_CPU_ACCOUNTING
+cputime_t task_utime(struct task_struct *p)
+{
+	return p->utime;
+}
+
+cputime_t task_stime(struct task_struct *p)
+{
+	return p->stime;
+}
+#else
+cputime_t task_utime(struct task_struct *p)
+{
+	clock_t utime = cputime_to_clock_t(p->utime),
+		total = utime + cputime_to_clock_t(p->stime);
+	u64 temp;
+
+	temp = (u64)nsec_to_clock_t(p->sched_time);
+
+	if (total) {
+		temp *= utime;
+		do_div(temp, total);
+	}
+	utime = (clock_t)temp;
+
+	p->prev_utime = max(p->prev_utime, clock_t_to_cputime(utime));
+	return p->prev_utime;
+}
+
+cputime_t task_stime(struct task_struct *p)
+{
+	clock_t stime;
+
+	stime = nsec_to_clock_t(p->sched_time) -
+			cputime_to_clock_t(task_utime(p));
+
+	if (stime >= 0)
+		p->prev_stime = max(p->prev_stime, clock_t_to_cputime(stime));
+
+	return p->prev_stime;
+}
+#endif
+
+inline cputime_t task_gtime(struct task_struct *p)
+{
+	return p->gtime;
+}
+
+void __cpuinit init_idle_bootup_task(struct task_struct *idle)
+{}
+
+#ifdef CONFIG_SCHED_DEBUG
+void proc_sched_show_task(struct task_struct *p, struct seq_file *m)
+{}
+
+void proc_sched_set_task(struct task_struct *p)
+{}
+#endif
diff -udrNp linux-2.6.27.orig/kernel/sysctl.c linux-2.6.27/kernel/sysctl.c
--- linux-2.6.27.orig/kernel/sysctl.c	2009-10-02 15:15:59.932298507 -0500
+++ linux-2.6.27/kernel/sysctl.c	2009-10-02 15:16:43.252298238 -0500
@@ -83,15 +83,12 @@ extern int compat_log;
 extern int maps_protect;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
+extern int rr_interval;
+extern int sched_iso_cpu;
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
-/* Constants used for minimum and  maximum */
-#if defined(CONFIG_HIGHMEM) || defined(CONFIG_DETECT_SOFTLOCKUP)
-static int one = 1;
-#endif
-
 #ifdef CONFIG_DETECT_SOFTLOCKUP
 static int sixty = 60;
 static int neg_one = -1;
@@ -102,7 +99,9 @@ static int two = 2;
 #endif
 
 static int zero;
-static int one_hundred = 100;
+static int __read_mostly one = 1;
+static int __read_mostly one_hundred = 100;
+static int __read_mostly five_thousand = 5000;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
@@ -230,113 +229,7 @@ static struct ctl_table root_table[] = {
 	{ .ctl_name = 0 }
 };
 
-#ifdef CONFIG_SCHED_DEBUG
-static int min_sched_granularity_ns = 100000;		/* 100 usecs */
-static int max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
-static int min_wakeup_granularity_ns;			/* 0 usecs */
-static int max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
-#endif
-
 static struct ctl_table kern_table[] = {
-#ifdef CONFIG_SCHED_DEBUG
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_min_granularity_ns",
-		.data		= &sysctl_sched_min_granularity,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &min_sched_granularity_ns,
-		.extra2		= &max_sched_granularity_ns,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_latency_ns",
-		.data		= &sysctl_sched_latency,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &sched_nr_latency_handler,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &min_sched_granularity_ns,
-		.extra2		= &max_sched_granularity_ns,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_wakeup_granularity_ns",
-		.data		= &sysctl_sched_wakeup_granularity,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
-		.extra1		= &min_wakeup_granularity_ns,
-		.extra2		= &max_wakeup_granularity_ns,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_shares_ratelimit",
-		.data		= &sysctl_sched_shares_ratelimit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_child_runs_first",
-		.data		= &sysctl_sched_child_runs_first,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_features",
-		.data		= &sysctl_sched_features,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_migration_cost",
-		.data		= &sysctl_sched_migration_cost,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_nr_migrate",
-		.data		= &sysctl_sched_nr_migrate,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
-#endif
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_period_us",
-		.data		= &sysctl_sched_rt_period,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &sched_rt_handler,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_rt_runtime_us",
-		.data		= &sysctl_sched_rt_runtime,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &sched_rt_handler,
-	},
-	{
-		.ctl_name	= CTL_UNNUMBERED,
-		.procname	= "sched_compat_yield",
-		.data		= &sysctl_sched_compat_yield,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 #ifdef CONFIG_PROVE_LOCKING
 	{
 		.ctl_name	= CTL_UNNUMBERED,
@@ -713,6 +606,28 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "rr_interval",
+		.data		= &rr_interval,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &five_thousand,
+	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "iso_cpu",
+		.data		= &sched_iso_cpu,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one_hundred,
+	},
 #if defined(CONFIG_S390) && defined(CONFIG_SMP)
 	{
 		.ctl_name	= KERN_SPIN_RETRY,
diff -udrNp linux-2.6.27.orig/kernel/timer.c linux-2.6.27/kernel/timer.c
--- linux-2.6.27.orig/kernel/timer.c	2009-10-02 15:16:11.116298432 -0500
+++ linux-2.6.27/kernel/timer.c	2009-10-02 15:16:43.252298238 -0500
@@ -958,8 +958,7 @@ void update_process_times(int user_tick)
 	struct task_struct *p = current;
 	int cpu = smp_processor_id();
 
-	/* Note: this timer irq context must be accounted for as well. */
-	account_process_tick(p, user_tick);
+	/* Accounting is done within sched_bfs.c */
 	run_local_timers();
 	if (rcu_pending(cpu))
 		rcu_check_callbacks(cpu, user_tick);
diff -udrNp linux-2.6.27.orig/kernel/trace/trace.c linux-2.6.27/kernel/trace/trace.c
--- linux-2.6.27.orig/kernel/trace/trace.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/kernel/trace/trace.c	2009-10-02 15:16:43.253298167 -0500
@@ -160,10 +160,10 @@ static struct tracer no_tracer __read_mo
 void trace_wake_up(void)
 {
 	/*
-	 * The runqueue_is_locked() can fail, but this is the best we
+	 * The grunqueue_is_locked() can fail, but this is the best we
 	 * have for now:
 	 */
-	if (!(trace_flags & TRACE_ITER_BLOCK) && !runqueue_is_locked())
+	if (!(trace_flags & TRACE_ITER_BLOCK) && !grunqueue_is_locked())
 		wake_up(&trace_wait);
 }
 
diff -udrNp linux-2.6.27.orig/kernel/workqueue.c linux-2.6.27/kernel/workqueue.c
--- linux-2.6.27.orig/kernel/workqueue.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/kernel/workqueue.c	2009-10-02 15:16:43.253298167 -0500
@@ -322,8 +322,6 @@ static int worker_thread(void *__cwq)
 	if (cwq->wq->freezeable)
 		set_freezable();
 
-	set_user_nice(current, -5);
-
 	for (;;) {
 		prepare_to_wait(&cwq->more_work, &wait, TASK_INTERRUPTIBLE);
 		if (!freezing(current) &&
diff -udrNp linux-2.6.27.orig/Makefile linux-2.6.27/Makefile
--- linux-2.6.27.orig/Makefile	2009-10-02 15:15:59.499298312 -0500
+++ linux-2.6.27/Makefile	2009-10-02 15:16:43.390298196 -0500
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .35
+EXTRAVERSION = .35-bfs300
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff -udrNp linux-2.6.27.orig/mm/oom_kill.c linux-2.6.27/mm/oom_kill.c
--- linux-2.6.27.orig/mm/oom_kill.c	2008-10-09 17:13:53.000000000 -0500
+++ linux-2.6.27/mm/oom_kill.c	2009-10-02 15:16:43.390298196 -0500
@@ -333,7 +333,7 @@ static void __oom_kill_task(struct task_
 	 * all the memory it needs. That way it should be able to
 	 * exit() and clear out its resources quickly...
 	 */
-	p->rt.time_slice = HZ;
+	p->time_slice = HZ;
 	set_tsk_thread_flag(p, TIF_MEMDIE);
 
 	force_sig(SIGKILL, p);


--------------090708080309010601040509
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.27.35-bfs300
# Fri Oct  1 15:25:30 2009
#
CONFIG_64BIT=y
# CONFIG_X86_32 is not set
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
# CONFIG_GENERIC_LOCKBREAK is not set
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_FAST_CMPXCHG_LOCAL=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
# CONFIG_GENERIC_GPIO is not set
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_RWSEM_GENERIC_SPINLOCK=y
# CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
# CONFIG_ARCH_HAS_ILOG2_U32 is not set
# CONFIG_ARCH_HAS_ILOG2_U64 is not set
CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_ARCH_POPULATES_NODE_MAP=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_AOUT=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_X86_SMP=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_X86_BIOS_REBOOT=y
CONFIG_X86_TRAMPOLINE=y
# CONFIG_KTIME_SCALAR is not set
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_LOCK_KERNEL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_LOCALVERSION=""
# CONFIG_LOCALVERSION_AUTO is not set
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_BSD_PROCESS_ACCT=y
# CONFIG_BSD_PROCESS_ACCT_V3 is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y
CONFIG_AUDIT=y
CONFIG_AUDITSYSCALL=y
CONFIG_AUDIT_TREE=y
# CONFIG_IKCONFIG is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
CONFIG_CGROUP_NS=y
CONFIG_CGROUP_DEVICE=y
CONFIG_CPUSETS=y
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_SYSFS_DEPRECATED_V2 is not set
CONFIG_PROC_PID_CPUSET=y
CONFIG_RELAY=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_USER_NS=y
CONFIG_PID_NS=y
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
# CONFIG_EMBEDDED is not set
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_KALLSYMS_EXTRA_PASS=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_PCSPKR_PLATFORM=y
# CONFIG_COMPAT_BRK is not set
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_ANON_INODES=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_SLUB_DEBUG=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_MARKERS=y
CONFIG_OPROFILE=m
CONFIG_HAVE_OPROFILE=y
CONFIG_KPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
# CONFIG_HAVE_ARCH_TRACEHOOK is not set
# CONFIG_HAVE_DMA_ATTRS is not set
CONFIG_USE_GENERIC_SMP_HELPERS=y
# CONFIG_HAVE_CLK is not set
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_SLABINFO=y
CONFIG_RT_MUTEXES=y
# CONFIG_TINY_SHMEM is not set
CONFIG_BASE_SMALL=0
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_MODULE_SRCVERSION_ALL=y
CONFIG_KMOD=y
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_IO_TRACE=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_INTEGRITY=y
CONFIG_BLOCK_COMPAT=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
# CONFIG_DEFAULT_AS is not set
# CONFIG_DEFAULT_DEADLINE is not set
CONFIG_DEFAULT_CFQ=y
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="cfq"
CONFIG_PREEMPT_NOTIFIERS=y
CONFIG_CLASSIC_RCU=y

#
# Processor type and features
#
CONFIG_TICK_ONESHOT=y
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_SMP=y
CONFIG_X86_FIND_SMP_CONFIG=y
CONFIG_X86_MPPARSE=y
CONFIG_X86_PC=y
# CONFIG_X86_ELAN is not set
# CONFIG_X86_VOYAGER is not set
# CONFIG_X86_GENERICARCH is not set
# CONFIG_X86_VSMP is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_XEN=y
CONFIG_XEN_MAX_DOMAIN_MEMORY=32
CONFIG_XEN_SAVE_RESTORE=y
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
# CONFIG_MEMTEST is not set
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
# CONFIG_M686 is not set
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP2 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_CPU=y
CONFIG_X86_L1_CACHE_BYTES=128
CONFIG_X86_INTERNODE_CACHE_BYTES=128
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=7
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_GART_IOMMU=y
CONFIG_CALGARY_IOMMU=y
CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
CONFIG_AMD_IOMMU=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=64
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_MCE=y
CONFIG_X86_MCE_INTEL=y
CONFIG_X86_MCE_AMD=y
CONFIG_I8K=m
CONFIG_MICROCODE=m
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
CONFIG_NUMA=y
CONFIG_K8_NUMA=y
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
# CONFIG_NUMA_EMU is not set
CONFIG_NODES_SHIFT=9
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_SELECT_MEMORY_MODEL=y
# CONFIG_FLATMEM_MANUAL is not set
# CONFIG_DISCONTIGMEM_MANUAL is not set
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
# CONFIG_SPARSEMEM_STATIC is not set
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_VMEMMAP=y
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=4
CONFIG_MIGRATION=y
CONFIG_RESOURCES_64BIT=y
CONFIG_ZONE_DMA_FLAG=1
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_MMU_NOTIFIER=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
# CONFIG_X86_RESERVE_LOW_64K is not set
CONFIG_MTRR=y
CONFIG_MTRR_SANITIZER=y
CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
CONFIG_X86_PAT=y
CONFIG_EFI=y
CONFIG_SECCOMP=y
# CONFIG_HZ_100 is not set
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
CONFIG_HZ_1000=y
CONFIG_HZ=1000
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
CONFIG_RELOCATABLE=y
CONFIG_PHYSICAL_ALIGN=0x200000
CONFIG_HOTPLUG_CPU=y
# CONFIG_COMPAT_VDSO is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y

#
# Power management options
#
CONFIG_PM=y
CONFIG_PM_DEBUG=y
# CONFIG_PM_VERBOSE is not set
CONFIG_CAN_PM_TRACE=y
# CONFIG_PM_TRACE_RTC is not set
CONFIG_PM_SLEEP_SMP=y
CONFIG_PM_SLEEP=y
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_ACPI=y
CONFIG_ACPI_PROCFS=y
CONFIG_ACPI_PROCFS_POWER=y
CONFIG_ACPI_SYSFS_POWER=y
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=m
CONFIG_ACPI_BATTERY=m
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=m
CONFIG_ACPI_FAN=y
CONFIG_ACPI_DOCK=y
CONFIG_ACPI_BAY=m
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_HOTPLUG_CPU=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_WMI=m
# CONFIG_ACPI_ASUS is not set
CONFIG_ACPI_TOSHIBA=m
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_ACPI_EC=y
CONFIG_ACPI_PCI_SLOT=y
CONFIG_ACPI_POWER=y
CONFIG_ACPI_SYSTEM=y
CONFIG_X86_PM_TIMER=y
CONFIG_ACPI_CONTAINER=y
CONFIG_ACPI_SBS=m

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=m
CONFIG_CPU_FREQ_DEBUG=y
CONFIG_CPU_FREQ_STAT=m
CONFIG_CPU_FREQ_STAT_DETAILS=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
CONFIG_CPU_FREQ_GOV_POWERSAVE=m
CONFIG_CPU_FREQ_GOV_USERSPACE=y
CONFIG_CPU_FREQ_GOV_ONDEMAND=m
CONFIG_CPU_FREQ_GOV_CONSERVATIVE=m

#
# CPUFreq processor drivers
#
CONFIG_X86_ACPI_CPUFREQ=m
CONFIG_X86_POWERNOW_K8=m
CONFIG_X86_POWERNOW_K8_ACPI=y
# CONFIG_X86_SPEEDSTEP_CENTRINO is not set
CONFIG_X86_P4_CLOCKMOD=m

#
# shared options
#
# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
CONFIG_X86_SPEEDSTEP_LIB=m
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_DOMAINS=y
# CONFIG_DMAR is not set
CONFIG_PCIEPORTBUS=y
CONFIG_HOTPLUG_PCI_PCIE=m
CONFIG_PCIEAER=y
CONFIG_PCIEASPM=y
# CONFIG_PCIEASPM_DEBUG is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_LEGACY=y
# CONFIG_PCI_DEBUG is not set
CONFIG_HT_IRQ=y
CONFIG_ISA_DMA_API=y
CONFIG_K8_NB=y
CONFIG_PCCARD=y
# CONFIG_PCMCIA_DEBUG is not set
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_PCMCIA_IOCTL=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
CONFIG_YENTA_RICOH=y
CONFIG_YENTA_TI=y
CONFIG_YENTA_ENE_TUNE=y
CONFIG_YENTA_TOSHIBA=y
CONFIG_PD6729=m
CONFIG_I82092=m
CONFIG_PCCARD_NONSTATIC=m
CONFIG_HOTPLUG_PCI=y
CONFIG_HOTPLUG_PCI_FAKE=m
CONFIG_HOTPLUG_PCI_ACPI=y
CONFIG_HOTPLUG_PCI_ACPI_IBM=m
# CONFIG_HOTPLUG_PCI_CPCI is not set
CONFIG_HOTPLUG_PCI_SHPC=m

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_COMPAT_BINFMT_ELF=y
CONFIG_BINFMT_MISC=y
CONFIG_IA32_EMULATION=y
# CONFIG_IA32_AOUT is not set
CONFIG_COMPAT=y
CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
CONFIG_SYSVIPC_COMPAT=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=y
CONFIG_PACKET_MMAP=y
CONFIG_UNIX=y
CONFIG_XFRM=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
CONFIG_XFRM_MIGRATE=y
CONFIG_XFRM_STATISTICS=y
CONFIG_XFRM_IPCOMP=m
CONFIG_NET_KEY=m
CONFIG_NET_KEY_MIGRATE=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_ASK_IP_FIB_HASH=y
# CONFIG_IP_FIB_TRIE is not set
CONFIG_IP_FIB_HASH=y
CONFIG_IP_MULTIPLE_TABLES=y
CONFIG_IP_ROUTE_MULTIPATH=y
CONFIG_IP_ROUTE_VERBOSE=y
# CONFIG_IP_PNP is not set
CONFIG_NET_IPIP=m
CONFIG_NET_IPGRE=m
CONFIG_NET_IPGRE_BROADCAST=y
CONFIG_IP_MROUTE=y
CONFIG_IP_PIMSM_V1=y
CONFIG_IP_PIMSM_V2=y
# CONFIG_ARPD is not set
CONFIG_SYN_COOKIES=y
CONFIG_INET_AH=m
CONFIG_INET_ESP=m
CONFIG_INET_IPCOMP=m
CONFIG_INET_XFRM_TUNNEL=m
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
CONFIG_INET_XFRM_MODE_BEET=m
CONFIG_INET_LRO=y
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=m
CONFIG_TCP_CONG_CUBIC=y
CONFIG_TCP_CONG_WESTWOOD=m
CONFIG_TCP_CONG_HTCP=m
CONFIG_TCP_CONG_HSTCP=m
CONFIG_TCP_CONG_HYBLA=m
CONFIG_TCP_CONG_VEGAS=m
CONFIG_TCP_CONG_SCALABLE=m
CONFIG_TCP_CONG_LP=m
CONFIG_TCP_CONG_VENO=m
CONFIG_TCP_CONG_YEAH=m
CONFIG_TCP_CONG_ILLINOIS=m
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_CUBIC=y
# CONFIG_DEFAULT_HTCP is not set
# CONFIG_DEFAULT_VEGAS is not set
# CONFIG_DEFAULT_WESTWOOD is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_TCP_MD5SIG=y
CONFIG_IP_VS=m
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12

#
# IPVS transport protocol load balancing support
#
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y

#
# IPVS scheduler
#
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m

#
# IPVS application helper
#
CONFIG_IP_VS_FTP=m
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_OPTIMISTIC_DAD=y
CONFIG_INET6_AH=m
CONFIG_INET6_ESP=m
CONFIG_INET6_IPCOMP=m
CONFIG_IPV6_MIP6=m
CONFIG_INET6_XFRM_TUNNEL=m
CONFIG_INET6_TUNNEL=m
CONFIG_INET6_XFRM_MODE_TRANSPORT=m
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=m
CONFIG_IPV6_SIT=m
CONFIG_IPV6_NDISC_NODETYPE=y
CONFIG_IPV6_TUNNEL=m
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
CONFIG_IPV6_MROUTE=y
CONFIG_IPV6_PIMSM_V2=y
CONFIG_NETLABEL=y
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
# CONFIG_NETFILTER_DEBUG is not set
CONFIG_NETFILTER_ADVANCED=y
CONFIG_BRIDGE_NETFILTER=y

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=m
CONFIG_NETFILTER_NETLINK_QUEUE=m
CONFIG_NETFILTER_NETLINK_LOG=m
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CT_ACCT=y
CONFIG_NF_CONNTRACK_MARK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CT_PROTO_DCCP=m
CONFIG_NF_CT_PROTO_GRE=m
CONFIG_NF_CT_PROTO_SCTP=m
CONFIG_NF_CT_PROTO_UDPLITE=m
CONFIG_NF_CONNTRACK_AMANDA=m
CONFIG_NF_CONNTRACK_FTP=m
CONFIG_NF_CONNTRACK_H323=m
CONFIG_NF_CONNTRACK_IRC=m
CONFIG_NF_CONNTRACK_NETBIOS_NS=m
CONFIG_NF_CONNTRACK_PPTP=m
CONFIG_NF_CONNTRACK_SANE=m
CONFIG_NF_CONNTRACK_SIP=m
CONFIG_NF_CONNTRACK_TFTP=m
CONFIG_NF_CT_NETLINK=m
CONFIG_NETFILTER_XTABLES=y
CONFIG_NETFILTER_XT_TARGET_CLASSIFY=m
CONFIG_NETFILTER_XT_TARGET_CONNMARK=m
CONFIG_NETFILTER_XT_TARGET_DSCP=m
CONFIG_NETFILTER_XT_TARGET_MARK=m
CONFIG_NETFILTER_XT_TARGET_NFQUEUE=m
CONFIG_NETFILTER_XT_TARGET_NFLOG=m
CONFIG_NETFILTER_XT_TARGET_NOTRACK=m
CONFIG_NETFILTER_XT_TARGET_RATEEST=m
CONFIG_NETFILTER_XT_TARGET_TRACE=m
CONFIG_NETFILTER_XT_TARGET_SECMARK=m
CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=m
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m
CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP=m
CONFIG_NETFILTER_XT_MATCH_COMMENT=m
CONFIG_NETFILTER_XT_MATCH_CONNBYTES=m
CONFIG_NETFILTER_XT_MATCH_CONNLIMIT=m
CONFIG_NETFILTER_XT_MATCH_CONNMARK=m
CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
CONFIG_NETFILTER_XT_MATCH_DCCP=m
CONFIG_NETFILTER_XT_MATCH_DSCP=m
CONFIG_NETFILTER_XT_MATCH_ESP=m
CONFIG_NETFILTER_XT_MATCH_HELPER=m
CONFIG_NETFILTER_XT_MATCH_IPRANGE=m
CONFIG_NETFILTER_XT_MATCH_LENGTH=m
CONFIG_NETFILTER_XT_MATCH_LIMIT=m
CONFIG_NETFILTER_XT_MATCH_MAC=m
CONFIG_NETFILTER_XT_MATCH_MARK=m
CONFIG_NETFILTER_XT_MATCH_OWNER=m
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_MULTIPORT=m
CONFIG_NETFILTER_XT_MATCH_PHYSDEV=m
CONFIG_NETFILTER_XT_MATCH_PKTTYPE=m
CONFIG_NETFILTER_XT_MATCH_QUOTA=m
CONFIG_NETFILTER_XT_MATCH_RATEEST=m
CONFIG_NETFILTER_XT_MATCH_REALM=m
CONFIG_NETFILTER_XT_MATCH_SCTP=m
CONFIG_NETFILTER_XT_MATCH_STATE=y
CONFIG_NETFILTER_XT_MATCH_STATISTIC=m
CONFIG_NETFILTER_XT_MATCH_STRING=m
CONFIG_NETFILTER_XT_MATCH_TCPMSS=m
CONFIG_NETFILTER_XT_MATCH_TIME=m
CONFIG_NETFILTER_XT_MATCH_U32=m
CONFIG_NETFILTER_XT_MATCH_HASHLIMIT=m

#
# IP: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV4=y
# CONFIG_NF_CONNTRACK_PROC_COMPAT is not set
CONFIG_IP_NF_QUEUE=m
CONFIG_IP_NF_IPTABLES=y
CONFIG_IP_NF_MATCH_RECENT=m
CONFIG_IP_NF_MATCH_ECN=m
CONFIG_IP_NF_MATCH_AH=m
CONFIG_IP_NF_MATCH_TTL=m
CONFIG_IP_NF_MATCH_ADDRTYPE=m
CONFIG_IP_NF_FILTER=y
CONFIG_IP_NF_TARGET_REJECT=y
CONFIG_IP_NF_TARGET_LOG=m
CONFIG_IP_NF_TARGET_ULOG=m
CONFIG_NF_NAT=m
CONFIG_NF_NAT_NEEDED=y
CONFIG_IP_NF_TARGET_MASQUERADE=m
CONFIG_IP_NF_TARGET_REDIRECT=m
CONFIG_IP_NF_TARGET_NETMAP=m
CONFIG_NF_NAT_SNMP_BASIC=m
CONFIG_NF_NAT_PROTO_DCCP=m
CONFIG_NF_NAT_PROTO_GRE=m
CONFIG_NF_NAT_PROTO_UDPLITE=m
CONFIG_NF_NAT_PROTO_SCTP=m
CONFIG_NF_NAT_FTP=m
CONFIG_NF_NAT_IRC=m
CONFIG_NF_NAT_TFTP=m
CONFIG_NF_NAT_AMANDA=m
CONFIG_NF_NAT_PPTP=m
CONFIG_NF_NAT_H323=m
CONFIG_NF_NAT_SIP=m
CONFIG_IP_NF_MANGLE=m
CONFIG_IP_NF_TARGET_ECN=m
CONFIG_IP_NF_TARGET_TTL=m
CONFIG_IP_NF_TARGET_CLUSTERIP=m
CONFIG_IP_NF_RAW=m
CONFIG_IP_NF_SECURITY=m
CONFIG_IP_NF_ARPTABLES=m
CONFIG_IP_NF_ARPFILTER=m
CONFIG_IP_NF_ARP_MANGLE=m

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_CONNTRACK_IPV6=m
CONFIG_IP6_NF_QUEUE=m
CONFIG_IP6_NF_IPTABLES=m
CONFIG_IP6_NF_MATCH_RT=m
CONFIG_IP6_NF_MATCH_OPTS=m
CONFIG_IP6_NF_MATCH_FRAG=m
CONFIG_IP6_NF_MATCH_HL=m
CONFIG_IP6_NF_MATCH_IPV6HEADER=m
CONFIG_IP6_NF_MATCH_AH=m
CONFIG_IP6_NF_MATCH_MH=m
CONFIG_IP6_NF_MATCH_EUI64=m
CONFIG_IP6_NF_FILTER=m
CONFIG_IP6_NF_TARGET_LOG=m
CONFIG_IP6_NF_TARGET_REJECT=m
CONFIG_IP6_NF_MANGLE=m
CONFIG_IP6_NF_TARGET_HL=m
CONFIG_IP6_NF_RAW=m
CONFIG_IP6_NF_SECURITY=m

#
# DECnet: Netfilter Configuration
#
# CONFIG_DECNET_NF_GRABULATOR is not set

#
# Bridge: Netfilter Configuration
#
CONFIG_BRIDGE_NF_EBTABLES=m
CONFIG_BRIDGE_EBT_BROUTE=m
CONFIG_BRIDGE_EBT_T_FILTER=m
CONFIG_BRIDGE_EBT_T_NAT=m
CONFIG_BRIDGE_EBT_802_3=m
CONFIG_BRIDGE_EBT_AMONG=m
CONFIG_BRIDGE_EBT_ARP=m
CONFIG_BRIDGE_EBT_IP=m
CONFIG_BRIDGE_EBT_IP6=m
CONFIG_BRIDGE_EBT_LIMIT=m
CONFIG_BRIDGE_EBT_MARK=m
CONFIG_BRIDGE_EBT_PKTTYPE=m
CONFIG_BRIDGE_EBT_STP=m
CONFIG_BRIDGE_EBT_VLAN=m
CONFIG_BRIDGE_EBT_ARPREPLY=m
CONFIG_BRIDGE_EBT_DNAT=m
CONFIG_BRIDGE_EBT_MARK_T=m
CONFIG_BRIDGE_EBT_REDIRECT=m
CONFIG_BRIDGE_EBT_SNAT=m
CONFIG_BRIDGE_EBT_LOG=m
CONFIG_BRIDGE_EBT_ULOG=m
CONFIG_BRIDGE_EBT_NFLOG=m
CONFIG_IP_DCCP=m
CONFIG_INET_DCCP_DIAG=m
CONFIG_IP_DCCP_ACKVEC=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
CONFIG_IP_DCCP_CCID2=m
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
CONFIG_IP_DCCP_CCID3=m
# CONFIG_IP_DCCP_CCID3_DEBUG is not set
CONFIG_IP_DCCP_CCID3_RTO=100
CONFIG_IP_DCCP_TFRC_LIB=m

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
CONFIG_NET_DCCPPROBE=m
CONFIG_IP_SCTP=m
# CONFIG_SCTP_DBG_MSG is not set
# CONFIG_SCTP_DBG_OBJCNT is not set
# CONFIG_SCTP_HMAC_NONE is not set
# CONFIG_SCTP_HMAC_SHA1 is not set
CONFIG_SCTP_HMAC_MD5=y
CONFIG_TIPC=m
# CONFIG_TIPC_ADVANCED is not set
# CONFIG_TIPC_DEBUG is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
CONFIG_ATM_LANE=m
# CONFIG_ATM_MPOA is not set
CONFIG_ATM_BR2684=m
# CONFIG_ATM_BR2684_IPFILTER is not set
CONFIG_STP=m
CONFIG_GARP=m
CONFIG_BRIDGE=m
CONFIG_VLAN_8021Q=m
CONFIG_VLAN_8021Q_GVRP=y
CONFIG_DECNET=m
CONFIG_DECNET_ROUTER=y
CONFIG_LLC=y
# CONFIG_LLC2 is not set
CONFIG_IPX=m
# CONFIG_IPX_INTERN is not set
CONFIG_ATALK=m
CONFIG_DEV_APPLETALK=m
CONFIG_IPDDP=m
CONFIG_IPDDP_ENCAP=y
CONFIG_IPDDP_DECAP=y
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
# CONFIG_ECONET is not set
CONFIG_WAN_ROUTER=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
CONFIG_NET_SCH_HTB=m
CONFIG_NET_SCH_HFSC=m
CONFIG_NET_SCH_ATM=m
CONFIG_NET_SCH_PRIO=m
CONFIG_NET_SCH_RED=m
CONFIG_NET_SCH_SFQ=m
CONFIG_NET_SCH_TEQL=m
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
CONFIG_NET_SCH_DSMARK=m
CONFIG_NET_SCH_NETEM=m
CONFIG_NET_SCH_INGRESS=m

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=m
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
CONFIG_NET_CLS_ROUTE=y
CONFIG_NET_CLS_FW=m
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
CONFIG_CLS_U32_MARK=y
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
CONFIG_NET_EMATCH=y
CONFIG_NET_EMATCH_STACK=32
CONFIG_NET_EMATCH_CMP=m
CONFIG_NET_EMATCH_NBYTE=m
CONFIG_NET_EMATCH_U32=m
CONFIG_NET_EMATCH_META=m
CONFIG_NET_EMATCH_TEXT=m
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=m
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
CONFIG_NET_ACT_IPT=m
CONFIG_NET_ACT_NAT=m
CONFIG_NET_ACT_PEDIT=m
CONFIG_NET_ACT_SIMP=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y

#
# Network testing
#
CONFIG_NET_PKTGEN=m
# CONFIG_NET_TCPPROBE is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=m
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=m
CONFIG_ROSE=m

#
# AX.25 network device drivers
#
CONFIG_MKISS=m
CONFIG_6PACK=m
CONFIG_BPQETHER=m
CONFIG_BAYCOM_SER_FDX=m
CONFIG_BAYCOM_SER_HDX=m
CONFIG_BAYCOM_PAR=m
CONFIG_YAM=m
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_DEBUG_DEVICES is not set
CONFIG_IRDA=m

#
# IrDA protocols
#
CONFIG_IRLAN=m
CONFIG_IRNET=m
CONFIG_IRCOMM=m
# CONFIG_IRDA_ULTRA is not set

#
# IrDA options
#
CONFIG_IRDA_CACHE_LAST_LSAP=y
CONFIG_IRDA_FAST_RR=y
# CONFIG_IRDA_DEBUG is not set

#
# Infrared-port device drivers
#

#
# SIR device drivers
#
CONFIG_IRTTY_SIR=m

#
# Dongle support
#
CONFIG_DONGLE=y
CONFIG_ESI_DONGLE=m
CONFIG_ACTISYS_DONGLE=m
CONFIG_TEKRAM_DONGLE=m
CONFIG_TOIM3232_DONGLE=m
CONFIG_LITELINK_DONGLE=m
CONFIG_MA600_DONGLE=m
CONFIG_GIRBIL_DONGLE=m
CONFIG_MCP2120_DONGLE=m
CONFIG_OLD_BELKIN_DONGLE=m
CONFIG_ACT200L_DONGLE=m
CONFIG_KINGSUN_DONGLE=m
CONFIG_KSDAZZLE_DONGLE=m
CONFIG_KS959_DONGLE=m

#
# FIR device drivers
#
CONFIG_USB_IRDA=m
CONFIG_SIGMATEL_FIR=m
CONFIG_NSC_FIR=m
CONFIG_WINBOND_FIR=m
CONFIG_SMC_IRCC_FIR=m
CONFIG_ALI_FIR=m
CONFIG_VLSI_FIR=m
CONFIG_VIA_FIR=m
CONFIG_MCS_FIR=m
CONFIG_BT=m
CONFIG_BT_L2CAP=m
CONFIG_BT_SCO=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
CONFIG_BT_BNEP=m
CONFIG_BT_BNEP_MC_FILTER=y
CONFIG_BT_BNEP_PROTO_FILTER=y
CONFIG_BT_CMTP=m
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
CONFIG_BT_HCIBTSDIO=m
CONFIG_BT_HCIUART=m
CONFIG_BT_HCIUART_H4=y
CONFIG_BT_HCIUART_BCSP=y
CONFIG_BT_HCIUART_LL=y
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
CONFIG_BT_HCIBFUSB=m
CONFIG_BT_HCIDTL1=m
CONFIG_BT_HCIBT3C=m
CONFIG_BT_HCIBLUECARD=m
CONFIG_BT_HCIBTUART=m
CONFIG_BT_HCIVHCI=m
# CONFIG_AF_RXRPC is not set
CONFIG_FIB_RULES=y

#
# Wireless
#
CONFIG_CFG80211=m
CONFIG_NL80211=y
CONFIG_WIRELESS_EXT=y
CONFIG_WIRELESS_EXT_SYSFS=y
CONFIG_MAC80211=m

#
# Rate control algorithm selection
#
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUGFS=y
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_IEEE80211=m
# CONFIG_IEEE80211_DEBUG is not set
CONFIG_IEEE80211_CRYPT_WEP=m
CONFIG_IEEE80211_CRYPT_CCMP=m
CONFIG_IEEE80211_CRYPT_TKIP=m
CONFIG_RFKILL=m
CONFIG_RFKILL_INPUT=m
CONFIG_RFKILL_LEDS=y
CONFIG_NET_9P=m
CONFIG_NET_9P_VIRTIO=m
# CONFIG_NET_9P_DEBUG is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=y
# CONFIG_FIRMWARE_IN_KERNEL is not set
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
CONFIG_CONNECTOR=y
CONFIG_PROC_EVENTS=y
CONFIG_MTD=m
# CONFIG_MTD_DEBUG is not set
CONFIG_MTD_CONCAT=m
CONFIG_MTD_PARTITIONS=y
CONFIG_MTD_REDBOOT_PARTS=m
CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
# CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED is not set
# CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
CONFIG_MTD_AR7_PARTS=m

#
# User Modules And Translation Layers
#
CONFIG_MTD_CHAR=m
CONFIG_MTD_BLKDEVS=m
CONFIG_MTD_BLOCK=m
CONFIG_MTD_BLOCK_RO=m
CONFIG_FTL=m
CONFIG_NFTL=m
CONFIG_NFTL_RW=y
CONFIG_INFTL=m
CONFIG_RFD_FTL=m
CONFIG_SSFDC=m
CONFIG_MTD_OOPS=m

#
# RAM/ROM/Flash chip drivers
#
CONFIG_MTD_CFI=m
CONFIG_MTD_JEDECPROBE=m
CONFIG_MTD_GEN_PROBE=m
# CONFIG_MTD_CFI_ADV_OPTIONS is not set
CONFIG_MTD_MAP_BANK_WIDTH_1=y
CONFIG_MTD_MAP_BANK_WIDTH_2=y
CONFIG_MTD_MAP_BANK_WIDTH_4=y
# CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
# CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
CONFIG_MTD_CFI_I1=y
CONFIG_MTD_CFI_I2=y
# CONFIG_MTD_CFI_I4 is not set
# CONFIG_MTD_CFI_I8 is not set
CONFIG_MTD_CFI_INTELEXT=m
CONFIG_MTD_CFI_AMDSTD=m
CONFIG_MTD_CFI_STAA=m
CONFIG_MTD_CFI_UTIL=m
CONFIG_MTD_RAM=m
CONFIG_MTD_ROM=m
CONFIG_MTD_ABSENT=m

#
# Mapping drivers for chip access
#
CONFIG_MTD_COMPLEX_MAPPINGS=y
# CONFIG_MTD_PHYSMAP is not set
CONFIG_MTD_SC520CDP=m
CONFIG_MTD_NETSC520=m
CONFIG_MTD_TS5500=m
# CONFIG_MTD_SBC_GXX is not set
# CONFIG_MTD_AMD76XROM is not set
# CONFIG_MTD_ICHXROM is not set
CONFIG_MTD_ESB2ROM=m
CONFIG_MTD_CK804XROM=m
CONFIG_MTD_SCB2_FLASH=m
# CONFIG_MTD_NETtel is not set
# CONFIG_MTD_DILNETPC is not set
# CONFIG_MTD_L440GX is not set
CONFIG_MTD_PCI=m
# CONFIG_MTD_INTEL_VR_NOR is not set
# CONFIG_MTD_PLATRAM is not set

#
# Self-contained MTD device drivers
#
CONFIG_MTD_PMC551=m
# CONFIG_MTD_PMC551_BUGFIX is not set
# CONFIG_MTD_PMC551_DEBUG is not set
# CONFIG_MTD_SLRAM is not set
# CONFIG_MTD_PHRAM is not set
CONFIG_MTD_MTDRAM=m
CONFIG_MTDRAM_TOTAL_SIZE=4096
CONFIG_MTDRAM_ERASE_SIZE=128
CONFIG_MTD_BLOCK2MTD=m

#
# Disk-On-Chip Device Drivers
#
# CONFIG_MTD_DOC2000 is not set
# CONFIG_MTD_DOC2001 is not set
# CONFIG_MTD_DOC2001PLUS is not set
CONFIG_MTD_NAND=m
# CONFIG_MTD_NAND_VERIFY_WRITE is not set
CONFIG_MTD_NAND_ECC_SMC=y
# CONFIG_MTD_NAND_MUSEUM_IDS is not set
CONFIG_MTD_NAND_IDS=m
CONFIG_MTD_NAND_DISKONCHIP=m
# CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
# CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
# CONFIG_MTD_NAND_CAFE is not set
CONFIG_MTD_NAND_NANDSIM=m
# CONFIG_MTD_NAND_PLATFORM is not set
CONFIG_MTD_ALAUDA=m
# CONFIG_MTD_ONENAND is not set

#
# UBI - Unsorted block images
#
CONFIG_MTD_UBI=m
CONFIG_MTD_UBI_WL_THRESHOLD=4096
CONFIG_MTD_UBI_BEB_RESERVE=1
# CONFIG_MTD_UBI_GLUEBI is not set

#
# UBI debugging options
#
# CONFIG_MTD_UBI_DEBUG is not set
CONFIG_PARPORT=m
CONFIG_PARPORT_PC=m
CONFIG_PARPORT_SERIAL=m
# CONFIG_PARPORT_PC_FIFO is not set
# CONFIG_PARPORT_PC_SUPERIO is not set
CONFIG_PARPORT_PC_PCMCIA=m
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
CONFIG_PARPORT_1284=y
CONFIG_PARPORT_NOT_PC=y
CONFIG_PNP=y
# CONFIG_PNP_DEBUG is not set

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=m
CONFIG_PARIDE=m

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=m
CONFIG_PARIDE_PCD=m
CONFIG_PARIDE_PF=m
CONFIG_PARIDE_PT=m
CONFIG_PARIDE_PG=m

#
# Parallel IDE protocol modules
#
CONFIG_PARIDE_ATEN=m
CONFIG_PARIDE_BPCK=m
CONFIG_PARIDE_COMM=m
CONFIG_PARIDE_DSTR=m
CONFIG_PARIDE_FIT2=m
CONFIG_PARIDE_FIT3=m
CONFIG_PARIDE_EPAT=m
CONFIG_PARIDE_EPATC8=y
CONFIG_PARIDE_EPIA=m
CONFIG_PARIDE_FRIQ=m
CONFIG_PARIDE_FRPW=m
CONFIG_PARIDE_KBIC=m
CONFIG_PARIDE_KTTI=m
CONFIG_PARIDE_ON20=m
CONFIG_PARIDE_ON26=m
CONFIG_BLK_CPQ_DA=m
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=y
CONFIG_BLK_DEV_CRYPTOLOOP=m
CONFIG_BLK_DEV_NBD=m
CONFIG_BLK_DEV_SX8=m
# CONFIG_BLK_DEV_UB is not set
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=16384
# CONFIG_BLK_DEV_XIP is not set
CONFIG_CDROM_PKTCDVD=m
CONFIG_CDROM_PKTCDVD_BUFFERS=8
# CONFIG_CDROM_PKTCDVD_WCACHE is not set
CONFIG_ATA_OVER_ETH=m
CONFIG_XEN_BLKDEV_FRONTEND=m
CONFIG_VIRTIO_BLK=m
# CONFIG_BLK_DEV_HD is not set
CONFIG_MISC_DEVICES=y
# CONFIG_IBM_ASM is not set
# CONFIG_PHANTOM is not set
CONFIG_EEPROM_93CX6=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ACER_WMI=m
CONFIG_ASUS_LAPTOP=m
CONFIG_FUJITSU_LAPTOP=m
# CONFIG_FUJITSU_LAPTOP_DEBUG is not set
CONFIG_HP_WMI=m
CONFIG_MSI_LAPTOP=m
CONFIG_COMPAL_LAPTOP=m
CONFIG_SONY_LAPTOP=m
CONFIG_SONYPI_COMPAT=y
CONFIG_THINKPAD_ACPI=m
# CONFIG_THINKPAD_ACPI_DEBUG is not set
CONFIG_THINKPAD_ACPI_VIDEO=y
CONFIG_THINKPAD_ACPI_HOTKEY_POLL=y
# CONFIG_INTEL_MENLOW is not set
# CONFIG_EEEPC_LAPTOP is not set
CONFIG_ENCLOSURE_SERVICES=m
CONFIG_SGI_XP=m
# CONFIG_HP_ILO is not set
CONFIG_SGI_GRU=m
# CONFIG_SGI_GRU_DEBUG is not set
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=m
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
CONFIG_CHR_DEV_ST=m
CONFIG_CHR_DEV_OSST=m
CONFIG_BLK_DEV_SR=y
CONFIG_BLK_DEV_SR_VENDOR=y
CONFIG_CHR_DEV_SG=y
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_ENCLOSURE=m

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
#
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
CONFIG_SCSI_SCAN_ASYNC=y
CONFIG_SCSI_WAIT_SCAN=m

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_ATA=y
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SAS_LIBSAS_DEBUG is not set
CONFIG_SCSI_SRP_ATTRS=m
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_ISCSI_TCP=m
CONFIG_BLK_DEV_3W_XXXX_RAID=m
CONFIG_SCSI_3W_9XXX=m
CONFIG_SCSI_ACARD=m
CONFIG_SCSI_AACRAID=m
CONFIG_SCSI_AIC7XXX=m
CONFIG_AIC7XXX_CMDS_PER_DEVICE=4
CONFIG_AIC7XXX_RESET_DELAY_MS=15000
# CONFIG_AIC7XXX_DEBUG_ENABLE is not set
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=m
CONFIG_SCSI_AIC79XX=m
CONFIG_AIC79XX_CMDS_PER_DEVICE=4
CONFIG_AIC79XX_RESET_DELAY_MS=15000
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
# CONFIG_AIC79XX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC94XX=m
# CONFIG_AIC94XX_DEBUG is not set
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=m
CONFIG_SCSI_ARCMSR_AER=y
CONFIG_MEGARAID_NEWGEN=y
CONFIG_MEGARAID_MM=m
CONFIG_MEGARAID_MAILBOX=m
CONFIG_MEGARAID_LEGACY=m
CONFIG_MEGARAID_SAS=m
CONFIG_SCSI_HPTIOP=m
CONFIG_SCSI_BUSLOGIC=m
# CONFIG_SCSI_DMX3191D is not set
# CONFIG_SCSI_EATA is not set
# CONFIG_SCSI_FUTURE_DOMAIN is not set
CONFIG_SCSI_GDTH=m
CONFIG_SCSI_IPS=m
CONFIG_SCSI_INITIO=m
CONFIG_SCSI_INIA100=m
CONFIG_SCSI_PPA=m
CONFIG_SCSI_IMM=m
# CONFIG_SCSI_IZIP_EPP16 is not set
# CONFIG_SCSI_IZIP_SLOW_CTR is not set
CONFIG_SCSI_MVSAS=m
CONFIG_SCSI_STEX=m
CONFIG_SCSI_SYM53C8XX_2=m
CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
CONFIG_SCSI_SYM53C8XX_MMIO=y
# CONFIG_SCSI_IPR is not set
CONFIG_SCSI_QLOGIC_1280=m
CONFIG_SCSI_QLA_FC=m
CONFIG_SCSI_QLA_ISCSI=m
CONFIG_SCSI_LPFC=m
CONFIG_SCSI_DC395x=m
CONFIG_SCSI_DC390T=m
# CONFIG_SCSI_DEBUG is not set
CONFIG_SCSI_SRP=m
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
# CONFIG_PCMCIA_FDOMAIN is not set
CONFIG_PCMCIA_QLOGIC=m
CONFIG_PCMCIA_SYM53C500=m
CONFIG_SCSI_DH=y
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
CONFIG_SCSI_DH_EMC=m
CONFIG_SCSI_DH_ALUA=m
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_ATA_ACPI=y
CONFIG_SATA_PMP=y
CONFIG_SATA_AHCI=y
CONFIG_SATA_SIL24=m
CONFIG_ATA_SFF=y
CONFIG_SATA_SVW=m
CONFIG_ATA_PIIX=y
CONFIG_SATA_MV=m
CONFIG_SATA_NV=m
CONFIG_PDC_ADMA=m
CONFIG_SATA_QSTOR=m
CONFIG_SATA_PROMISE=m
CONFIG_SATA_SX4=m
CONFIG_SATA_SIL=m
CONFIG_SATA_SIS=m
CONFIG_SATA_ULI=m
CONFIG_SATA_VIA=m
CONFIG_SATA_VITESSE=m
CONFIG_SATA_INIC162X=m
CONFIG_PATA_ACPI=m
CONFIG_PATA_ALI=m
CONFIG_PATA_AMD=m
CONFIG_PATA_ARTOP=m
CONFIG_PATA_ATIIXP=m
CONFIG_PATA_CMD640_PCI=m
CONFIG_PATA_CMD64X=m
CONFIG_PATA_CS5520=m
CONFIG_PATA_CS5530=m
CONFIG_PATA_CYPRESS=m
CONFIG_PATA_EFAR=m
CONFIG_ATA_GENERIC=m
CONFIG_PATA_HPT366=m
CONFIG_PATA_HPT37X=m
CONFIG_PATA_HPT3X2N=m
CONFIG_PATA_HPT3X3=m
CONFIG_PATA_HPT3X3_DMA=y
CONFIG_PATA_IT821X=m
CONFIG_PATA_IT8213=m
CONFIG_PATA_JMICRON=m
CONFIG_PATA_TRIFLEX=m
CONFIG_PATA_MARVELL=m
CONFIG_PATA_MPIIX=m
CONFIG_PATA_OLDPIIX=m
CONFIG_PATA_NETCELL=m
CONFIG_PATA_NINJA32=m
CONFIG_PATA_NS87410=m
CONFIG_PATA_NS87415=m
CONFIG_PATA_OPTI=m
CONFIG_PATA_OPTIDMA=m
CONFIG_PATA_PCMCIA=m
CONFIG_PATA_PDC_OLD=m
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
CONFIG_PATA_SERVERWORKS=m
CONFIG_PATA_PDC2027X=m
CONFIG_PATA_SIL680=m
CONFIG_PATA_SIS=m
CONFIG_PATA_VIA=m
CONFIG_PATA_WINBOND=m
CONFIG_PATA_SCH=m
CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID10=m
CONFIG_MD_RAID456=m
CONFIG_MD_RAID5_RESHAPE=y
CONFIG_MD_MULTIPATH=m
CONFIG_MD_FAULTY=m
CONFIG_BLK_DEV_DM=y
CONFIG_DM_DEBUG=y
CONFIG_DM_CRYPT=m
CONFIG_DM_SNAPSHOT=y
CONFIG_DM_MIRROR=y
CONFIG_DM_ZERO=y
CONFIG_DM_MULTIPATH=m
# CONFIG_DM_DELAY is not set
CONFIG_DM_UEVENT=y
CONFIG_FUSION=y
CONFIG_FUSION_SPI=m
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=40
CONFIG_FUSION_CTL=m
CONFIG_FUSION_LAN=m
CONFIG_FUSION_LOGGING=y

#
# IEEE 1394 (FireWire) support
#

#
# Enable only one of the two stacks, unless you know what you are doing
#
CONFIG_FIREWIRE=m
CONFIG_FIREWIRE_OHCI=m
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_FIREWIRE_SBP2=m
# CONFIG_IEEE1394 is not set
CONFIG_I2O=m
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
CONFIG_I2O_EXT_ADAPTEC=y
CONFIG_I2O_EXT_ADAPTEC_DMA64=y
CONFIG_I2O_CONFIG=m
CONFIG_I2O_CONFIG_OLD_IOCTL=y
CONFIG_I2O_BUS=m
CONFIG_I2O_BLOCK=m
CONFIG_I2O_SCSI=m
CONFIG_I2O_PROC=m
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_MAC_EMUMOUSEBTN=y
CONFIG_NETDEVICES=y
CONFIG_IFB=m
CONFIG_DUMMY=m
CONFIG_BONDING=m
CONFIG_MACVLAN=m
CONFIG_EQUALIZER=m
CONFIG_TUN=m
CONFIG_VETH=m
CONFIG_NET_SB1000=m
# CONFIG_ARCNET is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_MARVELL_PHY=m
CONFIG_DAVICOM_PHY=m
CONFIG_QSEMI_PHY=m
CONFIG_LXT_PHY=m
CONFIG_CICADA_PHY=m
CONFIG_VITESSE_PHY=m
CONFIG_SMSC_PHY=m
CONFIG_BROADCOM_PHY=m
CONFIG_ICPLUS_PHY=m
CONFIG_REALTEK_PHY=m
CONFIG_MDIO_BITBANG=m
CONFIG_NET_ETHERNET=y
CONFIG_MII=m
CONFIG_HAPPYMEAL=m
CONFIG_SUNGEM=m
CONFIG_CASSINI=m
CONFIG_NET_VENDOR_3COM=y
CONFIG_VORTEX=m
CONFIG_TYPHOON=m
CONFIG_NET_TULIP=y
CONFIG_DE2104X=m
CONFIG_TULIP=m
# CONFIG_TULIP_MWI is not set
CONFIG_TULIP_MMIO=y
# CONFIG_TULIP_NAPI is not set
CONFIG_DE4X5=m
CONFIG_WINBOND_840=m
CONFIG_DM9102=m
CONFIG_ULI526X=m
CONFIG_PCMCIA_XIRCOM=m
# CONFIG_HP100 is not set
# CONFIG_IBM_NEW_EMAC_ZMII is not set
# CONFIG_IBM_NEW_EMAC_RGMII is not set
# CONFIG_IBM_NEW_EMAC_TAH is not set
# CONFIG_IBM_NEW_EMAC_EMAC4 is not set
CONFIG_NET_PCI=y
CONFIG_PCNET32=m
CONFIG_AMD8111_ETH=m
CONFIG_ADAPTEC_STARFIRE=m
CONFIG_B44=m
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_FORCEDETH=m
CONFIG_FORCEDETH_NAPI=y
# CONFIG_EEPRO100 is not set
CONFIG_E100=m
CONFIG_FEALNX=m
CONFIG_NATSEMI=m
CONFIG_NE2K_PCI=m
CONFIG_8139CP=m
CONFIG_8139TOO=m
# CONFIG_8139TOO_PIO is not set
# CONFIG_8139TOO_TUNE_TWISTER is not set
CONFIG_8139TOO_8129=y
# CONFIG_8139_OLD_RX_RESET is not set
CONFIG_R6040=m
CONFIG_SIS900=m
CONFIG_EPIC100=m
CONFIG_SUNDANCE=m
# CONFIG_SUNDANCE_MMIO is not set
CONFIG_TLAN=m
CONFIG_VIA_RHINE=m
CONFIG_VIA_RHINE_MMIO=y
CONFIG_SC92031=m
CONFIG_NET_POCKET=y
CONFIG_ATP=m
CONFIG_DE600=m
CONFIG_DE620=m
CONFIG_NETDEV_1000=y
CONFIG_ACENIC=m
# CONFIG_ACENIC_OMIT_TIGON_I is not set
CONFIG_DL2K=m
CONFIG_E1000=m
# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
CONFIG_E1000E=m
CONFIG_IP1000=m
CONFIG_IGB=m
# CONFIG_IGB_LRO is not set
CONFIG_NS83820=m
CONFIG_HAMACHI=m
CONFIG_YELLOWFIN=m
CONFIG_R8169=m
CONFIG_R8169_VLAN=y
CONFIG_SIS190=m
CONFIG_SKGE=m
# CONFIG_SKGE_DEBUG is not set
CONFIG_SKY2=m
# CONFIG_SKY2_DEBUG is not set
CONFIG_VIA_VELOCITY=m
CONFIG_TIGON3=m
CONFIG_BNX2=m
CONFIG_QLA3XXX=m
CONFIG_ATL1=m
CONFIG_ATL1E=m
CONFIG_NETDEV_10000=y
CONFIG_CHELSIO_T1=m
CONFIG_CHELSIO_T1_1G=y
CONFIG_CHELSIO_T3=m
CONFIG_IXGBE=m
CONFIG_IXGB=m
CONFIG_S2IO=m
CONFIG_MYRI10GE=m
CONFIG_NETXEN_NIC=m
CONFIG_NIU=m
CONFIG_MLX4_CORE=m
CONFIG_MLX4_DEBUG=y
CONFIG_TEHUTI=m
CONFIG_BNX2X=m
# CONFIG_SFC is not set
CONFIG_TR=y
CONFIG_IBMOL=m
CONFIG_3C359=m
# CONFIG_TMS380TR is not set

#
# Wireless LAN
#
# CONFIG_WLAN_PRE80211 is not set
CONFIG_WLAN_80211=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_IPW2100=m
CONFIG_IPW2100_MONITOR=y
# CONFIG_IPW2100_DEBUG is not set
CONFIG_IPW2200=m
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBERTAS=m
CONFIG_LIBERTAS_USB=m
CONFIG_LIBERTAS_CS=m
CONFIG_LIBERTAS_SDIO=m
CONFIG_LIBERTAS_DEBUG=y
CONFIG_AIRO=m
CONFIG_HERMES=m
CONFIG_PLX_HERMES=m
CONFIG_TMD_HERMES=m
CONFIG_NORTEL_HERMES=m
CONFIG_PCI_HERMES=m
CONFIG_PCMCIA_HERMES=m
CONFIG_PCMCIA_SPECTRUM=m
CONFIG_ATMEL=m
CONFIG_PCI_ATMEL=m
CONFIG_PCMCIA_ATMEL=m
CONFIG_AIRO_CS=m
CONFIG_PCMCIA_WL3501=m
CONFIG_PRISM54=m
CONFIG_USB_ZD1201=m
CONFIG_USB_NET_RNDIS_WLAN=m
CONFIG_RTL8180=m
CONFIG_RTL8187=m
CONFIG_ADM8211=m
CONFIG_MAC80211_HWSIM=m
CONFIG_P54_COMMON=m
CONFIG_P54_USB=m
CONFIG_P54_PCI=m
CONFIG_ATH5K=m
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH9K=m
CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLAGN=m
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
CONFIG_IWL5000=y
CONFIG_IWL3945=m
CONFIG_IWL3945_RFKILL=y
CONFIG_IWL3945_SPECTRUM_MEASUREMENT=y
CONFIG_IWL3945_LEDS=y
CONFIG_IWL3945_DEBUG=y
CONFIG_HOSTAP=m
CONFIG_HOSTAP_FIRMWARE=y
CONFIG_HOSTAP_FIRMWARE_NVRAM=y
CONFIG_HOSTAP_PLX=m
CONFIG_HOSTAP_PCI=m
CONFIG_HOSTAP_CS=m
CONFIG_B43=m
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
CONFIG_B43_PCMCIA=y
CONFIG_B43_PIO=y
CONFIG_B43_LEDS=y
CONFIG_B43_RFKILL=y
CONFIG_B43_DEBUG=y
# CONFIG_B43_FORCE_PIO is not set
CONFIG_B43LEGACY=m
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
CONFIG_B43LEGACY_RFKILL=y
CONFIG_B43LEGACY_DEBUG=y
CONFIG_B43LEGACY_DMA=y
CONFIG_B43LEGACY_PIO=y
CONFIG_B43LEGACY_DMA_AND_PIO_MODE=y
# CONFIG_B43LEGACY_DMA_MODE is not set
# CONFIG_B43LEGACY_PIO_MODE is not set
CONFIG_ZD1211RW=m
# CONFIG_ZD1211RW_DEBUG is not set
CONFIG_RT2X00=m
CONFIG_RT2X00_LIB=m
CONFIG_RT2X00_LIB_PCI=m
CONFIG_RT2X00_LIB_USB=m
CONFIG_RT2X00_LIB_FIRMWARE=y
CONFIG_RT2X00_LIB_RFKILL=y
CONFIG_RT2X00_LIB_LEDS=y
CONFIG_RT2400PCI=m
CONFIG_RT2400PCI_RFKILL=y
CONFIG_RT2400PCI_LEDS=y
CONFIG_RT2500PCI=m
CONFIG_RT2500PCI_RFKILL=y
CONFIG_RT2500PCI_LEDS=y
CONFIG_RT61PCI=m
CONFIG_RT61PCI_RFKILL=y
CONFIG_RT61PCI_LEDS=y
CONFIG_RT2500USB=m
CONFIG_RT2500USB_LEDS=y
CONFIG_RT73USB=m
CONFIG_RT73USB_LEDS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
# CONFIG_RT2X00_DEBUG is not set

#
# USB Network Adapters
#
CONFIG_USB_CATC=m
CONFIG_USB_KAWETH=m
CONFIG_USB_PEGASUS=m
CONFIG_USB_RTL8150=m
CONFIG_USB_USBNET=m
CONFIG_USB_NET_AX8817X=m
CONFIG_USB_NET_CDCETHER=m
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_GL620A=m
CONFIG_USB_NET_NET1080=m
CONFIG_USB_NET_PLUSB=m
CONFIG_USB_NET_MCS7830=m
CONFIG_USB_NET_RNDIS_HOST=m
CONFIG_USB_NET_CDC_SUBSET=m
CONFIG_USB_ALI_M5632=y
CONFIG_USB_AN2720=y
CONFIG_USB_BELKIN=y
CONFIG_USB_ARMLINUX=y
CONFIG_USB_EPSON2888=y
CONFIG_USB_KC2190=y
CONFIG_USB_NET_ZAURUS=m
CONFIG_USB_HSO=m
CONFIG_NET_PCMCIA=y
CONFIG_PCMCIA_3C589=m
CONFIG_PCMCIA_3C574=m
CONFIG_PCMCIA_FMVJ18X=m
CONFIG_PCMCIA_PCNET=m
CONFIG_PCMCIA_NMCLAN=m
CONFIG_PCMCIA_SMC91C92=m
CONFIG_PCMCIA_XIRC2PS=m
CONFIG_PCMCIA_AXNET=m
# CONFIG_WAN is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
# CONFIG_ATM_ZATM is not set
CONFIG_ATM_IDT77252=m
# CONFIG_ATM_IDT77252_DEBUG is not set
# CONFIG_ATM_IDT77252_RCV_ALL is not set
CONFIG_ATM_IDT77252_USE_SUNI=y
CONFIG_ATM_AMBASSADOR=m
# CONFIG_ATM_AMBASSADOR_DEBUG is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=m
# CONFIG_ATM_FORE200E_USE_TASKLET is not set
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
CONFIG_XEN_NETDEV_FRONTEND=m
CONFIG_FDDI=y
# CONFIG_DEFXX is not set
CONFIG_SKFP=m
# CONFIG_HIPPI is not set
CONFIG_PLIP=m
CONFIG_PPP=m
CONFIG_PPP_MULTILINK=y
CONFIG_PPP_FILTER=y
CONFIG_PPP_ASYNC=m
CONFIG_PPP_SYNC_TTY=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_BSDCOMP is not set
CONFIG_PPP_MPPE=m
CONFIG_PPPOE=m
CONFIG_PPPOATM=m
CONFIG_PPPOL2TP=m
CONFIG_SLIP=m
CONFIG_SLIP_COMPRESSED=y
CONFIG_SLHC=m
CONFIG_SLIP_SMART=y
# CONFIG_SLIP_MODE_SLIP6 is not set
CONFIG_NET_FC=y
CONFIG_NETCONSOLE=m
CONFIG_NETCONSOLE_DYNAMIC=y
CONFIG_NETPOLL=y
CONFIG_NETPOLL_TRAP=y
CONFIG_NET_POLL_CONTROLLER=y
CONFIG_VIRTIO_NET=m
CONFIG_ISDN=y
CONFIG_MISDN=m
CONFIG_MISDN_DSP=m
CONFIG_MISDN_L1OIP=m

#
# mISDN hardware drivers
#
CONFIG_MISDN_HFCPCI=m
CONFIG_MISDN_HFCMULTI=m
CONFIG_ISDN_I4L=m
CONFIG_ISDN_PPP=y
CONFIG_ISDN_PPP_VJ=y
CONFIG_ISDN_MPP=y
CONFIG_IPPP_FILTER=y
# CONFIG_ISDN_PPP_BSDCOMP is not set
CONFIG_ISDN_AUDIO=y
CONFIG_ISDN_TTY_FAX=y

#
# ISDN feature submodules
#
CONFIG_ISDN_DIVERSION=m

#
# ISDN4Linux hardware drivers
#

#
# Passive cards
#
CONFIG_ISDN_DRV_HISAX=m

#
# D-channel protocol features
#
CONFIG_HISAX_EURO=y
CONFIG_DE_AOC=y
CONFIG_HISAX_NO_SENDCOMPLETE=y
CONFIG_HISAX_NO_LLC=y
CONFIG_HISAX_NO_KEYPAD=y
CONFIG_HISAX_1TR6=y
CONFIG_HISAX_NI1=y
CONFIG_HISAX_MAX_CARDS=8

#
# HiSax supported cards
#
CONFIG_HISAX_16_3=y
CONFIG_HISAX_TELESPCI=y
CONFIG_HISAX_S0BOX=y
CONFIG_HISAX_FRITZPCI=y
CONFIG_HISAX_AVM_A1_PCMCIA=y
CONFIG_HISAX_ELSA=y
CONFIG_HISAX_DIEHLDIVA=y
CONFIG_HISAX_SEDLBAUER=y
CONFIG_HISAX_NETJET=y
CONFIG_HISAX_NETJET_U=y
CONFIG_HISAX_NICCY=y
CONFIG_HISAX_BKM_A4T=y
CONFIG_HISAX_SCT_QUADRO=y
CONFIG_HISAX_GAZEL=y
CONFIG_HISAX_HFC_PCI=y
CONFIG_HISAX_W6692=y
CONFIG_HISAX_HFC_SX=y
CONFIG_HISAX_ENTERNOW_PCI=y
# CONFIG_HISAX_DEBUG is not set

#
# HiSax PCMCIA card service modules
#
CONFIG_HISAX_SEDLBAUER_CS=m
CONFIG_HISAX_ELSA_CS=m
CONFIG_HISAX_AVM_A1_CS=m
CONFIG_HISAX_TELES_CS=m

#
# HiSax sub driver modules
#
CONFIG_HISAX_ST5481=m
# CONFIG_HISAX_HFCUSB is not set
CONFIG_HISAX_HFC4S8S=m
CONFIG_HISAX_FRITZ_PCIPNP=m
CONFIG_HISAX_HDLC=y

#
# Active cards
#
CONFIG_HYSDN=m
CONFIG_HYSDN_CAPI=y
CONFIG_ISDN_DRV_GIGASET=m
CONFIG_GIGASET_BASE=m
CONFIG_GIGASET_M105=m
CONFIG_GIGASET_M101=m
# CONFIG_GIGASET_DEBUG is not set
# CONFIG_GIGASET_UNDOCREQ is not set
CONFIG_ISDN_CAPI=m
CONFIG_ISDN_DRV_AVMB1_VERBOSE_REASON=y
# CONFIG_CAPI_TRACE is not set
CONFIG_ISDN_CAPI_MIDDLEWARE=y
CONFIG_ISDN_CAPI_CAPI20=m
CONFIG_ISDN_CAPI_CAPIFS_BOOL=y
CONFIG_ISDN_CAPI_CAPIFS=m
CONFIG_ISDN_CAPI_CAPIDRV=m

#
# CAPI hardware drivers
#
CONFIG_CAPI_AVM=y
CONFIG_ISDN_DRV_AVMB1_B1PCI=m
CONFIG_ISDN_DRV_AVMB1_B1PCIV4=y
CONFIG_ISDN_DRV_AVMB1_B1PCMCIA=m
CONFIG_ISDN_DRV_AVMB1_AVM_CS=m
CONFIG_ISDN_DRV_AVMB1_T1PCI=m
CONFIG_ISDN_DRV_AVMB1_C4=m
# CONFIG_CAPI_EICON is not set
# CONFIG_PHONE is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=y
CONFIG_INPUT_POLLDEV=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=y
# CONFIG_INPUT_MOUSEDEV_PSAUX is not set
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
CONFIG_INPUT_EVDEV=y
# CONFIG_INPUT_EVBUG is not set
CONFIG_XEN_KBDDEV_FRONTEND=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_MOUSE_PS2_ALPS=y
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
CONFIG_MOUSE_PS2_TRACKPOINT=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
CONFIG_MOUSE_SERIAL=m
CONFIG_MOUSE_APPLETOUCH=m
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
CONFIG_INPUT_JOYSTICK=y
CONFIG_JOYSTICK_ANALOG=m
CONFIG_JOYSTICK_A3D=m
CONFIG_JOYSTICK_ADI=m
CONFIG_JOYSTICK_COBRA=m
CONFIG_JOYSTICK_GF2K=m
CONFIG_JOYSTICK_GRIP=m
CONFIG_JOYSTICK_GRIP_MP=m
CONFIG_JOYSTICK_GUILLEMOT=m
CONFIG_JOYSTICK_INTERACT=m
CONFIG_JOYSTICK_SIDEWINDER=m
CONFIG_JOYSTICK_TMDC=m
CONFIG_JOYSTICK_IFORCE=m
CONFIG_JOYSTICK_IFORCE_USB=y
CONFIG_JOYSTICK_IFORCE_232=y
CONFIG_JOYSTICK_WARRIOR=m
CONFIG_JOYSTICK_MAGELLAN=m
CONFIG_JOYSTICK_SPACEORB=m
CONFIG_JOYSTICK_SPACEBALL=m
CONFIG_JOYSTICK_STINGER=m
CONFIG_JOYSTICK_TWIDJOY=m
CONFIG_JOYSTICK_ZHENHUA=m
CONFIG_JOYSTICK_DB9=m
CONFIG_JOYSTICK_GAMECON=m
CONFIG_JOYSTICK_TURBOGRAFX=m
CONFIG_JOYSTICK_JOYDUMP=m
CONFIG_JOYSTICK_XPAD=m
CONFIG_JOYSTICK_XPAD_FF=y
CONFIG_JOYSTICK_XPAD_LEDS=y
CONFIG_INPUT_TABLET=y
CONFIG_TABLET_USB_ACECAD=m
CONFIG_TABLET_USB_AIPTEK=m
CONFIG_TABLET_USB_GTCO=m
CONFIG_TABLET_USB_KBTAB=m
CONFIG_TABLET_USB_WACOM=m
CONFIG_INPUT_TOUCHSCREEN=y
CONFIG_TOUCHSCREEN_FUJITSU=m
CONFIG_TOUCHSCREEN_GUNZE=m
CONFIG_TOUCHSCREEN_ELO=m
CONFIG_TOUCHSCREEN_MTOUCH=m
CONFIG_TOUCHSCREEN_INEXIO=m
CONFIG_TOUCHSCREEN_MK712=m
CONFIG_TOUCHSCREEN_PENMOUNT=m
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
CONFIG_TOUCHSCREEN_TOUCHWIN=m
CONFIG_TOUCHSCREEN_UCB1400=m
# CONFIG_TOUCHSCREEN_WM97XX is not set
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
CONFIG_TOUCHSCREEN_USB_EGALAX=y
CONFIG_TOUCHSCREEN_USB_PANJIT=y
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
CONFIG_TOUCHSCREEN_USB_GUNZE=y
CONFIG_TOUCHSCREEN_USB_DMC_TSC10=y
CONFIG_TOUCHSCREEN_USB_IRTOUCH=y
CONFIG_TOUCHSCREEN_USB_IDEALTEK=y
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
CONFIG_TOUCHSCREEN_USB_GOTOP=y
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_PCSPKR=m
CONFIG_INPUT_APANEL=m
CONFIG_INPUT_ATLAS_BTNS=m
CONFIG_INPUT_ATI_REMOTE=m
CONFIG_INPUT_ATI_REMOTE2=m
CONFIG_INPUT_KEYSPAN_REMOTE=m
CONFIG_INPUT_POWERMATE=m
CONFIG_INPUT_YEALINK=m
CONFIG_INPUT_UINPUT=m

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
# CONFIG_SERIO_CT82C710 is not set
# CONFIG_SERIO_PARKBD is not set
# CONFIG_SERIO_PCIPS2 is not set
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=m
CONFIG_GAMEPORT=m
CONFIG_GAMEPORT_NS558=m
CONFIG_GAMEPORT_L4=m
CONFIG_GAMEPORT_EMU10K1=m
CONFIG_GAMEPORT_FM801=m

#
# Character devices
#
CONFIG_VT=y
CONFIG_CONSOLE_TRANSLATIONS=y
CONFIG_VT_CONSOLE=y
CONFIG_HW_CONSOLE=y
CONFIG_VT_HW_CONSOLE_BINDING=y
# CONFIG_DEVKMEM is not set
CONFIG_SERIAL_NONSTANDARD=y
# CONFIG_COMPUTONE is not set
CONFIG_ROCKETPORT=m
CONFIG_CYCLADES=m
# CONFIG_CYZ_INTR is not set
# CONFIG_DIGIEPCA is not set
# CONFIG_MOXA_INTELLIO is not set
# CONFIG_MOXA_SMARTIO is not set
# CONFIG_ISI is not set
CONFIG_SYNCLINK=m
CONFIG_SYNCLINKMP=m
CONFIG_SYNCLINK_GT=m
CONFIG_N_HDLC=m
# CONFIG_RISCOM8 is not set
# CONFIG_SPECIALIX is not set
# CONFIG_SX is not set
# CONFIG_RIO is not set
# CONFIG_STALDRV is not set
CONFIG_NOZOMI=m

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CS=m
CONFIG_SERIAL_8250_NR_UARTS=32
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
CONFIG_SERIAL_8250_EXTENDED=y
CONFIG_SERIAL_8250_MANY_PORTS=y
CONFIG_SERIAL_8250_SHARE_IRQ=y
CONFIG_SERIAL_8250_DETECT_IRQ=y
CONFIG_SERIAL_8250_RSA=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
CONFIG_SERIAL_JSM=m
CONFIG_UNIX98_PTYS=y
# CONFIG_LEGACY_PTYS is not set
CONFIG_PRINTER=m
CONFIG_LP_CONSOLE=y
CONFIG_PPDEV=m
CONFIG_HVC_DRIVER=y
CONFIG_HVC_IRQ=y
CONFIG_HVC_XEN=y
CONFIG_VIRTIO_CONSOLE=m
CONFIG_IPMI_HANDLER=m
# CONFIG_IPMI_PANIC_EVENT is not set
CONFIG_IPMI_DEVICE_INTERFACE=m
CONFIG_IPMI_SI=m
CONFIG_IPMI_WATCHDOG=m
CONFIG_IPMI_POWEROFF=m
CONFIG_HW_RANDOM=y
CONFIG_HW_RANDOM_INTEL=m
CONFIG_HW_RANDOM_AMD=m
CONFIG_HW_RANDOM_VIRTIO=m
CONFIG_NVRAM=y
CONFIG_R3964=m
# CONFIG_APPLICOM is not set

#
# PCMCIA character devices
#
# CONFIG_SYNCLINK_CS is not set
CONFIG_CARDMAN_4000=m
CONFIG_CARDMAN_4040=m
CONFIG_IPWIRELESS=m
CONFIG_MWAVE=m
# CONFIG_PC8736x_GPIO is not set
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=8192
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
CONFIG_TCG_NSC=m
CONFIG_TCG_ATMEL=m
CONFIG_TCG_INFINEON=m
CONFIG_TELCLOCK=m
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
CONFIG_I2C_CHARDEV=m
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_ALGOBIT=m
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
# CONFIG_I2C_ALI1563 is not set
# CONFIG_I2C_ALI15X3 is not set
CONFIG_I2C_AMD756=m
CONFIG_I2C_AMD756_S4882=m
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
CONFIG_I2C_PIIX4=m
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_NFORCE2_S4985=m
# CONFIG_I2C_SIS5595 is not set
# CONFIG_I2C_SIS630 is not set
CONFIG_I2C_SIS96X=m
CONFIG_I2C_VIA=m
CONFIG_I2C_VIAPRO=m

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_OCORES is not set
CONFIG_I2C_SIMTEC=m

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=m
CONFIG_I2C_PARPORT_LIGHT=m
# CONFIG_I2C_TAOS_EVM is not set
CONFIG_I2C_TINY_USB=m

#
# Graphics adapter I2C/DDC channel drivers
#
CONFIG_I2C_VOODOO3=m

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_PCA_PLATFORM=m
CONFIG_I2C_STUB=m

#
# Miscellaneous I2C Chip support
#
# CONFIG_DS1682 is not set
CONFIG_AT24=m
CONFIG_SENSORS_EEPROM=m
CONFIG_SENSORS_PCF8574=m
CONFIG_PCF8575=m
CONFIG_SENSORS_PCA9539=m
CONFIG_SENSORS_PCF8591=m
CONFIG_SENSORS_MAX6875=m
CONFIG_SENSORS_TSL2550=m
# CONFIG_I2C_DEBUG_CORE is not set
# CONFIG_I2C_DEBUG_ALGO is not set
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_I2C_DEBUG_CHIP is not set
# CONFIG_SPI is not set
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
# CONFIG_GPIOLIB is not set
CONFIG_W1=m
CONFIG_W1_CON=y

#
# 1-wire Bus Masters
#
# CONFIG_W1_MASTER_MATROX is not set
CONFIG_W1_MASTER_DS2490=m
CONFIG_W1_MASTER_DS2482=m

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=m
CONFIG_W1_SLAVE_SMEM=m
CONFIG_W1_SLAVE_DS2433=m
CONFIG_W1_SLAVE_DS2433_CRC=y
CONFIG_W1_SLAVE_DS2760=m
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
# CONFIG_BATTERY_DS2760 is not set
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
CONFIG_SENSORS_AD7414=m
CONFIG_SENSORS_AD7418=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
CONFIG_SENSORS_ADM1026=m
CONFIG_SENSORS_ADM1029=m
CONFIG_SENSORS_ADM1031=m
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7473=m
CONFIG_SENSORS_K8TEMP=m
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_I5K_AMB=m
CONFIG_SENSORS_F71805F=m
CONFIG_SENSORS_F71882FG=m
CONFIG_SENSORS_F75375S=m
CONFIG_SENSORS_FSCHER=m
CONFIG_SENSORS_FSCPOS=m
CONFIG_SENSORS_FSCHMD=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IBMAEM=m
CONFIG_SENSORS_IBMPEX=m
CONFIG_SENSORS_IT87=m
CONFIG_SENSORS_LM63=m
CONFIG_SENSORS_LM75=m
CONFIG_SENSORS_LM77=m
CONFIG_SENSORS_LM78=m
CONFIG_SENSORS_LM80=m
CONFIG_SENSORS_LM83=m
CONFIG_SENSORS_LM85=m
CONFIG_SENSORS_LM87=m
CONFIG_SENSORS_LM90=m
CONFIG_SENSORS_LM92=m
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_MAX1619=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_PC87360=m
CONFIG_SENSORS_PC87427=m
CONFIG_SENSORS_SIS5595=m
CONFIG_SENSORS_DME1737=m
CONFIG_SENSORS_SMSC47M1=m
CONFIG_SENSORS_SMSC47M192=m
CONFIG_SENSORS_SMSC47B397=m
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_THMC50=m
CONFIG_SENSORS_VIA686A=m
CONFIG_SENSORS_VT1211=m
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
CONFIG_SENSORS_W83791D=m
CONFIG_SENSORS_W83792D=m
CONFIG_SENSORS_W83793=m
CONFIG_SENSORS_W83L785TS=m
CONFIG_SENSORS_W83L786NG=m
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_HDAPS=m
CONFIG_SENSORS_APPLESMC=m
# CONFIG_HWMON_DEBUG_CHIP is not set
CONFIG_THERMAL=y
CONFIG_WATCHDOG=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
CONFIG_SOFT_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
CONFIG_ALIM7101_WDT=m
# CONFIG_SC520_WDT is not set
# CONFIG_EUROTECH_WDT is not set
# CONFIG_IB700_WDT is not set
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
CONFIG_I6300ESB_WDT=m
CONFIG_ITCO_WDT=m
CONFIG_ITCO_VENDOR_SUPPORT=y
CONFIG_IT8712F_WDT=m
CONFIG_HP_WATCHDOG=m
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_60XX_WDT is not set
# CONFIG_SBC8360_WDT is not set
# CONFIG_CPU5_WDT is not set
# CONFIG_SMSC37B787_WDT is not set
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
# CONFIG_SBC_EPX_C3_WATCHDOG is not set

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m
CONFIG_WDT_501_PCI=y

#
# USB-based Watchdog Cards
#
CONFIG_USBPCWATCHDOG=m

#
# Sonics Silicon Backplane
#
CONFIG_SSB_POSSIBLE=y
CONFIG_SSB=m
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
# CONFIG_SSB_DEBUG is not set
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y

#
# Multifunction device drivers
#
# CONFIG_MFD_CORE is not set
CONFIG_MFD_SM501=m
# CONFIG_HTC_PASIC3 is not set
# CONFIG_MFD_TMIO is not set

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2060=m
CONFIG_MEDIA_TUNER_MT2266=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_QT1010=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_MEDIA_TUNER_MXL5007T=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_VMALLOC=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_HELPER_CHIPS_AUTO is not set
CONFIG_VIDEO_IR_I2C=m

#
# Encoders/decoders and other helper chips
#

#
# Audio decoders
#
CONFIG_VIDEO_TVAUDIO=m
CONFIG_VIDEO_TDA7432=m
CONFIG_VIDEO_TDA9840=m
CONFIG_VIDEO_TDA9875=m
CONFIG_VIDEO_TEA6415C=m
CONFIG_VIDEO_TEA6420=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_TLV320AIC23B=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m

#
# Video decoders
#
CONFIG_VIDEO_BT819=m
CONFIG_VIDEO_BT856=m
CONFIG_VIDEO_BT866=m
CONFIG_VIDEO_KS0127=m
CONFIG_VIDEO_OV7670=m
CONFIG_VIDEO_TCM825X=m
CONFIG_VIDEO_SAA7110=m
CONFIG_VIDEO_SAA7111=m
CONFIG_VIDEO_SAA7114=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_SAA7191=m
CONFIG_VIDEO_TVP5150=m
CONFIG_VIDEO_VPX3220=m

#
# Video and audio decoders
#
CONFIG_VIDEO_CX25840=m

#
# MPEG video encoders
#
CONFIG_VIDEO_CX2341X=m

#
# Video encoders
#
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_SAA7185=m
CONFIG_VIDEO_ADV7170=m
CONFIG_VIDEO_ADV7175=m

#
# Video improvement chips
#
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
# CONFIG_VIDEO_VIVI is not set
CONFIG_VIDEO_BT848=m
CONFIG_VIDEO_BT848_DVB=y
CONFIG_VIDEO_SAA6588=m
CONFIG_VIDEO_BWQCAM=m
CONFIG_VIDEO_CQCAM=m
CONFIG_VIDEO_W9966=m
CONFIG_VIDEO_CPIA=m
CONFIG_VIDEO_CPIA_PP=m
CONFIG_VIDEO_CPIA_USB=m
CONFIG_VIDEO_CPIA2=m
CONFIG_VIDEO_SAA5246A=m
CONFIG_VIDEO_SAA5249=m
CONFIG_TUNER_3036=m
CONFIG_VIDEO_STRADIS=m
CONFIG_VIDEO_ZORAN=m
CONFIG_VIDEO_ZORAN_DC30=m
CONFIG_VIDEO_ZORAN_ZR36060=m
CONFIG_VIDEO_ZORAN_BUZ=m
CONFIG_VIDEO_ZORAN_DC10=m
CONFIG_VIDEO_ZORAN_LML33=m
CONFIG_VIDEO_ZORAN_LML33R10=m
CONFIG_VIDEO_ZORAN_AVS6EYES=m
CONFIG_VIDEO_MEYE=m
CONFIG_VIDEO_SAA7134=m
CONFIG_VIDEO_SAA7134_ALSA=m
CONFIG_VIDEO_SAA7134_DVB=m
CONFIG_VIDEO_MXB=m
CONFIG_VIDEO_DPC=m
CONFIG_VIDEO_HEXIUM_ORION=m
CONFIG_VIDEO_HEXIUM_GEMINI=m
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
CONFIG_VIDEO_AU0828=m
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
# CONFIG_VIDEO_CAFE_CCIC is not set
CONFIG_V4L_USB_DRIVERS=y
CONFIG_USB_VIDEO_CLASS=m
CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
CONFIG_USB_GSPCA=m
CONFIG_VIDEO_PVRUSB2=m
CONFIG_VIDEO_PVRUSB2_SYSFS=y
CONFIG_VIDEO_PVRUSB2_DVB=y
# CONFIG_VIDEO_PVRUSB2_DEBUGIFC is not set
CONFIG_VIDEO_EM28XX=m
CONFIG_VIDEO_EM28XX_ALSA=m
CONFIG_VIDEO_EM28XX_DVB=m
CONFIG_VIDEO_USBVISION=m
CONFIG_VIDEO_USBVIDEO=m
CONFIG_USB_VICAM=m
CONFIG_USB_IBMCAM=m
CONFIG_USB_KONICAWC=m
CONFIG_USB_QUICKCAM_MESSENGER=m
CONFIG_USB_ET61X251=m
CONFIG_VIDEO_OVCAMCHIP=m
CONFIG_USB_W9968CF=m
CONFIG_USB_OV511=m
CONFIG_USB_SE401=m
CONFIG_USB_SN9C102=m
CONFIG_USB_STV680=m
# CONFIG_USB_ZC0301 is not set
CONFIG_USB_PWC=m
# CONFIG_USB_PWC_DEBUG is not set
CONFIG_USB_ZR364XX=m
CONFIG_USB_STKWEBCAM=m
CONFIG_USB_S2255=m
CONFIG_SOC_CAMERA=m
CONFIG_SOC_CAMERA_MT9M001=m
CONFIG_SOC_CAMERA_MT9V022=m
CONFIG_SOC_CAMERA_PLATFORM=m
# CONFIG_VIDEO_SH_MOBILE_CEU is not set
CONFIG_RADIO_ADAPTERS=y
CONFIG_RADIO_GEMTEK_PCI=m
CONFIG_RADIO_MAXIRADIO=m
CONFIG_RADIO_MAESTRO=m
CONFIG_USB_DSBR=m
CONFIG_USB_SI470X=m
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
CONFIG_DVB_AV7110=m
CONFIG_DVB_AV7110_OSD=y
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m
CONFIG_DVB_BUDGET_PATCH=m

#
# Supported USB Adapters
#
CONFIG_DVB_USB=m
# CONFIG_DVB_USB_DEBUG is not set
CONFIG_DVB_USB_A800=m
CONFIG_DVB_USB_DIBUSB_MB=m
# CONFIG_DVB_USB_DIBUSB_MB_FAULTY is not set
CONFIG_DVB_USB_DIBUSB_MC=m
CONFIG_DVB_USB_DIB0700=m
CONFIG_DVB_USB_UMT_010=m
CONFIG_DVB_USB_CXUSB=m
CONFIG_DVB_USB_M920X=m
CONFIG_DVB_USB_GL861=m
CONFIG_DVB_USB_AU6610=m
CONFIG_DVB_USB_DIGITV=m
CONFIG_DVB_USB_VP7045=m
CONFIG_DVB_USB_VP702X=m
CONFIG_DVB_USB_GP8PSK=m
CONFIG_DVB_USB_NOVA_T_USB2=m
CONFIG_DVB_USB_TTUSB2=m
CONFIG_DVB_USB_DTT200U=m
CONFIG_DVB_USB_OPERA1=m
CONFIG_DVB_USB_AF9005=m
CONFIG_DVB_USB_AF9005_REMOTE=m
CONFIG_DVB_USB_DW2102=m
CONFIG_DVB_USB_ANYSEE=m
CONFIG_DVB_TTUSB_BUDGET=m
CONFIG_DVB_TTUSB_DEC=m
CONFIG_DVB_CINERGYT2=m
CONFIG_DVB_CINERGYT2_TUNING=y
CONFIG_DVB_CINERGYT2_STREAM_URB_COUNT=32
CONFIG_DVB_CINERGYT2_STREAM_BUF_SIZE=512
CONFIG_DVB_CINERGYT2_QUERY_INTERVAL=250
CONFIG_DVB_CINERGYT2_ENABLE_RC_INPUT_DEVICE=y
CONFIG_DVB_CINERGYT2_RC_QUERY_INTERVAL=100
CONFIG_DVB_SIANO_SMS1XXX=m
CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS=y

#
# Supported FlexCopII (B2C2) Adapters
#
CONFIG_DVB_B2C2_FLEXCOP=m
CONFIG_DVB_B2C2_FLEXCOP_PCI=m
CONFIG_DVB_B2C2_FLEXCOP_USB=m
# CONFIG_DVB_B2C2_FLEXCOP_DEBUG is not set

#
# Supported BT878 Adapters
#
CONFIG_DVB_BT8XX=m

#
# Supported Pluto2 Adapters
#
CONFIG_DVB_PLUTO2=m

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRX397XD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
CONFIG_DVB_BCM3510=m
CONFIG_DVB_LGDT330X=m
CONFIG_DVB_S5H1409=m
CONFIG_DVB_AU8522=m
CONFIG_DVB_S5H1411=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DAB=y
CONFIG_USB_DABUSB=m

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_AMD64=y
CONFIG_AGP_INTEL=y
CONFIG_AGP_SIS=y
CONFIG_AGP_VIA=y
CONFIG_DRM=m
CONFIG_DRM_TDFX=m
CONFIG_DRM_R128=m
CONFIG_DRM_RADEON=m
CONFIG_DRM_I810=m
CONFIG_DRM_I830=m
CONFIG_DRM_I915=m
CONFIG_DRM_MGA=m
CONFIG_DRM_SIS=m
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
# CONFIG_FB_PM2 is not set
# CONFIG_FB_CYBER2000 is not set
# CONFIG_FB_ARC is not set
# CONFIG_FB_ASILIANT is not set
# CONFIG_FB_IMSTT is not set
CONFIG_FB_VGA16=m
# CONFIG_FB_UVESA is not set
CONFIG_FB_VESA=y
CONFIG_FB_EFI=y
# CONFIG_FB_IMAC is not set
# CONFIG_FB_N411 is not set
# CONFIG_FB_HGA is not set
# CONFIG_FB_S1D13XXX is not set
CONFIG_FB_NVIDIA=m
CONFIG_FB_NVIDIA_I2C=y
# CONFIG_FB_NVIDIA_DEBUG is not set
CONFIG_FB_NVIDIA_BACKLIGHT=y
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_LE80578 is not set
CONFIG_FB_INTEL=m
# CONFIG_FB_INTEL_DEBUG is not set
CONFIG_FB_INTEL_I2C=y
CONFIG_FB_MATROX=m
CONFIG_FB_MATROX_MILLENIUM=y
CONFIG_FB_MATROX_MYSTIQUE=y
CONFIG_FB_MATROX_G=y
CONFIG_FB_MATROX_I2C=m
CONFIG_FB_MATROX_MAVEN=m
CONFIG_FB_MATROX_MULTIHEAD=y
CONFIG_FB_RADEON=m
CONFIG_FB_RADEON_I2C=y
CONFIG_FB_RADEON_BACKLIGHT=y
# CONFIG_FB_RADEON_DEBUG is not set
CONFIG_FB_ATY128=m
CONFIG_FB_ATY128_BACKLIGHT=y
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
CONFIG_FB_ATY_GENERIC_LCD=y
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_SAVAGE=m
CONFIG_FB_SAVAGE_I2C=y
CONFIG_FB_SAVAGE_ACCEL=y
# CONFIG_FB_SIS is not set
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
CONFIG_FB_3DFX_ACCEL=y
CONFIG_FB_VOODOO1=m
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
CONFIG_FB_TRIDENT_ACCEL=y
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_GEODE is not set
CONFIG_FB_SM501=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_XEN_FBDEV_FRONTEND=y
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_PLATFORM=m
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_CORGI is not set
CONFIG_BACKLIGHT_PROGEAR=m
CONFIG_BACKLIGHT_MBP_NVIDIA=m

#
# Display device support
#
CONFIG_DISPLAY_SUPPORT=m

#
# Display hardware drivers
#

#
# Console display driver support
#
CONFIG_VGA_CONSOLE=y
CONFIG_VGACON_SOFT_SCROLLBACK=y
CONFIG_VGACON_SOFT_SCROLLBACK_SIZE=64
CONFIG_VIDEO_SELECT=y
CONFIG_DUMMY_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE=y
CONFIG_FRAMEBUFFER_CONSOLE_DETECT_PRIMARY=y
CONFIG_FRAMEBUFFER_CONSOLE_ROTATION=y
# CONFIG_FONTS is not set
CONFIG_FONT_8x8=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
CONFIG_LOGO_LINUX_CLUT224=y
CONFIG_SOUND=m
CONFIG_SND=m
CONFIG_SND_TIMER=m
CONFIG_SND_PCM=m
CONFIG_SND_HWDEP=m
CONFIG_SND_RAWMIDI=m
CONFIG_SND_SEQUENCER=m
CONFIG_SND_SEQ_DUMMY=m
CONFIG_SND_OSSEMUL=y
CONFIG_SND_MIXER_OSS=m
CONFIG_SND_PCM_OSS=m
CONFIG_SND_PCM_OSS_PLUGINS=y
CONFIG_SND_SEQUENCER_OSS=y
CONFIG_SND_DYNAMIC_MINORS=y
# CONFIG_SND_SUPPORT_OLD_API is not set
CONFIG_SND_VERBOSE_PROCFS=y
CONFIG_SND_VERBOSE_PRINTK=y
CONFIG_SND_DEBUG=y
# CONFIG_SND_DEBUG_VERBOSE is not set
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_SND_VMASTER=y
CONFIG_SND_MPU401_UART=m
CONFIG_SND_OPL3_LIB=m
CONFIG_SND_VX_LIB=m
CONFIG_SND_AC97_CODEC=m
CONFIG_SND_DRIVERS=y
CONFIG_SND_PCSP=m
CONFIG_SND_DUMMY=m
CONFIG_SND_VIRMIDI=m
CONFIG_SND_MTPAV=m
CONFIG_SND_MTS64=m
CONFIG_SND_SERIAL_U16550=m
CONFIG_SND_MPU401=m
CONFIG_SND_PORTMAN2X4=m
CONFIG_SND_AC97_POWER_SAVE=y
CONFIG_SND_AC97_POWER_SAVE_DEFAULT=5
CONFIG_SND_SB_COMMON=m
CONFIG_SND_SB16_DSP=m
CONFIG_SND_PCI=y
CONFIG_SND_AD1889=m
CONFIG_SND_ALS300=m
CONFIG_SND_ALS4000=m
CONFIG_SND_ALI5451=m
CONFIG_SND_ATIIXP=m
CONFIG_SND_ATIIXP_MODEM=m
CONFIG_SND_AU8810=m
CONFIG_SND_AU8820=m
CONFIG_SND_AU8830=m
# CONFIG_SND_AW2 is not set
CONFIG_SND_AZT3328=m
CONFIG_SND_BT87X=m
# CONFIG_SND_BT87X_OVERCLOCK is not set
CONFIG_SND_CA0106=m
CONFIG_SND_CMIPCI=m
CONFIG_SND_OXYGEN_LIB=m
CONFIG_SND_OXYGEN=m
CONFIG_SND_CS4281=m
CONFIG_SND_CS46XX=m
CONFIG_SND_CS46XX_NEW_DSP=y
CONFIG_SND_CS5530=m
CONFIG_SND_DARLA20=m
CONFIG_SND_GINA20=m
CONFIG_SND_LAYLA20=m
CONFIG_SND_DARLA24=m
CONFIG_SND_GINA24=m
CONFIG_SND_LAYLA24=m
CONFIG_SND_MONA=m
CONFIG_SND_MIA=m
CONFIG_SND_ECHO3G=m
CONFIG_SND_INDIGO=m
CONFIG_SND_INDIGOIO=m
CONFIG_SND_INDIGODJ=m
CONFIG_SND_EMU10K1=m
CONFIG_SND_EMU10K1X=m
CONFIG_SND_ENS1370=m
CONFIG_SND_ENS1371=m
CONFIG_SND_ES1938=m
CONFIG_SND_ES1968=m
CONFIG_SND_FM801=m
CONFIG_SND_FM801_TEA575X_BOOL=y
CONFIG_SND_FM801_TEA575X=m
CONFIG_SND_HDA_INTEL=m
CONFIG_SND_HDA_HWDEP=y
CONFIG_SND_HDA_CODEC_REALTEK=y
CONFIG_SND_HDA_CODEC_ANALOG=y
CONFIG_SND_HDA_CODEC_SIGMATEL=y
CONFIG_SND_HDA_CODEC_VIA=y
CONFIG_SND_HDA_CODEC_ATIHDMI=y
CONFIG_SND_HDA_CODEC_CONEXANT=y
CONFIG_SND_HDA_CODEC_CMEDIA=y
CONFIG_SND_HDA_CODEC_SI3054=y
CONFIG_SND_HDA_GENERIC=y
CONFIG_SND_HDA_POWER_SAVE=y
CONFIG_SND_HDA_POWER_SAVE_DEFAULT=0
CONFIG_SND_HDSP=m
CONFIG_SND_HDSPM=m
CONFIG_SND_HIFIER=m
CONFIG_SND_ICE1712=m
CONFIG_SND_ICE1724=m
CONFIG_SND_INTEL8X0=m
CONFIG_SND_INTEL8X0M=m
CONFIG_SND_KORG1212=m
CONFIG_SND_MAESTRO3=m
CONFIG_SND_MIXART=m
CONFIG_SND_NM256=m
CONFIG_SND_PCXHR=m
CONFIG_SND_RIPTIDE=m
CONFIG_SND_RME32=m
CONFIG_SND_RME96=m
CONFIG_SND_RME9652=m
CONFIG_SND_SONICVIBES=m
CONFIG_SND_TRIDENT=m
CONFIG_SND_VIA82XX=m
CONFIG_SND_VIA82XX_MODEM=m
CONFIG_SND_VIRTUOSO=m
CONFIG_SND_VX222=m
CONFIG_SND_YMFPCI=m
CONFIG_SND_USB=y
CONFIG_SND_USB_AUDIO=m
CONFIG_SND_USB_USX2Y=m
CONFIG_SND_USB_CAIAQ=m
CONFIG_SND_USB_CAIAQ_INPUT=y
# CONFIG_SND_PCMCIA is not set
# CONFIG_SND_SOC is not set
# CONFIG_SOUND_PRIME is not set
CONFIG_AC97_BUS=m
CONFIG_HID_SUPPORT=y
CONFIG_HID=y
CONFIG_HID_DEBUG=y
CONFIG_HIDRAW=y

#
# USB Input Devices
#
CONFIG_USB_HID=y
CONFIG_USB_HIDINPUT_POWERBOOK=y
CONFIG_HID_FF=y
CONFIG_HID_PID=y
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_PANTHERLORD_FF=y
CONFIG_THRUSTMASTER_FF=y
CONFIG_ZEROPLUS_FF=y
CONFIG_USB_HIDDEV=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB=y
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set
CONFIG_USB_MON=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
# CONFIG_USB_ISP116X_HCD is not set
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_OHCI_HCD=y
# CONFIG_USB_OHCI_BIG_ENDIAN_DESC is not set
# CONFIG_USB_OHCI_BIG_ENDIAN_MMIO is not set
CONFIG_USB_OHCI_LITTLE_ENDIAN=y
CONFIG_USB_UHCI_HCD=y
CONFIG_USB_U132_HCD=m
CONFIG_USB_SL811_HCD=m
# CONFIG_USB_SL811_CS is not set
# CONFIG_USB_R8A66597_HCD is not set

#
# USB Device Class drivers
#
CONFIG_USB_ACM=m
CONFIG_USB_PRINTER=m
CONFIG_USB_WDM=m

#
# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
#

#
# may also be needed; see USB_STORAGE Help for more information
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
CONFIG_USB_STORAGE_DATAFAB=y
CONFIG_USB_STORAGE_FREECOM=y
CONFIG_USB_STORAGE_ISD200=y
CONFIG_USB_STORAGE_DPCM=y
CONFIG_USB_STORAGE_USBAT=y
CONFIG_USB_STORAGE_SDDR09=y
CONFIG_USB_STORAGE_SDDR55=y
CONFIG_USB_STORAGE_JUMPSHOT=y
CONFIG_USB_STORAGE_ALAUDA=y
CONFIG_USB_STORAGE_ONETOUCH=y
CONFIG_USB_STORAGE_KARMA=y
CONFIG_USB_STORAGE_CYPRESS_ATACB=y
# CONFIG_USB_LIBUSUAL is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
CONFIG_USB_MICROTEK=m

#
# USB port drivers
#
CONFIG_USB_USS720=m
CONFIG_USB_SERIAL=m
CONFIG_USB_EZUSB=y
CONFIG_USB_SERIAL_GENERIC=y
CONFIG_USB_SERIAL_AIRCABLE=m
CONFIG_USB_SERIAL_ARK3116=m
CONFIG_USB_SERIAL_BELKIN=m
CONFIG_USB_SERIAL_CH341=m
CONFIG_USB_SERIAL_WHITEHEAT=m
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
CONFIG_USB_SERIAL_CP2101=m
CONFIG_USB_SERIAL_CYPRESS_M8=m
CONFIG_USB_SERIAL_EMPEG=m
CONFIG_USB_SERIAL_FTDI_SIO=m
CONFIG_USB_SERIAL_FUNSOFT=m
CONFIG_USB_SERIAL_VISOR=m
CONFIG_USB_SERIAL_IPAQ=m
CONFIG_USB_SERIAL_IR=m
CONFIG_USB_SERIAL_EDGEPORT=m
CONFIG_USB_SERIAL_EDGEPORT_TI=m
# CONFIG_USB_SERIAL_GARMIN is not set
CONFIG_USB_SERIAL_IPW=m
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
CONFIG_USB_SERIAL_KEYSPAN=m
CONFIG_USB_SERIAL_KLSI=m
CONFIG_USB_SERIAL_KOBIL_SCT=m
CONFIG_USB_SERIAL_MCT_U232=m
CONFIG_USB_SERIAL_MOS7720=m
CONFIG_USB_SERIAL_MOS7840=m
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
CONFIG_USB_SERIAL_SPCP8X5=m
CONFIG_USB_SERIAL_HP4X=m
CONFIG_USB_SERIAL_SAFE=m
CONFIG_USB_SERIAL_SAFE_PADDED=y
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
CONFIG_USB_SERIAL_XIRCOM=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
CONFIG_USB_SERIAL_DEBUG=m

#
# USB Miscellaneous drivers
#
CONFIG_USB_EMI62=m
CONFIG_USB_EMI26=m
CONFIG_USB_ADUTUX=m
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
CONFIG_USB_BERRY_CHARGE=m
CONFIG_USB_LED=m
# CONFIG_USB_CYPRESS_CY7C63 is not set
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_PHIDGET=m
CONFIG_USB_PHIDGETKIT=m
CONFIG_USB_PHIDGETMOTORCONTROL=m
CONFIG_USB_PHIDGETSERVO=m
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
CONFIG_USB_APPLEDISPLAY=m
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_SISUSBVGA_CON=y
CONFIG_USB_LD=m
CONFIG_USB_TRANCEVIBRATOR=m
CONFIG_USB_IOWARRIOR=m
# CONFIG_USB_TEST is not set
CONFIG_USB_ISIGHTFW=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
CONFIG_USB_UEAGLEATM=m
CONFIG_USB_XUSBATM=m
# CONFIG_USB_GADGET is not set
CONFIG_MMC=m
# CONFIG_MMC_DEBUG is not set
# CONFIG_MMC_UNSAFE_RESUME is not set

#
# MMC/SD Card Drivers
#
CONFIG_MMC_BLOCK=m
CONFIG_MMC_BLOCK_BOUNCE=y
CONFIG_SDIO_UART=m
# CONFIG_MMC_TEST is not set

#
# MMC/SD Host Controller Drivers
#
CONFIG_MMC_SDHCI=m
CONFIG_MMC_SDHCI_PCI=m
CONFIG_MMC_RICOH_MMC=m
CONFIG_MMC_WBSD=m
CONFIG_MMC_TIFM_SD=m
CONFIG_MMC_SDRICOH_CS=m
CONFIG_MEMSTICK=m
# CONFIG_MEMSTICK_DEBUG is not set

#
# MemoryStick drivers
#
# CONFIG_MEMSTICK_UNSAFE_RESUME is not set
CONFIG_MSPRO_BLOCK=m

#
# MemoryStick Host Controller Drivers
#
CONFIG_MEMSTICK_TIFM_MS=m
CONFIG_MEMSTICK_JMICRON_38X=m
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_CLEVO_MAIL=m
# CONFIG_LEDS_PCA955X is not set

#
# LED Triggers
#
CONFIG_LEDS_TRIGGERS=y
CONFIG_LEDS_TRIGGER_TIMER=m
CONFIG_LEDS_TRIGGER_HEARTBEAT=m
CONFIG_LEDS_TRIGGER_DEFAULT_ON=m
CONFIG_ACCESSIBILITY=y
CONFIG_A11Y_BRAILLE_CONSOLE=y
CONFIG_INFINIBAND=m
CONFIG_INFINIBAND_USER_MAD=m
CONFIG_INFINIBAND_USER_ACCESS=m
CONFIG_INFINIBAND_USER_MEM=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPATH=m
CONFIG_INFINIBAND_AMSO1100=m
# CONFIG_INFINIBAND_AMSO1100_DEBUG is not set
CONFIG_INFINIBAND_CXGB3=m
# CONFIG_INFINIBAND_CXGB3_DEBUG is not set
CONFIG_MLX4_INFINIBAND=m
CONFIG_INFINIBAND_NES=m
# CONFIG_INFINIBAND_NES_DEBUG is not set
CONFIG_INFINIBAND_IPOIB=m
CONFIG_INFINIBAND_IPOIB_CM=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_INFINIBAND_SRP=m
CONFIG_INFINIBAND_ISER=m
CONFIG_EDAC=y

#
# Reporting subsystems
#
# CONFIG_EDAC_DEBUG is not set
CONFIG_EDAC_MM_EDAC=m
CONFIG_EDAC_E752X=m
CONFIG_EDAC_I82975X=m
CONFIG_EDAC_I3000=m
CONFIG_EDAC_I5000=m
CONFIG_EDAC_I5100=m
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_SYSFS=y
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
# CONFIG_RTC_INTF_DEV_UIE_EMUL is not set
# CONFIG_RTC_DRV_TEST is not set

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_DS1307=m
CONFIG_RTC_DRV_DS1374=m
CONFIG_RTC_DRV_DS1672=m
CONFIG_RTC_DRV_MAX6900=m
CONFIG_RTC_DRV_RS5C372=m
CONFIG_RTC_DRV_ISL1208=m
CONFIG_RTC_DRV_X1205=m
CONFIG_RTC_DRV_PCF8563=m
CONFIG_RTC_DRV_PCF8583=m
CONFIG_RTC_DRV_M41T80=m
CONFIG_RTC_DRV_M41T80_WDT=y
# CONFIG_RTC_DRV_S35390A is not set
CONFIG_RTC_DRV_FM3130=m

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
CONFIG_RTC_DRV_CMOS=y
CONFIG_RTC_DRV_DS1511=m
CONFIG_RTC_DRV_DS1553=m
CONFIG_RTC_DRV_DS1742=m
CONFIG_RTC_DRV_STK17TA8=m
# CONFIG_RTC_DRV_M48T86 is not set
CONFIG_RTC_DRV_M48T59=m
CONFIG_RTC_DRV_V3020=m

#
# on-CPU RTC drivers
#
CONFIG_DMADEVICES=y

#
# DMA Devices
#
CONFIG_INTEL_IOATDMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
# CONFIG_DMATEST is not set
CONFIG_DCA=m
CONFIG_AUXDISPLAY=y
CONFIG_KS0108=m
CONFIG_KS0108_PORT=0x378
CONFIG_KS0108_DELAY=2
CONFIG_CFAG12864B=m
CONFIG_CFAG12864B_RATE=20
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_SMX=m
CONFIG_XEN_BALLOON=y
CONFIG_XEN_SCRUB_PAGES=y

#
# Firmware Drivers
#
CONFIG_EDD=m
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
CONFIG_EFI_VARS=y
CONFIG_DELL_RBU=m
CONFIG_DCDBAS=m
CONFIG_DMIID=y
CONFIG_ISCSI_IBFT_FIND=y
CONFIG_ISCSI_IBFT=m

#
# File systems
#
CONFIG_EXT2_FS=m
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT2_FS_POSIX_ACL=y
CONFIG_EXT2_FS_SECURITY=y
CONFIG_EXT2_FS_XIP=y
CONFIG_FS_XIP=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_EXT3_FS_POSIX_ACL=y
CONFIG_EXT3_FS_SECURITY=y
CONFIG_EXT4_FS=m
CONFIG_EXT4DEV_COMPAT=y
CONFIG_EXT4_FS_XATTR=y
CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_JBD2=m
CONFIG_JBD2_DEBUG=y
CONFIG_FS_MBCACHE=y
CONFIG_REISERFS_FS=m
# CONFIG_REISERFS_CHECK is not set
CONFIG_REISERFS_PROC_INFO=y
CONFIG_REISERFS_FS_XATTR=y
CONFIG_REISERFS_FS_POSIX_ACL=y
CONFIG_REISERFS_FS_SECURITY=y
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
CONFIG_JFS_SECURITY=y
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_XFS_FS=m
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
# CONFIG_XFS_RT is not set
# CONFIG_XFS_DEBUG is not set
CONFIG_GFS2_FS=m
CONFIG_GFS2_FS_LOCKING_DLM=m
CONFIG_OCFS2_FS=m
CONFIG_OCFS2_FS_O2CB=m
CONFIG_OCFS2_FS_USERSPACE_CLUSTER=m
# CONFIG_OCFS2_FS_STATS is not set
# CONFIG_OCFS2_DEBUG_MASKLOG is not set
# CONFIG_OCFS2_DEBUG_FS is not set
CONFIG_DNOTIFY=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_QUOTA=y
CONFIG_QUOTA_NETLINK_INTERFACE=y
# CONFIG_PRINT_QUOTA_WARNING is not set
# CONFIG_QFMT_V1 is not set
CONFIG_QFMT_V2=y
CONFIG_QUOTACTL=y
CONFIG_AUTOFS_FS=m
CONFIG_AUTOFS4_FS=m
CONFIG_FUSE_FS=m
CONFIG_GENERIC_ACL=y

#
# CD-ROM/DVD Filesystems
#
CONFIG_ISO9660_FS=y
CONFIG_JOLIET=y
CONFIG_ZISOFS=y
CONFIG_UDF_FS=m
CONFIG_UDF_NLS=y

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
CONFIG_MSDOS_FS=m
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="ascii"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_VMCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
CONFIG_CONFIGFS_FS=m

#
# Miscellaneous filesystems
#
# CONFIG_ADFS_FS is not set
CONFIG_AFFS_FS=m
CONFIG_ECRYPT_FS=m
CONFIG_HFS_FS=m
CONFIG_HFSPLUS_FS=m
CONFIG_BEFS_FS=m
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=m
CONFIG_EFS_FS=m
CONFIG_JFFS2_FS=m
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_JFFS2_FS_WRITEBUFFER=y
# CONFIG_JFFS2_FS_WBUF_VERIFY is not set
CONFIG_JFFS2_SUMMARY=y
CONFIG_JFFS2_FS_XATTR=y
CONFIG_JFFS2_FS_POSIX_ACL=y
CONFIG_JFFS2_FS_SECURITY=y
# CONFIG_JFFS2_COMPRESSION_OPTIONS is not set
CONFIG_JFFS2_ZLIB=y
# CONFIG_JFFS2_LZO is not set
CONFIG_JFFS2_RTIME=y
# CONFIG_JFFS2_RUBIN is not set
CONFIG_UBIFS_FS=m
CONFIG_UBIFS_FS_XATTR=y
# CONFIG_UBIFS_FS_ADVANCED_COMPR is not set
CONFIG_UBIFS_FS_LZO=y
CONFIG_UBIFS_FS_ZLIB=y
# CONFIG_UBIFS_FS_DEBUG is not set
CONFIG_CRAMFS=m
CONFIG_VXFS_FS=m
CONFIG_MINIX_FS=m
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
CONFIG_ROMFS_FS=m
CONFIG_SYSV_FS=m
CONFIG_UFS_FS=m
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_NFS_FS=m
CONFIG_NFS_V3=y
CONFIG_NFS_V3_ACL=y
CONFIG_NFS_V4=y
CONFIG_NFSD=m
CONFIG_NFSD_V2_ACL=y
CONFIG_NFSD_V3=y
CONFIG_NFSD_V3_ACL=y
CONFIG_NFSD_V4=y
CONFIG_LOCKD=m
CONFIG_LOCKD_V4=y
CONFIG_EXPORTFS=m
CONFIG_NFS_ACL_SUPPORT=m
CONFIG_NFS_COMMON=y
CONFIG_SUNRPC=m
CONFIG_SUNRPC_GSS=m
CONFIG_SUNRPC_XPRT_RDMA=m
CONFIG_RPCSEC_GSS_KRB5=m
CONFIG_RPCSEC_GSS_SPKM3=m
# CONFIG_SMB_FS is not set
CONFIG_CIFS=m
# CONFIG_CIFS_STATS is not set
CONFIG_CIFS_WEAK_PW_HASH=y
CONFIG_CIFS_UPCALL=y
CONFIG_CIFS_XATTR=y
CONFIG_CIFS_POSIX=y
# CONFIG_CIFS_DEBUG2 is not set
CONFIG_CIFS_EXPERIMENTAL=y
CONFIG_CIFS_DFS_UPCALL=y
CONFIG_NCP_FS=m
CONFIG_NCPFS_PACKET_SIGNING=y
CONFIG_NCPFS_IOCTL_LOCKING=y
CONFIG_NCPFS_STRONG=y
CONFIG_NCPFS_NFS_NS=y
CONFIG_NCPFS_OS2_NS=y
CONFIG_NCPFS_SMALLDOS=y
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
CONFIG_CODA_FS=m
# CONFIG_AFS_FS is not set
CONFIG_9P_FS=m

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
# CONFIG_ACORN_PARTITION is not set
CONFIG_OSF_PARTITION=y
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
CONFIG_MAC_PARTITION=y
CONFIG_MSDOS_PARTITION=y
CONFIG_BSD_DISKLABEL=y
CONFIG_MINIX_SUBPARTITION=y
CONFIG_SOLARIS_X86_PARTITION=y
CONFIG_UNIXWARE_DISKLABEL=y
# CONFIG_LDM_PARTITION is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
CONFIG_KARMA_PARTITION=y
CONFIG_EFI_PARTITION=y
# CONFIG_SYSV68_PARTITION is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="utf8"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_737=m
CONFIG_NLS_CODEPAGE_775=m
CONFIG_NLS_CODEPAGE_850=m
CONFIG_NLS_CODEPAGE_852=m
CONFIG_NLS_CODEPAGE_855=m
CONFIG_NLS_CODEPAGE_857=m
CONFIG_NLS_CODEPAGE_860=m
CONFIG_NLS_CODEPAGE_861=m
CONFIG_NLS_CODEPAGE_862=m
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
CONFIG_NLS_CODEPAGE_866=m
CONFIG_NLS_CODEPAGE_869=m
CONFIG_NLS_CODEPAGE_936=m
CONFIG_NLS_CODEPAGE_950=m
CONFIG_NLS_CODEPAGE_932=m
CONFIG_NLS_CODEPAGE_949=m
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
CONFIG_NLS_CODEPAGE_1250=m
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
CONFIG_NLS_ISO8859_6=m
CONFIG_NLS_ISO8859_7=m
CONFIG_NLS_ISO8859_9=m
CONFIG_NLS_ISO8859_13=m
CONFIG_NLS_ISO8859_14=m
CONFIG_NLS_ISO8859_15=m
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
CONFIG_NLS_UTF8=m
CONFIG_DLM=m
CONFIG_DLM_DEBUG=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
# CONFIG_PRINTK_TIME is not set
# CONFIG_ENABLE_WARN_DEPRECATED is not set
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
CONFIG_HEADERS_CHECK=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_DETECT_SOFTLOCKUP=y
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set
# CONFIG_DEBUG_PREEMPT is not set
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
# CONFIG_DEBUG_SPINLOCK is not set
# CONFIG_DEBUG_MUTEXES is not set
# CONFIG_DEBUG_LOCK_ALLOC is not set
# CONFIG_PROVE_LOCKING is not set
# CONFIG_LOCK_STAT is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
# CONFIG_DEBUG_VM is not set
# CONFIG_DEBUG_WRITECOUNT is not set
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
# CONFIG_DEBUG_SG is not set
CONFIG_FRAME_POINTER=y
CONFIG_BOOT_PRINTK_DELAY=y
# CONFIG_RCU_TORTURE_TEST is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
# CONFIG_LKDTM is not set
# CONFIG_FAULT_INJECTION is not set
CONFIG_LATENCYTOP=y
# CONFIG_SYSCTL_SYSCALL_CHECK is not set
CONFIG_HAVE_FTRACE=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_TRACING=y
# CONFIG_FTRACE is not set
CONFIG_IRQSOFF_TRACER=y
# CONFIG_PREEMPT_TRACER is not set
CONFIG_SYSPROF_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_CONTEXT_SWITCH_TRACER=y
# CONFIG_FTRACE_STARTUP_TEST is not set
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
CONFIG_BUILD_DOCSRC=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
CONFIG_KGDB_TESTS=y
# CONFIG_KGDB_TESTS_ON_BOOT is not set
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
CONFIG_DEBUG_STACKOVERFLOW=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_PAGEALLOC is not set
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_X86_PTDUMP is not set
CONFIG_DEBUG_RODATA=y
CONFIG_DIRECT_GBPAGES=y
# CONFIG_DEBUG_RODATA_TEST is not set
# CONFIG_DEBUG_NX_TEST is not set
# CONFIG_IOMMU_DEBUG is not set
# CONFIG_MMIOTRACE is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
CONFIG_IO_DELAY_0X80=y
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
# CONFIG_IO_DELAY_NONE is not set
CONFIG_DEFAULT_IO_DELAY_TYPE=0
CONFIG_DEBUG_BOOT_PARAMS=y
# CONFIG_CPA_DEBUG is not set
CONFIG_OPTIMIZE_INLINING=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY=y
CONFIG_SECURITY_NETWORK=y
CONFIG_SECURITY_NETWORK_XFRM=y
CONFIG_SECURITY_FILE_CAPABILITIES=y
# CONFIG_SECURITY_ROOTPLUG is not set
CONFIG_SECURITY_SELINUX=y
CONFIG_SECURITY_SELINUX_BOOTPARAM=y
CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
CONFIG_SECURITY_SELINUX_DISABLE=y
CONFIG_SECURITY_SELINUX_DEVELOP=y
CONFIG_SECURITY_SELINUX_AVC_STATS=y
CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT=y
# CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
# CONFIG_SECURITY_SMACK is not set
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_GF128MUL=m
CONFIG_CRYPTO_NULL=m
# CONFIG_CRYPTO_CRYPTD is not set
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
CONFIG_CRYPTO_XCBC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_MD4=m
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=m
CONFIG_CRYPTO_RMD128=m
CONFIG_CRYPTO_RMD160=m
CONFIG_CRYPTO_RMD256=m
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
CONFIG_CRYPTO_WP512=m

#
# Ciphers
#
CONFIG_CRYPTO_AES=m
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_ANUBIS=m
CONFIG_CRYPTO_ARC4=m
CONFIG_CRYPTO_BLOWFISH=m
CONFIG_CRYPTO_CAMELLIA=m
CONFIG_CRYPTO_CAST5=m
CONFIG_CRYPTO_CAST6=m
CONFIG_CRYPTO_DES=m
CONFIG_CRYPTO_FCRYPT=m
CONFIG_CRYPTO_KHAZAD=m
# CONFIG_CRYPTO_SALSA20 is not set
CONFIG_CRYPTO_SALSA20_X86_64=m
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_LZO=m
CONFIG_CRYPTO_HW=y
CONFIG_CRYPTO_DEV_HIFN_795X=m
CONFIG_CRYPTO_DEV_HIFN_795X_RNG=y
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_KVM=m
CONFIG_KVM_INTEL=m
CONFIG_KVM_AMD=m
CONFIG_KVM_TRACE=y
CONFIG_VIRTIO=m
CONFIG_VIRTIO_RING=m
CONFIG_VIRTIO_PCI=m
CONFIG_VIRTIO_BALLOON=m

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_FIND_NEXT_BIT=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=m
CONFIG_LZO_DECOMPRESS=m
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_REED_SOLOMON=m
CONFIG_REED_SOLOMON_DEC16=y
CONFIG_TEXTSEARCH=y
CONFIG_TEXTSEARCH_KMP=m
CONFIG_TEXTSEARCH_BM=m
CONFIG_TEXTSEARCH_FSM=m
CONFIG_PLIST=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y


--------------090708080309010601040509--
