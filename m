Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYCOEK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYCOEK3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYCOEKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:10:20 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55403 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbYCOEKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:10:18 -0400
Subject: [PATCH 3/5] cleanups ntp.c (from Ingo)
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1205554018.6122.81.camel@localhost.localdomain>
References: <1205553852.6122.76.camel@localhost.localdomain>
	 <1205553938.6122.79.camel@localhost.localdomain>
	 <1205554018.6122.81.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 21:10:10 -0700
Message-Id: <1205554210.6122.85.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this file more readable by applying a consistent coding style.

No code changed.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Merged on top of Roman's very similar cleanups.
(In other words: Blame John for the merge screwups).

Signed-off-by: John Stultz <johnstul@us.ibm.com>


Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c	2008-03-14 19:21:02.000000000 -0700
+++ linux-2.6/kernel/time/ntp.c	2008-03-14 20:10:41.000000000 -0700
@@ -1,13 +1,10 @@
 /*
- * linux/kernel/time/ntp.c
- *
  * NTP state machine interfaces and logic.
  *
  * This code was mainly moved from kernel/timer.c and kernel/time.c
  * Please see those files for relevant copyright info and historical
  * changelogs.
  */
-
 #include <linux/mm.h>
 #include <linux/time.h>
 #include <linux/timer.h>
@@ -22,32 +19,35 @@
 /*
  * Timekeeping variables
  */
-unsigned long tick_usec = TICK_USEC; 		/* USER_HZ period (usec) */
-unsigned long tick_nsec;			/* ACTHZ period (nsec) */
-u64 tick_length;
-static u64 tick_length_base;
-
-static struct hrtimer leap_timer;
-
-#define MAX_TICKADJ		500		/* microsecs */
-#define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
-				  NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
+unsigned long		tick_usec = TICK_USEC;	/* USER_HZ period (usec) */
+unsigned long		tick_nsec;		/* ACTHZ period (nsec) */
+u64			tick_length;
+static u64		tick_length_base;
+static const long	max_tickadj = 500;	/* (usec) */
+
+static struct hrtimer	leap_timer;
 
 /*
  * phase-lock loop variables
  */
 /* TIME_ERROR prevents overwriting the CMOS clock */
