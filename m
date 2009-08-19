Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbZHSQEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbZHSQEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 12:04:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZHSQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 12:04:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:55925 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZHSQEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 12:04:46 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: hch@infradead.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 06/17] vfs: Remove sync_page_range_nolock
Date: Wed, 19 Aug 2009 18:04:33 +0200
Message-Id: <1250697884-22288-7-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1250697884-22288-1-git-send-email-jack@suse.cz>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of sync_page_range_nolock() is generic_file_aio_write_nolock().
Now we have converted all its callers to not hold i_mutex and so we can
afford to call sync_page_range() instead of sync_page_range_nolock() from
there. This non-necessarily acquires i_mutex when syncing block devices but
that's happening in fsync() path as well and block_fsync() may just drop +
reacquire i_mutex if we care enough.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/writeback.h |    2 --
 mm/filemap.c              |   31 +------------------------------
 2 files changed, 1 insertions(+), 32 deletions(-)

diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 3224820..46d6064 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -159,8 +159,6 @@ int write_cache_pages(struct address_space *mapping,
 int do_writepages(struct address_space *mapping, struct writeback_control *wbc);
 int sync_page_range(struct inode *inode, struct address_space *mapping,
 			loff_t pos, loff_t count);
-int sync_page_range_nolock(struct inode *inode, struct address_space *mapping,
-			   loff_t pos, loff_t count);
 void set_page_dirty_balance(struct page *page, int page_mkwrite);
 void writeback_set_ratelimit(void);
 
diff --git a/mm/filemap.c b/mm/filemap.c
index 3bee198..dffdc60 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -362,35 +362,6 @@ int sync_page_range(struct inode *inode, struct address_space *mapping,
 EXPORT_SYMBOL(sync_page_range);
 
 /**
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
@@ -2492,7 +2463,7 @@ ssize_t generic_file_aio_write_nolock(struct kiocb *iocb,
 	if (ret > 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) {
 		ssize_t err;
 
-		err = sync_page_range_nolock(inode, mapping, pos, ret);
+		err = sync_page_range(inode, mapping, pos, ret);
 		if (err < 0)
 			ret = err;
 	}
-- 
1.6.0.2

