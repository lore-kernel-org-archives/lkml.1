Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbYCNUBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbYCNUBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756614AbYCNUBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:01:04 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48224 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbYCNUBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:01:00 -0400
Message-Id: <20080314195736.916228977@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 19:40:04 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Subject: [PATCH 3/8] increase time_freq resolution
Content-Disposition: inline; filename=time_freq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes time_freq to a 64bit value and makes it static (the only
outside user had no real need to modify it).
Intermediate values were already 64bit, so the change isn't that big,
but it saves a little in shifts by replacing SHIFT_NSEC with
TICK_LENGTH_SHIFT. PPM_SCALE is then used to convert between user space
and kernel space representation.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 arch/powerpc/kernel/time.c |    2 --
 include/linux/timex.h      |   11 ++++++-----
 kernel/time/ntp.c          |   30 +++++++++++++++---------------
 3 files changed, 21 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/powerpc/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/time.c	2008-03-10 14:36:42.000000000 +0100
+++ linux-2.6/arch/powerpc/kernel/time.c	2008-03-10 19:50:43.000000000 +0100
@@ -1007,8 +1007,6 @@ void __init time_init(void)
 	vdso_data->stamp_xsec = (u64) xtime.tv_sec * XSEC_PER_SEC;
 	vdso_data->tb_to_xs = tb_to_xs;
 
-	time_freq = 0;
-
 	write_sequnlock_irqrestore(&xtime_lock, flags);
 
 	/* Register the clocksource, if we're not running on iSeries */
Index: linux-2.6/include/linux/timex.h
===================================================================
--- linux-2.6.orig/include/linux/timex.h	2008-03-10 14:46:52.000000000 +0100
+++ linux-2.6/include/linux/timex.h	2008-03-10 19:50:43.000000000 +0100
@@ -84,11 +84,14 @@
  */
 #define SHIFT_UPDATE (SHIFT_HZ + 1) /* time offset scale (shift) */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
-#define SHIFT_NSEC 12		/* kernel frequency offset scale */
+#define PPM_SCALE (NSEC_PER_USEC << (TICK_LENGTH_SHIFT - SHIFT_USEC))
+#define PPM_SCALE_INV_SHIFT 20
+#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + TICK_LENGTH_SHIFT)) / \
+		       PPM_SCALE + 1)
 
 #define MAXPHASE 512000L        /* max phase error (us) */
-#define MAXFREQ (512L << SHIFT_USEC)  /* max frequency error (ppm) */
-#define MAXFREQ_NSEC (512000L << SHIFT_NSEC) /* max frequency error (ppb) */
+#define MAXFREQ 500000		/* max frequency error (ns/s) */
+#define MAXFREQ_SCALED ((s64)MAXFREQ << TICK_LENGTH_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
 #define MAXSEC 2048		/* max interval between updates (s) */
 #define	NTP_PHASE_LIMIT	(MAXPHASE << 5)	/* beyond max. dispersion */
@@ -208,8 +211,6 @@ extern int time_status;		/* clock synchr
 extern long time_maxerror;	/* maximum error */
 extern long time_esterror;	/* estimated error */
 
-extern long time_freq;		/* frequency offset (scaled ppm) */
-
 extern long time_adjust;	/* The amount of adjtime left */
 
 extern void ntp_clear(void);
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c	2008-03-10 14:46:52.000000000 +0100
+++ linux-2.6/kernel/time/ntp.c	2008-03-10 19:50:43.000000000 +0100
@@ -39,7 +39,7 @@ static s64 time_offset;			/* time adjust
 static long time_constant = 2;		/* pll time constant		*/
 long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
 long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
-long time_freq;				/* frequency offset (scaled ppm)*/
+static s64 time_freq;			/* frequency offset (scaled ns/s)*/
 static long time_reftime;		/* time at last adjustment (s)	*/
 long time_adjust;
 static long ntp_tick_adj;
@@ -49,7 +49,7 @@ static void ntp_update_frequency(void)
 	u64 second_length = (u64)(tick_usec * NSEC_PER_USEC * USER_HZ)
 				<< TICK_LENGTH_SHIFT;
 	second_length += (s64)ntp_tick_adj << TICK_LENGTH_SHIFT;
-	second_length += (s64)time_freq << (TICK_LENGTH_SHIFT - SHIFT_NSEC);
+	second_length += time_freq;
 
 	tick_length_base = second_length;
 
@@ -86,16 +86,16 @@ static void ntp_update_offset(long offse
 	time_reftime = xtime.tv_sec;
 
 	freq_adj = time_offset * mtemp;
-	freq_adj = shift_right(freq_adj, time_constant * 2 +
-			   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
+	freq_adj <<= TICK_LENGTH_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
 	time_status &= ~STA_MODE;
 	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-		freq_adj += div_s64(time_offset << (SHIFT_NSEC - SHIFT_FLL), mtemp);
+		freq_adj += div_s64(time_offset << (TICK_LENGTH_SHIFT - SHIFT_FLL),
+				    mtemp);
 		time_status |= STA_MODE;
 	}
 	freq_adj += time_freq;
-	freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
-	time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
+	freq_adj = min(freq_adj, MAXFREQ_SCALED);
+	time_freq = max(freq_adj, -MAXFREQ_SCALED);
 	time_offset = div_s64(time_offset, NTP_INTERVAL_FREQ);
 	time_offset <<= SHIFT_UPDATE;
 }
@@ -131,7 +131,7 @@ void second_overflow(void)
 	long time_adj;
 
 	/* Bump the maxerror field */
-	time_maxerror += MAXFREQ >> SHIFT_USEC;
+	time_maxerror += MAXFREQ / NSEC_PER_USEC;
 	if (time_maxerror > NTP_PHASE_LIMIT) {
 		time_maxerror = NTP_PHASE_LIMIT;
 		time_status |= STA_UNSYNC;
@@ -323,10 +323,9 @@ int do_adjtimex(struct timex *txc)
 			time_status &= ~STA_NANO;
 
 		if (txc->modes & ADJ_FREQUENCY) {
-			time_freq = min(txc->freq, MAXFREQ);
-			time_freq = min(time_freq, -MAXFREQ);
-			time_freq = ((s64)time_freq * NSEC_PER_USEC)
-					>> (SHIFT_USEC - SHIFT_NSEC);
+			time_freq = (s64)txc->freq * PPM_SCALE;
+			time_freq = min(time_freq, MAXFREQ_SCALED);
+			time_freq = max(time_freq, -MAXFREQ_SCALED);
 		}
 
 		if (txc->modes & ADJ_MAXERROR)
@@ -369,14 +368,15 @@ int do_adjtimex(struct timex *txc)
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
-	txc->freq	   = (time_freq / NSEC_PER_USEC) <<
-				(SHIFT_USEC - SHIFT_NSEC);
+	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
+					 (s64)PPM_SCALE_INV,
+					 TICK_LENGTH_SHIFT);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
 	txc->constant	   = time_constant;
 	txc->precision	   = 1;
-	txc->tolerance	   = MAXFREQ;
+	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
 	txc->tick	   = tick_usec;
 
 	/* PPS is not implemented, so these are zero */

-- 

