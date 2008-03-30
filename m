Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbYC3BTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbYC3BTl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 21:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbYC3BTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 21:19:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32822 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbYC3BTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 21:19:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI PM: Restore the 2.6.24 suspend ordering
Date: Sun, 30 Mar 2008 02:19:07 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Felix =?iso-8859-2?q?M=F6ller?= <fm@opensuse.org>,
       Arthur Erhardt <erhardt@pit.physik.uni-tuebingen.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803300319.08398.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len,

Please consider pushing the appended patch for 2.6.25.

It fixed the regression described at:
https://bugzilla.novell.com/show_bug.cgi?id=374217
http://bugzilla.kernel.org/show_bug.cgi?id=10340

details in the changelog.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

Some time ago it turned out that our suspend code ordering broke
some NVidia-based systems that hung if _PTS was executed with one of
the PCI devices, specifically a USB controller, in a low power state.
Then, it was noticed that the suspend code ordering was not compliant
with ACPI 1.0, although it was compliant with ACPI 2.0 (and later),
and it was argued that the code had to be changed for that reason
(ref. http://bugzilla.kernel.org/show_bug.cgi?id=9528).  So we did,
but evidently we did wrong, because it's now turning out that some
systems have been broken by this change (refs.
http://bugzilla.kernel.org/show_bug.cgi?id=10340 ,
https://bugzilla.novell.com/show_bug.cgi?id=374217#c16).  [I said
at that time that something like this might happend, but the majority
of people involved thought that it was improbable due to the
necessity to preserve the compliance of hardware with ACPI 1.0.]
This actually is a quite serious regression from 2.6.24.

Moreover, the ACPI 1.0 ordering of suspend code introduced another
issue that I have only noticed recently.  Namely, if the suspend of
one of devices fails, the already suspended devices will be resumed
without executing _WAK before, which leads to problems on some
systems (for example, in such situations thermal management is
broken on my HP nx6325).  Consequently, it also breaks suspend
debugging on the affected systems.

Note also, that the requirement to execute _PTS before suspending
devices does not really make sense, because the device in question
may be put into a low power state at run time for a reason unrelated
to a system-wide suspend.

For the reasons outlined above, the change of the suspend ordering
should be reverted, which is done by the patch below.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/kernel-parameters.txt |    5 --
 drivers/acpi/sleep/main.c           |   71 +++++++-----------------------------
 2 files changed, 14 insertions(+), 62 deletions(-)

Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c
+++ linux-2.6/drivers/acpi/sleep/main.c
@@ -26,21 +26,6 @@ u8 sleep_states[ACPI_S_STATE_COUNT];
 
 #ifdef CONFIG_PM_SLEEP
 static u32 acpi_target_sleep_state = ACPI_STATE_S0;
-static bool acpi_sleep_finish_wake_up;
-
-/*
- * ACPI 2.0 and later want us to execute _PTS after suspending devices, so we
- * allow the user to request that behavior by using the 'acpi_new_pts_ordering'
- * kernel command line option that causes the following variable to be set.
- */
-static bool new_pts_ordering;
-
-static int __init acpi_new_pts_ordering(char *str)
-{
-	new_pts_ordering = true;
-	return 1;
-}
-__setup("acpi_new_pts_ordering", acpi_new_pts_ordering);
 #endif
 
 static int acpi_sleep_prepare(u32 acpi_state)
@@ -91,14 +76,6 @@ static int acpi_pm_begin(suspend_state_t
 
 	if (sleep_states[acpi_state]) {
 		acpi_target_sleep_state = acpi_state;
-		if (new_pts_ordering)
-			return 0;
-
-		error = acpi_sleep_prepare(acpi_state);
-		if (error)
-			acpi_target_sleep_state = ACPI_STATE_S0;
-		else
-			acpi_sleep_finish_wake_up = true;
 	} else {
 		printk(KERN_ERR "ACPI does not support this state: %d\n",
 			pm_state);
@@ -116,14 +93,11 @@ static int acpi_pm_begin(suspend_state_t
 
 static int acpi_pm_prepare(void)
 {
-	if (new_pts_ordering) {
-		int error = acpi_sleep_prepare(acpi_target_sleep_state);
+	int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
-		if (error) {
-			acpi_target_sleep_state = ACPI_STATE_S0;
-			return error;
-		}
-		acpi_sleep_finish_wake_up = true;
+	if (error) {
+		acpi_target_sleep_state = ACPI_STATE_S0;
+		return error;
 	}
 
 	return ACPI_SUCCESS(acpi_hw_disable_all_gpes()) ? 0 : -EFAULT;
@@ -212,7 +186,6 @@ static void acpi_pm_finish(void)
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
-	acpi_sleep_finish_wake_up = false;
 
 #ifdef CONFIG_X86
 	if (init_8259A_after_S1) {
@@ -229,11 +202,10 @@ static void acpi_pm_finish(void)
 static void acpi_pm_end(void)
 {
 	/*
-	 * This is necessary in case acpi_pm_finish() is not called directly
-	 * during a failing transition to a sleep state.
+	 * This is necessary in case acpi_pm_finish() is not called during a
+	 * failing transition to a sleep state.
 	 */
-	if (acpi_sleep_finish_wake_up)
-		acpi_pm_finish();
+	acpi_target_sleep_state = ACPI_STATE_S0;
 }
 
 static int acpi_pm_state_valid(suspend_state_t pm_state)
@@ -296,31 +268,18 @@ __setup("acpi_s4_nosigcheck", acpi_s4_no
 
 static int acpi_hibernation_begin(void)
 {
-	int error;
-
 	acpi_target_sleep_state = ACPI_STATE_S4;
-	if (new_pts_ordering)
-		return 0;
 
-	error = acpi_sleep_prepare(ACPI_STATE_S4);
-	if (error)
-		acpi_target_sleep_state = ACPI_STATE_S0;
-	else
-		acpi_sleep_finish_wake_up = true;
-
-	return error;
+	return 0;
 }
 
 static int acpi_hibernation_prepare(void)
 {
-	if (new_pts_ordering) {
-		int error = acpi_sleep_prepare(ACPI_STATE_S4);
+	int error = acpi_sleep_prepare(ACPI_STATE_S4);
 
-		if (error) {
-			acpi_target_sleep_state = ACPI_STATE_S0;
-			return error;
-		}
-		acpi_sleep_finish_wake_up = true;
+	if (error) {
+		acpi_target_sleep_state = ACPI_STATE_S0;
+		return error;
 	}
 
 	return ACPI_SUCCESS(acpi_hw_disable_all_gpes()) ? 0 : -EFAULT;
@@ -370,17 +329,15 @@ static void acpi_hibernation_finish(void
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
 
 	acpi_target_sleep_state = ACPI_STATE_S0;
-	acpi_sleep_finish_wake_up = false;
 }
 
 static void acpi_hibernation_end(void)
 {
 	/*
 	 * This is necessary in case acpi_hibernation_finish() is not called
-	 * directly during a failing transition to the sleep state.
+	 * during a failing transition to the sleep state.
 	 */
-	if (acpi_sleep_finish_wake_up)
-		acpi_hibernation_finish();
+	acpi_target_sleep_state = ACPI_STATE_S0;
 }
 
 static int acpi_hibernation_pre_restore(void)
Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -170,11 +170,6 @@ and is between 256 and 4096 characters. 
 	acpi_irq_isa=	[HW,ACPI] If irq_balance, mark listed IRQs used by ISA
 			Format: <irq>,<irq>...
 
-	acpi_new_pts_ordering [HW,ACPI]
-			Enforce the ACPI 2.0 ordering of the _PTS control
-			method wrt putting devices into low power states
-			default: pre ACPI 2.0 ordering of _PTS
-
 	acpi_no_auto_ssdt	[HW,ACPI] Disable automatic loading of SSDT
 
 	acpi_os_name=	[HW,ACPI] Tell ACPI BIOS the name of the OS
