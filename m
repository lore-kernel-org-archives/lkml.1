Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbYCNUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbYCNUC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757584AbYCNUBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:01:07 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48229 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbYCNUBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:01:01 -0400
Message-Id: <20080314195736.975248867@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 19:40:05 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Subject: [PATCH 4/8] increase time_offset resolution
Content-Disposition: inline; filename=time_offset
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

time_offset is already a 64bit value but its resolution barely used, so
this makes better use of it by replacing SHIFT_UPDATE with
TICK_LENGTH_SHIFT.
Side note: the SHIFT_HZ in SHIFT_UPDATE was incorrect for CONFIG_NO_HZ
and the primary reason for changing time_offset to 64bit to avoid the
overflow.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/timex.h |    9 ++-------
 kernel/time/ntp.c     |   23 +++++++++++------------
 2 files changed, 13 insertions(+), 19 deletions(-)

Index: linux-2.6-mm/include/linux/timex.h
===================================================================
--- linux-2.6-mm.orig/include/linux/timex.h
+++ linux-2.6-mm/include/linux/timex.h
@@ -74,27 +74,22 @@
 #define MAXTC		10	/* maximum time constant (shift) */
 
 /*
- * The SHIFT_UPDATE define establishes the decimal point of the
- * time_offset variable which represents the current offset with
- * respect to standard time.
- *
  * SHIFT_USEC defines the scaling (shift) of the time_freq and
  * time_tolerance variables, which represent the current frequency
  * offset and maximum frequency tolerance.
  */
-#define SHIFT_UPDATE (SHIFT_HZ + 1) /* time offset scale (shift) */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
 #define PPM_SCALE (NSEC_PER_USEC << (TICK_LENGTH_SHIFT - SHIFT_USEC))
 #define PPM_SCALE_INV_SHIFT 20
 #define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + TICK_LENGTH_SHIFT)) / \
 		       PPM_SCALE + 1)
 
-#define MAXPHASE 512000L        /* max phase error (us) */
+#define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */
 #define MAXFREQ_SCALED ((s64)MAXFREQ << TICK_LENGTH_SHIFT)
 #define MINSEC 256		/* min interval between updates (s) */
 #define MAXSEC 2048		/* max interval between updates (s) */
-#define	NTP_PHASE_LIMIT	(MAXPHASE << 5)	/* beyond max. dispersion */
+#define NTP_PHASE_LIMIT ((MAXPHASE / NSEC_PER_USEC) << 5) /* beyond max. dispersion */
 
 /*
  * syscall interface - used (mainly by NTP daemon)
Index: linux-2.6-mm/kernel/time/ntp.c
===================================================================
--- linux-2.6-mm.orig/kernel/time/ntp.c
+++ linux-2.6-mm/kernel/time/ntp.c
@@ -65,16 +65,15 @@ static void ntp_update_offset(long offse
 	if (!(time_status & STA_PLL))
 		return;
 
-	time_offset = offset;
 	if (!(time_status & STA_NANO))
-		time_offset *= NSEC_PER_USEC;
+		offset *= NSEC_PER_USEC;
 
 	/*
 	 * Scale the phase adjustment and
 	 * clamp to the operating range.
 	 */
-	time_offset = min(time_offset, (s64)MAXPHASE * NSEC_PER_USEC);
-	time_offset = max(time_offset, (s64)-MAXPHASE * NSEC_PER_USEC);
+	offset = min(offset, MAXPHASE);
+	offset = max(offset, -MAXPHASE);
 
 	/*
 	 * Select how the frequency is to be controlled
@@ -85,19 +84,19 @@ static void ntp_update_offset(long offse
 	mtemp = xtime.tv_sec - time_reftime;
 	time_reftime = xtime.tv_sec;
 
-	freq_adj = time_offset * mtemp;
+	freq_adj = (s64)offset * mtemp;
 	freq_adj <<= TICK_LENGTH_SHIFT - 2 * (SHIFT_PLL + 2 + time_constant);
 	time_status &= ~STA_MODE;
 	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-		freq_adj += div_s64(time_offset << (TICK_LENGTH_SHIFT - SHIFT_FLL),
+		freq_adj += div_s64((s64)offset << (TICK_LENGTH_SHIFT - SHIFT_FLL),
 				    mtemp);
 		time_status |= STA_MODE;
 	}
 	freq_adj += time_freq;
 	freq_adj = min(freq_adj, MAXFREQ_SCALED);
 	time_freq = max(freq_adj, -MAXFREQ_SCALED);
-	time_offset = div_s64(time_offset, NTP_INTERVAL_FREQ);
-	time_offset <<= SHIFT_UPDATE;
+
+	time_offset = div_s64((s64)offset << TICK_LENGTH_SHIFT, NTP_INTERVAL_FREQ);
 }
 
 /**
@@ -128,7 +127,7 @@ void ntp_clear(void)
  */
 void second_overflow(void)
 {
-	long time_adj;
+	s64 time_adj;
 
 	/* Bump the maxerror field */
 	time_maxerror += MAXFREQ / NSEC_PER_USEC;
@@ -184,7 +183,7 @@ void second_overflow(void)
 	tick_length = tick_length_base;
 	time_adj = shift_right(time_offset, SHIFT_PLL + time_constant);
 	time_offset -= time_adj;
-	tick_length += (s64)time_adj << (TICK_LENGTH_SHIFT - SHIFT_UPDATE);
+	tick_length += time_adj;
 
 	if (unlikely(time_adjust)) {
 		if (time_adjust > MAX_TICKADJ) {
@@ -363,8 +362,8 @@ int do_adjtimex(struct timex *txc)
 	    (txc->modes == ADJ_OFFSET_SS_READ))
 		txc->offset = save_adjust;
 	else {
-		txc->offset = ((long)shift_right(time_offset, SHIFT_UPDATE)) *
-	    			NTP_INTERVAL_FREQ;
+		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
+					  TICK_LENGTH_SHIFT);
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}

-- 

