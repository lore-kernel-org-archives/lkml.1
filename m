Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab0BOPL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:11:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab0BOPLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:11:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B763C17.5080707@kernel.org>
References: <4B763C17.5080707@kernel.org> <1263776272-382-36-git-send-email-tj@kernel.org> <1263776272-382-1-git-send-email-tj@kernel.org> <24913.1265997809@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, awalls@radix.net, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, jens.axboe@oracle.com,
       rusty@rustcorp.com.au, cl@linux-foundation.org, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
Subject: Re: [PATCH 35/40] fscache: convert object to use workqueue instead of slow-work
Date: Mon, 15 Feb 2010 15:04:56 +0000
Message-ID: <27102.1266246296@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> wrote:

> > Okay, how do you stop the workqueue from having all its threads
> > blocking on pending work?  The reason the code you've removed
> > interacts with the slow work facility in this way is that there can
> > be a dependency whereby an executing work item depends on something
> > that is queued.  This code allows the thread to be given back to the
> > pool and processing deferred.
> 
> How deep the dependency chain can be?

There only needs to be a single dependency in the chain.  The problem is that a
pool thread gets blocked waiting for an item on the queue - but if there's a
limited number of pool threads, then all of them can wind up blocked waiting on
the contents of the queue.

The problem I've seen is that a someone goes and bulk-updates a bunch of files
on, say, an NFS server; then FS-Cache flushes all the altered objects and then
attempts to create new replacement ones.  However, it was stipulated that all
this had to happen asynchronously - so the new objects have to wait for the old
objects to go away so that they can replace them in the namespace.

So what happens is that the obsolete objects being deleted get executed to
begin deletion, but the deletions then get deferred because the objects are
still undergoing I/O - and so the objects get requeued *behind* the new objects
that are going to wait for them.

> As I wrote in the patch description, wake-me-up-on-another-enqueue can be
> implemented in similar way but I wasn't sure how useful it would be.  If the
> dependency chain is strictly bound and significantly shorter than the
> allowed concurrency, it might be better to just leave them sleep.

The problem there is that the timeouts add up and can significantly slow the
system.

> If it's mainly because there can be many concurrent long waiters (but
> no dependency), implementing staggered timeout might be better option.
> I wasn't sure about the requirement there.

We don't really want to time out if we've got threads to spare, and if our
dependency is getting or will get CPU time.

> > Note that just creating more threads isn't a good answer - that can
> > run you out of resources instead.
> 
> It depends.  The only resource taken up by an idle kthread is small
> amount of memory and it can definitely be traded off against code
> complexity and processing overhead.

And PIDs...

Also the definition of a 'small amount of memory' is dependent on how much
memory you actually have.

> Anyways, this really depends on what is the concurrency requirement there,
> can you please explain what would the bad cases be?

See above.  But I've come across this problem and dealt with it, generally
without resorting to timeouts.

> >> +	ret = -ENOMEM;
> >> +	fscache_object_wq =
> >> +		__create_workqueue("fscache_object", WQ_SINGLE_CPU, 99);
> >> +	if (!fscache_object_wq)
> >> +		goto error_object_wq;
> >> +
> > 
> > What does fscache_object_wq being WQ_SINGLE_CPU imply?  Does that mean there
> > can only be one CPU processing object state changes?
> 
> Yes.

That has scalability implications.

> > I'm not sure that's a good idea - something like a tar command can
> > create thousands of objects, all of which will start undergoing
> > state changes.
> 
> The default concurrency level for slow-work is pretty low.  Is it
> expected to be tuned to a very high value in certain configurations?

That's why I have a tuning knob.  I don't really have the facilities for
working up profiles of different loads, but I expect there's a sweet spot for
any particular load.  You have to trade the amount of time and resources it
takes to waggle the disk around off against the number of things you want to
cache.

> > Why did you do this?  Is it because cmwq does _not_ prevent reentrance to
> > executing work items?  I take it that's why you can get away with this:
> 
> and yes, I used it as a cheap way to avoid reentrance.  For most
> cases, it works just fine.  For slow work, it might not be enough.

Most cases don't think they need to avoid reentrance.  They might even be
right.  I've been bitten by it a number of times.

> > 	-	slow_work_enqueue(&object->work);
> > 	+	if (fscache_get_object(object) >= 0)
> > 	+		if (!queue_work(fscache_object_wq, &object->work))
> > 	+			fscache_put_object(object);
> > 
> > One of the reasons I _don't_ want to use the old workqueue facility is that
> > it doesn't manage reentrancy.  That can end up tying up multiple threads
> > for one long-duration work item.
> 
> Yeap, it's a drawback of the workqueue API although I don't think it
> would be big enough to warrant a completely separate workpool
> mechanism.  It's usually enough to implement synchronization from the
> callback or guarantee that running works don't get queued some other
> way.  What would happen if fscache object works are reentered?  Would
> there be correctness issues?

Definitely.  In the last rewrite, I started off by writing a thread pool that
was non-reentrant, and then built everything on top of that assumption.  This
means I don't have to do a whole bunch of locking because I _know_ each object
can only be under execution by one thread at any one time.

> How likely are they to get scheduled while being executed?

Reasonably likely, and the events aren't entirely within the control of the
local system.

> If this is something critical, I have a draft implementation which avoids
> reentrance.

If you can provide it, I can simplify RxRPC and AFS too.  Those suffer from
reentrancy issues too that I'd dearly like to avoid, but workqueues don't.

> I was gonna apply it for all works but it would cause too much cross CPU
> access when the wq users can already handle reentrance but it can be
> implemented as optional behavior along with SINGLE_CPU.

How many of them actually *handle* it?  For some of them it won't matter
because they're only scheduled once, but I bet that some of them it *is* an
issue that no one has considered, and the window of opportunity is small enough
that it's not happened or the has not been reported or successfully pinpointed.

> > Note that it would still be useful to know whether an object was queued for
> > work or being executed.
> 
> Adding wouldn't be difficult but would it justify having a dedicated
> function for that in workqueue where fscache would be the only user?
> Also please note that such information is only useful for debugging or
> as hints due to lack of synchronization.

Agreed, but debugging still has to be done sometimes.  Of course, it's much
easier for slow-work, since it has to manage reentrancy anyway, and so keeps
hold of the object till afterwards.


Oh, btw, I've run up your patches with FS-Cache.  They quickly create a couple
of hundred threads.  Is that right?  To be fair, the threads do go away again
after a period of quiscence.

David
