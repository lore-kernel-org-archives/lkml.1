Return-Path: <linux-kernel-owner+w=401wt.eu-S932226AbXIQVwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbXIQVwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758772AbXIQVvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:51:53 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47815 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758082AbXIQVvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:51:50 -0400
Date: Mon, 17 Sep 2007 16:47:10 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH 4/11] eCryptfs: Replace encrypt, decrypt, and inode size write
Message-ID: <20070917214710.GL13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917214436.GH13679@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace page encryption and decryption routines and inode size write
routine with versions that utilize the read_write.c functions.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |  427 ++++++++++++++++++++++------------------
 fs/ecryptfs/ecryptfs_kernel.h |   14 +-
 fs/ecryptfs/inode.c           |   12 +-
 fs/ecryptfs/mmap.c            |  131 ++++---------
 fs/ecryptfs/read_write.c      |   12 +-
 5 files changed, 290 insertions(+), 306 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 5d8a553..b829d3c 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -467,8 +467,91 @@ out:
 }
 
 /**
+ * ecryptfs_lower_offset_for_extent
+ *
+ * Convert an eCryptfs page index into a lower byte offset
+ */
+void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
+				      struct ecryptfs_crypt_stat *crypt_stat)
+{
+	(*offset) = ((crypt_stat->extent_size
+		      * crypt_stat->num_header_extents_at_front)
+		     + (crypt_stat->extent_size * extent_num));
+}
+
+/**
+ * ecryptfs_encrypt_extent
+ * @enc_extent_page: Allocated page into which to encrypt the data in
+ *                   @page
+ * @crypt_stat: crypt_stat containing cryptographic context for the
+ *              encryption operation
+ * @page: Page containing plaintext data extent to encrypt
+ * @extent_offset: Page extent offset for use in generating IV
+ *
+ * Encrypts one extent of data.
+ *
+ * Return zero on success; non-zero otherwise
+ */
+static int ecryptfs_encrypt_extent(struct page *enc_extent_page,
+				   struct ecryptfs_crypt_stat *crypt_stat,
+				   struct page *page,
+				   unsigned long extent_offset)
+{
+	unsigned long extent_base;
+	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
+	int rc;
+
+	extent_base = (page->index
+		       * (PAGE_CACHE_SIZE / crypt_stat->extent_size));
+	rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
+				(extent_base + extent_offset));
+	if (rc) {
+		ecryptfs_printk(KERN_ERR, "Error attempting to "
+				"derive IV for extent [0x%.16x]; "
+				"rc = [%d]\n", (extent_base + extent_offset),
+				rc);
+		goto out;
+	}
+	if (unlikely(ecryptfs_verbosity > 0)) {
+		ecryptfs_printk(KERN_DEBUG, "Encrypting extent "
+				"with iv:\n");
+		ecryptfs_dump_hex(extent_iv, crypt_stat->iv_bytes);
+		ecryptfs_printk(KERN_DEBUG, "First 8 bytes before "
+				"encryption:\n");
+		ecryptfs_dump_hex((char *)
+				  (page_address(page)
+				   + (extent_offset * crypt_stat->extent_size)),
+				  8);
+	}
+	rc = ecryptfs_encrypt_page_offset(crypt_stat, enc_extent_page, 0,
+					  page, (extent_offset
+						 * crypt_stat->extent_size),
+					  crypt_stat->extent_size, extent_iv);
+	if (rc < 0) {
+		printk(KERN_ERR "%s: Error attempting to encrypt page with "
+		       "page->index = [%ld], extent_offset = [%ld]; "
+		       "rc = [%d]\n", __FUNCTION__, page->index, extent_offset,
+		       rc);
+		goto out;
+	}
+	rc = 0;
+	if (unlikely(ecryptfs_verbosity > 0)) {
+		ecryptfs_printk(KERN_DEBUG, "Encrypt extent [0x%.16x]; "
+				"rc = [%d]\n", (extent_base + extent_offset),
+				rc);
+		ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
+				"encryption:\n");
+		ecryptfs_dump_hex((char *)(page_address(enc_extent_page)), 8);
+	}
+out:
+	return rc;
+}
+
+/**
  * ecryptfs_encrypt_page
- * @ctx: The context of the page
+ * @page: Page mapped from the eCryptfs inode for the file; contains
+ *        decrypted content that needs to be encrypted (to a temporary
+ *        page; not in place) and written out to the lower file
  *
  * Encrypt an eCryptfs page. This is done on a per-extent basis. Note
  * that eCryptfs pages may straddle the lower pages -- for instance,
@@ -478,128 +561,121 @@ out:
  * file, 24K of page 0 of the lower file will be read and decrypted,
  * and then 8K of page 1 of the lower file will be read and decrypted.
  *
- * The actual operations performed on each page depends on the
- * contents of the ecryptfs_page_crypt_context struct.
- *
  * Returns zero on success; negative on error
  */
