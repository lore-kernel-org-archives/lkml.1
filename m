Return-Path: <linux-kernel-owner+w=401wt.eu-S1752053AbXCXAkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbXCXAkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXCXAkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:40:39 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45951 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbXCXAki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:40:38 -0400
Subject: [PATCH] Avoid time_offset overflows
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 23 Mar 2007 17:40:34 -0700
Message-Id: <1174696834.5690.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing some odd NTP behavior recently on a few boxes and
finally narrowed it down to time_offset overflowing when converted to
SHIFT_UPDATE units (which was a side effect from my HZfreeNTP patch).

This patch converts time_offset from a long to a s64 which resolves the
issue.

thanks
-john

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index eb12509..eaa3d24 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -32,7 +32,7 @@ #define MAX_TICKADJ_SCALED	(((u64)(MAX_T
 /* TIME_ERROR prevents overwriting the CMOS clock */
 static int time_state = TIME_OK;	/* clock synchronization status	*/
 int time_status = STA_UNSYNC;		/* clock status bits		*/
-static long time_offset;		/* time adjustment (ns)		*/
+static s64 time_offset;		/* time adjustment (ns)		*/
 static long time_constant = 2;		/* pll time constant		*/
 long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
 long time_esterror = NTP_PHASE_LIMIT;	/* estimated error (us)		*/
@@ -196,7 +196,7 @@ void __attribute__ ((weak)) notify_arch_
  */
 int do_adjtimex(struct timex *txc)
 {
-	long ltemp, mtemp, save_adjust;
+	long mtemp, save_adjust;
 	s64 freq_adj, temp64;
 	int result;
 
@@ -277,14 +277,14 @@ #endif
 		    time_adjust = txc->offset;
 		}
 		else if (time_status & STA_PLL) {
-		    ltemp = txc->offset * NSEC_PER_USEC;
+		    time_offset = txc->offset * NSEC_PER_USEC;
 
 		    /*
 		     * Scale the phase adjustment and
 		     * clamp to the operating range.
 		     */
-		    time_offset = min(ltemp, MAXPHASE * NSEC_PER_USEC);
-		    time_offset = max(time_offset, -MAXPHASE * NSEC_PER_USEC);
+		    time_offset = min(time_offset, (s64)MAXPHASE * NSEC_PER_USEC);
+		    time_offset = max(time_offset, (s64)-MAXPHASE * NSEC_PER_USEC);
 
 		    /*
 		     * Select whether the frequency is to be controlled
@@ -297,11 +297,11 @@ #endif
 		    mtemp = xtime.tv_sec - time_reftime;
 		    time_reftime = xtime.tv_sec;
 
-		    freq_adj = (s64)time_offset * mtemp;
+		    freq_adj = time_offset * mtemp;
 		    freq_adj = shift_right(freq_adj, time_constant * 2 +
 					   (SHIFT_PLL + 2) * 2 - SHIFT_NSEC);
 		    if (mtemp >= MINSEC && (time_status & STA_FLL || mtemp > MAXSEC)) {
-			temp64 = (s64)time_offset << (SHIFT_NSEC - SHIFT_FLL);
+			temp64 = time_offset << (SHIFT_NSEC - SHIFT_FLL);
 			if (time_offset < 0) {
 			    temp64 = -temp64;
 			    do_div(temp64, mtemp);
@@ -314,8 +314,8 @@ #endif
 		    freq_adj += time_freq;
 		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
 		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
-		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
-		    			<< SHIFT_UPDATE;
+		    do_div(time_offset, NTP_INTERVAL_FREQ);
+		    time_offset <<= SHIFT_UPDATE;
 		} /* STA_PLL */
 	    } /* txc->modes & ADJ_OFFSET */
 	    if (txc->modes & ADJ_TICK)
@@ -330,7 +330,7 @@ leave:	if ((time_status & (STA_UNSYNC|ST
 	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT)
 	    txc->offset	   = save_adjust;
 	else
-	    txc->offset    = shift_right(time_offset, SHIFT_UPDATE)
+	    txc->offset    = ((long)shift_right(time_offset, SHIFT_UPDATE))
 	    			* NTP_INTERVAL_FREQ / 1000;
 	txc->freq	   = (time_freq / NSEC_PER_USEC)
 				<< (SHIFT_USEC - SHIFT_NSEC);



