Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbXKBSyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbXKBSyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757280AbXKBSyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:54:15 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:44026 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755029AbXKBSyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:54:14 -0400
Date: Fri, 2 Nov 2007 13:51:33 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       trevor.highland@gmail.com
Subject: [PATCH 1/3] eCryptfs: Track header bytes rather than extents
Message-ID: <20071102185133.GA30760@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20071102185033.GB30487@localhost.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102185033.GB30487@localhost.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove internal references to header extents; just keep track of
header bytes instead. Headers can easily span multiple pages with the
recent persistent file changes.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |   98 +++++++++++++++--------------------------
 fs/ecryptfs/ecryptfs_kernel.h |    3 +-
 fs/ecryptfs/inode.c           |    8 +--
 fs/ecryptfs/main.c            |    5 --
 fs/ecryptfs/mmap.c            |   21 +++++----
 5 files changed, 51 insertions(+), 84 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 9d70289..ca0dfea 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -361,8 +361,7 @@ out:
 void ecryptfs_lower_offset_for_extent(loff_t *offset, loff_t extent_num,
 				      struct ecryptfs_crypt_stat *crypt_stat)
 {
-	(*offset) = ((crypt_stat->extent_size
-		      * crypt_stat->num_header_extents_at_front)
+	(*offset) = (crypt_stat->num_header_bytes_at_front
 		     + (crypt_stat->extent_size * extent_num));
 }
 
@@ -826,15 +825,13 @@ void ecryptfs_set_default_sizes(struct ecryptfs_crypt_stat *crypt_stat)
 	set_extent_mask_and_shift(crypt_stat);
 	crypt_stat->iv_bytes = ECRYPTFS_DEFAULT_IV_BYTES;
 	if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
-		crypt_stat->num_header_extents_at_front = 0;
+		crypt_stat->num_header_bytes_at_front = 0;
 	else {
 		if (PAGE_CACHE_SIZE <= ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)
-			crypt_stat->num_header_extents_at_front =
-				(ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE
-				 / crypt_stat->extent_size);
+			crypt_stat->num_header_bytes_at_front =
+				ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE;
 		else
-			crypt_stat->num_header_extents_at_front =
-				(PAGE_CACHE_SIZE / crypt_stat->extent_size);
+			crypt_stat->num_header_bytes_at_front =	PAGE_CACHE_SIZE;
 	}
 }
 
@@ -1220,7 +1217,8 @@ ecryptfs_write_header_metadata(char *virt,
 
 	header_extent_size = (u32)crypt_stat->extent_size;
 	num_header_extents_at_front =
-		(u16)crypt_stat->num_header_extents_at_front;
+		(u16)(crypt_stat->num_header_bytes_at_front
+		      / crypt_stat->extent_size);
 	header_extent_size = cpu_to_be32(header_extent_size);
 	memcpy(virt, &header_extent_size, 4);
 	virt += 4;
@@ -1295,40 +1293,16 @@ static int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
 static int
 ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
 				    struct dentry *ecryptfs_dentry,
-				    char *page_virt)
+				    char *virt)
 {
-	int current_header_page;
-	int header_pages;
 	int rc;
 
-	rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, page_virt,
-				  0, PAGE_CACHE_SIZE);
-	if (rc) {
+	rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, virt,
+				  0, crypt_stat->num_header_bytes_at_front);
+	if (rc)
 		printk(KERN_ERR "%s: Error attempting to write header "
 		       "information to lower file; rc = [%d]\n", __FUNCTION__,
 		       rc);
-		goto out;
-	}
-	header_pages = ((crypt_stat->extent_size
-			 * crypt_stat->num_header_extents_at_front)
-			/ PAGE_CACHE_SIZE);
-	memset(page_virt, 0, PAGE_CACHE_SIZE);
-	current_header_page = 1;
-	while (current_header_page < header_pages) {
-		loff_t offset;
-
-		offset = (((loff_t)current_header_page) << PAGE_CACHE_SHIFT);
-		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,
-					       page_virt, offset,
-					       PAGE_CACHE_SIZE))) {
-			printk(KERN_ERR "%s: Error attempting to write header "
-			       "information to lower file; rc = [%d]\n",
-			       __FUNCTION__, rc);
-			goto out;
-		}
-		current_header_page++;
-	}
-out:
 	return rc;
 }
 
@@ -1354,15 +1328,13 @@ ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
  * retrieved via a prompt.  Exactly what happens at this point should
  * be policy-dependent.
  *
