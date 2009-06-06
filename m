Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbZFFXBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbZFFXBc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jun 2009 19:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbZFFXBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Jun 2009 19:01:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57071 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZFFXBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jun 2009 19:01:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 1/2] PM: Separate suspend to RAM functionality from core
Date: Sun, 7 Jun 2009 00:55:54 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <200906070054.19207.rjw@sisk.pl>
In-Reply-To: <200906070054.19207.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906070055.55156.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move the suspend to RAM and standby code from kernel/power/main.c
to two separate files, kernel/power/suspend.c containing the basic
functions and kernel/power/suspend-test.c containing the automatic
suspend test facility based on the RTC clock alarm.

There are no changes in functionality related to these modifications.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Makefile       |    2 
 kernel/power/main.c         |  503 --------------------------------------------
 kernel/power/power.h        |   17 +
 kernel/power/suspend-test.c |  187 ++++++++++++++++
 kernel/power/suspend.c      |  300 ++++++++++++++++++++++++++
 5 files changed, 505 insertions(+), 504 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -8,20 +8,9 @@
  *
  */
 
-#include <linux/module.h>
-#include <linux/suspend.h>
 #include <linux/kobject.h>
 #include <linux/string.h>
-#include <linux/delay.h>
-#include <linux/errno.h>
-#include <linux/kmod.h>
-#include <linux/init.h>
-#include <linux/console.h>
-#include <linux/cpu.h>
 #include <linux/resume-trace.h>
-#include <linux/freezer.h>
-#include <linux/vmstat.h>
-#include <linux/syscalls.h>
 
 #include "power.h"
 
