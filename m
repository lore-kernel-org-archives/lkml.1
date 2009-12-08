Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZLHOQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZLHOQy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:16:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZLHOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:16:51 -0500
Received: from mail-px0-f194.google.com ([209.85.216.194]:42223 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbZLHOQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:16:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ScMrD3/hHkI1k9yN5Jz1i61l0Dyog4zLj83cvIGanp4Uhfeyg4fmq5/L6uLZ0Xf/Ye
         svVnxxXEVRYDs1ZLot7v2sIhVrBfrX3sa9pcP1mKrtLieCJTgku+IMSCSRQP5Pk2LBp3
         FCQDd+v+E2tt+EFtbkt2fkVLxjVgn+pTyL9Z4=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: akpm@linux-foundation.org, Wu Zhangjin <wuzhangjin@gmail.com>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "Rafael J . Wysocki" <rjw@sisk.pl>, zhangfx@lemote.com,
       linux-laptop@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH v9 4/8] Loongson: YeeLoong: add battery driver
Date: Tue,  8 Dec 2009 22:15:52 +0800
Message-Id: <5c426a5091bee3e4483fc0b93f26359e2840428b.1260281599.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <4d821efaecc3dee0b9124119507a694e81572437.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260254344.git.wuzhangjin@gmail.com>
 <39d232e3f8359e9c11bad7536f0162444401ec94.1260281599.git.wuzhangjin@gmail.com>
 <7676d8397e593dbec0d40e24429b7ccbcecfa588.1260281599.git.wuzhangjin@gmail.com>
 <4d821efaecc3dee0b9124119507a694e81572437.1260281599.git.wuzhangjin@gmail.com>
In-Reply-To: <cover.1260281599.git.wuzhangjin@gmail.com>
References: <cover.1260281599.git.wuzhangjin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patch adds APM emulated Battery Driver, it provides standard
interface(/proc/apm) for user-space applications(e.g. kpowersave,
gnome-power-manager) to manage the battery.

Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
---
 drivers/platform/mips/Kconfig           |    2 +
 drivers/platform/mips/yeeloong_laptop.c |  108 ++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/mips/Kconfig b/drivers/platform/mips/Kconfig
index c1ba03d..965933b 100644
--- a/drivers/platform/mips/Kconfig
+++ b/drivers/platform/mips/Kconfig
@@ -18,6 +18,8 @@ config LEMOTE_YEELOONG2F
 	tristate "Lemote YeeLoong Laptop"
 	depends on LEMOTE_MACH2F
 	select BACKLIGHT_CLASS_DEVICE
+	select SYS_SUPPORTS_APM_EMULATION
+	select APM_EMULATION
 	help
 	  YeeLoong netbook is a mini laptop made by Lemote, which is basically
 	  compatible to FuLoong2F mini PC, but it has an extra Embedded
diff --git a/drivers/platform/mips/yeeloong_laptop.c b/drivers/platform/mips/yeeloong_laptop.c
index be674c5..b265674 100644
--- a/drivers/platform/mips/yeeloong_laptop.c
+++ b/drivers/platform/mips/yeeloong_laptop.c
@@ -2,7 +2,7 @@
  * Driver for YeeLoong laptop extras
  *
  *  Copyright (C) 2009 Lemote Inc.
- *  Author: Wu Zhangjin <wuzj@lemote.com>
+ *  Author: Wu Zhangjin <wuzj@lemote.com>, Liu Junliang <liujl@lemote.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2 as
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/backlight.h>	/* for backlight subdriver */
 #include <linux/fb.h>
+#include <linux/apm-emulation.h>/* for battery subdriver */
 
 #include <ec_kb3310b.h>
 
@@ -85,6 +86,106 @@ static void yeeloong_backlight_exit(void)
 	}
 }
 
