Return-Path: <linux-kernel-owner+w=401wt.eu-S1763507AbYFEDJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763507AbYFEDJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 23:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYFEDJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 23:09:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450AbYFEDJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 23:09:40 -0400
Date: Wed, 4 Jun 2008 20:08:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Ingo Molnar <mingo@elte.hu>, David Howells <dhowells@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <20080605015634.GC4327@wotan.suse.de>
Message-ID: <alpine.LFD.1.10.0806041956030.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805302109370.3141@woody.linux-foundation.org> <alpine.LFD.1.10.0805302116440.3141@woody.linux-foundation.org> <4840D63F.2090407@redhat.com> <alpine.LFD.1.10.0805311438080.3141@woody.linux-foundation.org> <20080602185433.GB4081@elte.hu>
 <alpine.LFD.1.10.0806021246060.3141@woody.linux-foundation.org> <20080602230316.GA24159@elte.hu> <20080603032403.GA17089@wotan.suse.de> <alpine.LFD.1.10.0806041249470.3473@woody.linux-foundation.org> <alpine.LFD.1.10.0806041320020.3473@woody.linux-foundation.org>
 <20080605015634.GC4327@wotan.suse.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jun 2008, Nick Piggin wrote:
> 
> I'd have thought that for a case like this, you'd simply hit the store
> alias logic and store forwarding would stall because it doesn't have
> the full data.

That's _one_ possible implementation. 

Quite frankly, I think it's the less likely one. It's much more likely 
that the cache read access and the store buffer probe happen in parallel 
(this is a really important hotpath for any CPU, but even more so x86 
where there are more of loads and stores that are spills). And then the 
store buffer logic would return the data and a bytemask mask (where the 
mask would be all zeroes for a miss), and the returned value is just the 
appropriate mix of the two.

> I'd like to know for sure.

You'd have to ask somebody very knowledgeable inside Intel and AMD, and it 
is quite likely that different microarchitectures have different 
approaches...

> The other thing that could be possible, and I'd imagine maybe more likely
> to be implemented in a real CPU because it should give more imrpovement
> (and which does break my algorithm) is just that the load to the cacheline
> may get to execute first, then if the cacheline gets evicted and
> modified by another CPU before our store completes, we effectively see
> store/load reordering again.

Oh, absolutely, the perfect algorithm would actually get the right answer 
and notice that the cacheline got evicted, and retried the whole sequence 
such that it is coherent. 

But we do know that Intel expressly documents loads and stores to pass 
each other and documents the fact that the store buffer is there. So I bet 
that this is visible in some micro-architecture, even if it's not 
necessarily visible in _all_ of them.

The recent Intel memory ordering whitepaper makes it very clear that loads 
can pass earlier stores and in particular that the store buffer allows 
intra-processor forwarding to subsequent loads (2.4 in their whitepaper). 
It _could_ be just a "for future CPU's", but quite frankly, I'm 100% sure 
it isn't. The store->load forwarding is such a critical performance issue 
that I can pretty much guarantee that it doesn't always hit the cacheline.

Of course, the partial store forwarding case is not nearly as important, 
and stalling is quite a reasonable implementation approach. I just 
personally suspect that doing the unconditional byte-masking is actually 
_simpler_ to implement than the stall, so..

			Linus
