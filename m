Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbXD0FQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbXD0FQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXD0FQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:16:29 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755343AbXD0FQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:16:27 -0400
Date: Thu, 26 Apr 2007 22:15:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-Id: <20070426221528.655d79cb.akpm@linux-foundation.org>
In-Reply-To: <20070427042046.GI65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com>
	<20070426190438.3a856220.akpm@linux-foundation.org>
	<20070427022731.GF65285596@melbourne.sgi.com>
	<20070426195357.597ffd7e.akpm@linux-foundation.org>
	<20070427042046.GI65285596@melbourne.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 14:20:46 +1000 David Chinner <dgc@sgi.com> wrote:

> >    blocksizes via this scheme - instantiate and lock four pages and go for
> >    it.
> 
> So now how do you get block aligned writeback?

in writeback and pageout:

	if (page->index & mapping->block_size_mask)
		continue;

> Or make sure that truncate
> doesn't race on a partial *block* truncate?

lock four pages

> You basically have to
> jump through nasty, nasty hoops, to handle corner cases that are introduced
> because the generic code can no longer reliably lock out access to a
> filesystem block.
> 
> Eventually you end up with something like fs/xfs/linux-2.6/xfs_buf.c and
> doing everything inside the filesystem because it's the only way sane
> way to serialise access to these aggregated structures. This is
> the way XFS used to work in it's data path, and we all know how long
> and loud people complained about that.....
> 
> A filesystem specific aggregation mechanism is not a palatable solution
> here because it drives filesystems away from being able to use generic
> code. 

I would expect we could (should) implement this in generic code by
modifying the existing stuff.

I'm not saying it's especially simple, nor fast.  But it has the advantage
that we're not forced to use larger pages with _it's_ attendant performance
problems.

And it will benefit all filesystems immediately.

And it doesn't introduce a rather nasty hack of pretending (in some places)
that pages are larger than they really are.

And it has the very significant advantage that it doesn't introduce brand
new concepts and some complexity into core MM.

And make no mistake: the latter disadvantage is huge.  Because if we do the
PAGE_CACHE_SIZE hack (sorry, but it _is_), we have to do it *for ever*. 
Maintaining and enhancing core MM and VFS becomes harder and more costly
and slower and more buggy *for ever*.  The ramp for people to become
competent on core MM becomes longer.  Our developer pool becomes smaller, and
proportionally less skilled.

And hardware gets better.  If Intel & AMD come out with a 16k pagesize
option in a couple of years we'll look pretty dumb.  If the problems which
you're presently having with that controller get sorted out in the next
generation of the hardware, we'll also look pretty dumb.

As always, there are tradeoffs.  We can see the cons, and they are very
significant.  We don't yet know the pros.  Perhaps they will be similarly
significant.  But I don't believe that the larger PAGE_CACHE_SIZE hack
(sorry) is the only way in which they can be realised.

