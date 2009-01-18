Return-Path: <linux-kernel-owner+w=401wt.eu-S934633AbZARQqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934633AbZARQqJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933813AbZARQkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:40:49 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:46613 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934183AbZARQkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:40:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=MuztJbgz8sVwRNdOdq1Br6wpMImyElMTx78WuvYsaToK+yRgzi4Mt/P/6gcqvw1Z3v
         q9ej5Qfqe5bMGohzX4ZVQA7llTnXQad3CrI31YVlZbUmydiQMo6/0ZGBf6MCRcXgdWCU
         nGEqb0dKvIEWaZ65HI9tV3bJJNW9Q2FGEkETk=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbou@mail.ru>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [RFC] power: add optional OTG transceiver and voltage regulator support to pda_power
Date: Sun, 18 Jan 2009 17:40:27 +0100
Message-Id: <1232296827-16471-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows machines to use an OTG transceiver driver instead of
supplying a custom is_usb_online callback to check USB power.
Also, in the case that the OTG transceiver handles charger control when
connected to USB, a regulator named "ac_draw" can be supplied instead of
the custom set_charge callback to control the charger when connected to AC.

The check for (transceiver->state == OTG_STATE_B_PERIPHERAL) in
otg_is_usb_online is probably too simple, I'm just using this with a peripheral
only device and gpio_vbus + bq24022. I'm not sure which other OTG states
can supply power.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/power/pda_power.c |   89 +++++++++++++++++++++++++++++++++++++++------
 include/linux/pda_power.h |    2 +
 2 files changed, 79 insertions(+), 12 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index b56a704..e4c5a50 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -12,11 +12,14 @@
 
 #include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/err.h>
 #include <linux/interrupt.h>
 #include <linux/power_supply.h>
 #include <linux/pda_power.h>
