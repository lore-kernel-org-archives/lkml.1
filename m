Return-Path: <linux-kernel-owner+w=401wt.eu-S965805AbXILK6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965805AbXILK6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 06:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965097AbXILK6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 06:58:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760971AbXILK6H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 06:58:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH -mm] Hibernation: Check if ACPI is enabled during restore in the right place
Date: Wed, 12 Sep 2007 13:09:39 +0200
User-Agent: KMail/1.9.5
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709121309.40687.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The following scenario leads to total confusion of the platform firmware on
some boxes (eg. HPC nx6325):
* Hibernate with ACPI enabled
* Resume passing "acpi=off" to the boot kernel

To prevent this from happening it's necessary to check if ACPI is enabled (and
enable it if that's not the case) _right_ _after_ control has been transfered
from the boot kernel to the image kernel, before device_power_up() is called
(ie. with interrupts disabled).  Enabling ACPI after calling device_power_up()
turns out to be insufficient.

For this reason, introduce new hibernation callback ->leave() that will be
executed before device_power_up() by the restored image kernel.  To make it
work, it also is necessary to move swsusp_suspend() from swsusp.c to disk.c
(it's name is changed to "create_image", which is more up to the point).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/acpi/sleep/main.c |    7 ++++-
 include/linux/suspend.h   |    7 +++++
 kernel/power/disk.c       |   58 +++++++++++++++++++++++++++++++++++++++++++++-
 kernel/power/power.h      |    1 
 kernel/power/swsusp.c     |   33 --------------------------
 5 files changed, 70 insertions(+), 36 deletions(-)

Index: linux-2.6.23-rc6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.23-rc6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.23-rc6/drivers/acpi/sleep/main.c
@@ -238,13 +238,17 @@ static int acpi_hibernation_enter(void)
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
 
-static void acpi_hibernation_finish(void)
+static void acpi_hibernation_leave(void)
 {
 	/*
 	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
 	 * enable it here.
 	 */
 	acpi_enable();
+}
+
+static void acpi_hibernation_finish(void)
+{
 	acpi_leave_sleep_state(ACPI_STATE_S4);
 	acpi_disable_wakeup_device(ACPI_STATE_S4);
 
@@ -274,6 +278,7 @@ static struct platform_hibernation_ops a
 	.finish = acpi_hibernation_finish,
 	.prepare = acpi_hibernation_prepare,
 	.enter = acpi_hibernation_enter,
+	.leave = acpi_hibernation_leave,
 	.pre_restore = acpi_hibernation_pre_restore,
 	.restore_cleanup = acpi_hibernation_restore_cleanup,
 };
Index: linux-2.6.23-rc6/include/linux/suspend.h
===================================================================
--- linux-2.6.23-rc6.orig/include/linux/suspend.h
+++ linux-2.6.23-rc6/include/linux/suspend.h
@@ -156,6 +156,12 @@ extern void mark_free_pages(struct zone 
  *	Called after the nonboot CPUs have been disabled and all of the low
  *	level devices have been shut down (runs with IRQs off).
  *
+ * @leave: Perform the first stage of the cleanup after the system sleep state
+ *	indicated by @set_target() has been left.
+ *	Called right after the control has been passed from the boot kernel to
+ *	the image kernel, before the nonboot CPUs are enabled and before devices
+ *	are resumed.  Executed with interrupts disabled.
+ *
  * @pre_restore: Prepare system for the restoration from a hibernation image.
  *	Called right after devices have been frozen and before the nonboot
  *	CPUs are disabled (runs with IRQs on).
@@ -170,6 +176,7 @@ struct platform_hibernation_ops {
 	void (*finish)(void);
 	int (*prepare)(void);
 	int (*enter)(void);
+	void (*leave)(void);
 	int (*pre_restore)(void);
 	void (*restore_cleanup)(void);
 };
Index: linux-2.6.23-rc6/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc6.orig/kernel/power/disk.c
+++ linux-2.6.23-rc6/kernel/power/disk.c
@@ -93,6 +93,17 @@ static int platform_pre_snapshot(int pla
 }
 
 /**
+ *	platform_leave - prepare the machine for switching to the normal mode
+ *	of operation using the platform driver (called with interrupts disabled)
+ */
+
+static void platform_leave(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->leave();
+}
+
+/**
  *	platform_finish - switch the machine to the normal mode of operation
  *	using the platform driver (must be called after platform_prepare())
  */
@@ -129,6 +140,51 @@ static void platform_restore_cleanup(int
 }
 
 /**
+ *	create_image - freeze devices that need to be frozen with interrupts
+ *	off, create the hibernation image and thaw those devices.  Control
+ *	reappears in this routine after a restore.
+ */
+
+int create_image(int platform_mode)
+{
+	int error;
+
+	error = arch_prepare_suspend();
+	if (error)
+		return error;
+
+	local_irq_disable();
+	/* At this point, device_suspend() has been called, but *not*
+	 * device_power_down(). We *must* call device_power_down() now.
+	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
+	 * become desynchronized with the actual state of the hardware
+	 * at resume time, and evil weirdness ensues.
+	 */
+	error = device_power_down(PMSG_FREEZE);
+	if (error) {
+		printk(KERN_ERR "Some devices failed to power down, "
+			KERN_ERR "aborting suspend\n");
+		goto Enable_irqs;
+	}
+
+	save_processor_state();
+	error = swsusp_arch_suspend();
+	if (error)
+		printk(KERN_ERR "Error %d while creating the image\n", error);
+	/* Restore control flow magically appears here */
+	restore_processor_state();
+	if (!in_suspend)
+		platform_leave(platform_mode);
+	/* NOTE:  device_power_up() is just a resume() for devices
+	 * that suspended with irqs off ... no overall powerup.
+	 */
+	device_power_up();
+ Enable_irqs:
+	local_irq_enable();
+	return error;
+}
+
+/**
  *	hibernation_snapshot - quiesce devices and create the hibernation
  *	snapshot image.
  *	@platform_mode - if set, use the platform driver, if available, to
@@ -163,7 +219,7 @@ int hibernation_snapshot(int platform_mo
 	if (!error) {
 		if (hibernation_mode != HIBERNATION_TEST) {
 			in_suspend = 1;
-			error = swsusp_suspend();
+			error = create_image(platform_mode);
 			/* Control returns here after successful restore */
 		} else {
 			printk("swsusp debug: Waiting for 5 seconds.\n");
Index: linux-2.6.23-rc6/kernel/power/power.h
===================================================================
--- linux-2.6.23-rc6.orig/kernel/power/power.h
+++ linux-2.6.23-rc6/kernel/power/power.h
@@ -183,7 +183,6 @@ extern int swsusp_swap_in_use(void);
 extern int swsusp_check(void);
 extern int swsusp_shrink_memory(void);
 extern void swsusp_free(void);
-extern int swsusp_suspend(void);
 extern int swsusp_resume(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
Index: linux-2.6.23-rc6/kernel/power/swsusp.c
===================================================================
--- linux-2.6.23-rc6.orig/kernel/power/swsusp.c
+++ linux-2.6.23-rc6/kernel/power/swsusp.c
@@ -270,39 +270,6 @@ int swsusp_shrink_memory(void)
 	return 0;
 }
 
-int swsusp_suspend(void)
-{
-	int error;
-
-	if ((error = arch_prepare_suspend()))
-		return error;
-
-	local_irq_disable();
-	/* At this point, device_suspend() has been called, but *not*
-	 * device_power_down(). We *must* device_power_down() now.
-	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
-	 * become desynchronized with the actual state of the hardware
-	 * at resume time, and evil weirdness ensues.
-	 */
-	if ((error = device_power_down(PMSG_FREEZE))) {
-		printk(KERN_ERR "Some devices failed to power down, aborting suspend\n");
-		goto Enable_irqs;
-	}
-
-	save_processor_state();
-	if ((error = swsusp_arch_suspend()))
-		printk(KERN_ERR "Error %d suspending\n", error);
-	/* Restore control flow magically appears here */
-	restore_processor_state();
-	/* NOTE:  device_power_up() is just a resume() for devices
-	 * that suspended with irqs off ... no overall powerup.
-	 */
-	device_power_up();
- Enable_irqs:
-	local_irq_enable();
-	return error;
-}
-
 int swsusp_resume(void)
 {
 	int error;