@@ -119,355 +108,6 @@ power_attr(pm_test);
 
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_SUSPEND
-
-static int suspend_test(int level)
-{
-#ifdef CONFIG_PM_DEBUG
-	if (pm_test_level == level) {
-		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
-		return 1;
-	}
-#endif /* !CONFIG_PM_DEBUG */
-	return 0;
-}
-
-#ifdef CONFIG_PM_TEST_SUSPEND
-
-/*
- * We test the system suspend code by setting an RTC wakealarm a short
- * time in the future, then suspending.  Suspending the devices won't
- * normally take long ... some systems only need a few milliseconds.
- *
- * The time it takes is system-specific though, so when we test this
- * during system bootup we allow a LOT of time.
- */
-#define TEST_SUSPEND_SECONDS	5
-
-static unsigned long suspend_test_start_time;
-
-static void suspend_test_start(void)
-{
-	/* FIXME Use better timebase than "jiffies", ideally a clocksource.
-	 * What we want is a hardware counter that will work correctly even
-	 * during the irqs-are-off stages of the suspend/resume cycle...
-	 */
-	suspend_test_start_time = jiffies;
-}
-
-static void suspend_test_finish(const char *label)
-{
-	long nj = jiffies - suspend_test_start_time;
-	unsigned msec;
-
-	msec = jiffies_to_msecs(abs(nj));
-	pr_info("PM: %s took %d.%03d seconds\n", label,
-			msec / 1000, msec % 1000);
-
-	/* Warning on suspend means the RTC alarm period needs to be
-	 * larger -- the system was sooo slooowwww to suspend that the
-	 * alarm (should have) fired before the system went to sleep!
-	 *
-	 * Warning on either suspend or resume also means the system
-	 * has some performance issues.  The stack dump of a WARN_ON
-	 * is more likely to get the right attention than a printk...
-	 */
-	WARN(msec > (TEST_SUSPEND_SECONDS * 1000), "Component: %s\n", label);
-}
-
-#else
-
-static void suspend_test_start(void)
-{
-}
-
-static void suspend_test_finish(const char *label)
-{
-}
-
-#endif
-
-static struct platform_suspend_ops *suspend_ops;
-
-/**
- *	suspend_set_ops - Set the global suspend method table.
- *	@ops:	Pointer to ops structure.
- */
-
-void suspend_set_ops(struct platform_suspend_ops *ops)
-{
-	mutex_lock(&pm_mutex);
-	suspend_ops = ops;
-	mutex_unlock(&pm_mutex);
-}
-
-/**
- * suspend_valid_only_mem - generic memory-only valid callback
- *
- * Platform drivers that implement mem suspend only and only need
- * to check for that in their .valid callback can use this instead
- * of rolling their own .valid callback.
- */
-int suspend_valid_only_mem(suspend_state_t state)
-{
-	return state == PM_SUSPEND_MEM;
-}
-
-/**
- *	suspend_prepare - Do prep work before entering low-power state.
- *
- *	This is common code that is called for each state that we're entering.
- *	Run suspend notifiers, allocate a console and stop all processes.
- */
-static int suspend_prepare(void)
-{
-	int error;
-
-	if (!suspend_ops || !suspend_ops->enter)
-		return -EPERM;
-
-	pm_prepare_console();
-
-	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
-	if (error)
-		goto Finish;
-
-	error = usermodehelper_disable();
-	if (error)
-		goto Finish;
-
-	error = suspend_freeze_processes();
-	if (!error)
-		return 0;
-
-	suspend_thaw_processes();
-	usermodehelper_enable();
- Finish:
-	pm_notifier_call_chain(PM_POST_SUSPEND);
-	pm_restore_console();
-	return error;
-}
-
-/* default implementation */
-void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
-{
-	local_irq_disable();
-}
-
-/* default implementation */
-void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
-{
-	local_irq_enable();
-}
-
-/**
- *	suspend_enter - enter the desired system sleep state.
- *	@state:		state to enter
- *
- *	This function should be called after devices have been suspended.
- */
-static int suspend_enter(suspend_state_t state)
-{
-	int error;
-
-	if (suspend_ops->prepare) {
-		error = suspend_ops->prepare();
-		if (error)
-			return error;
-	}
-
-	error = dpm_suspend_noirq(PMSG_SUSPEND);
-	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to power down\n");
-		goto Platfrom_finish;
-	}
-
-	if (suspend_ops->prepare_late) {
-		error = suspend_ops->prepare_late();
-		if (error)
-			goto Power_up_devices;
-	}
-
-	if (suspend_test(TEST_PLATFORM))
-		goto Platform_wake;
-
-	error = disable_nonboot_cpus();
-	if (error || suspend_test(TEST_CPUS))
-		goto Enable_cpus;
-
-	arch_suspend_disable_irqs();
-	BUG_ON(!irqs_disabled());
-
-	error = sysdev_suspend(PMSG_SUSPEND);
-	if (!error) {
-		if (!suspend_test(TEST_CORE))
-			error = suspend_ops->enter(state);
-		sysdev_resume();
-	}
-
-	arch_suspend_enable_irqs();
-	BUG_ON(irqs_disabled());
-
- Enable_cpus:
-	enable_nonboot_cpus();
-
- Platform_wake:
-	if (suspend_ops->wake)
-		suspend_ops->wake();
-
- Power_up_devices:
-	dpm_resume_noirq(PMSG_RESUME);
-
- Platfrom_finish:
-	if (suspend_ops->finish)
-		suspend_ops->finish();
-
-	return error;
-}
-
-/**
- *	suspend_devices_and_enter - suspend devices and enter the desired system
- *				    sleep state.
- *	@state:		  state to enter
- */
-int suspend_devices_and_enter(suspend_state_t state)
-{
-	int error;
-
-	if (!suspend_ops)
-		return -ENOSYS;
-
-	if (suspend_ops->begin) {
-		error = suspend_ops->begin(state);
-		if (error)
-			goto Close;
-	}
-	suspend_console();
-	suspend_test_start();
-	error = dpm_suspend_start(PMSG_SUSPEND);
-	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to suspend\n");
-		goto Recover_platform;
-	}
-	suspend_test_finish("suspend devices");
-	if (suspend_test(TEST_DEVICES))
-		goto Recover_platform;
-
-	suspend_enter(state);
-
- Resume_devices:
-	suspend_test_start();
-	dpm_resume_end(PMSG_RESUME);
-	suspend_test_finish("resume devices");
-	resume_console();
- Close:
-	if (suspend_ops->end)
-		suspend_ops->end();
-	return error;
-
- Recover_platform:
-	if (suspend_ops->recover)
-		suspend_ops->recover();
-	goto Resume_devices;
-}
-
-/**
- *	suspend_finish - Do final work before exiting suspend sequence.
- *
- *	Call platform code to clean up, restart processes, and free the 
- *	console that we've allocated. This is not called for suspend-to-disk.
- */
-static void suspend_finish(void)
-{
-	suspend_thaw_processes();
-	usermodehelper_enable();
-	pm_notifier_call_chain(PM_POST_SUSPEND);
-	pm_restore_console();
-}
-
-
-
-
-static const char * const pm_states[PM_SUSPEND_MAX] = {
-	[PM_SUSPEND_STANDBY]	= "standby",
-	[PM_SUSPEND_MEM]	= "mem",
-};
-
-static inline int valid_state(suspend_state_t state)
-{
-	/* All states need lowlevel support and need to be valid
-	 * to the lowlevel implementation, no valid callback
-	 * implies that none are valid. */
-	if (!suspend_ops || !suspend_ops->valid || !suspend_ops->valid(state))
-		return 0;
-	return 1;
-}
-
-
-/**
- *	enter_state - Do common work of entering low-power state.
- *	@state:		pm_state structure for state we're entering.
- *
- *	Make sure we're the only ones trying to enter a sleep state. Fail
- *	if someone has beat us to it, since we don't want anything weird to
- *	happen when we wake up.
- *	Then, do the setup for suspend, enter the state, and cleaup (after
- *	we've woken up).
- */
-static int enter_state(suspend_state_t state)
-{
-	int error;
-
-	if (!valid_state(state))
-		return -ENODEV;
-
-	if (!mutex_trylock(&pm_mutex))
-		return -EBUSY;
-
-	printk(KERN_INFO "PM: Syncing filesystems ... ");
-	sys_sync();
-	printk("done.\n");
-
-	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
-	error = suspend_prepare();
-	if (error)
-		goto Unlock;
-
-	if (suspend_test(TEST_FREEZER))
-		goto Finish;
-
-	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
-	error = suspend_devices_and_enter(state);
-
- Finish:
-	pr_debug("PM: Finishing wakeup.\n");
-	suspend_finish();
- Unlock:
-	mutex_unlock(&pm_mutex);
-	return error;
-}
-
-
-/**
- *	pm_suspend - Externally visible function for suspending system.
- *	@state:		Enumerated value of state to enter.
- *
- *	Determine whether or not value is within range, get state 
- *	structure, and enter (above).
- */
-
-int pm_suspend(suspend_state_t state)
-{
-	if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX)
-		return enter_state(state);
-	return -EINVAL;
-}
-
-EXPORT_SYMBOL(pm_suspend);
-
-#endif /* CONFIG_SUSPEND */
-
 struct kobject *power_kobj;
 
 /**
@@ -480,7 +120,6 @@ struct kobject *power_kobj;
  *	store() accepts one of those strings, translates it into the 
  *	proper enumerated value, and initiates a suspend transition.
  */
