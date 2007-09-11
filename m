Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbXIKOgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbXIKOgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 10:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752023AbXIKOgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 10:36:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41220 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbXIKOgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 10:36:10 -0400
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>, andrea@suse.de,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
In-Reply-To: <200709110452.20363.nickpiggin@yahoo.com.au>
References: <20070911060349.993975297@sgi.com>
	 <200709110452.20363.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Tue, 11 Sep 2007 16:36:07 +0100
Message-Id: <1189524967.32731.58.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-11 at 04:52 +1000, Nick Piggin wrote:
> On Tuesday 11 September 2007 16:03, Christoph Lameter wrote:
> 
> > 5. VM scalability
> >    Large block sizes mean less state keeping for the information being
> >    transferred. For a 1TB file one needs to handle 256 million page
> >    structs in the VM if one uses 4k page size. A 64k page size reduces
> >    that amount to 16 million. If the limitation in existing filesystems
> >    are removed then even higher reductions become possible. For very
> >    large files like that a page size of 2 MB may be beneficial which
> >    will reduce the number of page struct to handle to 512k. The variable
> >    nature of the block size means that the size can be tuned at file
> >    system creation time for the anticipated needs on a volume.
> 
> There is a limitation in the VM. Fragmentation. You keep saying this
> is a solved issue and just assuming you'll be able to fix any cases
> that come up as they happen.
> 
> I still don't get the feeling you realise that there is a fundamental
> fragmentation issue that is unsolvable with Mel's approach.
> 

I thought we had discussed this already at VM and reached something
resembling a conclusion. It was acknowledged that depending on
contiguous allocations to always succeed will get a caller into trouble
and they need to deal with fallback - whether the problem was
theoritical or not. It was also strongly pointed out that the large
block patches as presented would be vunerable to that problem.

The alternatives were fs-block and increasing the size of order-0. It
was felt that fs-block was far away because it's complex and I thought
that increasing the pagesize like what Andrea suggested would lead to
internal fragmentation problems. Regrettably we didn't discuss Andrea's
approach in depth.

I *thought* that the end conclusion was that we would go with
Christoph's approach pending two things being resolved;

o mmap() support that we agreed on is good
o A clear statement, with logging maybe for users that mounted a large 
  block filesystem that it might blow up and they get to keep both parts
  when it does. Basically, for now it's only suitable in specialised
  environments.

I also thought there was an acknowledgement that long-term, fs-block was
the way to go - possibly using contiguous pages optimistically instead
of virtual mapping the pages. At that point, it would be a general
solution and we could remove the warnings.

Basically, to start out with, this was going to be an SGI-only thing so
they get to rattle out the issues we expect to encounter with large
blocks and help steer the direction of the
more-complex-but-safer-overall fs-block.

> The idea that there even _is_ a bug to fail when higher order pages
> cannot be allocated was also brushed aside by some people at the
> vm/fs summit.

When that brushing occured, I thought I made it very clear what the
expectations were and that without fallback they would be taking a risk.
I am not sure if that message actually sank in or not.

That said, the filesystem people can experiement to some extent against
Christoph's approach as long as they don't think they are 100% safe.
Again, their experimenting will help steer the direction of fs-block.

>
>  I don't know if those people had gone through the
> math about this, but it goes somewhat like this: if you use a 64K
> page size, you can "run out of memory" with 93% of your pages free.
> If you use a 2MB page size, you can fail with 99.8% of your pages
> still free. That's 64GB of memory used on a 32TB Altix.
> 

That's the absolute worst case but yes, in theory this can occur and
it's safest to assume the situation will occur somewhere to someone. It
would be difficult to craft an attack to do it but conceivably a machine
running for a long enough time would trigger it particularly if the
large block allocations are GFP_NOIO or GFP_NOFS.

> If you don't consider that is a problem because you don't care about
> theoretical issues or nobody has reported it from running -mm
> kernels, then I simply can't argue against that on a technical basis.

The -mm kernels have patches related to watermarking that will not be
making it to mainline for reasons we don't need to revisit right now.
The lack of the watermarking patches may turn out to be a non-issue but
the point is that what's in mainline is not exactly the same as -mm and
mainline will be running for longer periods of time in a different
environment.

Where we expected to see the the use of this patchset was in specialised
environments *only*. The SGI people can mitigate their mixed
fragmentation problems somewhat by setting slub_min_order ==
large_block_order so that blocks get allocated and freed at the same
size. This is partial way towards Andrea's solution of raising the size
of an order-0 allocation. The point of printing out the warnings at
mount time was not so much for a general user who may miss the logs but
for distributions that consider turning large block use on by default to
discourage them until such time as we have proper fallback in place.

> But I'm totally against introducing known big fundamental problems to
> the VM at this stage of the kernel. God knows how long it takes to ever
> fix them in future after they have become pervasive throughout the 
> kernel.
> 
> IMO the only thing that higher order pagecache is good for is a quick
> hack for filesystems to support larger block sizes. And after seeing it
> is fairly ugly to support mmap, I'm not even really happy for it to do
> that.
> 

If the mmap() support is poor and going to be an obstacle in the future,
then that is a reason to hold it up. I haven't actually read the mmap()
support patch yet so I have no worthwhile opinion yet.

If the mmap() mess can be agreed on, the large block patchset as it is
could give us important information from the users willing to deal with
this risk about what sort of behaviour to expect. If they find it fails
all the time, then fs-block having the complexity of optimistically
using large pages is not worthwhile either. That is useful data.

> If VM scalability is a problem, then it needs to be addressed in other
> areas anyway for order-0 pages, and if contiguous pages helps IO
> scalability or crappy hardware, then there is nothing stopping us from
> *attempting* to get contiguous memory in the current scheme.
> 

This was also brought up at VM Summit but for the benefit of the people
that were not there;

It was emphasised that large block support is not the solution to all
scalability problems. There was a strong emphasis on fixing up the
order-0 uses should be encouraged. In particular, readahead should be
batched so that each page is not individually locked. There were also
other page-related operations that should be done in batch. On a similar
note, it was pointed out that dcache lookup is something that should be
scaled better - possibly before spending too much time on things like
page cache or radix locks.

For scalability, it was also pointed out at some point that heavy users
of large blocks may now find themselves contending on the zone->lock and
they might well find that order-0 pages were what they wanted to use
anyway.

> Basically, if you're placing your hopes for VM and IO scalability on this,
> then I think that's a totally broken thing to do and will end up making
> the kernel worse in the years to come (except maybe on some poor
> configurations of bad hardware).

My magic 8-ball is in the garage.

I thought the following plan was sane but I could be la-la

1. Go with large block + explosions to start with
   - Second class feature at this point, not fully supported
   - Experiment in different places to see what it gains (if anything)
2. Get fs-block in slowly over time with the fallback options replacing
   Christophs patches bit by bit
3. Kick away warnings
   - First class feature at this point, fully supported

Independently of that, we would work on order-0 scalability,
particularly readahead and batching operations on ranges of pages as
much as possible.

-- 
Mel "la-la" Gorman

