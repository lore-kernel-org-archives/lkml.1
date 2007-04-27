Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbXD0GJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbXD0GJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755369AbXD0GJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:09:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53793 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755372AbXD0GJk (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:09:40 -0400
Date: Fri, 27 Apr 2007 16:09:21 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427060921.GA77450368@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426221528.655d79cb.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 10:15:28PM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 14:20:46 +1000 David Chinner <dgc@sgi.com> wrote:
> 
> > >    blocksizes via this scheme - instantiate and lock four pages and go for
> > >    it.
> > 
> > So now how do you get block aligned writeback?
> 
> in writeback and pageout:
> 
> 	if (page->index & mapping->block_size_mask)
> 		continue;

So we might do writeback on one page in N - how do we
make sure none of the other pages are reclaimed while we are doing
writeback on this bclok?

IOWs, we have to lock every page in the block, mark them all as
writeback, etc. Instead of doing something once, we have
to repeat it for every block in page. This is better than a compound
page, how?

> > Or make sure that truncate
> > doesn't race on a partial *block* truncate?
> 
> lock four pages

And the locking order? How do you enforce *kernel wide* the
same locking order for all pages in the same block so that we
don't get ABBA deadlocks on page locks within a block?

i.e:

> > You basically have to
> > jump through nasty, nasty hoops, to handle corner cases that are introduced
> > because the generic code can no longer reliably lock out access to a
> > filesystem block.

This way lies insanity.

> > way to serialise access to these aggregated structures. This is
> > the way XFS used to work in it's data path, and we all know how long
> > and loud people complained about that.....
> > 
> > A filesystem specific aggregation mechanism is not a palatable solution
> > here because it drives filesystems away from being able to use generic
> > code. 
> 
> I would expect we could (should) implement this in generic code by
> modifying the existing stuff.

So you're suggesting that we reintroduce a buffer-oriented filesystem
interface to support large block sizes?

> I'm not saying it's especially simple, nor fast.  But it has the advantage
> that we're not forced to use larger pages with _it's_ attendant performance
> problems.

So you'll take slow, inefficient and complex rather than use an
non-intrusive and /optional/ interface to large pages?

Words fail me......

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