-int ecryptfs_encrypt_page(struct ecryptfs_page_crypt_context *ctx)
+int ecryptfs_encrypt_page(struct page *page)
 {
-	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
-	unsigned long base_extent;
-	unsigned long extent_offset = 0;
-	unsigned long lower_page_idx = 0;
-	unsigned long prior_lower_page_idx = 0;
-	struct page *lower_page;
-	struct inode *lower_inode;
-	struct ecryptfs_inode_info *inode_info;
+	struct inode *ecryptfs_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
+	char *enc_extent_virt = NULL;
+	struct page *enc_extent_page;
+	loff_t extent_offset;
 	int rc = 0;
-	int lower_byte_offset = 0;
-	int orig_byte_offset = 0;
-	int num_extents_per_page;
-#define ECRYPTFS_PAGE_STATE_UNREAD    0
-#define ECRYPTFS_PAGE_STATE_READ      1
-#define ECRYPTFS_PAGE_STATE_MODIFIED  2
-#define ECRYPTFS_PAGE_STATE_WRITTEN   3
-	int page_state;
-
-	lower_inode = ecryptfs_inode_to_lower(ctx->page->mapping->host);
-	inode_info = ecryptfs_inode_to_private(ctx->page->mapping->host);
-	crypt_stat = &inode_info->crypt_stat;
+
+	ecryptfs_inode = page->mapping->host;
+	crypt_stat =
+		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
 	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
-		rc = ecryptfs_copy_page_to_lower(ctx->page, lower_inode,
-						 ctx->param.lower_file);
+		rc = ecryptfs_write_lower_page_segment(ecryptfs_inode, page,
+						       0, PAGE_CACHE_SIZE);
 		if (rc)
-			ecryptfs_printk(KERN_ERR, "Error attempting to copy "
-					"page at index [0x%.16x]\n",
-					ctx->page->index);
+			printk(KERN_ERR "%s: Error attempting to copy "
+			       "page at index [%ld]\n", __FUNCTION__,
+			       page->index);
 		goto out;
 	}
-	num_extents_per_page = PAGE_CACHE_SIZE / crypt_stat->extent_size;
-	base_extent = (ctx->page->index * num_extents_per_page);
-	page_state = ECRYPTFS_PAGE_STATE_UNREAD;
-	while (extent_offset < num_extents_per_page) {
-		ecryptfs_extent_to_lwr_pg_idx_and_offset(
-			&lower_page_idx, &lower_byte_offset, crypt_stat,
-			(base_extent + extent_offset));
-		if (prior_lower_page_idx != lower_page_idx
-		    && page_state == ECRYPTFS_PAGE_STATE_MODIFIED) {
-			rc = ecryptfs_write_out_page(ctx, lower_page,
-						     lower_inode,
-						     orig_byte_offset,
-						     (PAGE_CACHE_SIZE
-						      - orig_byte_offset));
-			if (rc) {
-				ecryptfs_printk(KERN_ERR, "Error attempting "
-						"to write out page; rc = [%d]"
-						"\n", rc);
-				goto out;
-			}
-			page_state = ECRYPTFS_PAGE_STATE_WRITTEN;
-		}
-		if (page_state == ECRYPTFS_PAGE_STATE_UNREAD
-		    || page_state == ECRYPTFS_PAGE_STATE_WRITTEN) {
-			rc = ecryptfs_read_in_page(ctx, &lower_page,
-						   lower_inode, lower_page_idx,
-						   lower_byte_offset);
-			if (rc) {
-				ecryptfs_printk(KERN_ERR, "Error attempting "
-						"to read in lower page with "
-						"index [0x%.16x]; rc = [%d]\n",
-						lower_page_idx, rc);
-				goto out;
-			}
-			orig_byte_offset = lower_byte_offset;
-			prior_lower_page_idx = lower_page_idx;
-			page_state = ECRYPTFS_PAGE_STATE_READ;
-		}
-		BUG_ON(!(page_state == ECRYPTFS_PAGE_STATE_MODIFIED
-			 || page_state == ECRYPTFS_PAGE_STATE_READ));
-		rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
-					(base_extent + extent_offset));
+	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
+	if (!enc_extent_virt) {
+		rc = -ENOMEM;
+		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
+				"encrypted extent\n");
+		goto out;
+	}
+	enc_extent_page = virt_to_page(enc_extent_virt);
+	for (extent_offset = 0;
+	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
+	     extent_offset++) {
+		loff_t offset;
+
+		rc = ecryptfs_encrypt_extent(enc_extent_page, crypt_stat, page,
+					     extent_offset);
 		if (rc) {
-			ecryptfs_printk(KERN_ERR, "Error attempting to "
-					"derive IV for extent [0x%.16x]; "
-					"rc = [%d]\n",
-					(base_extent + extent_offset), rc);
+			printk(KERN_ERR "%s: Error encrypting extent; "
+			       "rc = [%d]\n", __FUNCTION__, rc);
 			goto out;
 		}
-		if (unlikely(ecryptfs_verbosity > 0)) {
-			ecryptfs_printk(KERN_DEBUG, "Encrypting extent "
-					"with iv:\n");
-			ecryptfs_dump_hex(extent_iv, crypt_stat->iv_bytes);
-			ecryptfs_printk(KERN_DEBUG, "First 8 bytes before "
-					"encryption:\n");
-			ecryptfs_dump_hex((char *)
-					  (page_address(ctx->page)
-					   + (extent_offset
-					      * crypt_stat->extent_size)), 8);
-		}
-		rc = ecryptfs_encrypt_page_offset(
-			crypt_stat, lower_page, lower_byte_offset, ctx->page,
-			(extent_offset * crypt_stat->extent_size),
-			crypt_stat->extent_size, extent_iv);
-		ecryptfs_printk(KERN_DEBUG, "Encrypt extent [0x%.16x]; "
-				"rc = [%d]\n",
-				(base_extent + extent_offset), rc);
-		if (unlikely(ecryptfs_verbosity > 0)) {
-			ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
-					"encryption:\n");
-			ecryptfs_dump_hex((char *)(page_address(lower_page)
-						   + lower_byte_offset), 8);
+		ecryptfs_lower_offset_for_extent(
+			&offset, ((page->index * (PAGE_CACHE_SIZE
+						  / crypt_stat->extent_size))
+				  + extent_offset), crypt_stat);
+		rc = ecryptfs_write_lower(ecryptfs_inode, enc_extent_virt,
+					  offset, crypt_stat->extent_size);
+		if (rc) {
+			ecryptfs_printk(KERN_ERR, "Error attempting "
+					"to write lower page; rc = [%d]"
+					"\n", rc);
+			goto out;
 		}
-		page_state = ECRYPTFS_PAGE_STATE_MODIFIED;
 		extent_offset++;
 	}