+#include <linux/regulator/consumer.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
+#include <linux/usb/otg.h>
 
 static inline unsigned int get_irq_flags(struct resource *res)
 {
@@ -35,6 +38,11 @@ static struct timer_list supply_timer;
 static struct timer_list polling_timer;
 static int polling;
 
+#ifdef CONFIG_USB_OTG_UTILS
+static struct otg_transceiver *transceiver;
+#endif
+static struct regulator *ac_draw;
+
 enum {
 	PDA_PSY_OFFLINE = 0,
 	PDA_PSY_ONLINE = 1,
@@ -104,18 +112,35 @@ static void update_status(void)
 
 static void update_charger(void)
 {
-	if (!pdata->set_charge)
-		return;
-
-	if (new_ac_status > 0) {
-		dev_dbg(dev, "charger on (AC)\n");
-		pdata->set_charge(PDA_POWER_CHARGE_AC);
-	} else if (new_usb_status > 0) {
-		dev_dbg(dev, "charger on (USB)\n");
-		pdata->set_charge(PDA_POWER_CHARGE_USB);
-	} else {
-		dev_dbg(dev, "charger off\n");
-		pdata->set_charge(0);
+	static int regulator_enabled = 0;
+	int max_uA = pdata->ac_max_uA;
+
+	if (pdata->set_charge) {
+		if (new_ac_status > 0) {
+			dev_dbg(dev, "charger on (AC)\n");
+			pdata->set_charge(PDA_POWER_CHARGE_AC);
+		} else if (new_usb_status > 0) {
+			dev_dbg(dev, "charger on (USB)\n");
+			pdata->set_charge(PDA_POWER_CHARGE_USB);
+		} else {
+			dev_dbg(dev, "charger off\n");
+			pdata->set_charge(0);
+		}
+	} else if (ac_draw) {
+		if (new_ac_status > 0) {
+			regulator_set_current_limit(ac_draw, max_uA, max_uA);
+			if (!regulator_enabled) {
+				dev_dbg(dev, "charger on (AC)\n");
+				regulator_enable(ac_draw);
+				regulator_enabled = 1;
+			}
+		} else {
+			if (regulator_enabled) {
+				dev_dbg(dev, "charger off\n");
+				regulator_disable(ac_draw);
+				regulator_enabled = 0;
+			}
+		}
 	}
 }
 
@@ -194,6 +219,13 @@ static void polling_timer_func(unsigned long unused)
 		  jiffies + msecs_to_jiffies(pdata->polling_interval));
 }
 
+#ifdef CONFIG_USB_OTG_UTILS
+static int otg_is_usb_online(void)
+{
+	return (transceiver->state == OTG_STATE_B_PERIPHERAL);
+}
+#endif
+
 static int pda_power_probe(struct platform_device *pdev)
 {
 	int ret = 0;
@@ -227,6 +259,9 @@ static int pda_power_probe(struct platform_device *pdev)
 	if (!pdata->polling_interval)
 		pdata->polling_interval = 2000;
 
+	if (!pdata->ac_max_uA)
+		pdata->ac_max_uA = 500000;
+
 	setup_timer(&charger_timer, charger_timer_func, 0);
 	setup_timer(&supply_timer, supply_timer_func, 0);
 
@@ -240,6 +275,13 @@ static int pda_power_probe(struct platform_device *pdev)
 		pda_psy_usb.num_supplicants = pdata->num_supplicants;
 	}
 
+	ac_draw = regulator_get(dev, "ac_draw");
+	if (IS_ERR(ac_draw)) {
+		dev_dbg(dev, "couldn't get ac_draw regulator\n");
+		ac_draw = NULL;
+		ret = PTR_ERR(ac_draw);
+	}
+
 	if (pdata->is_ac_online) {
 		ret = power_supply_register(&pdev->dev, &pda_psy_ac);
 		if (ret) {
@@ -261,6 +303,13 @@ static int pda_power_probe(struct platform_device *pdev)
 		}
 	}
 
+#ifdef CONFIG_USB_OTG_UTILS
+	transceiver = otg_get_transceiver();
+	if (transceiver && !pdata->is_usb_online) {
+		pdata->is_usb_online = otg_is_usb_online;
+	}
+#endif
+
 	if (pdata->is_usb_online) {
 		ret = power_supply_register(&pdev->dev, &pda_psy_usb);
 		if (ret) {
@@ -300,10 +349,18 @@ usb_irq_failed:
 usb_supply_failed:
 	if (pdata->is_ac_online && ac_irq)
 		free_irq(ac_irq->start, &pda_psy_ac);
+#ifdef CONFIG_USB_OTG_UTILS
+	if (transceiver)
+		otg_put_transceiver(transceiver);
+#endif
 ac_irq_failed:
 	if (pdata->is_ac_online)
 		power_supply_unregister(&pda_psy_ac);
 ac_supply_failed:
+	if (ac_draw) {
+		regulator_put(ac_draw);
+		ac_draw = NULL;
+	}
 	if (pdata->exit)
 		pdata->exit(dev);
 init_failed:
@@ -327,6 +384,14 @@ static int pda_power_remove(struct platform_device *pdev)
 		power_supply_unregister(&pda_psy_usb);
 	if (pdata->is_ac_online)
 		power_supply_unregister(&pda_psy_ac);
+#ifdef CONFIG_USB_OTG_UTILS
+	if (transceiver)
+		otg_put_transceiver(transceiver);
+#endif
+	if (ac_draw) {
+		regulator_put(ac_draw);
+		ac_draw = NULL;
+	}
 	if (pdata->exit)
 		pdata->exit(dev);
 
diff --git a/include/linux/pda_power.h b/include/linux/pda_power.h
index cb7d10f..d4cf7a2 100644
--- a/include/linux/pda_power.h
+++ b/include/linux/pda_power.h
@@ -31,6 +31,8 @@ struct pda_power_pdata {
 	unsigned int wait_for_status; /* msecs, default is 500 */
 	unsigned int wait_for_charger; /* msecs, default is 500 */
 	unsigned int polling_interval; /* msecs, default is 2000 */
+
+	unsigned long ac_max_uA; /* current to draw when on AC */
 };
 
 #endif /* __PDA_POWER_H__ */
-- 
1.5.6.5

