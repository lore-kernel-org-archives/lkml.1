Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbZBVRkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbZBVRkj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 12:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751344AbZBVRka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 12:40:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34545 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZBVRk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 12:40:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Sun, 22 Feb 2009 18:39:49 +0100
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
Message-Id: <200902221839.50357.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce two helper functions allowing us to disable device
interrupts (at the IO-APIC level) during suspend or hibernation
and enable them during the subsequent resume, respectively, so that
the timer interrupts are enabled while "late" suspend callbacks and
"early" resume callbacks provided by device drivers are being
executed.

Use these functions to rework the handling of interrupts during
suspend (hibernation) and resume.  Namely, interrupts will only be
disabled on the CPU right before suspending sysdevs, while device
interrupts will be disabled (at the IO-APIC level), with the help of
the new helper function, before calling "late" suspend callbacks
provided by device drivers and analogously during resume.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/apm_32.c  |   20 ++++++++--
 drivers/xen/manage.c      |   37 ++++++++++++--------
 include/linux/interrupt.h |    3 +
 kernel/irq/manage.c       |   85 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/kexec.c            |   11 ++++-
 kernel/power/disk.c       |   56 +++++++++++++++++++++++++++---
 kernel/power/main.c       |   27 +++++++++++---
 7 files changed, 208 insertions(+), 31 deletions(-)

Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -746,3 +746,88 @@ int request_irq(unsigned int irq, irq_ha
 	return retval;
 }
 EXPORT_SYMBOL(request_irq);
+
+#ifdef CONFIG_PM_SLEEP
+struct disabled_irq {
+	struct list_head list;
+	int irq;
+};
+
+static LIST_HEAD(resume_irqs_list);
+
+/**
+ *	enable_device_irqs - enable interrupts disabled by disable_device_irqs()
+ *
+ *	Enable all interrupt lines previously disabled by disable_device_irqs()
+ *	that are on resume_irqs_list.
+ */
+void enable_device_irqs(void)
+{
+	struct disabled_irq *resume_irq, *tmp;
+
+	list_for_each_entry_safe(resume_irq, tmp, &resume_irqs_list, list) {
+		enable_irq(resume_irq->irq);
+		list_del(&resume_irq->list);
+		kfree(resume_irq);
+	}
+}
+
+/**
+ *	disable_device_irqs - disable all enabled interrupt lines
+ *
+ *	During system-wide suspend or hibernation device interrupts need to be
+ *	disabled at the chip level and this function is provided for this
+ *	purpose.  It disables all interrupt lines that are enabled at the
+ *	moment and saves their numbers for enable_device_irqs().
+ */
+int disable_device_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		unsigned long flags;
+		struct disabled_irq *resume_irq;
+		struct irqaction *action;
+		bool is_timer_irq;
+
+		resume_irq = kzalloc(sizeof(*resume_irq), GFP_NOIO);
+		if (!resume_irq) {
+			enable_device_irqs();
+			return -ENOMEM;
+		}
+
+		spin_lock_irqsave(&desc->lock, flags);
+
+		is_timer_irq = false;
+		action = desc->action;
+		while (action) {
+			if (action->flags | IRQF_TIMER) {
+				is_timer_irq = true;
+				break;
+			}
+			action = action->next;
+		}
+
+		if (!is_timer_irq && !desc->depth) {
+			desc->depth++;
+			desc->status |= IRQ_DISABLED;
+			desc->chip->disable(irq);
+		} else {
+			spin_unlock_irqrestore(&desc->lock, flags);
+			kfree(resume_irq);
+			continue;
+		}
+
+		spin_unlock_irqrestore(&desc->lock, flags);
+
+		if (desc->action)
+			synchronize_irq(irq);
+
+		resume_irq->irq = irq;
+		list_add(&resume_irq->list, &resume_irqs_list);
+	}
+
+	return 0;
+}
+#endif /* CONFIG_PM_SLEEP */
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -470,4 +470,7 @@ extern int early_irq_init(void);
 extern int arch_early_irq_init(void);
 extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
 
