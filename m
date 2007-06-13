Return-Path: <linux-kernel-owner+w=401wt.eu-S1755622AbXFMTAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622AbXFMTAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 15:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXFMTAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 15:00:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60287 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbXFMTAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 15:00:32 -0400
Date: Wed, 13 Jun 2007 13:53:16 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David J. Kleikamp" <shaggy@us.ibm.com>, trevor.highland@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] eCryptfs: fix write zeros behavior
Message-ID: <20070613185316.GX13465@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the processes involved in wiping regions of the data
during truncate and write events, fixing a kernel hang in 2.6.22-rc4
while assuring that zero values are written out to the appropriate
locations during events in which the i_size will change.

The range passed to ecryptfs_truncate() from ecryptfs_prepare_write()
includes the page that is the object of ecryptfs_prepare_write(). This
leads to a kernel hang as read_cache_page() is executed on the same
page in the ecryptfs_truncate() execution path. This patch remedies
this by limiting the range passed to ecryptfs_truncate() so as to
exclude the page that is the object of ecryptfs_prepare_write(); it
also adds code to ecryptfs_prepare_write() to zero out the region of
its own page when writing past the i_size position. This patch also
modifies ecryptfs_truncate() so that when a file is truncated to a
smaller size, eCryptfs will zero out the contents of the new last page
from the new size through to the end of the last page.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>

---
 fs/ecryptfs/ecryptfs_kernel.h |    2 +
 fs/ecryptfs/inode.c           |   19 ++++++++++++++
 fs/ecryptfs/mmap.c            |   53 ++++++++++++++++++++++------------------
 3 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 403e3ba..1b9dd9a 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -580,5 +580,7 @@ void
 ecryptfs_write_header_metadata(char *virt,
 			       struct ecryptfs_crypt_stat *crypt_stat,
 			       size_t *written);
