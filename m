Return-Path: <linux-kernel-owner+w=401wt.eu-S936325AbXGKXxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936325AbXGKXxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935244AbXGKXgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:36:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:33417 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935217AbXGKXgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:36:05 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 43/61] sysfs: reorganize sysfs_new_indoe() and sysfs_create()
Date: Wed, 11 Jul 2007 16:32:02 -0700
Message-Id: <11841969401152-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841969361535-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Reorganize/clean up sysfs_new_inode() and sysfs_create().

* sysfs_init_inode() is separated out from sysfs_new_inode() and is
  responsible for basic initialization.
* sysfs_instantiate() replaces the last step of sysfs_create() and is
  responsible for dentry instantitaion.
* type-specific initialization is moved out to the callers.
* mode is specified only once when creating a sysfs_dirent.
* spurious list_del_init(&sd->s_sibling) dropped from create_dir()

This change is to

* prepare for inode allocation fix.
* separate alloc and init code for synchronization update.
* make dentry/inode initialization more flexible for later changes.

This patch doesn't introduce visible behavior change.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c   |  130 ++++++++++++++++++++----------------------------------
 fs/sysfs/inode.c |  108 ++++++++++++++++++++++++---------------------
 fs/sysfs/mount.c |   18 ++++---
 fs/sysfs/sysfs.h |    6 +-
 4 files changed, 118 insertions(+), 144 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index a26e3db..bbf3525 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -191,39 +191,18 @@ int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
 	return 0;
 }
 
-static int init_dir(struct inode * inode)
-{
-	inode->i_op = &sysfs_dir_inode_operations;
-	inode->i_fop = &sysfs_dir_operations;
-
-	/* directory inodes start off with i_nlink == 2 (for "." entry) */
-	inc_nlink(inode);
-	return 0;
-}
-
-static int init_file(struct inode * inode)
-{
-	inode->i_size = PAGE_SIZE;
-	inode->i_fop = &sysfs_file_operations;
-	return 0;
-}
-
-static int init_symlink(struct inode * inode)
-{
-	inode->i_op = &sysfs_symlink_inode_operations;
-	return 0;
-}
-
 static int create_dir(struct kobject *kobj, struct dentry *parent,
 		      const char *name, struct dentry **p_dentry)
 {
 	int error;
 	umode_t mode = S_IFDIR| S_IRWXU | S_IRUGO | S_IXUGO;
 	struct dentry *dentry;
+	struct inode *inode;
 	struct sysfs_dirent *sd;
 
 	mutex_lock(&parent->d_inode->i_mutex);
 
+	/* allocate */
 	dentry = lookup_one_len(name, parent, strlen(name));
 	if (IS_ERR(dentry)) {
 		error = PTR_ERR(dentry);
@@ -231,7 +210,7 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 	}
 
 	error = -EEXIST;
-	if (sysfs_dirent_exist(parent->d_fsdata, name))
+	if (dentry->d_inode)
 		goto out_dput;
 
 	error = -ENOMEM;
@@ -240,19 +219,31 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 		goto out_drop;
 	sd->s_elem.dir.kobj = kobj;
 
-	error = sysfs_create(sd, dentry, mode, init_dir);
-	if (error)
+	inode = sysfs_new_inode(sd);
+	if (!inode)
 		goto out_sput;
 
+	inode->i_op = &sysfs_dir_inode_operations;
+	inode->i_fop = &sysfs_dir_operations;
+	/* directory inodes start off with i_nlink == 2 (for "." entry) */
+	inc_nlink(inode);
+
+	/* link in */
+	error = -EEXIST;
+	if (sysfs_dirent_exist(parent->d_fsdata, name))
+		goto out_iput;
+
+	sysfs_instantiate(dentry, inode);
 	inc_nlink(parent->d_inode);
 	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
 
 	*p_dentry = dentry;
 	error = 0;
-	goto out_dput;
+	goto out_unlock;	/* pin directory dentry in core */
 
+ out_iput:
+	iput(inode);
  out_sput:
-	list_del_init(&sd->s_sibling);
 	sysfs_put(sd);
  out_drop:
 	d_drop(dentry);
@@ -298,71 +289,46 @@ int sysfs_create_dir(struct kobject * kobj, struct dentry *shadow_parent)
 	return error;
 }
 
