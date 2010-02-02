Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab0BBB4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 20:56:23 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:44960 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab0BBB4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 20:56:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:message-id:cc
         :content-type:content-transfer-encoding;
        b=mSNopl94VL/shJkT79l6HGUudldBRccHdL/NePvff+PQa92HVKDpmLwX6Mj0cQ5juf
         QOiZJcEqjNEWECLU2FvWTqmlhC9FFRw4P/IqfwILyehSOI3xzi2oBdhWW2H4mWzy3+mm
         nfPywJNwd25o6U1IxYHiPA3/fOkBVcFwzIX9U=
From: Edward Shishkin <edward.shishkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       ReiserFS Development List <reiserfs-devel@vger.kernel.org>
Subject: [patch 6/7] reiser4: writeback_inodes implementation
Date: Tue, 2 Feb 2010 02:56:27 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27.41-170.2.117.fc10.i686; KDE/4.3.3; i686; ; )
MIME-Version: 1.0
Message-Id: <201002020256.27208.edward.shishkin@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, jens.axboe@oracle.com
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. add reiser4 implementation of ->writeback_inodes()
  super operation;
. cleanup comments.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
---
 fs/reiser4/context.c    |    3 +-
 fs/reiser4/context.h    |    2 -
 fs/reiser4/entd.c       |    7 ++++--
 fs/reiser4/page_cache.c |   12 +++++------
 fs/reiser4/super_ops.c  |   49 +++++++++++++++++++++++++++++-------------------
 fs/reiser4/txnmgr.c     |    2 -
 6 files changed, 45 insertions(+), 30 deletions(-)

Index: linux-2.6.33-rc5-mm1/fs/reiser4/context.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/context.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/context.c
@@ -151,7 +151,8 @@ static void reiser4_throttle_write_at(re
 	 */
 	if (sbinfo != NULL && sbinfo->fake != NULL &&
 	    context->nr_marked_dirty != 0 &&
-	    !(current->flags & PF_MEMALLOC))
+	    !(current->flags & PF_MEMALLOC) &&
+	    !current_is_flush_bd_task())
 		/* FIXME-EDWARD: throttle with nr_marked_dirty? */
 		reiser4_throttle_write(sbinfo->fake, 1);
 }
Index: linux-2.6.33-rc5-mm1/fs/reiser4/context.h
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/context.h
+++ linux-2.6.33-rc5-mm1/fs/reiser4/context.h
@@ -66,7 +66,7 @@ struct reiser4_context {
 	/* count non-trivial jnode_set_dirty() calls */
 	unsigned long nr_marked_dirty;
 
-	/* reiser4_sync_inodes calls (via generic_sync_sb_inodes)
+	/* reiser4_writeback_inodes calls (via generic_writeback_sb_inodes)
 	 * reiser4_writepages for each of dirty inodes. Reiser4_writepages
 	 * captures pages. When number of pages captured in one
 	 * reiser4_sync_inodes reaches some threshold - some atoms get
Index: linux-2.6.33-rc5-mm1/fs/reiser4/entd.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/entd.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/entd.c
@@ -236,16 +236,19 @@ static void entd_flush(struct super_bloc
 	rq->wbc->range_end = rq->wbc->range_start +
 		(ENTD_CAPTURE_APAGE_BURST << PAGE_CACHE_SHIFT);
 	tmp = rq->wbc->nr_to_write;
+
+	assert("edward-1561", super == rq->wbc->sb);
+
 	rq->mapping->a_ops->writepages(rq->mapping, rq->wbc);
 
 	if (rq->wbc->nr_to_write > 0) {
 		rq->wbc->range_start = 0;
 		rq->wbc->range_end = LLONG_MAX;
-		generic_sync_sb_inodes(rq->wbc);
+		writeback_inodes_wbc(rq->wbc);
 	}
 	rq->wbc->nr_to_write = ENTD_CAPTURE_APAGE_BURST;
-	reiser4_writeout(super, rq->wbc);
 
+	reiser4_writeout(super, rq->wbc);
 	context_set_commit_async(&ctx);
 	reiser4_exit_context(&ctx);
 }
Index: linux-2.6.33-rc5-mm1/fs/reiser4/page_cache.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/page_cache.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/page_cache.c
@@ -486,15 +486,15 @@ static int can_hit_entd(reiser4_context 
 int reiser4_writepage(struct page *page,
 		      struct writeback_control *wbc)
 {
-	struct super_block *s;
-	reiser4_context *ctx;
-
+	/*
+	 * assert("edward-1562",
+	 * can_hit_entd(get_current_context_check(), sb));
+	 */
 	assert("vs-828", PageLocked(page));
 
-	s = page->mapping->host->i_sb;
-	ctx = get_current_context_check();
+	wbc->sb = page->mapping->host->i_sb;
+	wbc->bdi = page->mapping->backing_dev_info;
 
-	/* assert("", can_hit_entd(ctx, s)); */
 	return write_page_by_ent(page, wbc);
 }
 
