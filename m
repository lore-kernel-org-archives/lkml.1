Return-Path: <linux-kernel-owner+w=401wt.eu-S937454AbXHIKxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937454AbXHIKxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 06:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXHIKxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 06:53:11 -0400
Received: from ozlabs.org ([203.10.76.45]:45732 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbXHIKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 06:53:10 -0400
Subject: [PATCH] Fix non-TSC guest clocksource lockup
From: Rusty Russell <rusty@rustcorp.com.au>
To: lguest <lguest@ozlabs.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, tglx <tglx@linutronix.de>,
       ron minnich <rminnich@gmail.com>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 20:52:35 +1000
Message-Id: <1186656755.17752.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

lguest uses a host-supplied wallclock-based clocksource when the TSC
is not reliable.  As this is already in nanoseconds, I naively used a
multiplier of 1 and a shift of 0.

But update_wall_time() in its infinite wisdom decides to adjust the
clock a little (where does it think it's getting a more accurate time
from?)

It will happily tweak the multiplier... to 0, then -1.

So the "fix" is to use a shift of 22 like everyone else, and a
multiplier of 1 << 22.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r e715c5d0ca6d drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c	Thu Aug 09 15:08:26 2007 +1000
+++ b/drivers/lguest/lguest.c	Thu Aug 09 20:42:46 2007 +1000
@@ -691,7 +691,8 @@ static struct clocksource lguest_clock =
 	.rating		= 400,
 	.read		= lguest_clock_read,
 	.mask		= CLOCKSOURCE_MASK(64),
-	.mult		= 1,
+	.mult		= 1 << 22,
+	.shift		= 22,
 };
 
 /* The "scheduler clock" is just our real clock, adjusted to start at zero */
@@ -774,7 +775,6 @@ static void lguest_time_init(void)
 	 * way, the "rating" is initialized so high that it's always chosen
 	 * over any other clocksource. */
 	if (lguest_data.tsc_khz) {
-		lguest_clock.shift = 22;
 		lguest_clock.mult = clocksource_khz2mult(lguest_data.tsc_khz,
 							 lguest_clock.shift);
 		lguest_clock.flags = CLOCK_SOURCE_IS_CONTINUOUS;


