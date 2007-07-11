Return-Path: <linux-kernel-owner+w=401wt.eu-S936936AbXGLAB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936936AbXGLAB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935013AbXGKXhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:37:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:33540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935283AbXGKXhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:37:32 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 60/61] sysfs: make directory dentries and inodes reclaimable
Date: Wed, 11 Jul 2007 16:32:19 -0700
Message-Id: <1184197026634-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841970211456-git-send-email-gregkh@suse.de>
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
 <11841970052991-git-send-email-gregkh@suse.de>
 <11841970112965-git-send-email-gregkh@suse.de>
 <11841970162061-git-send-email-gregkh@suse.de>
 <11841970211456-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

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

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c        |  231 +++++++++++++++++++++++++++----------------------
 fs/sysfs/file.c       |  134 +++++++++++++----------------
 fs/sysfs/mount.c      |    2 +-
 fs/sysfs/sysfs.h      |    1 +
 include/linux/sysfs.h |    1 -
 5 files changed, 187 insertions(+), 182 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 9872112..aee966c 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -568,10 +568,10 @@ static void sysfs_drop_dentry(struct sysfs_dirent *sd)
 	spin_unlock(&dcache_lock);
 	spin_unlock(&sysfs_assoc_lock);
 
-	dput(dentry);
-	/* XXX: unpin if directory, this will go away soon */
-	if (sysfs_type(sd) == SYSFS_DIR)
+	/* dentries for shadowed inodes are pinned, unpin */
+	if (dentry && sysfs_is_shadowed_inode(dentry->d_inode))
 		dput(dentry);
+	dput(dentry);
 
 	/* adjust nlink and update timestamp */
 	inode = ilookup(sysfs_sb, sd->s_ino);
