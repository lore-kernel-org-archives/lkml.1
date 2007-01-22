Return-Path: <linux-kernel-owner+w=401wt.eu-S1751868AbXAVT2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbXAVT2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:28:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXAVT2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:28:41 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57486 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751868AbXAVT2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:28:39 -0500
Date: Mon, 22 Jan 2007 20:27:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: john stultz <johnstul@us.ibm.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Subject: [patch] HZ-free NTP
Message-ID: <20070122192712.GC12911@elte.hu>
References: <1165393929.24604.222.camel@localhost.localdomain> <Pine.LNX.4.64.0612061334230.1867@scrub.home> <20061206131155.GA8558@elte.hu> <Pine.LNX.4.64.0612061422190.1867@scrub.home> <1165956021.20229.10.camel@localhost> <Pine.LNX.4.64.0612131338420.1867@scrub.home> <1166037549.6425.21.camel@localhost.localdomain> <Pine.LNX.4.64.0612132125450.1867@scrub.home> <1166578357.5594.3.camel@localhost> <1166579658.5594.6.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1166579658.5594.6.camel@localhost>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -4.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-4.3 required=5.9 tests=ALL_TRUSTED,BAYES_00,UPPERCASE_25_50 autolearn=no SpamAssassin version=3.0.3
	-3.3 ALL_TRUSTED            Did not pass through any untrusted hosts
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* john stultz <johnstul@us.ibm.com> wrote:

> And here would be the follow on patch (again *untested*) for 
> CONFIG_NO_HZ slowing the time accumulation down to once per second.

thanks John - i've applied the combined patch below to -rt. It appears 
to work fine for me.

	Ingo

------------------------>
From: John Stultz <johnstul@us.ibm.com>
Subject: [patch] HZ-free NTP

Basically INTERVAL_LENGTH_NSEC defines the NTP interval length that the
time code will use to accumulate with. In this patch I've pushed it out
to a full second, but it could be set via config (NSEC_PER_SEC/HZ for
regular systems, something larger for systems using dynticks).

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/timex.h |    4 ++++
 kernel/hrtimer.c      |    4 +++-
 kernel/time/ntp.c     |   30 +++++++++++++++++++-----------
 kernel/timer.c        |    4 ++--
 4 files changed, 28 insertions(+), 14 deletions(-)

Index: linux/include/linux/timex.h
===================================================================
--- linux.orig/include/linux/timex.h
+++ linux/include/linux/timex.h
@@ -286,7 +286,11 @@ static inline void time_interpolator_upd
 
 #define TICK_LENGTH_SHIFT	32
 
+#ifdef CONFIG_NO_HZ
+#define NTP_INTERVAL_FREQ  (1)
+#else
 #define NTP_INTERVAL_FREQ  (HZ)
+#endif
 #define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
 
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
Index: linux/kernel/hrtimer.c
===================================================================
--- linux.orig/kernel/hrtimer.c
+++ linux/kernel/hrtimer.c
@@ -135,12 +135,14 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
  */
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
+	struct timespec ts;
 	ktime_t xtim, tomono;
 	unsigned long seq;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		xtim = timespec_to_ktime(xtime);
+		getnstimeofday(&ts);
+		xtim = timespec_to_ktime(ts);
 		tomono = timespec_to_ktime(wall_to_monotonic);
 
 	} while (read_seqretry(&xtime_lock, seq));
Index: linux/kernel/time/ntp.c
===================================================================
--- linux.orig/kernel/time/ntp.c
+++ linux/kernel/time/ntp.c
@@ -24,7 +24,7 @@ static u64 tick_length, tick_length_base
 
 #define MAX_TICKADJ		500		/* microsecs */
 #define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
-				  TICK_LENGTH_SHIFT) / HZ)
+				  TICK_LENGTH_SHIFT) / NTP_INTERVAL_FREQ)
 
 /*
  * phase-lock loop variables
@@ -46,13 +46,17 @@ long time_adjust;
 
 static void ntp_update_frequency(void)
 {
-	tick_length_base = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ) << TICK_LENGTH_SHIFT;
-	tick_length_base += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
-	tick_length_base += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
+	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
+				<< TICK_LENGTH_SHIFT;
+	second_length += (s64)CLOCK_TICK_ADJUST << TICK_LENGTH_SHIFT;
+	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
 
-	do_div(tick_length_base, HZ);
+	tick_length_base = second_length;
 
-	tick_nsec = tick_length_base >> TICK_LENGTH_SHIFT;
+	do_div(second_length, HZ);
+	tick_nsec = second_length >> TICK_LENGTH_SHIFT;
+
+	do_div(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -164,7 +168,7 @@ void second_overflow(void)
 			tick_length -= MAX_TICKADJ_SCALED;
 		} else {
 			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
-					     HZ) << TICK_LENGTH_SHIFT;
+					NTP_INTERVAL_FREQ) << TICK_LENGTH_SHIFT;
 			time_adjust = 0;
 		}
 	}
@@ -241,7 +245,8 @@ int do_adjtimex(struct timex *txc)
 		    result = -EINVAL;
 		    goto leave;
 		}
-		time_freq = ((s64)txc->freq * NSEC_PER_USEC) >> (SHIFT_USEC - SHIFT_NSEC);
+		time_freq = ((s64)txc->freq * NSEC_PER_USEC)
+				>> (SHIFT_USEC - SHIFT_NSEC);
 	    }
 
 	    if (txc->modes & ADJ_MAXERROR) {
@@ -311,7 +316,8 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = (time_offset / HZ) << SHIFT_UPDATE;
+		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
+		    			<< SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
 	    if (txc->modes & ADJ_TICK)
@@ -326,8 +332,10 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT)
 	    txc->offset	   = save_adjust;
 	else
-	    txc->offset    = shift_right(time_offset, SHIFT_UPDATE) * HZ / 1000;
-	txc->freq	   = (time_freq / NSEC_PER_USEC) << (SHIFT_USEC - SHIFT_NSEC);
+	    txc->offset    = shift_right(time_offset, SHIFT_UPDATE)
+	    			* NTP_INTERVAL_FREQ / 1000;
+	txc->freq	   = (time_freq / NSEC_PER_USEC)
+				<< (SHIFT_USEC - SHIFT_NSEC);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
Index: linux/kernel/timer.c
===================================================================
--- linux.orig/kernel/timer.c
+++ linux/kernel/timer.c
@@ -1030,7 +1030,7 @@ static void change_clocksource(void)
 
 	clock->error = 0;
 	clock->xtime_nsec = 0;
-	clocksource_calculate_interval(clock, tick_nsec);
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 
 	tick_clock_notify();
 
@@ -1086,7 +1086,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock, tick_nsec);
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	xtime.tv_sec = sec;
