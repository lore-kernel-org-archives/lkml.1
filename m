Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZKBQA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZKBQA2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755353AbZKBQA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:00:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbZKBQA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:00:27 -0500
Date: Mon, 2 Nov 2009 17:00:31 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch][rfc] x86, mutex: non-atomic unlock (and a rant)
Message-ID: <20091102160031.GB23221@wotan.suse.de>
References: <20091102120739.GA20318@wotan.suse.de> <alpine.LFD.2.01.0911020710030.31845@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911020710030.31845@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 07:20:08AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 2 Nov 2009, Nick Piggin wrote:
> > 
> > Non-atomic unlock for mutexs maybe? I do this by relying on cache
> > coherence on a cacheline basis for ordering rather than the memory
> > consistency of the x86. Linus I know you've told me this is an incorrect
> > assumption in the past, but I'm not so sure.
> 
> I'm sure.
> 
> This is simply buggy:
> 
> > +	atomic_set(&lock->count, 1);
> > +	barrier();
> > +	if (unlikely(lock->waiters))
> > +		fail_fn(lock);
> 
> because it doesn't matter one whit whether 'lock->count' and 
> 'lock->waiters' are in the same cacheline or not.
> 
> The cache coherency deals in cachelines, but the instruction re-ordering 
> logic does not. It's entirely possible that the CPU will turn this into
> 
> 	tmp = lock->waiters;
> 	...
> 	atomic_set(&lock->count, 1);
> 	if (tmp)
> 		fail_fn(lock);
> 
> and your "barrier()" did absolutely nothing.
> 
> The fact that it may _work_ in almost all circumstances (and perhaps even 
> "always" on some microarchitectures) is irrelevant. It's simply not 
> guaranteed to work. Yes, you need just the right timings, and yes, it's 
> probably hard to hit. And yes, I can well imagine that some micro-
> architecture will even guarantee the write->read ordering, and that it 
> would _always_ work on that micro-architecture.
> 
> But I can see your thing failing even on an in-order CPU. It literally 
> doesn't even need OoO to fail, all it needs is a sufficiently deep write 
> buffer on an in-order core. And to fail in practice, maybe there needs to 
> be lots of writes in that buffer, and some bad luck, but the thing is, 
> write buffers are not coherent between cores - so the write may have 
> happened as far as the core that does it is concerned, but other cores 
> (or even HT) may not see the new value until after the read has taken 
> effect.

Hm OK I see you must be right there. The trick will only be guaranteed
to work if you operate on exactly the same memory location I guess (or
for store/store vs load/load sequences). In which case, atomic ops
can't be avoided for the unlock case :(

Well, it can use a barrier instead of atomic for unlock, which might
help on some architectures but on x86 I don't think it does much.


