Return-Path: <linux-kernel-owner+w=401wt.eu-S936087AbXGKXto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936087AbXGKXto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935178AbXGKXfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:35:33 -0400
Received: from ns.suse.de ([195.135.220.2]:33916 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934983AbXGKXf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:35:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/61] sysfs: kill attribute file orphaning
Date: Wed, 11 Jul 2007 16:31:55 -0700
Message-Id: <1184196905515-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968992181-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
 <11841967493890-git-send-email-gregkh@suse.de>
 <1184196753488-git-send-email-gregkh@suse.de>
 <1184196759393-git-send-email-gregkh@suse.de>
 <11841967633087-git-send-email-gregkh@suse.de>
 <11841967674155-git-send-email-gregkh@suse.de>
 <11841967711788-git-send-email-gregkh@suse.de>
 <11841967793134-git-send-email-gregkh@suse.de>
 <1184196783245-git-send-email-gregkh@suse.de>
 <1184196787247-git-send-email-gregkh@suse.de>
 <11841967992975-git-send-email-gregkh@suse.de>
 <11841968032469-git-send-email-gregkh@suse.de>
 <11841968071826-git-send-email-gregkh@suse.de>
 <11841968111201-git-send-email-gregkh@suse.de>
 <11841968151257-git-send-email-gregkh@suse.de>
 <1184196818497-git-send-email-gregkh@suse.de>
 <11841968231043-git-send-email-gregkh@suse.de>
 <11841968271925-git-send-email-gregkh@suse.de>
 <11841968303508-git-send-email-gregkh@suse.de>
 <11841968352439-git-send-email-gregkh@suse.de>
 <11841968392043-git-send-email-gregkh@suse.de>
 <11841968431153-git-send-email-gregkh@suse.de>
 <11841968471598-git-send-email-gregkh@suse.de>
 <11841968512510-git-send-email-gregkh@suse.de>
 <1184196856662-git-send-email-gregkh@suse.de>
 <1184196860992-git-send-email-gregkh@suse.de>
 <11841968643630-git-send-email-gregkh@suse.de>
 <11841968683554-git-send-email-gregkh@suse.de>
 <11841968731843-git-send-email-gregkh@suse.de>
 <11841968773426-git-send-email-gregkh@suse.de>
 <118419688284-git-send-email-gregkh@suse.de>
 <11841968872456-git-send-email-gregkh@suse.de>
 <11841968903726-git-send-email-gregkh@suse.de>
 <11841968951572-git-send-email-gregkh@suse.de>
 <11841968992181-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Now that sysfs_dirent can be disconnected from kobject on deletion,
there is no need to orphan each attribute files.  All [bin_]attribute
nodes are automatically orphaned when the parent node is deleted.
Kill attribute file orphaning.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/file.c  |   65 ++++++++++-------------------------------------------
 fs/sysfs/inode.c |   25 --------------------
 fs/sysfs/mount.c |    8 ------
 fs/sysfs/sysfs.h |   16 -------------
 4 files changed, 13 insertions(+), 101 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 310430b..d673d9b 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -50,29 +50,15 @@ static struct sysfs_ops subsys_sysfs_ops = {
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
@@ -144,10 +130,7 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
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
@@ -246,16 +229,11 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
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
@@ -265,7 +243,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct kobject *kobj = attr_sd->s_parent->s_elem.dir.kobj;
-	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
@@ -289,26 +266,14 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
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
@@ -335,11 +300,9 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	if (!buffer)
 		goto err_mput;
 
-	INIT_LIST_HEAD(&buffer->associates);
 	init_MUTEX(&buffer->sem);
 	buffer->needs_read_fill = 1;
 	buffer->ops = ops;
-	add_to_collection(buffer, inode);
 	file->private_data = buffer;
 
 	/* open succeeded, put active references and pin attr_sd */
@@ -358,10 +321,8 @@ static int sysfs_release(struct inode * inode, struct file * filp)
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
index 7b9a8f1..d9ccc83 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -191,24 +191,6 @@ int sysfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *))
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
@@ -216,7 +198,6 @@ static inline void orphan_all_buffers(struct inode *node)
 void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 {
 	struct dentry *dentry = NULL;
-	struct inode *inode;
 
 	/* We're not holding a reference to ->s_dentry dentry but the
 	 * field will stay valid as long as sysfs_lock is held.
@@ -236,17 +217,11 @@ void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!d_unhashed(dentry) && dentry->d_inode) {
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
index 8f6d8b1..37ff9ff 100644
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
 	.s_ino		= 1,
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
index d998e8e..8b09e9d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -88,22 +88,6 @@ extern const struct file_operations bin_fops;
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
1.5.2.2

