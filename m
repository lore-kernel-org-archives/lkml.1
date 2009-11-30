Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZK3PMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZK3PMf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZK3PMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:12:34 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:31579 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZK3PMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:12:33 -0500
X-Spam-Flag: NO
X-Spam-Score: -14.389
Message-ID: <4B13E0DA.5030105@tremplin-utc.net>
Date: Mon, 30 Nov 2009 16:12:26 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v3 3/5] lis3: Sysfs entry for setting chip measurement
 rate
References: <1258622842-23129-1-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-2-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-3-git-send-email-samu.p.onkalo@nokia.com> <1258622842-23129-4-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1258622842-23129-4-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 19-11-09 10:27, Samu Onkalo schreef:
> It is possible to read position information at the chip measurement
> rate via sysfs. This patch adds possibility to configure chip
> measurement rate.
> 
Hi, it's only a slow path, so I suggest to use less variables and
compute them on the fly. Here is a new version of the patch.

Eric

8<--------------------------------------------------------
From: Samu Onkalo <samu.p.onkalo@nokia.com>
It is possible to read position information at the chip measurement
rate via sysfs. This patch adds possibility to configure chip
measurement rate.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
Signed-off-by: Éric Piel <eric.piel@tremplin-utc.net>
---
 drivers/hwmon/lis3lv02d.c |   50 ++++++++++++++++++++++++++++++++++++++------
 drivers/hwmon/lis3lv02d.h |    2 +
 2 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index a953a54..61c1973 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -121,18 +121,34 @@ static void lis3lv02d_get_xyz(struct lis3lv02d *lis3, int *x, int *y, int *z)
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
+			lis3_dev.write(&lis3_dev, CTRL_REG1, ctrl | (i << shift));
+			return 0;
+		}
+	return -EINVAL;
 }
 
 static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
@@ -438,9 +454,25 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
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
@@ -485,12 +517,16 @@ int lis3lv02d_init_device(struct lis3lv02d *dev)
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
1.6.5.3

