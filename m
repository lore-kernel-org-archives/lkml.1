Return-Path: <linux-kernel-owner+w=401wt.eu-S1763286AbXE1QiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763286AbXE1QiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759028AbXE1Qgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:36:42 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:61264 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbXE1Qgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=AWxSYP5MjKMvtBV9Yx/Tq6vx4tXKyJQp44A/2Q780RLSpZVqJMIpDMSMrDkmaUfVv1XEnwkNSv2KaxMa75SzQy0bt4k67rv8F+MG3z06BSe+Su6NSR8eDbCjzV3rcQfYxHvHTBIHxfVKyQdsCXL0jM6GFzr1A+v4/EaHr5XIKTw=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 6/6] sysfs: make directory dentries and inodes reclaimable
In-Reply-To: <11803701861778-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Tue, 29 May 2007 01:36:27 +0900
Message-Id: <11803701872730-git-send-email-htejun@gmail.com>
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

This patch makes dentries and inodes for sysfs directories
reclaimable.

* sysfs_notify() is modified to walk sysfs_dirent tree instead of
  dentry tree.
* sysfs_update_file() and sysfs_chmod_file() use sysfs_get_dentry() to
  grab the victim dentry.
* sysfs_rename_dir() and sysfs_move_dir() grab all dentries using
  sysfs_get_dentry() on startup.
* Dentries for all shadowed directories are pinned in memory to serve
  as lookup start point.
