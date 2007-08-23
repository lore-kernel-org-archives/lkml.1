Return-Path: <linux-kernel-owner+w=401wt.eu-S1760661AbXHWT3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661AbXHWT3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754784AbXHWT3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:29:06 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:11135 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbXHWT3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:29:04 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: [patch 1/2] virtual sched_clock() for s390
Date: Thu, 23 Aug 2007 21:28:28 +0200
User-Agent: KMail/1.9.7
Cc: Jan Glauber <jan.glauber@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
References: <200708232126.36475.borntraeger@de.ibm.com>
In-Reply-To: <200708232126.36475.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708232128.28194.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

virtual sched_clock() for s390

From: Jan Glauber <jan.glauber@de.ibm.com> 
From: Christian Borntraeger <borntraeger@de.ibm.com> 

This patch introduces a cpu time clock for s390 (only ticking if
the virtual cpu is running) and bases the s390 implementation of
sched_clock() on it. The patch is a revamped version of an earlier
patch from Jan Glauber.

The time slice length on a virtual cpu can be anything between the
calculated time slice and zero. In reality this doesn't seem to be
problem, since the scheduler is fair enough to not let a single
process starve but the current implementation can lead to inefficient
short time slices.

By providing a 'virtual' sched_clock() we improve the scheduler
fairness, regardless of scheduling decisions from the hypervisor.
We also lay a foundation to base process accouting on virtual cpu
time without CONFIG_VIRT_CPU_ACCOUNTING.


Changes since the last posted version:
o rename cpu_clock to s390_cpu_clock to avoid conflict with sched.c 
o remove local_irq_disable after local_irq_save
o fix calculation of read_timer if multiple timers are present
o change the registration of idle notifier: The s390 nohz and
  virtual timer infrastructure both register at the
  idle notifier. If a cpu returns from idle, start_cpu_timer and 
  start_hz_timer are called. start_hz_timer calls account_ticks,
  which calls account_system_vtime, which calls scheduler_tick, which
  calls sched_clock. A virtual timer based sched_clock implementation
  requires that the virtual timers are active. Thats means: on return
  from idle start_cpu_timer must be called before start_hz_timer.
  Solution is to reverse the notifier_call_chain initialization.
o Change hw clock to ns calculation. 
  old: minimal stepping 1ns,  early overflow
  new: minimal stepping 125ns, late overflow

Patch applies against current 2.6.23-rc3-git.

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
 arch/s390/kernel/time.c  |   30 +++++++++++++++++----------
 arch/s390/kernel/vtime.c |   52 
++++++++++++++++++++++++++++++++++++++++++++---
 include/asm-s390/timer.h |    2 +
 3 files changed, 70 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/s390/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/time.c
+++ linux-2.6/arch/s390/kernel/time.c
@@ -62,21 +62,27 @@ static u64 jiffies_timer_cc;
 static u64 xtime_cc;
 
 /*
- * Scheduler clock - returns current time in nanosec units.
+ * Monotonic_clock - returns # of nanoseconds passed since time_init()
  */
-unsigned long long sched_clock(void)
+unsigned long long monotonic_clock(void)
 {
-	return ((get_clock() - jiffies_timer_cc) * 125) >> 9;
+	return ((get_clock() - jiffies_timer_cc) >> 9) * 125;
 }
+EXPORT_SYMBOL(monotonic_clock);
 
 /*
- * Monotonic_clock - returns # of nanoseconds passed since time_init()
+ * Scheduler clock - returns current time in nanosec units.
+ * Now based on virtual cpu time to only account time the guest
+ * was actually running.
  */
-unsigned long long monotonic_clock(void)
+unsigned long long sched_clock(void)
 {
-	return sched_clock();
+#ifdef CONFIG_VIRT_TIMER
+	return s390_cpu_clock();
+#else
+	return monotonic_clock();
+#endif
 }
