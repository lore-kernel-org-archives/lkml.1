Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZFHT0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZFHT0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 15:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754859AbZFHTX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 15:23:28 -0400
Received: from thunk.org ([69.25.196.29]:39550 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbZFHTXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 15:23:16 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 48/49] ext4: truncate the file properly if we fail to copy data from userspace
Date: Mon,  8 Jun 2009 15:23:06 -0400
Message-Id: <1244488987-32564-49-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
In-Reply-To: <1244488987-32564-48-git-send-email-tytso@mit.edu>
References: <1244488987-32564-1-git-send-email-tytso@mit.edu>
 <1244488987-32564-2-git-send-email-tytso@mit.edu>
 <1244488987-32564-3-git-send-email-tytso@mit.edu>
 <1244488987-32564-4-git-send-email-tytso@mit.edu>
 <1244488987-32564-5-git-send-email-tytso@mit.edu>
 <1244488987-32564-6-git-send-email-tytso@mit.edu>
 <1244488987-32564-7-git-send-email-tytso@mit.edu>
 <1244488987-32564-8-git-send-email-tytso@mit.edu>
 <1244488987-32564-9-git-send-email-tytso@mit.edu>
 <1244488987-32564-10-git-send-email-tytso@mit.edu>
 <1244488987-32564-11-git-send-email-tytso@mit.edu>
 <1244488987-32564-12-git-send-email-tytso@mit.edu>
 <1244488987-32564-13-git-send-email-tytso@mit.edu>
 <1244488987-32564-14-git-send-email-tytso@mit.edu>
 <1244488987-32564-15-git-send-email-tytso@mit.edu>
 <1244488987-32564-16-git-send-email-tytso@mit.edu>
 <1244488987-32564-17-git-send-email-tytso@mit.edu>
 <1244488987-32564-18-git-send-email-tytso@mit.edu>
 <1244488987-32564-19-git-send-email-tytso@mit.edu>
 <1244488987-32564-20-git-send-email-tytso@mit.edu>
 <1244488987-32564-21-git-send-email-tytso@mit.edu>
 <1244488987-32564-22-git-send-email-tytso@mit.edu>
 <1244488987-32564-23-git-send-email-tytso@mit.edu>
 <1244488987-32564-24-git-send-email-tytso@mit.edu>
 <1244488987-32564-25-git-send-email-tytso@mit.edu>
 <1244488987-32564-26-git-send-email-tytso@mit.edu>
 <1244488987-32564-27-git-send-email-tytso@mit.edu>
 <1244488987-32564-28-git-send-email-tytso@mit.edu>
 <1244488987-32564-29-git-send-email-tytso@mit.edu>
 <1244488987-32564-30-git-send-email-tytso@mit.edu>
 <1244488987-32564-31-git-send-email-tytso@mit.edu>
 <1244488987-32564-32-git-send-email-tytso@mit.edu>
 <1244488987-32564-33-git-send-email-tytso@mit.edu>
 <1244488987-32564-34-git-send-email-tytso@mit.edu>
 <1244488987-32564-35-git-send-email-tytso@mit.edu>
 <1244488987-32564-36-git-send-email-tytso@mit.edu>
 <1244488987-32564-37-git-send-email-tytso@mit.edu>
 <1244488987-32564-38-git-send-email-tytso@mit.edu>
 <1244488987-32564-39-git-send-email-tytso@mit.edu>
 <1244488987-32564-40-git-send-email-tytso@mit.edu>
 <1244488987-32564-41-git-send-email-tytso@mit.edu>
 <1244488987-32564-42-git-send-email-tytso@mit.edu>
 <1244488987-32564-43-git-send-email-tytso@mit.edu>
 <1244488987-32564-44-git-send-email-tytso@mit.edu>
 <1244488987-32564-45-git-send-email-tytso@mit.edu>
 <1244488987-32564-46-git-send-email-tytso@mit.edu>
 <1244488987-32564-47-git-send-email-tytso@mit.edu>
 <1244488987-32564-48-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

In generic_perform_write if we fail to copy the user data we don't
update the inode->i_size.  We should truncate the file in the above
case so that we don't have blocks allocated outside inode->i_size.  Add
the inode to orphan list in the same transaction as block allocation
This ensures that if we crash in between the recovery would do the
truncate.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
CC:  Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |  128 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 102 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 036552a..5dc6c3d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1552,6 +1552,52 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 	return ext4_handle_dirty_metadata(handle, NULL, bh);
 }
 
