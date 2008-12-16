Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759314AbYLPXt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759314AbYLPXt5 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 18:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbYLPXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 18:49:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57433 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755504AbYLPXtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 18:49:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: acpi_os_allocate(GFP_KERNEL) (was Re: acpi_evaluate_integer broken by design)
Date: Wed, 17 Dec 2008 00:49:38 +0100
User-Agent: KMail/1.9.9
Cc: pavel@suse.cz, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <20081125110508.GA1943@elf.ucw.cz> <200812161634.25838.rjw@sisk.pl> <200812170040.07977.rjw@sisk.pl>
In-Reply-To: <200812170040.07977.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812170049.38464.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 17 of December 2008, Rafael J. Wysocki wrote:
> On Tuesday, 16 of December 2008, Rafael J. Wysocki wrote:
> > On Tuesday, 16 of December 2008, Andrew Morton wrote:
> > > On Tue, 16 Dec 2008 00:24:43 -0500 (EST) Len Brown <lenb@kernel.org> wrote:
> [--snip--]
> > > 
> > > (please use __weak)
> > > 
> > > Whether it's "system_resume_irqsoff" or "system_suspend_irqs_off",
> > > neither of them actually got used ;)
> > > 
> > > If the code is really this simple and localised then perhaps:
> > > 
> > > gfp_t acpi_aml_gfp_flags = GFP_ATOMIC;
> > > 
> > > void __weak arch_suspend_disable_irqs(void)
> > > {
> > > 	local_irq_disable();
> > > 	acpi_aml_gfp_flags = GFP_ATOMIC;
> > > }
> > > 
> > > /* default implementation */
> > > void __weak arch_suspend_enable_irqs(void)
> > > {
> > > 	local_irq_enable();
> > > 	acpi_aml_gfp_flags = GFP_KERNEL;
> > > }
> > > 
> > > would suffice.  Dunno.
> > 
> > arch_suspend_disable_irqs() and arch_suspend_enable_irqs() are only used during
> > suspend to RAM, but we have the 'suspend atomic context' during hibernation as
> > well.
> 
> In fact, we should be using GFP_ATOMIC already while devices are being
> suspended, so we can switch from GFP_KERNEL to GFP_ATOMIC even before
> interrupts are enabled.
> 
> In particular, we can do that in the suspend/hibernation platform callback as
> shown in the patch below.
> 
> The patch hasn't been tested and is indended for discussion.

Below is another patch for discussion.

It standardizes the switching of interrupts etc. during suspend to RAM and
hibernation and adds disabling/enabling of preemption so that the
cond_resched() in the ACPI code doesn't try to schedule.

The patch hasn't been tested yet.

Thanks,
Rafael

