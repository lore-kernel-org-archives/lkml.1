Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZBHThX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZBHThX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 14:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZBHThF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 14:37:05 -0500
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:46133 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752791AbZBHThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 14:37:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=bJwGaztfQiRhzOnUfBW34GAY7MeG9Z2KaxYoAAotaBaXxWb5KnVhFbCi/QkE7C81452ZvlSOfvsO49vPVegVbXfzJIxxlJQoq5c/008GGLzVReTNc68RxyE3PrI9bFvHtp+FHKTjiDevPYQwa1SrAnlEfLFToy1Bg7Sw+kiRY5E=  ;
X-YMail-OSG: kid8p0wVM1m1IuBdOPyLdwDE.PE_0UXVhJqE9HfnP22na6KyPADr9yEEaMNeuQmNNKioKIzhd.ang8SQ_9S_0H1w4H8QkKn9tJWxcq6V7Ajlej2OIuTLkdYBiqlI.i0kUdx.ZrOPPwsPE.KyaNrJD_wnijVSGeJPLGgpXLcHVgCaDs_uDACpis2gWV3bNvQl8g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@sirena.org.uk>
Subject: [patch 2.6.29-rc3-git 2/2] USB: disable twl4030 USB regulators when cable unplugged
Date: Sun, 8 Feb 2009 10:52:59 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       OMAP <linux-omap@vger.kernel.org>,
       Kalle Jokiniemi <kalle.jokiniemi@digia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902081053.00255.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>

This patch disables LDO regulators VUSB1V5, VUSB1V8, and VUSB3V1
when the USB cable is unplugged, to eliminate that source of power
waste.  (Enabled LDOs consume power at all times.)

Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
Depends on the twl4030 regulator driver, so I'm suggesting this
be merged (with that driver) through the regulator patch queue
to simplify things.

 drivers/usb/otg/twl4030-usb.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/usb/otg/twl4030-usb.c
+++ b/drivers/usb/otg/twl4030-usb.c
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/usb/otg.h>
 #include <linux/i2c/twl4030.h>
+#include <linux/regulator/consumer.h>
 
 
 /* Register defines */
@@ -246,6 +247,11 @@ struct twl4030_usb {
 	struct otg_transceiver	otg;
 	struct device		*dev;
 
+	/* TWL4030 internal USB regulator supplies */
+	struct regulator	*usb1v5;
+	struct regulator	*usb1v8;
+	struct regulator	*usb3v1;
+
 	/* for vbus reporting with irqs disabled */
 	spinlock_t		lock;
 
@@ -434,6 +440,9 @@ static void twl4030_phy_power(struct twl
 
 	pwr = twl4030_usb_read(twl, PHY_PWR_CTRL);
 	if (on) {
+		regulator_enable(twl->usb1v5);
+		regulator_enable(twl->usb1v8);
+		regulator_enable(twl->usb3v1);
 		pwr &= ~PHY_PWR_PHYPWD;
 		WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
 		twl4030_usb_write(twl, PHY_CLK_CTRL,
@@ -443,6 +452,9 @@ static void twl4030_phy_power(struct twl
 	} else  {
 		pwr |= PHY_PWR_PHYPWD;
 		WARN_ON(twl4030_usb_write_verify(twl, PHY_PWR_CTRL, pwr) < 0);
+		regulator_disable(twl->usb1v5);
+		regulator_disable(twl->usb1v8);
+		regulator_disable(twl->usb3v1);
 	}
 }
 
@@ -480,16 +492,19 @@ static void twl4030_usb_ldo_init(struct 
 	/* input to VUSB3V1 LDO is from VBAT, not VBUS */
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x14, VUSB_DEDICATED1);
 
-	/* turn on 3.1V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x20, VUSB3V1_DEV_GRP);
+	/* Initialize 3.1V regulator */
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_DEV_GRP);
+	twl->usb3v1 = regulator_get(twl->dev, "usb3v1");
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB3V1_TYPE);
 
-	/* turn on 1.5V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x20, VUSB1V5_DEV_GRP);
+	/* Initialize 1.5V regulator */
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_DEV_GRP);
+	twl->usb1v5 = regulator_get(twl->dev, "usb1v5");
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V5_TYPE);
 
-	/* turn on 1.8V regulator */
-	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x20, VUSB1V8_DEV_GRP);
+	/* Initialize 1.8V regulator */
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_DEV_GRP);
+	twl->usb1v8 = regulator_get(twl->dev, "usb1v8");
 	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0, VUSB1V8_TYPE);
 
 	/* disable access to power configuration registers */
@@ -688,6 +703,9 @@ static int __exit twl4030_usb_remove(str
 	twl4030_usb_clear_bits(twl, POWER_CTRL, POWER_CTRL_OTG_ENAB);
 
 	twl4030_phy_power(twl, 0);
+	regulator_put(twl->usb1v5);
+	regulator_put(twl->usb1v8);
+	regulator_put(twl->usb3v1);
 
 	kfree(twl);
 
