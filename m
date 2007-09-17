Return-Path: <linux-kernel-owner+w=401wt.eu-S932879AbXIQVyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932879AbXIQVyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932426AbXIQVyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:54:16 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:55928 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932896AbXIQVyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:54:12 -0400
Date: Mon, 17 Sep 2007 16:49:33 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH 7/11] eCryptfs: Make open, truncate, and setattr use persistent file
Message-ID: <20070917214933.GO13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917214436.GH13679@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than open a new lower file for every eCryptfs file that is
opened, truncated, or setattr'd, instead use the existing lower
persistent file for the eCryptfs inode. Change truncate to use
read_write.c functions. Change ecryptfs_getxattr() to use the common
ecryptfs_getxattr_lower() function.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |    2 +-
 fs/ecryptfs/file.c   |   50 ++++------------------
 fs/ecryptfs/inode.c  |  113 +++++++++++++++-----------------------------------
 3 files changed, 44 insertions(+), 121 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 6b4d310..b3014d7 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1674,7 +1674,7 @@ out:
 /**
  * ecryptfs_read_xattr_region
  * @page_virt: The vitual address into which to read the xattr data
- * @ecryptfs_dentry: The eCryptfs dentry
+ * @ecryptfs_inode: The eCryptfs inode
  *
  * Attempts to read the crypto metadata from the extended attribute
  * region of the lower file.
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index df70bfa..95be9a9 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -187,11 +187,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	/* Private value of ecryptfs_dentry allocated in
 	 * ecryptfs_lookup() */
 	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
-	struct inode *lower_inode = NULL;
-	struct file *lower_file = NULL;
-	struct vfsmount *lower_mnt;
 	struct ecryptfs_file_info *file_info;
-	int lower_flags;
 
 	mount_crypt_stat = &ecryptfs_superblock_to_private(
 		ecryptfs_dentry->d_sb)->mount_crypt_stat;
@@ -219,26 +215,12 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)) {
 		ecryptfs_printk(KERN_DEBUG, "Setting flags for stat...\n");
 		/* Policy code enabled in future release */
-		crypt_stat->flags |= ECRYPTFS_POLICY_APPLIED;
-		crypt_stat->flags |= ECRYPTFS_ENCRYPTED;
+		crypt_stat->flags |= (ECRYPTFS_POLICY_APPLIED
+				      | ECRYPTFS_ENCRYPTED);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
-	lower_flags = file->f_flags;
-	if ((lower_flags & O_ACCMODE) == O_WRONLY)
-		lower_flags = (lower_flags & O_ACCMODE) | O_RDWR;
-	if (file->f_flags & O_APPEND)
-		lower_flags &= ~O_APPEND;
-	lower_mnt = ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
-	/* Corresponding fput() in ecryptfs_release() */
-	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-				      lower_flags);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR, "Error opening lower file\n");
-		goto out_puts;
-	}
-	ecryptfs_set_file_lower(file, lower_file);
-	/* Isn't this check the same as the one in lookup? */
-	lower_inode = lower_dentry->d_inode;
+	ecryptfs_set_file_lower(
+		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "This is a directory\n");
 		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
@@ -260,7 +242,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 				       "and plaintext passthrough mode is not "
 				       "enabled; returning -EIO\n");
 				mutex_unlock(&crypt_stat->cs_mutex);
-				goto out_puts;
+				goto out_free;
 			}
 			rc = 0;
 			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
@@ -272,11 +254,8 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 	ecryptfs_printk(KERN_DEBUG, "inode w/ addr = [0x%p], i_ino = [0x%.16x] "
 			"size: [0x%.16x]\n", inode, inode->i_ino,
 			i_size_read(inode));
-	ecryptfs_set_file_lower(file, lower_file);
 	goto out;
-out_puts:
-	mntput(lower_mnt);
-	dput(lower_dentry);
+out_free:
 	kmem_cache_free(ecryptfs_file_info_cache,
 			ecryptfs_file_to_private(file));
 out:
