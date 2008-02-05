Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYBESxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYBESxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbYBESxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:53:41 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:31983 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbYBESxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:53:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=cCIyoplJ1VApllMV3s33NiyL8OgjWzGe1qwZzBFFFf2/Dd7I6SpVONdSybOEGqrHmqVJDCS1r6aeVZks1rS1OtEPasWMi33PvQCJacW+dFRmusNP9YPrnWxWZ2iXcCajJcMi3iPBjM7r6Siqka/QCyA7oke2ggqu7LzPG245gDc=
Date: Tue, 5 Feb 2008 19:53:31 +0100
To: Russell King <linux@arm.linux.org.uk>, rpurdie@openedhand.com
Cc: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
 Jornada 7xx handhelds
Message-Id: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__5_Feb_2008_19_53_31_+0100_EkUg7vQQ_jUaZcKS"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__5_Feb_2008_19_53_31_+0100_EkUg7vQQ_jUaZcKS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Greetings,

Richard I've cleaned up the driver by checking with checkpatch.pl as Russell suggested. I would appreciate it if you could
look through the patch again and give comments since the patch looks somewhat different.

I can add patch for Kconfig/Makefile later on but suspect there will be some changes required before that.

Oh and to answer your question regarding MAX/MIN values of the backlight, 0 = max and 255 = min. So we simply turn it around
by returning 255 - value. Same thing when we need to set value.

Best wishes
Kristoffer Ericson

diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c
new file mode 100644
index 0000000..4967b86
--- /dev/null
+++ b/drivers/video/backlight/jornada720_bllcd.c
@@ -0,0 +1,284 @@
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
+		return 255;
+
+	jornada_ssp_start();
+	if (jornada_ssp_inout(GETBRIGHTNESS) == -ETIMEDOUT) {
+		printk(KERN_ERR "jornada720_bl: GetBrightness failed\n");
+		ret = 256;
+	} else
+		ret = jornada_ssp_inout(TXDUMMY);
+
+	jornada_ssp_end();
+
+	/* 0 is max brightness */
+	return (255 - ret);
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
+			printk(KERN_ERR "jornada720_bl:
+				BrightnessOff timeout\n");
+		else {
+		/* backlight off */
+			PPSR &= ~PPC_LDD1;
+			PPDR |= PPC_LDD1;
+		}
+	} else {/* backlight on */
+			PPSR |= PPC_LDD1;
+
+	if ((jornada_ssp_inout(SETBRIGHTNESS)) == TXDUMMY) {
+		/* send brightness value (0 is max, 255 lowest) */
+		if (jornada_ssp_byte(255 - dev->props.brightness) != -ETIMEDOUT)
+			ret = (255 - dev->props.brightness);
+	} else
+		printk(KERN_ERR "jornada720_bl: SetBrightness timeout\n");
+	}
+
+	jornada_ssp_end();
+
+	return ret;
+}
+
+/* LCD HANDLING FUNCTIONS
+   ====================== */
+static int jornada_lcd_set_contrast(struct lcd_device *pdev, int contrast)
+{
+	int ret = 0;
+
+	jornada_ssp_start();
+
+	ret = jornada_ssp_inout(SETCONTRAST);
+
+	if (ret == -ETIMEDOUT)
+		printk(KERN_INFO "jornada_lcd: failure to set contrast\n");
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
+	} else
+	/* turn on LCD */
+	PPSR |= PPC_LDD2;
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
+		printk(KERN_INFO "jornada_lcd: getcontrast failed!\n");
+		ret = 256;
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
+				&pdev->dev, NULL, &jornada_bl_ops);
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
+	    .name = "jornada_bl",
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

--Multipart=_Tue__5_Feb_2008_19_53_31_+0100_EkUg7vQQ_jUaZcKS
Content-Type: application/octet-stream;
 name="jornada720_bllcd.patch"
Content-Disposition: attachment;
 filename="jornada720_bllcd.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmxsY2QuYyBi
