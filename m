Return-Path: <linux-kernel-owner+w=401wt.eu-S1756476AbZKJMmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbZKJMmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756460AbZKJMmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:42:39 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52715 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbZKJMmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:42:37 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v2 05/10] LIS3LV02D: Proper power on sequence
Date: Tue, 10 Nov 2009 14:41:07 +0200
Message-Id: <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 10 Nov 2009 12:41:28.0867 (UTC) FILETIME=[1FA2D730:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lis3 accelerometer sensors have quite long power on delay (up to 125
ms). This patch adds necessary delay to power on sequence for currently
supported lis3 chips.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   41 +++++++++++++++++++++++++++--------------
 drivers/hwmon/lis3lv02d.h |    1 +
 2 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index b12ee35..39b9ac8 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -50,6 +50,9 @@
  * joystick.
  */
 
+#define LIS3_PWRON_DELAY_WAI_12B	(5000)
+#define LIS3_PWRON_DELAY_WAI_8B		(3000)
+
 struct lis3lv02d lis3_dev = {
 	.misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(lis3_dev.misc_wait),
 };
@@ -112,6 +115,24 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 	*z = lis3lv02d_get_axis(lis3->ac.z, position);
 }
 
+/* conversion btw sampling rate and the register values */
+static int lis3_12_rates[4] = {40, 160, 640, 2560};
+static int lis3_8_rates[2] = {100, 400};
+
+static int lis3lv02d_get_odr(void)
+{
+	u8 ctrl;
+	int val;
+
+	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+
+	if (lis3_dev.whoami == WAI_12B)
+		val = lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
+	else
+		val = lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
+	return val;
+}
+
 void lis3lv02d_poweroff(struct lis3lv02d *lis3)
 {
 	/* disable X,Y,Z axis and power down */
@@ -125,6 +146,9 @@ void lis3lv02d_poweron(struct lis3lv02d *lis3)
 
 	lis3->init(lis3);
 
+	/* LIS3 power on delay is quite long */
+	msleep(lis3->pwron_delay / lis3lv02d_get_odr());
+
 	/*
 	 * Common configuration
 	 * BDU: (12 bits sensors only) LSB and MSB values are not updated until
@@ -364,23 +388,10 @@ static ssize_t lis3lv02d_calibrate_store(struct device *dev,
 	return count;
 }
 
-/* conversion btw sampling rate and the register values */
-static int lis3_12_rates[4] = {40, 160, 640, 2560};
-static int lis3_8_rates[2] = {100, 400};
 static ssize_t lis3lv02d_rate_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
-	u8 ctrl;
-	int val;
-
-	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
-
-	if (lis3_dev.whoami == WAI_12B)
-		val = lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
-	else
-		val = lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
-
-	return sprintf(buf, "%d\n", val);
+	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
 }
 
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
@@ -430,11 +441,13 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		printk(KERN_INFO DRIVER_NAME ": 12 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_12;
 		dev->mdps_max_val = 2048;
+		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
+		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index c6ae507..c57f21f 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -202,6 +202,7 @@ struct lis3lv02d {
 	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
+	int			pwron_delay;
 
 	struct input_polled_dev	*idev;     /* input device */
 	struct platform_device	*pdev;     /* platform device */
-- 
1.5.6.3

