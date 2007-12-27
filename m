Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbXL0SCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbXL0SCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbXL0SBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:01:50 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43408 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbXL0SBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:01:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][PATCH 2/7] ACPI: Separate invocations of _GTS and _BFS from _PTS and _WAK
Date: Thu, 27 Dec 2007 19:15:16 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       "Moore, Robert" <robert.moore@intel.com>
References: <200712271903.53961.rjw@sisk.pl>
In-Reply-To: <200712271903.53961.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712271915.17174.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The execution of ACPI global control methods _GTS and _BFS is
currently tied to the preparation to enter a sleep state and to the
leaving of the sleep state, respectively.  However, these functions
are called before disabling the nonboot CPUs and after enabling
them, respectively (in fact, on ACPI 1.0x systems the first of them
ought to be called before suspending devices), while according to the
ACPI specification, _GTS is to be executed right prior to entering
the system sleep state and _BFS is to be executed right after the
platfor firmware has returned control to the OS on wake up.

Move the execution of _GTS and _BFS to the right places.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/hardware/hwsleep.c |   75 ++++++++++++++++++++++++++++++----------
 drivers/acpi/sleep/main.c       |    7 +++
 include/acpi/acpixf.h           |    2 +
 3 files changed, 66 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/acpi/hardware/hwsleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/hardware/hwsleep.c
+++ linux-2.6/drivers/acpi/hardware/hwsleep.c
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
@@ -262,6 +257,8 @@ acpi_status asmlinkage acpi_enter_sleep_
 	struct acpi_bit_register_info *sleep_type_reg_info;
 	struct acpi_bit_register_info *sleep_enable_reg_info;
 	u32 in_value;
+	struct acpi_object_list arg_list;
+	union acpi_object arg;
 	acpi_status status;
 
 	ACPI_FUNCTION_TRACE(acpi_enter_sleep_state);
@@ -307,6 +304,18 @@ acpi_status asmlinkage acpi_enter_sleep_
 		return_ACPI_STATUS(status);
 	}
 
+	/* Execute the _GTS method */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
+
+	status = acpi_evaluate_object(NULL, METHOD_NAME__GTS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		return_ACPI_STATUS(status);
+	}
+
 	/* Get current value of PM1A control */
 
 	status = acpi_hw_register_read(ACPI_REGISTER_PM1_CONTROL, &PM1Acontrol);
@@ -473,17 +482,18 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_stat
 
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
- *              Called with interrupts ENABLED.
+ * DESCRIPTION: Perform the first state of OS-independent ACPI cleanup after a
+ *              sleep.
+ *              Called with interrupts DISABLED.
  *
  ******************************************************************************/
-acpi_status acpi_leave_sleep_state(u8 sleep_state)
+acpi_status acpi_leave_sleep_state_prep(u8 sleep_state)
 {
 	struct acpi_object_list arg_list;
 	union acpi_object arg;
@@ -493,7 +503,7 @@ acpi_status acpi_leave_sleep_state(u8 sl
 	u32 PM1Acontrol;
 	u32 PM1Bcontrol;
 
-	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state);
+	ACPI_FUNCTION_TRACE(acpi_leave_sleep_state_prep);
 
 	/*
 	 * Set SLP_TYPE and SLP_EN to state S0.
@@ -540,6 +550,41 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		}
 	}
 
+	/* Execute the _BFS method */
+
+	arg_list.count = 1;
+	arg_list.pointer = &arg;
+	arg.type = ACPI_TYPE_INTEGER;
+	arg.integer.value = sleep_state;
+
+	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
+	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
+		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
+	}
+
+	return_ACPI_STATUS(status);
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
+ * DESCRIPTION: Perform OS-independent ACPI cleanup after a sleep
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
+
 	/* Ensure enter_sleep_state_prep -> enter_sleep_state ordering */
 
 	acpi_gbl_sleep_type_a = ACPI_SLEEP_TYPE_INVALID;
@@ -558,12 +603,6 @@ acpi_status acpi_leave_sleep_state(u8 sl
 		ACPI_EXCEPTION((AE_INFO, status, "During Method _SST"));
 	}
 
-	arg.integer.value = sleep_state;
-	status = acpi_evaluate_object(NULL, METHOD_NAME__BFS, &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		ACPI_EXCEPTION((AE_INFO, status, "During Method _BFS"));
-	}
-
 	/*
 	 * GPEs must be enabled before _WAK is called as GPEs
 	 * might get fired there
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -139,6 +139,9 @@ static int acpi_pm_enter(suspend_state_t
 		break;
 	}
 
+	/* Reprogram control registers and execute _BFS */
+	acpi_leave_sleep_state_prep(acpi_state);
+
 	/* ACPI 3.0 specs (P62) says that it's the responsabilty
 	 * of the OSPM to clear the status bit [ implying that the
 	 * POWER_BUTTON event should not reach userspace ]
@@ -272,6 +275,8 @@ static int acpi_hibernation_enter(void)
 	acpi_enable_wakeup_device(ACPI_STATE_S4);
 	/* This shouldn't return.  If it returns, we have a problem */
 	status = acpi_enter_sleep_state(ACPI_STATE_S4);
+	/* Reprogram control registers and execute _BFS */
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
 	local_irq_restore(flags);
 
 	return ACPI_SUCCESS(status) ? 0 : -EFAULT;
@@ -284,6 +289,8 @@ static void acpi_hibernation_leave(void)
 	 * enable it here.
 	 */
 	acpi_enable();
+	/* Reprogram control registers and execute _BFS */
+	acpi_leave_sleep_state_prep(ACPI_STATE_S4);
 }
 
 static void acpi_hibernation_finish(void)
Index: linux-2.6/include/acpi/acpixf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpixf.h
+++ linux-2.6/include/acpi/acpixf.h
@@ -335,6 +335,8 @@ acpi_status asmlinkage acpi_enter_sleep_
 
 acpi_status asmlinkage acpi_enter_sleep_state_s4bios(void);
 
+acpi_status acpi_leave_sleep_state_prep(u8 sleep_state);
+
 acpi_status acpi_leave_sleep_state(u8 sleep_state);
 
 #endif				/* __ACXFACE_H__ */