L2RyaXZlcnMvdmlkZW8vYmFja2xpZ2h0L2pvcm5hZGE3MjBfYmxsY2QuYwpuZXcgZmlsZSBtb2Rl
IDEwMDY0NAppbmRleCAwMDAwMDAwLi40OTY3Yjg2Ci0tLSAvZGV2L251bGwKKysrIGIvZHJpdmVy
cy92aWRlby9iYWNrbGlnaHQvam9ybmFkYTcyMF9ibGxjZC5jCkBAIC0wLDAgKzEsMjg0IEBACisv
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
Q19MREQxKSkKKwkJcmV0dXJuIDI1NTsKKworCWpvcm5hZGFfc3NwX3N0YXJ0KCk7CisJaWYgKGpv
cm5hZGFfc3NwX2lub3V0KEdFVEJSSUdIVE5FU1MpID09IC1FVElNRURPVVQpIHsKKwkJcHJpbnRr
KEtFUk5fRVJSICJqb3JuYWRhNzIwX2JsOiBHZXRCcmlnaHRuZXNzIGZhaWxlZFxuIik7CisJCXJl
dCA9IDI1NjsKKwl9IGVsc2UKKwkJcmV0ID0gam9ybmFkYV9zc3BfaW5vdXQoVFhEVU1NWSk7CisK
Kwlqb3JuYWRhX3NzcF9lbmQoKTsKKworCS8qIDAgaXMgbWF4IGJyaWdodG5lc3MgKi8KKwlyZXR1
cm4gKDI1NSAtIHJldCk7Cit9CisKK3N0YXRpYyBpbnQgam9ybmFkYV9ibF91cGRhdGVfc3RhdHVz
KHN0cnVjdCBiYWNrbGlnaHRfZGV2aWNlICpkZXYpCit7CisJaW50IHJldCA9IDA7CisKKwlqb3Ju
YWRhX3NzcF9zdGFydCgpOworCisJaWYgKGRldi0+cHJvcHMucG93ZXIgIT0gRkJfQkxBTktfVU5C
TEFOSyB8fAorCQlkZXYtPnByb3BzLmZiX2JsYW5rICE9IEZCX0JMQU5LX1VOQkxBTkspIHsKKwkJ
cmV0ID0gam9ybmFkYV9zc3BfaW5vdXQoQlJJR0hUTkVTU09GRik7CisJCWlmIChyZXQgPT0gLUVU
SU1FRE9VVCkKKwkJCXByaW50ayhLRVJOX0VSUiAiam9ybmFkYTcyMF9ibDoKKwkJCQlCcmlnaHRu
ZXNzT2ZmIHRpbWVvdXRcbiIpOworCQllbHNlIHsKKwkJLyogYmFja2xpZ2h0IG9mZiAqLworCQkJ
UFBTUiAmPSB+UFBDX0xERDE7CisJCQlQUERSIHw9IFBQQ19MREQxOworCQl9CisJfSBlbHNlIHsv
KiBiYWNrbGlnaHQgb24gKi8KKwkJCVBQU1IgfD0gUFBDX0xERDE7CisKKwlpZiAoKGpvcm5hZGFf
c3NwX2lub3V0KFNFVEJSSUdIVE5FU1MpKSA9PSBUWERVTU1ZKSB7CisJCS8qIHNlbmQgYnJpZ2h0
bmVzcyB2YWx1ZSAoMCBpcyBtYXgsIDI1NSBsb3dlc3QpICovCisJCWlmIChqb3JuYWRhX3NzcF9i
eXRlKDI1NSAtIGRldi0+cHJvcHMuYnJpZ2h0bmVzcykgIT0gLUVUSU1FRE9VVCkKKwkJCXJldCA9
ICgyNTUgLSBkZXYtPnByb3BzLmJyaWdodG5lc3MpOworCX0gZWxzZQorCQlwcmludGsoS0VSTl9F
UlIgImpvcm5hZGE3MjBfYmw6IFNldEJyaWdodG5lc3MgdGltZW91dFxuIik7CisJfQorCisJam9y
bmFkYV9zc3BfZW5kKCk7CisKKwlyZXR1cm4gcmV0OworfQorCisvKiBMQ0QgSEFORExJTkcgRlVO
Q1RJT05TCisgICA9PT09PT09PT09PT09PT09PT09PT09ICovCitzdGF0aWMgaW50IGpvcm5hZGFf
bGNkX3NldF9jb250cmFzdChzdHJ1Y3QgbGNkX2RldmljZSAqcGRldiwgaW50IGNvbnRyYXN0KQor
eworCWludCByZXQgPSAwOworCisJam9ybmFkYV9zc3Bfc3RhcnQoKTsKKworCXJldCA9IGpvcm5h
ZGFfc3NwX2lub3V0KFNFVENPTlRSQVNUKTsKKworCWlmIChyZXQgPT0gLUVUSU1FRE9VVCkKKwkJ
cHJpbnRrKEtFUk5fSU5GTyAiam9ybmFkYV9sY2Q6IGZhaWx1cmUgdG8gc2V0IGNvbnRyYXN0XG4i
KTsKKwkgZWxzZQorCQlyZXQgPSBqb3JuYWRhX3NzcF9ieXRlKGNvbnRyYXN0KTsKKworCWpvcm5h
ZGFfc3NwX2VuZCgpOworCisJcmV0dXJuIHJldDsKK30KKworc3RhdGljIGludCBqb3JuYWRhX2xj
ZF9zZXRfcG93ZXIoc3RydWN0IGxjZF9kZXZpY2UgICpwZGV2LCBpbnQgcG93ZXIpCit7CisJaWYg
KHBvd2VyICE9IEZCX0JMQU5LX1VOQkxBTkspIHsKKwkJLyogdHVybiBvZmYgTENEICovCisJCVBQ
U1IgJj0gflBQQ19MREQyOworCQlQUERSIHw9IFBQQ19MREQyOworCX0gZWxzZQorCS8qIHR1cm4g
b24gTENEICovCisJUFBTUiB8PSBQUENfTEREMjsKKworCXJldHVybiAwOworfQorCitzdGF0aWMg
aW50IGpvcm5hZGFfbGNkX2dldF9wb3dlcihzdHJ1Y3QgbGNkX2RldmljZSAqcGRldikKK3sKKwlp
ZiAoUFBTUiAmIFBQQ19MREQyKQorCQlyZXR1cm4gRkJfQkxBTktfVU5CTEFOSzsKKwllbHNlCisJ
CXJldHVybiBGQl9CTEFOS19QT1dFUkRPV047Cit9CisKK3N0YXRpYyBpbnQgam9ybmFkYV9sY2Rf
Z2V0X2NvbnRyYXN0KHN0cnVjdCBsY2RfZGV2aWNlICpwZGV2KQoreworCWludCByZXQ7CisKKwkv
KiBEb24ndCBzZXQgY29udHJhc3Qgb24gb2ZmIHBvd2VyZCBMQ0QgKi8KKwlpZiAoam9ybmFkYV9s
Y2RfZ2V0X3Bvd2VyKHBkZXYpICE9IEZCX0JMQU5LX1VOQkxBTkspCisJCXJldHVybiAwOworCisJ
am9ybmFkYV9zc3Bfc3RhcnQoKTsKKworCXJldCA9IGpvcm5hZGFfc3NwX2lub3V0KEdFVENPTlRS
QVNUKTsKKwlpZiAocmV0ICE9IC1FVElNRURPVVQpCisJCXJldCA9IGpvcm5hZGFfc3NwX2lub3V0
KFRYRFVNTVkpOworCWVsc2UgeworCQlwcmludGsoS0VSTl9JTkZPICJqb3JuYWRhX2xjZDogZ2V0
Y29udHJhc3QgZmFpbGVkIVxuIik7CisJCXJldCA9IDI1NjsKKwl9CisKKwlqb3JuYWRhX3NzcF9l
bmQoKTsKKworCXJldHVybiByZXQ7Cit9CisKK3N0YXRpYyBzdHJ1Y3QgYmFja2xpZ2h0X29wcyBq
b3JuYWRhX2JsX29wcyA9IHsKKwkuZ2V0X2JyaWdodG5lc3MgPSBqb3JuYWRhX2JsX2dldF9icmln
aHRuZXNzLAorCS51cGRhdGVfc3RhdHVzID0gam9ybmFkYV9ibF91cGRhdGVfc3RhdHVzLAorfTsK
Kworc3RhdGljIHN0cnVjdCBsY2Rfb3BzIGpvcm5hZGFfbGNkX29wcyA9IHsKKwkuZ2V0X2NvbnRy
YXN0ID0gam9ybmFkYV9sY2RfZ2V0X2NvbnRyYXN0LAorCS5zZXRfY29udHJhc3QgPSBqb3JuYWRh
X2xjZF9zZXRfY29udHJhc3QsCisJLmdldF9wb3dlciA9IGpvcm5hZGFfbGNkX2dldF9wb3dlciwK
Kwkuc2V0X3Bvd2VyID0gam9ybmFkYV9sY2Rfc2V0X3Bvd2VyLAorfTsKKworc3RhdGljIGludCBq
b3JuYWRhX2JsX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCit7CisJc3RydWN0
IGpvcm5hZGFfYmxsY2RfZGV2aWNlICpibGxjZDsKKworCWJsbGNkID0ga3phbGxvYyhzaXplb2Yo
KmJsbGNkKSwgR0ZQX0tFUk5FTCk7CisJaWYgKGJsbGNkID09IE5VTEwpCisJCXJldHVybiAtRU5P
TUVNOworCisJLyogYmwgZHJpdmVyIC0gbmFtZSBtdXN0IG1hdGNoIGZiIGRyaXZlciBuYW1lICov
CisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZSA9IGJhY2tsaWdodF9kZXZpY2VfcmVnaXN0
ZXIoUzFEX0RFVklDRU5BTUUsCisJCQkJJnBkZXYtPmRldiwgTlVMTCwgJmpvcm5hZGFfYmxfb3Bz
KTsKKworCWlmIChJU19FUlIoYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZSkpIHsKKwkJa2Zy
ZWUoYmxsY2QpOworCQlyZXR1cm4gUFRSX0VSUihibGxjZC0+am9ybl9iYWNrbGlnaHRfZGV2aWNl
KTsKKwl9CisKKwkvKiBsY2QgZHJpdmVyICovCisJYmxsY2QtPmpvcm5fbGNkX2RldmljZSA9IGxj
ZF9kZXZpY2VfcmVnaXN0ZXIoUzFEX0RFVklDRU5BTUUsCisJCQkJJnBkZXYtPmRldiwgTlVMTCwg
Jmpvcm5hZGFfbGNkX29wcyk7CisJaWYgKElTX0VSUihibGxjZC0+am9ybl9sY2RfZGV2aWNlKSkg
eworCQlrZnJlZShibGxjZCk7CisJCXJldHVybiBQVFJfRVJSKGJsbGNkLT5qb3JuX2xjZF9kZXZp
Y2UpOworCX0KKworCWpvcm5hZGFfbGNkX3NldF9jb250cmFzdChibGxjZC0+am9ybl9sY2RfZGV2
aWNlLAorCQkJSk9STkFEQV9MQ0RfREVGQVVMVF9DT05UUkFTVCk7CisJam9ybmFkYV9sY2Rfc2V0
X3Bvd2VyKGJsbGNkLT5qb3JuX2xjZF9kZXZpY2UsCisJCQlGQl9CTEFOS19VTkJMQU5LKTsKKwor
CW1zbGVlcCgxMDApOworCisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMucG93
ZXIKKwkJPSBGQl9CTEFOS19VTkJMQU5LOworCWJsbGNkLT5qb3JuX2JhY2tsaWdodF9kZXZpY2Ut
PnByb3BzLmJyaWdodG5lc3MKKwkJPSBKT1JOQURBX0JMX0RFRkFVTFRfQlJJR0hUTkVTUzsKKwlq
b3JuYWRhX2JsX3VwZGF0ZV9zdGF0dXMoYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZSk7CisK
KwlwbGF0Zm9ybV9zZXRfZHJ2ZGF0YShwZGV2LCBibGxjZCk7CisJcHJpbnRrKEtFUk5fSU5GTyAi
SFAgSm9ybmFkYSA3eHggQmFja2xpZ2h0L0xDRCBkcml2ZXIgYWN0aXZhdGVkXG4iKTsKKworCXJl
dHVybiAwOworfQorCitzdGF0aWMgaW50IGpvcm5hZGFfYmxfcmVtb3ZlKHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpCit7CisJc3RydWN0IGpvcm5hZGFfYmxsY2RfZGV2aWNlICpibGxjZCA9
IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOworCisJYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2Rl
dmljZS0+cHJvcHMucG93ZXIgPSBGQl9CTEFOS19QT1dFUkRPV047CisJYmxsY2QtPmpvcm5fYmFj
a2xpZ2h0X2RldmljZS0+cHJvcHMuYnJpZ2h0bmVzcyA9IDA7CisJYmxsY2QtPmpvcm5fYmFja2xp
Z2h0X2RldmljZS0+cHJvcHMubWF4X2JyaWdodG5lc3MgPSAwOworCisJYmFja2xpZ2h0X2Rldmlj
ZV91bnJlZ2lzdGVyKGJsbGNkLT5qb3JuX2JhY2tsaWdodF9kZXZpY2UpOworCWxjZF9kZXZpY2Vf
dW5yZWdpc3RlcihibGxjZC0+am9ybl9sY2RfZGV2aWNlKTsKKworCXJldHVybiAwOworfQorCitz
dGF0aWMgaW50IGpvcm5hZGFfYmxfc3VzcGVuZChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
LCBwbV9tZXNzYWdlX3Qgc3RhdGUpCit7CisJc3RydWN0IGpvcm5hZGFfYmxsY2RfZGV2aWNlICpi
bGxjZCA9IHBsYXRmb3JtX2dldF9kcnZkYXRhKHBkZXYpOworCisJYmxsY2QtPmpvcm5fYmFja2xp
Z2h0X2RldmljZS0+cHJvcHMucG93ZXIgPSBGQl9CTEFOS19QT1dFUkRPV047CisJYmxsY2QtPmpv
cm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMuYnJpZ2h0bmVzcyA9IDA7CisJYmxsY2QtPmpvcm5f
YmFja2xpZ2h0X2RldmljZS0+cHJvcHMubWF4X2JyaWdodG5lc3MgPSAwOworCWpvcm5hZGFfYmxf
dXBkYXRlX3N0YXR1cyhibGxjZC0+am9ybl9iYWNrbGlnaHRfZGV2aWNlKTsKKworCWpvcm5hZGFf
bGNkX3NldF9wb3dlcihibGxjZC0+am9ybl9sY2RfZGV2aWNlLCBGQl9CTEFOS19QT1dFUkRPV04p
OworCisJcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgam9ybmFkYV9ibF9yZXN1bWUoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldikKK3sKKwlzdHJ1Y3Qgam9ybmFkYV9ibGxjZF9kZXZpY2Ug
KmJsbGNkID0gcGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7CisKKwlibGxjZC0+am9ybl9iYWNr
bGlnaHRfZGV2aWNlLT5wcm9wcy5wb3dlcgorCQk9IEZCX0JMQU5LX1VOQkxBTks7CisJYmxsY2Qt
Pmpvcm5fYmFja2xpZ2h0X2RldmljZS0+cHJvcHMuYnJpZ2h0bmVzcworCQk9IEpPUk5BREFfQkxf
REVGQVVMVF9CUklHSFRORVNTOworCWJsbGNkLT5qb3JuX2JhY2tsaWdodF9kZXZpY2UtPnByb3Bz
Lm1heF9icmlnaHRuZXNzCisJCT0gSk9STkFEQV9CTF9NQVhfQlJJR0hUTkVTUzsKKwlqb3JuYWRh
X2JsX3VwZGF0ZV9zdGF0dXMoYmxsY2QtPmpvcm5fYmFja2xpZ2h0X2RldmljZSk7CisKKwlqb3Ju
YWRhX2xjZF9zZXRfcG93ZXIoYmxsY2QtPmpvcm5fbGNkX2RldmljZSwgRkJfQkxBTktfVU5CTEFO
Syk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHN0cnVjdCBwbGF0Zm9ybV9kcml2ZXIgam9y
bmFkYV9ibF9kcml2ZXIgPSB7CisJLnByb2JlCT0gam9ybmFkYV9ibF9wcm9iZSwKKwkucmVtb3Zl
CT0gam9ybmFkYV9ibF9yZW1vdmUsCisjaWZkZWYgQ09ORklHX1BNCisJLnN1c3BlbmQgPSBqb3Ju
YWRhX2JsX3N1c3BlbmQsCisJLnJlc3VtZSA9IGpvcm5hZGFfYmxfcmVzdW1lLAorI2VuZGlmCisJ
LmRyaXZlciA9IHsKKwkgICAgLm5hbWUgPSAiam9ybmFkYV9ibCIsCisJfSwKK307CisKK3N0YXRp
YyBpbnQgX19pbml0IGpvcm5hZGFfYmxfaW5pdCh2b2lkKQoreworCXJldHVybiBwbGF0Zm9ybV9k
cml2ZXJfcmVnaXN0ZXIoJmpvcm5hZGFfYmxfZHJpdmVyKTsKK30KKworc3RhdGljIHZvaWQgX19l
eGl0IGpvcm5hZGFfYmxfZXhpdCh2b2lkKQoreworCXBsYXRmb3JtX2RyaXZlcl91bnJlZ2lzdGVy
KCZqb3JuYWRhX2JsX2RyaXZlcik7Cit9CisKK21vZHVsZV9pbml0KGpvcm5hZGFfYmxfaW5pdCk7
Cittb2R1bGVfZXhpdChqb3JuYWRhX2JsX2V4aXQpOwo=

--Multipart=_Tue__5_Feb_2008_19_53_31_+0100_EkUg7vQQ_jUaZcKS--
