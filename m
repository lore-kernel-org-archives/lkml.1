Return-Path: <linux-kernel-owner+w=401wt.eu-S966757AbXIKUyI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966757AbXIKUyI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 16:54:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965029AbXIKUxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 16:53:55 -0400
Received: from gir.skynet.ie ([193.1.99.77]:34471 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763185AbXIKUxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 16:53:54 -0400
Date: Tue, 11 Sep 2007 21:53:50 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911205350.GA18127@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <1189524967.32731.58.camel@localhost> <200709111144.48743.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200709111144.48743.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (11/09/07 11:44), Nick Piggin didst pronounce:
> On Wednesday 12 September 2007 01:36, Mel Gorman wrote:
> > On Tue, 2007-09-11 at 04:52 +1000, Nick Piggin wrote:
> > > On Tuesday 11 September 2007 16:03, Christoph Lameter wrote:
> > > > 5. VM scalability
> > > >    Large block sizes mean less state keeping for the information being
> > > >    transferred. For a 1TB file one needs to handle 256 million page
> > > >    structs in the VM if one uses 4k page size. A 64k page size reduces
> > > >    that amount to 16 million. If the limitation in existing filesystems
> > > >    are removed then even higher reductions become possible. For very
> > > >    large files like that a page size of 2 MB may be beneficial which
> > > >    will reduce the number of page struct to handle to 512k. The
> > > > variable nature of the block size means that the size can be tuned at
> > > > file system creation time for the anticipated needs on a volume.
> > >
> > > There is a limitation in the VM. Fragmentation. You keep saying this
> > > is a solved issue and just assuming you'll be able to fix any cases
> > > that come up as they happen.
> > >
> > > I still don't get the feeling you realise that there is a fundamental
> > > fragmentation issue that is unsolvable with Mel's approach.
> >
> > I thought we had discussed this already at VM and reached something
> > resembling a conclusion. It was acknowledged that depending on
> > contiguous allocations to always succeed will get a caller into trouble
> > and they need to deal with fallback - whether the problem was
> > theoritical or not. It was also strongly pointed out that the large
> > block patches as presented would be vunerable to that problem.
> 
> Well Christoph seems to still be spinning them as a solution for VM
> scalability and first class support for making contiguous IOs, large
> filesystem block sizes etc.
> 

Yeah, I can't argue with you there. I was under the impression that we
would be dealing with this strictly as a second class solution to see
what it bought to help steer the direction of fsblock.

> At the VM summit I think the conclusion was that grouping by
> mobility could be merged. I'm still not thrilled by that, but I was
> going to get steamrolled[*] anyway... and seeing as the userspace
> hugepages is a relatively demanded workload and can be
> implemented in this way with basically no other changes to the
> kernel and already must have fallbacks.... then that's actually a
> reasonable case for it.
> 

As you say, a difference is if we fail to allocate a hugepage, the world
does not end. It's been a well known problem for years and grouping pages
by mobility is aimed at relaxing some of the more painful points. It has
other uses as well, but each of them is expected to deal with failures with
contiguous range allocation.

> The higher order pagecache, again I'm just going to get steamrolled
> on, and it actually isn't so intrusive minus the mmap changes, so I
> didn't have much to reasonably say there.
> 

If the mmap() change is bad, then it gets halted up.

> And I would have kept quiet this time too, except for the worrying idea
> to use higher order pages to fix the SLUB vs SLAB regression, and if
> the rationale for this patchset was more realistic.
> 

I don't agree with using higher order pages to fix SLUB vs SLAB performance
issues either. SLUB has to be able to compete with SLAB on it's own terms. If
SLUB gains x% over SLAB in specialised cases with high orders, then fair
enough but minimally, SLUB has to perform the same as SLAB at order-0. Like
you, I think if we depend on SLUB using high orders to match SLAB, we are
going to get kicked further down the line.

However, this discussion belongs more with the non-existant-remove-slab patch.
Based on what we've seen since the summits, we need a thorough analysis
with benchmarks before making a final decision (kernbench, ebizzy, tbench
(netpipe if someone has the time/resources), hackbench and maybe sysbench
as well as something the filesystem people recommend to get good coverage
of the subsystems).

> [*] And I don't say steamrolled because I'm bitter and twisted :) I
> personally want the kernel to be perfect. But I realise it already isn't
> and for practical purposes people want these things, so I accept
> being overruled, no problem. The fact simply is -- I would have been
> steamrolled I think :P
> 

