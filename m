Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbYGUUEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbYGUUEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 16:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753888AbYGUUEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 16:04:43 -0400
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3505 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbYGUUEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 16:04:42 -0400
Date: Mon, 21 Jul 2008 21:59:57 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ADJ_OFFSET_SS_READ bug?
In-Reply-To: <cfd18e0f0807210336q3fa1102cq46708449af86a428@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0807212154470.6791@localhost.localdomain>
References: <485E0007.2020904@gmail.com>  <1214863650.3143.19.camel@localhost.localdomain>
  <cfd18e0f0806301830s7193c340k1dc857885cfc7803@mail.gmail.com>
 <cfd18e0f0807210336q3fa1102cq46708449af86a428@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 21 Jul 2008, Michael Kerrisk wrote:

> >> Sort of a quick off the cuff patch, but does the following look like the
> >> right fix to you?

I would more prefer a patch like below, instead of adding tests for this 
all over the place this separates the code more clearly, as this syscall 
is seriously overloaded.

bye, Roman


[PATCH] fix ADJ_OFFSET_SS_READ bug and do_adjtimex cleanup 

Thanks to the review by Michael Kerrisk <mtk.manpages@googlemail.com> a
bug in the recent ADJ_OFFSET_SS_READ option was discovered, where the
ntp time_offset was inadvertently set by it. This fixes this by making
the adjtime code more separate from the ntp_adjtime code (both of which
really want to be separate syscalls).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/timex.h |    9 +++++
 kernel/time/ntp.c     |   76 ++++++++++++++++++++++++++------------------------
 2 files changed, 48 insertions(+), 37 deletions(-)

Index: linux-2.6/include/linux/timex.h
===================================================================
--- linux-2.6.orig/include/linux/timex.h
+++ linux-2.6/include/linux/timex.h
@@ -141,8 +141,15 @@ struct timex {
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
+
+#ifdef __KERNEL__
+#define ADJ_ADJTIME		0x8000	/* switch between adjtime/adjtimex modes */
+#define ADJ_OFFSET_SINGLESHOT	0x0001	/* old-fashioned adjtime */
+#define ADJ_OFFSET_READONLY	0x2000	/* read-only adjtime */
+#else
 #define ADJ_OFFSET_SINGLESHOT	0x8001	/* old-fashioned adjtime */
-#define ADJ_OFFSET_SS_READ	0xa001  /* read-only adjtime */
+#define ADJ_OFFSET_SS_READ	0xa001	/* read-only adjtime */
+#endif
 
 /* xntp 3.4 compatibility names */
 #define MOD_OFFSET	ADJ_OFFSET
Index: linux-2.6/kernel/time/ntp.c
===================================================================
--- linux-2.6.orig/kernel/time/ntp.c
+++ linux-2.6/kernel/time/ntp.c
@@ -277,38 +277,50 @@ static inline void notify_cmos_timer(voi
 int do_adjtimex(struct timex *txc)
 {
 	struct timespec ts;
-	long save_adjust, sec;
 	int result;
 
-	/* In order to modify anything, you gotta be super-user! */
-	if (txc->modes && !capable(CAP_SYS_TIME))
-		return -EPERM;
-
-	/* Now we validate the data before disabling interrupts */
-
-	if ((txc->modes & ADJ_OFFSET_SINGLESHOT) == ADJ_OFFSET_SINGLESHOT) {
+	/* Validate the data before disabling interrupts */
+	if (txc->modes & ADJ_ADJTIME) {
 		/* singleshot must not be used with any other mode bits */
-		if (txc->modes & ~ADJ_OFFSET_SS_READ)
+		if (!(txc->modes & ADJ_OFFSET_SINGLESHOT))
 			return -EINVAL;
-	}
+		if (!(txc->modes & ADJ_OFFSET_READONLY) &&
+		    !capable(CAP_SYS_TIME))
+			return -EPERM;
+	} else {
+		/* In order to modify anything, you gotta be super-user! */
+		 if (txc->modes && !capable(CAP_SYS_TIME))
+			return -EPERM;
+
+		/* if the quartz is off by more than 10% something is VERY wrong! */
+		if (txc->modes & ADJ_TICK &&
+		    (txc->tick <  900000/USER_HZ ||
+		     txc->tick > 1100000/USER_HZ))
+				return -EINVAL;
 
-	/* if the quartz is off by more than 10% something is VERY wrong ! */
-	if (txc->modes & ADJ_TICK)
-		if (txc->tick <  900000/USER_HZ ||
-		    txc->tick > 1100000/USER_HZ)
-			return -EINVAL;
+		if (txc->modes & ADJ_STATUS && time_state != TIME_OK)
+			hrtimer_cancel(&leap_timer);
+	}
 
-	if (time_state != TIME_OK && txc->modes & ADJ_STATUS)
-		hrtimer_cancel(&leap_timer);
 	getnstimeofday(&ts);
 
 	write_seqlock_irq(&xtime_lock);
 
-	/* Save for later - semantics of adjtime is to return old value */
-	save_adjust = time_adjust;
-
 	/* If there are input parameters, then process them */
+	if (txc->modes & ADJ_ADJTIME) {
+		long save_adjust = time_adjust;
+
+		if (!(txc->modes & ADJ_OFFSET_READONLY)) {
+			/* adjtime() is independent from ntp_adjtime() */
+			time_adjust = txc->offset;
+			ntp_update_frequency();
+		}
+		txc->offset = save_adjust;
+		goto adj_done;
+	}
 	if (txc->modes) {
+		long sec;
+
 		if (txc->modes & ADJ_STATUS) {
 			if ((time_status & STA_PLL) &&
 			    !(txc->status & STA_PLL)) {
@@ -375,13 +387,8 @@ int do_adjtimex(struct timex *txc)
 		if (txc->modes & ADJ_TAI && txc->constant > 0)
 			time_tai = txc->constant;
 
-		if (txc->modes & ADJ_OFFSET) {
-			if (txc->modes == ADJ_OFFSET_SINGLESHOT)
-				/* adjtime() is independent from ntp_adjtime() */
-				time_adjust = txc->offset;
-			else
-				ntp_update_offset(txc->offset);
-		}
+		if (txc->modes & ADJ_OFFSET)
+			ntp_update_offset(txc->offset);
 		if (txc->modes & ADJ_TICK)
 			tick_usec = txc->tick;
 
@@ -389,19 +396,16 @@ int do_adjtimex(struct timex *txc)
 			ntp_update_frequency();
 	}
 
+	txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
+				  NTP_SCALE_SHIFT);
+	if (!(time_status & STA_NANO))
+		txc->offset /= NSEC_PER_USEC;
+
+adj_done:
 	result = time_state;	/* mostly `TIME_OK' */
 	if (time_status & (STA_UNSYNC|STA_CLOCKERR))
 		result = TIME_ERROR;
 
-	if ((txc->modes == ADJ_OFFSET_SINGLESHOT) ||
-	    (txc->modes == ADJ_OFFSET_SS_READ))
-		txc->offset = save_adjust;
-	else {
-		txc->offset = shift_right(time_offset * NTP_INTERVAL_FREQ,
-					  NTP_SCALE_SHIFT);
-		if (!(time_status & STA_NANO))
-			txc->offset /= NSEC_PER_USEC;
-	}
 	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
 					 (s64)PPM_SCALE_INV,
 					 NTP_SCALE_SHIFT);
