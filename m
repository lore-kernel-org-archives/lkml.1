Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbXIPVQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbXIPVQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 17:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753182AbXIPVQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 17:16:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:51771 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbXIPVQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 17:16:30 -0400
Date: Sun, 16 Sep 2007 22:16:27 +0100
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
Message-ID: <20070916211627.GE16406@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709111606.10873.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709111448430.27023@schroedinger.engr.sgi.com> <200709120407.48344.nickpiggin@yahoo.com.au> <87zlzpqlc8.fsf@informatik.uni-tuebingen.de> <1189791772.13629.20.camel@localhost> <87tzpwlqg2.fsf@informatik.uni-tuebingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <87tzpwlqg2.fsf@informatik.uni-tuebingen.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (15/09/07 02:31), Goswin von Brederlow didst pronounce:
> Mel Gorman <mel@csn.ul.ie> writes:
> 
> > On Fri, 2007-09-14 at 18:10 +0200, Goswin von Brederlow wrote:
> >> Nick Piggin <nickpiggin@yahoo.com.au> writes:
> >> 
> >> > In my attack, I cause the kernel to allocate lots of unmovable allocations
> >> > and deplete movable groups. I theoretically then only need to keep a
> >> > small number (1/2^N) of these allocations around in order to DoS a
> >> > page allocation of order N.
> >> 
> >> I'm assuming that when an unmovable allocation hijacks a movable group
> >> any further unmovable alloc will evict movable objects out of that
> >> group before hijacking another one. right?
> >> 
> >
> > No eviction takes place. If an unmovable allocation gets placed in a
> > movable group, then steps are taken to ensure that future unmovable
> > allocations will take place in the same range (these decisions take
> > place in __rmqueue_fallback()). When choosing a movable block to
> > pollute, it will also choose the lowest possible block in PFN terms to
> > steal so that fragmentation pollution will be as confined as possible.
> > Evicting the unmovable pages would be one of those expensive steps that
> > have been avoided to date.
> 
> But then you can have all blocks filled with movable data, free 4K in
> one group, allocate 4K unmovable to take over the group, free 4k in
> the next group, take that group and so on. You can end with 4k
> unmovable in every 64k easily by accident.
> 

As the mixing takes place at the lowest possible block, it's
exceptionally difficult to trigger this. Possible, but exceptionally
difficult.

As I have stated repeatedly, the guarantees can be made but potential
hugepage allocation did not justify it. Large blocks might.

> There should be a lot of preassure for movable objects to vacate a
> mixed group or you do get fragmentation catastrophs.

We (Andy Whitcroft and I) did implement something like that. It hooked into
kswapd to clean mixed blocks. If the caller could do the cleaning, it
did the work instead of kswapd.

> Looking at my
> little test program evicting movable objects from a mixed group should
> not be that expensive as it doesn't happen often.

It happens regularly if the size of the block you need to keep clean is
lower than min_free_kbytes. In the case of hugepages, that was always
the case.

> The cost of it
> should be freeing some pages (or finding free ones in a movable group)
> and then memcpy.

Freeing pages is not cheap. Copying pages is cheaper but not cheap.

> With my simplified simulation it never happens so I
> expect it to only happen when the work set changes.
> 
> >> > And it doesn't even have to be a DoS. The natural fragmentation
> >> > that occurs today in a kernel today has the possibility to slowly push out
> >> > the movable groups and give you the same situation.
> >> 
> >> How would you cause that? Say you do want to purposefully place one
> >> unmovable 4k page into every 64k compund page. So you allocate
> >> 4K. First 64k page locked. But now, to get 4K into the second 64K page
> >> you have to first use up all the rest of the first 64k page. Meaning
> >> one 4k chunk, one 8k chunk, one 16k cunk, one 32k chunk. Only then
> >> will a new 64k chunk be broken and become locked.
> >
> > It would be easier early in the boot to mmap a large area and fault it
> > in in virtual address order then mlock every a page every 64K. Early in
> > the systems lifetime, there will be a rough correlation between physical
> > and virtual memory.
> >
> > Without mlock(), the most successful attack will like mmap() a 60K
> > region and fault it in as an attempt to get pagetable pages placed in
> > every 64K region. This strategy would not work with grouping pages by
> > mobility though as it would group the pagetable pages together.
> 
> But even with mlock the virtual pages should still be movable.

They are. The Memory Compaction patches were able to do the job.

> So if
> you evict movable objects from mixed group when needed all the
> pagetable pages would end up in the same mixed group slowly taking it
> over completly. No fragmentation at all. See how essential that
> feature is. :)
> 

To move pages, there must be enough blocks free. That is where
min_free_kbytes had to come in. If you cared only about keeping 64KB
chunks free, it makes sense but it didn't in the context of hugepages.