-	BUG_ON(orig_byte_offset != 0);
-	rc = ecryptfs_write_out_page(ctx, lower_page, lower_inode, 0,
-				     (lower_byte_offset
-				      + crypt_stat->extent_size));
+out:
+	kfree(enc_extent_virt);
+	return rc;
+}
+
+static int ecryptfs_decrypt_extent(struct page *page,
+				   struct ecryptfs_crypt_stat *crypt_stat,
+				   struct page *enc_extent_page,
+				   unsigned long extent_offset)
+{
+	unsigned long extent_base;
+	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
+	int rc;
+
+	extent_base = (page->index
+		       * (PAGE_CACHE_SIZE / crypt_stat->extent_size));
+	rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
+				(extent_base + extent_offset));
 	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error attempting to write out "
-				"page; rc = [%d]\n", rc);
-				goto out;
+		ecryptfs_printk(KERN_ERR, "Error attempting to "
+				"derive IV for extent [0x%.16x]; "
+				"rc = [%d]\n", (extent_base + extent_offset),
+				rc);
+		goto out;
+	}
+	if (unlikely(ecryptfs_verbosity > 0)) {
+		ecryptfs_printk(KERN_DEBUG, "Decrypting extent "
+				"with iv:\n");
+		ecryptfs_dump_hex(extent_iv, crypt_stat->iv_bytes);
+		ecryptfs_printk(KERN_DEBUG, "First 8 bytes before "
+				"decryption:\n");
+		ecryptfs_dump_hex((char *)
+				  (page_address(enc_extent_page)
+				   + (extent_offset * crypt_stat->extent_size)),
+				  8);
+	}
+	rc = ecryptfs_decrypt_page_offset(crypt_stat, page,
+					  (extent_offset
+					   * crypt_stat->extent_size),
+					  enc_extent_page, 0,
+					  crypt_stat->extent_size, extent_iv);
+	if (rc < 0) {
+		printk(KERN_ERR "%s: Error attempting to decrypt to page with "
+		       "page->index = [%ld], extent_offset = [%ld]; "
+		       "rc = [%d]\n", __FUNCTION__, page->index, extent_offset,
+		       rc);
+		goto out;
+	}
+	rc = 0;
+	if (unlikely(ecryptfs_verbosity > 0)) {
+		ecryptfs_printk(KERN_DEBUG, "Decrypt extent [0x%.16x]; "
+				"rc = [%d]\n", (extent_base + extent_offset),
+				rc);
+		ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
+				"decryption:\n");
+		ecryptfs_dump_hex((char *)(page_address(page)
+					   + (extent_offset
+					      * crypt_stat->extent_size)), 8);
 	}
 out:
 	return rc;
