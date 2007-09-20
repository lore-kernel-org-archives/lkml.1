Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXITIJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXITIJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbXITIGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:04 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33572 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbXITIFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=e4PQzMTWhj2t+laOG/YGkvvP12FRyTFpOkI7AVniLHW373NG1XtlrsWz/kAGeaBUcO6G82rreVumr0CObBYVb6EpTZc3k1E7utqG3SWqPU/m6NK6uzQupA2z0ViIRODmSeWpV+ySXn6/r7RyEZ96FII9QcHJUgFcdE0Nhlj12QU=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 10/22] sysfs: drop kobj and attr from file related symbols
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <11902755401517-git-send-email-htejun@gmail.com>
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

Currently, regular sysfs files are called (kobj) attrs or files.  This
is a bit confusing and sd-based interface won't be bound to attribute.
Use 'file' consistently and drop all kobj and attr from symbol names.

This patch doesn't introduce any logic change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c   |    4 +-
 fs/sysfs/file.c  |  140 +++++++++++++++++++++++++++---------------------------
 fs/sysfs/group.c |    2 +-
 fs/sysfs/inode.c |    2 +-
 fs/sysfs/sysfs.h |    6 +-
 5 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b15ade7..170749d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -341,7 +341,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	case SYSFS_DIR:
 		mode |= S_IFDIR;
 		break;
-	case SYSFS_KOBJ_ATTR:
+	case SYSFS_FILE:
 	case SYSFS_KOBJ_BIN_ATTR:
 		mode |= S_IFREG;
 		break;
@@ -630,7 +630,7 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
 		sd->s_sibling = NULL;
 
 		sysfs_drop_dentry(sd);
