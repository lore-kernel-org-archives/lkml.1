Return-Path: <linux-kernel-owner+w=401wt.eu-S932775AbXIQVzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932775AbXIQVzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760346AbXIQVy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:54:58 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:56756 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155AbXIQVy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:54:56 -0400
Date: Mon, 17 Sep 2007 16:50:16 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH 8/11] eCryptfs: Convert mmap functions to use persistent file
Message-ID: <20070917215016.GP13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917214436.GH13679@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert readpage, prepare_write, and commit_write to use read_write.c
routines. Remove sync_page; I cannot think of a good reason for
implementing that in eCryptfs.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/mmap.c |  199 +++++++++++++++++++++++++++-------------------------
 1 files changed, 103 insertions(+), 96 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 60e635e..dd68dd3 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -267,9 +267,78 @@ static void set_header_info(char *page_virt,
 }
 
 /**
+ * ecryptfs_copy_up_encrypted_with_header
+ * @page: Sort of a ``virtual'' representation of the encrypted lower
+ *        file. The actual lower file does not have the metadata in
+ *        the header.
+ * @crypt_stat: The eCryptfs inode's cryptographic context
+ *
+ * The ``view'' is the version of the file that userspace winds up
+ * seeing, with the header information inserted.
+ */
+static int
+ecryptfs_copy_up_encrypted_with_header(struct page *page,
+				       struct ecryptfs_crypt_stat *crypt_stat)
+{
+	loff_t extent_num_in_page = 0;
+	loff_t num_extents_per_page = (PAGE_CACHE_SIZE
+				       / crypt_stat->extent_size);
+	int rc = 0;
+
+	while (extent_num_in_page < num_extents_per_page) {
+		loff_t view_extent_num = ((page->index * num_extents_per_page)
+					  + extent_num_in_page);
+
+		if (view_extent_num < crypt_stat->num_header_extents_at_front) {
+			/* This is a header extent */
+			char *page_virt;
+
+			page_virt = kmap_atomic(page, KM_USER0);
+			memset(page_virt, 0, PAGE_CACHE_SIZE);
+			/* TODO: Support more than one header extent */
+			if (view_extent_num == 0) {
+				rc = ecryptfs_read_xattr_region(
+					page_virt, page->mapping->host);
+				set_header_info(page_virt, crypt_stat);
+			}
+			kunmap_atomic(page_virt, KM_USER0);
+			flush_dcache_page(page);
+			if (rc) {
+				ClearPageUptodate(page);
+				printk(KERN_ERR "%s: Error reading xattr "
+				       "region; rc = [%d]\n", __FUNCTION__, rc);
+				goto out;
+			}
+			SetPageUptodate(page);
+		} else {
+			/* This is an encrypted data extent */
+			loff_t lower_offset =
+				((view_extent_num -
+				  crypt_stat->num_header_extents_at_front)
+				 * crypt_stat->extent_size);
+
+			rc = ecryptfs_read_lower_page_segment(
+				page, (lower_offset >> PAGE_CACHE_SHIFT),
+				(lower_offset & ~PAGE_CACHE_MASK),
+				crypt_stat->extent_size, page->mapping->host);
+			if (rc) {
+				printk(KERN_ERR "%s: Error attempting to read "
+				       "extent at offset [%lld] in the lower "
+				       "file; rc = [%d]\n", __FUNCTION__,
+				       lower_offset, rc);
+				goto out;
+			}
+		}
+		extent_num_in_page++;
+	}
+out:
+	return rc;
+}
+
+/**
  * ecryptfs_readpage
- * @file: This is an ecryptfs file
- * @page: ecryptfs associated page to stick the read data into
+ * @file: An eCryptfs file
+ * @page: Page from eCryptfs inode mapping into which to stick the read data
  *
  * Read in a page, decrypting if necessary.
  *
@@ -277,59 +346,35 @@ static void set_header_info(char *page_virt,
  */
 static int ecryptfs_readpage(struct file *file, struct page *page)
 {
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&ecryptfs_inode_to_private(file->f_path.dentry->d_inode)->crypt_stat;
 	int rc = 0;
-	struct ecryptfs_crypt_stat *crypt_stat;
 
-	BUG_ON(!(file && file->f_path.dentry && file->f_path.dentry->d_inode));
-	crypt_stat = &ecryptfs_inode_to_private(file->f_path.dentry->d_inode)
-			->crypt_stat;
 	if (!crypt_stat
 	    || !(crypt_stat->flags & ECRYPTFS_ENCRYPTED)
 	    || (crypt_stat->flags & ECRYPTFS_NEW_FILE)) {
 		ecryptfs_printk(KERN_DEBUG,
 				"Passing through unencrypted page\n");
-		rc = ecryptfs_do_readpage(file, page, page->index);
-		if (rc) {
-			ecryptfs_printk(KERN_ERR, "Error reading page; rc = "
-					"[%d]\n", rc);
-			goto out;
-		}
+		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
+						      PAGE_CACHE_SIZE,
+						      page->mapping->host);
 	} else if (crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED) {
 		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR) {
-			int num_pages_in_header_region =
-				(crypt_stat->extent_size
-				 / PAGE_CACHE_SIZE);
-
-			if (page->index < num_pages_in_header_region) {
-				char *page_virt;
-
-				page_virt = kmap_atomic(page, KM_USER0);
-				memset(page_virt, 0, PAGE_CACHE_SIZE);
-				if (page->index == 0) {
-					rc = ecryptfs_read_xattr_region(
-						page_virt, page->mapping->host);
-					set_header_info(page_virt, crypt_stat);
-				}
-				kunmap_atomic(page_virt, KM_USER0);
-				flush_dcache_page(page);
-				if (rc) {
-					printk(KERN_ERR "Error reading xattr "
-					       "region\n");
-					goto out;
-				}
-			} else {
-				rc = ecryptfs_do_readpage(
-					file, page,
-					(page->index
-					 - num_pages_in_header_region));
-				if (rc) {
-					printk(KERN_ERR "Error reading page; "
-					       "rc = [%d]\n", rc);
-					goto out;
-				}
+			rc = ecryptfs_copy_up_encrypted_with_header(page,
+								    crypt_stat);
+			if (rc) {
+				printk(KERN_ERR "%s: Error attempting to copy "
+				       "the encrypted content from the lower "
+				       "file whilst inserting the metadata "
+				       "from the xattr into the header; rc = "
+				       "[%d]\n", __FUNCTION__, rc);
+				goto out;
 			}
+
 		} else {
-			rc = ecryptfs_do_readpage(file, page, page->index);
+			rc = ecryptfs_read_lower_page_segment(
+				page, page->index, 0, PAGE_CACHE_SIZE,
+				page->mapping->host);
 			if (rc) {
 				printk(KERN_ERR "Error reading page; rc = "
 				       "[%d]\n", rc);
@@ -344,10 +389,7 @@ static int ecryptfs_readpage(struct file *file, struct page *page)
 			goto out;
 		}
 	}
-	SetPageUptodate(page);
 out:
-	if (rc)
-		ClearPageUptodate(page);
 	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
 			page->index);
 	unlock_page(page);
