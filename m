Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZLDNdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZLDNdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756283AbZLDNdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:33:16 -0500
Received: from mail-px0-f188.google.com ([209.85.216.188]:58268 "EHLO
	mail-px0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034AbZLDNdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:33:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=RAOz+yINSpK1YnMRnw8tvWn9QFpM5lN0yq+zDso3BMhN32UUa2jkLUy/FSV/UTXc26
         r2YwDQYvDEenzpmGehoQ9zUg1ZffbcnocQaq0gusgjo03JH0AKiQzmcmPgIrdztmy/ki
         uRGg5/dqYmjFNL/l6tFiWCrt0P4ZmLRp/UriA=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, akpm@linux-foundation.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       Richard Purdie <rpurdie@rpsys.net>, Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH v7 3/8] Loongson: YeeLoong: add backlight driver
Date: Fri,  4 Dec 2009 21:32:40 +0800
Message-Id: <c2b33b22356136a0cc528c877762a7ae00b4ac08.1259932036.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <cover.1259932036.git.wuzhangjin@gmail.com>
References: <cover.1259932036.git.wuzhangjin@gmail.com>
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
 drivers/platform/mips/yeeloong_laptop.c |   79 +++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index 76f0250..f7a3705 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -17,6 +17,7 @@ if MIPS_PLATFORM_DEVICES
 config LEMOTE_YEELOONG2F
 	tristate "Lemote YeeLoong Laptop"
 	depends on LEMOTE_MACH2F
+	select BACKLIGHT_CLASS_DEVICE
 	default m
 	help
 	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index 85fc7ed..fbc4ebb 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -11,6 +11,77 @@
 
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
+	current_level = ec_read(REG_DISPLAY_BRIGHTNESS);
+	if ((old_level == current_level) && (old_level != level))
+		ec_write(REG_DISPLAY_BRIGHTNESS, level);
+	old_level = level;
+
+	return 0;
+}
+
+static int yeeloong_get_brightness(struct backlight_device *bd)
+{
+	return (int)ec_read(REG_DISPLAY_BRIGHTNESS);
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
@@ -42,11 +113,19 @@ static int __init yeeloong_init(void)
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