I'd rather not get side-tracked here. I regret you feel stream-rolled but I
think grouping pages by mobility is the right thing to do for better usage
of the TLB by the kernel and for improving hugepage support in userspace
minimally. We never really did see eye-to-eye but this way, if I'm wrong
you get to chuck eggs down the line.

> > The alternatives were fs-block and increasing the size of order-0. It
> > was felt that fs-block was far away because it's complex and I thought
> > that increasing the pagesize like what Andrea suggested would lead to
> > internal fragmentation problems. Regrettably we didn't discuss Andrea's
> > approach in depth.
> 
> Sure. And some people run workloads where fragmentation is likely never
> going to be a problem, they are shipping this poorly configured hardware
> now or soon, so they don't have too much interest in doing it right at this
> point, rather than doing it *now*. OK, that's a valid reason which is why I
> don't use the argument that we should do it correctly or never at all.
> 

So are we saying the right thing to do is go with fs-block from day 1 once we
get it to optimistically use high-order pages? I think your concern might be
that if this goes in then it'll be harder to justify fsblock in the future
because it'll be solving a theoritical problem that takes months to trigger
if at all. i.e. The filesystem people will push because apparently large
block support as it is solves world peace. Is that accurate?

> 
> > I *thought* that the end conclusion was that we would go with
> > Christoph's approach pending two things being resolved;
> >
> > o mmap() support that we agreed on is good
> 
> In theory (and again for the filesystem guys who don't have to worry about
> it). In practice after seeing the patch it's not a nice thing for the VM to
> have to do.
> 

That may be a good enough reason on it's own to delay this. It's a
technical provable point.

> 
> > I also thought there was an acknowledgement that long-term, fs-block was
> > the way to go - possibly using contiguous pages optimistically instead
> > of virtual mapping the pages. At that point, it would be a general
> > solution and we could remove the warnings.
> 
> I guess it is still in the air. I personally think a vmapping approach and/or
> teaching filesystems to do some nonlinear block metadata access is the
> way to go (strangely, this happens to be one of the fsblock paradigms!).

What a co-incidence :)

> OTOH, I'm not sure how much buy-in there was from the filesystems guys.
> Particularly Christoph H and XFS (which is strange because they already do
> vmapping in places).
> 

I think they use vmapping because they have to, not because they want
to. They might be a lot happier with fsblock if it used contiguous pages
for large blocks whenever possible - I don't know for sure. The metadata
accessors they might be unhappy with because it's inconvenient but as
Christoph Hellwig pointed out at VM/FS, the filesystems who really care
will convert.

> That's understandable though. It is a lot of work for filesystems. But the
> reason I think it is the correct approach for larger block than soft-page
> size is that it doesn't have fundamental issues (assuming that virtually
> mapping the entire kernel is off the table).
> 

Virtually mapping the entire kernel is still off the table. We don't have
recent figures but the last measured slowdown I'm aware of was in the 5-10%
range for kernbench when we break 1:1 virt:phys mapping althought that
may be because we also lose hugepage backing of the kernel portion of the
address space. I didn't look deeply at the time because it was bad
whatever the root cause.

> > Basically, to start out with, this was going to be an SGI-only thing so
> > they get to rattle out the issues we expect to encounter with large
> > blocks and help steer the direction of the
> > more-complex-but-safer-overall fs-block.
> 
> That's what I expected, but it seems from the descriptions in the patches
> that it is also supposed to cure cancer :)
> 

