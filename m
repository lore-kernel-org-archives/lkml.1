Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZBGNkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZBGNkZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 08:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbZBGNkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 08:40:11 -0500
Received: from sh.osrg.net ([192.16.179.4]:34418 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162AbZBGNkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 08:40:09 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH mmotm] nilfs2: fix segment summary corruption
Date: Sat,  7 Feb 2009 22:34:53 +0900
Message-Id: <1234013693-2694-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 07 Feb 2009 22:39:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a report from David Arendt, one of the recent bug fixes
(nilfs2-fix-miss-sync-issue-for-do_sync_mapping_range.patch) turned
out to break segment summary under some conditions.

This fixes the problem and clarifies a few routines to prevent similar
regressions.  Thanks to David for his ardent feedbacks.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/segment.c |   81 +++++++++++++++++++++++++--------------------------
 1 files changed, 40 insertions(+), 41 deletions(-)

diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 90de8bb..6d66c5c 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -667,17 +667,16 @@ struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 	.write_node_binfo = NULL,
 };
 
-static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
-					   struct list_head *listp,
-					   struct nilfs_sc_info *sci,
-					   loff_t start, loff_t end)
+static size_t nilfs_lookup_dirty_data_buffers(struct inode *inode,
+					      struct list_head *listp,
+					      size_t nlimit,
+					      loff_t start, loff_t end)
 {
-	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
 	struct address_space *mapping = inode->i_mapping;
 	struct pagevec pvec;
-	unsigned i, ndirties = 0, nlimit;
 	pgoff_t index = 0, last = ULONG_MAX;
-	int err = 0;
+	size_t ndirties = 0;
+	int i;
 
 	if (unlikely(start != 0 || end != LLONG_MAX)) {
 		/*
@@ -688,16 +687,13 @@ static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		index = start >> PAGE_SHIFT;
 		last = end >> PAGE_SHIFT;
 	}
-	nlimit = sci->sc_segbuf_nblocks -
-		(sci->sc_nblk_this_inc + segbuf->sb_sum.nblocks);
-		/* Remaining number of blocks within the segment */
 	pagevec_init(&pvec, 0);
  repeat:
 	if (unlikely(index > last) ||
 	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
 				min_t(pgoff_t, last - index,
 				      PAGEVEC_SIZE - 1) + 1))
-		return 0;
+		return ndirties;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct buffer_head *bh, *head;
@@ -718,25 +714,19 @@ static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		do {
 			if (!buffer_dirty(bh))
 				continue;
-			if (unlikely(ndirties >= nlimit)) {
-				err = -E2BIG; /*
-					       * Internal code to indicate the
-					       * inode has more dirty buffers.
-					       */
-				goto bounded;
-			}
 			get_bh(bh);
 			list_add_tail(&bh->b_assoc_buffers, listp);
 			ndirties++;
+			if (unlikely(ndirties >= nlimit)) {
+				pagevec_release(&pvec);
+				cond_resched();
+				return ndirties;
+			}
 		} while (bh = bh->b_this_page, bh != head);
 	}
- bounded:
 	pagevec_release(&pvec);
 	cond_resched();
-
-	if (!err)
-		goto repeat;
-	return err;
+	goto repeat;
 }
 
 static void nilfs_lookup_dirty_node_buffers(struct inode *inode,
@@ -1090,23 +1080,31 @@ static int nilfs_segctor_apply_buffers(struct nilfs_sc_info *sci,
 	return err;
 }
 
+static size_t nilfs_segctor_buffer_rest(struct nilfs_sc_info *sci)
+{
+	/* Remaining number of blocks within segment buffer */
+	return sci->sc_segbuf_nblocks -
+		(sci->sc_nblk_this_inc + sci->sc_curseg->sb_sum.nblocks);
+}
+
 static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 				   struct inode *inode,
 				   struct nilfs_sc_operations *sc_ops)
 {
 	LIST_HEAD(data_buffers);
 	LIST_HEAD(node_buffers);
-	int err, err2;
+	int err;
 
 	if (!(sci->sc_stage.flags & NILFS_CF_NODE)) {
-		err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers,
-						      sci, 0, LLONG_MAX);
-		if (err) {
-			err2 = nilfs_segctor_apply_buffers(
+		size_t n, rest = nilfs_segctor_buffer_rest(sci);
+
+		n = nilfs_lookup_dirty_data_buffers(
+			inode, &data_buffers, rest + 1, 0, LLONG_MAX);
+		if (n > rest) {
+			err = nilfs_segctor_apply_buffers(
 				sci, inode, &data_buffers,
-				err == -E2BIG ? sc_ops->collect_data : NULL);
-			if (err == -E2BIG)
-				err = err2;
+				sc_ops->collect_data);
+			BUG_ON(!err); /* always receive -E2BIG or true error */
 			goto break_or_fail;
 		}
 	}
@@ -1146,19 +1144,20 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 					 struct inode *inode)
 {
 	LIST_HEAD(data_buffers);
-	int err, err2;
+	size_t n, rest = nilfs_segctor_buffer_rest(sci);
+	int err;
 
-	err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, sci,
-					      sci->sc_dsync_start,
-					      sci->sc_dsync_end);
+	n = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, rest + 1,
+					    sci->sc_dsync_start,
+					    sci->sc_dsync_end);
 
-	err2 = nilfs_segctor_apply_buffers(sci, inode, &data_buffers,
-					   (!err || err == -E2BIG) ?
-					   nilfs_collect_file_data : NULL);
-	if (err == -E2BIG)
-		err = err2;
-	if (!err)
+	err = nilfs_segctor_apply_buffers(sci, inode, &data_buffers,
+					  nilfs_collect_file_data);
+	if (!err) {
 		nilfs_segctor_end_finfo(sci, inode);
+		BUG_ON(n > rest);
+		/* always receive -E2BIG or true error if n > rest */
+	}
 	return err;
 }
 
-- 
1.5.6.5

