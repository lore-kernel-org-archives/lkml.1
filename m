Return-Path: <linux-kernel-owner+w=401wt.eu-S1754482AbYDWJk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbYDWJk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 05:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751187AbYDWJkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:40:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39726 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbYDWJkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:40:20 -0400
Date: Wed, 23 Apr 2008 11:40:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Soft lockup regression from today's sched.git merge.
Message-ID: <20080423094007.GA23293@elte.hu>
References: <20080422.015931.70144614.davem@davemloft.net> <20080422091456.GC9939@elte.hu> <20080422.224212.32058127.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422.224212.32058127.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> The code is fatally flawed, once __sync_cpu_clock() calls start 
> happening, they will happen on every cpu_clock() call.
> 
> So like my bisect showed from the get-go, these cpu_clock() changes 
> have major problems, so it was quite a mind boggling stretch to stick 
> a touch_softlockup_watchdog() call somewhere to try and fix this when 
> the guilty change in question didn't touch that area at all.
> :-(
> 
> Furthermore, this is an extremely expensive way to ensure monotonic 
> per-rq timestamps.  A global spinlock taken every 100000 ns on every 
> cpu?!?!  :-/
> 
> At least move any implication of "high speed" from the comments above 
> cpu_clock() if we're going to need something like this.  I have 128 
> cpus, that's 128 grabs of that spinlock every quantum.  My next system 
> I'm getting will have 256 cpus.  The expense of your solution 
> increases linearly with the number of cpus, which doesn't scale.

we are glad about your feedback and we will fix any and all bugs in this 
code, as fast as we can. Let me also defend the code as there are two 
factors that you might not be aware of:

Firstly, cpu_clock() is only used in debug code, not in a fastpath. 
Using a global lock there was a conscious choice, it's been in -mm for 
two months and in linux-next as well for some time. I booted it on a 
64-way box with nohz enabled and it wasnt a visible problem in 
benchmarks.

The time_sync_thresh thing was indeed an afterthought and it was indeed 
buggy but harmless to functionality. (that's why it went unnoticed - 
until you found the thinko - thanks for that.) The patches i sent today 
should largely address that.

Secondly, and perhaps more importantly, the nohz code _already_ uses a 
very heavy lock in the idle path and always did that! It is exactly the 
kind of global lock you complain about above, just much worse: it's used 
in the fastpath.

Every time irq_enter() is done on an idle CPU we do:

|  static void tick_do_update_jiffies64(ktime_t now)
|  {
|          unsigned long ticks = 0;
|          ktime_t delta;
|
|          /* Reevalute with xtime_lock held */
|          write_seqlock(&xtime_lock);

... that xtime_lock is a heavy global seqlock - just as heavy as any 
global spinlock. That's the price we pay for global jiffies and shoddy 
drivers that rely on it.

This has been there in the fastpath unconditionally (not in debug code) 
and it was not reported as a problem before. The reason is that while 
this global lock truly sucks it spends time from an _idle_ CPU's time 
which mutes some of its overhead and makes it mostly "invisible" to any 
real performance measurement.

It's still not ideal because it slightly increases irq latency. So it 
would be nice to improve upon it but it's nothing new and it's not 
caused by these commits. Any ideas how to do it? I guess we could first 
check jiffies unlocked - this would mute much of the polling that goes 
on here. Something like the patch below. Hm?

	Ingo

------------------------->
Subject: nohz: reduce jiffies polling overhead
From: Ingo Molnar <mingo@elte.hu>
Date: Wed Apr 23 11:05:09 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -48,6 +48,13 @@ static void tick_do_update_jiffies64(kti
 	unsigned long ticks = 0;
 	ktime_t delta;
 
+	/*
+	 * Do a quick check without holding xtime_lock:
+	 */
+	delta = ktime_sub(now, last_jiffies_update);
+	if (delta.tv64 < tick_period.tv64)
+		return;
+
 	/* Reevalute with xtime_lock held */
 	write_seqlock(&xtime_lock);
 