-/* attaches attribute's sysfs_dirent to the dentry corresponding to the
- * attribute file
- */
-static int sysfs_attach_attr(struct sysfs_dirent * sd, struct dentry * dentry)
-{
-	struct attribute * attr = NULL;
-	struct bin_attribute * bin_attr = NULL;
-	int (* init) (struct inode *) = NULL;
-	int error = 0;
-
-        if (sd->s_type & SYSFS_KOBJ_BIN_ATTR) {
-                bin_attr = sd->s_elem.bin_attr.bin_attr;
-                attr = &bin_attr->attr;
-        } else {
-                attr = sd->s_elem.attr.attr;
-                init = init_file;
-        }
-
-	error = sysfs_create(sd, dentry,
-			     (attr->mode & S_IALLUGO) | S_IFREG, init);
-	if (error)
-		return error;
-
-        if (bin_attr) {
-		dentry->d_inode->i_size = bin_attr->size;
-		dentry->d_inode->i_fop = &bin_fops;
-	}
-
-	sysfs_attach_dentry(sd, dentry);
-
-	return 0;
-}
-
-static int sysfs_attach_link(struct sysfs_dirent * sd, struct dentry * dentry)
-{
-	int err;
-
-	err = sysfs_create(sd, dentry, S_IFLNK|S_IRWXUGO, init_symlink);
-	if (!err)
-		sysfs_attach_dentry(sd, dentry);
-
-	return err;
-}
-
 static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 				struct nameidata *nd)
 {
 	struct sysfs_dirent * parent_sd = dentry->d_parent->d_fsdata;
 	struct sysfs_dirent * sd;
-	int err = 0;
+	struct inode *inode;
+	int found = 0;
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
-		if (sd->s_type & SYSFS_NOT_PINNED) {
-			if (strcmp(sd->s_name, dentry->d_name.name))
-				continue;
-
-			if (sd->s_type & SYSFS_KOBJ_LINK)
-				err = sysfs_attach_link(sd, dentry);
-			else
-				err = sysfs_attach_attr(sd, dentry);
+		if ((sd->s_type & SYSFS_NOT_PINNED) &&
+		    !strcmp(sd->s_name, dentry->d_name.name)) {
+			found = 1;
 			break;
 		}
 	}
 
-	return ERR_PTR(err);
+	/* no such entry */
+	if (!found)
+		return NULL;
+
+	/* attach dentry and inode */
+	inode = sysfs_new_inode(sd);
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	/* initialize inode according to type */
+	if (sd->s_type & SYSFS_KOBJ_ATTR) {
+		inode->i_size = PAGE_SIZE;
+		inode->i_fop = &sysfs_file_operations;
+	} else if (sd->s_type & SYSFS_KOBJ_BIN_ATTR) {
+		struct bin_attribute *bin_attr = sd->s_elem.bin_attr.bin_attr;
+		inode->i_size = bin_attr->size;
+		inode->i_fop = &bin_fops;
+	} else if (sd->s_type & SYSFS_KOBJ_LINK)
+		inode->i_op = &sysfs_symlink_inode_operations;
+
+	sysfs_instantiate(dentry, inode);
+	sysfs_attach_dentry(sd, dentry);
+
+	return NULL;
 }
 
 const struct inode_operations sysfs_dir_inode_operations = {
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 6ad47c1..26d8503 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -133,62 +133,68 @@ static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
  */
 static struct lock_class_key sysfs_inode_imutex_key;
 
-struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent * sd)
+void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
-	struct inode * inode = new_inode(sysfs_sb);
-	if (inode) {
-		inode->i_blocks = 0;
-		inode->i_mapping->a_ops = &sysfs_aops;
-		inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
-		inode->i_op = &sysfs_inode_operations;
-		inode->i_ino = sd->s_ino;
-		lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
-
-		if (sd->s_iattr) {
-			/* sysfs_dirent has non-default attributes
-			 * get them for the new inode from persistent copy
-			 * in sysfs_dirent
-			 */
-			set_inode_attr(inode, sd->s_iattr);
-		} else
-			set_default_inode_attr(inode, mode);
-	}
+	inode->i_blocks = 0;
+	inode->i_mapping->a_ops = &sysfs_aops;
+	inode->i_mapping->backing_dev_info = &sysfs_backing_dev_info;
+	inode->i_op = &sysfs_inode_operations;
+	inode->i_ino = sd->s_ino;
+	lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
+
+	if (sd->s_iattr) {
+		/* sysfs_dirent has non-default attributes
+		 * get them for the new inode from persistent copy
+		 * in sysfs_dirent
+		 */
+		set_inode_attr(inode, sd->s_iattr);
+	} else
+		set_default_inode_attr(inode, sd->s_mode);
+}
+
+/**
+ *	sysfs_new_inode - allocate new inode for sysfs_dirent
+ *	@sd: sysfs_dirent to allocate inode for
+ *
+ *	Allocate inode for @sd and initialize basics.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ *
+ *	RETURNS:
+ *	Pointer to allocated inode on success, NULL on failure.
+ */
+struct inode * sysfs_new_inode(struct sysfs_dirent *sd)
+{
+	struct inode *inode;
+
+	inode = new_inode(sysfs_sb);
+	if (inode)
+		sysfs_init_inode(sd, inode);
+
 	return inode;
 }
 
