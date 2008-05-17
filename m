Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYEQTj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYEQTj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbYEQTjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:39:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41830 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbYEQTju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:39:50 -0400
Date: Sat, 17 May 2008 21:39:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [GIT pull] x86 fixes for 2.6.26
Message-ID: <20080517193928.GA29722@elte.hu>
References: <alpine.LFD.1.10.0805161544080.3020@woody.linux-foundation.org> <alpine.LFD.1.10.0805170116490.3255@apollo.tec.linutronix.de> <alpine.LFD.1.10.0805161658450.3020@woody.linux-foundation.org> <20080516.172835.260358594.davem@davemloft.net> <alpine.LFD.1.10.0805161831380.3020@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805161831380.3020@woody.linux-foundation.org>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > If users, or even you, want to get a bug fix from Linus's tree or 
> > check if there will be merge conflicts, just create a test branch 
> > and play with such things there.
> 
> Yes. I think you guys already have a test branch for the "join it all 
> together" case, don't you?

yep, we have such a branch in -tip that is the integration of all 
currently stable topic branches, and which also embedds misc temporary 
convenience fixes that we pick up for ourselves anyway. It's basically 
the -rt model.

[ Our 'latest' branch is in essence a _daily_ stable release of the
  kernel - stable as far as our own testsystems go and as far as 
  contributor boxes go. (We dont "release" it without having at least 10 
  successful bootups of the tree and we immediate resolve regressions 
  one way or another.) ]

We've now solved the merge-commit pollution problem that you noticed (we 
still are git newbies ;-) and you shouldnt see unnecessary merge commits 
in the future anymore. Holler if you see anything else in -tip that 
looks non-Git-ish ...

We've solved it by still doing the merges (we _need_ the information 
about potential upcoming merge trouble), but we dont commit them to the 
topic branches - we throw them away. We only do a permanent, externally 
visible merge if we (after the fact) detect that a merge was non-trivial 
[because an upstream change interfered with the topic].

We had a couple of rather strong technical reasons to keep the topic 
branches merged on a daily basis:

- Spreading out maintenance and risks: people interested in a particular 
  topic can just pick up a topic branch and _usually_ it should just 
  work and should be fairly recent. We encourage contributors to advance 
  individual topics themselves and [now with the -tip tree] send pull 
  requests against trees with that specific topic branch modified, 
  instead of having to come back to our integration branches all the 
  time.

- Testing: we auto-test each topic branch in isolation - so keeping them
  uptodate against upstream is important.

- Automation of conflict resolution: with 30+ topics we cannot detect 
  interactions manually in a reliable way, we detect them automatically. 
  We deal with popular, high-flux areas of the kernel where we often get 
  "outside" interference and where we in fact _encourage_ outside 
  interference (even if we could ask for strict maintenance boundaries) 
  because we dont think strict maintenance boundaries are particularly 
  good for Linux. Other subsystem trees have it "easier" because they 
  have a strict hierarchy that controls essentially all changes to that 
  area of code. So they can do conflict resolution by basically doing 
  conflict _avoidance_. (The flip side is that conflict avoidance tends 
  to teach people to fight "outside" interference instead of learning 
  how to interact intelligently.)

- Lower cost of fixes, lower latency of conflict resolution: to detect
  conflicts and interaction between continuing work in each topic, and 
  with work that goes on upstream. It's much easier to resolve such 
  interactions on a clean, per topic basis than on a 'whole tree' basis. 
  The sooner we detect trouble, the faster we can act. Also, we can 
  often detect interaction right when it happens: when the other party 
  is still "active" in pursuing that other, interacting topic - this is 
  the time when fixes are the cheapest and where any change of plans is 
  the cheapest as well.

- Inability to predict future conflicts: we cannot predict the future, 
  so we dont know it _in advance_ when conflicts or interactions occur. 
  So we kept topics rolled forward on a daily basis. This spreads out
  our workload quite a bit, and also makes any trouble easier to 
  repair: a same-day bugreport or reverts are much easier for all 
  parties involved than a revert 1 or 2 weeks later, when everyone has 
  already forgotten the details of that change and is busy in another 
  topic.

- Stability: our experience is that after the merge window, the 
  stability of the upstream kernel increases near monotonically. By 
  keeping a topic branch merged daily, the practical stability of each 
  topic branch is 1-7 days better than if we merged to it weekly.

We've done tons of non-trivial conflict resolutions in the past ~5 years 
against a 'hostile' (well, indifferent) upstream tree. So we've learned 
how to do this rather efficiently in the long run [ while still staying 
sane and productive :) ], and one of the key things was to have a daily 
merge cycle.

The reason is that the best way to do conflict resolution IMO is either 
to do hard-core conflict avoidance, or to use our "finegrained roll 
forward" method: to have a topic merged cleanly to just before the point 
where the conflict happens, and then to resolve the conflict by also 
merging to just after the conflict. This means there's the least 
possible amount of unrelated flux to look at.

The reasons you cited for not having that many merge commits are of 
course all valid (graphical output and bisectability) - and they trump 
our concerns because they affect the 'end result' tree which might not 
care about our sub-tree and development concerns. (I wish we extended 
such thinking to make the tree even more bisectable than it is today - 
but that attacks the append-only nature of the tree.)

	Ingo
