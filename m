Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbXH2PP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbXH2PP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 11:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbXH2PPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 11:15:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54651 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbXH2PPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 11:15:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: Re: [linux-pm] [PATCH -mm 3/3] PM: Improve handling of ACPI system state indicator (rev. 3)
Date: Wed, 29 Aug 2007 17:26:13 +0200
User-Agent: KMail/1.9.5
Cc: linux-pm@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200708272347.45438.rjw@sisk.pl> <200708272353.09380.rjw@sisk.pl>
In-Reply-To: <200708272353.09380.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708291726.14414.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since I've just sent a new version of the 2/3 patch, below is the alternatove
version of $subject applying on top of that one.

Greetings,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>

To be able to avoid turning off the sleep state indicator during hibernation
on Thinkpads (currently, it is turned off before saving the image, because we
need to call finish() before unfreezing devices), we need to move the invocation
of the _SST global ACPI method from acpi_enter_sleep_state_prep() to a separate
function, acpi_set_sleep_state_indicator(), that will be called wherever
necessary by higher-level routines.  Also, once acpi_set_sleep_state_indicator()
has been introduced, the execution of _SST can be removed from
acpi_leave_sleep_state_finish().

acpi_set_sleep_state_indicator() should be called by acpi_pm_prepare() as well
as by acpi_pm_finish() and by acpi_hibernation_finish().  Moreover, it is
necessary to introduce a new hibernation callback ->post_snapshot(), that won't
change the state indicator status and will be executed instead of ->finish()
after creating a hibernation image.  Of course, the status indicator should be
set before the hibernation, so the ->pre_snapshot() callback also has to call
acpi_set_sleep_state_indicator() on ACPI systems.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/hardware/hwsleep.c |   51 +++++++++++++++++++++++++++-------------
 drivers/acpi/sleep/main.c       |   39 ++++++++++++++++++++++++------
 include/acpi/acpixf.h           |    2 +
 include/linux/suspend.h         |   19 ++++++++++----
 kernel/power/disk.c             |   23 ++++++++++++++----
 5 files changed, 100 insertions(+), 34 deletions(-)

Index: linux-2.6.23-rc4/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.23-rc4.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6.23-rc4/drivers/acpi/hardware/hwsleep.c
@@ -199,15 +199,46 @@ acpi_status acpi_enter_sleep_state_prep(
 		return_ACPI_STATUS(status);
 	}
 
-	/* Setup the argument to _SST */
+	/* Disable/Clear all GPEs */
+
+	status = acpi_hw_disable_all_gpes();
+
+	return_ACPI_STATUS(status);
+}
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_set_sleep_state_indicator
+ *
+ * PARAMETERS:  sleep_state         - Which sleep state to enter
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Make the system status indicator reflect the sleep state being
+ *              entered.
+ *              This function must execute with interrupts enabled.
+ *
+ ******************************************************************************/
+acpi_status acpi_set_sleep_state_indicator(u8 sleep_state)
+{
+	acpi_status status;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
+
+	ACPI_FUNCTION_TRACE(acpi_set_sleep_state_indicator);
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+
+	arg.type = ACPI_TYPE_INTEGER;
+
+	/* Setup the argument to _SST */
 	switch (sleep_state) {
 	case ACPI_STATE_S0:
 		arg.integer.value = ACPI_SST_WORKING;
 		break;
 
 	case ACPI_STATE_S1:
-	case ACPI_STATE_S2:
 	case ACPI_STATE_S3:
 		arg.integer.value = ACPI_SST_SLEEPING;
 		break;
@@ -217,27 +248,21 @@ acpi_status acpi_enter_sleep_state_prep(
 		break;
 
 	default:
-		arg.integer.value = ACPI_SST_INDICATOR_OFF;	/* Default is off */
+		/* Default is off */
+		arg.integer.value = ACPI_SST_INDICATOR_OFF;
 		break;
 	}
 
 	/* Set the system indicators to show the desired sleep state. */
-
 	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		ACPI_EXCEPTION((AE_INFO, status,
 				"While executing method _SST"));
 	}
 
-	/* Disable/Clear all GPEs */
-
-	status = acpi_hw_disable_all_gpes();
-
 	return_ACPI_STATUS(status);
 }
 
-ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_prep)
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_enter_sleep_state
@@ -652,11 +677,5 @@ acpi_status acpi_leave_sleep_state_finis
 	    acpi_set_register(acpi_gbl_fixed_event_info
 			      [ACPI_EVENT_POWER_BUTTON].status_register_id, 1);
 
-	arg.integer.value = ACPI_SST_WORKING;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__SST, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
-	}
-
 	return_ACPI_STATUS(status);
 }
Index: linux-2.6.23-rc4/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.23-rc4.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.23-rc4/drivers/acpi/sleep/main.c
@@ -70,6 +70,8 @@ static int acpi_pm_prepare(void)
 
 	if (error)
 		acpi_target_sleep_state = ACPI_STATE_S0;
+	else
+		acpi_set_sleep_state_indicator(acpi_target_sleep_state);
 
 	return error;
 }
@@ -159,6 +161,7 @@ static void acpi_pm_finish(void)
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
+	acpi_set_sleep_state_indicator(ACPI_STATE_S0);
 
 #ifdef CONFIG_X86
 	if (init_8259A_after_S1) {
@@ -217,9 +220,33 @@ static struct dmi_system_id __initdata a
 static int acpi_hibernation_start(void)
 {
 	acpi_target_sleep_state = ACPI_STATE_S4;
+
 	return 0;
 }
 
+static int acpi_hibernation_pre_snapshot(void)
+{
+	int error = acpi_sleep_prepare(ACPI_STATE_S4);
+
+	if (error)
+		acpi_target_sleep_state = ACPI_STATE_S0;
+	else
+		acpi_set_sleep_state_indicator(ACPI_STATE_S4);
+
+	return error;
+}
+
+static void acpi_hibernation_post_snapshot(void)
+{
+	acpi_leave_sleep_state_finish(ACPI_STATE_S4);
+	acpi_disable_wakeup_device(ACPI_STATE_S4);
+
+	/* reset firmware waking vector */
+	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
+
+	acpi_target_sleep_state = ACPI_STATE_S0;
+}
+
 static int acpi_hibernation_prepare(void)
 {
 	return acpi_sleep_prepare(ACPI_STATE_S4);
@@ -253,13 +280,8 @@ static void acpi_hibernation_leave(void)
 
 static void acpi_hibernation_finish(void)
 {
-	acpi_leave_sleep_state_finish(ACPI_STATE_S4);
-	acpi_disable_wakeup_device(ACPI_STATE_S4);
-
-	/* reset firmware waking vector */
-	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
-
-	acpi_target_sleep_state = ACPI_STATE_S0;
+	acpi_hibernation_post_snapshot();
+	acpi_set_sleep_state_indicator(ACPI_STATE_S0);
 }
 
 static int acpi_hibernation_pre_restore(void)
@@ -278,7 +300,8 @@ static void acpi_hibernation_restore_cle
 
 static struct platform_hibernation_ops acpi_hibernation_ops = {
 	.start = acpi_hibernation_start,
-	.pre_snapshot = acpi_hibernation_prepare,
+	.pre_snapshot = acpi_hibernation_pre_snapshot,
+	.post_snapshot = acpi_hibernation_post_snapshot,
 	.finish = acpi_hibernation_finish,
 	.prepare = acpi_hibernation_prepare,
 	.enter = acpi_hibernation_enter,
Index: linux-2.6.23-rc4/include/acpi/acpixf.h
===================================================================
--- linux-2.6.23-rc4.orig/include/acpi/acpixf.h
+++ linux-2.6.23-rc4/include/acpi/acpixf.h
@@ -327,6 +327,8 @@ acpi_get_firmware_waking_vector(acpi_phy
 acpi_status
 acpi_get_sleep_type_data(u8 sleep_state, u8 * slp_typ_a, u8 * slp_typ_b);
 
+acpi_status acpi_set_sleep_state_indicator(u8 sleep_state);
+
 acpi_status acpi_enter_sleep_state_prep(u8 sleep_state);
 
 acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state);
Index: linux-2.6.23-rc4/include/linux/suspend.h
===================================================================
--- linux-2.6.23-rc4.orig/include/linux/suspend.h
+++ linux-2.6.23-rc4/include/linux/suspend.h
@@ -139,13 +139,19 @@ extern void mark_free_pages(struct zone 
  *
  * @pre_snapshot: Prepare the platform for creating the hibernation image.
  *	Called right after devices have been frozen and before the nonboot
- *	CPUs are disabled (runs with IRQs on).
+ *	CPUs are disabled (runs with interrupts enabled).
  *
- * @finish: Restore the previous state of the platform after the hibernation
- *	image has been created *or* put the platform into the normal operation
- *	mode after the hibernation (the same method is executed in both cases).
- *	Called right after the nonboot CPUs have been enabled and before
- *	thawing devices (runs with IRQs on).
+ * @post_snapshot: Restore the previous state of the platform after creating a
+ *	hibernation image.
+ *	Called when the hibernation image has been created, right after the
+ *	nonboot CPUs have been enabled and before thawing devices (runs with
+ *	interrupts enabled).
+ *
+ * @finish: Put the platform into the normal operation mode after the
+ *	hibernation.
+ *	Called only after @leave() has been executed, right after the nonboot
+ *	CPUs have been enabled and before thawing devices (runs with interrupts
+ *	enabled).
  *
  * @prepare: Prepare the platform for entering the low power state.
  *	Called right after the hibernation image has been saved and before
@@ -173,6 +179,7 @@ extern void mark_free_pages(struct zone 
 struct platform_hibernation_ops {
 	int (*start)(void);
 	int (*pre_snapshot)(void);
+	void (*post_snapshot)(void);
 	void (*finish)(void);
 	int (*prepare)(void);
 	int (*enter)(void);
Index: linux-2.6.23-rc4/kernel/power/disk.c
===================================================================
--- linux-2.6.23-rc4.orig/kernel/power/disk.c
+++ linux-2.6.23-rc4/kernel/power/disk.c
@@ -54,9 +54,9 @@ static struct platform_hibernation_ops *
 
 void hibernation_set_ops(struct platform_hibernation_ops *ops)
 {
-	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
-	    && ops->prepare && ops->enter && ops->leave && ops->pre_restore
-	    && ops->restore_cleanup)) {
+	if (ops && !(ops->start && ops->pre_snapshot && ops->post_snapshot
+	    && ops->finish && ops->prepare && ops->enter && ops->leave
+	    && ops->pre_restore && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
 	}
@@ -93,6 +93,18 @@ static int platform_pre_snapshot(int pla
 }
 
 /**
+ *	platform_post_snapshot - switch the machine to the normal mode of
+ *	operation using the platform driver after creating the hibernation
+ *	image
+ */
+
+static void platform_post_snapshot(int platform_mode)
+{
+	if (platform_mode && hibernation_ops)
+		hibernation_ops->post_snapshot();
+}
+
+/**
  *	platform_leave - prepare the machine for switching to the normal mode
  *	of operation using the platform driver (called with interrupts disabled)
  */
@@ -228,7 +240,10 @@ int hibernation_snapshot(int platform_mo
 	}
 	enable_nonboot_cpus();
  Resume_devices:
-	platform_finish(platform_mode);
+	if (!error && !in_suspend)
+		platform_finish(platform_mode);
+	else
+		platform_post_snapshot(platform_mode);
 	device_resume();
  Resume_console:
 	resume_console();
