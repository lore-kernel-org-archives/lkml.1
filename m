Return-Path: <linux-kernel-owner+w=401wt.eu-S1161375AbXBGQvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161375AbXBGQvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:51:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965689AbXBGQvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:51:31 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:17065 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965688AbXBGQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:51:30 -0500
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH] ecryptfs lower file handling code issues
From: Dmitriy Monakhov <dmonakhov@openvz.org>
Date: Wed, 07 Feb 2007 19:50:44 +0300
Message-ID: <87d54loqsb.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

eCryptfs lower file handling code has several issues:
  - Retval from prepare_write()/commit_writ() was't checked to equality 
    to AOP_TRUNCATED_PAGE.
  - In some places page was't unmapped and unlocked after error.

Signed-off-by: Dmitriy Monakhov <dmonakhov@openvz.org>
--------------   

--=-=-=
Content-Disposition: inline; filename=diff-ms-fs-ecryptfs-fix

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 06843d2..27ac9ef 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -391,12 +391,14 @@ out:
 	return rc;
 }
 
-static void ecryptfs_unmap_and_release_lower_page(struct page *lower_page)
+static void ecryptfs_unmap_and_release_lower_page(struct page *lower_page,
+		int page_locked)
 {
 	kunmap(lower_page);
 	ecryptfs_printk(KERN_DEBUG, "Unlocking lower page with index = "
 			"[0x%.16x]\n", lower_page->index);
-	unlock_page(lower_page);
+	if (page_locked)
+		unlock_page(lower_page);
 	page_cache_release(lower_page);
 }
 
@@ -417,6 +419,7 @@ ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	char *header_virt;
 	const struct address_space_operations *lower_a_ops;
 	u64 file_size;
+	int pg_locked = 1;
 
 	rc = ecryptfs_grab_and_map_lower_page(&header_page, &header_virt,
 					      lower_inode, 0);
@@ -427,6 +430,12 @@ ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	}
 	lower_a_ops = lower_inode->i_mapping->a_ops;
 	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
+	if (rc) {
+		if (rc == AOP_TRUNCATED_PAGE)
+			pg_locked = 0;
+		ecryptfs_unmap_and_release_lower_page(header_page, pg_locked);
+		goto out;
+	}
 	file_size = (u64)i_size_read(inode);
 	ecryptfs_printk(KERN_DEBUG, "Writing size: [0x%.16x]\n", file_size);
 	file_size = cpu_to_be64(file_size);
@@ -435,7 +444,9 @@ ecryptfs_write_inode_size_to_header(struct file *lower_file,
 	if (rc < 0)
 		ecryptfs_printk(KERN_ERR, "Error commiting header page "
 				"write\n");
-	ecryptfs_unmap_and_release_lower_page(header_page);
+	if (rc == AOP_TRUNCATED_PAGE)
+		pg_locked = 0;
+	ecryptfs_unmap_and_release_lower_page(header_page, pg_locked);
 	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty_sync(inode);
 out:
@@ -468,7 +479,10 @@ int ecryptfs_get_lower_page(struct page **lower_page, struct inode *lower_inode,
 	}
 out:
 	if (rc && (*lower_page)) {
-		ecryptfs_unmap_and_release_lower_page(*lower_page);
+		int pg_locked = 1;
+		if (rc == AOP_TRUNCATED_PAGE)
+			pg_locked = 0;
+		ecryptfs_unmap_and_release_lower_page(*lower_page, pg_locked);
 		(*lower_page) = NULL;
 	}
 	return rc;
@@ -484,16 +498,19 @@ ecryptfs_commit_lower_page(struct page *lower_page, struct inode *lower_inode,
 			   struct file *lower_file, int byte_offset,
 			   int region_size)
 {
+	int pg_locked = 1;
 	int rc = 0;
 
 	rc = lower_inode->i_mapping->a_ops->commit_write(
 		lower_file, lower_page, byte_offset, region_size);
+	if (rc == AOP_TRUNCATED_PAGE)
+		pg_locked = 0;
 	if (rc < 0) {
 		ecryptfs_printk(KERN_ERR,
 				"Error committing write; rc = [%d]\n", rc);
 	} else
 		rc = 0;
-	ecryptfs_unmap_and_release_lower_page(lower_page);
+	ecryptfs_unmap_and_release_lower_page(lower_page, pg_locked);
 	return rc;
 }
 
@@ -541,6 +558,7 @@ process_new_file(struct ecryptfs_crypt_stat *crypt_stat,
 	int current_header_page = 0;
 	int header_pages;
 	int more_header_data_to_be_written = 1;
+	int pg_locked = 1;
 
 	lower_inode = ecryptfs_inode_to_lower(inode);
 	lower_file = ecryptfs_file_to_lower(file);
@@ -563,6 +581,10 @@ process_new_file(struct ecryptfs_crypt_stat *crypt_stat,
 		rc = lower_a_ops->prepare_write(lower_file, header_page, 0,
 						PAGE_CACHE_SIZE);
 		if (rc) {
+			if (rc == AOP_TRUNCATED_PAGE)
+				pg_locked = 0;
+			ecryptfs_unmap_and_release_lower_page(header_page,
+				pg_locked);
 			ecryptfs_printk(KERN_ERR, "Error preparing to write "
 					"header page out; rc = [%d]\n", rc);
 			goto out;
@@ -579,7 +601,7 @@ process_new_file(struct ecryptfs_crypt_stat *crypt_stat,
 				rc = -EIO;
 				memset(header_virt, 0, PAGE_CACHE_SIZE);
 				ecryptfs_unmap_and_release_lower_page(
-					header_page);
+					header_page, pg_locked);
 				goto out;
 			}
 			if (current_header_page == 0)
@@ -588,7 +610,9 @@ process_new_file(struct ecryptfs_crypt_stat *crypt_stat,
 		}
 		rc = lower_a_ops->commit_write(lower_file, header_page, 0,
 					       PAGE_CACHE_SIZE);
-		ecryptfs_unmap_and_release_lower_page(header_page);
+		if (rc == AOP_TRUNCATED_PAGE)
+			pg_locked = 0;
+		ecryptfs_unmap_and_release_lower_page(header_page, pg_locked);
 		if (rc < 0) {
 			ecryptfs_printk(KERN_ERR,
 					"Error commiting header page write; "

--=-=-=--

