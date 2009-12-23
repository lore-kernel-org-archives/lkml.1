Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZLWEFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZLWEFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbZLWEFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:05:40 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:35874 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbZLWEFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:05:40 -0500
Subject: [RFC][PATCH 5/14] Convert cris to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.comf
In-Reply-To: <1261541054.3508.65.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:05:30 -0800
Message-ID: <1261541130.3508.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the cris architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.


Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 Kconfig                |    3 +++
 arch-v10/kernel/time.c |   37 ++-----------------------------------
 arch-v32/kernel/time.c |   40 ++--------------------------------------
 kernel/time.c          |   20 +++++++++++---------
 4 files changed, 18 insertions(+), 82 deletions(-)

Index: gettimeoffset/arch/cris/Kconfig
===================================================================
--- gettimeoffset.orig/arch/cris/Kconfig	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/cris/Kconfig	2009-12-22 18:51:26.000000000 -0800
@@ -20,6 +20,9 @@ config RWSEM_GENERIC_SPINLOCK
 config RWSEM_XCHGADD_ALGORITHM
 	bool
 
+config GENERIC_CMOS_UPDATE
+	def_bool y
+
 config GENERIC_IOMAP
        bool
        default y
Index: gettimeoffset/arch/cris/arch-v10/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/cris/arch-v10/kernel/time.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/cris/arch-v10/kernel/time.c	2009-12-22 18:51:26.000000000 -0800
@@ -26,7 +26,6 @@
 /* it will make jiffies at 96 hz instead of 100 hz though */
 #undef USE_CASCADE_TIMERS
 
-extern void update_xtime_from_cmos(void);
 extern int set_rtc_mmss(unsigned long nowtime);
 extern int have_rtc;
 
@@ -188,8 +187,6 @@ stop_watchdog(void)
 #endif	
 }
 
-/* last time the cmos clock got updated */
-static long last_rtc_update = 0;
 
 /*
  * timer_interrupt() needs to keep up the real-time clock,
@@ -232,24 +229,6 @@ timer_interrupt(int irq, void *dev_id)
 	do_timer(1);
 	
         cris_do_profile(regs); /* Save profiling information */
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 *
-	 * The division here is not time critical since it will run once in 
-	 * 11 minutes
-	 */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - (tick_nsec / 1000) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + (tick_nsec / 1000) / 2) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
-	}
         return IRQ_HANDLED;
 }
 
@@ -274,22 +253,10 @@ time_init(void)
 	 */
 	loops_per_usec = 50;
 
-	if(RTC_INIT() < 0) {
-		/* no RTC, start at 1980 */
-		xtime.tv_sec = 0;
-		xtime.tv_nsec = 0;
+	if(RTC_INIT() < 0)
 		have_rtc = 0;
-	} else {		
-		/* get the current time */
+	else
 		have_rtc = 1;
-		update_xtime_from_cmos();
-	}
-
-	/*
-	 * Initialize wall_to_monotonic such that adding it to xtime will yield zero, the
-	 * tv_nsec field must be normalized (i.e., 0 <= nsec < NSEC_PER_SEC).
-	 */
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 
 	/* Setup the etrax timers
 	 * Base frequency is 25000 hz, divider 250 -> 100 HZ
Index: gettimeoffset/arch/cris/arch-v32/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/cris/arch-v32/kernel/time.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/cris/arch-v32/kernel/time.c	2009-12-22 18:51:27.000000000 -0800
@@ -44,7 +44,6 @@ unsigned long timer_regs[NR_CPUS] =
 #endif
 };
 
-extern void update_xtime_from_cmos(void);
 extern int set_rtc_mmss(unsigned long nowtime);
 extern int have_rtc;
 
@@ -198,9 +197,6 @@ handle_watchdog_bite(struct pt_regs* reg
 #endif
 }
 
-/* Last time the cmos clock got updated. */
-static long last_rtc_update = 0;
-
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick.
@@ -238,25 +234,6 @@ timer_interrupt(int irq, void *dev_id)
 
 	/* Call the real timer interrupt handler */
 	do_timer(1);
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 *
-	 * The division here is not time critical since it will run once in
-	 * 11 minutes
-	 */
-	if ((time_status & STA_UNSYNC) == 0 &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / 1000) >= 500000 - (tick_nsec / 1000) / 2 &&
-	    (xtime.tv_nsec / 1000) <= 500000 + (tick_nsec / 1000) / 2) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			/* Do it again in 60 s */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
         return IRQ_HANDLED;
 }
 
@@ -309,23 +286,10 @@ time_init(void)
 	 */
 	loops_per_usec = 50;
 
-	if(RTC_INIT() < 0) {
-		/* No RTC, start at 1980 */
-		xtime.tv_sec = 0;
-		xtime.tv_nsec = 0;
+	if(RTC_INIT() < 0)
 		have_rtc = 0;
-	} else {
-		/* Get the current time */
+	else
 		have_rtc = 1;
-		update_xtime_from_cmos();
-	}
-
-	/*
-	 * Initialize wall_to_monotonic such that adding it to
-	 * xtime will yield zero, the tv_nsec field must be normalized
-	 * (i.e., 0 <= nsec < NSEC_PER_SEC).
-	 */
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 
 	/* Start CPU local timer. */
 	cris_timer_init();
Index: gettimeoffset/arch/cris/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/cris/kernel/time.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/cris/kernel/time.c	2009-12-22 18:51:27.000000000 -0800
@@ -162,6 +162,8 @@ unsigned long
 get_cmos_time(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
+	if(!have_rtc)
+		return 0;
 
 	sec = CMOS_READ(RTC_SECONDS);
 	min = CMOS_READ(RTC_MINUTES);
@@ -183,19 +185,19 @@ get_cmos_time(void)
 	return mktime(year, mon, day, hour, min, sec);
 }
 
-/* update xtime from the CMOS settings. used when /dev/rtc gets a SET_TIME.
- * TODO: this doesn't reset the fancy NTP phase stuff as do_settimeofday does.
- */
 
-void
-update_xtime_from_cmos(void)
+int update_persistent_clock(struct timespec now)
 {
-	if(have_rtc) {
-		xtime.tv_sec = get_cmos_time();
-		xtime.tv_nsec = 0;
-	}
+	return set_rtc_mmss(now.tv_sec);
 }
 
+void read_persistent_clock(struct timespec *ts)
+{
+	ts->tv_sec = get_cmos_time();
+	ts->tv_nsec = 0;
+}
+
+
 extern void cris_profile_sample(struct pt_regs* regs);
 
 void


