Return-Path: <linux-kernel-owner+w=401wt.eu-S935916AbXGKXqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935916AbXGKXqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935183AbXGKXfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:35:05 -0400
Received: from ns.suse.de ([195.135.220.2]:33880 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935180AbXGKXfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:35:02 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/61] sysfs: add sysfs_dirent->s_name
Date: Wed, 11 Jul 2007 16:31:49 -0700
Message-Id: <11841968773426-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968731843-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Add s_name to sysfs_dirent.  This is to further reduce dependency to
the associated dentry.  Name is copied for directories and symlinks
but not for attributes.

Where possible, name dereferences are converted to use sd->s_name.
sysfs_symlink->link_name and sysfs_get_name() are unused now and
removed.

This change allows symlink to be implemented using sysfs_dirent tree
proper, which is the last remaining dentry-dependent sysfs walk.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c        |   67 ++++++++++++++++++++++++++++++++-----------------
 fs/sysfs/file.c       |    2 +-
 fs/sysfs/inode.c      |   33 +-----------------------
 fs/sysfs/symlink.c    |    8 +-----
 fs/sysfs/sysfs.h      |    7 ++---
 include/linux/sysfs.h |    1 +
 6 files changed, 51 insertions(+), 67 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5d50e1d..6e8d6f5 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -54,10 +54,11 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 
 	if (sd->s_type & SYSFS_KOBJ_LINK) {
 		struct sysfs_symlink * sl = sd->s_element;
-		kfree(sl->link_name);
 		kobject_put(sl->target_kobj);
 		kfree(sl);
 	}
+	if (sd->s_type & SYSFS_COPY_NAME)
+		kfree(sd->s_name);
 	kfree(sd->s_iattr);
 	sysfs_free_ino(sd->s_ino);
 	kmem_cache_free(sysfs_dir_cachep, sd);
@@ -94,29 +95,41 @@ static struct dentry_operations sysfs_dentry_ops = {
 	.d_iput		= sysfs_d_iput,
 };
 
-struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode, int type)
+struct sysfs_dirent *sysfs_new_dirent(const char *name, void *element,
+				      umode_t mode, int type)
 {
-	struct sysfs_dirent * sd;
+	char *dup_name = NULL;
+	struct sysfs_dirent *sd = NULL;
+
+	if (type & SYSFS_COPY_NAME) {
+		name = dup_name = kstrdup(name, GFP_KERNEL);
+		if (!name)
+			goto err_out;
+	}
 
 	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
 	if (!sd)
-		return NULL;
+		goto err_out;
 
-	if (sysfs_alloc_ino(&sd->s_ino)) {
-		kmem_cache_free(sysfs_dir_cachep, sd);
-		return NULL;
-	}
+	if (sysfs_alloc_ino(&sd->s_ino))
+		goto err_out;
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
 	INIT_LIST_HEAD(&sd->s_sibling);
 
+	sd->s_name = name;
 	sd->s_element = element;
 	sd->s_mode = mode;
 	sd->s_type = type;
 
 	return sd;
+
+ err_out:
+	kfree(dup_name);
+	kmem_cache_free(sysfs_dir_cachep, sd);
+	return NULL;
 }
 
 void sysfs_attach_dirent(struct sysfs_dirent *sd,
@@ -148,8 +161,7 @@ int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_element) {
-			const unsigned char *existing = sysfs_get_name(sd);
-			if (strcmp(existing, new))
+			if (strcmp(sd->s_name, new))
 				continue;
 			else
 				return -EEXIST;
@@ -203,7 +215,7 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 		goto out_dput;
 
 	error = -ENOMEM;
-	sd = sysfs_new_dirent(kobj, mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(name, kobj, mode, SYSFS_DIR);
 	if (!sd)
 		goto out_drop;
 	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
@@ -334,9 +346,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_type & SYSFS_NOT_PINNED) {
-			const unsigned char * name = sysfs_get_name(sd);
-
-			if (strcmp(name, dentry->d_name.name))
+			if (strcmp(sd->s_name, dentry->d_name.name))
 				continue;
 
 			if (sd->s_type & SYSFS_KOBJ_LINK)
@@ -427,9 +437,11 @@ void sysfs_remove_dir(struct kobject * kobj)
 int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
 		     const char *new_name)
 {
+	struct sysfs_dirent *sd = kobj->dentry->d_fsdata;
+	struct sysfs_dirent *parent_sd = new_parent->d_fsdata;
+	struct dentry *new_dentry;
+	char *dup_name;
 	int error;
-	struct dentry * new_dentry;
-	struct sysfs_dirent *sd, *parent_sd;
 
 	if (!new_parent)
 		return -EFAULT;
@@ -457,22 +469,31 @@ int sysfs_rename_dir(struct kobject * kobj, struct dentry *new_parent,
 	if (new_dentry->d_inode)
 		goto out_dput;
 
+	/* rename kobject and sysfs_dirent */
+	error = -ENOMEM;
+	new_name = dup_name = kstrdup(new_name, GFP_KERNEL);
+	if (!new_name)
+		goto out_drop;
+
 	error = kobject_set_name(kobj, "%s", new_name);
 	if (error)
-		goto out_drop;
+		goto out_free;
 
+	kfree(sd->s_name);
+	sd->s_name = new_name;
+
+	/* move under the new parent */
 	d_add(new_dentry, NULL);
 	d_move(kobj->dentry, new_dentry);
 
-	sd = kobj->dentry->d_fsdata;
-	parent_sd = new_parent->d_fsdata;
-
 	list_del_init(&sd->s_sibling);
 	list_add(&sd->s_sibling, &parent_sd->s_children);
 
 	error = 0;
 	goto out_unlock;
 
+ out_free:
+	kfree(dup_name);
  out_drop:
 	d_drop(new_dentry);
  out_dput:
@@ -535,7 +556,7 @@ static int sysfs_dir_open(struct inode *inode, struct file *file)
 	struct sysfs_dirent * sd;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	sd = sysfs_new_dirent(NULL, 0, 0);
+	sd = sysfs_new_dirent("_DIR_", NULL, 0, 0);
 	if (sd)
 		sysfs_attach_dirent(sd, parent_sd, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -605,7 +626,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 				if (!next->s_element)
 					continue;
 
-				name = sysfs_get_name(next);
+				name = next->s_name;
 				len = strlen(name);
 				ino = next->s_ino;
 
@@ -717,7 +738,7 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	if (!shadow)
 		goto nomem;
 
-	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
+	sd = sysfs_new_dirent("_SHADOW_", kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
 	/* point to parent_sd but don't attach to it */
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fd4b6dc..8240b16 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -454,7 +454,7 @@ int sysfs_add_file(struct dentry * dir, const struct attribute * attr, int type)
 		goto out_unlock;
 	}
 
-	sd = sysfs_new_dirent((void *)attr, mode, type);
+	sd = sysfs_new_dirent(attr->name, (void *)attr, mode, type);
 	if (!sd) {
 		error = -ENOMEM;
 		goto out_unlock;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 5266eec..5c605b0 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -191,37 +191,6 @@ int sysfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *))
 	return error;
 }
 
-/*
- * Get the name for corresponding element represented by the given sysfs_dirent
- */
-const unsigned char * sysfs_get_name(struct sysfs_dirent *sd)
-{
-	struct attribute * attr;
-	struct bin_attribute * bin_attr;
-	struct sysfs_symlink  * sl;
-
-	BUG_ON(!sd || !sd->s_element);
-
-	switch (sd->s_type) {
-		case SYSFS_DIR:
-			/* Always have a dentry so use that */
-			return sd->s_dentry->d_name.name;
-
-		case SYSFS_KOBJ_ATTR:
-			attr = sd->s_element;
-			return attr->name;
-
-		case SYSFS_KOBJ_BIN_ATTR:
-			bin_attr = sd->s_element;
-			return bin_attr->attr.name;
-
-		case SYSFS_KOBJ_LINK:
-			sl = sd->s_element;
-			return sl->link_name;
-	}
-	return NULL;
-}
-
 static inline void orphan_all_buffers(struct inode *node)
 {
 	struct sysfs_buffer_collection *set;
@@ -305,7 +274,7 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (!sd->s_element)
 			continue;
-		if (!strcmp(sysfs_get_name(sd), name)) {
+		if (!strcmp(sd->s_name, name)) {
 			list_del_init(&sd->s_sibling);
 			sysfs_drop_dentry(sd, dir);
 			sysfs_put(sd);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index d96bb9c..c728204 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -57,14 +57,9 @@ static int sysfs_add_link(struct dentry * parent, const char * name, struct kobj
 	if (!sl)
 		goto err_out;
 
-	sl->link_name = kmalloc(strlen(name) + 1, GFP_KERNEL);
-	if (!sl->link_name)
-		goto err_out;
-
-	strcpy(sl->link_name, name);
 	sl->target_kobj = kobject_get(target);
 
-	sd = sysfs_new_dirent(sl, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	sd = sysfs_new_dirent(name, sl, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
 	if (!sd)
 		goto err_out;
 	sysfs_attach_dirent(sd, parent_sd, NULL);
@@ -74,7 +69,6 @@ static int sysfs_add_link(struct dentry * parent, const char * name, struct kobj
  err_out:
 	if (sl) {
 		kobject_put(sl->target_kobj);
-		kfree(sl->link_name);
 		kfree(sl);
 	}
 	return error;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ce05d6f..d34b008 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -3,6 +3,7 @@ struct sysfs_dirent {
 	struct sysfs_dirent	* s_parent;
 	struct list_head	s_sibling;
 	struct list_head	s_children;
+	const char		* s_name;
 	void 			* s_element;
 	int			s_type;
 	umode_t			s_mode;
@@ -21,8 +22,8 @@ extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
-extern struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode,
-					     int type);
+extern struct sysfs_dirent *sysfs_new_dirent(const char *name, void *element,
+					     umode_t mode, int type);
 extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
 				struct sysfs_dirent *parent_sd,
 				struct dentry *dentry);
@@ -34,7 +35,6 @@ extern struct sysfs_dirent *sysfs_find(struct sysfs_dirent *dir, const char * na
 extern int sysfs_create_subdir(struct kobject *, const char *, struct dentry **);
 extern void sysfs_remove_subdir(struct dentry *);
 
-extern const unsigned char * sysfs_get_name(struct sysfs_dirent *sd);
 extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
 extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
 
@@ -48,7 +48,6 @@ extern const struct inode_operations sysfs_dir_inode_operations;
 extern const struct inode_operations sysfs_symlink_inode_operations;
 
 struct sysfs_symlink {
-	char * link_name;
 	struct kobject * target_kobj;
 };
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 7d5d1ec..2f86b08 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -76,6 +76,7 @@ struct sysfs_ops {
 #define SYSFS_KOBJ_BIN_ATTR	0x0008
 #define SYSFS_KOBJ_LINK 	0x0020
 #define SYSFS_NOT_PINNED	(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR | SYSFS_KOBJ_LINK)
+#define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #ifdef CONFIG_SYSFS
 
-- 
1.5.2.2

