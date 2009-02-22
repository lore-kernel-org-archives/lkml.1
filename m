Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZBVRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZBVRlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZBVRkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:40:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34550 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbZBVRkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:40:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/2] PM: Split up sysdev_[suspend|resume] from device_power_[down|up]
Date: Sun, 22 Feb 2009 18:38:50 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl>
In-Reply-To: <200902221837.49396.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902221838.51548.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move the sysdev_suspend/resume from the callee to the callers, with
no real change in semantics, so that we can rework the disabling of
interrupts during suspend/hibernation.

This is based on an earlier patch from Linus.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/apm_32.c  |    4 ++++
 drivers/base/base.h       |    2 --
 drivers/base/power/main.c |    3 ---
 drivers/xen/manage.c      |    8 ++++++++
 include/linux/pm.h        |    2 ++
 kernel/kexec.c            |    7 +++++++
 kernel/power/disk.c       |   11 +++++++++++
 kernel/power/main.c       |    8 ++++++--
 8 files changed, 38 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6/arch/x86/kernel/apm_32.c
@@ -1192,6 +1192,7 @@ static int suspend(int vetoable)
 	device_suspend(PMSG_SUSPEND);
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
+	sysdev_suspend(PMSG_SUSPEND);
 
 	local_irq_enable();
 
@@ -1208,6 +1209,7 @@ static int suspend(int vetoable)
 	if (err != APM_SUCCESS)
 		apm_error("suspend", err);
 	err = (err == APM_SUCCESS) ? 0 : -EIO;
+	sysdev_resume();
 	device_power_up(PMSG_RESUME);
 	local_irq_enable();
 	device_resume(PMSG_RESUME);
@@ -1228,6 +1230,7 @@ static void standby(void)
 
 	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
+	sysdev_suspend(PMSG_SUSPEND);
 	local_irq_enable();
 
 	err = set_system_power_state(APM_STATE_STANDBY);
@@ -1235,6 +1238,7 @@ static void standby(void)
 		apm_error("standby", err);
 
 	local_irq_disable();
+	sysdev_resume();
 	device_power_up(PMSG_RESUME);
 	local_irq_enable();
 }
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -333,7 +333,6 @@ static void dpm_power_up(pm_message_t st
  */
 void device_power_up(pm_message_t state)
 {
-	sysdev_resume();
 	dpm_power_up(state);
 }
 EXPORT_SYMBOL_GPL(device_power_up);
@@ -577,8 +576,6 @@ int device_power_down(pm_message_t state
 		}
 		dev->power.status = DPM_OFF_IRQ;
 	}
-	if (!error)
-		error = sysdev_suspend(state);
 	if (error)
 		dpm_power_up(resume_event(state));
 	return error;
Index: linux-2.6/drivers/xen/manage.c
===================================================================
--- linux-2.6.orig/drivers/xen/manage.c
+++ linux-2.6/drivers/xen/manage.c
@@ -45,6 +45,13 @@ static int xen_suspend(void *data)
 		       err);
 		return err;
 	}
+	err = sysdev_suspend(PMSG_SUSPEND);
+	if (err) {
+		printk(KERN_ERR "xen_suspend: sysdev_suspend failed: %d\n",
+			err);
+		device_power_up(PMSG_RESUME);
+		return err;
+	}
 
 	xen_mm_pin_all();
 	gnttab_suspend();
@@ -61,6 +68,7 @@ static int xen_suspend(void *data)
 	gnttab_resume();
 	xen_mm_unpin_all();
 
+	sysdev_resume();
 	device_power_up(PMSG_RESUME);
 
 	if (!*cancelled) {
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1465,6 +1465,11 @@ int kernel_kexec(void)
 		error = device_power_down(PMSG_FREEZE);
 		if (error)
 			goto Enable_irqs;
+
+		/* Suspend system devices */
+		error = sysdev_suspend(PMSG_FREEZE);
+		if (error)
+			goto Power_up_devices;
 	} else
 #endif
 	{
@@ -1477,6 +1482,8 @@ int kernel_kexec(void)
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
+		sysdev_resume();
+ Power_up_devices:
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
 		local_irq_enable();
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -227,6 +227,12 @@ static int create_image(int platform_mod
 			"aborting hibernation\n");
 		goto Enable_irqs;
 	}
+	sysdev_suspend(PMSG_FREEZE);
+	if (error) {
+		printk(KERN_ERR "PM: Some devices failed to power down, "
+			"aborting hibernation\n");
+		goto Power_up_devices;
+	}
 
 	if (hibernation_test(TEST_CORE))
 		goto Power_up;
@@ -242,9 +248,11 @@ static int create_image(int platform_mod
 	if (!in_suspend)
 		platform_leave(platform_mode);
  Power_up:
+	sysdev_resume();
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
+ Power_up_devices:
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
  Enable_irqs:
@@ -335,6 +343,7 @@ static int resume_target_kernel(void)
 			"aborting resume\n");
 		goto Enable_irqs;
 	}
+	sysdev_suspend(PMSG_QUIESCE);
 	/* We'll ignore saved state, but this gets preempt count (etc) right */
 	save_processor_state();
 	error = restore_highmem();
@@ -357,6 +366,7 @@ static int resume_target_kernel(void)
 	swsusp_free();
 	restore_processor_state();
 	touch_softlockup_watchdog();
+	sysdev_resume();
 	device_power_up(PMSG_RECOVER);
  Enable_irqs:
 	local_irq_enable();
@@ -440,6 +450,7 @@ int hibernation_platform_enter(void)
 	local_irq_disable();
 	error = device_power_down(PMSG_HIBERNATE);
 	if (!error) {
+		sysdev_suspend(PMSG_HIBERNATE);
 		hibernation_ops->enter();
 		/* We should never get here */
 		while (1);
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -298,8 +298,12 @@ static int suspend_enter(suspend_state_t
 		goto Done;
 	}
 
-	if (!suspend_test(TEST_CORE))
-		error = suspend_ops->enter(state);
+	error = sysdev_suspend(PMSG_SUSPEND);
+	if (!error) {
+		if (!suspend_test(TEST_CORE))
+			error = suspend_ops->enter(state);
+		sysdev_resume();
+	}
 
 	device_power_up(PMSG_RESUME);
  Done:
Index: linux-2.6/drivers/base/base.h
===================================================================
--- linux-2.6.orig/drivers/base/base.h
+++ linux-2.6/drivers/base/base.h
@@ -88,8 +88,6 @@ extern void driver_detach(struct device_
 extern int driver_probe_device(struct device_driver *drv, struct device *dev);
 
 extern void sysdev_shutdown(void);
-extern int sysdev_suspend(pm_message_t state);
-extern int sysdev_resume(void);
 
 extern char *make_class_name(const char *name, struct kobject *kobj);
 
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -381,10 +381,12 @@ struct dev_pm_info {
 
 #ifdef CONFIG_PM_SLEEP
 extern void device_pm_lock(void);
+extern int sysdev_resume(void);
 extern void device_power_up(pm_message_t state);
 extern void device_resume(pm_message_t state);
 
 extern void device_pm_unlock(void);
+extern int sysdev_suspend(pm_message_t state);
 extern int device_power_down(pm_message_t state);
 extern int device_suspend(pm_message_t state);
 extern int device_prepare_suspend(pm_message_t state);