> > Targetted attacks on grouping pages by mobility are not very easy and
> > not that interesting either. As Nick suggests, the natural fragmentation
> > over long periods of time is what is interesting.
> >
> >> So to get the last 64k chunk used all previous 32k chunks need to be
> >> blocked and you need to allocate 32k (or less if more is blocked). For
> >> all previous 32k chunks to be blocked every second 16k needs to be
> >> blocked. To block the last of those 16k chunks all previous 8k chunks
> >> need to be blocked and you need to allocate 8k. For all previous 8k
> >> chunks to be blocked every second 4k page needs to be used. To alloc
> >> the last of those 4k pages all previous 4k pages need to be used.
> >> 
> >> So to construct a situation where no continious 64k chunk is free you
> >> have to allocate <total mem> - 64k - 32k - 16k - 8k - 4k (or there
> >> about) of memory first. Only then could you free memory again while
> >> still keeping every 64k page blocked. Does that occur naturally given
> >> enough ram to start with?
> >> 
> >
> > I believe it's very difficult to craft an attack that will work in a
> > short period of time. An attack that worked on 2.6.22 as well may have
> > no success on 2.6.23-rc4-mm1 for example as grouping pages by mobility
> > does it make it exceedingly hard to craft an attack unless the attacker
> > can mlock large amounts of memory.
> >
> >> 
> >> Too see how bad fragmentation could be I wrote a little progamm to
> >> simulate allocations with the following simplified alogrithm:
> >> 
> >> Memory management:
> >> - Free pages are kept in buckets, one per order, and sorted by address.
> >> - alloc() the front page (smallest address) out of the bucket of the
> >>   right order or recursively splits the next higher bucket.
> >> - free() recursively tries to merge a page with its neighbour and puts
> >>   the result back into the proper bucket (sorted by address).
> >> 
> >> Allocation and lifetime:
> >> - Every tick a new page is allocated with random order.
> >
> > This step in itself is not representative of what happens in the kernel.
> > The vast vast majority of allocations are order-0. It's a fun analysis
> > but I'm not sure can we draw any conclusions from it.
> 
> I skewed the distribution to that end. Maybe not enough but I wanted
> to get quite a big of large pages. Also I'm only simulating the
> unmovable objects and I would expect the I/O layer to make a lot of
> higher order allocs/free to benefit from compound pages. If nobody
> uses them then what is the point adding them?
> 

Ok. It's a bit fairer if we pick two orders that are commonly used then.
order-0 for almost everything and order-4 for a hypothetical large block
filesystem that is mounted.

> > Statistical analysis of the buddy algorithm have implied that it doesn't
> > suffer that badly from external fragmentation but we know in practice
> > that things are different. A model is hard because minimally the
> > lifetime of pages varies widely.
> >
> >> - The order is a triangle distribution with max at 0 (throw 2 dice,
> >>   add the eyes, subtract 7, abs() the number).
> >> - The page is scheduled to be freed after X ticks. Where X is nearly
> >>   a gaus curve centered at 0 and maximum at <total num pages> * 1.5.
> >>   (What I actualy do is throw 8 dice and sum them up and shift the
> >>    result.)
> >> 
> >
> > I doubt this is how the kernel behaves either.
> 
> I had to pick something. I agree that the lifetime part is the hardest
> to simulate and the point where an attack would start.
> 

That's fair.

> >> Display:
> >> I start with a white window. Every page allocation draws a black box
> >> from the address of the page and as wide as the page is big (-1 pixel to
> >> give a seperation to the next page). Every page free draws a yellow
> >> box in place of the black one. Yellow to show where a page was in use
> >> at one point while white means the page was never used.
> >> 
> >> As the time ticks the memory fills up. Quickly at first and then comes
> >> to a stop around 80% filled. And then something interesting
> >> happens. The yellow regions (previously used but now free) start
> >> drifting up. Small pages tend to end up in the lower addresses and big
> >> pages at the higher addresses. The memory defragments itself to some
> >> degree.
> >> 
> >> http://mrvn.homeip.net/fragment/
> >> 
> >> Simulating 256MB ram and after 1472943 ticks and 530095 4k, 411841 8k,
> >> 295296 16k, 176647 32k and 59064 64k allocations you get this:
> >> http://mrvn.homeip.net/fragment/256mb.png
> >> 
> >> Simulating 1GB ram and after 5881185 ticks  and 2116671 4k, 1645957
> >> 8k, 1176994 16k, 705873 32k and 235690 64k allocations you get this:
> >> http://mrvn.homeip.net/fragment/1gb.png
> >> 
> >
> > These type of pictures feel somewhat familiar
> > (http://www.skynet.ie/~mel/anti-frag/2007-02-28/page_type_distribution.jpg).
> 
> Those look a lot better and look like they are actually real kernel
> data. How did you make them and can one create them in real-time (say
> once a second or so)?
> 

It's from a real kernel. When I was measuring this stuff, I took a
sample every 2 seconds.

> There seem to be an awfull lot of pinned pages inbetween the movable.

It wasn't grouping by mobility at the time.

> I would verry much like to see the same data with evicting of movable
> pages out of mixed groups. I see not a single movable group while with
> strict eviction there could be at most one mixed group per order.
> 

With strict eviction, there would be no mixed blocks period.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
