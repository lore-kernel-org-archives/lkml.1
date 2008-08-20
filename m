Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYHTC3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYHTC3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 22:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbYHTC3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 22:29:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36390 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbYHTC3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 22:29:09 -0400
Subject: [PATCH] fix adjtimex() freq return error
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Martin Ziegler <ziegler@uni-freiburg.de>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Aug 2008 19:29:06 -0700
Message-Id: <1219199346.6276.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Ziegler reported a bug in adjtimex(), where odd positive 
frequencies are reduced by 1 while negative values are correct.

See http://bugzilla.kernel.org/show_bug.cgi?id=11370 for details

The issue was introduced in the following commit that increased 
time_freq to a 64bit value and increased its resolution:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=074b3b87941c99bc0ce35385b5817924b1ed0c23;hp=eea83d896e318bda54be2d2770d2c5d6668d11db

The problem is how we convert from our internal high res value back to
userland. Instead of dividing, we shift, then mult, then shift again,
causing the slight error seen in the bug.

I don't think adjtimex() is a terribly hot path, so this patch simply
uses div_s64() to convert back to the external resolution and removes 
the unused shift defines to resolve the issue.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

Index: 2.6-git/kernel/time/ntp.c
===================================================================
--- 2.6-git.orig/kernel/time/ntp.c
+++ 2.6-git/kernel/time/ntp.c
@@ -402,9 +402,7 @@ int do_adjtimex(struct timex *txc)
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
-	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
-					 (s64)PPM_SCALE_INV,
-					 NTP_SCALE_SHIFT);
+	txc->freq	   = div_s64(time_freq, PPM_SCALE);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
Index: 2.6-git/include/linux/timex.h
===================================================================
--- 2.6-git.orig/include/linux/timex.h
+++ 2.6-git/include/linux/timex.h
@@ -82,9 +82,6 @@
  */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
 #define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
-#define PPM_SCALE_INV_SHIFT 20
-#define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
-		       PPM_SCALE + 1)
 
 #define MAXPHASE 500000000l	/* max phase error (ns) */
 #define MAXFREQ 500000		/* max frequency error (ns/s) */


