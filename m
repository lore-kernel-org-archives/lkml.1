Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbZCAWa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbZCAWa1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 17:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755657AbZCAWaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 17:30:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53543 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258AbZCAWaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 17:30:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 3/4] PM: Change hibernation code ordering
Date: Sun, 1 Mar 2009 23:26:46 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>
References: <200902221837.49396.rjw@sisk.pl> <200903012321.40328.rjw@sisk.pl>
In-Reply-To: <200903012321.40328.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903012326.48459.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Change the ordering of the hibernation core code so that the platform
"prepare" callbacks are executed and the nonboot CPUs are disabled
after calling device drivers' "late suspend" methods.

This change (along with the previous analogous change of the suspend
core code) will allow us to rework the PCI PM core so that the power
state of devices is changed in the "late" phase of suspend (and
analogously in the "early" phase of resume), which in turn will allow
us to avoid the race condition where a device using shared interrupts
is put into a low power state with interrupts enabled and then an
interrupt (for another device) comes in and confuses its driver.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/disk.c |  109 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 61 insertions(+), 48 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -228,13 +228,22 @@ static int create_image(int platform_mod
 		goto Unlock;
 	}
 
+	error = platform_pre_snapshot(platform_mode);
+	if (error || hibernation_test(TEST_PLATFORM))
+		goto Platform_finish;
+
+	error = disable_nonboot_cpus();
+	if (error || hibernation_test(TEST_CPUS)
+	    || hibernation_testmode(HIBERNATION_TEST))
+		goto Enable_cpus;
+
 	local_irq_disable();
 
 	sysdev_suspend(PMSG_FREEZE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting hibernation\n");
-		goto Power_up_devices;
+		goto Enable_irqs;
 	}
 
 	if (hibernation_test(TEST_CORE))
@@ -250,15 +259,22 @@ static int create_image(int platform_mod
 	restore_processor_state();
 	if (!in_suspend)
 		platform_leave(platform_mode);
+
  Power_up:
 	sysdev_resume();
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
 
- Power_up_devices:
+ Enable_irqs:
 	local_irq_enable();
 
+ Enable_cpus:
+	enable_nonboot_cpus();
+
+ Platform_finish:
+	platform_finish(platform_mode);
+
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
 
@@ -298,25 +314,9 @@ int hibernation_snapshot(int platform_mo
 	if (hibernation_test(TEST_DEVICES))
 		goto Recover_platform;
 
-	error = platform_pre_snapshot(platform_mode);
-	if (error || hibernation_test(TEST_PLATFORM))
-		goto Finish;
-
-	error = disable_nonboot_cpus();
-	if (!error) {
-		if (hibernation_test(TEST_CPUS))
-			goto Enable_cpus;
-
-		if (hibernation_testmode(HIBERNATION_TEST))
-			goto Enable_cpus;
+	error = create_image(platform_mode);
+	/* Control returns here after successful restore */
 
-		error = create_image(platform_mode);
-		/* Control returns here after successful restore */
-	}
- Enable_cpus:
-	enable_nonboot_cpus();
- Finish:
-	platform_finish(platform_mode);
  Resume_devices:
 	device_resume(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
@@ -338,7 +338,7 @@ int hibernation_snapshot(int platform_mo
  *	kernel.
  */
 
-static int resume_target_kernel(void)
+static int resume_target_kernel(bool platform_mode)
 {
 	int error;
 
@@ -351,9 +351,20 @@ static int resume_target_kernel(void)
 		goto Unlock;
 	}
 
+	error = platform_pre_restore(platform_mode);
+	if (error)
+		goto Cleanup;
+
+	error = disable_nonboot_cpus();
+	if (error)
+		goto Enable_cpus;
+
 	local_irq_disable();
 
-	sysdev_suspend(PMSG_QUIESCE);
+	error = sysdev_suspend(PMSG_QUIESCE);
+	if (error)
+		goto Enable_irqs;
+
 	/* We'll ignore saved state, but this gets preempt count (etc) right */
 	save_processor_state();
 	error = restore_highmem();
@@ -379,8 +390,15 @@ static int resume_target_kernel(void)
 
 	sysdev_resume();
 
+ Enable_irqs:
 	local_irq_enable();
 
+ Enable_cpus:
+	enable_nonboot_cpus();
+
+ Cleanup:
+	platform_restore_cleanup(platform_mode);
+
 	device_power_up(PMSG_RECOVER);
 
  Unlock:
@@ -405,19 +423,10 @@ int hibernation_restore(int platform_mod
 	pm_prepare_console();
 	suspend_console();
 	error = device_suspend(PMSG_QUIESCE);
-	if (error)
-		goto Finish;
-
-	error = platform_pre_restore(platform_mode);
 	if (!error) {
-		error = disable_nonboot_cpus();
-		if (!error)
-			error = resume_target_kernel();
-		enable_nonboot_cpus();
+		error = resume_target_kernel(platform_mode);
+		device_resume(PMSG_RECOVER);
 	}
-	platform_restore_cleanup(platform_mode);
-	device_resume(PMSG_RECOVER);
- Finish:
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -453,34 +462,38 @@ int hibernation_platform_enter(void)
 		goto Resume_devices;
 	}
 
+	device_pm_lock();
+
+	error = device_power_down(PMSG_HIBERNATE);
+	if (error)
+		goto Unlock;
+
 	error = hibernation_ops->prepare();
 	if (error)
-		goto Resume_devices;
+		goto Platofrm_finish;
 
 	error = disable_nonboot_cpus();
 	if (error)
-		goto Finish;
-
-	device_pm_lock();
-
-	error = device_power_down(PMSG_HIBERNATE);
-	if (!error) {
-		local_irq_disable();
-		sysdev_suspend(PMSG_HIBERNATE);
-		hibernation_ops->enter();
-		/* We should never get here */
-		while (1);
-	}
+		goto Platofrm_finish;
 
-	device_pm_unlock();
+	local_irq_disable();
+	sysdev_suspend(PMSG_HIBERNATE);
+	hibernation_ops->enter();
+	/* We should never get here */
+	while (1);
 
 	/*
 	 * We don't need to reenable the nonboot CPUs or resume consoles, since
 	 * the system is going to be halted anyway.
 	 */
- Finish:
+ Platofrm_finish:
 	hibernation_ops->finish();
 
+	device_power_up(PMSG_RESTORE);
+
+ Unlock:
+	device_pm_unlock();
+
  Resume_devices:
 	entering_platform_hibernation = false;
 	device_resume(PMSG_RESTORE);
