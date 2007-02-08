Return-Path: <linux-kernel-owner+w=401wt.eu-S1422852AbXBHAif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422852AbXBHAif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 19:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965710AbXBHAiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 19:38:01 -0500
Received: from mail.suse.de ([195.135.220.2]:56409 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422936AbXBHAc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 19:32:26 -0500
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Oliver Neukum <oliver@neukum.org>, Oliver Neukum <oliver@neukum.name>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/28] Driver core: fix race in sysfs between sysfs_remove_file() and read()/write()
Date: Wed,  7 Feb 2007 16:30:05 -0800
Message-Id: <11708946762594-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.4.4.4
In-Reply-To: <11708946734097-git-send-email-greg@kroah.com>
References: <20070208002908.GA4796@kroah.com> <11708946163722-git-send-email-greg@kroah.com> <1170894620889-git-send-email-greg@kroah.com> <11708946251265-git-send-email-greg@kroah.com> <11708946283719-git-send-email-greg@kroah.com> <11708946362677-git-send-email-greg@kroah.com> <11708946391465-git-send-email-greg@kroah.com> <11708946432920-git-send-email-greg@kroah.com> <11708946472324-git-send-email-greg@kroah.com> <1170894650872-git-send-email-greg@kroah.com> <11708946533931-git-send-email-greg@kroah.com> <11708946561557-git-send-email-greg@kroah.com> <11708946601643-git-send-email-greg@kroah.com> <1170894664547-git-send-email-greg@kroah.com> <11708946672133-git-send-email-greg@kroah.com> <1170894670676-git-send-email-greg@kroah.com> <11708946734097-git-send-email-greg@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oliver@neukum.org>

This patch prevents a race between IO and removing a file from sysfs.
It introduces a list of sysfs_buffers associated with a file at the inode.
Upon removal of a file the list is walked and the buffers marked orphaned.
IO to orphaned buffers fails with -ENODEV. The driver can safely free
associated data structures or be unloaded.

Signed-off-by: Oliver Neukum <oliver@neukum.name>
Acked-by: Maneesh Soni <maneesh@in.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/bin.c     |    1 +
 fs/sysfs/dir.c     |    1 +
 fs/sysfs/file.c    |   67 ++++++++++++++++++++++++++++++++++++++-------------
 fs/sysfs/group.c   |    1 +
 fs/sysfs/inode.c   |   24 ++++++++++++++++++
 fs/sysfs/mount.c   |    9 +++++++
 fs/sysfs/symlink.c |    1 +
 fs/sysfs/sysfs.h   |   16 ++++++++++++
 8 files changed, 103 insertions(+), 17 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index e8f540d..9ec1c85 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 
 #include <asm/uaccess.h>
+#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2bab1b4..9ff0449 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
+#include <asm/semaphore.h>
 #include "sysfs.h"
 
 DECLARE_RWSEM(sysfs_rename_sem);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 9cfe53e..cba4c1c 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -7,6 +7,7 @@
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
+#include <linux/list.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 
@@ -50,17 +51,29 @@ static struct sysfs_ops subsys_sysfs_ops = {
 	.store	= subsys_attr_store,
 };
 
+/**
+ *	add_to_collection - add buffer to a collection
+ *	@buffer:	buffer to be added
+ *	@node		inode of set to add to
+ */
 
-struct sysfs_buffer {
-	size_t			count;
-	loff_t			pos;
-	char			* page;
-	struct sysfs_ops	* ops;
-	struct semaphore	sem;
-	int			needs_read_fill;
-	int			event;
-};
+static inline void
+add_to_collection(struct sysfs_buffer *buffer, struct inode *node)
+{
+	struct sysfs_buffer_collection *set = node->i_private;
 
+	mutex_lock(&node->i_mutex);
+	list_add(&buffer->associates, &set->associates);
+	mutex_unlock(&node->i_mutex);
+}
+
+static inline void
+remove_from_collection(struct sysfs_buffer *buffer, struct inode *node)
+{
+	mutex_lock(&node->i_mutex);
+	list_del(&buffer->associates);
+	mutex_unlock(&node->i_mutex);
+}
 
 /**
  *	fill_read_buffer - allocate and fill buffer from object.
@@ -153,6 +166,10 @@ sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	ssize_t retval = 0;
 
 	down(&buffer->sem);
+	if (buffer->orphaned) {
+		retval = -ENODEV;
+		goto out;
+	}
 	if (buffer->needs_read_fill) {
 		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
 			goto out;
@@ -165,7 +182,6 @@ out:
 	return retval;
 }
 
-
 /**
  *	fill_write_buffer - copy buffer from userspace.
  *	@buffer:	data buffer for file.
@@ -243,19 +259,25 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
 	ssize_t len;
 
 	down(&buffer->sem);
+	if (buffer->orphaned) {
+		len = -ENODEV;
+		goto out;
+	}
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
 		len = flush_write_buffer(file->f_path.dentry, buffer, len);
 	if (len > 0)
 		*ppos += len;
+out:
 	up(&buffer->sem);
 	return len;
 }
 
-static int check_perm(struct inode * inode, struct file * file)
+static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
 	struct attribute * attr = to_attr(file->f_path.dentry);
+	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error = 0;
@@ -285,6 +307,18 @@ static int check_perm(struct inode * inode, struct file * file)
 	if (!ops)
 		goto Eaccess;
 
+	/* make sure we have a collection to add our buffers to */
+	mutex_lock(&inode->i_mutex);
+	if (!(set = inode->i_private)) {
+		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
+			error = -ENOMEM;
+			goto Done;
+		} else {
+			INIT_LIST_HEAD(&set->associates);
+		}
+	}
+	mutex_unlock(&inode->i_mutex);
+
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
 	 * and we must have a store method.
