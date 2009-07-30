Return-Path: <linux-kernel-owner+w=401wt.eu-S1751557AbZG3Fhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbZG3Fhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 01:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbZG3Fhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 01:37:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57630 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbZG3Fhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 01:37:34 -0400
Message-ID: <4A713248.4070304@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 13:40:24 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Pavel Machek <pavel@ucw.cz>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/2] Add function to convert between calendar time and
 broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>	<20090714151040.b7b3b26d.akpm@linux-foundation.org>	<20090718115019.GH1433@ucw.cz>	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>	<20090719202018.497f7ec1.akpm@linux-foundation.org>	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>	<87ocr9mi8h.fsf@devron.myhome.or.jp> <4A6D1BCF.1030109@cn.fujitsu.com>	<87k51u8xwa.fsf@devron.myhome.or.jp> <4A6E6ADD.6090602@cn.fujitsu.com> <87vdld9yrr.fsf@devron.myhome.or.jp> <4A713204.7030005@cn.fujitsu.com>
In-Reply-To: <4A713204.7030005@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are many similar code in kernel for one object:
convert time between calendar time and broken-down time.

Here is some source I found:
fs/ncpfs/dir.c
fs/smbfs/proc.c
fs/fat/misc.c
fs/udf/udftime.c
fs/cifs/netmisc.c
net/netfilter/xt_time.c
drivers/scsi/ips.c
drivers/input/misc/hp_sdc_rtc.c
drivers/rtc/rtc-lib.c
arch/ia64/hp/sim/boot/fw-emu.c
arch/m68k/mac/misc.c
arch/powerpc/kernel/time.c
arch/parisc/include/asm/rtc.h
...

We can make a common function for this type of convert,
At least we can get following benefit:
1: Make kernel simple and unify
2: Easy to fix bug in converting code
3: Reduce clone of code in future
   For example, I'm trying to make ftrace display walltime,
   this patch will make me easy.

This code is based on code from glibc-2.6

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 include/linux/time.h   |   28 +++++++++++
 kernel/time/Makefile   |    2 +-
 kernel/time/timeconv.c |  127 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 156 insertions(+), 1 deletions(-)
 create mode 100644 kernel/time/timeconv.c

diff --git a/include/linux/time.h b/include/linux/time.h
index ea16c1a..4bc7a91 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -151,6 +151,34 @@ extern void update_xtime_cache(u64 nsec);
 struct tms;
 extern void do_sys_times(struct tms *);
 
