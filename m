Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbYLPNke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbYLPNke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 08:40:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbYLPNj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 08:39:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54546 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751643AbYLPNj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 08:39:58 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] mfd: Register WM8400 codec device
Date: Tue, 16 Dec 2008 13:39:56 +0000
Message-Id: <1229434796-24871-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1229434796-24871-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1229434796-24871-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a child device for the codec in the WM8400.

Also switch the unregistration of the MFD devices to use the MFD core
since the current code is hand rolling the same thing.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig       |    1 +
 drivers/mfd/wm8400-core.c |   31 +++++++++++++++++++++++++------
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 8cd3dd9..ddfb12b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -116,6 +116,7 @@ config PMIC_DA903X
 
 config MFD_WM8400
 	tristate "Support Wolfson Microelectronics WM8400"
+	select MFD_CORE
 	depends on I2C
 	help
 	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
diff --git a/drivers/mfd/wm8400-core.c b/drivers/mfd/wm8400-core.c
index 6a0cedb..cf30d06 100644
--- a/drivers/mfd/wm8400-core.c
+++ b/drivers/mfd/wm8400-core.c
@@ -15,6 +15,7 @@
 #include <linux/bug.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
+#include <linux/mfd/core.h>
 #include <linux/mfd/wm8400-private.h>
 #include <linux/mfd/wm8400-audio.h>
 
@@ -239,6 +240,16 @@ void wm8400_reset_codec_reg_cache(struct wm8400 *wm8400)
 }
 EXPORT_SYMBOL_GPL(wm8400_reset_codec_reg_cache);
 
+static int wm8400_register_codec(struct wm8400 *wm8400)
+{
+	struct mfd_cell cell = {
+		.name = "wm8400-codec",
+		.driver_data = wm8400,
+	};
+
+	return mfd_add_devices(wm8400->dev, -1, &cell, 1, NULL, 0);
+}
+
 /*
  * wm8400_init - Generic initialisation
  *
@@ -296,24 +307,32 @@ static int wm8400_init(struct wm8400 *wm8400,
 	reg = (reg & WM8400_CHIP_REV_MASK) >> WM8400_CHIP_REV_SHIFT;
 	dev_info(wm8400->dev, "WM8400 revision %x\n", reg);
 
+	ret = wm8400_register_codec(wm8400);
+	if (ret != 0) {
+		dev_err(wm8400->dev, "Failed to register codec\n");
+		goto err_children;
+	}
+
 	if (pdata && pdata->platform_init) {
 		ret = pdata->platform_init(wm8400->dev);
-		if (ret != 0)
+		if (ret != 0) {
 			dev_err(wm8400->dev, "Platform init failed: %d\n",
 				ret);
+			goto err_children;
+		}
 	} else
 		dev_warn(wm8400->dev, "No platform initialisation supplied\n");
 
+	return 0;
+
+err_children:
+	mfd_remove_devices(wm8400->dev);
 	return ret;
 }
 
 static void wm8400_release(struct wm8400 *wm8400)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(wm8400->regulators); i++)
-		if (wm8400->regulators[i].name)
-			platform_device_unregister(&wm8400->regulators[i]);
+	mfd_remove_devices(wm8400->dev);
 }
 
 #if defined(CONFIG_I2C) || defined(CONFIG_I2C_MODULE)
-- 
1.5.6.5

