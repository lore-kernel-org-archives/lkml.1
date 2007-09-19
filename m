Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXISFK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXISFK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXISFKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:10:11 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58393 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751807AbXISFKI (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:10:08 -0400
Date: Wed, 19 Sep 2007 15:09:10 +1000
From: David Chinner <dgc@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nathan Scott <nscott@aconex.com>, Andrea Arcangeli <andrea@suse.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070919050910.GK995458@sgi.com>
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org> <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org> <1190163523.24970.378.camel@edge.yarra.acx> <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 06:06:52PM -0700, Linus Torvalds wrote:
> >						 especially as the Linux
> > kernel limitations in this area are well known.  There's no "16K mess"
> > that SGI is trying to clean up here (and SGI have offered both IA64 and
> > x86_64 systems for some time now, so not sure how you came up with that
> > whacko theory).
> 
> Well, if that is the case, then I vote that we drop the whole patch-series 
> entirely. It clearly has no reason for existing at all.
> 
> There is *no* valid reason for 16kB blocksizes unless you have legacy 
> issues.

Ok, let's step back for a moment and look at a basic, fundamental
constraint of disks - seek capacity. A decade ago, a terabyte of
filesystem had 30 disks behind it - a seek capacity of about
6000 seeks/s. Nowdays, that's a single disk with a seek
capacity of about 200/s. We're going *rapidly* backwards in
terms of seek capacity per terabyte of storage.

Now fill that terabyte of storage and index it in the most efficient
way - let's say btrees are used because lots of filesystems use
them. Hence the depth of the tree is roughly O((log n)/m) where m is
a factor of the btree block size.  Effectively, btree depth = seek
count on lookup of any object.

When the filesystem had a capacity of 6,000 seeks/s, we didn't
really care if the indexes used 4k blocks or not - the storage
subsystem had an excess of seek capacity to deal with
less-than-optimal indexing. Now we have over an order of magnitude
less seeks to expend in index operations *for the same amount of
data* so we are really starting to care about minimising the
number of seeks in our indexing mechanisms and allocations.

We can play tricks in index compaction to reduce the number of
interior nodes of the tree (like hashed indexing in the XFS ext3
htree directories) but that still only gets us so far in reducing
seeks and doesn't help at all for tree traversals. That leaves us
with the btree block size as the only factor we can further vary to
reduce the depth of the tree. i.e. "m".

So we want to increase the filesystem block size it improve the
efficiency of our indexing. That improvement in efficiency
translates directly into better performance on seek constrained
storage subsystems.

The problem is this: to alter the fundamental block size of the
filesystem we also need to alter the data block size and that is
exactly the piece that linux does not support right now.  So while
we have the capability to use large block sizes in certain
filesystems, we can't use that capability until the data path
supports it.

To summarise, large block size support in the filesystem is not
about "legacy" issues. It's about trying to cope with the rapid
expansion of storage capabilities of modern hardware where we have
to index much, much more data with a corresponding decrease in
the seek capability of the hardware.

> So get your stories straight, people.

Ok, so let's set the record straight. There were 3 justifications
for using *large pages* to *support* large filesystem block sizes
The justifications for the variable order page cache with large
pages were:

	1. little code change needed in the filesystems
		-> still true

	2. Increased I/O sizes on 4k page machines (the "SCSI
	   controller problem")
		-> redundant thanks to Jens Axboe's quick work

	3. avoiding the need for vmap() as it has great
	   overhead and does not scale
	   	-> Nick is starting to work on that and has
		   already had good results.

Everyone seems to be focussing on #2 as the entire justification for
large block sizes in filesystems and that this is an "SGI" problem.
Nothing could be further from the truth - the truth is that large
pages solved multiple problems in one go. We now have a different,
better solution #2, so please, please stop using that as some
justification for claiming filesystems don't need large block sizes.

However, all this doesn't change the fact that we have a major storage
scalability crunch coming in the next few years. Disk capacity is
likely to continue to double every 12 months for the next 3 or 4
years. Large block size support is only one mechanism we need to
help cope with this trend.

The variable order page cache with large pages was a means to an end
- it's not the only solution to this problem and I'm extremely happy
to see that there is progress on multiple fronts.  That's the
strength of the Linux community showing through.  In the end, I
really don't care how we end up supporting large filesystem block
sizes in the page cache - all I care about is that we end up
supporting it as efficiently and generically as we possibly can.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
