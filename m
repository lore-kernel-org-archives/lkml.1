Return-Path: <linux-kernel-owner+w=401wt.eu-S1763231AbZAOL0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763231AbZAOL0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 06:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbZAOL0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 06:26:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46046 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752295AbZAOL0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 06:26:45 -0500
Date: Thu, 15 Jan 2009 12:26:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Michal Hocko <mhocko@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
Message-ID: <20090115112640.GF22850@elte.hu>
References: <20090113122455.GA24824@dhcp35.suse.cz> <200901151754.58311.nickpiggin@yahoo.com.au> <20090115100013.GE5833@elte.hu> <200901152153.42159.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901152153.42159.nickpiggin@yahoo.com.au>
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

> On Thursday 15 January 2009 21:00:13 Ingo Molnar wrote:
> > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > On Tuesday 13 January 2009 23:34:25 Ingo Molnar wrote:
> > > > * Michal Hocko <mhocko@suse.cz> wrote:
> > > > > Hi,
> > > > > I am not sure whether someone has already reported this, but
> > > > > I can see the following early boot WARNING with the 2.6.29-rc1 kernel
> > > > > in the serial console output:
> > > > >
> > > > > ------------[ cut here ]------------
> > > > > WARNING: at kernel/sched.c:4440 sub_preempt_count+0x81/0x95()
> > > >
> > > > That one should be fixed in tip/master and it is in the to-Linus queue
> > > > of fixes:
> > > >
> > > >   http://people.redhat.com/mingo/tip.git/README
> > > >
> > > > it's this commit:
> > > >
> > > >   01e3eb8: Revert "sched: improve preempt debugging"
> > > >
> > > > if you want to cherry-pick the fix.
> > >
> > > OK, but I still don't think this is the actual problem, but there is
> > > something amiss in the init code being exposed by it.
> >
> > the warnings triggered after a softirq, and there's already preempt-leak
> > checks in the softirq code - so we can exclude that.
> >
> > a hardirq might have leaked a preempt count - but that would have quite
> > bad effects [with quick atomic check asserts in schedule()], wouldnt it?
> > So i tend to think that this is a false positive.
> >
> > One problem i can think of (and which i outlined in the revert commit log)
> > is that if a hardirq hits this window in lock_kernel():
> >
> > void __lockfunc lock_kernel(void)
> > {
> >         int depth = current->lock_depth+1;
> >                                            <-------------- HERE
> 
> current->lock_depth is not yet modified at this point.
> 
> >         if (likely(!depth))
> >                 __lock_kernel();
> 
> And here we increment preempt_count when taking the BKL, but we
> has not yet modified current->lock_depth, so preempt debugging
> will proceed with no impact of my patch at this point, regardless
> of what interrupts are taken.
> 
> So there is a race window, but it is to err on the safe side and
> not trigger a false report.
> 
> >         current->lock_depth = depth;
> > }
> 
> At this point, the BKL addition to preempt_count will be taken into
> account in underflow checking of subsequent preempt counters.

indeed, and the unlock path looks good too.

> > then we have kernel_locked() already true (it checks lock_depth), but 
> > the preempt count is not elevated yet via __lock_kernel(). So if we 
> > return from the hardirq [and run into softirqs that end with a 
> > preempt_enable() - a pure hardirq exit has no preempt debug check] 
> > we'll incorrectly think that there's a preempt leak going on.
> 
> I don't think so. And anyway BKL is taken very early in boot and not 
> released for a long time, so I don't think it is possible for these 
> kinds of races to trigger here anyway.
> 
> So I really think it still is a bug or some other misunderstanding we 
> have. I'd prefer to try to fix it or at least discover why it is 
> happening.

yes - but the thing was reported a month ago, it went then upstream and 
re-reported and re-bisected - so time ran out to debug it and we reverted 
it. We can re-apply it if you have a good theory about what happened.

	Ingo
