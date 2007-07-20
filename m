Return-Path: <linux-kernel-owner+w=401wt.eu-S1760970AbXGTFkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760970AbXGTFkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 01:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXGTFkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 01:40:08 -0400
Received: from mail.suse.de ([195.135.220.2]:38053 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbXGTFkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 01:40:06 -0400
Date: Fri, 20 Jul 2007 07:40:04 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mark Fasheh <mark.fasheh@oracle.com>, dgc@sgi.com, mhalcrow@us.ibm.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch] fix some conversion overflows
Message-ID: <20070720054004.GA22099@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix page index to offset conversion overflows in buffer layer, ecryptfs,
and ocfs2.

It would be nice to convert the whole tree to page_offset, but for now
just fix the bugs.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
diff --git a/fs/buffer.c b/fs/buffer.c
index 02ebb1f..0e5ec37 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2221,7 +2221,7 @@ block_page_mkwrite(struct vm_area_struct
 	lock_page(page);
 	size = i_size_read(inode);
 	if ((page->mapping != inode->i_mapping) ||
-	    ((page->index << PAGE_CACHE_SHIFT) > size)) {
+	    (page_offset(page) > size)) {
 		/* page got truncated out from underneath us */
 		goto out_unlock;
 	}
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 7d5a43c..e4ab7bc 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -409,8 +409,7 @@ static int ecryptfs_prepare_write(struct
 	if (!PageUptodate(page))
 		rc = ecryptfs_do_readpage(file, page, page->index);
 	if (page->index != 0) {
-		loff_t end_of_prev_pg_pos =
-			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
+		loff_t end_of_prev_pg_pos = page_offset(page) - 1;
 
 		if (end_of_prev_pg_pos > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
@@ -736,7 +735,7 @@ static int ecryptfs_commit_write(struct
 		goto out;
 	}
 	inode->i_blocks = lower_inode->i_blocks;
-	pos = (page->index << PAGE_CACHE_SHIFT) + to;
+	pos = page_offset(page) + to;
 	if (pos > i_size_read(inode)) {
 		i_size_write(inode, pos);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index ee64749..9875615 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -89,7 +89,7 @@ static int __ocfs2_page_mkwrite(struct i
 {
 	int ret;
 	struct address_space *mapping = inode->i_mapping;
-	loff_t pos = page->index << PAGE_CACHE_SHIFT;
+	loff_t pos = page_offset(page);
 	unsigned int len = PAGE_CACHE_SIZE;
 	pgoff_t last_index;
 	struct page *locked_page = NULL;
