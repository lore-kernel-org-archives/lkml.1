Return-Path: <linux-kernel-owner+w=401wt.eu-S1758613AbZANEbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613AbZANEbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:31:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZANEbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:31:24 -0500
Received: from sh.osrg.net ([192.16.179.4]:48946 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbZANEbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:31:23 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH mmotm] nilfs2: fix miss-sync issue for do_sync_mapping_range
Date: Wed, 14 Jan 2009 13:27:54 +0900
Message-Id: <1231907274-508-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason pointed out that there is a miss sync issue in
nilfs_writepages():

On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> It looks like nilfs_writepage ignores WB_SYNC_NONE, which is used by
> do_sync_mapping_range().

where WB_SYNC_NONE in do_sync_mapping_range() was replaced with
WB_SYNC_ALL by a Nick's patch
(commit: ee53a891f47444c53318b98dac947ede963db400).

This fixes the problem by letting nilfs_writepages() write out the log
of file data within the range if sync_mode is WB_SYNC_ALL.

This involves removal of nilfs_file_aio_write() which was previously
needed to ensure O_SYNC sync writes.

Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c    |   27 ++-----------------
 fs/nilfs2/inode.c   |   16 ++++++-----
 fs/nilfs2/segment.c |   69 ++++++++++++++++++++++++++++++++++----------------
 fs/nilfs2/segment.h |   11 ++++++-
 4 files changed, 68 insertions(+), 55 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index c22f97c..34c751b 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -44,35 +44,14 @@ int nilfs_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		return 0;
 
 	if (datasync)
-		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode, 0,
+						    LLONG_MAX);
 	else
 		err = nilfs_construct_segment(inode->i_sb);
 
 	return err;
 }
 
-static ssize_t
-nilfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
-		     unsigned long nr_segs, loff_t pos)
-{
-	struct file *file = iocb->ki_filp;
-	struct inode *inode = file->f_dentry->d_inode;
-	ssize_t ret;
-
-	ret = generic_file_aio_write(iocb, iov, nr_segs, pos);
-	if (ret <= 0)
-		return ret;
-
-	if ((file->f_flags & O_SYNC) || IS_SYNC(inode)) {
-		int err;
-
-		err = nilfs_construct_dsync_segment(inode->i_sb, inode);
-		if (unlikely(err))
-			return err;
-	}
-	return ret;
-}
-
 static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
 	struct inode *inode = vma->vm_file->f_dentry->d_inode;
