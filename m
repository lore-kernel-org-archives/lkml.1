Return-Path: <linux-kernel-owner+w=401wt.eu-S1756761AbXIQJLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756761AbXIQJLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 05:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbXIQI5V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:57:21 -0400
Received: from gir.skynet.ie ([193.1.99.77]:43725 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758686AbXIQI5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:57:18 -0400
Date: Mon, 17 Sep 2007 09:57:14 +0100
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070917085714.GA25706@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709111606.10873.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com> <200709120407.48344.nickpiggin@yahoo.com.au> <87zlzpqlc8.fsf@informatik.uni-tuebingen.de> <1189791772.13629.20.camel@localhost> <87tzpwlqg2.fsf@informatik.uni-tuebingen.de> <20070916211627.GE16406@skynet.ie> <87zlzm44o0.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87zlzm44o0.fsf@informatik.uni-tuebingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (17/09/07 00:38), Goswin von Brederlow didst pronounce:
> mel@skynet.ie (Mel Gorman) writes:
> 
> > On (15/09/07 02:31), Goswin von Brederlow didst pronounce:
> >> Mel Gorman <mel@csn.ul.ie> writes:
> >> 
> >> > On Fri, 2007-09-14 at 18:10 +0200, Goswin von Brederlow wrote:
> >> >> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> >> >> 
> >> >> > In my attack, I cause the kernel to allocate lots of unmovable allocations
> >> >> > and deplete movable groups. I theoretically then only need to keep a
> >> >> > small number (1/2^N) of these allocations around in order to DoS a
> >> >> > page allocation of order N.
> >> >> 
> >> >> I'm assuming that when an unmovable allocation hijacks a movable group
> >> >> any further unmovable alloc will evict movable objects out of that
> >> >> group before hijacking another one. right?
> >> >> 
> >> >
> >> > No eviction takes place. If an unmovable allocation gets placed in a
> >> > movable group, then steps are taken to ensure that future unmovable
> >> > allocations will take place in the same range (these decisions take
> >> > place in __rmqueue_fallback()). When choosing a movable block to
> >> > pollute, it will also choose the lowest possible block in PFN terms to
> >> > steal so that fragmentation pollution will be as confined as possible.
> >> > Evicting the unmovable pages would be one of those expensive steps that
> >> > have been avoided to date.
> >> 
> >> But then you can have all blocks filled with movable data, free 4K in
> >> one group, allocate 4K unmovable to take over the group, free 4k in
> >> the next group, take that group and so on. You can end with 4k
> >> unmovable in every 64k easily by accident.
> >> 
> >
> > As the mixing takes place at the lowest possible block, it's
> > exceptionally difficult to trigger this. Possible, but exceptionally
> > difficult.
> 
> Why is it difficult?
> 

Unless mlock() is being used, it is difficult to place the pages in the
way you suggest. Feel free to put together a test program that forces an
adverse fragmentation situation, it'll be useful in the future for comparing
reliability of any large block solution.

> When user space allocates memory wouldn't it get it contiously?

Not unless it's using libhugetlbfs or it's very very early in the
lifetime of the system. Even then, another process faulting at the same
time will break it up.

> I mean
> that is one of the goals, to use larger continious allocations and map
> them with a single page table entry where possible, right?

It's a goal ultimately but not what we do right now. There have been
suggestions of allocating the contiguous pages optimistically in the
fault path and later promoting with an arch-specific hook but it's
vapourware right now.

> And then
> you can roughly predict where an munmap() would free a page.
> 
> Say the application does map a few GB of file, uses madvice to tell
> the kernel it needs a 2MB block (to get a continious 2MB chunk
> mapped), waits for it and then munmaps 4K in there. A 4k hole for some
> unmovable object to fill.

With grouping pages by mobility, that 4K hole would be on the movable
free lists. To get an unmovable allocation in there, the system needs to
be under considerable stress. Even just raising min_free_kbytes a bit
would make it considerably harder.

With the standard kernel, it would be easier to place as you suggest.

> If you can then trigger the creation of an
> unmovable object as well (stat some file?) and loop you will fill the
> ram quickly. Maybe it only works in 10% but then you just do it 10
> times as often.
> 
> Over long times it could occur naturally. This is just to demonstrate
> it with malice.
> 

Try writing such a program. I'd be interested in reading it.

> > As I have stated repeatedly, the guarantees can be made but potential
> > hugepage allocation did not justify it. Large blocks might.
> >
> >> There should be a lot of preassure for movable objects to vacate a
> >> mixed group or you do get fragmentation catastrophs.
> >
> > We (Andy Whitcroft and I) did implement something like that. It hooked into
> > kswapd to clean mixed blocks. If the caller could do the cleaning, it
> > did the work instead of kswapd.
> 
> Do you have a graphic like
> http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg
> for that case?
> 

Not at the moment. I don't have any of the patches to accurately reflect
it up to date. The eviction patches have rotted to the point of
unusability.

> >> Looking at my
> >> little test program evicting movable objects from a mixed group should
> >> not be that expensive as it doesn't happen often.
> >
> > It happens regularly if the size of the block you need to keep clean is
> > lower than min_free_kbytes. In the case of hugepages, that was always
> > the case.
> 
> That assumes that the number of groups allocated for unmovable objects
> will continiously grow and shrink.

They do grow and shrink. The number of pagetables in use changes for
example.

> I'm assuming it will level off at
> some size for long times (hours) under normal operations.

It doesn't unless you assume the system remains in a steady state for it's
lifetime. Things like updatedb tend to throw a spanner into the works.

> There should
> be some buffering of a few groups to be held back in reserve when it
> shrinks to prevent the scenario that the size is just at a group
> boundary and always grows/shrinks by 1 group.
> 

And what size should this group be that all workloads function?

> >> The cost of it
> >> should be freeing some pages (or finding free ones in a movable group)
> >> and then memcpy.
> >
> > Freeing pages is not cheap. Copying pages is cheaper but not cheap.
> 
> To copy you need a free page as destination. Thats all I
> ment. Hopefully there will always be a free one and the actual freeing
> is done asynchronously from the copying.
> 

If the pages are free, finding them isn't that hard. The memory
compaction patches were able to do it.

> >> So if
> >> you evict movable objects from mixed group when needed all the
> >> pagetable pages would end up in the same mixed group slowly taking it
> >> over completly. No fragmentation at all. See how essential that
> >> feature is. :)
> >> 
> >
> > To move pages, there must be enough blocks free. That is where
> > min_free_kbytes had to come in. If you cared only about keeping 64KB
> > chunks free, it makes sense but it didn't in the context of hugepages.
> 
> I'm more concerned with keeping the little unmovable things out of the
> way. Those are the things that will fragment the memory and prevent
> any huge pages to be available even with moving other stuff out of the
> way.
> 

