Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYKMTLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYKMTLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYKMTLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:11:00 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:55040 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbYKMTK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:10:59 -0500
Date: Thu, 13 Nov 2008 21:10:50 +0200
From: Felipe Balbi <me@felipebalbi.com>
To: Felipe Balbi <me@felipebalbi.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org,
       Felipe Balbi <felipe.balbi@nokia.com>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [PATCH] led: simplify led_trigger_register_simple
Message-ID: <20081113191046.GA25855@frodo>
Reply-To: me@felipebalbi.com
References: <1226545753-6640-1-git-send-email-me@felipebalbi.com> <1226579912.5402.21.camel@dax.rpnet.com> <20081113181407.GC17166@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081113181407.GC17166@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2008 at 08:14:16PM +0200, Felipe Balbi wrote:
> On Thu, Nov 13, 2008 at 12:38:32PM +0000, Richard Purdie wrote:
> > The simple triggers were designed to cause minimum interference to the
> > usually external subsystem code they were added into. As an example this
> > meant things like errors were just handled gracefully with a printk
> > warning and did not take down the whole subsystem. I therefore don't
> > regard this patch as a simplification, more a complication.
> 
> That's a matter of changing the return ERR_PTR(err); back to a printk.

And here you are. I still think we should at least kfree(trigger) in
case of error, though.

======= cut here ===========

>From 4a96a53109f1edc3277ffb2d22641330930e60cd Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@nokia.com>
Date: Thu, 13 Nov 2008 03:28:22 +0200
Subject: [PATCH] led: simplify led_trigger_register_simple

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
 drivers/leds/led-triggers.c         |    4 ++--
 drivers/leds/ledtrig-ide-disk.c     |    2 +-
 drivers/mmc/core/host.c             |    2 +-
 drivers/mtd/nand/nand_base.c        |    2 +-
 drivers/power/power_supply_leds.c   |   13 ++++++-------
 drivers/staging/at76_usb/at76_usb.c |    2 +-
 include/linux/leds.h                |    5 ++---
 7 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
index f910eaf..4304278 100644
--- a/drivers/leds/led-triggers.c
+++ b/drivers/leds/led-triggers.c
@@ -222,7 +222,7 @@ void led_trigger_event(struct led_trigger *trigger,
 }
 EXPORT_SYMBOL_GPL(led_trigger_event);
 
-void led_trigger_register_simple(const char *name, struct led_trigger **tp)
+struct led_trigger *led_trigger_register_simple(const char *name)
 {
 	struct led_trigger *trigger;
 	int err;
@@ -239,7 +239,7 @@ void led_trigger_register_simple(const char *name, struct led_trigger **tp)
 		printk(KERN_WARNING "LED trigger %s failed to register"
 			" (no memory)\n", name);
 
-	*tp = trigger;
+	return trigger;
 }
 EXPORT_SYMBOL_GPL(led_trigger_register_simple);
 
diff --git a/drivers/leds/ledtrig-ide-disk.c b/drivers/leds/ledtrig-ide-disk.c
index 883a577..750e166 100644
--- a/drivers/leds/ledtrig-ide-disk.c
+++ b/drivers/leds/ledtrig-ide-disk.c
@@ -46,7 +46,7 @@ static void ledtrig_ide_timerfunc(unsigned long data)
 
 static int __init ledtrig_ide_init(void)
 {
-	led_trigger_register_simple("ide-disk", &ledtrig_ide);
+	ledtrig_ide = led_trigger_register_simple("ide-disk");
 	return 0;
 }
 
diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
index 5e945e6..8b337de 100644
--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -120,7 +120,7 @@ int mmc_add_host(struct mmc_host *host)
 	WARN_ON((host->caps & MMC_CAP_SDIO_IRQ) &&
 		!host->ops->enable_sdio_irq);
 
-	led_trigger_register_simple(dev_name(&host->class_dev), &host->led);
+	host->led = led_trigger_register_simple(dev_name(&host->class_dev));
 
 	err = device_add(&host->class_dev);
 	if (err)
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 0a9c9cd..9c5f0e2 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -2781,7 +2781,7 @@ EXPORT_SYMBOL_GPL(nand_release);
 
 static int __init nand_base_init(void)
 {
-	led_trigger_register_simple("nand-disk", &nand_led_trigger);
+	nand_led_trigger = led_trigger_register_simple("nand-disk");
 	return 0;
 }
 
diff --git a/drivers/power/power_supply_leds.c b/drivers/power/power_supply_leds.c
index 2dece40..da03990 100644
--- a/drivers/power/power_supply_leds.c
+++ b/drivers/power/power_supply_leds.c
@@ -63,12 +63,11 @@ static int power_supply_create_bat_triggers(struct power_supply *psy)
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
+	psy->charging_trig = led_trigger_register_simple(
+			psy->charging_trig_name);
+	psy->full_trig = led_trigger_register_simple(psy->full_trig_name);
 
 	goto success;
 
@@ -117,7 +116,7 @@ static int power_supply_create_gen_triggers(struct power_supply *psy)
 	if (!psy->online_trig_name)
 		goto online_failed;
 
-	led_trigger_register_simple(psy->online_trig_name, &psy->online_trig);
+	psy->online_trig = led_trigger_register_simple(psy->online_trig_name);
 
 	goto success;
 
diff --git a/drivers/staging/at76_usb/at76_usb.c b/drivers/staging/at76_usb/at76_usb.c
index 174e2be..ae6dc6e 100644
--- a/drivers/staging/at76_usb/at76_usb.c
+++ b/drivers/staging/at76_usb/at76_usb.c
@@ -5528,7 +5528,7 @@ static int __init at76_mod_init(void)
 		printk(KERN_ERR DRIVER_NAME
 		       ": usb_register failed (status %d)\n", result);
 
-	led_trigger_register_simple("at76_usb-tx", &ledtrig_tx);
+	ledtrig_tx = led_trigger_register_simple("at76_usb-tx");
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

-- 
balbi