+extern int disable_device_irqs(void);
+extern void enable_device_irqs(void);
+
 #endif
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -22,6 +22,7 @@
 #include <linux/freezer.h>
 #include <linux/vmstat.h>
 #include <linux/syscalls.h>
+#include <linux/interrupt.h>
 
 #include "power.h"
 
@@ -287,17 +288,25 @@ void __attribute__ ((weak)) arch_suspend
  */
 static int suspend_enter(suspend_state_t state)
 {
-	int error = 0;
+	int error;
 
 	device_pm_lock();
-	arch_suspend_disable_irqs();
-	BUG_ON(!irqs_disabled());
 
-	if ((error = device_power_down(PMSG_SUSPEND))) {
+	error = disable_device_irqs();
+	if (error) {
+		printk(KERN_ERR "PM: Failed to disable device interrupts\n");
+		goto Unlock;
+	}
+
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
@@ -305,11 +314,17 @@ static int suspend_enter(suspend_state_t
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
+	enable_device_irqs();
+
+ Unlock:
 	device_pm_unlock();
+
 	return error;
 }
 
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -22,6 +22,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <linux/interrupt.h>
 
 #include "power.h"
 
@@ -214,7 +215,13 @@ static int create_image(int platform_mod
 		return error;
 
 	device_pm_lock();
-	local_irq_disable();
+
+	error = disable_device_irqs();
+	if (error) {
+		printk(KERN_ERR "PM: Failed to disable device interrupts\n");
+		goto Unlock;
+	}
+
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* call device_power_down() now.
 	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
@@ -227,6 +234,9 @@ static int create_image(int platform_mod
 			"aborting hibernation\n");
 		goto Enable_irqs;
 	}
+
+	local_irq_disable();
+
 	sysdev_suspend(PMSG_FREEZE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
@@ -252,11 +262,17 @@ static int create_image(int platform_mod
 	/* NOTE:  device_power_up() is just a resume() for devices
 	 * that suspended with irqs off ... no overall powerup.
 	 */
+
  Power_up_devices:
+	local_irq_enable();
+
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+
  Enable_irqs:
-	local_irq_enable();
+ 	enable_device_irqs();
+
+ Unlock:
 	device_pm_unlock();
 	return error;
 }
@@ -336,13 +352,22 @@ static int resume_target_kernel(void)
 	int error;
 
 	device_pm_lock();
-	local_irq_disable();
+
+	error = disable_device_irqs();
+	if (error) {
+		printk(KERN_ERR "PM: Failed to disable device interrupts\n");
+		goto Unlock;
+	}
+
 	error = device_power_down(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
 			"aborting resume\n");
 		goto Enable_irqs;
 	}
+
+	local_irq_disable();
+
 	sysdev_suspend(PMSG_QUIESCE);
 	/* We'll ignore saved state, but this gets preempt count (etc) right */
 	save_processor_state();
@@ -366,11 +391,19 @@ static int resume_target_kernel(void)
 	swsusp_free();
 	restore_processor_state();
 	touch_softlockup_watchdog();
+
 	sysdev_resume();
+
+	local_irq_enable();
+
 	device_power_up(PMSG_RECOVER);
+
  Enable_irqs:
-	local_irq_enable();
+	enable_device_irqs();
+
+ Unlock:
 	device_pm_unlock();
+
 	return error;
 }
 
@@ -447,15 +480,23 @@ int hibernation_platform_enter(void)
 		goto Finish;
 
 	device_pm_lock();
-	local_irq_disable();
+
+	error = disable_device_irqs();
+	if (error)
+		goto Unlock;
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
+	enable_device_irqs();
+
+ Unlock:
 	device_pm_unlock();
 
 	/*
@@ -464,12 +505,15 @@ int hibernation_platform_enter(void)
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
@@ -228,6 +228,7 @@
 #include <linux/suspend.h>
 #include <linux/kthread.h>
 #include <linux/jiffies.h>
+#include <linux/interrupt.h>
 
 #include <asm/system.h>
 #include <asm/uaccess.h>
@@ -1190,8 +1191,11 @@ static int suspend(int vetoable)
 	struct apm_user	*as;
 
 	device_suspend(PMSG_SUSPEND);
-	local_irq_disable();
+
+	disable_device_irqs();
 	device_power_down(PMSG_SUSPEND);
+
+	local_irq_disable();
 	sysdev_suspend(PMSG_SUSPEND);
 
 	local_irq_enable();
@@ -1209,9 +1213,13 @@ static int suspend(int vetoable)
 	if (err != APM_SUCCESS)
 		apm_error("suspend", err);
 	err = (err == APM_SUCCESS) ? 0 : -EIO;
+
 	sysdev_resume();
-	device_power_up(PMSG_RESUME);
 	local_irq_enable();
+
+	device_power_up(PMSG_RESUME);
+	enable_device_irqs();
+
 	device_resume(PMSG_RESUME);
 	queue_event(APM_NORMAL_RESUME, NULL);
 	spin_lock(&user_list_lock);
@@ -1228,8 +1236,10 @@ static void standby(void)
 {
 	int err;
 
-	local_irq_disable();
+	disable_device_irqs();
 	device_power_down(PMSG_SUSPEND);
+
+	local_irq_disable();
 	sysdev_suspend(PMSG_SUSPEND);
 	local_irq_enable();
 
@@ -1239,8 +1249,10 @@ static void standby(void)
 
 	local_irq_disable();
 	sysdev_resume();
-	device_power_up(PMSG_RESUME);
 	local_irq_enable();
+
+	device_power_up(PMSG_RESUME);
+	enable_device_irqs();
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
@@ -69,13 +63,6 @@ static int xen_suspend(void *data)
 	xen_mm_unpin_all();
 
 	sysdev_resume();
-	device_power_up(PMSG_RESUME);
-
-	if (!*cancelled) {
-		xen_irq_resume();
-		xen_console_resume();
-		xen_timer_resume();
-	}
 
 	return 0;
 }
@@ -108,6 +95,18 @@ static void do_suspend(void)
 	/* XXX use normal device tree? */
 	xenbus_suspend();
 
+	err = disable_device_irqs();
+	if (err) {
+		printk(KERN_ERR "disable_device_irqs failed: %d\n", err);
+		goto resume_devices;
+	}
+
+	err = device_power_down(PMSG_SUSPEND);
+	if (err) {
+		printk(KERN_ERR "device_power_down failed: %d\n", err);
+		goto enable_irqs;
+	}
+
 	err = stop_machine(xen_suspend, &cancelled, &cpumask_of_cpu(0));
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
@@ -120,6 +119,18 @@ static void do_suspend(void)
 	} else
 		xenbus_suspend_cancel();
 