-		if (sysfs_type(sd) == SYSFS_KOBJ_ATTR)
+		if (sysfs_type(sd) == SYSFS_FILE)
 			sysfs_file_check_suicide(sd);
 		sysfs_deactivate(sd);
 		sysfs_put(sd);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3b74912..ae4d7cb 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -55,7 +55,7 @@ static struct sysfs_ops subsys_sysfs_ops = {
  * files.
  *
  * filp->private_data points to sysfs_buffer and
- * sysfs_dirent->s_attr.open points to sysfs_open_dirent.  s_attr.open
+ * sysfs_dirent->s_file.open points to sysfs_open_dirent.  s_file.open
  * is protected by sysfs_open_dirent_lock.
  */
 static spinlock_t sysfs_open_dirent_lock = SPIN_LOCK_UNLOCKED;
@@ -103,7 +103,7 @@ void sysfs_file_check_suicide(struct sysfs_dirent *sd)
 
 	spin_lock(&sysfs_open_dirent_lock);
 
-	od = sd->s_attr.open;
+	od = sd->s_file.open;
 	if (od) {
 		list_for_each_entry(buffer, &od->buffers, list) {
 			if (buffer->accessor != current)
@@ -144,8 +144,8 @@ void sysfs_file_check_suicide(struct sysfs_dirent *sd)
  */
 static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kobject *kobj = sd->s_parent->s_dir.data;
 	struct sysfs_ops * ops = buffer->ops;
 	int ret = 0;
 	ssize_t count;
@@ -155,19 +155,19 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 	if (!buffer->page)
 		return -ENOMEM;
 
-	/* need attr_sd for attr and ops, its parent for kobj */
-	if (!sysfs_get_active_two(attr_sd))
+	/* need sd for attr and ops, its parent for kobj */
+	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
-	buffer->event = atomic_read(&attr_sd->s_attr.open->event);
+	buffer->event = atomic_read(&sd->s_file.open->event);
 	buffer->accessor = current;
 
-	count = ops->show(kobj, attr_sd->s_attr.attr, buffer->page);
+	count = ops->show(kobj, sd->s_file.attr, buffer->page);
 
 	if (buffer->committed_suicide)
 		module_allow_unload();
 	else
-		sysfs_put_active_two(attr_sd);
+		sysfs_put_active_two(sd);
 
 	BUG_ON(count > (ssize_t)PAGE_SIZE);
 	if (count >= 0) {
@@ -180,24 +180,22 @@ static int fill_read_buffer(struct dentry * dentry, struct sysfs_buffer * buffer
 }
 
 /**
- *	sysfs_read_file - read an attribute. 
+ *	sysfs_read_file - read from a sysfs file
  *	@file:	file pointer.
  *	@buf:	buffer to fill.
  *	@count:	number of bytes to read.
  *	@ppos:	starting offset in file.
  *
- *	Userspace wants to read an attribute file. The attribute descriptor
- *	is in the file's ->d_fsdata. The target object is in the directory's
- *	->d_fsdata.
+ *	Userspace wants to read a file. The sysfs_dirent is in the
+ *	file's ->d_fsdata.
  *
- *	We call fill_read_buffer() to allocate and fill the buffer from the
- *	object's show() method exactly once (if the read is happening from
- *	the beginning of the file). That should fill the entire buffer with
- *	all the data the object has to offer for that attribute.
- *	We then call flush_read_buffer() to copy the buffer to userspace
- *	in the increments specified.
+ *	We call fill_read_buffer() to allocate and fill the buffer
+ *	from the object's show() method exactly once (if the read is
+ *	happening from the beginning of the file).  That should fill
+ *	the entire buffer with all the data the object has to offer
+ *	for that file.  We then call flush_read_buffer() to copy the
+ *	buffer to userspace in the increments specified.
  */
-
 static ssize_t
 sysfs_read_file(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
@@ -264,43 +262,45 @@ fill_write_buffer(struct sysfs_buffer * buffer, const char __user * buf, size_t
 static int
 flush_write_buffer(struct dentry * dentry, struct sysfs_buffer * buffer, size_t count)
 {
-	struct sysfs_dirent *attr_sd = dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct kobject *kobj = sd->s_parent->s_dir.data;
 	struct sysfs_ops * ops = buffer->ops;
 	int rc;
 
 	/* need attr_sd for attr and ops, its parent for kobj */
-	if (!sysfs_get_active_two(attr_sd))
+	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	buffer->accessor = current;
 
-	rc = ops->store(kobj, attr_sd->s_attr.attr, buffer->page, count);
+	rc = ops->store(kobj, sd->s_file.attr, buffer->page, count);
 
 	if (buffer->committed_suicide)
 		module_allow_unload();
 	else
-		sysfs_put_active_two(attr_sd);
+		sysfs_put_active_two(sd);
 
 	return rc;
 }
 
 
 /**
- *	sysfs_write_file - write an attribute.
+ *	sysfs_write_file - write to a sysfs file
  *	@file:	file pointer
  *	@buf:	data to write
  *	@count:	number of bytes
  *	@ppos:	starting offset
  *
- *	Similar to sysfs_read_file(), though working in the opposite direction.
- *	We allocate and fill the data from the user in fill_write_buffer(),
- *	then push it to the kobject in flush_write_buffer().
- *	There is no easy way for us to know if userspace is only doing a partial
- *	write, so we don't support them. We expect the entire buffer to come
- *	on the first write. 
- *	Hint: if you're writing a value, first read the file, modify only the
- *	the value you're changing, then write entire buffer back. 
+ *	Similar to sysfs_read_file(), though working in the opposite
+ *	direction.  We allocate and fill the data from the user in
+ *	fill_write_buffer(), then push it to the sysfs_dirent in
+ *	flush_write_buffer().  There is no easy way for us to know if
+ *	userspace is only doing a partial write, so we don't support
+ *	them. We expect the entire buffer to come on the first write.
+ *	Hint: if you're writing a value, first read the file, modify
+ *	only the the value you're changing, then write entire buffer
+ *	back.
+ *
  */
 
 static ssize_t
@@ -324,7 +324,7 @@ sysfs_write_file(struct file *file, const char __user *buf, size_t count, loff_t
  *	@sd: target sysfs_dirent
  *	@buffer: sysfs_buffer for this instance of open
  *
- *	If @sd->s_attr.open exists, increment its reference count;
+ *	If @sd->s_file.open exists, increment its reference count;
  *	otherwise, create one.  @buffer is chained to the buffers
  *	list.
  *
@@ -342,12 +342,12 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
  retry:
 	spin_lock(&sysfs_open_dirent_lock);
 
-	if (!sd->s_attr.open && new_od) {
-		sd->s_attr.open = new_od;
+	if (!sd->s_file.open && new_od) {
+		sd->s_file.open = new_od;
 		new_od = NULL;
 	}
 
-	od = sd->s_attr.open;
+	od = sd->s_file.open;
 	if (od) {
 		atomic_inc(&od->refcnt);
 		list_add_tail(&buffer->list, &od->buffers);
@@ -377,7 +377,7 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
  *	@sd: target sysfs_dirent
  *	@buffer: associated sysfs_buffer
  *
- *	Put @sd->s_attr.open and unlink @buffer from the buffers list.
+ *	Put @sd->s_file.open and unlink @buffer from the buffers list.
  *	If reference count reaches zero, disassociate and free it.
  *
  *	LOCKING:
@@ -386,13 +386,13 @@ static int sysfs_get_open_dirent(struct sysfs_dirent *sd,
 static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 				  struct sysfs_buffer *buffer)
 {
-	struct sysfs_open_dirent *od = sd->s_attr.open;
+	struct sysfs_open_dirent *od = sd->s_file.open;
 
 	spin_lock(&sysfs_open_dirent_lock);
 
 	list_del(&buffer->list);
 	if (atomic_dec_and_test(&od->refcnt))
-		sd->s_attr.open = NULL;
+		sd->s_file.open = NULL;
 	else
 		od = NULL;
 
@@ -403,14 +403,14 @@ static void sysfs_put_open_dirent(struct sysfs_dirent *sd,
 
 static int sysfs_open_file(struct inode *inode, struct file *file)
 {
-	struct sysfs_dirent *attr_sd = file->f_path.dentry->d_fsdata;
-	struct kobject *kobj = attr_sd->s_parent->s_dir.data;
+	struct sysfs_dirent *sd = file->f_path.dentry->d_fsdata;
+	struct kobject *kobj = sd->s_parent->s_dir.data;
 	struct sysfs_buffer * buffer;
 	struct sysfs_ops * ops = NULL;
 	int error;
 
-	/* need attr_sd for attr and ops, its parent for kobj */
-	if (!sysfs_get_active_two(attr_sd))
+	/* need sd for attr and ops, its parent for kobj */
+	if (!sysfs_get_active_two(sd))
 		return -ENODEV;
 
 	/* if the kobject has no ktype, then we assume that it is a subsystem
@@ -463,18 +463,18 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	file->private_data = buffer;
 
 	/* make sure we have open dirent struct */
-	error = sysfs_get_open_dirent(attr_sd, buffer);
+	error = sysfs_get_open_dirent(sd, buffer);
 	if (error)
 		goto err_free;
 
 	/* open succeeded, put active references */
-	sysfs_put_active_two(attr_sd);
+	sysfs_put_active_two(sd);
 	return 0;
 
  err_free:
 	kfree(buffer);
  err_out:
-	sysfs_put_active_two(attr_sd);
+	sysfs_put_active_two(sd);
 	return error;
 }
 
@@ -492,33 +492,33 @@ static int sysfs_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-/* Sysfs attribute files are pollable.  The idea is that you read
- * the content and then you use 'poll' or 'select' to wait for
- * the content to change.  When the content changes (assuming the
- * manager for the kobject supports notification), poll will
- * return POLLERR|POLLPRI, and select will return the fd whether
- * it is waiting for read, write, or exceptions.
- * Once poll/select indicates that the value has changed, you
- * need to close and re-open the file, as simply seeking and reading
- * again will not get new data, or reset the state of 'poll'.
- * Reminder: this only works for attributes which actively support
- * it, and it is not possible to test an attribute from userspace
- * to see if it supports poll (Neither 'poll' nor 'select' return
- * an appropriate error code).  When in doubt, set a suitable timeout value.
+/* Sysfs files are pollable.  The idea is that you read the content
+ * and then you use 'poll' or 'select' to wait for the content to
+ * change.  When the content changes (assuming the manager for the
+ * sysfs_dirent supports notification), poll will return
+ * POLLERR|POLLPRI, and select will return the fd whether it is
+ * waiting for read, write, or exceptions.  Once poll/select indicates
+ * that the value has changed, you need to close and re-open the file,
+ * as simply seeking and reading again will not get new data, or reset
+ * the state of 'poll'.  Reminder: this only works for files which
+ * actively support it, and it is not possible to test a file from
+ * userspace to see if it supports poll (Neither 'poll' nor 'select'
+ * return an appropriate error code).  When in doubt, set a suitable
+ * timeout value.
  */
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 {
-	struct sysfs_buffer * buffer = filp->private_data;
-	struct sysfs_dirent *attr_sd = filp->f_path.dentry->d_fsdata;
-	struct sysfs_open_dirent *od = attr_sd->s_attr.open;
+	struct sysfs_buffer *buffer = filp->private_data;
+	struct sysfs_dirent *sd = filp->f_path.dentry->d_fsdata;
+	struct sysfs_open_dirent *od = sd->s_file.open;
 
 	/* need parent for the kobj, grab both */
-	if (!sysfs_get_active_two(attr_sd))
+	if (!sysfs_get_active_two(sd))
 		goto trigger;
 
 	poll_wait(filp, &od->poll, wait);
 
-	sysfs_put_active_two(attr_sd);
+	sysfs_put_active_two(sd);
 
 	if (buffer->event != atomic_read(&od->event))
 		goto trigger;
@@ -545,7 +545,7 @@ void sysfs_notify(struct kobject *k, char *dir, char *attr)
 
 		spin_lock(&sysfs_open_dirent_lock);
 
-		od = sd->s_attr.open;
+		od = sd->s_file.open;
 		if (od) {
 			atomic_inc(&od->event);
 			wake_up_interruptible(&od->poll);
@@ -579,7 +579,7 @@ int __sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 	sd = sysfs_new_dirent(attr->name, mode, type);
 	if (!sd)
 		return -ENOMEM;
-	sd->s_attr.attr = (void *)attr;
+	sd->s_file.attr = (void *)attr;
 
 	sysfs_addrm_start(&acxt);
 	rc = sysfs_add_one(&acxt, dir_sd, sd);
@@ -602,7 +602,7 @@ int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)
 {
 	BUG_ON(!kobj || !kobj->sd || !attr);
 
-	return __sysfs_add_file(kobj->sd, attr, SYSFS_KOBJ_ATTR);
+	return __sysfs_add_file(kobj->sd, attr, SYSFS_FILE);
 
 }
 
@@ -623,7 +623,7 @@ int sysfs_add_file_to_group(struct kobject *kobj,
 	if (!dir_sd)
 		return -ENOENT;
 
-	error = __sysfs_add_file(dir_sd, attr, SYSFS_KOBJ_ATTR);
+	error = __sysfs_add_file(dir_sd, attr, SYSFS_FILE);
 	sysfs_put(dir_sd);
 
 	return error;
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index 5c5aab0..bb94f6a 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -32,7 +32,7 @@ static int create_files(struct sysfs_dirent *dir_sd,
 	int error = 0;
 
 	for (attr = grp->attrs; *attr && !error; attr++)
-		error = __sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
+		error = __sysfs_add_file(dir_sd, *attr, SYSFS_FILE);
 	if (error)
 		remove_files(dir_sd, grp);
 	return error;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 95bde29..318e5d5 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -162,7 +162,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 		inode->i_fop = &sysfs_dir_operations;
 		inode->i_nlink = sysfs_count_nlink(sd);
 		break;
-	case SYSFS_KOBJ_ATTR:
+	case SYSFS_FILE:
 		inode->i_size = PAGE_SIZE;
 		inode->i_fop = &sysfs_file_operations;
 		break;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index c57b2dc..4e032eb 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -11,7 +11,7 @@ struct sysfs_elem_symlink {
 	struct sysfs_dirent	*target_sd;
 };
 
-struct sysfs_elem_attr {
+struct sysfs_elem_file {
 	struct attribute	*attr;
 	struct sysfs_open_dirent *open;
 };
@@ -38,7 +38,7 @@ struct sysfs_dirent {
 	union {
 		struct sysfs_elem_dir		s_dir;
 		struct sysfs_elem_symlink	s_symlink;
-		struct sysfs_elem_attr		s_attr;
+		struct sysfs_elem_file		s_file;
 		struct sysfs_elem_bin_attr	s_bin_attr;
 	};
 
@@ -52,7 +52,7 @@ struct sysfs_dirent {
 
 #define SYSFS_TYPE_MASK			0x00ff
 #define SYSFS_DIR			0x0001
-#define SYSFS_KOBJ_ATTR			0x0002
+#define SYSFS_FILE			0x0002
 #define SYSFS_KOBJ_BIN_ATTR		0x0004
 #define SYSFS_KOBJ_LINK			0x0008
 
-- 
1.5.0.3


