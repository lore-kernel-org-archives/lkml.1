Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbXGJKMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbXGJKMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbXGJKMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:12:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:57814 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757411AbXGJKMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:12:02 -0400
Date: Tue, 10 Jul 2007 12:11:48 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: RFC: CONFIG_PAGE_SHIFT (aka software PAGE_SIZE)
Message-ID: <20070710101148.GJ1482@v2.random>
References: <20070706222651.GG5777@v2.random> <20070708232031.GF12413810@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070708232031.GF12413810@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 09:20:31AM +1000, David Chinner wrote:
> I think you've misunderstood why large block sizes are important to
> XFS.  The major benefits to XFS of larger block size have almost
> nothing to do with data layout or in memory indexing - it comes from
> metadata btree's getting much broader and so we can search much
> larger spaces using the same number of seeks. It's metadata
> scalability that I'm concerned about here, not file data.

I didn't misunderstand. But the reason you can't use a larger
blocksize than 4k is because the PAGE_SIZE is 4k, and
CONFIG_PAGE_SHIFT raises the PAGE_SIZE to 8k or more, so you can then
enlarge the filesystem blocksize too.

> IOWs, larger pages in the page cache are not directly related to
> improving data I/O performance of the filesystem, but to allow us

Of course, for I/O performance the CPU cost is mostly irrelevant,
especially with slow storage.

> to greatly improve metadata scalability of the filesystem by
> allowing us to increase the fundamental block size of the filesystem.
> This, in turn, improves the data I/O scalability of the filesystem.

Yes I'm aware of this and my patch allows it too the same way, but the
fundamental difference is that it should help your I/O layout
optimizations with larger blocksize, while at the same time making the
_whole_ kernel faster. And it won't even waste more pagecache than a
variable order page size would (both CONFIG_PAGE_SHIFT and variable
order page size will waste some pagecache compared to a 4k page
size). So they better be used for workloads manipulating large files.

> And given that XFS has different metadata block sizes (even on 4k
> block size filesystems), it would be really handy to be able to
> allocate different sized large pages to match all those different
> block sizes so we could avoid having to play vmap() games....

That should be possible the same way with both designs.

> In this case "they" != "XFS developers" - you're lumping several
> different groups of ppl that want large pages for I/O into one
> group.

Sorry.

> This is where simply increasing the page size falls down - if you
> want to use large block size on your DVD drive (i.e. every desktop
> machine out there) you need to use (say) a 64k page size which is
> less than ideal for caching the kernel trees that you are currently
> compiling.

Totally agreed, your approach would be much better for dvd on the
desktop. If only I could trust it to be reliable (I guess I'd rather
stick to growisofs).

But for your _own_ usage, the big box with lots of ram and where a
blocksize of 4k is a blocker, my design should be much better because
it'll give you many more advantages on the CPU side too (the only
downside is the higher complexity in the pte manipulations).

Think, even if you would end up mounting xfs with 64k blocksize on a
kernel with a 16k PAGE_SIZE, that's still going to be a smaller
fragmentation risk than using a 64k blocksize on a kernel with a 4k
PAGE_SIZE, the risk in failing defrag because of alloc_page() = 4k is
much higher than if the undefragmentable alloc_page returns a 16k
page. The CPU cost of defrag itself will be diminished by a factor of
4 too.

> e.g. I was recently asked what the downsides of moving from a 16k
> page to a 64k page size would be - the back-of-the-envelope
> calculations I did for a cached kernel tree showed it's foot-print
> increased from about 300MB to ~1.2GB of RAM because 80% of the files
> in the kernel tree I looked at were smaller than 16k and all that
> happened is we wasted much more memory on those files.  That's not
> what you want for your desktop, yet we would like 32-64k pages for
> the DVD drives.

The equivalent waste will happen on disk if you raise the blocksize to
64k. The same waste will happen as well if you mounted the filesystem
with the cache kernel tree using a variable order page size of 64k.

I guess for maximizing cache usage during kernel development the ideal
PAGE_SIZE would be smaller than 4k...

> The point that seems to be ignored is that this is not a "one size
> fits all" type of problem.  This is why the variable page cache may
> be a better solution if the fragmentation issues can be solved.
> They've been solved before, so I don't see why they can't be solved
> again.

You guys need to explain me how you solved the defrag issue if you
can't defrag the return value of alloc_page(GFP_KERNEL) =
4k. Furthermore you never seem to account the CPU cost of defrag on
big systems that may need to memcpy a lot of ram. My design doesn't
need proofs, it never requires memcpy, and it'll just always run as
fast as right after boot. Boosting the PAGE_SIZE is more a black and
white and predictable think so I've no doubt I prefer it.

BTW, I asked Hugh to look into Bill's and Hugh's old patch to see if
there's some goodness we can copy to solve things like the underlying
overlapping anon page after writeprotect faults over
MAP_PRIVATE. Perhaps there's a better way than looking the nearby pte
for a pte pointing to PG_anon or a swap entry which is my current
idea. This is assuming their old patches were really using a similar
design to mine (btw, back then there was no PG_anon but I guess
checking page->mapping for null would have been enough to tell it was
an anon page).

Hugh also reminded me that at KS some year ago their old patch
boosting the PAGE_SIZE was dismissed because it looked unnecessary,
the major reason for wanting it back then was the mem_map_t array
size, and that's not an issue anymore on 64bit archs. But back then,
nobody proposed to boost the pagecache to order > 0 allocations, so
this is one reason why _now_ it's different. It's really your variable
order page size and the defrag efforts that don't math-proof guarantee
defrag, that triggered my interest in CONFIG_PAGE_SHIFT.
