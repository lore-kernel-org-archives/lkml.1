Return-Path: <linux-kernel-owner+w=401wt.eu-S1757781AbXH2PQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757781AbXH2PQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbXH2PPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:15:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54654 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064AbXH2PPn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:15:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH -mm 2/3] PM: More fine grained ACPI handling during suspend and hibernation (rev. 3)
Date: Wed, 29 Aug 2007 17:22:46 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200708272347.45438.rjw@sisk.pl> <200708281548.45912.lenb@kernel.org> <200708282335.47113.rjw@sisk.pl>
In-Reply-To: <200708282335.47113.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200708291722.47688.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 August 2007 23:35, Rafael J. Wysocki wrote:
> On Tuesday, 28 August 2007 21:48, Len Brown wrote:
> > On Monday 27 August 2007 17:51, Rafael J. Wysocki wrote:
> > > According to the ACPI specification (eg. ACPI 2.0c, sec. 7.3.1, 7.3.3,
> > > ACPI 3.0b, sec. 7.3.1, 7.3.3) the _GTS and _BFS global control methods should
> > > be executed, respectively, right before entering a sleep state (S1-S4) and right
> > > after leaving it, but we don't follow this reqirement.  Namely, in our
> > > implementation the nonboot CPUs are disabled after executing _GTS and enabled
> > > before executing _BFS, which doesn't seem to be correct.
> > 
> > I've never encountered a BIOS that actually implements _GTS or _BFS,
> > so I expect that changing how they are invoked may be somewhat academic.
> 
> It is for now, but once we have a system that implements them, we'd most
> probably need to change the current code, so I think it's better to consider
> that in advance.
> 
> > > [In fact, the ACPI 
> > > specification requires that no physical I/O and interrupt servicing be performed
> > > after the sleep state has been left and before _BFS is executed as well as after
> > > executing _GTS and before the sleep state is entered, but we can't follow this
> > > requirement literally, 
> > 
> > > since our AML interpreter needs to run with interrupts 
> > > enabled and we need to carry out some operations with interrupts disabled before
> > > entering the sleep state and after leaving it.]
> > 
> > This is sort of a myth.
> > 
> > The real requirement is that the ACPI interpreter must be able to call kmalloc().
> > It does this today via acpi_os_allocate(), which does this:
> > 
> > kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> > 
> > No, we don't actually run the interpreter during device interrupts,
> > but we need to be able to run it with interrupts off for boot,
> > suspend, and resume.
> 
> At present, during suspend and resume we always call the AML interpreter
> with interrupts enabled.
> 
> Frankly, I'd like _BFS and _GTS to be executed with interrupts disabled,
> just as the specification tells us to do.  If you think that's safe, I'll
> change the patch to work this way.

Appended is an alternative version of the $subject patch, in which the _GTS and
_BFS methods are executed with interrupts disabled.  It is simpler than the
previous one, so I prefer it. :-)

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

According to the ACPI specification (eg. ACPI 2.0c, sec. 7.3.1, 7.3.3,
ACPI 3.0b, sec. 7.3.1, 7.3.3) the _GTS and _BFS global control methods should
be executed, respectively, right before entering a sleep state (S1-S4) and right
after leaving it, but we don't follow this reqirement.  Namely, in our
implementation the nonboot CPUs are disabled after executing _GTS and enabled
before executing _BFS, which doesn't seem to be correct.  Moreover,
acpi_enable() called after restoring the system memory state from a hibernation
image should really be executed before enabling the nonboot CPUs, since
functional ACPI layer may be needed for that.  Thus, it seems reasonable to do
the following changes:
* Move the execution of _GTS from acpi_enter_sleep_state_prep() to
  acpi_enter_sleep_state()
* Move the execution of _BFS to before the execution of _SST in
  acpi_leave_sleep_state()
* Move the enabling of GPS, the execution of _WAK and the enabling of power
  buttons from acpi_leave_sleep_state() to a new function
  acpi_leave_sleep_state_finish()
* Make acpi_leave_sleep_state() be called with interrupts disabled from
  acpi_pm_enter(), right after leaving the sleep state
* Make acpi_pm_finish() call acpi_leave_sleep_state_finish() instead of
  acpi_leave_sleep_state()
