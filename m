Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbYBESOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbYBESOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbYBESOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:14:12 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:6120 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbYBESOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:14:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:organization:x-mailer:mime-version:content-type:from;
        b=RZ54Mue2Um7otSzZ/XUOvRFLVaigZjTY+J1ulyqSbSQDyIJDZSVwS2AxfEgUEjt85Db8iyq8uVPma9DQq8AZo7GX57xNIPC6axKyfja5GX8Frnm6AxT+FI/p81qxZPT6PR5iQH06XnjcXUB2eaOHwwRjNIuYDsqwo5yAtLVODWY=
Date: Tue, 5 Feb 2008 19:13:56 +0100
To: rpurdie@openedhand.com
Cc: linux-main <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
Subject: [PATCH/HP6XX] - Add leds support to the HP Jornada 6xx handheld
Message-Id: <20080205191356.ae2e8948.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Tue__5_Feb_2008_19_13_56_+0100_33dk_5V=WhrmDp1d"
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Tue__5_Feb_2008_19_13_56_+0100_33dk_5V=WhrmDp1d
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Greetings,

Richard, I've been told from paul that I should seek another solution for my hd6446x.h merger (perhaps mfd driver). So this patch
is against linux-2.6.git with the header and defines changed back to old style. Tested to compile. I tested the "old" patch and that worked and I've only changed 5-6 names so it really should work as before.

shortlog:
This patch adds leds support for the HP Jornada 6xx handheld(s). Usage can either be through /sys/platform.. 
or by adding various triggers in menuconfig. The leds only support on / off where 0 is off and 1 is on.

signed-off-by:Kristoffer Ericson <kristoffer.ericson@gmail.com>

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index ec568fa..0b0bca1 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -100,6 +100,14 @@ config LEDS_COBALT_RAQ
 	help
 	  This option enables support for the Cobalt Raq series LEDs.
 
+config LEDS_HP6XX
+	bool "LED Support for the HP Jornada 6xx"
+	depends on LEDS_CLASS && SH_HP6XX
+	select LEDS_TRIGGERS
+	help
+	  This option enables led support for the handheld
+	  HP Jornada 620/660/680/690.
+
 config LEDS_GPIO
 	tristate "LED Support for GPIO connected LEDs"
 	depends on LEDS_CLASS && GENERIC_GPIO
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index a60de1b..a9a8ffb 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_LEDS_COBALT_QUBE)		+= leds-cobalt-qube.o
 obj-$(CONFIG_LEDS_COBALT_RAQ)		+= leds-cobalt-raq.o
 obj-$(CONFIG_LEDS_GPIO)			+= leds-gpio.o
 obj-$(CONFIG_LEDS_CM_X270)              += leds-cm-x270.o
+obj-$(CONFIG_LEDS_HP6XX)		+= leds-hp6xx.o
 
 # LED Triggers
 obj-$(CONFIG_LEDS_TRIGGER_TIMER)	+= ledtrig-timer.o
