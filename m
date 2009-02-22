Return-Path: <linux-kernel-owner+w=401wt.eu-S1756824AbZBVXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824AbZBVXtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 18:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbZBVXtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 18:49:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35417 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbZBVXtI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 18:49:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Mon, 23 Feb 2009 00:48:32 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0902220946070.3111@localhost.localdomain> <200902222342.08285.rjw@sisk.pl>
In-Reply-To: <200902222342.08285.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902230048.33635.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 22 February 2009, Rafael J. Wysocki wrote:
> On Sunday 22 February 2009, Linus Torvalds wrote:
> > 
> > On Sun, 22 Feb 2009, Rafael J. Wysocki wrote:
[--snip--]
> 
> Thanks a lot for your comments, I'll send an updated patch shortly.

The updated patch is appended.

It has been initially tested, but requires more testing, especially with APM,
XEN, kexec jump etc.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Rework handling of interrupts during suspend-resume (rev. 2)

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
 arch/x86/kernel/apm_32.c  |   20 ++++++++++++----
 drivers/xen/manage.c      |   32 +++++++++++++++----------
 include/linux/interrupt.h |    3 ++
 include/linux/irq.h       |    1 
 kernel/irq/manage.c       |   57 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/kexec.c            |   10 ++++----
 kernel/power/disk.c       |   46 +++++++++++++++++++++++++++++--------
 kernel/power/main.c       |   20 +++++++++++-----
 8 files changed, 152 insertions(+), 37 deletions(-)

Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -746,3 +746,60 @@ int request_irq(unsigned int irq, irq_ha
 	return retval;
 }
 EXPORT_SYMBOL(request_irq);
+
+#ifdef CONFIG_PM_SLEEP
+/**
+ *	suspend_device_irqs - disable all currently enabled interrupt lines
+ *
+ *	During system-wide suspend or hibernation device interrupts need to be
+ *	disabled at the chip level and this function is provided for this
+ *	purpose.  It disables all interrupt lines that are enabled at the
+ *	moment and sets the IRQ_SUSPENDED flag for them.
+ */
+void suspend_device_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&desc->lock, flags);
+
+		if (!desc->depth && desc->action
+		    && !(desc->action->flags & IRQF_TIMER)) {
+			desc->depth++;
+			desc->status |= IRQ_DISABLED | IRQ_SUSPENDED;
+			desc->chip->disable(irq);
+		}
+
+		spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	for_each_irq_desc(irq, desc) {
+		if (desc->status & IRQ_SUSPENDED)
+			synchronize_irq(irq);
+	}
+}
+EXPORT_SYMBOL_GPL(suspend_device_irqs);
+
+/**
+ *	resume_device_irqs - enable interrupts disabled by suspend_device_irqs()
+ *
+ *	Enable all interrupt lines previously disabled by suspend_device_irqs()
+ *	that have the IRQ_SUSPENDED flag set.
+ */
+void resume_device_irqs(void)
+{
+	struct irq_desc *desc;
+	int irq;
+
+	for_each_irq_desc(irq, desc) {
+		if (!(desc->status & IRQ_SUSPENDED))
+			continue;
+		desc->status &= ~IRQ_SUSPENDED;
+		enable_irq(irq);
+	}
+}
+EXPORT_SYMBOL_GPL(resume_device_irqs);
+#endif /* CONFIG_PM_SLEEP */
Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -470,4 +470,7 @@ extern int early_irq_init(void);
 extern int arch_early_irq_init(void);
 extern int arch_init_chip_data(struct irq_desc *desc, int cpu);
 
+extern void suspend_device_irqs(void);
+extern void resume_device_irqs(void);
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
 
