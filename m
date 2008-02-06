Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYBFQeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYBFQeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYBFQeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:34:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:4405 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYBFQeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:34:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:from;
        b=eVz1akv+SdHmqQ/Q8Pq9bVP5tvxmn52wAzEJoMwKTC/LOJnrj1+Gk18g0DtrxWB8OISNrjN/H/I2cNIvBFGWPGz7mlO2ZJlOmdXO97IMNYytpIya3pI5t7bJF2Cnpcg589145oXyRUfe21ZYhlEQ+ZqX5U5DOXO/K7SxdPVnS7k=
Date: Wed, 6 Feb 2008 17:33:41 +0100
To: Roel Kluin <12o3l@tiscali.nl>
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       Russell King <linux@arm.linux.org.uk>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
 Jornada 7xx handhelds
Message-Id: <20080206173341.619c52c8.Kristoffer.ericson@gmail.com>
In-Reply-To: <47A9AA4F.80508@tiscali.nl>
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com>
	<47A9A944.7090401@tiscali.nl>
	<47A9AA4F.80508@tiscali.nl>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__6_Feb_2008_17_33_41_+0100_zmSlnqkEcDuPui=w"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__6_Feb_2008_17_33_41_+0100_zmSlnqkEcDuPui=w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit


Oki, here is attempt #2 (btw, new mail or just keep thread?)

Tested to build and checkpatch.

diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c
new file mode 100644
index 0000000..e911a5e
--- /dev/null
+++ b/drivers/video/backlight/jornada720_bllcd.c
@@ -0,0 +1,286 @@
+/*
+ * drivers/video/backlight/jornada720_bllcd.c
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
+#define JORNADA_LCD_MAX_CONTRAST	0xff
+#define JORNADA_LCD_DEFAULT_CONTRAST	0x80
+#define JORNADA_BL_MAX_BRIGHTNESS	0xff
+#define JORNADA_BL_DEFAULT_BRIGHTNESS	0x19
+
+struct jornada_bllcd_device {
+	struct backlight_device *jorn_backlight_device;
+	struct lcd_device *jorn_lcd_device;
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
+		return JORNADA_BL_MAX_BRIGHTNESS;
+
+	jornada_ssp_start();
+	if (jornada_ssp_inout(GETBRIGHTNESS) == -ETIMEDOUT) {
+		printk(KERN_ERR "jornada720_bl: GetBrightness failed\n");
+		ret = JORNADA_BL_MAX_BRIGHTNESS + 1;
+	} else
+		ret = jornada_ssp_inout(TXDUMMY);
+
+	jornada_ssp_end();
+
+	/* 0 is max brightness */
+	return (JORNADA_BL_MAX_BRIGHTNESS - ret);
+}
+
+static int jornada_bl_update_status(struct backlight_device *dev)
+{
+	int ret = 0;
+
+	jornada_ssp_start();
+
+	if (dev->props.power != FB_BLANK_UNBLANK ||
+		dev->props.fb_blank != FB_BLANK_UNBLANK) {
+		ret = jornada_ssp_inout(BRIGHTNESSOFF);
+		if (ret == -ETIMEDOUT)
+			printk(KERN_ERR "jornada720_bl:	\
+				BrightnessOff timeout\n");
+			/* backlight off */
+			PPSR &= ~PPC_LDD1;
+			PPDR |= PPC_LDD1;
+
+	} else	{	/* backlight on */
+			PPSR |= PPC_LDD1;
+			if ((jornada_ssp_inout(SETBRIGHTNESS)) == TXDUMMY) {
+			    /* send brightness value (0 is max, 255 lowest) */
+				if (jornada_ssp_byte(JORNADA_BL_MAX_BRIGHTNESS -
+					 dev->props.brightness) != -ETIMEDOUT)
+				ret = (JORNADA_BL_MAX_BRIGHTNESS -
+					dev->props.brightness);
+			} else
+				printk(KERN_ERR "jornada720_bl:	\
+					SetBrightness timeout\n");
+		}
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
+		printk(KERN_ERR "jornada_lcd: failure to set contrast\n");
+	 else
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
+		}
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
+		printk(KERN_ERR "jornada_lcd: getcontrast failed!\n");
+		ret = JORNADA_BL_MAX_BRIGHTNESS + 1;
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
+	struct jornada_bllcd_device *bllcd;
+
+	bllcd = kzalloc(sizeof(*bllcd), GFP_KERNEL);
+	if (bllcd == NULL)
+		return -ENOMEM;
+
+	/* bl driver - name must match fb driver name */
+	bllcd->jorn_backlight_device = backlight_device_register(S1D_DEVICENAME,
+		&pdev->dev, NULL, &jornada_bl_ops);
+
+	if (IS_ERR(bllcd->jorn_backlight_device)) {
+		kfree(bllcd);
+		return PTR_ERR(bllcd->jorn_backlight_device);
+	}
+
+	/* lcd driver */
+	bllcd->jorn_lcd_device = lcd_device_register(S1D_DEVICENAME,
+				&pdev->dev, NULL, &jornada_lcd_ops);
+	if (IS_ERR(bllcd->jorn_lcd_device)) {
+		kfree(bllcd);
+		return PTR_ERR(bllcd->jorn_lcd_device);
+	}
+
+	jornada_lcd_set_contrast(bllcd->jorn_lcd_device,
+			JORNADA_LCD_DEFAULT_CONTRAST);
+	jornada_lcd_set_power(bllcd->jorn_lcd_device,
+			FB_BLANK_UNBLANK);
+
+	msleep(100);
+
+	bllcd->jorn_backlight_device->props.power
+		= FB_BLANK_UNBLANK;
+	bllcd->jorn_backlight_device->props.brightness
+		= JORNADA_BL_DEFAULT_BRIGHTNESS;
+	jornada_bl_update_status(bllcd->jorn_backlight_device);
+
+	platform_set_drvdata(pdev, bllcd);
+	printk(KERN_INFO "HP Jornada 7xx Backlight/LCD driver activated\n");
+
+	return 0;
+}
+
+static int jornada_bl_remove(struct platform_device *pdev)
+{
+	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
+
+	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
+	bllcd->jorn_backlight_device->props.brightness = 0;
+	bllcd->jorn_backlight_device->props.max_brightness = 0;
+
+	backlight_device_unregister(bllcd->jorn_backlight_device);
+	lcd_device_unregister(bllcd->jorn_lcd_device);
+
+	return 0;
+}
+
+static int jornada_bl_suspend(struct platform_device *pdev, pm_message_t state)
+{
+	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
+
+	bllcd->jorn_backlight_device->props.power = FB_BLANK_POWERDOWN;
+	bllcd->jorn_backlight_device->props.brightness = 0;
+	bllcd->jorn_backlight_device->props.max_brightness = 0;
+	jornada_bl_update_status(bllcd->jorn_backlight_device);
+
+	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_POWERDOWN);
+
+	return 0;
+}
+
+static int jornada_bl_resume(struct platform_device *pdev)
+{
+	struct jornada_bllcd_device *bllcd = platform_get_drvdata(pdev);
+
+	bllcd->jorn_backlight_device->props.power
+		= FB_BLANK_UNBLANK;
+	bllcd->jorn_backlight_device->props.brightness
+		= JORNADA_BL_DEFAULT_BRIGHTNESS;
+	bllcd->jorn_backlight_device->props.max_brightness
+		= JORNADA_BL_MAX_BRIGHTNESS;
+	jornada_bl_update_status(bllcd->jorn_backlight_device);
+
+	jornada_lcd_set_power(bllcd->jorn_lcd_device, FB_BLANK_UNBLANK);
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

On Wed, 06 Feb 2008 13:38:39 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:
> Roel Kluin wrote:
> > Kristoffer Ericson wrote:
> >> Greetings,
> >>
> >> Richard I've cleaned up the driver by checking with checkpatch.pl as Russell suggested. I would appreciate it if you could
> >> look through the patch again and give comments since the patch looks somewhat different.
> >>
> >> I can add patch for Kconfig/Makefile later on but suspect there will be some changes required before that.
> >>
> >> Oh and to answer your question regarding MAX/MIN values of the backlight, 0 = max and 255 = min. So we simply turn it around
> >> by returning 255 - value. Same thing when we need to set value.
> >>
> >> Best wishes
> >> Kristoffer Ericson
> >>
> >> diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c
> 
> >> +static int jornada_bl_get_brightness(struct backlight_device *dev)
> >> +{
> >> +	int ret;
> >> +
> >> +	/* check if backlight is on */
> >> +	if (!(PPSR & PPC_LDD1))
> >> +		return 255;
> > return JORNADA_BL_MAX_BRIGHTNESS;
> > 
> >> +
> >> +	jornada_ssp_start();
> >> +	if (jornada_ssp_inout(GETBRIGHTNESS) == -ETIMEDOUT) {
> >> +		printk(KERN_ERR "jornada720_bl: GetBrightness failed\n");
> >> +		ret = 256;
> > ret = JORNADA_BL_MAX_BRIGHTNESS + 1;
> >> +	} else
> >> +		ret = jornada_ssp_inout(TXDUMMY);
> 
> forgot to mention missing curly bracket here
> 
> >> +
> >> +	jornada_ssp_end();
> >> +
> >> +	/* 0 is max brightness */
> >> +	return (255 - ret);
> > return (JORNADA_BL_MAX_BRIGHTNESS - ret);
> >> +}

--Multipart=_Wed__6_Feb_2008_17_33_41_+0100_zmSlnqkEcDuPui=w
Content-Type: application/octet-stream;
 name="jornada720_bllcd.patch"
Content-Disposition: attachment;
 filename="jornada720_bllcd.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmxsY2QuYyBi
L2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmxsY2QuYwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwLi5lOTExYTVlCi0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy92aWRlby9iYWNrbGlnaHQvam9ybmFkYTcyMF9ibGxjZC5jCkBAIC0wLDAgKzEsMjg2IEBACisv
KgorICogZHJpdmVycy92aWRlby9iYWNrbGlnaHQvam9ybmFkYTcyMF9ibGxjZC5jCisgKgorICog
QmFja2xpZ2h0IGFuZCBMQ0QgRHJpdmVyIGZvciBIUCBKb3JuYWRhIDcyMAorICogQ29weXJpZ2h0
IChDKSAyMDA3IEtyaXN0b2ZmZXIgRXJpY3NvbiA8S3Jpc3RvZmZlci5Fcmljc29uQGdtYWlsLmNv
bT4KKyAqCisgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3Ry
aWJ1dGUgaXQgYW5kL29yIG1vZGlmeQorICogaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUg
R2VuZXJhbCBQdWJsaWMgTGljZW5zZSB2ZXJzaW9uIDIKKyAqIG9yIGFueSBsYXRlciB2ZXJzaW9u
IGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uLgorICoKKyAqLwor
I2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPgorI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2lu
Y2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNpbmNsdWRlIDxsaW51eC9iYWNrbGlnaHQuaD4KKyNpbmNs
dWRlIDxsaW51eC9sY2QuaD4KKyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgorI2luY2x1ZGUgPGxp
bnV4L3BsYXRmb3JtX2RldmljZS5oPgorI2luY2x1ZGUgPGxpbnV4L2ZiLmg+CisjaW5jbHVkZSA8
bGludXgvZGV2aWNlLmg+CisjaW5jbHVkZSA8YXNtL2hhcmR3YXJlLmg+CisjaW5jbHVkZSA8YXNt
L2FyY2gvam9ybmFkYTcyMC5oPgorI2luY2x1ZGUgPHZpZGVvL3MxZDEzeHh4ZmIuaD4KKworTU9E
VUxFX0FVVEhPUigiS3Jpc3RvZmZlciBFcmljc29uIDxrcmlzdG9mZmVyLmVyaWNzb25AZ21haWwu
Y29tPiIpOworTU9EVUxFX0RFU0NSSVBUSU9OKCJIUCBKb3JuYWRhIDcxMC83MjAvNzI4IEJhY2ts
aWdodC9MQ0QgRHJpdmVyIik7CitNT0RVTEVfTElDRU5TRSgiR1BMIik7CisKKyNkZWZpbmUgSk9S
TkFEQV9MQ0RfTUFYX0NPTlRSQVNUCTB4ZmYKKyNkZWZpbmUgSk9STkFEQV9MQ0RfREVGQVVMVF9D
T05UUkFTVAkweDgwCisjZGVmaW5lIEpPUk5BREFfQkxfTUFYX0JSSUdIVE5FU1MJMHhmZgorI2Rl
ZmluZSBKT1JOQURBX0JMX0RFRkFVTFRfQlJJR0hUTkVTUwkweDE5CisKK3N0cnVjdCBqb3JuYWRh
X2JsbGNkX2RldmljZSB7CisJc3RydWN0IGJhY2tsaWdodF9kZXZpY2UgKmpvcm5fYmFja2xpZ2h0
X2RldmljZTsKKwlzdHJ1Y3QgbGNkX2RldmljZSAqam9ybl9sY2RfZGV2aWNlOworfTsKKworLyoK
KyAqIEJBQ0tMSUdIVCBIQU5ETElORyBST1VUSU5FUworICovCitzdGF0aWMgaW50IGpvcm5hZGFf
YmxfZ2V0X2JyaWdodG5lc3Moc3RydWN0IGJhY2tsaWdodF9kZXZpY2UgKmRldikKK3sKKwlpbnQg
cmV0OworCisJLyogY2hlY2sgaWYgYmFja2xpZ2h0IGlzIG9uICovCisJaWYgKCEoUFBTUiAmIFBQ
Q19MREQxKSkKKwkJcmV0dXJuIEpPUk5BREFfQkxfTUFYX0JSSUdIVE5FU1M7CisKKwlqb3JuYWRh
X3NzcF9zdGFydCgpOworCWlmIChqb3JuYWRhX3NzcF9pbm91dChHRVRCUklHSFRORVNTKSA9PSAt
RVRJTUVET1VUKSB7CisJCXByaW50ayhLRVJOX0VSUiAiam9ybmFkYTcyMF9ibDogR2V0QnJpZ2h0
bmVzcyBmYWlsZWRcbiIpOworCQlyZXQgPSBKT1JOQURBX0JMX01BWF9CUklHSFRORVNTICsgMTsK
Kwl9IGVsc2UKKwkJcmV0ID0gam9ybmFkYV9zc3BfaW5vdXQoVFhEVU1NWSk7CisKKwlqb3JuYWRh
X3NzcF9lbmQoKTsKKworCS8qIDAgaXMgbWF4IGJyaWdodG5lc3MgKi8KKwlyZXR1cm4gKEpPUk5B
REFfQkxfTUFYX0JSSUdIVE5FU1MgLSByZXQpOworfQorCitzdGF0aWMgaW50IGpvcm5hZGFfYmxf
dXBkYXRlX3N0YXR1cyhzdHJ1Y3QgYmFja2xpZ2h0X2RldmljZSAqZGV2KQoreworCWludCByZXQg
PSAwOworCisJam9ybmFkYV9zc3Bfc3RhcnQoKTsKKworCWlmIChkZXYtPnByb3BzLnBvd2VyICE9
IEZCX0JMQU5LX1VOQkxBTksgfHwKKwkJZGV2LT5wcm9wcy5mYl9ibGFuayAhPSBGQl9CTEFOS19V
TkJMQU5LKSB7CisJCXJldCA9IGpvcm5hZGFfc3NwX2lub3V0KEJSSUdIVE5FU1NPRkYpOworCQlp
ZiAocmV0ID09IC1FVElNRURPVVQpCisJCQlwcmludGsoS0VSTl9FUlIgImpvcm5hZGE3MjBfYmw6
CVwKKwkJCQlCcmlnaHRuZXNzT2ZmIHRpbWVvdXRcbiIpOworCQkJLyogYmFja2xpZ2h0IG9mZiAq
LworCQkJUFBTUiAmPSB+UFBDX0xERDE7CisJCQlQUERSIHw9IFBQQ19MREQxOworCisJfSBlbHNl
CXsJLyogYmFja2xpZ2h0IG9uICovCisJCQlQUFNSIHw9IFBQQ19MREQxOworCQkJaWYgKChqb3Ju
YWRhX3NzcF9pbm91dChTRVRCUklHSFRORVNTKSkgPT0gVFhEVU1NWSkgeworCQkJICAgIC8qIHNl
bmQgYnJpZ2h0bmVzcyB2YWx1ZSAoMCBpcyBtYXgsIDI1NSBsb3dlc3QpICovCisJCQkJaWYgKGpv
cm5hZGFfc3NwX2J5dGUoSk9STkFEQV9CTF9NQVhfQlJJR0hUTkVTUyAtCisJCQkJCSBkZXYtPnBy
b3BzLmJyaWdodG5lc3MpICE9IC1FVElNRURPVVQpCisJCQkJcmV0ID0gKEpPUk5BREFfQkxfTUFY
X0JSSUdIVE5FU1MgLQorCQkJCQlkZXYtPnByb3BzLmJyaWdodG5lc3MpOworCQkJfSBlbHNlCisJ
CQkJcHJpbnRrKEtFUk5fRVJSICJqb3JuYWRhNzIwX2JsOglcCisJCQkJCVNldEJyaWdodG5lc3Mg
dGltZW91dFxuIik7CisJCX0KKwlqb3JuYWRhX3NzcF9lbmQoKTsKKworCXJldHVybiByZXQ7Cit9
CisKKy8qCisgKiBMQ0QgSEFORExJTkcgRlVOQ1RJT05TCisgKi8KK3N0YXRpYyBpbnQgam9ybmFk
YV9sY2Rfc2V0X2NvbnRyYXN0KHN0cnVjdCBsY2RfZGV2aWNlICpwZGV2LCBpbnQgY29udHJhc3Qp
Cit7CisJaW50IHJldCA9IDA7CisKKwlqb3JuYWRhX3NzcF9zdGFydCgpOworCisJcmV0ID0gam9y
bmFkYV9zc3BfaW5vdXQoU0VUQ09OVFJBU1QpOworCisJaWYgKHJldCA9PSAtRVRJTUVET1VUKQor
CQlwcmludGsoS0VSTl9FUlIgImpvcm5hZGFfbGNkOiBmYWlsdXJlIHRvIHNldCBjb250cmFzdFxu
Iik7CisJIGVsc2UKKwkJcmV0ID0gam9ybmFkYV9zc3BfYnl0ZShjb250cmFzdCk7CisKKwlqb3Ju
YWRhX3NzcF9lbmQoKTsKKworCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBpbnQgam9ybmFkYV9s
Y2Rfc2V0X3Bvd2VyKHN0cnVjdCBsY2RfZGV2aWNlICAqcGRldiwgaW50IHBvd2VyKQoreworCWlm
IChwb3dlciAhPSBGQl9CTEFOS19VTkJMQU5LKSB7CisJCS8qIHR1cm4gb2ZmIExDRCAqLworCQlQ
UFNSICY9IH5QUENfTEREMjsKKwkJUFBEUiB8PSBQUENfTEREMjsKKwl9IGVsc2UgeworCQkvKiB0
dXJuIG9uIExDRCAqLworCQlQUFNSIHw9IFBQQ19MREQyOworCQl9CisKKwlyZXR1cm4gMDsKK30K
Kworc3RhdGljIGludCBqb3JuYWRhX2xjZF9nZXRfcG93ZXIoc3RydWN0IGxjZF9kZXZpY2UgKnBk
ZXYpCit7CisJaWYgKFBQU1IgJiBQUENfTEREMikKKwkJcmV0dXJuIEZCX0JMQU5LX1VOQkxBTks7
CisJZWxzZQorCQlyZXR1cm4gRkJfQkxBTktfUE9XRVJET1dOOworfQorCitzdGF0aWMgaW50IGpv
cm5hZGFfbGNkX2dldF9jb250cmFzdChzdHJ1Y3QgbGNkX2RldmljZSAqcGRldikKK3sKKwlpbnQg
cmV0OworCisJLyogRG9uJ3Qgc2V0IGNvbnRyYXN0IG9uIG9mZiBwb3dlcmQgTENEICovCisJaWYg
KGpvcm5hZGFfbGNkX2dldF9wb3dlcihwZGV2KSAhPSBGQl9CTEFOS19VTkJMQU5LKQorCQlyZXR1
cm4gMDsKKworCWpvcm5hZGFfc3NwX3N0YXJ0KCk7CisKKwlyZXQgPSBqb3JuYWRhX3NzcF9pbm91
dChHRVRDT05UUkFTVCk7CisJaWYgKHJldCAhPSAtRVRJTUVET1VUKQorCQlyZXQgPSBqb3JuYWRh
X3NzcF9pbm91dChUWERVTU1ZKTsKKwllbHNlIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJqb3JuYWRh
X2xjZDogZ2V0Y29udHJhc3QgZmFpbGVkIVxuIik7CisJCXJldCA9IEpPUk5BREFfQkxfTUFYX0JS
SUdIVE5FU1MgKyAxOworCX0KKworCWpvcm5hZGFfc3NwX2VuZCgpOworCisJcmV0dXJuIHJldDsK
K30KKworc3RhdGljIHN0cnVjdCBiYWNrbGlnaHRfb3BzIGpvcm5hZGFfYmxfb3BzID0geworCS5n
ZXRfYnJpZ2h0bmVzcyA9IGpvcm5hZGFfYmxfZ2V0X2JyaWdodG5lc3MsCisJLnVwZGF0ZV9zdGF0
dXMgPSBqb3JuYWRhX2JsX3VwZGF0ZV9zdGF0dXMsCit9OworCitzdGF0aWMgc3RydWN0IGxjZF9v
cHMgam9ybmFkYV9sY2Rfb3BzID0geworCS5nZXRfY29udHJhc3QgPSBqb3JuYWRhX2xjZF9nZXRf
Y29udHJhc3QsCisJLnNldF9jb250cmFzdCA9IGpvcm5hZGFfbGNkX3NldF9jb250cmFzdCwKKwku
Z2V0X3Bvd2VyID0gam9ybmFkYV9sY2RfZ2V0X3Bvd2VyLAorCS5zZXRfcG93ZXIgPSBqb3JuYWRh
X2xjZF9zZXRfcG93ZXIsCit9OworCitzdGF0aWMgaW50IGpvcm5hZGFfYmxfcHJvYmUoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldikKK3sKKwlzdHJ1Y3Qgam9ybmFkYV9ibGxjZF9kZXZpY2Ug
KmJsbGNkOworCisJYmxsY2QgPSBremFsbG9jKHNpemVvZigqYmxsY2QpLCBHRlBfS0VSTkVMKTsK
KwlpZiAoYmxsY2QgPT0gTlVMTCkKKwkJcmV0dXJuIC1FTk9NRU07CisKKwkvKiBibCBkcml2ZXIg
LSBuYW1lIG11c3QgbWF0Y2ggZmIgZHJpdmVyIG5hbWUgKi8KKwlibGxjZC0+am9ybl9iYWNrbGln
aHRfZGV2aWNlID0gYmFja2xpZ2h0X2RldmljZV9yZWdpc3RlcihTMURfREVWSUNFTkFNRSwKKwkJ
JnBkZXYtPmRldiwgTlVMTCwgJmpvcm5hZGFfYmxfb3BzKTsKKworCWlmIChJU19FUlIoYmxsY2Qt
Pmpvcm5fYmFja2xpZ2h0X2RldmljZSkpIHsKKwkJa2ZyZWUoYmxsY2QpOworCQlyZXR1cm4gUFRS
X0VSUihibGxjZC0+am9ybl9iYWNrbGlnaHRfZGV2aWNlKTsKKwl9CisKKwkvKiBsY2QgZHJpdmVy
ICovCisJYmxsY2QtPmpvcm5fbGNkX2RldmljZSA9IGxjZF9kZXZpY2VfcmVnaXN0ZXIoUzFEX0RF
VklDRU5BTUUsCisJCQkJJnBkZXYtPmRldiwgTlVMTCwgJmpvcm5hZGFfbGNkX29wcyk7CisJaWYg
KElTX0VSUihibGxjZC0+am9ybl9sY2RfZGV2aWNlKSkgeworCQlrZnJlZShibGxjZCk7CisJCXJl
dHVybiBQVFJfRVJSKGJsbGNkLT5qb3JuX2xjZF9kZXZpY2UpOworCX0KKworCWpvcm5hZGFfbGNk
X3NldF9jb250cmFzdChibGxjZC0+am9ybl9sY2RfZGV2aWNlLAorCQkJSk9STkFEQV9MQ0RfREVG
QVVMVF9DT05UUkFTVCk7CisJam9ybmFkYV9sY2Rfc2V0X3Bvd2VyKGJsbGNkLT5qb3JuX2xjZF9k
ZXZpY2UsCisJCQlGQl9CTEFOS19VTkJMQU5LKTsKKworCW1zbGVlcCgxMDApOworCisJYmxsY2Qt
Pmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMucG93ZXIKKwkJPSBGQl9CTEFOS19VTkJMQU5L
OworCWJsbGNkLT5qb3JuX2JhY2tsaWdodF9kZXZpY2UtPnByb3BzLmJyaWdodG5lc3MKKwkJPSBK
T1JOQURBX0JMX0RFRkFVTFRfQlJJR0hUTkVTUzsKKwlqb3JuYWRhX2JsX3VwZGF0ZV9zdGF0dXMo
YmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZSk7CisKKwlwbGF0Zm9ybV9zZXRfZHJ2ZGF0YShw
ZGV2LCBibGxjZCk7CisJcHJpbnRrKEtFUk5fSU5GTyAiSFAgSm9ybmFkYSA3eHggQmFja2xpZ2h0
L0xDRCBkcml2ZXIgYWN0aXZhdGVkXG4iKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50
IGpvcm5hZGFfYmxfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCit7CisJc3Ry
dWN0IGpvcm5hZGFfYmxsY2RfZGV2aWNlICpibGxjZCA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBk
ZXYpOworCisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMucG93ZXIgPSBGQl9C
TEFOS19QT1dFUkRPV047CisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMuYnJp
Z2h0bmVzcyA9IDA7CisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMubWF4X2Jy
aWdodG5lc3MgPSAwOworCisJYmFja2xpZ2h0X2RldmljZV91bnJlZ2lzdGVyKGJsbGNkLT5qb3Ju
X2JhY2tsaWdodF9kZXZpY2UpOworCWxjZF9kZXZpY2VfdW5yZWdpc3RlcihibGxjZC0+am9ybl9s
Y2RfZGV2aWNlKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgaW50IGpvcm5hZGFfYmxfc3Vz
cGVuZChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LCBwbV9tZXNzYWdlX3Qgc3RhdGUpCit7
CisJc3RydWN0IGpvcm5hZGFfYmxsY2RfZGV2aWNlICpibGxjZCA9IHBsYXRmb3JtX2dldF9kcnZk
YXRhKHBkZXYpOworCisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMucG93ZXIg
PSBGQl9CTEFOS19QT1dFUkRPV047CisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJv
cHMuYnJpZ2h0bmVzcyA9IDA7CisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMu
bWF4X2JyaWdodG5lc3MgPSAwOworCWpvcm5hZGFfYmxfdXBkYXRlX3N0YXR1cyhibGxjZC0+am9y
bl9iYWNrbGlnaHRfZGV2aWNlKTsKKworCWpvcm5hZGFfbGNkX3NldF9wb3dlcihibGxjZC0+am9y
bl9sY2RfZGV2aWNlLCBGQl9CTEFOS19QT1dFUkRPV04pOworCisJcmV0dXJuIDA7Cit9CisKK3N0
YXRpYyBpbnQgam9ybmFkYV9ibF9yZXN1bWUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikK
K3sKKwlzdHJ1Y3Qgam9ybmFkYV9ibGxjZF9kZXZpY2UgKmJsbGNkID0gcGxhdGZvcm1fZ2V0X2Ry
dmRhdGEocGRldik7CisKKwlibGxjZC0+am9ybl9iYWNrbGlnaHRfZGV2aWNlLT5wcm9wcy5wb3dl
cgorCQk9IEZCX0JMQU5LX1VOQkxBTks7CisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+
cHJvcHMuYnJpZ2h0bmVzcworCQk9IEpPUk5BREFfQkxfREVGQVVMVF9CUklHSFRORVNTOworCWJs
bGNkLT5qb3JuX2JhY2tsaWdodF9kZXZpY2UtPnByb3BzLm1heF9icmlnaHRuZXNzCisJCT0gSk9S
TkFEQV9CTF9NQVhfQlJJR0hUTkVTUzsKKwlqb3JuYWRhX2JsX3VwZGF0ZV9zdGF0dXMoYmxsY2Qt
Pmpvcm5fYmFja2xpZ2h0X2RldmljZSk7CisKKwlqb3JuYWRhX2xjZF9zZXRfcG93ZXIoYmxsY2Qt
Pmpvcm5fbGNkX2RldmljZSwgRkJfQkxBTktfVU5CTEFOSyk7CisKKwlyZXR1cm4gMDsKK30KKwor
c3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgam9ybmFkYV9ibF9kcml2ZXIgPSB7CisJLnBy
b2JlCT0gam9ybmFkYV9ibF9wcm9iZSwKKwkucmVtb3ZlCT0gam9ybmFkYV9ibF9yZW1vdmUsCisj
aWZkZWYgQ09ORklHX1BNCisJLnN1c3BlbmQgPSBqb3JuYWRhX2JsX3N1c3BlbmQsCisJLnJlc3Vt
ZSA9IGpvcm5hZGFfYmxfcmVzdW1lLAorI2VuZGlmCisJLmRyaXZlciA9IHsKKwkgICAgLm5hbWUg
PSAiam9ybmFkYV9ibGxjZCIsCisJfSwKK307CisKK3N0YXRpYyBpbnQgX19pbml0IGpvcm5hZGFf
YmxfaW5pdCh2b2lkKQoreworCXJldHVybiBwbGF0Zm9ybV9kcml2ZXJfcmVnaXN0ZXIoJmpvcm5h
ZGFfYmxfZHJpdmVyKTsKK30KKworc3RhdGljIHZvaWQgX19leGl0IGpvcm5hZGFfYmxfZXhpdCh2
b2lkKQoreworCXBsYXRmb3JtX2RyaXZlcl91bnJlZ2lzdGVyKCZqb3JuYWRhX2JsX2RyaXZlcik7
Cit9CisKK21vZHVsZV9pbml0KGpvcm5hZGFfYmxfaW5pdCk7Cittb2R1bGVfZXhpdChqb3JuYWRh
X2JsX2V4aXQpOwo=

--Multipart=_Wed__6_Feb_2008_17_33_41_+0100_zmSlnqkEcDuPui=w--
