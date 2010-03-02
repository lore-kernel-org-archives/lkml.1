Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab0CBLZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 06:25:08 -0500
Received: from gir.skynet.ie ([193.1.99.77]:36877 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab0CBLZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 06:25:06 -0500
Date: Tue, 2 Mar 2010 11:24:48 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       epasch@de.ibm.com, SCHILLIG@de.ibm.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, christof.schmitt@de.ibm.com,
       thoss@de.ibm.com, hare@suse.de, gregkh@novell.com
Subject: Re: Performance regression in scsi sequential throughput (iozone)
	due to "e084b - page-allocator: preserve PFN ordering when
	__GFP_COLD is set"
Message-ID: <20100302112448.GJ3852@csn.ul.ie>
References: <4B7BBCFC.4090101@linux.vnet.ibm.com> <20100218114310.GC32626@csn.ul.ie> <4B7D664C.20507@linux.vnet.ibm.com> <4B7E73BF.5030901@linux.vnet.ibm.com> <20100219151934.GA1445@csn.ul.ie> <20100302065225.GC8653@laptop> <20100302100402.GH3852@csn.ul.ie> <20100302103646.GF8653@laptop> <20100302110149.GI3852@csn.ul.ie> <20100302111827.GI8653@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100302111827.GI8653@laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 10:18:27PM +1100, Nick Piggin wrote:
> On Tue, Mar 02, 2010 at 11:01:50AM +0000, Mel Gorman wrote:
> > On Tue, Mar 02, 2010 at 09:36:46PM +1100, Nick Piggin wrote:
> > > On Tue, Mar 02, 2010 at 10:04:02AM +0000, Mel Gorman wrote:
> > > > On Tue, Mar 02, 2010 at 05:52:25PM +1100, Nick Piggin wrote:
> > > > > The zone pressure waitqueue patch makes sense.
> > > > 
> > > > I've just started the rebase and considering what sort of test is best
> > > > for it.
> > > > 
> > > > > We may even want to make
> > > > > it more strictly FIFO (eg. check upfront if there are waiters on the
> > > > > queue before allocating a page, and if yes then add ourself to the back
> > > > > of the waitqueue).
> > > > 
> > > > To be really strict about this, we'd have to check in the hot-path of the
> > > > per-cpu allocator which would be undesirable.
> > > 
> > > Yes, but it would also be desirable for other reasons (eliminating
> > > all unnecessary latency here). Which is why I say it is a tradeoff
> > > but it might be worthwhile.
> > > 
> > > We obviously wouldn't load the waitqueue itself in the fastpath, but
> > > probably some field in a cacheline we already touch.
> > > 
> > 
> > I'm struggling to justify it in my head. Granted, right now the pressure_wq is
> > located beside the wait_table as a "rarely-used" field. It could be located
> > before the free_area[] so it would be pulled in which would have some impact
> > for the high-order lists but probably not too bad. This would make
> > accessing pressure_wq a little cheaper.
> 
> No you would mark it in another field in the slowpath.
> 

i.e. a flag in zone->flags that is set if something is waiting on the queue?

> It would be justified if the aggregate cost of the work is outweighed
> by the reduction in unnecessary wait time in the congestion code, plus
> some unquantifiable goodness from the extra fairness.
> 
> Obviously that depends on the workload, but so does every change we
> do like this.
>  

True. I'll sketch out what needs to happen along these lines and see
what it looks like.

> > The impact of *not* checking is unfairness. A late process makes forward
> > progress while others sleep on a queue waiting for a reclaim pass to finish
> > and the queue to be woken up. At worst, processes continue sleeping for the
> > entire timeout because late processes kept the zone below the watermark.
> > 
> > Is a little unfairness in a path concerned with heavy memory pressure
> > enough to justify checking on every page allocation?
> 
> Well, we've had patches that do a lot more than that in the allocator
> that most people don't really use :) (and they've had relatively small
> impact).
> 
> But no, it adds at least another branch, icache cost, and at least one
> more memory bit in the fastpath. Obviously that's a drawback.
> 

Of which the branch would be the greatest concern but it's also a very
unlikely branch.

> > > > We could check further in the
> > > > slow-path but I bet it'd be very rare that the logic would be triggered. For
> > > > a process to enter the FIFO due to waiters that were not yet woken up, the
> > > > system would have to be a) under heavy memory pressure b) reclaim taking such
> > > > a long time that check_zone_pressure() is not being called in time and c)
> > > > a process exiting or otherwise freeing memory such that the watermarks are
> > > > cleared without reclaim being involved.
> > > 
> > > I don't think it would be too rare. Things can get freed up and
> > > other allocations come in while reclaim is happening. But anyway
> > > the nasty thing about the "rare" events is that they do add a
> > > rare source of unexpected latency or starvation.
> > > 
> > 
> > If processes are asleep on the waitqueue, reclaim must be active (by kswapd
> > if nothing else). If pages are getting freed above the necessary watermark,
> > then the processes will be woken up when the current shrink_zone() finished
> > unless unfair processes are keeping the zone below watermarks.  But unless
> > reclaim is taking an extraordinary long length of time, there would be little
> > difference between waking the queue in the free path and waking it in the
> > reclaim path.
> 
> Reclaim can take quite a while, yes.
> 
>  
> > Again, is a little unfairness under heavy memory pressure enough to
> > alter the main paths?
> 
> Well you didn't let me answer yet :) See above.
> 
>  
> > > I'm not saying necessarily that it will make a noticable improvement
> > > to throughput for this test case, but that now that we have the
> > > waitqueue there, we should think about exactly how far we want to
> > > go with it.
> > 
> > Fair point but I'd sooner look at the other places the VM waits on timeouts
> > and see can they be converted to waiting on events. Just in case, after these
> > tests complete (and assuming they generate usable figures), I'll prototype
> > some of the suggestions and see what the impact is.
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
