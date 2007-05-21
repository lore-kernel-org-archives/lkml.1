Return-Path: <linux-kernel-owner+w=401wt.eu-S1762893AbXEUXAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893AbXEUXAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 19:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756243AbXEUXAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 19:00:30 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52732 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859AbXEUXA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 19:00:29 -0400
Date: Mon, 21 May 2007 18:00:21 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH] eCryptfs: Delay writing 0's after llseek until write
Message-ID: <20070521230021.GD3621@us.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Delay writing 0's out in eCryptfs after a seek past the end of the
file until data is actually written.
    
Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>

diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 9881b5c..59288d8 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -33,63 +33,6 @@
 #include "ecryptfs_kernel.h"
 
 /**
- * ecryptfs_llseek
- * @file: File we are seeking in
- * @offset: The offset to seek to
- * @origin: 2 - offset from i_size; 1 - offset from f_pos
- *
- * Returns the position we have seeked to, or negative on error
- */
-static loff_t ecryptfs_llseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t rv;
-	loff_t new_end_pos;
-	int rc;
-	int expanding_file = 0;
-	struct inode *inode = file->f_mapping->host;
-
-	/* If our offset is past the end of our file, we're going to
-	 * need to grow it so we have a valid length of 0's */
-	new_end_pos = offset;
-	switch (origin) {
-	case 2:
-		new_end_pos += i_size_read(inode);
-		expanding_file = 1;
-		break;
-	case 1:
-		new_end_pos += file->f_pos;
-		if (new_end_pos > i_size_read(inode)) {
-			ecryptfs_printk(KERN_DEBUG, "new_end_pos(=[0x%.16x]) "
-					"> i_size_read(inode)(=[0x%.16x])\n",
-					new_end_pos, i_size_read(inode));
-			expanding_file = 1;
-		}
-		break;
-	default:
-		if (new_end_pos > i_size_read(inode)) {
-			ecryptfs_printk(KERN_DEBUG, "new_end_pos(=[0x%.16x]) "
-					"> i_size_read(inode)(=[0x%.16x])\n",
-					new_end_pos, i_size_read(inode));
-			expanding_file = 1;
-		}
-	}
-	ecryptfs_printk(KERN_DEBUG, "new_end_pos = [0x%.16x]\n", new_end_pos);
-	if (expanding_file) {
-		rc = ecryptfs_truncate(file->f_path.dentry, new_end_pos);
-		if (rc) {
-			rv = rc;
-			ecryptfs_printk(KERN_ERR, "Error on attempt to "
-					"truncate to (higher) offset [0x%.16x];"
-					" rc = [%d]\n", new_end_pos, rc);
-			goto out;
-		}
-	}
-	rv = generic_file_llseek(file, offset, origin);
-out:
-	return rv;
-}
-
-/**
  * ecryptfs_read_update_atime
  *
  * generic_file_read updates the atime of upper layer inode.  But, it
@@ -425,7 +368,7 @@ const struct file_operations ecryptfs_dir_fops = {
 };
 
 const struct file_operations ecryptfs_main_fops = {
-	.llseek = ecryptfs_llseek,
+	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.aio_read = ecryptfs_read_update_atime,
 	.write = do_sync_write,
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 88ea669..55cec98 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -376,9 +376,31 @@ out:
 	return 0;
 }
 
+/**
+ * eCryptfs does not currently support holes. When writing after a
+ * seek past the end of the file, eCryptfs fills in 0's through to the
+ * current location. The code to fill in the 0's to all the
+ * intermediate pages calls ecryptfs_prepare_write_no_truncate().
+ */
+static int
+ecryptfs_prepare_write_no_truncate(struct file *file, struct page *page,
+				   unsigned from, unsigned to)
+{
+	int rc = 0;
+
+	if (from == 0 && to == PAGE_CACHE_SIZE)
+		goto out;	/* If we are writing a full page, it will be
+				   up to date. */
+	if (!PageUptodate(page))
+		rc = ecryptfs_do_readpage(file, page, page->index);
+out:
+	return rc;
+}
+
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
+	loff_t pos;
 	int rc = 0;
 
 	if (from == 0 && to == PAGE_CACHE_SIZE)
@@ -386,6 +408,16 @@ static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				   up to date. */
 	if (!PageUptodate(page))
 		rc = ecryptfs_do_readpage(file, page, page->index);
+	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+	if (pos > i_size_read(page->mapping->host)) {
+		rc = ecryptfs_truncate(file->f_path.dentry, pos);
+		if (rc) {
+			printk(KERN_ERR "Error on attempt to "
+			       "truncate to (higher) offset [%lld];"
+			       " rc = [%d]\n", pos, rc);
+			goto out;
+		}
+	}
 out:
 	return rc;
 }
@@ -744,10 +776,10 @@ int write_zeros(struct file *file, pgoff_t index, int start, int num_zeros)
 		rc = PTR_ERR(tmp_page);
 		goto out;
 	}
-	rc = ecryptfs_prepare_write(file, tmp_page, start, start + num_zeros);
-	if (rc) {
+	if ((rc = ecryptfs_prepare_write_no_truncate(file, tmp_page, start,
+						     (start + num_zeros)))) {
 		ecryptfs_printk(KERN_ERR, "Error preparing to write zero's "
-				"to remainder of page at index [0x%.16x]\n",
+				"to page at index [0x%.16x]\n",
 				index);
 		page_cache_release(tmp_page);
 		goto out;
