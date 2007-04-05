Return-Path: <linux-kernel-owner+w=401wt.eu-S1767657AbXDFN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767657AbXDFN7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 09:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767658AbXDFN7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 09:59:20 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43852 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767657AbXDFN7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 09:59:13 -0400
Date: Thu, 5 Apr 2007 11:04:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Harald Welte <laforge@openmoko.org>, openmoko-kernel@lists.openmoko.org,
       kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net
Cc: Russell King <rmk@arm.linux.org.uk>
Subject: backlight support for fic1973
Message-ID: <20070405090401.GA11126@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for backlight on Fic1973 phone. I removed some
#ifdefs from Harald's version, and simple, non-PWM mode is no longer
supported. I do not think it was too useful besides for debugging.

From: Harald Welte <laforge@openmoko.org>
Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/drivers/video/backlight/Kconfig b/drivers/video/backlight/Kconfig
index 47d15b5..e0be3aa 100644
--- a/drivers/video/backlight/Kconfig
+++ b/drivers/video/backlight/Kconfig
@@ -48,6 +48,14 @@ config BACKLIGHT_LOCOMO
 	  If you have a Sharp Zaurus SL-5500 (Collie) or SL-5600 (Poodle) say y to
 	  enable the LCD/backlight driver.
 
+config BACKLIGHT_GTA01
+	tristate "FIC GTA01 Backlight Driver"
+	depends on BACKLIGHT_CLASS_DEVICE && MACH_GTA01
+	default y
+	help
+	  If you have a FIC GTA01 say y to enable the backlight driver.
+
+
 config BACKLIGHT_HP680
 	tristate "HP Jornada 680 Backlight Driver"
 	depends on BACKLIGHT_CLASS_DEVICE && SH_HP6XX
diff --git a/drivers/video/backlight/Makefile b/drivers/video/backlight/Makefile
index 0c3ce46..55cdf6d 100644
--- a/drivers/video/backlight/Makefile
+++ b/drivers/video/backlight/Makefile
@@ -3,6 +3,7 @@ # Backlight & LCD drivers
 obj-$(CONFIG_LCD_CLASS_DEVICE)     += lcd.o
 obj-$(CONFIG_BACKLIGHT_CLASS_DEVICE) += backlight.o
 obj-$(CONFIG_BACKLIGHT_CORGI)	+= corgi_bl.o
+obj-$(CONFIG_BACKLIGHT_GTA01)	+= gta01_bl.o
 obj-$(CONFIG_BACKLIGHT_HP680)	+= hp680_bl.o
 obj-$(CONFIG_BACKLIGHT_LOCOMO)	+= locomolcd.o
 obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
