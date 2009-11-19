Return-Path: <linux-kernel-owner+w=401wt.eu-S1754261AbZKSJ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbZKSJ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 04:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755337AbZKSJ3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 04:29:22 -0500
Received: from smtp.nokia.com ([192.100.122.230]:41541 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533AbZKSJ2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 04:28:53 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v3 3/5] lis3: Sysfs entry for setting chip measurement rate
Date: Thu, 19 Nov 2009 11:27:20 +0200
Message-Id: <1258622842-23129-4-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1258622842-23129-3-git-send-email-samu.p.onkalo@nokia.com>
References: <1258622842-23129-1-git-send-email-samu.p.onkalo@nokia.com>
 <1258622842-23129-2-git-send-email-samu.p.onkalo@nokia.com>
 <1258622842-23129-3-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 19 Nov 2009 09:27:32.0613 (UTC) FILETIME=[859B2350:01CA68FA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to read position information at the chip measurement
rate via sysfs. This patch adds possibility to configure chip
measurement rate.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   51 ++++++++++++++++++++++++++++++++++++++------
 drivers/hwmon/lis3lv02d.h |    4 +++
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index a953a54..3c781f2 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -121,18 +121,31 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 static int lis3_12_rates[4] = {40, 160, 640, 2560};
 static int lis3_8_rates[2] = {100, 400};
 
+/* ODR is Output Data Rate */
 static int lis3lv02d_get_odr(void)
 {
 	u8 ctrl;
-	int val;
 
 	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+	ctrl &= lis3_dev.odr_mask;
+	return lis3_dev.odrs[(ctrl >> lis3_dev.odr_shift)];
+}
 
-	if (lis3_dev.whoami == WAI_12B)
-		val = lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
-	else
-		val = lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
-	return val;
+static int lis3lv02d_set_odr(int rate)
+{
+	u8 ctrl;
+	int i;
+
+	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+	ctrl &= ~lis3_dev.odr_mask;
+
+	for (i = 0; i < lis3_dev.odr_len; i++)
+		if (lis3_dev.odrs[i] == rate) {
+			lis3_dev.write(&lis3_dev,
+				CTRL_REG1, ctrl | (i << lis3_dev.odr_shift));
+			return 0;
+		}
+	return -EINVAL;
 }
 
 static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
@@ -438,9 +451,25 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
 	return sprintf(buf, "%d\n", lis3lv02d_get_odr());
 }
 
+static ssize_t lis3lv02d_rate_set(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	unsigned long rate;
+
+	if (strict_strtoul(buf, 0, &rate))
+		return -EINVAL;
+
+	if (lis3lv02d_set_odr(rate))
+		return -EINVAL;
+
+	return count;
+}
+
 static DEVICE_ATTR(selftest, S_IRUSR, lis3lv02d_selftest_show, NULL);
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
-static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
+static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
+					    lis3lv02d_rate_set);
 
 static struct attribute *lis3lv02d_attributes[] = {
 	&dev_attr_selftest.attr,
@@ -485,12 +514,20 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->read_data = lis3lv02d_read_12;
 		dev->mdps_max_val = 2048;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
+		dev->odrs = lis3_12_rates;
+		dev->odr_len = ARRAY_SIZE(lis3_12_rates);
+		dev->odr_mask = CTRL1_DF0 | CTRL1_DF1;
+		dev->odr_shift = 4;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
+		dev->odrs = lis3_8_rates;
+		dev->odr_len = ARRAY_SIZE(lis3_8_rates);
+		dev->odr_mask = CTRL1_DR;
+		dev->odr_shift = 7;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 1e9fb03..d7141f4 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -208,6 +208,10 @@ struct lis3lv02d {
 	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
 	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
 
+	int                     *odrs;     /* Supported output data rates */
+	u8                      odr_len;   /* Length of the table above */
+	u8                      odr_shift; /* ODR bit(s) location */
+	u8                      odr_mask;  /* ODR bit mask */
 	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
-- 
1.6.0.4

