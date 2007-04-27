Return-Path: <linux-kernel-owner+w=401wt.eu-S1755473AbXD0IDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473AbXD0IDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 04:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbXD0IDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 04:03:46 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32841 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755473AbXD0IDm (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 04:03:42 -0400
Date: Fri, 27 Apr 2007 18:03:21 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427080321.GG32602149@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org> <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <20070427060921.GA77450368@melbourne.sgi.com> <20070427000403.6013d1fa.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427000403.6013d1fa.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 12:04:03AM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 16:09:21 +1000 David Chinner <dgc@sgi.com> wrote:
> 
> > On Thu, Apr 26, 2007 at 10:15:28PM -0700, Andrew Morton wrote:
> > > On Fri, 27 Apr 2007 14:20:46 +1000 David Chinner <dgc@sgi.com> wrote:
> > > 
> > > > >    blocksizes via this scheme - instantiate and lock four pages and go for
> > > > >    it.
> > > > 
> > > > So now how do you get block aligned writeback?
> > > 
> > > in writeback and pageout:
> > > 
> > > 	if (page->index & mapping->block_size_mask)
> > > 		continue;
> > 
> > So we might do writeback on one page in N - how do we
> > make sure none of the other pages are reclaimed while we are doing
> > writeback on this bclok?
> 
> By marking them all dirty when one is marked dirty.
> 
> David, you're perfectly capable of working all this out yourself.  But
> you're trying not to.  Please stop this game.

I've looked at all this but I'm trying to work out if anyone
else has looked at the impact of doing this. I have direct experience
with this form of block aggregation - this is pretty much what is
done in irix - and it's full of nasty, ugly corner cases.

I've got several year-old Irix bugs  assigned that are hit every so
often where one page in the aggregated set has the wrong state, and
it's simply not possible to either reproduce the problem or work out
how it happened. The code has grown too complex and convoluted, and
by the time the problem is noticed (either by hang, panic or bug
check) the cause of it is long gone.

I don't want to go back to having to deal with this sort of problem
- I'd much prefer to have a design that does not make the same
mistakes that lead to these sorts of problem.

> > > > You basically have to
> > > > jump through nasty, nasty hoops, to handle corner cases that are introduced
> > > > because the generic code can no longer reliably lock out access to a
> > > > filesystem block.
> > 
> > This way lies insanity.
> 
> You're addressing Christoph's straw man here.

No, I'm speaking from years of experience working on a
page/buffer/chunk cache capable of using both large pages and
aggregating multiple pages. It has, at times, almost driven me
insane and I don't want to go back there.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