+/*
+ * Similar to the struct tm in userspace <time.h>, but it needs to be here so
+ * that the kernel source is self contained.
+ */
+struct tm {
+	/*
+	 * the number of seconds after the minute, normally in the range
+	 * 0 to 59, but can be up to 60 to allow for leap seconds
+	 */
+	int tm_sec;
+	/* the number of minutes after the hour, in the range 0 to 59*/
+	int tm_min;
+	/* the number of hours past midnight, in the range 0 to 23 */
+	int tm_hour;
+	/* the day of the month, in the range 1 to 31 */
+	int tm_mday;
+	/* the number of months since January, in the range 0 to 11 */
+	int tm_mon;
+	/* the number of years since 1900 */
+	long tm_year;
+	/* the number of days since Sunday, in the range 0 to 6 */
+	int tm_wday;
+	/* the number of days since January 1, in the range 0 to 365 */
+	int tm_yday;
+};
+
+void time_to_tm(time_t totalsecs, int offset, struct tm *result);
+
 /**
  * timespec_to_ns - Convert timespec to nanoseconds
  * @ts:		pointer to the timespec variable to be converted
diff --git a/kernel/time/Makefile b/kernel/time/Makefile
index 0b0a636..ee26662 100644
--- a/kernel/time/Makefile
+++ b/kernel/time/Makefile
@@ -1,4 +1,4 @@
-obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o
+obj-y += timekeeping.o ntp.o clocksource.o jiffies.o timer_list.o timecompare.o timeconv.o
 
 obj-$(CONFIG_GENERIC_CLOCKEVENTS_BUILD)		+= clockevents.o
 obj-$(CONFIG_GENERIC_CLOCKEVENTS)		+= tick-common.o
diff --git a/kernel/time/timeconv.c b/kernel/time/timeconv.c
new file mode 100644
index 0000000..86628e7
--- /dev/null
+++ b/kernel/time/timeconv.c
@@ -0,0 +1,127 @@
+/*
+ * Copyright (C) 1993, 1994, 1995, 1996, 1997 Free Software Foundation, Inc.
+ * This file is part of the GNU C Library.
+ * Contributed by Paul Eggert (eggert@twinsun.com).
+ *
+ * The GNU C Library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public License as
+ * published by the Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version.
+ *
+ * The GNU C Library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with the GNU C Library; see the file COPYING.LIB.  If not,
+ * write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 02111-1307, USA.
+ */
+
+/*
+ * Converts the calendar time to broken-down time representation
+ * Based on code from glibc-2.6
+ *
+ * 2009-7-14:
+ *   Moved from glibc-2.6 to kernel by Zhaolei<zhaolei@cn.fujitsu.com>
+ */
+
+#include <linux/time.h>
+#include <linux/module.h>
+
+/*
+ * Nonzero if YEAR is a leap year (every 4 years,
+ * except every 100th isn't, and every 400th is).
+ */
+static int __isleap(long year)
+{
+	return (year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0);
+}
+
+/* do a mathdiv for long type */
+static long math_div(long a, long b)
+{
+	return a / b - (a % b < 0);
+}
+
+/* How many leap years between y1 and y2, y1 must less or equal to y2 */
+static long leaps_between(long y1, long y2)
+{
+	long leaps1 = math_div(y1 - 1, 4) - math_div(y1 - 1, 100)
+		+ math_div(y1 - 1, 400);
+	long leaps2 = math_div(y2 - 1, 4) - math_div(y2 - 1, 100)
+		+ math_div(y2 - 1, 400);
+	return leaps2 - leaps1;
+}
+
+/* How many days come before each month (0-12). */
+static const unsigned short __mon_yday[2][13] = {
+	/* Normal years. */
+	{0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365},
+	/* Leap years. */
+	{0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366}
+};
+
+#define SECS_PER_HOUR	(60 * 60)
+#define SECS_PER_DAY	(SECS_PER_HOUR * 24)
+
+/**
+ * time_to_tm - converts the calendar time to local broken-down time
+ *
+ * @totalsecs	the number of seconds elapsed since 00:00:00 on January 1, 1970,
+ *		Coordinated Universal Time (UTC).
+ * @offset	offset seconds adding to totalsecs.
+ * @result	pointer to struct tm variable to receive broken-down time
+ */
+void time_to_tm(time_t totalsecs, int offset, struct tm *result)
+{
+	long days, rem, y;
+	const unsigned short *ip;
+
+	days = totalsecs / SECS_PER_DAY;
+	rem = totalsecs % SECS_PER_DAY;
+	rem += offset;
+	while (rem < 0) {
+		rem += SECS_PER_DAY;
+		--days;
+	}
+	while (rem >= SECS_PER_DAY) {
+		rem -= SECS_PER_DAY;
+		++days;
+	}
+
+	result->tm_hour = rem / SECS_PER_HOUR;
+	rem %= SECS_PER_HOUR;
+	result->tm_min = rem / 60;
+	result->tm_sec = rem % 60;
+
+	/* January 1, 1970 was a Thursday. */
+	result->tm_wday = (4 + days) % 7;
+	if (result->tm_wday < 0)
+		result->tm_wday += 7;
+
+	y = 1970;
+
+	while (days < 0 || days >= (__isleap(y) ? 366 : 365)) {
+		/* Guess a corrected year, assuming 365 days per year. */
+		long yg = y + math_div(days, 365);
+
+		/* Adjust DAYS and Y to match the guessed year. */
+		days -= (yg - y) * 365 + leaps_between(y, yg);
+		y = yg;
+	}
+
+	result->tm_year = y - 1900;
+
+	result->tm_yday = days;
+
+	ip = __mon_yday[__isleap(y)];
+	for (y = 11; days < ip[y]; y--)
+		continue;
+	days -= ip[y];
+
+	result->tm_mon = y;
+	result->tm_mday = days + 1;
+}
+EXPORT_SYMBOL(time_to_tm);
-- 
1.5.5.3


