Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbYH0Nd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbYH0Nd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:33:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYH0NdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:33:20 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:33812 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbYH0NdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:33:20 -0400
Message-ID: <48B55788.5050306@harris.com>
Date: Wed, 27 Aug 2008 09:32:56 -0400
From: "Steven A. Falco" <sfalco@harris.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
CC: alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       will.newton@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC] Driver for Real Time Clock chip ST M41T65
References: <87a5b0800808260700g52cedf59kb07880ae05a104b@mail.gmail.com>	<20080826161353.6326f6e2@i1501.lan.towertech.it>	<48B4159A.9070907@harris.com> <20080827.213551.72707274.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080827.213551.72707274.anemo@mba.ocn.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2008 13:32:57.0739 (UTC) FILETIME=[6AFD4DB0:01C90849]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for M41T65 Real Time Clock chip.

Signed-off-by: Steven A. Falco <sfalco@harris.com>
---

Ok - here is a respin with the Kconfig modded to indicate support for
the M41T65.


 drivers/rtc/Kconfig      |   12 ++++++------
 drivers/rtc/rtc-m41t80.c |   43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4949dc4..b3da827 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -220,12 +220,12 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 config RTC_DRV_M41T80
-	tristate "ST M41T80/81/82/83/84/85/87"
+	tristate "ST M41T80/81/82/83/84/85/87/65"
 	help
-	  If you say Y here you will get support for the
-	  ST M41T80 RTC chips series. Currently following chips are
-	  supported: M41T80, M41T81, M41T82, M41T83, M41ST84, M41ST85
-	  and M41ST87.
+	  If you say Y here you will get support for the ST M41T80
+	  and M41T60 RTC chips series. Currently, the following chips are
+	  supported: M41T80, M41T81, M41T82, M41T83, M41ST84, M41ST85,
+	  M41ST87, and M41T65.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-m41t80.
@@ -235,7 +235,7 @@ config RTC_DRV_M41T80_WDT
 	depends on RTC_DRV_M41T80
 	help
 	  If you say Y here you will get support for the
-	  watchdog timer in ST M41T80 RTC chips series.
+	  watchdog timer in the ST M41T80 and M41T60 RTC chips series.
 
 config RTC_DRV_TWL92330
 	boolean "TI TWL92330/Menelaus"
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
 
-- 
1.5.5.1