@@ -403,9 +445,12 @@ static int ecryptfs_prepare_write(struct file *file, struct page *page,
 		goto out;	/* If we are writing a full page, it will be
 				   up to date. */
 	if (!PageUptodate(page))
-		rc = ecryptfs_do_readpage(file, page, page->index);
+		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
+						      PAGE_CACHE_SIZE,
+						      page->mapping->host);
 	if (page->index != 0) {
-		loff_t end_of_prev_pg_pos = page_offset(page) - 1;
+		loff_t end_of_prev_pg_pos =
+			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
 
 		if (end_of_prev_pg_pos > i_size_read(page->mapping->host)) {
 			rc = ecryptfs_truncate(file->f_path.dentry,
@@ -633,18 +678,11 @@ static int ecryptfs_commit_write(struct file *file, struct page *page,
 				 unsigned from, unsigned to)
 {
 	loff_t pos;
-	struct inode *inode;
-	struct inode *lower_inode;
-	struct file *lower_file;
-	struct ecryptfs_crypt_stat *crypt_stat;
+	struct inode *ecryptfs_inode = page->mapping->host;
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&ecryptfs_inode_to_private(file->f_path.dentry->d_inode)->crypt_stat;
 	int rc;
 
-	inode = page->mapping->host;
-	lower_inode = ecryptfs_inode_to_lower(inode);
-	lower_file = ecryptfs_file_to_lower(file);
-	mutex_lock(&lower_inode->i_mutex);
-	crypt_stat = &ecryptfs_inode_to_private(file->f_path.dentry->d_inode)
-				->crypt_stat;
 	if (crypt_stat->flags & ECRYPTFS_NEW_FILE) {
 		ecryptfs_printk(KERN_DEBUG, "ECRYPTFS_NEW_FILE flag set in "
 			"crypt_stat at memory location [%p]\n", crypt_stat);
@@ -654,6 +692,7 @@ static int ecryptfs_commit_write(struct file *file, struct page *page,
 	ecryptfs_printk(KERN_DEBUG, "Calling fill_zeros_to_end_of_page"
 			"(page w/ index = [0x%.16x], to = [%d])\n", page->index,
 			to);
+	/* Fills in zeros if 'to' goes beyond inode size */
 	rc = fill_zeros_to_end_of_page(page, to);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error attempting to fill "
@@ -667,25 +706,17 @@ static int ecryptfs_commit_write(struct file *file, struct page *page,
 				"index [0x%.16x])\n", page->index);
 		goto out;
 	}
-	inode->i_blocks = lower_inode->i_blocks;
-	pos = page_offset(page) + to;
-	if (pos > i_size_read(inode)) {
-		i_size_write(inode, pos);
+	pos = (page->index << PAGE_CACHE_SHIFT) + to;
+	if (pos > i_size_read(ecryptfs_inode)) {
+		i_size_write(ecryptfs_inode, pos);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
-				"[0x%.16x]\n", i_size_read(inode));
+				"[0x%.16x]\n", i_size_read(ecryptfs_inode));
 	}
-	rc = ecryptfs_write_inode_size_to_metadata(inode);
+	rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
 	if (rc)
 		printk(KERN_ERR "Error writing inode size to metadata; "
 		       "rc = [%d]\n", rc);
-	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
-	mark_inode_dirty_sync(inode);
 out:
-	if (rc < 0)
-		ClearPageUptodate(page);
-	else
-		SetPageUptodate(page);
-	mutex_unlock(&lower_inode->i_mutex);
 	return rc;
 }
 
@@ -751,34 +782,10 @@ static sector_t ecryptfs_bmap(struct address_space *mapping, sector_t block)
 	return rc;
 }
 
-static void ecryptfs_sync_page(struct page *page)
-{
-	struct inode *inode;
-	struct inode *lower_inode;
-	struct page *lower_page;
-
-	inode = page->mapping->host;
-	lower_inode = ecryptfs_inode_to_lower(inode);
-	/* NOTE: Recently swapped with grab_cache_page(), since
-	 * sync_page() just makes sure that pending I/O gets done. */
-	lower_page = find_lock_page(lower_inode->i_mapping, page->index);
-	if (!lower_page) {
-		ecryptfs_printk(KERN_DEBUG, "find_lock_page failed\n");
-		return;
-	}
-	if (lower_page->mapping->a_ops->sync_page)
-		lower_page->mapping->a_ops->sync_page(lower_page);
-	ecryptfs_printk(KERN_DEBUG, "Unlocking page with index = [0x%.16x]\n",
-			lower_page->index);
-	unlock_page(lower_page);
-	page_cache_release(lower_page);
-}
-
 struct address_space_operations ecryptfs_aops = {
 	.writepage = ecryptfs_writepage,
 	.readpage = ecryptfs_readpage,
 	.prepare_write = ecryptfs_prepare_write,
 	.commit_write = ecryptfs_commit_write,
 	.bmap = ecryptfs_bmap,
-	.sync_page = ecryptfs_sync_page,
 };
-- 
1.5.1.6

