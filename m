Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbYKMDJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbYKMDJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 22:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751006AbYKMDJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 22:09:32 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:36745 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYKMDJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 22:09:31 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org
Cc: Felipe Balbi <felipe.balbi@nokia.com>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: [PATCH] led: simplify led_trigger_register_simple
Date: Thu, 13 Nov 2008 05:09:13 +0200
Message-Id: <1226545753-6640-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.0.4.617.g2baf1
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

We can make led_trigger_register_simple by returning a
struct led_trigger *, instead of passing a struct led_trigger **
as a parameter and changing it inside the function.

Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
Note that I could only test ide, power_supply and mmc changes with my laptop.
The other changes weren't tested.

 drivers/leds/led-triggers.c         |   25 ++++++++++++++---------
 drivers/leds/ledtrig-ide-disk.c     |    6 ++++-
 drivers/mmc/core/host.c             |    4 ++-
 drivers/mtd/nand/nand_base.c        |    5 +++-
 drivers/power/power_supply_leds.c   |   36 ++++++++++++++++++++++++++++------
 drivers/staging/at76_usb/at76_usb.c |    6 ++++-
 include/linux/leds.h                |    5 +--
 7 files changed, 63 insertions(+), 24 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index f910eaf..24e5851 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -13,6 +13,7 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
@@ -222,24 +223,28 @@ void led_trigger_event(struct led_trigger *trigger,
 }
 EXPORT_SYMBOL_GPL(led_trigger_event);
 
