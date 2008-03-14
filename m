Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbYCNUCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbYCNUCm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbYCNUBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:01:08 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48232 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755774AbYCNUBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:01:01 -0400
Message-Id: <20080314195736.792798828@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 19:40:02 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Subject: [PATCH 1/8] cleanup ntp.c
Content-Disposition: inline; filename=update_offset
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is mostly a style cleanup of ntp.c and extracts part of do_adjtimex
as ntp_update_offset(). Otherwise the functionality is still the same as
before.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 kernel/time/ntp.c |  171 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 90 insertions(+), 81 deletions(-)

Index: linux-2.6-mm/kernel/time/ntp.c
===================================================================
--- linux-2.6-mm.orig/kernel/time/ntp.c
+++ linux-2.6-mm/kernel/time/ntp.c
@@ -35,7 +35,7 @@ static u64 tick_length, tick_length_base
 /* TIME_ERROR prevents overwriting the CMOS clock */
 static int time_state = TIME_OK;	/* clock synchronization status	*/
 int time_status = STA_UNSYNC;		/* clock status bits		*/
-static s64 time_offset;		/* time adjustment (ns)		*/
+static s64 time_offset;			/* time adjustment (ns)		*/
 static long time_constant = 2;		/* pll time constant		*/
 long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
 long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
@@ -57,6 +57,44 @@ static void ntp_update_frequency(void)
 	tick_length_base = div_u64(tick_length_base, NTP_INTERVAL_FREQ);
 }
 
