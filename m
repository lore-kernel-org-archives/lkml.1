Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXLFLzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXLFLzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 06:55:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbXLFLzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 06:55:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38368 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752106AbXLFLzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 06:55:38 -0500
Date: Thu, 6 Dec 2007 03:55:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-Id: <20071206035511.83bef995.akpm@linux-foundation.org>
In-Reply-To: <200712060148.53805.phillips@phunq.net>
References: <200712051603.02183.phillips@phunq.net>
	<200712052221.45409.phillips@phunq.net>
	<20071205233152.c567fa57.akpm@linux-foundation.org>
	<200712060148.53805.phillips@phunq.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2007 01:48:52 -0800 Daniel Phillips <phillips@phunq.net> wrote:

> On Wednesday 05 December 2007 23:31, Andrew Morton wrote:
> > > > Rather than asking the stack "how much memory will this request consume"
> > > > you could instead ask "how much memory are you currently using".
> > > > 
> > > > ie: on entry to the stack, do 
> > > > 
> > > > 	current->account_block_allocations = 1;
> > > > 	make_request(...);
> > > > 	rq->used_memory += current->pages_used_for_block_allocations;
> > > > 
> > > > and in the page allocator do
> > > > 
> > > > 	if (!in_interrupt() && current->account_block_allocations)
> > > > 		current->pages_used_for_block_allocations++;
> > > > 
> > > > and then somehow handle deallocation too ;)
> > > 
> > > Ah, and how do you ensure that you do not deadlock while making this
> > > inquiry?
> > 
> > It isn't an inquiry - it's a plain old submit_bio() and it runs to
> > completion in the usual fashion.
> > 
> > Thing is, we wouldn't have called it at all if this queue was already over 
> > its allocation limit.  IOW, we know that it's below its allocation limit,
> > so we know it won't deadlock.  Given, of course, reasonably pessimistc
> > error margins.
> 
> OK, I see what you are suggesting.  Yes, one could set the inflight limit
> very low and the reserve very high, and run a bio through the stack (what
> I meant by "inquiry") to discover the actual usage, then shrink the reserve
> accordingly.  By also running a real bio through the stack we can discover
> something about the latency.  So we would then know roughly how high
> the inflight limit should be set and how much the memalloc reserve
> should be increased to handle that particular driver instance.
> 
> The big fly in this ointment is that we cannot possibly know that our bio
> followed the worst case resource consumption path, whereas it is fairly
> easy (hopefully) for a programmer to determine this statically.

nonono...

Consider an example.

- We a-priori decide to limit a particular stack's peak memory usage to
  1MB

- We empirically discover that the maximum amount of memory which is
  allocated by that stack on behalf of a single BIO is 16kb.  (ie: that's
  the most it has ever used for a single BIO).

- Now, we refuse to feed any more BIOs into the stack when its
  instantaneous memory usage exceeds (1MB - 16kb).

Of course, the _average_ memory-per-BIO is much less than 16kb.  So there
are a lot of BIOs in flight - probably hundreds, but a minimum of 63.

There is a teeny so-small-it-doesn't-matter chance that the stack will
exceed the 1MB limit.  If it happens to be at its (1MB-16kb) limit and all
the memory in the machine is AWOL and then someone throws a
never-seen-before twirly BIO at it.  Not worth worrying about, surely.
