Return-Path: <linux-kernel-owner+w=401wt.eu-S1753399AbXLFBPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbXLFBPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXLFBP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:15:27 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:57145 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbXLFBP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:15:26 -0500
X-Greylist: delayed 1764 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2007 20:15:26 EST
Date: Thu, 6 Dec 2007 02:48:31 +0100
From: Andrzej Zaborowski <balrogg@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: David Brownell <david-b@pacbell.net>, LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] backlight: OMAP1 backlight driver
Message-ID: <20071206014830.GB27930@borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the OMAP1 PWL-based LCD backlight driver.  It's been in the
OMAP tree for some time.  Note that OMAP2 can do similar things with
the generic timers which have PWM outputs.  Such timers are more generic
than the PWL found on OMAP1 chips, but have a different EMI profile
because they aren't driven by a pseudorandom number generator.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrzej Zaborowski <balrogg@gmail.com>
---

 drivers/video/backlight/Kconfig    |    9 +
 drivers/video/backlight/Makefile   |    1 
 drivers/video/backlight/omap1_bl.c |  218 +++++++++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+)

--- a/drivers/video/backlight/Kconfig	2007-10-25 13:05:20.000000000 -0700
+++ b/drivers/video/backlight/Kconfig	2007-12-05 14:31:03.000000000 -0800
@@ -67,6 +67,15 @@ config BACKLIGHT_LOCOMO
 	  If you have a Sharp Zaurus SL-5500 (Collie) or SL-5600 (Poodle) say y to
 	  enable the LCD/backlight driver.
 
+config BACKLIGHT_OMAP1
+	tristate "OMAP1 PWL-based LCD Backlight"
+	depends on BACKLIGHT_CLASS_DEVICE && ARCH_OMAP1
+	default y
+	help
+	  This driver controls the LCD backlight level and power for
+	  the PWL module of OMAP1 processors.  Say Y if your board
+	  uses this hardware.
+
 config BACKLIGHT_HP680
 	tristate "HP Jornada 680 Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE && SH_HP6XX
--- a/drivers/video/backlight/Makefile	2007-10-25 13:05:20.000000000 -0700
+++ b/drivers/video/backlight/Makefile	2007-12-05 14:27:20.000000000 -0800
@@ -7,5 +7,6 @@ obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += 
 obj-$(CONFIG_BACKLIGHT_CORGI)	+= corgi_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
+obj-$(CONFIG_BACKLIGHT_OMAP1)	+= omap1_bl.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
 obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ b/drivers/video/backlight/omap1_bl.c	2007-12-05 14:25:57.000000000 -0800
