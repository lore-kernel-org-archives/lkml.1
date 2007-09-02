Return-Path: <linux-kernel-owner+w=401wt.eu-S933407AbXIBKAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbXIBKAI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 06:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755734AbXIBJ74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 05:59:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57324 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731AbXIBJ7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 05:59:55 -0400
Date: Sun, 2 Sep 2007 11:59:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satyam Sharma <satyam@infradead.org>
Cc: Daniel Walker <dwalker@mvista.com>, Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
Message-ID: <20070902095940.GA26138@elte.hu>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <1188694367.11196.42.camel@dhcp193.mvista.com> <20070902072029.GA24427@elte.hu> <alpine.LFD.0.999.0709021349290.22654@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709021349290.22654@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.0.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2871]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Satyam Sharma <satyam@infradead.org> wrote:

> On Sun, 2 Sep 2007, Ingo Molnar wrote:
> > 
> > Although it _should_ have been a net code size win, because if you 
> > look at the diff you'll see that other useful things were removed as 
> > well: sleeper fairness, CPU time distribution smarts, tunings, 
> > scheduler instrumentation code, etc.
> 
> To be fair to Roman, he probably started development off an earlier 
> CFS, most probably 2.6.23-rc3-git1, if I guess correctly from his 
> original posting. So it's likely he missed out on some of the 
> tunings/comments(?) etc code that got merged after that.

actually, here are the rc3->rc5 changes to CFS:

 sched.c       |   89 ++++++++++++++++++++++++------------
 sched_debug.c |    3 -
 sched_fair.c  |  142 +++++++++++++++++++++++++++++++++++++++++++++-------------
 sched_rt.c    |   11 +++-
 4 files changed, 182 insertions(+), 63 deletions(-)

so since -rc3 CFS's size _increased_ (a bit).

and i just checked, the sched.o codesize still increases even when 
comparing rc4 against rc4+patch (his original patch) and there are no 
comments added by Roman's patch at all. (all the comments in 
sched_norm.c were inherited from sched_fair.c and none of the new code 
comes with comments - this can be seen in Daniel's rediffed patch.)

(and it's still not apples to oranges, for the reasons i outlined - so 
this whole comparison is unfair to CFS on several levels.)

also, note that CFS's modularity probably enabled Roman to do a fairly 
stable kernel/sched_norm.c (as most of the post-rc3 CFS changes were not 
to sched.c but to sched_fair.c) with easy porting. So with the CFS 
modular framework you can easily whip up and prototype a new scheduler 
and name it whatever you like. [ i expect the RCFS (Really Completely 
Fair Scheduler) patches to be posted to lkml any minute ;-) ]

> > It would be far more reviewable and objectively judgeable on an item 
> > by item basis if Roman posted the finegrained patches i asked for. 
> > (which patch series should be sorted in order of intrusiveness - 
> > i.e. leaving the harder changes to the end of the series.)
>
> Absolutely. And if there indeed are net improvements (be it for corner 
> cases) over latest CFS-rc5, while maintaining performance for the 
> common cases at the same time, well, that can only be a good thing.

yeah - and as i said to Roman, i like for example the use of a 
ready-queue instead of a run-queue. (but these are independent of the 
math changes, obviously.)

I also think that the core math changes should be split from the 
Breshenham optimizations. I.e. the Breshenham _fract code should be done 
as a "this improves performance and improves rounding, without changing 
behavior" add-on ontop of a fairly simple core math change. I think 
Roman will easily be able to do this with a few hours of effort which 
should present much reduced .text overhead in his next version of the 
patch, to demonstrate the simplicity of his implementation of the CFS 
fairness math - this really isnt hard to do.

	Ingo

