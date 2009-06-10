Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZFJJie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZFJJie (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 05:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZFJJiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 05:38:00 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbZFJJh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 05:37:58 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/24] GFS2: Optimise writepage for metadata
Date: Wed, 10 Jun 2009 09:30:43 +0100
Message-Id: <1244622665-7470-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
References: <1244622665-7470-1-git-send-email-swhiteho@redhat.com>
 <1244622665-7470-2-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a GFS2 specific writepage for metadata, rather than
continuing to use the VFS function. As a result we now tag all
our metadata I/O with the correct flag so that blktraces will
now be less confusing.

Also, the generic function was checking for a number of corner
cases which cannot happen on the metadata address spaces so that
this should be faster too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 75b2aec..78a5f43 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -33,17 +33,65 @@
 #include "util.h"
 #include "ops_address.h"
 
-static int aspace_get_block(struct inode *inode, sector_t lblock,
-			    struct buffer_head *bh_result, int create)
+static int gfs2_aspace_writepage(struct page *page, struct writeback_control *wbc)
 {
-	gfs2_assert_warn(inode->i_sb->s_fs_info, 0);
-	return -EOPNOTSUPP;
-}
+	int err;
+	struct buffer_head *bh, *head;
+	int nr_underway = 0;
+	int write_op = (1 << BIO_RW_META) | ((wbc->sync_mode == WB_SYNC_ALL ?
+			WRITE_SYNC_PLUG : WRITE));
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(!page_has_buffers(page));
+
+	head = page_buffers(page);
+	bh = head;
+
+	do {
+		if (!buffer_mapped(bh))
+			continue;
+		/*
+		 * If it's a fully non-blocking write attempt and we cannot
+		 * lock the buffer then redirty the page.  Note that this can
+		 * potentially cause a busy-wait loop from pdflush and kswapd
+		 * activity, but those code paths have their own higher-level
+		 * throttling.
+		 */
+		if (wbc->sync_mode != WB_SYNC_NONE || !wbc->nonblocking) {
+			lock_buffer(bh);
+		} else if (!trylock_buffer(bh)) {
+			redirty_page_for_writepage(wbc, page);
+			continue;
+		}
+		if (test_clear_buffer_dirty(bh)) {
+			mark_buffer_async_write(bh);
+		} else {
+			unlock_buffer(bh);
+		}
+	} while ((bh = bh->b_this_page) != head);
+
+	/*
+	 * The page and its buffers are protected by PageWriteback(), so we can
+	 * drop the bh refcounts early.
+	 */
+	BUG_ON(PageWriteback(page));
+	set_page_writeback(page);
+
+	do {
+		struct buffer_head *next = bh->b_this_page;
+		if (buffer_async_write(bh)) {
+			submit_bh(write_op, bh);
+			nr_underway++;
+		}
+		bh = next;
+	} while (bh != head);
+	unlock_page(page);
 
-static int gfs2_aspace_writepage(struct page *page,
-				 struct writeback_control *wbc)
-{
-	return block_write_full_page(page, aspace_get_block, wbc);
+	err = 0;
+	if (nr_underway == 0)
+		end_page_writeback(page);
+
+	return err;
 }
 
 static const struct address_space_operations aspace_aops = {
-- 
1.6.0.6

