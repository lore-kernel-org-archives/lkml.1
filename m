Return-Path: <linux-kernel-owner+w=401wt.eu-S1760749AbZBXX3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749AbZBXX3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754155AbZBXX3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:29:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50712 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbZBXX3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:29:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 2/2] PM: Rework handling of interrupts during suspend-resume
Date: Wed, 25 Feb 2009 00:29:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <200902221837.49396.rjw@sisk.pl> <200902250007.13069.rjw@sisk.pl> <20090224230935.GA15165@elte.hu>
In-Reply-To: <20090224230935.GA15165@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902250029.16107.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Tuesday 24 February 2009, Linus Torvalds wrote:
> > > 
> > > On Tue, 24 Feb 2009, Rafael J. Wysocki wrote:
> > > >
> > > > > The only safe way on x86 to shutdown a level triggered ioapic irq
> > > > > outside of irq context is for the driver to program the hardware to
> > > > > not generate an irq.
> > > > 
> > > > Well, that changes things quite a bit, because it means we can't change the
> > > > suspend-resume sequence in a way we thought we could without fixing all
> > > > drivers first, but this is exactly what we'd like to avoid by changing the
> > > > core.
> > > 
> > > Calling "disable_irq()" is perfectly fine.
> > > 
> > > What is not possible on that broken IO-APIC (among other 
> > > things) is to actually turn the interrupts off at the apic 
> > > (ie the whole ->shutdown() thing). But that's not what we 
> > > even want to do. What we care about is just disabling the 
> > > interrupt from a drievr perspective.
> > > 
> > > IOW, the patches I have seen are fine, and all the comments 
> > > from Eric are just confusion about what we want done.
> > 
> > Ah, OK.  Thanks for the explanation, I got confused too.
> > 
> > > WE DO NOT WANT TO TURN OFF THE IO-APIC. That may or may 
> > > happen later, but that's totally unrelated to this whole 
> > > "suspend_device_irq()" thing.
> > 
> > Yeah.
> 
> We definitely dont want to turn off x86 IO-APICs - the timer IRQ 
> goes via one of them.

No, we don't.  At least not at this point.

BTW, appended is the current (3rd) version of the $subject patch with some
of your comments taken into account.  In particular, I did the following:
- moved [suspend|resume]_device_irqs() to a separate file (pm.c)
- fixed interrupt.h so that their headers are at a better place
- made enable_irq() clear IRQ_SUSPENDED
- made device_power_down() and device_power_up() call
  suspend_device_irqs() and resume_device_irqs(), respectively, which
  simplified the callers quite a bit (it changed the Xen code ordering, though,
  but I _think_ it still should work).

Please have a look.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Rework handling of interrupts during suspend-resume (rev. 3)

Introduce two helper functions allowing us to prevent device drivers
from getting any interrupts (without disabling interrupts on the CPU)
during suspend (or hibernation) and to make them start to receive
interrupts again during the subsequent resume, respectively.  These
functions make it possible to keep timer interrupts enabled while the
"late" suspend and "early" resume callbacks provided by device
drivers are being executed.

Use these functions to rework the handling of interrupts during
suspend (hibernation) and resume.  Namely, interrupts will only be
disabled on the CPU right before suspending sysdevs, while device
drivers will be prevented from receiving interrupts, with the help of
the new helper function, before their "late" suspend callbacks run
(and analogously during resume).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/apm_32.c  |   15 ++++++++--
 drivers/base/power/main.c |   20 ++++++++------
 drivers/xen/manage.c      |   16 ++++++-----
 include/linux/interrupt.h |    4 ++
 include/linux/irq.h       |    1 
 kernel/irq/Makefile       |    1 
 kernel/irq/manage.c       |    3 +-
 kernel/irq/pm.c           |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 kernel/kexec.c            |    8 ++---
 kernel/power/disk.c       |   39 +++++++++++++++++++++-------
 kernel/power/main.c       |   17 ++++++++----
 11 files changed, 146 insertions(+), 41 deletions(-)

Index: linux-2.6/include/linux/interrupt.h
===================================================================
--- linux-2.6.orig/include/linux/interrupt.h
+++ linux-2.6/include/linux/interrupt.h
@@ -106,6 +106,10 @@ extern void disable_irq_nosync(unsigned 
 extern void disable_irq(unsigned int irq);
 extern void enable_irq(unsigned int irq);
 
+/* The following two functions are for the core kernel use only. */
+extern void suspend_device_irqs(void);
+extern void resume_device_irqs(void);
+
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 
 extern cpumask_var_t irq_default_affinity;
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
Index: linux-2.6/kernel/irq/pm.c
===================================================================
--- /dev/null
+++ linux-2.6/kernel/irq/pm.c
@@ -0,0 +1,63 @@
+/*
+ * linux/kernel/irq/pm.c
+ *
+ * Copyright (C) 2009 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
+ *
+ * This file contains power management functions related to interrupts.
+ */
+
+#include <linux/irq.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+
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
+		if (!desc->depth && !(desc->status & IRQ_WAKEUP)
+		    && desc->action && !(desc->action->flags & IRQF_TIMER)) {
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
+	for_each_irq_desc(irq, desc)
+		if (desc->status & IRQ_SUSPENDED)
+			enable_irq(irq);
+}
+EXPORT_SYMBOL_GPL(resume_device_irqs);
Index: linux-2.6/kernel/irq/Makefile
===================================================================
--- linux-2.6.orig/kernel/irq/Makefile
+++ linux-2.6/kernel/irq/Makefile
@@ -4,3 +4,4 @@ obj-$(CONFIG_GENERIC_IRQ_PROBE) += autop
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
 obj-$(CONFIG_NUMA_MIGRATE_IRQ_DESC) += numa_migrate.o
+obj-$(CONFIG_PM_SLEEP) += pm.o
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -222,8 +222,9 @@ static void __enable_irq(struct irq_desc
 		WARN(1, KERN_WARNING "Unbalanced enable for IRQ %d\n", irq);
 		break;
 	case 1: {
-		unsigned int status = desc->status & ~IRQ_DISABLED;
+		unsigned int status;
 
+		status = desc->status & ~(IRQ_DISABLED | IRQ_SUSPENDED);
 		/* Prevent probing on this irq: */
 		desc->status = status | IRQ_NOPROBE;
 		check_irq_resend(desc, irq);
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
