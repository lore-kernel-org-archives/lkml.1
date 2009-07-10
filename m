Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbZGJQKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbZGJQKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 12:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbZGJQKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 12:10:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35540 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZGJQKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 12:10:40 -0400
Date: Fri, 10 Jul 2009 18:10:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: Move the sleeping while atomic checks early
	in cond_resched()
Message-ID: <20090710161034.GB22049@elte.hu>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com> <1247237391-5352-2-git-send-email-fweisbec@gmail.com> <1247237995.7529.43.camel@twins> <20090710150827.GA5318@nowhere> <1247238728.7529.46.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247238728.7529.46.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-07-10 at 17:08 +0200, Frederic Weisbecker wrote:
> > On Fri, Jul 10, 2009 at 04:59:55PM +0200, Peter Zijlstra wrote:
> > > On Fri, 2009-07-10 at 16:49 +0200, Frederic Weisbecker wrote:
> > > 
> > > > index 0cb0d8d..e357dc7 100644
> > > > --- a/include/linux/sched.h
> > > > +++ b/include/linux/sched.h
> > > > @@ -2279,11 +2279,13 @@ extern int _cond_resched(void);
> > > >  #ifdef CONFIG_PREEMPT_BKL
> > > >  static inline int cond_resched(void)
> > > >  {
> > > > +	might_sleep();
> > > >  	return 0;
> > > >  }
> > > >  #else
> > > >  static inline int cond_resched(void)
> > > >  {
> > > > +	might_sleep();
> > > >  	return _cond_resched();
> > > >  }
> > > >  #endif
> > > 
> > > # define might_resched() _cond_resched()
> > 
> > 
> > Argh, indeed.
> > I thought might_sleep() only wrapped __might_sleep(__FILE__, __LINE__)
> > 
> >  
> > > # define might_sleep() \
> > > 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
> > > 
> > > 
> > > Doesn't seem to make it any better that, but yeah, moving that
> > > __might_sleep() did occur to me earlier today when I touched that code.
> > 
> > 
> > Ok.
> > 
> > Another idea: if cond_resched() was a macro and __might_sleep() was
> > called inside, the given __FILE__ __LINE__ would be much more useful.
> > 
> > Only the backtraces would be useful in the current state, __FILE__
> > and __LINE__ point to sched.h, which is not exactly what is needed,
> > right?
> 
> Right. There's some CONFIG_PREEMPT_BKL clutter in sched.h but I 
> think we could largely fold might_sleep() and cond_resched().
> 
> Ingo?

Yep - CONFIG_PREEMPT_BKL wont ever come back so any legacy related 
to it should be removed. (That doesnt mean it wont crash or 
misbehave, this code is quite fragile.)

	Ingo
