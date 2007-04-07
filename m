Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXDGI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXDGI23 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965540AbXDGIYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:24:45 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:60690 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965544AbXDGIX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=dzrjH4a5QtwP6gjbvEh/Pfq9GF/VvBnn/kWDEV7ymWe9GMpToLTW/jguBILXfm3G9/gm36oHiljljj9TB7ONN6ABhAqoMWKJioqL0ZeIBGNjWFy3I/oRCXVN30wAT55Y+KjyrfUsX4Z328A5BApgZNfLR+PBKKuWHbQZZPQaNjk=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 13/14] sysfs: kill attribute file orphaning
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:48 +0900
Message-Id: <1175934228125-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       cornelia.huck@de.ibm.com, oneukum@suse.de, rpurdie@rpsys.net,
       James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       htejun@gmail.com
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
index 133a108..cd80b20 100644
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
@@ -294,7 +272,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
-	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	struct kobject *kobj;
@@ -322,26 +299,14 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
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
@@ -368,11 +333,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (!buffer)
 		goto err_mput;
 
-	INIT_LIST_HEAD(&buffer->associates);
 	init_MUTEX(&buffer->sem);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
-	add_to_collection(buffer, inode);
 	file->private_data = buffer;
 
 	/* open succeeded, put kobj and pin attr_sd */
@@ -391,10 +354,8 @@ static int sysfs_release(struct inode * inode, struct file * filp)
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
index 2581bfa..e4eb116 100644
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
index 0defb3a..09edcad 100644
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
@@ -35,11 +32,6 @@ static struct sysfs_dirent sysfs_root = {
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
index b56186f..6802576 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -72,22 +72,6 @@ extern const struct file_operations bin_fops;
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


