Return-Path: <linux-kernel-owner+w=401wt.eu-S936295AbXGQUpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936295AbXGQUpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935531AbXGQUmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:42:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50058 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934115AbXGQUmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:42:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH 8/9] PM: Rework struct hibernation_ops
Date: Tue, 17 Jul 2007 22:47:52 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>
References: <200707172236.28895.rjw@sisk.pl>
In-Reply-To: <200707172236.28895.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707172247.53627.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

During hibernation we also need to tell the ACPI core that we're going to put
the system into the S4 sleep state.  For this reason, an additional method
in 'struct hibernation_ops' is needed, playing the role of set_target() in
'struct platform_suspend_operations'.  Moreover, the role of the .prepare()
method is now different, so it's better to introduce another method, that in
general may be different from .prepare(), that will be used to prepare the
platform for creating the hibernation image (.prepare() is used anyway to
notify the platform that we're going to enter the low power state after the
image has been saved).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/acpi/sleep/main.c |   12 +++++++++++-
 include/linux/suspend.h   |   38 ++++++++++++++++++++++++++++++++------
 kernel/power/disk.c       |   27 +++++++++++++++++++++------
 3 files changed, 64 insertions(+), 13 deletions(-)

Index: linux-2.6.22-git5/include/linux/suspend.h
===================================================================
--- linux-2.6.22-git5.orig/include/linux/suspend.h
+++ linux-2.6.22-git5/include/linux/suspend.h
@@ -133,16 +133,42 @@ extern void mark_free_pages(struct zone 
  *
  * All three methods must be assigned.
  *
- * @prepare: prepare system for hibernation
- * @enter: shut down system after state has been saved to disk
- * @finish: finish/clean up after state has been reloaded
- * @pre_restore: prepare system for the restoration from a hibernation image
- * @restore_cleanup: clean up after a failing image restoration
+ * @start: Tell the platform driver that we're starting hibernation.
+ *	Called right after shrinking memory and before freezing devices.
+ *
+ * @pre_snapshot: Prepare the platform for creating the hibernation image.
+ *	Called right after devices have been frozen and before the nonboot
+ *	CPUs are disabled (runs with IRQs on).
+ *
+ * @finish: Restore the previous state of the platform after the hibernation
+ *	image has been created *or* put the platform into the normal operation
+ *	mode after the hibernation (the same method is executed in both cases).
+ *	Called right after the nonboot CPUs have been enabled and before
+ *	thawing devices (runs with IRQs on).
+ *
+ * @prepare: Prepare the platform for entering the low power state.
+ *	Called right after the hibernation image has been saved and before
+ *	devices are prepared for entering the low power state.
+ *
+ * @enter: Put the system into the low power state after the hibernation image
+ *	has been saved to disk.
+ *	Called after the nonboot CPUs have been disabled and all of the low
+ *	level devices have been shut down (runs with IRQs off).
+ *
+ * @pre_restore: Prepare system for the restoration from a hibernation image.
+ *	Called right after devices have been frozen and before the nonboot
+ *	CPUs are disabled (runs with IRQs on).
+ *
+ * @restore_cleanup: Clean up after a failing image restoration.
+ *	Called right after the nonboot CPUs have been enabled and before
+ *	thawing devices (runs with IRQs on).
  */
 struct hibernation_ops {
+	int (*start)(void);
+	int (*pre_snapshot)(void);
+	void (*finish)(void);
 	int (*prepare)(void);
 	int (*enter)(void);
-	void (*finish)(void);
 	int (*pre_restore)(void);
 	void (*restore_cleanup)(void);
 };
Index: linux-2.6.22-git5/kernel/power/disk.c
===================================================================
--- linux-2.6.22-git5.orig/kernel/power/disk.c
+++ linux-2.6.22-git5/kernel/power/disk.c
@@ -54,8 +54,9 @@ struct hibernation_ops *hibernation_ops;
 
 void hibernation_set_ops(struct hibernation_ops *ops)
 {
-	if (ops && !(ops->prepare && ops->enter && ops->finish
-	    && ops->pre_restore && ops->restore_cleanup)) {
+	if (ops && !(ops->start && ops->pre_snapshot && ops->finish
+	    && ops->prepare && ops->enter && ops->pre_restore
+	    && ops->restore_cleanup)) {
 		WARN_ON(1);
 		return;
 	}
@@ -69,16 +70,26 @@ void hibernation_set_ops(struct hibernat
 	mutex_unlock(&pm_mutex);
 }
 
+/**
+ *	platform_start - tell the platform driver that we're starting
+ *	hibernation
+ */
+
+static int platform_start(int platform_mode)
+{
+	return (platform_mode && hibernation_ops) ?
+		hibernation_ops->start() : 0;
+}
 
 /**
- *	platform_prepare - prepare the machine for hibernation using the
+ *	platform_pre_snapshot - prepare the machine for hibernation using the
  *	platform driver if so configured and return an error code if it fails
  */
 
-static int platform_prepare(int platform_mode)
+static int platform_pre_snapshot(int platform_mode)
 {
 	return (platform_mode && hibernation_ops) ?
-		hibernation_ops->prepare() : 0;
+		hibernation_ops->pre_snapshot() : 0;
 }
 
 /**
@@ -135,12 +146,16 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		return error;
 
+	error = platform_start(platform_mode);
+	if (error)
+		return error;
+
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
 	if (error)
 		goto Resume_console;
 
-	error = platform_prepare(platform_mode);
+	error = platform_pre_snapshot(platform_mode);
 	if (error)
 		goto Resume_devices;
 
Index: linux-2.6.22-git5/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.22-git5.orig/drivers/acpi/sleep/main.c
+++ linux-2.6.22-git5/drivers/acpi/sleep/main.c
@@ -199,6 +199,12 @@ static struct platform_suspend_ops acpi_
 };
 
 #ifdef CONFIG_SOFTWARE_SUSPEND
+static int acpi_hibernation_start(void)
+{
+	acpi_target_sleep_state = ACPI_STATE_S4;
+	return 0;
+}
+
 static int acpi_hibernation_prepare(void)
 {
 	return acpi_sleep_prepare(ACPI_STATE_S4);
@@ -227,6 +233,8 @@ static void acpi_hibernation_finish(void
 
 	/* reset firmware waking vector */
 	acpi_set_firmware_waking_vector((acpi_physical_address) 0);
+
+	acpi_target_sleep_state = ACPI_STATE_S0;
 }
 
 static int acpi_hibernation_pre_restore(void)
@@ -244,9 +252,11 @@ static void acpi_hibernation_restore_cle
 }
 
 static struct hibernation_ops acpi_hibernation_ops = {
+	.start = acpi_hibernation_start,
+	.pre_snapshot = acpi_hibernation_prepare,
+	.finish = acpi_hibernation_finish,
 	.prepare = acpi_hibernation_prepare,
 	.enter = acpi_hibernation_enter,
-	.finish = acpi_hibernation_finish,
 	.pre_restore = acpi_hibernation_pre_restore,
 	.restore_cleanup = acpi_hibernation_restore_cleanup,
 };

