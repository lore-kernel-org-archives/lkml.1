Return-Path: <linux-kernel-owner+w=401wt.eu-S933234AbYA2RFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234AbYA2RFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754397AbYA2RFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:05:44 -0500
Received: from smtp.cs.utexas.edu ([128.83.120.210]:49997 "EHLO
	smtp.cs.utexas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbYA2RFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:05:43 -0500
X-Greylist: delayed 1984 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 12:05:43 EST
Date: Tue, 29 Jan 2008 10:31:48 -0600
From: Don Porter <porterde@cs.utexas.edu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Chris Snook <csnook@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] Optimize zone allocator synchronization
Message-ID: <20080129163148.GA23405@olive-green.cs.utexas.edu>
References: <20071104195212.GF16354@olive-green.cs.utexas.edu> <47303D07.4050404@redhat.com> <20071106221928.f629c69f.akpm@linux-foundation.org> <200711071632.00055.nickpiggin@yahoo.com.au> <20071118053626.GC21569@olive-green.cs.utexas.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071118053626.GC21569@olive-green.cs.utexas.edu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize again for the long delay in responding with the requested
additional data needed to understand the performance of this patch.
The complete information is available at:

http://www.cs.utexas.edu/~porterde/kernel-patch.html#subsequent

I instrumented the kernel within simics to determine that the mean
value of the count is 7 and the order is 0 for both free_pages_bulk()
and rmqueue_bulk() for the simulation workloads.

I applied the change suggested by Andrew Morton to the 2.6.24-rc7
kernel patched with Nick Piggin's ticket spinlock patch.

These data indicate that there is a small performance penalty (1-2%)
incurred when adding ticket spinlocks alone, probably because they are
not used enough in the kernel to reap the performance benefits of the
implementation cost.  By allowing the lock to be released and
reacquired under contention in just these two places, the 1-2%
overhead of ticket spin performance is reclaimed in most benchmarks,
making overall performance comparable to the baseline kernel.

The only data inconsistent with these results are the kernel
compilation benchmarks.  These data indicate that the best performance
is from the baseline kernel.  It is not clear to me what property of
kernel compilation causes it to have this performance profile.

Placing the zone spin lock in its own cache line hurts performance.

The dd regression test actually shows a similar trend to the other
benchmarks; ticket spinlocks + my patch perform best.

Thanks for your comments and consideration,

Don Porter

On Sat, Nov 17, 2007 at 11:36:26PM -0600, Don Porter wrote:
> Thank you all for your consideration and insightful responses to my
> posting.  I apologize for not responding sooner---I have been under a
> deadline.
> 
> It seems clear that further investigation will be needed to understand
> these performance numbers better.
> 
> To summarize, I understand that the following experiments will be helpful:
> 
> 1) Instrument the allocation code to determine the common size/order
> of the allocations for these workloads.
> 
> 2) Try to integrate these changes with ticket spinlocks
> 
> 3) Try placing the zone lock in its own cacheline
> 
> 4) Look for single-threaded regressions (dd benchmark).
> 
> I'll do these at my first opportunity, hopefully within the next week.
> Please let me know if I misunderstood any of your comments.
> 
> My intuition about the cost of ping-ponging the lock's cache line
> certainly matched yours, so I was very surprised to see these
> performance numbers.  
> 
> On Wed, Nov 07, 2007 at 04:31:59PM +1100, Nick Piggin wrote:
> > It's funny, Dave Miller and I were just talking about the possible
> > reappearance of zone->lock contention with massively multi core and
> > multi threaded CPUs. I think the right way to fix this in the long run
> > if it turns into a real problem, is something like having a lock per
> > MAX_ORDER block, and having CPUs prefer to allocate from different
> > blocks. Anti-frag makes this pretty interesting to implement, but it
> > will be possible.
> 
> As a bit of background, the zone lock is indeed one of the more
> contended locks in my target workloads so it was no accident that I
> was looking for ways to improve its scalability.  I am quite
> interested in Nick's ideas about how to split up the zone allocator's
> synchronization.
> 
> Of course, these contention levels may not meet your definition of
> "real problem" (~.1% of the execution time).
> 
> Best regards,
> Don