* Introduce a new global hibernation callback ->leave() to be executed with
  interrupts disabled just after transferring control from the boot kernel to
  the image kernel and make it call acpi_enable() and
  acpi_leave_sleep_state(ACPI_STATE_S4) on ACPI systems
* Make acpi_hibernation_finish() call acpi_leave_sleep_state_finish() instead of
  acpi_leave_sleep_state()

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/hardware/hwsleep.c |   73 +++++++++++++++++++++++++++++++---------
 drivers/acpi/sleep/main.c       |   13 ++++++-
 include/acpi/acpixf.h           |    2 +
 include/linux/suspend.h         |    7 +++
 kernel/power/disk.c             |   62 ++++++++++++++++++++++++++++++++-
 kernel/power/power.h            |    1 
 kernel/power/swsusp.c           |   33 ------------------
 7 files changed, 137 insertions(+), 54 deletions(-)

Index: linux-2.6.23-rc4/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.23-rc4.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6.23-rc4/drivers/acpi/hardware/hwsleep.c
@@ -192,18 +192,13 @@ acpi_status acpi_enter_sleep_state_prep(
 	arg.type = ACPI_TYPE_INTEGER;
 	arg.integer.value = sleep_state;
 
-	/* Run the _PTS and _GTS methods */
+	/* Run the _PTS method */
 
 	status = acpi_evaluate_object(NULL, METHOD_NAME__PTS, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		return_ACPI_STATUS(status);
 	}
 
-	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		return_ACPI_STATUS(status);
-	}
-
 	/* Setup the argument to _SST */
 
 	switch (sleep_state) {
@@ -263,6 +258,8 @@ acpi_status asmlinkage acpi_enter_sleep_
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 in_value;
 	acpi_status status;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
 
 	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
 
@@ -317,6 +314,19 @@ acpi_status asmlinkage acpi_enter_sleep_
 	ACPI_DEBUG_PRINT((ACPI_DB_INIT,
 			  "Entering sleep state [S%d]\n", sleep_state));
 
+	/* Execute the _GTS method */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
+
+	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		return_ACPI_STATUS(status);
+	}
+
 	/* Clear SLP_EN and SLP_TYP fields */
 
 	PM1Acontrol &= ~(sleep_type_reg_info->access_bit_mask |
@@ -484,8 +494,9 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_stat
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
- *              Called with interrupts ENABLED.
+ * DESCRIPTION: Perform the first stage of OS-independent ACPI cleanup after a
+ *              sleep.
+ *              Called with one CPU on line and with interrupts DISABLED.
  *
  ******************************************************************************/
 acpi_status acpi_leave_sleep_state(u8 sleep_state)
@@ -560,17 +571,43 @@ acpi_status acpi_leave_sleep_state(u8 sl
 
 	/* Ignore any errors from these methods */
 
+	arg.integer.value = sleep_state;
+	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
+	}
+
 	arg.integer.value = ACPI_SST_WAKING;
 	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
 	}
 
-	arg.integer.value = sleep_state;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
-	}
+	return_ACPI_STATUS(AE_OK);
+}
+
+ACPI_EXPORT_SYMBOL(acpi_leave_sleep_state)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_leave_sleep_state_finish
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Perform the second stage of OS-independent ACPI cleanup after a
+ *              sleep.
+ *              Called with interrupts ENABLED.
+ *
+ ******************************************************************************/
+acpi_status acpi_leave_sleep_state_finish(u8 sleep_state)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_finish);
 
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
@@ -589,6 +626,14 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		return_ACPI_STATUS(status);
 	}
 
+	/* Execute the _WAK method */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
+
 	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
@@ -615,5 +660,3 @@ acpi_status acpi_leave_sleep_state(u8 sl
 
 	return_ACPI_STATUS(status);
 }
-
-ACPI_EXPORT_SYMBOL(acpi_leave_sleep_state)
Index: linux-2.6.23-rc4/include/acpi/acpixf.h
===================================================================
--- linux-2.6.23-rc4.orig/include/acpi/acpixf.h
+++ linux-2.6.23-rc4/include/acpi/acpixf.h
@@ -335,4 +335,6 @@ acpi_status asmlinkage acpi_enter_sleep_
 
 acpi_status acpi_leave_sleep_state(u8 sleep_state);
 
