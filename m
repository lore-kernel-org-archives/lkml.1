Return-Path: <linux-kernel-owner+w=401wt.eu-S932745AbZJAOlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745AbZJAOlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932723AbZJAOlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:41:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34133 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932722AbZJAOlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:41:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 4/4] mfd: Add support for WM8320 PMICs
Date: Thu,  1 Oct 2009 15:41:07 +0100
Message-Id: <1254408067-15908-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM8320 is an integrated power management subsystem providing
voltage regulators, RTC, watchdog and other functionality. The
WM8320 is derived from the WM831x and therefore shares most of
the driver code with the WM831x.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/Kconfig             |    6 +-
 drivers/mfd/wm831x-core.c       |  159 +++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/core.h |    1 +
 3 files changed, 163 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 570be13..f88cce4 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -171,12 +171,12 @@ config MFD_WM8400
 	  the functionality of the device.
 
 config MFD_WM831X
-	tristate "Support Wolfson Microelectronics WM831x PMICs"
+	tristate "Support Wolfson Microelectronics WM831x/2x PMICs"
 	select MFD_CORE
 	depends on I2C
 	help
-	  Support for the Wolfson Microelecronics WM831x PMICs.  This
-	  driver provides common support for accessing the device,
+	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs.
+	  This driver provides common support for accessing the device,
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
 
diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 45d6770..015df29 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -93,6 +93,7 @@ enum wm831x_parent {
 	WM8310 = 0x8310,
 	WM8311 = 0x8311,
 	WM8312 = 0x8312,
+	WM8320 = 0x8320,
 };
 
 static int wm831x_reg_locked(struct wm831x *wm831x, unsigned short reg)
@@ -478,6 +479,20 @@ static struct resource wm831x_dcdc4_resources[] = {
 	},
 };
 
