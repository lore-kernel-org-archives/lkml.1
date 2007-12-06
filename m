Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbXLFHcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbXLFHcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:32:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbXLFHcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:32:16 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60405 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753200AbXLFHcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:32:15 -0500
Date: Wed, 5 Dec 2007 23:31:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Message-Id: <20071205233152.c567fa57.akpm@linux-foundation.org>
In-Reply-To: <200712052221.45409.phillips@phunq.net>
References: <200712051603.02183.phillips@phunq.net>
	<20071205172446.ea54e4d3.akpm@linux-foundation.org>
	<200712052221.45409.phillips@phunq.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2007 22:21:44 -0800 Daniel Phillips <phillips@phunq.net> wrote:

> On Wednesday 05 December 2007 17:24, Andrew Morton wrote:
> > On Wed, 5 Dec 2007 16:03:01 -0800 Daniel Phillips <phillips@phunq.net> wrote:
> > > ...a block device these days may not be just a single 
> > > device, but may be a stack of devices connected together by a generic 
> > > mechanism such as device mapper, or a hardcoded stack such as 
> > > multi-disk or network block device.  It is necessary to consider the 
> > > resource requirements of the stack as a whole _before_ letting a 
> > > transfer proceed into any layer of the stack, otherwise deadlock on 
> > > many partially completed transfers becomes a possibility.  For this 
> > > reason, the bio throttling is only implemented at the initial, highest 
> > > level submission of the bio to the block layer and not for any recursive 
> > > submission of the same bio to a lower level block device in a stack.
> > > 
> > > This in turn has rather far reaching implications: the top level device 
> > > in a stack must take care of inspecting the entire stack in order to 
> > > determine how to calculate its resource requirements, thus becoming
> > > the boss device for the entire stack.  Though this intriguing idea could 
> > > easily become the cause of endless design work and many thousands of 
> > > lines of fancy code, today I sidestep the question entirely using 
> > > the "just provide lots of reserve" strategy.  Horrifying as it may seem 
> > > to some, this is precisely the strategy that Linux has used in the 
> > > context of resource management in general, from the very beginning and 
> > > likely continuing for quite some time into the future  My strongly held 
> > > opinion in this matter is that we need to solve the real, underlying 
> > > problems definitively with nice code before declaring the opening of 
> > > fancy patch season.  So I am leaving further discussion of automatic 
> > > resource discovery algorithms and the like out of this post.
> > 
> > Rather than asking the stack "how much memory will this request consume"
> > you could instead ask "how much memory are you currently using".
> > 
> > ie: on entry to the stack, do 
> > 
> > 	current->account_block_allocations = 1;
> > 	make_request(...);
> > 	rq->used_memory += current->pages_used_for_block_allocations;
> > 
> > and in the page allocator do
> > 
> > 	if (!in_interrupt() && current->account_block_allocations)
> > 		current->pages_used_for_block_allocations++;
> > 
> > and then somehow handle deallocation too ;)
> 
> Ah, and how do you ensure that you do not deadlock while making this
> inquiry?

It isn't an inquiry - it's a plain old submit_bio() and it runs to
completion in the usual fashion.

Thing is, we wouldn't have called it at all if this queue was already over
its allocation limit.  IOW, we know that it's below its allocation limit,
so we know it won't deadlock.  Given, of course, reasonably pessimistc
error margins.

Which margins can even be observed at runtime: keep a running "max" of this
stack's most-ever memory consumption (for a single call), and only submit a
bio into it when its current allocation is less than (limit - that-max).

>  Perhaps send a dummy transaction down the pipe?  Even so,
> deadlock is possible, quite evidently so in the real life example I have
> at hand.
> 
> Yours is essentially one of the strategies I had in mind, the other major
> one being simply to examine the whole stack, which presupposes some
> as-yet-nonexistant kernel wide method of representing block device
> stacks in all there glorious possible topology variations.

We already have that, I think: blk_run_backing_dev().  One could envisage a
similar thing which runs up and down the stack accumulating "how much
memory do you need for this request" data, but I think that would be hard to
implement and plain dumb.

> > The basic idea being to know in real time how much memory a particular
> > block stack is presently using.  Then, on entry to that stack, if the
> > stack's current usage is too high, wait for it to subside.
> 
> We do not wait for high block device resource usage to subside before
> submitting more requests.  The improvement you suggest is aimed at
> automatically determining resource requirements by sampling a
> running system, rather than requiring a programmer to determine them
> arduously by hand.  Something like automatically determining a
> workable locking strategy by analyzing running code, wouldn't that be
> a treat?  I will hope for one of those under my tree at Christmas.

I don't see any unviability.

> More practically, I can see a debug mode implemented along the lines
> you describe where we automatically detect that a writeout path has
> violated its covenant as expressed by its throttle_metric.
>  
> > otoh we already have mechanisms for limiting the number of requests in
> > flight.  This is approximately proportional to the amount of memory which
> > was allocated to service those requests.  Why not just use that?
> 
> Two reasons.  The minor one is that device mapper bypasses that
> mechanism (no elevator)

oh.

> and the major one is that number of requests
> does not map well to the amount of resources consumed.  In ddsnap for
> example, the amount of memory used by the userspace ddsnapd is
> roughly linear vs the number of pages transferred, not the number of
> requests.

Yeah, one would need to be pretty pessimal.  Perhaps unacceptably
inaccurate, dunno.

> > > @@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
> > >  	if (bio_check_eod(bio, nr_sectors))
> > >  		goto end_io;
> > >  
> > > +	if (q && q->metric && !bio->bi_queue) {
> > > +		int need = bio->bi_throttle = q->metric(bio);
> > > +		bio->bi_queue = q;
> > > +		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
> > > +		wait_event_interruptible(q->throttle_wait, atomic_read(&q->available) >= need);
> > 
> > This will fall straight through if signal_pending() and (I assume) bad
> > stuff will happen.  uninterruptible sleep, methinks.
> 
> Yes, as a first order repair.  To be done properly I need to express this
> in terms of the guts of wait_event_*, and get rid of that race, maybe that
> changes the equation.

I don't think so.  If you're going to sleep in state TASK_INTERRUPTIBLE
then you *have* to bale out and return to userspace (or whatever) when
signal_pending().  Because schedule() becomes a no-op.

> It would be nice if threads didn't get stuck in D state here, though
> _interruptible is probably the wrong idea, we should instead ensure that
> whatever is being waited on must respond to, e.g., SIGKILL.  This at the
> limits of my scheduler knowledge, l would appreciate a better
> suggestion.  I do detest hang in D state with SIGKILL immunity, which
> behavior unfortunately does not seem all that rare.

Well..  See 

add-lock_page_killable.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch

in 2.6.24-rc4-mm1.

But for now, TASK_UNINTERRUPTIBLE is the honest solution.

