Return-Path: <linux-kernel-owner+w=401wt.eu-S1753005AbYCIIIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbYCIIIf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 04:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYCIIIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 04:08:14 -0400
Received: from www.tglx.de ([62.245.132.106]:40524 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYCIIIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 04:08:07 -0400
Date: Sun, 9 Mar 2008 09:07:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] time(r) fixes for .25
Message-ID: <alpine.LFD.1.00.0803090857480.3099@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull time(r) related fixes from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/tglx/linux-2.6-hrt.git master

Thanks,
	tglx

David Howells (1):
      ntp: use unsigned input for do_div()

Karsten Wiese (1):
      time: don't touch an offlined CPU's ts->tick_stopped in tick_cancel_sched_timer()

Roman Zippel (1):
      time: remove obsolete CLOCK_TICK_ADJUST

Segher Boessenkool (1):
      time: prevent the loop in timespec_add_ns() from being optimised away

 include/linux/time.h      |    4 ++++
 include/linux/timex.h     |    9 +--------
 kernel/time/ntp.c         |   23 +++++++++++++++++------
 kernel/time/tick-sched.c  |    2 +-
 kernel/time/timekeeping.c |    6 ++----

 5 files changed, 25 insertions(+), 19 deletions(-)
diff --git a/include/linux/time.h b/include/linux/time.h
index 2091a19..d32ef0a 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
 {
 	ns += a->tv_nsec;
 	while(unlikely(ns >= NSEC_PER_SEC)) {
+		/* The following asm() prevents the compiler from
+		 * optimising this loop into a modulo operation.  */
+		asm("" : "+r"(ns));
+
 		ns -= NSEC_PER_SEC;
 		a->tv_sec++;
 	}
diff --git a/include/linux/timex.h b/include/linux/timex.h
index c3f3747..8ea3e71 100644
--- a/include/linux/timex.h
+++ b/include/linux/timex.h
@@ -232,14 +232,7 @@ static inline int ntp_synced(void)
 #else
 #define NTP_INTERVAL_FREQ  (HZ)
 #endif
-
-#define CLOCK_TICK_OVERFLOW	(LATCH * HZ - CLOCK_TICK_RATE)
-#define CLOCK_TICK_ADJUST	(((s64)CLOCK_TICK_OVERFLOW * NSEC_PER_SEC) / \
-					(s64)CLOCK_TICK_RATE)
-
-/* Because using NSEC_PER_SEC would be too easy */
-#define NTP_INTERVAL_LENGTH ((((s64)TICK_USEC * NSEC_PER_USEC * USER_HZ) + \
-			      CLOCK_TICK_ADJUST) / NTP_INTERVAL_FREQ)
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index c88b591..5fd9b94 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -42,12 +42,13 @@ long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
 long time_freq;				/* frequency offset (scaled ppm)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
+static long ntp_tick_adj;
 
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< TICK_LENGTH_SHIFT;
-	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
+	second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
 	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
 
 	tick_length_base = second_length;
@@ -342,14 +343,16 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
 		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
+			u64 utemp64;
 			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
 			if (time_offset < 0) {
-			    temp64 = -temp64;
-			    do_div(temp64, mtemp);
-			    freq_adj -= temp64;
+			    utemp64 = -temp64;
+			    do_div(utemp64, mtemp);
+			    freq_adj -= utemp64;
 			} else {
-			    do_div(temp64, mtemp);
-			    freq_adj += temp64;
+			    utemp64 = temp64;
+			    do_div(utemp64, mtemp);
+			    freq_adj += utemp64;
 			}
 		    }
 		    freq_adj += time_freq;
@@ -400,3 +403,11 @@ leave:	if ((time_status & (STA_UNSYNC|STA_CLOCKERR)) != 0)
 	notify_cmos_timer();
 	return(result);
 }
+
+static int __init ntp_tick_adj_setup(char *str)
+{
+	ntp_tick_adj = simple_strtol(str, NULL, 0);
+	return 1;
+}
+
+__setup("ntp_tick_adj=", ntp_tick_adj_setup);
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2968298..686da82 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -640,7 +640,7 @@ void tick_cancel_sched_timer(int cpu)
 
 	if (ts->sched_timer.base)
 		hrtimer_cancel(&ts->sched_timer);
-	ts->tick_stopped = 0;
+
 	ts->nohz_mode = NOHZ_MODE_INACTIVE;
 }
 #endif /* HIGH_RES_TIMERS */
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 1af9fb0..671af61 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -187,8 +187,7 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
 
@@ -245,8 +244,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock,
-		(unsigned long)(current_tick_length()>>TICK_LENGTH_SHIFT));
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;
