Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935200Ab0CMAW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:22:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:47727 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935189Ab0CMAWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:22:51 -0500
Date: Sat, 13 Mar 2010 00:21:53 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jesper.nilsson@axis.com, johnstul@us.ibm.com, akpm@linux-foundation.org,
       starvik@axis.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jesper.nilsson@axis.com, akpm@linux-foundation.org, johnstul@us.ibm.com,
       starvik@axis.com, tglx@linutronix.de
In-Reply-To: <1267675049-12337-14-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-14-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] cris: Convert cris to use read/update_persistent_clock
Message-ID: <tip-8eff8a5c1d3a1de7a2d173e0effc6cc9bcbb5177@git.kernel.org>
Git-Commit-ID: 8eff8a5c1d3a1de7a2d173e0effc6cc9bcbb5177
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:21:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8eff8a5c1d3a1de7a2d173e0effc6cc9bcbb5177
Gitweb:     http://git.kernel.org/tip/8eff8a5c1d3a1de7a2d173e0effc6cc9bcbb5177
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:28 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:13 +0100

cris: Convert cris to use read/update_persistent_clock

This patch converts the cris architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-14-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/cris/Kconfig                |    3 ++
 arch/cris/arch-v10/kernel/time.c |   37 +---------------------------------
 arch/cris/arch-v32/kernel/time.c |   40 +------------------------------------
 arch/cris/kernel/time.c          |   20 ++++++++++--------
 4 files changed, 18 insertions(+), 82 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 059eac6..e25bf44 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -23,6 +23,9 @@ config RWSEM_XCHGADD_ALGORITHM
 config GENERIC_TIME
 	def_bool y
 
+config GENERIC_CMOS_UPDATE
+	def_bool y
+
 config ARCH_USES_GETTIMEOFFSET
 	def_bool y
 
diff --git a/arch/cris/arch-v10/kernel/time.c b/arch/cris/arch-v10/kernel/time.c
index 31ca141..30adae5 100644
--- a/arch/cris/arch-v10/kernel/time.c
+++ b/arch/cris/arch-v10/kernel/time.c
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
diff --git a/arch/cris/arch-v32/kernel/time.c b/arch/cris/arch-v32/kernel/time.c
index b1920d8..1ee0e10 100644
--- a/arch/cris/arch-v32/kernel/time.c
+++ b/arch/cris/arch-v32/kernel/time.c
@@ -44,7 +44,6 @@ unsigned long timer_regs[NR_CPUS] =
 #endif
 };
 
-extern void update_xtime_from_cmos(void);
 extern int set_rtc_mmss(unsigned long nowtime);
 extern int have_rtc;
 
@@ -198,9 +197,6 @@ handle_watchdog_bite(struct pt_regs* regs)
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
diff --git a/arch/cris/kernel/time.c b/arch/cris/kernel/time.c
index a05dd31..c72730d 100644
--- a/arch/cris/kernel/time.c
+++ b/arch/cris/kernel/time.c
@@ -98,6 +98,8 @@ unsigned long
 get_cmos_time(void)
 {
 	unsigned int year, mon, day, hour, min, sec;
+	if(!have_rtc)
+		return 0;
 
 	sec = CMOS_READ(RTC_SECONDS);
 	min = CMOS_READ(RTC_MINUTES);
@@ -119,19 +121,19 @@ get_cmos_time(void)
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
