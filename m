Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbXL1Qxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbXL1Qxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 11:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754034AbXL1QxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 11:53:23 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58575 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbXL1QxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 11:53:22 -0500
Subject: Re: [PATCH] jfs: clear PAGECACHE_TAG_DIRTY for no-write pages
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jfs-discussion@lists.sourceforge.net,
       Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <1198859101.13075.10.camel@norville.austin.ibm.com>
References: <E1J8AC5-0002BE-RP@localhost>  <1198841626.6821.92.camel@twins>
	 <1198859101.13075.10.camel@norville.austin.ibm.com>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 10:53:14 -0600
Message-Id: <1198860794.13075.15.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-12-28 at 10:25 -0600, Dave Kleikamp wrote:
> On Fri, 2007-12-28 at 12:33 +0100, Peter Zijlstra wrote:

> > I'm not liking this open-coded tag_clear, although I currently fail to
> > come up with a nice solution.
> 
> I'm looking at __block_write_full_page() for guidance.  The situation
> here is similar to writing a page where all the bufferheads are clean.
> __block_write_full_page() always calls set_page_writeback(page), and
> then, if no I/O is initiated, immediately calls
> end_page_writeback(page).
> 
> I'll put together a patch for testing.

Here it is, compile-test only so far.  I borrowed some of the changeset
comments from Fengguang.

JFS: clear PAGECACHE_TAG_DIRTY for no-write pages

When JFS decides to drop a dirty metapage, it simply clears the META_dirty bit
and leave alone the PG_dirty and PAGECACHE_TAG_DIRTY bits.

When such no-write page goes to metapage_writepage(), the `relic'
PAGECACHE_TAG_DIRTY tag should be cleared, to prevent pdflush from
repeatedly trying to sync them.  This is done through
set_page_writeback(), so call it should be called in all cases.  If
no I/O is initiated, end_page_writeback() should be called immediately.

This is how __block_write_full_page() does things.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
CC: Fengguang Wu <wfg@mail.ustc.edu.cn>
---

diff -Nurp linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c linux/fs/jfs/jfs_metapage.c
--- linux-2.6.24-rc6-git5/fs/jfs/jfs_metapage.c	2007-12-28 10:28:33.000000000 -0600
+++ linux/fs/jfs/jfs_metapage.c	2007-12-28 10:37:30.000000000 -0600
@@ -360,6 +360,7 @@ static int metapage_writepage(struct pag
 	struct metapage *mp;
 	int redirty = 0;
 	sector_t lblock;
+	int nr_underway = 0;
 	sector_t pblock;
 	sector_t next_block = 0;
 	sector_t page_start;
@@ -371,6 +372,7 @@ static int metapage_writepage(struct pag
 		     (PAGE_CACHE_SHIFT - inode->i_blkbits);
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
+	set_page_writeback(page);
 
 	for (offset = 0; offset < PAGE_CACHE_SIZE; offset += PSIZE) {
 		mp = page_to_mp(page, offset);
@@ -413,11 +415,10 @@ static int metapage_writepage(struct pag
 			if (!bio->bi_size)
 				goto dump_bio;
 			submit_bio(WRITE, bio);
+			nr_underway++;
 			bio = NULL;
-		} else {
-			set_page_writeback(page);
+		} else
 			inc_io(page);
-		}
 		xlen = (PAGE_CACHE_SIZE - offset) >> inode->i_blkbits;
 		pblock = metapage_get_blocks(inode, lblock, &xlen);
 		if (!pblock) {
@@ -449,12 +450,16 @@ static int metapage_writepage(struct pag
 			goto dump_bio;
 
 		submit_bio(WRITE, bio);
+		nr_underway++;
 	}
 	if (redirty)
 		redirty_page_for_writepage(wbc, page);
 
 	unlock_page(page);
 
+	if (nr_underway == 0)
+		end_page_writeback(page);
+
 	return 0;
 add_failed:
 	/* We should never reach here, since we're only adding one vec */

-- 
David Kleikamp
IBM Linux Technology Center

