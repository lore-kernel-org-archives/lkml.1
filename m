Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXD1OON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXD1OON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 10:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXD1OON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 10:14:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:62704 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbXD1OOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 10:14:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=TWt+lkNV/hnZpY3DbECPWCEfRcjcKTGhroxlLdICM10JSIVJ26eHOlv/iGtg+cD651BNxxay5Sn71lFz+HN4Xlw4HZZxHsxA2Pd1EegUShRXP6eROsDR8Y+AQYVnLtxLH6cJw90hbftwzsy7u6a7NXlKQc16wUvmA5+D1yGTuhI=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 18/21] sysfs: kill attribute file orphaning
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:42 +0900
Message-Id: <11777675821862-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Now that sysfs_dirent can be disconnected from kobject on deletion,
there is no need to orphan each attribute files.  All [bin_]attribute
nodes are automatically orphaned when the parent node is deleted.
Kill attribute file orphaning.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/file.c  |   65 ++++++++++-------------------------------------------
 fs/sysfs/inode.c |   25 --------------------
 fs/sysfs/mount.c |    8 ------
 fs/sysfs/sysfs.h |   16 -------------
 4 files changed, 13 insertions(+), 101 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index df0e0c0..a34c2fa 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -51,29 +51,15 @@ static struct sysfs_ops subsys_sysfs_ops = {
 	.store	= subsys_attr_store,
 };
 
-/**
- *	add_to_collection - add buffer to a collection
- *	@buffer:	buffer to be added
- *	@node:		inode of set to add to
- */
-
-static inline void
-add_to_collection(struct sysfs_buffer *buffer, struct inode *node)
-{
-	struct sysfs_buffer_collection *set = node->i_private;
-
-	mutex_lock(&node->i_mutex);
-	list_add(&buffer->associates, &set->associates);
-	mutex_unlock(&node->i_mutex);
-}
-
-static inline void
-remove_from_collection(struct sysfs_buffer *buffer, struct inode *node)
-{
-	mutex_lock(&node->i_mutex);
-	list_del(&buffer->associates);
-	mutex_unlock(&node->i_mutex);
-}
+struct sysfs_buffer {
+	size_t			count;
+	loff_t			pos;
+	char			* page;
+	struct sysfs_ops	* ops;
+	struct semaphore	sem;
+	int			needs_read_fill;
+	int			event;
+};
 
 /**
  *	fill_read_buffer - allocate and fill buffer from object.
@@ -175,10 +161,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 	down(&buffer->sem);
 	if (buffer->needs_read_fill) {
-		if (buffer->orphaned)
-			retval = -ENODEV;
-		else
-			retval = fill_read_buffer(file->f_path.dentry,buffer);
+		retval = fill_read_buffer(file->f_path.dentry,buffer);
 		if (retval)
 			goto out;
 	}
@@ -276,16 +259,11 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 	ssize_t len;
 
 	down(&buffer->sem);
-	if (buffer->orphaned) {
-		len = -ENODEV;
-		goto out;
-	}
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
 		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
-out:
 	up(&buffer->sem);
 	return len;
 }
@@ -295,7 +273,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
-	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
@@ -319,26 +296,14 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	else
 		ops = &subsys_sysfs_ops;
 
+	error = -EACCES;
+
 	/* No sysfs operations, either from having no subsystem,
 	 * or the subsystem have no operations.
 	 */
-	error = -EACCES;
 	if (!ops)
 		goto err_mput;
 
-	/* make sure we have a collection to add our buffers to */
-	mutex_lock(&inode->i_mutex);
-	if (!(set = inode->i_private)) {
-		error = -ENOMEM;
-		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL)))
-			goto err_mput;
-		else
-			INIT_LIST_HEAD(&set->associates);
-	}
-	mutex_unlock(&inode->i_mutex);
-
-	error = -EACCES;
-
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
 	 * and we must have a store method.
@@ -365,11 +330,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (!buffer)
 		goto err_mput;
 
-	INIT_LIST_HEAD(&buffer->associates);
 	init_MUTEX(&buffer->sem);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
-	add_to_collection(buffer, inode);
 	file->private_data = buffer;
 
 	/* open succeeded, put active references and pin attr_sd */
@@ -388,10 +351,8 @@ static int sysfs_release(struct inode * inode, struct file * filp)
 {
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
-	struct sysfs_buffer * buffer = filp->private_data;
+	struct sysfs_buffer *buffer = filp->private_data;
 
-	if (buffer)
-		remove_from_collection(buffer, inode);
 	sysfs_put(attr_sd);
 	/* After this point, attr should not be accessed. */
 	module_put(attr->owner);
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index a222064..b72d18a 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -190,24 +190,6 @@ int sysfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *))
 	return error;
 }
 
-static inline void orphan_all_buffers(struct inode *node)
-{
-	struct sysfs_buffer_collection *set;
-	struct sysfs_buffer *buf;
-
-	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
-	set = node->i_private;
-	if (set) {
-		list_for_each_entry(buf, &set->associates, associates) {
-			down(&buf->sem);
-			buf->orphaned = 1;
-			up(&buf->sem);
-		}
-	}
-	mutex_unlock(&node->i_mutex);
-}
-
-
 /*
  * Unhashes the dentry corresponding to given sysfs_dirent
  * Called with parent inode's i_mutex held.
@@ -215,23 +197,16 @@ static inline void orphan_all_buffers(struct inode *node)
 void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 {
 	struct dentry * dentry = sd->s_dentry;
-	struct inode *inode;
 
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
-			inode = dentry->d_inode;
-			spin_lock(&inode->i_lock);
-			__iget(inode);
-			spin_unlock(&inode->i_lock);
 			dget_locked(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			simple_unlink(parent->d_inode, dentry);
-			orphan_all_buffers(inode);
-			iput(inode);
 		} else {
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index b31256a..d1a37e8 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -19,12 +19,9 @@ struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
-static void sysfs_clear_inode(struct inode *inode);
-
 static const struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= sysfs_delete_inode,
-	.clear_inode	= sysfs_clear_inode,
 };
 
 static struct sysfs_dirent sysfs_root = {
@@ -36,11 +33,6 @@ static struct sysfs_dirent sysfs_root = {
 	.s_iattr	= NULL,
 };
 
-static void sysfs_clear_inode(struct inode *inode)
-{
-	kfree(inode->i_private);
-}
-
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 47d5c5a..537c64b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -87,22 +87,6 @@ extern const struct file_operations bin_fops;
 extern const struct inode_operations sysfs_dir_inode_operations;
 extern const struct inode_operations sysfs_symlink_inode_operations;
 
-struct sysfs_buffer {
-	struct list_head		associates;
-	size_t				count;
-	loff_t				pos;
-	char				* page;
-	struct sysfs_ops		* ops;
-	struct semaphore		sem;
-	int				orphaned;
-	int				needs_read_fill;
-	int				event;
-};
-
-struct sysfs_buffer_collection {
-	struct list_head	associates;
-};
-
 static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 {
 	if (sd) {
-- 
1.5.0.3