diff --git a/drivers/video/backlight/gta01_bl.c b/drivers/video/backlight/gta01_bl.c
new file mode 100644
index 0000000..c0feee5
--- /dev/null
+++ b/drivers/video/backlight/gta01_bl.c
@@ -0,0 +1,265 @@
+/*
+ *  Backlight Driver for FIC GTA01 (Neo1973) GSM Phone
+ *
+ * Copyright (C) 2006-2007 by OpenMoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ * All rights reserved.
+ *
+ *  based on corgi_cl.c, Copyright (c) 2004-2006 Richard Purdie
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
+ * MA 02111-1307 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/fb.h>
+#include <linux/backlight.h>
+#include <linux/clk.h>
+
+#include <asm/arch/hardware.h>
+#include <asm/arch/regs-timer.h>
+#include <asm/arch/gta01.h>
+
+static struct backlight_properties gta01bl_prop;
+static struct backlight_device *gta01_backlight_device;
+static struct gta01bl_machinfo *bl_machinfo;
+
+static unsigned long gta01bl_flags;
+
+struct gta01bl_data {
+	int intensity;
+	struct mutex mutex;
+	struct clk *clk;
+};
+
+static struct gta01bl_data gta01bl;
+
+#define GTA01BL_SUSPENDED     0x01
+#define GTA01BL_BATTLOW       0x02
+
+#define GTA01BL_FREQ	400
+
+/* On the GTA01 / Neo1973, we use a 50 or 66MHz PCLK, which gives
+ * us a 6.25..8.25MHz DIV8 clock, which is further divided by a
+ * prescaler of 4, resulting in a 1.56..2.06MHz tick.  This results in a
+ * minimum frequency of 24..31Hz.  At 400Hz, we need to set the count
+ * to something like 3906..5156, providing us a way sufficient resolution
+ * for display brightness adjustment. */
+
+static int gta01bl_send_intensity(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	if (bd->props.power != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (bd->props.fb_blank != FB_BLANK_UNBLANK)
+		intensity = 0;
+	if (gta01bl_flags & GTA01BL_SUSPENDED)
+		intensity = 0;
+	if (gta01bl_flags & GTA01BL_BATTLOW)
+		intensity &= bl_machinfo->limit_mask;
+
+ 	mutex_lock(&gta01bl.mutex);
+	if (intensity == bd->props.max_brightness) {
+		s3c2410_gpio_setpin(GTA01_GPIO_BACKLIGHT, 1);
+		s3c2410_gpio_cfgpin(GTA01_GPIO_BACKLIGHT, S3C2410_GPIO_OUTPUT);
+	} else  {
+		__raw_writel(intensity & 0xffff, S3C2410_TCMPB(0));
+		s3c2410_gpio_cfgpin(GTA01_GPIO_BACKLIGHT, S3C2410_GPB0_TOUT0);
+	}
+	mutex_unlock(&gta01bl.mutex);
+
+	gta01bl.intensity = intensity;
+
+	return 0;
+}
+
+static void gta01bl_init_hw(void)
+{
+	unsigned long tcon, tcfg0, tcfg1, tcnt, pclk;
+
+	pclk = clk_get_rate(gta01bl.clk);
+
+	tcon = __raw_readl(S3C2410_TCON);
+	tcfg1 = __raw_readl(S3C2410_TCFG1);
+	tcfg0 = __raw_readl(S3C2410_TCFG0);
+
+	tcfg1 &= ~S3C2410_TCFG1_MUX0_MASK;
+	tcfg1 |= S3C2410_TCFG1_MUX0_DIV8;
+
+	tcfg0 &= ~S3C2410_TCFG_PRESCALER0_MASK;
+	tcfg0 |= (4 - 1);
+
+	tcnt = (pclk / 32) / GTA01BL_FREQ;
+	tcnt--;
+
+	__raw_writel(tcfg1, S3C2410_TCFG1);
+	__raw_writel(tcfg0, S3C2410_TCFG0);
+
+	/* ensure timer is stopped */
+
+	tcon &= 0xffffff00;
+	tcon |= S3C2410_TCON_T0RELOAD;
+	tcon |= S3C2410_TCON_T0MANUALUPD;
+
+	__raw_writel(tcnt, S3C2410_TCNTB(0));
+	__raw_writel(tcnt, S3C2410_TCMPB(0));
+	__raw_writel(tcon, S3C2410_TCON);
+
+	/* start the timer */
+	tcon |= S3C2410_TCON_T0START;
+	tcon &= ~S3C2410_TCON_T0MANUALUPD;
+	__raw_writel(tcon, S3C2410_TCON);
+
+	gta01bl_prop.max_brightness = tcnt;
+}
+
+#ifdef CONFIG_PM
+static int gta01bl_suspend(struct platform_device *dev, pm_message_t state)
+{
+	gta01bl_flags |= GTA01BL_SUSPENDED;
+	gta01bl_send_intensity(gta01_backlight_device);
+	return 0;
+}
+
+static int gta01bl_resume(struct platform_device *dev)
+{
+	mutex_lock(&gta01bl.mutex);
+	gta01bl_init_hw();
+	mutex_unlock(&gta01bl.mutex);
+
+	gta01bl_flags &= ~GTA01BL_SUSPENDED;
+	gta01bl_send_intensity(gta01_backlight_device);
+	return 0;
+}
+#else
+#define gta01bl_suspend	NULL
+#define gta01bl_resume	NULL
+#endif
+
+static int gta01bl_get_intensity(struct backlight_device *bd)
+{
+	return gta01bl.intensity;
+}
+
+static int gta01bl_set_intensity(struct backlight_device *bd)
+{
+	gta01bl_send_intensity(gta01_backlight_device);
+	return 0;
+}
+
+/*
+ * Called when the battery is low to limit the backlight intensity.
+ * If limit==0 clear any limit, otherwise limit the intensity
+ */
+void gta01bl_limit_intensity(int limit)
+{
+	if (limit)
+		gta01bl_flags |= GTA01BL_BATTLOW;
+	else
+		gta01bl_flags &= ~GTA01BL_BATTLOW;
+	gta01bl_send_intensity(gta01_backlight_device);
+}
+EXPORT_SYMBOL(gta01bl_limit_intensity);
+
+
+static struct backlight_ops gta01bl_ops = {
+	.get_brightness = gta01bl_get_intensity,
+	.update_status  = gta01bl_set_intensity,
+};
+
+static int __init gta01bl_probe(struct platform_device *pdev)
+{
+	struct gta01bl_machinfo *machinfo = pdev->dev.platform_data;
+
+	/* use s3c_device_timer0 for PWM */
+	gta01bl.clk = clk_get(NULL, "timers");
+	if (IS_ERR(gta01bl.clk))
+		return PTR_ERR(gta01bl.clk);
+
+	clk_enable(gta01bl.clk);
+
+	gta01bl_init_hw();
+	mutex_init(&gta01bl.mutex);
+
+	if (!machinfo->limit_mask)
+		machinfo->limit_mask = -1;
+
+	gta01_backlight_device = backlight_device_register("gta01-bl",
+							   &pdev->dev, NULL,
+							   &gta01bl_ops);
+	if (IS_ERR(gta01_backlight_device))
+		return PTR_ERR(gta01_backlight_device);
+
+	gta01_backlight_device->props.power = FB_BLANK_UNBLANK;
+	gta01_backlight_device->props.brightness = gta01bl_prop.max_brightness;
+	gta01bl_send_intensity(gta01_backlight_device);
+
+	printk("GTA01 Backlight Driver Initialized.\n");
+	return 0;
+}
+
+static int gta01bl_remove(struct platform_device *dev)
+{
+	unsigned long tcon;
+
+	/* stop this timer */
+	tcon = __raw_readl(S3C2410_TCON);
+	tcon &= 0xffffff00;
+	__raw_writel(tcon, S3C2410_TCON);
+
+	clk_disable(gta01bl.clk);
+	clk_put(gta01bl.clk);
+
+	backlight_device_unregister(gta01_backlight_device);
+	mutex_destroy(&gta01bl.mutex);
+
+	printk("GTA01 Backlight Driver Unloaded, constant backlight\n");
+	s3c2410_gpio_cfgpin(GTA01_GPIO_BACKLIGHT, S3C2410_GPIO_OUTPUT);
+	s3c2410_gpio_setpin(GTA01_GPIO_BACKLIGHT, 1);
+
+	return 0;
+}
+
+static struct platform_driver gta01bl_driver = {
+	.probe		= gta01bl_probe,
+	.remove		= gta01bl_remove,
+	.suspend	= gta01bl_suspend,
+	.resume		= gta01bl_resume,
+	.driver		= {
+		.name	= "gta01-bl",
+	},
+};
+
+static int __init gta01bl_init(void)
+{
+	return platform_driver_register(&gta01bl_driver);
+}
+
+static void __exit gta01bl_exit(void)
+{
+	platform_driver_unregister(&gta01bl_driver);
+}
+
+module_init(gta01bl_init);
+module_exit(gta01bl_exit);
+
+MODULE_AUTHOR("Harald Welte <laforge@openmoko.org>");
+MODULE_DESCRIPTION("FIC GTA01 (Neo1973) Backlight Driver");
+MODULE_LICENSE("GPL");

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
