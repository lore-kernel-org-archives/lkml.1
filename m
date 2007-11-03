Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXKCTnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXKCTnF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 15:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756874AbXKCTmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 15:42:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756676AbXKCTmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 15:42:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 1/3] Suspend: Testing facility (rev. 2)
Date: Sat, 3 Nov 2007 20:56:32 +0100
User-Agent: KMail/1.9.5
Cc: Johannes Berg <johannes@sipsolutions.net>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711032054.40195.rjw@sisk.pl>
In-Reply-To: <200711032054.40195.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711032056.33330.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce sysfs attribute /sys/power/pm_test allowing one to test the suspend
core code.  Namely, writing one of the strings:

freezer
devices
platform
processors
core

to this file causes the suspend code to work in one of the test modes defined as
follows:

freezer - test the freezing of processes
devices - test the freezing of processes and suspending of devices
platform - test the freezing of processes, suspending of devices and platform
           global control methods(*)
processors - test the freezing of processes, suspending of devices, platform
             global control methods and the disabling of nonboot CPUs
core - test the freezing of processes, suspending of devices, platform global
       control methods, the disabling of nonboot CPUs and suspending of
       platform/system devices

(*) These are ACPI global control methods on ACPI systems

Then, if a suspend is started by normal means, the suspend core will perform
its normal operations up to the point indicated by given test level.  Next, it
will wait for 5 seconds and carry out the resume operations needed to transition
the system back to the fully functional state.

Writing "none" to /sys/power/pm_test turns the testing off.

When open for reading, /sys/power/pm_test contains a space-separated list of all
available tests (including "none" that represents the normal functionality) in
which the current test level is indicated by square brackets.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c  |  109 ++++++++++++++++++++++++++++++++++++++++++++++-----
 kernel/power/power.h |   18 ++++++++
 2 files changed, 118 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -31,6 +31,80 @@ DEFINE_MUTEX(pm_mutex);
 unsigned int pm_flags;
 EXPORT_SYMBOL(pm_flags);
 
+#ifdef CONFIG_PM_DEBUG
+int pm_test_level = TEST_NONE;
+
+static int suspend_test(int level)
+{
+	if (pm_test_level == level) {
+		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
+		mdelay(5000);
+		return 1;
+	}
+	return 0;
+}
+
+static const char * const pm_tests[__TEST_AFTER_LAST] = {
+	[TEST_NONE] = "none",
+	[TEST_CORE] = "core",
+	[TEST_CPUS] = "processors",
+	[TEST_PLATFORM] = "platform",
+	[TEST_DEVICES] = "devices",
+	[TEST_FREEZER] = "freezer",
+};
+
+static ssize_t pm_test_show(struct kset *kset, char *buf)
+{
+	char *s = buf;
+	int level;
+
+	for (level = TEST_FIRST; level <= TEST_MAX; level++)
+		if (pm_tests[level]) {
+			if (level == pm_test_level)
+				s += sprintf(s, "[%s] ", pm_tests[level]);
+			else
+				s += sprintf(s, "%s ", pm_tests[level]);
+		}
+
+	if (s != buf)
+		/* convert the last space to a newline */
+		*(s-1) = '\n';
+
+	return (s - buf);
+}
+
+static ssize_t pm_test_store(struct kset *kset, const char *buf, size_t n)
+{
+	const char * const *s;
+	int level;
+	char *p;
+	int len;
+	int error = -EINVAL;
+
+	p = memchr(buf, '\n', n);
+	len = p ? p - buf : n;
+
+	mutex_lock(&pm_mutex);
+
+	level = TEST_FIRST;
+	for (s = &pm_tests[level]; level <= TEST_MAX; s++, level++)
+		if (*s && len == strlen(*s) && !strncmp(buf, *s, len)) {
+			pm_test_level = level;
+			error = 0;
+			break;
+		}
+
+	mutex_unlock(&pm_mutex);
+
+	return error ? error : n;
+}
+
+power_attr(pm_test);
+#else /* !CONFIG_PM_DEBUG */
+static inline int suspend_test(int level) { return 0; }
+#endif /* !CONFIG_PM_DEBUG */
+
+
 #ifdef CONFIG_SUSPEND
 
 /* This is just an arbitrary number */
@@ -136,7 +210,10 @@ static int suspend_enter(suspend_state_t
 		printk(KERN_ERR "Some devices failed to power down\n");
 		goto Done;
 	}
-	error = suspend_ops->enter(state);
+
+	if (!suspend_test(TEST_CORE))
+		error = suspend_ops->enter(state);
+
 	device_power_up();
  Done:
 	arch_suspend_enable_irqs();
@@ -167,16 +244,25 @@ int suspend_devices_and_enter(suspend_st
 		printk(KERN_ERR "Some devices failed to suspend\n");
 		goto Resume_console;
 	}
+
+	if (suspend_test(TEST_DEVICES))
+		goto Resume_devices;
+
 	if (suspend_ops->prepare) {
 		error = suspend_ops->prepare();
 		if (error)
 			goto Resume_devices;
 	}
+
+	if (suspend_test(TEST_PLATFORM))
+		goto Finish;
+
 	error = disable_nonboot_cpus();
-	if (!error)
+	if (!error && !suspend_test(TEST_CPUS))
 		suspend_enter(state);
 
 	enable_nonboot_cpus();
+ Finish:
 	if (suspend_ops->finish)
 		suspend_ops->finish();
  Resume_devices:
@@ -243,12 +329,17 @@ static int enter_state(suspend_state_t s
 	printk("done.\n");
 
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
-	if ((error = suspend_prepare()))
+	error = suspend_prepare();
+	if (error)
 		goto Unlock;
 
+	if (suspend_test(TEST_FREEZER))
+		goto Finish;
+
 	pr_debug("PM: Entering %s sleep\n", pm_states[state]);
 	error = suspend_devices_and_enter(state);
 
+ Finish:
 	pr_debug("PM: Finishing wakeup.\n");
 	suspend_finish();
  Unlock:
@@ -366,18 +457,18 @@ pm_trace_store(struct kset *kset, const 
 }
 
 power_attr(pm_trace);
+#endif /* CONFIG_PM_TRACE */
 
 static struct attribute * g[] = {
 	&state_attr.attr,
+#ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
+#endif
+#ifdef CONFIG_PM_DEBUG
+	&pm_test_attr.attr,
+#endif
 	NULL,
 };
-#else
-static struct attribute * g[] = {
-	&state_attr.attr,
-	NULL,
-};
-#endif /* CONFIG_PM_TRACE */
 
 static struct attribute_group attr_group = {
 	.attrs = g,
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -190,3 +190,21 @@ int restore_highmem(void);
 static inline unsigned int count_highmem_pages(void) { return 0; }
 static inline int restore_highmem(void) { return 0; }
 #endif
+
+/*
+ * Suspend test levels
+ */
+enum {
+	/* keep first */
+	TEST_NONE,
+	TEST_CORE,
+	TEST_CPUS,
+	TEST_PLATFORM,
+	TEST_DEVICES,
+	TEST_FREEZER,
+	/* keep last */
+	__TEST_AFTER_LAST
+};
+
+#define TEST_FIRST	TEST_NONE
+#define TEST_MAX	(__TEST_AFTER_LAST - 1)

