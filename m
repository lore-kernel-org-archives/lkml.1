Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYHUDNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYHUDNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 23:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752686AbYHUDM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 23:12:57 -0400
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3039 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYHUDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 23:12:56 -0400
Date: Thu, 21 Aug 2008 05:07:05 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: john stultz <johnstul@us.ibm.com>,
       Martin Ziegler <ziegler@uni-freiburg.de>,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] fix adjtimex() freq return error
In-Reply-To: <20080819204752.d9540f15.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0808210503100.2507@localhost.localdomain>
References: <1219199346.6276.5.camel@localhost> <20080819204752.d9540f15.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 19 Aug 2008, Andrew Morton wrote:

> This fix caused Roman's
> ntp-fix-adj_offset_ss_read-bug-and-do_adjtimex-cleanup.patch (which I
> have queued for when Thomas wakes up) to toss a reject, but fixing that
> seemed pretty simple.  I think.  The scripts/kconfig/conf segfaults are
> being a bit of a PITA at present.

Below is a better patch on top of the above patch, note that this not a 
bug fix and thus not an issue for stable.

bye, Roman


[PATCH] improve adjtimex frequency rounding

Change PPM_SCALE_INV_SHIFT so that it doesn't throw away any input bits
(19 is the amount of the factor 2 in PPM_SCALE), the output frequency
can then be calculated back to its input value, as the inverse divide
produce a slightly larger value, which is then correctly rounded by the
final shift.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>

---
 include/linux/timex.h |    2 +-
 kernel/time/ntp.c     |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6-mm/include/linux/timex.h
===================================================================
--- linux-2.6-mm.orig/include/linux/timex.h
+++ linux-2.6-mm/include/linux/timex.h
@@ -82,7 +82,7 @@
  */
 #define SHIFT_USEC 16		/* frequency offset scale (shift) */
 #define PPM_SCALE (NSEC_PER_USEC << (NTP_SCALE_SHIFT - SHIFT_USEC))
-#define PPM_SCALE_INV_SHIFT 20
+#define PPM_SCALE_INV_SHIFT 19
 #define PPM_SCALE_INV ((1ll << (PPM_SCALE_INV_SHIFT + NTP_SCALE_SHIFT)) / \
 		       PPM_SCALE + 1)
 
Index: linux-2.6-mm/kernel/time/ntp.c
===================================================================
--- linux-2.6-mm.orig/kernel/time/ntp.c
+++ linux-2.6-mm/kernel/time/ntp.c
@@ -402,9 +402,8 @@ int do_adjtimex(struct timex *txc)
 		if (!(time_status & STA_NANO))
 			txc->offset /= NSEC_PER_USEC;
 	}
-	txc->freq	   = shift_right((s32)(time_freq >> PPM_SCALE_INV_SHIFT) *
-					 (s64)PPM_SCALE_INV,
-					 NTP_SCALE_SHIFT);
+	txc->freq	   = shift_right((time_freq >> PPM_SCALE_INV_SHIFT) *
+					 (s64)PPM_SCALE_INV, NTP_SCALE_SHIFT);
 	txc->maxerror	   = time_maxerror;
 	txc->esterror	   = time_esterror;
 	txc->status	   = time_status;
