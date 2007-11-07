Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbXKGGUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbXKGGUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 01:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbXKGGUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 01:20:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695AbXKGGUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 01:20:39 -0500
Date: Tue, 6 Nov 2007 22:19:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Snook <csnook@redhat.com>
Cc: porterde@cs.utexas.edu, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [RFC/PATCH] Optimize zone allocator synchronization
Message-Id: <20071106221928.f629c69f.akpm@linux-foundation.org>
In-Reply-To: <47303D07.4050404@redhat.com>
References: <20071104195212.GF16354@olive-green.cs.utexas.edu>
	<47303D07.4050404@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 06 Nov 2007 05:08:07 -0500 Chris Snook <csnook@redhat.com> wrote:
> Don Porter wrote:
> > From: Donald E. Porter <porterde@cs.utexas.edu>
> > 
> > In the bulk page allocation/free routines in mm/page_alloc.c, the zone
> > lock is held across all iterations.  For certain parallel workloads, I
> > have found that releasing and reacquiring the lock for each iteration
> > yields better performance, especially at higher CPU counts.  For
> > instance, kernel compilation is sped up by 5% on an 8 CPU test
> > machine.  In most cases, there is no significant effect on performance
> > (although the effect tends to be slightly positive).  This seems quite
> > reasonable for the very small scope of the change.
> > 
> > My intuition is that this patch prevents smaller requests from waiting
> > on larger ones.  While grabbing and releasing the lock within the loop
> > adds a few instructions, it can lower the latency for a particular
> > thread's allocation which is often on the thread's critical path.
> > Lowering the average latency for allocation can increase system throughput.
> > 
> > More detailed information, including data from the tests I ran to
> > validate this change are available at
> > http://www.cs.utexas.edu/~porterde/kernel-patch.html .
> > 
> > Thanks in advance for your consideration and feedback.
> 
> That's an interesting insight.  My intuition is that Nick Piggin's 
> recently-posted ticket spinlocks patches[1] will reduce the need for this patch, 
> though it may be useful to have both.  Can you benchmark again with only ticket 
> spinlocks, and with ticket spinlocks + this patch?  You'll probably want to use 
> 2.6.24-rc1 as your baseline, due to the x86 architecture merge.

The patch as-is would hurt low cpu-count workloads, and single-threaded
workloads: it is simply taking that lock a lot more times.  This will be
particuarly noticable on things like older P4 machines which have peculiarly
expensive locked operations.

A test to run would be, on ext2:

	time (dd if=/dev/zero of=foo bs=16k count=2048 ; rm foo)

(might need to increase /proc/sys/vm/dirty* to avoid any writeback)


I wonder if we can do something like:

	if (lock_is_contended(lock)) {
		spin_unlock(lock);
		spin_lock(lock);		/* To the back of the queue */
	}

(in conjunction with the ticket locks) so that we only do the expensive
buslocked operation when we actually have a need to do so.

(The above should be wrapped in some new spinlock interface function which
is probably a no-op on architectures which cannot implement it usefully)
