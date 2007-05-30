Return-Path: <linux-kernel-owner+w=401wt.eu-S1753538AbXE3Kqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbXE3Kqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 06:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbXE3Kqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 06:46:32 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:53736 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751900AbXE3Kqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 06:46:30 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH v2] Samsung LTV350QV LCD driver
Date: Wed, 30 May 2007 12:46:15 +0200
Message-Id: <11805219751252-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <1180477183.5822.105.camel@localhost.localdomain>
References: <1180477183.5822.105.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for powering on and off the Samsung LTV350QV
LCD panel via SPI. The driver responds to framebuffer power
management, it powers off the panel on reboot/halt/poweroff, and it
can also be controlled through sysfs. The panel is powered up when the
module is loaded and off when the module is unloaded.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
I agree that the write_reg() macro with embedded goto is ugly, so I've
removed it. I've also added some code that tries to recover by powering
down the display if the power-on sequence fails halfway through.

The driver has been rebased onto
http://git.o-hand.com/?p=linux-rpurdie-backlight;a=shortlog;h=for-mm

so it should apply nicely on top of David's Kconfig patch.

 drivers/video/backlight/Kconfig    |   12 ++
 drivers/video/backlight/Makefile   |    2 +
 drivers/video/backlight/ltv350qv.c |  340 ++++++++++++++++++++++++++++++++++++
 drivers/video/backlight/ltv350qv.h |   95 ++++++++++
 4 files changed, 449 insertions(+), 0 deletions(-)

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 2580f5f..b6f936a 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -24,6 +24,18 @@ config LCD_CLASS_DEVICE
 	  To have support for your specific LCD panel you will have to
 	  select the proper drivers which depend on this option.
 
+config LCD_LTV350QV
+	tristate "Samsung LTV350QV LCD Panel"
+	depends on LCD_CLASS_DEVICE && SPI_MASTER
+	default n
+	help
+	  If you have a Samsung LTV350QV LCD panel, say y to include a
+	  power control driver for it.  The panel starts up in power
+	  off state, so you need this driver in order to see any
+	  output.
+
+	  The LTV350QV panel is present on all ATSTK1000 boards.
+
 #
 # Backlight
 #
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index c6e2266..965a78b 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -1,6 +1,8 @@
 # Backlight & LCD drivers
 
 obj-$(CONFIG_LCD_CLASS_DEVICE)     += lcd.o
+obj-$(CONFIG_LCD_LTV350QV)	+= ltv350qv.o
+
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
 obj-$(CONFIG_BACKLIGHT_CORGI)	+= corgi_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
