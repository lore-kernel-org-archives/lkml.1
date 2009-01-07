Return-Path: <linux-kernel-owner+w=401wt.eu-S1757852AbZAGNMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852AbZAGNMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 08:12:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757012AbZAGNMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 08:12:38 -0500
Received: from sh.osrg.net ([192.16.179.4]:43461 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633AbZAGNMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 08:12:35 -0500
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Chris Mason <chris.mason@oracle.com>
Subject: [PATCH mmotm] nilfs2: insert checks and hole block allocation in page_mkwrite
Date: Wed,  7 Jan 2009 22:06:19 +0900
Message-Id: <1231333579-25296-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
X-Dispatcher: imput version 20050308(IM148)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason told me that page_mkwrite() has some works to do.

On Wed, 17 Dec 2008 21:52:55 -0500, Chris Mason wrote:
> nilfs_page_mkwrite doesn't seem to dirty the page?  block_page_mkwrite
> does more, including checks against i_size and others.

This will insert i_size check, and hole block allocation code in the
nilfs_page_mkwrite.

Previously, the hole block allocation was delayed until just before
writing for mmapped pages.  This accompanies removal of the delayed
allocation code.

Cc: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
---
 fs/nilfs2/file.c    |   59 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/nilfs2/segment.c |   42 ++++--------------------------------
 2 files changed, 62 insertions(+), 39 deletions(-)

diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
index 7ddd42e..146dc23 100644
--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -75,11 +75,66 @@ nilfs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 
 static int nilfs_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
-	if (!(vma->vm_flags & (VM_WRITE | VM_MAYWRITE)))
-		return -EPERM;
+	struct inode *inode = vma->vm_file->f_dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	struct nilfs_transaction_info ti;
+	struct buffer_head *bh, *head;
+	int fully_mapped = 1;
+	int ret = -EINVAL;
+
+	/*
+	 * use i_alloc_sem to stop truncate operations on the inode
+	 */
+	down_read(&inode->i_alloc_sem);
+
+	if (page->mapping != mapping ||
+	    page_offset(page) >= i_size_read(inode) || !PageUptodate(page))
+		goto failed;
+
+	if (PageMappedToDisk(page))
+		goto mapped;
+
+	spin_lock(&mapping->private_lock); /* exclude try_to_free_buffers() */
+	if (page_has_buffers(page)) {
+		bh = head = page_buffers(page);
+		do {
+			if (!buffer_mapped(bh)) {
+				fully_mapped = 0;
+				break;
+			}
+		} while (bh = bh->b_this_page, bh != head);
+
+		if (fully_mapped) {
+			spin_unlock(&mapping->private_lock);
+			SetPageMappedToDisk(page);
+			goto mapped;
+		}
+	}
+	spin_unlock(&mapping->private_lock);
+
+	/*
+	 * Fill hole blocks. This accompanies a disk capacity check.
+	 */
+	ret = nilfs_transaction_begin(inode->i_sb, &ti, 1);
+	if (unlikely(ret))
+		goto failed;
+
+	ret = block_page_mkwrite(vma, page, nilfs_get_block);
+	if (unlikely(ret)) {
+		nilfs_transaction_abort(inode->i_sb);
+		goto failed;
+	}
+	nilfs_transaction_commit(inode->i_sb);
+
+ mapped:
+	up_read(&inode->i_alloc_sem);
 	SetPageChecked(page);
 	wait_on_page_writeback(page);
 	return 0;
+
+ failed:
+	up_read(&inode->i_alloc_sem);
+	return ret;
 }
 
 struct vm_operations_struct nilfs_file_vm_ops = {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index 182fb26..b5d28d2 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -667,42 +667,6 @@ struct nilfs_sc_operations nilfs_sc_dsync_ops = {
 	.write_node_binfo = NULL,
 };
 
-static int nilfs_prepare_data_page(struct inode *inode, struct page *page)
-{
-	int err = 0;
-
-	lock_page(page);
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
-
-	if (!PageMappedToDisk(page)) {
-		struct buffer_head *bh, *head;
-		sector_t blkoff
-			= page->index << (PAGE_SHIFT - inode->i_blkbits);
-
-		int non_mapped = 0;
-
-		bh = head = page_buffers(page);
-		do {
-			if (!buffer_mapped(bh)) {
-				if (!buffer_dirty(bh)) {
-					non_mapped++;
-					continue;
-				}
-				err = nilfs_get_block(inode, blkoff, bh, 1);
-				if (unlikely(err))
-					goto out_unlock;
-			}
-		} while (blkoff++, (bh = bh->b_this_page) != head);
-		if (!non_mapped)
-			SetPageMappedToDisk(page);
-	}
-
- out_unlock:
-	unlock_page(page);
-	return err;
-}
-
 static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 					   struct list_head *listp,
 					   struct nilfs_sc_info *sci)
@@ -727,7 +691,11 @@ static int nilfs_lookup_dirty_data_buffers(struct inode *inode,
 		struct page *page = pvec.pages[i];
 
 		if (mapping->host) {
-			err = nilfs_prepare_data_page(inode, page);
+			lock_page(page);
+			if (!page_has_buffers(page))
+				create_empty_buffers(page,
+						     1 << inode->i_blkbits, 0);
+			unlock_page(page);
 			if (unlikely(err))
 				break;
 		}
-- 
1.5.6.5

