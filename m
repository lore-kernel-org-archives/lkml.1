Return-Path: <linux-kernel-owner+w=401wt.eu-S1755379AbZKBPUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379AbZKBPUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbZKBPUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:20:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754814AbZKBPUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:20:19 -0500
Date: Mon, 2 Nov 2009 07:20:08 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch][rfc] x86, mutex: non-atomic unlock (and a rant)
In-Reply-To: <20091102120739.GA20318@wotan.suse.de>
Message-ID: <alpine.LFD.2.01.0911020710030.31845@localhost.localdomain>
References: <20091102120739.GA20318@wotan.suse.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 2 Nov 2009, Nick Piggin wrote:
> 
> Non-atomic unlock for mutexs maybe? I do this by relying on cache
> coherence on a cacheline basis for ordering rather than the memory
> consistency of the x86. Linus I know you've told me this is an incorrect
> assumption in the past, but I'm not so sure.

I'm sure.

This is simply buggy:

> +	atomic_set(&lock->count, 1);
> +	barrier();
> +	if (unlikely(lock->waiters))
> +		fail_fn(lock);

because it doesn't matter one whit whether 'lock->count' and 
'lock->waiters' are in the same cacheline or not.

The cache coherency deals in cachelines, but the instruction re-ordering 
logic does not. It's entirely possible that the CPU will turn this into

	tmp = lock->waiters;
	...
	atomic_set(&lock->count, 1);
	if (tmp)
		fail_fn(lock);

and your "barrier()" did absolutely nothing.

The fact that it may _work_ in almost all circumstances (and perhaps even 
"always" on some microarchitectures) is irrelevant. It's simply not 
guaranteed to work. Yes, you need just the right timings, and yes, it's 
probably hard to hit. And yes, I can well imagine that some micro-
architecture will even guarantee the write->read ordering, and that it 
would _always_ work on that micro-architecture.

But I can see your thing failing even on an in-order CPU. It literally 
doesn't even need OoO to fail, all it needs is a sufficiently deep write 
buffer on an in-order core. And to fail in practice, maybe there needs to 
be lots of writes in that buffer, and some bad luck, but the thing is, 
write buffers are not coherent between cores - so the write may have 
happened as far as the core that does it is concerned, but other cores 
(or even HT) may not see the new value until after the read has taken 
effect.

			Linus