@@ -296,20 +275,9 @@ static int ecryptfs_flush(struct file *file, fl_owner_t td)
 
 static int ecryptfs_release(struct inode *inode, struct file *file)
 {
-	struct file *lower_file = ecryptfs_file_to_lower(file);
-	struct ecryptfs_file_info *file_info = ecryptfs_file_to_private(file);
-	struct inode *lower_inode = ecryptfs_inode_to_lower(inode);
-	int rc;
-
-	rc = ecryptfs_close_lower_file(lower_file);
-	if (rc) {
-		printk(KERN_ERR "Error closing lower_file\n");
-		goto out;
-	}
-	inode->i_blocks = lower_inode->i_blocks;
-	kmem_cache_free(ecryptfs_file_info_cache, file_info);
-out:
-	return rc;
+	kmem_cache_free(ecryptfs_file_info_cache,
+			ecryptfs_file_to_private(file));
+	return 0;
 }
 
 static int
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index a29dc31..5701f81 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -739,8 +739,7 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 	int rc = 0;
 	struct inode *inode = dentry->d_inode;
 	struct dentry *lower_dentry;
-	struct vfsmount *lower_mnt;
-	struct file fake_ecryptfs_file, *lower_file = NULL;
+	struct file fake_ecryptfs_file;
 	struct ecryptfs_crypt_stat *crypt_stat;
 	loff_t i_size = i_size_read(inode);
 	loff_t lower_size_before_truncate;
@@ -763,51 +762,43 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 		goto out;
 	}
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	/* This dget & mntget is released through fput at out_fput: */
-	lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-	rc = ecryptfs_open_lower_file(&lower_file, lower_dentry, lower_mnt,
-				      O_RDWR);
-	if (rc) {
-		ecryptfs_printk(KERN_ERR,
-				"Error opening dentry; rc = [%i]\n", rc);
-		goto out_free;
-	}
-	ecryptfs_set_file_lower(&fake_ecryptfs_file, lower_file);
+	ecryptfs_set_file_lower(
+		&fake_ecryptfs_file,
+		ecryptfs_inode_to_private(dentry->d_inode)->lower_file);
 	/* Switch on growing or shrinking file */
 	if (new_length > i_size) {
-		rc = ecryptfs_fill_zeros(&fake_ecryptfs_file, new_length);
-		if (rc) {
-			ecryptfs_printk(KERN_ERR,
-					"Problem with fill_zeros\n");
-			goto out_fput;
-		}
-		i_size_write(inode, new_length);
-		rc = ecryptfs_write_inode_size_to_metadata(inode);
-		if (rc) {
-			printk(KERN_ERR	"Problem with "
-			       "ecryptfs_write_inode_size_to_metadata; "
-			       "rc = [%d]\n", rc);
-			goto out_fput;
-		}
+		char zero[] = { 0x00 };
+
+		/* Write a single 0 at the last position of the file;
+		 * this triggers code that will fill in 0's throughout
+		 * the intermediate portion of the previous end of the
+		 * file and the new and of the file */
+		rc = ecryptfs_write(&fake_ecryptfs_file, zero,
+				    (new_length - 1), 1);
 	} else { /* new_length < i_size_read(inode) */
-		pgoff_t index = 0;
-		int end_pos_in_page = -1;
-
-		if (new_length != 0) {
-			index = ((new_length - 1) >> PAGE_CACHE_SHIFT);
-			end_pos_in_page = ((new_length - 1) & ~PAGE_CACHE_MASK);
-		}
-		if (end_pos_in_page != (PAGE_CACHE_SIZE - 1)) {
-			rc = ecryptfs_write_zeros(&fake_ecryptfs_file,
-						  index,
-						  (end_pos_in_page + 1),
-						  ((PAGE_CACHE_SIZE - 1)
-						   - end_pos_in_page));
+		/* We're chopping off all the pages down do the page
+		 * in which new_length is located. Fill in the end of
+		 * that page from (new_length & ~PAGE_CACHE_MASK) to
+		 * PAGE_CACHE_SIZE with zeros. */
+		size_t num_zeros = (PAGE_CACHE_SIZE
+				    - (new_length & ~PAGE_CACHE_MASK));
+
+		if (num_zeros) {
+			char *zeros_virt;
+
+			zeros_virt = kzalloc(num_zeros, GFP_KERNEL);
+			if (!zeros_virt) {
+				rc = -ENOMEM;
+				goto out_free;
+			}
+			rc = ecryptfs_write(&fake_ecryptfs_file, zeros_virt,
+					    new_length, num_zeros);
+			kfree(zeros_virt);
 			if (rc) {
 				printk(KERN_ERR "Error attempting to zero out "
 				       "the remainder of the end page on "
 				       "reducing truncate; rc = [%d]\n", rc);
-				goto out_fput;
+				goto out_free;
 			}
 		}
 		vmtruncate(inode, new_length);
@@ -816,7 +807,7 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 			printk(KERN_ERR	"Problem with "
 			       "ecryptfs_write_inode_size_to_metadata; "
 			       "rc = [%d]\n", rc);
-			goto out_fput;
+			goto out_free;
 		}
 		/* We are reducing the size of the ecryptfs file, and need to
 		 * know if we need to reduce the size of the lower file. */
@@ -828,14 +819,6 @@ int ecryptfs_truncate(struct dentry *dentry, loff_t new_length)
 			vmtruncate(lower_dentry->d_inode,
 				   lower_size_after_truncate);
 	}
