Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbXIBHUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbXIBHUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 03:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933115AbXIBHUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 03:20:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58598 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932920AbXIBHUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 03:20:43 -0400
Date: Sun, 2 Sep 2007 09:20:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
Message-ID: <20070902072029.GA24427@elte.hu>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <1188694367.11196.42.camel@dhcp193.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1188694367.11196.42.camel@dhcp193.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4422]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> The the patch is near the end of this email..  The most notable thing 
> about the rediff is the line count,
> 
>  4 files changed, 323 insertions(+), 729 deletions(-)
> 
> That's impressive (assuming my rediff is correct). [...]

Yeah, at first glance i liked that too, then i looked into the diff and 
noticed that a good chunk of the removal "win" comes from the removal of 
~35 comment blocks while adding new code that has no comments at all 
(!).

And if you look at the resulting code size/complexity, it actually 
increases with Roman's patch (UP, nodebug, x86):

     text    data     bss     dec     hex filename
    13420     228    1204   14852    3a04 sched.o.rc5
    13554     228    1228   15010    3aa2 sched.o.rc5-roman

Although it _should_ have been a net code size win, because if you look 
at the diff you'll see that other useful things were removed as well: 
sleeper fairness, CPU time distribution smarts, tunings, scheduler 
instrumentation code, etc.

> I also ran hackbench (in a haphazard way) a few times on it vs. CFS in 
> my tree, and RFS was faster to some degree (it varied)..

here are some actual numbers for "hackbench 50" on -rc5, 10 consecutive 
runs fresh after bootup, Core2Duo, UP:

           -rc5(cfs)           -rc5+rfs
          -------------------------------
          Time: 3.905         Time: 4.259
          Time: 3.962         Time: 4.190
          Time: 3.981         Time: 4.241
          Time: 3.986         Time: 3.937
          Time: 3.984         Time: 4.120
          Time: 4.001         Time: 4.013
          Time: 3.980         Time: 4.248
          Time: 3.983         Time: 3.961
          Time: 3.989         Time: 4.345
          Time: 3.981         Time: 4.294
          -------------------------------
           Avg: 3.975          Avg: 4.160 (+4.6%)
         Fluct: 0.138        Fluct: 1.671

so unmodified CFS is 4.6% faster on this box than with Roman's patch and 
it's also more consistent/stable (10 times lower fluctuations).

At lower hackbench levels (hackbench 10) the numbers are closer - that 
could be what you saw.

But, this measurement too is apples to oranges, given the amount of 
useful code the patch removes - fact is that you can always speed up the 
scheduler by removing stuff, just run hackbench as SCHED_FIFO (via "chrt 
-f 90 ./hackbench 50") to see what a minimal scheduler can do.

It would be far more reviewable and objectively judgeable on an item by 
item basis if Roman posted the finegrained patches i asked for. (which 
patch series should be sorted in order of intrusiveness - i.e. leaving 
the harder changes to the end of the series.)

	Ingo
