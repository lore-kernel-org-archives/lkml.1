Return-Path: <linux-kernel-owner+w=401wt.eu-S1761665AbXITIQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761665AbXITIQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756714AbXITIGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:37 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33572 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758571AbXITIGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:06:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=fNZ7gSPxFwCCgEyblZtImpHUNUkxuQc5De7eaFQF8kmjbmd6Kj+UNxi2PC5ggrHTFDk3c+t0Tg/MqqKqk5PJMgAsI3RTrMxOPiJUbAQbCl4aefKlN1nPboOVMYlY12+pItsHkao0fPO5l7owS0TvLoTdhwb3DnrCBnuLMYqr8jo=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 11/22] sysfs: implement sysfs_dirent based file interface
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <11902755401257-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_add_file() creates a text sysfs file which is equivalent to
attribute file of the original API.  Each sysfs file has its own ops
containing show and store, and can have arbitrary private data.  Both
show and store methods are given two private data arguments - one for
its own, the other for its parent's.  This is primarily to support the
original kobject based API where private data was only available for
directory nodes but can be used for other purposes too.  As with
sysfs_add_dir(), SYSFS_COPY_NAME flag can also be used.

sysfs_notify_file() is equivalent to sysfs_notify() of the original
API and can be called only on file dirents.

sysfs_chmod() is extended version of sysfs_chmod_file().  It lives in
fs/sysfs/dir.c and can be called on any type of node.

The new interface makes sysfs files very straight forward compared to
the original overly and uglily objectified API.  A sysfs file lives
under a sysfs directory, has two opertaions - show and store which
take buffer and its own and parent's private data.  No hidden method
selection or enforcing the same methods for all attributes under a
directory; thus, no extra wrapping or forced de-multiplexing in
show/store methods is necessary.

Kobject based interface works by setting parent_data to kobj and data
to attr.  All kobject-based file related API functions are
reimplemented using the above functions in fs/sysfs/kobject.c.

This patch doesn't introduce any behavior change to the original API
except that sysfs_pos is now determined on each read/write operation
instead of on each open.  This shouldn't cause any noticeable
difference.

This patch increase the size of sysfs_dirent by one pointer.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |   47 +++++++
 fs/sysfs/file.c       |  335 +++++++++++++++++--------------------------------
 fs/sysfs/kobject.c    |  192 ++++++++++++++++++++++++++++
 fs/sysfs/sysfs.h      |    3 +-
 include/linux/sysfs.h |   28 ++++
 5 files changed, 385 insertions(+), 220 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 170749d..f4a6f2f 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1130,3 +1130,50 @@ const struct file_operations sysfs_dir_operations = {
 	.read		= generic_read_dir,
 	.readdir	= sysfs_readdir,
 };
