Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbXJWUAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbXJWUAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 16:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbXJWUA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 16:00:27 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:64916 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXJWUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 16:00:26 -0400
Subject: [RFC PATCH 1/2] virtual sched_clock() for s390
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefksy <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Oct 2007 22:02:21 +0200
Message-Id: <1193169742.5922.46.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Glauber <jan.glauber@de.ibm.com> 
From: Christian Borntraeger <borntraeger@de.ibm.com> 

This patch introduces a cpu time clock for s390 (only ticking if
the virtual cpu is running) and bases the s390 implementation of
sched_clock() on it.

The time slice length on a virtual cpu can be anything between the
calculated time slice and zero. In reality this doesn't seem to be
problem, since the scheduler is fair enough to not let a single
process starve but the current implementation can lead to inefficient
short time slices.

By providing a 'virtual' sched_clock() we improve the scheduler
fairness, regardless of scheduling decisions from the hypervisor.
We also lay a foundation to base process accouting on virtual cpu
time without CONFIG_VIRT_CPU_ACCOUNTING.

Signed-off-by: Jan Glauber <jan.glauber@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>

---
 arch/s390/kernel/time.c  |   30 +++++++++++++++++----------
 arch/s390/kernel/vtime.c |   52 ++++++++++++++++++++++++++++++++++++++++++++---
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

