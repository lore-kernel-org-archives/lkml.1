Return-Path: <linux-kernel-owner+w=401wt.eu-S935717AbYBAHtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935717AbYBAHtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934373AbYBAHla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:41:30 -0500
Received: from rex.snapgear.com ([203.143.235.140]:45228 "EHLO snapgear.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935352AbYBAHl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:41:28 -0500
Date: Fri, 1 Feb 2008 17:40:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-Id: <200802010740.m117edPr022792@goober>
To: torvalds@linux-foundation.org
Subject: [M68KNOMMU 05/07]: remove local gettimeofday code 
Cc: gerg@uclinux.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused local gettimeofday functions, now that we are using
GENERIC_TIME.

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
---


diff -Naurp linux-2.6.24/arch/m68knommu/kernel/time.c linux-2.6.24-uc0/arch/m68knommu/kernel/time.c
--- linux-2.6.24/arch/m68knommu/kernel/time.c	2008-01-25 08:58:37.000000000 +1000
+++ linux-2.6.24-uc0/arch/m68knommu/kernel/time.c	2008-01-15 16:33:28.000000000 +1000
@@ -112,60 +112,3 @@ void time_init(void)
 	hw_timer_init();
 }
 
-/*
- * This version of gettimeofday has near microsecond resolution.
- */
-void do_gettimeofday(struct timeval *tv)
-{
-	unsigned long flags;
-	unsigned long seq;
-	unsigned long usec, sec;
-
-	do {
-		seq = read_seqbegin_irqsave(&xtime_lock, flags);
-		usec = hw_timer_offset();
-		sec = xtime.tv_sec;
-		usec += (xtime.tv_nsec / 1000);
-	} while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
-
-	while (usec >= 1000000) {
-		usec -= 1000000;
-		sec++;
-	}
-
-	tv->tv_sec = sec;
-	tv->tv_usec = usec;
-}
-
-EXPORT_SYMBOL(do_gettimeofday);
-
-int do_settimeofday(struct timespec *tv)
-{
-	time_t wtm_sec, sec = tv->tv_sec;
-	long wtm_nsec, nsec = tv->tv_nsec;
-
-	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
-		return -EINVAL;
-
-	write_seqlock_irq(&xtime_lock);
-	/*
-	 * This is revolting. We need to set the xtime.tv_usec
-	 * correctly. However, the value in this location is
-	 * is value at the last tick.
-	 * Discover what correction gettimeofday
-	 * would have done, and then undo it!
-	 */
-	nsec -= (hw_timer_offset() * 1000);
-
-	wtm_sec  = wall_to_monotonic.tv_sec + (xtime.tv_sec - sec);
-	wtm_nsec = wall_to_monotonic.tv_nsec + (xtime.tv_nsec - nsec);
-
-	set_normalized_timespec(&xtime, sec, nsec);
-	set_normalized_timespec(&wall_to_monotonic, wtm_sec, wtm_nsec);
-
-	ntp_clear();
-	write_sequnlock_irq(&xtime_lock);
-	clock_was_set();
-	return 0;
-}
-EXPORT_SYMBOL(do_settimeofday);
