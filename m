Return-Path: <linux-kernel-owner+w=401wt.eu-S1753937AbZLAIez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753937AbZLAIez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZLAIey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:34:54 -0500
Received: from smtp.nokia.com ([192.100.122.230]:59278 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912AbZLAIew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:34:52 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v4 3/5] lis3: Sysfs entry for setting chip measurement rate
Date: Tue,  1 Dec 2009 10:33:40 +0200
Message-Id: <1259656422-7697-4-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1259656422-7697-3-git-send-email-samu.p.onkalo@nokia.com>
References: <1259656422-7697-1-git-send-email-samu.p.onkalo@nokia.com>
 <1259656422-7697-2-git-send-email-samu.p.onkalo@nokia.com>
 <1259656422-7697-3-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Dec 2009 08:33:49.0795 (UTC) FILETIME=[019D2330:01CA7261]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to read position information at the chip measurement
rate via sysfs. This patch adds possibility to configure chip
measurement rate.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c |   51 ++++++++++++++++++++++++++++++++++++++------
 drivers/hwmon/lis3lv02d.h |    2 +
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 02ac5fa..ba97ed8 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -121,18 +121,35 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
 static int lis3_12_rates[4] = {40, 160, 640, 2560};
 static int lis3_8_rates[2] = {100, 400};
 
+/* ODR is Output Data Rate */
 static int lis3lv02d_get_odr(void)
 {
 	u8 ctrl;
-	int val;
+	int shift;
 
 	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+	ctrl &= lis3_dev.odr_mask;
+	shift = ffs(lis3_dev.odr_mask) - 1;
+	return lis3_dev.odrs[(ctrl >> shift)];
+}
 
-	if (lis3_dev.whoami == WAI_12B)
-		val = lis3_12_rates[(ctrl & (CTRL1_DF0 | CTRL1_DF1)) >> 4];
-	else
-		val = lis3_8_rates[(ctrl & CTRL1_DR) >> 7];
-	return val;
+static int lis3lv02d_set_odr(int rate)
+{
+	u8 ctrl;
+	int i, len, shift;
+
+	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+	ctrl &= ~lis3_dev.odr_mask;
+	len = 1 << hweight_long(lis3_dev.odr_mask); /* # of possible values */
+	shift = ffs(lis3_dev.odr_mask) - 1;
+
+	for (i = 0; i < len; i++)
+		if (lis3_dev.odrs[i] == rate) {
+			lis3_dev.write(&lis3_dev, CTRL_REG1,
+					ctrl | (i << shift));
+			return 0;
+		}
+	return -EINVAL;
 }
 
 static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
@@ -433,9 +450,25 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
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
@@ -480,12 +513,16 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
 		dev->read_data = lis3lv02d_read_12;
 		dev->mdps_max_val = 2048;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_12B;
+		dev->odrs = lis3_12_rates;
+		dev->odr_mask = CTRL1_DF0 | CTRL1_DF1;
 		break;
 	case WAI_8B:
 		printk(KERN_INFO DRIVER_NAME ": 8 bits sensor found\n");
 		dev->read_data = lis3lv02d_read_8;
 		dev->mdps_max_val = 128;
 		dev->pwron_delay = LIS3_PWRON_DELAY_WAI_8B;
+		dev->odrs = lis3_8_rates;
+		dev->odr_mask = CTRL1_DR;
 		break;
 	default:
 		printk(KERN_ERR DRIVER_NAME
diff --git a/drivers/hwmon/lis3lv02d.h b/drivers/hwmon/lis3lv02d.h
index 1e9fb03..f73c786 100644
--- a/drivers/hwmon/lis3lv02d.h
+++ b/drivers/hwmon/lis3lv02d.h
@@ -208,6 +208,8 @@ struct lis3lv02d {
 	int (*write) (struct lis3lv02d *lis3, int reg, u8 val);
 	int (*read) (struct lis3lv02d *lis3, int reg, u8 *ret);
 
+	int                     *odrs;     /* Supported output data rates */
+	u8                      odr_mask;  /* ODR bit mask */
 	u8			whoami;    /* indicates measurement precision */
 	s16 (*read_data) (struct lis3lv02d *lis3, int reg);
 	int			mdps_max_val;
-- 
1.6.0.4

