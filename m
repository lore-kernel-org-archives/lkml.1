Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbZG3Fia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbZG3Fia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 01:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZG3Fia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 01:38:30 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63824 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZG3Fi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 01:38:29 -0400
Message-ID: <4A713283.8060602@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 13:41:23 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Pavel Machek <pavel@ucw.cz>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/2] Use common time_to_tm in fat_time_unix2fat()
References: <4A5C3BC0.6020701@cn.fujitsu.com>	<20090714151040.b7b3b26d.akpm@linux-foundation.org>	<20090718115019.GH1433@ucw.cz>	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>	<20090719202018.497f7ec1.akpm@linux-foundation.org>	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>	<87ocr9mi8h.fsf@devron.myhome.or.jp> <4A6D1BCF.1030109@cn.fujitsu.com>	<87k51u8xwa.fsf@devron.myhome.or.jp> <4A6E6ADD.6090602@cn.fujitsu.com> <87vdld9yrr.fsf@devron.myhome.or.jp> <4A713204.7030005@cn.fujitsu.com>
In-Reply-To: <4A713204.7030005@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not necessary to write custom code for convert calendar time
to broken-down time.
time_to_tm() is more generic to do that.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 fs/fat/misc.c |   57 +++++++++++++++------------------------------------------
 1 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index a6c2047..03bf98d 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/time.h>
 #include "fat.h"
 
 /*
@@ -155,10 +156,6 @@ extern struct timezone sys_tz;
 #define SECS_PER_MIN	60
 #define SECS_PER_HOUR	(60 * 60)
 #define SECS_PER_DAY	(SECS_PER_HOUR * 24)
-#define UNIX_SECS_1980	315532800L
-#if BITS_PER_LONG == 64
-#define UNIX_SECS_2108	4354819200L
-#endif
 /* days between 1.1.70 and 1.1.80 (2 leap days) */
 #define DAYS_DELTA	(365 * 10 + 2)
 /* 120 (2100 - 1980) isn't leap year */
@@ -211,58 +208,35 @@ void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
 void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
 		       __le16 *time, __le16 *date, u8 *time_cs)
 {
-	time_t second = ts->tv_sec;
-	time_t day, leap_day, month, year;
+	struct tm tm;
+	time_to_tm(ts->tv_sec, sbi->options.tz_utc ? 0 :
+		   -sys_tz.tz_minuteswest * 60, &tm);
 
-	if (!sbi->options.tz_utc)
-		second -= sys_tz.tz_minuteswest * SECS_PER_MIN;
-
-	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
-	if (second < UNIX_SECS_1980) {
+	/*  FAT can only support year between 1980 to 2107 */
+	if (tm.tm_year < 1980 - 1900) {
 		*time = 0;
 		*date = cpu_to_le16((0 << 9) | (1 << 5) | 1);
 		if (time_cs)
 			*time_cs = 0;
 		return;
 	}
-#if BITS_PER_LONG == 64
-	if (second >= UNIX_SECS_2108) {
+	if (tm.tm_year > 2107 - 1900) {
 		*time = cpu_to_le16((23 << 11) | (59 << 5) | 29);
 		*date = cpu_to_le16((127 << 9) | (12 << 5) | 31);
 		if (time_cs)
 			*time_cs = 199;
 		return;
 	}
-#endif
 
-	day = second / SECS_PER_DAY - DAYS_DELTA;
-	year = day / 365;
-	leap_day = (year + 3) / 4;
-	if (year > YEAR_2100)		/* 2100 isn't leap year */
-		leap_day--;
-	if (year * 365 + leap_day > day)
-		year--;
-	leap_day = (year + 3) / 4;
-	if (year > YEAR_2100)		/* 2100 isn't leap year */
-		leap_day--;
-	day -= year * 365 + leap_day;
-
-	if (IS_LEAP_YEAR(year) && day == days_in_year[3]) {
-		month = 2;
-	} else {
-		if (IS_LEAP_YEAR(year) && day > days_in_year[3])
-			day--;
-		for (month = 1; month < 12; month++) {
-			if (days_in_year[month + 1] > day)
-				break;
-		}
-	}
-	day -= days_in_year[month];
+	/* from 1900 -> from 1980 */
+	tm.tm_year -= 80;
+	/* 0~11 -> 1~12 */
+	tm.tm_mon++;
+	/* 0~59 -> 0~29(2sec counts) */
+	tm.tm_sec >>= 1;
 
-	*time = cpu_to_le16(((second / SECS_PER_HOUR) % 24) << 11
-			    | ((second / SECS_PER_MIN) % 60) << 5
-			    | (second % SECS_PER_MIN) >> 1);
-	*date = cpu_to_le16((year << 9) | (month << 5) | (day + 1));
+	*time = cpu_to_le16(tm.tm_hour << 11 | tm.tm_min << 5 | tm.tm_sec);
+	*date = cpu_to_le16(tm.tm_year << 9 | tm.tm_mon << 5 | tm.tm_mday);
 	if (time_cs)
 		*time_cs = (ts->tv_sec & 1) * 100 + ts->tv_nsec / 10000000;
 }
@@ -283,4 +257,3 @@ int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 	}
 	return err;
 }
-
-- 
1.5.5.3


