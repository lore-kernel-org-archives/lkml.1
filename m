Return-Path: <linux-kernel-owner+w=401wt.eu-S1759309AbYCNUCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759309AbYCNUCE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757279AbYCNUBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:01:06 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48230 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbYCNUBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:01:01 -0400
Message-Id: <20080314195737.095246143@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 19:40:07 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Subject: [PATCH 6/8] Rename TICK_LENGTH_SHIFT to NTP_SCALE_SHIFT
Content-Disposition: inline; filename=ntp_scale_shift
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As TICK_LENGTH_SHIFT is used for more than just the tick length, the
name isn't quite approriate anymore, so this renames it to
NTP_SCALE_SHIFT.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 arch/powerpc/kernel/time.c |    2 +-
 include/linux/timex.h      |    8 ++++----
 kernel/time/ntp.c          |   20 ++++++++++----------
 kernel/time/timekeeping.c  |   10 +++++-----
 4 files changed, 20 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c	2008-03-10 14:46:52.000000000 +0100
+++ linux-2.6/arch/powerpc/kernel/time.c	2008-03-10 14:57:30.000000000 +0100
@@ -149,7 +149,7 @@ EXPORT_SYMBOL(tb_ticks_per_sec);	/* for 
 u64 tb_to_xs;
 unsigned tb_to_us;
 
-#define TICKLEN_SCALE	TICK_LENGTH_SHIFT
+#define TICKLEN_SCALE	NTP_SCALE_SHIFT
 u64 last_tick_len;	/* units are ns / 2^TICKLEN_SCALE */
 u64 ticklen_to_xs;	/* 0.64 fraction */
 
Index: linux-2.6/include/linux/timex.h
===================================================================
--- linux-2.6.orig/include/linux/timex.h	2008-03-10 14:56:07.000000000 +0100
+++ linux-2.6/include/linux/timex.h	2008-03-10 19:50:34.000000000 +0100
@@ -79,14 +79,14 @@
  * offset and maximum frequency tolerance.
  */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
-#define PPM_SCALE (NSEC_PER_USEC << (TICK_LENGTH_SHIFT - SHIFT_USEC))
+#define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
 #define PPM_SCALE_INV_SHIFT 20
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + TICK_LENGTH_SHIFT)) / \
+#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
 		       PPM_SCALE + 1)
 
 #define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
-#define MAXFREQ_SCALED ((s64)MAXFREQ << TICK_LENGTH_SHIFT)
+#define MAXFREQ_SCALED ((s64)MAXFREQ << NTP_SCALE_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
 #define MAXSEC 2048		/* max interval between updates (s) */
 #define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
@@ -228,7 +228,7 @@ static inline int ntp_synced(void)
 	__x < 0 ? -(-__x >> __s) : __x >> __s;	\
 })
 
-#define TICK_LENGTH_SHIFT	32
+#define NTP_SCALE_SHIFT		32
 
 #ifdef CONFIG_NO_HZ
 #define NTP_INTERVAL_FREQ  (2)
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c	2008-03-10 14:56:07.000000000 +0100
+++ linux-2.6/kernel/time/ntp.c	2008-03-10 19:50:34.000000000 +0100
@@ -27,7 +27,7 @@ static u64 tick_length, tick_length_base
 
 #define MAX_TICKADJ		500		/* microsecs */
 #define MAX_TICKADJ_SCALED	(((u64)(MAX_TICKADJ * NSEC_PER_USEC) << \
