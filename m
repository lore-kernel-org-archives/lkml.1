Return-Path: <linux-kernel-owner+w=401wt.eu-S1753955AbZHXXpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbZHXXpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 19:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753878AbZHXXpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 19:45:09 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:58096 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868AbZHXXpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 19:45:08 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nicolas@boichat.ch, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] hwmon: applesmc: restore accelerometer and keyboard backlight on resume
Date: Tue, 25 Aug 2009 01:42:01 +0200
Message-Id: <1251157321-25535-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.6.3.3
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1MfjCG-0005E8-BK.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1MfjCG-0005E8-BK dbbe9a854abf362018ba2237e261d2dd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On resume from suspend, the driver currently resets the logical
state as if it was brought up from halt. This patch uses the
dev_pm_ops.resume/restore methods to synchronize the hardware with
the memorized logical state, in effect bringing back the accelerometer
and backlight to the state prior to suspend. Works for both suspend to
ram and hibernation. The patch has zero effect on the running state.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   38 ++++++++++++++++++++++++++------------
 1 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 678e34b..b7ab1a0 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -178,6 +178,8 @@ static const int debug;
 static struct platform_device *pdev;
 static s16 rest_x;
 static s16 rest_y;
+static u8 backlight_state[2];
+
 static struct device *hwmon_dev;
 static struct input_polled_dev *applesmc_idev;
 
@@ -497,17 +499,36 @@ static int applesmc_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int applesmc_resume(struct platform_device *dev)
+/* Synchronize device with memorized backlight state */
+static int applesmc_pm_resume(struct device *dev)
 {
-	return applesmc_device_init();
+	mutex_lock(&applesmc_lock);
+	if (applesmc_light)
+		applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
+	mutex_unlock(&applesmc_lock);
+	return 0;
 }
 
+/* Reinitialize device on resume from hibernation */
+static int applesmc_pm_restore(struct device *dev)
+{
+	int ret = applesmc_device_init();
+	if (ret)
+		return ret;
+	return applesmc_pm_resume(dev);
+}
+
+static struct dev_pm_ops applesmc_pm_ops = {
+	.resume = applesmc_pm_resume,
+	.restore = applesmc_pm_restore,
+};
+
 static struct platform_driver applesmc_driver = {
 	.probe = applesmc_probe,
-	.resume = applesmc_resume,
 	.driver	= {
 		.name = "applesmc",
 		.owner = THIS_MODULE,
+		.pm = &applesmc_pm_ops,
 	},
 };
 
@@ -804,17 +825,10 @@ static ssize_t applesmc_calibrate_store(struct device *dev,
 	return count;
 }
 
-/* Store the next backlight value to be written by the work */
-static unsigned int backlight_value;
-
 static void applesmc_backlight_set(struct work_struct *work)
 {
-	u8 buffer[2];
-
 	mutex_lock(&applesmc_lock);
-	buffer[0] = backlight_value;
-	buffer[1] = 0x00;
-	applesmc_write_key(BACKLIGHT_KEY, buffer, 2);
+	applesmc_write_key(BACKLIGHT_KEY, backlight_state, 2);
 	mutex_unlock(&applesmc_lock);
 }
 static DECLARE_WORK(backlight_work, &applesmc_backlight_set);
@@ -824,7 +838,7 @@ static void applesmc_brightness_set(struct led_classdev *led_cdev,
 {
 	int ret;
 
-	backlight_value = value;
+	backlight_state[0] = value;
 	ret = queue_work(applesmc_led_wq, &backlight_work);
 
 	if (debug && (!ret))
-- 
1.6.3.3