+int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
+			 int num_zeros);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 1548be2..0981ae3 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -800,6 +800,25 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 			goto out_fput;
 		}
 	} else { /* new_length < i_size_read(inode) */
+		pgoff_t index = 0;
+		int end_pos_in_page = -1;
+
+		if (new_length != 0) {
+			index = ((new_length - 1) >> PAGE_CACHE_SHIFT);
+			end_pos_in_page = ((new_length - 1) & ~PAGE_CACHE_MASK);
+		}
+		if (end_pos_in_page != (PAGE_CACHE_SIZE - 1)) {
+			if ((rc = ecryptfs_write_zeros(&fake_ecryptfs_file,
+						       index,
+						       (end_pos_in_page + 1),
+						       ((PAGE_CACHE_SIZE - 1)
+							- end_pos_in_page)))) {
+				printk(KERN_ERR "Error attempting to zero out "
+				       "the remainder of the end page on "
+				       "reducing truncate; rc = [%d]\n", rc);
+				goto out_fput;
+			}
+		}
 		vmtruncate(inode, new_length);
 		rc = ecryptfs_write_inode_size_to_metadata(
 			lower_file, lower_dentry->d_inode, inode, dentry,
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 55cec98..6df410c 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -56,9 +56,6 @@ static struct page *ecryptfs_get1page(struct file *file, int index)
 	return read_mapping_page(mapping, index, (void *)file);
 }
 
-static
-int write_zeros(struct file *file, pgoff_t index, int start, int num_zeros);
-
 /**
  * ecryptfs_fill_zeros
  * @file: The ecryptfs file
@@ -101,10 +98,13 @@ int ecryptfs_fill_zeros(struct file *file, loff_t new_length)
 	if (old_end_page_index == new_end_page_index) {
 		/* Start and end are in the same page; we just need to
 		 * set a portion of the existing page to zero's */
-		rc = write_zeros(file, index, (old_end_pos_in_page + 1),
-				 (new_end_pos_in_page - old_end_pos_in_page));
+		rc = ecryptfs_write_zeros(file, index,
+					  (old_end_pos_in_page + 1),
+					  (new_end_pos_in_page
+					   - old_end_pos_in_page));
 		if (rc)
-			ecryptfs_printk(KERN_ERR, "write_zeros(file=[%p], "
+			ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros("
+					"file=[%p], "
 					"index=[0x%.16x], "
 					"old_end_pos_in_page=[d], "
 					"(PAGE_CACHE_SIZE - new_end_pos_in_page"
@@ -117,10 +117,10 @@ int ecryptfs_fill_zeros(struct file *file, loff_t new_length)
 		goto out;
 	}
 	/* Fill the remainder of the previous last page with zeros */
-	rc = write_zeros(file, index, (old_end_pos_in_page + 1),
+	rc = ecryptfs_write_zeros(file, index, (old_end_pos_in_page + 1),
 			 ((PAGE_CACHE_SIZE - 1) - old_end_pos_in_page));
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "write_zeros(file=[%p], "
+		ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros(file=[%p], "
 				"index=[0x%.16x], old_end_pos_in_page=[d], "
 				"(PAGE_CACHE_SIZE - old_end_pos_in_page)=[d]) "
 				"returned [%d]\n", file, index,
@@ -131,9 +131,10 @@ int ecryptfs_fill_zeros(struct file *file, loff_t new_length)
 	index++;
 	while (index < new_end_page_index) {
 		/* Fill all intermediate pages with zeros */
-		rc = write_zeros(file, index, 0, PAGE_CACHE_SIZE);
+		rc = ecryptfs_write_zeros(file, index, 0, PAGE_CACHE_SIZE);
 		if (rc) {
-			ecryptfs_printk(KERN_ERR, "write_zeros(file=[%p], "
+			ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros("
+					"file=[%p], "
 					"index=[0x%.16x], "
 					"old_end_pos_in_page=[d], "
 					"(PAGE_CACHE_SIZE - new_end_pos_in_page"
@@ -149,9 +150,9 @@ int ecryptfs_fill_zeros(struct file *file, loff_t new_length)
 	}
 	/* Fill the portion at the beginning of the last new page with
 	 * zero's */
-	rc = write_zeros(file, index, 0, (new_end_pos_in_page + 1));
+	rc = ecryptfs_write_zeros(file, index, 0, (new_end_pos_in_page + 1));
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "write_zeros(file="
+		ecryptfs_printk(KERN_ERR, "ecryptfs_write_zeros(file="
 				"[%p], index=[0x%.16x], 0, "
 				"new_end_pos_in_page=[%d]"
 				"returned [%d]\n", file, index,
@@ -400,7 +401,6 @@ out:
 static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				  unsigned from, unsigned to)
 {
-	loff_t pos;
 	int rc = 0;
 
 	if (from == 0 && to == PAGE_CACHE_SIZE)
@@ -408,14 +408,19 @@ static int ecryptfs_prepare_write(struct file *file, struct page *page,
 				   up to date. */
 	if (!PageUptodate(page))
 		rc = ecryptfs_do_readpage(file, page, page->index);
-	pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
-	if (pos > i_size_read(page->mapping->host)) {
-		rc = ecryptfs_truncate(file->f_path.dentry, pos);
-		if (rc) {
-			printk(KERN_ERR "Error on attempt to "
-			       "truncate to (higher) offset [%lld];"
-			       " rc = [%d]\n", pos, rc);
-			goto out;
+	if (page->index != 0) {
+		loff_t end_of_prev_pg_pos =
+			(((loff_t)page->index << PAGE_CACHE_SHIFT) - 1);
+
+		if (end_of_prev_pg_pos > i_size_read(page->mapping->host)) {
+			rc = ecryptfs_truncate(file->f_path.dentry,
+					       end_of_prev_pg_pos);
+			if (rc) {
+				printk(KERN_ERR "Error on attempt to "
+				       "truncate to (higher) offset [%lld];"
+				       " rc = [%d]\n", end_of_prev_pg_pos, rc);
+				goto out;
+			}
 		}
 	}
 out:
@@ -753,7 +758,7 @@ out:
 }
 
 /**
- * write_zeros
+ * ecryptfs_write_zeros
  * @file: The ecryptfs file
  * @index: The index in which we are writing
  * @start: The position after the last block of data
@@ -763,8 +768,8 @@ out:
  *
  * (start + num_zeros) must be less than or equal to PAGE_CACHE_SIZE
  */
-static
-int write_zeros(struct file *file, pgoff_t index, int start, int num_zeros)
+int
+ecryptfs_write_zeros(struct file *file, pgoff_t index, int start, int num_zeros)
 {
 	int rc = 0;
 	struct page *tmp_page;
-- 
1.4.4.4

