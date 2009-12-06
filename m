Return-Path: <linux-kernel-owner+w=401wt.eu-S1754310AbZLFHFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbZLFHFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 02:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZLFHFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 02:05:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:54381 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223AbZLFHFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 02:05:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aciTarY1S7vZ0oqHH9o0FbgMBcYeEpJ/NMjW/Ez5QCgr2rBhd9and/0htglvlizdGm
         LUbZw5X1XGoNWMS4t6mvYXxvK+l3nUMRzp66aESTCha+KysJmK1vSS33DHRqLkJ/zliE
         rLkiB/vLCwuJF529NhsQE6oiE4ZM8aaERrNB0=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v8 3/8] Loongson: YeeLoong: add backlight driver
Date: Sun,  6 Dec 2009 15:01:43 +0800
Message-Id: <3c77f3891e73e189cceef7155dc9cb6503084a4b.1260082252.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <5a8742a71e96ba40bee34fb37478cc8339e76530.1260082252.git.wuzhangjin@gmail.com>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
 <d6bb11d33fe01abd6de945117ce647af73841f00.1260082252.git.wuzhangjin@gmail.com>
 <5a8742a71e96ba40bee34fb37478cc8339e76530.1260082252.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1260082252.git.wuzhangjin@gmail.com>
References: <cover.1260082252.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch adds YeeLoong Backlight Driver, it provides standard
interface(/sys/class/backlight/) for user-space applications(e.g.
kpowersave, gnome-power-manager) to control the brightness of the
backlight.

Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/platform/mips/Kconfig           |    1 +
 drivers/platform/mips/yeeloong_laptop.c |   81 +++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index 5ac5215..c1ba03d 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -17,6 +17,7 @@ if MIPS_PLATFORM_DEVICES
 config LEMOTE_YEELOONG2F
 	tristate "Lemote YeeLoong Laptop"
 	depends on LEMOTE_MACH2F
+	select BACKLIGHT_CLASS_DEVICE
 	help
 	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
 	  compatible to FuLoong2F mini PC, but it has an extra Embedded
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index 85fc7ed..f04a7e2 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -11,6 +11,79 @@
 
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/backlight.h>	/* for backlight subdriver */
+#include <linux/fb.h>
+
+#include <ec_kb3310b.h>
+
+/* backlight subdriver */
+#define MAX_BRIGHTNESS	8
+
+static int yeeloong_set_brightness(struct backlight_device *bd)
+{
+	unsigned int level, current_level;
+	static unsigned int old_level;
+
+	level = (bd->props.fb_blank == FB_BLANK_UNBLANK &&
+		 bd->props.power == FB_BLANK_UNBLANK) ?
+	    bd->props.brightness : 0;
+
+	if (level > MAX_BRIGHTNESS)
+		level = MAX_BRIGHTNESS;
+	else if (level < 0)
+		level = 0;
+
+	/* Avoid to modify the brightness when EC is tuning it */
+	if (old_level != level) {
+		current_level = ec_read(REG_DISPLAY_BRIGHTNESS);
+		if (old_level == current_level)
+			ec_write(REG_DISPLAY_BRIGHTNESS, level);
+	}
+	old_level = level;
+
+	return 0;
+}
+
+static int yeeloong_get_brightness(struct backlight_device *bd)
+{
+	return ec_read(REG_DISPLAY_BRIGHTNESS);
+}
+
+static struct backlight_ops backlight_ops = {
+	.get_brightness = yeeloong_get_brightness,
+	.update_status = yeeloong_set_brightness,
+};
+
+static struct backlight_device *yeeloong_backlight_dev;
+
+static int yeeloong_backlight_init(void)
+{
+	int ret;
+
+	yeeloong_backlight_dev = backlight_device_register("backlight0", NULL,
+			NULL, &backlight_ops);
+
+	if (IS_ERR(yeeloong_backlight_dev)) {
+		ret = PTR_ERR(yeeloong_backlight_dev);
+		yeeloong_backlight_dev = NULL;
+		return ret;
+	}
+
+	yeeloong_backlight_dev->props.max_brightness = MAX_BRIGHTNESS;
+	yeeloong_backlight_dev->props.brightness =
+		yeeloong_get_brightness(yeeloong_backlight_dev);
+	backlight_update_status(yeeloong_backlight_dev);
+
+	return 0;
+}
+
+static void yeeloong_backlight_exit(void)
+{
+	if (yeeloong_backlight_dev) {
+		backlight_device_unregister(yeeloong_backlight_dev);
+		yeeloong_backlight_dev = NULL;
+	}
+}
 
 static struct platform_device_id platform_device_ids[] = {
 	{
@@ -42,11 +115,19 @@ static int __init yeeloong_init(void)
 		return ret;
 	}
 
+	ret = yeeloong_backlight_init();
+	if (ret) {
+		pr_err("Fail to register yeeloong backlight driver.\n");
+		yeeloong_backlight_exit();
+		return ret;
+	}
+
 	return 0;
 }
 
 static void __exit yeeloong_exit(void)
 {
+	yeeloong_backlight_exit();
 	platform_driver_unregister(&platform_driver);
 
 	pr_info("Unload YeeLoong Platform Specific Driver.\n");
-- 
1.6.2.1

