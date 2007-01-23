Return-Path: <linux-kernel-owner+w=401wt.eu-S933108AbXAWWRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933108AbXAWWRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933168AbXAWWRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:17:08 -0500
Received: from www.osadl.org ([213.239.205.134]:35799 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933108AbXAWWAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:44 -0500
Message-Id: <20070123211203.020952000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:00:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 03/46] [RFC] HZ free ntp
Content-Disposition: inline; filename=ntp-make-dyntick-aware.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From johnstul@us.ibm.com Wed Dec 20 02:36:15 2006

Distangle the NTP update from HZ. This is necessary for dynamic tick
enabled kernels.

---
 include/linux/timex.h |    7 +++++++
 kernel/hrtimer.c      |   11 ++++++++---
 kernel/time/ntp.c     |   30 +++++++++++++++++++-----------
 kernel/timer.c        |    4 ++--
 4 files changed, 36 insertions(+), 16 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/timex.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/timex.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/timex.h
@@ -286,6 +286,13 @@ static inline void time_interpolator_upd
 
 #define TICK_LENGTH_SHIFT	32
 
+#ifdef CONFIG_NO_HZ
+#define NTP_INTERVAL_FREQ  (2)
+#else
+#define NTP_INTERVAL_FREQ  (HZ)
+#endif
+#define NTP_INTERVAL_LENGTH (NSEC_PER_SEC/NTP_INTERVAL_FREQ)
+
 /* Returns how long ticks are at present, in ns / 2^(SHIFT_SCALE-10). */
 extern u64 current_tick_length(void);
 
Index: linux-2.6.20-rc4-mm1-bo/kernel/time/ntp.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/time/ntp.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/time/ntp.c
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
@@ -162,7 +166,7 @@ void second_overflow(void)
 			tick_length -= MAX_TICKADJ_SCALED;
 		} else {
 			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
-					     HZ) << TICK_LENGTH_SHIFT;
+					NTP_INTERVAL_FREQ) << TICK_LENGTH_SHIFT;
 			time_adjust = 0;
 		}
 	}
@@ -239,7 +243,8 @@ int do_adjtimex(struct timex *txc)
 		    result = -EINVAL;
 		    goto leave;
 		}
-		time_freq = ((s64)txc->freq * NSEC_PER_USEC) >> (SHIFT_USEC - SHIFT_NSEC);
+		time_freq = ((s64)txc->freq * NSEC_PER_USEC)
+				>> (SHIFT_USEC - SHIFT_NSEC);
 	    }
 
 	    if (txc->modes & ADJ_MAXERROR) {
@@ -309,7 +314,8 @@ int do_adjtimex(struct timex *txc)
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = (time_offset / HZ) << SHIFT_UPDATE;
+		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
+		    			<< SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
 	    if (txc->modes & ADJ_TICK)
@@ -324,8 +330,10 @@ leave:	if ((time_status & (STA_UNSYNC|ST
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
Index: linux-2.6.20-rc4-mm1-bo/kernel/timer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/timer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/timer.c
@@ -890,7 +890,7 @@ void __init timekeeping_init(void)
 	ntp_clear();
 
 	clock = clocksource_get_next();
-	clocksource_calculate_interval(clock, tick_nsec);
+	clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	clock->cycle_last = clocksource_read(clock);
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
@@ -1092,7 +1092,7 @@ static void update_wall_time(void)
 	if (change_clocksource()) {
 		clock->error = 0;
 		clock->xtime_nsec = 0;
-		clocksource_calculate_interval(clock, tick_nsec);
+		clocksource_calculate_interval(clock, NTP_INTERVAL_LENGTH);
 	}
 }
 
Index: linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/hrtimer.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/hrtimer.c
@@ -128,15 +128,20 @@ EXPORT_SYMBOL_GPL(ktime_get_ts);
 static void hrtimer_get_softirq_time(struct hrtimer_base *base)
 {
 	ktime_t xtim, tomono;
+	struct timespec xts;
 	unsigned long seq;
 
 	do {
 		seq = read_seqbegin(&xtime_lock);
-		xtim = timespec_to_ktime(xtime);
-		tomono = timespec_to_ktime(wall_to_monotonic);
-
+#ifdef CONFIG_NO_HZ
+		getnstimeofday(&xts);
+#else
+		xts = xtime;
+#endif
 	} while (read_seqretry(&xtime_lock, seq));
 
+	xtim = timespec_to_ktime(xts);
+	tomono = timespec_to_ktime(wall_to_monotonic);
 	base[CLOCK_REALTIME].softirq_time = xtim;
 	base[CLOCK_MONOTONIC].softirq_time = ktime_add(xtim, tomono);
 }

--

