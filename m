Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbZKJMmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbZKJMmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 07:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756439AbZKJMmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 07:42:38 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52711 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbZKJMmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 07:42:36 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, daniel@caiaq.de, pavel@ucw.cz
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [PATCH v2 08/10] lis3: Sysfs entry for setting chip measurement rate
Date: Tue, 10 Nov 2009 14:41:10 +0200
Message-Id: <1257856872-11612-9-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com>
References: <1257856872-11612-1-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-2-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-3-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-4-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-5-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-6-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-7-git-send-email-samu.p.onkalo@nokia.com>
 <1257856872-11612-8-git-send-email-samu.p.onkalo@nokia.com>
X-OriginalArrivalTime: 10 Nov 2009 12:41:35.0288 (UTC) FILETIME=[23769B80:01CA6203]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to read position information at the chip measurement
rate via sysfs. This patch adds possibility to configure chip
measurement rate.

Signed-off-by: Samu Onkalo <samu.p.onkalo@nokia.com>
---
 drivers/hwmon/lis3lv02d.c |   49 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 48 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/lis3lv02d.c b/drivers/hwmon/lis3lv02d.c
index 5b39257..be2eb97 100644
--- a/drivers/hwmon/lis3lv02d.c
+++ b/drivers/hwmon/lis3lv02d.c
@@ -133,6 +133,37 @@ static int lis3lv02d_get_odr(void)
 	return val;
 }
 
+static int lis3lv02d_set_odr(int rate)
+{
+	u8 ctrl;
+	int i, len, shift;
+	int *rates;
+	int ret = -EINVAL;
+
+	lis3_dev.read(&lis3_dev, CTRL_REG1, &ctrl);
+
+	if (lis3_dev.whoami == WAI_12B) {
+		len = sizeof(lis3_12_rates);
+		rates = lis3_12_rates;
+		shift = 4;
+		ctrl &= ~(CTRL1_DF0 | CTRL1_DF1);
+	} else {
+		len = sizeof(lis3_8_rates);
+		rates = lis3_8_rates;
+		shift = 7;
+		ctrl &= ~CTRL1_DR;
+	}
+
+	for (i = 0; i < len; i++)
+		if (rates[i] == rate) {
+			lis3_dev.write(&lis3_dev,
+				CTRL_REG1, ctrl | (i << shift));
+			ret = 0;
+			break;
+		}
+	return ret;
+}
+
 static int lis3lv02d_selftest(struct lis3lv02d *lis3, s16 results[3])
 {
 	u8 reg;
@@ -427,9 +458,25 @@ static ssize_t lis3lv02d_rate_show(struct device *dev,
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
 static DEVICE_ATTR(selftest, S_IRUGO, lis3lv02d_selftest_show, NULL);
 static DEVICE_ATTR(position, S_IRUGO, lis3lv02d_position_show, NULL);
-static DEVICE_ATTR(rate, S_IRUGO, lis3lv02d_rate_show, NULL);
+static DEVICE_ATTR(rate, S_IRUGO | S_IWUSR, lis3lv02d_rate_show,
+					    lis3lv02d_rate_set);
 
 static struct attribute *lis3lv02d_attributes[] = {
 	&dev_attr_selftest.attr,
-- 
1.5.6.3

