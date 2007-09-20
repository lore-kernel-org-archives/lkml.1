Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbXITRaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbXITRaQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757324AbXITRaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:30:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:64282 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbXITR36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:29:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=mKbUKvjpEmIwHUTyMFgWc1vo82u/9vribPumPaOQLUSyn76UAl89ODuuqu4MSuHdO3snBsAleHhjd7EJ+5DXkibhQgDs6ikAbpPs4iSwArE1nHXq5/2N+ymysWnz0V0K4vgpp7gZDLd6BaCxpwWQjJ9bFYkYLjkYo3PpMZ6A568=
Message-ID: <46F2AE16.9080803@gmail.com>
Date: Thu, 20 Sep 2007 21:29:58 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Maciek Rutecki <maciej.rutecki@gmail.com>
CC: Frans Pop <elendil@planet.nl>, Pavel Machek <pavel@ucw.cz>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6: S4 and S5 no longer listed as supported on Toshiba
 Satellite A40
References: <200709192014.08443.elendil@planet.nl> <20070920105312.GC12157@atrey.karlin.mff.cuni.cz> <200709201437.56431.elendil@planet.nl> <46F2A0E9.9000603@gmail.com>
In-Reply-To: <46F2A0E9.9000603@gmail.com>
X-Enigmail-Version: 0.95.3
Content-Type: multipart/mixed;
 boundary="------------080600040106000202020307"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080600040106000202020307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Please try this patch.

Regards,
Alex.

--------------080600040106000202020307
Content-Type: text/x-patch;
 name="consolidate_Sx_handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="consolidate_Sx_handling.patch"

ACPI: suspend: consolidate handling of Sx states.

From: Alexey Starikovskiy <astarikovskiy@suse.de>

Recent changes to sleep initialization in ACPI dropped reporting of supported Sx 
states above S3. Fix that and also move S5 init into same file as other Sx.
The only functional change is adding printk() for S4 and S5 cases.

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 drivers/acpi/sleep/Makefile   |    2 +
 drivers/acpi/sleep/main.c     |   53 ++++++++++++++++++++++++++---
 drivers/acpi/sleep/poweroff.c |   75 -----------------------------------------
 3 files changed, 49 insertions(+), 81 deletions(-)

diff --git a/drivers/acpi/sleep/Makefile b/drivers/acpi/sleep/Makefile
index 195a4f6..ba9bd40 100644
--- a/drivers/acpi/sleep/Makefile
+++ b/drivers/acpi/sleep/Makefile
@@ -1,4 +1,4 @@
-obj-y					:= poweroff.o wakeup.o
+obj-y					:= wakeup.o
 obj-$(CONFIG_ACPI_SLEEP)		+= main.o
 obj-$(CONFIG_ACPI_SLEEP)		+= proc.o
 
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index c52ade8..638172f 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -15,6 +15,9 @@
 #include <linux/dmi.h>
 #include <linux/device.h>
 #include <linux/suspend.h>
+
+#include <asm/io.h>
+
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include "sleep.h"
@@ -57,6 +60,27 @@ static int acpi_pm_set_target(suspend_state_t pm_state)
 	return error;
 }
 
