Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZG0Nqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZG0Nqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754740AbZG0Nqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59113 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754500AbZG0Nq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:26 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 05/22] mfd: Conditionally add WM831x backlight subdevice
Date: Mon, 27 Jul 2009 14:45:55 +0100
Message-Id: <1248702372-29534-5-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x backlight driver requires at least the specification of the
current sink to use and a maximum current to allow them to function and
will actively interfere with other users of the regulators it uses if
misconfigured so only register the subdevice for it if this platform
data has been supplied.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c        |   15 +++++++++++++++
 include/linux/mfd/wm831x/pdata.h |    6 ++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index 42bef1d..bc40ea3 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1172,6 +1172,12 @@ static struct mfd_cell wm8312_devs[] = {
 	},
 };
 
+static struct mfd_cell backlight_devs[] = {
+	{
+		.name = "wm831x-backlight",
+	},
+};
+
 /*
  * Instantiate the generic non-control parts of the device.
  */
@@ -1325,6 +1331,15 @@ static int wm831x_device_init(struct wm831x *wm831x, unsigned long id, int irq)
 		goto err_irq;
 	}
 
+	if (pdata && pdata->backlight) {
+		/* Treat errors as non-critical */
+		ret = mfd_add_devices(wm831x->dev, -1, backlight_devs,
+				      ARRAY_SIZE(backlight_devs), NULL, 0);
+		if (ret < 0)
+			dev_err(wm831x->dev, "Failed to add backlight: %d\n",
+				ret);
+	}
+
 	if (pdata && pdata->post_init) {
 		ret = pdata->post_init(wm831x);
 		if (ret != 0) {
diff --git a/include/linux/mfd/wm831x/pdata.h b/include/linux/mfd/wm831x/pdata.h
index 571e601..90d8202 100644
--- a/include/linux/mfd/wm831x/pdata.h
+++ b/include/linux/mfd/wm831x/pdata.h
@@ -18,6 +18,11 @@
 struct wm831x;
 struct regulator_init_data;
 
+struct wm831x_backlight_pdata {
+	int isink;     /** ISINK to use, 1 or 2 */
+	int max_uA;    /** Maximum current to allow */
+};
+
 struct wm831x_backup_pdata {
 	int charger_enable;
 	int no_constant_voltage;  /** Disable constant voltage charging */
@@ -87,6 +92,7 @@ struct wm831x_pdata {
 	int (*post_init)(struct wm831x *wm831x);
 
 	int gpio_base;
+	struct wm831x_backlight_pdata *backlight;
 	struct wm831x_backup_pdata *backup;
 	struct wm831x_battery_pdata *battery;
 	struct wm831x_touch_pdata *touch;
-- 
1.6.3.3

