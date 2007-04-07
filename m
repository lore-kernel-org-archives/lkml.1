Return-Path: <linux-kernel-owner+w=401wt.eu-S965638AbXDGI05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965638AbXDGI05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXDGIY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:24:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:60677 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965533AbXDGIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=F7CvLBprsj2sE039/ZuEulz9L+b+6hyTbQMWU7403aknHYDGL7LlUZ2qFWueTn08IxQy5AHR+ulEFHr/8g7nJj1kCX8FsVNBTzL1rkr/8iLjDKail9FoattrSDECtzfrgGYLNy0Rney1KBjNUvEJSjkJ+YT8oew84AysUEHwt9I=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 12/14] sysfs: implement immediate kobject disconnect
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:48 +0900
Message-Id: <11759342283967-git-send-email-htejun@gmail.com>
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

Opening a sysfs node references its associated kobject, so userland
can arbitrarily prolong lifetime of a kobject which complicates
lifetime rules in drivers.  This patch makes the association between
kobject and sysfs immediately breakable.

Each sysfs_dirent representing a kobject has a rwsem.  Any file
operation which has to access the associated kobject should read lock
the rwsem and check whether the pointer is still valid.  The read lock
should be held until access to the kobj is not necessary.

On sysfs_dirent deletion, the rwsem is write locked and the pointer is
cleared.  This ensures that there is no user to the kobj through the
sysfs_dirent.  This way, sysfs_dirent doesn't have to hold reference
to its associated kobj and can disconnect from it immediately on
deletion.

sysfs_get_dir_kobj() and sysfs_put_dir_kobj() read lock and unlock
kobj access, respectively.  As write locking is used only once during
deletion, blocking on down_read() indicates that the kobj will have
been disassociated when down_read() succeeds, so down_read_trylock()
is used in sysfs_get_dir_kobj() making the function non-blocking.

Unlike other operations, mmapped area lingers on after mmap() is
finished and the kobj needs to stay referenced till all the mapped
pages are gone.  This is accomplished by holding one reference to kobj
if there have been any mmap during lifetime of an openfile.  The
reference is dropped when the openfile is released.

Note that read locking kobject not only protects the kobject itself
but also ensures that the backing module doesn't go away while the
lock is held.  IOW, any access to code or data out of sysfs core
shouldn't be made without grabbing kobject.  So, access to attr should
be done while holding its parent's kobject.

This change makes sysfs lifetime rules independent from both kobject's
and module's.  It not only fixes several race conditions caused by
sysfs not holding onto the proper module when referencing kobject, but
also helps fixing and simplifying lifetime management in driver model
and drivers by taking sysfs out of the equation.

Please read the following message for more info.

  http://article.gmane.org/gmane.linux.kernel/510293

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c   |   97 ++++++++++++++++++++++++++-------------
 fs/sysfs/dir.c   |   39 +++++++++++-----
 fs/sysfs/file.c  |  133 ++++++++++++++++++++++++++++++++----------------------
 fs/sysfs/sysfs.h |   10 +---
 4 files changed, 172 insertions(+), 107 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 1dd1bf1..a2180c5 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -23,6 +23,7 @@
 struct bin_buffer {
 	struct mutex	mutex;
 	void		*buffer;
+	int		mmapped;
 };
 
 static int
@@ -30,12 +31,20 @@ fill_read(struct dentry *dentry, char *buffer, loff_t off, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject * kobj = to_kobj(dentry->d_parent);
+	struct kobject *kobj;
+	int rc;
+
+	kobj = sysfs_get_dir_kobj(attr_sd->s_parent);
+	if (!kobj)
+		return -ENODEV;
 
-	if (!attr->read)
-		return -EIO;
+	rc = -EIO;
+	if (attr->read)
+		rc = attr->read(kobj, buffer, off, count);
 
-	return attr->read(kobj, buffer, off, count);
+	sysfs_put_dir_kobj(attr_sd->s_parent);
+
+	return rc;
 }
 
 static ssize_t