diff --git a/drivers/leds/leds-hp6xx.c b/drivers/leds/leds-hp6xx.c
new file mode 100644
index 0000000..82d4ec3
--- /dev/null
+++ b/drivers/leds/leds-hp6xx.c
@@ -0,0 +1,120 @@
+/*
+ * LED Triggers Core
+ * For the HP Jornada 620/660/680/690 handhelds
+ *
+ * Copyright 2008 Kristoffer Ericson <kristoffer.ericson@gmail.com>
+ *     this driver is based on leds-spitz.c by Richard Purdie.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/leds.h>
+#include <asm/hd64461.h>
+#include <asm/hp6xx.h>
+
+static void hp6xxled_green_set(struct led_classdev *led_cdev, enum led_brightness value)
+{
+	u8 v8;
+
+	v8 = inb(PKDR);
+	if (value)
+		outb(v8 & (~PKDR_LED_GREEN), PKDR);
+	else
+		outb(v8 | PKDR_LED_GREEN, PKDR);
+}
+
+static void hp6xxled_red_set(struct led_classdev *led_cdev, enum led_brightness value)
+{
+	u16 v16;
+
+	v16 = inw(HD64461_GPBDR);
+	if (value)
+		outw(v16 & (~HD64461_GPBDR_LED_RED), HD64461_GPBDR);
+	else
+		outw(v16 | HD64461_GPBDR_LED_RED, HD64461_GPBDR);
+}
+
+static struct led_classdev hp6xx_red_led = {
+	.name			= "hp6xx:red",
+	.default_trigger	= "hp6xx-charge",
+	.brightness_set		= hp6xxled_red_set,
+};
+
+static struct led_classdev hp6xx_green_led = {
+	.name			= "hp6xx:green",
+	.default_trigger	= "ide-disk",
+	.brightness_set		= hp6xxled_green_set,
+};
+
+#ifdef CONFIG_PM
+static int hp6xxled_suspend(struct platform_device *dev, pm_message_t state)
+{
+	led_classdev_suspend(&hp6xx_red_led);
+	led_classdev_suspend(&hp6xx_green_led);
+	return 0;
+}
+
+static int hp6xxled_resume(struct platform_device *dev)
+{
+	led_classdev_resume(&hp6xx_red_led);
+	led_classdev_resume(&hp6xx_green_led);
+	return 0;
+}
+#endif
+
+static int hp6xxled_probe(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = led_classdev_register(&pdev->dev, &hp6xx_red_led);
+	if (ret < 0)
+		return ret;
+
+	ret = led_classdev_register(&pdev->dev, &hp6xx_green_led);
+	if (ret < 0)
+		led_classdev_unregister(&hp6xx_red_led);
+
+	return ret;
+}
+
+static int hp6xxled_remove(struct platform_device *pdev)
+{
+	led_classdev_unregister(&hp6xx_red_led);
+	led_classdev_unregister(&hp6xx_green_led);
+
+	return 0;
+}
+
+static struct platform_driver hp6xxled_driver = {
+	.probe		= hp6xxled_probe,
+	.remove		= hp6xxled_remove,
+#ifdef CONFIG_PM
+	.suspend	= hp6xxled_suspend,
+	.resume		= hp6xxled_resume,
+#endif
+	.driver		= {
+		.name		= "hp6xx-led",
+	},
+};
+
+static int __init hp6xxled_init(void)
+{
+	return platform_driver_register(&hp6xxled_driver);
+}
+
+static void __exit hp6xxled_exit(void)
+{
+	platform_driver_unregister(&hp6xxled_driver);
+}
+
+module_init(hp6xxled_init);
+module_exit(hp6xxled_exit);
+
+MODULE_AUTHOR("Kristoffer Ericson <kristoffer.ericson@gmail.com>");
+MODULE_DESCRIPTION("HP Jornada 6xx LED driver");
+MODULE_LICENSE("GPL");


--Multipart=_Tue__5_Feb_2008_19_13_56_+0100_33dk_5V=WhrmDp1d
Content-Type: application/octet-stream;
 name="hp6xx-leds-support.patch"
Content-Disposition: attachment;
 filename="hp6xx-leds-support.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbGVkcy9LY29uZmlnIGIvZHJpdmVycy9sZWRzL0tjb25maWcK
aW5kZXggZWM1NjhmYS4uMGIwYmNhMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9sZWRzL0tjb25maWcK
KysrIGIvZHJpdmVycy9sZWRzL0tjb25maWcKQEAgLTEwMCw2ICsxMDAsMTQgQEAgY29uZmlnIExF
RFNfQ09CQUxUX1JBUQogCWhlbHAKIAkgIFRoaXMgb3B0aW9uIGVuYWJsZXMgc3VwcG9ydCBmb3Ig
dGhlIENvYmFsdCBSYXEgc2VyaWVzIExFRHMuCiAKK2NvbmZpZyBMRURTX0hQNlhYCisJYm9vbCAi
TEVEIFN1cHBvcnQgZm9yIHRoZSBIUCBKb3JuYWRhIDZ4eCIKKwlkZXBlbmRzIG9uIExFRFNfQ0xB
U1MgJiYgU0hfSFA2WFgKKwlzZWxlY3QgTEVEU19UUklHR0VSUworCWhlbHAKKwkgIFRoaXMgb3B0
aW9uIGVuYWJsZXMgbGVkIHN1cHBvcnQgZm9yIHRoZSBoYW5kaGVsZAorCSAgSFAgSm9ybmFkYSA2
MjAvNjYwLzY4MC82OTAuCisKIGNvbmZpZyBMRURTX0dQSU8KIAl0cmlzdGF0ZSAiTEVEIFN1cHBv
cnQgZm9yIEdQSU8gY29ubmVjdGVkIExFRHMiCiAJZGVwZW5kcyBvbiBMRURTX0NMQVNTICYmIEdF
TkVSSUNfR1BJTwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9sZWRzL01ha2VmaWxlIGIvZHJpdmVycy9s
ZWRzL01ha2VmaWxlCmluZGV4IGE2MGRlMWIuLmE5YThmZmIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
bGVkcy9NYWtlZmlsZQorKysgYi9kcml2ZXJzL2xlZHMvTWFrZWZpbGUKQEAgLTE5LDYgKzE5LDcg
QEAgb2JqLSQoQ09ORklHX0xFRFNfQ09CQUxUX1FVQkUpCQkrPSBsZWRzLWNvYmFsdC1xdWJlLm8K
IG9iai0kKENPTkZJR19MRURTX0NPQkFMVF9SQVEpCQkrPSBsZWRzLWNvYmFsdC1yYXEubwogb2Jq
LSQoQ09ORklHX0xFRFNfR1BJTykJCQkrPSBsZWRzLWdwaW8ubwogb2JqLSQoQ09ORklHX0xFRFNf
Q01fWDI3MCkgICAgICAgICAgICAgICs9IGxlZHMtY20teDI3MC5vCitvYmotJChDT05GSUdfTEVE
U19IUDZYWCkJCSs9IGxlZHMtaHA2eHgubwogCiAjIExFRCBUcmlnZ2Vycwogb2JqLSQoQ09ORklH
X0xFRFNfVFJJR0dFUl9USU1FUikJKz0gbGVkdHJpZy10aW1lci5vCmRpZmYgLS1naXQgYS9kcml2
ZXJzL2xlZHMvbGVkcy1ocDZ4eC5jIGIvZHJpdmVycy9sZWRzL2xlZHMtaHA2eHguYwpuZXcgZmls
ZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi44MmQ0ZWMzCi0tLSAvZGV2L251bGwKKysrIGIv
ZHJpdmVycy9sZWRzL2xlZHMtaHA2eHguYwpAQCAtMCwwICsxLDEyMCBAQAorLyoKKyAqIExFRCBU
cmlnZ2VycyBDb3JlCisgKiBGb3IgdGhlIEhQIEpvcm5hZGEgNjIwLzY2MC82ODAvNjkwIGhhbmRo
ZWxkcworICoKKyAqIENvcHlyaWdodCAyMDA4IEtyaXN0b2ZmZXIgRXJpY3NvbiA8a3Jpc3RvZmZl
ci5lcmljc29uQGdtYWlsLmNvbT4KKyAqICAgICB0aGlzIGRyaXZlciBpcyBiYXNlZCBvbiBsZWRz
LXNwaXR6LmMgYnkgUmljaGFyZCBQdXJkaWUuCisgKgorICogVGhpcyBwcm9ncmFtIGlzIGZyZWUg
c29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqIGl0IHVu
ZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgdmVyc2lvbiAy
IGFzCisgKiBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbi4KKyAqLwor
CisjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgvaW5pdC5oPgorI2lu
Y2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPgorI2luY2x1ZGUgPGxpbnV4L2xlZHMuaD4K
KyNpbmNsdWRlIDxhc20vaGQ2NDQ2MS5oPgorI2luY2x1ZGUgPGFzbS9ocDZ4eC5oPgorCitzdGF0
aWMgdm9pZCBocDZ4eGxlZF9ncmVlbl9zZXQoc3RydWN0IGxlZF9jbGFzc2RldiAqbGVkX2NkZXYs
IGVudW0gbGVkX2JyaWdodG5lc3MgdmFsdWUpCit7CisJdTggdjg7CisKKwl2OCA9IGluYihQS0RS
KTsKKwlpZiAodmFsdWUpCisJCW91dGIodjggJiAoflBLRFJfTEVEX0dSRUVOKSwgUEtEUik7CisJ
ZWxzZQorCQlvdXRiKHY4IHwgUEtEUl9MRURfR1JFRU4sIFBLRFIpOworfQorCitzdGF0aWMgdm9p
ZCBocDZ4eGxlZF9yZWRfc2V0KHN0cnVjdCBsZWRfY2xhc3NkZXYgKmxlZF9jZGV2LCBlbnVtIGxl
ZF9icmlnaHRuZXNzIHZhbHVlKQoreworCXUxNiB2MTY7CisKKwl2MTYgPSBpbncoSEQ2NDQ2MV9H
UEJEUik7CisJaWYgKHZhbHVlKQorCQlvdXR3KHYxNiAmICh+SEQ2NDQ2MV9HUEJEUl9MRURfUkVE
KSwgSEQ2NDQ2MV9HUEJEUik7CisJZWxzZQorCQlvdXR3KHYxNiB8IEhENjQ0NjFfR1BCRFJfTEVE
X1JFRCwgSEQ2NDQ2MV9HUEJEUik7Cit9CisKK3N0YXRpYyBzdHJ1Y3QgbGVkX2NsYXNzZGV2IGhw
Nnh4X3JlZF9sZWQgPSB7CisJLm5hbWUJCQk9ICJocDZ4eDpyZWQiLAorCS5kZWZhdWx0X3RyaWdn
ZXIJPSAiaHA2eHgtY2hhcmdlIiwKKwkuYnJpZ2h0bmVzc19zZXQJCT0gaHA2eHhsZWRfcmVkX3Nl
dCwKK307CisKK3N0YXRpYyBzdHJ1Y3QgbGVkX2NsYXNzZGV2IGhwNnh4X2dyZWVuX2xlZCA9IHsK
KwkubmFtZQkJCT0gImhwNnh4OmdyZWVuIiwKKwkuZGVmYXVsdF90cmlnZ2VyCT0gImlkZS1kaXNr
IiwKKwkuYnJpZ2h0bmVzc19zZXQJCT0gaHA2eHhsZWRfZ3JlZW5fc2V0LAorfTsKKworI2lmZGVm
IENPTkZJR19QTQorc3RhdGljIGludCBocDZ4eGxlZF9zdXNwZW5kKHN0cnVjdCBwbGF0Zm9ybV9k
ZXZpY2UgKmRldiwgcG1fbWVzc2FnZV90IHN0YXRlKQoreworCWxlZF9jbGFzc2Rldl9zdXNwZW5k
KCZocDZ4eF9yZWRfbGVkKTsKKwlsZWRfY2xhc3NkZXZfc3VzcGVuZCgmaHA2eHhfZ3JlZW5fbGVk
KTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBocDZ4eGxlZF9yZXN1bWUoc3RydWN0IHBs
YXRmb3JtX2RldmljZSAqZGV2KQoreworCWxlZF9jbGFzc2Rldl9yZXN1bWUoJmhwNnh4X3JlZF9s
ZWQpOworCWxlZF9jbGFzc2Rldl9yZXN1bWUoJmhwNnh4X2dyZWVuX2xlZCk7CisJcmV0dXJuIDA7
Cit9CisjZW5kaWYKKworc3RhdGljIGludCBocDZ4eGxlZF9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlICpwZGV2KQoreworCWludCByZXQ7CisKKwlyZXQgPSBsZWRfY2xhc3NkZXZfcmVnaXN0
ZXIoJnBkZXYtPmRldiwgJmhwNnh4X3JlZF9sZWQpOworCWlmIChyZXQgPCAwKQorCQlyZXR1cm4g
cmV0OworCisJcmV0ID0gbGVkX2NsYXNzZGV2X3JlZ2lzdGVyKCZwZGV2LT5kZXYsICZocDZ4eF9n
cmVlbl9sZWQpOworCWlmIChyZXQgPCAwKQorCQlsZWRfY2xhc3NkZXZfdW5yZWdpc3RlcigmaHA2
eHhfcmVkX2xlZCk7CisKKwlyZXR1cm4gcmV0OworfQorCitzdGF0aWMgaW50IGhwNnh4bGVkX3Jl
bW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQoreworCWxlZF9jbGFzc2Rldl91bnJl
Z2lzdGVyKCZocDZ4eF9yZWRfbGVkKTsKKwlsZWRfY2xhc3NkZXZfdW5yZWdpc3RlcigmaHA2eHhf
Z3JlZW5fbGVkKTsKKworCXJldHVybiAwOworfQorCitzdGF0aWMgc3RydWN0IHBsYXRmb3JtX2Ry
aXZlciBocDZ4eGxlZF9kcml2ZXIgPSB7CisJLnByb2JlCQk9IGhwNnh4bGVkX3Byb2JlLAorCS5y
ZW1vdmUJCT0gaHA2eHhsZWRfcmVtb3ZlLAorI2lmZGVmIENPTkZJR19QTQorCS5zdXNwZW5kCT0g
aHA2eHhsZWRfc3VzcGVuZCwKKwkucmVzdW1lCQk9IGhwNnh4bGVkX3Jlc3VtZSwKKyNlbmRpZgor
CS5kcml2ZXIJCT0geworCQkubmFtZQkJPSAiaHA2eHgtbGVkIiwKKwl9LAorfTsKKworc3RhdGlj
IGludCBfX2luaXQgaHA2eHhsZWRfaW5pdCh2b2lkKQoreworCXJldHVybiBwbGF0Zm9ybV9kcml2
ZXJfcmVnaXN0ZXIoJmhwNnh4bGVkX2RyaXZlcik7Cit9CisKK3N0YXRpYyB2b2lkIF9fZXhpdCBo
cDZ4eGxlZF9leGl0KHZvaWQpCit7CisJcGxhdGZvcm1fZHJpdmVyX3VucmVnaXN0ZXIoJmhwNnh4
bGVkX2RyaXZlcik7Cit9CisKK21vZHVsZV9pbml0KGhwNnh4bGVkX2luaXQpOworbW9kdWxlX2V4
aXQoaHA2eHhsZWRfZXhpdCk7CisKK01PRFVMRV9BVVRIT1IoIktyaXN0b2ZmZXIgRXJpY3NvbiA8
a3Jpc3RvZmZlci5lcmljc29uQGdtYWlsLmNvbT4iKTsKK01PRFVMRV9ERVNDUklQVElPTigiSFAg
Sm9ybmFkYSA2eHggTEVEIGRyaXZlciIpOworTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwo=

--Multipart=_Tue__5_Feb_2008_19_13_56_+0100_33dk_5V=WhrmDp1d--
