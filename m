Return-Path: <linux-kernel-owner+w=401wt.eu-S1759081AbZKYR14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759081AbZKYR14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759047AbZKYREL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:11 -0500
Received: from mx1.emlix.com ([193.175.82.87]:42743 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759040AbZKYREK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:10 -0500
From: Johannes Weiner <jw@emlix.com>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org
Subject: [patch 3/3] rtc-x1205: unconditionally set date when setting clock
Date: Wed, 25 Nov 2009 17:32:16 +0100
Message-Id: <1259166736-31006-3-git-send-email-jw@emlix.com>
In-Reply-To: <1259166736-31006-1-git-send-email-jw@emlix.com>
References: <1259166736-31006-1-git-send-email-jw@emlix.com>
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callsites of x1205_set_datetime() want the date to be set as well,
so remove the flag parameter and set it unconditionally.

Signed-off-by: Johannes Weiner <jw@emlix.com>
---
 drivers/rtc/rtc-x1205.c |   53 ++++++++++++++++-------------------------------
 1 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/rtc/rtc-x1205.c b/drivers/rtc/rtc-x1205.c
index 6583c1a..9aae491 100644
--- a/drivers/rtc/rtc-x1205.c
+++ b/drivers/rtc/rtc-x1205.c
@@ -155,11 +155,11 @@ static int x1205_get_status(struct i2c_client *client, unsigned char *sr)
 }
 
 static int x1205_set_datetime(struct i2c_client *client, struct rtc_time *tm,
-			int datetoo, u8 reg_base, unsigned char alm_enable)
+			u8 reg_base, unsigned char alm_enable)
 {
-	int i, xfer, nbytes;
-	unsigned char buf[8];
+	int i, xfer;
 	unsigned char rdata[10] = { 0, reg_base };
+	unsigned char *buf = rdata + 2;
 
 	static const unsigned char wel[3] = { 0, X1205_REG_SR,
 						X1205_SR_WEL };
@@ -170,9 +170,9 @@ static int x1205_set_datetime(struct i2c_client *client, struct rtc_time *tm,
 	static const unsigned char diswe[3] = { 0, X1205_REG_SR, 0 };
 
 	dev_dbg(&client->dev,
-		"%s: secs=%d, mins=%d, hours=%d\n",
-		__func__,
-		tm->tm_sec, tm->tm_min, tm->tm_hour);
+		"%s: sec=%d min=%d hour=%d mday=%d mon=%d year=%d wday=%d\n",
+		__func__, tm->tm_sec, tm->tm_min, tm->tm_hour, tm->tm_mday,
+		tm->tm_mon, tm->tm_year, tm->tm_wday);
 
 	buf[CCR_SEC] = bin2bcd(tm->tm_sec);
 	buf[CCR_MIN] = bin2bcd(tm->tm_min);
@@ -180,23 +180,15 @@ static int x1205_set_datetime(struct i2c_client *client, struct rtc_time *tm,
 	/* set hour and 24hr bit */
 	buf[CCR_HOUR] = bin2bcd(tm->tm_hour) | X1205_HR_MIL;
 
-	/* should we also set the date? */
-	if (datetoo) {
-		dev_dbg(&client->dev,
-			"%s: mday=%d, mon=%d, year=%d, wday=%d\n",
-			__func__,
-			tm->tm_mday, tm->tm_mon, tm->tm_year, tm->tm_wday);
+	buf[CCR_MDAY] = bin2bcd(tm->tm_mday);
 
-		buf[CCR_MDAY] = bin2bcd(tm->tm_mday);
+	/* month, 1 - 12 */
+	buf[CCR_MONTH] = bin2bcd(tm->tm_mon + 1);
 
-		/* month, 1 - 12 */
-		buf[CCR_MONTH] = bin2bcd(tm->tm_mon + 1);
-
-		/* year, since the rtc epoch*/
-		buf[CCR_YEAR] = bin2bcd(tm->tm_year % 100);
-		buf[CCR_WDAY] = tm->tm_wday & 0x07;
-		buf[CCR_Y2K] = bin2bcd((tm->tm_year + 1900) / 100);
-	}
+	/* year, since the rtc epoch*/
+	buf[CCR_YEAR] = bin2bcd(tm->tm_year % 100);
+	buf[CCR_WDAY] = tm->tm_wday & 0x07;
+	buf[CCR_Y2K] = bin2bcd((tm->tm_year + 1900) / 100);
 
 	/* If writing alarm registers, set compare bits on registers 0-4 */
 	if (reg_base < X1205_CCR_BASE)
@@ -214,17 +206,8 @@ static int x1205_set_datetime(struct i2c_client *client, struct rtc_time *tm,
 		return -EIO;
 	}
 
-
-	/* write register's data */
-	if (datetoo)
-		nbytes = 8;
-	else
-		nbytes = 3;
-	for (i = 0; i < nbytes; i++)
-		rdata[2+i] = buf[i];
-
-	xfer = i2c_master_send(client, rdata, nbytes+2);
-	if (xfer != nbytes+2) {
+	xfer = i2c_master_send(client, rdata, sizeof(rdata));
+	if (xfer != sizeof(rdata)) {
 		dev_err(&client->dev,
 			"%s: result=%d addr=%02x, data=%02x\n",
 			__func__,
@@ -282,7 +265,7 @@ static int x1205_fix_osc(struct i2c_client *client)
 
 	memset(&tm, 0, sizeof(tm));
 
-	err = x1205_set_datetime(client, &tm, 1, X1205_CCR_BASE, 0);
+	err = x1205_set_datetime(client, &tm, X1205_CCR_BASE, 0);
 	if (err < 0)
 		dev_err(&client->dev, "unable to restart the oscillator\n");
 
@@ -481,7 +464,7 @@ static int x1205_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int x1205_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	return x1205_set_datetime(to_i2c_client(dev),
-		&alrm->time, 1, X1205_ALM0_BASE, alrm->enabled);
+		&alrm->time, X1205_ALM0_BASE, alrm->enabled);
 }
 
 static int x1205_rtc_read_time(struct device *dev, struct rtc_time *tm)
@@ -493,7 +476,7 @@ static int x1205_rtc_read_time(struct device *dev, struct rtc_time *tm)
 static int x1205_rtc_set_time(struct device *dev, struct rtc_time *tm)
 {
 	return x1205_set_datetime(to_i2c_client(dev),
-		tm, 1, X1205_CCR_BASE, 0);
+		tm, X1205_CCR_BASE, 0);
 }
 
 static int x1205_rtc_proc(struct device *dev, struct seq_file *seq)
-- 
1.6.5

