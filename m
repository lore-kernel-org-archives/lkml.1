Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbXE1Qh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbXE1Qh1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757738AbXE1Qgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:36:38 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:61264 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXE1Qge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=drku0PQYEzs+KJYpfJkPyabArOPxTwU/qyyUo0QdwbcQlzT4box2E4WUAitWW81KtPmnfbG+ATXnaZfPi2Bx1F5bd+L5FofFcErdWNOl8pDCtZsN/sokqCc+dbrzFe9dwtM8oJC8y5QwetrXh/c+GTsnsYdPBJm4RNiF5JGnNew=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 4/6] sysfs: use sysfs_lock to protect the sysfs_dirent tree
In-Reply-To: <11803701861778-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:36:27 +0900
Message-Id: <1180370187803-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

As kobj sysfs dentries and inodes are gonna be made reclaimable,
i_mutex can't be used to protect sysfs_dirent tree.  Use sysfs_lock
instead.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c     |  107 ++++++++++++++++++++++++++++++++++-----------------
 fs/sysfs/file.c    |   31 +++++++--------
 fs/sysfs/inode.c   |    9 +---
 fs/sysfs/symlink.c |   51 +++++++++++++------------
 fs/sysfs/sysfs.h   |    1 -
 5 files changed, 115 insertions(+), 84 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 58a92aa..a474e54 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -14,7 +14,6 @@
 #include <asm/semaphore.h>
 #include "sysfs.h"
 
-DECLARE_RWSEM(sysfs_rename_sem);
 spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
 spinlock_t kobj_sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
@@ -29,7 +28,7 @@ static DEFINE_IDA(sysfs_ino_ida);
  *	sd->s_parent->s_children.
  *
  *	Locking:
