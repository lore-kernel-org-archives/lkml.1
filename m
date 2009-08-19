Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZHSQGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZHSQGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZHSQGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:06:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:55954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZHSQEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:48 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>,
       Anton Altaparmakov <aia21@cantab.net>,
       linux-ntfs-dev@lists.sourceforge.net
Subject: [PATCH 12/17] ntfs: Use new syncing helpers and update comments
Date: Wed, 19 Aug 2009 18:04:39 +0200
Message-Id: <1250697884-22288-13-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new syncing helpers in .write and .aio_write functions. Also
remove superfluous syncing in ntfs_file_buffered_write() and update
comments about generic_osync_inode().

CC: Anton Altaparmakov <aia21@cantab.net>
CC: linux-ntfs-dev@lists.sourceforge.net
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ntfs/file.c |   16 ++++------------
 fs/ntfs/mft.c  |   13 ++++++-------
 2 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 3140a44..4350d49 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -2076,14 +2076,6 @@ err_out:
 	*ppos = pos;
 	if (cached_page)
 		page_cache_release(cached_page);
-	/* For now, when the user asks for O_SYNC, we actually give O_DSYNC. */
-	if (likely(!status)) {
-		if (unlikely((file->f_flags & O_SYNC) || IS_SYNC(vi))) {
-			if (!mapping->a_ops->writepage || !is_sync_kiocb(iocb))
-				status = generic_osync_inode(vi, mapping,
-						OSYNC_METADATA|OSYNC_DATA);
-		}
-  	}
 	pagevec_lru_add_file(&lru_pvec);
 	ntfs_debug("Done.  Returning %s (written 0x%lx, status %li).",
 			written ? "written" : "status", (unsigned long)written,
@@ -2145,8 +2137,8 @@ static ssize_t ntfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	mutex_lock(&inode->i_mutex);
 	ret = ntfs_file_aio_write_nolock(iocb, iov, nr_segs, &iocb->ki_pos);
 	mutex_unlock(&inode->i_mutex);
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-		int err = sync_page_range(inode, mapping, pos, ret);
+	if (ret > 0) {
+		int err = generic_write_sync(file, pos, ret);
 		if (err < 0)
 			ret = err;
 	}
@@ -2173,8 +2165,8 @@ static ssize_t ntfs_file_writev(struct file *file, const struct iovec *iov,
 	if (ret == -EIOCBQUEUED)
 		ret = wait_on_sync_kiocb(&kiocb);
 	mutex_unlock(&inode->i_mutex);
-	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
-		int err = sync_page_range(inode, mapping, *ppos - ret, ret);
+	if (ret > 0) {
+		int err = generic_write_sync(file, *ppos - ret, ret);
 		if (err < 0)
 			ret = err;
 	}
diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 23bf684..1caa0ef 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -384,13 +384,12 @@ unm_err_out:
  * it is dirty in the inode meta data rather than the data page cache of the
  * inode, and thus there are no data pages that need writing out.  Therefore, a
  * full mark_inode_dirty() is overkill.  A mark_inode_dirty_sync(), on the
- * other hand, is not sufficient, because I_DIRTY_DATASYNC needs to be set to
- * ensure ->write_inode is called from generic_osync_inode() and this needs to
- * happen or the file data would not necessarily hit the device synchronously,
- * even though the vfs inode has the O_SYNC flag set.  Also, I_DIRTY_DATASYNC
- * simply "feels" better than just I_DIRTY_SYNC, since the file data has not
- * actually hit the block device yet, which is not what I_DIRTY_SYNC on its own
- * would suggest.
+ * other hand, is not sufficient, because ->write_inode needs to be called even
+ * in case of fdatasync. This needs to happen or the file data would not
+ * necessarily hit the device synchronously, even though the vfs inode has the
+ * O_SYNC flag set.  Also, I_DIRTY_DATASYNC simply "feels" better than just
+ * I_DIRTY_SYNC, since the file data has not actually hit the block device yet,
+ * which is not what I_DIRTY_SYNC on its own would suggest.
  */
 void __mark_mft_record_dirty(ntfs_inode *ni)
 {
-- 
1.6.0.2