-EXPORT_SYMBOL(monotonic_clock);
 
 void tod_to_timeval(__u64 todval, struct timespec *xtime)
 {
@@ -348,13 +354,15 @@ void __init time_init(void)
 	/* Enable TOD clock interrupts on the boot cpu. */
 	init_cpu_timer();
 
-#ifdef CONFIG_NO_IDLE_HZ
-	nohz_init();
-#endif
-
+	/* The virtual timer must be ready on the first tick, therefore,
+	   The vtime notifier callback must be registered first */
 #ifdef CONFIG_VIRT_TIMER
 	vtime_init();
 #endif
+
+#ifdef CONFIG_NO_IDLE_HZ
+	nohz_init();
+#endif
 }
 
 /*
Index: linux-2.6/arch/s390/kernel/vtime.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/vtime.c
+++ linux-2.6/arch/s390/kernel/vtime.c
@@ -3,8 +3,9 @@
  *    Virtual cpu timer based timer functions.
  *
  *  S390 version
- *    Copyright (C) 2004 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Copyright 2004,2007 IBM Corp.
  *    Author(s): Jan Glauber <jan.glauber@de.ibm.com>
+ *               Christian Borntraeger <borntraeger@de.ibm.com>
  */
 
 #include <linux/module.h>
@@ -26,6 +27,44 @@
 
 static ext_int_info_t ext_int_info_timer;
 static DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
+static DEFINE_PER_CPU(struct vtimer_list, cpu_clock_timer);
+
+/*
+ * read the remaining time of a virtual timer running on the current cpu
+ */
+static unsigned long long read_cpu_timer(struct vtimer_list *timer)
+{
+	struct vtimer_queue *vt_list;
+	unsigned long flags;
+	__u64 done;
+
+	local_irq_save(flags);
+
+	BUG_ON(timer->cpu != smp_processor_id());
+
+	vt_list = &per_cpu(virt_cpu_timer, timer->cpu);
+	asm volatile ("STPT %0" : "=m" (done));
+
+	done = timer->expires - vt_list->offset - (vt_list->to_expire - done);
+	local_irq_restore(flags);
+	return done;
+}
+
+/*
+ * Cpu clock, returns cpu time in nanosec units.
+ * Must be called with preemption disabled.
+ */
+unsigned long long s390_cpu_clock(void)
+{
+	__u64 remaining = read_cpu_timer(&__get_cpu_var(cpu_clock_timer));
+	return ((VTIMER_MAX_SLICE - remaining) >> 9) * 125;
+}
+
+/* expire after 142 years ... */
+static void cpu_clock_timer_callback(unsigned long data)
+{
+	BUG();
+}
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 /*
@@ -148,7 +187,7 @@ static void start_cpu_timer(void)
 	vt_list = &__get_cpu_var(virt_cpu_timer);
 
 	/* CPU timer interrupt is pending, don't reprogramm it */
-	if (vt_list->idle & 1LL<<63)
+	if ((s64) vt_list->idle < 0)
 		return;
 
 	if (!list_empty(&vt_list->list))
@@ -174,7 +213,7 @@ static void stop_cpu_timer(void)
 	 * If the CPU timer is negative we don't reprogramm
 	 * it because we will get instantly an interrupt.
 	 */
-	if (vt_list->idle & 1LL<<63)
+	if ((s64) vt_list->idle < 0)
 		return;
 
 	vt_list->offset += vt_list->to_expire - vt_list->idle;
@@ -522,6 +561,7 @@ EXPORT_SYMBOL(del_virt_timer);
 void init_cpu_vtimer(void)
 {
 	struct vtimer_queue *vt_list;
+	struct vtimer_list *timer;
 
 	/* kick the virtual timer */
 	S390_lowcore.exit_timer = VTIMER_MAX_SLICE;
@@ -539,6 +579,12 @@ void init_cpu_vtimer(void)
 	vt_list->offset = 0;
 	vt_list->idle = 0;
 
+	/* add dummy timers needed for cpu_clock */
+	timer = &__get_cpu_var(cpu_clock_timer);
+	init_virt_timer(timer);
+	timer->expires = VTIMER_MAX_SLICE;
+	timer->function = cpu_clock_timer_callback;
+	add_virt_timer(timer);
 }
 
 static int vtimer_idle_notify(struct notifier_block *self,
Index: linux-2.6/include/asm-s390/timer.h
===================================================================
--- linux-2.6.orig/include/asm-s390/timer.h
+++ linux-2.6/include/asm-s390/timer.h
@@ -48,6 +48,8 @@ extern int del_virt_timer(struct vtimer_
 extern void init_cpu_vtimer(void);
 extern void vtime_init(void);
 
+extern unsigned long long s390_cpu_clock(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_S390_TIMER_H */

 