+static void ntp_update_offset(long offset)
+{
+	long mtemp;
+	s64 freq_adj;
+
+	if (!(time_status & STA_PLL))
+		return;
+
+	time_offset = offset * NSEC_PER_USEC;
+
+	/*
+	 * Scale the phase adjustment and
+	 * clamp to the operating range.
+	 */
+	time_offset = min(time_offset, (s64)MAXPHASE * NSEC_PER_USEC);
+	time_offset = max(time_offset, (s64)-MAXPHASE * NSEC_PER_USEC);
+
+	/*
+	 * Select how the frequency is to be controlled
+	 * and in which mode (PLL or FLL).
+	 */
+	if (time_status & STA_FREQHOLD || time_reftime == 0)
+		time_reftime = xtime.tv_sec;
+	mtemp = xtime.tv_sec - time_reftime;
+	time_reftime = xtime.tv_sec;
+
+	freq_adj = time_offset * mtemp;
+	freq_adj = shift_right(freq_adj, time_constant * 2 +
+			   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
+	if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC))
+		freq_adj += div_s64(time_offset << (SHIFT_NSEC - SHIFT_FLL), mtemp);
+	freq_adj += time_freq;
+	freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
+	time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
+	time_offset = div_s64(time_offset, NTP_INTERVAL_FREQ);
+	time_offset <<= SHIFT_UPDATE;
+}
+
 /**
  * ntp_clear - Clears the NTP state variables
  *
@@ -131,7 +169,7 @@ void second_overflow(void)
 		break;
 	case TIME_WAIT:
 		if (!(time_status & (STA_INS | STA_DEL)))
-		time_state = TIME_OK;
+			time_state = TIME_OK;
 	}
 
 	/*
@@ -234,8 +272,7 @@ static inline void notify_cmos_timer(voi
  */
 int do_adjtimex(struct timex *txc)
 {
-	long mtemp, save_adjust;
-	s64 freq_adj;
+	long save_adjust;
 	int result;
 
 	/* In order to modify anything, you gotta be super-user! */
@@ -272,94 +309,63 @@ int do_adjtimex(struct timex *txc)
 	time_status &= ~STA_CLOCKERR;		/* reset STA_CLOCKERR */
 #endif
 	/* If there are input parameters, then process them */
-	if (txc->modes)
-	{
-	    if (txc->modes & ADJ_STATUS)	/* only set allowed bits */
-		time_status =  (txc->status & ~STA_RONLY) |
-			      (time_status & STA_RONLY);
-
-	    if (txc->modes & ADJ_FREQUENCY) {	/* p. 22 */
-		if (txc->freq > MAXFREQ || txc->freq < -MAXFREQ) {
-		    result = -EINVAL;
-		    goto leave;
+	if (txc->modes) {
+		if (txc->modes & ADJ_STATUS)	/* only set allowed bits */
+			time_status = (txc->status & ~STA_RONLY) |
+				      (time_status & STA_RONLY);
+
+		if (txc->modes & ADJ_FREQUENCY) {
+			if (txc->freq > MAXFREQ || txc->freq < -MAXFREQ) {
+				result = -EINVAL;
+				goto leave;
+			}
+			time_freq = ((s64)txc->freq * NSEC_PER_USEC)
+					>> (SHIFT_USEC - SHIFT_NSEC);
 		}
-		time_freq = ((s64)txc->freq * NSEC_PER_USEC)
-				>> (SHIFT_USEC - SHIFT_NSEC);
-	    }
-
-	    if (txc->modes & ADJ_MAXERROR) {
-		if (txc->maxerror < 0 || txc->maxerror >= NTP_PHASE_LIMIT) {
-		    result = -EINVAL;
-		    goto leave;
+
+		if (txc->modes & ADJ_MAXERROR) {
+			if (txc->maxerror < 0 || txc->maxerror >= NTP_PHASE_LIMIT) {
+				result = -EINVAL;
+				goto leave;
+			}
+			time_maxerror = txc->maxerror;
 		}
-		time_maxerror = txc->maxerror;
-	    }
 
-	    if (txc->modes & ADJ_ESTERROR) {
-		if (txc->esterror < 0 || txc->esterror >= NTP_PHASE_LIMIT) {
-		    result = -EINVAL;
-		    goto leave;
+		if (txc->modes & ADJ_ESTERROR) {
+			if (txc->esterror < 0 || txc->esterror >= NTP_PHASE_LIMIT) {
+				result = -EINVAL;
+				goto leave;
+			}
+			time_esterror = txc->esterror;
 		}
-		time_esterror = txc->esterror;
-	    }
 
-	    if (txc->modes & ADJ_TIMECONST) {	/* p. 24 */
-		if (txc->constant < 0) {	/* NTP v4 uses values > 6 */
-		    result = -EINVAL;
-		    goto leave;
+		if (txc->modes & ADJ_TIMECONST) {
+			if (txc->constant < 0) {	/* NTP v4 uses values > 6 */
+				result = -EINVAL;
+				goto leave;
+			}
+			time_constant = min(txc->constant + 4, (long)MAXTC);
 		}
-		time_constant = min(txc->constant + 4, (long)MAXTC);
-	    }
 
-	    if (txc->modes & ADJ_OFFSET) {	/* values checked earlier */
-		if (txc->modes == ADJ_OFFSET_SINGLESHOT) {
-		    /* adjtime() is independent from ntp_adjtime() */
-		    time_adjust = txc->offset;
+		if (txc->modes & ADJ_OFFSET) {
+			if (txc->modes == ADJ_OFFSET_SINGLESHOT)
+				/* adjtime() is independent from ntp_adjtime() */
+				time_adjust = txc->offset;
+			else
+				ntp_update_offset(txc->offset);
 		}
-		else if (time_status & STA_PLL) {
-		    time_offset = txc->offset * NSEC_PER_USEC;
+		if (txc->modes & ADJ_TICK)
+			tick_usec = txc->tick;
 
-		    /*
-		     * Scale the phase adjustment and
-		     * clamp to the operating range.
-		     */
-		    time_offset = min(time_offset, (s64)MAXPHASE * NSEC_PER_USEC);
-		    time_offset = max(time_offset, (s64)-MAXPHASE * NSEC_PER_USEC);
-
-		    /*
-		     * Select whether the frequency is to be controlled
-		     * and in which mode (PLL or FLL). Clamp to the operating
-		     * range. Ugly multiply/divide should be replaced someday.
-		     */
-
-		    if (time_status & STA_FREQHOLD || time_reftime == 0)
-		        time_reftime = xtime.tv_sec;
-		    mtemp = xtime.tv_sec - time_reftime;
-		    time_reftime = xtime.tv_sec;
-
-		    freq_adj = time_offset * mtemp;
-		    freq_adj = shift_right(freq_adj, time_constant * 2 +
-					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
-		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC))
-			freq_adj += div_s64(time_offset << (SHIFT_NSEC - SHIFT_FLL), mtemp);
-		    freq_adj += time_freq;
-		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
-		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = div_s64(time_offset, NTP_INTERVAL_FREQ);
-		    time_offset <<= SHIFT_UPDATE;
-		} /* STA_PLL */
-	    } /* txc->modes & ADJ_OFFSET */
-	    if (txc->modes & ADJ_TICK)
-		tick_usec = txc->tick;
-
-	    if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
-		    ntp_update_frequency();
-	} /* txc->modes */
-leave:	if ((time_status & (STA_UNSYNC|STA_CLOCKERR)) != 0)
+		if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
+			ntp_update_frequency();
+	}
+leave:
+	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
 		result = TIME_ERROR;
 
 	if ((txc->modes == ADJ_OFFSET_SINGLESHOT) ||
-			(txc->modes == ADJ_OFFSET_SS_READ))
+	    (txc->modes == ADJ_OFFSET_SS_READ))
 		txc->offset = save_adjust;
 	else
 		txc->offset = ((long)shift_right(time_offset, SHIFT_UPDATE)) *
@@ -384,9 +390,12 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	txc->errcnt	   = 0;
 	txc->stbcnt	   = 0;
 	write_sequnlock_irq(&xtime_lock);
+
 	do_gettimeofday(&txc->time);
+
 	notify_cmos_timer();
-	return(result);
+
+	return result;
 }
 
 static int __init ntp_tick_adj_setup(char *str)

-- 

