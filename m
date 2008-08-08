Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYHHQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYHHQlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 12:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758099AbYHHQgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 12:36:35 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36117 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290AbYHHQgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 12:36:33 -0400
Date: Fri, 8 Aug 2008 19:34:58 +0300
From: Adrian Bunk <bunk@kernel.org>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>
Subject: [15/17] sparc64: use bcd2bin/bin2bcd
Message-ID: <20080808163458.GV14495@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes sparc64 to use the new bcd2bin/bin2bcd functions 
instead of the obsolete BCD_TO_BIN/BIN_TO_BCD macros.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/sparc64/kernel/time.c |   94 ++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 47 deletions(-)

adfd943c41514e84cf7786824447052b8970e172 
diff --git a/arch/sparc64/kernel/time.c b/arch/sparc64/kernel/time.c
index a0c6a97..01f9cb5 100644
--- a/arch/sparc64/kernel/time.c
+++ b/arch/sparc64/kernel/time.c
@@ -582,13 +582,13 @@ static void __init set_system_time(void)
 
 		writeb(val, bregs + 0x0e);
 
-		BCD_TO_BIN(sec);
-		BCD_TO_BIN(min);
-		BCD_TO_BIN(hour);
-		BCD_TO_BIN(day);
-		BCD_TO_BIN(mon);
-		BCD_TO_BIN(year);
-		BCD_TO_BIN(century);
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
+		century = bcd2bin(century);
 
 		year += (century * 100);
 	} else {
@@ -604,12 +604,12 @@ static void __init set_system_time(void)
 		} while (sec != CMOS_READ(RTC_SECONDS));
 
 		if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-			BCD_TO_BIN(sec);
-			BCD_TO_BIN(min);
-			BCD_TO_BIN(hour);
-			BCD_TO_BIN(day);
-			BCD_TO_BIN(mon);
-			BCD_TO_BIN(year);
+			sec = bcd2bin(sec);
+			min = bcd2bin(min);
+			hour = bcd2bin(hour);
+			day = bcd2bin(day);
+			mon = bcd2bin(mon);
+			year = bcd2bin(year);
 		}
 		if ((year += 1900) < 1970)
 			year += 100;
@@ -1146,7 +1146,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 		writeb(val | 0x08, bregs + 0x0e);
 
 		chip_minutes = readb(bregs + 0x02);
-		BCD_TO_BIN(chip_minutes);
+		chip_minutes = bcd2bin(chip_minutes);
 		real_seconds = nowtime % 60;
 		real_minutes = nowtime / 60;
 		if (((abs(real_minutes - chip_minutes) + 15)/30) & 1)
@@ -1154,8 +1154,8 @@ static int set_rtc_mmss(unsigned long nowtime)
 		real_minutes %= 60;
 
 		if (abs(real_minutes - chip_minutes) < 30) {
-			BIN_TO_BCD(real_seconds);
-			BIN_TO_BCD(real_minutes);
+			real_seconds = bin2bcd(real_seconds);
+			real_minutes = bin2bcd(real_minutes);
 			writeb(real_seconds, bregs + 0x00);
 			writeb(real_minutes, bregs + 0x02);
 		} else {
@@ -1184,7 +1184,7 @@ static int set_rtc_mmss(unsigned long nowtime)
 
 		chip_minutes = CMOS_READ(RTC_MINUTES);
 		if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD)
-			BCD_TO_BIN(chip_minutes);
+			chip_minutes = bcd2bin(chip_minutes);
 		real_seconds = nowtime % 60;
 		real_minutes = nowtime / 60;
 		if (((abs(real_minutes - chip_minutes) + 15)/30) & 1)
