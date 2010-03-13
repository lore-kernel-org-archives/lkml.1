Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965270Ab0CMBce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:32:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:45663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934858Ab0CMATs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:48 -0500
Date: Sat, 13 Mar 2010 00:19:26 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, yasutake.koichi@jp.panasonic.com,
       dhowells@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, akpm@linux-foundation.org, johnstul@us.ibm.com,
       tglx@linutronix.de, yasutake.koichi@jp.panasonic.com
In-Reply-To: <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] mn10300: Convert mn10300 to use read/update_persistent_clock
Message-ID: <tip-f7a56575fa4e62e94a644f72ef8c5d423c073982@git.kernel.org>
Git-Commit-ID: f7a56575fa4e62e94a644f72ef8c5d423c073982
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:19:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7a56575fa4e62e94a644f72ef8c5d423c073982
Gitweb:     http://git.kernel.org/tip/f7a56575fa4e62e94a644f72ef8c5d423c073982
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:17 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:09 +0100

mn10300: Convert mn10300 to use read/update_persistent_clock

This patch converts the mn10300 architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
