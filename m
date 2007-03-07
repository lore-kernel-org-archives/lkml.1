Return-Path: <linux-kernel-owner+w=401wt.eu-S1030650AbXCGOjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030650AbXCGOjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030659AbXCGOjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:39:01 -0500
Received: from mo-p07-ob.rzone.de ([81.169.146.189]:29017 "EHLO
	mo-p07-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030650AbXCGOi7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:38:59 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.21-rc suspend regression: sysfs deadlock
Date: Wed, 7 Mar 2007 15:38:49 +0100
User-Agent: KMail/1.9.1
Cc: Hugh Dickins <hugh@veritas.com>, Maneesh Soni <maneesh@in.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Adrian Bunk <bunk@stusta.de>,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0703061914030.18144@blonde.wat.veritas.com> <Pine.LNX.4.64.0703061735350.5963@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703061735350.5963@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703071538.50441.oliver@neukum.org>
X-RZG-AUTH: kN+qSWxTQH+Xqix8Cni7tCsVYhPCm1GPE5pUNaoG1wTinqjVVl1GKJZKNFH/11jSg2To
X-RZG-CLASS-ID: mo07
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. März 2007 02:56 schrieb Linus Torvalds:
> Anyway, I'm unable to revert the broken commit, since there are now other 
> changes that depend on it, but can somebody *please* do that? I'll apply 
> Hugh's silly patch in the meantime, just to avoid the lockup.

As you like it. This patch reverts it.

	Regards
		Oliver

Signed-off-by: Oliver Neukum <oliver@neukum.name>
-----

--- orig/fs/sysfs/inode.c	2007-03-07 10:49:42.000000000 +0100
+++ linux-2.6.21-rc3/fs/sysfs/inode.c	2007-03-07 10:52:56.000000000 +0100
@@ -220,20 +220,6 @@
 	return NULL;
 }
 
-static inline void orphan_all_buffers(struct inode *node)
-{
-	struct sysfs_buffer_collection *set = node->i_private;
-	struct sysfs_buffer *buf;
-
-	mutex_lock_nested(&node->i_mutex, I_MUTEX_CHILD);
-	if (node->i_private) {
-		list_for_each_entry(buf, &set->associates, associates)
-			buf->orphaned = 1;
-	}
-	mutex_unlock(&node->i_mutex);
-}
-
-
 /*
  * Unhashes the dentry corresponding to given sysfs_dirent
  * Called with parent inode's i_mutex held.
@@ -241,23 +227,16 @@
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
--- orig/fs/sysfs/file.c	2007-03-07 10:37:28.000000000 +0100
+++ linux-2.6.21-rc3/fs/sysfs/file.c	2007-03-07 10:54:00.000000000 +0100
@@ -7,7 +7,6 @@
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
-#include <linux/list.h>
 #include <asm/uaccess.h>
 #include <asm/semaphore.h>
 
@@ -52,30 +51,6 @@
 };
 
 /**
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
-
-/**
  *	fill_read_buffer - allocate and fill buffer from object.
  *	@dentry:	dentry pointer.
  *	@buffer:	data buffer for file.
@@ -168,10 +143,6 @@
 	ssize_t retval = 0;
 
 	down(&buffer->sem);
-	if (buffer->orphaned) {
-		retval = -ENODEV;
-		goto out;
-	}
 	if (buffer->needs_read_fill) {
 		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
 			goto out;
@@ -261,16 +232,11 @@
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
@@ -279,7 +245,6 @@
 {
 	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
 	struct attribute * attr = to_attr(file->f_path.dentry);
-	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error = 0;
@@ -309,18 +274,6 @@
 	if (!ops)
 		goto Eaccess;
 
-	/* make sure we have a collection to add our buffers to */
-	mutex_lock(&inode->i_mutex);
-	if (!(set = inode->i_private)) {
-		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
-			error = -ENOMEM;
-			goto Done;
-		} else {
-			INIT_LIST_HEAD(&set->associates);
-		}
-	}
-	mutex_unlock(&inode->i_mutex);
-
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
 	 * and we must have a store method.
@@ -346,11 +299,9 @@
 	 */
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
 	if (buffer) {
-		INIT_LIST_HEAD(&buffer->associates);
 		init_MUTEX(&buffer->sem);
 		buffer->needs_read_fill = 1;
 		buffer->ops = ops;
-		add_to_collection(buffer, inode);
 		file->private_data = buffer;
 	} else
 		error = -ENOMEM;
@@ -375,8 +326,6 @@
 	struct module * owner = attr->owner;
 	struct sysfs_buffer * buffer = filp->private_data;
 
-	if (buffer)
-		remove_from_collection(buffer, inode);
 	kobject_put(kobj);
 	/* After this point, attr should not be accessed. */
 	module_put(owner);
--- orig/fs/sysfs/mount.c	2007-03-07 10:37:50.000000000 +0100
+++ linux-2.6.21-rc3/fs/sysfs/mount.c	2007-03-07 10:38:14.000000000 +0100
@@ -19,12 +19,9 @@
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
@@ -35,11 +32,6 @@
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
--- orig/fs/sysfs/sysfs.h	2007-03-07 10:38:44.000000000 +0100
+++ linux-2.6.21-rc3/fs/sysfs/sysfs.h	2007-03-07 10:39:26.000000000 +0100
@@ -46,21 +46,15 @@
 };
 
 struct sysfs_buffer {
-	struct list_head		associates;
 	size_t				count;
 	loff_t				pos;
 	char				* page;
 	struct sysfs_ops		* ops;
 	struct semaphore		sem;
-	int				orphaned;
 	int				needs_read_fill;
 	int				event;
 };
 
-struct sysfs_buffer_collection {
-	struct list_head	associates;
-};
-
 static inline struct kobject * to_kobj(struct dentry * dentry)
 {
 	struct sysfs_dirent * sd = dentry->d_fsdata;