@@ -607,8 +683,9 @@ out:
 
 /**
  * ecryptfs_decrypt_page
- * @file: The ecryptfs file
- * @page: The page in ecryptfs to decrypt
+ * @page: Page mapped from the eCryptfs inode for the file; data read
+ *        and decrypted from the lower file will be written into this
+ *        page
  *
  * Decrypt an eCryptfs page. This is done on a per-extent basis. Note
  * that eCryptfs pages may straddle the lower pages -- for instance,
@@ -620,103 +697,69 @@ out:
  *
  * Returns zero on success; negative on error
  */
-int ecryptfs_decrypt_page(struct file *file, struct page *page)
+int ecryptfs_decrypt_page(struct page *page)
 {
-	char extent_iv[ECRYPTFS_MAX_IV_BYTES];
-	unsigned long base_extent;
-	unsigned long extent_offset = 0;
-	unsigned long lower_page_idx = 0;
-	unsigned long prior_lower_page_idx = 0;
-	struct page *lower_page;
-	char *lower_page_virt = NULL;
-	struct inode *lower_inode;
+	struct inode *ecryptfs_inode;
 	struct ecryptfs_crypt_stat *crypt_stat;
+	char *enc_extent_virt = NULL;
+	struct page *enc_extent_page;
+	unsigned long extent_offset;
 	int rc = 0;
-	int byte_offset;
-	int num_extents_per_page;
-	int page_state;
 
-	crypt_stat = &(ecryptfs_inode_to_private(
-			       page->mapping->host)->crypt_stat);
-	lower_inode = ecryptfs_inode_to_lower(page->mapping->host);
+	ecryptfs_inode = page->mapping->host;
+	crypt_stat =
+		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
 	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
-		rc = ecryptfs_do_readpage(file, page, page->index);
+		rc = ecryptfs_read_lower_page_segment(page, page->index, 0,
+						      PAGE_CACHE_SIZE,
+						      ecryptfs_inode);
 		if (rc)
-			ecryptfs_printk(KERN_ERR, "Error attempting to copy "
-					"page at index [0x%.16x]\n",
-					page->index);
-		goto out;
+			printk(KERN_ERR "%s: Error attempting to copy "
+			       "page at index [%ld]\n", __FUNCTION__,
+			       page->index);
+		goto out_clear_uptodate;
 	}
