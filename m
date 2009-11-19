Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbZKSJ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbZKSJ3l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757628AbZKSJ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:29:41 -0500
Received: from smtp.nokia.com ([192.100.105.134]:16931 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZKSJ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:28:36 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v3 4/5] lis3: Scale output values to mg
Date: Thu, 19 Nov 2009 11:27:21 +0200
Message-Id: <1258622842-23129-5-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1258622842-23129-4-git-send-email-samu.p.onkalo@nokia.com>
References: <1258622842-23129-1-git-send-email-samu.p.onkalo@nokia.com>
 <1258622842-23129-2-git-send-email-samu.p.onkalo@nokia.com>
 <1258622842-23129-3-git-send-email-samu.p.onkalo@nokia.com>
 <1258622842-23129-4-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 19 Nov 2009 09:27:34.0348 (UTC) FILETIME=[86A3E0C0:01CA68FA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report output values as 1/1000 of earth gravity.

Output values from lis3 can be read from sysfs position entry and
from input device. Input device can be accessed as event device
and as joystick device. Joystick device can be in two modes. Meaning of the
output values varies from case to case depending on the chip type
and configuration (scale). Only joystick interface in JS_CORR_BROKEN mode
returned somehow similar output values in different configurations.
Joystick device is in that state by default in case of lis3.

Position sysfs entry, input event device and raw joystick device
have been little bit broken since meaning of the output values has been
varied between 12 and 8 bit devices. Applications which relayed on those
methods failed if the chip is different than the expected one.

This patch converts output values to mean similar thing in different
configurations. Both 8 and 12 bit devices reports now same acceleration values.
If somebody implements full scale support to the driver, output values will
still mean the same. Scaling factor and input device range must be updated
in that case.

Joystick interface in JS_CORR_BROKEN mode is not touched by this patch.
All other interfaces have different scale after this change.
For 12 bit device scaling factor is 0.977 which keeps scaled and unscaled
values are quite close to each others.
For 8 bit device, scaled values are 18 times bigger than unscaled values.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   31 ++++++++++++++++++++++++++++---
 drivers/hwmon/lis3lv02d.h |    4 ++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 3c781f2..480a397 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -53,6 +53,19 @@
 #define LIS3_PWRON_DELAY_WAI_12B	(5000)
 #define LIS3_PWRON_DELAY_WAI_8B		(3000)
 
+/*
+ * LIS3LV02D spec says 1024 LSBs corresponds 1 G -> 1LSB is 1000/1024 mG
+ * LIS302D spec says: 18 mG / digit
+ * SCALING_ACCURACY is used to increase accuracy of the intermediate
+ * calculation results.
+ */
+#define LIS3_SCALING_ACCURACY           1024
+#define LIS3_2G2G_SENSITIVITY_WAI_12B	((LIS3_SCALING_ACCURACY * 1000) / 1024)
+#define LIS3_2G2G_SENSITIVITY_WAI_8B	(18 * LIS3_SCALING_ACCURACY)
+
+#define LIS3_DEFAULT_FUZZ		3
+#define LIS3_DEFAULT_FLAT		3
+
 struct lis3lv02d lis3_dev = {
 	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
 };
@@ -105,6 +118,7 @@ static inline int lis3lv02d_get_axis(s8 axis, int hw_values[3])
 static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 {
 	int position[3];
+	int i;
 
 	mutex_lock(&lis3->mutex);
 	position[0] = lis3->read_data(lis3, OUTX);
@@ -112,6 +126,10 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 	position[2] = lis3->read_data(lis3, OUTZ);
 	mutex_unlock(&lis3->mutex);
 
+	for (i = 0; i < 3; i++)
+		position[i] = (position[i] * lis3->scale) /
+			LIS3_SCALING_ACCURACY;
+
 	*x = lis3lv02d_get_axis(lis3->ac.x, position);
 	*y = lis3lv02d_get_axis(lis3->ac.y, position);
 	*z = lis3lv02d_get_axis(lis3->ac.z, position);
@@ -378,6 +396,7 @@ int lis3lv02d_joystick_enable(void)
 {
 	struct input_dev *input_dev;
 	int err;
+	int max_val, fuzz, flat;
 
 	if (lis3_dev.idev)
 		return -EINVAL;
@@ -397,9 +416,13 @@ int lis3lv02d_joystick_enable(void)
 	input_dev->dev.parent = &lis3_dev.pdev->dev;
 
 	set_bit(EV_ABS, input_dev->evbit);
-	input_set_abs_params(input_dev, ABS_X, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
-	input_set_abs_params(input_dev, ABS_Y, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
-	input_set_abs_params(input_dev, ABS_Z, -lis3_dev.mdps_max_val, lis3_dev.mdps_max_val, 3, 3);
+	max_val = (lis3_dev.mdps_max_val * lis3_dev.scale)
+		/ LIS3_SCALING_ACCURACY;
+	fuzz = (LIS3_DEFAULT_FUZZ * lis3_dev.scale)  / LIS3_SCALING_ACCURACY;
+	flat = (LIS3_DEFAULT_FLAT * lis3_dev.scale) / LIS3_SCALING_ACCURACY;
+	input_set_abs_params(input_dev, ABS_X, -max_val, max_val, fuzz, flat);
+	input_set_abs_params(input_dev, ABS_Y, -max_val, max_val, fuzz, flat);
+	input_set_abs_params(input_dev, ABS_Z, -max_val, max_val, fuzz, flat);
 
 	err = input_register_polled_device(lis3_dev.idev);
 	if (err) {
@@ -518,6 +541,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->odr_len = ARRAY_SIZE(lis3_12_rates);
 		dev->odr_mask = CTRL1_DF0 | CTRL1_DF1;
 		dev->odr_shift = 4;
+		dev->scale = LIS3_2G2G_SENSITIVITY_WAI_12B;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
@@ -528,6 +552,7 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->odr_len = ARRAY_SIZE(lis3_8_rates);
 		dev->odr_mask = CTRL1_DR;
 		dev->odr_shift = 7;
+		dev->scale = LIS3_2G2G_SENSITIVITY_WAI_8B;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index d7141f4..e0bcb77 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -216,6 +216,10 @@ struct lis3lv02d {
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
 	int			pwron_delay;
+	int                     scale; /*
+					* relationship between 1 LBS and mG
+					* (1/1000th of earth gravity)
+					*/
 
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
-- 
1.6.0.4