+	device_power_up(PMSG_RESUME);
+
+	if (!cancelled) {
+		xen_irq_resume();
+		xen_console_resume();
+		xen_timer_resume();
+	}
+
+enable_irqs:
+	enable_device_irqs();
+
+resume_devices:
 	device_resume(PMSG_RESUME);
 
 	/* Make sure timer events get retriggered on all CPUs */
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1454,7 +1454,11 @@ int kernel_kexec(void)
 		if (error)
 			goto Resume_devices;
 		device_pm_lock();
-		local_irq_disable();
+
+		error = disable_device_irqs();
+		if (error)
+			goto Unlock_pm;
+
 		/* At this point, device_suspend() has been called,
 		 * but *not* device_power_down(). We *must*
 		 * device_power_down() now.  Otherwise, drivers for
@@ -1466,6 +1470,7 @@ int kernel_kexec(void)
 		if (error)
 			goto Enable_irqs;
 
+		local_irq_disable();
 		/* Suspend system devices */
 		error = sysdev_suspend(PMSG_FREEZE);
 		if (error)
@@ -1484,9 +1489,11 @@ int kernel_kexec(void)
 	if (kexec_image->preserve_context) {
 		sysdev_resume();
  Power_up_devices:
+		local_irq_enable();
 		device_power_up(PMSG_RESTORE);
  Enable_irqs:
-		local_irq_enable();
+		enable_device_irqs();
+ Unlock_pm:
 		device_pm_unlock();
 		enable_nonboot_cpus();
  Resume_devices:
