Return-Path: <linux-kernel-owner+w=401wt.eu-S1756529AbYBFTVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbYBFTVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 14:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYBFTVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 14:21:38 -0500
Received: from wx-out-0506.google.com ([66.249.82.227]:37489 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYBFTVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 14:21:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:from;
        b=afgpBvdQmVBZ7TOQoScgJuYnHcHp8G9F8KyeIpLnG1VNIItOwmflmpjlid2ZgyAyYOpN+8zm+z76ATncjuc/6EdNdcqbMaj9AtrMkDfWufbCMOwICQQjejCh9//gv8QatocLgElgMVroqpYNWo0MnsOK0cPTPwDJrHCAXEcTS9Q=
Date: Wed, 6 Feb 2008 20:21:28 +0100
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Roel Kluin <12o3l@tiscali.nl>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
 Jornada 7xx handhelds
Message-Id: <20080206202128.06fbcafa.Kristoffer.ericson@gmail.com>
In-Reply-To: <20080206164435.GC32245@flint.arm.linux.org.uk>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com>
	<47A9A944.7090401@tiscali.nl>
	<47A9AA4F.80508@tiscali.nl>
	<20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
	<20080206164435.GC32245@flint.arm.linux.org.uk>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__6_Feb_2008_20_21_28_+0100_.5WIE8oTcBNPV+zT"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__6_Feb_2008_20_21_28_+0100_.5WIE8oTcBNPV+zT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Attempt #3 :
Changes :
---------
* removed JORN.. prefixes except from functions.
* removed file location in head
* fixed (hope) indent issues
* do not exceed 80 chars per line
* added extra checks if driver allocation fails
* return -1 instead of (MAX + 1)
...and probably alot more.

Patch:
* builds
* passes checkpatch.pl (only complaining about signoff-tag)

Oh, and thanks for all the feedback people! (and for doing it nicely)
Only thing not adress so far is richards mdelay question, need to do a quick test before I can answer that.

/Kristoffer

diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c
new file mode 100644
index 0000000..0adbc49
--- /dev/null
+++ b/drivers/video/backlight/jornada720_bllcd.c
@@ -0,0 +1,287 @@
+/*
+ *
+ * Backlight and LCD Driver for HP Jornada 720
+ * Copyright (C) 2007 Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * or any later version as published by the Free Software Foundation.
+ *
+ */
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/backlight.h>
+#include <linux/lcd.h>
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/fb.h>
+#include <linux/device.h>
+#include <asm/hardware.h>
+#include <asm/arch/jornada720.h>
+#include <video/s1d13xxxfb.h>
+
+MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
+MODULE_DESCRIPTION("HP Jornada 710/720/728 Backlight/LCD Driver");
+MODULE_LICENSE("GPL");
+
+/* Contrast */
+#define LCD_MAX_CONTR	0xff
+#define LCD_DEF_CONTR	0x80
+/* Brightness */
+#define BL_MAX_BRIGHT	0xff
+#define BL_DEF_BRIGHT	0x19
+
+struct bllcd_device {
+	struct backlight_device *bl_device;
+	struct lcd_device *lcd_device;
+};
+
+/*
+ * BACKLIGHT HANDLING ROUTINES
+ */
+static int jornada_bl_get_brightness(struct backlight_device *dev)
+{
+	int ret;
+
+	/* check if backlight is on */
+	if (!(PPSR & PPC_LDD1))
+		return BL_MAX_BRIGHT;
+
+	jornada_ssp_start();
+	if (jornada_ssp_inout(GETBRIGHTNESS) == -ETIMEDOUT) {
+		printk(KERN_ERR "bl :get brightness timeout\n");
+		ret = -1;
+	} else
+		ret = jornada_ssp_inout(TXDUMMY);
+
+	jornada_ssp_end();
+
+	/* 0 is max brightness */
+	return BL_MAX_BRIGHT - ret;
+}
+
+static int jornada_bl_update_status(struct backlight_device *dev)
+{
+	int ret = 0;
+	int value;
+
+	jornada_ssp_start();
+
+	if (dev->props.power != FB_BLANK_UNBLANK ||
+	dev->props.fb_blank != FB_BLANK_UNBLANK) {
+		ret = jornada_ssp_inout(BRIGHTNESSOFF);
+		if (ret == -ETIMEDOUT) {
+			printk(KERN_ERR "bl : brightness off timeout\n");
+			/* backlight off */
+			PPSR &= ~PPC_LDD1;
+			PPDR |= PPC_LDD1;
+		}
+	} else { /* backlight on */
+		PPSR |= PPC_LDD1;
+		/* send setbrightness cmd */
+		ret = jornada_ssp_inout(SETBRIGHTNESS);
+		if (ret != TXDUMMY) {
+			printk(KERN_ERR "bl :set brightness timeout\n");
+		} else {
+			/* cmd accepted */
+			value = BL_MAX_BRIGHT - dev->props.brightness;
+			if (jornada_ssp_byte(value) == TXDUMMY)
+				ret = value;
+			else
+				printk(KERN_ERR "bl :set brightness failed\n");
+		}
+	}
+
+	jornada_ssp_end();
+
+	return ret;
+}
+
+/*
+ * LCD HANDLING FUNCTIONS
+ */
+static int jornada_lcd_set_contrast(struct lcd_device *pdev, int contrast)
+{
+	int ret = 0;
+
+	jornada_ssp_start();
+
+	ret = jornada_ssp_inout(SETCONTRAST);
+
+	if (ret == -ETIMEDOUT)
+		printk(KERN_ERR "lcd :set contrast timeout\n");
+	else
+		ret = jornada_ssp_byte(contrast);
+
+	jornada_ssp_end();
+
+	return ret;
+}
+
+static int jornada_lcd_set_power(struct lcd_device  *pdev, int power)
+{
+	if (power != FB_BLANK_UNBLANK) {
+		/* turn off LCD */
+		PPSR &= ~PPC_LDD2;
+		PPDR |= PPC_LDD2;
+	} else {
+		/* turn on LCD */
+		PPSR |= PPC_LDD2;
+	}
+
+	return 0;
+}
+
+static int jornada_lcd_get_power(struct lcd_device *pdev)
+{
+	if (PPSR & PPC_LDD2)
+		return FB_BLANK_UNBLANK;
+	else
+		return FB_BLANK_POWERDOWN;
+}
+
+static int jornada_lcd_get_contrast(struct lcd_device *pdev)
+{
+	int ret;
+
+	/* Don't set contrast on off powerd LCD */
+	if (jornada_lcd_get_power(pdev) != FB_BLANK_UNBLANK)
+		return 0;
+
+	jornada_ssp_start();
+
+	ret = jornada_ssp_inout(GETCONTRAST);
+	if (ret != -ETIMEDOUT)
+		ret = jornada_ssp_inout(TXDUMMY);
+	else {
+		printk(KERN_ERR "lcd :get contrast timeout\n");
+		ret = -1;
+	}
+
+	jornada_ssp_end();
+
+	return ret;
+}
+
+static struct backlight_ops jornada_bl_ops = {
+	.get_brightness = jornada_bl_get_brightness,
+	.update_status = jornada_bl_update_status,
+};
+
+static struct lcd_ops jornada_lcd_ops = {
+	.get_contrast = jornada_lcd_get_contrast,
+	.set_contrast = jornada_lcd_set_contrast,
+	.get_power = jornada_lcd_get_power,
+	.set_power = jornada_lcd_set_power,
+};
+
+static int jornada_bl_probe(struct platform_device *pdev)
+{
+	struct bllcd_device *bllcd;
+
+	bllcd = kzalloc(sizeof(*bllcd), GFP_KERNEL);
+	if (bllcd == NULL)
+		return -ENOMEM;
+
+	/* bl driver - name must match fb driver name */
+	bllcd->bl_device = backlight_device_register(S1D_DEVICENAME,
+	&pdev->dev, NULL, &jornada_bl_ops);
+
+	if (IS_ERR(bllcd->bl_device)) {
+		kfree(bllcd);
+		printk(KERN_ERR "bl :failed to register device\n");
+		return -ENODEV;
+	}
+
+	/* lcd driver */
+	bllcd->lcd_device = lcd_device_register(S1D_DEVICENAME,
+				&pdev->dev, NULL, &jornada_lcd_ops);
+	if (IS_ERR(bllcd->lcd_device)) {
+		backlight_device_unregister(bllcd->bl_device);
+		kfree(bllcd);
+		printk(KERN_ERR "lcd :failed to register device\n");
+		return -ENODEV;
+	}
+
+	jornada_lcd_set_contrast(bllcd->lcd_device, LCD_DEF_CONTR);
+	jornada_lcd_set_power(bllcd->lcd_device, FB_BLANK_UNBLANK);
+
+	msleep(100);
+
+	bllcd->bl_device->props.power = FB_BLANK_UNBLANK;
+	bllcd->bl_device->props.brightness = BL_DEF_BRIGHT;
+	jornada_bl_update_status(bllcd->bl_device);
+
+	platform_set_drvdata(pdev, bllcd);
+	printk(KERN_INFO "HP Jornada 7xx Backlight/LCD driver activated\n");
+
+	return 0;
+}
+
+static int jornada_bl_remove(struct platform_device *pdev)
+{
+	struct bllcd_device *bllcd = platform_get_drvdata(pdev);
+
+	bllcd->bl_device->props.power = FB_BLANK_POWERDOWN;
+	bllcd->bl_device->props.brightness = 0;
+	bllcd->bl_device->props.max_brightness = 0;
+
+	backlight_device_unregister(bllcd->bl_device);
+	lcd_device_unregister(bllcd->lcd_device);
+
+	return 0;
+}
+
+static int jornada_bl_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct bllcd_device *bllcd = platform_get_drvdata(pdev);
+
+	bllcd->bl_device->props.power = FB_BLANK_POWERDOWN;
+	bllcd->bl_device->props.brightness = 0;
+	bllcd->bl_device->props.max_brightness = 0;
+	jornada_bl_update_status(bllcd->bl_device);
+
+	jornada_lcd_set_power(bllcd->lcd_device, FB_BLANK_POWERDOWN);
+
+	return 0;
+}
+
+static int jornada_bl_resume(struct platform_device *pdev)
+{
+	struct bllcd_device *bllcd = platform_get_drvdata(pdev);
+
+	bllcd->bl_device->props.power = FB_BLANK_UNBLANK;
+	bllcd->bl_device->props.brightness = BL_DEF_BRIGHT;
+	bllcd->bl_device->props.max_brightness = BL_MAX_BRIGHT;
+	jornada_bl_update_status(bllcd->bl_device);
+
+	jornada_lcd_set_power(bllcd->lcd_device, FB_BLANK_UNBLANK);
+
+	return 0;
+}
+
+static struct platform_driver jornada_bl_driver = {
+	.probe	= jornada_bl_probe,
+	.remove	= jornada_bl_remove,
+#ifdef CONFIG_PM
+	.suspend = jornada_bl_suspend,
+	.resume = jornada_bl_resume,
+#endif
+	.driver = {
+	    .name = "jornada_bllcd",
+	},
+};
+
+static int __init jornada_bl_init(void)
+{
+	return platform_driver_register(&jornada_bl_driver);
+}
+
+static void __exit jornada_bl_exit(void)
+{
+	platform_driver_unregister(&jornada_bl_driver);
+}
+
+module_init(jornada_bl_init);
+module_exit(jornada_bl_exit);





