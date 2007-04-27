Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbXD0EVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbXD0EVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 00:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbXD0EVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 00:21:06 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49701 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755244AbXD0EVC (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 00:21:02 -0400
Date: Fri, 27 Apr 2007 14:20:46 +1000
From: David Chinner <dgc@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070427042046.GI65285596@melbourne.sgi.com>
References: <20070424222105.883597089@sgi.com> <20070426190438.3a856220.akpm@linux-foundation.org> <20070427022731.GF65285596@melbourne.sgi.com> <20070426195357.597ffd7e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426195357.597ffd7e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 07:53:57PM -0700, Andrew Morton wrote:
> On Fri, 27 Apr 2007 12:27:31 +1000 David Chinner <dgc@sgi.com> wrote:
> > On Thu, Apr 26, 2007 at 07:04:38PM -0700, Andrew Morton wrote:
> > > On Tue, 24 Apr 2007 15:21:05 -0700 clameter@sgi.com wrote:
> > > Also, afaict your important requirements would be met by retaining
> > > PAGE_CACHE_SIZE=4k and simply ensuring that pagecache is populated by
> > > physically contiguous pages
> > 
> > Sure, that addresses the larger I/O side of things, but it doesn't address
> > the large filesystem blocksize issues that can only be solved with some kind
> > of page aggregation abstraction.
> 
> a) That wasn't a part of Christoph's original rationale list, so forgive
>    me for thinking it is not so important and got snuck in post-facto when
>    things got tough.

I've been pushing christoph to do something like this for more than a year
purely so we can support large block sizes in XFS. He's got other reasons
for wanting to do this, but that doesn't mean that the large filesystem
blocksize issue is any less important.

>    blocksizes via this scheme - instantiate and lock four pages and go for
>    it.

So now how do you get block aligned writeback? Or make sure that truncate
doesn't race on a partial *block* truncate? You basically have to
jump through nasty, nasty hoops, to handle corner cases that are introduced
because the generic code can no longer reliably lock out access to a
filesystem block.

Eventually you end up with something like fs/xfs/linux-2.6/xfs_buf.c and
doing everything inside the filesystem because it's the only way sane
way to serialise access to these aggregated structures. This is
the way XFS used to work in it's data path, and we all know how long
and loud people complained about that.....

A filesystem specific aggregation mechanism is not a palatable solution
here because it drives filesystems away from being able to use generic
code. 

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
