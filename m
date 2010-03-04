Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048Ab0CDD5n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:57:43 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:54624 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab0CDD5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:35 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/14] mn10300: Convert mn10300 to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:17 -0800
Message-Id: <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the mn10300 architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/mn10300/Kconfig       |    3 +++
 arch/mn10300/kernel/rtc.c  |   27 +++++----------------------
 arch/mn10300/kernel/time.c |    4 ----
 3 files changed, 8 insertions(+), 26 deletions(-)

diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 89faaca..1c4565a 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -37,6 +37,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
diff --git a/arch/mn10300/kernel/rtc.c b/arch/mn10300/kernel/rtc.c
index 7978470..815a933 100644
--- a/arch/mn10300/kernel/rtc.c
+++ b/arch/mn10300/kernel/rtc.c
@@ -26,17 +26,15 @@ static long last_rtc_update;
 /* time for RTC to update itself in ioclks */
 static unsigned long mn10300_rtc_update_period;
 
-/*
- * read the current RTC time
- */
-unsigned long __init get_initial_rtc_time(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	struct rtc_time tm;
 
 	get_rtc_time(&tm);
 
-	return mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
+	ts->tv_sec = mktime(tm.tm_year, tm.tm_mon, tm.tm_mday,
 		      tm.tm_hour, tm.tm_min, tm.tm_sec);
+	ts->tv_nsec = 0;
 }
 
 /*
@@ -110,24 +108,9 @@ static int set_rtc_mmss(unsigned long nowtime)
 	return retval;
 }
 
-void check_rtc_time(void)
+int update_persistent_clock(struct timespec now)
 {
-	/* the RTC clock just finished ticking over again this second
-	 * - if we have an externally synchronized Linux clock, then update
-	 *   RTC clock accordingly every ~11 minutes. set_rtc_mmss() has to be
-	 *   called as close as possible to 500 ms before the new second starts.
-	 */
-	if ((time_status & STA_UNSYNC) == 0 &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    xtime.tv_nsec / 1000 >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
-	    xtime.tv_nsec / 1000 <= 500000 + ((unsigned) TICK_SIZE) / 2
-	    ) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			/* do it again in 60s */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
+	return set_rtc_mms(now.tv_sec);
 }
 
 /*
diff --git a/arch/mn10300/kernel/time.c b/arch/mn10300/kernel/time.c
index 395caf0..8f7f6d2 100644
--- a/arch/mn10300/kernel/time.c
+++ b/arch/mn10300/kernel/time.c
@@ -111,7 +111,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 		/* advance the kernel's time tracking system */
 		profile_tick(CPU_PROFILING);
 		do_timer(1);
-		check_rtc_time();
 	}
 
 	write_sequnlock(&xtime_lock);
@@ -139,9 +138,6 @@ void __init time_init(void)
 	       " (calibrated against RTC)\n",
 	       MN10300_TSCCLK / 1000000, (MN10300_TSCCLK / 10000) % 100);
 
-	xtime.tv_sec = get_initial_rtc_time();
-	xtime.tv_nsec = 0;
-
 	mn10300_last_tsc = TMTSCBC;
 
 	/* use timer 0 & 1 cascaded to tick at as close to HZ as possible */
-- 
1.6.0.4

