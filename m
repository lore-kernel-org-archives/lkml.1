Return-Path: <linux-kernel-owner+w=401wt.eu-S935592AbXGKX7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935592AbXGKX7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935101AbXGKXhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:14 -0400
Received: from ns2.suse.de ([195.135.220.15]:33519 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935240AbXGKXhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:10 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 56/61] sysfs: use sysfs_mutex to protect the sysfs_dirent tree
Date: Wed, 11 Jul 2007 16:32:15 -0700
Message-Id: <11841970052991-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841970013184-git-send-email-gregkh@suse.de>
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
 <1184196905515-git-send-email-gregkh@suse.de>
 <11841969101299-git-send-email-gregkh@suse.de>
 <11841969142368-git-send-email-gregkh@suse.de>
 <11841969191116-git-send-email-gregkh@suse.de>
 <118419692665-git-send-email-gregkh@suse.de>
 <11841969323515-git-send-email-gregkh@suse.de>
 <11841969361535-git-send-email-gregkh@suse.de>
 <11841969401152-git-send-email-gregkh@suse.de>
 <11841969453004-git-send-email-gregkh@suse.de>
 <11841969502188-git-send-email-gregkh@suse.de>
 <1184196954330-git-send-email-gregkh@suse.de>
 <11841969641445-git-send-email-gregkh@suse.de>
 <1184196968712-git-send-email-gregkh@suse.de>
 <11841969731234-git-send-email-gregkh@suse.de>
 <11841969771935-git-send-email-gregkh@suse.de>
 <11841969814023-git-send-email-gregkh@suse.de>
 <11841969873230-git-send-email-gregkh@suse.de>
 <11841969912096-git-send-email-gregkh@suse.de>
 <1184196995958-git-send-email-gregkh@suse.de>
 <11841970013184-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

As kobj sysfs dentries and inodes are gonna be made reclaimable,
i_mutex can't be used to protect sysfs_dirent tree.  Use sysfs_mutex
globally instead.  As the whole tree is protected with sysfs_mutex,
there is no reason to keep sysfs_rename_sem.  Drop it.

While at it, add docbook comments to functions which require
sysfs_mutex locking.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |  101 ++++++++++++++++++++++++++++++++++++---------------
 fs/sysfs/file.c    |   31 ++++++++--------
 fs/sysfs/inode.c   |   11 ++----
 fs/sysfs/symlink.c |   51 +++++++++++++-------------
 fs/sysfs/sysfs.h   |    2 +-
 5 files changed, 116 insertions(+), 80 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1b56434..9fc8558 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -14,7 +14,7 @@
 #include <asm/semaphore.h>
 #include "sysfs.h"
 
-DECLARE_RWSEM(sysfs_rename_sem);
+DEFINE_MUTEX(sysfs_mutex);
 spinlock_t sysfs_assoc_lock = SPIN_LOCK_UNLOCKED;
 
 static spinlock_t sysfs_ino_lock = SPIN_LOCK_UNLOCKED;
@@ -28,7 +28,7 @@ static DEFINE_IDA(sysfs_ino_ida);
  *	sd->s_parent->s_children.
  *
  *	Locking:
