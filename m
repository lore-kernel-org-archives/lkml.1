Return-Path: <linux-kernel-owner+w=401wt.eu-S1759551AbZCYKy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551AbZCYKy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 06:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbZCYKyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 06:54:36 -0400
Received: from mx1.emlix.com ([193.175.82.87]:54510 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbZCYKyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 06:54:35 -0400
From: =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       =?utf-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>
Subject: [patch 1/3] rtc: add m41t62 support to rtc-m41t80 driver
Date: Wed, 25 Mar 2009 11:55:35 +0100
Message-Id: <1237978537-23681-1-git-send-email-dg@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Organization: emlix gmbh, Goettingen, Germany"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compared to the other supported chips, the m41t62 uses a different
register to set the square wave frequency.

Signed-off-by: Daniel Glöckner <dg@emlix.com>
---
 drivers/rtc/Kconfig      |    4 ++--
 drivers/rtc/rtc-m41t80.c |   18 +++++++++++++-----
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 81450fb..1a9af76 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -224,11 +224,11 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 config RTC_DRV_M41T80
-	tristate "ST M41T65/M41T80/81/82/83/84/85/87"
+	tristate "ST M41T62/65/M41T80/81/82/83/84/85/87"
 	help
 	  If you say Y here you will get support for the ST M41T60
 	  and M41T80 RTC chips series. Currently, the following chips are
-	  supported: M41T65, M41T80, M41T81, M41T82, M41T83, M41ST84,
+	  supported: M41T62, M41T65, M41T80, M41T81, M41T82, M41T83, M41ST84,
 	  M41ST85, and M41ST87.
 
 	  This driver can also be built as a module. If so, the module
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 893f7de..60fe266 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -64,10 +64,12 @@
 #define M41T80_FEATURE_BL	(1 << 1)	/* Battery low indicator */
 #define M41T80_FEATURE_SQ	(1 << 2)	/* Squarewave feature */
 #define M41T80_FEATURE_WD	(1 << 3)	/* Extra watchdog resolution */
+#define M41T80_FEATURE_SQ_ALT	(1 << 4)	/* RSx bits are in reg 4 */
 
 #define DRV_VERSION "0.05"
 
 static const struct i2c_device_id m41t80_id[] = {
+	{ "m41t62", M41T80_FEATURE_SQ | M41T80_FEATURE_SQ_ALT },
 	{ "m41t65", M41T80_FEATURE_HT | M41T80_FEATURE_WD },
 	{ "m41t80", M41T80_FEATURE_SQ },
 	{ "m41t81", M41T80_FEATURE_HT | M41T80_FEATURE_SQ},
@@ -393,12 +395,15 @@ static ssize_t m41t80_sysfs_show_sqwfreq(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
-	int val;
+	int val, reg_sqw;
 
 	if (!(clientdata->features & M41T80_FEATURE_SQ))
 		return -EINVAL;
 
-	val = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
+	reg_sqw = M41T80_REG_SQW;
+	if (clientdata->features & M41T80_FEATURE_SQ_ALT)
+		reg_sqw = M41T80_REG_WDAY;
+	val = i2c_smbus_read_byte_data(client, reg_sqw);
 	if (val < 0)
 		return -EIO;
 	val = (val >> 4) & 0xf;
@@ -419,7 +424,7 @@ static ssize_t m41t80_sysfs_set_sqwfreq(struct device *dev,
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	struct m41t80_data *clientdata = i2c_get_clientdata(client);
-	int almon, sqw;
+	int almon, sqw, reg_sqw;
 	int val = simple_strtoul(buf, NULL, 0);
 
 	if (!(clientdata->features & M41T80_FEATURE_SQ))
@@ -440,13 +445,16 @@ static ssize_t m41t80_sysfs_set_sqwfreq(struct device *dev,
 	almon = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
 	if (almon < 0)
 		return -EIO;
-	sqw = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
+	reg_sqw = M41T80_REG_SQW;
+	if (clientdata->features & M41T80_FEATURE_SQ_ALT)
+		reg_sqw = M41T80_REG_WDAY;
+	sqw = i2c_smbus_read_byte_data(client, reg_sqw);
 	if (sqw < 0)
 		return -EIO;
 	sqw = (sqw & 0x0f) | (val << 4);
 	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
 				      almon & ~M41T80_ALMON_SQWE) < 0 ||
-	    i2c_smbus_write_byte_data(client, M41T80_REG_SQW, sqw) < 0)
+	    i2c_smbus_write_byte_data(client, reg_sqw, sqw) < 0)
 		return -EIO;
 	if (val && i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
 					     almon | M41T80_ALMON_SQWE) < 0)
-- 
1.6.2.107.ge47ee

