Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYELO7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYELO7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbYELO7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:59:33 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61232 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752255AbYELO7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:59:33 -0400
Date: Mon, 12 May 2008 15:58:52 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NTP: Fix calculation of the next jiffie to trigger RTC sync
Message-ID: <Pine.LNX.4.55.0805121528470.535@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 We have a bug in the calculation of the next jiffie to trigger the RTC 
synchronisation.  The aim here is to run sync_cmos_clock() as close as 
possible to the middle of a second.  Which means we want this function to 
be called less than or equal to half a jiffie away from when now.tv_nsec 
equals 5e8 (500000000).

 If this is not the case for a given call to the function, for this
purpose instead of updating the RTC we calculate the offset in nanoseconds
to the next point in time where now.tv_nsec will be equal 5e8.  The
calculated offset is then converted to jiffies as these are the unit used
by the timer.

 Hovewer timespec_to_jiffies() used here uses a ceil()-type rounding mode,
where the resulting value is rounded up.  As a result the range of
now.tv_nsec when the timer will trigger is from 5e8 to 5e8 + TICK_NSEC
rather than the desired 5e8 - TICK_NSEC / 2 to 5e8 + TICK_NSEC / 2.

 As a result if for example sync_cmos_clock() happens to be called at the
time when now.tv_nsec is between 5e8 + TICK_NSEC / 2 and 5e8 to 5e8 +
TICK_NSEC, it will simply be rescheduled HZ jiffies later, falling in the
same range of now.tv_nsec again.  Similarly for cases offsetted by an 
integer multiple of TICK_NSEC.

 This change addresses the problem by subtracting TICK_NSEC / 2 from the
nanosecond offset to the next point in time where now.tv_nsec will be
equal 5e8, effectively shifting the following rounding in
timespec_to_jiffies() so that it produces a rounded-to-nearest result.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested successfully at the run time with a MIPS64 system (Broadcom
SWARM), removing frequent desparate indefinite failed attempts to update
the RTC.  Please apply.

  Maciej

patch-2.6.26-rc1-20080505-ntp-sync-timer-round-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c linux-2.6.26-rc1-20080505/kernel/time/ntp.c
--- linux-2.6.26-rc1-20080505.macro/kernel/time/ntp.c	2008-05-05 02:56:03.000000000 +0000
+++ linux-2.6.26-rc1-20080505/kernel/time/ntp.c	2008-05-12 05:02:41.000000000 +0000
@@ -245,7 +245,7 @@ static void sync_cmos_clock(unsigned lon
 	if (abs(now.tv_nsec - (NSEC_PER_SEC / 2)) <= tick_nsec / 2)
 		fail = update_persistent_clock(now);
 
-	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec;
+	next.tv_nsec = (NSEC_PER_SEC / 2) - now.tv_nsec - (TICK_NSEC / 2);
 	if (next.tv_nsec <= 0)
 		next.tv_nsec += NSEC_PER_SEC;
 
