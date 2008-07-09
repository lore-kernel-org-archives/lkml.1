Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYGIWTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYGIWTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751879AbYGIWSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:18:51 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38561 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbYGIWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:18:50 -0400
Date: Wed, 9 Jul 2008 17:21:48 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] eCryptfs: Do not try to open device files on mknod
Message-ID: <20080709222148.GB6773@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When creating device nodes, eCryptfs needs to delay actually opening
the lower persistent file until an application tries to open. Device
handles may not be backed by anything when they first come into
existence.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |    6 +++++-
 fs/ecryptfs/file.c            |   14 ++++++++++++++
 fs/ecryptfs/inode.c           |    6 ++++--
 fs/ecryptfs/main.c            |   29 +++++++++++++++++++----------
 4 files changed, 42 insertions(+), 13 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index c15c257..023f19d 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -235,6 +235,7 @@ struct ecryptfs_crypt_stat {
 #define ECRYPTFS_METADATA_IN_XATTR  0x00000100
 #define ECRYPTFS_VIEW_AS_ENCRYPTED  0x00000200
 #define ECRYPTFS_KEY_SET            0x00000400
+#define ECRYPTFS_DELAY_PERSISTENT   0x00000800
 	u32 flags;
 	unsigned int file_version;
 	size_t iv_bytes;
@@ -560,9 +561,11 @@ extern struct kmem_cache *ecryptfs_key_sig_cache;
 extern struct kmem_cache *ecryptfs_global_auth_tok_cache;
 extern struct kmem_cache *ecryptfs_key_tfm_cache;
 
+#define ECRYPTFS_INTERPOSE_FLAG_D_ADD                 0x00000001
+#define ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE 0x00000002
 int ecryptfs_interpose(struct dentry *hidden_dentry,
 		       struct dentry *this_dentry, struct super_block *sb,
-		       int flag);
+		       u32 flags);
 int ecryptfs_fill_zeros(struct file *file, loff_t new_length);
 int ecryptfs_decode_filename(struct ecryptfs_crypt_stat *crypt_stat,
 			     const char *name, int length,
@@ -690,5 +693,6 @@ void ecryptfs_msg_ctx_alloc_to_free(struct ecryptfs_msg_ctx *msg_ctx);
 int
 ecryptfs_spawn_daemon(struct ecryptfs_daemon **daemon, uid_t euid,
 		      struct user_namespace *user_ns, struct pid *pid);
+int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry);
 
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index 2258b8f..1148876 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -191,6 +191,20 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 				      | ECRYPTFS_ENCRYPTED);
 	}
 	mutex_unlock(&crypt_stat->cs_mutex);
+	if (!ecryptfs_inode_to_private(inode)->lower_file) {
+		BUG_ON(!(crypt_stat->flags & ECRYPTFS_DELAY_PERSISTENT));
+		mutex_lock(&crypt_stat->cs_mutex);
+		crypt_stat->flags &= ~(ECRYPTFS_ENCRYPTED);
+		mutex_unlock(&crypt_stat->cs_mutex);
+		rc = ecryptfs_init_persistent_file(ecryptfs_dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       ecryptfs_dentry->d_name.name, rc);
+			goto out;
+		}
+	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
 	if (S_ISDIR(ecryptfs_dentry->d_inode->i_mode)) {
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index c92cc1c..56cf5d5 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -307,7 +307,8 @@ static struct dentry *ecryptfs_lookup(struct inode *dir, struct dentry *dentry,
 		d_add(dentry, NULL);
 		goto out;
 	}
-	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 1);
+	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb,
+				ECRYPTFS_INTERPOSE_FLAG_D_ADD);
 	if (rc) {
 		ecryptfs_printk(KERN_ERR, "Error interposing\n");
 		goto out_dput;
@@ -537,7 +538,8 @@ ecryptfs_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 	rc = vfs_mknod(lower_dir_dentry->d_inode, lower_dentry, mode, dev);
 	if (rc || !lower_dentry->d_inode)
 		goto out;
-	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb, 0);
+	rc = ecryptfs_interpose(lower_dentry, dentry, dir->i_sb,
+				ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE);
 	if (rc)
 		goto out;
 	fsstack_copy_attr_times(dir, lower_dir_dentry->d_inode);
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index d603631..e47d04d 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -117,7 +117,7 @@ void __ecryptfs_printk(const char *fmt, ...)
  *
  * Returns zero on success; non-zero otherwise
  */
-static int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
+int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
 {
 	struct ecryptfs_inode_info *inode_info =
 		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
@@ -163,14 +163,14 @@ static int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
  * @lower_dentry: Existing dentry in the lower filesystem
  * @dentry: ecryptfs' dentry
  * @sb: ecryptfs's super_block
- * @flag: If set to true, then d_add is called, else d_instantiate is called
+ * @flags: flags to govern behavior of interpose procedure
  *
  * Interposes upper and lower dentries.
  *
  * Returns zero on success; non-zero otherwise
  */
 int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
-		       struct super_block *sb, int flag)
+		       struct super_block *sb, u32 flags)
 {
 	struct inode *lower_inode;
 	struct inode *inode;
@@ -207,7 +207,7 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 		init_special_inode(inode, lower_inode->i_mode,
 				   lower_inode->i_rdev);
 	dentry->d_op = &ecryptfs_dops;
-	if (flag)
+	if (flags & ECRYPTFS_INTERPOSE_FLAG_D_ADD)
 		d_add(dentry, inode);
 	else
 		d_instantiate(dentry, inode);
@@ -215,12 +215,21 @@ int ecryptfs_interpose(struct dentry *lower_dentry, struct dentry *dentry,
 	/* This size will be overwritten for real files w/ headers and
 	 * other metadata */
 	fsstack_copy_inode_size(inode, lower_inode);
-	rc = ecryptfs_init_persistent_file(dentry);
-	if (rc) {
-		printk(KERN_ERR "%s: Error attempting to initialize the "
-		       "persistent file for the dentry with name [%s]; "
-		       "rc = [%d]\n", __func__, dentry->d_name.name, rc);
-		goto out;
+	if (!(flags & ECRYPTFS_INTERPOSE_FLAG_DELAY_PERSISTENT_FILE)) {
+		rc = ecryptfs_init_persistent_file(dentry);
+		if (rc) {
+			printk(KERN_ERR "%s: Error attempting to initialize "
+			       "the persistent file for the dentry with name "
+			       "[%s]; rc = [%d]\n", __func__,
+			       dentry->d_name.name, rc);
+			goto out;
+		}
+	} else {
+		struct ecryptfs_inode_info *inode_info =
+			ecryptfs_inode_to_private(dentry->d_inode);
+
+		inode_info->lower_file = NULL;
+		inode_info->crypt_stat.flags |= ECRYPTFS_DELAY_PERSISTENT;
 	}
 out:
 	return rc;
-- 
1.5.3.6

