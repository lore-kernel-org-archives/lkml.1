Return-Path: <linux-kernel-owner+w=401wt.eu-S934232AbXC0W3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934232AbXC0W3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934231AbXC0W2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:28:44 -0400
Received: from 49.sub-75-208-212.myvzw.com ([75.208.212.49]:55531 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934230AbXC0W2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:28:41 -0400
Message-Id: <20070327215828.171904908@goop.org>
References: <20070327214919.800272641@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Mar 2007 14:49:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, virtualization@lists.osdl.org,
       Prarit Bhargava <prarit@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Lalancette <clalance@redhat.com>
Subject: [patch 4/4] Add global disable/enable for softlockup watchdog
Content-Disposition: inline; filename=softlockup-global-enable.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some machine-wide activities can cause spurious softlockup watchdog
warnings, so add a mechanism to allow the watchdog to be disabled.

The most obvious activity is suspend/resume, but long sysrq output can
also stall the system long enough to cause problems.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Chris Lalancette <clalance@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>

---
 drivers/char/sysrq.c  |    8 +++++
 include/linux/sched.h |   10 ++++++
 kernel/panic.c        |    3 +-
 kernel/power/swsusp.c |    3 +-
 kernel/softlockup.c   |   72 ++++++++++++++++++++++++++++++++++++++++++-------
 kernel/timer.c        |    4 ++
 6 files changed, 87 insertions(+), 13 deletions(-)

===================================================================
--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -211,7 +211,11 @@ static struct sysrq_key_op sysrq_showreg
 
 static void sysrq_handle_showstate(int key, struct tty_struct *tty)
 {
+	softlockup_global_disable();  /* may take a while */
+
 	show_state();
+
+	softlockup_global_enable();
 }
 static struct sysrq_key_op sysrq_showstate_op = {
 	.handler	= sysrq_handle_showstate,
@@ -222,7 +226,11 @@ static struct sysrq_key_op sysrq_showsta
 
 static void sysrq_handle_showstate_blocked(int key, struct tty_struct *tty)
 {
+	softlockup_global_disable();  /* may take a while */
+
 	show_state_filter(TASK_UNINTERRUPTIBLE);
+
+	softlockup_global_enable();
 }
 static struct sysrq_key_op sysrq_showstate_blocked_op = {
 	.handler	= sysrq_handle_showstate_blocked,
===================================================================
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -243,6 +243,10 @@ extern int  softlockup_disable(void);
 extern int  softlockup_disable(void);
 extern void softlockup_enable(int state);
 
+/* Disable/re-enable softlockup watchdog on all CPUs */
+extern void softlockup_global_disable(void);
+extern void softlockup_global_enable(void);
+
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 #else
@@ -263,6 +267,12 @@ static inline void softlockup_enable(int
 static inline void softlockup_enable(int state)
 {
 	preempt_enable();
+}
+static inline void softlockup_global_enable(void)
+{
+}
+static inline void softlockup_global_disable(void)
+{
 }
 static inline void spawn_softlockup_task(void)
 {
===================================================================
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -131,8 +131,9 @@ NORET_TYPE void panic(const char * fmt, 
         disabled_wait(caller);
 #endif
 	local_irq_enable();
+	softlockup_global_disable();
+
 	for (i = 0;;) {
-		touch_softlockup_watchdog();
 		i += panic_blink(i);
 		mdelay(1);
 		i++;
===================================================================
--- a/kernel/power/swsusp.c
+++ b/kernel/power/swsusp.c
@@ -289,6 +289,7 @@ int swsusp_suspend(void)
 	 * that suspended with irqs off ... no overall powerup.
 	 */
 	device_power_up();
+	softlockup_global_disable();
  Enable_irqs:
 	local_irq_enable();
 	return error;
@@ -323,7 +324,7 @@ int swsusp_resume(void)
 	 */
 	swsusp_free();
 	restore_processor_state();
-	touch_softlockup_watchdog();
+	softlockup_global_enable();
 	device_power_up();
 	local_irq_enable();
 	return error;
===================================================================
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -17,10 +17,21 @@
 
 static DEFINE_SPINLOCK(print_lock);
 
+/*
+ * Since sched_clock() is inherently per-cpu, its not possible to
+ * update another CPU's timestamp.  To deal with this, we add an extra
+ * state meaning "enabled, but timestamp needs update".
+ */
+enum state {
+	SL_OFF = 0,		/* disabled */
+	SL_UPDATE,		/* enabled, but timestamp old */
+	SL_ON,			/* enabled */
+};
+
 static DEFINE_PER_CPU(unsigned long, touch_timestamp);
 static DEFINE_PER_CPU(unsigned long, print_timestamp);
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
-static DEFINE_PER_CPU(int, enabled);
+static DEFINE_PER_CPU(enum state, softlock_state);
 
 static int did_panic = 0;
 
@@ -48,7 +59,12 @@ static unsigned long get_timestamp(void)
 
 void inline touch_softlockup_watchdog(void)
 {
+	if (__raw_get_cpu_var(softlock_state) == SL_OFF)
+		return;
+
 	__raw_get_cpu_var(touch_timestamp) = get_timestamp();
+	barrier();
+	__raw_get_cpu_var(softlock_state) = SL_ON;
 }
 EXPORT_SYMBOL(touch_softlockup_watchdog);
 
@@ -58,7 +74,7 @@ EXPORT_SYMBOL(touch_softlockup_watchdog)
  */
 void inline softlockup_tick_disable(void)
 {
-	__get_cpu_var(enabled) = 0;
+	__get_cpu_var(softlock_state) = SL_OFF;
 }
 
 /*
@@ -73,7 +89,7 @@ int softlockup_disable(void)
 
 	preempt_disable();
 
-	ret = __get_cpu_var(enabled);
+	ret = __get_cpu_var(softlock_state) == SL_OFF;
 	softlockup_tick_disable();
 
 	return ret;
@@ -86,7 +102,7 @@ EXPORT_SYMBOL(softlockup_disable);
  */
 void inline softlockup_tick_enable(void)
 {
-	__get_cpu_var(enabled) = 1;
+	__get_cpu_var(softlock_state) = SL_UPDATE;
 }
 
 /*
@@ -96,15 +112,41 @@ void softlockup_enable(int state)
 void softlockup_enable(int state)
 {
 	if (state) {
-		touch_softlockup_watchdog();
-		/* update timestamp before enable */
-		barrier();
 		softlockup_tick_enable();
+		touch_softlockup_watchdog();
 	}
 
 	preempt_enable();
 }
 EXPORT_SYMBOL(softlockup_enable);
+
+/*
+ * Disable softlockup watchdog on all CPUs.  This is useful for
+ * globally disruptive activities, like suspend/resume or large sysrq
+ * debug outputs.
+ */
+void softlockup_global_disable()
+{
+	unsigned cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(softlock_state, cpu) = SL_OFF;
+}
+EXPORT_SYMBOL(softlockup_global_disable);
+
+/*
+ * Globally re-enable soft lockups.  This will obviously interfere
+ * with any CPU's local softlockup disable, but with luck that won't
+ * matter.
+ */
+void softlockup_global_enable()
+{
+	unsigned cpu;
+
+	for_each_online_cpu(cpu)
+		per_cpu(softlock_state, cpu) = SL_UPDATE;
+}
+EXPORT_SYMBOL(softlockup_global_enable);
 
 /*
  * This callback runs from the timer interrupt, and checks
@@ -117,9 +159,19 @@ void softlockup_tick(void)
 	unsigned long print_timestamp;
 	unsigned long now;
 
-	/* return if not enabled */
-	if (!__get_cpu_var(enabled))
-		return;
+	switch(__get_cpu_var(softlock_state)) {
+	case SL_OFF:
+		/* not enabled */
+		return;
+
+	case SL_UPDATE:
+		/* update timestamp */
+		touch_softlockup_watchdog();
+		return;
+
+	case SL_ON:
+		break;
+	}
 
 	print_timestamp = __get_cpu_var(print_timestamp);
 
===================================================================
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1011,7 +1011,7 @@ static int timekeeping_resume(struct sys
 	timekeeping_suspended = 0;
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
-	touch_softlockup_watchdog();
+	softlockup_global_enable();
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
 
@@ -1029,6 +1029,8 @@ static int timekeeping_suspend(struct sy
 	timekeeping_suspended = 1;
 	timekeeping_suspend_time = read_persistent_clock();
 	write_sequnlock_irqrestore(&xtime_lock, flags);
+
+	softlockup_global_disable();
 
 	clockevents_notify(CLOCK_EVT_NOTIFY_SUSPEND, NULL);
 

-- 