heh, fair enough. I guess that minimally, the leaders need warnings all
over the place as well or else we're going back to the drawing board or all
getting behind fs-block (or Andrea's of it comes to that) and pushing.

> 
> > > The idea that there even _is_ a bug to fail when higher order pages
> > > cannot be allocated was also brushed aside by some people at the
> > > vm/fs summit.
> >
> > When that brushing occured, I thought I made it very clear what the
> > expectations were and that without fallback they would be taking a risk.
> > I am not sure if that message actually sank in or not.
> 
> No, you have been good about that aspect. I wasn't trying to point to you
> at all here.
> 
> 
> > >  I don't know if those people had gone through the
> > > math about this, but it goes somewhat like this: if you use a 64K
> > > page size, you can "run out of memory" with 93% of your pages free.
> > > If you use a 2MB page size, you can fail with 99.8% of your pages
> > > still free. That's 64GB of memory used on a 32TB Altix.
> >
> > That's the absolute worst case but yes, in theory this can occur and
> > it's safest to assume the situation will occur somewhere to someone. It
> > would be difficult to craft an attack to do it but conceivably a machine
> > running for a long enough time would trigger it particularly if the
> > large block allocations are GFP_NOIO or GFP_NOFS.
> 
> It would be interesting to craft an attack. If you knew roughly the layout
> and size of your dentry slab for example... maybe you could stat a whole
> lot of files, then open one and keep it open (maybe post the fd to a unix
> socket or something crazy!) when you think you have filled up a couple
> of MB worth of them.

I might regret saying this, but it would be easier to craft an attack
using pagetable pages. It's woefully difficult to do but it's probably
doable. I say pagetables because while slub targetted reclaim is on the
cards and memory compaction exists for page cache pages, pagetables are
currently pinned with no prototype patch existing to deal with them.

> Repeat the process until your movable zone is
> gone. Or do the same things with pagetables, or task structs, or radix
> tree nodes, etc.. these are the kinds of things I worry about (as well as
> just the gradual natural degredation).
> 

If we hit this problem at all, it'll be due to gradual natural degredation.
It used to be a case that jumbo ethernets reported problems after running
for weeks and we might encounter something similar with large blocks while it
lacks a fallback. We no longer see jumbo ethernet reports but the fact is we
don't know if it's because we fixed it or people gave up. Chances are people
will be more persistent with large blocks than they were with jumbo ethernet.

> Yeah, it might be reasonably possible to make an attack that would
> deplete most of higher order allocations while pinning somewhat close
> to just the theoretical minimum required.
> 
> [snip]
> 
> Thanks Mel. Fairly good summary I think.
> 
> 
> > > Basically, if you're placing your hopes for VM and IO scalability on
> > > this, then I think that's a totally broken thing to do and will end up
> > > making the kernel worse in the years to come (except maybe on some poor
> > > configurations of bad hardware).
> >
> > My magic 8-ball is in the garage.
> >
> > I thought the following plan was sane but I could be la-la
> >
> > 1. Go with large block + explosions to start with
> >    - Second class feature at this point, not fully supported
> >    - Experiment in different places to see what it gains (if anything)
> > 2. Get fs-block in slowly over time with the fallback options replacing
> >    Christophs patches bit by bit
> > 3. Kick away warnings
> >    - First class feature at this point, fully supported
> 
> I guess that was my hope. The only problem I have with a 2nd class
> higher order pagecache on a *practical* technical issue is introducing
> more complexity in the VM for mmap. Andrea and Hugh are probably
> more guardians of that area of code than I, so if they're happy with the
> mmap stuff then again I can accept being overruled on this ;)
> 

I'm happy to go with their decision on this one as well unless Andrea says
he hates it simply on the grounds he wants the PAGE_SIZE_SHIFT solution :)

> Then I would love to say #2 will go ahead (and I hope it would), but I
> can't force it down the throat of the filesystem maintainers just like I
> feel they can't force vm devs (me) to do a virtually mapped and
> defrag-able kernel :) Basically I'm trying to practice what I preach and
> I don't want to force fsblock onto anyone.
> 

If the FS people really want it and they insist that this has to be a
#1 citizen then it's fsblock or make something new up. I'm still not 100%
convinced that Andrea's solution is immune from fragmentation problems. Also,
I don't think a virtually mapped and 100% defraggable kernel is going to
perform very well or I'd have gone down that road already.

> Maybe when ext2 is converted and if I can show it isn't a performance
> problem / too much complexity then I'll have another leg to stand on
> here... I don't know.
> 

Even if the conversion is hard but only a few days work per filesystem,
it's difficult to argue against on any grounds other than name calling.

> > Independently of that, we would work on order-0 scalability,
> > particularly readahead and batching operations on ranges of pages as
> > much as possible.
> 
> Definitely. Also, aops capable of spanning multiple pages, batching of
> large write(2) pagecache insertion, etc all are things we must go after,
> regardless of the large page and/or block size work.
> 

Agreed.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