-	num_extents_per_page = PAGE_CACHE_SIZE / crypt_stat->extent_size;
-	base_extent = (page->index * num_extents_per_page);
-	lower_page_virt = kmem_cache_alloc(ecryptfs_lower_page_cache,
-					   GFP_KERNEL);
-	if (!lower_page_virt) {
+	enc_extent_virt = kmalloc(PAGE_CACHE_SIZE, GFP_USER);
+	if (!enc_extent_virt) {
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Error getting page for encrypted "
-				"lower page(s)\n");
-		goto out;
-	}
-	lower_page = virt_to_page(lower_page_virt);
-	page_state = ECRYPTFS_PAGE_STATE_UNREAD;
-	while (extent_offset < num_extents_per_page) {
-		ecryptfs_extent_to_lwr_pg_idx_and_offset(
-			&lower_page_idx, &byte_offset, crypt_stat,
-			(base_extent + extent_offset));
-		if (prior_lower_page_idx != lower_page_idx
-		    || page_state == ECRYPTFS_PAGE_STATE_UNREAD) {
-			rc = ecryptfs_do_readpage(file, lower_page,
-						  lower_page_idx);
-			if (rc) {
-				ecryptfs_printk(KERN_ERR, "Error reading "
-						"lower encrypted page; rc = "
-						"[%d]\n", rc);
-				goto out;
-			}
-			prior_lower_page_idx = lower_page_idx;
-			page_state = ECRYPTFS_PAGE_STATE_READ;
-		}
-		rc = ecryptfs_derive_iv(extent_iv, crypt_stat,
-					(base_extent + extent_offset));
+		ecryptfs_printk(KERN_ERR, "Error allocating memory for "
+				"encrypted extent\n");
+		goto out_clear_uptodate;
+	}
+	enc_extent_page = virt_to_page(enc_extent_virt);
+	for (extent_offset = 0;
+	     extent_offset < (PAGE_CACHE_SIZE / crypt_stat->extent_size);
+	     extent_offset++) {
+		loff_t offset;
+
+		ecryptfs_lower_offset_for_extent(
+			&offset, ((page->index * (PAGE_CACHE_SIZE
+						  / crypt_stat->extent_size))
+				  + extent_offset), crypt_stat);
+		rc = ecryptfs_read_lower(enc_extent_virt, offset,
+					 crypt_stat->extent_size,
+					 ecryptfs_inode);
 		if (rc) {
-			ecryptfs_printk(KERN_ERR, "Error attempting to "
-					"derive IV for extent [0x%.16x]; rc = "
-					"[%d]\n",
-					(base_extent + extent_offset), rc);
-			goto out;
-		}
-		if (unlikely(ecryptfs_verbosity > 0)) {
-			ecryptfs_printk(KERN_DEBUG, "Decrypting extent "
-					"with iv:\n");
-			ecryptfs_dump_hex(extent_iv, crypt_stat->iv_bytes);
-			ecryptfs_printk(KERN_DEBUG, "First 8 bytes before "
-					"decryption:\n");
-			ecryptfs_dump_hex((lower_page_virt + byte_offset), 8);
+			ecryptfs_printk(KERN_ERR, "Error attempting "
+					"to read lower page; rc = [%d]"
+					"\n", rc);
+			goto out_clear_uptodate;
 		}
-		rc = ecryptfs_decrypt_page_offset(crypt_stat, page,
-						  (extent_offset
-						   * crypt_stat->extent_size),
-						  lower_page, byte_offset,
-						  crypt_stat->extent_size,
-						  extent_iv);
-		if (rc != crypt_stat->extent_size) {
-			ecryptfs_printk(KERN_ERR, "Error attempting to "
-					"decrypt extent [0x%.16x]\n",
-					(base_extent + extent_offset));
-			goto out;
-		}
-		rc = 0;
-		if (unlikely(ecryptfs_verbosity > 0)) {
-			ecryptfs_printk(KERN_DEBUG, "First 8 bytes after "
-					"decryption:\n");
-			ecryptfs_dump_hex((char *)(page_address(page)
-						   + byte_offset), 8);
+		rc = ecryptfs_decrypt_extent(page, crypt_stat, enc_extent_page,
+					     extent_offset);
+		if (rc) {
+			printk(KERN_ERR "%s: Error encrypting extent; "
+			       "rc = [%d]\n", __FUNCTION__, rc);
+			goto out_clear_uptodate;
 		}
 		extent_offset++;
 	}
+	SetPageUptodate(page);
+	goto out;
+out_clear_uptodate:
+	ClearPageUptodate(page);
 out:
-	if (lower_page_virt)
-		kmem_cache_free(ecryptfs_lower_page_cache, lower_page_virt);
+	kfree(enc_extent_virt);
 	return rc;
 }
 
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index e6a68a8..65f7ddf 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -552,13 +552,7 @@ void ecryptfs_destroy_crypt_stat(struct ecryptfs_crypt_stat *crypt_stat);
 void ecryptfs_destroy_mount_crypt_stat(
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat);
 int ecryptfs_init_crypt_ctx(struct ecryptfs_crypt_stat *crypt_stat);
-#define ECRYPTFS_LOWER_I_MUTEX_NOT_HELD 0
-#define ECRYPTFS_LOWER_I_MUTEX_HELD 1
-int ecryptfs_write_inode_size_to_metadata(struct file *lower_file,
-					  struct inode *lower_inode,
-					  struct inode *inode,
-					  struct dentry *ecryptfs_dentry,
-					  int lower_i_mutex_held);
+int ecryptfs_write_inode_size_to_metadata(struct inode *ecryptefs_inode);
 int ecryptfs_get_lower_page(struct page **lower_page, struct inode *lower_inode,
 			    struct file *lower_file,
 			    unsigned long lower_page_index, int byte_offset,
@@ -574,8 +568,8 @@ int ecryptfs_do_readpage(struct file *file, struct page *page,
 int ecryptfs_writepage_and_release_lower_page(struct page *lower_page,
 					      struct inode *lower_inode,
 					      struct writeback_control *wbc);
-int ecryptfs_encrypt_page(struct ecryptfs_page_crypt_context *ctx);
-int ecryptfs_decrypt_page(struct file *file, struct page *page);
+int ecryptfs_encrypt_page(struct page *page);
+int ecryptfs_decrypt_page(struct page *page);
 int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
 			    struct file *lower_file);
 int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
@@ -655,6 +649,8 @@ int ecryptfs_keyring_auth_tok_for_sig(struct key **auth_tok_key,
 				      char *sig);
 int ecryptfs_write_zeros(struct file *file, pgoff_t index, int start,
 			 int num_zeros);
+void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
+				      struct ecryptfs_crypt_stat *crypt_stat);
 int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
 			 loff_t offset, size_t size);
 int ecryptfs_write_lower_page_segment(struct inode *ecryptfs_inode,
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index d70f599..7192a81 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -168,9 +168,7 @@ static int grow_file(struct dentry *ecryptfs_dentry, struct file *lower_file,
 		goto out;
 	}
 	i_size_write(inode, 0);
-	rc = ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode,
-			inode, ecryptfs_dentry,
-			ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
+	rc = ecryptfs_write_inode_size_to_metadata(inode);
 	ecryptfs_inode_to_private(inode)->crypt_stat.flags |= ECRYPTFS_NEW_FILE;
 out:
 	return rc;
@@ -798,9 +796,7 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 			goto out_fput;
 		}
 		i_size_write(inode, new_length);