-				  TICK_LENGTH_SHIFT) / NTP_INTERVAL_FREQ)
+				  NTP_SCALE_SHIFT) / NTP_INTERVAL_FREQ)
 
 /*
  * phase-lock loop variables
@@ -48,13 +48,13 @@ static long ntp_tick_adj;
 static void ntp_update_frequency(void)
 {
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
-				<< TICK_LENGTH_SHIFT;
-	second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
+				<< NTP_SCALE_SHIFT;
+	second_length += (s64)ntp_tick_adj << NTP_SCALE_SHIFT;
 	second_length += time_freq;
 
 	tick_length_base = second_length;
 
-	tick_nsec = div_u64(second_length, HZ) >> TICK_LENGTH_SHIFT;
+	tick_nsec = div_u64(second_length, HZ) >> NTP_SCALE_SHIFT;
 	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
@@ -86,10 +86,10 @@ static void ntp_update_offset(long offse
 	time_reftime = xtime.tv_sec;
 
 	freq_adj = (s64)offset * mtemp;
-	freq_adj <<= TICK_LENGTH_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
+	freq_adj <<= NTP_SCALE_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
 	time_status &= ~STA_MODE;
 	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-		freq_adj += div_s64((s64)offset << (TICK_LENGTH_SHIFT - SHIFT_FLL),
+		freq_adj += div_s64((s64)offset << (NTP_SCALE_SHIFT - SHIFT_FLL),
 				    mtemp);
 		time_status |= STA_MODE;
 	}
@@ -97,7 +97,7 @@ static void ntp_update_offset(long offse
 	freq_adj = min(freq_adj, MAXFREQ_SCALED);
 	time_freq = max(freq_adj, -MAXFREQ_SCALED);
 
-	time_offset = div_s64((s64)offset << TICK_LENGTH_SHIFT, NTP_INTERVAL_FREQ);
+	time_offset = div_s64((s64)offset << NTP_SCALE_SHIFT, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -197,7 +197,7 @@ void second_overflow(void)
 			tick_length -= MAX_TICKADJ_SCALED;
 		} else {
 			tick_length += (s64)(time_adjust * NSEC_PER_USEC /
-					NTP_INTERVAL_FREQ) << TICK_LENGTH_SHIFT;
+					NTP_INTERVAL_FREQ) << NTP_SCALE_SHIFT;
 			time_adjust = 0;
 		}
 	}
@@ -369,13 +369,13 @@ int do_adjtimex(struct timex *txc)
 		txc->offset = save_adjust;
 	else {
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
-					  TICK_LENGTH_SHIFT);
+					  NTP_SCALE_SHIFT);
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
 	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
 					 (s64)PPM_SCALE_INV,
-					 TICK_LENGTH_SHIFT);
+					 NTP_SCALE_SHIFT);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
Index: linux-2.6/kernel/time/timekeeping.c
===================================================================
--- linux-2.6.orig/kernel/time/timekeeping.c	2008-03-10 14:37:04.000000000 +0100
+++ linux-2.6/kernel/time/timekeeping.c	2008-03-10 19:50:34.000000000 +0100
@@ -365,7 +365,7 @@ static __always_inline int clocksource_b
 	 * here.  This is tuned so that an error of about 1 msec is adjusted
 	 * within about 1 sec (or 2^20 nsec in 2^SHIFT_HZ ticks).
 	 */
-	error2 = clock->error >> (TICK_LENGTH_SHIFT + 22 - 2 * SHIFT_HZ);
+	error2 = clock->error >> (NTP_SCALE_SHIFT + 22 - 2 * SHIFT_HZ);
 	error2 = abs(error2);
 	for (look_ahead = 0; error2 > 0; look_ahead++)
 		error2 >>= 2;
@@ -375,7 +375,7 @@ static __always_inline int clocksource_b
 	 * remove the single look ahead already included in the error.
 	 */
 	tick_error = current_tick_length() >>
-		(TICK_LENGTH_SHIFT - clock->shift + 1);
+		(NTP_SCALE_SHIFT - clock->shift + 1);
 	tick_error -= clock->xtime_interval >> 1;
 	error = ((error - tick_error) >> look_ahead) + tick_error;
 
@@ -406,7 +406,7 @@ static void clocksource_adjust(s64 offse
 	s64 error, interval = clock->cycle_interval;
 	int adj;
 
-	error = clock->error >> (TICK_LENGTH_SHIFT - clock->shift - 1);
+	error = clock->error >> (NTP_SCALE_SHIFT - clock->shift - 1);
 	if (error > interval) {
 		error >>= 2;
 		if (likely(error <= interval))
@@ -428,7 +428,7 @@ static void clocksource_adjust(s64 offse
 	clock->xtime_interval += interval;
 	clock->xtime_nsec -= offset;
 	clock->error -= (interval - offset) <<
-			(TICK_LENGTH_SHIFT - clock->shift);
+			(NTP_SCALE_SHIFT - clock->shift);
 }
 
 /**
@@ -468,7 +468,7 @@ void update_wall_time(void)
 
 		/* accumulate error between NTP and clock interval */
 		clock->error += current_tick_length();
-		clock->error -= clock->xtime_interval << (TICK_LENGTH_SHIFT - clock->shift);
+		clock->error -= clock->xtime_interval << (NTP_SCALE_SHIFT - clock->shift);
 	}
 
 	/* correct the clock when NTP error is too big */

-- 