- *	mutex_lock(sd->s_parent->dentry->d_inode->i_mutex)
+ *	spin_lock(sysfs_lock)
  */
 static void sysfs_link_sibling(struct sysfs_dirent *sd)
 {
@@ -48,7 +47,7 @@ static void sysfs_link_sibling(struct sy
  *	sd->s_parent->s_children.
  *
  *	Locking:
- *	mutex_lock(sd->s_parent->dentry->d_inode->i_mutex)
+ *	spin_lock(sysfs_lock)
  */
 static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
@@ -216,6 +215,9 @@ void release_sysfs_dirent(struct sysfs_d
 	struct sysfs_dirent *parent_sd;
 
  repeat:
+	/* Moving/renaming is always done while holding reference.
+	 * sd->s_parent won't change beneath us.
+	 */
 	parent_sd = sd->s_parent;
 
 	if (sysfs_type(sd) & SYSFS_KOBJ_LINK)
@@ -292,19 +294,36 @@ struct sysfs_dirent *sysfs_new_dirent(co
 	return NULL;
 }
 
+/**
+ *	sysfs_attach_dentry - associate sysfs_dirent with dentry
+ *	@sd: target sysfs_dirent
+ *	@dentry: dentry to associate
+ *
+ *	Associate @sd with @dentry.  This is protected by sysfs_lock
+ *	to avoid race with sysfs_d_iput().
+ *
+ *	LOCKING:
+ *	spin_lock(sysfs_lock)
+ */
 static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
 {
 	dentry->d_op = &sysfs_dentry_ops;
 	dentry->d_fsdata = sysfs_get(sd);
-
-	/* protect sd->s_dentry against sysfs_d_iput */
-	spin_lock(&sysfs_lock);
-	sd->s_dentry = dentry;
-	spin_unlock(&sysfs_lock);
-
+	sd->s_dentry = dentry;	/* protected with sysfs_lock */
 	d_rehash(dentry);
 }
 
+/**
+ *	sysfs_attach_dirent - attach sysfs_dirent to its parent and dentry
+ *	@sd: sysfs_dirent to attach
+ *	@parent_sd: parent to attach to (optional)
+ *	@dentry: dentry to be associated to @sd (optional)
+ *
+ *	Attach @sd to @parent_sd and/or @dentry.  Both are optional.
+ *
+ *	LOCKING:
+ *	spin_lock(sysfs_lock)
+ */
 void sysfs_attach_dirent(struct sysfs_dirent *sd,
 			 struct sysfs_dirent *parent_sd, struct dentry *dentry)
 {
@@ -325,7 +344,7 @@ void sysfs_attach_dirent(struct sysfs_di
  *	Look for sysfs_dirent with name @name under @parent_sd.
  *
  *	LOCKING:
- *	mutex_lock(parent->i_mutex)
+ *	spin_lock(sysfs_lock)
  *
  *	RETURNS:
  *	Pointer to sysfs_dirent if found, NULL if not.
@@ -350,7 +369,7 @@ struct sysfs_dirent *sysfs_find_dirent(s
  *	it if found.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep)
+ *	None.  Grabs sysfs_lock.
  *
  *	RETURNS:
  *	Pointer to sysfs_dirent if found, NULL if not.
@@ -360,10 +379,10 @@ struct sysfs_dirent *sysfs_get_dirent(st
 {
 	struct sysfs_dirent *sd;
 
-	mutex_lock(&parent_sd->s_dentry->d_inode->i_mutex);
+	spin_lock(&sysfs_lock);
 	sd = sysfs_find_dirent(parent_sd, name);
 	sysfs_get(sd);
-	mutex_unlock(&parent_sd->s_dentry->d_inode->i_mutex);
+	spin_unlock(&sysfs_lock);
 
 	return sd;
 }
@@ -409,14 +428,20 @@ static int create_dir(struct kobject *ko
 	}
 
 	/* link in */
+	spin_lock(&sysfs_lock);
+
 	error = -EEXIST;
-	if (sysfs_find_dirent(parent_sd, name))
+	if (sysfs_find_dirent(parent_sd, name)) {
+		spin_unlock(&sysfs_lock);
 		goto out_iput;
+	}
 
 	sysfs_instantiate(dentry, inode);
 	inc_nlink(parent->d_inode);
 	sysfs_attach_dirent(sd, parent_sd, dentry);
 
+	spin_unlock(&sysfs_lock);
+
 	*p_sd = sd;
 	error = 0;
 	goto out_unlock;	/* pin directory dentry in core */
@@ -494,6 +519,8 @@ static struct dentry * sysfs_lookup(stru
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	spin_lock(&sysfs_lock);
+
 	if (inode->i_state & I_NEW) {
 		/* initialize inode according to type */
 		switch (sysfs_type(sd)) {
@@ -517,6 +544,8 @@ static struct dentry * sysfs_lookup(stru
 	sysfs_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
 
+	spin_unlock(&sysfs_lock);
+
 	return NULL;
 }
 
@@ -527,17 +556,13 @@ const struct inode_operations sysfs_dir_
 
 static void remove_dir(struct sysfs_dirent *sd)
 {
-	struct dentry *parent = sd->s_parent->s_dentry;
-
-	mutex_lock(&parent->d_inode->i_mutex);
-
+	spin_lock(&sysfs_lock);
 	sysfs_unlink_sibling(sd);
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
+	spin_unlock(&sysfs_lock);
 
 	pr_debug(" o %s removing done\n", sd->s_name);
 
-	mutex_unlock(&parent->d_inode->i_mutex);
-
 	sysfs_drop_dentry(sd);
 	sysfs_deactivate(sd);
 	sysfs_put(sd);
@@ -553,15 +578,12 @@ static void __sysfs_remove_dir(struct sy
 {
 	struct sysfs_dirent *removed = NULL;
 	struct sysfs_dirent **pos;
-	struct dentry *dir;
 
 	if (!dir_sd)
 		return;
 
-	dir = dir_sd->s_dentry;
-
 	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
-	mutex_lock(&dir->d_inode->i_mutex);
+	spin_lock(&sysfs_lock);
 	pos = &dir_sd->s_children;
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
@@ -574,7 +596,7 @@ static void __sysfs_remove_dir(struct sy
 		} else
 			pos = &(*pos)->s_sibling;
 	}
-	mutex_unlock(&dir->d_inode->i_mutex);
+	spin_unlock(&sysfs_lock);
 
 	while (removed) {
 		struct sysfs_dirent *sd = removed;
@@ -622,7 +644,6 @@ int sysfs_rename_dir(struct kobject *kob
 	if (!new_parent_sd)
 		return -EFAULT;
 
-	down_write(&sysfs_rename_sem);
 	mutex_lock(&new_parent->d_inode->i_mutex);
 
 	new_dentry = lookup_one_len(new_name, new_parent, strlen(new_name));
@@ -662,12 +683,16 @@ int sysfs_rename_dir(struct kobject *kob
 	d_add(new_dentry, NULL);
 	d_move(sd->s_dentry, new_dentry);
 
+	spin_lock(&sysfs_lock);
+
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
+	spin_unlock(&sysfs_lock);
+
 	error = 0;
 	goto out_unlock;
 
@@ -679,7 +704,6 @@ int sysfs_rename_dir(struct kobject *kob
 	dput(new_dentry);
  out_unlock:
 	mutex_unlock(&new_parent->d_inode->i_mutex);
-	up_write(&sysfs_rename_sem);
 	return error;
 }
 
@@ -718,12 +742,15 @@ again:
 	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
+	spin_lock(&sysfs_lock);
+
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
+	spin_unlock(&sysfs_lock);
 out:
 	mutex_unlock(&new_parent_dentry->d_inode->i_mutex);
 	mutex_unlock(&old_parent_dentry->d_inode->i_mutex);
@@ -737,11 +764,12 @@ static int sysfs_dir_open(struct inode *
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
 	struct sysfs_dirent * sd;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
 	sd = sysfs_new_dirent("_DIR_", 0, 0);
-	if (sd)
+	if (sd) {
+		spin_lock(&sysfs_lock);
 		sysfs_attach_dirent(sd, parent_sd, NULL);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+		spin_unlock(&sysfs_lock);
+	}
 
 	file->private_data = sd;
 	return sd ? 0 : -ENOMEM;
@@ -749,12 +777,11 @@ static int sysfs_dir_open(struct inode *
 
 static int sysfs_dir_close(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_path.dentry;
 	struct sysfs_dirent * cursor = file->private_data;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
+	spin_lock(&sysfs_lock);
 	sysfs_unlink_sibling(cursor);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	spin_unlock(&sysfs_lock);
 
 	release_sysfs_dirent(cursor);
 
@@ -795,6 +822,8 @@ static int sysfs_readdir(struct file * f
 			i++;
 			/* fallthrough */
 		default:
+			spin_lock(&sysfs_lock);
+
 			pos = &parent_sd->s_children;
 			while (*pos != cursor)
 				pos = &(*pos)->s_sibling;
@@ -827,6 +856,8 @@ static int sysfs_readdir(struct file * f
 			/* put cursor back in */
 			cursor->s_sibling = *pos;
 			*pos = cursor;
+
+			spin_unlock(&sysfs_lock);
 	}
 	return 0;
 }
@@ -835,7 +866,6 @@ static loff_t sysfs_dir_lseek(struct fil
 {
 	struct dentry * dentry = file->f_path.dentry;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (origin) {
 		case 1:
 			offset += file->f_pos;
@@ -843,10 +873,11 @@ static loff_t sysfs_dir_lseek(struct fil
 			if (offset >= 0)
 				break;
 		default:
-			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {
+		spin_lock(&sysfs_lock);
+
 		file->f_pos = offset;
 		if (file->f_pos >= 2) {
 			struct sysfs_dirent *sd = dentry->d_fsdata;
@@ -867,8 +898,10 @@ static loff_t sysfs_dir_lseek(struct fil
 			cursor->s_sibling = *pos;
 			*pos = cursor;
 		}
+
+		spin_unlock(&sysfs_lock);
 	}
-	mutex_unlock(&dentry->d_inode->i_mutex);
+
 	return offset;
 }
 
@@ -934,7 +967,9 @@ struct sysfs_dirent *sysfs_create_shadow
 	sd->s_elem.dir.kobj = kobj;
 	/* point to parent_sd but don't attach to it */
 	sd->s_parent = sysfs_get(parent_sd);
+	spin_lock(&sysfs_lock);
 	sysfs_attach_dirent(sd, NULL, shadow);
+	spin_unlock(&sysfs_lock);
 
 	d_instantiate(shadow, igrab(inode));
 	inc_nlink(inode);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index acc9890..f2e3c88 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -415,29 +415,28 @@ const struct file_operations sysfs_file_
 int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 		   int type)
 {
-	struct dentry *dir = dir_sd->s_dentry;
 	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
 	struct sysfs_dirent *sd;
-	int error = 0;
 
-	mutex_lock(&dir->d_inode->i_mutex);
+	sd = sysfs_new_dirent(attr->name, mode, type);
+	if (!sd)
+		return -ENOMEM;
+	sd->s_elem.attr.attr = (void *)attr;
 
-	if (sysfs_find_dirent(dir_sd, attr->name)) {
-		error = -EEXIST;
-		goto out_unlock;
-	}
+	spin_lock(&sysfs_lock);
 
-	sd = sysfs_new_dirent(attr->name, mode, type);
-	if (!sd) {
-		error = -ENOMEM;
-		goto out_unlock;
+	if (!sysfs_find_dirent(dir_sd, attr->name)) {
+		sysfs_attach_dirent(sd, dir_sd, NULL);
+		sd = NULL;
 	}
-	sd->s_elem.attr.attr = (void *)attr;
-	sysfs_attach_dirent(sd, dir_sd, NULL);
 
- out_unlock:
-	mutex_unlock(&dir->d_inode->i_mutex);
-	return error;
+	spin_unlock(&sysfs_lock);
+
+	if (sd) {
+		sysfs_put(sd);
+		return -EEXIST;
+	}
+	return 0;
 }
 
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 4077ab5..705c03d 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -283,15 +283,11 @@ void sysfs_drop_dentry(struct sysfs_dire
 
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
-	struct dentry *dir = dir_sd->s_dentry;
 	struct sysfs_dirent **pos, *sd;
 	int found = 0;
 
-	if (dir->d_inode == NULL)
-		/* no inode means this hasn't been made visible yet */
-		return -ENOENT;
+	spin_lock(&sysfs_lock);
 
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	for (pos = &dir_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
 
@@ -305,7 +301,8 @@ int sysfs_hash_and_remove(struct sysfs_d
 			break;
 		}
 	}
-	mutex_unlock(&dir->d_inode->i_mutex);
+
+	spin_unlock(&sysfs_lock);
 
 	if (!found)
 		return -ENOENT;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 43cc522..b05f6a6 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -44,20 +44,6 @@ static void fill_object_path(struct sysf
 	}
 }
 
-static int sysfs_add_link(struct sysfs_dirent * parent_sd, const char * name,
-			  struct sysfs_dirent * target_sd)
-{
-	struct sysfs_dirent * sd;
-
-	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
-	if (!sd)
-		return -ENOMEM;
-
-	sd->s_elem.symlink.target_sd = target_sd;
-	sysfs_attach_dirent(sd, parent_sd, NULL);
-	return 0;
-}
-
 /**
  *	sysfs_create_link - create symlink between two objects.
  *	@kobj:	object whose directory we're creating the link in.
@@ -68,7 +54,8 @@ int sysfs_create_link(struct kobject * k
 {
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
-	int error = -EEXIST;
+	struct sysfs_dirent *sd = NULL;
+	int error;
 
 	BUG_ON(!name);
 
@@ -78,8 +65,9 @@ int sysfs_create_link(struct kobject * k
 	} else
 		parent_sd = kobj->sd;
 
+	error = -EFAULT;
 	if (!parent_sd)
-		return -EFAULT;
+		goto out_put;
 
 	/* target->sd can go away beneath us but is protected with
 	 * kobj_sysfs_assoc_lock.  Fetch target_sd from it.
@@ -89,17 +77,30 @@ int sysfs_create_link(struct kobject * k
 		target_sd = sysfs_get(target->sd);
 	spin_unlock(&kobj_sysfs_assoc_lock);
 
+	error = -ENOENT;
 	if (!target_sd)
-		return -ENOENT;
+		goto out_put;
+
+	error = -ENOMEM;
+	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	if (!sd)
+		goto out_put;
+	sd->s_elem.symlink.target_sd = target_sd;
 
-	mutex_lock(&parent_sd->s_dentry->d_inode->i_mutex);
-	if (!sysfs_find_dirent(parent_sd, name))
-		error = sysfs_add_link(parent_sd, name, target_sd);
-	mutex_unlock(&parent_sd->s_dentry->d_inode->i_mutex);
+	spin_lock(&sysfs_lock);
+	error = -EEXIST;
+	if (sysfs_find_dirent(parent_sd, name))
+		goto out_unlock;
+	sysfs_attach_dirent(sd, parent_sd, NULL);
+	spin_unlock(&sysfs_lock);
 
-	if (error)
-		sysfs_put(target_sd);
+	return 0;
 
+ out_unlock:
+	spin_unlock(&sysfs_lock);
+ out_put:
+	sysfs_put(target_sd);
+	sysfs_put(sd);
 	return error;
 }
 
@@ -144,9 +145,9 @@ static int sysfs_getlink(struct dentry *
 	struct sysfs_dirent *target_sd = sd->s_elem.symlink.target_sd;
 	int error;
 
-	down_read(&sysfs_rename_sem);
+	spin_lock(&sysfs_lock);
 	error = sysfs_get_target_path(parent_sd, target_sd, path);
-	up_read(&sysfs_rename_sem);
+	spin_unlock(&sysfs_lock);
 
 	return error;
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 27a5f4b..476d58b 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -83,7 +83,6 @@ extern int sysfs_setattr(struct dentry *
 
 extern spinlock_t sysfs_lock;
 extern spinlock_t kobj_sysfs_assoc_lock;
-extern struct rw_semaphore sysfs_rename_sem;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
 extern const struct file_operations sysfs_file_operations;
-- 
1.4.3.4


