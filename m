Return-Path: <linux-kernel-owner+w=401wt.eu-S1752881AbZGTL5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbZGTL5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 07:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZGTL5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 07:57:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42154 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbZGTL5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 07:57:43 -0400
Date: Mon, 20 Jul 2009 13:56:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Pull up the might_sleep() check into
	cond_resched()
Message-ID: <20090720115638.GC29811@elte.hu>
References: <1247725694-6082-6-git-send-email-fweisbec@gmail.com> <tip-613afbf83298efaead05ebcac23d2285609d7160@git.kernel.org> <4A6413AB.2050807@cn.fujitsu.com> <20090720081210.GA5309@nowhere> <1248079747.15751.8202.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248079747.15751.8202.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

> On Mon, 2009-07-20 at 04:12 -0400, Frederic Weisbecker wrote:
> 
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: [PATCH] sched: Check if the spinlock is locked in cond_resched_lock()
> > 
> > Some uses of cond_resched_lock() might involve an
> > unlocked spinlock, resulting in spurious sleep in
> > atomic warnings.
> > Check whether the spinlock is actually locked and
> > take that into account in the might_sleep() check.
> > 
> > Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index cb070dc..2789658 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2294,9 +2294,10 @@ extern int _cond_resched(void);
> >  
> >  extern int __cond_resched_lock(spinlock_t *lock);
> >  
> > -#define cond_resched_lock(lock) ({				\
> > -	__might_sleep(__FILE__, __LINE__, PREEMPT_OFFSET);	\
> > -	__cond_resched_lock(lock);				\
> > +#define cond_resched_lock(lock) ({				  \
> > +	__might_sleep(__FILE__, __LINE__, spin_is_locked(lock) ?  \
> > +					  PREEMPT_OFFSET : 0);	  \
> > +	__cond_resched_lock(lock);				  \
> >  })
> >  
> >  extern int __cond_resched_softirq(void);
> 
> 
> No, this looks utterly broken.. who is to say it doesn't get unlocked
> right after that spin_is_locked() check?
> 
> cond_resched_lock() callers must hold the lock they use it on, not doing
> so is broken.
> 
> So I would suggest something like the below instead:
> 
> (utterly untested)

FYI, i've undone the tip:sched/core bits from tip:master for now - 
please send a delta patch against tip:sched/core once this is fixed.

Thanks,

	Ingo
