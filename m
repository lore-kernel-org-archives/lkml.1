Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbZLWEM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbZLWEM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:12:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZLWEM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:12:58 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37036 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbZLWEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:12:58 -0500
Subject: [RFC][PATCH 11/14] Convert mn10300 to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>,
       Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
       linux-am33-list@redhat.com
In-Reply-To: <1261541491.3508.72.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
	 <1261541130.3508.66.camel@localhost.localdomain>
	 <1261541188.3508.67.camel@localhost.localdomain>
	 <1261541286.3508.69.camel@localhost.localdomain>
	 <1261541342.3508.70.camel@localhost.localdomain>
	 <1261541415.3508.71.camel@localhost.localdomain>
	 <1261541491.3508.72.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:12:47 -0800
Message-ID: <1261541567.3508.73.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the mn10300 architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 Kconfig       |    3 +++
 kernel/rtc.c  |   27 +++++----------------------
 kernel/time.c |    4 ----
 3 files changed, 8 insertions(+), 26 deletions(-)

Index: gettimeoffset/arch/mn10300/Kconfig
===================================================================
--- gettimeoffset.orig/arch/mn10300/Kconfig	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/mn10300/Kconfig	2009-12-22 18:51:03.000000000 -0800
@@ -37,6 +37,9 @@ config GENERIC_HARDIRQS_NO__DO_IRQ
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config GENERIC_FIND_NEXT_BIT
 	def_bool y
 
Index: gettimeoffset/arch/mn10300/kernel/rtc.c
===================================================================
--- gettimeoffset.orig/arch/mn10300/kernel/rtc.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/mn10300/kernel/rtc.c	2009-12-22 18:51:03.000000000 -0800
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
@@ -110,24 +108,9 @@ static int set_rtc_mmss(unsigned long no
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
Index: gettimeoffset/arch/mn10300/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/mn10300/kernel/time.c	2009-12-22 18:50:55.000000000 -0800
+++ gettimeoffset/arch/mn10300/kernel/time.c	2009-12-22 18:51:03.000000000 -0800
@@ -111,7 +111,6 @@ static irqreturn_t timer_interrupt(int i
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


