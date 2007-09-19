Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbXISOEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbXISOEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 10:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbXISOEi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 10:04:38 -0400
Received: from ns.suse.de ([195.135.220.2]:52146 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbXISOEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 10:04:36 -0400
Date: Wed, 19 Sep 2007 16:04:30 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20070919140430.GJ4608@v2.random>
References: <20070911060349.993975297@sgi.com> <200709161853.12050.nickpiggin@yahoo.com.au> <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org> <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org> <1190163523.24970.378.camel@edge.yarra.acx> <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org> <20070919050910.GK995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919050910.GK995458@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 03:09:10PM +1000, David Chinner wrote:
> Ok, let's step back for a moment and look at a basic, fundamental
> constraint of disks - seek capacity. A decade ago, a terabyte of
> filesystem had 30 disks behind it - a seek capacity of about
> 6000 seeks/s. Nowdays, that's a single disk with a seek
> capacity of about 200/s. We're going *rapidly* backwards in
> terms of seek capacity per terabyte of storage.
> 
> Now fill that terabyte of storage and index it in the most efficient
> way - let's say btrees are used because lots of filesystems use
> them. Hence the depth of the tree is roughly O((log n)/m) where m is
> a factor of the btree block size.  Effectively, btree depth = seek
> count on lookup of any object.

I agree. btrees will clearly benefit if the nodes are larger. We've an
excess of disk capacity and an huge gap between seeking and contiguous
bandwidth.

You don't need largepages for this, fsblocks is enough.

Largepages for you are a further improvement to avoid reducing the SG
entries and potentially reducing the cpu utilization a bit (not much
though, only the pagecache works with largepages and especially with
small sized random I/O you'll be taking the radix tree lock the same
number of times...).

Plus of course you don't like fsblock because it requires work to
adapt a fs to it, I can't argue about that.

> Ok, so let's set the record straight. There were 3 justifications
> for using *large pages* to *support* large filesystem block sizes
> The justifications for the variable order page cache with large
> pages were:
> 
> 	1. little code change needed in the filesystems
> 		-> still true

Disagree, the mmap side is not a little change. If you do it just for
the not-mmapped I/O that truly is an hack, but then frankly I would
prefer only the read/write hack (without mmap) so it will not reject
heavily with my stuff and it'll be quicker to nuke it out of the
kernel later.

> 	3. avoiding the need for vmap() as it has great
> 	   overhead and does not scale
> 	   	-> Nick is starting to work on that and has
> 		   already had good results.

Frankly I don't follow this vmap thing. Can you elaborate? Is this
about allowing the blkdev pagecache for metadata to go in highmemory?
Is that the kmap thing? I think we can stick to a direct mapped b_data
and avoid all overhead of converting a struct page to a virtual
address. It takes the same 64bit size anyway in ram and we avoid one
layer of indirection and many modifications. If we wanted to switch to
kmap for blkdev pagecache we should have done years ago, now it's far
too late to worry about it.

> Everyone seems to be focussing on #2 as the entire justification for
> large block sizes in filesystems and that this is an "SGI" problem.

I agree it's not a SGI problem and this is why I want a design that
has a _slight chance_ to improve performance on x86-64 too. If
variable order page cache will provide any further improvement on top
of fsblock will be only because your I/O device isn't fast with small
sg entries.

For the I/O layout the fsblock is more than enough, but I don't think
your variable order page cache will help in any significant way on
x86-64. Furthermore the complexity of handle page faults on largepages
is almost equivalent to the complexity of config-page-shift, but
config-page-shift gives you the whole cpu-saving benefits that you can
never remotely hope to achieve with variable order page cache.

config-page-shift + fsblock IMHO is the way to go for x86-64, with one
additional 64k PAGE_SIZE rpm. config-page-shift will stack nicely on
top of fsblocks.

fsblock will provide the guarantee of "mounting" all fs anywhere no
matter which config-page-shift you selected at compile time, as well
as dvd writing. Then config-page-shift will provide the cpu
optimization on all fronts, not just for the pagecache I/O for the
large ram systems, without fragmentation issues and with 100%
reliability in the "free" numbers (not working by luck). That's all we
need as far as I can tell.
