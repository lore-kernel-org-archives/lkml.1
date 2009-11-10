Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZKJMmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZKJMmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756490AbZKJMmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:42:49 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52725 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbZKJMmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:42:46 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v2 09/10] lis3: Scale output values to mg
Date: Tue, 10 Nov 2009 14:41:11 +0200
Message-Id: <1257856872-11612-10-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 10 Nov 2009 12:41:37.0413 (UTC) FILETIME=[24BADB50:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report output values as 1/1000 of earth gravity.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   31 ++++++++++++++++++++++++++++---
 drivers/hwmon/lis3lv02d.h |    4 ++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index be2eb97..7e72836 100644
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
@@ -105,11 +118,16 @@ static inline int lis3lv02d_get_axis(s8 axis, int hw_values[3])
 static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 {
 	int position[3];
+	int i;
 
 	position[0] = lis3->read_data(lis3, OUTX);
 	position[1] = lis3->read_data(lis3, OUTY);
 	position[2] = lis3->read_data(lis3, OUTZ);
 
+	for (i = 0; i < 3; i++)
+		position[i] = (position[i] * lis3->scale) /
+			LIS3_SCALING_ACCURACY;
+
 	*x = lis3lv02d_get_axis(lis3->ac.x, position);
 	*y = lis3lv02d_get_axis(lis3->ac.y, position);
 	*z = lis3lv02d_get_axis(lis3->ac.z, position);
@@ -385,6 +403,7 @@ int lis3lv02d_joystick_enable(void)
 {
 	struct input_dev *input_dev;
 	int err;
+	int max_val, fuzz, flat;
 
 	if (lis3_dev.idev)
 		return -EINVAL;
@@ -404,9 +423,13 @@ int lis3lv02d_joystick_enable(void)
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
@@ -521,12 +544,14 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->read_data = lis3lv02d_read_12;
 		dev->mdps_max_val = 2048;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
+		dev->scale = LIS3_2G2G_SENSITIVITY_WAI_12B;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
+		dev->scale = LIS3_2G2G_SENSITIVITY_WAI_8B;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index a692116..42618b8 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -212,6 +212,10 @@ struct lis3lv02d {
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
1.5.6.3

