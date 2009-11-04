Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbZKDVZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbZKDVZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758176AbZKDVZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:25:32 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:61407 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757387AbZKDVZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:25:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PJdsMO1QjQ0p0Ev1IZE8jFv/Zs9xCZZf6QOnteG821BBBtMqHZXigPprzBGze/f3Fe
         +MKi/VyM1YXmxgipMHOv4dz26z5qPph4tXgBRWpoC7reCWdqruZjipEvs/9xEh1KPLd9
         lRpM5mj9kuGuKCGplrVbtnUKNSdz3EYu+79Xs=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Sean McNeil <sean@mcneil.com>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 1/6] power: pcf50633: add ac power supply class to the charger
Date: Thu,  5 Nov 2009 00:24:54 +0300
Message-Id: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sean McNeil <sean@mcneil.com>

This adds an appropriate ac power_supply class and shows usb only when
at the appropriate current limit.

Signed-off-by: Sean McNeil <sean@mcneil.com>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/power/pcf50633-charger.c |   46 +++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/power/pcf50633-charger.c b/drivers/power/pcf50633-charger.c
index e8b278f..48e92c0 100644
--- a/drivers/power/pcf50633-charger.c
+++ b/drivers/power/pcf50633-charger.c
@@ -36,6 +36,7 @@ struct pcf50633_mbc {
 
 	struct power_supply usb;
 	struct power_supply adapter;
+	struct power_supply ac;
 
 	struct delayed_work charging_restart_work;
 };
@@ -237,6 +238,7 @@ pcf50633_mbc_irq_handler(int irq, void *data)
 	else if (irq == PCF50633_IRQ_USBLIMOFF)
 		mbc->usb_active = 1;
 
+	power_supply_changed(&mbc->ac);
 	power_supply_changed(&mbc->usb);
 	power_supply_changed(&mbc->adapter);
 
@@ -269,10 +271,34 @@ static int usb_get_property(struct power_supply *psy,
 {
 	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, usb);
 	int ret = 0;
+	u8 usblim = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCC7) &
+						PCF50633_MBCC7_USB_MASK;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = mbc->usb_online &&
+				(usblim <= PCF50633_MBCC7_USB_500mA);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static int ac_get_property(struct power_supply *psy,
+			enum power_supply_property psp,
+			union power_supply_propval *val)
+{
+	struct pcf50633_mbc *mbc = container_of(psy, struct pcf50633_mbc, ac);
+	int ret = 0;
+	u8 usblim = pcf50633_reg_read(mbc->pcf, PCF50633_REG_MBCC7) &
+						PCF50633_MBCC7_USB_MASK;
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_ONLINE:
-		val->intval = mbc->usb_online;
+		val->intval = mbc->usb_online &&
+				(usblim == PCF50633_MBCC7_USB_1000mA);
 		break;
 	default:
 		ret = -EINVAL;
@@ -337,6 +363,14 @@ static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
 	mbc->usb.supplied_to		= mbc->pcf->pdata->batteries;
 	mbc->usb.num_supplicants	= mbc->pcf->pdata->num_batteries;
 
+	mbc->ac.name			= "ac";
+	mbc->ac.type			= POWER_SUPPLY_TYPE_MAINS;
+	mbc->ac.properties		= power_props;
+	mbc->ac.num_properties		= ARRAY_SIZE(power_props);
+	mbc->ac.get_property		= ac_get_property;
+	mbc->ac.supplied_to		= mbc->pcf->pdata->batteries;
+	mbc->ac.num_supplicants		= mbc->pcf->pdata->num_batteries;
+
 	ret = power_supply_register(&pdev->dev, &mbc->adapter);
 	if (ret) {
 		dev_err(mbc->pcf->dev, "failed to register adapter\n");
@@ -352,6 +386,15 @@ static int __devinit pcf50633_mbc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	ret = power_supply_register(&pdev->dev, &mbc->ac);
+	if (ret) {
+		dev_err(mbc->pcf->dev, "failed to register ac\n");
+		power_supply_unregister(&mbc->adapter);
+		power_supply_unregister(&mbc->usb);
+		kfree(mbc);
+		return ret;
+	}
+
 	INIT_DELAYED_WORK(&mbc->charging_restart_work,
 				pcf50633_mbc_charging_restart);
 
@@ -379,6 +422,7 @@ static int __devexit pcf50633_mbc_remove(struct platform_device *pdev)
 
 	power_supply_unregister(&mbc->usb);
 	power_supply_unregister(&mbc->adapter);
+	power_supply_unregister(&mbc->ac);
 
 	cancel_delayed_work_sync(&mbc->charging_restart_work);
 
-- 
1.6.4.4