Index: linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/super_ops.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/super_ops.c
@@ -379,48 +379,59 @@ static void reiser4_clear_inode(struct i
 }
 
 /**
- * reiser4_sync_inodes - sync_inodes of super operations
+ * reiser4_writeback_inodes - writeback_inodes of super operations
  * @super:
+ * @wb:
  * @wbc:
  *
  * This method is called by background and non-backgound writeback. Reiser4's
- * implementation uses generic_sync_sb_inodes to call reiser4_writepages for
- * each of dirty inodes. Reiser4_writepages handles pages dirtied via shared
- * mapping - dirty pages get into atoms. Writeout is called to flush some
- * atoms.
+ * implementation uses generic_writeback_sb_inodes to call reiser4_writepages
+ * for each of dirty inodes. reiser4_writepages handles pages dirtied via shared
+ * mapping - dirty pages get into atoms. Writeout is called to flush some atoms.
  */
-static void reiser4_sync_inodes(struct super_block *super,
-			       struct writeback_control *wbc)
+static int reiser4_writeback_inodes(struct super_block *super,
+				    struct bdi_writeback *wb,
+				    struct writeback_control *wbc)
 {
-	reiser4_context *ctx;
+	int ret;
 	long to_write;
+	reiser4_context *ctx;
 
 	if (wbc->for_kupdate)
 		/* reiser4 has its own means of periodical write-out */
-		return;
-
-	to_write = wbc->nr_to_write;
+		goto skip;
 	assert("vs-49", wbc->older_than_this == NULL);
 
+	spin_unlock(&inode_lock);
 	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx)) {
 		warning("vs-13", "failed to init context");
-		return;
+		spin_lock(&inode_lock);
+		goto skip;
 	}
-
+	to_write = wbc->nr_to_write;
 	/*
-	 * call reiser4_writepages for each of dirty inodes to turn dirty pages
-	 * into transactions if they were not yet.
+	 * call reiser4_writepages for each of dirty inodes to turn
+	 * dirty pages into transactions if they were not yet.
 	 */
-	generic_sync_sb_inodes(wbc);
+	spin_lock(&inode_lock);
+	ret = generic_writeback_sb_inodes(super, wb, wbc);
+	spin_unlock(&inode_lock);
 
-	/* flush goes here */
 	wbc->nr_to_write = to_write;
+
+	/* flush goes here */
 	reiser4_writeout(super, wbc);
 
-	/* avoid recursive calls to ->sync_inodes */
+	/* avoid recursive calls to ->writeback_inodes */
 	context_set_commit_async(ctx);
 	reiser4_exit_context(ctx);
+	spin_lock(&inode_lock);
+
+	return wbc->nr_to_write <= 0 ? 1 : ret;
+ skip:
+	writeback_skip_sb_inodes(super, wb);
+	return 0;
 }
 
 /**
@@ -458,7 +469,7 @@ struct super_operations reiser4_super_op
 	.write_super = reiser4_write_super,
 	.statfs = reiser4_statfs,
 	.clear_inode = reiser4_clear_inode,
-	.sync_inodes = reiser4_sync_inodes,
+	.writeback_inodes = reiser4_writeback_inodes,
 	.show_options = reiser4_show_options
 };
 
Index: linux-2.6.33-rc5-mm1/fs/reiser4/txnmgr.c
===================================================================
--- linux-2.6.33-rc5-mm1.orig/fs/reiser4/txnmgr.c
+++ linux-2.6.33-rc5-mm1/fs/reiser4/txnmgr.c
@@ -1410,7 +1410,7 @@ flush_some_atom(jnode * start, long *nr_
 		 * Write throttling is case of no one atom can be
 		 * flushed/committed.
 		 */
-		if (!wbc->nonblocking) {
+		if (!wbc->nonblocking && !current_is_flush_bd_task()) {
 			list_for_each_entry(atom, &tmgr->atoms_list, atom_link) {
 				spin_lock_atom(atom);
 				/* Repeat the check from the above. */