+
+/**
+ *	sysfs_chmod - chmod a sysfs_dirent
+ *	@sd: sysfs_dirent to chmod
+ *	@mode: target mode
+ *
+ *	chmod @sd to @mode.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
+int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode)
+{
+	struct dentry *dentry;
+	struct inode *inode;
+	struct iattr newattrs;
+	int rc;
+
+	mutex_lock(&sysfs_rename_mutex);
+	dentry = sysfs_get_dentry(sd);
+	mutex_unlock(&sysfs_rename_mutex);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	inode = dentry->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+
+	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
+	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+	rc = notify_change(dentry, &newattrs);
+
+	if (rc == 0) {
+		mutex_lock(&sysfs_mutex);
+		sd->s_mode = newattrs.ia_mode;
+		mutex_unlock(&sysfs_mutex);
+	}
+
+	mutex_unlock(&inode->i_mutex);
+
+	dput(dentry);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sysfs_chmod);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index ae4d7cb..4c0e29f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -3,8 +3,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/kobject.h>
-#include <linux/namei.h>
 #include <linux/poll.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
@@ -12,43 +10,6 @@
 
 #include "sysfs.h"
 
-#define to_sattr(a) container_of(a,struct subsys_attribute, attr)
-
-/*
- * Subsystem file operations.
- * These operations allow subsystems to have files that can be 
- * read/written. 
- */
-static ssize_t 
-subsys_attr_show(struct kobject * kobj, struct attribute * attr, char * page)
-{
-	struct kset *kset = to_kset(kobj);
-	struct subsys_attribute * sattr = to_sattr(attr);
-	ssize_t ret = -EIO;
-
-	if (sattr->show)
-		ret = sattr->show(kset, page);
-	return ret;
-}
-
-static ssize_t 
-subsys_attr_store(struct kobject * kobj, struct attribute * attr, 
-		  const char * page, size_t count)
-{
-	struct kset *kset = to_kset(kobj);
-	struct subsys_attribute * sattr = to_sattr(attr);
-	ssize_t ret = -EIO;
-
-	if (sattr->store)
-		ret = sattr->store(kset, page, count);
-	return ret;
-}
-
-static struct sysfs_ops subsys_sysfs_ops = {
-	.show	= subsys_attr_show,
-	.store	= subsys_attr_store,
-};
-
 /*
  * There's one sysfs_buffer for each open file and one
  * sysfs_open_dirent for each sysfs_dirent with one or more open
@@ -70,8 +31,7 @@ struct sysfs_open_dirent {
 struct sysfs_buffer {
 	size_t			count;
 	loff_t			pos;
-	char			* page;
-	struct sysfs_ops	* ops;
+	char			*page;
 	struct mutex		mutex;
 	int			needs_read_fill;
 	int			event;
@@ -136,47 +96,44 @@ void sysfs_file_check_suicide(struct sysfs_dirent *sd)
  *	@dentry:	dentry pointer.
  *	@buffer:	data buffer for file.
  *
- *	Allocate @buffer->page, if it hasn't been already, then call the
- *	kobject's show() method to fill the buffer with this attribute's 
- *	data. 
- *	This is called only once, on the file's first read unless an error
- *	is returned.
+ *	Allocate @buffer->page, if it hasn't been already, then call
+ *	the fops->show() method to fill the buffer with this file's
+ *	data.  This is called only once, on the file's first read
+ *	unless an error is returned.
  */
-static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
+static int fill_read_buffer(struct dentry *dentry, struct sysfs_buffer *buffer)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
-	struct kobject *kobj = sd->s_parent->s_dir.data;
-	struct sysfs_ops * ops = buffer->ops;
-	int ret = 0;
-	ssize_t count;
+	const struct sysfs_file_ops *fops = sd->s_file.ops;
+	int rc;
 
 	if (!buffer->page)
 		buffer->page = (char *) get_zeroed_page(GFP_KERNEL);
 	if (!buffer->page)
 		return -ENOMEM;
 
-	/* need sd for attr and ops, its parent for kobj */
+	/* need sd for fops and data, its parent for parent_data */
 	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	buffer->event = atomic_read(&sd->s_file.open->event);
 	buffer->accessor = current;
 
-	count = ops->show(kobj, sd->s_file.attr, buffer->page);
+	rc = fops->show(buffer->page, sd->s_file.data,
+			sd->s_parent->s_dir.data);
 
 	if (buffer->committed_suicide)
 		module_allow_unload();
 	else
 		sysfs_put_active_two(sd);
 
-	BUG_ON(count > (ssize_t)PAGE_SIZE);
-	if (count >= 0) {
+	BUG_ON(rc > (ssize_t)PAGE_SIZE);
+	if (rc >= 0) {
 		buffer->needs_read_fill = 0;
-		buffer->count = count;
-	} else {
-		ret = count;
+		buffer->count = rc;
+ 		rc = 0;
 	}
-	return ret;
+	return rc;
 }
 
 /**
@@ -247,33 +204,30 @@ fill_write_buffer(struct sysfs_buffer * buffer, const char __user * buf, size_t
 	return error ? -EFAULT : count;
 }
 
-
 /**
- *	flush_write_buffer - push buffer to kobject.
- *	@dentry:	dentry to the attribute
+ *	flush_write_buffer - push buffer to sysfs_dirent
+ *	@dentry:	dentry to the file
  *	@buffer:	data buffer for file.
  *	@count:		number of bytes
  *
- *	Get the correct pointers for the kobject and the attribute we're
- *	dealing with, then call the store() method for the attribute, 
+ *	Call the sysfs_dirent's fops->store() method for the file,
  *	passing the buffer that we acquired in fill_write_buffer().
  */