+static int ext4_generic_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	int i_size_changed = 0;
+	struct inode *inode = mapping->host;
+	handle_t *handle = ext4_journal_current_handle();
+
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+
+	/*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold i_mutex.
+	 *
+	 * But it's important to update i_size while still holding page lock:
+	 * page writeout could otherwise come in and zero beyond i_size.
+	 */
+	if (pos + copied > inode->i_size) {
+		i_size_write(inode, pos + copied);
+		i_size_changed = 1;
+	}
+
+	if (pos + copied >  EXT4_I(inode)->i_disksize) {
+		/* We need to mark inode dirty even if
+		 * new_i_size is less that inode->i_size
+		 * bu greater than i_disksize.(hint delalloc)
+		 */
+		ext4_update_i_disksize(inode, (pos + copied));
+		i_size_changed = 1;
+	}
+	unlock_page(page);
+	page_cache_release(page);
+
+	/*
+	 * Don't mark the inode dirty under page lock. First, it unnecessarily
+	 * makes the holding time of page lock longer. Second, it forces lock
+	 * ordering of page lock and transaction start for journaling
+	 * filesystems.
+	 */
+	if (i_size_changed)
+		ext4_mark_inode_dirty(handle, inode);
+
+	return copied;
+}
+
 /*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `file' can be NULL - eg, when called from page_symlink().
@@ -1575,21 +1621,15 @@ static int ext4_ordered_write_end(struct file *file,
 	ret = ext4_jbd2_file_inode(handle, inode);
 
 	if (ret == 0) {
-		loff_t new_i_size;
-
-		new_i_size = pos + copied;
-		if (new_i_size > EXT4_I(inode)->i_disksize) {
-			ext4_update_i_disksize(inode, new_i_size);
-			/* We need to mark inode dirty even if
-			 * new_i_size is less that inode->i_size
-			 * bu greater than i_disksize.(hint delalloc)
-			 */
-			ext4_mark_inode_dirty(handle, inode);
-		}
-
-		ret2 = generic_write_end(file, mapping, pos, len, copied,
+		ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		copied = ret2;
+		if (pos + len > inode->i_size)
+			/* if we have allocated more blocks and copied
+			 * less. We will have blocks allocated outside
+			 * inode->i_size. So truncate them
+			 */
+			ext4_orphan_add(handle, inode);
 		if (ret2 < 0)
 			ret = ret2;
 	}
@@ -1597,6 +1637,18 @@ static int ext4_ordered_write_end(struct file *file,
 	if (!ret)
 		ret = ret2;
 
+	if (pos + len > inode->i_size) {
+		vmtruncate(inode, inode->i_size);
+		/* 
+		 * If vmtruncate failed early the inode might still be
+		 * on the orphan list; we need to make sure the inode
+		 * is removed from the orphan list in that case.
+		 */
+		if (inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
+	}
+
+
 	return ret ? ret : copied;
 }
 
@@ -1608,25 +1660,21 @@ static int ext4_writeback_write_end(struct file *file,
 	handle_t *handle = ext4_journal_current_handle();
 	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
-	loff_t new_i_size;
 
 	trace_mark(ext4_writeback_write_end,
 		   "dev %s ino %lu pos %llu len %u copied %u",
 		   inode->i_sb->s_id, inode->i_ino,
 		   (unsigned long long) pos, len, copied);
-	new_i_size = pos + copied;
-	if (new_i_size > EXT4_I(inode)->i_disksize) {
-		ext4_update_i_disksize(inode, new_i_size);
-		/* We need to mark inode dirty even if
-		 * new_i_size is less that inode->i_size
-		 * bu greater than i_disksize.(hint delalloc)
-		 */
-		ext4_mark_inode_dirty(handle, inode);
-	}
-
-	ret2 = generic_write_end(file, mapping, pos, len, copied,
+	ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	copied = ret2;
+	if (pos + len > inode->i_size)
+		/* if we have allocated more blocks and copied
+		 * less. We will have blocks allocated outside
+		 * inode->i_size. So truncate them
+		 */
+		ext4_orphan_add(handle, inode);
+
 	if (ret2 < 0)
 		ret = ret2;
 
@@ -1634,6 +1682,17 @@ static int ext4_writeback_write_end(struct file *file,
 	if (!ret)
 		ret = ret2;
 
+	if (pos + len > inode->i_size) {
+		vmtruncate(inode, inode->i_size);
+		/* 
+		 * If vmtruncate failed early the inode might still be
+		 * on the orphan list; we need to make sure the inode
+		 * is removed from the orphan list in that case.
+		 */
+		if (inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
+	}
+
 	return ret ? ret : copied;
 }
 
@@ -1678,10 +1737,27 @@ static int ext4_journalled_write_end(struct file *file,
 	}
 
 	unlock_page(page);
+	page_cache_release(page);
+	if (pos + len > inode->i_size)
+		/* if we have allocated more blocks and copied
+		 * less. We will have blocks allocated outside
+		 * inode->i_size. So truncate them
+		 */
+		ext4_orphan_add(handle, inode);
+
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	page_cache_release(page);
+	if (pos + len > inode->i_size) {
+		vmtruncate(inode, inode->i_size);
+		/* 
+		 * If vmtruncate failed early the inode might still be
+		 * on the orphan list; we need to make sure the inode
+		 * is removed from the orphan list in that case.
+		 */
+		if (inode->i_nlink)
+			ext4_orphan_del(NULL, inode);
+	}
 
 	return ret ? ret : copied;
 }
-- 
1.6.3.2.1.gb9f7d.dirty