new file mode 100644
index 0000000..342b97a
--- /dev/null
+++ b/drivers/video/backlight/ltv350qv.c
@@ -0,0 +1,340 @@
+/*
+ * Power control for Samsung LTV350QV Quarter VGA LCD Panel
+ *
+ * Copyright (C) 2006, 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/delay.h>
+#include <linux/err.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/lcd.h>
+#include <linux/module.h>
+#include <linux/spi/spi.h>
+
+#include "ltv350qv.h"
+
+#define POWER_IS_ON(pwr)	((pwr) <= FB_BLANK_NORMAL)
+
+struct ltv350qv {
+	struct spi_device	*spi;
+	u8			*buffer;
+	int			power;
+	struct lcd_device	*ld;
+};
+
+/*
+ * The power-on and power-off sequences are taken from the
+ * LTV350QV-F04 data sheet from Samsung. The register definitions are
+ * taken from the S6F2002 command list also from Samsung. Both
+ * documents are distributed with the AVR32 Linux BSP CD from Atmel.
+ *
+ * There's still some voodoo going on here, but it's a lot better than
+ * in the first incarnation of the driver where all we had was the raw
+ * numbers from the initialization sequence.
+ */
+static int ltv350qv_write_reg(struct ltv350qv *lcd, u8 reg, u16 val)
+{
+	struct spi_message msg;
+	struct spi_transfer index_xfer = {
+		.len		= 3,
+		.cs_change	= 1,
+	};
+	struct spi_transfer value_xfer = {
+		.len		= 3,
+		.cs_change	= 1,
+	};
+
+	spi_message_init(&msg);
+
+	/* register index */
+	lcd->buffer[0] = LTV_OPC_INDEX;
+	lcd->buffer[1] = 0x00;
+	lcd->buffer[2] = reg & 0x7f;
+	index_xfer.tx_buf = lcd->buffer;
+	spi_message_add_tail(&index_xfer, &msg);
+
+	/* register value */
+	lcd->buffer[4] = LTV_OPC_DATA;
+	lcd->buffer[5] = val >> 8;
+	lcd->buffer[6] = val;
+	value_xfer.tx_buf = lcd->buffer + 4;
+	spi_message_add_tail(&value_xfer, &msg);
+
+	return spi_sync(lcd->spi, &msg);
+}
+
+/* The comments are taken straight from the data sheet */
+static int ltv350qv_power_on(struct ltv350qv *lcd)
+{
+	int ret;
+
+	/* Power On Reset Display off State */
+	if (ltv350qv_write_reg(lcd, LTV_PWRCTL1, 0x0000))
+		goto err;
+	msleep(15);
+
+	/* Power Setting Function 1 */
+	if (ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE))
+		goto err;
+	if (ltv350qv_write_reg(lcd, LTV_PWRCTL2, LTV_VCOML_ENABLE))
+		goto err_power1;
+
+	/* Power Setting Function 2 */
+	if (ltv350qv_write_reg(lcd, LTV_PWRCTL1,
+			       LTV_VCOM_DISABLE | LTV_DRIVE_CURRENT(5)
+			       | LTV_SUPPLY_CURRENT(5)))
+		goto err_power2;
+
+	msleep(55);
+
+	/* Instruction Setting */
+	ret = ltv350qv_write_reg(lcd, LTV_IFCTL,
+				 LTV_NMD | LTV_REV | LTV_NL(0x1d));
+	ret |= ltv350qv_write_reg(lcd, LTV_DATACTL,
+				  LTV_DS_SAME | LTV_CHS_480
+				  | LTV_DF_RGB | LTV_RGB_BGR);
+	ret |= ltv350qv_write_reg(lcd, LTV_ENTRY_MODE,
+				  LTV_VSPL_ACTIVE_LOW
+				  | LTV_HSPL_ACTIVE_LOW
+				  | LTV_DPL_SAMPLE_RISING
+				  | LTV_EPL_ACTIVE_LOW
+				  | LTV_SS_RIGHT_TO_LEFT);
+	ret |= ltv350qv_write_reg(lcd, LTV_GATECTL1, LTV_CLW(3));
+	ret |= ltv350qv_write_reg(lcd, LTV_GATECTL2,
+				  LTV_NW_INV_1LINE | LTV_FWI(3));
+	ret |= ltv350qv_write_reg(lcd, LTV_VBP, 0x000a);
+	ret |= ltv350qv_write_reg(lcd, LTV_HBP, 0x0021);
+	ret |= ltv350qv_write_reg(lcd, LTV_SOTCTL, LTV_SDT(3) | LTV_EQ(0));
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(0), 0x0103);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(1), 0x0301);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(2), 0x1f0f);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(3), 0x1f0f);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(4), 0x0707);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(5), 0x0307);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(6), 0x0707);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(7), 0x0000);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(8), 0x0004);
+	ret |= ltv350qv_write_reg(lcd, LTV_GAMMA(9), 0x0000);
+	if (ret)
+		goto err_settings;
+
+	/* Wait more than 2 frames */
+	msleep(20);
+
+	/* Display On Sequence */
+	ret = ltv350qv_write_reg(lcd, LTV_PWRCTL1,
+				 LTV_VCOM_DISABLE | LTV_VCOMOUT_ENABLE
+				 | LTV_POWER_ON | LTV_DRIVE_CURRENT(5)
+				 | LTV_SUPPLY_CURRENT(5));
+	ret |= ltv350qv_write_reg(lcd, LTV_GATECTL2,
+				  LTV_NW_INV_1LINE | LTV_DSC | LTV_FWI(3));
+	if (ret)
+		goto err_disp_on;
+
+	/* Display should now be ON. Phew. */
+	return 0;
+
+err_disp_on:
+	/*
+	 * Try to recover. Error handling probably isn't very useful
+	 * at this point, just make a best effort to switch the panel
+	 * off.
+	 */
+	ltv350qv_write_reg(lcd, LTV_PWRCTL1,
+			   LTV_VCOM_DISABLE | LTV_DRIVE_CURRENT(5)
+			   | LTV_SUPPLY_CURRENT(5));
+	ltv350qv_write_reg(lcd, LTV_GATECTL2,
+			   LTV_NW_INV_1LINE | LTV_FWI(3));
+err_settings:
+err_power2:
+err_power1:
+	ltv350qv_write_reg(lcd, LTV_PWRCTL2, 0x0000);
+	msleep(1);
+err:
+	ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE);
+	return -EIO;
+}
+
+static int ltv350qv_power_off(struct ltv350qv *lcd)
+{
+	int ret;
+
+	/* Display Off Sequence */
+	ret = ltv350qv_write_reg(lcd, LTV_PWRCTL1,
+				 LTV_VCOM_DISABLE
+				 | LTV_DRIVE_CURRENT(5)
+				 | LTV_SUPPLY_CURRENT(5));
+	ret |= ltv350qv_write_reg(lcd, LTV_GATECTL2,
+				  LTV_NW_INV_1LINE | LTV_FWI(3));
+
+	/* Power down setting 1 */
+	ret |= ltv350qv_write_reg(lcd, LTV_PWRCTL2, 0x0000);
+
+	/* Wait at least 1 ms */
+	msleep(1);
+
+	/* Power down setting 2 */
+	ret |= ltv350qv_write_reg(lcd, LTV_PWRCTL1, LTV_VCOM_DISABLE);
+
+	/*
+	 * No point in trying to recover here. If we can't switch the
+	 * panel off, what are we supposed to do other than inform the
+	 * user about the failure?
+	 */
+	if (ret)
+		return -EIO;
+
+	/* Display power should now be OFF */
+	return 0;
+}
+
+static int ltv350qv_power(struct ltv350qv *lcd, int power)
+{
+	int ret = 0;
+
+	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
+		ret = ltv350qv_power_on(lcd);
+	else if (!POWER_IS_ON(power) && POWER_IS_ON(lcd->power))
+		ret = ltv350qv_power_off(lcd);
+
+	if (!ret)
+		lcd->power = power;
+
+	return ret;
+}
+
+static int ltv350qv_set_power(struct lcd_device *ld, int power)
+{
+	struct ltv350qv *lcd;
+
+	lcd = class_get_devdata(&ld->class_dev);
+	return ltv350qv_power(lcd, power);
+}
+
+static int ltv350qv_get_power(struct lcd_device *ld)
+{
+	struct ltv350qv *lcd;
+
+	lcd = class_get_devdata(&ld->class_dev);
+	return lcd->power;
+}
+
+static struct lcd_ops ltv_ops = {
+	.get_power	= ltv350qv_get_power,
+	.set_power	= ltv350qv_set_power,
+};
+
+static int __devinit ltv350qv_probe(struct spi_device *spi)
+{
+	struct ltv350qv *lcd;
+	struct lcd_device *ld;
+	int ret;
+
+	lcd = kzalloc(sizeof(struct ltv350qv), GFP_KERNEL);
+	if (!lcd)
+		return -ENOMEM;
+
+	lcd->spi = spi;
+	lcd->power = FB_BLANK_POWERDOWN;
+	lcd->buffer = kzalloc(8, GFP_KERNEL);
+
+	ld = lcd_device_register("ltv350qv", lcd, &ltv_ops);
+	if (IS_ERR(ld)) {
+		ret = PTR_ERR(ld);
+		goto out_free_lcd;
+	}
+	lcd->ld = ld;
+
+	ret = ltv350qv_power(lcd, FB_BLANK_UNBLANK);
+	if (ret)
+		goto out_unregister;
+
+	dev_set_drvdata(&spi->dev, lcd);
+
+	return 0;
+
+out_unregister:
+	lcd_device_unregister(ld);
+out_free_lcd:
+	kfree(lcd);
+	return ret;
+}
+
+static int __devexit ltv350qv_remove(struct spi_device *spi)
+{
+	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+
+	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
+	lcd_device_unregister(lcd->ld);
+	kfree(lcd);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int ltv350qv_suspend(struct spi_device *spi,
+			    pm_message_t state, u32 level)
+{
+	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+
+	if (level == SUSPEND_POWER_DOWN)
+		return ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
+
+	return 0;
+}
+
+static int ltv350qv_resume(struct spi_device *spi, u32 level)
+{
+	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+
+	if (level == RESUME_POWER_ON)
+		return ltv350qv_power(lcd, FB_BLANK_UNBLANK);
+
+	return 0;
+}
+#else
+#define ltv350qv_suspend	NULL
+#define ltv350qv_resume		NULL
+#endif
+
+/* Power down all displays on reboot, poweroff or halt */
+static void ltv350qv_shutdown(struct spi_device *spi)
+{
+	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+
+	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
+}
+
+static struct spi_driver ltv350qv_driver = {
+	.driver = {
+		.name		= "ltv350qv",
+		.bus		= &spi_bus_type,
+		.owner		= THIS_MODULE,
+	},
+
+	.probe		= ltv350qv_probe,
+	.remove		= __devexit_p(ltv350qv_remove),
+	.shutdown	= ltv350qv_shutdown,
+	.suspend	= ltv350qv_suspend,
+	.resume		= ltv350qv_resume,
+};
+
+static int __init ltv350qv_init(void)
+{
+	return spi_register_driver(&ltv350qv_driver);
+}
+
+static void __exit ltv350qv_exit(void)
+{
+	spi_unregister_driver(&ltv350qv_driver);
+}
+module_init(ltv350qv_init);
+module_exit(ltv350qv_exit);
+
+MODULE_AUTHOR("Haavard Skinnemoen <hskinnemoen@atmel.com>");
+MODULE_DESCRIPTION("Samsung LTV350QV LCD Driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/video/backlight/ltv350qv.h b/drivers/video/backlight/ltv350qv.h
new file mode 100644
index 0000000..189112e
--- /dev/null
+++ b/drivers/video/backlight/ltv350qv.h
@@ -0,0 +1,95 @@
+/*
+ * Register definitions for Samsung LTV350QV Quarter VGA LCD Panel
+ *
+ * Copyright (C) 2006, 2007 Atmel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LTV350QV_H
+#define __LTV350QV_H
+
+#define LTV_OPC_INDEX	0x74
+#define LTV_OPC_DATA	0x76
+
+#define LTV_ID		0x00		/* ID Read */
+#define LTV_IFCTL	0x01		/* Display Interface Control */
+#define LTV_DATACTL	0x02		/* Display Data Control */
+#define LTV_ENTRY_MODE	0x03		/* Entry Mode */
+#define LTV_GATECTL1	0x04		/* Gate Control 1 */
+#define LTV_GATECTL2	0x05		/* Gate Control 2 */
+#define LTV_VBP		0x06		/* Vertical Back Porch */
+#define LTV_HBP		0x07		/* Horizontal Back Porch */
+#define LTV_SOTCTL	0x08		/* Source Output Timing Control */
+#define LTV_PWRCTL1	0x09		/* Power Control 1 */
+#define LTV_PWRCTL2	0x0a		/* Power Control 2 */
+#define LTV_GAMMA(x)	(0x10 + (x))	/* Gamma control */
+
+/* Bit definitions for LTV_IFCTL */
+#define LTV_IM			(1 << 15)
+#define LTV_NMD			(1 << 14)
+#define LTV_SSMD		(1 << 13)
+#define LTV_REV			(1 <<  7)
+#define LTV_NL(x)		(((x) & 0x001f) << 0)
+
+/* Bit definitions for LTV_DATACTL */
+#define LTV_DS_SAME		(0 << 12)
+#define LTV_DS_D_TO_S		(1 << 12)
+#define LTV_DS_S_TO_D		(2 << 12)
+#define LTV_CHS_384		(0 <<  9)
+#define LTV_CHS_480		(1 <<  9)
+#define LTV_CHS_492		(2 <<  9)
+#define LTV_DF_RGB		(0 <<  6)
+#define LTV_DF_RGBX		(1 <<  6)
+#define LTV_DF_XRGB		(2 <<  6)
+#define LTV_RGB_RGB		(0 <<  2)
+#define LTV_RGB_BGR		(1 <<  2)
+#define LTV_RGB_GRB		(2 <<  2)
+#define LTV_RGB_RBG		(3 <<  2)
+
+/* Bit definitions for LTV_ENTRY_MODE */
+#define LTV_VSPL_ACTIVE_LOW	(0 << 15)
+#define LTV_VSPL_ACTIVE_HIGH	(1 << 15)
+#define LTV_HSPL_ACTIVE_LOW	(0 << 14)
+#define LTV_HSPL_ACTIVE_HIGH	(1 << 14)
+#define LTV_DPL_SAMPLE_RISING	(0 << 13)
+#define LTV_DPL_SAMPLE_FALLING	(1 << 13)
+#define LTV_EPL_ACTIVE_LOW	(0 << 12)
+#define LTV_EPL_ACTIVE_HIGH	(1 << 12)
+#define LTV_SS_LEFT_TO_RIGHT	(0 <<  8)
+#define LTV_SS_RIGHT_TO_LEFT	(1 <<  8)
+#define LTV_STB			(1 <<  1)
+
+/* Bit definitions for LTV_GATECTL1 */
+#define LTV_CLW(x)		(((x) & 0x0007) << 12)
+#define LTV_GAON		(1 <<  5)
+#define LTV_SDR			(1 <<  3)
+
+/* Bit definitions for LTV_GATECTL2 */
+#define LTV_NW_INV_FRAME	(0 << 14)
+#define LTV_NW_INV_1LINE	(1 << 14)
+#define LTV_NW_INV_2LINE	(2 << 14)
+#define LTV_DSC			(1 << 12)
+#define LTV_GIF			(1 <<  8)
+#define LTV_FHN			(1 <<  7)
+#define LTV_FTI(x)		(((x) & 0x0003) << 4)
+#define LTV_FWI(x)		(((x) & 0x0003) << 0)
+
+/* Bit definitions for LTV_SOTCTL */
+#define LTV_SDT(x)		(((x) & 0x0007) << 10)
+#define LTV_EQ(x)		(((x) & 0x0007) <<  2)
+
+/* Bit definitions for LTV_PWRCTL1 */
+#define LTV_VCOM_DISABLE	(1 << 14)
+#define LTV_VCOMOUT_ENABLE	(1 << 11)
+#define LTV_POWER_ON		(1 <<  9)
+#define LTV_DRIVE_CURRENT(x)	(((x) & 0x0007) << 4)	/* 0=off, 5=max */
+#define LTV_SUPPLY_CURRENT(x)	(((x) & 0x0007) << 0)	/* 0=off, 5=max */
+
+/* Bit definitions for LTV_PWRCTL2 */
+#define LTV_VCOML_ENABLE	(1 << 13)
+#define LTV_VCOML_VOLTAGE(x)	(((x) & 0x001f) << 8)	/* 0=1V, 31=-1V */
+#define LTV_VCOMH_VOLTAGE(x)	(((x) & 0x001f) << 0)	/* 0=3V, 31=4.5V */
+
+#endif /* __LTV350QV_H */
-- 
1.4.4.4