+acpi_status acpi_leave_sleep_state_finish(u8 sleep_state);
+
 #endif				/* __ACXFACE_H__ */
Index: linux-2.6.23-rc4/include/linux/suspend.h
===================================================================
--- linux-2.6.23-rc4.orig/include/linux/suspend.h
+++ linux-2.6.23-rc4/include/linux/suspend.h
@@ -156,6 +156,12 @@ extern void mark_free_pages(struct zone 
  *	Called after the nonboot CPUs have been disabled and all of the low
  *	level devices have been shut down (runs with IRQs off).
  *
+ * @leave: Perform the first stage of the cleanup after the system sleep state
+ *	indicated by @set_target() has been left.
+ *	Called right after contol has been passed from the boot kernel to the
+ *	image kernel, before the nonboot CPUs are enabled and before devices are
+ *	resumed.  Executed with interrupts disabled.
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
Index: linux-2.6.23-rc4/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc4.orig/kernel/power/disk.c
+++ linux-2.6.23-rc4/kernel/power/disk.c
@@ -55,7 +55,7 @@ static struct platform_hibernation_ops *
 void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
 	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
-	    && ops->prepare && ops->enter && ops->pre_restore
+	    && ops->prepare && ops->enter && ops->leave && ops->pre_restore
 	    && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
@@ -93,8 +93,19 @@ static int platform_pre_snapshot(int pla
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
- *	using the platform driver (must be called after platform_prepare())
+ *	using the platform driver (must be called after platform_leave())
  */
 
 static void platform_finish(int platform_mode)
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
+	if (!error && !in_suspend)
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
Index: linux-2.6.23-rc4/kernel/power/swsusp.c
===================================================================
--- linux-2.6.23-rc4.orig/kernel/power/swsusp.c
+++ linux-2.6.23-rc4/kernel/power/swsusp.c
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
Index: linux-2.6.23-rc4/kernel/power/power.h
===================================================================
--- linux-2.6.23-rc4.orig/kernel/power/power.h
+++ linux-2.6.23-rc4/kernel/power/power.h
@@ -183,7 +183,6 @@ extern int swsusp_swap_in_use(void);
 extern int swsusp_check(void);
 extern int swsusp_shrink_memory(void);
 extern void swsusp_free(void);
-extern int swsusp_suspend(void);
 extern int swsusp_resume(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
Index: linux-2.6.23-rc4/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.23-rc4.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.23-rc4/drivers/acpi/sleep/main.c
@@ -114,6 +114,9 @@ static int acpi_pm_enter(suspend_state_t
 		break;
 	}
 
+	/* Execute _BFS */
+	acpi_leave_sleep_state(acpi_state);
+
 	/* ACPI 3.0 specs (P62) says that it's the responsabilty
 	 * of the OSPM to clear the status bit [ implying that the
 	 * POWER_BUTTON event should not reach userspace ]
@@ -149,7 +152,7 @@ static void acpi_pm_finish(void)
 {
 	u32 acpi_state = acpi_target_sleep_state;
 
-	acpi_leave_sleep_state(acpi_state);
+	acpi_leave_sleep_state_finish(acpi_state);
 	acpi_disable_wakeup_device(acpi_state);
 
 	/* reset firmware waking vector */
@@ -238,7 +241,7 @@ static int acpi_hibernation_enter(void)
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
 
-static void acpi_hibernation_finish(void)
+static void acpi_hibernation_leave(void)
 {
 	/*
 	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
@@ -246,6 +249,11 @@ static void acpi_hibernation_finish(void
 	 */
 	acpi_enable();
 	acpi_leave_sleep_state(ACPI_STATE_S4);
+}
+
+static void acpi_hibernation_finish(void)
+{
+	acpi_leave_sleep_state_finish(ACPI_STATE_S4);
 	acpi_disable_wakeup_device(ACPI_STATE_S4);
 
 	/* reset firmware waking vector */
@@ -274,6 +282,7 @@ static struct platform_hibernation_ops a
 	.finish = acpi_hibernation_finish,
 	.prepare = acpi_hibernation_prepare,
 	.enter = acpi_hibernation_enter,
+	.leave = acpi_hibernation_leave,
 	.pre_restore = acpi_hibernation_pre_restore,
 	.restore_cleanup = acpi_hibernation_restore_cleanup,
 };
