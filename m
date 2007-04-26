Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXDZNvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXDZNvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbXDZNvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:51:00 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34898 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754796AbXDZNuy (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:50:54 -0400
Date: Thu, 26 Apr 2007 23:50:33 +1000
From: David Chinner <dgc@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426135033.GU65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5vzmoo7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 04:10:32AM -0600, Eric W. Biederman wrote:
> David Chinner <dgc@sgi.com> writes:
> 
> > On Thu, Apr 26, 2007 at 03:37:28PM +1000, Nick Piggin wrote:
> >> I think starting with the assumption that we _want_ to use higher order
> >> allocations, and then creating all this complexity around that is not a
> >> good one, and if we start introducing things that _require_ significant
> >> higher order allocations to function then it is a nasty thing for
> >> robustness.
> >
> >>From my POV, we started with the problem of how to provide atomic
> > access to a multi-page block in the page cache. For example, we want
> > to lock the filesystem block and prevent any updates to it, so we
> > need to lock all the pages in it. And then when we write them back,
> > they all need to change state at the same time, and they all need to
> > have their radix tree tags changed at the same time, the problem of
> > mapping them to disk, getting writeback to do block aligned and
> > sized writeback chunks, and so on.
> 
> Ok.  That is a reasonable problem and worth solving.
> 
> I suspect the easiest way to go is to have something in the code
> that points all of the locking activities at the first page in the
> block.  Like large pages do but they don't have to be physically
> contiguous.

You just described non-contiguous compount pages.

Not much different, but how do you link all the pages together while
still having a private pointer for the filesystem without growing
the struct page?  Remember, you have to be able to get from any page
to the head node, and you have to be able to get from the head node
to the individual pages when you have to free the compound page.
You'll need something like a linked list between the pages in
addition to the head pointer.

And then there's the allocation code - you need to alloc 1 page
N times rather than N pages once. And then we can still only
get 128 pages into a bio so all we've done churned some in memory
structures and not gained anything where it counts (i.e. on the
storage).

IMO, non-contiguous compound pages are more difficult to manage,
will burn lots more cpu, consume more memory and be able to drive
I/O no faster than the current code. three strikes and you're
out; fouri strikes....

OTOH, contiguous compound pages burn little extra CPU,  will consume
less memory due to smaller radix trees and less bufferhead usage and
can improve the I/O efficiency of the machine.....

> I think that would be even less code then what you are proposing.

More, actually, and with a bigger impact on memory usage because of
the struct page size changes needed.

> > And then there's the problem that most hardware is limited to 128
> > s/g entries and that means 128 non-contiguous pages in memory is the
> > maximum I/O size we can issue to these devices. We have RAID arrays
> > that go twice as fast if we can send them 1MB I/Os instead of 512k
> > I/Os and that means we need contiguous pages to be handled to the
> > devices....
> 
> Ok.  Now why are high end hardware manufacturers building crippled
> hardware?  Or is there only an 8bit field in SCSI for describing
> scatter gather entries?  Although I would think this would be
> move of a controller ranter than a drive issue.

scsi.h:

/*
 *      The maximum sg list length SCSI can cope with
 *      (currently must be a power of 2 between 32 and 256)
 */
#define SCSI_MAX_PHYS_SEGMENTS  MAX_PHYS_SEGMENTS

And from blkdev.h:

#define MAX_PHYS_SEGMENTS 128
#define MAX_HW_SEGMENTS 128

So currentlt on SCSI we are limited to 128 s/g entries, and the
maximum is 256.  So I'd say we've got good grounds for needing
contiguous pages to go beyond 1MB I/O size on x86_64.

> > All of these things require some aggregating structure to
> > co-ordinate. In times gone by on other OSs, this has been done with
> > a buffer cache, but Linux got rid of that long ago and we don't want
> > to reintroduce one. We can't use buffer heads - they can only point
> > to one page. So what do we do?
> 
> For I/O we have the BIO which can point to multiple pages just fine.

And it's a block layer construct it's rather heavyweight compared
to a compound page and a bufferhead for the disk mapping....

> Buffer heads are irrelevant.  The question is how do we get to
> the page cache from the BIO and from the BIO to the page cache.

You missed a layer - the filesystem is usually the transalation
layer between the page cache and the BIO.  Buffer heads are used to
carry extra filesystem state that can't fit on the page. Like the
block number the page is mapped to (i.e. the translation key for
page cache to bio mapping), the per block state (dirty,
unwritten, new, etc), and so on.

>From this information we can construct bios when they are
appropriate, but to use bios where we currently use buffer heads
is extremely wasteful of memory (we often have millions of bufferheads
in memory at once).

FWIW, block size larger than page size also reduces bufferhead usage
so XFS will reduce it's memory footprint when doing buffered writes.

> > That's where compound pages are so nice - they solve all of these
> > problems with only a very small amount of code perturbation and they
> > don't change any algorithms or fundamental design of the OS at all.
> 
> The change the fundamental fragmentation avoidance algorithm of the
> OS.  Use only one size of page.  That is a huge problem.

And one that Mel Gorman has been working on for quite some time
with good results.

> Yes we do relax that rule but only on things that we don't care
> about much and don't mind failing.

No comment.

[snip repeated mantra]

> That is a huge concern.

So don't compile it in!

> > FWIW, if you want 32 bit machines to support larger than 16TB
> > devices, you need high order page indexing in the page cache....
> 
> Huh?  Only if you are doing raw device accesses.  We are limited
> to 16TB files.

Many filesystems use a block device address space to address all
their metadata. e.g ext2/3 can't put metadata and therefore track
usage above 16TB. Therefore, filesytem gets no larger.

> >> >That would make the choice of using larger order pages (essentially
> >> >increasing PAGE_SIZE) something that can be investigated in parallel.
> >> 
> >> I agree that hardware inefficiencies should be handled by increasing
> >> PAGE_SIZE (not making PAGE_CACHE_SIZE > PAGE_SIZE) at the arch level.
> >
> > And what do we do for arches that can't do multiple page sizes, only
> > only have a limited and mostly useless set of page sizes to choose
> > from?
> 
> You have HW_PAGE_SIZE != PAGE_SIZE.

That's rather wasteful, though. Better to only use the large pages
when the filesystem needs them rather than penalise all filesystems.

> That is you hide the fact from
> the bulk of the kernel struct page manges 2 or more real hardware pages.
> But you expose it to the handful of places that actually care.
> Partly this is a path you are starting down in your patches, with
> larger page cache support.

Right, exactly. So apart from the contiguous allocation issue, you think
we are doing the right thing?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
