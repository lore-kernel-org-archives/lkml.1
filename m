Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbYH0RWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbYH0RWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751186AbYH0RWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:22:15 -0400
Received: from mlbe2k2.cs.myharris.net ([137.237.90.89]:59293 "EHLO
	mlbe2k2.cs.myharris.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYH0RWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:22:14 -0400
Message-ID: <48B58D3D.6030808@harris.com>
Date: Wed, 27 Aug 2008 13:22:05 -0400
From: "Steven A. Falco" <sfalco@harris.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Atsushi Nemoto <anemo@mba.ocn.ne.jp>, alessandro.zummo@towertech.it,
       rtc-linux@googlegroups.com, will.newton@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] Re: [RFC] Driver for Real Time Clock chip ST M41T65
References: <48B4159A.9070907@harris.com> <20080827.213551.72707274.anemo@mba.ocn.ne.jp> <48B55788.5050306@harris.com> <20080827.225323.118975574.anemo@mba.ocn.ne.jp> <Pine.LNX.4.55.0808271717110.5930@cliff.in.clinika.pl>
In-Reply-To: <Pine.LNX.4.55.0808271717110.5930@cliff.in.clinika.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Aug 2008 17:22:06.0803 (UTC) FILETIME=[6E11FA30:01C90869]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for M41T65 Real Time Clock chip

Signed-off-by: Steven A. Falco <sfalco@harris.com>
---

Fair enough.  Here is a sorted version.

 drivers/rtc/Kconfig      |   14 +++++++-------
 drivers/rtc/rtc-m41t80.c |   43 +++++++++++++++++++++++++++++++++----------
 2 files changed, 40 insertions(+), 17 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4949dc4..c7586bc 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -220,22 +220,22 @@ config RTC_DRV_PCF8583
 	  will be called rtc-pcf8583.
 
 config RTC_DRV_M41T80
-	tristate "ST M41T80/81/82/83/84/85/87"
+	tristate "ST M41T65/M41T80/81/82/83/84/85/87"
 	help
-	  If you say Y here you will get support for the
-	  ST M41T80 RTC chips series. Currently following chips are
-	  supported: M41T80, M41T81, M41T82, M41T83, M41ST84, M41ST85
-	  and M41ST87.
+	  If you say Y here you will get support for the ST M41T60
+	  and M41T80 RTC chips series. Currently, the following chips are
+	  supported: M41T65, M41T80, M41T81, M41T82, M41T83, M41ST84,
+	  M41ST85, and M41ST87.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-m41t80.
 
 config RTC_DRV_M41T80_WDT
-	bool "ST M41T80 series RTC watchdog timer"
+	bool "ST M41T65/M41T80 series RTC watchdog timer"
 	depends on RTC_DRV_M41T80
 	help
 	  If you say Y here you will get support for the
-	  watchdog timer in ST M41T80 RTC chips series.
+	  watchdog timer in the ST M41T60 and M41T80 RTC chips series.
 
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