---
 include/linux/suspend.h |    3 +
 kernel/power/disk.c     |   26 ++++++++--------
 kernel/power/main.c     |   75 ++++++++++++++++++++++++++++++++++++------------
 kernel/power/power.h    |    4 ++
 4 files changed, 78 insertions(+), 30 deletions(-)

Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -214,8 +214,8 @@ static int create_image(int platform_mod
 	if (error)
 		return error;
 
-	device_pm_lock();
-	local_irq_disable();
+	suspend_disable_concurrency();
+
 	/* At this point, device_suspend() has been called, but *not*
 	 * device_power_down(). We *must* call device_power_down() now.
 	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
@@ -248,9 +248,10 @@ static int create_image(int platform_mod
 	 */
 	device_power_up(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+
  Enable_irqs:
-	local_irq_enable();
-	device_pm_unlock();
+	suspend_enable_concurrency();
+
 	return error;
 }
 
@@ -330,8 +331,8 @@ static int resume_target_kernel(void)
 {
 	int error;
 
-	device_pm_lock();
-	local_irq_disable();
+	suspend_disable_concurrency();
+
 	error = device_power_down(PMSG_QUIESCE);
 	if (error) {
 		printk(KERN_ERR "PM: Some devices failed to power down, "
@@ -361,9 +362,10 @@ static int resume_target_kernel(void)
 	restore_processor_state();
 	touch_softlockup_watchdog();
 	device_power_up(PMSG_RECOVER);
+
  Enable_irqs:
-	local_irq_enable();
-	device_pm_unlock();
+	suspend_enable_concurrency();
+
 	return error;
 }
 
@@ -442,16 +444,16 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Finish;
 
-	device_pm_lock();
-	local_irq_disable();
+	suspend_disable_concurrency();
+
 	error = device_power_down(PMSG_HIBERNATE);
 	if (!error) {
 		hibernation_ops->enter();
 		/* We should never get here */
 		while (1);
 	}
-	local_irq_enable();
-	device_pm_unlock();
+
+	suspend_enable_concurrency();
 
 	/*
 	 * We don't need to reenable the nonboot CPUs or resume consoles, since
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -55,6 +55,46 @@ int pm_notifier_call_chain(unsigned long
 			== NOTIFY_BAD) ? -EINVAL : 0;
 }
 
+/* default implementation */
+void __weak arch_suspend_disable_irqs(void)
+{
+	local_irq_disable();
+}
+
+/* default implementation */
+void __weak arch_suspend_enable_irqs(void)
+{
+	local_irq_enable();
+}
+
+/**
+ *	suspend_disable_concurrency - disable the execution of any other code
+ *                                    in parallel with the calling thread
+ *
+ *	To be executed with only one CPU on line.
+ */
+void suspend_disable_concurrency(void)
+{
+	device_pm_lock();
+	preempt_disable();
+	arch_suspend_disable_irqs();
+	BUG_ON(!irqs_disabled());
+}
+
+/**
+ *	suspend_enable_concurrency - allow other code to be executed in parallel
+ *                                   with the calling thread
+ *
+ *	To be executed with only one CPU on line.
+ */
+void suspend_enable_concurrency(void)
+{
+	arch_suspend_enable_irqs();
+	BUG_ON(irqs_disabled());
+	preempt_enable_no_resched();
+	device_pm_unlock();
+}
+
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
@@ -268,18 +321,6 @@ static int suspend_prepare(void)
 	return error;
 }
 
-/* default implementation */
-void __attribute__ ((weak)) arch_suspend_disable_irqs(void)
-{
-	local_irq_disable();
-}
-
-/* default implementation */
-void __attribute__ ((weak)) arch_suspend_enable_irqs(void)
-{
-	local_irq_enable();
-}
-
 /**
  *	suspend_enter - enter the desired system sleep state.
  *	@state:		state to enter
@@ -290,9 +331,7 @@ static int suspend_enter(suspend_state_t
 {
 	int error = 0;
 
-	device_pm_lock();
-	arch_suspend_disable_irqs();
-	BUG_ON(!irqs_disabled());
+	suspend_disable_concurrency();
 
 	if ((error = device_power_down(PMSG_SUSPEND))) {
 		printk(KERN_ERR "PM: Some devices failed to power down\n");
@@ -303,10 +342,10 @@ static int suspend_enter(suspend_state_t
 		error = suspend_ops->enter(state);
 
 	device_power_up(PMSG_RESUME);
+
  Done:
-	arch_suspend_enable_irqs();
-	BUG_ON(irqs_disabled());
-	device_pm_unlock();
+	suspend_enable_concurrency();
+
 	return error;
 }
 
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -163,11 +163,15 @@ extern void swsusp_show_speed(struct tim
 #ifdef CONFIG_SUSPEND
 /* kernel/power/main.c */
 extern int suspend_devices_and_enter(suspend_state_t state);
+extern void suspend_disable_concurrency(void);
+extern void suspend_enable_concurrency(void);
 #else /* !CONFIG_SUSPEND */
 static inline int suspend_devices_and_enter(suspend_state_t state)
 {
 	return -ENOSYS;
 }
+static inline void suspend_disable_concurrency(void) {}
+static inline void suspend_enable_concurrency(void) {}
 #endif /* !CONFIG_SUSPEND */
 
 #ifdef CONFIG_PM_SLEEP