-int sysfs_create(struct sysfs_dirent *sd, struct dentry *dentry, int mode,
-		 int (*init)(struct inode *))
+/**
+ *	sysfs_instantiate - instantiate dentry
+ *	@dentry: dentry to be instantiated
+ *	@inode: inode associated with @sd
+ *
+ *	Instantiate @dentry with @inode.
+ *
+ *	LOCKING:
+ *	None.
+ */
+void sysfs_instantiate(struct dentry *dentry, struct inode *inode)
 {
-	int error = 0;
-	struct inode * inode = NULL;
-	if (dentry) {
-		if (!dentry->d_inode) {
-			if ((inode = sysfs_new_inode(mode, sd))) {
-				if (dentry->d_parent && dentry->d_parent->d_inode) {
-					struct inode *p_inode = dentry->d_parent->d_inode;
-					p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
-				}
-				goto Proceed;
-			}
-			else 
-				error = -ENOMEM;
-		} else
-			error = -EEXIST;
-	} else 
-		error = -ENOENT;
-	goto Done;
-
- Proceed:
-	if (init)
-		error = init(inode);
-	if (!error) {
-		d_instantiate(dentry, inode);
-		if (S_ISDIR(mode))
-			dget(dentry);  /* pin only directory dentry in core */
-	} else
-		iput(inode);
- Done:
-	return error;
+	BUG_ON(!dentry || dentry->d_inode);
+
+	if (dentry->d_parent && dentry->d_parent->d_inode) {
+		struct inode *p_inode = dentry->d_parent->d_inode;
+		p_inode->i_mtime = p_inode->i_ctime = CURRENT_TIME;
+	}
+
+	d_instantiate(dentry, inode);
 }
 
 /**
diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 37ff9ff..6d3a624 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -29,6 +29,7 @@ static struct sysfs_dirent sysfs_root = {
 	.s_sibling	= LIST_HEAD_INIT(sysfs_root.s_sibling),
 	.s_children	= LIST_HEAD_INIT(sysfs_root.s_children),
 	.s_type		= SYSFS_ROOT,
+	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
 	.s_iattr	= NULL,
 	.s_ino		= 1,
 };
@@ -45,18 +46,19 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 	sysfs_sb = sb;
 
-	inode = sysfs_new_inode(S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
-				 &sysfs_root);
-	if (inode) {
-		inode->i_op = &sysfs_dir_inode_operations;
-		inode->i_fop = &sysfs_dir_operations;
-		/* directory inodes start off with i_nlink == 2 (for "." entry) */
-		inc_nlink(inode);
-	} else {
+	inode = new_inode(sysfs_sb);
+	if (!inode) {
 		pr_debug("sysfs: could not get root inode\n");
 		return -ENOMEM;
 	}
 
+	sysfs_init_inode(&sysfs_root, inode);
+
+	inode->i_op = &sysfs_dir_inode_operations;
+	inode->i_fop = &sysfs_dir_operations;
+	/* directory inodes start off with i_nlink == 2 (for "." entry) */
+	inc_nlink(inode);
+
 	root = d_alloc_root(inode);
 	if (!root) {
 		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index fc6aa86..143fdbe 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -57,9 +57,9 @@ extern struct vfsmount * sysfs_mount;
 extern struct kmem_cache *sysfs_dir_cachep;
 
 extern void sysfs_delete_inode(struct inode *inode);
-extern struct inode * sysfs_new_inode(mode_t mode, struct sysfs_dirent *);
-extern int sysfs_create(struct sysfs_dirent *sd, struct dentry *dentry,
-			int mode, int (*init)(struct inode *));
+extern void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode);
+extern struct inode * sysfs_new_inode(struct sysfs_dirent *sd);
+extern void sysfs_instantiate(struct dentry *dentry, struct inode *inode);
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
-- 
1.5.2.2

