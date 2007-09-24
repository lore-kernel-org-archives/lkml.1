Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbXIXWNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbXIXWNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbXIXWNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:13:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:41110 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbXIXWNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:13:20 -0400
Date: Mon, 24 Sep 2007 17:12:16 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/11] eCryptfs: read_write.c routines
Message-ID: <20070924221216.GC11833@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com> <20070917214632.GK13679@halcrow.austin.ibm.com> <20070919223850.3e1132ac.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070919223850.3e1132ac.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 10:38:50PM -0700, Andrew Morton wrote:
> > +	offset = (page_for_lower->index << PAGE_CACHE_SHIFT) + offset_in_page;
> 
> bug.  You need to cast page.index to loff_t before shifting.
> 
> I'd fix it on the spot, but this would be a good time to review the
> whole patchset and perhaps the whole fs for this easy-to-do,
> hard-to-find bug.

Update data types and add casts in order to avoid potential overflow
issues.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 5d27cf9..4bf1a95 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -149,7 +149,7 @@ out:
  * ecryptfs_derive_iv
  * @iv: destination for the derived iv vale
  * @crypt_stat: Pointer to crypt_stat struct for the current inode
- * @offset: Offset of the page whose's iv we are to derive
+ * @offset: Offset of the extent whose IV we are to derive
  *
  * Generate the initialization vector from the given root IV and page
  * offset.
@@ -157,7 +157,7 @@ out:
  * Returns zero on success; non-zero on error.
  */
 static int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
-			      pgoff_t offset)
+			      loff_t offset)
 {
 	int rc = 0;
 	char dst[MD5_DIGEST_SIZE];
@@ -173,7 +173,7 @@ static int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
 	 * hashing business. -Halcrow */
 	memcpy(src, crypt_stat->root_iv, crypt_stat->iv_bytes);
 	memset((src + crypt_stat->iv_bytes), 0, 16);
-	snprintf((src + crypt_stat->iv_bytes), 16, "%ld", offset);
+	snprintf((src + crypt_stat->iv_bytes), 16, "%lld", offset);
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(KERN_DEBUG, "source:\n");
 		ecryptfs_dump_hex(src, (crypt_stat->iv_bytes + 16));
@@ -384,11 +384,11 @@ static int ecryptfs_encrypt_extent(struct page *enc_extent_page,
 				   struct page *page,
 				   unsigned long extent_offset)
 {
-	unsigned long extent_base;
+	loff_t extent_base;
 	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
 	int rc;
 
-	extent_base = (page->index
+	extent_base = (((loff_t)page->index)
 		       * (PAGE_CACHE_SIZE / crypt_stat->extent_size));
 	rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
 				(extent_base + extent_offset));
@@ -492,8 +492,9 @@ int ecryptfs_encrypt_page(struct page *page)
 			goto out;
 		}
 		ecryptfs_lower_offset_for_extent(
-			&offset, ((page->index * (PAGE_CACHE_SIZE
-						  / crypt_stat->extent_size))
+			&offset, ((((loff_t)page->index)
+				   * (PAGE_CACHE_SIZE
+				      / crypt_stat->extent_size))
 				  + extent_offset), crypt_stat);
 		rc = ecryptfs_write_lower(ecryptfs_inode, enc_extent_virt,
 					  offset, crypt_stat->extent_size);
@@ -515,11 +516,11 @@ static int ecryptfs_decrypt_extent(struct page *page,
 				   struct page *enc_extent_page,
 				   unsigned long extent_offset)
 {
-	unsigned long extent_base;
+	loff_t extent_base;
 	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
 	int rc;
 
-	extent_base = (page->index
+	extent_base = (((loff_t)page->index)
 		       * (PAGE_CACHE_SIZE / crypt_stat->extent_size));
 	rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
 				(extent_base + extent_offset));
@@ -1320,7 +1321,7 @@ ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
 	while (current_header_page < header_pages) {
 		loff_t offset;
 
-		offset = (current_header_page << PAGE_CACHE_SHIFT);
+		offset = (((loff_t)current_header_page) << PAGE_CACHE_SHIFT);
 		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,
 					       page_virt, offset,
 					       PAGE_CACHE_SIZE))) {
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index c6a8a33..4eb09c1 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -127,7 +127,8 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 	int rc = 0;
 
 	while (extent_num_in_page < num_extents_per_page) {
-		loff_t view_extent_num = ((page->index * num_extents_per_page)
+		loff_t view_extent_num = ((((loff_t)page->index)
+					   * num_extents_per_page)
 					  + extent_num_in_page);
 
 		if (view_extent_num < crypt_stat->num_header_extents_at_front) {
@@ -418,7 +419,7 @@ static int ecryptfs_commit_write(struct file *file, struct page *page,
 				"index [0x%.16x])\n", page->index);
 		goto out;
 	}
-	pos = (page->index << PAGE_CACHE_SHIFT) + to;
+	pos = (((loff_t)page->index) << PAGE_CACHE_SHIFT) + to;
 	if (pos > i_size_read(ecryptfs_inode)) {
 		i_size_write(ecryptfs_inode, pos);
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index ccd2599..272eaeb 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -87,7 +87,8 @@ int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
 	loff_t offset;
 	int rc;
 
-	offset = (page_for_lower->index << PAGE_CACHE_SHIFT) + offset_in_page;
+	offset = ((((off_t)page_for_lower->index) << PAGE_CACHE_SHIFT)
+		  + offset_in_page);
 	virt = kmap(page_for_lower);
 	rc = ecryptfs_write_lower(ecryptfs_inode, virt, offset, size);
 	kunmap(page_for_lower);
@@ -117,7 +118,8 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 {
 	struct page *ecryptfs_page;
 	char *ecryptfs_page_virt;
-	u64 ecryptfs_file_size = i_size_read(ecryptfs_file->f_dentry->d_inode);
+	loff_t ecryptfs_file_size =
+		i_size_read(ecryptfs_file->f_dentry->d_inode);
 	loff_t data_offset = 0;
 	loff_t pos;
 	int rc = 0;
@@ -277,7 +279,7 @@ int ecryptfs_read_lower_page_segment(struct page *page_for_ecryptfs,
 	loff_t offset;
 	int rc;
 
-	offset = ((page_index << PAGE_CACHE_SHIFT) + offset_in_page);
+	offset = ((((loff_t)page_index) << PAGE_CACHE_SHIFT) + offset_in_page);
 	virt = kmap(page_for_ecryptfs);
 	rc = ecryptfs_read_lower(virt, offset, size, ecryptfs_inode);
 	kunmap(page_for_ecryptfs);
@@ -306,7 +308,8 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 {
 	struct page *ecryptfs_page;
 	char *ecryptfs_page_virt;
-	u64 ecryptfs_file_size = i_size_read(ecryptfs_file->f_dentry->d_inode);
+	loff_t ecryptfs_file_size =
+		i_size_read(ecryptfs_file->f_dentry->d_inode);
 	loff_t data_offset = 0;
 	loff_t pos;
 	int rc = 0;
