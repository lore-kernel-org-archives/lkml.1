Return-Path: <linux-kernel-owner+w=401wt.eu-S934673AbXGKXpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673AbXGKXpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935058AbXGKXey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:34:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:33873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765906AbXGKXew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:34:52 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/61] sysfs: consolidate sysfs_dirent creation functions
Date: Wed, 11 Jul 2007 16:31:47 -0700
Message-Id: <11841968683554-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968643630-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

Currently there are four functions to create sysfs_dirent -
__sysfs_new_dirent(), sysfs_new_dirent(), __sysfs_make_dirent() and
sysfs_make_dirent().  Other than sysfs_make_dirent(), no function has
two users if calls to implement other functions are excluded.

This patch consolidates sysfs_dirent creation functions into the
following two.

* sysfs_new_dirent() : allocate and initialize
* sysfs_attach_dirent() : attach to sysfs_dirent hierarchy and/or
			  associate with dentry

This simplifies interface and gives callers more flexibility.  This is
in preparation of object reference simplification.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |   82 ++++++++++++++++------------------------------------
 fs/sysfs/file.c    |   21 ++++++++++---
 fs/sysfs/symlink.c |    7 ++--
 fs/sysfs/sysfs.h   |    7 +++-
 4 files changed, 50 insertions(+), 67 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 90bed5d..f16aa7e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -85,10 +85,7 @@ static struct dentry_operations sysfs_dentry_ops = {
 	.d_iput		= sysfs_d_iput,
 };
 
-/*
- * Allocates a new sysfs_dirent and links it to the parent sysfs_dirent
- */
-static struct sysfs_dirent * __sysfs_new_dirent(void * element)
+struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode, int type)
 {
 	struct sysfs_dirent * sd;
 
@@ -105,25 +102,25 @@ static struct sysfs_dirent * __sysfs_new_dirent(void * element)
 	atomic_set(&sd->s_event, 1);
 	INIT_LIST_HEAD(&sd->s_children);
 	INIT_LIST_HEAD(&sd->s_sibling);
+
 	sd->s_element = element;
+	sd->s_mode = mode;
+	sd->s_type = type;
 
 	return sd;
 }
 
-static void __sysfs_list_dirent(struct sysfs_dirent *parent_sd,
-			      struct sysfs_dirent *sd)
+void sysfs_attach_dirent(struct sysfs_dirent *sd,
+			 struct sysfs_dirent *parent_sd, struct dentry *dentry)
 {
-	if (sd)
-		list_add(&sd->s_sibling, &parent_sd->s_children);
-}
+	if (dentry) {
+		sd->s_dentry = dentry;
+		dentry->d_fsdata = sysfs_get(sd);
+		dentry->d_op = &sysfs_dentry_ops;
+	}
 
