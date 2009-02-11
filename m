Return-Path: <linux-kernel-owner+w=401wt.eu-S1755423AbZBKHH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755423AbZBKHH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 02:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbZBKHHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 02:07:09 -0500
Received: from harmaja.edelkey.net ([213.138.147.141]:51275 "EHLO
	harmaja.edelkey.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbZBKHHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 02:07:08 -0500
From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
To: david-b@pacbell.net
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
       jouni.hogander@nokia.com, broonie@sirena.org.uk,
       Kalle Jokiniemi <kalle.jokiniemi@digia.com>
Subject: [PATCH 1/2] TWL: USB: disable VUSB regulators when cable unplugged
Date: Wed, 11 Feb 2009 09:06:41 +0200
Message-Id: <1234336002-26372-2-git-send-email-kalle.jokiniemi@digia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1234336002-26372-1-git-send-email-kalle.jokiniemi@digia.com>
References: <>
 <1234336002-26372-1-git-send-email-kalle.jokiniemi@digia.com>
X-OriginalArrivalTime: 11 Feb 2009 07:06:45.0019 (UTC) FILETIME=[4C5ED6B0:01C98C17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jouni Hogander <jouni.hogander@nokia.com>

This patch disables USB regulators VUSB1V5, VUSB1V8, and VUSB3V1
when the USB cable is unplugged to reduce power consumption.

Signed-off-by: Jouni Hogander <jouni.hogander@nokia.com>
Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
---
 drivers/usb/otg/twl4030-usb.c |   45 +++++++++++++++++++++++++++++++++++-----
 1 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
index 416e441..29df421 100644
--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -34,6 +34,8 @@
 #include <linux/delay.h>
 #include <linux/usb/otg.h>
 #include <linux/i2c/twl4030.h>
+#include <linux/regulator/consumer.h>
+#include <linux/err.h>
 
 
 /* Register defines */
@@ -246,6 +248,11 @@ struct twl4030_usb {
 	struct otg_transceiver	otg;
 	struct device		*dev;
 
+	/* TWL4030 internal USB regulator supplies */
+	struct regulator	*usb1v5;
+	struct regulator	*usb1v8;
+	struct regulator	*usb3v1;
+
 	/* for vbus reporting with irqs disabled */
 	spinlock_t		lock;
 
@@ -434,6 +441,12 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 
 	pwr = twl4030_usb_read(twl, PHY_PWR_CTRL);
 	if (on) {
+		if (twl->usb1v5)
+			regulator_enable(twl->usb1v5);
+		if (twl->usb1v8)
+			regulator_enable(twl->usb1v8);
+		if (twl->usb3v1)
+			regulator_enable(twl->usb3v1);
 		pwr &= ~PHY_PWR_PHYPWD;
 		WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
 		twl4030_usb_write(twl, PHY_CLK_CTRL,
@@ -443,6 +456,12 @@ static void twl4030_phy_power(struct twl4030_usb *twl, int on)
 	} else  {
 		pwr |= PHY_PWR_PHYPWD;
 		WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
+		if (twl->usb1v5)
+			regulator_disable(twl->usb1v5);
+		if (twl->usb1v8)
+			regulator_disable(twl->usb1v8);
+		if (twl->usb3v1)
+			regulator_disable(twl->usb3v1);
 	}
 }
 
@@ -470,6 +489,8 @@ static void twl4030_phy_resume(struct twl4030_usb *twl)
 
 static void twl4030_usb_ldo_init(struct twl4030_usb *twl)
 {
+	struct regulator	*reg;
+
 	/* Enable writing to power configuration registers */
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0xC0, PROTECT_KEY);
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_MASTER, 0x0C, PROTECT_KEY);
@@ -480,16 +501,25 @@ static void twl4030_usb_ldo_init(struct twl4030_usb *twl)
 	/* input to VUSB3V1 LDO is from VBAT, not VBUS */
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
 
-	/* turn on 3.1V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x20, VUSB3V1_DEV_GRP);
+	/* Initialize 3.1V regulator */
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
+	reg = regulator_get(twl->dev, "usb3v1");
+	if (!IS_ERR(reg))
+		twl->usb3v1 = reg;
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
 
-	/* turn on 1.5V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x20, VUSB1V5_DEV_GRP);
+	/* Initialize 1.5V regulator */
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
+	reg = regulator_get(twl->dev, "usb1v5");
+	if (!IS_ERR(reg))
+		twl->usb1v5 = reg;
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
 
-	/* turn on 1.8V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x20, VUSB1V8_DEV_GRP);
+	/* Initialize 1.8V regulator */
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
+	reg = regulator_get(twl->dev, "usb1v8");
+	if (!IS_ERR(reg))
+		twl->usb1v8 = reg;
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
 
 	/* disable access to power configuration registers */
@@ -688,6 +718,9 @@ static int __exit twl4030_usb_remove(struct platform_device *pdev)
 	twl4030_usb_clear_bits(twl, POWER_CTRL, POWER_CTRL_OTG_ENAB);
 
 	twl4030_phy_power(twl, 0);
+	regulator_put(twl->usb1v5);
+	regulator_put(twl->usb1v8);
+	regulator_put(twl->usb3v1);
 
 	kfree(twl);
 
-- 
1.5.4.3

