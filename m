Return-Path: <linux-kernel-owner+w=401wt.eu-S1753854AbXLFJtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854AbXLFJtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 04:49:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXLFJs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 04:48:59 -0500
Received: from phunq.net ([64.81.85.152]:56869 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751938AbXLFJs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:48:57 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [PATCH] A clean approach to writeout throttling
Date: Thu, 6 Dec 2007 01:48:52 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712052221.45409.phillips@phunq.net> <20071205233152.c567fa57.akpm@linux-foundation.org>
In-Reply-To: <20071205233152.c567fa57.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712060148.53805.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 December 2007 23:31, Andrew Morton wrote:
> > > Rather than asking the stack "how much memory will this request consume"
> > > you could instead ask "how much memory are you currently using".
> > > 
> > > ie: on entry to the stack, do 
> > > 
> > > 	current->account_block_allocations = 1;
> > > 	make_request(...);
> > > 	rq->used_memory += current->pages_used_for_block_allocations;
> > > 
> > > and in the page allocator do
> > > 
> > > 	if (!in_interrupt() && current->account_block_allocations)
> > > 		current->pages_used_for_block_allocations++;
> > > 
> > > and then somehow handle deallocation too ;)
> > 
> > Ah, and how do you ensure that you do not deadlock while making this
> > inquiry?
> 
> It isn't an inquiry - it's a plain old submit_bio() and it runs to
> completion in the usual fashion.
> 
> Thing is, we wouldn't have called it at all if this queue was already over 
> its allocation limit.  IOW, we know that it's below its allocation limit,
> so we know it won't deadlock.  Given, of course, reasonably pessimistc
> error margins.

OK, I see what you are suggesting.  Yes, one could set the inflight limit
very low and the reserve very high, and run a bio through the stack (what
I meant by "inquiry") to discover the actual usage, then shrink the reserve
accordingly.  By also running a real bio through the stack we can discover
something about the latency.  So we would then know roughly how high
the inflight limit should be set and how much the memalloc reserve
should be increased to handle that particular driver instance.

The big fly in this ointment is that we cannot possibly know that our bio
followed the worst case resource consumption path, whereas it is fairly
easy (hopefully) for a programmer to determine this statically.

> Which margins can even be observed at runtime: keep a running "max" of this
> stack's most-ever memory consumption (for a single call), and only submit a
> bio into it when its current allocation is less than (limit - that-max).

Actually, your mechanism would always have to be operable at runtime,
since inserting a new driver while the system is under heavy memory
load is a perfectly valid operation and has to be reliable.

Anyway, even if you run a bio through the stack lots of times (insert
definition of "lots" here) you still cannot be sure that it has explored the
worst case path.  To put this in perspective, some of the deadlocks we
have hunted down recently have taken days to manifest under artificially
high load.  It just takes that long to randomly explore a sufficient number
of corner cases.

> >  Perhaps send a dummy transaction down the pipe?  Even so,
> > deadlock is possible, quite evidently so in the real life example I have
> > at hand.
> > 
> > Yours is essentially one of the strategies I had in mind, the other major
> > one being simply to examine the whole stack, which presupposes some
> > as-yet-nonexistant kernel wide method of representing block device
> > stacks in all there glorious possible topology variations.
> 
> We already have that, I think: blk_run_backing_dev().  One could envisage a
> similar thing which runs up and down the stack accumulating "how much
> memory do you need for this request" data, but I think that would be hard to
> implement and plain dumb.

I don't think I quite communicated there.  We don't actually have any
generic notion of "the block device stack".  Device mapper has its own
model, md has another model, and other stacking devices may have no
model at all, just some through-coded hack.  It would be worth fixing this
problem as part of an effort to generalize the block IO model and make
block devices in general look more like device mapper devices.  But
that would be a pretty big project, the need for which is not generally
recognized.

> > ...Something like automatically determining a
> > workable locking strategy by analyzing running code, wouldn't that be
> > a treat?  I will hope for one of those under my tree at Christmas.
> 
> I don't see any unviability.

A small matter of coding.  It would be a legendary hack.

> > ...number of requests
> > does not map well to the amount of resources consumed.  In ddsnap for
> > example, the amount of memory used by the userspace ddsnapd is
> > roughly linear vs the number of pages transferred, not the number of
> > requests.
> 
> Yeah, one would need to be pretty pessimal.  Perhaps unacceptably
> inaccurate, dunno.

Orders of magnitude more reserve would need to be allocated in the
case of ddsnap, since bio payload can vary through a big range, which
is expected to get bigger as time goes by.  So the few lines of extra
code and the extra bio field needed to get a better fit is well worth the
effort, or even indispensable.

> > > > @@ -3221,6 +3221,13 @@ static inline void __generic_make_reques
> > > >  	if (bio_check_eod(bio, nr_sectors))
> > > >  		goto end_io;
> > > >  
> > > > +	if (q && q->metric && !bio->bi_queue) {
> > > > +		int need = bio->bi_throttle = q->metric(bio);
> > > > +		bio->bi_queue = q;
> > > > +		/* FIXME: potential race if atomic_sub is called in the middle of condition check */
> > > > +		wait_event_interruptible(q->throttle_wait, atomic_read(&q->available) >= need);
> > > 
> > > This will fall straight through if signal_pending() and (I assume) bad
> > > stuff will happen.  uninterruptible sleep, methinks.
> > 
> > Yes, as a first order repair.  To be done properly I need to express this
> > in terms of the guts of wait_event_*, and get rid of that race, maybe that
> > changes the equation.
> 
> I don't think so.  If you're going to sleep in state TASK_INTERRUPTIBLE
> then you *have* to bale out and return to userspace (or whatever) when
> signal_pending().  Because schedule() becomes a no-op.

Thanks for clearing that up.  No I did not know that important fact about
signal handling, and now it is obvious why it must be so.  Got a pointer
to a doc for that, and other similar scheduler factoids that must surely
be known to those in the know?

> ...for now, TASK_UNINTERRUPTIBLE is the honest solution.

Right, and easy too.  I think we ought to be able to do a fairly good job
of making the in-flight items go away in the presence of a signal, thus
ending the uninterruptible sleep reliably.  Probably.

Regards,

Daniel
