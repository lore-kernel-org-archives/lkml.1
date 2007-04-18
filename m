Return-Path: <linux-kernel-owner+w=401wt.eu-S964780AbXDRVF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbXDRVF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964784AbXDRVF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:05:28 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50446 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780AbXDRVF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:05:26 -0400
Date: Wed, 18 Apr 2007 23:04:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matt Mackall <mpm@selenic.com>, Nick Piggin <npiggin@suse.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418210449.GA24374@elte.hu>
References: <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070418152355.GU11115@waste.org> <alpine.LFD.0.98.0704181012470.2828@woody.linux-foundation.org> <20070418174945.GA7930@elte.hu> <20070418175936.GA11980@elte.hu> <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704181223190.2828@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > perhaps a more fitting term would be 'precise group-scheduling'. 
> > Within the lowest level task group entity (be that thread group or 
> > uid group, etc.) 'precise scheduling' is equivalent to 'fairness'.
> 
> Yes. Absolutely. Except I think that at least if you're going to name 
> somethign "complete" (or "perfect" or "precise"), you should also 
> admit that groups can be hierarchical.

yes. Am i correct to sum up your impression as:

 " Ingo, for you the hierarchy still appears to be an after-thought,
   while in practice it's easily the most important thing! Why are you
   so hung up about 'fairness', it makes no sense!"

right?

and you would definitely be right if you suggested that i neglected the 
'group scheduling' aspects of CFS (except for a minimalistic nice level 
implementation, which is a poor-man's-non-automatic-group-scheduling), 
but i very much know its important and i'll definitely fix it for -v4.

But please let me explain my reasons for my different focus:

yes, group scheduling in practice is the most important first-layer 
thing, and without it any of the other 'CFS wins' can easily be useless.

Firstly, i have not neglected the group scheduling related CFS 
regressions at all, mainly because there _is_ already a quick hack to 
check whether group scheduling would solve these regressions: renice. 
And it was tried in both of the two CFS regression cases i'm aware of: 
Mike's X starvation problem and Willy's "kevents starvation with 
thousands of scheddos tasks running" problem. And in both cases, 
applying the renice hack [which should be properly and automatically 
implemented as uid group scheduling] fixed the regression for them! So i 
was not worried at all, group scheduling _provably solves_ these CFS 
regressions. I rather concentrated on the CFS regressions that were much 
less clear.

But PLEASE believe me: even with perfect cross-group CPU allocation but 
with a simple non-heuristic scheduler underlying it, you can _easily_ 
get a sucky desktop experience! I know it because i tried it and others 
tried it too. (in fact the first version of sched_fair.c was tick based 
and low-res, and it sucked)

Two more things were needed:

  - the high precision of nsec/64-bit accounting
    ('reliability of scheduling')

  - extremely even time-distribution of CPU power 
    ('determinism/smoothness, human perception')

(i'm expanding on these two concepts further below)

take out any of these and group scheduling or not, you are easily going 
to have a sucky desktop! (We know that from years of experiments: many 
people tried to rip out the unfairness from the scheduler and there were 
always nasty corner cases that 'should' have worked but didnt.)

Without these we'd in essence start again at square one, just at a 
different square, this time with another group of people being 
irritated!

But the biggest and hardest to achieve _wins_ of CFS are _NOT_ achieved 
via a simple 'get rid of the unfairness of the upstream scheduler and 
apply group scheduling'. (I know that because i tried it before and 
because others tried it before, for many many years.) You will _easily_ 
get sucky desktop experience. The other two things are very much needed 
too:

 - the high precision of nsec/64-bit accounting, and the many
   corner-cases this solves. (For example on a typical desktop there are
   _lots_ of timing-driven workloads that are in essence 'invisible' to
   low-resolution, timer-tick based accounting and are heavily skewed.)

 - extremely even time-distribution of CPU power. CFS behaves pretty
   well even under the dreaded 'make -jN in an xterm' kernel build
   workload as reported by Mark Lord, because it also distributes CPU
   power in a _finegrained_ way. A shell prompt under CFS still behaves
   acceptably on a single-CPU testbox of mine with a "make -j50"
   workload. (yes, fifty) Humans react alot more negatively to sudden
   changes in application behavior ('lags', pauses, short hangs) than
   they react to fine, gradual, all-encompassing slowdowns. This is a
   key property of CFS.

  ( Otherwise renicing X to -10 would have solved most of the
    interactivity complaints against the vanilla scheduler, otherwise
    renicing X to -10 would have fixed Mike's setup under SD (it didnt)
    while it worked much better under CFS, otherwise Gene wouldnt have
    found CFS markedly better than SD, etc., etc. So getting rid of the
    heuristics is less than 50% of the road to the perfect desktop
    scheduler. )

and i claim that these were the really hard bits, and i spent most of 
the CFS coding only on getting _these_ details 100% right under various 
workloads, and it makes a night and day difference _even without any 
group scheduling help_.

and note another reason here: group scheduling _masks_ many other 
scheduling deficiencies that are possible in scheduler. So since CFS 
doesnt do group scheduling, i get a _fuller_ picture of the behavior of 
the core "precise scheduling" engine. At the initial stage i didnt want 
to hide bugs by masking them via group scheduling, especially because 
the renice workaround/hack was available.

Guess how nice it all will get if we also add group scheduling to the 
mix, and people wouldnt have to add nasty and fragile renice based 
hacks, it will 'just work' out of box?

	Ingo
