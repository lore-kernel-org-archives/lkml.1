Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbYCOENA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbYCOENA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 00:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750824AbYCOEMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 00:12:52 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36166 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYCOEMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 00:12:51 -0400
Subject: [PATCH 4/5]  ntp.c code flow clenaups  (from Ingo)
From: john stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1205554210.6122.85.camel@localhost.localdomain>
References: <1205553852.6122.76.camel@localhost.localdomain>
	 <1205553938.6122.79.camel@localhost.localdomain>
	 <1205554018.6122.81.camel@localhost.localdomain>
	 <1205554210.6122.85.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 21:12:46 -0700
Message-Id: <1205554366.6122.88.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: [patch] ntp: clean up code flow

clean up the flow of code by splitting the way too large and way too
nested do_adjtimex() function.

no change in the logic.

Signed-off-by: Ingo Molnar <mingo@elte.hu>

Merged on top of Roman's very similar cleanups.
(In other words: Blame John for the merge screwups).

Signed-off-by: John Stultz <johnstul@us.ibm.com>

Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c	2008-03-14 20:10:41.000000000 -0700
+++ linux-2.6/kernel/time/ntp.c	2008-03-14 20:43:48.000000000 -0700
@@ -275,6 +275,87 @@ static void notify_cmos_timer(void)
 static inline void notify_cmos_timer(void) { }
 #endif
 
+static inline void process_adjtimex_adj_offset(struct timex *txc, long sec)
+{
+	if (txc->modes & ADJ_STATUS) {
+		if ((time_status & STA_PLL) && !(txc->status & STA_PLL)) {
+			time_state = TIME_OK;
+			time_status = STA_UNSYNC;
+		}
+		/* only set allowed bits */
+		time_status &= STA_RONLY;
+		time_status |= txc->status & ~STA_RONLY;
+
+		switch (time_state) {
+		case TIME_OK:
+		start_timer:
+			if (time_status & STA_INS) {
+				time_state = TIME_INS;
+				sec += 86400 - sec % 86400;
+				hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
+			} else if (time_status & STA_DEL) {
+				time_state = TIME_DEL;
+				sec += 86400 - (sec + 1) % 86400;
+				hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
+			}
+			break;
+		case TIME_INS:
+		case TIME_DEL:
+			time_state = TIME_OK;
+			goto start_timer;
+			break;
+		case TIME_WAIT:
+			if (!(time_status & (STA_INS | STA_DEL)))
+				time_state = TIME_OK;
+			break;
+		case TIME_OOP:
+			hrtimer_restart(&leap_timer);
+			break;
+		}
+	}
+
+	if (txc->modes & ADJ_NANO)
+		time_status |= STA_NANO;
+	if (txc->modes & ADJ_MICRO)
+		time_status &= ~STA_NANO;
+
+	if (txc->modes & ADJ_FREQUENCY) {
+		time_freq = (s64)txc->freq * PPM_SCALE;
+		time_freq = min(time_freq, MAXFREQ_SCALED);
+		time_freq = max(time_freq, -MAXFREQ_SCALED);
+	}
+
+	if (txc->modes & ADJ_MAXERROR)
+		time_maxerror = txc->maxerror;
+	if (txc->modes & ADJ_ESTERROR)
+		time_esterror = txc->esterror;
+
+	if (txc->modes & ADJ_TIMECONST) {
+		time_constant = txc->constant;
+		if (!(time_status & STA_NANO))
+			time_constant += 4;
+		time_constant = min(time_constant, (long)MAXTC);
+		time_constant = max(time_constant, 0l);
+	}
+
+	if (txc->modes & ADJ_TAI && txc->constant > 0)
+		time_tai = txc->constant;
+
+	if (txc->modes & ADJ_OFFSET) {
+		if (txc->modes == ADJ_OFFSET_SINGLESHOT)
+			/* adjtime() is independent from ntp_adjtime() */
+			time_adjust = txc->offset;
+		else
+			ntp_update_offset(txc->offset);
+	}
+
+	if (txc->modes & ADJ_TICK)
+		tick_usec = txc->tick;
+
+	if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
+		ntp_update_frequency();
+}
+
 /*
  * adjtimex mainly allows reading (and writing, if superuser) of
  * kernel time-keeping variables. used by xntpd.
@@ -282,7 +363,7 @@ static inline void notify_cmos_timer(voi
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
-	long save_adjust, sec;
+	long save_adjust;
 	int result;
 
 	/* In order to modify anything, you gotta be super-user! */
@@ -306,6 +387,7 @@ int do_adjtimex(struct timex *txc)
 
 	if (time_state != TIME_OK && txc->modes & ADJ_STATUS)
 		hrtimer_cancel(&leap_timer);
+
 	getnstimeofday(&ts);
 
 	write_seqlock_irq(&xtime_lock);
@@ -314,121 +396,42 @@ int do_adjtimex(struct timex *txc)
 	save_adjust = time_adjust;
 
 	/* If there are input parameters, then process them */