- *	mutex_lock(sd->s_parent->dentry->d_inode->i_mutex)
+ *	mutex_lock(sysfs_mutex)
  */
 static void sysfs_link_sibling(struct sysfs_dirent *sd)
 {
@@ -47,7 +47,7 @@ static void sysfs_link_sibling(struct sysfs_dirent *sd)
  *	sd->s_parent->s_children.
  *
  *	Locking:
- *	mutex_lock(sd->s_parent->dentry->d_inode->i_mutex)
+ *	mutex_lock(sysfs_mutex)
  */
 static void sysfs_unlink_sibling(struct sysfs_dirent *sd)
 {
@@ -215,6 +215,9 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	struct sysfs_dirent *parent_sd;
 
  repeat:
+	/* Moving/renaming is always done while holding reference.
+	 * sd->s_parent won't change beneath us.
+	 */
 	parent_sd = sd->s_parent;
 
 	if (sysfs_type(sd) == SYSFS_KOBJ_LINK)
@@ -291,6 +294,17 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 	return NULL;
 }
 
+/**
+ *	sysfs_attach_dentry - associate sysfs_dirent with dentry
+ *	@sd: target sysfs_dirent
+ *	@dentry: dentry to associate
+ *
+ *	Associate @sd with @dentry.  This is protected by
+ *	sysfs_assoc_lock to avoid race with sysfs_d_iput().
+ *
+ *	LOCKING:
+ *	mutex_lock(sysfs_mutex)
+ */
 static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
 {
 	dentry->d_op = &sysfs_dentry_ops;
@@ -304,6 +318,17 @@ static void sysfs_attach_dentry(struct sysfs_dirent *sd, struct dentry *dentry)
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
+ *	mutex_lock(sysfs_mutex)
+ */
 void sysfs_attach_dirent(struct sysfs_dirent *sd,
 			 struct sysfs_dirent *parent_sd, struct dentry *dentry)
 {
@@ -324,7 +349,7 @@ void sysfs_attach_dirent(struct sysfs_dirent *sd,
  *	Look for sysfs_dirent with name @name under @parent_sd.
  *
  *	LOCKING:
- *	mutex_lock(parent->i_mutex)
+ *	mutex_lock(sysfs_mutex)
  *
  *	RETURNS:
  *	Pointer to sysfs_dirent if found, NULL if not.
@@ -349,7 +374,7 @@ struct sysfs_dirent *sysfs_find_dirent(struct sysfs_dirent *parent_sd,
  *	it if found.
  *
  *	LOCKING:
- *	Kernel thread context (may sleep)
+ *	Kernel thread context (may sleep).  Grabs sysfs_mutex.
  *
  *	RETURNS:
  *	Pointer to sysfs_dirent if found, NULL if not.
@@ -359,10 +384,10 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 {
 	struct sysfs_dirent *sd;
 
-	mutex_lock(&parent_sd->s_dentry->d_inode->i_mutex);
+	mutex_lock(&sysfs_mutex);
 	sd = sysfs_find_dirent(parent_sd, name);
 	sysfs_get(sd);
-	mutex_unlock(&parent_sd->s_dentry->d_inode->i_mutex);
+	mutex_unlock(&sysfs_mutex);
 
 	return sd;
 }
@@ -408,14 +433,20 @@ static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 	}
 
 	/* link in */
+	mutex_lock(&sysfs_mutex);
+
 	error = -EEXIST;
-	if (sysfs_find_dirent(parent_sd, name))
+	if (sysfs_find_dirent(parent_sd, name)) {
+		mutex_unlock(&sysfs_mutex);
 		goto out_iput;
+	}
 
 	sysfs_instantiate(dentry, inode);
 	inc_nlink(parent->d_inode);
 	sysfs_attach_dirent(sd, parent_sd, dentry);
 
+	mutex_unlock(&sysfs_mutex);
+
 	*p_sd = sd;
 	error = 0;
 	goto out_unlock;	/* pin directory dentry in core */
@@ -493,6 +524,8 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_lock(&sysfs_mutex);
+
 	if (inode->i_state & I_NEW) {
 		/* initialize inode according to type */
 		switch (sysfs_type(sd)) {
@@ -516,6 +549,8 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	sysfs_instantiate(dentry, inode);
 	sysfs_attach_dentry(sd, dentry);
 
+	mutex_unlock(&sysfs_mutex);
+
 	return NULL;
 }
 
@@ -526,17 +561,13 @@ const struct inode_operations sysfs_dir_inode_operations = {
 
 static void remove_dir(struct sysfs_dirent *sd)
 {
-	struct dentry *parent = sd->s_parent->s_dentry;
-
-	mutex_lock(&parent->d_inode->i_mutex);
-
+	mutex_lock(&sysfs_mutex);
 	sysfs_unlink_sibling(sd);
 	sd->s_flags |= SYSFS_FLAG_REMOVED;
+	mutex_unlock(&sysfs_mutex);
 
 	pr_debug(" o %s removing done\n", sd->s_name);
 
-	mutex_unlock(&parent->d_inode->i_mutex);
-
 	sysfs_drop_dentry(sd);
 	sysfs_deactivate(sd);
 	sysfs_put(sd);
@@ -552,15 +583,12 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
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
+	mutex_lock(&sysfs_mutex);
 	pos = &dir_sd->s_children;
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
@@ -573,7 +601,7 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 		} else
 			pos = &(*pos)->s_sibling;
 	}
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&sysfs_mutex);
 
 	while (removed) {
 		struct sysfs_dirent *sd = removed;
@@ -621,7 +649,6 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 	if (!new_parent_sd)
 		return -EFAULT;
 
-	down_write(&sysfs_rename_sem);
 	mutex_lock(&new_parent->d_inode->i_mutex);
 
 	new_dentry = lookup_one_len(new_name, new_parent, strlen(new_name));
@@ -661,12 +688,16 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 	d_add(new_dentry, NULL);
 	d_move(sd->s_dentry, new_dentry);
 
+	mutex_lock(&sysfs_mutex);
+
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
+	mutex_unlock(&sysfs_mutex);
+
 	error = 0;
 	goto out_unlock;
 
@@ -678,7 +709,6 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 	dput(new_dentry);
  out_unlock:
 	mutex_unlock(&new_parent->d_inode->i_mutex);
-	up_write(&sysfs_rename_sem);
 	return error;
 }
 
@@ -717,12 +747,15 @@ again:
 	dput(new_dentry);
 
 	/* Remove from old parent's list and insert into new parent's list. */
+	mutex_lock(&sysfs_mutex);
+
 	sysfs_unlink_sibling(sd);
 	sysfs_get(new_parent_sd);
 	sysfs_put(sd->s_parent);
 	sd->s_parent = new_parent_sd;
 	sysfs_link_sibling(sd);
 
+	mutex_unlock(&sysfs_mutex);
 out:
 	mutex_unlock(&new_parent_dentry->d_inode->i_mutex);
 	mutex_unlock(&old_parent_dentry->d_inode->i_mutex);
@@ -736,11 +769,12 @@ static int sysfs_dir_open(struct inode *inode, struct file *file)
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
 	struct sysfs_dirent * sd;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
 	sd = sysfs_new_dirent("_DIR_", 0, 0);
-	if (sd)
+	if (sd) {
+		mutex_lock(&sysfs_mutex);
 		sysfs_attach_dirent(sd, parent_sd, NULL);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+		mutex_unlock(&sysfs_mutex);
+	}
 
 	file->private_data = sd;
 	return sd ? 0 : -ENOMEM;
@@ -748,12 +782,11 @@ static int sysfs_dir_open(struct inode *inode, struct file *file)
 
 static int sysfs_dir_close(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_path.dentry;
 	struct sysfs_dirent * cursor = file->private_data;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
+	mutex_lock(&sysfs_mutex);
 	sysfs_unlink_sibling(cursor);
-	mutex_unlock(&dentry->d_inode->i_mutex);
+	mutex_unlock(&sysfs_mutex);
 
 	release_sysfs_dirent(cursor);
 
@@ -794,6 +827,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			i++;
 			/* fallthrough */
 		default:
+			mutex_lock(&sysfs_mutex);
+
 			pos = &parent_sd->s_children;
 			while (*pos != cursor)
 				pos = &(*pos)->s_sibling;
@@ -826,6 +861,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			/* put cursor back in */
 			cursor->s_sibling = *pos;
 			*pos = cursor;
+
+			mutex_unlock(&sysfs_mutex);
 	}
 	return 0;
 }
@@ -834,7 +871,6 @@ static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
 {
 	struct dentry * dentry = file->f_path.dentry;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
 	switch (origin) {
 		case 1:
 			offset += file->f_pos;
@@ -842,10 +878,11 @@ static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
 			if (offset >= 0)
 				break;
 		default:
-			mutex_unlock(&file->f_path.dentry->d_inode->i_mutex);
 			return -EINVAL;
 	}
 	if (offset != file->f_pos) {
+		mutex_lock(&sysfs_mutex);
+
 		file->f_pos = offset;
 		if (file->f_pos >= 2) {
 			struct sysfs_dirent *sd = dentry->d_fsdata;
@@ -866,8 +903,10 @@ static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
 			cursor->s_sibling = *pos;
 			*pos = cursor;
 		}
+
+		mutex_unlock(&sysfs_mutex);
 	}
-	mutex_unlock(&dentry->d_inode->i_mutex);
+
 	return offset;
 }
 
@@ -933,7 +972,9 @@ struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj)
 	sd->s_elem.dir.kobj = kobj;
 	/* point to parent_sd but don't attach to it */
 	sd->s_parent = sysfs_get(parent_sd);
+	mutex_lock(&sysfs_mutex);
 	sysfs_attach_dirent(sd, NULL, shadow);
+	mutex_unlock(&sysfs_mutex);
 
 	d_instantiate(shadow, igrab(inode));
 	inc_nlink(inode);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 20703b9..d0deed3 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -415,29 +415,28 @@ const struct file_operations sysfs_file_operations = {
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
+	mutex_lock(&sysfs_mutex);
 
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
+	mutex_unlock(&sysfs_mutex);
+
+	if (sd) {
+		sysfs_put(sd);
+		return -EEXIST;
+	}
+	return 0;
 }
 
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index e4c2393..d439c0b 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -277,20 +277,14 @@ void sysfs_drop_dentry(struct sysfs_dirent *sd)
 
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 {
-	struct dentry *dir;
 	struct sysfs_dirent **pos, *sd;
 	int found = 0;
 
 	if (!dir_sd)
 		return -ENOENT;
 
-	dir = dir_sd->s_dentry;
+	mutex_lock(&sysfs_mutex);
 
-	if (dir->d_inode == NULL)
-		/* no inode means this hasn't been made visible yet */
-		return -ENOENT;
-
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	for (pos = &dir_sd->s_children; *pos; pos = &(*pos)->s_sibling) {
 		sd = *pos;
 
@@ -304,7 +298,8 @@ int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name)
 			break;
 		}
 	}
-	mutex_unlock(&dir->d_inode->i_mutex);
+
+	mutex_unlock(&sysfs_mutex);
 
 	if (!found)
 		return -ENOENT;
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index cbd95a4..683316f 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -44,20 +44,6 @@ static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
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
@@ -68,7 +54,8 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 {
 	struct sysfs_dirent *parent_sd = NULL;
 	struct sysfs_dirent *target_sd = NULL;
-	int error = -EEXIST;
+	struct sysfs_dirent *sd = NULL;
+	int error;
 
 	BUG_ON(!name);
 
@@ -78,8 +65,9 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	} else
 		parent_sd = kobj->sd;
 
+	error = -EFAULT;
 	if (!parent_sd)
-		return -EFAULT;
+		goto out_put;
 
 	/* target->sd can go away beneath us but is protected with
 	 * sysfs_assoc_lock.  Fetch target_sd from it.
@@ -89,17 +77,30 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 		target_sd = sysfs_get(target->sd);
 	spin_unlock(&sysfs_assoc_lock);
 
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
+	mutex_lock(&sysfs_mutex);
+	error = -EEXIST;
+	if (sysfs_find_dirent(parent_sd, name))
+		goto out_unlock;
+	sysfs_attach_dirent(sd, parent_sd, NULL);
+	mutex_unlock(&sysfs_mutex);
 
-	if (error)
-		sysfs_put(target_sd);
+	return 0;
 
+ out_unlock:
+	mutex_unlock(&sysfs_mutex);
+ out_put:
+	sysfs_put(target_sd);
+	sysfs_put(sd);
 	return error;
 }
 
@@ -144,9 +145,9 @@ static int sysfs_getlink(struct dentry *dentry, char * path)
 	struct sysfs_dirent *target_sd = sd->s_elem.symlink.target_sd;
 	int error;
 
-	down_read(&sysfs_rename_sem);
+	mutex_lock(&sysfs_mutex);
 	error = sysfs_get_target_path(parent_sd, target_sd, path);
-	up_read(&sysfs_rename_sem);
+	mutex_unlock(&sysfs_mutex);
 
 	return error;
 }
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 4572677..2605161 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -82,7 +82,7 @@ extern void sysfs_drop_dentry(struct sysfs_dirent *sd);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
 extern spinlock_t sysfs_assoc_lock;
-extern struct rw_semaphore sysfs_rename_sem;
+extern struct mutex sysfs_mutex;
 extern struct super_block * sysfs_sb;
 extern const struct file_operations sysfs_dir_operations;
 extern const struct file_operations sysfs_file_operations;
-- 
1.5.2.2

