Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0CDEAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:00:24 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46665 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab0CDD5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:34 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Richard Henderson <rth@twiddle.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/14] alpha: Convert alpha to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:16 -0800
Message-Id: <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the alpha architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: Richard Henderson <rth@twiddle.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/alpha/Kconfig       |    3 +
 arch/alpha/kernel/time.c |  101 +++++++++++++++++++++------------------------
 2 files changed, 50 insertions(+), 54 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index bd7261e..75fff7e 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -54,6 +54,9 @@ config ARCH_USES_GETTIMEOFFSET
 	bool
 	default y
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config ZONE_DMA
 	bool
 	default y
diff --git a/arch/alpha/kernel/time.c b/arch/alpha/kernel/time.c
index 5d08266..5465e93 100644
--- a/arch/alpha/kernel/time.c
+++ b/arch/alpha/kernel/time.c
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
@@ -123,19 +167,6 @@ irqreturn_t timer_interrupt(int irq, void *dev)
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
-- 
1.6.0.4