+int acpi_sleep_prepare(u32 acpi_state)
+{
+#ifdef CONFIG_ACPI_SLEEP
+	/* do we have a wakeup address for S2 and S3? */
+	if (acpi_state == ACPI_STATE_S3) {
+		if (!acpi_wakeup_address) {
+			return -EFAULT;
+		}
+		acpi_set_firmware_waking_vector((acpi_physical_address)
+						virt_to_phys((void *)
+							     acpi_wakeup_address));
+
+	}
+	ACPI_FLUSH_CPU_CACHE();
+	acpi_enable_wakeup_device_prep(acpi_state);
+#endif
+	acpi_gpe_sleep_prepare(acpi_state);
+	acpi_enter_sleep_state_prep(acpi_state);
+	return 0;
+}
+
 /**
  *	acpi_pm_prepare - Do preliminary suspend work.
  *	@pm_state: ignored
@@ -350,6 +374,20 @@ int acpi_pm_device_sleep_state(struct device *dev, int wake, int *d_min_p)
 	return d_max;
 }
 
+static void acpi_power_off_prepare(void)
+{
+	/* Prepare to power off the system */
+	acpi_sleep_prepare(ACPI_STATE_S5);
+}
+
+static void acpi_power_off(void)
+{
+	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
+	printk("%s called\n", __FUNCTION__);
+	local_irq_disable();
+	acpi_enter_sleep_state(ACPI_STATE_S5);
+}
+
 int __init acpi_sleep_init(void)
 {
 	acpi_status status;
@@ -363,8 +401,8 @@ int __init acpi_sleep_init(void)
 	if (acpi_disabled)
 		return 0;
 
+printk(KERN_INFO PREFIX "(supports");
 #ifdef CONFIG_SUSPEND
-	printk(KERN_INFO PREFIX "(supports");
 	for (i = ACPI_STATE_S0; i < ACPI_STATE_S4; i++) {
 		status = acpi_get_sleep_type_data(i, &type_a, &type_b);
 		if (ACPI_SUCCESS(status)) {
@@ -372,7 +410,6 @@ int __init acpi_sleep_init(void)
 			printk(" S%d", i);
 		}
 	}
-	printk(")\n");
 
 	pm_set_ops(&acpi_pm_ops);
 #endif
@@ -382,10 +419,16 @@ int __init acpi_sleep_init(void)
 	if (ACPI_SUCCESS(status)) {
 		hibernation_set_ops(&acpi_hibernation_ops);
 		sleep_states[ACPI_STATE_S4] = 1;
+		printk(" S4");
 	}
-#else
-	sleep_states[ACPI_STATE_S4] = 0;
 #endif
-
+	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
+	if (ACPI_SUCCESS(status)) {
+		sleep_states[ACPI_STATE_S5] = 1;
+		printk(" S5");
+		pm_power_off_prepare = acpi_power_off_prepare;
+		pm_power_off = acpi_power_off;
+	}
+	printk(")\n");
 	return 0;
 }
diff --git a/drivers/acpi/sleep/poweroff.c b/drivers/acpi/sleep/poweroff.c
deleted file mode 100644
index 39e40d5..0000000
--- a/drivers/acpi/sleep/poweroff.c
+++ /dev/null
@@ -1,75 +0,0 @@
-/*
- * poweroff.c - ACPI handler for powering off the system.
- *
- * AKA S5, but it is independent of whether or not the kernel supports
- * any other sleep support in the system.
- *
- * Copyright (c) 2005 Alexey Starikovskiy <alexey.y.starikovskiy@intel.com>
- *
- * This file is released under the GPLv2.
- */
-
-#include <linux/pm.h>
-#include <linux/init.h>
-#include <acpi/acpi_bus.h>
-#include <linux/sysdev.h>
-#include <asm/io.h>
-#include "sleep.h"
-
-int acpi_sleep_prepare(u32 acpi_state)
-{
-#ifdef CONFIG_ACPI_SLEEP
-	/* do we have a wakeup address for S2 and S3? */
-	if (acpi_state == ACPI_STATE_S3) {
-		if (!acpi_wakeup_address) {
-			return -EFAULT;
-		}
-		acpi_set_firmware_waking_vector((acpi_physical_address)
-						virt_to_phys((void *)
-							     acpi_wakeup_address));
-
-	}
-	ACPI_FLUSH_CPU_CACHE();
-	acpi_enable_wakeup_device_prep(acpi_state);
-#endif
-	acpi_gpe_sleep_prepare(acpi_state);
-	acpi_enter_sleep_state_prep(acpi_state);
-	return 0;
-}
-
-#ifdef CONFIG_PM
-
-static void acpi_power_off_prepare(void)
-{
-	/* Prepare to power off the system */
-	acpi_sleep_prepare(ACPI_STATE_S5);
-}
-
-static void acpi_power_off(void)
-{
-	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
-	printk("%s called\n", __FUNCTION__);
-	local_irq_disable();
-	/* Some SMP machines only can poweroff in boot CPU */
-	acpi_enter_sleep_state(ACPI_STATE_S5);
-}
-
-static int acpi_poweroff_init(void)
-{
-	if (!acpi_disabled) {
-		u8 type_a, type_b;
-		acpi_status status;
-
-		status =
-		    acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
-		if (ACPI_SUCCESS(status)) {
-			pm_power_off_prepare = acpi_power_off_prepare;
-			pm_power_off = acpi_power_off;
-		}
-	}
-	return 0;
-}
-
-late_initcall(acpi_poweroff_init);
-
-#endif				/* CONFIG_PM */

--------------080600040106000202020307--