-
-static int
-flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t count)
+static int flush_write_buffer(struct dentry *dentry,
+			      struct sysfs_buffer *buffer, size_t count)
 {
 	struct sysfs_dirent *sd = dentry->d_fsdata;
-	struct kobject *kobj = sd->s_parent->s_dir.data;
-	struct sysfs_ops * ops = buffer->ops;
+	const struct sysfs_file_ops *fops = sd->s_file.ops;
 	int rc;
 
-	/* need attr_sd for attr and ops, its parent for kobj */
+	/* need sd for fops and data, its parent for parent_data */
 	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	buffer->accessor = current;
 
-	rc = ops->store(kobj, sd->s_file.attr, buffer->page, count);
+	rc = fops->store(buffer->page, count, sd->s_file.data,
+			 sd->s_parent->s_dir.data);
 
 	if (buffer->committed_suicide)
 		module_allow_unload();
@@ -401,56 +355,56 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 	kfree(od);
 }
 
+/**
+ *	sysfs_open_file - open method for file sysfs_dirents
+ *	@inode: inode to open, passed from VFS layer
+ *	@file: file struct to be opened, passed from VFS layer
+ *
+ *	Open a file sysfs_dirent.  This function performs several
+ *	checks including sysfs_dirent and parent alivenss and access
+ *	permissions.  If that passes, it allocates or gets data
+ *	structures needed for file operations and grants the open
+ *	request.
+ *
+ *	LOCKING:
+ *	Determined by VFS layer.
+ *
+ *	RETURNS:
+ *	0 on success, -errno on failure.
+ */
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
 	struct sysfs_dirent *sd = file->f_path.dentry->d_fsdata;
-	struct kobject *kobj = sd->s_parent->s_dir.data;
-	struct sysfs_buffer * buffer;
-	struct sysfs_ops * ops = NULL;
+	const struct sysfs_file_ops *fops = sd->s_file.ops;
+	struct sysfs_buffer *buffer;
 	int error;
 
-	/* need sd for attr and ops, its parent for kobj */
+	/* file operations require both @sd and its parent */
 	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
-	/* if the kobject has no ktype, then we assume that it is a subsystem
-	 * itself, and use ops for it.
-	 */
-	if (kobj->kset && kobj->kset->ktype)
-		ops = kobj->kset->ktype->sysfs_ops;
-	else if (kobj->ktype)
-		ops = kobj->ktype->sysfs_ops;
-	else
-		ops = &subsys_sysfs_ops;
-
 	error = -EACCES;
 
-	/* No sysfs operations, either from having no subsystem,
-	 * or the subsystem have no operations.
-	 */
-	if (!ops)
+	/* can't open a file without fops */
+	if (!fops)
 		goto err_out;
 
-	/* File needs write support.
-	 * The inode's perms must say it's ok, 
+	/* File needs write support.  The sd's perms must say it's ok,
 	 * and we must have a store method.
 	 */
-	if (file->f_mode & FMODE_WRITE) {
-		if (!(inode->i_mode & S_IWUGO) || !ops->store)
-			goto err_out;
-	}
+	if ((file->f_mode & FMODE_WRITE) &&
+	    (!(sd->s_mode & S_IWUGO) || !fops->store))
+		goto err_out;
 
-	/* File needs read support.
-	 * The inode's perms must say it's ok, and we there
-	 * must be a show method for it.
+	/* File needs read support.  The sd's perms must say it's ok,
+	 * and we must have a show method for it.
 	 */