-static int time_state = TIME_OK;	/* clock synchronization status	*/
-int time_status = STA_UNSYNC;		/* clock status bits		*/
-static long time_tai;			/* TAI offset (s)		*/
-static s64 time_offset;			/* time adjustment (ns)		*/
-static long time_constant = 2;		/* pll time constant		*/
-long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
-long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
-static s64 time_freq;			/* frequency offset (scaled ns/s)*/
-static long time_reftime;		/* time at last adjustment (s)	*/
-long time_adjust;
-static long ntp_tick_adj;
+static int	time_state = TIME_OK;		/* clock synch status	 */
+int		time_status = STA_UNSYNC;	/* clock status bits	 */
+static long	time_tai;			/* TAI offset (s)	 */
+static s64	time_offset;			/* time adjustment (ns)	 */
+static long	time_constant = 2;		/* pll time constant	 */
+long		time_maxerror = NTP_PHASE_LIMIT;/* maximum error (us)	 */
+long		time_esterror = NTP_PHASE_LIMIT;/* estimated error (us)	 */
+static		s64 time_freq;		/* frequency offset (scaled ns/s)*/
+static long	time_reftime;		/* time at last adjustment (s)	 */
+long		time_adjust;
+static long	ntp_tick_adj;
+
+
+static inline u64 scale_tickadj(u64 adj)
+{
+	return ((adj * NSEC_PER_USEC) << NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ;
+}
 
 static void ntp_update_frequency(void)
 {
@@ -111,15 +111,15 @@ static void ntp_update_offset(long offse
  */
 void ntp_clear(void)
 {
-	time_adjust = 0;		/* stop active adjtime() */
-	time_status |= STA_UNSYNC;
-	time_maxerror = NTP_PHASE_LIMIT;
-	time_esterror = NTP_PHASE_LIMIT;
+	time_adjust	= 0;		/* stop active adjtime() */
+	time_status	|= STA_UNSYNC;
+	time_maxerror	= NTP_PHASE_LIMIT;
+	time_esterror	= NTP_PHASE_LIMIT;
 
 	ntp_update_frequency();
 
-	tick_length = tick_length_base;
-	time_offset = 0;
+	tick_length	= tick_length_base;
+	time_offset	= 0;
 }
 
 /*
@@ -136,28 +136,32 @@ static enum hrtimer_restart ntp_leap_sec
 	switch (time_state) {
 	case TIME_OK:
 		break;
+
 	case TIME_INS:
 		xtime.tv_sec--;
 		wall_to_monotonic.tv_sec++;
 		time_state = TIME_OOP;
-		printk(KERN_NOTICE "Clock: "
-		       "inserting leap second 23:59:60 UTC\n");
+		printk(KERN_NOTICE
+			 "Clock: inserting leap second 23:59:60 UTC\n");
 		leap_timer.expires = ktime_add_ns(leap_timer.expires,
 						  NSEC_PER_SEC);
 		res = HRTIMER_RESTART;
 		break;
+
 	case TIME_DEL:
 		xtime.tv_sec++;
 		time_tai--;
 		wall_to_monotonic.tv_sec--;
 		time_state = TIME_WAIT;
-		printk(KERN_NOTICE "Clock: "
-		       "deleting leap second 23:59:59 UTC\n");
+		printk(KERN_NOTICE
+			"Clock: deleting leap second 23:59:59 UTC\n");
 		break;
+
 	case TIME_OOP:
 		time_tai++;
 		time_state = TIME_WAIT;
 		/* fall through */
+
 	case TIME_WAIT:
 		if (!(time_status & (STA_INS | STA_DEL)))
 			time_state = TIME_OK;
@@ -193,21 +197,20 @@ void second_overflow(void)
 	 * Compute the phase adjustment for the next second. The offset is
 	 * reduced by a fixed factor times the time constant.
 	 */
-	tick_length = tick_length_base;
-	time_adj = shift_right(time_offset, SHIFT_PLL + time_constant);
-	time_offset -= time_adj;
-	tick_length += time_adj;
+	tick_length	= tick_length_base;
+	time_adj	= shift_right(time_offset, SHIFT_PLL + time_constant);
+	time_offset	-= time_adj;
+	tick_length	+= time_adj;
 
 	if (unlikely(time_adjust)) {
-		if (time_adjust > MAX_TICKADJ) {
-			time_adjust -= MAX_TICKADJ;
-			tick_length += MAX_TICKADJ_SCALED;
-		} else if (time_adjust < -MAX_TICKADJ) {
-			time_adjust += MAX_TICKADJ;
-			tick_length -= MAX_TICKADJ_SCALED;
+		if (time_adjust > max_tickadj) {
+			time_adjust -= max_tickadj;
+			tick_length += scale_tickadj(max_tickadj);
+		} else if (time_adjust < -max_tickadj) {
+			time_adjust += max_tickadj;
+			tick_length -= scale_tickadj(max_tickadj);
 		} else {
-			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
-					NTP_INTERVAL_FREQ) << NTP_SCALE_SHIFT;
+			tick_length += scale_tickadj(time_adjust);
 			time_adjust = 0;
 		}
 	}
@@ -216,13 +219,13 @@ void second_overflow(void)
 #ifdef CONFIG_GENERIC_CMOS_UPDATE
 
 /* Disable the cmos update - used by virtualization and embedded */
-int no_sync_cmos_clock  __read_mostly;
+int no_sync_cmos_clock __read_mostly;
 
-static void sync_cmos_clock(unsigned long dummy);
+static void sync_cmos_clock(unsigned long unused);
 
 static DEFINE_TIMER(sync_cmos_timer, sync_cmos_clock, 0, 0);
 
-static void sync_cmos_clock(unsigned long dummy)
+static void sync_cmos_clock(unsigned long unused)
 {
 	struct timespec now, next;
 	int fail = 1;
@@ -234,12 +237,13 @@ static void sync_cmos_clock(unsigned lon
 	 * This code is run on a timer.  If the clock is set, that timer
 	 * may not expire at the correct time.  Thus, we adjust...
 	 */
-	if (!ntp_synced())
+	if (!ntp_synced()) {
 		/*
 		 * Not synced, exit, do not restart a timer (if one is
 		 * running, let it run out).
 		 */
 		return;
+	}
 
 	getnstimeofday(&now);
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
@@ -271,7 +275,8 @@ static void notify_cmos_timer(void)
 static inline void notify_cmos_timer(void) { }
 #endif
 
-/* adjtimex mainly allows reading (and writing, if superuser) of
+/*
+ * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
  */
 int do_adjtimex(struct timex *txc)
@@ -293,10 +298,11 @@ int do_adjtimex(struct timex *txc)
 	}
 
 	/* if the quartz is off by more than 10% something is VERY wrong ! */
-	if (txc->modes & ADJ_TICK)
+	if (txc->modes & ADJ_TICK) {
 		if (txc->tick <  900000/USER_HZ ||
 		    txc->tick > 1100000/USER_HZ)
 			return -EINVAL;
+	}
 
 	if (time_state != TIME_OK && txc->modes & ADJ_STATUS)
 		hrtimer_cancel(&leap_timer);