@@ -287,17 +288,20 @@ void __attribute__ ((weak)) arch_suspend
  */
 static int suspend_enter(suspend_state_t state)
 {
-	int error = 0;
+	int error;
 
 	device_pm_lock();
-	arch_suspend_disable_irqs();
-	BUG_ON(!irqs_disabled());
+	suspend_device_irqs();
 
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
@@ -305,11 +309,15 @@ static int suspend_enter(suspend_state_t
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
+	resume_device_irqs();
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
 
@@ -214,7 +215,8 @@ static int create_image(int platform_mod
 		return error;
 
 	device_pm_lock();
-	local_irq_disable();
+	suspend_device_irqs();
+
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* call device_power_down() now.
 	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
@@ -225,8 +227,11 @@ static int create_image(int platform_mod
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
@@ -252,12 +257,17 @@ static int create_image(int platform_mod
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
+	resume_device_irqs();
 	device_pm_unlock();
+
 	return error;
 }
 
@@ -336,13 +346,17 @@ static int resume_target_kernel(void)
 	int error;
 
 	device_pm_lock();
-	local_irq_disable();
+	suspend_device_irqs();
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
@@ -366,11 +380,17 @@ static int resume_target_kernel(void)
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
+	resume_device_irqs();
 	device_pm_unlock();
+
 	return error;
 }
 
@@ -447,15 +467,18 @@ int hibernation_platform_enter(void)
 		goto Finish;
 
 	device_pm_lock();
-	local_irq_disable();
+	suspend_device_irqs();
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
+	resume_device_irqs();
 	device_pm_unlock();
 
 	/*
@@ -464,12 +487,15 @@ int hibernation_platform_enter(void)
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
+	suspend_device_irqs();
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
+	resume_device_irqs();
+
 	device_resume(PMSG_RESUME);
 	queue_event(APM_NORMAL_RESUME, NULL);
 	spin_lock(&user_list_lock);
@@ -1228,8 +1236,10 @@ static void standby(void)
 {
 	int err;
 
-	local_irq_disable();
+	suspend_device_irqs();
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
+	resume_device_irqs();
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
@@ -108,6 +95,14 @@ static void do_suspend(void)
 	/* XXX use normal device tree? */
 	xenbus_suspend();
 
+	suspend_device_irqs();
+
+	err = device_power_down(PMSG_SUSPEND);
+	if (err) {
+		printk(KERN_ERR "device_power_down failed: %d\n", err);
+		goto resume_devices;
+	}
+
 	err = stop_machine(xen_suspend, &cancelled, &cpumask_of_cpu(0));
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
@@ -120,6 +115,17 @@ static void do_suspend(void)
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
+resume_devices:
+	resume_device_irqs();
+
 	device_resume(PMSG_RESUME);
 
 	/* Make sure timer events get retriggered on all CPUs */
Index: linux-2.6/kernel/kexec.c
===================================================================
--- linux-2.6.orig/kernel/kexec.c
+++ linux-2.6/kernel/kexec.c
@@ -1454,7 +1454,7 @@ int kernel_kexec(void)
 		if (error)
 			goto Resume_devices;
 		device_pm_lock();
-		local_irq_disable();
+		suspend_device_irqs();
 		/* At this point, device_suspend() has been called,
 		 * but *not* device_power_down(). We *must*
 		 * device_power_down() now.  Otherwise, drivers for
@@ -1464,8 +1464,9 @@ int kernel_kexec(void)
 		 */
 		error = device_power_down(PMSG_FREEZE);
 		if (error)
-			goto Enable_irqs;
+			goto Resume_irqs;
 
+		local_irq_disable();
 		/* Suspend system devices */
 		error = sysdev_suspend(PMSG_FREEZE);
 		if (error)
@@ -1484,9 +1485,10 @@ int kernel_kexec(void)
 	if (kexec_image->preserve_context) {
 		sysdev_resume();
  Power_up_devices:
-		device_power_up(PMSG_RESTORE);
- Enable_irqs:
 		local_irq_enable();
+		device_power_up(PMSG_RESTORE);
+ Resume_irqs:
+		resume_device_irqs();
 		device_pm_unlock();
 		enable_nonboot_cpus();
  Resume_devices:
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -65,6 +65,7 @@ typedef	void (*irq_flow_handler_t)(unsig
 #define IRQ_SPURIOUS_DISABLED	0x00800000	/* IRQ was disabled by the spurious trap */
 #define IRQ_MOVE_PCNTXT		0x01000000	/* IRQ migration from process context */
 #define IRQ_AFFINITY_SET	0x02000000	/* IRQ affinity was set from userspace*/
+#define IRQ_SUSPENDED		0x04000000	/* IRQ has gone through suspend sequence */
 
 #ifdef CONFIG_IRQ_PER_CPU
 # define CHECK_IRQ_PER_CPU(var) ((var) & IRQ_PER_CPU)
