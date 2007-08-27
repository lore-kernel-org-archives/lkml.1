Return-Path: <linux-kernel-owner+w=401wt.eu-S965396AbXH0V4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396AbXH0V4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933218AbXH0VpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:45:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47338 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933696AbXH0Vo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:44:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/3] PM: More fine grained ACPI handling during suspend and hibernation (rev. 3)
Date: Mon, 27 Aug 2007 23:51:10 +0200
User-Agent: KMail/1.9.5
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200708272347.45438.rjw@sisk.pl>
In-Reply-To: <200708272347.45438.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708272351.10882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

According to the ACPI specification (eg. ACPI 2.0c, sec. 7.3.1, 7.3.3,
ACPI 3.0b, sec. 7.3.1, 7.3.3) the _GTS and _BFS global control methods should
be executed, respectively, right before entering a sleep state (S1-S4) and right
after leaving it, but we don't follow this reqirement.  Namely, in our
implementation the nonboot CPUs are disabled after executing _GTS and enabled
before executing _BFS, which doesn't seem to be correct.  [In fact, the ACPI
specification requires that no physical I/O and interrupt servicing be performed
after the sleep state has been left and before _BFS is executed as well as after
executing _GTS and before the sleep state is entered, but we can't follow this
requirement literally, since our AML interpreter needs to run with interrupts
enabled and we need to carry out some operations with interrupts disabled before
entering the sleep state and after leaving it.]  Moreover, acpi_enable() called
after restoring the system memory state from a hibernation image should really
be executed before enabling the nonboot CPUs, since functional ACPI may be
needed for that.  All of this means that we need to handle ACPI in a more fine
grained manner during suspend and hibernation.

For this reason we can introduce new global platform callbacks prepare_late()
and finish_early() to be executed, respectively, between disabling the nonboot
CPUs and entering a sleep state and between leaving the sleep state and enabling
the nonboot CPUs.  For ACPI systems they can be used to execute the _GTS and
_BFS global control methods, respectively.

It also seems to be a good idea to introduce new hibernation-related callback
post_snapshot() to be executed after creating a hibernation image, instead of
finish() (for now, both these callbacks are defined to point to the same
function, but that will be changed in the future).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/acpi/hardware/hwsleep.c |   98 ++++++++++++++++++++++++++++++++--------
 drivers/acpi/sleep/main.c       |   57 +++++++++++++++++++++--
 include/acpi/acpixf.h           |    4 +
 include/linux/suspend.h         |   57 +++++++++++++++++++----
 kernel/power/disk.c             |   50 +++++++++++++++++---
 kernel/power/main.c             |   16 +++++-
 6 files changed, 241 insertions(+), 41 deletions(-)

Index: linux-2.6.23-rc3/include/linux/suspend.h
===================================================================
--- linux-2.6.23-rc3.orig/include/linux/suspend.h
+++ linux-2.6.23-rc3/include/linux/suspend.h
@@ -49,7 +49,7 @@ typedef int __bitwise suspend_state_t;
  *	passed to @enter() is meaningless and should be ignored.
  *
  * @prepare: Prepare the platform for entering the system sleep state indicated
- *	by @set_target().
+ *	by @set_target() (first stage).
  *	@prepare() is called right after devices have been suspended (ie. the
  *	appropriate .suspend() method has been executed for each device) and
  *	before the nonboot CPUs are disabled (it is executed with IRQs enabled).
@@ -57,12 +57,27 @@ typedef int __bitwise suspend_state_t;
  *	error code otherwise, in which case the system cannot enter the desired
  *	sleep state (@enter() and @finish() will not be called in that case).
  *
+ * @prepare_late: Prepare the platform for entering the system sleep state
+ *	indicated by @set_target() (second stage).
+ *	@prepare_late() is called right after the nonboot CPUs have been
+ *	disabled (it is executed with on CPU on line and with IRQs enabled).
+ *	This callback is optional.  It returns 0 on success or a negative
+ *	error code otherwise, in which case the system cannot enter the desired
+ *	sleep state (@enter() will not be called in that case).
+ *
  * @enter: Enter the system sleep state indicated by @set_target() or
  *	represented by the argument if @set_target() is not implemented.
  *	This callback is mandatory.  It returns 0 on success or a negative
  *	error code otherwise, in which case the system cannot enter the desired
  *	sleep state.
  *
+ * @finish_early: Called when the system has just left a sleep state, right
+ *	prior to enabling the nonboot CPUs (it is executed with one CPU on line
+ *	and with IRQs enabled).
+ *	This callback is optional, but should be implemented by the platforms
+ *	that implement @prepare_late().  If @enter() fails, this callback will
+ *	not be executed.
+ *
  * @finish: Called when the system has just left a sleep state, right after
  *	the nonboot CPUs have been enabled and before devices are resumed (it is
  *	executed with IRQs enabled).
