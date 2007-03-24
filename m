Return-Path: <linux-kernel-owner+w=401wt.eu-S2992544AbXCXHcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992544AbXCXHcB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 03:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965352AbXCXHbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 03:31:38 -0400
Received: from peabody.ximian.com ([130.57.169.10]:36814 "EHLO
	peabody.ximian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965225AbXCXHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 03:31:29 -0400
Subject: [RFC][PATCH 2/3] export time until next timer interrupt using NOHZ
From: Adam Belay <abelay@novell.com>
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Shaohua Li <shaohua.li@intel.com>, Pallipadi@vger.kernel.org,
       Venkatesh <venkatesh.pallipadi@intel.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain
Date: Sat, 24 Mar 2007 03:47:03 -0400
Message-Id: <1174722423.32554.83.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch exposes information about the time remaining until the next
timer interrupt expires by utilizing the dynticks infrastructure.  It
also modifies the main idle loop to allow dynticks to handle
non-interrupt break events (e.g. DMA).  Finally, it exposes sleep ticks
information to external code.  Thomas Gleixner is responsible for much
of the code in this patch.  However, I've made some additional changes,
so I'm probably responsible if there are any bugs or oversights :)

Thanks,
Adam

 arch/i386/kernel/process.c |    3 ++-
 include/linux/tick.h       |   10 ++++++++++
 kernel/softirq.c           |    5 -----
 kernel/time/tick-sched.c   |   24 ++++++++++++++++++++++++
 4 files changed, 36 insertions(+), 6 deletions(-)


diff -urN a/arch/i386/kernel/process.c b/arch/i386/kernel/process.c
--- a/arch/i386/kernel/process.c	2007-03-23 23:02:16.000000000 -0400
+++ b/arch/i386/kernel/process.c	2007-03-24 01:48:33.000000000 -0400
@@ -174,13 +174,14 @@
 
 	/* endless idle loop with no priority at all */
 	while (1) {
-		tick_nohz_stop_sched_tick();
 		while (!need_resched()) {
 			void (*idle)(void);
 
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			tick_nohz_stop_sched_tick();
+
 			rmb();
 			idle = pm_idle;
 
diff -urN a/include/linux/tick.h b/include/linux/tick.h
--- a/include/linux/tick.h	2007-03-23 23:03:03.000000000 -0400
+++ b/include/linux/tick.h	2007-03-24 01:39:03.000000000 -0400
@@ -40,6 +40,7 @@
  * @idle_sleeps:	Number of idle calls, where the sched tick was stopped
  * @idle_entrytime:	Time when the idle call was entered
  * @idle_sleeptime:	Sum of the time slept in idle with sched tick stopped
+ * @sleep_length:	Duration of the current idle sleep
  */
 struct tick_sched {
 	struct hrtimer			sched_timer;
@@ -52,6 +53,7 @@
 	unsigned long			idle_sleeps;
 	ktime_t				idle_entrytime;
 	ktime_t				idle_sleeptime;
+	ktime_t				sleep_length;
 	unsigned long			last_jiffies;
 	unsigned long			next_jiffies;
 	ktime_t				idle_expires;
@@ -100,10 +102,18 @@
 extern void tick_nohz_stop_sched_tick(void);
 extern void tick_nohz_restart_sched_tick(void);
 extern void tick_nohz_update_jiffies(void);
+extern ktime_t tick_nohz_get_sleep_length(void);
+extern unsigned long tick_nohz_get_idle_jiffies(void);
 # else
 static inline void tick_nohz_stop_sched_tick(void) { }
 static inline void tick_nohz_restart_sched_tick(void) { }
 static inline void tick_nohz_update_jiffies(void) { }
+static inline ktime_t tick_nohz_get_sleep_length(void)
+{
+	ktime_t len = { .tv64 = NSEC_PER_SEC/HZ };
+
+	return len;
+}
 # endif /* !NO_HZ */
 
 #endif
diff -urN a/kernel/softirq.c b/kernel/softirq.c
--- a/kernel/softirq.c	2007-03-23 23:03:03.000000000 -0400
+++ b/kernel/softirq.c	2007-03-24 01:54:11.000000000 -0400
@@ -303,11 +303,6 @@
 	if (!in_interrupt() && local_softirq_pending())
 		invoke_softirq();
 
-#ifdef CONFIG_NO_HZ
-	/* Make sure that timer wheel updates are propagated */
-	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
-		tick_nohz_stop_sched_tick();
-#endif
 	preempt_enable_no_resched();
 }
 
diff -urN a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c	2007-03-23 23:03:03.000000000 -0400
+++ b/kernel/time/tick-sched.c	2007-03-24 01:44:55.000000000 -0400
@@ -153,6 +153,7 @@
 	unsigned long seq, last_jiffies, next_jiffies, delta_jiffies, flags;
 	struct tick_sched *ts;
 	ktime_t last_update, expires, now, delta;
+	struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;
 	int cpu;
 
 	local_irq_save(flags);
@@ -250,11 +251,34 @@
 out:
 	ts->next_jiffies = next_jiffies;
 	ts->last_jiffies = last_jiffies;
+	ts->sleep_length = ktime_sub(dev->next_event, now);
 end:
 	local_irq_restore(flags);
 }
 
 /**
+ * tick_nohz_get_sleep_length - return the length of the current sleep
+ *
+ * Called from power state control code with interrupts disabled
+ */
+ktime_t tick_nohz_get_sleep_length(void)
+{
+       struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+       return ts->sleep_length;
+}
+
+/**
+ * tick_nohz_get_idle_jiffies - returns the current idle jiffie count
+ */
+unsigned long tick_nohz_get_idle_jiffies(void)
+{
+       struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+       return ts->idle_jiffies;
+}
+
+/**
  * nohz_restart_sched_tick - restart the idle tick from the idle task
  *
  * Restart the idle tick when the CPU is woken up from idle


