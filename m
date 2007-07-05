Return-Path: <linux-kernel-owner+w=401wt.eu-S1760182AbXGETNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182AbXGETNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760676AbXGETNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:13:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760306AbXGETNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:13:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 2/2] PM: Introduce pm_power_off_prepare
Date: Thu, 5 Jul 2007 21:20:07 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
References: <200707052112.30548.rjw@sisk.pl>
In-Reply-To: <200707052112.30548.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707052120.08177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Introduce the pm_power_off_prepare() callback that can be registered by the
interested platforms in analogy with pm_idle() and pm_power_off(), used for
preparing the system to power off (needed by ACPI).

This allows us to drop acpi_sysclass and device_acpi that are only defined in
order to register the ACPI power off preparation callback, which is needed by
pm_power_off() registered in a much different way.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/acpi/sleep/poweroff.c |   38 +++++++++-----------------------------
 include/linux/pm.h            |    1 +
 kernel/sys.c                  |    9 +++++++++
 3 files changed, 19 insertions(+), 29 deletions(-)

Index: linux-2.6.22-rc6-mm1/include/linux/pm.h
===================================================================
--- linux-2.6.22-rc6-mm1.orig/include/linux/pm.h
+++ linux-2.6.22-rc6-mm1/include/linux/pm.h
@@ -101,6 +101,7 @@ struct pm_dev
  */
 extern void (*pm_idle)(void);
 extern void (*pm_power_off)(void);
+extern void (*pm_power_off_prepare)(void);
 
 typedef int __bitwise suspend_state_t;
 
Index: linux-2.6.22-rc6-mm1/kernel/sys.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/kernel/sys.c
+++ linux-2.6.22-rc6-mm1/kernel/sys.c
@@ -100,6 +100,13 @@ struct pid *cad_pid;
 EXPORT_SYMBOL(cad_pid);
 
 /*
+ * If set, this is used for preparing the system to power off.
+ */
+
+void (*pm_power_off_prepare)(void);
+EXPORT_SYMBOL(pm_power_off_prepare);
+
+/*
  *	Notifier list for kernel code which wants to be called
  *	at shutdown. This is used to stop any idling DMA operations
  *	and the like. 
@@ -867,6 +874,8 @@ EXPORT_SYMBOL_GPL(kernel_halt);
 void kernel_power_off(void)
 {
 	kernel_shutdown_prepare(SYSTEM_POWER_OFF);
+	if (pm_power_off_prepare)
+		pm_power_off_prepare();
 	printk(KERN_EMERG "Power down.\n");
 	machine_power_off();
 }
Index: linux-2.6.22-rc6-mm1/drivers/acpi/sleep/poweroff.c
===================================================================
--- linux-2.6.22-rc6-mm1.orig/drivers/acpi/sleep/poweroff.c
+++ linux-2.6.22-rc6-mm1/drivers/acpi/sleep/poweroff.c
@@ -39,7 +39,13 @@ int acpi_sleep_prepare(u32 acpi_state)
 
 #ifdef CONFIG_PM
 
-void acpi_power_off(void)
+static void acpi_power_off_prepare(void)
+{
+	/* Prepare to power off the system */
+	acpi_sleep_prepare(ACPI_STATE_S5);
+}
+
+static void acpi_power_off(void)
 {
 	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
 	printk("%s called\n", __FUNCTION__);
@@ -48,27 +54,6 @@ void acpi_power_off(void)
 	acpi_enter_sleep_state(ACPI_STATE_S5);
 }
 
-static int acpi_shutdown(struct sys_device *x)
-{
-	switch (system_state) {
-	case SYSTEM_POWER_OFF:
-		/* Prepare to power off the system */
-		return acpi_sleep_prepare(ACPI_STATE_S5);
-	default:
-		return 0;
-	}
-}
-
-static struct sysdev_class acpi_sysclass = {
-	set_kset_name("acpi"),
-	.shutdown = acpi_shutdown
-};
-
-static struct sys_device device_acpi = {
-	.id = 0,
-	.cls = &acpi_sysclass,
-};
-
 static int acpi_poweroff_init(void)
 {
 	if (!acpi_disabled) {
@@ -78,13 +63,8 @@ static int acpi_poweroff_init(void)
 		status =
 		    acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
-			int error;
-			error = sysdev_class_register(&acpi_sysclass);
-			if (!error)
-				error = sysdev_register(&device_acpi);
-			if (!error)
-				pm_power_off = acpi_power_off;
-			return error;
+			pm_power_off_prepare = acpi_power_off_prepare;
+			pm_power_off = acpi_power_off;
 		}
 	}
 	return 0;
