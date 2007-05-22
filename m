Return-Path: <linux-kernel-owner+w=401wt.eu-S1765516AbXEVCl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765516AbXEVCl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbXEVClu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:41:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:46933 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240AbXEVClt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:41:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [PATCH 3/3] rd: Simplify by using the same helper functions in libfs
References: <m14pm5io6h.fsf@ebiederm.dsl.xmission.com>
	<m1zm3xh9do.fsf@ebiederm.dsl.xmission.com>
Date: Mon, 21 May 2007 20:40:02 -0600
In-Reply-To: <m1zm3xh9do.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Mon, 21 May 2007 20:36:51 -0600")
Message-ID: <m1veelh98d.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While the ramdisk code in the page cache started with the ramfs
code it has diverged, and is a result is more complicated then
it currently needs to be.  This patch simplifies the ramfs
code by syncing it with ramfs and similar pieces of code.

The big difference is that the ramdisk must cope with people placing
buffer heads on it's pages so there is extra code required to mark
those buffer heads dirty and uptodate.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/block/rd.c |   76 +++------------------------------------------------
 1 files changed, 5 insertions(+), 71 deletions(-)

diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index 41de0f4..56b2b54 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -92,36 +92,16 @@ static int rd_blocksize = CONFIG_BLK_DEV_RAM_BLOCKSIZE;
  * aops copied from ramfs.
  */
 
-/*
- * If a ramdisk page has buffers, some may be uptodate and some may be not.
- * To bring the page uptodate we zero out the non-uptodate buffers.  The
- * page must be locked.
- */
 static void make_page_uptodate(struct page *page)
 {
+	clear_highpage(page);
 	if (page_has_buffers(page)) {
 		struct buffer_head *bh = page_buffers(page);
 		struct buffer_head *head = bh;
 
 		do {
-			if (!buffer_uptodate(bh)) {
-				memset(bh->b_data, 0, bh->b_size);
-				/*
-				 * akpm: I'm totally undecided about this.  The
-				 * buffer has just been magically brought "up to
-				 * date", but nobody should want to be reading
-				 * it anyway, because it hasn't been used for
-				 * anything yet.  It is still in a "not read
-				 * from disk yet" state.
-				 *
-				 * But non-uptodate buffers against an uptodate
-				 * page are against the rules.  So do it anyway.
-				 */
-				 set_buffer_uptodate(bh);
-			}
+			set_buffer_uptodate(bh);
 		} while ((bh = bh->b_this_page) != head);
-	} else {
-		memset(page_address(page), 0, PAGE_CACHE_SIZE);
 	}
 	flush_dcache_page(page);
 	SetPageUptodate(page);
@@ -129,55 +109,11 @@ static void make_page_uptodate(struct page *page)
 
 static int ramdisk_readpage(struct file *file, struct page *page)
 {
-	if (!PageUptodate(page))
-		make_page_uptodate(page);
+	make_page_uptodate(page);
 	unlock_page(page);
 	return 0;
 }
 
-static int ramdisk_prepare_write(struct file *file, struct page *page,
-				unsigned offset, unsigned to)
-{
-	if (!PageUptodate(page))
-		make_page_uptodate(page);
-	return 0;
-}
-
-static int ramdisk_commit_write(struct file *file, struct page *page,
-				unsigned offset, unsigned to)
-{
-	set_page_dirty(page);
-	return 0;
-}
-
-/*
- * ->writepage to the blockdev's mapping has to redirty the page so that the
- * VM doesn't go and steal it.  We return AOP_WRITEPAGE_ACTIVATE so that the VM
- * won't try to (pointlessly) write the page again for a while.
- *
- * Really, these pages should not be on the LRU at all.
- */
-static int ramdisk_writepage(struct page *page, struct writeback_control *wbc)
-{
-	if (!PageUptodate(page))
-		make_page_uptodate(page);
-	SetPageDirty(page);
-	if (wbc->for_reclaim)
-		return AOP_WRITEPAGE_ACTIVATE;
-	unlock_page(page);
-	return 0;
-}
-
-/*
- * This is a little speedup thing: short-circuit attempts to write back the
- * ramdisk blockdev inode to its non-existent backing store.
- */
-static int ramdisk_writepages(struct address_space *mapping,
-				struct writeback_control *wbc)
-{
-	return 0;
-}
-
 /*
  * ramdisk blockdev pages have their own ->set_page_dirty() because we don't
  * want them to contribute to dirty memory accounting.
@@ -206,11 +142,9 @@ static int ramdisk_set_page_dirty(struct page *page)
 
 static const struct address_space_operations ramdisk_aops = {
 	.readpage	= ramdisk_readpage,
-	.prepare_write	= ramdisk_prepare_write,
-	.commit_write	= ramdisk_commit_write,
-	.writepage	= ramdisk_writepage,
+	.prepare_write	= simple_prepare_write,
+	.commit_write	= simple_commit_write,
 	.set_page_dirty	= ramdisk_set_page_dirty,
-	.writepages	= ramdisk_writepages,
 };
 
 static int rd_blkdev_pagecache_IO(int rw, struct bio_vec *vec, sector_t sector,
-- 
1.5.1.1.181.g2de0