@@ -0,0 +1,218 @@
+/*
+ * drivers/video/backlight/omap1_bl.c
+ *
+ * Backlight driver for OMAP based boards.
+ *
+ * Copyright (c) 2006 Andrzej Zaborowski  <balrog@zabor.org>
+ *
+ * This package is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This package is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this package; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+
+#include <asm/arch/hardware.h>
+#include <asm/arch/board.h>
+#include <asm/arch/mux.h>
+
+#define OMAPBL_MAX_INTENSITY		0xff
+
+struct omap_backlight {
+	int powermode;
+	int current_intensity;
+
+	struct device *dev;
+	struct omap_backlight_config *pdata;
+};
+
+static void inline omapbl_send_intensity(int intensity)
+{
+	omap_writeb(intensity, OMAP_PWL_ENABLE);
+}
+
+static void inline omapbl_send_enable(int enable)
+{
+	omap_writeb(enable, OMAP_PWL_CLK_ENABLE);
+}
+
+static void omapbl_blank(struct omap_backlight *bl, int mode)
+{
+	if (bl->pdata->set_power)
+		bl->pdata->set_power(bl->dev, mode);
+
+	switch (mode) {
+	case FB_BLANK_NORMAL:
+	case FB_BLANK_VSYNC_SUSPEND:
+	case FB_BLANK_HSYNC_SUSPEND:
+	case FB_BLANK_POWERDOWN:
+		omapbl_send_intensity(0);
+		omapbl_send_enable(0);
+		break;
+
+	case FB_BLANK_UNBLANK:
+		omapbl_send_intensity(bl->current_intensity);
+		omapbl_send_enable(1);
+		break;
+	}
+}
+
+#ifdef CONFIG_PM
+static int omapbl_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct backlight_device *dev = platform_get_drvdata(pdev);
+	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+
+	omapbl_blank(bl, FB_BLANK_POWERDOWN);
+	return 0;
+}
+
+static int omapbl_resume(struct platform_device *pdev)
+{
+	struct backlight_device *dev = platform_get_drvdata(pdev);
+	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+
+	omapbl_blank(bl, bl->powermode);
+	return 0;
+}
+#else
+#define omapbl_suspend	NULL
+#define omapbl_resume	NULL
+#endif
+
+static int omapbl_set_power(struct backlight_device *dev, int state)
+{
+	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+
+	omapbl_blank(bl, state);
+	bl->powermode = state;
+
+	return 0;
+}
+
+static int omapbl_update_status(struct backlight_device *dev)
+{
+	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+
+	if (bl->current_intensity != dev->props.brightness) {
+		if (dev->props.brightness < 0)
+			return -EPERM;	/* Leave current_intensity untouched */
+
+		if (bl->powermode == FB_BLANK_UNBLANK)
+			omapbl_send_intensity(dev->props.brightness);
+		bl->current_intensity = dev->props.brightness;
+	}
+
+	if (dev->props.fb_blank != bl->powermode)
+		omapbl_set_power(dev, dev->props.fb_blank);
+
+	return 0;
+}
+
+
+static int omapbl_get_intensity(struct backlight_device *dev)
+{
+	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+	return bl->current_intensity;
+}
+
+static struct backlight_ops omapbl_ops = {
+	.get_brightness = omapbl_get_intensity,
+	.update_status  = omapbl_update_status,
+};
+
+
+static int omapbl_probe(struct platform_device *pdev)
+{
+	struct backlight_device *dev;
+	struct omap_backlight *bl;
+	struct omap_backlight_config *pdata = pdev->dev.platform_data;
+
+	if (!pdata)
+		return -ENXIO;
+
+	omapbl_ops.check_fb = pdata->check_fb;
+
+	bl = kzalloc(sizeof(struct omap_backlight), GFP_KERNEL);
+	if (unlikely(!bl))
+		return -ENOMEM;
+
+	dev = backlight_device_register("omap-bl", &pdev->dev,
+			bl, &omapbl_ops);
+	if (IS_ERR(dev)) {
+		kfree(bl);
+		return PTR_ERR(dev);
+	}
+
+	bl->powermode = FB_BLANK_POWERDOWN;
+	bl->current_intensity = 0;
+
+	bl->pdata = pdata;
+	bl->dev = &pdev->dev;
+
+	platform_set_drvdata(pdev, dev);
+
+	omap_cfg_reg(PWL);	/* Conflicts with UART3 */
+
+	dev->props.fb_blank = FB_BLANK_UNBLANK;
+	dev->props.max_brightness = OMAPBL_MAX_INTENSITY;
+	dev->props.brightness = pdata->default_intensity;
+	omapbl_update_status(dev);
+
+	printk(KERN_INFO "OMAP LCD backlight initialised\n");
+
+	return 0;
+}
+
+static int omapbl_remove(struct platform_device *pdev)
+{
+	struct backlight_device *dev = platform_get_drvdata(pdev);
+	struct omap_backlight *bl = dev_get_drvdata(&dev->dev);
+
+	backlight_device_unregister(dev);
+	kfree(bl);
+
+	return 0;
+}
+
+static struct platform_driver omapbl_driver = {
+	.probe		= omapbl_probe,
+	.remove		= omapbl_remove,
+	.suspend	= omapbl_suspend,
+	.resume		= omapbl_resume,
+	.driver		= {
+		.name	= "omap-bl",
+	},
+};
+
+static int __init omapbl_init(void)
+{
+	return platform_driver_register(&omapbl_driver);
+}
+
+static void __exit omapbl_exit(void)
+{
+	platform_driver_unregister(&omapbl_driver);
+}
+
+module_init(omapbl_init);
+module_exit(omapbl_exit);
+
+MODULE_AUTHOR("Andrzej Zaborowski <balrog@zabor.org>");
+MODULE_DESCRIPTION("OMAP LCD Backlight driver");
+MODULE_LICENSE("GPL");