-static struct sysfs_dirent * sysfs_new_dirent(struct sysfs_dirent *parent_sd,
-						void * element)
-{
-	struct sysfs_dirent *sd;
-	sd = __sysfs_new_dirent(element);
-	__sysfs_list_dirent(parent_sd, sd);
-	return sd;
+	if (parent_sd)
+		list_add(&sd->s_sibling, &parent_sd->s_children);
 }
 
 /*
@@ -151,39 +148,6 @@ int sysfs_dirent_exist(struct sysfs_dirent *parent_sd,
 	return 0;
 }
 
-
-static struct sysfs_dirent *
-__sysfs_make_dirent(struct dentry *dentry, void *element, mode_t mode, int type)
-{
-	struct sysfs_dirent * sd;
-
-	sd = __sysfs_new_dirent(element);
-	if (!sd)
-		goto out;
-
-	sd->s_mode = mode;
-	sd->s_type = type;
-	sd->s_dentry = dentry;
-	if (dentry) {
-		dentry->d_fsdata = sysfs_get(sd);
-		dentry->d_op = &sysfs_dentry_ops;
-	}
-
-out:
-	return sd;
-}
-
-int sysfs_make_dirent(struct sysfs_dirent * parent_sd, struct dentry * dentry,
-			void * element, umode_t mode, int type)
-{
-	struct sysfs_dirent *sd;
-
-	sd = __sysfs_make_dirent(dentry, element, mode, type);
-	__sysfs_list_dirent(parent_sd, sd);
-
-	return sd ? 0 : -ENOMEM;
-}
-
 static int init_dir(struct inode * inode)
 {
 	inode->i_op = &sysfs_dir_inode_operations;
@@ -227,10 +191,11 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 	if (sysfs_dirent_exist(parent->d_fsdata, name))
 		goto out_dput;
 
-	error = sysfs_make_dirent(parent->d_fsdata, dentry, kobj, mode,
-				  SYSFS_DIR);
-	if (error)
+	error = -ENOMEM;
+	sd = sysfs_new_dirent(kobj, mode, SYSFS_DIR);
+	if (!sd)
 		goto out_drop;
+	sysfs_attach_dirent(sd, parent->d_fsdata, dentry);
 
 	error = sysfs_create(dentry, mode, init_dir);
 	if (error)
@@ -245,7 +210,6 @@ static int create_dir(struct kobject *kobj, struct dentry *parent,
 	goto out_dput;
 
  out_sput:
-	sd = dentry->d_fsdata;
 	list_del_init(&sd->s_sibling);
 	sysfs_put(sd);
  out_drop:
@@ -557,13 +521,16 @@ static int sysfs_dir_open(struct inode *inode, struct file *file)
 {
 	struct dentry * dentry = file->f_path.dentry;
 	struct sysfs_dirent * parent_sd = dentry->d_fsdata;
+	struct sysfs_dirent * sd;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	file->private_data = sysfs_new_dirent(parent_sd, NULL);
+	sd = sysfs_new_dirent(NULL, 0, 0);
+	if (sd)
+		sysfs_attach_dirent(sd, parent_sd, NULL);
 	mutex_unlock(&dentry->d_inode->i_mutex);
 
-	return file->private_data ? 0 : -ENOMEM;
-
+	file->private_data = sd;
+	return sd ? 0 : -ENOMEM;
 }
 
 static int sysfs_dir_close(struct inode *inode, struct file *file)
@@ -736,9 +703,10 @@ struct dentry *sysfs_create_shadow_dir(struct kobject *kobj)
 	if (!shadow)
 		goto nomem;
 
-	sd = __sysfs_make_dirent(shadow, kobj, inode->i_mode, SYSFS_DIR);
+	sd = sysfs_new_dirent(kobj, inode->i_mode, SYSFS_DIR);
 	if (!sd)
 		goto nomem;
+	sysfs_attach_dirent(sd, NULL, shadow);
 
 	d_instantiate(shadow, igrab(inode));
 	inc_nlink(inode);
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b502c71..fd4b6dc 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -444,14 +444,25 @@ int sysfs_add_file(struct dentry * dir, const struct attribute * attr, int type)
 {
 	struct sysfs_dirent * parent_sd = dir->d_fsdata;
 	umode_t mode = (attr->mode & S_IALLUGO) | S_IFREG;
-	int error = -EEXIST;
+	struct sysfs_dirent *sd;
+	int error = 0;
 
 	mutex_lock(&dir->d_inode->i_mutex);
-	if (!sysfs_dirent_exist(parent_sd, attr->name))
-		error = sysfs_make_dirent(parent_sd, NULL, (void *)attr,
-					  mode, type);
-	mutex_unlock(&dir->d_inode->i_mutex);
 
+	if (sysfs_dirent_exist(parent_sd, attr->name)) {
+		error = -EEXIST;
+		goto out_unlock;
+	}
+
+	sd = sysfs_new_dirent((void *)attr, mode, type);
+	if (!sd) {
+		error = -ENOMEM;
+		goto out_unlock;
+	}
+	sysfs_attach_dirent(sd, parent_sd, NULL);
+
+ out_unlock:
+	mutex_unlock(&dir->d_inode->i_mutex);
 	return error;
 }
 
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index b463f17..d96bb9c 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -49,6 +49,7 @@ static int sysfs_add_link(struct dentry * parent, const char * name, struct kobj
 {
 	struct sysfs_dirent * parent_sd = parent->d_fsdata;
 	struct sysfs_symlink * sl;
+	struct sysfs_dirent * sd;
 	int error;
 
 	error = -ENOMEM;
@@ -63,10 +64,10 @@ static int sysfs_add_link(struct dentry * parent, const char * name, struct kobj
 	strcpy(sl->link_name, name);
 	sl->target_kobj = kobject_get(target);
 
-	error = sysfs_make_dirent(parent_sd, NULL, sl, S_IFLNK|S_IRWXUGO,
-				SYSFS_KOBJ_LINK);
-	if (error)
+	sd = sysfs_new_dirent(sl, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
+	if (!sd)
 		goto err_out;
+	sysfs_attach_dirent(sd, parent_sd, NULL);
 
 	return 0;
 
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index f4fdbbf..f8f49cc 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -20,8 +20,11 @@ extern int sysfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 
 extern void release_sysfs_dirent(struct sysfs_dirent * sd);
 extern int sysfs_dirent_exist(struct sysfs_dirent *, const unsigned char *);
-extern int sysfs_make_dirent(struct sysfs_dirent *, struct dentry *, void *,
-				umode_t, int);
+extern struct sysfs_dirent *sysfs_new_dirent(void *element, umode_t mode,
+					     int type);
+extern void sysfs_attach_dirent(struct sysfs_dirent *sd,
+				struct sysfs_dirent *parent_sd,
+				struct dentry *dentry);
 
 extern int sysfs_add_file(struct dentry *, const struct attribute *, int);
 extern int sysfs_hash_and_remove(struct dentry * dir, const char * name);
-- 
1.5.2.2

