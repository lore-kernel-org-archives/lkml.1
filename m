Return-Path: <linux-kernel-owner+w=401wt.eu-S1757593AbYHOM6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593AbYHOM6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYHOM6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:58:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36545 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbYHOM6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:58:36 -0400
Date: Fri, 15 Aug 2008 14:58:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [git pull] core fixes
Message-ID: <20080815125818.GA30597@elte.hu>
References: <20080811222026.GA20579@elte.hu> <200808121613.24846.nickpiggin@yahoo.com.au> <200808121805.14009.nickpiggin@yahoo.com.au> <200808141445.03936.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808141445.03936.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Tuesday 12 August 2008 18:05, Nick Piggin wrote:
> > On Tuesday 12 August 2008 16:13, Nick Piggin wrote:
> > > On Tuesday 12 August 2008 08:20, Ingo Molnar wrote:
> > > > Nick Piggin (1):
> > > >       generic-ipi: fix stack and rcu interaction bug in
> > > > smp_call_function_mask()
> > >
> > > I'm still not 100% sure that I have this patch right... I might have seen
> > > a lockup trace implicating the smp call function path... which may have
> > > been due to some other problem or a different bug in the new call
> > > function code, but if some more people can take a look at it before
> > > merging?
> >
> > OK indeed it did have a couple of bugs. Firstly, I wasn't freeing the
> > data properly in the alloc && wait case. Secondly, I wasn't resetting
> > CSD_FLAG_WAIT in the for each cpu loop (so only the first CPU would
> > wait).
> >
> > After those fixes, the patch boots and runs with the kmalloc commented
> > out (so it always executes the slowpath).
> 
> Hmm, thanks for merging this Ingo, but it didn't get upstream very 
> nicely (first was merged the one totally broken patch I didn't even 
> really test let alone propose for inclusion!). Then some window of 
> other patches, then the incremental patch to fix it.
> 
> I know it probably is easiest for your "vacuum the mailing list" mode 
> of workflow. And it's not that I don't appreciate it, but what I care 
> about most is the end result and that is suboptimal in this case.
> 
> The argument that we lose the "thought process" of coming up with a 
> correct patch I don't really buy into either. We want to document the 
> thought process of well thought out, well reviewed and tested patches 
> -- if they get merged and subsequently found to be broken, it is 
> really nice to be able to look back at how and why they went wrong[*].

generally i agree and replace patches - but in this case i went for the 
delta because -rc3 was imminent and the previous patch was already 
well-tested with practical workloads, even though broken in the 
slowpath. Also, in terms of judging risks, it was easier to look at the 
delta between the two commits and say "that obviously cannot make it 
worse than the current code". But it's all a special-case really.

> But merging bits and pieces of such raw patches IMO just adds too much 
> noise to the tree, and breaks bisection too easily. In the case of my 
> patch, the kernel will still build and mostly run, but that is 
> actually even a worse way to break the biesection if you are hunting 
> for some obscure and hard to reproduce bug.

Note that the two commits were kept together tightly so the chance of 
bisection going in the middle of it _and_ hitting the obscure slowpath 
is reasonably small. What is wrong is to keep them apart (say merge a 
full upstream release between them) and break bisection on a wide basis.

Btw., we could add "dont bisect into this other commit" markers to later 
commits. Bisection is a relatively slow operation anyway, so checking a 
graph of bisection markers would be within its reach without causing any 
practical slowdown of bisection. (I think.)

> [*] BTW. it would be nice to have some formal regression: and/or link: 
> tags in git patches which I think would help that kind of analysis and 
> also help distros to pick up fixes...

yeah. Perhaps also some tags to note their lkml thread identity.

	Ingo
