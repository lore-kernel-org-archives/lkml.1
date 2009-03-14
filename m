Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZCNLgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZCNLgY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 07:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755468AbZCNLfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 07:35:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40219 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZCNLfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 07:35:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/11] PM: Rework handling of interrupts during suspend-resume
Date: Sat, 14 Mar 2009 12:27:09 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       Linux PCI <linux-pci@vger.kernel.org>
References: <200902221837.49396.rjw@sisk.pl> <200903141224.29591.rjw@sisk.pl>
In-Reply-To: <200903141224.29591.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903141227.10924.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Use the functions introduced in by the previous patch,
suspend_device_irqs(), resume_device_irqs() and check_wakeup_irqs(),
to rework the handling of interrupts during suspend (hibernation) and
resume.  Namely, interrupts will only be disabled on the CPU right
before suspending sysdevs, while device drivers will be prevented
from receiving interrupts, with the help of the new helper function,
before their "late" suspend callbacks run (and analogously during
resume).

In addition, since the device interrups are now disabled before the
CPU has turned all interrupts off and the CPU will ACK the interrupts
setting the IRQ_PENDING bit for them, check in sysdev_suspend() if
any wake-up interrupts are pending and abort suspend if that's the
case.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/apm_32.c  |   15 +++++++++++----
 drivers/base/power/main.c |   20 +++++++++++---------
 drivers/base/sys.c        |    8 ++++++++
 drivers/xen/manage.c      |   16 +++++++++-------
 kernel/kexec.c            |    8 ++++----
 kernel/power/disk.c       |   39 +++++++++++++++++++++++++++++----------
 kernel/power/main.c       |   17 +++++++++++------
 7 files changed, 83 insertions(+), 40 deletions(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -287,17 +287,19 @@ void __attribute__ ((weak)) arch_suspend
  */
 static int suspend_enter(suspend_state_t state)
 {
-	int error = 0;
+	int error;
 
 	device_pm_lock();
-	arch_suspend_disable_irqs();
-	BUG_ON(!irqs_disabled());
 
-	if ((error = device_power_down(PMSG_SUSPEND))) {
+	error = device_power_down(PMSG_SUSPEND);
+	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down\n");
 		goto Done;
 	}
 
+	arch_suspend_disable_irqs();
+	BUG_ON(!irqs_disabled());
+
 	error = sysdev_suspend(PMSG_SUSPEND);
 	if (!error) {
 		if (!suspend_test(TEST_CORE))
@@ -305,11 +307,14 @@ static int suspend_enter(suspend_state_t
 		sysdev_resume();
 	}
 
-	device_power_up(PMSG_RESUME);
- Done:
 	arch_suspend_enable_irqs();
 	BUG_ON(irqs_disabled());
+
+	device_power_up(PMSG_RESUME);
+
+ Done:
 	device_pm_unlock();
+
 	return error;
 }
 
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -214,7 +214,7 @@ static int create_image(int platform_mod
 		return error;
 
 	device_pm_lock();
-	local_irq_disable();
+
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* call device_power_down() now.
 	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
@@ -225,8 +225,11 @@ static int create_image(int platform_mod
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting hibernation\n");
-		goto Enable_irqs;
+		goto Unlock;
 	}
+
+	local_irq_disable();
+
 	sysdev_suspend(PMSG_FREEZE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
@@ -252,12 +255,16 @@ static int create_image(int platform_mod
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
+
  Power_up_devices:
+	local_irq_enable();
+
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
- Enable_irqs:
-	local_irq_enable();
+
+ Unlock:
 	device_pm_unlock();
+
 	return error;
 }
 
@@ -336,13 +343,16 @@ static int resume_target_kernel(void)
 	int error;
 
 	device_pm_lock();
-	local_irq_disable();
+
 	error = device_power_down(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting resume\n");
-		goto Enable_irqs;
+		goto Unlock;
 	}
+
+	local_irq_disable();
+
 	sysdev_suspend(PMSG_QUIESCE);
 	/* We'll ignore saved state, but this gets preempt count (etc) right */
 	save_processor_state();
@@ -366,11 +376,16 @@ static int resume_target_kernel(void)
 	swsusp_free();
 	restore_processor_state();
 	touch_softlockup_watchdog();
+
 	sysdev_resume();
-	device_power_up(PMSG_RECOVER);
- Enable_irqs:
+
 	local_irq_enable();
+
+	device_power_up(PMSG_RECOVER);
+
+ Unlock:
 	device_pm_unlock();
+
 	return error;
 }
 
@@ -447,15 +462,16 @@ int hibernation_platform_enter(void)
 		goto Finish;
 
 	device_pm_lock();
-	local_irq_disable();
+
 	error = device_power_down(PMSG_HIBERNATE);
 	if (!error) {
+		local_irq_disable();
 		sysdev_suspend(PMSG_HIBERNATE);
 		hibernation_ops->enter();
 		/* We should never get here */
 		while (1);
 	}
-	local_irq_enable();
+
 	device_pm_unlock();
 
 	/*
@@ -464,12 +480,15 @@ int hibernation_platform_enter(void)
 	 */
  Finish:
 	hibernation_ops->finish();
+
  Resume_devices:
 	entering_platform_hibernation = false;
 	device_resume(PMSG_RESTORE);
 	resume_console();
+
  Close:
 	hibernation_ops->end();
+
 	return error;
 }
 
Index: linux-2.6/arch/x86/kernel/apm_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apm_32.c
+++ linux-2.6/arch/x86/kernel/apm_32.c
@@ -1190,8 +1190,10 @@ static int suspend(int vetoable)
 	struct apm_user	*as;
 
 	device_suspend(PMSG_SUSPEND);
-	local_irq_disable();
+
 	device_power_down(PMSG_SUSPEND);
+
+	local_irq_disable();
 	sysdev_suspend(PMSG_SUSPEND);
 
 	local_irq_enable();
@@ -1209,9 +1211,12 @@ static int suspend(int vetoable)
 	if (err != APM_SUCCESS)
 		apm_error("suspend", err);
 	err = (err == APM_SUCCESS) ? 0 : -EIO;
+
 	sysdev_resume();
-	device_power_up(PMSG_RESUME);
 	local_irq_enable();
+
+	device_power_up(PMSG_RESUME);
+
 	device_resume(PMSG_RESUME);
 	queue_event(APM_NORMAL_RESUME, NULL);
 	spin_lock(&user_list_lock);
@@ -1228,8 +1233,9 @@ static void standby(void)
 {
 	int err;
 
-	local_irq_disable();
 	device_power_down(PMSG_SUSPEND);
+
+	local_irq_disable();
 	sysdev_suspend(PMSG_SUSPEND);
 	local_irq_enable();
 
@@ -1239,8 +1245,9 @@ static void standby(void)
 
 	local_irq_disable();
 	sysdev_resume();
-	device_power_up(PMSG_RESUME);
 	local_irq_enable();
+
+	device_power_up(PMSG_RESUME);
 }
 
 static apm_event_t get_event(void)
Index: linux-2.6/drivers/xen/manage.c
===================================================================
--- linux-2.6.orig/drivers/xen/manage.c
+++ linux-2.6/drivers/xen/manage.c
@@ -39,12 +39,6 @@ static int xen_suspend(void *data)
 
 	BUG_ON(!irqs_disabled());
 
-	err = device_power_down(PMSG_SUSPEND);
-	if (err) {
-		printk(KERN_ERR "xen_suspend: device_power_down failed: %d\n",
-		       err);
-		return err;
-	}
 	err = sysdev_suspend(PMSG_SUSPEND);
 	if (err) {
 		printk(KERN_ERR "xen_suspend: sysdev_suspend failed: %d\n",
@@ -69,7 +63,6 @@ static int xen_suspend(void *data)
 	xen_mm_unpin_all();
 
 	sysdev_resume();
-	device_power_up(PMSG_RESUME);
 
 	if (!*cancelled) {
 		xen_irq_resume();
@@ -108,6 +101,12 @@ static void do_suspend(void)
 	/* XXX use normal device tree? */
 	xenbus_suspend();
 
+	err = device_power_down(PMSG_SUSPEND);
+	if (err) {
+		printk(KERN_ERR "device_power_down failed: %d\n", err);
+		goto resume_devices;
+	}
+
 	err = stop_machine(xen_suspend, &cancelled, &cpumask_of_cpu(0));
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
@@ -120,6 +119,9 @@ static void do_suspend(void)
 	} else
 		xenbus_suspend_cancel();
 
+	device_power_up(PMSG_RESUME);
+
+resume_devices:
 	device_resume(PMSG_RESUME);
 
 	/* Make sure timer events get retriggered on all CPUs */
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1454,7 +1454,6 @@ int kernel_kexec(void)
 		if (error)
 			goto Resume_devices;
 		device_pm_lock();
-		local_irq_disable();
 		/* At this point, device_suspend() has been called,
 		 * but *not* device_power_down(). We *must*
 		 * device_power_down() now.  Otherwise, drivers for
@@ -1464,8 +1463,9 @@ int kernel_kexec(void)
 		 */
 		error = device_power_down(PMSG_FREEZE);
 		if (error)
-			goto Enable_irqs;
+			goto Unlock_pm;
 
+		local_irq_disable();
 		/* Suspend system devices */
 		error = sysdev_suspend(PMSG_FREEZE);
 		if (error)
@@ -1484,9 +1484,9 @@ int kernel_kexec(void)
 	if (kexec_image->preserve_context) {
 		sysdev_resume();
  Power_up_devices:
-		device_power_up(PMSG_RESTORE);
- Enable_irqs:
 		local_irq_enable();
+		device_power_up(PMSG_RESTORE);
+ Unlock_pm:
 		device_pm_unlock();
 		enable_nonboot_cpus();
  Resume_devices:
Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -23,6 +23,7 @@
 #include <linux/pm.h>
 #include <linux/resume-trace.h>
 #include <linux/rwsem.h>
+#include <linux/interrupt.h>
 
 #include "../base.h"
 #include "power.h"
@@ -305,7 +306,8 @@ static int resume_device_noirq(struct de
  *	Execute the appropriate "noirq resume" callback for all devices marked
  *	as DPM_OFF_IRQ.
  *
- *	Must be called with interrupts disabled and only one CPU running.
+ *	Must be called under dpm_list_mtx.  Device drivers should not receive
+ *	interrupts while it's being executed.
  */
 static void dpm_power_up(pm_message_t state)
 {
@@ -326,14 +328,13 @@ static void dpm_power_up(pm_message_t st
  *	device_power_up - Turn on all devices that need special attention.
  *	@state: PM transition of the system being carried out.
  *
- *	Power on system devices, then devices that required we shut them down
- *	with interrupts disabled.
- *
- *	Must be called with interrupts disabled.
+ *	Call the "early" resume handlers and enable device drivers to receive
+ *	interrupts.
  */
 void device_power_up(pm_message_t state)
 {
 	dpm_power_up(state);
+	resume_device_irqs();
 }
 EXPORT_SYMBOL_GPL(device_power_up);
 
@@ -558,16 +559,17 @@ static int suspend_device_noirq(struct d
  *	device_power_down - Shut down special devices.
  *	@state: PM transition of the system being carried out.
  *
- *	Power down devices that require interrupts to be disabled.
- *	Then power down system devices.
+ *	Prevent device drivers from receiving interrupts and call the "late"
+ *	suspend handlers.
  *
- *	Must be called with interrupts disabled and only one CPU running.
+ *	Must be called under dpm_list_mtx.
  */
 int device_power_down(pm_message_t state)
 {
 	struct device *dev;
 	int error = 0;
 
+	suspend_device_irqs();
 	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
 		error = suspend_device_noirq(dev, state);
 		if (error) {
@@ -577,7 +579,7 @@ int device_power_down(pm_message_t state
 		dev->power.status = DPM_OFF_IRQ;
 	}
 	if (error)
-		dpm_power_up(resume_event(state));
+		device_power_up(resume_event(state));
 	return error;
 }
 EXPORT_SYMBOL_GPL(device_power_down);
Index: linux-2.6/drivers/base/sys.c
===================================================================
--- linux-2.6.orig/drivers/base/sys.c
+++ linux-2.6/drivers/base/sys.c
@@ -22,6 +22,7 @@
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/interrupt.h>
 
 #include "base.h"
 
@@ -369,6 +370,13 @@ int sysdev_suspend(pm_message_t state)
 	struct sysdev_driver *drv, *err_drv;
 	int ret;
 
+	pr_debug("Checking wake-up interrupts\n");
+
+	/* Return error code if there are any wake-up interrupts pending */
+	ret = check_wakeup_irqs();
+	if (ret)
+		return ret;
+
 	pr_debug("Suspending System Devices\n");
 
 	list_for_each_entry_reverse(cls, &system_kset->list, kset.kobj.entry) {
