Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbZHURY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbZHURY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932808AbZHURY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:24:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:52107 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932677AbZHURYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:24:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 17/17] vfs: Remove generic_osync_inode() and sync_page_range{_nolock}()
Date: Fri, 21 Aug 2009 19:24:07 +0200
Message-Id: <1250875447-15622-18-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250875447-15622-1-git-send-email-jack@suse.cz>
References: <1250875447-15622-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove these three functions since nobody uses them anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c         |   54 --------------------------------------
 include/linux/fs.h        |    5 ---
 include/linux/writeback.h |    4 ---
 mm/filemap.c              |   64 ---------------------------------------------
 4 files changed, 0 insertions(+), 127 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index c54226b..d8dbef0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -737,57 +737,3 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
 	return ret;
 }
 EXPORT_SYMBOL(sync_inode);
-
-/**
- * generic_osync_inode - flush all dirty data for a given inode to disk
- * @inode: inode to write
- * @mapping: the address_space that should be flushed
- * @what:  what to write and wait upon
- *
- * This can be called by file_write functions for files which have the
- * O_SYNC flag set, to flush dirty writes to disk.
- *
- * @what is a bitmask, specifying which part of the inode's data should be
- * written and waited upon.
- *
- *    OSYNC_DATA:     i_mapping's dirty data
- *    OSYNC_METADATA: the buffers at i_mapping->private_list
- *    OSYNC_INODE:    the inode itself
- */
-
-int generic_osync_inode(struct inode *inode, struct address_space *mapping, int what)
-{
-	int err = 0;
-	int need_write_inode_now = 0;
-	int err2;
-
-	if (what & OSYNC_DATA)
-		err = filemap_fdatawrite(mapping);
-	if (what & (OSYNC_METADATA|OSYNC_DATA)) {
-		err2 = sync_mapping_buffers(mapping);
-		if (!err)
-			err = err2;
-	}
-	if (what & OSYNC_DATA) {
-		err2 = filemap_fdatawait(mapping);
-		if (!err)
-			err = err2;
-	}
-
-	spin_lock(&inode_lock);
-	if ((inode->i_state & I_DIRTY) &&
-	    ((what & OSYNC_INODE) || (inode->i_state & I_DIRTY_DATASYNC)))
-		need_write_inode_now = 1;
-	spin_unlock(&inode_lock);
-
-	if (need_write_inode_now) {
-		err2 = write_inode_now(inode, 1);
-		if (!err)
-			err = err2;
-	}
-	else
-		inode_sync_wait(inode);
-
-	return err;
-}
-EXPORT_SYMBOL(generic_osync_inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 648001c..57b2866 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1458,11 +1458,6 @@ int fiemap_check_flags(struct fiemap_extent_info *fieinfo, u32 fs_flags);
 #define DT_SOCK		12
 #define DT_WHT		14
 
-#define OSYNC_METADATA	(1<<0)
-#define OSYNC_DATA	(1<<1)
-#define OSYNC_INODE	(1<<2)
-int generic_osync_inode(struct inode *, struct address_space *, int);
-
 /*
  * This is the "filldir" function type, used by readdir() to let
  * the kernel specify what kind of dirent layout it wants to have.
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 3224820..1446694 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -157,10 +157,6 @@ int write_cache_pages(struct address_space *mapping,
 		      struct writeback_control *wbc, writepage_t writepage,
 		      void *data);
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
-int sync_page_range(struct inode *inode, struct address_space *mapping,
-			loff_t pos, loff_t count);
-int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
-			   loff_t pos, loff_t count);
 void set_page_dirty_balance(struct page *page, int page_mkwrite);
 void writeback_set_ratelimit(void);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 70988a1..854e10e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -326,70 +326,6 @@ int filemap_fdatawait_range(struct address_space *mapping, loff_t start,
 EXPORT_SYMBOL(filemap_fdatawait_range);
 
 /**
- * sync_page_range - write and wait on all pages in the passed range
- * @inode:	target inode
- * @mapping:	target address_space
- * @pos:	beginning offset in pages to write
- * @count:	number of bytes to write
- *
- * Write and wait upon all the pages in the passed range.  This is a "data
- * integrity" operation.  It waits upon in-flight writeout before starting and
- * waiting upon new writeout.  If there was an IO error, return it.
- *
- * We need to re-take i_mutex during the generic_osync_inode list walk because
- * it is otherwise livelockable.
- */
-int sync_page_range(struct inode *inode, struct address_space *mapping,
-			loff_t pos, loff_t count)
-{
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
-	int ret;
-
-	if (!mapping_cap_writeback_dirty(mapping) || !count)
-		return 0;
-	ret = filemap_fdatawrite_range(mapping, pos, pos + count - 1);
-	if (ret == 0) {
-		mutex_lock(&inode->i_mutex);
-		ret = generic_osync_inode(inode, mapping, OSYNC_METADATA);
-		mutex_unlock(&inode->i_mutex);
-	}
-	if (ret == 0)
-		ret = wait_on_page_writeback_range(mapping, start, end);
-	return ret;
-}
-EXPORT_SYMBOL(sync_page_range);
-
-/**
- * sync_page_range_nolock - write & wait on all pages in the passed range without locking
- * @inode:	target inode
- * @mapping:	target address_space
- * @pos:	beginning offset in pages to write
- * @count:	number of bytes to write
- *
- * Note: Holding i_mutex across sync_page_range_nolock() is not a good idea
- * as it forces O_SYNC writers to different parts of the same file
- * to be serialised right until io completion.
- */
-int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
-			   loff_t pos, loff_t count)
-{
-	pgoff_t start = pos >> PAGE_CACHE_SHIFT;
-	pgoff_t end = (pos + count - 1) >> PAGE_CACHE_SHIFT;
-	int ret;
-
-	if (!mapping_cap_writeback_dirty(mapping) || !count)
-		return 0;
-	ret = filemap_fdatawrite_range(mapping, pos, pos + count - 1);
-	if (ret == 0)
-		ret = generic_osync_inode(inode, mapping, OSYNC_METADATA);
-	if (ret == 0)
-		ret = wait_on_page_writeback_range(mapping, start, end);
-	return ret;
-}
-EXPORT_SYMBOL(sync_page_range_nolock);
-
-/**
  * filemap_fdatawait - wait for all under-writeback pages to complete
  * @mapping: address space structure to wait for
  *
-- 
1.6.0.2

