Return-Path: <linux-kernel-owner+w=401wt.eu-S1756278AbXD1Nll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbXD1Nll (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 09:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXD1Nkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 09:40:49 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45359 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965838AbXD1NkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 09:40:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=MLgUcWLNtYu6vLU41N2MXUgoCQXP1no90HyZLUiOEBb7EOGU2/GUmDhFjHZJsEeRhdnIURVXdeVSd6ruDsB7VehN48mvZnlYgyhMPYEUWTkZr1AjYZW0Ij5ioW/7ahNQHhHPvRlHQctkpsE/F0tiqxy6/Vn8+R++disDChn4n8k=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 15/21] sysfs: reimplement symlink using sysfs_dirent tree
In-Reply-To: <11777675753460-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Sat, 28 Apr 2007 22:39:42 +0900
Message-Id: <11777675823416-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, stern@rowland.harvard.edu,
       maneesh@in.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 fs/sysfs/dir.c     |    2 +-
 fs/sysfs/symlink.c |   88 +++++++++++++++++++++++++++------------------------
 fs/sysfs/sysfs.h   |    9 +++--
 3 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 2fddf8a..36d47d3 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -53,7 +53,7 @@ void release_sysfs_dirent(struct sysfs_dirent * sd)
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
index e37b6e8..e1a213d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -3,7 +3,7 @@ struct sysfs_elem_dir {
 };
 
 struct sysfs_elem_symlink {
-	struct kobject		* target_kobj;
+	struct sysfs_dirent	* target_sd;
 };
 
 struct sysfs_elem_attr {
@@ -99,10 +99,11 @@ static inline struct kobject *sysfs_get_kobject(struct dentry *dentry)
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
1.5.0.3


