Return-Path: <linux-kernel-owner+w=401wt.eu-S1752484AbYKAJWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbYKAJWU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 05:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYKAJWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 05:22:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33867 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751304AbYKAJWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 05:22:08 -0400
Date: Sat, 1 Nov 2008 02:21:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chad Talbott <ctalbott@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Rubin <mrubin@google.com>
Subject: Re: Metadata in sys_sync_file_range and fadvise(DONTNEED)
Message-Id: <20081101022128.3f8a535c.akpm@linux-foundation.org>
In-Reply-To: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
References: <1786ab030810311354h1a7c8fb0q1267969d432f521c@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 13:54:14 -0700 Chad Talbott <ctalbott@google.com> wrote:

> We are looking at adding calls to posix_fadvise(DONTNEED) to various
> data logging routines.  This has two benefits:
> 
>   - frequent write-out -> shorter queues give lower latency, also disk
>     is more utilized as writeout begins immediately
> 
>   - less useless stuff in page cache
> 
> One problem with fadvise() (and ext2, at least) is that associated
> metadata isn't scheduled with the data.  So, for a large log file with
> a high append rate, hundreds of indirect blocks are left to be written
> out by periodic writeback.  This metadata consists of single blocks
> spaced by 4MB, leading to spikes of very inefficient disk utilization,
> deep queues and high latency.
> 
> Andrew suggests a new SYNC_FILE_RANGE_METADATA flag for
> sys_sync_file_range(), and leaving posix_fadvise() alone.  That will
> work for my purposes, but it seems like it leaves
> posix_fadvise(DONTNEED) with a performance bug on ext2 (or any other
> filesystem with interleaved data/metadata).  Andrew's argument is that
> people have expectations about posix_fadvise() behavior as it's been
> around for years in Linux.

Sort-of.  It's just that posix_fadvise() is so poorly defined, and
there is some need to be compatible with other implementations.

And fadvise(FADV_DONTNEED) is just that: "I won't be using that data
again".  Implementing specific writeback behaviour underneath that hint
is unobvious and a bit weird.  It's a bit of a fluke that it does
writeout at all!

We have much more flexibility with sync_file_range(), and it is more
explicit.


That being said, I don't understand why the IO scheduling problems
which you're seeing are occurring.  There is code in fs/mpage.c
specifically to handle this case (search for "write_boundary_block"). 
It will spot that 4k indirect block in the middle of two 4MB data
blocks and will schedule it for writeout at the right time.

So why isn't that working?

The below (I merged it this week) is kinda related...



From: Miquel van Smoorenburg <mikevs@xs4all.net>

While tracing I/O patterns with blktrace (a great tool) a few weeks ago I
identified a minor issue in fs/mpage.c

As the comment above mpage_readpages() says, a fs's get_block function
will set BH_Boundary when it maps a block just before a block for which
extra I/O is required.

Since get_block() can map a range of pages, for all these pages the
BH_Boundary flag will be set.  But we only need to push what I/O we have
accumulated at the last block of this range.

This makes do_mpage_readpage() send out the largest possible bio instead
of a bunch of page-sized ones in the BH_Boundary case.

Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mpage.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/mpage.c~do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary fs/mpage.c
--- a/fs/mpage.c~do_mpage_readpage-dont-submit-lots-of-small-bios-on-boundary
+++ a/fs/mpage.c
@@ -308,7 +308,10 @@ alloc_new:
 		goto alloc_new;
 	}
 
-	if (buffer_boundary(map_bh) || (first_hole != blocks_per_page))
+	relative_block = block_in_file - *first_logical_block;
+	nblocks = map_bh->b_size >> blkbits;
+	if ((buffer_boundary(map_bh) && relative_block == nblocks) ||
+	    (first_hole != blocks_per_page))
 		bio = mpage_bio_submit(READ, bio);
 	else
 		*last_block_in_bio = blocks[blocks_per_page - 1];
_


