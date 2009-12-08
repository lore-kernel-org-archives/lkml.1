Return-Path: <linux-kernel-owner+w=401wt.eu-S1755693AbZLHORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693AbZLHORS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZLHORP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:17:15 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:47006 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbZLHORJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:17:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iV4Sr0JjNs7csqUQsnTa9PvFivvC6QeZAjFJCQo6Oecz3tuzRIHvsQsP/MH6TdHTNl
         +JAnPvNwBx5v2c13XfP9a4Zb8JiVqDDOeY23u2xvB79KvCo0dP+8sKgnnKj4f9+rzyNo
         Kbb66LIJRG4P66Nfu+D9BcP8gJYkT24q7+bxI=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v9 6/8] Loongson: YeeLoong: add video output driver
Date: Tue,  8 Dec 2009 22:15:54 +0800
Message-Id: <234c5ecd475b05e3eb17ead3ae107cfe3426e0e0.1260281599.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260254344.git.wuzhangjin@gmail.com>
 <39d232e3f8359e9c11bad7536f0162444401ec94.1260281599.git.wuzhangjin@gmail.com>
 <7676d8397e593dbec0d40e24429b7ccbcecfa588.1260281599.git.wuzhangjin@gmail.com>
 <4d821efaecc3dee0b9124119507a694e81572437.1260281599.git.wuzhangjin@gmail.com>
 <5c426a5091bee3e4483fc0b93f26359e2840428b.1260281599.git.wuzhangjin@gmail.com>
 <5e9acb4cd757075f617daa45cbd6f5fad94678ac.1260281599.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260281599.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch adds Video Output Driver, it provides standard
interface(/sys/class/video_output) to turn on/off the video output of
LCD, CRT.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/platform/mips/Kconfig           |    1 +
 drivers/platform/mips/yeeloong_laptop.c |  139 +++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index 352594c..e2dbe28 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -21,6 +21,7 @@ config LEMOTE_YEELOONG2F
 	select SYS_SUPPORTS_APM_EMULATION
 	select APM_EMULATION
 	select HWMON
+	select VIDEO_OUTPUT_CONTROL
 	help
 	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
 	  compatible to FuLoong2F mini PC, but it has an extra Embedded
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index becda4f..f8907da 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -16,6 +16,7 @@
 #include <linux/apm-emulation.h>/* for battery subdriver */
 #include <linux/hwmon.h>	/* for hwmon subdriver */
 #include <linux/hwmon-sysfs.h>
+#include <linux/video_output.h>	/* for video output subdriver */
 
 #include <ec_kb3310b.h>
 
@@ -381,6 +382,136 @@ static void yeeloong_hwmon_exit(void)
 	}
 }
 
+/* video output subdriver */
+
+static int lcd_video_output_get(struct output_device *od)
+{
+	return ec_read(REG_DISPLAY_LCD);
+}
+
+#define LCD	0
+#define CRT	1
+
+static void display_vo_set(int display, int on)
+{
+	int addr;
+	unsigned long value;
+
+	addr = (display == LCD) ? 0x31 : 0x21;
+
+	outb(addr, 0x3c4);
+	value = inb(0x3c5);
+
+	if (display == LCD)
+		value |= (on ? 0x03 : 0x02);
+	else {
+		if (on)
+			clear_bit(7, &value);
+		else
+			set_bit(7, &value);
+	}
+
+	outb(addr, 0x3c4);
+	outb(value, 0x3c5);
+}
+
+static int lcd_video_output_set(struct output_device *od)
+{
+	unsigned long status;
+
+	status = !!od->request_state;
+
+	display_vo_set(LCD, status);
+	ec_write(REG_BACKLIGHT_CTRL, status);
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
+	unsigned long status;
+
+	status = !!od->request_state;
+
+	if (ec_read(REG_CRT_DETECT) == BIT_CRT_DETECT_PLUG)
+		display_vo_set(CRT, status);
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
@@ -427,11 +558,19 @@ static int __init yeeloong_init(void)
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