-	/* Update the access times */
-	lower_dentry->d_inode->i_mtime = lower_dentry->d_inode->i_ctime
-		= CURRENT_TIME;
-	mark_inode_dirty_sync(inode);
-out_fput:
-	rc = ecryptfs_close_lower_file(lower_file);
-	if (rc)
-		printk(KERN_ERR "Error closing lower_file\n");
 out_free:
 	if (ecryptfs_file_to_private(&fake_ecryptfs_file))
 		kmem_cache_free(ecryptfs_file_info_cache,
@@ -895,21 +878,8 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 	else if (S_ISREG(dentry->d_inode->i_mode)
 		 && (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED)
 		     || !(crypt_stat->flags & ECRYPTFS_KEY_VALID))) {
-		struct vfsmount *lower_mnt;
-		struct file *lower_file = NULL;
 		struct ecryptfs_mount_crypt_stat *mount_crypt_stat;
-		int lower_flags;
 
-		lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
-		lower_flags = O_RDONLY;
-		rc = ecryptfs_open_lower_file(&lower_file, lower_dentry,
-					      lower_mnt, lower_flags);
-		if (rc) {
-			printk(KERN_ERR
-			       "Error opening lower file; rc = [%d]\n", rc);
-			mutex_unlock(&crypt_stat->cs_mutex);
-			goto out;
-		}
 		mount_crypt_stat = &ecryptfs_superblock_to_private(
 			dentry->d_sb)->mount_crypt_stat;
 		rc = ecryptfs_read_metadata(dentry);
@@ -923,16 +893,13 @@ static int ecryptfs_setattr(struct dentry *dentry, struct iattr *ia)
 				       "enabled; returning -EIO\n");
 
 				mutex_unlock(&crypt_stat->cs_mutex);
-				fput(lower_file);
 				goto out;
 			}
 			rc = 0;
 			crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
 			mutex_unlock(&crypt_stat->cs_mutex);
-			fput(lower_file);
 			goto out;
 		}
-		fput(lower_file);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
 	if (ia->ia_valid & ATTR_SIZE) {
@@ -995,20 +962,8 @@ ssize_t
 ecryptfs_getxattr(struct dentry *dentry, const char *name, void *value,
 		  size_t size)
 {
-	int rc = 0;
-	struct dentry *lower_dentry;
-
-	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (!lower_dentry->d_inode->i_op->getxattr) {
-		rc = -ENOSYS;
-		goto out;
-	}
-	mutex_lock(&lower_dentry->d_inode->i_mutex);
-	rc = lower_dentry->d_inode->i_op->getxattr(lower_dentry, name, value,
-						   size);
-	mutex_unlock(&lower_dentry->d_inode->i_mutex);
-out:
-	return rc;
+	return ecryptfs_getxattr_lower(ecryptfs_dentry_to_lower(dentry), name,
+				       value, size);
 }
 
 static ssize_t
-- 
1.5.1.6

