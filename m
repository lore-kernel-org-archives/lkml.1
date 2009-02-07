Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZBGGNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZBGGNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 01:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZBGGNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 01:13:37 -0500
Received: from rv-out-0506.google.com ([209.85.198.234]:57826 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbZBGGNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 01:13:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SCLRA6vVY2KS9NbXMgsdsorHloc/92Ln+VulBncPjW+eKGEWfMAdhXOEZuVOrfbCyu
         366xO5rJDxFBb/0Ic2XlSF1dg6jvoMFXMqjksso6WWWvmrJ1Ymli1w3LGdGPULJLVaV8
         dFpsAoFfWFIVgjgk5oHNHWNeCruesrwUA70IQ=
MIME-Version: 1.0
Date: Sat, 7 Feb 2009 15:13:35 +0900
Message-ID: <4e1455be0902062213o769a4d15ha0c892508839dbad@mail.gmail.com>
Subject: [PATCH] twl4030-gpio: Fix getting the value of the TWL4030 GPIO 
	output pin
From: Joonyoung Shim <dofmind@gmail.com>
To: Tony Lindgren <tony@atomide.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If TWL4030 GPIO pin is output, must read the value from REG_GPIODATAOUTx
register in twl4030_get_gpio_datainout().

Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
---

diff --git a/drivers/gpio/twl4030-gpio.c b/drivers/gpio/twl4030-gpio.c
index afad147..890518a 100644
--- a/drivers/gpio/twl4030-gpio.c
+++ b/drivers/gpio/twl4030-gpio.c
@@ -183,7 +183,7 @@ static int twl4030_set_gpio_dataout(int gpio, int enable)
 	return gpio_twl4030_write(base, d_msk);
 }

-static int twl4030_get_gpio_datain(int gpio)
+static int twl4030_get_gpio_datainout(int gpio)
 {
 	u8 d_bnk = gpio >> 3;
 	u8 d_off = gpio & 0x7;
@@ -194,7 +194,17 @@ static int twl4030_get_gpio_datain(int gpio)
 		|| !(gpio_usage_count & BIT(gpio))))
 		return -EPERM;

-	base = REG_GPIODATAIN1 + d_bnk;
+	base = REG_GPIODATADIR1 + d_bnk;
+	ret = gpio_twl4030_read(base);
+	if (ret > 0)
+		ret = (ret >> d_off) & 0x1;
+	else
+		return ret;
+
+	if (ret)
+		base = REG_GPIODATAOUT1 + d_bnk;
+	else
+		base = REG_GPIODATAIN1 + d_bnk;
 	ret = gpio_twl4030_read(base);
 	if (ret > 0)
 		ret = (ret >> d_off) & 0x1;
