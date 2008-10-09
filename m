Return-Path: <linux-kernel-owner+w=401wt.eu-S1760472AbYJIRyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760472AbYJIRyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757167AbYJIRy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:54:26 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40137 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944AbYJIRyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:54:24 -0400
Subject: Re: [PATCH] sched_clock: prevent scd->clock from moving backwards
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20081009151703.GA8010@elte.hu>
References: <48D959E8.4000303@goop.org>
	 <1223470773.6336.13.camel@norville.austin.ibm.com>
	 <1223470854.6336.15.camel@norville.austin.ibm.com>
	 <1223507104.7382.6.camel@lappy.programming.kicks-ass.net>
	 <20081009090605.GA21798@elte.hu>  <20081009151703.GA8010@elte.hu>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 12:54:22 -0500
Message-Id: <1223574862.6407.16.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-09 at 17:17 +0200, Ingo Molnar wrote:

> hm, -tip testing found a sporadic hard lockup during bootup, and i've 
> bisected it back to this patch. They happened on 64-bit test-systems. 
> I've attached the .config that produced the problem.
> 
> i reverted the patch and the lockups went away. But i cannot see what's 
> wrong with it ...

I could have sworn I ran with the patch, but maybe I got my patch queue
messed up and never tested it right.

I think I see the problem.

--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -118,13 +118,13 @@ static u64 __update_sched_clock(struct
sched_clock_data *scd, u64 now)
 
        /*
         * scd->clock = clamp(scd->tick_gtod + delta,
-        *                    max(scd->tick_gtod, scd->clock),
-        *                    scd->tick_gtod + TICK_NSEC);
+        *                    max(scd->tick_gtod, scd->clock),
+        *                    min(scd->clock, scd->tick_gtod +
TICK_NSEC));
         */
 
        clock = scd->tick_gtod + delta;
        min_clock = wrap_max(scd->tick_gtod, scd->clock);
-       max_clock = scd->tick_gtod + TICK_NSEC;
+       max_clock = wrap_min(scd->clock, scd->tick_gtod + TICK_NSEC);
 
        clock = wrap_max(clock, min_clock);
        clock = wrap_min(clock, max_clock);

We want wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC), not
wrap_min().  The problem I am trying to fix is that scd->tick_gtod +
TICK_NSEC may be too low.  The upper bound needs to be at LEAST
scd->clock.  Limiting it to scd->clock all the time is disastrous.  :-)

I'll fix the patch and retest it before sending it again.

Sorry about my sloppiness.

Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

