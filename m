Return-Path: <linux-kernel-owner+w=401wt.eu-S937516AbXGLAPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937516AbXGLAPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937375AbXGLANI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:13:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46694 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S937379AbXGLANG (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:13:06 -0400
Date: Thu, 12 Jul 2007 10:12:56 +1000
From: David Chinner <dgc@sgi.com>
To: Andrea Arcangeli <andrea@suse.de>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070712001256.GI31489@sgi.com>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com> <20070710101148.GJ1482@v2.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710101148.GJ1482@v2.random>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 12:11:48PM +0200, Andrea Arcangeli wrote:
> On Mon, Jul 09, 2007 at 09:20:31AM +1000, David Chinner wrote:
> > I think you've misunderstood why large block sizes are important to
> > XFS.  The major benefits to XFS of larger block size have almost
> > nothing to do with data layout or in memory indexing - it comes from
> > metadata btree's getting much broader and so we can search much
> > larger spaces using the same number of seeks. It's metadata
> > scalability that I'm concerned about here, not file data.
> 
> I didn't misunderstand. But the reason you can't use a larger
> blocksize than 4k is because the PAGE_SIZE is 4k, and
> CONFIG_PAGE_SHIFT raises the PAGE_SIZE to 8k or more, so you can then
> enlarge the filesystem blocksize too.

Sure, but now we waste more memory on small files....

> > to greatly improve metadata scalability of the filesystem by
> > allowing us to increase the fundamental block size of the filesystem.
> > This, in turn, improves the data I/O scalability of the filesystem.
> 
> Yes I'm aware of this and my patch allows it too the same way, but the
> fundamental difference is that it should help your I/O layout
> optimizations with larger blocksize, while at the same time making the
> _whole_ kernel faster. And it won't even waste more pagecache than a
> variable order page size would (both CONFIG_PAGE_SHIFT and variable
> order page size will waste some pagecache compared to a 4k page
> size). So they better be used for workloads manipulating large files.

The difference is that we can use different blocksizes even
within the one filesystem for small and large files with a
variable page cache. We can't do that with a fixed page size.

> > And given that XFS has different metadata block sizes (even on 4k
> > block size filesystems), it would be really handy to be able to
> > allocate different sized large pages to match all those different
> > block sizes so we could avoid having to play vmap() games....
> 
> That should be possible the same way with both designs.

Not really. If I want a inode cache, it always needs to be 8k based.
If I want a directory cache, it needs to be one of 4k, 8k, 16k, 32k or 64k.
in the same filesystem. the data block size is different again to the
directory block size and the inode block size.

This is where the variable page cache wins hands down. I don't need
to care what page size someone built their kernel with, the file
system can be moved between different page size kernels and *still work*.

> But for your _own_ usage, the big box with lots of ram and where a
> blocksize of 4k is a blocker, my design should be much better because
> it'll give you many more advantages on the CPU side too (the only
> downside is the higher complexity in the pte manipulations).

FWIW, I don't really care all that much about huge HPC machines. Most
of the systems I deal with are 4-8 socket machines with tens to hundreds of
TB of disk. i.e. small CPU count, relatively small memory (64-128GB RAM)
but really large storage subsystems.

I need really large filesystems that contain both small and large files to
work more efficiently on small boxes where we can't throw endless amounts of
RAM and CPUs at the problem.  Hence things like 64k page size are just not an
option because of the wastage that it entails.

> Think, even if you would end up mounting xfs with 64k blocksize on a
> kernel with a 16k PAGE_SIZE, that's still going to be a smaller
> fragmentation risk than using a 64k blocksize on a kernel with a 4k
> PAGE_SIZE, the risk in failing defrag because of alloc_page() = 4k is
> much higher than if the undefragmentable alloc_page returns a 16k
> page. The CPU cost of defrag itself will be diminished by a factor of
> 4 too.
> 
> > e.g. I was recently asked what the downsides of moving from a 16k
> > page to a 64k page size would be - the back-of-the-envelope
> > calculations I did for a cached kernel tree showed it's foot-print
> > increased from about 300MB to ~1.2GB of RAM because 80% of the files
> > in the kernel tree I looked at were smaller than 16k and all that
> > happened is we wasted much more memory on those files.  That's not
> > what you want for your desktop, yet we would like 32-64k pages for
> > the DVD drives.
> 
> The equivalent waste will happen on disk if you raise the blocksize to
> 64k. The same waste will happen as well if you mounted the filesystem
> with the cache kernel tree using a variable order page size of 64k.

See, that's where variable page cache is so good - I don't need to
move everything to 64k block size. We can *easily* do variable
data block size in the filesystem because it's all extent based,
so this really isn't an issue for us on disk. Just changing the
base page size doesn't give us the flexibility we need in memory
to do this....

> > The point that seems to be ignored is that this is not a "one size
> > fits all" type of problem.  This is why the variable page cache may
> > be a better solution if the fragmentation issues can be solved.
> > They've been solved before, so I don't see why they can't be solved
> > again.
> 
> You guys need to explain me how you solved the defrag issue if you
> can't defrag the return value of alloc_page(GFP_KERNEL) = 4k.

Me? I'm a just filesystems weenie, not a vm guru. I don't care about
academic mathematical proof for a defrag algorithm - I just want
something that works. It's the "something that works" that has been
done before....

i.e. I'm not wedded to large pages in the page cache - what I
really, really want is an efficient variable order page cache that
doesn't have any vmap overhead. I don't really care how it is
implemented, but changing the base page size doesn't meet the
"efficiency" or "flexibility" requirement I have.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