-	if (file->f_mode & FMODE_READ) {
-		if (!(inode->i_mode & S_IRUGO) || !ops->show)
-			goto err_out;
-	}
+	if ((file->f_mode & FMODE_READ) &&
+	    (!(inode->i_mode & S_IRUGO) || !fops->show))
+		goto err_out;
 
-	/* No error? Great, allocate a buffer for the file, and store it
-	 * it in file->private_data for easy access.
+	/* Allocate a buffer for the file, and store it it in
+	 * file->private_data for easy access.
 	 */
 	error = -ENOMEM;
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
@@ -459,7 +413,6 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 
 	mutex_init(&buffer->mutex);
 	buffer->needs_read_fill = 1;
-	buffer->ops = ops;
 	file->private_data = buffer;
 
 	/* make sure we have open dirent struct */
@@ -512,7 +465,7 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
 	struct sysfs_open_dirent *od = sd->s_file.open;
 
-	/* need parent for the kobj, grab both */
+	/* file operations require both @sd and its parent */
 	if (!sysfs_get_active_two(sd))
 		goto trigger;
 
@@ -530,33 +483,34 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	return POLLERR|POLLPRI;
 }
 
-void sysfs_notify(struct kobject *k, char *dir, char *attr)
+/**
+ *	sysfs_notify_file - notify file update
+ *	@sd: target sysfs_dirent
+ *
+ *	To be called on sysfs files which support polling after the
+ *	file is updated.  This function marks @sd changed and wakes up
+ *	polling waiters.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void sysfs_notify_file(struct sysfs_dirent *sd)
 {
-	struct sysfs_dirent *sd = k->sd;
-
-	mutex_lock(&sysfs_mutex);
-
-	if (sd && dir)
-		sd = sysfs_find_dirent(sd, dir);
-	if (sd && attr)
-		sd = sysfs_find_dirent(sd, attr);
-	if (sd) {
-		struct sysfs_open_dirent *od;
+	struct sysfs_open_dirent *od;
 
-		spin_lock(&sysfs_open_dirent_lock);
+	BUG_ON(sysfs_type(sd) != SYSFS_FILE);
 
-		od = sd->s_file.open;
-		if (od) {
-			atomic_inc(&od->event);
-			wake_up_interruptible(&od->poll);
-		}
+	spin_lock(&sysfs_open_dirent_lock);
 
-		spin_unlock(&sysfs_open_dirent_lock);
+	od = sd->s_file.open;
+	if (od) {
+		atomic_inc(&od->event);
+		wake_up_interruptible(&od->poll);
 	}
 
-	mutex_unlock(&sysfs_mutex);
+	spin_unlock(&sysfs_open_dirent_lock);
 }
-EXPORT_SYMBOL_GPL(sysfs_notify);
+EXPORT_SYMBOL_GPL(sysfs_notify_file);
 
 const struct file_operations sysfs_file_operations = {
 	.read		= sysfs_read_file,
@@ -567,6 +521,41 @@ const struct file_operations sysfs_file_operations = {
 	.poll		= sysfs_poll,
 };
 
+/**
+ *	sysfs_add_file - add a sysfs file
+ *	@parent: parent to add the sysfs file under
+ *	@name: name of new sysfs file
+ *	@mode: mode of new sysfs file
+ *	@fops: s_file.ops for new sysfs file
+ *	@data: s_file.data for new sysfs file
+ *
+ *	Add a new sysfs file with the specified parameters under
+ *	@parent.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to the new sysfs_dirent on success, ERR_PTR() value on
+ *	failure.
+ */
+struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
+				const char *name, mode_t mode,
+				const struct sysfs_file_ops *fops, void *data)
+{
+	struct sysfs_dirent *sd;
+
+	/* allocate and initialize */
+	sd = sysfs_new_dirent(name, mode, SYSFS_FILE);
+	if (!sd)
+		return ERR_PTR(-ENOMEM);
+
+	sd->s_file.ops = fops;
+	sd->s_file.data = data;
+
+	return sysfs_insert_one(parent, sd);
+}
+EXPORT_SYMBOL(sysfs_add_file);
 
 int __sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		   int type)