- * TODO: Support header information spanning multiple pages
- *
  * Returns zero on success; non-zero on error
  */
 int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry)
 {
 	struct ecryptfs_crypt_stat *crypt_stat =
 		&ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
-	char *page_virt;
+	char *virt;
 	size_t size = 0;
 	int rc = 0;
 
@@ -1373,40 +1345,39 @@ int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry)
 			goto out;
 		}
 	} else {
+		printk(KERN_WARNING "%s: Encrypted flag not set\n",
+		       __FUNCTION__);
 		rc = -EINVAL;
-		ecryptfs_printk(KERN_WARNING,
-				"Called with crypt_stat->encrypted == 0\n");
 		goto out;
 	}
 	/* Released in this function */
-	page_virt = kmem_cache_zalloc(ecryptfs_header_cache_0, GFP_USER);
-	if (!page_virt) {
-		ecryptfs_printk(KERN_ERR, "Out of memory\n");
+	virt = kzalloc(crypt_stat->num_header_bytes_at_front, GFP_KERNEL);
+	if (!virt) {
+		printk(KERN_ERR "%s: Out of memory\n", __FUNCTION__);
 		rc = -ENOMEM;
 		goto out;
 	}
-	rc = ecryptfs_write_headers_virt(page_virt, &size, crypt_stat,
-  					 ecryptfs_dentry);
+	rc = ecryptfs_write_headers_virt(virt, &size, crypt_stat,
+					 ecryptfs_dentry);
 	if (unlikely(rc)) {
-		ecryptfs_printk(KERN_ERR, "Error whilst writing headers\n");
-		memset(page_virt, 0, PAGE_CACHE_SIZE);
+		printk(KERN_ERR "%s: Error whilst writing headers; rc = [%d]\n",
+		       __FUNCTION__, rc);
 		goto out_free;
 	}
 	if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
 		rc = ecryptfs_write_metadata_to_xattr(ecryptfs_dentry,
-						      crypt_stat, page_virt,
-						      size);
+						      crypt_stat, virt, size);
 	else
 		rc = ecryptfs_write_metadata_to_contents(crypt_stat,
-							 ecryptfs_dentry,
-							 page_virt);
+							 ecryptfs_dentry, virt);
 	if (rc) {
-		printk(KERN_ERR "Error writing metadata out to lower file; "
-		       "rc = [%d]\n", rc);
+		printk(KERN_ERR "%s: Error writing metadata out to lower file; "
+		       "rc = [%d]\n", __FUNCTION__, rc);
 		goto out_free;
 	}
 out_free:
-	kmem_cache_free(ecryptfs_header_cache_0, page_virt);
+	memset(virt, 0, crypt_stat->num_header_bytes_at_front);
+	kfree(virt);
 out:
 	return rc;
 }
