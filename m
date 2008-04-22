Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbYDVJPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbYDVJPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 05:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYDVJPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 05:15:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755483AbYDVJPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 05:15:21 -0400
Date: Tue, 22 Apr 2008 11:14:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Soft lockup regression from today's sched.git merge.
Message-ID: <20080422091456.GC9939@elte.hu>
References: <20080422.015931.70144614.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422.015931.70144614.davem@davemloft.net>
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

> The following commit:
> 
> commit 27ec4407790d075c325e1f4da0a19c56953cce23
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Thu Feb 28 21:00:21 2008 +0100
> 
>     sched: make cpu_clock() globally synchronous
>     
>     Alexey Zaytsev reported (and bisected) that the introduction of
>     cpu_clock() in printk made the timestamps jump back and forth.
>     
>     Make cpu_clock() more reliable while still keeping it fast when it's
>     called frequently.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> causes watchdog triggers when a cpu exits NOHZ state when it has been 
> there for >= the soft lockup threshold, for example here are some 
> messages from a 128 cpu Niagara2 box:
> 
> [  168.106406] BUG: soft lockup - CPU#11 stuck for 128s! [dd:3239]
> [  168.989592] BUG: soft lockup - CPU#21 stuck for 86s! [swapper:0]
> [  168.999587] BUG: soft lockup - CPU#29 stuck for 91s! [make:4511]
> [  168.999615] BUG: soft lockup - CPU#2 stuck for 85s! [swapper:0]
> [  169.020514] BUG: soft lockup - CPU#37 stuck for 91s! [swapper:0]
> [  169.020514] BUG: soft lockup - CPU#45 stuck for 91s! [sh:4515]
> [  169.020515] BUG: soft lockup - CPU#69 stuck for 92s! [swapper:0]
> [  169.020515] BUG: soft lockup - CPU#77 stuck for 92s! [swapper:0]
> [  169.020515] BUG: soft lockup - CPU#61 stuck for 92s! [swapper:0]
> [  169.112554] BUG: soft lockup - CPU#85 stuck for 92s! [swapper:0]
> [  169.112554] BUG: soft lockup - CPU#101 stuck for 92s! [swapper:0]
> [  169.112554] BUG: soft lockup - CPU#109 stuck for 92s! [swapper:0]
> [  169.112554] BUG: soft lockup - CPU#117 stuck for 92s! [swapper:0]
> [  169.171483] BUG: soft lockup - CPU#40 stuck for 80s! [dd:3239]
> [  169.331483] BUG: soft lockup - CPU#13 stuck for 86s! [swapper:0]
> [  169.351500] BUG: soft lockup - CPU#43 stuck for 101s! [dd:3239]
> [  169.531482] BUG: soft lockup - CPU#9 stuck for 129s! [mkdir:4565]
> [  169.595754] BUG: soft lockup - CPU#20 stuck for 93s! [swapper:0]
> [  169.626787] BUG: soft lockup - CPU#52 stuck for 93s! [swapper:0]
> [  169.626787] BUG: soft lockup - CPU#84 stuck for 92s! [swapper:0]
> [  169.636812] BUG: soft lockup - CPU#116 stuck for 94s! [swapper:0]
> 
> It's simple enough to trigger this by doing a 10 minute sleep after a 
> fresh bootup then starting a parallel kernel build.
> 
> I suspect this might be reintroducing a problem we've had and fixed 
> before, see the thread:
> 
> http://marc.info/?l=linux-kernel&m=119546414004065&w=2

yeah, it looks very similar.

> Please have a look, thank you.

thanks for reporting it. I havent seen this false positive happen in a 
long time - but then again, PC CPUs are a lot less idle than a 128-CPU 
Niagara2 :-/ I'm wondering what the best method would be to provoke a 
CPU to stay idle that long - to make sure this bug is fixed.

so i only have the untested patch below for now - does it fix the bug 
for you?

	Ingo

----------------------------------->
Subject: softlockup: fix NOHZ wakeup
From: Ingo Molnar <mingo@elte.hu>

David Miller reported:

|--------------->
the following commit:

| commit 27ec4407790d075c325e1f4da0a19c56953cce23
| Author: Ingo Molnar <mingo@elte.hu>
| Date:   Thu Feb 28 21:00:21 2008 +0100
|
|     sched: make cpu_clock() globally synchronous
|
|     Alexey Zaytsev reported (and bisected) that the introduction of
|     cpu_clock() in printk made the timestamps jump back and forth.
|
|     Make cpu_clock() more reliable while still keeping it fast when it's
|     called frequently.
|
|     Signed-off-by: Ingo Molnar <mingo@elte.hu>

causes watchdog triggers when a cpu exits NOHZ state when it has been
there for >= the soft lockup threshold, for example here are some
messages from a 128 cpu Niagara2 box:

[  168.106406] BUG: soft lockup - CPU#11 stuck for 128s! [dd:3239]
[  168.989592] BUG: soft lockup - CPU#21 stuck for 86s! [swapper:0]
[  168.999587] BUG: soft lockup - CPU#29 stuck for 91s! [make:4511]
[  168.999615] BUG: soft lockup - CPU#2 stuck for 85s! [swapper:0]
[  169.020514] BUG: soft lockup - CPU#37 stuck for 91s! [swapper:0]
[  169.020514] BUG: soft lockup - CPU#45 stuck for 91s! [sh:4515]
[  169.020515] BUG: soft lockup - CPU#69 stuck for 92s! [swapper:0]
[  169.020515] BUG: soft lockup - CPU#77 stuck for 92s! [swapper:0]
[  169.020515] BUG: soft lockup - CPU#61 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#85 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#101 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#109 stuck for 92s! [swapper:0]
[  169.112554] BUG: soft lockup - CPU#117 stuck for 92s! [swapper:0]
[  169.171483] BUG: soft lockup - CPU#40 stuck for 80s! [dd:3239]
[  169.331483] BUG: soft lockup - CPU#13 stuck for 86s! [swapper:0]
[  169.351500] BUG: soft lockup - CPU#43 stuck for 101s! [dd:3239]
[  169.531482] BUG: soft lockup - CPU#9 stuck for 129s! [mkdir:4565]
[  169.595754] BUG: soft lockup - CPU#20 stuck for 93s! [swapper:0]
[  169.626787] BUG: soft lockup - CPU#52 stuck for 93s! [swapper:0]
[  169.626787] BUG: soft lockup - CPU#84 stuck for 92s! [swapper:0]
[  169.636812] BUG: soft lockup - CPU#116 stuck for 94s! [swapper:0]

It's simple enough to trigger this by doing a 10 minute sleep after a
fresh bootup then starting a parallel kernel build.

I suspect this might be reintroducing a problem we've had and fixed
before, see the thread:

http://marc.info/?l=linux-kernel&m=119546414004065&w=2
<---------------|

touch the softlockup watchdog when exiting NOHZ state - we are
obviously not locked up.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/time/tick-sched.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c
+++ linux/kernel/time/tick-sched.c
@@ -393,6 +393,7 @@ void tick_nohz_restart_sched_tick(void)
 		sub_preempt_count(HARDIRQ_OFFSET);
 	}
 
+	touch_softlockup_watchdog();
 	/*
 	 * Cancel the scheduled timer and restore the tick
 	 */