@@ -74,7 +89,9 @@ struct platform_suspend_ops {
 	int (*valid)(suspend_state_t state);
 	int (*set_target)(suspend_state_t state);
 	int (*prepare)(void);
+	int (*prepare_late)(void);
 	int (*enter)(suspend_state_t state);
+	void (*finish_early)(void);
 	void (*finish)(void);
 };
 
@@ -141,15 +158,32 @@ extern void mark_free_pages(struct zone 
  *	Called right after devices have been frozen and before the nonboot
  *	CPUs are disabled (runs with IRQs on).
  *
- * @finish: Restore the previous state of the platform after the hibernation
- *	image has been created *or* put the platform into the normal operation
- *	mode after the hibernation (the same method is executed in both cases).
- *	Called right after the nonboot CPUs have been enabled and before
- *	thawing devices (runs with IRQs on).
- *
- * @prepare: Prepare the platform for entering the low power state.
- *	Called right after the hibernation image has been saved and before
- *	devices are prepared for entering the low power state.
+ * @post_snapshot: Prepare the platform for saving the hibernation image.
+ *	Called right prior to thawing devices in order to save the hibernation
+ *	image, after the nonboot CPUs have been enabled (runs with IRQs on).
+ *
+ * @finish_early: Restore the previous state of the platform putting it into the
+ *	normal operation mode after hibernation (first stage).
+ *	Called only during restore, prior to enabling the nonboot CPUs (runs
+ *	with one CPU on line and with IRQs on).
+ *
+ * @finish: Restore the previous state of the platform putting it into the
+ *	normal operation mode after hibernation (second stage).
+ *	Called during restore after the nonboot CPUs have been enabled and prior
+ *	to thawing devices.  Also called during hibernation if there's an error
+ *	making it impossible to hibernate, but only after @pre_snapshot() have
+ *	been successfully executed.  Runs with IRQs on.
+ *
+ * @prepare: Prepare the platform for entering the hibernation state (first
+ *	stage).
+ *	Called right after the hibernation image has been saved and devices have
+ *	been prepared for entering the low power states.
+ *
+ * @prepare_late: Prepare the platform for entering the hibernation state
+ *	(second stage).
+ *	Called after the hibernation image has been saved, devices have been
+ *	prepared for entering the low power states and the nonboot CPUs have
+ *	been disabled.
  *
  * @enter: Put the system into the low power state after the hibernation image
  *	has been saved to disk.
@@ -167,8 +201,11 @@ extern void mark_free_pages(struct zone 
 struct platform_hibernation_ops {
 	int (*start)(void);
 	int (*pre_snapshot)(void);
+	void (*post_snapshot)(void);
+	void (*finish_early)(void);
 	void (*finish)(void);
 	int (*prepare)(void);
+	int (*prepare_late)(void);
 	int (*enter)(void);
 	int (*pre_restore)(void);
 	void (*restore_cleanup)(void);
Index: linux-2.6.23-rc3/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.23-rc3/drivers/acpi/sleep/main.c
@@ -58,7 +58,7 @@ static int acpi_pm_set_target(suspend_st
 }
 
 /**
- *	acpi_pm_prepare - Do preliminary suspend work.
+ *	acpi_pm_prepare - Do preliminary suspend work (first stage).
  *
  *	If necessary, set the firmware waking vector and do arch-specific
  *	nastiness to get the wakeup code to the waking vector.
@@ -75,6 +75,24 @@ static int acpi_pm_prepare(void)
 }
 
 /**
+ *	acpi_pm_prepare_late - Do preliminary suspend work (second stage).
+ */
+
+static int acpi_pm_prepare_late(void)
+{
+	acpi_status status;
+
+	status = acpi_enter_sleep_state_prep_late(acpi_target_sleep_state);
+
+	if (ACPI_SUCCESS(status))
+		return 0;
+
+	acpi_target_sleep_state = ACPI_STATE_S0;
+
+	return -EFAULT;
+}
+
+/**
  *	acpi_pm_enter - Actually enter a sleep state.
  *	@pm_state: ignored
  *
@@ -139,10 +157,22 @@ static int acpi_pm_enter(suspend_state_t
 }
 
 /**
- *	acpi_pm_finish - Finish up suspend sequence.
+ *	acpi_pm_finish_early - Finish up suspend sequence (first stage).
  *
  *	This is called after we wake back up (or if entering the sleep state
- *	failed). 
+ *	has failed).
+ */
+
+static void acpi_pm_finish_early(void)
+{
+	acpi_leave_sleep_state_prep(acpi_target_sleep_state);
+}
+
+/**
+ *	acpi_pm_finish - Finish up suspend sequence (second stage).
+ *
+ *	This is called after we wake back up (or if entering the sleep state
+ *	has failed).
  */
 
 static void acpi_pm_finish(void)
@@ -185,7 +215,9 @@ static struct platform_suspend_ops acpi_
 	.valid = acpi_pm_state_valid,
 	.set_target = acpi_pm_set_target,
 	.prepare = acpi_pm_prepare,
+	.prepare_late = acpi_pm_prepare_late,
 	.enter = acpi_pm_enter,
+	.finish_early = acpi_pm_finish_early,
 	.finish = acpi_pm_finish,
 };
 
@@ -222,6 +254,15 @@ static int acpi_hibernation_prepare(void
 	return acpi_sleep_prepare(ACPI_STATE_S4);
 }
 
+static int acpi_hibernation_prepare_late(void)
+{
+	acpi_status status;
+
+	status = acpi_enter_sleep_state_prep_late(ACPI_STATE_S4);
+
+	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
+}
+
 static int acpi_hibernation_enter(void)
 {
 	acpi_status status = AE_OK;
@@ -238,13 +279,18 @@ static int acpi_hibernation_enter(void)
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
 }
 
-static void acpi_hibernation_finish(void)
+static void acpi_hibernation_finish_early(void)
 {
 	/*
 	 * If ACPI is not enabled by the BIOS and the boot kernel, we need to
 	 * enable it here.
 	 */
 	acpi_enable();
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
+}
+
+static void acpi_hibernation_finish(void)
+{
 	acpi_leave_sleep_state(ACPI_STATE_S4);
 	acpi_disable_wakeup_device(ACPI_STATE_S4);
 
@@ -271,7 +317,10 @@ static void acpi_hibernation_restore_cle
 static struct platform_hibernation_ops acpi_hibernation_ops = {
 	.start = acpi_hibernation_start,
 	.pre_snapshot = acpi_hibernation_prepare,
+	.post_snapshot = acpi_hibernation_finish,
 	.finish = acpi_hibernation_finish,
+	.finish_early = acpi_hibernation_finish_early,
+	.prepare_late = acpi_hibernation_prepare_late,
 	.prepare = acpi_hibernation_prepare,
 	.enter = acpi_hibernation_enter,
 	.pre_restore = acpi_hibernation_pre_restore,
Index: linux-2.6.23-rc3/kernel/power/main.c
===================================================================
--- linux-2.6.23-rc3.orig/kernel/power/main.c
+++ linux-2.6.23-rc3/kernel/power/main.c
@@ -173,9 +173,21 @@ int suspend_devices_and_enter(suspend_st
 			goto Resume_devices;
 	}
 	error = disable_nonboot_cpus();
-	if (!error)
-		suspend_enter(state);
+	if (error)
+		goto Enable_cpus;
+
+	if (suspend_ops->prepare_late) {
+		error = suspend_ops->prepare_late();
+		if (error)
+			goto Enable_cpus;
+	}
+
+	error = suspend_enter(state);
+
+	if (!error && suspend_ops->finish_early)
+		suspend_ops->finish_early();
 
+ Enable_cpus:
 	enable_nonboot_cpus();
 	if (suspend_ops->finish)
 		suspend_ops->finish();
Index: linux-2.6.23-rc3/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.23-rc3.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6.23-rc3/drivers/acpi/hardware/hwsleep.c
@@ -162,8 +162,8 @@ ACPI_EXPORT_SYMBOL(acpi_get_firmware_wak
  *
  * DESCRIPTION: Prepare to enter a system sleep state (see ACPI 2.0 spec p 231)
  *              This function must execute with interrupts enabled.
- *              We break sleeping into 2 stages so that OSPM can handle
- *              various OS-specific tasks between the two steps.
+ *              We break sleeping into 3 stages so that OSPM can handle
+ *              various OS-specific tasks between the three steps.
  *
  ******************************************************************************/
 acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
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
@@ -245,6 +240,43 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_stat
 
 /*******************************************************************************
  *
+ * FUNCTION:    acpi_enter_sleep_state_prep_late
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Execute the _GTS ACPI global control method.
+ *              This function must execute with interrupts enabled.
+ *
+ ******************************************************************************/
+acpi_status acpi_enter_sleep_state_prep_late(u8 sleep_state)
+{
+	acpi_status status;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+
+	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state_prep_late);
+
+	/* Setup parameter object */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
+
+	/* Run the _GTS method */
+
+	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
+
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		return_ACPI_STATUS(status);
+	}
+	return_ACPI_STATUS(AE_OK);
+}
+/*******************************************************************************
+ *
  * FUNCTION:    acpi_enter_sleep_state
  *
  * PARAMETERS:  sleep_state         - Which sleep state to enter
@@ -478,17 +510,17 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_stat
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_leave_sleep_state
+ * FUNCTION:    acpi_leave_sleep_state_prep
  *
- * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ * PARAMETERS:  sleep_state         - Which sleep state we are exiting
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
+ * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep (first stage)
  *              Called with interrupts ENABLED.
  *
  ******************************************************************************/
-acpi_status acpi_leave_sleep_state(u8 sleep_state)
+acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 {
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
@@ -498,7 +530,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	u32 PM1Acontrol;
 	u32 PM1Bcontrol;
 
-	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_prep);
 
 	/*
 	 * Set SLP_TYPE and SLP_EN to state S0.
@@ -560,17 +592,40 @@ acpi_status acpi_leave_sleep_state(u8 sl
 
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
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_leave_sleep_state
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep (second stage)
+ *              Called with interrupts ENABLED.
+ *
+ ******************************************************************************/
+acpi_status acpi_leave_sleep_state(u8 sleep_state)
+{
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+	acpi_status status;
+
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
@@ -589,6 +644,13 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		return_ACPI_STATUS(status);
 	}
 
+	/* Setup parameter object */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
+
 	status = acpi_evaluate_object(NULL, METHOD_NAME__WAK, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _WAK"));
Index: linux-2.6.23-rc3/include/acpi/acpixf.h
===================================================================
--- linux-2.6.23-rc3.orig/include/acpi/acpixf.h
+++ linux-2.6.23-rc3/include/acpi/acpixf.h
@@ -329,10 +329,14 @@ acpi_get_sleep_type_data(u8 sleep_state,
 
 acpi_status acpi_enter_sleep_state_prep(u8 sleep_state);
 
+acpi_status acpi_enter_sleep_state_prep_late(u8 sleep_state);
+
 acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state);
 
 acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void);
 
+acpi_status acpi_leave_sleep_state_prep(u8 sleep_state);
+
 acpi_status acpi_leave_sleep_state(u8 sleep_state);
 
 #endif				/* __ACXFACE_H__ */
Index: linux-2.6.23-rc3/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc3.orig/kernel/power/disk.c
+++ linux-2.6.23-rc3/kernel/power/disk.c
@@ -54,9 +54,10 @@ static struct platform_hibernation_ops *
 
 void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
-	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
-	    && ops->prepare && ops->enter && ops->pre_restore
-	    && ops->restore_cleanup)) {
+	if (ops && !(ops->start && ops->pre_snapshot && ops->post_snapshot
+	    && ops->finish_early && ops->finish
+	    && ops->prepare && ops->prepare_late && ops->enter
+	    && ops->pre_restore && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
 	}
@@ -93,8 +94,32 @@ static int platform_pre_snapshot(int pla
 }
 
 /**
+ *	platform_post_snapshot - use the platform driver, if so configured, to
+ *	prepare the machine for saving the hibernation image.
+ */
+
+static void platform_post_snapshot(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->post_snapshot();
+}
+
+/**
+ *	platform_finish_early - switch the machine to the normal mode of
+ *	operation using the platform driver (first stage; called only after
+ *	image restoration)
+ */
+
+static void platform_finish_early(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->finish_early();
+}
+
+/**
  *	platform_finish - switch the machine to the normal mode of operation
- *	using the platform driver (must be called after platform_prepare())
+ *	using the platform driver (second stage; called only after image
+ *	restoration)
  */
 
 static void platform_finish(int platform_mode)
@@ -165,14 +190,20 @@ int hibernation_snapshot(int platform_mo
 			in_suspend = 1;
 			error = swsusp_suspend();
 			/* Control returns here after successful restore */
+			if (!in_suspend)
+				platform_finish_early(platform_mode);
 		} else {
 			printk("swsusp debug: Waiting for 5 seconds.\n");
 			mdelay(5000);
 		}
 	}
 	enable_nonboot_cpus();
+
+	if (in_suspend && !error)
+		platform_post_snapshot(platform_mode);
+	else
+		platform_finish(platform_mode);
  Resume_devices:
-	platform_finish(platform_mode);
 	device_resume();
  Resume_console:
 	resume_console();
@@ -227,8 +258,9 @@ int hibernation_platform_enter(void)
 
 	/*
 	 * We have cancelled the power transition by running
-	 * hibernation_ops->finish() before saving the image, so we should let
-	 * the firmware know that we're going to enter the sleep state after all
+	 * hibernation_ops->post_snapshot() before saving the image, so we
+	 * should let the firmware know that we're going to enter the sleep
+	 * state after all
 	 */
 	error = hibernation_ops->start();
 	if (error)
@@ -247,6 +279,10 @@ int hibernation_platform_enter(void)
 	if (error)
 		goto Finish;
 
+	error = hibernation_ops->prepare_late();
+	if (error)
+		goto Finish;
+
 	local_irq_disable();
 	error = device_power_down(PMSG_SUSPEND);
 	if (!error) {
