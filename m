Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZDNW1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZDNW1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 18:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZDNW1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 18:27:11 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57896 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbZDNW1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 18:27:10 -0400
Subject: [PATCH] Avoid possible endless loop when using jiffies clocksource
 and ONESHOT mode clockevent
From: john stultz <johnstul@us.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200903230111.08814.elendil@planet.nl>
References: <200903080230.10099.elendil@planet.nl>
	 <200903181307.44867.elendil@planet.nl>
	 <1237391338.32698.9.camel@jstultz-laptop>
	 <200903230111.08814.elendil@planet.nl>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 15:27:07 -0700
Message-Id: <1239748027.6064.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Thomas,

I think this might have flown past your radar, so I'm resending. Not
super critical, but probably a good thing to have, so its fine for
2.6.31.

Here's the fix to the tick_handle_periodic() tripping into an infinite
loop. This was originally seen on s390 emulator. Again, this was only
triggered because the divide error that caused jiffies to be skewed
enough that the clock-steering code increased the ns per jiffy
conversion value enough that any slack we had in the loop before was
lost.

Fixing the divide issue (already upstream) avoids the problem, but the
underlying issue that we allow ONESHOT clockevent mode to be used while
the jiffies clocksource is in use is still a concern.

Thomas had pointed out that ppc and other arches that do not have
PERIODIC mode clockevents don't trip over this, but I believe this has
been just luck so far, as we do not enable clocksource switching till
bootup is almost finished (to avoid clocksource churn), so after
interrupts are enabled, but before clocksource switching is allowed,
there is a chance (albeit very very small) that clock steering could
cause a similar problem on other arches.

Thomas, what do you think about this?  With the s390 emulator that
originally tripped over this issue, this patch makes it runs fine even
without the do_div() fix.

thanks
-john



The following patch avoids and endless loop issue by requiring that a
highres valid clocksource be installed before we call tick_periodic() in
a loop when using ONESHOT mode. The result is we will only increment
jiffies once per interrupt until a continuous hardware clocksource is
available.

Without this, we can run into a endless loop, where each cycle through
the loop, jiffies is updated which increments time by tick_period or
more (due to clock steering), which can cause the event programming to
think the next event was before the newly incremented time and fail
causing tick_periodic() to be called again and the whole process loops
forever.

Signed-off-by: John Stultz <johnstul@us.ibm.com>

diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 21a5ca8..83c4417 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -93,7 +93,17 @@ void tick_handle_periodic(struct clock_event_device *dev)
 	for (;;) {
 		if (!clockevents_program_event(dev, next, ktime_get()))
 			return;
-		tick_periodic(cpu);
+		/*
+		 * Have to be careful here. If we're in oneshot mode,
+		 * before we call tick_periodic() in a loop, we need
+		 * to be sure we're using a real hardware clocksource.
+		 * Otherwise we could get trapped in an infinite
+		 * loop, as the tick_periodic() increments jiffies,
+		 * when then will increment time, posibly causing
+		 * the loop to trigger again and again.
+		 */
+		if (timekeeping_valid_for_hres())
+			tick_periodic(cpu);
 		next = ktime_add(next, tick_period);
 	}
 }





