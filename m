Return-Path: <linux-kernel-owner+w=401wt.eu-S965526AbXDGI06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbXDGI06 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 04:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965529AbXDGIY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 04:24:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:60690 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965526AbXDGIX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 04:23:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=jNxcjUJtYunAMFVGW9+iMLex1QN5dtApSe4bxybG/b5xnEInJuc210UMvmCE05mgklmcAgFbPeO0rLTbI01JmPq9hsiOSZRFWnoZcTuv/9ISP9zcPEO6zobhZq9TEMmvC0vMccpAWU8ys+lJEzVoMxHUhHMzRrICCzfZm/4jdvA=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 07/14] sysfs: add sysfs_dirent->s_name
In-Reply-To: <1175934226928-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 7 Apr 2007 17:23:47 +0900
Message-Id: <11759342271067-git-send-email-htejun@gmail.com>
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

Add s_name to sysfs_dirent.  This is to further reduce dependency to
the associated dentry.  Name is copied for directories and symlinks
but not for attributes.

Where possible, name dereferences are converted to use sd->s_name.
sysfs_symlink->link_name and sysfs_get_name() are unused now and
removed.

This change allows symlink to be implemented using sysfs_dirent tree
proper, which is the last remaining dentry-dependent sysfs walk.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/dir.c        |   33 +++++++++++++++++++++------------
 fs/sysfs/file.c       |    2 +-
 fs/sysfs/inode.c      |   33 +--------------------------------
 fs/sysfs/symlink.c    |    8 +-------
 fs/sysfs/sysfs.h      |    7 +++----
 include/linux/sysfs.h |    1 +
 6 files changed, 28 insertions(+), 56 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index ef45c3e..26c3088 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -41,10 +41,11 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 
 	if (sd->s_type & SYSFS_KOBJ_LINK) {
 		struct sysfs_symlink * sl = sd->s_element;
-		kfree(sl->link_name);
 		kobject_put(sl->target_kobj);
 		kfree(sl);
 	}
+	if (sd->s_type & SYSFS_COPY_NAME)
+		kfree(sd->s_name);
 	kfree(sd->s_iattr);
 	kmem_cache_free(sysfs_dir_cachep, sd);
 
@@ -69,19 +70,30 @@ static struct dentry_operations sysfs_dentry_ops = {
 	.d_iput		= sysfs_d_iput,
 };
 
-struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode, int type)
+struct sysfs_dirent *sysfs_new_dirent(const char *name, void *element,
+				      umode_t mode, int type)
 {
+	char *dup_name = NULL;
 	struct sysfs_dirent * sd;
 
+	if (type & SYSFS_COPY_NAME) {
+		name = dup_name = kstrdup(name, GFP_KERNEL);
+		if (!name)
+			return NULL;
+	}
+
 	sd = kmem_cache_zalloc(sysfs_dir_cachep, GFP_KERNEL);
-	if (!sd)
+	if (!sd) {
+		kfree(dup_name);
 		return NULL;
+	}
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
 	INIT_LIST_HEAD(&sd->s_sibling);
 
+	sd->s_name = name;
 	sd->s_element = element;
 	sd->s_mode = mode;
 	sd->s_type = type;
@@ -118,8 +130,7 @@ int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_element) {
-			const unsigned char *existing = sysfs_get_name(sd);
-			if (strcmp(existing, new))
+			if (strcmp(sd->s_name, new))
 				continue;
 			else
 				return -EEXIST;
@@ -173,7 +184,7 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 		goto out_dput;
 
 	error = -ENOMEM;
-	sd = sysfs_new_dirent(kobj, mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(name, kobj, mode, SYSFS_DIR);
 	if (!sd)
 		goto out_drop;
 	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
@@ -298,9 +309,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 
 	list_for_each_entry(sd, &parent_sd->s_children, s_sibling) {
 		if (sd->s_type & SYSFS_NOT_PINNED) {
-			const unsigned char * name = sysfs_get_name(sd);
-
-			if (strcmp(name, dentry->d_name.name))
+			if (strcmp(sd->s_name, dentry->d_name.name))
 				continue;
 
 			if (sd->s_type & SYSFS_KOBJ_LINK)
@@ -490,7 +499,7 @@ static int sysfs_dir_open(struct inode *inode, struct file *file)
 	struct sysfs_dirent * sd;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	sd = sysfs_new_dirent(NULL, 0, 0);
+	sd = sysfs_new_dirent("_DIR_", NULL, 0, 0);
 	if (sd)
 		sysfs_attach_dirent(sd, parent_sd, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -557,7 +566,7 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 				if (!next->s_element)
 					continue;
 
-				name = sysfs_get_name(next);
+				name = next->s_name;
 				len = strlen(name);
 				ino = (unsigned long)next;
 
@@ -669,7 +678,7 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	if (!shadow)
 		goto nomem;
 
-	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
+	sd = sysfs_new_dirent("_SHADOW_", kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
 	/* point to parent_sd but don't attach to it */
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index f6b86a8..62ab272 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -484,7 +484,7 @@ int sysfs_add_file(struct dentry * dir, const struct attribute * attr, int type)
 		goto out_unlock;
 	}
 
-	sd = sysfs_new_dirent((void *)attr, mode, type);
+	sd = sysfs_new_dirent(attr->name, (void *)attr, mode, type);
 	if (!sd) {
 		error = -ENOMEM;
 		goto out_unlock;
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index b8b010c..4960be8 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -190,37 +190,6 @@ int sysfs_create(struct dentry * dentry, int mode, int (*init)(struct inode *))
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
@@ -288,7 +257,7 @@ int sysfs_hash_and_remove(struct dentry * dir, const char * name)
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
index b4876de..ac5fd2a 100644
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
 extern struct kobject *sysfs_get_kobject(struct dentry *dentry);
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
 
@@ -47,7 +47,6 @@ extern const struct inode_operations sysfs_dir_inode_operations;
 extern const struct inode_operations sysfs_symlink_inode_operations;
 
 struct sysfs_symlink {
-	char * link_name;
 	struct kobject * target_kobj;
 };
 
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index fea9a6b..c79944a 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -76,6 +76,7 @@ struct sysfs_ops {
 #define SYSFS_KOBJ_BIN_ATTR	0x0008
 #define SYSFS_KOBJ_LINK 	0x0020
 #define SYSFS_NOT_PINNED	(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR | SYSFS_KOBJ_LINK)
+#define SYSFS_COPY_NAME		(SYSFS_DIR | SYSFS_KOBJ_LINK)
 
 #ifdef CONFIG_SYSFS
 
-- 
1.5.0.3


