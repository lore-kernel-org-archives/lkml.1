Return-Path: <linux-kernel-owner+w=401wt.eu-S1761556AbYEMVGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761556AbYEMVGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 17:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758525AbYEMVGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 17:06:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50637 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759441AbYEMVGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 17:06:07 -0400
Date: Tue, 13 May 2008 23:05:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Sven Wegener <sven.wegener@stealer.net>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [git pull] scheduler fixes
Message-ID: <20080513210513.GA17492@elte.hu>
References: <20080511144203.GB3220@elte.hu> <20080511144821.GW19219@parisc-linux.org> <20080511151909.GA3887@elte.hu> <20080511152942.GY19219@parisc-linux.org> <20080513141129.GC18798@elte.hu> <20080513142135.GF9324@parisc-linux.org> <20080513144207.GA4697@elte.hu> <20080513152846.GI9324@parisc-linux.org> <20080513171352.GE22348@elte.hu> <alpine.LFD.1.10.0805131019360.3019@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805131019360.3019@woody.linux-foundation.org>
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

> > Why does it signal to its waiters that "resource is available", when 
> > in reality that resource is not available but immediately serialized 
> > via a lock? (even if the lock might technically be some _other_ 
> > object)
> 
> So you have 'n' resources available, and you use a counting semaphore 
> for that resource counting.
> 
> But you'd still need a spinlock to actually protect the list of 
> resources themselves. The spinlock protects a different thing than the 
> semaphore. The semaphore isn't about mutual exclusion - it's about 
> counting resources and waiting when there are too many things in 
> flight.
> 
> And you seem to think that a counting semaphore is about mutual 
> exclusion. It has nothing what-so-ever to do with that.

i was reacting to the point that Matthew made:

  " The first thing that each task does is grab a spinlock, so if you 
    put as much in flight as early as possible, you end up with horrible 
    contention on that spinlock. "

We were talking about the case of double, parallel up()s. My point was 
that the best guess is to put two tasks in flight in the synchronization 
primitive. Matthew's point was that the wakeups of the two tasks should 
be chained: one task gets woken first, which then wakes the second task 
in a chain. [ Matthew, i'm paraphrasing your opinion so please correct 
me if i'm misinterpreting your point. ]

My argument is that chaining like that in the synchronization primitive 
is bad for parallelism in general, because wakeup latencies are just too 
long in general and any action required in the context of the "first 
waker" throttles parallelism artificially and introduces artificial 
workload delays.

Even in the simple list+lock case you are talking about it's beneficial 
to keep as many wakers in flight as possible. The reason is that even 
with the worst-possible cacheline bouncing imaginable, it's much better 
to spin a bit on a spinlock (which is "horrible bouncing" only on paper, 
in practice it's nicely ordered waiting on a FIFO spinlock, with a list 
op every 100 nsecs or so) than to implement "soft bouncing" of tasks via 
an artificial chain of wakeups.

That artificial chain of wakeups has a latency of a few microseconds 
even in the best case - and in the worst-case it can be a delay of 
milliseconds later - throttling not just the current parallelism of the 
workload but also hiding potential future parallelism. The hardware is 
so much faster at messaging. [*] [**]

	Ingo

[*]  Not without qualifications - maybe not so on 1024 CPU systems, but
     certainly so on anything sane up to 16way or so. But if worry about 
     1024 CPU systems i'd suggest to first take a look at the current 
     practice in kernel/semaphore.c taking the semaphore internal 
     spinlock again _after_ a task has woken up, just to remove itself 
     from the list of waiters. That is rather unnecessary serialization 
     - at up() time we are already holding the lock, so we should remove
     the entry there. That's what the mutex code does too.

[**] The only place where i can see staggered/chained wakeups help is in 
     the specific case when the wakee runs into a heavy lock _right 
     after_ wakeup. XFS might be running into that and my reply above 
     talks about that hypothetical scenario.

     If it is so then it is handled incorrectly, because in that case we 
     dont have any true parallelism at the point of up(), and we know it 
     right there. There is no reason to pretend at that point that we 
     have more parallelism, when all we do is we block on a heavy lock 
     right after wakeup.

     Instead, the correct implementation in that case would be to have a 
     wait queue for that heavy lock (which in other words can be thought 
     of as a virtual single-resource which is either 'available' or 
     'unavailable'), and _then_ after that to use a counting semaphore 
     for the rest of the program flow, which is hopefully more parallel. 

     I.e. precisely map the true parallelism of the code via the 
     synchronization primitives, do not over-synchronize it and do not
     under-synchronize it. And if there's any doubt which one should be 
     used, under-synchronize it - because while the scheduler is rather
     good at dealing with too many tasks it cannot conjure runnable 
     tasks out of thin air.

     Btw., the AIM7 regression was exactly that: in the 50% regressed 
     workload the semaphore code hid the true parallelism of the 
     workload and we had only had 5 tasks on the runqueue and the 
     scheduler had no chance to saturate all CPUs. In the "good" case 
     (be that spinlock based or proper-semaphores based BKL) there were 
     2000 runnable tasks on the runqueues, and the scheduler sorted them 
     out and batched the workload just fine!