-		rc = ecryptfs_write_inode_size_to_metadata(
-			lower_file, lower_dentry->d_inode, inode, dentry,
-			ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
+		rc = ecryptfs_write_inode_size_to_metadata(inode);
 		if (rc) {
 			printk(KERN_ERR	"Problem with "
 			       "ecryptfs_write_inode_size_to_metadata; "
@@ -829,9 +825,7 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 			}
 		}
 		vmtruncate(inode, new_length);
-		rc = ecryptfs_write_inode_size_to_metadata(
-			lower_file, lower_dentry->d_inode, inode, dentry,
-			ECRYPTFS_LOWER_I_MUTEX_NOT_HELD);
+		rc = ecryptfs_write_inode_size_to_metadata(inode);
 		if (rc) {
 			printk(KERN_ERR	"Problem with "
 			       "ecryptfs_write_inode_size_to_metadata; "
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 0c53320..9b62110 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -171,13 +171,9 @@ out:
  */
 static int ecryptfs_writepage(struct page *page, struct writeback_control *wbc)
 {
-	struct ecryptfs_page_crypt_context ctx;
 	int rc;
 
-	ctx.page = page;
-	ctx.mode = ECRYPTFS_WRITEPAGE_MODE;
-	ctx.param.wbc = wbc;
-	rc = ecryptfs_encrypt_page(&ctx);
+	rc = ecryptfs_encrypt_page(page);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error encrypting "
 				"page (upper index [0x%.16x])\n", page->index);
@@ -341,7 +337,7 @@ static int ecryptfs_readpage(struct file *file, struct page *page)
 			}
 		}
 	} else {
-		rc = ecryptfs_decrypt_page(file, page);
+		rc = ecryptfs_decrypt_page(page);
 		if (rc) {
 			ecryptfs_printk(KERN_ERR, "Error decrypting page; "
 					"rc = [%d]\n", rc);
@@ -459,58 +455,48 @@ static void ecryptfs_release_lower_page(struct page *lower_page)
  *
  * Returns zero on success; non-zero on error.
  */
-static int ecryptfs_write_inode_size_to_header(struct file *lower_file,
-					       struct inode *lower_inode,
-					       struct inode *inode)
+static int ecryptfs_write_inode_size_to_header(struct inode *ecryptfs_inode)
 {
-	int rc = 0;
-	struct page *header_page;
-	char *header_virt;
-	const struct address_space_operations *lower_a_ops;
 	u64 file_size;
+	char *file_size_virt;
+	int rc;
 
-	header_page = grab_cache_page(lower_inode->i_mapping, 0);
-	if (!header_page) {
-		ecryptfs_printk(KERN_ERR, "grab_cache_page for "
-				"lower_page_index 0 failed\n");
-		rc = -EINVAL;
-		goto out;
-	}
-	lower_a_ops = lower_inode->i_mapping->a_ops;
-	rc = lower_a_ops->prepare_write(lower_file, header_page, 0, 8);
-	if (rc) {
-		ecryptfs_release_lower_page(header_page);
+	file_size_virt = kmalloc(sizeof(u64), GFP_KERNEL);
+	if (!file_size_virt) {
+		rc = -ENOMEM;
 		goto out;
 	}
-	file_size = (u64)i_size_read(inode);
-	ecryptfs_printk(KERN_DEBUG, "Writing size: [0x%.16x]\n", file_size);
+	file_size = (u64)i_size_read(ecryptfs_inode);
 	file_size = cpu_to_be64(file_size);
-	header_virt = kmap_atomic(header_page, KM_USER0);
-	memcpy(header_virt, &file_size, sizeof(u64));
-	kunmap_atomic(header_virt, KM_USER0);
-	flush_dcache_page(header_page);
-	rc = lower_a_ops->commit_write(lower_file, header_page, 0, 8);
-	if (rc < 0)
-		ecryptfs_printk(KERN_ERR, "Error commiting header page "
-				"write\n");
-	ecryptfs_release_lower_page(header_page);
-	lower_inode->i_mtime = lower_inode->i_ctime = CURRENT_TIME;
-	mark_inode_dirty_sync(inode);
+	memcpy(file_size_virt, &file_size, sizeof(u64));
+	rc = ecryptfs_write_lower(ecryptfs_inode, file_size_virt, 0,
+				  sizeof(u64));
+	kfree(file_size_virt);
+	if (rc)
+		printk(KERN_ERR "%s: Error writing file size to header; "
+		       "rc = [%d]\n", __FUNCTION__, rc);
 out:
 	return rc;
 }
 
-static int ecryptfs_write_inode_size_to_xattr(struct inode *lower_inode,
-					      struct inode *inode,
-					      struct dentry *ecryptfs_dentry,
-					      int lower_i_mutex_held)
+struct kmem_cache *ecryptfs_xattr_cache;
+
+static int ecryptfs_write_inode_size_to_xattr(struct inode *ecryptfs_inode)
 {
 	ssize_t size;
 	void *xattr_virt;
-	struct dentry *lower_dentry;
+	struct dentry *lower_dentry =
+		ecryptfs_inode_to_private(ecryptfs_inode)->lower_file->f_dentry;
+	struct inode *lower_inode = lower_dentry->d_inode;
 	u64 file_size;
 	int rc;
 
+	if (!lower_inode->i_op->getxattr || !lower_inode->i_op->setxattr) {
+		printk(KERN_WARNING
+		       "No support for setting xattr in lower filesystem\n");
+		rc = -ENOSYS;
+		goto out;
+	}
 	xattr_virt = kmem_cache_alloc(ecryptfs_xattr_cache, GFP_KERNEL);
 	if (!xattr_virt) {
 		printk(KERN_ERR "Out of memory whilst attempting to write "
@@ -518,35 +504,17 @@ static int ecryptfs_write_inode_size_to_xattr(struct inode *lower_inode,
 		rc = -ENOMEM;
 		goto out;
 	}
-	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
-	if (!lower_dentry->d_inode->i_op->getxattr ||
-			!lower_dentry->d_inode->i_op->setxattr) {
-		printk(KERN_WARNING
-		       "No support for setting xattr in lower filesystem\n");
-		rc = -ENOSYS;
-		kmem_cache_free(ecryptfs_xattr_cache, xattr_virt);
-		goto out;
-	}
-	if (!lower_i_mutex_held)
-		mutex_lock(&lower_dentry->d_inode->i_mutex);
-	size = lower_dentry->d_inode->i_op->getxattr(lower_dentry,
-						     ECRYPTFS_XATTR_NAME,
-						     xattr_virt,
-						     PAGE_CACHE_SIZE);
-	if (!lower_i_mutex_held)
-		mutex_unlock(&lower_dentry->d_inode->i_mutex);
+	mutex_lock(&lower_inode->i_mutex);
+	size = lower_inode->i_op->getxattr(lower_dentry, ECRYPTFS_XATTR_NAME,
+					   xattr_virt, PAGE_CACHE_SIZE);
 	if (size < 0)
 		size = 8;
-	file_size = (u64)i_size_read(inode);
+	file_size = (u64)i_size_read(ecryptfs_inode);
 	file_size = cpu_to_be64(file_size);
 	memcpy(xattr_virt, &file_size, sizeof(u64));
-	if (!lower_i_mutex_held)
-		mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry,
-						   ECRYPTFS_XATTR_NAME,
-						   xattr_virt, size, 0);
-	if (!lower_i_mutex_held)
-		mutex_unlock(&lower_dentry->d_inode->i_mutex);
+	rc = lower_inode->i_op->setxattr(lower_dentry, ECRYPTFS_XATTR_NAME,
+					 xattr_virt, size, 0);
+	mutex_unlock(&lower_inode->i_mutex);
 	if (rc)
 		printk(KERN_ERR "Error whilst attempting to write inode size "
 		       "to lower file xattr; rc = [%d]\n", rc);
@@ -555,24 +523,15 @@ out:
 	return rc;
 }
 
-int
-ecryptfs_write_inode_size_to_metadata(struct file *lower_file,
-				      struct inode *lower_inode,
-				      struct inode *inode,
-				      struct dentry *ecryptfs_dentry,
-				      int lower_i_mutex_held)
+int ecryptfs_write_inode_size_to_metadata(struct inode *ecryptfs_inode)
 {
 	struct ecryptfs_crypt_stat *crypt_stat;
 
-	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
+	crypt_stat = &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
 	if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
-		return ecryptfs_write_inode_size_to_xattr(lower_inode, inode,
-							  ecryptfs_dentry,
-							  lower_i_mutex_held);
+		return ecryptfs_write_inode_size_to_xattr(ecryptfs_inode);
 	else
-		return ecryptfs_write_inode_size_to_header(lower_file,
-							   lower_inode,
-							   inode);
+		return ecryptfs_write_inode_size_to_header(ecryptfs_inode);
 }
 
 int ecryptfs_get_lower_page(struct page **lower_page, struct inode *lower_inode,
@@ -659,8 +618,6 @@ out:
 	return rc;
 }
 
-struct kmem_cache *ecryptfs_xattr_cache;
-
 /**
  * ecryptfs_commit_write
  * @file: The eCryptfs file object
@@ -675,7 +632,6 @@ struct kmem_cache *ecryptfs_xattr_cache;
 static int ecryptfs_commit_write(struct file *file, struct page *page,
 				 unsigned from, unsigned to)
 {
-	struct ecryptfs_page_crypt_context ctx;
 	loff_t pos;
 	struct inode *inode;
 	struct inode *lower_inode;
@@ -705,10 +661,7 @@ static int ecryptfs_commit_write(struct file *file, struct page *page,
 				page->index);
 		goto out;
 	}
-	ctx.page = page;
-	ctx.mode = ECRYPTFS_PREPARE_COMMIT_MODE;
-	ctx.param.lower_file = lower_file;
-	rc = ecryptfs_encrypt_page(&ctx);
+	rc = ecryptfs_encrypt_page(page);
 	if (rc) {
 		ecryptfs_printk(KERN_WARNING, "Error encrypting page (upper "
 				"index [0x%.16x])\n", page->index);
@@ -721,9 +674,7 @@ static int ecryptfs_commit_write(struct file *file, struct page *page,
 		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
 				"[0x%.16x]\n", i_size_read(inode));
 	}
-	rc = ecryptfs_write_inode_size_to_metadata(lower_file, lower_inode,
-						   inode, file->f_dentry,
-						   ECRYPTFS_LOWER_I_MUTEX_HELD);
+	rc = ecryptfs_write_inode_size_to_metadata(inode);
 	if (rc)
 		printk(KERN_ERR "Error writing inode size to metadata; "
 		       "rc = [%d]\n", rc);
diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
index e59c94a..ccd2599 100644
--- a/fs/ecryptfs/read_write.c
+++ b/fs/ecryptfs/read_write.c
@@ -154,8 +154,8 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 			/* Read in the page from the lower
 			 * into the eCryptfs inode page cache,
 			 * decrypting */
-			if ((rc = ecryptfs_decrypt_page(NULL, /* placeholder for git-bisect */
-							ecryptfs_page))) {
+			rc = ecryptfs_decrypt_page(ecryptfs_page);
+			if (rc) {
 				printk(KERN_ERR "%s: Error decrypting "
 				       "page; rc = [%d]\n",
 				       __FUNCTION__, rc);
@@ -178,7 +178,7 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 		}
 		kunmap_atomic(ecryptfs_page_virt, KM_USER0);
 		flush_dcache_page(ecryptfs_page);
-		rc = ecryptfs_encrypt_page(NULL /* placeholder for git-bisect */);
+		rc = ecryptfs_encrypt_page(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error encrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
@@ -190,8 +190,8 @@ int ecryptfs_write(struct file *ecryptfs_file, char *data, loff_t offset,
 	}
 	if ((offset + size) > ecryptfs_file_size) {
 		i_size_write(ecryptfs_file->f_dentry->d_inode, (offset + size));
-		rc = ecryptfs_write_inode_size_to_metadata(NULL, NULL, NULL,
-							   NULL, 0); /* placeholders for git-bisect */
+		rc = ecryptfs_write_inode_size_to_metadata(
+			ecryptfs_file->f_dentry->d_inode);
 		if (rc) {
 			printk(KERN_ERR	"Problem with "
 			       "ecryptfs_write_inode_size_to_metadata; "
@@ -338,7 +338,7 @@ int ecryptfs_read(char *data, loff_t offset, size_t size,
 			       ecryptfs_page_idx, rc);
 			goto out;
 		}
-		rc = ecryptfs_decrypt_page(NULL /* placeholder for git-bisect */, ecryptfs_page);
+		rc = ecryptfs_decrypt_page(ecryptfs_page);
 		if (rc) {
 			printk(KERN_ERR "%s: Error decrypting "
 			       "page; rc = [%d]\n", __FUNCTION__, rc);
-- 
1.5.1.6

