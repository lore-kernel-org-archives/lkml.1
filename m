Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbXL0SDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbXL0SDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:03:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXL0SB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:01:58 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43426 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbXL0SBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:01:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [RFC][PATCH 4/7] Suspend: Call _PTS early on ACPI 1.0x systems
Date: Thu, 27 Dec 2007 19:17:32 +0100
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
Message-Id: <200712271917.32982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The ACPI 1.0 specification wants us to put devices into low power
states after executing the _PTS global control methods, while ACPI
2.0 and later want us to do that in the reverse order.  The current
suspend code follows ACPI 2.0 in that respect which causes some
ACPI 1.0x systems to hang during suspend (ref.
http://bugzilla.kernel.org/show_bug.cgi?id=9528).

Make the suspend code execute _PTS before putting devices into low
power states on ACPI 1.0x systems (i.e. on systems for which the
revision in the FADT header is lesser than 3).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/sleep/main.c |   38 +++++++++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -26,6 +26,7 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
 
 #ifdef CONFIG_PM_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
+static bool acpi_sleep_finish_wake_up;
 #endif
 
 int acpi_sleep_prepare(u32 acpi_state)
@@ -74,6 +75,14 @@ static int acpi_pm_open(suspend_state_t 
 
 	if (sleep_states[acpi_state]) {
 		acpi_target_sleep_state = acpi_state;
+		/* On ACPI 1.0x systems _PTS has to be executed right now. */
+		if (acpi_gbl_FADT.header.revision < 3) {
+			error = acpi_sleep_prepare(acpi_state);
+			if (error)
+				acpi_target_sleep_state = ACPI_STATE_S0;
+			else
+				acpi_sleep_finish_wake_up = true;
+		}
 	} else {
 		printk(KERN_ERR "ACPI does not support this state: %d\n",
 			pm_state);
@@ -91,15 +100,18 @@ static int acpi_pm_open(suspend_state_t 
 
 static int acpi_pm_prepare(void)
 {
-	int error;
+	/* On ACPI 1.0x systems_PTS global is executed earlier. */
+	if (acpi_gbl_FADT.header.revision >= 3) {
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
@@ -123,10 +135,8 @@ static int acpi_pm_enter(suspend_state_t
 	if (acpi_state == ACPI_STATE_S3) {
 		int error = acpi_save_state_mem();
 
-		if (error) {
-			acpi_target_sleep_state = ACPI_STATE_S0;
+		if (error)
 			return error;
-		}
 	}
 
 	local_irq_save(flags);
@@ -187,6 +197,7 @@ static void acpi_pm_finish(void)
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
+	acpi_sleep_finish_wake_up = false;
 
 #ifdef CONFIG_X86
 	if (init_8259A_after_S1) {
@@ -203,10 +214,11 @@ static void acpi_pm_finish(void)
 static void acpi_pm_close(void)
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
