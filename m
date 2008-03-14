Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYCNUDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYCNUDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758567AbYCNUBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:01:11 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48228 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755426AbYCNUBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:01:01 -0400
Message-Id: <20080314195737.035249969@linux-m68k.org>
References: <20080314184001.695807682@linux-m68k.org>
User-Agent: quilt/0.46-1
Date: Fri, 14 Mar 2008 19:40:06 +0100
From: zippel@linux-m68k.org
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, johnstul@us.ibm.com
Subject: [PATCH 5/8] support for TAI
Content-Disposition: inline; filename=time_tai
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for setting the TAI value (International Atomic Time).
The value is reported back to userspace via timex (as we don't have a
ntp_gettime() syscall).

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/compat.h |    3 ++-
 include/linux/timex.h  |    4 +++-
 kernel/compat.c        |    3 ++-
 kernel/time/ntp.c      |    7 +++++++
 4 files changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6-mm/include/linux/compat.h
===================================================================
--- linux-2.6-mm.orig/include/linux/compat.h
+++ linux-2.6-mm/include/linux/compat.h
@@ -65,10 +65,11 @@ struct compat_timex {
 	compat_long_t calcnt;
 	compat_long_t errcnt;
 	compat_long_t stbcnt;
+	compat_int_t tai;
 
 	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
 	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
-	compat_int_t :32; compat_int_t :32; compat_int_t :32; compat_int_t :32;
+	compat_int_t :32; compat_int_t :32; compat_int_t :32;
 };
 
 #define _COMPAT_NSIG_WORDS	(_COMPAT_NSIG / _COMPAT_NSIG_BPW)
Index: linux-2.6-mm/include/linux/timex.h
===================================================================
--- linux-2.6-mm.orig/include/linux/timex.h
+++ linux-2.6-mm/include/linux/timex.h
@@ -116,9 +116,11 @@ struct timex {
 	long errcnt;            /* calibration errors (ro) */
 	long stbcnt;            /* stability limit exceeded (ro) */
 
+	int tai;		/* TAI offset (ro) */
+
 	int  :32; int  :32; int  :32; int  :32;
 	int  :32; int  :32; int  :32; int  :32;
-	int  :32; int  :32; int  :32; int  :32;
+	int  :32; int  :32; int  :32;
 };
 
 /*
@@ -135,6 +135,7 @@ struct timex {
 #define ADJ_ESTERROR		0x0008	/* estimated time error */
 #define ADJ_STATUS		0x0010	/* clock status */
 #define ADJ_TIMECONST		0x0020	/* pll time constant */
+#define ADJ_TAI			0x0080	/* set TAI offset */
 #define ADJ_MICRO		0x1000	/* select microsecond resolution */
 #define ADJ_NANO		0x2000	/* select nanosecond resolution */
 #define ADJ_TICK		0x4000	/* tick value */
Index: linux-2.6-mm/kernel/compat.c
===================================================================
--- linux-2.6-mm.orig/kernel/compat.c
+++ linux-2.6-mm/kernel/compat.c
@@ -955,7 +955,8 @@ asmlinkage long compat_sys_adjtimex(stru
 			__put_user(txc.jitcnt, &utp->jitcnt) ||
 			__put_user(txc.calcnt, &utp->calcnt) ||
 			__put_user(txc.errcnt, &utp->errcnt) ||
-			__put_user(txc.stbcnt, &utp->stbcnt))
+			__put_user(txc.stbcnt, &utp->stbcnt) ||
+			__put_user(txc.tai, &utp->tai))
 		ret = -EFAULT;
 
 	return ret;
Index: linux-2.6-mm/kernel/time/ntp.c
===================================================================
--- linux-2.6-mm.orig/kernel/time/ntp.c
+++ linux-2.6-mm/kernel/time/ntp.c
@@ -35,6 +35,7 @@ static u64 tick_length, tick_length_base
 /* TIME_ERROR prevents overwriting the CMOS clock */
 static int time_state = TIME_OK;	/* clock synchronization status	*/
 int time_status = STA_UNSYNC;		/* clock status bits		*/
+static long time_tai;			/* TAI offset (s)		*/
 static s64 time_offset;			/* time adjustment (ns)		*/
 static long time_constant = 2;		/* pll time constant		*/
 long time_maxerror = NTP_PHASE_LIMIT;	/* maximum error (us)		*/
@@ -162,6 +163,7 @@ void second_overflow(void)
 	case TIME_DEL:
 		if ((xtime.tv_sec + 1) % 86400 == 0) {
 			xtime.tv_sec++;
+			time_tai--;
 			wall_to_monotonic.tv_sec--;
 			time_state = TIME_WAIT;
 			printk(KERN_NOTICE "Clock: deleting leap second "
@@ -169,6 +171,7 @@ void second_overflow(void)
 		}
 		break;
 	case TIME_OOP:
+		time_tai++;
 		time_state = TIME_WAIT;
 		break;
 	case TIME_WAIT:
@@ -340,6 +343,9 @@ int do_adjtimex(struct timex *txc)
 			time_constant = max(time_constant, 0l);
 		}
 
+		if (txc->modes & ADJ_TAI && txc->constant > 0)
+			time_tai = txc->constant;
+
 		if (txc->modes & ADJ_OFFSET) {
 			if (txc->modes == ADJ_OFFSET_SINGLESHOT)
 				/* adjtime() is independent from ntp_adjtime() */
@@ -375,6 +381,7 @@ int do_adjtimex(struct timex *txc)
 	txc->precision	   = 1;
 	txc->tolerance	   = MAXFREQ_SCALED / PPM_SCALE;
 	txc->tick	   = tick_usec;
+	txc->tai	   = time_tai;
 
 	/* PPS is not implemented, so these are zero */
 	txc->ppsfreq	   = 0;

-- 