@@ -686,69 +686,29 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 static int create_dir(struct kobject *kobj, struct sysfs_dirent *parent_sd,
 		      const char *name, struct sysfs_dirent **p_sd)
 {
-	struct dentry *parent = parent_sd->s_dentry;
-	struct sysfs_addrm_cxt acxt;
-	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
-	struct dentry *dentry;
-	struct inode *inode;
+	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 
-	sysfs_addrm_start(&acxt, parent_sd);
-
 	/* allocate */
-	dentry = lookup_one_len(name, parent, strlen(name));
-	if (IS_ERR(dentry)) {
-		error = PTR_ERR(dentry);
-		goto out_finish;
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
-	error = -EEXIST;
-	if (sysfs_find_dirent(parent_sd, name))
-		goto out_iput;
-
-	sysfs_add_one(&acxt, sd);
-	sysfs_link_sibling(sd);
-	sysfs_instantiate(dentry, inode);
-	sysfs_attach_dentry(sd, dentry);
-
-	*p_sd = sd;
-	error = 0;
-	goto out_finish;	/* pin directory dentry in core */
+	sysfs_addrm_start(&acxt, parent_sd);
+	if (!sysfs_find_dirent(parent_sd, name)) {
+		sysfs_add_one(&acxt, sd);
+		sysfs_link_sibling(sd);
+	}
+	if (sysfs_addrm_finish(&acxt)) {
+		*p_sd = sd;
+		return 0;
+	}
 
- out_iput:
-	iput(inode);
- out_sput:
 	sysfs_put(sd);
- out_drop:
-	d_drop(dentry);
- out_dput:
-	dput(dentry);
- out_finish:
-	sysfs_addrm_finish(&acxt);
-	return error;
+	return -EEXIST;
 }
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
@@ -785,6 +745,17 @@ int sysfs_create_dir(struct kobject *kobj,
 	return error;
 }
 
+static int sysfs_count_nlink(struct sysfs_dirent *sd)
+{
+	struct sysfs_dirent *child;
+	int nr = 0;
+
+	for (child = sd->s_children; child; child = child->s_sibling)
+		if (sysfs_type(child) == SYSFS_DIR)
+			nr++;
+	return nr + 2;
+}
+
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
@@ -795,7 +766,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	int found = 0;
 
 	for (sd = parent_sd->s_children; sd; sd = sd->s_sibling) {
-		if ((sysfs_type(sd) & SYSFS_NOT_PINNED) &&
+		if (sysfs_type(sd) &&
 		    !strcmp(sd->s_name, dentry->d_name.name)) {
 			found = 1;
 			break;
@@ -816,6 +787,11 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 	if (inode->i_state & I_NEW) {
 		/* initialize inode according to type */
 		switch (sysfs_type(sd)) {
+		case SYSFS_DIR:
+			inode->i_op = &sysfs_dir_inode_operations;
+			inode->i_fop = &sysfs_dir_operations;
+			inode->i_nlink = sysfs_count_nlink(sd);
+			break;
 		case SYSFS_KOBJ_ATTR:
 			inode->i_size = PAGE_SIZE;
 			inode->i_fop = &sysfs_file_operations;
@@ -876,7 +852,7 @@ static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
 	while (*pos) {
 		struct sysfs_dirent *sd = *pos;
 
-		if (sysfs_type(sd) && (sysfs_type(sd) & SYSFS_NOT_PINNED)) {
+		if (sysfs_type(sd) && sysfs_type(sd) != SYSFS_DIR) {
 			*pos = sd->s_sibling;
 			sd->s_sibling = NULL;
 			sysfs_remove_one(&acxt, sd);
@@ -912,14 +888,25 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
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
@@ -933,14 +920,14 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
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
@@ -950,9 +937,9 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
 
 	error = kobject_set_name(kobj, "%s", new_name);
 	if (error)
-		goto out_free;
+		goto out_drop;
 
-	kfree(sd->s_name);
+	dup_name = sd->s_name;
 	sd->s_name = new_name;
 
 	/* move under the new parent */
@@ -972,45 +959,58 @@ int sysfs_rename_dir(struct kobject *kobj, struct sysfs_dirent *new_parent_sd,
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
@@ -1027,10 +1027,14 @@ again:
 	sysfs_link_sibling(sd);
 
 	mutex_unlock(&sysfs_mutex);
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
 
@@ -1191,12 +1195,20 @@ static loff_t sysfs_dir_lseek(struct file * file, loff_t offset, int origin)
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
@@ -1223,17 +1235,23 @@ int sysfs_make_shadowed_dir(struct kobject *kobj,
 
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
 	struct sysfs_addrm_cxt acxt;
 
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
@@ -1258,12 +1276,15 @@ struct sysfs_dirent *sysfs_create_shadow_dir(struct kobject *kobj)
 
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
index 69bacf1..cc49799 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -362,43 +362,22 @@ static unsigned int sysfs_poll(struct file *filp, poll_table *wait)
 	return POLLERR|POLLPRI;
 }
 
-
-static struct dentry *step_down(struct dentry *dir, const char * name)
+void sysfs_notify(struct kobject *k, char *dir, char *attr)
 {
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
+	struct sysfs_dirent *sd = k->sd;
 
-void sysfs_notify(struct kobject * k, char *dir, char *attr)
-{
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
+	mutex_lock(&sysfs_mutex);
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
+	mutex_unlock(&sysfs_mutex);
 }
 EXPORT_SYMBOL_GPL(sysfs_notify);
 
@@ -485,30 +464,31 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
  */
 int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
 {
-	struct dentry *dir = kobj->sd->s_dentry;
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
 
 
@@ -521,30 +501,34 @@ int sysfs_update_file(struct kobject * kobj, const struct attribute * attr)
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
 
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 078537e..402cc35 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -24,7 +24,7 @@ static const struct super_operations sysfs_ops = {
 	.drop_inode	= sysfs_delete_inode,
 };
 
-static struct sysfs_dirent sysfs_root = {
+struct sysfs_dirent sysfs_root = {
 	.s_count	= ATOMIC_INIT(1),
 	.s_flags	= SYSFS_ROOT,
 	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 72530dc..6a37f23 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -52,6 +52,7 @@ struct sysfs_addrm_cxt {
 };
 
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
1.5.2.2

