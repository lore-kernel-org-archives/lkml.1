Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbXLFGWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbXLFGWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 01:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbXLFGWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 01:22:06 -0500
Received: from phunq.net ([64.81.85.152]:50899 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752012AbXLFGWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 01:22:05 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Date: Wed, 5 Dec 2007 22:21:44 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <20071205172446.ea54e4d3.akpm@linux-foundation.org>
In-Reply-To: <20071205172446.ea54e4d3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712052221.45409.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2007 17:24, Andrew Morton wrote:
> On Wed, 5 Dec 2007 16:03:01 -0800 Daniel Phillips <phillips@phunq.net> wrote:
> > ...a block device these days may not be just a single 
> > device, but may be a stack of devices connected together by a generic 
> > mechanism such as device mapper, or a hardcoded stack such as 
> > multi-disk or network block device.  It is necessary to consider the 
> > resource requirements of the stack as a whole _before_ letting a 
> > transfer proceed into any layer of the stack, otherwise deadlock on 
> > many partially completed transfers becomes a possibility.  For this 
> > reason, the bio throttling is only implemented at the initial, highest 
> > level submission of the bio to the block layer and not for any recursive 
> > submission of the same bio to a lower level block device in a stack.
> > 
> > This in turn has rather far reaching implications: the top level device 
> > in a stack must take care of inspecting the entire stack in order to 
> > determine how to calculate its resource requirements, thus becoming
> > the boss device for the entire stack.  Though this intriguing idea could 
> > easily become the cause of endless design work and many thousands of 
> > lines of fancy code, today I sidestep the question entirely using 
> > the "just provide lots of reserve" strategy.  Horrifying as it may seem 
> > to some, this is precisely the strategy that Linux has used in the 
> > context of resource management in general, from the very beginning and 
> > likely continuing for quite some time into the future  My strongly held 
> > opinion in this matter is that we need to solve the real, underlying 
> > problems definitively with nice code before declaring the opening of 
> > fancy patch season.  So I am leaving further discussion of automatic 
> > resource discovery algorithms and the like out of this post.
> 
> Rather than asking the stack "how much memory will this request consume"
> you could instead ask "how much memory are you currently using".
> 
> ie: on entry to the stack, do 
> 
> 	current->account_block_allocations = 1;
> 	make_request(...);
> 	rq->used_memory += current->pages_used_for_block_allocations;
> 
> and in the page allocator do
> 
> 	if (!in_interrupt() && current->account_block_allocations)
> 		current->pages_used_for_block_allocations++;
> 
> and then somehow handle deallocation too ;)

Ah, and how do you ensure that you do not deadlock while making this
inquiry?  Perhaps send a dummy transaction down the pipe?  Even so,
deadlock is possible, quite evidently so in the real life example I have
at hand.

Yours is essentially one of the strategies I had in mind, the other major
one being simply to examine the whole stack, which presupposes some
as-yet-nonexistant kernel wide method of representing block device
stacks in all there glorious possible topology variations.

> The basic idea being to know in real time how much memory a particular
> block stack is presently using.  Then, on entry to that stack, if the
> stack's current usage is too high, wait for it to subside.

We do not wait for high block device resource usage to subside before
submitting more requests.  The improvement you suggest is aimed at
automatically determining resource requirements by sampling a
running system, rather than requiring a programmer to determine them
arduously by hand.  Something like automatically determining a
workable locking strategy by analyzing running code, wouldn't that be
a treat?  I will hope for one of those under my tree at Christmas.

More practically, I can see a debug mode implemented along the lines
you describe where we automatically detect that a writeout path has
violated its covenant as expressed by its throttle_metric.
 
> otoh we already have mechanisms for limiting the number of requests in
> flight.  This is approximately proportional to the amount of memory which
> was allocated to service those requests.  Why not just use that?

Two reasons.  The minor one is that device mapper bypasses that
mechanism (no elevator) and the major one is that number of requests
does not map well to the amount of resources consumed.  In ddsnap for
example, the amount of memory used by the userspace ddsnapd is
roughly linear vs the number of pages transferred, not the number of
requests.

> > @@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
> >  	if (bio_check_eod(bio, nr_sectors))
> >  		goto end_io;
> >  
> > +	if (q && q->metric && !bio->bi_queue) {
> > +		int need = bio->bi_throttle = q->metric(bio);
> > +		bio->bi_queue = q;
> > +		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
> > +		wait_event_interruptible(q->throttle_wait, atomic_read(&q->available) >= need);
> 
> This will fall straight through if signal_pending() and (I assume) bad
> stuff will happen.  uninterruptible sleep, methinks.

Yes, as a first order repair.  To be done properly I need to express this
in terms of the guts of wait_event_*, and get rid of that race, maybe that
changes the equation.

It would be nice if threads didn't get stuck in D state here, though
_interruptible is probably the wrong idea, we should instead ensure that
whatever is being waited on must respond to, e.g., SIGKILL.  This at the
limits of my scheduler knowledge, l would appreciate a better
suggestion.  I do detest hang in D state with SIGKILL immunity, which
behavior unfortunately does not seem all that rare.

Daniel