@@ -158,7 +137,7 @@ struct file_operations nilfs_file_operations = {
 	.read		= do_sync_read,
 	.write		= do_sync_write,
 	.aio_read	= generic_file_aio_read,
-	.aio_write	= nilfs_file_aio_write,
+	.aio_write	= generic_file_aio_write,
 	.ioctl		= nilfs_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= nilfs_compat_ioctl,
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index e29e329..4bf1e2c 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -24,6 +24,7 @@
 #include <linux/buffer_head.h>
 #include <linux/mpage.h>
 #include <linux/writeback.h>
+#include <linux/uio.h>
 #include "nilfs.h"
 #include "segment.h"
 #include "page.h"
@@ -146,8 +147,14 @@ static int nilfs_readpages(struct file *file, struct address_space *mapping,
 static int nilfs_writepages(struct address_space *mapping,
 			    struct writeback_control *wbc)
 {
-	/* This empty method is required not to call generic_writepages() */
-	return 0;
+	struct inode *inode = mapping->host;
+	int err = 0;
+
+	if (wbc->sync_mode == WB_SYNC_ALL)
+		err = nilfs_construct_dsync_segment(inode->i_sb, inode,
+						    wbc->range_start,
+						    wbc->range_end);
+	return err;
 }
 
 static int nilfs_writepage(struct page *page, struct writeback_control *wbc)
@@ -226,11 +233,6 @@ nilfs_direct_IO(int rw, struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file->f_mapping->host;
 	ssize_t size;
-	int err;
-
-	err = nilfs_construct_dsync_segment(inode->i_sb, inode);
-	if (unlikely(err))
-		return err;
 
 	if (rw == WRITE)
 		return 0;
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index b4b96ac..90de8bb 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -669,27 +669,43 @@ struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 
 static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 					   struct list_head *listp,
-					   struct nilfs_sc_info *sci)
+					   struct nilfs_sc_info *sci,
+					   loff_t start, loff_t end)
 {
 	struct nilfs_segment_buffer *segbuf = sci->sc_curseg;
 	struct address_space *mapping = inode->i_mapping;
 	struct pagevec pvec;
 	unsigned i, ndirties = 0, nlimit;
-	pgoff_t index = 0;
+	pgoff_t index = 0, last = ULONG_MAX;
 	int err = 0;
 
+	if (unlikely(start != 0 || end != LLONG_MAX)) {
+		/*
+		 * A valid range is given for sync-ing data pages. The
+		 * range is rounded to per-page; extra dirty buffers
+		 * may be included if blocksize < pagesize.
+		 */
+		index = start >> PAGE_SHIFT;
+		last = end >> PAGE_SHIFT;
+	}
 	nlimit = sci->sc_segbuf_nblocks -
 		(sci->sc_nblk_this_inc + segbuf->sb_sum.nblocks);
+		/* Remaining number of blocks within the segment */
 	pagevec_init(&pvec, 0);
  repeat:
-	if (!pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
-				PAGEVEC_SIZE))
+	if (unlikely(index > last) ||
+	    !pagevec_lookup_tag(&pvec, mapping, &index, PAGECACHE_TAG_DIRTY,
+				min_t(pgoff_t, last - index,
+				      PAGEVEC_SIZE - 1) + 1))
 		return 0;
 
 	for (i = 0; i < pagevec_count(&pvec); i++) {
 		struct buffer_head *bh, *head;
 		struct page *page = pvec.pages[i];
 
+		if (unlikely(page->index > last))
+			break;
+
 		if (mapping->host) {
 			lock_page(page);
 			if (!page_has_buffers(page))
@@ -700,18 +716,21 @@ static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 
 		bh = head = page_buffers(page);
 		do {
-			if (buffer_dirty(bh)) {
-				if (ndirties > nlimit) {
-					err = -E2BIG;
-					break;
-				}
-				get_bh(bh);
-				list_add_tail(&bh->b_assoc_buffers, listp);
-				ndirties++;
+			if (!buffer_dirty(bh))
+				continue;
+			if (unlikely(ndirties >= nlimit)) {
+				err = -E2BIG; /*
+					       * Internal code to indicate the
+					       * inode has more dirty buffers.
+					       */
+				goto bounded;
 			}
-			bh = bh->b_this_page;
-		} while (bh != head);
+			get_bh(bh);
+			list_add_tail(&bh->b_assoc_buffers, listp);
+			ndirties++;
+		} while (bh = bh->b_this_page, bh != head);
 	}
+ bounded:
 	pagevec_release(&pvec);
 	cond_resched();
 
@@ -1081,7 +1100,7 @@ static int nilfs_segctor_scan_file(struct nilfs_sc_info *sci,
 
 	if (!(sci->sc_stage.flags & NILFS_CF_NODE)) {
 		err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers,
-						      sci);
+						      sci, 0, LLONG_MAX);
 		if (err) {
 			err2 = nilfs_segctor_apply_buffers(
 				sci, inode, &data_buffers,
@@ -1129,7 +1148,10 @@ static int nilfs_segctor_scan_file_dsync(struct nilfs_sc_info *sci,
 	LIST_HEAD(data_buffers);
 	int err, err2;
 
-	err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, sci);
+	err = nilfs_lookup_dirty_data_buffers(inode, &data_buffers, sci,
+					      sci->sc_dsync_start,
+					      sci->sc_dsync_end);
+
 	err2 = nilfs_segctor_apply_buffers(sci, inode, &data_buffers,
 					   (!err || err == -E2BIG) ?
 					   nilfs_collect_file_data : NULL);
@@ -1289,14 +1311,13 @@ static int nilfs_segctor_collect_blocks(struct nilfs_sc_info *sci, int mode)
 	case NILFS_ST_DSYNC:
  dsync_mode:
 		sci->sc_curseg->sb_sum.flags |= NILFS_SS_SYNDT;
-		ii = sci->sc_stage.dirty_file_ptr;
+		ii = sci->sc_dsync_inode;
 		if (!test_bit(NILFS_I_BUSY, &ii->i_state))
 			break;
 
 		err = nilfs_segctor_scan_file_dsync(sci, &ii->vfs_inode);
 		if (unlikely(err))
 			break;
-		sci->sc_stage.dirty_file_ptr = NULL;
 		sci->sc_curseg->sb_sum.flags |= NILFS_SS_LOGEND;
 		sci->sc_stage.scnt = NILFS_ST_DONE;
 		return 0;
@@ -2637,7 +2658,9 @@ int nilfs_construct_segment(struct super_block *sb)
 /**
  * nilfs_construct_dsync_segment - construct a data-only logical segment
  * @sb: super block
- * @inode: the inode whose data blocks should be written out
+ * @inode: inode whose data blocks should be written out
+ * @start: start byte offset
+ * @end: end byte offset (inclusive)
  *
  * Return Value: On success, 0 is retured. On errors, one of the following
  * negative error code is returned.
@@ -2652,8 +2675,8 @@ int nilfs_construct_segment(struct super_block *sb)
  *
  * %-ENOMEM - Insufficient memory available.
  */
-int nilfs_construct_dsync_segment(struct super_block *sb,
-				  struct inode *inode)
+int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
+				  loff_t start, loff_t end)
 {
 	struct nilfs_sb_info *sbi = NILFS_SB(sb);
 	struct nilfs_sc_info *sci = NILFS_SC(sbi);
@@ -2684,7 +2707,9 @@ int nilfs_construct_dsync_segment(struct super_block *sb,
 		return 0;
 	}
 	spin_unlock(&sbi->s_inode_lock);
-	sci->sc_stage.dirty_file_ptr = ii;
+	sci->sc_dsync_inode = ii;
+	sci->sc_dsync_start = start;
+	sci->sc_dsync_end = end;
 
 	err = nilfs_segctor_do_construct(sci, SC_LSEG_DSYNC);
 
diff --git a/fs/nilfs2/segment.h b/fs/nilfs2/segment.h
index 615654b..2dd39da 100644
--- a/fs/nilfs2/segment.h
+++ b/fs/nilfs2/segment.h
@@ -93,6 +93,9 @@ struct nilfs_segsum_pointer {
  * @sc_active_segments: List of active segments that were already written out
  * @sc_cleaning_segments: List of segments to be freed through construction
  * @sc_copied_buffers: List of copied buffers (buffer heads) to freeze data
+ * @sc_dsync_inode: inode whose data pages are written for a sync operation
+ * @sc_dsync_start: start byte offset of data pages
+ * @sc_dsync_end: end byte offset of data pages (inclusive)
  * @sc_segbufs: List of segment buffers
  * @sc_segbuf_nblocks: Number of available blocks in segment buffers.
  * @sc_curseg: Current segment buffer
@@ -134,6 +137,10 @@ struct nilfs_sc_info {
 	struct list_head	sc_cleaning_segments;
 	struct list_head	sc_copied_buffers;
 
+	struct nilfs_inode_info *sc_dsync_inode;
+	loff_t			sc_dsync_start;
+	loff_t			sc_dsync_end;
+
 	/* Segment buffers */
 	struct list_head	sc_segbufs;
 	unsigned long		sc_segbuf_nblocks;
@@ -221,8 +228,8 @@ extern void nilfs_destroy_transaction_cache(void);
 extern void nilfs_relax_pressure_in_lock(struct super_block *);
 
 extern int nilfs_construct_segment(struct super_block *);
-extern int nilfs_construct_dsync_segment(struct super_block *,
-					 struct inode *);
+extern int nilfs_construct_dsync_segment(struct super_block *, struct inode *,
+					 loff_t, loff_t);
 extern void nilfs_flush_segment(struct super_block *, ino_t);
 extern int nilfs_clean_segments(struct super_block *, void __user *);
 
-- 
1.5.6.5

