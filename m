Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXD1DSF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXD1DSF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 23:18:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030965AbXD1DSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 23:18:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38315 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932263AbXD1DSC (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 23:18:02 -0400
Date: Sat, 28 Apr 2007 13:17:40 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428031739.GK32602149@melbourne.sgi.com>
References: <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com> <20070426235542.bad7035a.akpm@linux-foundation.org> <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com> <20070427002640.22a71d06.akpm@linux-foundation.org> <20070427163620.GI32602149@melbourne.sgi.com> <20070427173432.GJ32602149@melbourne.sgi.com> <20070427121108.9ee05710.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427121108.9ee05710.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 12:11:08PM -0700, Andrew Morton wrote:
> On Sat, 28 Apr 2007 03:34:32 +1000 David Chinner <dgc@sgi.com> wrote:
> 
> > Some more information - stripe unit on the dm raid0 is 512k.
> > I have not attempted to increase I/O sizes at all yet - these test are
> > just demonstrating efficiency improvements in the filesystem.
> > 
> > These numbers for 32GB files.
> > 
> >                     READ            WRITE
> > disks  blksz     tput   sys       tput    sys
> > -----  -----    -----   ----      -----  ----
> >   1     4k        89     18s       57     44s
> >   1    16k        46     13s       67     18s
> >   1    64k        75     12s       68     12s
> >   2     4k       179     20s      114     43s
> >   2    16k        55     13s      132     18s
> >   2    64k       126     12s      126     12s
> >   4     4k       350     20s      214     43s
> >   4    16k       350     14s      264     19s
> >   4    64k       176     11s      266     12s
> >   8     4k       415     21s      446     41s
> >   8    16k       655     13s      518     19s
> >   8    64k       664     12s      552     12s
> >  12     4k       413     20s      633     33s
> >  12    16k       736     14s      741     19s
> >  12    64k       836     12s      743     12s
> > 
> > Throughput in MB/s.
> > 
> > 
> > Consistent improvement across the write results, first time
> > I've hit the limits of the PCI-X bus with a single buffered
> > I/O thread doing either reads or writes.
> 
> 1-disk and 2-disk read throughput fell by an improbable amount, which makes
> me cautious about the other numbers.

For read, yes, and it's because something is going wrong with the
I/O size - it looks like readahead thrashing of some kind even
with 4k pages tests.

When when I bumped the block device readahead from 256 -> 2048,
the single disk read numbers went 60, 75, 75MB/s for 4->64k block size
and were repeatable, so we definitely have some interaction with readahead.

> Your annotation says "blocksize".  Are you really varying the fs blocksize
> here, or did you mean "pagesize"?

Filesystem blocksize, as specified by mkfs.xfs. Which, in turn,
changes the page cache order.

> What worries me here is that we have inefficient code, and increasing the
> pagesize amortises that inefficiency without curing it.

Increasing the filesystem block size also reduces the overhead of
the filesystem, not just he page cache. A lot of the overhead (write
especially) reductions are going to be filesystem block size
related, so I wouldn't start assuming that it's just he page cache
changes that have brought about these system time reductions.

> If so, it would be better to fix the inefficiencies, so that 4k pagesize
> will also benefit.
> 
> For example, see __do_page_cache_readahead().  It does a read_lock() and a
> page allocation and a radix-tree lookup for each page.  We can vastly
> improve that.

....

Sure but that's a different problem to what we are trying to solve
now.  Even with this in place, I think we'd still realise
improvements with the compound pages....

> Fix up your lameo HBA for reads.

Where did that come from? You spend 20 lines described the inefficiencies
of the readahead in the page cache and it should be fixed but then you
turn around and say fix the HBA? 

This test was constructed to keep the I/o sizes within the current
bounds, so the HBA sees no difference in I/O sizes as the filesystem
block size changes.  i.e. the HBA is constant factor during the
tests. IOWs, the changes in numbers above are purely a result of the
page cache and filesystem changes....

And besides, the "lameo HBA" I'm using is cleared limited by the
PCI-X bus it's on, not the size and type of pages being thrown at it
by the I/O layers. The hardware is pretty much irrelevant in these
tests....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
