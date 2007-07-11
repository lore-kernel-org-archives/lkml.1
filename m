Return-Path: <linux-kernel-owner+w=401wt.eu-S934689AbXGKXsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934689AbXGKXsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:48:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935090AbXGKXfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:35:18 -0400
Received: from ns.suse.de ([195.135.220.2]:33903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935084AbXGKXfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:35:15 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <htejun@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/61] sysfs: reimplement symlink using sysfs_dirent tree
Date: Wed, 11 Jul 2007 16:31:52 -0700
Message-Id: <11841968903726-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841968872456-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <htejun@gmail.com>

sysfs symlink is implemented by referencing dentry and kobject from
sysfs_dirent - symlink entry references kobject, dentry is used to
walk the tree.  This complicates object lifetimes rules and is
dangerous - for example, there is no way to tell to which module the
target of a symlink belongs and referencing that kobject can make it
linger after the module is gone.

This patch reimplements symlink using only sysfs_dirent tree.  sd for
a symlink points and holds reference to the target sysfs_dirent and
all walking is done using sysfs_dirent tree.  Simpler and safer.

Please read the following message for more info.

  http://article.gmane.org/gmane.linux.kernel/510293

Signed-off-by: Tejun Heo <htejun@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c     |    2 +-
 fs/sysfs/symlink.c |   88 +++++++++++++++++++++++++++------------------------
 fs/sysfs/sysfs.h   |    9 +++--
 3 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index e9fddcc..2a94dc3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -54,7 +54,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
 	parent_sd = sd->s_parent;
 
 	if (sd->s_type & SYSFS_KOBJ_LINK)
-		kobject_put(sd->s_elem.symlink.target_kobj);
+		sysfs_put(sd->s_elem.symlink.target_sd);
 	if (sd->s_type & SYSFS_COPY_NAME)
 		kfree(sd->s_name);
 	kfree(sd->s_iattr);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 27df635..ff605d3 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -11,50 +11,49 @@
 
 #include "sysfs.h"
 
-static int object_depth(struct kobject * kobj)
+static int object_depth(struct sysfs_dirent *sd)
 {
-	struct kobject * p = kobj;
 	int depth = 0;
-	do { depth++; } while ((p = p->parent));
+
+	for (; sd->s_parent; sd = sd->s_parent)
+		depth++;
+
 	return depth;
 }
 
-static int object_path_length(struct kobject * kobj)
+static int object_path_length(struct sysfs_dirent * sd)
 {
-	struct kobject * p = kobj;
 	int length = 1;
-	do {
-		length += strlen(kobject_name(p)) + 1;
-		p = p->parent;
-	} while (p);
+
+	for (; sd->s_parent; sd = sd->s_parent)
+		length += strlen(sd->s_name) + 1;
+
 	return length;
 }
 
-static void fill_object_path(struct kobject * kobj, char * buffer, int length)
+static void fill_object_path(struct sysfs_dirent *sd, char *buffer, int length)
 {
-	struct kobject * p;
-
 	--length;
-	for (p = kobj; p; p = p->parent) {
-		int cur = strlen(kobject_name(p));
+	for (; sd->s_parent; sd = sd->s_parent) {
+		int cur = strlen(sd->s_name);
 
 		/* back up enough to print this bus id with '/' */
 		length -= cur;
-		strncpy(buffer + length,kobject_name(p),cur);
+		strncpy(buffer + length, sd->s_name, cur);
 		*(buffer + --length) = '/';
 	}
 }
 
-static int sysfs_add_link(struct dentry * parent, const char * name, struct kobject * target)
+static int sysfs_add_link(struct sysfs_dirent * parent_sd, const char * name,
+			  struct sysfs_dirent * target_sd)
 {
-	struct sysfs_dirent * parent_sd = parent->d_fsdata;
 	struct sysfs_dirent * sd;
 
 	sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
 	if (!sd)
 		return -ENOMEM;
 
-	sd->s_elem.symlink.target_kobj = kobject_get(target);
+	sd->s_elem.symlink.target_sd = target_sd;
 	sysfs_attach_dirent(sd, parent_sd, NULL);
 	return 0;
 }
@@ -68,6 +67,8 @@ static int sysfs_add_link(struct dentry * parent, const char * name, struct kobj
 int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char * name)
 {
 	struct dentry *dentry = NULL;
+	struct sysfs_dirent *parent_sd = NULL;
+	struct sysfs_dirent *target_sd = NULL;
 	int error = -EEXIST;
 
 	BUG_ON(!name);
@@ -80,11 +81,27 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 
 	if (!dentry)
 		return -EFAULT;
+	parent_sd = dentry->d_fsdata;
+
+	/* target->dentry can go away beneath us but is protected with
+	 * kobj_sysfs_assoc_lock.  Fetch target_sd from it.
+	 */
+	spin_lock(&kobj_sysfs_assoc_lock);
+	if (target->dentry)
+		target_sd = sysfs_get(target->dentry->d_fsdata);
+	spin_unlock(&kobj_sysfs_assoc_lock);
+
+	if (!target_sd)
+		return -ENOENT;
 
 	mutex_lock(&dentry->d_inode->i_mutex);
 	if (!sysfs_dirent_exist(dentry->d_fsdata, name))
-		error = sysfs_add_link(dentry, name, target);
+		error = sysfs_add_link(parent_sd, name, target_sd);
 	mutex_unlock(&dentry->d_inode->i_mutex);
+
+	if (error)
+		sysfs_put(target_sd);
+
 	return error;
 }
 
@@ -100,14 +117,14 @@ void sysfs_remove_link(struct kobject * kobj, const char * name)
 	sysfs_hash_and_remove(kobj->dentry,name);
 }
 