@@ -1426,16 +1397,16 @@ static int parse_header_metadata(struct ecryptfs_crypt_stat *crypt_stat,
 	virt += sizeof(u32);
 	memcpy(&num_header_extents_at_front, virt, sizeof(u16));
 	num_header_extents_at_front = be16_to_cpu(num_header_extents_at_front);
-	crypt_stat->num_header_extents_at_front =
-		(int)num_header_extents_at_front;
+	crypt_stat->num_header_bytes_at_front =
+		(((size_t)num_header_extents_at_front
+		  * (size_t)header_extent_size));
 	(*bytes_read) = (sizeof(u32) + sizeof(u16));
 	if ((validate_header_size == ECRYPTFS_VALIDATE_HEADER_SIZE)
-	    && ((crypt_stat->extent_size
-		 * crypt_stat->num_header_extents_at_front)
+	    && (crypt_stat->num_header_bytes_at_front
 		< ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE)) {
 		rc = -EINVAL;
-		printk(KERN_WARNING "Invalid number of header extents: [%zd]\n",
-		       crypt_stat->num_header_extents_at_front);
+		printk(KERN_WARNING "Invalid header size: [%zd]\n",
+		       crypt_stat->num_header_bytes_at_front);
 	}
 	return rc;
 }
@@ -1450,7 +1421,8 @@ static int parse_header_metadata(struct ecryptfs_crypt_stat *crypt_stat,
  */
 static void set_default_header_data(struct ecryptfs_crypt_stat *crypt_stat)
 {
-	crypt_stat->num_header_extents_at_front = 2;
+	crypt_stat->num_header_bytes_at_front =
+		ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE;
 }
 
 /**
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index ce7a5d4..78b7916 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -237,7 +237,7 @@ struct ecryptfs_crypt_stat {
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
-	size_t num_header_extents_at_front;
+	size_t num_header_bytes_at_front;
 	size_t extent_size; /* Data extent size; default is 4096 */
 	size_t key_size;
 	size_t extent_shift;
@@ -521,7 +521,6 @@ extern struct kmem_cache *ecryptfs_file_info_cache;
 extern struct kmem_cache *ecryptfs_dentry_info_cache;
 extern struct kmem_cache *ecryptfs_inode_info_cache;
 extern struct kmem_cache *ecryptfs_sb_info_cache;
-extern struct kmem_cache *ecryptfs_header_cache_0;
 extern struct kmem_cache *ecryptfs_header_cache_1;
 extern struct kmem_cache *ecryptfs_header_cache_2;
 extern struct kmem_cache *ecryptfs_xattr_cache;
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 0b1ab01..8fb40ff 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -378,8 +378,7 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 		dentry->d_sb)->mount_crypt_stat;
 	if (mount_crypt_stat->flags & ECRYPTFS_ENCRYPTED_VIEW_ENABLED) {
 		if (crypt_stat->flags & ECRYPTFS_METADATA_IN_XATTR)
-			file_size = ((crypt_stat->extent_size
-				      * crypt_stat->num_header_extents_at_front)
+			file_size = (crypt_stat->num_header_bytes_at_front
 				     + i_size_read(lower_dentry->d_inode));
 		else
 			file_size = i_size_read(lower_dentry->d_inode);
@@ -697,7 +696,7 @@ ecryptfs_put_link(struct dentry *dentry, struct nameidata *nd, void *ptr)
  * @crypt_stat: Crypt_stat associated with file
  * @upper_size: Size of the upper file
  *
- * Calculate the requried size of the lower file based on the
+ * Calculate the required size of the lower file based on the
  * specified size of the upper file. This calculation is based on the
  * number of headers in the underlying file and the extent size.
  *
@@ -709,8 +708,7 @@ upper_size_to_lower_size(struct ecryptfs_crypt_stat *crypt_stat,
 {
 	loff_t lower_size;
 
-	lower_size = (crypt_stat->extent_size
-		      * crypt_stat->num_header_extents_at_front);
+	lower_size = crypt_stat->num_header_bytes_at_front;
 	if (upper_size != 0) {
 		loff_t num_extents;
 
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index b83a512..333db23 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -650,11 +650,6 @@ static struct ecryptfs_cache_info {
 		.size = sizeof(struct ecryptfs_sb_info),
 	},
 	{
-		.cache = &ecryptfs_header_cache_0,
-		.name = "ecryptfs_headers_0",
-		.size = PAGE_CACHE_SIZE,
-	},
-	{
 		.cache = &ecryptfs_header_cache_1,
 		.name = "ecryptfs_headers_1",
 		.size = PAGE_CACHE_SIZE,
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 16a7a55..a6242a7 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -102,13 +102,14 @@ static void set_header_info(char *page_virt,
 			    struct ecryptfs_crypt_stat *crypt_stat)
 {
 	size_t written;
-	int save_num_header_extents_at_front =
-		crypt_stat->num_header_extents_at_front;
+	size_t save_num_header_bytes_at_front =
+		crypt_stat->num_header_bytes_at_front;
 
-	crypt_stat->num_header_extents_at_front = 1;
+	crypt_stat->num_header_bytes_at_front =
+		ECRYPTFS_MINIMUM_HEADER_EXTENT_SIZE;
 	ecryptfs_write_header_metadata(page_virt + 20, crypt_stat, &written);
-	crypt_stat->num_header_extents_at_front =
-		save_num_header_extents_at_front;
+	crypt_stat->num_header_bytes_at_front =
+		save_num_header_bytes_at_front;
 }
 
 /**
@@ -134,8 +135,11 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 		loff_t view_extent_num = ((((loff_t)page->index)
 					   * num_extents_per_page)
 					  + extent_num_in_page);
+		size_t num_header_extents_at_front =
+			(crypt_stat->num_header_bytes_at_front
+			 / crypt_stat->extent_size);
 
-		if (view_extent_num < crypt_stat->num_header_extents_at_front) {
+		if (view_extent_num < num_header_extents_at_front) {
 			/* This is a header extent */
 			char *page_virt;
 
@@ -157,9 +161,8 @@ ecryptfs_copy_up_encrypted_with_header(struct page *page,
 		} else {
 			/* This is an encrypted data extent */
 			loff_t lower_offset =
-				((view_extent_num -
-				  crypt_stat->num_header_extents_at_front)
-				 * crypt_stat->extent_size);
+				((view_extent_num * crypt_stat->extent_size)
+				 - crypt_stat->num_header_bytes_at_front);
 
 			rc = ecryptfs_read_lower_page_segment(
 				page, (lower_offset >> PAGE_CACHE_SHIFT),
-- 
1.5.0.6

