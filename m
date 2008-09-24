Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbYIXRja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbYIXRja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbYIXRjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:39:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40887 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYIXRjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:39:19 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Convert cifs to new aops.
Date: Wed, 24 Sep 2008 13:39:13 -0400
Message-Id: <1222277953-3669-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is based on the one originally posted by Nick Piggin. His
patch was very close, but had a couple of small bugs. Nick's original
comments follow:

---------------[snip]--------------

This is another relatively naive conversion. Always do the read upfront
when the page is not uptodate (unless we're in the writethrough path).

Fix an uninitialized data exposure where SetPageUptodate was called
before the page was uptodate.

SetPageUptodate and switch to writeback mode in the case that the full
page was dirtied.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Reviewed-by: Badari Pulavarty <pbadari@us.ibm.com>
Acked-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Steve French <smfrench@gmail.com>
Cc: Nick Piggin <npiggin@suse.de>
---
 fs/cifs/file.c |  120 +++++++++++++++++++++++++++----------------------------
 1 files changed, 59 insertions(+), 61 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d39e852..c4a8a06 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -107,7 +107,7 @@ static inline int cifs_open_inode_helper(struct inode *inode, struct file *file,
 
 	/* want handles we can use to read with first
 	   in the list so we do not have to walk the
-	   list to search for one in prepare_write */
+	   list to search for one in write_begin */
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY) {
 		list_add_tail(&pCifsFile->flist,
 			      &pCifsInode->openFileList);
@@ -915,7 +915,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 }
 
 static ssize_t cifs_write(struct file *file, const char *write_data,
-	size_t write_size, loff_t *poffset)
+			  size_t write_size, loff_t *poffset)
 {
 	int rc = 0;
 	unsigned int bytes_written = 0;
@@ -1455,49 +1455,52 @@ static int cifs_writepage(struct page *page, struct writeback_control *wbc)
 	return rc;
 }
 
-static int cifs_commit_write(struct file *file, struct page *page,
-	unsigned offset, unsigned to)
+static int cifs_write_end(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned copied,
+			struct page *page, void *fsdata)
 {
-	int xid;
-	int rc = 0;
-	struct inode *inode = page->mapping->host;
-	loff_t position = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-	char *page_data;
+	int rc;
+	struct inode *inode = mapping->host;
 
-	xid = GetXid();
-	cFYI(1, ("commit write for page %p up to position %lld for %d",
-		 page, position, to));
-	spin_lock(&inode->i_lock);
-	if (position > inode->i_size)
-		i_size_write(inode, position);
+	cFYI(1, ("write_end for page %p from pos %lld with %d bytes",
+		 page, pos, copied));
+
+	if (!PageUptodate(page) && copied == PAGE_CACHE_SIZE)
+		SetPageUptodate(page);
 
-	spin_unlock(&inode->i_lock);
 	if (!PageUptodate(page)) {
-		position =  ((loff_t)page->index << PAGE_CACHE_SHIFT) + offset;
-		/* can not rely on (or let) writepage write this data */
-		if (to < offset) {
-			cFYI(1, ("Illegal offsets, can not copy from %d to %d",
-				offset, to));
-			FreeXid(xid);
-			return rc;
-		}
+		char *page_data;
+		unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
+		int xid;
+
+		xid = GetXid();
 		/* this is probably better than directly calling
 		   partialpage_write since in this function the file handle is
 		   known which we might as well	leverage */
 		/* BB check if anything else missing out of ppw
 		   such as updating last write time */
 		page_data = kmap(page);
-		rc = cifs_write(file, page_data + offset, to-offset,
-				&position);
-		if (rc > 0)
-			rc = 0;
-		/* else if (rc < 0) should we set writebehind rc? */
+		rc = cifs_write(file, page_data + offset, copied, &pos);
+		/* if (rc < 0) should we set writebehind rc? */
 		kunmap(page);
+
+		FreeXid(xid);
 	} else {
+		rc = copied;
+		pos += copied;
 		set_page_dirty(page);
 	}
 
-	FreeXid(xid);
+	if (rc > 0) {
+		spin_lock(&inode->i_lock);
+		if (pos > inode->i_size)
+			i_size_write(inode, pos);
+		spin_unlock(&inode->i_lock);
+	}
+
+	unlock_page(page);
+	page_cache_release(page);
+
 	return rc;
 }
 
