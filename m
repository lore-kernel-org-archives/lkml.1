Return-Path: <linux-kernel-owner+w=401wt.eu-S1754950AbXITBjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbXITBjg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 21:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXITBj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 21:39:26 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41367 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751290AbXITBjY (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 21:39:24 -0400
Date: Thu, 20 Sep 2007 11:38:21 +1000
From: David Chinner <dgc@sgi.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: David Chinner <dgc@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070920013821.GR995458@sgi.com>
References: <200709161853.12050.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org> <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org> <1190163523.24970.378.camel@edge.yarra.acx> <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org> <20070919050910.GK995458@sgi.com> <20070919140430.GJ4608@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919140430.GJ4608@v2.random>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 04:04:30PM +0200, Andrea Arcangeli wrote:
> On Wed, Sep 19, 2007 at 03:09:10PM +1000, David Chinner wrote:
> > Ok, let's step back for a moment and look at a basic, fundamental
> > constraint of disks - seek capacity. A decade ago, a terabyte of
> > filesystem had 30 disks behind it - a seek capacity of about
> > 6000 seeks/s. Nowdays, that's a single disk with a seek
> > capacity of about 200/s. We're going *rapidly* backwards in
> > terms of seek capacity per terabyte of storage.
> > 
> > Now fill that terabyte of storage and index it in the most efficient
> > way - let's say btrees are used because lots of filesystems use
> > them. Hence the depth of the tree is roughly O((log n)/m) where m is
> > a factor of the btree block size.  Effectively, btree depth = seek
> > count on lookup of any object.
> 
> I agree. btrees will clearly benefit if the nodes are larger. We've an
> excess of disk capacity and an huge gap between seeking and contiguous
> bandwidth.
> 
> You don't need largepages for this, fsblocks is enough.

Sure, and that's what I meant when I said VPC + large pages was
a means to the end, not the only solution to the problem.

> Plus of course you don't like fsblock because it requires work to
> adapt a fs to it, I can't argue about that.

No, I don't like fsblock because it is inherently a "struture
per filesystem block" construct, just like buggerheads. You
still need to allocate millions of them when you have millions
dirty pages around. Rather than type it all out again, read
the fsblocks thread from here:

http://marc.info/?l=linux-fsdevel&m=118284983925719&w=2

FWIW, with Chris mason's extent-based block mapping (which btrfs
is using and Christoph Hellwig is porting XFS over to) we completely
remove buggerheads from XFS and so fsblock would be a pretty
major step backwards for us if Chris's work goes into mainline.

> > Ok, so let's set the record straight. There were 3 justifications
> > for using *large pages* to *support* large filesystem block sizes
> > The justifications for the variable order page cache with large
> > pages were:
> > 
> > 	1. little code change needed in the filesystems
> > 		-> still true
> 
> Disagree, the mmap side is not a little change.

That's not in the filesystem, though. ;)

However, I agree that if you don't have mmap then it's not
worthwhile and the changes for VPC aren't trivial.

> > 	3. avoiding the need for vmap() as it has great
> > 	   overhead and does not scale
> > 	   	-> Nick is starting to work on that and has
> > 		   already had good results.
> 
> Frankly I don't follow this vmap thing. Can you elaborate?

We current support metadata blocks larger than page size for
certain types of metadata in XFS. e.g. directory blocks.
This however, requires vmap()ing a bunch of individual,
non-contiguous pages out of a block device address space
in exactly the fashion that was proposed by Nick with fsblock
originally.

vmap() has severe scalability problems - read this subthread
of this discussion between Nick and myself:

http://lkml.org/lkml/2007/9/11/508

> > Everyone seems to be focussing on #2 as the entire justification for
> > large block sizes in filesystems and that this is an "SGI" problem.
> 
> I agree it's not a SGI problem and this is why I want a design that
> has a _slight chance_ to improve performance on x86-64 too. If
> variable order page cache will provide any further improvement on top
> of fsblock will be only because your I/O device isn't fast with small
> sg entries.

<sigh>

There we go - back to the bloody I/O devices. Can ppl please stop
bringing this up because it *is not an issue any more*.

> config-page-shift + fsblock IMHO is the way to go for x86-64, with one
> additional 64k PAGE_SIZE rpm. config-page-shift will stack nicely on
> top of fsblocks.

Hmm - so you'll need page cache tail packing as well in that case
to prevent memory being wasted on small files. That means any way
we look at it (VPC+mmap or config-page-shift+fsblock+pctails)
we've got some non-trivial VM  modifications to make. 

If VPC can be separated from the large contiguous page requirement
(i.e. virtually mapped compound page support), I still think it
comes out on top because it doesn't require every filesystem to be
modified and you can use standard pages where they are optimal
(i.e. on filesystems were block size <= PAGE_SIZE).

But, I'm not going to argue endlessly for one solution or another;
I'm happy to see different solutions being chased, so may the
best VM win ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