@@ -79,12 +88,20 @@ flush_write(struct dentry *dentry, char *buffer, loff_t offset, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = to_kobj(dentry->d_parent);
+	struct kobject *kobj;
+	int rc;
+
+	kobj = sysfs_get_dir_kobj(attr_sd->s_parent);
+	if (!kobj)
+		return -ENODEV;
 
-	if (!attr->write)
-		return -EIO;
+	rc = -EIO;
+	if (attr->write)
+		rc = attr->write(kobj, buffer, offset, count);
 
-	return attr->write(kobj, buffer, offset, count);
+	sysfs_put_dir_kobj(attr_sd->s_parent);
+
+	return rc;
 }
 
 static ssize_t write(struct file *file, const char __user *userbuf,
@@ -124,14 +141,24 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 	struct bin_buffer *bb = file->private_data;
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
-	struct kobject *kobj = to_kobj(file->f_path.dentry->d_parent);
+	struct kobject *kobj;
 	int rc;
 
-	if (!attr->mmap)
-		return -EINVAL;
-
 	mutex_lock(&bb->mutex);
-	rc = attr->mmap(kobj, attr, vma);
+
+	kobj = sysfs_get_dir_kobj(attr_sd->s_parent);
+	if (!kobj)
+		return -ENODEV;
+
+	rc = -EINVAL;
+	if (attr->mmap)
+		rc = attr->mmap(kobj, attr, vma);
+
+	if (rc == 0 && !bb->mmapped)
+		bb->mmapped = 1;
+	else
+		sysfs_put_dir_kobj(attr_sd->s_parent);
+
 	mutex_unlock(&bb->mutex);
 
 	return rc;
@@ -139,58 +166,62 @@ static int mmap(struct file *file, struct vm_area_struct *vma)
 
 static int open(struct inode * inode, struct file * file)
 {
-	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
 	struct bin_buffer *bb = NULL;
-	int error = -EINVAL;
+	int error;
 
-	if (!kobj || !attr)
-		goto Done;
+	/* Grab kobject first.  attr might go away underneath us if
+	 * we're not holding kobject.
+	 */
+	if (!sysfs_get_dir_kobj(attr_sd->s_parent))
+		return -ENODEV;
 
-	/* Grab the module reference for this attribute if we have one */
+	/* Grab the module reference for this attribute */
 	error = -ENODEV;
-	if (!try_module_get(attr->attr.owner)) 
-		goto Done;
+	if (!try_module_get(attr->attr.owner))
+		goto err_sput;
 
 	error = -EACCES;
 	if ((file->f_mode & FMODE_WRITE) && !(attr->write || attr->mmap))
-		goto Error;
+		goto err_mput;
 	if ((file->f_mode & FMODE_READ) && !(attr->read || attr->mmap))
-		goto Error;
+		goto err_mput;
 
 	error = -ENOMEM;
 	bb = kzalloc(sizeof(*bb), GFP_KERNEL);
 	if (!bb)
-		goto Error;
+		goto err_mput;
 
 	bb->buffer = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!bb->buffer)
-		goto Error;
+		goto err_mput;
 
 	mutex_init(&bb->mutex);
 	file->private_data = bb;
 
-	error = 0;
-	goto Done;
+	/* open succeeded, put kobj and pin attr_sd */
+	sysfs_put_dir_kobj(attr_sd->s_parent);
+	sysfs_get(attr_sd);
+	return 0;
 
- Error:
-	kfree(bb);
+ err_mput:
 	module_put(attr->attr.owner);
- Done:
-	if (error)
-		kobject_put(kobj);
+ err_sput:
+	sysfs_put_dir_kobj(attr_sd->s_parent);
+	kfree(bb);
 	return error;
 }
 
 static int release(struct inode * inode, struct file * file)
 {
-	struct kobject * kobj = to_kobj(file->f_path.dentry->d_parent);
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct bin_attribute *attr = attr_sd->s_elem.bin_attr.bin_attr;
 	struct bin_buffer *bb = file->private_data;
 
-	kobject_put(kobj);
+	if (bb->mmapped)
+		sysfs_put_dir_kobj(attr_sd->s_parent);
+	sysfs_put(attr_sd);
 	module_put(attr->attr.owner);
 	kfree(bb->buffer);
 	kfree(bb);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b7d0e0e..b2406cb 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -15,22 +15,28 @@
 DECLARE_RWSEM(sysfs_rename_sem);
 spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
-struct kobject *sysfs_get_kobject(struct dentry *dentry)
+struct kobject *sysfs_get_dir_kobj(struct sysfs_dirent *sd)
 {
-	struct kobject * kobj = NULL;
+	struct sysfs_elem_dir *sdir = &sd->s_elem.dir;
 
-	spin_lock(&dcache_lock);
-	if (!d_unhashed(dentry)) {
-		struct sysfs_dirent * sd = dentry->d_fsdata;
+	BUG_ON(!(sd->s_type & SYSFS_DIR));
 
-		if (sd->s_type & SYSFS_KOBJ_LINK)
-			sd = sd->s_elem.symlink.target_sd;
+	if (unlikely(!down_read_trylock(&sdir->rwsem)))
+		return NULL;
 
-		kobj = kobject_get(sd->s_elem.dir.kobj);
-	}
-	spin_unlock(&dcache_lock);
+	if (unlikely(!sdir->kobj))
+		up_read(&sdir->rwsem);
 
-	return kobj;
+	return sdir->kobj;
+}
+
+void sysfs_put_dir_kobj(struct sysfs_dirent *sd)
+{
+	struct sysfs_elem_dir *sdir = &sd->s_elem.dir;
+
+	BUG_ON(!(sd->s_type & SYSFS_DIR) || !sdir->kobj);
+
+	up_read(&sdir->rwsem);
 }
 
 void release_sysfs_dirent(struct sysfs_dirent * sd)
@@ -183,6 +189,7 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
 	if (!sd)
 		goto out_drop;
+	init_rwsem(&sd->s_elem.dir.rwsem);
 	sd->s_elem.dir.kobj = kobj;
 	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
 
@@ -328,11 +335,16 @@ const struct inode_operations sysfs_dir_inode_operations = {
 static void remove_dir(struct dentry * d)
 {
 	struct dentry * parent = dget(d->d_parent);
-	struct sysfs_dirent * sd;
+	struct sysfs_dirent *sd = d->d_fsdata;
+	struct sysfs_elem_dir *sdir = &sd->s_elem.dir;
+
+	/* disconnect kobject */
+	down_write(&sdir->rwsem);
+	sdir->kobj = NULL;
+	up_write(&sdir->rwsem);
 
 	mutex_lock(&parent->d_inode->i_mutex);
 	d_delete(d);
-	sd = d->d_fsdata;
  	list_del_init(&sd->s_sibling);
 	sysfs_put(sd);
 	if (d->d_inode)
@@ -683,6 +695,7 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	sd = sysfs_new_dirent("_SHADOW_", inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
+	init_rwsem(&sd->s_elem.dir.rwsem);
 	sd->s_elem.dir.kobj = kobj;
 	/* point to parent_sd but don't attach to it */
 	sd->s_parent = sysfs_get(parent_sd);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index a6c72c6..133a108 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -88,9 +88,9 @@ remove_from_collection(struct sysfs_buffer *buffer, struct inode *node)
  */
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
-	struct sysfs_dirent * sd = dentry->d_fsdata;
-	struct kobject * kobj = to_kobj(dentry->d_parent);
+	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
 	struct sysfs_ops * ops = buffer->ops;
+	struct kobject *kobj;
 	int ret = 0;
 	ssize_t count;
 
@@ -99,8 +99,15 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	if (!buffer->page)
 		return -ENOMEM;
 
-	buffer->event = atomic_read(&sd->s_event);
-	count = ops->show(kobj, sd->s_elem.attr.attr, buffer->page);
+	kobj = sysfs_get_dir_kobj(attr_sd->s_parent);
+	if (!kobj)
+		return -ENODEV;
+
+	buffer->event = atomic_read(&attr_sd->s_event);
+	count = ops->show(kobj, attr_sd->s_elem.attr.attr, buffer->page);
+
+	sysfs_put_dir_kobj(attr_sd->s_parent);
+
 	BUG_ON(count > (ssize_t)PAGE_SIZE);
 	if (count >= 0) {
 		buffer->needs_read_fill = 0;
@@ -225,14 +232,23 @@ fill_write_buffer(struct sysfs_buffer * buffer, const char __user * buf, size_t
  *	passing the buffer that we acquired in fill_write_buffer().
  */
 
-static int 
+static int
 flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t count)
 {
 	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject * kobj = to_kobj(dentry->d_parent);
 	struct sysfs_ops * ops = buffer->ops;
+	struct kobject *kobj;
+	int rc;
 
-	return ops->store(kobj, attr_sd->s_elem.attr.attr, buffer->page, count);
+	kobj = sysfs_get_dir_kobj(attr_sd->s_parent);
+	if (!kobj)
+		return -ENODEV;
+
+	rc = ops->store(kobj, attr_sd->s_elem.attr.attr, buffer->page, count);
+
+	sysfs_put_dir_kobj(attr_sd->s_parent);
+
+	return rc;
 }
 
 
@@ -276,22 +292,25 @@ out:
 
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
-	struct kobject *kobj = sysfs_get_kobject(file->f_path.dentry->d_parent);
 	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct sysfs_buffer_collection *set;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
-	int error = 0;
+	struct kobject *kobj;
+	int error;
 
-	if (!kobj || !attr)
-		goto Einval;
+	/* Grab kobject first.  attr might go away underneath us if
+	 * we're not holding kobject.
+	 */
+	kobj = sysfs_get_dir_kobj(attr_sd->s_parent);
+	if (!kobj)
+		return -ENODEV;
 
-	/* Grab the module reference for this attribute if we have one */
-	if (!try_module_get(attr->owner)) {
-		error = -ENODEV;
-		goto Done;
-	}
+	/* Grab the module reference for this attribute */
+	error = -ENODEV;
+	if (!try_module_get(attr->owner))
+		goto err_sput;
 
 	/* if the kobject has no ktype, then we assume that it is a subsystem
 	 * itself, and use ops for it.
@@ -306,30 +325,30 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	/* No sysfs operations, either from having no subsystem,
 	 * or the subsystem have no operations.
 	 */
+	error = -EACCES;
 	if (!ops)
-		goto Eaccess;
+		goto err_mput;
 
 	/* make sure we have a collection to add our buffers to */
 	mutex_lock(&inode->i_mutex);
 	if (!(set = inode->i_private)) {
-		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
-			error = -ENOMEM;
-			goto Done;
-		} else {
+		error = -ENOMEM;
+		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL)))
+			goto err_mput;
+		else
 			INIT_LIST_HEAD(&set->associates);
-		}
 	}
 	mutex_unlock(&inode->i_mutex);
 
+	error = -EACCES;
+
 	/* File needs write support.
 	 * The inode's perms must say it's ok, 
 	 * and we must have a store method.
 	 */
 	if (file->f_mode & FMODE_WRITE) {
-
 		if (!(inode->i_mode & S_IWUGO) || !ops->store)
-			goto Eaccess;
-
+			goto err_mput;
 	}
 
 	/* File needs read support.
@@ -338,46 +357,45 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	 */
 	if (file->f_mode & FMODE_READ) {
 		if (!(inode->i_mode & S_IRUGO) || !ops->show)
-			goto Eaccess;
+			goto err_mput;
 	}
 
 	/* No error? Great, allocate a buffer for the file, and store it
 	 * it in file->private_data for easy access.
 	 */
+	error = -ENOMEM;
 	buffer = kzalloc(sizeof(struct sysfs_buffer), GFP_KERNEL);
-	if (buffer) {
-		INIT_LIST_HEAD(&buffer->associates);
-		init_MUTEX(&buffer->sem);
-		buffer->needs_read_fill = 1;
-		buffer->ops = ops;
-		add_to_collection(buffer, inode);
-		file->private_data = buffer;
-	} else
-		error = -ENOMEM;
-	goto Done;
+	if (!buffer)
+		goto err_mput;
 
- Einval:
-	error = -EINVAL;
-	goto Done;
- Eaccess:
-	error = -EACCES;
+	INIT_LIST_HEAD(&buffer->associates);
+	init_MUTEX(&buffer->sem);
+	buffer->needs_read_fill = 1;
+	buffer->ops = ops;
+	add_to_collection(buffer, inode);
+	file->private_data = buffer;
+
+	/* open succeeded, put kobj and pin attr_sd */
+	sysfs_put_dir_kobj(attr_sd->s_parent);
+	sysfs_get(attr_sd);
+	return 0;
+
+ err_mput:
 	module_put(attr->owner);
- Done:
-	if (error)
-		kobject_put(kobj);
+ err_sput:
+	sysfs_put_dir_kobj(attr_sd->s_parent);
 	return error;
 }
 
 static int sysfs_release(struct inode * inode, struct file * filp)
 {
-	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
 	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
 	struct attribute *attr = attr_sd->s_elem.attr.attr;
 	struct sysfs_buffer * buffer = filp->private_data;
 
 	if (buffer)
 		remove_from_collection(buffer, inode);
-	kobject_put(kobj);
+	sysfs_put(attr_sd);
 	/* After this point, attr should not be accessed. */
 	module_put(attr->owner);
 
@@ -406,18 +424,25 @@ static int sysfs_release(struct inode * inode, struct file * filp)
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
 	struct sysfs_buffer * buffer = filp->private_data;
-	struct kobject * kobj = to_kobj(filp->f_path.dentry->d_parent);
-	struct sysfs_dirent * sd = filp->f_path.dentry->d_fsdata;
-	int res = 0;
+	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
+	struct kobject *kobj;
+
+	kobj = sysfs_get_dir_kobj(attr_sd->s_parent);
+	if (!kobj)
+		goto trigger;
 
 	poll_wait(filp, &kobj->poll, wait);
 
-	if (buffer->event != atomic_read(&sd->s_event)) {
-		res = POLLERR|POLLPRI;
-		buffer->needs_read_fill = 1;
-	}
+	sysfs_put_dir_kobj(attr_sd->s_parent);
 
-	return res;
+	if (buffer->event != atomic_read(&attr_sd->s_event))
+		goto trigger;
+
+	return 0;
+
+ trigger:
+	buffer->needs_read_fill = 1;
+	return POLLERR|POLLPRI;
 }
 
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index b9acf0e..b56186f 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -1,4 +1,5 @@
 struct sysfs_elem_dir {
+	struct rw_semaphore	rwsem;
 	struct kobject		* kobj;
 };
 
@@ -42,7 +43,8 @@ extern void sysfs_delete_inode(struct inode *inode);
 extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
 extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
-extern struct kobject *sysfs_get_kobject(struct dentry *dentry);
+extern struct kobject *sysfs_get_dir_kobj(struct sysfs_dirent *sd);
+extern void sysfs_put_dir_kobj(struct sysfs_dirent *sd);
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
 extern struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode,
@@ -86,12 +88,6 @@ struct sysfs_buffer_collection {
 	struct list_head	associates;
 };
 
-static inline struct kobject * to_kobj(struct dentry * dentry)
-{
-	struct sysfs_dirent * sd = dentry->d_fsdata;
-	return sd->s_elem.dir.kobj;
-}
-
 static inline struct sysfs_dirent * sysfs_get(struct sysfs_dirent * sd)
 {
 	if (sd) {
-- 
1.5.0.3


