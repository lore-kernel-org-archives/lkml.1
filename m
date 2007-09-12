Return-Path: <linux-kernel-owner+w=401wt.eu-S966882AbXILLC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966882AbXILLC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 07:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966091AbXILLCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 07:02:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39061 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964778AbXILLCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 07:02:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH -mm] Hibernation: Enter platform hibernation state in a consistent way (rev. 4)
Date: Wed, 12 Sep 2007 13:14:08 +0200
User-Agent: KMail/1.9.5
Cc: David Brownell <david-b@pacbell.net>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Stefan Becker <Stefan.Becker@nokia.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709121314.09676.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make hibernation_platform_enter() execute the enter-a-sleep-state sequence
instead of the mixed shutdown-with-entering-S4 thing.

Replace the shutting down of devices done by kernel_shutdown_prepare(), before
entering the ACPI S4 sleep state, with suspending them and the shutting down of
sysdevs with calling device_power_down(PMSG_SUSPEND) (just like before entering
S1 or S3, but the target state is now S4).  Also, disable the nonboot CPUs
before entering the sleep state (S4), which generally always is a good idea.

This is known to fix the "double disk spin down during hibernation" on some
machines, eg. HPC nx6325 (ref. http://lkml.org/lkml/2007/8/7/316 and the
following thread).  Moreover, it has been reported to make
/sys/class/rtc/rtc0/wakealarm work correctly with hibernation for some users.
It also generally causes the hibernation state (ACPI S4) to be entered faster.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 kernel/power/disk.c |   61 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 17 deletions(-)

Index: linux-2.6.23-rc6/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc6.orig/kernel/power/disk.c
+++ linux-2.6.23-rc6/kernel/power/disk.c
@@ -222,21 +222,48 @@ int hibernation_platform_enter(void)
 {
 	int error;
 
-	if (hibernation_ops) {
-		kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
-		/*
-		 * We have cancelled the power transition by running
-		 * hibernation_ops->finish() before saving the image, so we
-		 * should let the firmware know that we're going to enter the
-		 * sleep state after all
-		 */
-		error = hibernation_ops->prepare();
-		sysdev_shutdown();
-		if (!error)
-			error = hibernation_ops->enter();
-	} else {
-		error = -ENOSYS;
+	if (!hibernation_ops)
+		return -ENOSYS;
+
+	/*
+	 * We have cancelled the power transition by running
+	 * hibernation_ops->finish() before saving the image, so we should let
+	 * the firmware know that we're going to enter the sleep state after all
+	 */
+	error = hibernation_ops->start();
+	if (error)
+		return error;
+
+	suspend_console();
+	error = device_suspend(PMSG_SUSPEND);
+	if (error)
+		return error;
+
+	error = hibernation_ops->prepare();
+	if (error)
+		goto Resume_devices;
+
+	error = disable_nonboot_cpus();
+	if (error)
+		goto Finish;
+
+	local_irq_disable();
+	error = device_power_down(PMSG_SUSPEND);
+	if (!error) {
+		hibernation_ops->enter();
+		/* We should never get here */
+		while (1);
 	}
+	local_irq_enable();
+
+	/*
+	 * We don't need to reenable the nonboot CPUs or resume consoles, since
+	 * the system is going to be halted anyway.
+	 */
+ Finish:
+	hibernation_ops->finish();
+ Resume_devices:
+	device_resume();
 	return error;
 }
 
@@ -253,14 +280,14 @@ static void power_down(void)
 	case HIBERNATION_TEST:
 	case HIBERNATION_TESTPROC:
 		break;
-	case HIBERNATION_SHUTDOWN:
-		kernel_power_off();
-		break;
 	case HIBERNATION_REBOOT:
 		kernel_restart(NULL);
 		break;
 	case HIBERNATION_PLATFORM:
 		hibernation_platform_enter();
+	case HIBERNATION_SHUTDOWN:
+		kernel_power_off();
+		break;
 	}
 	kernel_halt();
 	/*
