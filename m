Return-Path: <linux-kernel-owner+w=401wt.eu-S935795AbYBAEz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935795AbYBAEz4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765998AbYBAEnF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:43:05 -0500
Received: from mga10.intel.com ([192.55.52.92]:64964 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760672AbYBAEmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:42:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,288,1199692800"; 
   d="scan'208";a="511516625"
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>
Subject: [PATCH 29/37] ACPI suspend: Call _PTS before suspending devices
Date: Thu, 31 Jan 2008 23:37:00 -0500
Message-Id: <c833a830b4926ea04d190524966874d061397900.1201840183.git.len.brown@intel.com>
X-Mailer: git-send-email 1.5.4.rc5.16.gc0279
In-Reply-To: <1201840628-23136-1-git-send-email-lenb@kernel.org>
References: <1201840628-23136-1-git-send-email-lenb@kernel.org>
In-Reply-To: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
References: <edae89f5d1eb1fbe1cab74333db5a8e29776900e.1201840183.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The ACPI 1.0 specification wants us to put devices into low power
states after executing the _PTS global control method, while ACPI
2.0 and later want us to do that in the reverse order.  The current
suspend code follows ACPI 2.0 in that respect which causes some
ACPI 1.0x systems to hang during suspend (ref.
http://bugzilla.kernel.org/show_bug.cgi?id=9528).

Make the suspend code execute _PTS before putting devices into low
power states (ie. in accordance with ACPI 1.0x) and provide a command
line option to override the default if need be.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/kernel-parameters.txt |    5 +++
 drivers/acpi/sleep/main.c           |   51 ++++++++++++++++++++++++++---------
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 92c40d1..cf38689 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -168,6 +168,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	acpi_irq_isa=	[HW,ACPI] If irq_balance, mark listed IRQs used by ISA
 			Format: <irq>,<irq>...
 
+	acpi_new_pts_ordering [HW,ACPI]
+			Enforce the ACPI 2.0 ordering of the _PTS control
+			method wrt putting devices into low power states
+			default: pre ACPI 2.0 ordering of _PTS
+
 	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
 
 	acpi_os_name=	[HW,ACPI] Tell ACPI BIOS the name of the OS
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 198ff8a..c37c4ea 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -26,6 +26,21 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
 
 #ifdef CONFIG_PM_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+static bool acpi_sleep_finish_wake_up;
+
+/*
+ * ACPI 2.0 and later want us to execute _PTS after suspending devices, so we
+ * allow the user to request that behavior by using the 'acpi_new_pts_ordering'
+ * kernel command line option that causes the following variable to be set.
+ */
+static bool new_pts_ordering;
+
+static int __init acpi_new_pts_ordering(char *str)
+{
+	new_pts_ordering = true;
+	return 1;
+}
+__setup("acpi_new_pts_ordering", acpi_new_pts_ordering);
 #endif
 
 int acpi_sleep_prepare(u32 acpi_state)
@@ -74,6 +89,14 @@ static int acpi_pm_begin(suspend_state_t pm_state)
 
 	if (sleep_states[acpi_state]) {
 		acpi_target_sleep_state = acpi_state;
+		if (new_pts_ordering)
+			return 0;
+
+		error = acpi_sleep_prepare(acpi_state);
+		if (error)
+			acpi_target_sleep_state = ACPI_STATE_S0;
+		else
+			acpi_sleep_finish_wake_up = true;
 	} else {
 		printk(KERN_ERR "ACPI does not support this state: %d\n",
 			pm_state);
@@ -91,15 +114,17 @@ static int acpi_pm_begin(suspend_state_t pm_state)
 
 static int acpi_pm_prepare(void)
 {
-	int error;
+	if (new_pts_ordering) {
+		int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
-	error = acpi_sleep_prepare(acpi_target_sleep_state);
-	if (error)
-		acpi_target_sleep_state = ACPI_STATE_S0;
-	else if (!ACPI_SUCCESS(acpi_hw_disable_all_gpes()))
-		error = -EFAULT;
+		if (error) {
+			acpi_target_sleep_state = ACPI_STATE_S0;
+			return error;
+		}
+		acpi_sleep_finish_wake_up = true;
+	}
 
-	return error;
+	return ACPI_SUCCESS(acpi_hw_disable_all_gpes()) ? 0 : -EFAULT;
 }
 
 /**
@@ -123,10 +148,8 @@ static int acpi_pm_enter(suspend_state_t pm_state)
 	if (acpi_state == ACPI_STATE_S3) {
 		int error = acpi_save_state_mem();
 
-		if (error) {
-			acpi_target_sleep_state = ACPI_STATE_S0;
+		if (error)
 			return error;
-		}
 	}
 
 	local_irq_save(flags);
@@ -187,6 +210,7 @@ static void acpi_pm_finish(void)
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
+	acpi_sleep_finish_wake_up = false;
 
 #ifdef CONFIG_X86
 	if (init_8259A_after_S1) {
@@ -203,10 +227,11 @@ static void acpi_pm_finish(void)
 static void acpi_pm_end(void)
 {
 	/*
-	 * This is necessary in case acpi_pm_finish() is not called during a
-	 * failing transition to a sleep state.
+	 * This is necessary in case acpi_pm_finish() is not called directly
+	 * during a failing transition to a sleep state.
 	 */
-	acpi_target_sleep_state = ACPI_STATE_S0;
+	if (acpi_sleep_finish_wake_up)
+		acpi_pm_finish();
 }
 
 static int acpi_pm_state_valid(suspend_state_t pm_state)
-- 
1.5.4.rc5.16.gc0279

