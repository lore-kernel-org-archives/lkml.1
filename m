Return-Path: <linux-kernel-owner+w=401wt.eu-S1161704AbXDXHxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161704AbXDXHxs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161705AbXDXHxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:53:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42729 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161704AbXDXHxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:53:47 -0400
Date: Tue, 24 Apr 2007 09:53:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Gerdau <mgd@technosis.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v5 vs sd-0.46
Message-ID: <20070424075319.GA30909@elte.hu>
References: <200704240938.07482.mgd@technosis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704240938.07482.mgd@technosis.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Gerdau <mgd@technosis.de> wrote:

> I'm running three single threaded perl scripts that do double 
> precision floating point math with little i/o after initially loading 
> the data.

thanks for the testing!

> What I also don't understand is the difference in load average, sd 
> constantly had higher values, the above figures are representative for 
> the whole log. I don't know which is better though.

hm, it's hard from here to tell that. What load average does the vanilla 
kernel report? I'd take that as a reference.

> Here are excerpts from a concurrently run vmstat 3 200:
> 
> sd-0.46
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  5  0      0 1702928  63664 827876    0    0     0    67  458 1350 100  0  0  0
>  3  0      0 1702928  63684 827876    0    0     0    89  468 1362 100  0  0  0
>  5  0      0 1702680  63696 827876    0    0     0   132  461 1598 99  1  0  0
>  8  0      0 1702680  63712 827892    0    0     0    80  465 1180 99  1  0  0

> cfs-v5
> procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
>  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
>  6  0      0 2157728  31816 545236    0    0     0   103  543  748 100  0  0  0
>  4  0      0 2157780  31828 545256    0    0     0    63  435  752 100  0  0  0
>  4  0      0 2157928  31852 545256    0    0     0   105  424  770 100  0  0  0
>  4  0      0 2157928  31868 545268    0    0     0   261  457  763 100  0  0  0

interesting - CFS has half the context-switch rate of SD. That is 
probably because on your workload CFS defaults to longer 'timeslices' 
than SD. You can influence the 'timeslice length' under SD via 
/proc/sys/kernel/rr_interval (milliseconds units) and under CFS via 
/proc/sys/kernel/sched_granularity_ns. On CFS the value is not 
necessarily the timeslice length you will observe - for example in your 
workload above the granularity is set to 5 msec, but your rescheduling 
rate is 13 msecs. SD default to a rr_interval value of 8 msecs, which in 
your workload produces a timeslice length of 6-7 msecs.

so to be totally 'fair' and get the same rescheduling 'granularity' you 
should probably lower CFS's sched_granularity_ns to 2 msecs.

> Last not least I'd like to add that at least on my system having X 
> niced to -19 does result in kind of "erratic" (for lack of a better 
> word) desktop behavior. I'll will reevaluate this with -v6 but for now 
> IMO nicing X to -19 is a regression at least on my machine despite the 
> claim that cfs doesn't suffer from it.

indeed with -19 the rescheduling limit is so high under CFS that it does 
not throttle X's scheduling rate enough and so it will make CFS behave 
as badly as other schedulers.

I retested this with -10 and it should work better with that. In -v6 i 
changed the default to -10 too.

> PS: Only learning how to test these things I'm happy to get pointed 
> out the shortcomings of what I tested above. Of course suggestions for 
> improvements are welcome.

your report was perfectly fine and useful. "no visible regressions" is 
valuable feedback too. [ In fact, such type of feedback is the one i 
find the easiest to resolve ;-) ]

Since you are running number-crunchers you might be able to give 
performacne feedback too: do you have any reliable 'performance metric' 
available for your number cruncher jobs (ops per minute, runtime, etc.) 
so that it would be possible to compare number-crunching performance of 
mainline to SD and to CFS as well? If that value is easy to get and 
reliable/stable enough to be meaningful. (And it would be nice to also 
establish some ballpark figure about how much noise there is in any 
performance metric, so that we can see whether any differences between 
schedulers are systematic or not.)

	Ingo
