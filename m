Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXGSK5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXGSK5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 06:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXGSK5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 06:57:44 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:46636 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbXGSK5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 06:57:42 -0400
Subject: [PATCH] virtual sched_clock() for s390
From: Jan Glauber <jang@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, vatsa@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com, efault@gmx.de, dmitry.adamushko@gmail.com,
       paulus@samba.org, anton@samba.org
Content-Type: text/plain
Date: Thu, 19 Jul 2007 10:57:41 +0000
Message-Id: <1184842661.6546.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a cpu time clock for s390 (only ticking
if the virtual cpu is running) and bases the s390 implementation
of sched_clock() on it.

The times lice length on a virtual cpu can be anything
between the calculated time slice and zero. In reality
this doesn't seem to be problem, since the scheduler is fair
enough to not let a single process starve but the current
implementation can lead to inefficient short time slices.

By providing a 'virtual' sched_clock() we guarantee that a
process can get its time slice regardless of scheduling
decisions from the hypervisor.

Patch applies to 2.6.22 git and works fine with CFS.

Jan

--
 arch/s390/kernel/time.c  |   18 ++++++++++++------
 arch/s390/kernel/vtime.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/asm-s390/timer.h |    2 ++
 3 files changed, 59 insertions(+), 6 deletions(-)

--- ./include/asm-s390/timer.h.cpu_clock	2007-07-18 13:43:53.000000000 +0200
+++ ./include/asm-s390/timer.h	2007-07-18 20:41:13.000000000 +0200
@@ -48,6 +48,8 @@
 extern void init_cpu_vtimer(void);
 extern void vtime_init(void);
 
+extern unsigned long long cpu_clock(void);
+
 #endif /* __KERNEL__ */
 
 #endif /* _ASM_S390_TIMER_H */
--- ./arch/s390/kernel/time.c.cpu_clock	2007-07-18 13:43:35.000000000 +0200
+++ ./arch/s390/kernel/time.c	2007-07-18 21:01:07.000000000 +0200
@@ -62,21 +62,27 @@
 static u64 xtime_cc;
 
 /*
- * Scheduler clock - returns current time in nanosec units.
+ * Monotonic_clock - returns # of nanoseconds passed since time_init()
  */
-unsigned long long sched_clock(void)
+unsigned long long monotonic_clock(void)
 {
 	return ((get_clock() - jiffies_timer_cc) * 125) >> 9;
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
+	return cpu_clock();
+#else
+	return monotonic_clock();
+#endif
 }
-EXPORT_SYMBOL(monotonic_clock);
 
 void tod_to_timeval(__u64 todval, struct timespec *xtime)
 {
--- ./arch/s390/kernel/vtime.c.cpu_clock	2007-07-18 13:43:44.000000000 +0200
+++ ./arch/s390/kernel/vtime.c	2007-07-18 20:52:14.000000000 +0200
@@ -26,6 +26,44 @@
 
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
+	local_irq_disable();
+
+	BUG_ON(timer->cpu != smp_processor_id());
+
+	vt_list = &per_cpu(virt_cpu_timer, timer->cpu);
+	asm volatile ("STPT %0" : "=m" (done));
+
+	done = vt_list->to_expire + vt_list->offset - done;
+	local_irq_restore(flags);
+	return done;
+}
+
+/*
+ * Cpu clock, returns cpu time in nanosec units.
+ * Must be called with preemption disabled.
+ */
+unsigned long long cpu_clock(void)
+{
+	return ((read_cpu_timer(&__get_cpu_var(cpu_clock_timer)) * 125) >> 9);
+}
+
+/* expire after 142 years ... */
+static void cpu_clock_timer_callback(unsigned long data)
+{
+	BUG();
+}
 
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
 /*
@@ -522,6 +560,7 @@
 void init_cpu_vtimer(void)
 {
 	struct vtimer_queue *vt_list;
+	struct vtimer_list *timer;
 
 	/* kick the virtual timer */
 	S390_lowcore.exit_timer = VTIMER_MAX_SLICE;
@@ -539,6 +578,12 @@
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