* parent mtime/ctime update on inode instantiation is dropped.  I' not
  sure what to do about it yet.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |  238 ++++++++++++++++++++++++++++---------------------
 fs/sysfs/file.c       |  134 ++++++++++++---------------
 fs/sysfs/inode.c      |   15 +--
 fs/sysfs/mount.c      |    2 +-
 fs/sysfs/sysfs.h      |    1 +
 include/linux/sysfs.h |    1 -
 6 files changed, 202 insertions(+), 189 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 0242cbd..ae1f379 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -482,73 +482,46 @@ struct sysfs_dirent *sysfs_get_dirent(st
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
 {
-	struct dentry *parent = parent_sd->s_dentry;
-	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
-	struct dentry *dentry;
-	struct inode *inode;
+	struct dentry *parent_dentry = NULL;
 	struct sysfs_dirent *sd;
-
-	mutex_lock(&parent->d_inode->i_mutex);
+	int error;
 
 	/* allocate */
-	dentry = lookup_one_len(name, parent, strlen(name));
-	if (IS_ERR(dentry)) {
-		error = PTR_ERR(dentry);
-		goto out_unlock;
-	}
-
-	error = -EEXIST;
-	if (dentry->d_inode)
-		goto out_dput;
-
-	error = -ENOMEM;
 	sd = sysfs_new_dirent(name, mode, SYSFS_DIR);
 	if (!sd)
-		goto out_drop;
+		return -ENOMEM;
 	sd->s_elem.dir.kobj = kobj;
 
-	inode = sysfs_get_inode(sd);
-	if (!inode)
-		goto out_sput;
-
-	if (inode->i_state & I_NEW) {
-		inode->i_op = &sysfs_dir_inode_operations;
-		inode->i_fop = &sysfs_dir_operations;
-		/* directory inodes start off with i_nlink == 2 (for ".") */
-		inc_nlink(inode);
-	}
-
 	/* link in */
+	error = -EEXIST;
 	spin_lock(&sysfs_lock);
+	if (!sysfs_find_dirent(parent_sd, name)) {
+		sysfs_attach_dirent(sd, parent_sd, NULL);
+		error = 0;
 
-	error = -EEXIST;
-	if (sysfs_find_dirent(parent_sd, name)) {
-		spin_unlock(&sysfs_lock);
-		goto out_iput;
+		spin_lock(&dcache_lock);
+		if (parent_sd->s_dentry && parent_sd->s_dentry->d_inode)
+			parent_dentry = dget_locked(parent_sd->s_dentry);
+		spin_unlock(&dcache_lock);
 	}
+	spin_unlock(&sysfs_lock);
 
-	sysfs_instantiate(dentry, inode);
-	inc_nlink(parent->d_inode);
-	sysfs_attach_dirent(sd, parent_sd, dentry);
+	if (error) {
+		sysfs_put(sd);
+		return error;
+	}
 
-	spin_unlock(&sysfs_lock);
+	/* adjust nlink of parent */
+	if (parent_dentry) {
+		mutex_lock(&parent_dentry->d_inode->i_mutex);
+		inc_nlink(parent_dentry->d_inode);
+		mutex_unlock(&parent_dentry->d_inode->i_mutex);
+		dput(parent_dentry);
+	}
 
 	*p_sd = sd;
-	error = 0;
-	goto out_unlock;	/* pin directory dentry in core */
-
- out_iput:
-	iput(inode);
- out_sput:
-	sysfs_put(sd);
- out_drop:
-	d_drop(dentry);
- out_dput:
-	dput(dentry);
- out_unlock:
-	mutex_unlock(&parent->d_inode->i_mutex);
-	return error;
+	return 0;
 }
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
@@ -582,9 +555,21 @@ int sysfs_create_dir(struct kobject * ko
 	error = create_dir(kobj, parent_sd, kobject_name(kobj), &sd);
 	if (!error)
 		kobj->sd = sd;
+
 	return error;
 }
 
+static int sysfs_nr_subdirs(struct sysfs_dirent *sd)
+{
+	struct sysfs_dirent *child;
+	int nr = 0;
+
+	for (child = sd->s_children; child; child = child->s_sibling)
+		if (sysfs_type(child) & SYSFS_DIR)
+			nr++;
+	return nr;
+}
+
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
@@ -595,7 +580,7 @@ static struct dentry * sysfs_lookup(stru
 	int found = 0;
 
 	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if ((sysfs_type(sd) & SYSFS_NOT_PINNED) &&
+		if (sysfs_type(sd) &&
 		    !strcmp(sd->s_name, dentry->d_name.name)) {
 			found = 1;
 			break;
@@ -616,6 +601,11 @@ static struct dentry * sysfs_lookup(stru
 	if (inode->i_state & I_NEW) {
 		/* initialize inode according to type */
 		switch (sysfs_type(sd)) {
+		case SYSFS_DIR:
+			inode->i_op = &sysfs_dir_inode_operations;
+			inode->i_fop = &sysfs_dir_operations;
+			inode->i_nlink = 2 + sysfs_nr_subdirs(sd);
+			break;
 		case SYSFS_KOBJ_ATTR:
 			inode->i_size = PAGE_SIZE;
 			inode->i_fop = &sysfs_file_operations;
@@ -680,7 +670,7 @@ static void __sysfs_remove_dir(struct sy
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
-		if (sysfs_type(sd) && (sysfs_type(sd) & SYSFS_NOT_PINNED)) {
+		if (sysfs_type(sd) && !(sysfs_type(sd) & SYSFS_DIR)) {
 			sd->s_flags |= SYSFS_FLAG_REMOVED;
 			*pos = sd->s_sibling;
 			sd->s_sibling = removed;
@@ -728,14 +718,25 @@ int sysfs_rename_dir(struct kobject *kob
 		     const char *new_name)
 {
 	struct sysfs_dirent *sd = kobj->sd;
-	struct dentry *new_parent = new_parent_sd->s_dentry;
-	struct dentry *new_dentry;
-	char *dup_name;
+	struct dentry *new_parent = NULL;
+	struct dentry *old_dentry = NULL, *new_dentry = NULL;
+	const char *dup_name = NULL;
 	int error;
 
-	if (!new_parent_sd)
-		return -EFAULT;
+	/* get dentries */
+	old_dentry = sysfs_get_dentry(sd);
+	if (IS_ERR(old_dentry)) {
+		error = PTR_ERR(old_dentry);
+		goto out_dput;
+	}
+
+	new_parent = sysfs_get_dentry(new_parent_sd);
+	if (IS_ERR(new_parent)) {
+		error = PTR_ERR(new_parent);
+		goto out_dput;
+	}
 
+	/* lock new_parent and get dentry for new name */
 	mutex_lock(&new_parent->d_inode->i_mutex);
 
 	new_dentry = lookup_one_len(new_name, new_parent, strlen(new_name));
@@ -749,14 +750,14 @@ int sysfs_rename_dir(struct kobject *kob
 	 * shadows of the same directory
 	 */
 	error = -EINVAL;
-	if (sd->s_parent->s_dentry->d_inode != new_parent->d_inode ||
+	if (old_dentry->d_parent->d_inode != new_parent->d_inode ||
 	    new_dentry->d_parent->d_inode != new_parent->d_inode ||
-	    new_dentry == sd->s_dentry)
-		goto out_dput;
+	    old_dentry == new_dentry)
+		goto out_unlock;
 
 	error = -EEXIST;
 	if (new_dentry->d_inode)
-		goto out_dput;
+		goto out_unlock;
 
 	/* rename kobject and sysfs_dirent */
 	error = -ENOMEM;
@@ -766,9 +767,9 @@ int sysfs_rename_dir(struct kobject *kob
 
 	error = kobject_set_name(kobj, "%s", new_name);
 	if (error)
-		goto out_free;
+		goto out_drop;
 
-	kfree(sd->s_name);
+	dup_name = sd->s_name;
 	sd->s_name = new_name;
 
 	/* move under the new parent */
@@ -788,45 +789,58 @@ int sysfs_rename_dir(struct kobject *kob
 	error = 0;
 	goto out_unlock;
 
- out_free:
-	kfree(dup_name);
  out_drop:
 	d_drop(new_dentry);
- out_dput:
-	dput(new_dentry);
  out_unlock:
 	mutex_unlock(&new_parent->d_inode->i_mutex);
+ out_dput:
+	kfree(dup_name);
+	dput(new_parent);
+	dput(old_dentry);
+	dput(new_dentry);
 	return error;
 }
 
-int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent)
+int sysfs_move_dir(struct kobject *kobj, struct kobject *new_parent_kobj)
 {
-	struct dentry *old_parent_dentry, *new_parent_dentry, *new_dentry;
-	struct sysfs_dirent *new_parent_sd, *sd;
+	struct sysfs_dirent *sd = kobj->sd;
+	struct sysfs_dirent *new_parent_sd;
+	struct dentry *old_parent, *new_parent = NULL;
+	struct dentry *old_dentry = NULL, *new_dentry = NULL;
 	int error;
 
-	old_parent_dentry = kobj->parent ?
-		kobj->parent->sd->s_dentry : sysfs_mount->mnt_sb->s_root;
-	new_parent_dentry = new_parent ?
-		new_parent->sd->s_dentry : sysfs_mount->mnt_sb->s_root;
+	BUG_ON(!sd->s_parent);
+	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
+
+	/* get dentries */
+	old_dentry = sysfs_get_dentry(sd);
+	if (IS_ERR(old_dentry)) {
+		error = PTR_ERR(old_dentry);
+		goto out_dput;
+	}
+	old_parent = sd->s_parent->s_dentry;
+
+	new_parent = sysfs_get_dentry(new_parent_sd);
+	if (IS_ERR(new_parent)) {
+		error = PTR_ERR(new_parent);
+		goto out_dput;
+	}
 
-	if (old_parent_dentry->d_inode == new_parent_dentry->d_inode)
-		return 0;	/* nothing to move */
+	if (old_parent->d_inode == new_parent->d_inode) {
+		error = 0;
+		goto out_dput;	/* nothing to move */
+	}
 again:
-	mutex_lock(&old_parent_dentry->d_inode->i_mutex);
-	if (!mutex_trylock(&new_parent_dentry->d_inode->i_mutex)) {
-		mutex_unlock(&old_parent_dentry->d_inode->i_mutex);
+	mutex_lock(&old_parent->d_inode->i_mutex);
+	if (!mutex_trylock(&new_parent->d_inode->i_mutex)) {
+		mutex_unlock(&old_parent->d_inode->i_mutex);
 		goto again;
 	}
 
-	new_parent_sd = new_parent_dentry->d_fsdata;
-	sd = kobj->sd;
-
-	new_dentry = lookup_one_len(kobj->name, new_parent_dentry,
-				    strlen(kobj->name));
+	new_dentry = lookup_one_len(kobj->name, new_parent, strlen(kobj->name));
 	if (IS_ERR(new_dentry)) {
 		error = PTR_ERR(new_dentry);
-		goto out;
+		goto out_unlock;
 	} else
 		error = 0;
 	d_add(new_dentry, NULL);
@@ -843,10 +857,14 @@ again:
 	sysfs_link_sibling(sd);
 
 	spin_unlock(&sysfs_lock);
-out:
-	mutex_unlock(&new_parent_dentry->d_inode->i_mutex);
-	mutex_unlock(&old_parent_dentry->d_inode->i_mutex);
 
+ out_unlock:
+	mutex_unlock(&new_parent->d_inode->i_mutex);
+	mutex_unlock(&old_parent->d_inode->i_mutex);
+ out_dput:
+	dput(new_parent);
+	dput(old_dentry);
+	dput(new_dentry);
 	return error;
 }
 
@@ -1006,12 +1024,20 @@ static loff_t sysfs_dir_lseek(struct fil
 int sysfs_make_shadowed_dir(struct kobject *kobj,
 	void * (*follow_link)(struct dentry *, struct nameidata *))
 {
+	struct dentry *dentry;
 	struct inode *inode;
 	struct inode_operations *i_op;
 
-	inode = kobj->sd->s_dentry->d_inode;
-	if (inode->i_op != &sysfs_dir_inode_operations)
+	/* get dentry for @kobj->sd, dentry of a shadowed dir is pinned */
+	dentry = sysfs_get_dentry(kobj->sd);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	inode = dentry->d_inode;
+	if (inode->i_op != &sysfs_dir_inode_operations) {
+		dput(dentry);
 		return -EINVAL;
+	}
 
 	i_op = kmalloc(sizeof(*i_op), GFP_KERNEL);
 	if (!i_op)
@@ -1038,16 +1064,22 @@ int sysfs_make_shadowed_dir(struct kobje
 
 struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj)
 {
-	struct dentry *dir = kobj->sd->s_dentry;
-	struct inode *inode = dir->d_inode;
-	struct dentry *parent = dir->d_parent;
-	struct sysfs_dirent *parent_sd = parent->d_fsdata;
-	struct dentry *shadow;
+	struct sysfs_dirent *parent_sd = kobj->sd->s_parent;
+	struct dentry *dir, *parent, *shadow;
+	struct inode *inode;
 	struct sysfs_dirent *sd;
 
+	dir = sysfs_get_dentry(kobj->sd);
+	if (IS_ERR(dir)) {
+		sd = (void *)dir;
+		goto out;
+	}
+	parent = dir->d_parent;
+
+	inode = dir->d_inode;
 	sd = ERR_PTR(-EINVAL);
 	if (!sysfs_is_shadowed_inode(inode))
-		goto out;
+		goto out_dput;
 
 	shadow = d_alloc(parent, &dir->d_name);
 	if (!shadow)
@@ -1066,15 +1098,17 @@ struct sysfs_dirent *sysfs_create_shadow
 	d_instantiate(shadow, igrab(inode));
 	inc_nlink(inode);
 	inc_nlink(parent->d_inode);
-
 	dget(shadow);		/* Extra count - pin the dentry in core */
 
-out:
-	return sd;
-nomem:
+	goto out_dput;
+
+ nomem:
 	dput(shadow);
 	sd = ERR_PTR(-ENOMEM);
-	goto out;
+ out_dput:
+	dput(dir);
+ out:
+	return sd;
 }
 
 /**
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index f2e3c88..1b0c441 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -362,43 +362,22 @@ static unsigned int sysfs_poll(struct fi
 	return POLLERR|POLLPRI;
 }
 
-
-static struct dentry *step_down(struct dentry *dir, const char * name)
-{
-	struct dentry * de;
-
-	if (dir == NULL || dir->d_inode == NULL)
-		return NULL;
-
-	mutex_lock(&dir->d_inode->i_mutex);
-	de = lookup_one_len(name, dir, strlen(name));
-	mutex_unlock(&dir->d_inode->i_mutex);
-	dput(dir);
-	if (IS_ERR(de))
-		return NULL;
-	if (de->d_inode == NULL) {
-		dput(de);
-		return NULL;
-	}
-	return de;
-}
-
 void sysfs_notify(struct kobject * k, char *dir, char *attr)
 {
-	struct dentry *de = k->sd->s_dentry;
-	if (de)
-		dget(de);
-	if (de && dir)
-		de = step_down(de, dir);
-	if (de && attr)
-		de = step_down(de, attr);
-	if (de) {
-		struct sysfs_dirent * sd = de->d_fsdata;
-		if (sd)
-			atomic_inc(&sd->s_event);
+	struct sysfs_dirent *sd = k->sd;
+
+	spin_lock(&sysfs_lock);
+
+	if (sd && dir)
+		sd = sysfs_find_dirent(sd, dir);
+	if (sd && attr)
+		sd = sysfs_find_dirent(sd, attr);
+	if (sd) {
+		atomic_inc(&sd->s_event);
 		wake_up_interruptible(&k->poll);
-		dput(de);
 	}
+
+	spin_unlock(&sysfs_lock);
 }
 EXPORT_SYMBOL_GPL(sysfs_notify);
 
@@ -486,30 +465,31 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_grou
  */
 int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
 {
-	struct dentry * dir = kobj->sd->s_dentry;
-	struct dentry * victim;
-	int res = -ENOENT;
-
-	mutex_lock(&dir->d_inode->i_mutex);
-	victim = lookup_one_len(attr->name, dir, strlen(attr->name));
-	if (!IS_ERR(victim)) {
-		/* make sure dentry is really there */
-		if (victim->d_inode && 
-		    (victim->d_parent->d_inode == dir->d_inode)) {
-			victim->d_inode->i_mtime = CURRENT_TIME;
-			fsnotify_modify(victim);
-			res = 0;
-		} else
-			d_drop(victim);
-		
-		/**
-		 * Drop the reference acquired from lookup_one_len() above.
-		 */
-		dput(victim);
+	struct sysfs_dirent *victim_sd = NULL;
+	struct dentry *victim = NULL;
+	int rc;
+
+	rc = -ENOENT;
+	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
+	if (!victim_sd)
+		goto out;
+
+	victim = sysfs_get_dentry(victim_sd);
+	if (IS_ERR(victim)) {
+		rc = PTR_ERR(victim);
+		victim = NULL;
+		goto out;
 	}
-	mutex_unlock(&dir->d_inode->i_mutex);
 
-	return res;
+	mutex_lock(&victim->d_inode->i_mutex);
+	victim->d_inode->i_mtime = CURRENT_TIME;
+	fsnotify_modify(victim);
+	mutex_unlock(&victim->d_inode->i_mutex);
+	rc = 0;
+ out:
+	dput(victim);
+	sysfs_put(victim_sd);
+	return rc;
 }
 
 
@@ -522,30 +502,34 @@ int sysfs_update_file(struct kobject * k
  */
 int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 {
-	struct dentry *dir = kobj->sd->s_dentry;
-	struct dentry *victim;
+	struct sysfs_dirent *victim_sd = NULL;
+	struct dentry *victim = NULL;
 	struct inode * inode;
 	struct iattr newattrs;
-	int res = -ENOENT;
-
-	mutex_lock(&dir->d_inode->i_mutex);
-	victim = lookup_one_len(attr->name, dir, strlen(attr->name));
-	if (!IS_ERR(victim)) {
-		if (victim->d_inode &&
-		    (victim->d_parent->d_inode == dir->d_inode)) {
-			inode = victim->d_inode;
-			mutex_lock(&inode->i_mutex);
-			newattrs.ia_mode = (mode & S_IALLUGO) |
-						(inode->i_mode & ~S_IALLUGO);
-			newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
-			res = notify_change(victim, &newattrs);
-			mutex_unlock(&inode->i_mutex);
-		}
-		dput(victim);
+	int rc;
+
+	rc = -ENOENT;
+	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
+	if (!victim_sd)
+		goto out;
+
+	victim = sysfs_get_dentry(victim_sd);
+	if (IS_ERR(victim)) {
+		rc = PTR_ERR(victim);
+		victim = NULL;
+		goto out;
 	}
-	mutex_unlock(&dir->d_inode->i_mutex);
 
-	return res;
+	inode = victim->d_inode;
+	mutex_lock(&inode->i_mutex);
+	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
+	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+	rc = notify_change(victim, &newattrs);
+	mutex_unlock(&inode->i_mutex);
+ out:
+	dput(victim);
+	sysfs_put(victim_sd);
+	return rc;
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
 
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 705c03d..e71d763 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -190,15 +190,9 @@ void sysfs_instantiate(struct dentry *de
 {
 	BUG_ON(!dentry || dentry->d_inode);
 
-	if (inode->i_state & I_NEW) {
+	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 
-		if (dentry->d_parent && dentry->d_parent->d_inode) {
-			struct inode *p_inode = dentry->d_parent->d_inode;
-			p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
-		}
-	}
-
 	d_instantiate(dentry, inode);
 }
 
@@ -232,7 +226,7 @@ void sysfs_drop_dentry(struct sysfs_dire
 		/* get dentry if it's there and dput() didn't kill it yet */
 		dentry = dget_locked(sd->s_dentry);
 		parent = dentry->d_parent;
-	} else if (sd->s_parent->s_dentry->d_inode) {
+	} else if (sd->s_parent->s_dentry && sd->s_parent->s_dentry->d_inode) {
 		/* We need to update the parent even if dentry for the
 		 * victim itself doesn't exist.
 		 */
@@ -267,8 +261,9 @@ void sysfs_drop_dentry(struct sysfs_dire
 		if (sysfs_type(sd) & SYSFS_DIR) {
 			drop_nlink(dentry->d_inode);
 			drop_nlink(dir);
-			/* XXX: unpin if directory, this will go away soon */
-			dput(dentry);
+			/* dentries for shadowed inode are pinned, unpin */
+			if (sysfs_is_shadowed_inode(dentry->d_inode))
+				dput(dentry);
 		}
 	}
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index d5ce3aa..f82c345 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -22,7 +22,7 @@ static const struct super_operations sys
 	.drop_inode	= sysfs_delete_inode,
 };
 
-static struct sysfs_dirent sysfs_root = {
+struct sysfs_dirent sysfs_root = {
 	.s_count	= ATOMIC_INIT(1),
 	.s_flags	= SYSFS_ROOT,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index b11c448..0aa4b18 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -45,6 +45,7 @@ struct sysfs_dirent {
 #define SD_DEACTIVATED_BIAS	INT_MIN
 
 extern struct vfsmount * sysfs_mount;
+extern struct sysfs_dirent sysfs_root;
 extern struct kmem_cache *sysfs_dir_cachep;
 
 extern struct dentry *sysfs_get_dentry(struct sysfs_dirent *sd);
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 4c43030..2f58ca1 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -81,7 +81,6 @@ struct sysfs_ops {
 #define SYSFS_KOBJ_ATTR 	0x0004
 #define SYSFS_KOBJ_BIN_ATTR	0x0008
 #define SYSFS_KOBJ_LINK 	0x0020
-#define SYSFS_NOT_PINNED	(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR | SYSFS_KOBJ_LINK)
 #define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #define SYSFS_FLAG_MASK		~SYSFS_TYPE_MASK
-- 
1.4.3.4