-	if (txc->modes) {
-		if (txc->modes & ADJ_STATUS) {
-			if ((time_status & STA_PLL) &&
-			    !(txc->status & STA_PLL)) {
-				time_state = TIME_OK;
-				time_status = STA_UNSYNC;
-			}
-			/* only set allowed bits */
-			time_status &= STA_RONLY;
-			time_status |= txc->status & ~STA_RONLY;
-
-			switch (time_state) {
-			case TIME_OK:
-			start_timer:
-				sec = ts.tv_sec;
-				if (time_status & STA_INS) {
-					time_state = TIME_INS;
-					sec += 86400 - sec % 86400;
-					hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
-				} else if (time_status & STA_DEL) {
-					time_state = TIME_DEL;
-					sec += 86400 - (sec + 1) % 86400;
-					hrtimer_start(&leap_timer, ktime_set(sec, 0), HRTIMER_MODE_ABS);
-				}
-				break;
-			case TIME_INS:
-			case TIME_DEL:
-				time_state = TIME_OK;
-				goto start_timer;
-				break;
-			case TIME_WAIT:
-				if (!(time_status & (STA_INS | STA_DEL)))
-					time_state = TIME_OK;
-				break;
-			case TIME_OOP:
-				hrtimer_restart(&leap_timer);
-				break;
-			}
-		}
-
-		if (txc->modes & ADJ_NANO)
-			time_status |= STA_NANO;
-		if (txc->modes & ADJ_MICRO)
-			time_status &= ~STA_NANO;
-
-		if (txc->modes & ADJ_FREQUENCY) {
-			time_freq = (s64)txc->freq * PPM_SCALE;
-			time_freq = min(time_freq, MAXFREQ_SCALED);
-			time_freq = max(time_freq, -MAXFREQ_SCALED);
-		}
-
-		if (txc->modes & ADJ_MAXERROR)
-			time_maxerror = txc->maxerror;
-		if (txc->modes & ADJ_ESTERROR)
-			time_esterror = txc->esterror;
-
-		if (txc->modes & ADJ_TIMECONST) {
-			time_constant = txc->constant;
-			if (!(time_status & STA_NANO))
-				time_constant += 4;
-			time_constant = min(time_constant, (long)MAXTC);
-			time_constant = max(time_constant, 0l);
-		}
-
-		if (txc->modes & ADJ_TAI && txc->constant > 0)
-			time_tai = txc->constant;
-
-		if (txc->modes & ADJ_OFFSET) {
-			if (txc->modes == ADJ_OFFSET_SINGLESHOT)
-				/* adjtime() is independent from ntp_adjtime() */
-				time_adjust = txc->offset;
-			else
-				ntp_update_offset(txc->offset);
-		}
-		if (txc->modes & ADJ_TICK)
-			tick_usec = txc->tick;
-
-		if (txc->modes & (ADJ_TICK|ADJ_FREQUENCY|ADJ_OFFSET))
-			ntp_update_frequency();
-	}
+	if (txc->modes)
+		process_adjtimex_adj_offset(txc, ts.tv_sec);
 
 	result = time_state;	/* mostly `TIME_OK' */
 	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
 		result = TIME_ERROR;
 
 	if ((txc->modes == ADJ_OFFSET_SINGLESHOT) ||
-	    (txc->modes == ADJ_OFFSET_SS_READ))
+			(txc->modes == ADJ_OFFSET_SS_READ)) {
 		txc->offset = save_adjust;
-	else {
+	} else {
 		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
 					  NTP_SCALE_SHIFT);
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
-	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
-					 (s64)PPM_SCALE_INV,
-					 NTP_SCALE_SHIFT);
-	txc->maxerror	   = time_maxerror;
-	txc->esterror	   = time_esterror;
-	txc->status	   = time_status;
-	txc->constant	   = time_constant;
-	txc->precision	   = 1;
-	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
-	txc->tick	   = tick_usec;
-	txc->tai	   = time_tai;
+	txc->freq	= shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
+					 (s64)PPM_SCALE_INV, NTP_SCALE_SHIFT);
+	txc->maxerror	= time_maxerror;
+	txc->esterror	= time_esterror;
+	txc->status	= time_status;
+	txc->constant	= time_constant;
+	txc->precision	= 1;
+	txc->tolerance	= MAXFREQ_SCALED / PPM_SCALE;
+	txc->tick	= tick_usec;
+	txc->tai	= time_tai;
 
 	/* PPS is not implemented, so these are zero */
-	txc->ppsfreq	   = 0;
-	txc->jitter	   = 0;
-	txc->shift	   = 0;
-	txc->stabil	   = 0;
-	txc->jitcnt	   = 0;
-	txc->calcnt	   = 0;
-	txc->errcnt	   = 0;
-	txc->stbcnt	   = 0;
+	txc->ppsfreq	= 0;
+	txc->jitter	= 0;
+	txc->shift	= 0;
+	txc->stabil	= 0;
+	txc->jitcnt	= 0;
+	txc->calcnt	= 0;
+	txc->errcnt	= 0;
+	txc->stbcnt	= 0;
 	write_sequnlock_irq(&xtime_lock);
 
 	txc->time.tv_sec = ts.tv_sec;


