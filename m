Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZLWEAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZLWEAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbZLWEAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:00:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55655 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbZLWEAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:00:47 -0500
Subject: [RFC][PATCH 1/14] Convert alpha to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Richard Henderson <rth@twiddle.net>, linux-alpha@vger.kernel.org
In-Reply-To: <1261540762.3508.61.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:00:26 -0800
Message-ID: <1261540826.3508.62.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the alpha architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 Kconfig       |    3 +
 kernel/time.c |  101 ++++++++++++++++++++++++++--------------------------------
 2 files changed, 50 insertions(+), 54 deletions(-)

Index: gettimeoffset/arch/alpha/Kconfig
===================================================================
--- gettimeoffset.orig/arch/alpha/Kconfig	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/alpha/Kconfig	2009-12-22 18:51:01.000000000 -0800
@@ -54,6 +54,9 @@ config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config ZONE_DMA
 	bool
 	default y
Index: gettimeoffset/arch/alpha/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/alpha/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/alpha/kernel/time.c	2009-12-22 18:51:01.000000000 -0800
@@ -75,8 +75,6 @@ static struct {
 	__u32 last_time;
 	/* ticks/cycle * 2^48 */
 	unsigned long scaled_ticks_per_cycle;
-	/* last time the CMOS clock got updated */
-	time_t last_rtc_update;
 	/* partial unused tick */
 	unsigned long partial_tick;
 } state;
@@ -91,6 +89,52 @@ static inline __u32 rpcc(void)
     return result;
 }
 
+int update_persistent_clock(struct timespec now)
+{
+	return set_rtc_mmss(now.tv_sec);
+}
+
+void read_persistent_clock(struct timespec *ts)
+{
+	unsigned int year, mon, day, hour, min, sec, epoch;
+
+	sec = CMOS_READ(RTC_SECONDS);
+	min = CMOS_READ(RTC_MINUTES);
+	hour = CMOS_READ(RTC_HOURS);
+	day = CMOS_READ(RTC_DAY_OF_MONTH);
+	mon = CMOS_READ(RTC_MONTH);
+	year = CMOS_READ(RTC_YEAR);
+
+	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
+		sec = bcd2bin(sec);
+		min = bcd2bin(min);
+		hour = bcd2bin(hour);
+		day = bcd2bin(day);
+		mon = bcd2bin(mon);
+		year = bcd2bin(year);
+	}
+
+	/* PC-like is standard; used for year >= 70 */
+	epoch = 1900;
+	if (year < 20)
+		epoch = 2000;
+	else if (year >= 20 && year < 48)
+		/* NT epoch */
+		epoch = 1980;
+	else if (year >= 48 && year < 70)
+		/* Digital UNIX epoch */
+		epoch = 1952;
+
+	printk(KERN_INFO "Using epoch = %d\n", epoch);
+
+	if ((year += epoch) < 1970)
+		year += 100;
+
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+}
+
+
+
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -123,19 +167,6 @@ irqreturn_t timer_interrupt(int irq, voi
 	if (nticks)
 		do_timer(nticks);
 
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	if (ntp_synced()
-	    && xtime.tv_sec > state.last_rtc_update + 660
-	    && xtime.tv_nsec >= 500000 - ((unsigned) TICK_SIZE) / 2
-	    && xtime.tv_nsec <= 500000 + ((unsigned) TICK_SIZE) / 2) {
-		int tmp = set_rtc_mmss(xtime.tv_sec);
-		state.last_rtc_update = xtime.tv_sec - (tmp ? 600 : 0);
-	}
-
 	write_sequnlock(&xtime_lock);
 
 #ifndef CONFIG_SMP
@@ -304,7 +335,7 @@ rpcc_after_update_in_progress(void)
 void __init
 time_init(void)
 {
-	unsigned int year, mon, day, hour, min, sec, cc1, cc2, epoch;
+	unsigned int cc1, cc2;
 	unsigned long cycle_freq, tolerance;
 	long diff;
 
@@ -348,43 +379,6 @@ time_init(void)
 	   bogomips yet, but this is close on a 500Mhz box.  */
 	__delay(1000000);
 
-	sec = CMOS_READ(RTC_SECONDS);
-	min = CMOS_READ(RTC_MINUTES);
-	hour = CMOS_READ(RTC_HOURS);
-	day = CMOS_READ(RTC_DAY_OF_MONTH);
-	mon = CMOS_READ(RTC_MONTH);
-	year = CMOS_READ(RTC_YEAR);
-
-	if (!(CMOS_READ(RTC_CONTROL) & RTC_DM_BINARY) || RTC_ALWAYS_BCD) {
-		sec = bcd2bin(sec);
-		min = bcd2bin(min);
-		hour = bcd2bin(hour);
-		day = bcd2bin(day);
-		mon = bcd2bin(mon);
-		year = bcd2bin(year);
-	}
-
-	/* PC-like is standard; used for year >= 70 */
-	epoch = 1900;
-	if (year < 20)
-		epoch = 2000;
-	else if (year >= 20 && year < 48)
-		/* NT epoch */
-		epoch = 1980;
-	else if (year >= 48 && year < 70)
-		/* Digital UNIX epoch */
-		epoch = 1952;
-
-	printk(KERN_INFO "Using epoch = %d\n", epoch);
-
-	if ((year += epoch) < 1970)
-		year += 100;
-
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = 0;
-
-        wall_to_monotonic.tv_sec -= xtime.tv_sec;
-        wall_to_monotonic.tv_nsec = 0;
 
 	if (HZ > (1<<16)) {
 		extern void __you_loose (void);
@@ -394,7 +388,6 @@ time_init(void)
 	state.last_time = cc1;
 	state.scaled_ticks_per_cycle
 		= ((unsigned long) HZ << FIX_SHIFT) / cycle_freq;
-	state.last_rtc_update = 0;
 	state.partial_tick = 0L;
 
 	/* Startup the timer source. */