@@ -2043,49 +2046,44 @@ bool is_size_safe_to_change(struct cifsInodeInfo *cifsInode, __u64 end_of_file)
 		return true;
 }
 
-static int cifs_prepare_write(struct file *file, struct page *page,
-	unsigned from, unsigned to)
+static int cifs_write_begin(struct file *file, struct address_space *mapping,
+			loff_t pos, unsigned len, unsigned flags,
+			struct page **pagep, void **fsdata)
 {
-	int rc = 0;
-	loff_t i_size;
-	loff_t offset;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	loff_t offset = pos & (PAGE_CACHE_SIZE - 1);
+
+	cFYI(1, ("write_begin from %lld len %d", (long long)pos, len));
+
+	*pagep = __grab_cache_page(mapping, index);
+	if (!*pagep)
+		return -ENOMEM;
 
-	cFYI(1, ("prepare write for page %p from %d to %d", page, from, to));
-	if (PageUptodate(page))
+	if (PageUptodate(*pagep))
 		return 0;
 
 	/* If we are writing a full page it will be up to date,
 	   no need to read from the server */
-	if ((to == PAGE_CACHE_SIZE) && (from == 0)) {
-		SetPageUptodate(page);
+	if (len == PAGE_CACHE_SIZE && flags & AOP_FLAG_UNINTERRUPTIBLE)
 		return 0;
-	}
 
-	offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
-	i_size = i_size_read(page->mapping->host);
+	if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
+		int rc;
 
-	if ((offset >= i_size) ||
-	    ((from == 0) && (offset + to) >= i_size)) {
-		/*
-		 * We don't need to read data beyond the end of the file.
-		 * zero it, and set the page uptodate
-		 */
-		simple_prepare_write(file, page, from, to);
-		SetPageUptodate(page);
-	} else if ((file->f_flags & O_ACCMODE) != O_WRONLY) {
 		/* might as well read a page, it is fast enough */
-		rc = cifs_readpage_worker(file, page, &offset);
+		rc = cifs_readpage_worker(file, *pagep, &offset);
+
+		/* we do not need to pass errors back
+		   e.g. if we do not have read access to the file
+		   because cifs_write_end will attempt synchronous writes
+		   -- shaggy */
 	} else {
 		/* we could try using another file handle if there is one -
 		   but how would we lock it to prevent close of that handle
 		   racing with this read? In any case
-		   this will be written out by commit_write so is fine */
+		   this will be written out by write_end so is fine */
 	}
 
-	/* we do not need to pass errors back
-	   e.g. if we do not have read access to the file
-	   because cifs_commit_write will do the right thing.  -- shaggy */
-
 	return 0;
 }
 
@@ -2094,8 +2092,8 @@ const struct address_space_operations cifs_addr_ops = {
 	.readpages = cifs_readpages,
 	.writepage = cifs_writepage,
 	.writepages = cifs_writepages,
-	.prepare_write = cifs_prepare_write,
-	.commit_write = cifs_commit_write,
+	.write_begin = cifs_write_begin,
+	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
@@ -2110,8 +2108,8 @@ const struct address_space_operations cifs_addr_ops_smallbuf = {
 	.readpage = cifs_readpage,
 	.writepage = cifs_writepage,
 	.writepages = cifs_writepages,
-	.prepare_write = cifs_prepare_write,
-	.commit_write = cifs_commit_write,
+	.write_begin = cifs_write_begin,
+	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
 	/* .sync_page = cifs_sync_page, */
 	/* .direct_IO = */
-- 
1.5.5.1