+static struct resource wm8320_dcdc4_buck_resources[] = {
+	{
+		.start = WM831X_DC4_CONTROL,
+		.end   = WM832X_DC4_SLEEP_CONTROL,
+		.flags = IORESOURCE_IO,
+	},
+	{
+		.name  = "UV",
+		.start = WM831X_IRQ_UV_DC4,
+		.end   = WM831X_IRQ_UV_DC4,
+		.flags = IORESOURCE_IRQ,
+	},
+};
+
 static struct resource wm831x_gpio_resources[] = {
 	{
 		.start = WM831X_IRQ_GPIO_1,
@@ -1246,6 +1261,137 @@ static struct mfd_cell wm8312_devs[] = {
 	},
 };
 
+static struct mfd_cell wm8320_devs[] = {
+	{
+		.name = "wm831x-backup",
+	},
+	{
+		.name = "wm831x-buckv",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc1_resources),
+		.resources = wm831x_dcdc1_resources,
+	},
+	{
+		.name = "wm831x-buckv",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc2_resources),
+		.resources = wm831x_dcdc2_resources,
+	},
+	{
+		.name = "wm831x-buckp",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_dcdc3_resources),
+		.resources = wm831x_dcdc3_resources,
+	},
+	{
+		.name = "wm831x-buckp",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm8320_dcdc4_buck_resources),
+		.resources = wm8320_dcdc4_buck_resources,
+	},
+	{
+		.name = "wm831x-gpio",
+		.num_resources = ARRAY_SIZE(wm831x_gpio_resources),
+		.resources = wm831x_gpio_resources,
+	},
+	{
+		.name = "wm831x-hwmon",
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_ldo1_resources),
+		.resources = wm831x_ldo1_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_ldo2_resources),
+		.resources = wm831x_ldo2_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 3,
+		.num_resources = ARRAY_SIZE(wm831x_ldo3_resources),
+		.resources = wm831x_ldo3_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 4,
+		.num_resources = ARRAY_SIZE(wm831x_ldo4_resources),
+		.resources = wm831x_ldo4_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 5,
+		.num_resources = ARRAY_SIZE(wm831x_ldo5_resources),
+		.resources = wm831x_ldo5_resources,
+	},
+	{
+		.name = "wm831x-ldo",
+		.id = 6,
+		.num_resources = ARRAY_SIZE(wm831x_ldo6_resources),
+		.resources = wm831x_ldo6_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 7,
+		.num_resources = ARRAY_SIZE(wm831x_ldo7_resources),
+		.resources = wm831x_ldo7_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 8,
+		.num_resources = ARRAY_SIZE(wm831x_ldo8_resources),
+		.resources = wm831x_ldo8_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 9,
+		.num_resources = ARRAY_SIZE(wm831x_ldo9_resources),
+		.resources = wm831x_ldo9_resources,
+	},
+	{
+		.name = "wm831x-aldo",
+		.id = 10,
+		.num_resources = ARRAY_SIZE(wm831x_ldo10_resources),
+		.resources = wm831x_ldo10_resources,
+	},
+	{
+		.name = "wm831x-alive-ldo",
+		.id = 11,
+		.num_resources = ARRAY_SIZE(wm831x_ldo11_resources),
+		.resources = wm831x_ldo11_resources,
+	},
+	{
+		.name = "wm831x-on",
+		.num_resources = ARRAY_SIZE(wm831x_on_resources),
+		.resources = wm831x_on_resources,
+	},
+	{
+		.name = "wm831x-rtc",
+		.num_resources = ARRAY_SIZE(wm831x_rtc_resources),
+		.resources = wm831x_rtc_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 1,
+		.num_resources = ARRAY_SIZE(wm831x_status1_resources),
+		.resources = wm831x_status1_resources,
+	},
+	{
+		.name = "wm831x-status",
+		.id = 2,
+		.num_resources = ARRAY_SIZE(wm831x_status2_resources),
+		.resources = wm831x_status2_resources,
+	},
+	{
+		.name = "wm831x-watchdog",
+		.num_resources = ARRAY_SIZE(wm831x_wdt_resources),
+		.resources = wm831x_wdt_resources,
+	},
+};
+
 static struct mfd_cell backlight_devs[] = {
 	{
 		.name = "wm831x-backlight",
@@ -1318,6 +1464,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		dev_info(wm831x->dev, "WM8312 revision %c\n", 'A' + rev);
 		break;
 
+	case WM8320:
+		parent = WM8320;
+		wm831x->num_gpio = 12;
+		dev_info(wm831x->dev, "WM8320 revision %c\n", 'A' + rev);
+		break;
+
 	default:
 		dev_err(wm831x->dev, "Unknown WM831x device %04x\n", ret);
 		ret = -EINVAL;
@@ -1376,6 +1528,12 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 				      NULL, 0);
 		break;
 
+	case WM8320:
+		ret = mfd_add_devices(wm831x->dev, -1,
+				      wm8320_devs, ARRAY_SIZE(wm8320_devs),
+				      NULL, 0);
+		break;
+
 	default:
 		/* If this happens the bus probe function is buggy */
 		BUG();
@@ -1501,6 +1659,7 @@ static const struct i2c_device_id wm831x_i2c_id[] = {
 	{ "wm8310", WM8310 },
 	{ "wm8311", WM8311 },
 	{ "wm8312", WM8312 },
+	{ "wm8320", WM8320 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, wm831x_i2c_id);
diff --git a/include/linux/mfd/wm831x/core.h b/include/linux/mfd/wm831x/core.h
index c1bc59f..d01d293 100644
--- a/include/linux/mfd/wm831x/core.h
+++ b/include/linux/mfd/wm831x/core.h
@@ -117,6 +117,7 @@
 #define WM831X_DC3_SLEEP_CONTROL                0x4063
 #define WM831X_DC4_CONTROL                      0x4064
 #define WM831X_DC4_SLEEP_CONTROL                0x4065
+#define WM832X_DC4_SLEEP_CONTROL                0x4067
 #define WM831X_EPE1_CONTROL                     0x4066
 #define WM831X_EPE2_CONTROL                     0x4067
 #define WM831X_LDO1_CONTROL                     0x4068
-- 
1.6.4.3

