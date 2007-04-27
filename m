Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbXD0HEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbXD0HEn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754117AbXD0HEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:04:42 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:46515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512AbXD0HEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:04:41 -0400
Date: Fri, 27 Apr 2007 00:04:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070427000403.6013d1fa.akpm@linux-foundation.org>
In-Reply-To: <20070427060921.GA77450368@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
	<20070426221528.655d79cb.akpm@linux-foundation.org>
	<20070427060921.GA77450368@melbourne.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 16:09:21 +1000 David Chinner <dgc@sgi.com> wrote:

> On Thu, Apr 26, 2007 at 10:15:28PM -0700, Andrew Morton wrote:
> > On Fri, 27 Apr 2007 14:20:46 +1000 David Chinner <dgc@sgi.com> wrote:
> > 
> > > >    blocksizes via this scheme - instantiate and lock four pages and go for
> > > >    it.
> > > 
> > > So now how do you get block aligned writeback?
> > 
> > in writeback and pageout:
> > 
> > 	if (page->index & mapping->block_size_mask)
> > 		continue;
> 
> So we might do writeback on one page in N - how do we
> make sure none of the other pages are reclaimed while we are doing
> writeback on this bclok?

By marking them all dirty when one is marked dirty.

David, you're perfectly capable of working all this out yourself.  But
you're trying not to.  Please stop this game.

> IOWs, we have to lock every page in the block, mark them all as
> writeback, etc. Instead of doing something once, we have
> to repeat it for every block in page. This is better than a compound
> page, how?

I already said it'd be a bit slower.  But given that those four pageframes
will fall within two cachelines the cost will be small.

> > > Or make sure that truncate
> > > doesn't race on a partial *block* truncate?
> > 
> > lock four pages
> 
> And the locking order? How do you enforce *kernel wide* the
> same locking order for all pages in the same block so that we
> don't get ABBA deadlocks on page locks within a block?

Oh stop it.  You know perfectly well how to do this.  It is trivial.

> i.e:
> 
> > > You basically have to
> > > jump through nasty, nasty hoops, to handle corner cases that are introduced
> > > because the generic code can no longer reliably lock out access to a
> > > filesystem block.
> 
> This way lies insanity.
> 

You're addressing Christoph's straw man here.

> > > way to serialise access to these aggregated structures. This is
> > > the way XFS used to work in it's data path, and we all know how long
> > > and loud people complained about that.....
> > > 
> > > A filesystem specific aggregation mechanism is not a palatable solution
> > > here because it drives filesystems away from being able to use generic
> > > code. 
> > 
> > I would expect we could (should) implement this in generic code by
> > modifying the existing stuff.
> 
> So you're suggesting that we reintroduce a buffer-oriented filesystem
> interface to support large block sizes?

Nothing vaguely like it.  Please be serious.

> > I'm not saying it's especially simple, nor fast.  But it has the advantage
> > that we're not forced to use larger pages with _it's_ attendant performance
> > problems.
> 
> So you'll take slow, inefficient and complex rather than use an
> non-intrusive and /optional/ interface to large pages?

The optionality is useful - it at least means that we can easily remove it
all if/when it becomes obsolete.

