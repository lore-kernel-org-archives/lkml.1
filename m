Return-Path: <linux-kernel-owner+w=401wt.eu-S1754016AbXEGF1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbXEGF1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 01:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbXEGF1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 01:27:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40505 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754016AbXEGF1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 01:27:55 -0400
Date: Mon, 7 May 2007 15:27:29 +1000
From: David Chinner <dgc@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: David Chinner <dgc@sgi.com>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070507052729.GV32602149@melbourne.sgi.com>
References: <20070427042046.GI65285596@melbourne.sgi.com> <20070426221528.655d79cb.akpm@linux-foundation.org> <20070427060921.GA77450368@melbourne.sgi.com> <20070427000403.6013d1fa.akpm@linux-foundation.org> <20070427080321.GG32602149@melbourne.sgi.com> <20070427014849.41f383f7.akpm@linux-foundation.org> <20070427164535.GH24852@thunk.org> <m1abwku30d.fsf@ebiederm.dsl.xmission.com> <20070507042925.GT32602149@melbourne.sgi.com> <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tzupkzmw.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 10:48:23PM -0600, Eric W. Biederman wrote:
> David Chinner <dgc@sgi.com> writes:
> 
> > On Fri, May 04, 2007 at 07:33:54AM -0600, Eric W. Biederman wrote:
> >> >
> >> > So while the jury is out about how many other filesystems might use
> >> > it, I suspect it's more than you might think.  At the very least,
> >> > there may be some IA64 users who might be trying to transition their
> >> > way to x86_64, and have existing filesystems using a 8k or 16k
> >> > block filesystems.  :-)
> >> 
> >> How much of a problem would it be if those blocks were not necessarily
> >> contiguous in RAM, but placed in normal 4K pages in the page cache?
> >
> > If you need to treat the block in a contiguous range, then you need to
> > vmap() the discontiguous pages. That has substantial overhead if you
> > have to do it regularly.
> 
> Which is why I would prefer not to do it.  I think vmap is not really
> compatible with the design of the linux page cache.

Right - so how do we efficiently  manipulate data inside a large
block that spans multiple discontigous pages if we don't vmap
it?

> Although we can't even count on the pages being mapped into low
> memory right now and have to call kmap if we want to access them
> so things might not be that bad.  Even if it was a multipage kmap
> type operation.

Except when you structures span page boundaries. Then you can't directly
reference the structure - it needs to be copied out elsewhere, modified
and copied back. That's messy and will require significant modification
to any filesystem that wants large block sizes....

> > We do this in xfs_buf.c for > page size blocks - the overhead that
> > caused when operating on inode clusters resulted in us doing some
> > pointer fiddling and directly addresing the contents of each page
> > to avoid the vmap overhead. See xfs_buf_offset() and friends....
> >
> >> I expect meta data operations would have to be modified but that otherwise
> >> you would not care.
> >
> > I think you might need to modify the copy-in and copy-out operations
> > substantially (e.g. prepare_/commit_write()) as they assume a buffer doesn't
> > span multple pages.....
> 
> But in a filesystem like ext2 except for a zeroing some unused hunks
> of the page all that really happens is you setup for DMA straight out
> of the page cache.  So this is primarily an issue for meta-data.

I'm not sure I follow you here - copyin/copyout is to userspace and
has to handle things like RMW cycles to a filesystem block. e.g. if
we get a partial block over-write, we need to read in all the bits
around it and that will span multiple discontiguous pages. Currently
these function only handle RMW operations on something up to a
single page in size - to handle a RMW cycle on a block larger than a
page they are going to need substantial modification or entirely
new interfaces.

The high order page cache avoids the need to redesign interfaces
because it doesn't change the interfaces between the filesystem
and the page cache - everything still effectively operates
on single pages and the filesystem block size never exceeds the
size of a single page.....

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