-static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
-				 char *path)
+static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
+				 struct sysfs_dirent * target_sd, char *path)
 {
 	char * s;
 	int depth, size;
 
-	depth = object_depth(kobj);
-	size = object_path_length(target) + depth * 3 - 1;
+	depth = object_depth(parent_sd);
+	size = object_path_length(target_sd) + depth * 3 - 1;
 	if (size > PATH_MAX)
 		return -ENAMETOOLONG;
 
@@ -116,7 +133,7 @@ static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
 	for (s = path; depth--; s += 3)
 		strcpy(s,"../");
 
-	fill_object_path(target, path, size);
+	fill_object_path(target_sd, path, size);
 	pr_debug("%s: path = '%s'\n", __FUNCTION__, path);
 
 	return 0;
@@ -124,27 +141,16 @@ static int sysfs_get_target_path(struct kobject * kobj, struct kobject * target,
 
 static int sysfs_getlink(struct dentry *dentry, char * path)
 {
-	struct kobject *kobj, *target_kobj;
-	int error = 0;
-
-	kobj = sysfs_get_kobject(dentry->d_parent);
-	if (!kobj)
-		return -EINVAL;
-
-	target_kobj = sysfs_get_kobject(dentry);
-	if (!target_kobj) {
-		kobject_put(kobj);
-		return -EINVAL;
-	}
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct sysfs_dirent *parent_sd = sd->s_parent;
+	struct sysfs_dirent *target_sd = sd->s_elem.symlink.target_sd;
+	int error;
 
 	down_read(&sysfs_rename_sem);
-	error = sysfs_get_target_path(kobj, target_kobj, path);
+	error = sysfs_get_target_path(parent_sd, target_sd, path);
 	up_read(&sysfs_rename_sem);
-	
-	kobject_put(kobj);
-	kobject_put(target_kobj);
-	return error;
 
+	return error;
 }
 
 static void *sysfs_follow_link(struct dentry *dentry, struct nameidata *nd)
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 718e2e1..6071766 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -3,7 +3,7 @@ struct sysfs_elem_dir {
 };
 
 struct sysfs_elem_symlink {
-	struct kobject		* target_kobj;
+	struct sysfs_dirent	* target_sd;
 };
 
 struct sysfs_elem_attr {
@@ -100,10 +100,11 @@ static inline struct kobject *sysfs_get_kobject(struct dentry *dentry)
 	spin_lock(&dcache_lock);
 	if (!d_unhashed(dentry)) {
 		struct sysfs_dirent * sd = dentry->d_fsdata;
+
 		if (sd->s_type & SYSFS_KOBJ_LINK)
-			kobj = kobject_get(sd->s_elem.symlink.target_kobj);
-		else
-			kobj = kobject_get(sd->s_elem.dir.kobj);
+			sd = sd->s_elem.symlink.target_sd;
+
+		kobj = kobject_get(sd->s_elem.dir.kobj);
 	}
 	spin_unlock(&dcache_lock);
 
-- 
1.5.2.2