-
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 			  char *buf)
 {
@@ -578,7 +217,6 @@ static struct attribute_group attr_group
 	.attrs = g,
 };
 
-
 static int __init pm_init(void)
 {
 	power_kobj = kobject_create_and_add("power", NULL);
@@ -588,144 +226,3 @@ static int __init pm_init(void)
 }
 
 core_initcall(pm_init);
-
-
-#ifdef CONFIG_PM_TEST_SUSPEND
-
-#include <linux/rtc.h>
-
-/*
- * To test system suspend, we need a hands-off mechanism to resume the
- * system.  RTCs wake alarms are a common self-contained mechanism.
- */
-
-static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
-{
-	static char err_readtime[] __initdata =
-		KERN_ERR "PM: can't read %s time, err %d\n";
-	static char err_wakealarm [] __initdata =
-		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
-	static char err_suspend[] __initdata =
-		KERN_ERR "PM: suspend test failed, error %d\n";
-	static char info_test[] __initdata =
-		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
-
-	unsigned long		now;
-	struct rtc_wkalrm	alm;
-	int			status;
-
-	/* this may fail if the RTC hasn't been initialized */
-	status = rtc_read_time(rtc, &alm.time);
-	if (status < 0) {
-		printk(err_readtime, dev_name(&rtc->dev), status);
-		return;
-	}
-	rtc_tm_to_time(&alm.time, &now);
-
-	memset(&alm, 0, sizeof alm);
-	rtc_time_to_tm(now + TEST_SUSPEND_SECONDS, &alm.time);
-	alm.enabled = true;
-
-	status = rtc_set_alarm(rtc, &alm);
-	if (status < 0) {
-		printk(err_wakealarm, dev_name(&rtc->dev), status);
-		return;
-	}
-
-	if (state == PM_SUSPEND_MEM) {
-		printk(info_test, pm_states[state]);
-		status = pm_suspend(state);
-		if (status == -ENODEV)
-			state = PM_SUSPEND_STANDBY;
-	}
-	if (state == PM_SUSPEND_STANDBY) {
-		printk(info_test, pm_states[state]);
-		status = pm_suspend(state);
-	}
-	if (status < 0)
-		printk(err_suspend, status);
-
-	/* Some platforms can't detect that the alarm triggered the
-	 * wakeup, or (accordingly) disable it after it afterwards.
-	 * It's supposed to give oneshot behavior; cope.
-	 */
-	alm.enabled = false;
-	rtc_set_alarm(rtc, &alm);
-}
-
-static int __init has_wakealarm(struct device *dev, void *name_ptr)
-{
-	struct rtc_device *candidate = to_rtc_device(dev);
-
-	if (!candidate->ops->set_alarm)
-		return 0;
-	if (!device_may_wakeup(candidate->dev.parent))
-		return 0;
-
-	*(const char **)name_ptr = dev_name(dev);
-	return 1;
-}
-
-/*
- * Kernel options like "test_suspend=mem" force suspend/resume sanity tests
- * at startup time.  They're normally disabled, for faster boot and because
- * we can't know which states really work on this particular system.
- */
-static suspend_state_t test_state __initdata = PM_SUSPEND_ON;
-
-static char warn_bad_state[] __initdata =
-	KERN_WARNING "PM: can't test '%s' suspend state\n";
-
-static int __init setup_test_suspend(char *value)
-{
-	unsigned i;
-
-	/* "=mem" ==> "mem" */
-	value++;
-	for (i = 0; i < PM_SUSPEND_MAX; i++) {
-		if (!pm_states[i])
-			continue;
-		if (strcmp(pm_states[i], value) != 0)
-			continue;
-		test_state = (__force suspend_state_t) i;
-		return 0;
-	}
-	printk(warn_bad_state, value);
-	return 0;
-}
-__setup("test_suspend", setup_test_suspend);
-
-static int __init test_suspend(void)
-{
-	static char		warn_no_rtc[] __initdata =
-		KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
-
-	char			*pony = NULL;
-	struct rtc_device	*rtc = NULL;
-
-	/* PM is initialized by now; is that state testable? */
-	if (test_state == PM_SUSPEND_ON)
-		goto done;
-	if (!valid_state(test_state)) {
-		printk(warn_bad_state, pm_states[test_state]);
-		goto done;
-	}
-
-	/* RTCs have initialized by now too ... can we use one? */
-	class_find_device(rtc_class, NULL, &pony, has_wakealarm);
-	if (pony)
-		rtc = rtc_class_open(pony);
-	if (!rtc) {
-		printk(warn_no_rtc);
-		goto done;
-	}
-
-	/* go for it */
-	test_wakealarm(rtc, test_state);
-	rtc_class_close(rtc);
-done:
-	return 0;
-}
-late_initcall(test_suspend);
-
-#endif /* CONFIG_PM_TEST_SUSPEND */
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/power/suspend.c
@@ -0,0 +1,300 @@
+/*
+ * kernel/power/suspend.c - Suspend to RAM and standby functionality.
+ *
+ * Copyright (c) 2003 Patrick Mochel
+ * Copyright (c) 2003 Open Source Development Lab
+ * Copyright (c) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/console.h>
+#include <linux/cpu.h>
+#include <linux/syscalls.h>
+
+#include "power.h"
+
+const char *const pm_states[PM_SUSPEND_MAX] = {
+	[PM_SUSPEND_STANDBY]	= "standby",
+	[PM_SUSPEND_MEM]	= "mem",
+};
+
+static struct platform_suspend_ops *suspend_ops;
+
+/**
+ *	suspend_set_ops - Set the global suspend method table.
+ *	@ops:	Pointer to ops structure.
+ */
+void suspend_set_ops(struct platform_suspend_ops *ops)
+{
+	mutex_lock(&pm_mutex);
+	suspend_ops = ops;
+	mutex_unlock(&pm_mutex);
+}
+
+bool valid_state(suspend_state_t state)
+{
+	/*
+	 * All states need lowlevel support and need to be valid to the lowlevel
+	 * implementation, no valid callback implies that none are valid.
+	 */
+	return suspend_ops && suspend_ops->valid && suspend_ops->valid(state);
+}
+
+/**
+ * suspend_valid_only_mem - generic memory-only valid callback
+ *
+ * Platform drivers that implement mem suspend only and only need
+ * to check for that in their .valid callback can use this instead
+ * of rolling their own .valid callback.
+ */
+int suspend_valid_only_mem(suspend_state_t state)
+{
+	return state == PM_SUSPEND_MEM;
+}
+
+static int suspend_test(int level)
+{
+#ifdef CONFIG_PM_DEBUG
+	if (pm_test_level == level) {
+		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
+		mdelay(5000);
+		return 1;
+	}
+#endif /* !CONFIG_PM_DEBUG */
+	return 0;
+}
+
+/**
+ *	suspend_prepare - Do prep work before entering low-power state.
+ *
+ *	This is common code that is called for each state that we're entering.
+ *	Run suspend notifiers, allocate a console and stop all processes.
+ */
+static int suspend_prepare(void)
+{
+	int error;
+
+	if (!suspend_ops || !suspend_ops->enter)
+		return -EPERM;
+
+	pm_prepare_console();
+
+	error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
+	if (error)
+		goto Finish;
+
+	error = usermodehelper_disable();
+	if (error)
+		goto Finish;
+
+	error = suspend_freeze_processes();
+	if (!error)
+		return 0;
+
+	suspend_thaw_processes();
+	usermodehelper_enable();
+ Finish:
+	pm_notifier_call_chain(PM_POST_SUSPEND);
+	pm_restore_console();
+	return error;
+}
+
+/* default implementation */
+void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
+{
+	local_irq_disable();
+}
+
+/* default implementation */
+void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
+{
+	local_irq_enable();
+}
+
+/**
+ *	suspend_enter - enter the desired system sleep state.
+ *	@state:		state to enter
+ *
+ *	This function should be called after devices have been suspended.
+ */
+static int suspend_enter(suspend_state_t state)
+{
+	int error;
+
+	if (suspend_ops->prepare) {
+		error = suspend_ops->prepare();
+		if (error)
+			return error;
+	}
+
+	error = dpm_suspend_noirq(PMSG_SUSPEND);
+	if (error) {
+		printk(KERN_ERR "PM: Some devices failed to power down\n");
+		goto Platfrom_finish;
+	}
+
+	if (suspend_ops->prepare_late) {
+		error = suspend_ops->prepare_late();
+		if (error)
+			goto Power_up_devices;
+	}
+
+	if (suspend_test(TEST_PLATFORM))
+		goto Platform_wake;
+
+	error = disable_nonboot_cpus();
+	if (error || suspend_test(TEST_CPUS))
+		goto Enable_cpus;
+
+	arch_suspend_disable_irqs();
+	BUG_ON(!irqs_disabled());
+
+	error = sysdev_suspend(PMSG_SUSPEND);
+	if (!error) {
+		if (!suspend_test(TEST_CORE))
+			error = suspend_ops->enter(state);
+		sysdev_resume();
+	}
+
+	arch_suspend_enable_irqs();
+	BUG_ON(irqs_disabled());
+
+ Enable_cpus:
+	enable_nonboot_cpus();
+
+ Platform_wake:
+	if (suspend_ops->wake)
+		suspend_ops->wake();
+
+ Power_up_devices:
+	dpm_resume_noirq(PMSG_RESUME);
+
+ Platfrom_finish:
+	if (suspend_ops->finish)
+		suspend_ops->finish();
+
+	return error;
+}
+
+/**
+ *	suspend_devices_and_enter - suspend devices and enter the desired system
+ *				    sleep state.
+ *	@state:		  state to enter
+ */
+int suspend_devices_and_enter(suspend_state_t state)
+{
+	int error;
+
+	if (!suspend_ops)
+		return -ENOSYS;
+
+	if (suspend_ops->begin) {
+		error = suspend_ops->begin(state);
+		if (error)
+			goto Close;
+	}
+	suspend_console();
+	suspend_test_start();
+	error = dpm_suspend_start(PMSG_SUSPEND);
+	if (error) {
+		printk(KERN_ERR "PM: Some devices failed to suspend\n");
+		goto Recover_platform;
+	}
+	suspend_test_finish("suspend devices");
+	if (suspend_test(TEST_DEVICES))
+		goto Recover_platform;
+
+	suspend_enter(state);
+
+ Resume_devices:
+	suspend_test_start();
+	dpm_resume_end(PMSG_RESUME);
+	suspend_test_finish("resume devices");
+	resume_console();
+ Close:
+	if (suspend_ops->end)
+		suspend_ops->end();
+	return error;
+
+ Recover_platform:
+	if (suspend_ops->recover)
+		suspend_ops->recover();
+	goto Resume_devices;
+}
+
+/**
+ *	suspend_finish - Do final work before exiting suspend sequence.
+ *
+ *	Call platform code to clean up, restart processes, and free the
+ *	console that we've allocated. This is not called for suspend-to-disk.
+ */
+static void suspend_finish(void)
+{
+	suspend_thaw_processes();
+	usermodehelper_enable();
+	pm_notifier_call_chain(PM_POST_SUSPEND);
+	pm_restore_console();
+}
+
+/**
+ *	enter_state - Do common work of entering low-power state.
+ *	@state:		pm_state structure for state we're entering.
+ *
+ *	Make sure we're the only ones trying to enter a sleep state. Fail
+ *	if someone has beat us to it, since we don't want anything weird to
+ *	happen when we wake up.
+ *	Then, do the setup for suspend, enter the state, and cleaup (after
+ *	we've woken up).
+ */
+int enter_state(suspend_state_t state)
+{
+	int error;
+
+	if (!valid_state(state))
+		return -ENODEV;
+
+	if (!mutex_trylock(&pm_mutex))
+		return -EBUSY;
+
+	printk(KERN_INFO "PM: Syncing filesystems ... ");
+	sys_sync();
+	printk("done.\n");
+
+	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
+	error = suspend_prepare();
+	if (error)
+		goto Unlock;
+
+	if (suspend_test(TEST_FREEZER))
+		goto Finish;
+
+	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
+	error = suspend_devices_and_enter(state);
+
+ Finish:
+	pr_debug("PM: Finishing wakeup.\n");
+	suspend_finish();
+ Unlock:
+	mutex_unlock(&pm_mutex);
+	return error;
+}
+
+/**
+ *	pm_suspend - Externally visible function for suspending system.
+ *	@state:		Enumerated value of state to enter.
+ *
+ *	Determine whether or not value is within range, get state
+ *	structure, and enter (above).
+ */
+int pm_suspend(suspend_state_t state)
+{
+	if (state > PM_SUSPEND_ON && state <= PM_SUSPEND_MAX)
+		return enter_state(state);
+	return -EINVAL;
+}
+EXPORT_SYMBOL(pm_suspend);
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -160,15 +160,30 @@ extern void swsusp_show_speed(struct tim
 				unsigned int, char *);
 
 #ifdef CONFIG_SUSPEND
