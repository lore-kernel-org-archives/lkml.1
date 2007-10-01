Return-Path: <linux-kernel-owner+w=401wt.eu-S1752161AbXJARcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161AbXJARcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 13:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbXJARcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 13:32:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47676 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbXJARcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 13:32:12 -0400
Date: Mon, 1 Oct 2007 19:31:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
Message-ID: <20071001173159.GB2492@elte.hu>
References: <20071001162507.GA22791@elte.hu> <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Schwartz <davids@webmaster.com> wrote:

> > > BTW, it looks like risky to criticise sched_yield too much: some 
> > > people can misinterpret such discussions and stop using this at 
> > > all, even where it's right.
> 
> > Really, i have never seen a _single_ mainstream app where the use of 
> > sched_yield() was the right choice.
> 
> It can occasionally be an optimization. You may have a case where you 
> can do something very efficiently if a lock is not held, but you 
> cannot afford to wait for the lock to be released. So you check the 
> lock, if it's held, you yield and then check again. If that fails, you 
> do it the less optimal way (for example, dispatching it to a thread 
> that *can* afford to wait).

These are generic statements, but i'm _really_ interested in the 
specifics. Real, specific code that i can look at. The typical Linux 
distro consists of in execess of 500 millions of lines of code, in tens 
of thousands of apps, so there really must be some good, valid and 
"right" use of sched_yield() somewhere in there, in some mainstream app, 
right? (because, as you might have guessed it, in the past decade of 
sched_yield() existence i _have_ seen my share of sched_yield() 
utilizing user-space code, and at the moment i'm not really impressed by 
those examples.)
 
Preferably that example should show that the best quality user-space 
lock implementation in a given scenario is best done via sched_yield(). 
Actual code and numbers. (And this isnt _that_ hard. I'm not asking for 
a full RDBMS implementation that must run through SQL99 spec suite. This 
is about a simple locking primitive, or a simple pointer to an existing 
codebase.)

> It is also sometimes used in the implementation of spinlock-type 
> primitives. After spinning fails, yielding is tried.

(user-space spinlocks are broken beyond words for anything but perhaps 
SCHED_FIFO tasks.)

> One example I know of is a defragmenter for a multi-threaded memory 
> allocator, and it has to lock whole pools. When it releases these 
> locks, it calls yield before re-acquiring them to go back to work. The 
> idea is to "go to the back of the line" if any threads are blocking on 
> those mutexes.

at a quick glance this seems broken too - but if you show the specific 
code i might be able to point out the breakage in detail. (One 
underlying problem here appears to be fairness: a quick unlock/lock 
sequence may starve out other threads. yield wont solve that fundamental 
problem either, and it will introduce random latencies into apps using 
this memory allocator.)

> > Fortunately, the sched_yield() API is already one of the most rarely
> > used scheduler functionalities, so it does not really matter. [ In my
> > experience a Linux scheduler is stabilizing pretty well when the
> > discussion shifts to yield behavior, because that shows that everything
> > else is pretty much fine ;-) ]
> 
> Can you explain what the current sched_yield behavior *is* for CFS and 
> what the tunable does to change it?

sure. (and i described that flag on lkml before) The sched_yield flag 
does two things:

 - if 0 ("opportunistic mode"), then the task will reschedule to any
   other task that is in "bigger need for CPU time" than the currently 
   running task, as indicated by CFS's ->wait_runtime metric. (or as 
   indicated by the similar ->vruntime metric in sched-devel.git)

 - if 1 ("agressive mode"), then the task will be one-time requeued to 
   the right end of the CFS rbtree. This means that for one instance, 
   all other tasks will run before this task will run again - after that 
   this task's natural ordering within the rbtree is restored.

> The desired behavior is for the current thread to not be rescheduled 
> until every thread at the same static priority as this thread has had 
> a chance to be scheduled.

do you realize that this "desired behavior" you just described is not 
achieved by the old scheduler, and that this random behavior _is_ the 
main problem here? If yield was well-specified then we could implement 
it in a well-specified way - even if the API was poor.

But fact is that it is _not_ well-specified, and apps grew upon a random 
scheduler implementation details in random ways. (in the lkml discussion 
about this topic, Linus offered a pretty sane theoretical definition for 
yield but it's not simple to implement [and no scheduler implements it 
at the moment] - nor will it map to the old scheduler's yield behavior 
so we'll end up breaking more apps.)

	Ingo