-void led_trigger_register_simple(const char *name, struct led_trigger **tp)
+struct led_trigger *led_trigger_register_simple(const char *name)
 {
 	struct led_trigger *trigger;
 	int err;
 
 	trigger = kzalloc(sizeof(struct led_trigger), GFP_KERNEL);
-
-	if (trigger) {
-		trigger->name = name;
-		err = led_trigger_register(trigger);
-		if (err < 0)
-			printk(KERN_WARNING "LED trigger %s failed to register"
-				" (%d)\n", name, err);
-	} else
+	if (!trigger) {
 		printk(KERN_WARNING "LED trigger %s failed to register"
 			" (no memory)\n", name);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	trigger->name = name;
+	err = led_trigger_register(trigger);
+	if (err < 0) {
+		printk(KERN_WARNING "LED trigger %s failed to register"
+				" (%d)\n", name, err);
+		kfree(trigger);
+		return ERR_PTR(err);
+	}
 
-	*tp = trigger;
+	return trigger;
 }
 EXPORT_SYMBOL_GPL(led_trigger_register_simple);
 
diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
index 883a577..e62e080 100644
--- a/drivers/leds/ledtrig-ide-disk.c
+++ b/drivers/leds/ledtrig-ide-disk.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/leds.h>
@@ -46,7 +47,10 @@ static void ledtrig_ide_timerfunc(unsigned long data)
 
 static int __init ledtrig_ide_init(void)
 {
-	led_trigger_register_simple("ide-disk", &ledtrig_ide);
+	ledtrig_ide = led_trigger_register_simple("ide-disk");
+	if (IS_ERR(ledtrig_ide))
+		return PTR_ERR(ledtrig_ide);
+
 	return 0;
 }
 
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 5e945e6..07247b7 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -120,7 +120,9 @@ int mmc_add_host(struct mmc_host *host)
 	WARN_ON((host->caps & MMC_CAP_SDIO_IRQ) &&
 		!host->ops->enable_sdio_irq);
 
-	led_trigger_register_simple(dev_name(&host->class_dev), &host->led);
+	host->led = led_trigger_register_simple(dev_name(&host->class_dev));
+	if (IS_ERR(host->led))
+		return PTR_ERR(host->led);
 
 	err = device_add(&host->class_dev);
 	if (err)
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 0a9c9cd..b170a62 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2781,7 +2781,10 @@ EXPORT_SYMBOL_GPL(nand_release);
 
 static int __init nand_base_init(void)
 {
-	led_trigger_register_simple("nand-disk", &nand_led_trigger);
+	nand_led_trigger = led_trigger_register_simple("nand-disk");
+	if (IS_ERR(nand_led_trigger))
+		return PTR_ERR(nand_led_trigger);
+
 	return 0;
 }
 
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 2dece40..d1a857c 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/err.h>
 #include <linux/power_supply.h>
 
 #include "power_supply.h"
@@ -63,15 +64,32 @@ static int power_supply_create_bat_triggers(struct power_supply *psy)
 	if (!psy->full_trig_name)
 		goto full_failed;
 
-	led_trigger_register_simple(psy->charging_full_trig_name,
-				    &psy->charging_full_trig);
-	led_trigger_register_simple(psy->charging_trig_name,
-				    &psy->charging_trig);
-	led_trigger_register_simple(psy->full_trig_name,
-				    &psy->full_trig);
+	psy->charging_full_trig = led_trigger_register_simple(
+			psy->charging_full_trig_name);
+	if (IS_ERR(psy->charging_full_trig)) {
+		rc = PTR_ERR(psy->charging_full_trig);
+		goto full_failed;
+	}
+
+	psy->charging_trig = led_trigger_register_simple(
+			psy->charging_trig_name);
+	if (IS_ERR(psy->charging_trig)) {
+		rc = PTR_ERR(psy->charging_full_trig);
+		goto charging_trig_failed;
+	}
+
+	psy->full_trig = led_trigger_register_simple(psy->full_trig_name);
+	if (IS_ERR(psy->full_trig)) {
+		rc = PTR_ERR(psy->charging_full_trig);
+		goto full_trig_failed;
+	}
 
 	goto success;
 
+full_trig_failed:
+	led_trigger_unregister_simple(psy->charging_trig);
+charging_trig_failed:
+	led_trigger_unregister_simple(psy->charging_full_trig);
 full_failed:
 	kfree(psy->charging_trig_name);
 charging_failed:
@@ -117,7 +135,11 @@ static int power_supply_create_gen_triggers(struct power_supply *psy)
 	if (!psy->online_trig_name)
 		goto online_failed;
 
-	led_trigger_register_simple(psy->online_trig_name, &psy->online_trig);
+	psy->online_trig = led_trigger_register_simple(psy->online_trig_name);
+	if (IS_ERR(psy->online_trig)) {
+		rc = PTR_ERR(psy->online_trig);
+		goto online_failed;
+	}
 
 	goto success;
 
diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 174e2be..e769aae 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/module.h>
@@ -5528,7 +5529,10 @@ static int __init at76_mod_init(void)
 		printk(KERN_ERR DRIVER_NAME
 		       ": usb_register failed (status %d)\n", result);
 
-	led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
+	ledtrig_tx = led_trigger_register_simple("at76_usb-tx");
+	if (IS_ERR(ledtrig_tx))
+		result = PTR_ERR(ledtrig_tx);
+
 	return result;
 }
 
diff --git a/include/linux/leds.h b/include/linux/leds.h
index d3a73f5..b796ec0 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -94,8 +94,7 @@ extern void led_trigger_unregister(struct led_trigger *trigger);
 /* Registration functions for simple triggers */
 #define DEFINE_LED_TRIGGER(x)		static struct led_trigger *x;
 #define DEFINE_LED_TRIGGER_GLOBAL(x)	struct led_trigger *x;
-extern void led_trigger_register_simple(const char *name,
-				struct led_trigger **trigger);
+extern struct led_trigger *led_trigger_register_simple(const char *name);
 extern void led_trigger_unregister_simple(struct led_trigger *trigger);
 extern void led_trigger_event(struct led_trigger *trigger,
 				enum led_brightness event);
@@ -105,7 +104,7 @@ extern void led_trigger_event(struct led_trigger *trigger,
 /* Triggers aren't active - null macros */
 #define DEFINE_LED_TRIGGER(x)
 #define DEFINE_LED_TRIGGER_GLOBAL(x)
-#define led_trigger_register_simple(x, y) do {} while(0)
+#define led_trigger_register_simple(x) NULL
 #define led_trigger_unregister_simple(x) do {} while(0)
 #define led_trigger_event(x, y) do {} while(0)
 
-- 
1.6.0.4.617.g2baf1

