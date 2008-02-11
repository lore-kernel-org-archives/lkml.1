Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbYBKXtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbYBKXtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 18:49:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYBKXtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 18:49:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:39815 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752274AbYBKXtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 18:49:35 -0500
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX1+6s8wYW6u6I3ZYKde1wxem+dGY/F78RsgtIJgFlZ
	cZyMfptRCEex9+
Subject: Re: [REGRESSION]fan turns at highspeed after suspend2ram
From: Mirco Tischler <mt-ml@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@suse.cz>, Ray Lee <ray-lk@madrabbit.org>
In-Reply-To: <200802120005.20601.rjw@sisk.pl>
References: <1202664109.8394.19.camel@mtlp> <200802112013.53850.rjw@sisk.pl>
	 <1202769137.7338.2.camel@mtlp>  <200802120005.20601.rjw@sisk.pl>
Content-Type: multipart/mixed; boundary="=-E2qYFi7LRx1oXtcrAvLG"
Date: Tue, 12 Feb 2008 00:49:30 +0100
Message-Id: <1202773771.14135.1.camel@mtlp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E2qYFi7LRx1oXtcrAvLG
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Di, 2008-02-12 at 00:05 +0100, Rafael J. Wysocki wrote:
> Well, this is strange, because one function introduced by this commit
is
> referred to by the subsequent commits.  Can you send me the patch
reverting
> this commit that you apply on top of 2.6.25-rc1, please?
> 
> Thanks,
> Rafael

Here is the diff after reverting the patch.

Mirco



--=-E2qYFi7LRx1oXtcrAvLG
Content-Disposition: attachment; filename=patch-revert-fanfix
Content-Type: text/x-patch; name=patch-revert-fanfix; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff --git a/drivers/acpi/hardware/hwsleep.c b/drivers/acpi/hardware/hwsleep.c
index 058d0be..eb05733 100644
--- a/drivers/acpi/hardware/hwsleep.c
+++ b/drivers/acpi/hardware/hwsleep.c
@@ -192,13 +192,18 @@ acpi_status acpi_enter_sleep_state_prep(u8 sleep_state)
 	arg.type = ACPI_TYPE_INTEGER;
 	arg.integer.value = sleep_state;
 
-	/* Run the _PTS method */
+	/* Run the _PTS and _GTS methods */
 
 	status = acpi_evaluate_object(NULL, METHOD_NAME__PTS, &arg_list, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
 		return_ACPI_STATUS(status);
 	}
 
+	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		return_ACPI_STATUS(status);
+	}
+
 	/* Setup the argument to _SST */
 
 	switch (sleep_state) {
@@ -253,8 +258,6 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 in_value;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
@@ -300,18 +303,6 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state)
 		return_ACPI_STATUS(status);
 	}
 
-	/* Execute the _GTS method */
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = sleep_state;
-
-	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		return_ACPI_STATUS(status);
-	}
-
 	/* Get current value of PM1A control */
 
 	status = acpi_hw_register_read(ACPI_REGISTER_PM1_CONTROL, &PM1Acontrol);
@@ -478,18 +469,17 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state_s4bios)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_leave_sleep_state_prep
+ * FUNCTION:    acpi_leave_sleep_state
  *
- * PARAMETERS:  sleep_state         - Which sleep state we are exiting
+ * PARAMETERS:  sleep_state         - Which sleep state we just exited
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Perform the first state of OS-independent ACPI cleanup after a
- *              sleep.
- *              Called with interrupts DISABLED.
+ * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
+ *              Called with interrupts ENABLED.
  *
  ******************************************************************************/
-acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
+acpi_status acpi_leave_sleep_state(u8 sleep_state)
 {
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
@@ -499,7 +489,7 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 	u32 PM1Acontrol;
 	u32 PM1Bcontrol;
 
-	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_prep);
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
 
 	/*
 	 * Set SLP_TYPE and SLP_EN to state S0.
@@ -546,41 +536,6 @@ acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 		}
 	}
 
-	/* Execute the _BFS method */
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = sleep_state;
-
-	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
-	}
-
-	return_ACPI_STATUS(status);
-}
-
-/*******************************************************************************
- *
- * FUNCTION:    acpi_leave_sleep_state
- *
- * PARAMETERS:  sleep_state         - Which sleep state we just exited
- *
- * RETURN:      Status
- *
- * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
- *              Called with interrupts ENABLED.
- *
- ******************************************************************************/
-acpi_status acpi_leave_sleep_state(u8 sleep_state)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-	acpi_status status;
-
-	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
-
 	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
 
 	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
@@ -599,6 +554,12 @@ acpi_status acpi_leave_sleep_state(u8 sleep_state)
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
 	}
 
+	arg.integer.value = sleep_state;
+	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
+	}
+
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
 	 * might get fired there
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 293a1cb..3381ea1 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -167,10 +167,7 @@ static int acpi_pm_enter(suspend_state_t pm_state)
 		break;
 	}
 
-	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(acpi_state);
-
-	/* ACPI 3.0 specs (P62) says that it's the responsibility
+	/* ACPI 3.0 specs (P62) says that it's the responsabilty
 	 * of the OSPM to clear the status bit [ implying that the
 	 * POWER_BUTTON event should not reach userspace ]
 	 */
@@ -326,8 +323,6 @@ static int acpi_hibernation_enter(void)
 	acpi_enable_wakeup_device(ACPI_STATE_S4);
 	/* This shouldn't return.  If it returns, we have a problem */
 	status = acpi_enter_sleep_state(ACPI_STATE_S4);
-	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
 	local_irq_restore(flags);
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
@@ -340,8 +335,6 @@ static void acpi_hibernation_leave(void)
 	 * enable it here.
 	 */
 	acpi_enable();
-	/* Reprogram control registers and execute _BFS */
-	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
 }
 
 static void acpi_hibernation_finish(void)
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index d970f7f..18a6377 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -335,8 +335,6 @@ acpi_status asmlinkage acpi_enter_sleep_state(u8 sleep_state);
 
 acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void);
 
-acpi_status acpi_leave_sleep_state_prep(u8 sleep_state);
-
 acpi_status acpi_leave_sleep_state(u8 sleep_state);
 
 #endif				/* __ACXFACE_H__ */

--=-E2qYFi7LRx1oXtcrAvLG--

