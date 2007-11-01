Return-Path: <linux-kernel-owner+w=401wt.eu-S1760857AbXKAWox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760857AbXKAWox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbXKAWoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:44:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50816 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758471AbXKAWoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:44:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 2/3] Hibernation: New testing facility
Date: Thu, 1 Nov 2007 23:59:15 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200711012357.27797.rjw@sisk.pl>
In-Reply-To: <200711012357.27797.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711012359.16428.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to test the hibernation core code with the help of the
/sys/power/pm_test_level attribute introduced for suspend testing in the
previous patch.

Writing a number (1-5) to this file causes the hibernation code to work in one
of the test modes defined as follows:

5 - test the freezing of processes
4 - test the freezing of processes and suspending of devices
3 - test the freezing of processes, suspending of devices and platform global
    control methods(*)
2 - test the freezing of processes, suspending of devices, platform global
    control methods(*) and the disabling of nonboot CPUs
1 - test the freezing of processes, suspending of devices, platform global
    control methods(*), the disabling of nonboot CPUs and suspending of
    platform/system devices

(*) - the platform global control methods are only available on ACPI systems
      and are only tested if the hibernation mode is set to "platform"

Then, if a hibernation is started by normal means, the hibernation core will
perform its normal operations up to the point indicated by the test level.
Next, it will wait for 5 seconds and carry out the resume operations needed to
transition the system back to the fully functional state.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c  |   70 ++++++++++++++++++++++++++++++++++++++++-----------
 kernel/power/power.h |    2 +
 2 files changed, 57 insertions(+), 15 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -70,6 +70,35 @@ void hibernation_set_ops(struct platform
 	mutex_unlock(&pm_mutex);
 }
 
+#ifdef CONFIG_PM_DEBUG
+static void hibernation_debug_sleep(void)
+{
+	printk(KERN_INFO "hibernation debug: Waiting for 5 seconds.\n");
+	mdelay(5000);
+}
+
+static int hibernation_testmode(int mode)
+{
+	if (hibernation_mode == mode) {
+		hibernation_debug_sleep();
+		return 1;
+	}
+	return 0;
+}
+
+static int hibernation_test(int level)
+{
+	if (pm_test_level == level) {
+		hibernation_debug_sleep();
+		return 1;
+	}
+	return 0;
+}
+#else /* !CONFIG_PM_DEBUG */
+static int hibernation_testmode(int mode) { return 0; }
+static int hibernation_test(int level) { return 0; }
+#endif /* !CONFIG_PM_DEBUG */
+
 /**
  *	platform_start - tell the platform driver that we're starting
  *	hibernation
@@ -167,6 +196,10 @@ int create_image(int platform_mode)
 		goto Enable_irqs;
 	}
 
+	if (hibernation_test(TEST_CORE))
+		goto Power_up;
+
+	in_suspend = 1;
 	save_processor_state();
 	error = swsusp_arch_suspend();
 	if (error)
@@ -175,6 +208,7 @@ int create_image(int platform_mode)
 	restore_processor_state();
 	if (!in_suspend)
 		platform_leave(platform_mode);
+ Power_up:
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
@@ -211,24 +245,29 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		goto Resume_console;
 
-	error = platform_pre_snapshot(platform_mode);
-	if (error)
+	if (hibernation_test(TEST_DEVICES))
 		goto Resume_devices;
 
+	error = platform_pre_snapshot(platform_mode);
+	if (error || hibernation_test(TEST_PLATFORM))
+		goto Finish;
+
 	error = disable_nonboot_cpus();
 	if (!error) {
-		if (hibernation_mode != HIBERNATION_TEST) {
-			in_suspend = 1;
-			error = create_image(platform_mode);
-			/* Control returns here after successful restore */
-		} else {
-			printk("swsusp debug: Waiting for 5 seconds.\n");
-			mdelay(5000);
-		}
+		if (hibernation_test(TEST_CPUS))
+			goto Enable_cpus;
+
+		if (hibernation_testmode(HIBERNATION_TEST))
+			goto Enable_cpus;
+
+		error = create_image(platform_mode);
+		/* Control returns here after successful restore */
 	}
+ Enable_cpus:
 	enable_nonboot_cpus();
- Resume_devices:
+ Finish:
 	platform_finish(platform_mode);
+ Resume_devices:
 	device_resume();
  Resume_console:
 	resume_console();
@@ -406,11 +445,12 @@ int hibernate(void)
 	if (error)
 		goto Finish;
 
-	if (hibernation_mode == HIBERNATION_TESTPROC) {
-		printk("swsusp debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
+	if (hibernation_test(TEST_FREEZER))
 		goto Thaw;
-	}
+
+	if (hibernation_testmode(HIBERNATION_TESTPROC))
+		goto Thaw;
+
 	error = hibernation_snapshot(hibernation_mode == HIBERNATION_PLATFORM);
 	if (in_suspend && !error) {
 		unsigned int flags = 0;
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -192,3 +192,5 @@ enum {
 	TEST_DEVICES,
 	TEST_FREEZER
 };
+
+extern int pm_test_level;

