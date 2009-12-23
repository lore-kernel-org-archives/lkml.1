Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZLWEKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZLWEKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 23:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbZLWEK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 23:10:29 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50052 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZLWEK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 23:10:28 -0500
Subject: [RFC][PATCH 9/14] Convert m32r to read/update_persistent_clock
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org
In-Reply-To: <1261541342.3508.70.camel@localhost.localdomain>
References: <1261540762.3508.61.camel@localhost.localdomain>
	 <1261540826.3508.62.camel@localhost.localdomain>
	 <1261540902.3508.63.camel@localhost.localdomain>
	 <1261540988.3508.64.camel@localhost.localdomain>
	 <1261541054.3508.65.camel@localhost.localdomain>
	 <1261541130.3508.66.camel@localhost.localdomain>
	 <1261541188.3508.67.camel@localhost.localdomain>
	 <1261541286.3508.69.camel@localhost.localdomain>
	 <1261541342.3508.70.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:10:15 -0800
Message-ID: <1261541415.3508.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the m32r  architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 time.c |   47 +++++++----------------------------------------
 1 file changed, 7 insertions(+), 40 deletions(-)

Index: gettimeoffset/arch/m32r/kernel/time.c
===================================================================
--- gettimeoffset.orig/arch/m32r/kernel/time.c	2009-12-22 18:50:54.000000000 -0800
+++ gettimeoffset/arch/m32r/kernel/time.c	2009-12-22 18:51:15.000000000 -0800
@@ -106,24 +106,6 @@ u32 arch_gettimeoffset(void)
 }
 
 /*
- * In order to set the CMOS clock precisely, set_rtc_mmss has to be
- * called 500 ms after the second nowtime has started, because when
- * nowtime is written into the registers of the CMOS clock, it will
- * jump to the next second precisely 500 ms later. Check the Motorola
- * MC146818A or Dallas DS12887 data sheet for details.
- *
- * BUG: This routine does not handle hour overflow properly; it just
- *      sets the minutes. Usually you won't notice until after reboot!
- */
-static inline int set_rtc_mmss(unsigned long nowtime)
-{
-	return 0;
-}
-
-/* last time the cmos clock got updated */
-static long last_rtc_update = 0;
-
-/*
  * timer_interrupt() needs to keep up the real-time clock,
  * as well as call the "do_timer()" routine every clocktick
  */
@@ -138,23 +120,6 @@ static irqreturn_t timer_interrupt(int i
 #ifndef CONFIG_SMP
 	update_process_times(user_mode(get_irq_regs()));
 #endif
-	/*
-	 * If we have an externally synchronized Linux clock, then update
-	 * CMOS clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
-	 * called as close as possible to 500 ms before the new second starts.
-	 */
-	write_seqlock(&xtime_lock);
-	if (ntp_synced()
-		&& xtime.tv_sec > last_rtc_update + 660
-		&& (xtime.tv_nsec / 1000) >= 500000 - ((unsigned)TICK_SIZE) / 2
-		&& (xtime.tv_nsec / 1000) <= 500000 + ((unsigned)TICK_SIZE) / 2)
-	{
-		if (set_rtc_mmss(xtime.tv_sec) == 0)
-			last_rtc_update = xtime.tv_sec;
-		else	/* do it again in 60 s */
-			last_rtc_update = xtime.tv_sec - 600;
-	}
-	write_sequnlock(&xtime_lock);
 	/* As we return to user mode fire off the other CPU schedulers..
 	   this is basically because we don't yet share IRQ's around.
 	   This message is rigged to be safe on the 386 - basically it's
@@ -174,7 +139,7 @@ static struct irqaction irq0 = {
 	.name = "MFT2",
 };
 
-void __init time_init(void)
+void read_persistent_clock(struct timespec *ts)
 {
 	unsigned int epoch, year, mon, day, hour, min, sec;
 
@@ -194,11 +159,13 @@ void __init time_init(void)
 		epoch = 1952;
 	year += epoch;
 
-	xtime.tv_sec = mktime(year, mon, day, hour, min, sec);
-	xtime.tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
-	set_normalized_timespec(&wall_to_monotonic,
-		-xtime.tv_sec, -xtime.tv_nsec);
+	ts->tv_sec = mktime(year, mon, day, hour, min, sec);
+	ts->tv_nsec = (INITIAL_JIFFIES % HZ) * (NSEC_PER_SEC / HZ);
+}
+
 
+void __init time_init(void)
+{
 #if defined(CONFIG_CHIP_M32102) || defined(CONFIG_CHIP_XNUX2) \
 	|| defined(CONFIG_CHIP_VDEC2) || defined(CONFIG_CHIP_M32700) \
 	|| defined(CONFIG_CHIP_OPSP) || defined(CONFIG_CHIP_M32104)


