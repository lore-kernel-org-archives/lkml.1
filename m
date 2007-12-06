Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbXLFBZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbXLFBZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 20:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbXLFBZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 20:25:09 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46004 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751656AbXLFBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 20:25:08 -0500
Date: Wed, 5 Dec 2007 17:24:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-Id: <20071205172446.ea54e4d3.akpm@linux-foundation.org>
In-Reply-To: <200712051603.02183.phillips@phunq.net>
References: <200712051603.02183.phillips@phunq.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2007 16:03:01 -0800 Daniel Phillips <phillips@phunq.net> wrote:

> Practice
> 
> So here is the key idea of today's patch: it provides a simple mechanism 
> for imposing a limit on the amount of data that can be in flight to any 
> particular block device.
> 
> The limit on in-flight data is in fact expressed generically, as it is 
> hard to set down any single rule to specify the amount of resources 
> any particular bio transfer will require.  Instead, the block layer 
> provides a method that a block driver may optionally fill in, to 
> calculate the resource bound in units of the block driver's choosing.  
> The block driver thus takes upon itself the task of translating its 
> own, self-imposed bound into generic resource units that can be treated 
> generically by the kernel.  In simple terms, the block driver looks at 
> each bio and decides how many pages (at most) of memalloc reserve could 
> be needed to fully service the transfer, and translates that 
> requirement into generic units for use by the block layer. The block 
> layer compares the generic units to a generic bound provided by the 
> block driver at initialization time and decides whether to let the bio 
> transfer in question proceed, or hold it back.
> 
> This idea is Simplicity itself.  Some not so obvious details follow.
> 
> For one thing, a block device these days may not be just a single 
> device, but may be a stack of devices connected together by a generic 
> mechanism such as device mapper, or a hardcoded stack such as 
> multi-disk or network block device.  It is necessary to consider the 
> resource requirements of the stack as a whole _before_ letting a 
> transfer proceed into any layer of the stack, otherwise deadlock on 
> many partially completed transfers becomes a possibility.  For this 
> reason, the bio throttling is only implemented at the initial, highest 
> level submission of the bio to the block layer and not for any recursive 
> submission of the same bio to a lower level block device in a stack.
> 
> This in turn has rather far reaching implications: the top level device 
> in a stack must take care of inspecting the entire stack in order to 
> determine how to calculate its resource requirements, thus becoming
> the boss device for the entire stack.  Though this intriguing idea could 
> easily become the cause of endless design work and many thousands of 
> lines of fancy code, today I sidestep the question entirely using 
> the "just provide lots of reserve" strategy.  Horrifying as it may seem 
> to some, this is precisely the strategy that Linux has used in the 
> context of resource management in general, from the very beginning and 
> likely continuing for quite some time into the future  My strongly held 
> opinion in this matter is that we need to solve the real, underlying 
> problems definitively with nice code before declaring the opening of 
> fancy patch season.  So I am leaving further discussion of automatic 
> resource discovery algorithms and the like out of this post.

Rather than asking the stack "how much memory will this request consume"
you could instead ask "how much memory are you currently using".

ie: on entry to the stack, do

	current->account_block_allocations = 1;
	make_request(...);
	rq->used_memory += current->pages_used_for_block_allocations;

and in the page allocator do

	if (!in_interrupt() && current->account_block_allocations)
		current->pages_used_for_block_allocations++;

and then somehow handle deallocation too ;)

The basic idea being to know in real time how much memory a particular
block stack is presently using.  Then, on entry to that stack, if the
stack's current usage is too high, wait for it to subside.


otoh we already have mechanisms for limiting the number of requests in
flight.  This is approximately proportional to the amount of memory which
was allocated to service those requests.  Why not just use that?

> @@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
>  	if (bio_check_eod(bio, nr_sectors))
>  		goto end_io;
>  
> +	if (q && q->metric && !bio->bi_queue) {
> +		int need = bio->bi_throttle = q->metric(bio);
> +		bio->bi_queue = q;
> +		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
> +		wait_event_interruptible(q->throttle_wait, atomic_read(&q->available) >= need);

This will fall straight through if signal_pending() and (I assume) bad
stuff will happen.  uninterruptible sleep, methinks.


