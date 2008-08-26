Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbYHZN4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbYHZN4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 09:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755333AbYHZN4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 09:56:15 -0400
Received: from mlbe2k1.cs.myharris.net ([137.237.90.88]:28775 "EHLO
	mlbe2k1.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbYHZN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 09:56:14 -0400
Message-ID: <48B40B68.1040607@harris.com>
Date: Tue, 26 Aug 2008 09:55:52 -0400
From: "Steven A. Falco" <sfalco@harris.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] Driver for Real Time Clock chip ST M41T65
References: <48B2EB77.9000103@harris.com> <87a5b0800808260130i383ec8d0y45690f85366c5059@mail.gmail.com>
In-Reply-To: <87a5b0800808260130i383ec8d0y45690f85366c5059@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Aug 2008 13:55:53.0054 (UTC) FILETIME=[7453F7E0:01C90783]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Newton wrote:
> On Mon, Aug 25, 2008 at 6:27 PM, Steven A. Falco <sfalco@harris.com> wrote:
>> I will be using a Real Time Clock chip, ST M41T65, on a new embedded system.
>> The chip is quite similar to the M41T8x family, which already has driver
>> rtc-m41t80.c.
>>
>> Would it be more acceptible to generalize rtc-m41t80.c (perhaps renaming it to
>> rtc-m41txx.c) or would it be better to create a new rtc-m41t6x.c?

Thanks for the feedback.  Here is a respin which addresses your comments.

I'd also like to know if I should submit a new driver or mod the existing
one.  If I mod the existing one, should it be renamed, should I update the
Kconfig, existing defconfigs, etc?

Signed-off-by: Steven A. Falco <sfalco@harris.com>

diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index a3e0880..7eb4e05 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -55,21 +55,27 @@
 #define M41T80_ALHOUR_HT	(1 << 6)	/* HT: Halt Update Bit */
 #define M41T80_FLAGS_AF		(1 << 6)	/* AF: Alarm Flag Bit */
 #define M41T80_FLAGS_BATT_LOW	(1 << 4)	/* BL: Battery Low Bit */
+#define M41T80_WATCHDOG_RB2	(1 << 7)	/* RB: Watchdog resolution */
+#define M41T80_WATCHDOG_RB1	(1 << 1)	/* RB: Watchdog resolution */
+#define M41T80_WATCHDOG_RB0	(1 << 0)	/* RB: Watchdog resolution */
 
-#define M41T80_FEATURE_HT	(1 << 0)
-#define M41T80_FEATURE_BL	(1 << 1)
+#define M41T80_FEATURE_HT	(1 << 0)	/* Halt feature */
+#define M41T80_FEATURE_BL	(1 << 1)	/* Battery low indicator */
+#define M41T80_FEATURE_SQ	(1 << 2)	/* Squarewave feature */
+#define M41T80_FEATURE_WD	(1 << 3)	/* Extra watchdog resolution */
 
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
@@ -385,8 +391,12 @@ static ssize_t m41t80_sysfs_show_sqwfreq(struct device *dev,
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
@@ -407,9 +417,13 @@ static ssize_t m41t80_sysfs_set_sqwfreq(struct device *dev,
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
@@ -498,6 +512,8 @@ static void wdt_ping(void)
 			.buf	= i2c_data,
 		},
 	};
+	struct m41t80_data *clientdata = i2c_get_clientdata(save_client);
+
 	i2c_data[0] = 0x09;		/* watchdog register */
 
 	if (wdt_margin > 31)
@@ -508,6 +524,13 @@ static void wdt_ping(void)
 		 */
 		i2c_data[1] = wdt_margin<<2 | 0x82;
 
+	/*
+	 * M41T65 has three bits for watchdog resolution.  Don't set bit 7, as
+	 * that would be an invalid resolution.
+	 */
+	if (clientdata->features & M41T80_FEATURE_WD)
+		i2c_data[1] &= ~M41T80_WATCHDOG_RB2;
+
 	i2c_transfer(save_client->adapter, msgs1, 1);
 }
 
