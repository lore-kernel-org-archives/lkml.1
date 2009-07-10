Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZGJQL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZGJQL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbZGJQLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:11:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33253 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZGJQLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:11:48 -0400
Date: Fri, 10 Jul 2009 18:11:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] sched: Drop the need_resched() loop from
	cond_resched()
Message-ID: <20090710161141.GC22049@elte.hu>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com> <200907101717.39460.arnd@arndb.de> <20090710152425.GB5318@nowhere> <200907101735.29463.arnd@arndb.de> <20090710155037.GC5318@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710155037.GC5318@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Fri, Jul 10, 2009 at 05:35:29PM +0200, Arnd Bergmann wrote:
> > On Friday 10 July 2009, Frederic Weisbecker wrote:
> > > On Fri, Jul 10, 2009 at 05:17:38PM +0200, Arnd Bergmann wrote:
> > > > On Friday 10 July 2009, Frederic Weisbecker wrote:
> > > > > --- a/kernel/sched.c
> > > > > +++ b/kernel/sched.c
> > > > > @@ -6613,11 +6613,9 @@ static void __cond_resched(void)
> > > > >          * PREEMPT_ACTIVE, which could trigger a second
> > > > >          * cond_resched() call.
> > > > >          */
> > > > > -       do {
> > > > > -               add_preempt_count(PREEMPT_ACTIVE);
> > > > > -               schedule();
> > > > > -               sub_preempt_count(PREEMPT_ACTIVE);
> > > > > -       } while (need_resched());
> > > > > +       add_preempt_count(PREEMPT_ACTIVE);
> > > > > +       schedule();
> > > > > +       sub_preempt_count(PREEMPT_ACTIVE);
> > > > >  }
> > > > >  
> > > > 
> > > > If you drop the loop, then you should also remove the comment that
> > > > explains why it was put there.
> > > > 
> > > 
> > > Hmm, these comments seem to actually explain why we do the PREEMPT_ACTIVE
> > > trick, which is to prevent from cond_resched() recursion, right?
> > > 
> > 
> > I think we both misinterpreted the comment, which seemed to refer
> > to older code added by Ingo in 5bbcfd900 "cond_resched(): fix bogus
> > might_sleep() warning" and removed by Andrew in e7b384043e2
> > "cond_resched() fix".
> > 
> > The original code in Ingos version looked like
> > 
> >  static inline void __cond_resched(void)
> >  {
> >        /*
> >         * The BKS might be reacquired before we have dropped
> >         * PREEMPT_ACTIVE, which could trigger a second
> >         * cond_resched() call.
> >         */
> >        if (unlikely(preempt_count()))
> >                return;
> >        do {
> >                add_preempt_count(PREEMPT_ACTIVE);
> >                schedule();
> > 	...
> > 
> > 
> > So, it's got nothing to do with the loop, but should still be removed
> > because the 'if (unlikely(preempt_count()))' is no longer there.
> 
> 
> Yeah, but the comment still fits the code after this patch, don't 
> you think? :-)

... except that there's no Big Kernel Semaphore anymore ;-)

	Ingo
