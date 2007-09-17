Return-Path: <linux-kernel-owner+w=401wt.eu-S1760259AbXIQVwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760259AbXIQVwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:52:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759916AbXIQVwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:52:34 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34793 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757964AbXIQVwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:52:33 -0400
Date: Mon, 17 Sep 2007 16:47:54 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net
Subject: [PATCH 5/11] eCryptfs: Set up and destroy persistent lower file
Message-ID: <20070917214754.GM13679@halcrow.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20070917214436.GH13679@halcrow.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917214436.GH13679@halcrow.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets up and destroys the persistent lower file for each
eCryptfs inode.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/inode.c |   23 +++++++++++++++---
 fs/ecryptfs/main.c  |   65 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ecryptfs/super.c |   22 +++++++++++++++--
 3 files changed, 103 insertions(+), 7 deletions(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 7192a81..c746b5d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -119,10 +119,23 @@ ecryptfs_do_create(struct inode *directory_inode,
 	}
 	rc = ecryptfs_create_underlying_file(lower_dir_dentry->d_inode,
 					     ecryptfs_dentry, mode, nd);
-	if (unlikely(rc)) {
-		ecryptfs_printk(KERN_ERR,
-				"Failure to create underlying file\n");
-		goto out_lock;
+	if (rc) {
+		struct inode *ecryptfs_inode = ecryptfs_dentry->d_inode;
+		struct ecryptfs_inode_info *inode_info =
+			ecryptfs_inode_to_private(ecryptfs_inode);
+
+		printk(KERN_WARNING "%s: Error creating underlying file; "
+		       "rc = [%d]; checking for existing\n", __FUNCTION__, rc);
+		if (inode_info) {
+			mutex_lock(&inode_info->lower_file_mutex);
+			if (!inode_info->lower_file) {
+				mutex_unlock(&inode_info->lower_file_mutex);
+				printk(KERN_ERR "%s: Failure to set underlying "
+				       "file; rc = [%d]\n", __FUNCTION__, rc);
+				goto out_lock;
+			}
+			mutex_unlock(&inode_info->lower_file_mutex);
+		}
 	}
 	rc = ecryptfs_interpose(lower_dentry, ecryptfs_dentry,
 				directory_inode->i_sb, 0);
@@ -252,6 +265,8 @@ ecryptfs_create(struct inode *directory_inode, struct dentry *ecryptfs_dentry,
 {
 	int rc;
 
+	/* ecryptfs_do_create() calls ecryptfs_interpose(), which opens
+	 * the crypt_stat->lower_file (persistent file) */
 	rc = ecryptfs_do_create(directory_inode, ecryptfs_dentry, mode, nd);
 	if (unlikely(rc)) {
 		ecryptfs_printk(KERN_WARNING, "Failed to create file in"
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 967bad0..3e324f8 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -98,6 +98,64 @@ void __ecryptfs_printk(const char *fmt, ...)
 }
 
 /**
+ * ecryptfs_init_persistent_file
+ * @ecryptfs_dentry: Fully initialized eCryptfs dentry object, with
+ *                   the lower dentry and the lower mount set
+ *
+ * eCryptfs only ever keeps a single open file for every lower
+ * inode. All I/O operations to the lower inode occur through that
+ * file. When the first eCryptfs dentry that interposes with the first
+ * lower dentry for that inode is created, this function creates the
+ * persistent file struct and associates it with the eCryptfs
+ * inode. When the eCryptfs inode is destroyed, the file is closed.
+ *
+ * The persistent file will be opened with read/write permissions, if
+ * possible. Otherwise, it is opened read-only.
+ *
+ * This function does nothing if a lower persistent file is already
+ * associated with the eCryptfs inode.
+ *
+ * Returns zero on success; non-zero otherwise
+ */
+int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
+{
+	struct ecryptfs_inode_info *inode_info =
+		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
+	int rc = 0;
+
+	mutex_lock(&inode_info->lower_file_mutex);
+	if (!inode_info->lower_file) {
+		struct dentry *lower_dentry;
+		struct vfsmount *lower_mnt =
+			ecryptfs_dentry_to_lower_mnt(ecryptfs_dentry);
+
+		lower_dentry = ecryptfs_dentry_to_lower(ecryptfs_dentry);
+		/* Corresponding dput() and mntput() are done when the
+		 * persistent file is fput() when the eCryptfs inode
+		 * is destroyed. */
+		dget(lower_dentry);
+		mntget(lower_mnt);
+		inode_info->lower_file = dentry_open(lower_dentry,
+						     lower_mnt,
+						     (O_RDWR | O_LARGEFILE));
+		if (IS_ERR(inode_info->lower_file))
+			inode_info->lower_file = dentry_open(lower_dentry,
+							     lower_mnt,
+							     (O_RDONLY
+							      | O_LARGEFILE));
+		if (IS_ERR(inode_info->lower_file)) {
+			printk(KERN_ERR "Error opening lower persistent file "
+			       "for lower_dentry [0x%p] and lower_mnt [0x%p]\n",
+			       lower_dentry, lower_mnt);
+			rc = PTR_ERR(inode_info->lower_file);
+			inode_info->lower_file = NULL;
+		}
+	}
+	mutex_unlock(&inode_info->lower_file_mutex);
+	return rc;
+}
+
+/**
  * ecryptfs_interpose
  * @lower_dentry: Existing dentry in the lower filesystem
  * @dentry: ecryptfs' dentry
@@ -154,6 +212,13 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
+	rc = ecryptfs_init_persistent_file(dentry);
+	if (rc) {
+		printk(KERN_ERR "%s: Error attempting to initialize the "
+		       "persistent file for the dentry with name [%s]; "
+		       "rc = [%d]\n", __FUNCTION__, dentry->d_name.name, rc);
+		goto out;
+	}
 out:
 	return rc;
 }
diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
index 18d77f8..b97e210 100644
--- a/fs/ecryptfs/super.c
+++ b/fs/ecryptfs/super.c
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/key.h>
 #include <linux/seq_file.h>
+#include <linux/file.h>
 #include <linux/crypto.h>
 #include "ecryptfs_kernel.h"
 
@@ -63,9 +64,10 @@ out:
  * ecryptfs_destroy_inode
  * @inode: The ecryptfs inode
  *
- * This is used during the final destruction of the inode.
- * All allocation of memory related to the inode, including allocated
- * memory in the crypt_stat struct, will be released here.
+ * This is used during the final destruction of the inode.  All
+ * allocation of memory related to the inode, including allocated
+ * memory in the crypt_stat struct, will be released here. This
+ * function also fput()'s the persistent file for the lower inode.
  * There should be no chance that this deallocation will be missed.
  */
 static void ecryptfs_destroy_inode(struct inode *inode)
@@ -73,6 +75,20 @@ static void ecryptfs_destroy_inode(struct inode *inode)
 	struct ecryptfs_inode_info *inode_info;
 
 	inode_info = ecryptfs_inode_to_private(inode);
+	mutex_lock(&inode_info->lower_file_mutex);
+	if (inode_info->lower_file) {
+		struct dentry *lower_dentry =
+			inode_info->lower_file->f_dentry;
+
+		BUG_ON(!lower_dentry);
+		if (lower_dentry->d_inode) {
+			fput(inode_info->lower_file);
+			inode_info->lower_file = NULL;
+			d_drop(lower_dentry);
+			d_delete(lower_dentry);
+		}
+	}
+	mutex_unlock(&inode_info->lower_file_mutex);
 	ecryptfs_destroy_crypt_stat(&inode_info->crypt_stat);
 	kmem_cache_free(ecryptfs_inode_info_cache, inode_info);
 }
-- 
1.5.1.6