@@ -1193,8 +1193,8 @@ static int set_rtc_mmss(unsigned long nowtime)
 
 		if (abs(real_minutes - chip_minutes) < 30) {
 			if (!(save_control & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-				BIN_TO_BCD(real_seconds);
-				BIN_TO_BCD(real_minutes);
+				real_seconds = bin2bcd(real_seconds);
+				real_minutes = bin2bcd(real_minutes);
 			}
 			CMOS_WRITE(real_seconds,RTC_SECONDS);
 			CMOS_WRITE(real_minutes,RTC_MINUTES);
@@ -1353,14 +1353,14 @@ static void bq4802_get_rtc_time(struct rtc_time *time)
 
 	writeb(val, bq4802_regs + 0x0e);
 
-	BCD_TO_BIN(time->tm_sec);
-	BCD_TO_BIN(time->tm_min);
-	BCD_TO_BIN(time->tm_hour);
-	BCD_TO_BIN(time->tm_mday);
-	BCD_TO_BIN(time->tm_mon);
-	BCD_TO_BIN(time->tm_year);
-	BCD_TO_BIN(time->tm_wday);
-	BCD_TO_BIN(century);
+	time->tm_sec = bcd2bin(time->tm_sec);
+	time->tm_min = bcd2bin(time->tm_min);
+	time->tm_hour = bcd2bin(time->tm_hour);
+	time->tm_mday = bcd2bin(time->tm_mday);
+	time->tm_mon = bcd2bin(time->tm_mon);
+	time->tm_year = bcd2bin(time->tm_year);
+	time->tm_wday = bcd2bin(time->tm_wday);
+	century = bcd2bin(century);
 
 	time->tm_year += (century * 100);
 	time->tm_year -= 1900;
@@ -1384,13 +1384,13 @@ static int bq4802_set_rtc_time(struct rtc_time *time)
 	min = time->tm_min;
 	sec = time->tm_sec;
 
-	BIN_TO_BCD(sec);
-	BIN_TO_BCD(min);
-	BIN_TO_BCD(hrs);
-	BIN_TO_BCD(day);
-	BIN_TO_BCD(mon);
-	BIN_TO_BCD(yrs);
-	BIN_TO_BCD(century);
+	sec = bin2bcd(sec);
+	min = bin2bcd(min);
+	hrs = bin2bcd(hrs);
+	day = bin2bcd(day);
+	mon = bin2bcd(mon);
+	yrs = bin2bcd(yrs);
+	century = bin2bcd(century);
 
 	writeb(val | 0x08, bq4802_regs + 0x0e);
 
@@ -1421,13 +1421,13 @@ static void cmos_get_rtc_time(struct rtc_time *rtc_tm)
 
 	ctrl = CMOS_READ(RTC_CONTROL);
 	if (!(ctrl & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BCD_TO_BIN(rtc_tm->tm_sec);
-		BCD_TO_BIN(rtc_tm->tm_min);
-		BCD_TO_BIN(rtc_tm->tm_hour);
-		BCD_TO_BIN(rtc_tm->tm_mday);
-		BCD_TO_BIN(rtc_tm->tm_mon);
-		BCD_TO_BIN(rtc_tm->tm_year);
-		BCD_TO_BIN(rtc_tm->tm_wday);
+		rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
+		rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
+		rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
+		rtc_tm->tm_mday = bcd2bin(rtc_tm->tm_mday);
+		rtc_tm->tm_mon = bcd2bin(rtc_tm->tm_mon);
+		rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
+		rtc_tm->tm_wday = bcd2bin(rtc_tm->tm_wday);
 	}
 
 	if (rtc_tm->tm_year <= 69)
@@ -1453,12 +1453,12 @@ static int cmos_set_rtc_time(struct rtc_time *rtc_tm)
 		yrs -= 100;
 
 	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		BIN_TO_BCD(sec);
-		BIN_TO_BCD(min);
-		BIN_TO_BCD(hrs);
-		BIN_TO_BCD(day);
-		BIN_TO_BCD(mon);
-		BIN_TO_BCD(yrs);
+		sec = bin2bcd(sec);
+		min = bin2bcd(min);
+		hrs = bin2bcd(hrs);
+		day = bin2bcd(day);
+		mon = bin2bcd(mon);
+		yrs = bin2bcd(yrs);
 	}
 
 	save_control = CMOS_READ(RTC_CONTROL);