-/* kernel/power/main.c */
+/* kernel/power/suspend.c */
+extern const char *const pm_states[];
+
+extern bool valid_state(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
+extern int enter_state(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
 static inline int suspend_devices_and_enter(suspend_state_t state)
 {
 	return -ENOSYS;
 }
+static inline int enter_state(suspend_state_t state) { return -ENOSYS; }
+static inline bool valid_state(suspend_state_t state) { return false; }
 #endif /* !CONFIG_SUSPEND */
 
+#ifdef CONFIG_PM_TEST_SUSPEND
+/* kernel/power/suspend-test.c */
+extern void suspend_test_start(void);
+extern void suspend_test_finish(const char *label);
+#else /* !CONFIG_PM_TEST_SUSPEND */
+static inline void suspend_test_start(void) {}
+static inline void suspend_test_finish(const char *label) {}
+#endif /* !CONFIG_PM_TEST_SUSPEND */
+
 #ifdef CONFIG_PM_SLEEP
 /* kernel/power/main.c */
 extern int pm_notifier_call_chain(unsigned long val);
Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile
+++ linux-2.6/kernel/power/Makefile
@@ -6,6 +6,8 @@ endif
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
+obj-$(CONFIG_SUSPEND)		+= suspend.o
+obj-$(CONFIG_PM_TEST_SUSPEND)	+= suspend-test.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux-2.6/kernel/power/suspend-test.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/power/suspend-test.c
@@ -0,0 +1,187 @@
+/*
+ * kernel/power/suspend-test.c - Suspend to RAM and standby test facility.
+ *
+ * Copyright (c) 2009 Pavel Machek <pavel@ucw.cz>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/init.h>
+#include <linux/rtc.h>
+
+#include "power.h"
+
+/*
+ * We test the system suspend code by setting an RTC wakealarm a short
+ * time in the future, then suspending.  Suspending the devices won't
+ * normally take long ... some systems only need a few milliseconds.
+ *
+ * The time it takes is system-specific though, so when we test this
+ * during system bootup we allow a LOT of time.
+ */
+#define TEST_SUSPEND_SECONDS	5
+
+static unsigned long suspend_test_start_time;
+
+void suspend_test_start(void)
+{
+	/* FIXME Use better timebase than "jiffies", ideally a clocksource.
+	 * What we want is a hardware counter that will work correctly even
+	 * during the irqs-are-off stages of the suspend/resume cycle...
+	 */
+	suspend_test_start_time = jiffies;
+}
+
+void suspend_test_finish(const char *label)
+{
+	long nj = jiffies - suspend_test_start_time;
+	unsigned msec;
+
+	msec = jiffies_to_msecs(abs(nj));
+	pr_info("PM: %s took %d.%03d seconds\n", label,
+			msec / 1000, msec % 1000);
+
+	/* Warning on suspend means the RTC alarm period needs to be
+	 * larger -- the system was sooo slooowwww to suspend that the
+	 * alarm (should have) fired before the system went to sleep!
+	 *
+	 * Warning on either suspend or resume also means the system
+	 * has some performance issues.  The stack dump of a WARN_ON
+	 * is more likely to get the right attention than a printk...
+	 */
+	WARN(msec > (TEST_SUSPEND_SECONDS * 1000), "Component: %s\n", label);
+}
+
+/*
+ * To test system suspend, we need a hands-off mechanism to resume the
+ * system.  RTCs wake alarms are a common self-contained mechanism.
+ */
+
+static void __init test_wakealarm(struct rtc_device *rtc, suspend_state_t state)
+{
+	static char err_readtime[] __initdata =
+		KERN_ERR "PM: can't read %s time, err %d\n";
+	static char err_wakealarm [] __initdata =
+		KERN_ERR "PM: can't set %s wakealarm, err %d\n";
+	static char err_suspend[] __initdata =
+		KERN_ERR "PM: suspend test failed, error %d\n";
+	static char info_test[] __initdata =
+		KERN_INFO "PM: test RTC wakeup from '%s' suspend\n";
+
+	unsigned long		now;
+	struct rtc_wkalrm	alm;
+	int			status;
+
+	/* this may fail if the RTC hasn't been initialized */
+	status = rtc_read_time(rtc, &alm.time);
+	if (status < 0) {
+		printk(err_readtime, dev_name(&rtc->dev), status);
+		return;
+	}
+	rtc_tm_to_time(&alm.time, &now);
+
+	memset(&alm, 0, sizeof alm);
+	rtc_time_to_tm(now + TEST_SUSPEND_SECONDS, &alm.time);
+	alm.enabled = true;
+
+	status = rtc_set_alarm(rtc, &alm);
+	if (status < 0) {
+		printk(err_wakealarm, dev_name(&rtc->dev), status);
+		return;
+	}
+
+	if (state == PM_SUSPEND_MEM) {
+		printk(info_test, pm_states[state]);
+		status = pm_suspend(state);
+		if (status == -ENODEV)
+			state = PM_SUSPEND_STANDBY;
+	}
+	if (state == PM_SUSPEND_STANDBY) {
+		printk(info_test, pm_states[state]);
+		status = pm_suspend(state);
+	}
+	if (status < 0)
+		printk(err_suspend, status);
+
+	/* Some platforms can't detect that the alarm triggered the
+	 * wakeup, or (accordingly) disable it after it afterwards.
+	 * It's supposed to give oneshot behavior; cope.
+	 */
+	alm.enabled = false;
+	rtc_set_alarm(rtc, &alm);
+}
+
+static int __init has_wakealarm(struct device *dev, void *name_ptr)
+{
+	struct rtc_device *candidate = to_rtc_device(dev);
+
+	if (!candidate->ops->set_alarm)
+		return 0;
+	if (!device_may_wakeup(candidate->dev.parent))
+		return 0;
+
+	*(const char **)name_ptr = dev_name(dev);
+	return 1;
+}
+
+/*
+ * Kernel options like "test_suspend=mem" force suspend/resume sanity tests
+ * at startup time.  They're normally disabled, for faster boot and because
+ * we can't know which states really work on this particular system.
+ */
+static suspend_state_t test_state __initdata = PM_SUSPEND_ON;
+
+static char warn_bad_state[] __initdata =
+	KERN_WARNING "PM: can't test '%s' suspend state\n";
+
+static int __init setup_test_suspend(char *value)
+{
+	unsigned i;
+
+	/* "=mem" ==> "mem" */
+	value++;
+	for (i = 0; i < PM_SUSPEND_MAX; i++) {
+		if (!pm_states[i])
+			continue;
+		if (strcmp(pm_states[i], value) != 0)
+			continue;
+		test_state = (__force suspend_state_t) i;
+		return 0;
+	}
+	printk(warn_bad_state, value);
+	return 0;
+}
+__setup("test_suspend", setup_test_suspend);
+
+static int __init test_suspend(void)
+{
+	static char		warn_no_rtc[] __initdata =
+		KERN_WARNING "PM: no wakealarm-capable RTC driver is ready\n";
+
+	char			*pony = NULL;
+	struct rtc_device	*rtc = NULL;
+
+	/* PM is initialized by now; is that state testable? */
+	if (test_state == PM_SUSPEND_ON)
+		goto done;
+	if (!valid_state(test_state)) {
+		printk(warn_bad_state, pm_states[test_state]);
+		goto done;
+	}
+
+	/* RTCs have initialized by now too ... can we use one? */
+	class_find_device(rtc_class, NULL, &pony, has_wakealarm);
+	if (pony)
+		rtc = rtc_class_open(pony);
+	if (!rtc) {
+		printk(warn_no_rtc);
+		goto done;
+	}
+
+	/* go for it */
+	test_wakealarm(rtc, test_state);
+	rtc_class_close(rtc);
+done:
+	return 0;
+}
+late_initcall(test_suspend);

