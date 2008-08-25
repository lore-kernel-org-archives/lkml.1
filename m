Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYHYRsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYHYRsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYHYRsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:48:13 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:34187 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYHYRsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:48:12 -0400
X-Greylist: delayed 1250 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Aug 2008 13:48:12 EDT
Message-ID: <48B2EB77.9000103@harris.com>
Date: Mon, 25 Aug 2008 13:27:19 -0400
From: "Steven A. Falco" <sfalco@harris.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [RFC] Driver for Real Time Clock chip ST M41T65
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Aug 2008 17:27:20.0202 (UTC) FILETIME=[D40B5EA0:01C906D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will be using a Real Time Clock chip, ST M41T65, on a new embedded system.
The chip is quite similar to the M41T8x family, which already has driver
rtc-m41t80.c.

Would it be more acceptible to generalize rtc-m41t80.c (perhaps renaming it to
rtc-m41txx.c) or would it be better to create a new rtc-m41t6x.c?

The main differences I see between the M41T65 and M41T80 are that:

1) The M41T65 watchdog timer has three bits controlling resolution (versus two
   for the M41T80).

2) There is no register 0x13 for controlling square-wave output.

Here is the patch I am currently using (on some prototype hardware), for
reference.  I've introduced two new feature bits to cover the above
differences.  I have not yet done any renaming, nor have I modified any of the
defconfigs to account for a name change.

	Steve Falco
	sfalco@harris.com

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index a3e0880..4d9b1a9 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -58,18 +58,21 @@
 
 #define M41T80_FEATURE_HT	(1 << 0)
 #define M41T80_FEATURE_BL	(1 << 1)
+#define M41T80_FEATURE_SQ	(1 << 2)
+#define M41T80_FEATURE_WD	(1 << 3)
 
 #define DRV_VERSION "0.05"
 
 static const struct i2c_device_id m41t80_id[] = {
-	{ "m41t80", 0 },
-	{ "m41t81", M41T80_FEATURE_HT },
-	{ "m41t81s", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41t82", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41t83", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41st84", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41st85", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
-	{ "m41st87", M41T80_FEATURE_HT | M41T80_FEATURE_BL },
+	{ "m41t65", M41T80_FEATURE_HT | M41T80_FEATURE_WD },
+	{ "m41t80", M41T80_FEATURE_SQ },
+	{ "m41t81", M41T80_FEATURE_HT | M41T80_FEATURE_SQ},
+	{ "m41t81s", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41t82", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41t83", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41st84", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41st85", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
+	{ "m41st87", M41T80_FEATURE_HT | M41T80_FEATURE_BL | M41T80_FEATURE_SQ },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, m41t80_id);
@@ -385,8 +388,12 @@ static ssize_t m41t80_sysfs_show_sqwfreq(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct m41t80_data *clientdata = i2c_get_clientdata(client);
 	int val;
 
+	if (!(clientdata->features & M41T80_FEATURE_SQ))
+		return -EINVAL;
+
 	val = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
 	if (val < 0)
 		return -EIO;
@@ -407,9 +414,13 @@ static ssize_t m41t80_sysfs_set_sqwfreq(struct device *dev,
 				const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
+	struct m41t80_data *clientdata = i2c_get_clientdata(client);
 	int almon, sqw;
 	int val = simple_strtoul(buf, NULL, 0);
 
+	if (!(clientdata->features & M41T80_FEATURE_SQ))
+		return -EINVAL;
+
 	if (val) {
 		if (!is_power_of_2(val))
 			return -EINVAL;
@@ -498,6 +509,8 @@ static void wdt_ping(void)
 			.buf	= i2c_data,
 		},
 	};
+	struct m41t80_data *clientdata = i2c_get_clientdata(save_client);
+
 	i2c_data[0] = 0x09;		/* watchdog register */
 
 	if (wdt_margin > 31)
@@ -508,6 +521,12 @@ static void wdt_ping(void)
 		 */
 		i2c_data[1] = wdt_margin<<2 | 0x82;
 
+	/* M41T65 has three bits for resolution.  Don't set bit 7, as that would
+	 * be an invalid resolution.
+	 */
+	if (clientdata->features & M41T80_FEATURE_WD)
+		i2c_data[1] &= ~0x80;
+
 	i2c_transfer(save_client->adapter, msgs1, 1);
 }
 
