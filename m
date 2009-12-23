Return-Path: <linux-kernel-owner+w=401wt.eu-S1752325AbZLWEEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbZLWEEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:04:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZLWEET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:04:19 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:49768 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbZLWEES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:04:18 -0500
Subject: [RFC][PATCH 4/14] Convert blackfin to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org
In-Reply-To: <1261540988.3508.64.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:04:14 -0800
Message-ID: <1261541054.3508.65.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the blackfin architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 time-ts.c |   13 +++++++------
 time.c    |   39 ++++++---------------------------------
 2 files changed, 13 insertions(+), 39 deletions(-)

Index: gettimeoffset/arch/blackfin/kernel/time-ts.c
===================================================================
--- gettimeoffset.orig/arch/blackfin/kernel/time-ts.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/blackfin/kernel/time-ts.c	2009-12-22 18:51:13.000000000 -0800
@@ -348,9 +348,15 @@ static int __init bfin_clockevent_init(v
 	return 0;
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	time_t secs_since_1970 = (365 * 37 + 9) * 24 * 60 * 60;	/* 1 Jan 2007 */
+	ts->tv_sec = secs_since_1970;
+	ts->tv_nsec = 0;
+}
+
+void __init time_init(void)
+{
 
 #ifdef CONFIG_RTC_DRV_BFIN
 	/* [#2663] hack to filter junk RTC values that would cause
@@ -363,11 +369,6 @@ void __init time_init(void)
 	}
 #endif
 
-	/* Initialize xtime. From now on, xtime is updated with timer interrupts */
-	xtime.tv_sec = secs_since_1970;
-	xtime.tv_nsec = 0;
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
-
 	bfin_cs_cycles_init();
 	bfin_cs_gptimer0_init();
 	bfin_clockevent_init();
Index: gettimeoffset/arch/blackfin/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/blackfin/kernel/time.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/blackfin/kernel/time.c	2009-12-22 18:51:13.000000000 -0800
@@ -112,11 +112,6 @@ u32 arch_gettimeoffset(void)
 }
 #endif
 
-static inline int set_rtc_mmss(unsigned long nowtime)
-{
-	return 0;
-}
-
 /*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
@@ -126,29 +121,8 @@ __attribute__((l1_text))
 #endif
 irqreturn_t timer_interrupt(int irq, void *dummy)
 {
-	/* last time the cmos clock got updated */
-	static long last_rtc_update;
-
 	write_seqlock(&xtime_lock);
 	do_timer(1);
-
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	if (ntp_synced() &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
-	    (xtime.tv_nsec / NSEC_PER_USEC) >=
-	    500000 - ((unsigned)TICK_SIZE) / 2
-	    && (xtime.tv_nsec / NSEC_PER_USEC) <=
-	    500000 + ((unsigned)TICK_SIZE) / 2) {
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else
-			/* Do it again in 60s. */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
 	write_sequnlock(&xtime_lock);
 
 #ifdef CONFIG_IPIPE
@@ -161,10 +135,15 @@ irqreturn_t timer_interrupt(int irq, voi
 	return IRQ_HANDLED;
 }
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	time_t secs_since_1970 = (365 * 37 + 9) * 24 * 60 * 60;	/* 1 Jan 2007 */
+	ts->tv_sec = secs_since_1970;
+	ts->tv_nsec = 0;
+}
 
+void __init time_init(void)
+{
 #ifdef CONFIG_RTC_DRV_BFIN
 	/* [#2663] hack to filter junk RTC values that would cause
 	 * userspace to have to deal with time values greater than
@@ -176,11 +155,5 @@ void __init time_init(void)
 	}
 #endif
 
-	/* Initialize xtime. From now on, xtime is updated with timer interrupts */
-	xtime.tv_sec = secs_since_1970;
-	xtime.tv_nsec = 0;
-
-	wall_to_monotonic.tv_sec = -xtime.tv_sec;
-
 	time_sched_init(timer_interrupt);
 }