On Wed, 6 Feb 2008 16:44:36 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Wed, Feb 06, 2008 at 05:33:41PM +0100, Kristoffer Ericson wrote:
> > Oki, here is attempt #2 (btw, new mail or just keep thread?)
> 
> Probably better to keep the thread.  More comments 8)
> 
> > +struct jornada_bllcd_device {
> > +	struct backlight_device *jorn_backlight_device;
> > +	struct lcd_device *jorn_lcd_device;
> 
> We're inside a jornada file.  Do these "jorn_" prefixes add anything
> useful that the reader doesn't already know?
> 
> > +static int jornada_bl_update_status(struct backlight_device *dev)
> > +{
> > +	int ret = 0;
> > +
> > +	jornada_ssp_start();
> > +
> > +	if (dev->props.power != FB_BLANK_UNBLANK ||
> > +		dev->props.fb_blank != FB_BLANK_UNBLANK) {
> > +		ret = jornada_ssp_inout(BRIGHTNESSOFF);
> > +		if (ret == -ETIMEDOUT)
> > +			printk(KERN_ERR "jornada720_bl:	\
> > +				BrightnessOff timeout\n");
> > +			/* backlight off */
> > +			PPSR &= ~PPC_LDD1;
> > +			PPDR |= PPC_LDD1;
> 
> Look at the above 5 lines.  What are your expectations if ret != -ETIMEDOUT?
> If C were python you'd have one behaviour due to the indent...
> 
> > +
> > +	} else	{	/* backlight on */
> 
> Too many spaces.
> 
> > +			PPSR |= PPC_LDD1;
> > +			if ((jornada_ssp_inout(SETBRIGHTNESS)) == TXDUMMY) {
> > +			    /* send brightness value (0 is max, 255 lowest) */
> > +				if (jornada_ssp_byte(JORNADA_BL_MAX_BRIGHTNESS -
> > +					 dev->props.brightness) != -ETIMEDOUT)
> > +				ret = (JORNADA_BL_MAX_BRIGHTNESS -
> > +					dev->props.brightness);
> > +			} else
> > +				printk(KERN_ERR "jornada720_bl:	\
> > +					SetBrightness timeout\n");
> > +		}
> 
> If this corresponds with the "} else {" line, it should have one tab.  Plus
> the above indented code section should probably have one less indentation.
> 
> > +	jornada_ssp_end();
> > +
> > +	return ret;
> > +}
> > +
> > +/*
> > + * LCD HANDLING FUNCTIONS
> > + */
> > +static int jornada_lcd_set_contrast(struct lcd_device *pdev, int contrast)
> > +{
> > +	int ret = 0;
> > +
> > +	jornada_ssp_start();
> > +
> > +	ret = jornada_ssp_inout(SETCONTRAST);
> > +
> > +	if (ret == -ETIMEDOUT)
> > +		printk(KERN_ERR "jornada_lcd: failure to set contrast\n");
> > +	 else
> 
> Space before 'else' not required.
> 
> > +		ret = jornada_ssp_byte(contrast);
> > +
> > +	jornada_ssp_end();
> > +
> > +	return ret;
> > +}
> > +
> > +static int jornada_lcd_set_power(struct lcd_device  *pdev, int power)
> > +{
> > +	if (power != FB_BLANK_UNBLANK) {
> > +		/* turn off LCD */
> > +		PPSR &= ~PPC_LDD2;
> > +		PPDR |= PPC_LDD2;
> > +	} else {
> > +		/* turn on LCD */
> > +		PPSR |= PPC_LDD2;
> > +		}
> 
> Wrongly placed }
> 
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_lcd_get_power(struct lcd_device *pdev)
> > +{
> > +	if (PPSR & PPC_LDD2)
> > +		return FB_BLANK_UNBLANK;
> > +	else
> > +		return FB_BLANK_POWERDOWN;
> > +}
> > +
> > +static int jornada_lcd_get_contrast(struct lcd_device *pdev)
> > +{
> > +	int ret;
> > +
> > +	/* Don't set contrast on off powerd LCD */
> > +	if (jornada_lcd_get_power(pdev) != FB_BLANK_UNBLANK)
> > +		return 0;
> > +
> > +	jornada_ssp_start();
> > +
> > +	ret = jornada_ssp_inout(GETCONTRAST);
> > +	if (ret != -ETIMEDOUT)
> > +		ret = jornada_ssp_inout(TXDUMMY);
> > +	else {
> > +		printk(KERN_ERR "jornada_lcd: getcontrast failed!\n");
> > +		ret = JORNADA_BL_MAX_BRIGHTNESS + 1;
> > +	}
> > +
> > +	jornada_ssp_end();
> > +
> > +	return ret;
> > +}
> > +
> > +static struct backlight_ops jornada_bl_ops = {
> > +	.get_brightness = jornada_bl_get_brightness,
> > +	.update_status = jornada_bl_update_status,
> > +};
> > +
> > +static struct lcd_ops jornada_lcd_ops = {
> > +	.get_contrast = jornada_lcd_get_contrast,
> > +	.set_contrast = jornada_lcd_set_contrast,
> > +	.get_power = jornada_lcd_get_power,
> > +	.set_power = jornada_lcd_set_power,
> > +};
> > +
> > +static int jornada_bl_probe(struct platform_device *pdev)
> > +{
> > +	struct jornada_bllcd_device *bllcd;
> > +
> > +	bllcd = kzalloc(sizeof(*bllcd), GFP_KERNEL);
> > +	if (bllcd == NULL)
> > +		return -ENOMEM;
> > +
> > +	/* bl driver - name must match fb driver name */
> > +	bllcd->jorn_backlight_device = backlight_device_register(S1D_DEVICENAME,
> > +		&pdev->dev, NULL, &jornada_bl_ops);
> > +
> > +	if (IS_ERR(bllcd->jorn_backlight_device)) {
> > +		kfree(bllcd);
> > +		return PTR_ERR(bllcd->jorn_backlight_device);
> 
> Access after free.  Bad bad bad.
> 
> > +	}
> > +
> > +	/* lcd driver */
> > +	bllcd->jorn_lcd_device = lcd_device_register(S1D_DEVICENAME,
> > +				&pdev->dev, NULL, &jornada_lcd_ops);
> > +	if (IS_ERR(bllcd->jorn_lcd_device)) {
> > +		kfree(bllcd);
> > +		return PTR_ERR(bllcd->jorn_lcd_device);
> 
> Access after free.  Bad bad bad.
> 
> > +	}
> > +
> > +	jornada_lcd_set_contrast(bllcd->jorn_lcd_device,
> > +			JORNADA_LCD_DEFAULT_CONTRAST);
> > +	jornada_lcd_set_power(bllcd->jorn_lcd_device,
> > +			FB_BLANK_UNBLANK);
> > +
> > +	msleep(100);
> > +
> > +	bllcd->jorn_backlight_device->props.power
> > +		= FB_BLANK_UNBLANK;
> > +	bllcd->jorn_backlight_device->props.brightness
> > +		= JORNADA_BL_DEFAULT_BRIGHTNESS;
> 
> If you get rid of the "jorn_" prefix, can these be on one line?
> 
> > +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> > +
> > +	platform_set_drvdata(pdev, bllcd);
> > +	printk(KERN_INFO "HP Jornada 7xx Backlight/LCD driver activated\n");
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_bl_remove(struct platform_device *pdev)
> > +{
> > +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> > +
> > +	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
> > +	bllcd->jorn_backlight_device->props.brightness = 0;
> > +	bllcd->jorn_backlight_device->props.max_brightness = 0;
> > +
> > +	backlight_device_unregister(bllcd->jorn_backlight_device);
> > +	lcd_device_unregister(bllcd->jorn_lcd_device);
> 
> Leaves bllcd allocated - memory leak.
> 
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_bl_suspend(struct platform_device *pdev, pm_message_t state)
> > +{
> > +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> > +
> > +	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
> > +	bllcd->jorn_backlight_device->props.brightness = 0;
> > +	bllcd->jorn_backlight_device->props.max_brightness = 0;
> > +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> > +
> > +	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_POWERDOWN);
> > +
> > +	return 0;
> > +}
> > +
> > +static int jornada_bl_resume(struct platform_device *pdev)
> > +{
> > +	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
> > +
> > +	bllcd->jorn_backlight_device->props.power
> > +		= FB_BLANK_UNBLANK;
> > +	bllcd->jorn_backlight_device->props.brightness
> > +		= JORNADA_BL_DEFAULT_BRIGHTNESS;
> > +	bllcd->jorn_backlight_device->props.max_brightness
> > +		= JORNADA_BL_MAX_BRIGHTNESS;
> > +	jornada_bl_update_status(bllcd->jorn_backlight_device);
> > +
> > +	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_UNBLANK);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct platform_driver jornada_bl_driver = {
> > +	.probe	= jornada_bl_probe,
> > +	.remove	= jornada_bl_remove,
> > +#ifdef CONFIG_PM
> > +	.suspend = jornada_bl_suspend,
> > +	.resume = jornada_bl_resume,
> > +#endif
> > +	.driver = {
> > +	    .name = "jornada_bllcd",
> 
> a tab, not 4 spaces.
> 

--Multipart=_Wed__6_Feb_2008_20_21_28_+0100_.5WIE8oTcBNPV+zT
Content-Type: application/octet-stream;
 name="jornada720_bllcd.patch"
Content-Disposition: attachment;
 filename="jornada720_bllcd.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmxsY2QuYyBi
L2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmxsY2QuYwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwLi4wYWRiYzQ5Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy92aWRlby9iYWNrbGlnaHQvam9ybmFkYTcyMF9ibGxjZC5jCkBAIC0wLDAgKzEsMjg3IEBACisv
KgorICoKKyAqIEJhY2tsaWdodCBhbmQgTENEIERyaXZlciBmb3IgSFAgSm9ybmFkYSA3MjAKKyAq
IENvcHlyaWdodCAoQykgMjAwNyBLcmlzdG9mZmVyIEVyaWNzb24gPEtyaXN0b2ZmZXIuRXJpY3Nv
bkBnbWFpbC5jb20+CisgKgorICogVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBj
YW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBv
ZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgdmVyc2lvbiAyCisgKiBvciBhbnkgbGF0
ZXIgdmVyc2lvbiBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4K
KyAqCisgKi8KKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9rZXJu
ZWwuaD4KKyNpbmNsdWRlIDxsaW51eC9pbml0Lmg+CisjaW5jbHVkZSA8bGludXgvYmFja2xpZ2h0
Lmg+CisjaW5jbHVkZSA8bGludXgvbGNkLmg+CisjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4KKyNp
bmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4KKyNpbmNsdWRlIDxsaW51eC9mYi5oPgor
I2luY2x1ZGUgPGxpbnV4L2RldmljZS5oPgorI2luY2x1ZGUgPGFzbS9oYXJkd2FyZS5oPgorI2lu
Y2x1ZGUgPGFzbS9hcmNoL2pvcm5hZGE3MjAuaD4KKyNpbmNsdWRlIDx2aWRlby9zMWQxM3h4eGZi
Lmg+CisKK01PRFVMRV9BVVRIT1IoIktyaXN0b2ZmZXIgRXJpY3NvbiA8a3Jpc3RvZmZlci5lcmlj
c29uQGdtYWlsLmNvbT4iKTsKK01PRFVMRV9ERVNDUklQVElPTigiSFAgSm9ybmFkYSA3MTAvNzIw
LzcyOCBCYWNrbGlnaHQvTENEIERyaXZlciIpOworTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOworCisv
KiBDb250cmFzdCAqLworI2RlZmluZSBMQ0RfTUFYX0NPTlRSCTB4ZmYKKyNkZWZpbmUgTENEX0RF
Rl9DT05UUgkweDgwCisvKiBCcmlnaHRuZXNzICovCisjZGVmaW5lIEJMX01BWF9CUklHSFQJMHhm
ZgorI2RlZmluZSBCTF9ERUZfQlJJR0hUCTB4MTkKKworc3RydWN0IGJsbGNkX2RldmljZSB7CisJ
c3RydWN0IGJhY2tsaWdodF9kZXZpY2UgKmJsX2RldmljZTsKKwlzdHJ1Y3QgbGNkX2RldmljZSAq
bGNkX2RldmljZTsKK307CisKKy8qCisgKiBCQUNLTElHSFQgSEFORExJTkcgUk9VVElORVMKKyAq
Lworc3RhdGljIGludCBqb3JuYWRhX2JsX2dldF9icmlnaHRuZXNzKHN0cnVjdCBiYWNrbGlnaHRf
ZGV2aWNlICpkZXYpCit7CisJaW50IHJldDsKKworCS8qIGNoZWNrIGlmIGJhY2tsaWdodCBpcyBv
biAqLworCWlmICghKFBQU1IgJiBQUENfTEREMSkpCisJCXJldHVybiBCTF9NQVhfQlJJR0hUOwor
CisJam9ybmFkYV9zc3Bfc3RhcnQoKTsKKwlpZiAoam9ybmFkYV9zc3BfaW5vdXQoR0VUQlJJR0hU
TkVTUykgPT0gLUVUSU1FRE9VVCkgeworCQlwcmludGsoS0VSTl9FUlIgImJsIDpnZXQgYnJpZ2h0
bmVzcyB0aW1lb3V0XG4iKTsKKwkJcmV0ID0gLTE7CisJfSBlbHNlCisJCXJldCA9IGpvcm5hZGFf
c3NwX2lub3V0KFRYRFVNTVkpOworCisJam9ybmFkYV9zc3BfZW5kKCk7CisKKwkvKiAwIGlzIG1h
eCBicmlnaHRuZXNzICovCisJcmV0dXJuIEJMX01BWF9CUklHSFQgLSByZXQ7Cit9CisKK3N0YXRp
YyBpbnQgam9ybmFkYV9ibF91cGRhdGVfc3RhdHVzKHN0cnVjdCBiYWNrbGlnaHRfZGV2aWNlICpk
ZXYpCit7CisJaW50IHJldCA9IDA7CisJaW50IHZhbHVlOworCisJam9ybmFkYV9zc3Bfc3RhcnQo
KTsKKworCWlmIChkZXYtPnByb3BzLnBvd2VyICE9IEZCX0JMQU5LX1VOQkxBTksgfHwKKwlkZXYt
PnByb3BzLmZiX2JsYW5rICE9IEZCX0JMQU5LX1VOQkxBTkspIHsKKwkJcmV0ID0gam9ybmFkYV9z
c3BfaW5vdXQoQlJJR0hUTkVTU09GRik7CisJCWlmIChyZXQgPT0gLUVUSU1FRE9VVCkgeworCQkJ
cHJpbnRrKEtFUk5fRVJSICJibCA6IGJyaWdodG5lc3Mgb2ZmIHRpbWVvdXRcbiIpOworCQkJLyog
YmFja2xpZ2h0IG9mZiAqLworCQkJUFBTUiAmPSB+UFBDX0xERDE7CisJCQlQUERSIHw9IFBQQ19M
REQxOworCQl9CisJfSBlbHNlIHsgLyogYmFja2xpZ2h0IG9uICovCisJCVBQU1IgfD0gUFBDX0xE
RDE7CisJCS8qIHNlbmQgc2V0YnJpZ2h0bmVzcyBjbWQgKi8KKwkJcmV0ID0gam9ybmFkYV9zc3Bf
aW5vdXQoU0VUQlJJR0hUTkVTUyk7CisJCWlmIChyZXQgIT0gVFhEVU1NWSkgeworCQkJcHJpbnRr
KEtFUk5fRVJSICJibCA6c2V0IGJyaWdodG5lc3MgdGltZW91dFxuIik7CisJCX0gZWxzZSB7CisJ
CQkvKiBjbWQgYWNjZXB0ZWQgKi8KKwkJCXZhbHVlID0gQkxfTUFYX0JSSUdIVCAtIGRldi0+cHJv
cHMuYnJpZ2h0bmVzczsKKwkJCWlmIChqb3JuYWRhX3NzcF9ieXRlKHZhbHVlKSA9PSBUWERVTU1Z
KQorCQkJCXJldCA9IHZhbHVlOworCQkJZWxzZQorCQkJCXByaW50ayhLRVJOX0VSUiAiYmwgOnNl
dCBicmlnaHRuZXNzIGZhaWxlZFxuIik7CisJCX0KKwl9CisKKwlqb3JuYWRhX3NzcF9lbmQoKTsK
KworCXJldHVybiByZXQ7Cit9CisKKy8qCisgKiBMQ0QgSEFORExJTkcgRlVOQ1RJT05TCisgKi8K
K3N0YXRpYyBpbnQgam9ybmFkYV9sY2Rfc2V0X2NvbnRyYXN0KHN0cnVjdCBsY2RfZGV2aWNlICpw
ZGV2LCBpbnQgY29udHJhc3QpCit7CisJaW50IHJldCA9IDA7CisKKwlqb3JuYWRhX3NzcF9zdGFy
dCgpOworCisJcmV0ID0gam9ybmFkYV9zc3BfaW5vdXQoU0VUQ09OVFJBU1QpOworCisJaWYgKHJl
dCA9PSAtRVRJTUVET1VUKQorCQlwcmludGsoS0VSTl9FUlIgImxjZCA6c2V0IGNvbnRyYXN0IHRp
bWVvdXRcbiIpOworCWVsc2UKKwkJcmV0ID0gam9ybmFkYV9zc3BfYnl0ZShjb250cmFzdCk7CisK
Kwlqb3JuYWRhX3NzcF9lbmQoKTsKKworCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBpbnQgam9y
bmFkYV9sY2Rfc2V0X3Bvd2VyKHN0cnVjdCBsY2RfZGV2aWNlICAqcGRldiwgaW50IHBvd2VyKQor
eworCWlmIChwb3dlciAhPSBGQl9CTEFOS19VTkJMQU5LKSB7CisJCS8qIHR1cm4gb2ZmIExDRCAq
LworCQlQUFNSICY9IH5QUENfTEREMjsKKwkJUFBEUiB8PSBQUENfTEREMjsKKwl9IGVsc2Ugewor
CQkvKiB0dXJuIG9uIExDRCAqLworCQlQUFNSIHw9IFBQQ19MREQyOworCX0KKworCXJldHVybiAw
OworfQorCitzdGF0aWMgaW50IGpvcm5hZGFfbGNkX2dldF9wb3dlcihzdHJ1Y3QgbGNkX2Rldmlj
ZSAqcGRldikKK3sKKwlpZiAoUFBTUiAmIFBQQ19MREQyKQorCQlyZXR1cm4gRkJfQkxBTktfVU5C
TEFOSzsKKwllbHNlCisJCXJldHVybiBGQl9CTEFOS19QT1dFUkRPV047Cit9CisKK3N0YXRpYyBp
bnQgam9ybmFkYV9sY2RfZ2V0X2NvbnRyYXN0KHN0cnVjdCBsY2RfZGV2aWNlICpwZGV2KQorewor
CWludCByZXQ7CisKKwkvKiBEb24ndCBzZXQgY29udHJhc3Qgb24gb2ZmIHBvd2VyZCBMQ0QgKi8K
KwlpZiAoam9ybmFkYV9sY2RfZ2V0X3Bvd2VyKHBkZXYpICE9IEZCX0JMQU5LX1VOQkxBTkspCisJ
CXJldHVybiAwOworCisJam9ybmFkYV9zc3Bfc3RhcnQoKTsKKworCXJldCA9IGpvcm5hZGFfc3Nw
X2lub3V0KEdFVENPTlRSQVNUKTsKKwlpZiAocmV0ICE9IC1FVElNRURPVVQpCisJCXJldCA9IGpv
cm5hZGFfc3NwX2lub3V0KFRYRFVNTVkpOworCWVsc2UgeworCQlwcmludGsoS0VSTl9FUlIgImxj
ZCA6Z2V0IGNvbnRyYXN0IHRpbWVvdXRcbiIpOworCQlyZXQgPSAtMTsKKwl9CisKKwlqb3JuYWRh
X3NzcF9lbmQoKTsKKworCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBzdHJ1Y3QgYmFja2xpZ2h0
X29wcyBqb3JuYWRhX2JsX29wcyA9IHsKKwkuZ2V0X2JyaWdodG5lc3MgPSBqb3JuYWRhX2JsX2dl
dF9icmlnaHRuZXNzLAorCS51cGRhdGVfc3RhdHVzID0gam9ybmFkYV9ibF91cGRhdGVfc3RhdHVz
LAorfTsKKworc3RhdGljIHN0cnVjdCBsY2Rfb3BzIGpvcm5hZGFfbGNkX29wcyA9IHsKKwkuZ2V0
X2NvbnRyYXN0ID0gam9ybmFkYV9sY2RfZ2V0X2NvbnRyYXN0LAorCS5zZXRfY29udHJhc3QgPSBq
b3JuYWRhX2xjZF9zZXRfY29udHJhc3QsCisJLmdldF9wb3dlciA9IGpvcm5hZGFfbGNkX2dldF9w
b3dlciwKKwkuc2V0X3Bvd2VyID0gam9ybmFkYV9sY2Rfc2V0X3Bvd2VyLAorfTsKKworc3RhdGlj
IGludCBqb3JuYWRhX2JsX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCit7CisJ
c3RydWN0IGJsbGNkX2RldmljZSAqYmxsY2Q7CisKKwlibGxjZCA9IGt6YWxsb2Moc2l6ZW9mKCpi
bGxjZCksIEdGUF9LRVJORUwpOworCWlmIChibGxjZCA9PSBOVUxMKQorCQlyZXR1cm4gLUVOT01F
TTsKKworCS8qIGJsIGRyaXZlciAtIG5hbWUgbXVzdCBtYXRjaCBmYiBkcml2ZXIgbmFtZSAqLwor
CWJsbGNkLT5ibF9kZXZpY2UgPSBiYWNrbGlnaHRfZGV2aWNlX3JlZ2lzdGVyKFMxRF9ERVZJQ0VO
QU1FLAorCSZwZGV2LT5kZXYsIE5VTEwsICZqb3JuYWRhX2JsX29wcyk7CisKKwlpZiAoSVNfRVJS
KGJsbGNkLT5ibF9kZXZpY2UpKSB7CisJCWtmcmVlKGJsbGNkKTsKKwkJcHJpbnRrKEtFUk5fRVJS
ICJibCA6ZmFpbGVkIHRvIHJlZ2lzdGVyIGRldmljZVxuIik7CisJCXJldHVybiAtRU5PREVWOwor
CX0KKworCS8qIGxjZCBkcml2ZXIgKi8KKwlibGxjZC0+bGNkX2RldmljZSA9IGxjZF9kZXZpY2Vf
cmVnaXN0ZXIoUzFEX0RFVklDRU5BTUUsCisJCQkJJnBkZXYtPmRldiwgTlVMTCwgJmpvcm5hZGFf
bGNkX29wcyk7CisJaWYgKElTX0VSUihibGxjZC0+bGNkX2RldmljZSkpIHsKKwkJYmFja2xpZ2h0
X2RldmljZV91bnJlZ2lzdGVyKGJsbGNkLT5ibF9kZXZpY2UpOworCQlrZnJlZShibGxjZCk7CisJ
CXByaW50ayhLRVJOX0VSUiAibGNkIDpmYWlsZWQgdG8gcmVnaXN0ZXIgZGV2aWNlXG4iKTsKKwkJ
cmV0dXJuIC1FTk9ERVY7CisJfQorCisJam9ybmFkYV9sY2Rfc2V0X2NvbnRyYXN0KGJsbGNkLT5s
Y2RfZGV2aWNlLCBMQ0RfREVGX0NPTlRSKTsKKwlqb3JuYWRhX2xjZF9zZXRfcG93ZXIoYmxsY2Qt
PmxjZF9kZXZpY2UsIEZCX0JMQU5LX1VOQkxBTkspOworCisJbXNsZWVwKDEwMCk7CisKKwlibGxj
ZC0+YmxfZGV2aWNlLT5wcm9wcy5wb3dlciA9IEZCX0JMQU5LX1VOQkxBTks7CisJYmxsY2QtPmJs
X2RldmljZS0+cHJvcHMuYnJpZ2h0bmVzcyA9IEJMX0RFRl9CUklHSFQ7CisJam9ybmFkYV9ibF91
cGRhdGVfc3RhdHVzKGJsbGNkLT5ibF9kZXZpY2UpOworCisJcGxhdGZvcm1fc2V0X2RydmRhdGEo
cGRldiwgYmxsY2QpOworCXByaW50ayhLRVJOX0lORk8gIkhQIEpvcm5hZGEgN3h4IEJhY2tsaWdo
dC9MQ0QgZHJpdmVyIGFjdGl2YXRlZFxuIik7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGlu
dCBqb3JuYWRhX2JsX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQoreworCXN0
cnVjdCBibGxjZF9kZXZpY2UgKmJsbGNkID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7CisK
KwlibGxjZC0+YmxfZGV2aWNlLT5wcm9wcy5wb3dlciA9IEZCX0JMQU5LX1BPV0VSRE9XTjsKKwli
bGxjZC0+YmxfZGV2aWNlLT5wcm9wcy5icmlnaHRuZXNzID0gMDsKKwlibGxjZC0+YmxfZGV2aWNl
LT5wcm9wcy5tYXhfYnJpZ2h0bmVzcyA9IDA7CisKKwliYWNrbGlnaHRfZGV2aWNlX3VucmVnaXN0
ZXIoYmxsY2QtPmJsX2RldmljZSk7CisJbGNkX2RldmljZV91bnJlZ2lzdGVyKGJsbGNkLT5sY2Rf
ZGV2aWNlKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGpvcm5hZGFfYmxfc3VzcGVu
ZChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LCBwbV9tZXNzYWdlX3Qgc3RhdGUpCit7CisJ
c3RydWN0IGJsbGNkX2RldmljZSAqYmxsY2QgPSBwbGF0Zm9ybV9nZXRfZHJ2ZGF0YShwZGV2KTsK
KworCWJsbGNkLT5ibF9kZXZpY2UtPnByb3BzLnBvd2VyID0gRkJfQkxBTktfUE9XRVJET1dOOwor
CWJsbGNkLT5ibF9kZXZpY2UtPnByb3BzLmJyaWdodG5lc3MgPSAwOworCWJsbGNkLT5ibF9kZXZp
Y2UtPnByb3BzLm1heF9icmlnaHRuZXNzID0gMDsKKwlqb3JuYWRhX2JsX3VwZGF0ZV9zdGF0dXMo
YmxsY2QtPmJsX2RldmljZSk7CisKKwlqb3JuYWRhX2xjZF9zZXRfcG93ZXIoYmxsY2QtPmxjZF9k
ZXZpY2UsIEZCX0JMQU5LX1BPV0VSRE9XTik7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGlu
dCBqb3JuYWRhX2JsX3Jlc3VtZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQoreworCXN0
cnVjdCBibGxjZF9kZXZpY2UgKmJsbGNkID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7CisK
KwlibGxjZC0+YmxfZGV2aWNlLT5wcm9wcy5wb3dlciA9IEZCX0JMQU5LX1VOQkxBTks7CisJYmxs
Y2QtPmJsX2RldmljZS0+cHJvcHMuYnJpZ2h0bmVzcyA9IEJMX0RFRl9CUklHSFQ7CisJYmxsY2Qt
PmJsX2RldmljZS0+cHJvcHMubWF4X2JyaWdodG5lc3MgPSBCTF9NQVhfQlJJR0hUOworCWpvcm5h
ZGFfYmxfdXBkYXRlX3N0YXR1cyhibGxjZC0+YmxfZGV2aWNlKTsKKworCWpvcm5hZGFfbGNkX3Nl
dF9wb3dlcihibGxjZC0+bGNkX2RldmljZSwgRkJfQkxBTktfVU5CTEFOSyk7CisKKwlyZXR1cm4g
MDsKK30KKworc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgam9ybmFkYV9ibF9kcml2ZXIg
PSB7CisJLnByb2JlCT0gam9ybmFkYV9ibF9wcm9iZSwKKwkucmVtb3ZlCT0gam9ybmFkYV9ibF9y
ZW1vdmUsCisjaWZkZWYgQ09ORklHX1BNCisJLnN1c3BlbmQgPSBqb3JuYWRhX2JsX3N1c3BlbmQs
CisJLnJlc3VtZSA9IGpvcm5hZGFfYmxfcmVzdW1lLAorI2VuZGlmCisJLmRyaXZlciA9IHsKKwkg
ICAgLm5hbWUgPSAiam9ybmFkYV9ibGxjZCIsCisJfSwKK307CisKK3N0YXRpYyBpbnQgX19pbml0
IGpvcm5hZGFfYmxfaW5pdCh2b2lkKQoreworCXJldHVybiBwbGF0Zm9ybV9kcml2ZXJfcmVnaXN0
ZXIoJmpvcm5hZGFfYmxfZHJpdmVyKTsKK30KKworc3RhdGljIHZvaWQgX19leGl0IGpvcm5hZGFf
YmxfZXhpdCh2b2lkKQoreworCXBsYXRmb3JtX2RyaXZlcl91bnJlZ2lzdGVyKCZqb3JuYWRhX2Js
X2RyaXZlcik7Cit9CisKK21vZHVsZV9pbml0KGpvcm5hZGFfYmxfaW5pdCk7Cittb2R1bGVfZXhp
dChqb3JuYWRhX2JsX2V4aXQpOwo=

--Multipart=_Wed__6_Feb_2008_20_21_28_+0100_.5WIE8oTcBNPV+zT--
