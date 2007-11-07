Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbXKGHi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbXKGHi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 02:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997AbXKGHis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 02:38:48 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:36154 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752357AbXKGHir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 02:38:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mT9xQ1uSMkz7ikE34E1ihCTCE2OcJQxdghHTDl5N0lNP60z8jS2FTyfMR5p/FafYKz/Ya74lYanD5lA4k+d1JDllu1/q0GX5GlfN50gtiNBEf3shC5go2GKw+RSmPB94OYuAcY325Xn6jukmILxldgTQyEsVcASbo//8UihQvF0=  ;
X-YMail-OSG: W9M4pVEVM1kpvi4fkqQFbBTT3Dzd2c8G6cBHB7uA7LFdL2gp.2Gt9eXBzNqwa28fihdHfjEyrIXwTCT2QsSBoLmNm.fBhrBksasDAKeEb74lT6v8En7U49jnZdpD0w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC/PATCH] Optimize zone allocator synchronization
Date: Wed, 7 Nov 2007 16:31:59 +1100
User-Agent: KMail/1.9.5
Cc: Chris Snook <csnook@redhat.com>, porterde@cs.utexas.edu,
       linux-kernel@vger.kernel.org
References: <20071104195212.GF16354@olive-green.cs.utexas.edu> <47303D07.4050404@redhat.com> <20071106221928.f629c69f.akpm@linux-foundation.org>
In-Reply-To: <20071106221928.f629c69f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711071632.00055.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 November 2007 17:19, Andrew Morton wrote:
> > On Tue, 06 Nov 2007 05:08:07 -0500 Chris Snook <csnook@redhat.com> wrote:
> >
> > Don Porter wrote:
> > > From: Donald E. Porter <porterde@cs.utexas.edu>
> > >
> > > In the bulk page allocation/free routines in mm/page_alloc.c, the zone
> > > lock is held across all iterations.  For certain parallel workloads, I
> > > have found that releasing and reacquiring the lock for each iteration
> > > yields better performance, especially at higher CPU counts.  For
> > > instance, kernel compilation is sped up by 5% on an 8 CPU test
> > > machine.  In most cases, there is no significant effect on performance
> > > (although the effect tends to be slightly positive).  This seems quite
> > > reasonable for the very small scope of the change.
> > >
> > > My intuition is that this patch prevents smaller requests from waiting
> > > on larger ones.  While grabbing and releasing the lock within the loop
> > > adds a few instructions, it can lower the latency for a particular
> > > thread's allocation which is often on the thread's critical path.
> > > Lowering the average latency for allocation can increase system
> > > throughput.
> > >
> > > More detailed information, including data from the tests I ran to
> > > validate this change are available at
> > > http://www.cs.utexas.edu/~porterde/kernel-patch.html .
> > >
> > > Thanks in advance for your consideration and feedback.

I did see this initial post, and didn't quite know what to make of it.
I'll admit it is slightly unexpected :) Always good to research ideas
against common convention, though.

I don't know whether your reasoning is correct though: unless there is
a significant number of higher order allocations (which there should
not be, AFAIKS), all allocators will go through the per CPU lists which
batch the same number of objects on and off, so there is no such thing
as smaller or larger requests.

And there are a number of regressions as well in your tests. It would be
nice to get some more detailed profile numbers (preferably with an
upstream kernel) to try to work out what is going faster.

It's funny, Dave Miller and I were just talking about the possible
reappearance of zone->lock contention with massively multi core and
multi threaded CPUs. I think the right way to fix this in the long run
if it turns into a real problem, is something like having a lock per
MAX_ORDER block, and having CPUs prefer to allocate from different
blocks. Anti-frag makes this pretty interesting to implement, but it
will be possible.


> > That's an interesting insight.  My intuition is that Nick Piggin's
> > recently-posted ticket spinlocks patches[1] will reduce the need for this
> > patch, though it may be useful to have both.  Can you benchmark again
> > with only ticket spinlocks, and with ticket spinlocks + this patch? 
> > You'll probably want to use 2.6.24-rc1 as your baseline, due to the x86
> > architecture merge.
>
> The patch as-is would hurt low cpu-count workloads, and single-threaded
> workloads: it is simply taking that lock a lot more times.  This will be
> particuarly noticable on things like older P4 machines which have
> peculiarly expensive locked operations.

It's not even restricted to P4s -- another big cost is going to be the
cacheline pingpong. Actually it might be worth trying another test run
with zone->lock put into its own cacheline (as it stands, when the lock
gets contended, spinners will just sit there pushing useful fields out
of the holder's memory -- ticket locks will do better here, but they
still write to the lock once, then sit there loading it).


> A test to run would be, on ext2:
>
> 	time (dd if=/dev/zero of=foo bs=16k count=2048 ; rm foo)
>
> (might need to increase /proc/sys/vm/dirty* to avoid any writeback)
>
>
> I wonder if we can do something like:
>
> 	if (lock_is_contended(lock)) {
> 		spin_unlock(lock);
> 		spin_lock(lock);		/* To the back of the queue */
> 	}
>
> (in conjunction with the ticket locks) so that we only do the expensive
> buslocked operation when we actually have a need to do so.
>
> (The above should be wrapped in some new spinlock interface function which
> is probably a no-op on architectures which cannot implement it usefully)

We have the need_lockbreak stuff. Of course, that's often pretty useless
with regular spinlocks (when you consider that my tests show that a single
CPU can be allowed to retake the same lock several million times in a row
despite contention)...

Anyway, yeah we could do that. But I think we do actually want to batch
up allocations on a given CPU in the multithreaded case as well, rather
than interleave them. There are some benefits avoiding cacheline bouncing.