+/* battery subdriver */
+
+static void get_fixed_battery_info(void)
+{
+	int design_cap, full_charged_cap, design_vol, vendor, cell_count;
+
+	design_cap = (ec_read(REG_BAT_DESIGN_CAP_HIGH) << 8)
+	    | ec_read(REG_BAT_DESIGN_CAP_LOW);
+	full_charged_cap = (ec_read(REG_BAT_FULLCHG_CAP_HIGH) << 8)
+	    | ec_read(REG_BAT_FULLCHG_CAP_LOW);
+	design_vol = (ec_read(REG_BAT_DESIGN_VOL_HIGH) << 8)
+	    | ec_read(REG_BAT_DESIGN_VOL_LOW);
+	vendor = ec_read(REG_BAT_VENDOR);
+	cell_count = ec_read(REG_BAT_CELL_COUNT);
+
+	if (vendor != 0) {
+		pr_info("battery vendor(%s), cells count(%d), "
+		       "with designed capacity(%d),designed voltage(%d),"
+		       " full charged capacity(%d)\n",
+		       (vendor ==
+			FLAG_BAT_VENDOR_SANYO) ? "SANYO" : "SIMPLO",
+		       (cell_count == FLAG_BAT_CELL_3S1P) ? 3 : 6,
+		       design_cap, design_vol,
+		       full_charged_cap);
+	}
+}
+
+#define APM_CRITICAL		5
+
+static void get_power_status(struct apm_power_info *info)
+{
+	unsigned char bat_status;
+
+	info->battery_status = APM_BATTERY_STATUS_UNKNOWN;
+	info->battery_flag = APM_BATTERY_FLAG_UNKNOWN;
+	info->units = APM_UNITS_MINS;
+
+	info->battery_life = (ec_read(REG_BAT_RELATIVE_CAP_HIGH) << 8) |
+		(ec_read(REG_BAT_RELATIVE_CAP_LOW));
+
+	info->ac_line_status = (ec_read(REG_BAT_POWER) & BIT_BAT_POWER_ACIN) ?
+		APM_AC_ONLINE : APM_AC_OFFLINE;
+
+	bat_status = ec_read(REG_BAT_STATUS);
+
+	if (!(bat_status & BIT_BAT_STATUS_IN)) {
+		/* no battery inserted */
+		info->battery_status = APM_BATTERY_STATUS_NOT_PRESENT;
+		info->battery_flag = APM_BATTERY_FLAG_NOT_PRESENT;
+		info->time = 0x00;
+		return;
+	}
+
+	/* adapter inserted */
+	if (info->ac_line_status == APM_AC_ONLINE) {
+		if (!(bat_status & BIT_BAT_STATUS_FULL)) {
+			/* battery is not fully charged */
+			info->battery_status = APM_BATTERY_STATUS_CHARGING;
+			info->battery_flag = APM_BATTERY_FLAG_CHARGING;
+		} else {
+			/* battery is fully charged */
+			info->battery_status = APM_BATTERY_STATUS_HIGH;
+			info->battery_flag = APM_BATTERY_FLAG_HIGH;
+			info->battery_life = 100;
+		}
+	} else {
+		/* battery is too low */
+		if (bat_status & BIT_BAT_STATUS_LOW) {
+			info->battery_status = APM_BATTERY_STATUS_LOW;
+			info->battery_flag = APM_BATTERY_FLAG_LOW;
+			if (info->battery_life <= APM_CRITICAL) {
+				/* we should power off the system now */
+				info->battery_status =
+					APM_BATTERY_STATUS_CRITICAL;
+				info->battery_flag = APM_BATTERY_FLAG_CRITICAL;
+			}
+		} else {
+			/* assume the battery is high enough. */
+			info->battery_status = APM_BATTERY_STATUS_HIGH;
+			info->battery_flag = APM_BATTERY_FLAG_HIGH;
+		}
+	}
+	info->time = ((info->battery_life - 3) * 54 + 142) / 60;
+}
+
+static int yeeloong_battery_init(void)
+{
+	get_fixed_battery_info();
+
+	apm_get_power_status = get_power_status;
+
+	return 0;
+}
+
+static void yeeloong_battery_exit(void)
+{
+	if (apm_get_power_status == get_power_status)
+		apm_get_power_status = NULL;
+}
+
 static struct platform_device_id platform_device_ids[] = {
 	{
 		.name = "yeeloong_laptop",
@@ -122,11 +223,14 @@ static int __init yeeloong_init(void)
 		return ret;
 	}
 
+	yeeloong_battery_init();
+
 	return 0;
 }
 
 static void __exit yeeloong_exit(void)
 {
+	yeeloong_battery_exit();
 	yeeloong_backlight_exit();
 	platform_driver_unregister(&platform_driver);
 
@@ -136,6 +240,6 @@ static void __exit yeeloong_exit(void)
 module_init(yeeloong_init);
 module_exit(yeeloong_exit);
 
-MODULE_AUTHOR("Wu Zhangjin <wuzj@lemote.com>");
+MODULE_AUTHOR("Wu Zhangjin <wuzj@lemote.com>; Liu Junliang <liujl@lemote.com>");
 MODULE_DESCRIPTION("YeeLoong laptop driver");
 MODULE_LICENSE("GPL");
-- 
1.6.2.1