@@ -579,7 +568,7 @@ int __sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
 		return -ENOMEM;
-	sd->s_file.attr = (void *)attr;
+	sd->s_file.data = (void *)attr;
 
 	sysfs_addrm_start(&acxt);
 	rc = sysfs_add_one(&acxt, dir_sd, sd);
@@ -590,95 +579,3 @@ int __sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 
 	return rc;
 }
-
-
-/**
- *	sysfs_create_file - create an attribute file for an object.
- *	@kobj:	object we're creating for. 
- *	@attr:	atrribute descriptor.
- */
-
-int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
-{
-	BUG_ON(!kobj || !kobj->sd || !attr);
-
-	return __sysfs_add_file(kobj->sd, attr, SYSFS_FILE);
-
-}
-
-
-/**
- * sysfs_add_file_to_group - add an attribute file to a pre-existing group.
- * @kobj: object we're acting for.
- * @attr: attribute descriptor.
- * @group: group name.
- */
-int sysfs_add_file_to_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group)
-{
-	struct sysfs_dirent *dir_sd;
-	int error;
-
-	dir_sd = sysfs_get_dirent(kobj->sd, group);
-	if (!dir_sd)
-		return -ENOENT;
-
-	error = __sysfs_add_file(dir_sd, attr, SYSFS_FILE);
-	sysfs_put(dir_sd);
-
-	return error;
-}
-EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
-
-/**
- * sysfs_chmod_file - update the modified mode value on an object attribute.
- * @kobj: object we're acting for.
- * @attr: attribute descriptor.
- * @mode: file permissions.
- *
- */
-int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
-{
-	struct sysfs_dirent *victim_sd = NULL;
-	struct dentry *victim = NULL;
-	struct inode * inode;
-	struct iattr newattrs;
-	int rc;
-
-	rc = -ENOENT;
-	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
-	if (!victim_sd)
-		goto out;
-
-	mutex_lock(&sysfs_rename_mutex);
-	victim = sysfs_get_dentry(victim_sd);
-	mutex_unlock(&sysfs_rename_mutex);
-	if (IS_ERR(victim)) {
-		rc = PTR_ERR(victim);
-		victim = NULL;
-		goto out;
-	}
-
-	inode = victim->d_inode;
-
-	mutex_lock(&inode->i_mutex);
-
-	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
-	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-	rc = notify_change(victim, &newattrs);
-
-	if (rc == 0) {
-		mutex_lock(&sysfs_mutex);
-		victim_sd->s_mode = newattrs.ia_mode;
-		mutex_unlock(&sysfs_mutex);
-	}
-
-	mutex_unlock(&inode->i_mutex);
- out:
-	dput(victim);
-	sysfs_put(victim_sd);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(sysfs_chmod_file);
-
-EXPORT_SYMBOL_GPL(sysfs_create_file);
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 8e4677c..56ec704 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -17,6 +17,8 @@
 #include <linux/module.h>
 #include "sysfs.h"
 
+#define to_sattr(a) container_of(a,struct subsys_attribute, attr)
+
 static int sysfs_remove_child(struct sysfs_dirent *parent, const char *name)
 {
 	struct sysfs_dirent *sd;
@@ -73,6 +75,128 @@ void sysfs_remove_dir(struct kobject * kobj)
 	__sysfs_remove(sd, 0);
 }
 
+/*
+ * Subsystem file operations.  These operations allow subsystems to
+ * have files that can be read/written.
+ */
+static ssize_t
+subsys_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
+{
+	struct kset *kset = to_kset(kobj);
+	struct subsys_attribute *sattr = to_sattr(attr);
+	ssize_t ret = -EIO;
+
+	if (sattr->show)
+		ret = sattr->show(kset, page);
+	return ret;
+}
+
+static ssize_t
+subsys_attr_store(struct kobject *kobj, struct attribute *attr,
+		  const char *page, size_t count)
+{
+	struct kset *kset = to_kset(kobj);
+	struct subsys_attribute *sattr = to_sattr(attr);
+	ssize_t ret = -EIO;
+
+	if (sattr->store)
+		ret = sattr->store(kset, page, count);
+	return ret;
+}
+
+static struct sysfs_ops subsys_sysfs_ops = {
+	.show	= subsys_attr_show,
+	.store	= subsys_attr_store,
+};
+
+/*
+ * kobject file show/store
+ */
+static struct sysfs_ops *sysfs_attr_ops(struct kobject *kobj)
+{
+	/* If the kobject has no ktype, then we assume that it is a
+	 * subsystem itself, and use ops for it.
+	 */
+	if (kobj->kset && kobj->kset->ktype)
+		return kobj->kset->ktype->sysfs_ops;
+	else if (kobj->ktype)
+		return kobj->ktype->sysfs_ops;
+	else
+		return &subsys_sysfs_ops;
+}
+
+static ssize_t sysfs_attr_show(char *page, void *data, void *parent_data)
+{
+	struct kobject *kobj = parent_data;
+	struct sysfs_ops *attr_ops = sysfs_attr_ops(kobj);
+	struct attribute *attr = data;
+
+	if (!attr_ops->show)
+		return -EACCES;
+
+	return attr_ops->show(kobj, attr, page);
+}
+
+static ssize_t sysfs_attr_store(const char *page, size_t size, void *data,
+				void *parent_data)
+{
+	struct kobject *kobj = parent_data;
+	struct sysfs_ops *attr_ops = sysfs_attr_ops(kobj);
+	struct attribute *attr = data;
+
+	if (!attr_ops->store)
+		return -EACCES;
+
+	return attr_ops->store(kobj, attr, page, size);
+}
+
+static const struct sysfs_file_ops sysfs_attr_rw_fops = {
+	.show	= sysfs_attr_show,
+	.store	= sysfs_attr_store,
+};
+
+static const struct sysfs_file_ops sysfs_attr_ro_fops = {
+	.show	= sysfs_attr_show,
+};
+
+static const struct sysfs_file_ops sysfs_attr_wo_fops = {
+	.store	= sysfs_attr_store,
+};
+
+static const struct sysfs_file_ops *sysfs_attr_fops(struct kobject *kobj)
+{
+	struct sysfs_ops *attr_ops = sysfs_attr_ops(kobj);
+
+	if (attr_ops) {
+		if (attr_ops->show && attr_ops->store)
+			return &sysfs_attr_rw_fops;
+		else if (attr_ops->show)
+			return &sysfs_attr_ro_fops;
+		else if (attr_ops->store)
+			return &sysfs_attr_wo_fops;
+	}
+	return NULL;
+}
+
+/**
+ *	sysfs_create_file - create an attribute file for an object.
+ *	@kobj:	object we're creating for.
+ *	@attr:	atrribute descriptor.
+ */
+int sysfs_create_file(struct kobject *kobj, const struct attribute *attr)
+{
+	struct sysfs_dirent *sd;
+
+	BUG_ON(!kobj->sd || !attr);
+
+	sd = sysfs_add_file(kobj->sd, attr->name, attr->mode,
+			    sysfs_attr_fops(kobj), (void *)attr);
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_create_file);
+
 /**
  *	sysfs_remove_file - remove an object attribute.
  *	@kobj:	object we're acting for.
@@ -86,6 +210,48 @@ void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr)
 }
 EXPORT_SYMBOL_GPL(sysfs_remove_file);
 
+void sysfs_notify(struct kobject *k, char *dir, char *attr)
+{
+	struct sysfs_dirent *sd = k->sd;
+
+	mutex_lock(&sysfs_mutex);
+
+	if (sd && dir)
+		sd = sysfs_find_dirent(sd, dir);
+	if (sd && attr)
+		sd = sysfs_find_dirent(sd, attr);
+
+	sysfs_get(sd);
+
+	mutex_unlock(&sysfs_mutex);
+
+	if (sd)
+		sysfs_notify_file(sd);
+
+	sysfs_put(sd);
+}
+EXPORT_SYMBOL_GPL(sysfs_notify);
+
+/**
+ * sysfs_chmod_file - update the modified mode value on an object attribute.
+ * @kobj: object we're acting for.
+ * @attr: attribute descriptor.
+ * @mode: file permissions.
+ *
+ */
+int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
+{
+	struct sysfs_dirent *sd;
+	int rc = -ENOENT;
+
+	sd = sysfs_get_dirent(kobj->sd, attr->name);
+	if (sd)
+		rc = sysfs_chmod(sd, mode);
+	sysfs_put(sd);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sysfs_chmod_file);
+
 /**
  *	sysfs_remove_bin_file - remove binary file for object.
  *	@kobj:	object.
@@ -114,6 +280,32 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 EXPORT_SYMBOL_GPL(sysfs_remove_link);
 
 /**
+ * sysfs_add_file_to_group - add an attribute file to a pre-existing group.
+ * @kobj: object we're acting for.
+ * @attr: attribute descriptor.
+ * @group: group name.
+ */
+int sysfs_add_file_to_group(struct kobject *kobj,
+		const struct attribute *attr, const char *group)
+{
+	struct sysfs_dirent *dir_sd;
+	struct sysfs_dirent *sd;
+
+	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (!dir_sd)
+		return -ENOENT;
+
+	sd = sysfs_add_file(dir_sd, attr->name, attr->mode,
+			    sysfs_attr_fops(kobj), (void *)attr);
+	sysfs_put(dir_sd);
+
+	if (IS_ERR(sd))
+		return PTR_ERR(sd);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
+
+/**
  * sysfs_remove_file_from_group - remove an attribute file from a group.
  * @kobj: object we're acting for.
  * @attr: attribute descriptor.
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 4e032eb..ca02276 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -12,7 +12,8 @@ struct sysfs_elem_symlink {
 };
 
 struct sysfs_elem_file {
-	struct attribute	*attr;
+	const struct sysfs_file_ops *ops;
+	void			*data;
 	struct sysfs_open_dirent *open;
 };
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 3c64b4a..9304db7 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -34,17 +34,29 @@ struct vm_area_struct;
 /* collection of all flags for verification */
 #define SYSFS_MODE_FLAGS	SYSFS_COPY_NAME
 
+struct sysfs_file_ops {
+	ssize_t (*show)(char *page, void *data, void *parent_data);
+	ssize_t (*store)(const char *page, size_t size, void *data,
+			 void *parent_data);
+};
+
 #ifdef CONFIG_SYSFS
 
 extern struct sysfs_dirent * const sysfs_root;
 
 struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
 			const char *name, mode_t mode, void *data);
+struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
+			const char *name, mode_t mode,
+			const struct sysfs_file_ops *fops, void *data);
 
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 				      const char *name);
 void sysfs_remove(struct sysfs_dirent *sd);
 
+void sysfs_notify_file(struct sysfs_dirent *sd);
+int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode);
+
 int __must_check sysfs_init(void);
 
 #else /* CONFIG_SYSFS */
@@ -57,6 +69,13 @@ static inline struct sysfs_dirent *sysfs_add_dir(struct sysfs_dirent *parent,
 	return NULL;
 }
 
+static inline struct sysfs_dirent *sysfs_add_file(struct sysfs_dirent *parent,
+			const char *name, mode_t mode,
+			const struct sysfs_file_ops *fops, void *data)
+{
+	return NULL;
+}
+
 static inline struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 						    const char *name)
 {
@@ -67,6 +86,15 @@ static inline void sysfs_remove(struct sysfs_dirent *sd)
 {
 }
 
+static inline void sysfs_notify_file(struct sysfs_dirent *sd)
+{
+}
+
+static inline int sysfs_chmod(struct sysfs_dirent *sd, mode_t mode)
+{
+	return 0;
+}
+
 static inline int __must_check sysfs_init(void)
 {
 	return 0;
-- 
1.5.0.3


