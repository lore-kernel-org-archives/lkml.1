Return-Path: <linux-kernel-owner+w=401wt.eu-S933766AbXDZJUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933766AbXDZJUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 05:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933760AbXDZJUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 05:20:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45408 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933769AbXDZJUd (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 05:20:33 -0400
Date: Thu, 26 Apr 2007 19:20:14 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Lameter <clameter@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426092014.GT65285596@melbourne.sgi.com>
References: <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <Pine.LNX.4.64.0704252154250.29271@schroedinger.engr.sgi.com> <m1abwvofke.fsf@ebiederm.dsl.xmission.com> <463048FE.5000600@yahoo.com.au> <Pine.LNX.4.64.0704252341560.30340@schroedinger.engr.sgi.com> <46304D50.1040706@yahoo.com.au> <Pine.LNX.4.64.0704260008280.30731@schroedinger.engr.sgi.com> <46305327.2000206@yahoo.com.au> <Pine.LNX.4.64.0704260028190.31003@schroedinger.engr.sgi.com> <4630593C.8070905@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4630593C.8070905@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 05:48:12PM +1000, Nick Piggin wrote:
> Christoph Lameter wrote:
> >On Thu, 26 Apr 2007, Nick Piggin wrote:
> >
> >
> >>No I don't want to add another fs layer.
> >
> >
> >Well maybe you could explain what you want. Preferably without redefining 
> >the established terms?
> 
> Support for larger buffers than page cache pages.

The problem with this approach is that it turns around the whole
way we look at bufferheads. Right now we have well defined 1:n
mapping of page to bufferheads and so we tpyically lock the
page first them iterate all the bufferheads on the page.

Going the other way, we need to support m:n which we means
the buffer has to become the primary interface for the filesystem
to the page cache. i.e. we need to lock the bufferhead first, then
iterate all the pages on it. This is messy because the cache indexes
via pages, not bufferheads. hence a buffer needs to point to all the
pages in it explicitly, and this leads to interesting issues with
locking.

If you still think that this is a good idea, I suggest that you
spend a bit of time looking at fs/xfs/linux-2.6/xfs_buf.c, because
that is *exactly* what this does - it is a multi-page buffer
interface on top of a block device address space radix tree. This
cache is the reason that XFS was so easy to transition to large
block sizes (i only needed to convert the data path).

However, this approach has some serious problems:

	- need to index buffers so that lookups can be done
	  on buffer before page
	- completely different locking is required
	- needs memory allocation to hold more than 4 pages
	- needs vmap() rather than kmap_atomic() for mapping
	  multi-page buffers
	- I/O needs to be issued based on buffers, not pages
	- needs it's own flush code
	- does not interface with memory reclaim well

IOWs, we need to turn every filesystem completely upside down to
make work with this sort of large page infrastructure, not to mention
the rest of the VM (mmap, page reclaim, etc). It's back to the
bad ol' days of buffer caches again and we don't want to go back
there.

Compared to a buffer based implementation, the high order page cache
is a picture of elegance and refined integration. It is an
evolutionary step, not a disconnect, from what we have now....
	
> >Because 4k is a good page size that is bound to the binary format? Frankly 
> >there is no point in having my text files in large page sizes. However, 
> >when I read a dvd then I may want to transfer 64k chunks or when use my 
> >flash drive I may want to transfer 128k chunks. And yes if a scientific 
> >application needs to do data dump then it should be able to use very high 
> >page sizes (megabytes, gigabytes) to be able to continue its work while 
> >the huge dumps runs at full I/O speed ...
> 
> So block size > page cache size... also, you should obviously be using
> hardware that is tuned to work well with 4K pages, because surely there
> is lots of that around.

The CPU hardware works well with 4k pages, but in general I/O
hardware works more efficiently as the numbers of s/g entries they
require drops for a given I/O size. Given that we limit drivers to
128 s/g entries, we really aren't using I/O hardware to it's full
potential or at it's most efficient by limiting each s/g entry to a
single 4k page.

And FWIW, a having a buffer for block size > page size does not
solve this problem - only contiguous page allocation solves this
problem.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
