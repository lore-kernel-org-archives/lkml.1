Return-Path: <linux-kernel-owner+w=401wt.eu-S932628AbXIQVxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbXIQVxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbXIQVxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:53:25 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35504 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbXIQVxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:53:23 -0400
Date: Mon, 17 Sep 2007 16:48:44 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH 6/11] eCryptfs: Update metadata read/write functions
Message-ID: <20070917214844.GN13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917214436.GH13679@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update the metadata read/write functions and grow_file() to use the
read_write.c routines. Do not open another lower file; use the
persistent lower file instead. Provide a separate function for
crypto.c::ecryptfs_read_xattr_region() to get to the lower xattr
without having to go through the eCryptfs getxattr.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c          |  126 +++++++++++++++++++----------------------
 fs/ecryptfs/ecryptfs_kernel.h |   15 +++--
 fs/ecryptfs/file.c            |    2 +-
 fs/ecryptfs/inode.c           |  101 +++++++++++++++------------------
 fs/ecryptfs/mmap.c            |    2 +-
 5 files changed, 113 insertions(+), 133 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index d6a0680..6b4d310 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1344,21 +1344,28 @@ out:
 	return rc;
 }
 
-int ecryptfs_read_and_validate_header_region(char *data, struct dentry *dentry,
-					     struct vfsmount *mnt)
+int ecryptfs_read_and_validate_header_region(char *data,
+					     struct inode *ecryptfs_inode)
 {
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&(ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat);
 	int rc;
 
-	rc = ecryptfs_read_header_region(data, dentry, mnt);
-	if (rc)
+	rc = ecryptfs_read_lower(data, 0, crypt_stat->extent_size,
+				 ecryptfs_inode);
+	if (rc) {
+		printk(KERN_ERR "%s: Error reading header region; rc = [%d]\n",
+		       __FUNCTION__, rc);
 		goto out;
-	if (!contains_ecryptfs_marker(data + ECRYPTFS_FILE_SIZE_BYTES))
+	}
+	if (!contains_ecryptfs_marker(data + ECRYPTFS_FILE_SIZE_BYTES)) {
 		rc = -EINVAL;
+		ecryptfs_printk(KERN_DEBUG, "Valid marker not found\n");
+	}
 out:
 	return rc;
 }
 
