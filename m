Return-Path: <linux-kernel-owner+w=401wt.eu-S1757991AbXGHXUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991AbXGHXUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbXGHXUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:20:41 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:58902 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751280AbXGHXUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:20:40 -0400
Date: Mon, 9 Jul 2007 09:20:31 +1000
From: David Chinner <dgc@sgi.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070708232031.GF12413810@sgi.com>
References: <20070706222651.GG5777@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070706222651.GG5777@v2.random>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2007 at 12:26:51AM +0200, Andrea Arcangeli wrote:
> The xfs developers for example want to enlarge their filesystem
> blocksize (the filesystem blocksize has a tradeoff similar to the
> PAGE_SIZE, the larger the faster the filesystem but more disk space is
> potentially wasted),

I think you've misunderstood why large block sizes are important to
XFS.  The major benefits to XFS of larger block size have almost
nothing to do with data layout or in memory indexing - it comes from
metadata btree's getting much broader and so we can search much
larger spaces using the same number of seeks. It's metadata
scalability that I'm concerned about here, not file data.

IOWs, larger pages in the page cache are not directly related to
improving data I/O performance of the filesystem, but to allow us
to greatly improve metadata scalability of the filesystem by
allowing us to increase the fundamental block size of the filesystem.
This, in turn, improves the data I/O scalability of the filesystem.

And given that XFS has different metadata block sizes (even on 4k
block size filesystems), it would be really handy to be able to
allocate different sized large pages to match all those different
block sizes so we could avoid having to play vmap() games....

> they also want to use the “normal” writeback
> pagecache efficient behavior when using a writable fs on top of a
> dvd-ram with an hardblocksize of 64k.

In this case "they" != "XFS developers" - you're lumping several
different groups of ppl that want large pages for I/O into one
group.

This is where simply increasing the page size falls down - if you
want to use large block size on your DVD drive (i.e. every desktop
machine out there) you need to use (say) a 64k page size which is
less than ideal for caching the kernel trees that you are currently
compiling.

e.g. I was recently asked what the downsides of moving from a 16k
page to a 64k page size would be - the back-of-the-envelope
calculations I did for a cached kernel tree showed it's foot-print
increased from about 300MB to ~1.2GB of RAM because 80% of the files
in the kernel tree I looked at were smaller than 16k and all that
happened is we wasted much more memory on those files.  That's not
what you want for your desktop, yet we would like 32-64k pages for
the DVD drives.

The point that seems to be ignored is that this is not a "one size
fits all" type of problem.  This is why the variable page cache may
be a better solution if the fragmentation issues can be solved.
They've been solved before, so I don't see why they can't be solved
again.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