@@ -310,9 +344,11 @@ static int check_perm(struct inode * inode, struct file * file)
 	 */
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
 	if (buffer) {
+		INIT_LIST_HEAD(&buffer->associates);
 		init_MUTEX(&buffer->sem);
 		buffer->needs_read_fill = 1;
 		buffer->ops = ops;
+		add_to_collection(buffer, inode);
 		file->private_data = buffer;
 	} else
 		error = -ENOMEM;
@@ -330,11 +366,6 @@ static int check_perm(struct inode * inode, struct file * file)
 	return error;
 }
 
-static int sysfs_open_file(struct inode * inode, struct file * filp)
-{
-	return check_perm(inode,filp);
-}
-
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
 	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
@@ -342,6 +373,8 @@ static int sysfs_release(struct inode * inode, struct file * filp)
 	struct module * owner = attr->owner;
 	struct sysfs_buffer * buffer = filp->private_data;
 
+	if (buffer)
+		remove_from_collection(buffer, inode);
 	if (kobj) 
 		kobject_put(kobj);
 	/* After this point, attr should not be accessed. */
@@ -548,7 +581,7 @@ EXPORT_SYMBOL_GPL(sysfs_chmod_file);
 
 void sysfs_remove_file(struct kobject * kobj, const struct attribute * attr)
 {
-	sysfs_hash_and_remove(kobj->dentry,attr->name);
+	sysfs_hash_and_remove(kobj->dentry, attr->name);
 }
 
 
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 122145b..46a277b 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -13,6 +13,7 @@
 #include <linux/dcache.h>
 #include <linux/namei.h>
 #include <linux/err.h>
+#include <asm/semaphore.h>
 #include "sysfs.h"
 
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e79e38d..1a81ebc 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -13,6 +13,7 @@
 #include <linux/backing-dev.h>
 #include <linux/capability.h>
 #include <linux/errno.h>
+#include <asm/semaphore.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
@@ -209,6 +210,22 @@ const unsigned char * sysfs_get_name(struct sysfs_dirent *sd)
 	return NULL;
 }
 
+static inline void orphan_all_buffers(struct inode *node)
+{
+	struct sysfs_buffer_collection *set = node->i_private;
+	struct sysfs_buffer *buf;
+
+	mutex_lock(&node->i_mutex);
+	if (node->i_private) {
+		list_for_each_entry(buf, &set->associates, associates) {
+			down(&buf->sem);
+			buf->orphaned = 1;
+			up(&buf->sem);
+		}
+	}
+	mutex_unlock(&node->i_mutex);
+}
+
 
 /*
  * Unhashes the dentry corresponding to given sysfs_dirent
@@ -217,16 +234,23 @@ const unsigned char * sysfs_get_name(struct sysfs_dirent *sd)
 void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
 {
 	struct dentry * dentry = sd->s_dentry;
+	struct inode *inode;
 
 	if (dentry) {
 		spin_lock(&dcache_lock);
 		spin_lock(&dentry->d_lock);
 		if (!(d_unhashed(dentry) && dentry->d_inode)) {
+			inode = dentry->d_inode;
+			spin_lock(&inode->i_lock);
+			__iget(inode);
+			spin_unlock(&inode->i_lock);
 			dget_locked(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
 			simple_unlink(parent->d_inode, dentry);
+			orphan_all_buffers(inode);
+			iput(inode);
 		} else {
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&dcache_lock);
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index e503f85..a1a58b9 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -8,6 +8,7 @@
 #include <linux/mount.h>
 #include <linux/pagemap.h>
 #include <linux/init.h>
+#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
@@ -18,9 +19,12 @@ struct vfsmount *sysfs_mount;
 struct super_block * sysfs_sb = NULL;
 struct kmem_cache *sysfs_dir_cachep;
 
+static void sysfs_clear_inode(struct inode *inode);
+
 static struct super_operations sysfs_ops = {
 	.statfs		= simple_statfs,
 	.drop_inode	= generic_delete_inode,
+	.clear_inode	= sysfs_clear_inode,
 };
 
 static struct sysfs_dirent sysfs_root = {
@@ -31,6 +35,11 @@ static struct sysfs_dirent sysfs_root = {
 	.s_iattr	= NULL,
 };
 
+static void sysfs_clear_inode(struct inode *inode)
+{
+	kfree(inode->i_private);
+}
+
 static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct inode *inode;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index f50e3cc..4869f61 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
+#include <asm/semaphore.h>
 
 #include "sysfs.h"
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index bd7cec2..39c623f 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -33,6 +33,22 @@ struct sysfs_symlink {
 	struct kobject * target_kobj;
 };
 
+struct sysfs_buffer {
+	struct list_head		associates;
+	size_t				count;
+	loff_t				pos;
+	char				* page;
+	struct sysfs_ops		* ops;
+	struct semaphore		sem;
+	int				orphaned;
+	int				needs_read_fill;
+	int				event;
+};
+
+struct sysfs_buffer_collection {
+	struct list_head	associates;
+};
+
 static inline struct kobject * to_kobj(struct dentry * dentry)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
-- 
1.4.4.4

