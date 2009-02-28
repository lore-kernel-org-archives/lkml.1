Return-Path: <linux-kernel-owner+w=401wt.eu-S1753574AbZB1MFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbZB1MFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 07:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbZB1MFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 07:05:25 -0500
Received: from ns1.siteground211.com ([209.62.36.12]:47497 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbZB1MFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 07:05:24 -0500
From: Felipe Balbi <me@felipebalbi.com>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: soni.trilok@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Samuel Ortiz <sameo@openedhand.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [PATCH] mfd: twl4030: add twl4030-pwrbutton as our child
Date: Sat, 28 Feb 2009 14:05:10 +0200
Message-Id: <1235822710-2758-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
In-Reply-To: <5d5443650902272151g7595deb4gc91145a4c6938b74@mail.gmail.com>
References: <5d5443650902272151g7595deb4gc91145a4c6938b74@mail.gmail.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <felipe.balbi@nokia.com>

Make that twl4030-pwrbutton.c driver probe with current
child creation api for twl4030.

Cc: Samuel Ortiz <sameo@openedhand.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/input/misc/twl4030-pwrbutton.c |   10 ++++------
 drivers/mfd/twl4030-core.c             |   13 +++++++++++++
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
index ba9cbdc..85a46d9 100644
--- a/drivers/input/misc/twl4030-pwrbutton.c
+++ b/drivers/input/misc/twl4030-pwrbutton.c
@@ -1,7 +1,5 @@
 /**
- * drivers/i2c/chips/twl4030-pwrbutton.c
- *
- * Driver for sending triton2 power button event to input-layer
+ * twl4030-pwrbutton.c - TWL4030 Power Button Input Driver
  *
  * Copyright (C) 2008-2009 Nokia Corporation
  *
@@ -55,6 +53,7 @@ static irqreturn_t powerbutton_irq(int irq, void *dev_id)
 	if (!err)  {
 		input_report_key(powerbutton_dev, KEY_POWER,
 				 value & PWR_PWRON_IRQ);
+		input_sync(powerbutton_dev);
 	} else {
 		dev_err(dbg_dev, "twl4030: i2c error %d while reading TWL4030"
 			" PM_MASTER STS_HW_CONDITIONS register\n", err);
@@ -104,7 +103,7 @@ static int __devinit twl4030_pwrbutton_probe(struct platform_device *pdev)
 free_input_dev:
 	input_free_device(powerbutton_dev);
 free_irq_and_out:
-	free_irq(TWL4030_PWRIRQ_PWRBTN, NULL);
+	free_irq(irq, NULL);
 out:
 	return err;
 }
@@ -115,14 +114,13 @@ static int __devexit twl4030_pwrbutton_remove(struct platform_device *pdev)
 
 	free_irq(irq, NULL);
 	input_unregister_device(powerbutton_dev);
-	input_free_device(powerbutton_dev);
 
 	return 0;
 }
 
 struct platform_driver twl4030_pwrbutton_driver = {
 	.probe		= twl4030_pwrbutton_probe,
-	.remove		= twl4030_pwrbutton_remove,
+	.remove		= __devexit_p(twl4030_pwrbutton_remove),
 	.driver		= {
 		.name	= "twl4030-pwrbutton",
 		.owner	= THIS_MODULE,
diff --git a/drivers/mfd/twl4030-core.c b/drivers/mfd/twl4030-core.c
index 68826f1..c86bc3b 100644
--- a/drivers/mfd/twl4030-core.c
+++ b/drivers/mfd/twl4030-core.c
@@ -101,6 +101,12 @@
 #define twl_has_usb()	false
 #endif
 
+#if defined(CONFIG_INPUT_TWL4030_PWRBUTTON) \
+	|| defined(CONFIG_INPUT_TWL4030_PWBUTTON_MODULE)
+#define twl_has_pwrbutton()	true
+#else
+#define twl_has_pwrbutton()	false
+#endif
 
 /* Triton Core internal information (BEGIN) */
 
@@ -526,6 +532,13 @@ add_children(struct twl4030_platform_data *pdata, unsigned long features)
 		usb_transceiver = child;
 	}
 
+	if (twl_has_pwrbutton()) {
+		child = add_child(1, "twl4030_pwrbutton",
+				NULL, 0, true, pdata->irq_base + 8 + 0, 0);
+		if (IS_ERR(child))
+			return PTR_ERR(child);
+	}
+
 	if (twl_has_regulator()) {
 		/*
 		child = add_regulator(TWL4030_REG_VPLL1, pdata->vpll1);
-- 
1.6.2.rc0.61.g5cd12

