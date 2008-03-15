Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbYCOEPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbYCOEPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbYCOEPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:15:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53929 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYCOEPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:15:08 -0400
Subject: [PATCH 5/5] make more ntp values static
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1205554366.6122.88.camel@localhost.localdomain>
References: <1205553852.6122.76.camel@localhost.localdomain>
	 <1205553938.6122.79.camel@localhost.localdomain>
	 <1205554018.6122.81.camel@localhost.localdomain>
	 <1205554210.6122.85.camel@localhost.localdomain>
	 <1205554366.6122.88.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 21:15:01 -0700
Message-Id: <1205554501.6122.92.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Make time_status, time_maxerror and time_esterror static to ntp.c

Signed-off-by: John Stultz <johnstul@us.ibm.com>


Index: linux-2.6/arch/cris/arch-v32/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/time.c	2008-02-13 12:07:00.000000000 -0800
+++ linux-2.6/arch/cris/arch-v32/kernel/time.c	2008-03-14 20:13:24.000000000 -0700
@@ -248,8 +248,7 @@ timer_interrupt(int irq, void *dev_id)
 	 * The division here is not time critical since it will run once in
 	 * 11 minutes
 	 */
-	if ((time_status & STA_UNSYNC) == 0 &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
+	if (ntp_synced() && xtime.tv_sec > last_rtc_update + 660 &&
 	    (xtime.tv_nsec / 1000) >= 500000 - (tick_nsec / 1000) / 2 &&
 	    (xtime.tv_nsec / 1000) <= 500000 + (tick_nsec / 1000) / 2) {
 		if (set_rtc_mmss(xtime.tv_sec) == 0)
Index: linux-2.6/arch/mn10300/kernel/rtc.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/rtc.c	2008-02-13 12:07:00.000000000 -0800
+++ linux-2.6/arch/mn10300/kernel/rtc.c	2008-03-14 20:13:24.000000000 -0700
@@ -117,8 +117,7 @@ void check_rtc_time(void)
 	 *   RTC clock accordingly every ~11 minutes. set_rtc_mmss() has to be
 	 *   called as close as possible to 500 ms before the new second starts.
 	 */
-	if ((time_status & STA_UNSYNC) == 0 &&
-	    xtime.tv_sec > last_rtc_update + 660 &&
+	if (ntp_synced() && xtime.tv_sec > last_rtc_update + 660 &&
 	    xtime.tv_nsec / 1000 >= 500000 - ((unsigned) TICK_SIZE) / 2 &&
 	    xtime.tv_nsec / 1000 <= 500000 + ((unsigned) TICK_SIZE) / 2
 	    ) {
Index: linux-2.6/include/linux/timex.h
===================================================================
--- linux-2.6.orig/include/linux/timex.h	2008-03-14 19:21:02.000000000 -0700
+++ linux-2.6/include/linux/timex.h	2008-03-14 20:18:44.000000000 -0700
@@ -206,23 +206,8 @@ extern int tickadj;			/* amount of adjus
 /*
  * phase-lock loop variables
  */
-extern int time_status;		/* clock synchronization status bits */
-extern long time_maxerror;	/* maximum error */
-extern long time_esterror;	/* estimated error */
-
 extern long time_adjust;	/* The amount of adjtime left */
 
-extern void ntp_init(void);
-extern void ntp_clear(void);
-
-/**
- * ntp_synced - Returns 1 if the NTP status is not UNSYNC
- *
- */
-static inline int ntp_synced(void)
-{
-	return !(time_status & STA_UNSYNC);
-}
 
 /* Required to safely shift negative values */
 #define shift_right(x, s) ({	\
@@ -243,6 +228,9 @@ static inline int ntp_synced(void)
 /* Returns how long ticks are at present, in ns / 2^NTP_SCALE_SHIFT. */
 extern u64 tick_length;
 
+extern void ntp_init(void);
+extern int ntp_synced(void);
+extern void ntp_clear(void);
 extern void second_overflow(void);
 extern void update_ntp_one_tick(void);
 extern int do_adjtimex(struct timex *);
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c	2008-03-14 20:13:06.000000000 -0700
+++ linux-2.6/kernel/time/ntp.c	2008-03-14 20:15:27.000000000 -0700
@@ -32,13 +32,13 @@ static struct hrtimer	leap_timer;
  */
 /* TIME_ERROR prevents overwriting the CMOS clock */
 static int	time_state = TIME_OK;		/* clock synch status	 */
-int		time_status = STA_UNSYNC;	/* clock status bits	 */
+static int	time_status = STA_UNSYNC;	/* clock status bits	 */
 static long	time_tai;			/* TAI offset (s)	 */
 static s64	time_offset;			/* time adjustment (ns)	 */
 static long	time_constant = 2;		/* pll time constant	 */
-long		time_maxerror = NTP_PHASE_LIMIT;/* maximum error (us)	 */
-long		time_esterror = NTP_PHASE_LIMIT;/* estimated error (us)	 */
-static		s64 time_freq;		/* frequency offset (scaled ns/s)*/
+static long	time_maxerror = NTP_PHASE_LIMIT;/* maximum error (us)	 */
+static long	time_esterror = NTP_PHASE_LIMIT;/* estimated error (us)	 */
+static s64	time_freq;		/* frequency offset (scaled ns/s)*/
 static long	time_reftime;		/* time at last adjustment (s)	 */
 long		time_adjust;
 static long	ntp_tick_adj;
@@ -174,6 +174,15 @@ static enum hrtimer_restart ntp_leap_sec
 	return res;
 }
 
+/**
+ * ntp_synced - Returns 1 if the NTP status is not UNSYNC
+ *
+ */
+int ntp_synced(void)
+{
+	return !(time_status & STA_UNSYNC);
+}
+
 /*
  * this routine handles the overflow of the microsecond field
  *