-
 void
 ecryptfs_write_header_metadata(char *virt,
 			       struct ecryptfs_crypt_stat *crypt_stat,
@@ -1443,24 +1450,18 @@ static int ecryptfs_write_headers_virt(char *page_virt, size_t *size,
 
 static int
 ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
-				    struct file *lower_file, char *page_virt)
+				    struct dentry *ecryptfs_dentry,
+				    char *page_virt)
 {
-	mm_segment_t oldfs;
 	int current_header_page;
 	int header_pages;
-	ssize_t size;
-	int rc = 0;
+	int rc;
 
-	lower_file->f_pos = 0;
-	oldfs = get_fs();
-	set_fs(get_ds());
-	size = vfs_write(lower_file, (char __user *)page_virt, PAGE_CACHE_SIZE,
-			 &lower_file->f_pos);
-	if (size < 0) {
-		rc = (int)size;
-		printk(KERN_ERR "Error attempting to write lower page; "
-		       "rc = [%d]\n", rc);
-		set_fs(oldfs);
+	if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode, page_virt,
+				       0, PAGE_CACHE_SIZE))) {
+		printk(KERN_ERR "%s: Error attempting to write header "
+		       "information to lower file; rc = [%d]\n", __FUNCTION__,
+		       rc);
 		goto out;
 	}
 	header_pages = ((crypt_stat->extent_size
@@ -1469,18 +1470,19 @@ ecryptfs_write_metadata_to_contents(struct ecryptfs_crypt_stat *crypt_stat,
 	memset(page_virt, 0, PAGE_CACHE_SIZE);
 	current_header_page = 1;
 	while (current_header_page < header_pages) {
-		size = vfs_write(lower_file, (char __user *)page_virt,
-				 PAGE_CACHE_SIZE, &lower_file->f_pos);
-		if (size < 0) {
-			rc = (int)size;
-			printk(KERN_ERR "Error attempting to write lower page; "
-			       "rc = [%d]\n", rc);
-			set_fs(oldfs);
+		loff_t offset;
+
+		offset = (current_header_page << PAGE_CACHE_SHIFT);
+		if ((rc = ecryptfs_write_lower(ecryptfs_dentry->d_inode,
+					       page_virt, offset,
+					       PAGE_CACHE_SIZE))) {
+			printk(KERN_ERR "%s: Error attempting to write header "
+			       "information to lower file; rc = [%d]\n",
+			       __FUNCTION__, rc);
 			goto out;
 		}
 		current_header_page++;
 	}
-	set_fs(oldfs);
 out:
 	return rc;
 }
@@ -1500,7 +1502,6 @@ ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
 /**
  * ecryptfs_write_metadata
  * @ecryptfs_dentry: The eCryptfs dentry
- * @lower_file: The lower file struct, which was returned from dentry_open
  *
  * Write the file headers out.  This will likely involve a userspace
  * callout, in which the session key is encrypted with one or more
@@ -1508,22 +1509,21 @@ ecryptfs_write_metadata_to_xattr(struct dentry *ecryptfs_dentry,
  * retrieved via a prompt.  Exactly what happens at this point should
  * be policy-dependent.
  *
+ * TODO: Support header information spanning multiple pages
+ *
  * Returns zero on success; non-zero on error
  */
-int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
-			    struct file *lower_file)
+int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry)
 {
-	struct ecryptfs_crypt_stat *crypt_stat;
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
 	char *page_virt;
-	size_t size;
+	size_t size = 0;
 	int rc = 0;
 
-	crypt_stat = &ecryptfs_inode_to_private(
-		ecryptfs_dentry->d_inode)->crypt_stat;
 	if (likely(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
 		if (!(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
-			ecryptfs_printk(KERN_DEBUG, "Key is "
-					"invalid; bailing out\n");
+			printk(KERN_ERR "Key is invalid; bailing out\n");
 			rc = -EINVAL;
 			goto out;
 		}
@@ -1552,7 +1552,8 @@ int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
 						      crypt_stat, page_virt,
 						      size);
 	else
-		rc = ecryptfs_write_metadata_to_contents(crypt_stat, lower_file,
+		rc = ecryptfs_write_metadata_to_contents(crypt_stat,
+							 ecryptfs_dentry,
 							 page_virt);
 	if (rc) {
 		printk(KERN_ERR "Error writing metadata out to lower file; "
@@ -1680,15 +1681,17 @@ out:
  *
  * Returns zero on success; non-zero on error
  */
-int ecryptfs_read_xattr_region(char *page_virt, struct dentry *ecryptfs_dentry)
+int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode)
 {
+	struct dentry *lower_dentry =
+		ecryptfs_inode_to_private(ecryptfs_inode)->lower_file->f_dentry;
 	ssize_t size;
 	int rc = 0;
 
-	size = ecryptfs_getxattr(ecryptfs_dentry, ECRYPTFS_XATTR_NAME,
-				 page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
+	size = ecryptfs_getxattr_lower(lower_dentry, ECRYPTFS_XATTR_NAME,
+				       page_virt, ECRYPTFS_DEFAULT_EXTENT_SIZE);
 	if (size < 0) {
-		printk(KERN_DEBUG "Error attempting to read the [%s] "
+		printk(KERN_ERR "Error attempting to read the [%s] "
 		       "xattr from the lower file; return value = [%zd]\n",
 		       ECRYPTFS_XATTR_NAME, size);
 		rc = -EINVAL;
@@ -1703,7 +1706,7 @@ int ecryptfs_read_and_validate_xattr_region(char *page_virt,
 {
 	int rc;
 
-	rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_dentry);
+	rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_dentry->d_inode);
 	if (rc)
 		goto out;
 	if (!contains_ecryptfs_marker(page_virt	+ ECRYPTFS_FILE_SIZE_BYTES)) {
@@ -1717,8 +1720,6 @@ out:
 
 /**
  * ecryptfs_read_metadata
- * @ecryptfs_dentry: The eCryptfs dentry
- * @lower_file: The lower file from which to read the metadata
  *
  * Common entry point for reading file metadata. From here, we could
  * retrieve the header information from the header region of the file,
@@ -1729,15 +1730,13 @@ out:
  *
  * Returns zero if valid headers found and parsed; non-zero otherwise
  */
-int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
-			   struct file *lower_file)
+int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry)
 {
 	int rc = 0;
 	char *page_virt = NULL;
-	mm_segment_t oldfs;
-	ssize_t bytes_read;
+	struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
 	struct ecryptfs_crypt_stat *crypt_stat =
-	    &ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
+	    &ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
 	struct ecryptfs_mount_crypt_stat *mount_crypt_stat =
 		&ecryptfs_superblock_to_private(
 			ecryptfs_dentry->d_sb)->mount_crypt_stat;
@@ -1748,27 +1747,18 @@ int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
 	page_virt = kmem_cache_alloc(ecryptfs_header_cache_1, GFP_USER);
 	if (!page_virt) {
 		rc = -ENOMEM;
-		ecryptfs_printk(KERN_ERR, "Unable to allocate page_virt\n");
+		printk(KERN_ERR "%s: Unable to allocate page_virt\n",
+		       __FUNCTION__);
 		goto out;
 	}
-	lower_file->f_pos = 0;
-	oldfs = get_fs();
-	set_fs(get_ds());
-	bytes_read = lower_file->f_op->read(lower_file,
-					    (char __user *)page_virt,
-					    ECRYPTFS_DEFAULT_EXTENT_SIZE,
-					    &lower_file->f_pos);
-	set_fs(oldfs);
-	if (bytes_read != ECRYPTFS_DEFAULT_EXTENT_SIZE) {
-		rc = -EINVAL;
-		goto out;
-	}
-	rc = ecryptfs_read_headers_virt(page_virt, crypt_stat,
-					ecryptfs_dentry,
-					ECRYPTFS_VALIDATE_HEADER_SIZE);
+	rc = ecryptfs_read_lower(page_virt, 0, crypt_stat->extent_size,
+				 ecryptfs_inode);
+	if (!rc)
+		rc = ecryptfs_read_headers_virt(page_virt, crypt_stat,
+						ecryptfs_dentry,
+						ECRYPTFS_VALIDATE_HEADER_SIZE);
 	if (rc) {
-		rc = ecryptfs_read_xattr_region(page_virt,
-						ecryptfs_dentry);
+		rc = ecryptfs_read_xattr_region(page_virt, ecryptfs_inode);
 		if (rc) {
 			printk(KERN_DEBUG "Valid eCryptfs headers not found in "
 			       "file header region or xattr region\n");
diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 65f7ddf..3e52b42 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -570,13 +570,11 @@ int ecryptfs_writepage_and_release_lower_page(struct page *lower_page,
 					      struct writeback_control *wbc);
 int ecryptfs_encrypt_page(struct page *page);
 int ecryptfs_decrypt_page(struct page *page);
-int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry,
-			    struct file *lower_file);
-int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry,
-			   struct file *lower_file);
+int ecryptfs_write_metadata(struct dentry *ecryptfs_dentry);
+int ecryptfs_read_metadata(struct dentry *ecryptfs_dentry);
 int ecryptfs_new_file_context(struct dentry *ecryptfs_dentry);
-int ecryptfs_read_and_validate_header_region(char *data, struct dentry *dentry,
-					     struct vfsmount *mnt);
+int ecryptfs_read_and_validate_header_region(char *data,
+					     struct inode *ecryptfs_inode);
 int ecryptfs_read_and_validate_xattr_region(char *page_virt,
 					    struct dentry *ecryptfs_dentry);
 u16 ecryptfs_code_for_cipher_string(struct ecryptfs_crypt_stat *crypt_stat);
@@ -599,10 +597,13 @@ int ecryptfs_open_lower_file(struct file **lower_file,
 int ecryptfs_close_lower_file(struct file *lower_file);
 ssize_t ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 			  size_t size);
+ssize_t
+ecryptfs_getxattr_lower(struct dentry *lower_dentry, const char *name,
+			void *value, size_t size);
 int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
-int ecryptfs_read_xattr_region(char *page_virt, struct dentry *ecryptfs_dentry);
+int ecryptfs_read_xattr_region(char *page_virt, struct inode *ecryptfs_inode);
 int ecryptfs_process_helo(unsigned int transport, uid_t uid, pid_t pid);
 int ecryptfs_process_quit(uid_t uid, pid_t pid);
 int ecryptfs_process_response(struct ecryptfs_message *msg, uid_t uid,
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 59c846d..df70bfa 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -248,7 +248,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	mutex_lock(&crypt_stat->cs_mutex);
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
 	    || !(crypt_stat->flags & ECRYPTFS_KEY_VALID)) {
-		rc = ecryptfs_read_metadata(ecryptfs_dentry, lower_file);
+		rc = ecryptfs_read_metadata(ecryptfs_dentry);
 		if (rc) {
 			ecryptfs_printk(KERN_DEBUG,
 					"Valid headers not found\n");
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index c746b5d..a29dc31 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -153,37 +153,30 @@ out:
 
 /**
  * grow_file
- * @ecryptfs_dentry: the ecryptfs dentry
- * @lower_file: The lower file
- * @inode: The ecryptfs inode
- * @lower_inode: The lower inode
+ * @ecryptfs_dentry: the eCryptfs dentry
  *
  * This is the code which will grow the file to its correct size.
  */
-static int grow_file(struct dentry *ecryptfs_dentry, struct file *lower_file,
-		     struct inode *inode, struct inode *lower_inode)
+static int grow_file(struct dentry *ecryptfs_dentry)
 {
-	int rc = 0;
+	struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
 	struct file fake_file;
 	struct ecryptfs_file_info tmp_file_info;
+	char zero_virt[] = { 0x00 };
+	int rc = 0;
 
 	memset(&fake_file, 0, sizeof(fake_file));
 	fake_file.f_path.dentry = ecryptfs_dentry;
 	memset(&tmp_file_info, 0, sizeof(tmp_file_info));
 	ecryptfs_set_file_private(&fake_file, &tmp_file_info);
-	ecryptfs_set_file_lower(&fake_file, lower_file);
-	rc = ecryptfs_fill_zeros(&fake_file, 1);
-	if (rc) {
-		ecryptfs_inode_to_private(inode)->crypt_stat.flags |=
-			ECRYPTFS_SECURITY_WARNING;
-		ecryptfs_printk(KERN_WARNING, "Error attempting to fill zeros "
-				"in file; rc = [%d]\n", rc);
-		goto out;
-	}
-	i_size_write(inode, 0);
-	rc = ecryptfs_write_inode_size_to_metadata(inode);
-	ecryptfs_inode_to_private(inode)->crypt_stat.flags |= ECRYPTFS_NEW_FILE;
-out:
+	ecryptfs_set_file_lower(
+		&fake_file,
+		ecryptfs_inode_to_private(ecryptfs_inode)->lower_file);
+	rc = ecryptfs_write(&fake_file, zero_virt, 0, 1);
+	i_size_write(ecryptfs_inode, 0);
+	rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
+	ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat.flags |=
+		ECRYPTFS_NEW_FILE;
 	return rc;
 }
 
@@ -197,53 +190,31 @@ out:
  */
 static int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry)
 {
+	struct ecryptfs_crypt_stat *crypt_stat =
+		&ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->crypt_stat;
 	int rc = 0;
-	int lower_flags;
-	struct ecryptfs_crypt_stat *crypt_stat;
-	struct dentry *lower_dentry;
-	struct file *lower_file;
-	struct inode *inode, *lower_inode;
-	struct vfsmount *lower_mnt;
 
-	lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
-	ecryptfs_printk(KERN_DEBUG, "lower_dentry->d_name.name = [%s]\n",
-			lower_dentry->d_name.name);
-	inode = ecryptfs_dentry->d_inode;
-	crypt_stat = &ecryptfs_inode_to_private(inode)->crypt_stat;
-	lower_flags = ((O_CREAT | O_TRUNC) & O_ACCMODE) | O_RDWR;
-	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
-	/* Corresponding fput() at end of this function */
-	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-				      lower_flags);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR,
-				"Error opening dentry; rc = [%i]\n", rc);
-		goto out;
-	}
-	lower_inode = lower_dentry->d_inode;
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-		goto out_fput;
+		goto out;
 	}
 	crypt_stat->flags |= ECRYPTFS_NEW_FILE;
 	ecryptfs_printk(KERN_DEBUG, "Initializing crypto context\n");
 	rc = ecryptfs_new_file_context(ecryptfs_dentry);
 	if (rc) {
-		ecryptfs_printk(KERN_DEBUG, "Error creating new file "
-				"context\n");
-		goto out_fput;
+		ecryptfs_printk(KERN_ERR, "Error creating new file "
+				"context; rc = [%d]\n", rc);
+		goto out;
 	}
-	rc = ecryptfs_write_metadata(ecryptfs_dentry, lower_file);
+	rc = ecryptfs_write_metadata(ecryptfs_dentry);
 	if (rc) {
-		ecryptfs_printk(KERN_DEBUG, "Error writing headers\n");
-		goto out_fput;
+		printk(KERN_ERR "Error writing headers; rc = [%d]\n", rc);
+		goto out;
 	}
-	rc = grow_file(ecryptfs_dentry, lower_file, inode, lower_inode);
-out_fput:
-	rc = ecryptfs_close_lower_file(lower_file);
+	rc = grow_file(ecryptfs_dentry);
 	if (rc)
-		printk(KERN_ERR "Error closing lower_file\n");
+		printk(KERN_ERR "Error growing file; rc = [%d]\n", rc);
 out:
 	return rc;
 }
@@ -389,8 +360,8 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
 		ecryptfs_set_default_sizes(crypt_stat);
-	rc = ecryptfs_read_and_validate_header_region(page_virt, lower_dentry,
-						      nd->mnt);
+	rc = ecryptfs_read_and_validate_header_region(page_virt,
+						      dentry->d_inode);
 	if (rc) {
 		rc = ecryptfs_read_and_validate_xattr_region(page_virt, dentry);
 		if (rc) {
@@ -941,7 +912,7 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 		}
 		mount_crypt_stat = &ecryptfs_superblock_to_private(
 			dentry->d_sb)->mount_crypt_stat;
-		rc = ecryptfs_read_metadata(dentry, lower_file);
+		rc = ecryptfs_read_metadata(dentry);
 		if (rc) {
 			if (!(mount_crypt_stat->flags
 			      & ECRYPTFS_PLAINTEXT_PASSTHROUGH_ENABLED)) {
@@ -1003,6 +974,24 @@ out:
 }
 
 ssize_t
+ecryptfs_getxattr_lower(struct dentry *lower_dentry, const char *name,
+			void *value, size_t size)
+{
+	int rc = 0;
+
+	if (!lower_dentry->d_inode->i_op->getxattr) {
+		rc = -ENOSYS;
+		goto out;
+	}
+	mutex_lock(&lower_dentry->d_inode->i_mutex);
+	rc = lower_dentry->d_inode->i_op->getxattr(lower_dentry, name, value,
+						   size);
+	mutex_unlock(&lower_dentry->d_inode->i_mutex);
+out:
+	return rc;
+}
+
+ssize_t
 ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 		  size_t size)
 {
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 9b62110..60e635e 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -307,7 +307,7 @@ static int ecryptfs_readpage(struct file *file, struct page *page)
 				memset(page_virt, 0, PAGE_CACHE_SIZE);
 				if (page->index == 0) {
 					rc = ecryptfs_read_xattr_region(
-						page_virt, file->f_path.dentry);
+						page_virt, page->mapping->host);
 					set_header_info(page_virt, crypt_stat);
 				}
 				kunmap_atomic(page_virt, KM_USER0);
-- 
1.5.1.6

