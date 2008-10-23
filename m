Return-Path: <linux-kernel-owner+w=401wt.eu-S1757525AbYJWQPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbYJWQPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 12:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYJWQPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 12:15:19 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3344 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYJWQPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 12:15:16 -0400
Date: Thu, 23 Oct 2008 18:15:03 +0200
From: Miquel van Smoorenburg <mikevs@xs4all.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] do_mpage_readpage: don't submit lots of small bios on
	boundary
Message-ID: <20081023161500.GA28181@xs4all.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-NCC-RegID: nl.xs4all
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(not really sure who to put in the Cc list here)

While tracing I/O patterns with blktrace (a great tool) a few
weeks ago I identified a minor issue in fs/mpage.c

[PATCH] do_mpage_readpage: don't submit lots of small bios on boundary

As the comment above mpage_readpages() says, a fs's get_block
function will set BH_Boundary when it maps a block just before
a block for which extra I/O is required.

Since get_block() can map a range of pages, for all these pages
the BH_Boundary flag will be set. But we only need to push what
I/O we have accumulated at the last block of this range.

This makes do_mpage_readpage() send out the largest possible
bio instead of a bunch of page-sized ones in the BH_Boundary case.

Signed-off-by: Miquel van Smoorenburg <mikevs@xs4all.net>

diff -ruN linux-2.6.26.5.orig/fs/mpage.c linux-2.6.26.5/fs/mpage.c
--- linux-2.6.26.5.orig/fs/mpage.c	2008-09-08 19:40:20.000000000 +0200
+++ linux-2.6.26.5/fs/mpage.c	2008-10-23 00:32:11.000000000 +0200
@@ -307,7 +307,10 @@
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
