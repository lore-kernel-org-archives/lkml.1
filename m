Return-Path: <linux-kernel-owner+w=401wt.eu-S1761471AbZJMV7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761471AbZJMV7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 17:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761455AbZJMV7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 17:59:55 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44719 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761454AbZJMV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 17:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=QOZKHVlVpMIGXdEGq3DzlDIgw9EllnkrUq3FmQ68+7SXaN0oi1Qp3mCwTvUheTlmso
         dcz+wzrxY5SuC07nJ3zCbIMnb8l4WtU96ngfC6BGy0NwfAK7ntXjwG8hGbWpd6fq5Yq9
         oWL+y8IT9pOCQfNqSIasgrG74rLAb8V7S92cg=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Nelson Castillo <arhuaco@freaks-unidos.net>,
       Sean McNeil <sean@mcneil.com>, Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] power: pcf50633: add ac power supply class to the charger
Date: Wed, 14 Oct 2009 01:59:03 +0400
Message-Id: <1255471148-29047-1-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
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
1.6.0.6