That's fair, just not cheap

> It would also already be a big plus to have 64k continious chunks for
> many operations. Guaranty that the filesystem and block layers can
> always get such a page (by means of copying pages out of the way when
> needed) and do even larger pages speculative.
> 

64K contiguous chunks is what Andrea's apprach seeks to do so lets see what
that looks like. Or lets see if Nick's approach makes the whole exercise
pointless

> But as you say that is where min_free_kbytes comes in. To have the
> chance of a 2MB continious free chunk you need to have much more
> reserved free. Something I would certainly do on a 16GB ram
> server. Note that the buddy system will be better at having large free
> chunks if user space allocates and frees large chunks as well.

This is true and one of the reasons that Andrea's approach will go a
long way for large blocks. This observation is also why I suggested
having slub_min_order set the same as the largeblock size when
Christophs approach was used to have this allocating/freeing of
same-sized chunks.

> It is
> much easier to make an 128K chunk out of 64K chunks than out of 4K
> chunks. Much more probable to get 2 64k chunks adjacent than 32 4K
> chunks in series.
> 
> >> > These type of pictures feel somewhat familiar
> >> > (http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg).
> >> 
> >> Those look a lot better and look like they are actually real kernel
> >> data. How did you make them and can one create them in real-time (say
> >> once a second or so)?
> >> 
> >
> > It's from a real kernel. When I was measuring this stuff, I took a
> > sample every 2 seconds.
> 
> Can you tell me how? I would like to do the same.
> 

They were generated using trace_allocmap kernel module in
http://www.csn.ul.ie/~mel/projects/vmregress/vmregress-0.81-rc2.tar.gz
in combination with frag-display in the same package.  However, in the
current version against current -mm's, it'll identify some movable pages
wrong. Specifically, it will appear to be mixing movable pages with slab
pages and it doesn't identify SLUB pages properly at all (SLUB came after
the last revision of this tool). I need to bring an annotation patch up to
date before it can generate the images correctly.

> >> There seem to be an awfull lot of pinned pages inbetween the movable.
> >
> > It wasn't grouping by mobility at the time.
> 
> That might explain at lot. I was thinking that was with grouping. But
> without grouping such a rather random distribution of unmovable
> objects doesn't sound uncommon,.
> 

It's expected even.

> >> I would verry much like to see the same data with evicting of movable
> >> pages out of mixed groups. I see not a single movable group while with
> >> strict eviction there could be at most one mixed group per order.
> >> 
> >
> > With strict eviction, there would be no mixed blocks period.
> 
> I ment on demand eviction. Not evicting the whole group just because
> we need 4k of it. Even looser would be to allow say 16 mixed groups
> before moving pages out of the way when needed for an alloc. Best to
> make it a proc entry and then change the value once a day and see how
> it behaves. :)
> 

That is a tunable I'd rather avoid because it'll be impossible to recommend
a proper value - I would sooner recommend increasing min_free_kbytes. It's
and not something I'm likely to investigate until we really know we need
it. I would prefer to see how Nick's, Christoph's and Andrea's approaches
get on before taking those type of steps.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
