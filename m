Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYGQSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYGQSRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYGQSRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 14:17:40 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41721 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036AbYGQSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 14:17:39 -0400
Date: Thu, 17 Jul 2008 13:16:50 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       "David J. Kleikamp" <shaggy@us.ibm.com>
Subject: [PATCH] eCryptfs: Make all persistent file opens delayed
Message-ID: <20080717181650.GB6773@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no good reason to immediately open the lower file, and that
can cause problems with files that the user does not intend to
immediately open, such as device nodes.

This patch removes the persistent file open from the interpose step
and pushes that to the locations where eCryptfs really does need the
lower persistent file, such as just before reading or writing the
metadata stored in the lower file header.

Two functions are jumping to out_dput when they should just be jumping
to out on error paths. This patch also fixes these.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |    2 --
 fs/ecryptfs/file.c            |    4 ----
 fs/ecryptfs/inode.c           |   27 +++++++++++++++++++++++----
 fs/ecryptfs/main.c            |   16 ----------------
 4 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index b0727f9..b73fb75 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -235,7 +235,6 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_METADATA_IN_XATTR  0x00000100
 #define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
 #define ECRYPTFS_KEY_SET            0x00000400
-#define ECRYPTFS_DELAY_PERSISTENT   0x00000800
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -576,7 +575,6 @@ struct ecryptfs_open_req {
 };
 
 #define ECRYPTFS_INTERPOSE_FLAG_D_ADD                 0x00000001
-#define ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE 0x00000002
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
 		       u32 flags);
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 2c2d60d..9244d65 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -200,10 +200,6 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 		goto out;
 	}
 	if (!ecryptfs_inode_to_private(inode)->lower_file) {
-		BUG_ON(!(crypt_stat->flags & ECRYPTFS_DELAY_PERSISTENT));
-		mutex_lock(&crypt_stat->cs_mutex);
-		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
-		mutex_unlock(&crypt_stat->cs_mutex);
 		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
 		if (rc) {
 			printk(KERN_ERR "%s: Error attempting to initialize "
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 4ec8161..0326ba3 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -188,6 +188,16 @@ static int ecryptfs_initialize_file(struct dentry *ecryptfs_dentry)
 				"context; rc = [%d]\n", rc);
 		goto out;
 	}
+	if (!ecryptfs_inode_to_private(ecryptfs_dentry->d_inode)->lower_file) {
+		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       ecryptfs_dentry->d_name.name, rc);
+			goto out;
+		}
+	}
 	rc = ecryptfs_write_metadata(ecryptfs_dentry);
 	if (rc) {
 		printk(KERN_ERR "Error writing headers; rc = [%d]\n", rc);
@@ -311,7 +321,7 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 				ECRYPTFS_INTERPOSE_FLAG_D_ADD);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error interposing\n");
-		goto out_dput;
+		goto out;
 	}
 	if (S_ISDIR(lower_inode->i_mode)) {
 		ecryptfs_printk(KERN_DEBUG, "Is a directory; returning\n");
@@ -337,11 +347,21 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 		rc = -ENOMEM;
 		ecryptfs_printk(KERN_ERR,
 				"Cannot ecryptfs_kmalloc a page\n");
-		goto out_dput;
+		goto out;
 	}
 	crypt_stat = &ecryptfs_inode_to_private(dentry->d_inode)->crypt_stat;
 	if (!(crypt_stat->flags & ECRYPTFS_POLICY_APPLIED))
 		ecryptfs_set_default_sizes(crypt_stat);
+	if (!ecryptfs_inode_to_private(dentry->d_inode)->lower_file) {
+		rc = ecryptfs_init_persistent_file(dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       dentry->d_name.name, rc);
+			goto out;
+		}
+	}
 	rc = ecryptfs_read_and_validate_header_region(page_virt,
 						      dentry->d_inode);
 	if (rc) {
@@ -538,8 +558,7 @@ ecryptfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, mode, dev);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
-	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb,
-				ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE);
+	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
 	if (rc)
 		goto out;
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 32d9b59..155caa2 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -201,22 +201,6 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
-	if (!(flags & ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE)) {
-		rc = ecryptfs_init_persistent_file(dentry);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to initialize "
-			       "the persistent file for the dentry with name "
-			       "[%s]; rc = [%d]\n", __func__,
-			       dentry->d_name.name, rc);
-			goto out;
-		}
-	} else {
-		struct ecryptfs_inode_info *inode_info =
-			ecryptfs_inode_to_private(dentry->d_inode);
-
-		inode_info->lower_file = NULL;
-		inode_info->crypt_stat.flags |= ECRYPTFS_DELAY_PERSISTENT;
-	}
 out:
 	return rc;
 }
-- 
1.5.3.6

