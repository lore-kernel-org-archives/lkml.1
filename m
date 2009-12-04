Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZLDNhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZLDNhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:37:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbZLDNhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:37:05 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:51495 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbZLDNhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:37:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k/qjnWXZVQhBwT1gw1jDgmb+QZ+g7/diTs9q/sU56yzRq+PxNYSjRV+7Asb/ZXi2Tz
         NDVltpyNHtCCyxqtjlzid/OYhWJzSecFM7LWmEuTwPqu1Q7UqPPNuQFeCa8/c59/JoVX
         b2MOKV1YLk/FGz/9KfS7dNtQGdtSXiJ+stiMM=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, luming.yu@intel.com,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH v7 6/8] Loongson: YeeLoong: add video output driver
Date: Fri,  4 Dec 2009 21:36:43 +0800
Message-Id: <5fd87c1f64a3c6d3e51fc6b0224cc1be3cb0d9d5.1259932036.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1259932036.git.wuzhangjin@gmail.com>
References: <cover.1259932036.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch adds Video Output Driver, it provides standard
interface(/sys/class/video_output) to turn on/off the video output of
LCD, CRT.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/platform/mips/Kconfig           |    1 +
 drivers/platform/mips/yeeloong_laptop.c |  147 +++++++++++++++++++++++++++++++
 2 files changed, 148 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index 9c8385c..4a89c01 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -21,6 +21,7 @@ config LEMOTE_YEELOONG2F
 	select SYS_SUPPORTS_APM_EMULATION
 	select APM_EMULATION
 	select HWMON
+	select VIDEO_OUTPUT_CONTROL
 	default m
 	help
 	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index 644aaa7..8378926 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -16,6 +16,7 @@
 #include <linux/apm-emulation.h>/* for battery subdriver */
 #include <linux/hwmon.h>	/* for hwmon subdriver */
 #include <linux/hwmon-sysfs.h>
+#include <linux/video_output.h>	/* for video output subdriver */
 
 #include <ec_kb3310b.h>
 
@@ -397,6 +398,144 @@ static void yeeloong_hwmon_exit(void)
 	}
 }
 
+/* video output subdriver */
+
+static int lcd_video_output_get(struct output_device *od)
+{
+	return ec_read(REG_DISPLAY_LCD);
+}
+
+static int lcd_video_output_set(struct output_device *od)
+{
+	int value;
+	unsigned long status;
+
+	status = !!od->request_state;
+
+	if (status == BIT_DISPLAY_LCD_ON) {
+		/* Turn on LCD */
+		outb(0x31, 0x3c4);
+		value = inb(0x3c5);
+		value = (value & 0xf8) | 0x03;
+		outb(0x31, 0x3c4);
+		outb(value, 0x3c5);
+		/* Turn on backlight */
+		ec_write(REG_BACKLIGHT_CTRL, BIT_BACKLIGHT_ON);
+	} else {
+		/* Turn off backlight */
+		ec_write(REG_BACKLIGHT_CTRL, BIT_BACKLIGHT_OFF);
+		/* Turn off LCD */
+		outb(0x31, 0x3c4);
+		value = inb(0x3c5);
+		value = (value & 0xf8) | 0x02;
+		outb(0x31, 0x3c4);
+		outb(value, 0x3c5);
+	}
+
+	return 0;
+}
+
+static struct output_properties lcd_output_properties = {
+	.set_state = lcd_video_output_set,
+	.get_status = lcd_video_output_get,
+};
+
+static int crt_video_output_get(struct output_device *od)
+{
+	return ec_read(REG_CRT_DETECT);
+}
+
+static int crt_video_output_set(struct output_device *od)
+{
+	int value;
+	unsigned long status;
+
+	status = !!od->request_state;
+
+	if (status == BIT_CRT_DETECT_PLUG) {
+		if (ec_read(REG_CRT_DETECT) == BIT_CRT_DETECT_PLUG) {
+			/* Turn on CRT */
+			outb(0x21, 0x3c4);
+			value = inb(0x3c5);
+			value &= ~(1 << 7);
+			outb(0x21, 0x3c4);
+			outb(value, 0x3c5);
+		}
+	} else {
+		/* Turn off CRT */
+		outb(0x21, 0x3c4);
+		value = inb(0x3c5);
+		value |= (1 << 7);
+		outb(0x21, 0x3c4);
+		outb(value, 0x3c5);
+	}
+
+	return 0;
+}
+
+static struct output_properties crt_output_properties = {
+	.set_state = crt_video_output_set,
+	.get_status = crt_video_output_get,
+};
+
+static struct output_device *lcd_output_dev, *crt_output_dev;
+
+static void yeeloong_lcd_vo_set(int status)
+{
+	lcd_output_dev->request_state = status;
+	lcd_video_output_set(lcd_output_dev);
+}
+
+static void yeeloong_crt_vo_set(int status)
+{
+	crt_output_dev->request_state = status;
+	crt_video_output_set(crt_output_dev);
+}
+
+static int yeeloong_vo_init(void)
+{
+	int ret;
+
+	/* Register video output device: lcd, crt */
+	lcd_output_dev = video_output_register("LCD", NULL, NULL,
+			&lcd_output_properties);
+
+	if (IS_ERR(lcd_output_dev)) {
+		ret = PTR_ERR(lcd_output_dev);
+		lcd_output_dev = NULL;
+		return ret;
+	}
+	/* Ensure LCD is on by default */
+	yeeloong_lcd_vo_set(BIT_DISPLAY_LCD_ON);
+
+	crt_output_dev = video_output_register("CRT", NULL, NULL,
+			&crt_output_properties);
+
+	if (IS_ERR(crt_output_dev)) {
+		ret = PTR_ERR(crt_output_dev);
+		crt_output_dev = NULL;
+		return ret;
+	}
+
+	/* Turn off CRT by default, and will be enabled when the CRT
+	 * connectting event reported by SCI */
+	yeeloong_crt_vo_set(BIT_CRT_DETECT_UNPLUG);
+
+	return 0;
+}
+
+static void yeeloong_vo_exit(void)
+{
+	if (lcd_output_dev) {
+		video_output_unregister(lcd_output_dev);
+		lcd_output_dev = NULL;
+	}
+	if (crt_output_dev) {
+		video_output_unregister(crt_output_dev);
+		crt_output_dev = NULL;
+	}
+}
+
 static struct platform_device_id platform_device_ids[] = {
 	{
 		.name = "yeeloong_laptop",
@@ -443,11 +582,19 @@ static int __init yeeloong_init(void)
 		return ret;
 	}
 
+	ret = yeeloong_vo_init();
+	if (ret) {
+		pr_err("Fail to register yeeloong video output driver.\n");
+		yeeloong_vo_exit();
+		return ret;
+	}
+
 	return 0;
 }
 
 static void __exit yeeloong_exit(void)
 {
+	yeeloong_vo_exit();
 	yeeloong_hwmon_exit();
 	yeeloong_battery_exit();
 	yeeloong_backlight_exit();
-- 
1.6.2.1

