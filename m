Return-Path: <linux-kernel-owner+w=401wt.eu-S933699AbXDZJQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699AbXDZJQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933753AbXDZJQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:16:36 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:46672 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933699AbXDZJQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:16:35 -0400
Date: Thu, 26 Apr 2007 10:16:33 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426091632.GA27620@skynet.ie>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252328340.30340@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704252328340.30340@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (25/04/07 23:37), Christoph Lameter didst pronounce:
> On Wed, 25 Apr 2007, Eric W. Biederman wrote:
> 
> > You are trying to couple something that has no business being coupled
> > as it reduces the system usability when you couple them.
> 
> What I am coupling? The approach solves a series of issues as far as I can 
> tell.
> 
> > > But that is due to the VM (at least Linus tree) having no defrag methods.
> > > mm has Mel's antifrag methods and can do it.
> > 
> > This is fundamental.  Fragmentation when you multiple chunk sizes
> > cannot be solved without a the ability to move things in memory,
> > whereas it doesn't exist when you only have a single chunk size.
> 
> We have that ability (although in a limited form) right now.
>  

And grouping pages by mobility works best when the majority of memory is
used as page cache and other movable/reclaimable allocations which it be
for the majority of workloads that care about larger blocksizes. If a 
failure case is found, the memory partitioning is there to give hard
guarantees until I figure out what went wrong.

> > > Yes you get lots of small request *because* we do not support defrag and 
> > > cannot large contiguous allocations.
> > 
> > Lots of small requests are fundamental.  If lots of small requests were
> > not fundamental we would gets large requests scatter gather requests.
> 
> That is a statement of faith in small requests? Small requests are 
> fundamental so we want them?
> 
> > > Ummm the other arches read 16k blocks of contigous memory. That is not 
> > > supported on 4k platforms right now. I guess you you move those to vmalloc 
> > > areas? Want to hack the filesystems for this?
> > 
> > Freak no.  You teach the code how to have a block in multiple physical
> > pages. 
> 
> This aint gonna work without something that stores the information about 
> how the pieces come together. Teach the code.... More hacks.
>  
> > > There are multiple scaling issues in the kernel. What you propose is to 
> > > add hack over hack into the VM to avoid having to deal with 
> > > defragmentation. That in turn will cause churn with hardware etc
> > > etc.
> > 
> > No. I propose to avoid all designs that have the concept of
> > fragmentation.
> 
> There are such designs? You can limit fragmentation but not avoid it.
> 

Indeed, it can't be eliminated unless all memory is movable which isn't.
That's why grouping pages by mobility keeps migratable+reclaimable memory
in one set of blocks and reclaimable (mainly slab) in a second set on the
knowledge that truely unmovable allocations are rare.

Heuristic it might be, but I expect it'll work well in practice. This sort
of patchset will put the fragmentation avoidance under more pressure than I
was expecting so problems will be found sooner rather than later. It's also
worth bearing in mind that the high-order allocations looked for here are
in the order 3 or 4 level instead of the order-9 and order-10 allocations
that I normally test with and get reasonably high success rates for.

Besides, we've seen that with the normal kernel that order-3 allocations
(e1000 jumbo frames) work longer than one would expect without fragmentation
avoidance and they are atomic allocations as well as everything else.  With
fragmentation avoidance, we should be able to handle it although I'll admit
that jumbo frame allocations are nowhere near as long lived. If I'm wrong,
the allocation failure bug reports will roll in in a very obvious manner.

> > There is an argument for having struct page control more than 4K
> > of memory even when the hardware page size is 4K.  But that is a
> > separate problem.  And by only having one size we still don't
> > get fragmentation.
> 
> We have fragmentation because we cannot limit our allocation sizes to 4k. 
> The stack is already 8k and there are subsystems that need more (f.e. 
> for jumbo frames). Then there is the huge page subsystem that is used to 
> avoid the TLB pressure that comes with small pages.
> 
> I think we are doing our typical community thing of running away from the 
> problem and developing ways to explain why our traditional approaches are 
> right.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
