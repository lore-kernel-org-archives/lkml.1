Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYGPDHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYGPDHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 23:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYGPDHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 23:07:17 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58746 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814AbYGPDHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 23:07:15 -0400
Subject: [PATCH]  fix rounding problem during clock update
From: john stultz <johnstul@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 20:07:13 -0700
Message-Id: <1216177633.6294.46.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I had assumed this was picked up already, but apparently it somehow
got lost in the early 2.6.26 time-frame.

Anyway, I pinged Roman about it, but he hasn't responded, so I wanted to
send this on for inclusion into -mm (I've not had much time to test with
it, so it probably could use some wider testing) and then hopefully
2.6.27.

thanks
-john


From: Roman Zippel <zippel@linux-m68k.org>

Due to a rounding problem during a clock update it's possible for
readers to observe the clock jumping back by 1nsec. The following
simplified example demonstrates the problem:

cycle	xtime
0	0
1000	999999.6
2000	1999999.2
3000	2999998.8
...

1500 =	1499999.4
=	0.0 + 1499999.4
=	999999.6 + 499999.8

When reading the clock only the full nanosecond part is used, while
timekeeping internally keeps nanosecond fractions. If the clock is now
updated at cycle 1500 here, a nanosecond is missing due to the
truncation.
The simple fix is to round up the xtime value during the update, this
also changes the distance to the reference time, but the adjustment will
automatically take care that it stays under control.

Signed-off-by: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>

---
 kernel/time/timekeeping.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6-mm/kernel/time/timekeeping.c
===================================================================
--- linux-2.6-mm.orig/kernel/time/timekeeping.c
+++ linux-2.6-mm/kernel/time/timekeeping.c
@@ -484,7 +484,7 @@ void update_wall_time(void)
 #else
 	offset = clock->cycle_interval;
 #endif
-	clock->xtime_nsec += (s64)xtime.tv_nsec << clock->shift;
+	clock->xtime_nsec = (s64)xtime.tv_nsec << clock->shift;

 	/* normally this loop will run just once, however in the
 	 * case of lost or late ticks, it will accumulate correctly.
@@ -515,9 +515,12 @@ void update_wall_time(void)
 	/* correct the clock when NTP error is too big */
 	clocksource_adjust(offset);

-	/* store full nanoseconds into xtime */
-	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
+	/* store full nanoseconds into xtime after rounding it up and
+	 * add the remainder to the error difference.
+	 */
+	xtime.tv_nsec = ((s64)clock->xtime_nsec >> clock->shift) + 1;
 	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
+	clock->error += clock->xtime_nsec << (NTP_SCALE_SHIFT - clock->shift);

 	update_xtime_cache(cyc2ns(clock, offset));


-- 



