Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbXITIJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbXITIJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758875AbXITIGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:06:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:33587 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbXITIFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:05:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:cc:subject:in-reply-to:x-mailer:date:message-id:mime-version:content-type:reply-to:to:content-transfer-encoding:from;
        b=k2oLjKqRZ9dV1FZertdJDhjLKwP2ePnpSitJTM/ztEpYJvZfbmsMQi3sbYrwdOwSu7JI0z4J8cxLVNapSg0nt7g9uztDZSvN3gH8QUHDcu8rROXdEv83K6B5K9HSujzvqrqQpq04Vi3yjFeJ6tG/KRh8l0kEnaKcdTigJdZqkms=
Cc: Tejun Heo <htejun@gmail.com>
Subject: [PATCH 07/22] sysfs: implement sysfs_dirent based remove interface sysfs_remove()
In-Reply-To: <11902755392688-git-send-email-htejun@gmail.com>
X-Mailer: git-send-email
Date: Thu, 20 Sep 2007 17:05:40 +0900
Message-Id: <11902755403948-git-send-email-htejun@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Content-Transfer-Encoding: 7BIT
From: Tejun Heo <htejun@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements new sysfs_remove(), which takes @sd as target
argument and can be used on any type of node.  Also, it recurses into
sub directories.

* sysfs_remove_file(), sysfs_remove_file_from_group(),
  sysfs_remove_bin_file() are reimplemented using sysfs_remove() in
  fs/sysfs/kobject.c.

* To keep backward compatibility sysfs_remove_dir() is reimplemented
  using internal function __sysfs_remove() with @recurse argument set
  to zero so that it doesn't descend into subdirectories.

This patch doesn't introduce any behavior change to the original API.

Signed-off-by: Tejun Heo <htejun@gmail.com>
---
 fs/sysfs/bin.c        |   13 -----
 fs/sysfs/dir.c        |  125 ++++++++++++++++++++++++++++++++++---------------
 fs/sysfs/file.c       |   35 --------------
 fs/sysfs/group.c      |    4 +-
 fs/sysfs/kobject.c    |   92 ++++++++++++++++++++++++++++++++++++
 fs/sysfs/symlink.c    |   13 -----
 fs/sysfs/sysfs.h      |    3 +-
 include/linux/sysfs.h |    6 ++
 8 files changed, 189 insertions(+), 102 deletions(-)

diff --git a/fs/sysfs/bin.c b/fs/sysfs/bin.c
index 247ea19..1c12cf0 100644
--- a/fs/sysfs/bin.c
+++ b/fs/sysfs/bin.c
@@ -237,17 +237,4 @@ int sysfs_create_bin_file(struct kobject * kobj, struct bin_attribute * attr)
 	return sysfs_add_file(kobj->sd, &attr->attr, SYSFS_KOBJ_BIN_ATTR);
 }
 
-
-/**
- *	sysfs_remove_bin_file - remove binary file for object.
- *	@kobj:	object.
- *	@attr:	attribute descriptor.
- */
-
-void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
-{
-	sysfs_hash_and_remove(kobj->sd, attr->attr.name);
-}
-
 EXPORT_SYMBOL_GPL(sysfs_create_bin_file);
-EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index b1cf090..7cb3f1e 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -816,64 +816,113 @@ const struct inode_operations sysfs_dir_inode_operations = {
 	.setattr	= sysfs_setattr,
 };
 
-static void remove_dir(struct sysfs_dirent *sd)
+/**
+ *	sysfs_tree_walk_next - walk sysfs subtree
+ *	@top: top of the subtree to walk
+ *	@cur: the current sysfs_dirent (NULL to begin walk)
+ *
+ *	Walk subtree of @top.  Each call to this function returns the
+ *	next node to visit.  The walk is descendant first,
+ *	left-to-right.  The last node naturally is @top.  The walk
+ *	order is to allow removing the previous node while walking the
+ *	tree.
+ *
+ *	LOCKING:
+ *	mutex_lock(sysfs_mutex)
+ *
+ *	RETURNS:
+ *	Next sysfs_dirent to visit, NULL if the walk is complete.
+ */
+static struct sysfs_dirent *sysfs_tree_walk_next(struct sysfs_dirent *top,
+						 struct sysfs_dirent *cur)
 {
-	struct sysfs_addrm_cxt acxt;
+	if (cur == NULL) {
+		/* we're beginning a walk, go to the deepest child */
+		cur = top;
 
-	sysfs_addrm_start(&acxt);
-	sysfs_remove_one(&acxt, sd);
-	sysfs_addrm_finish(&acxt);
-}
+		while (sysfs_type(cur) == SYSFS_DIR && cur->s_dir.children)
+			cur = cur->s_dir.children;
 
-void sysfs_remove_subdir(struct sysfs_dirent *sd)
-{
-	remove_dir(sd);
-}
+		return cur;
+	} else if (cur == top) {
+		/* walk ends at @top */
+		return NULL;
+	}
 
+	/* continue walking */
+	if (cur->s_sibling) {
+		/* if possible, go right and deep */
+		cur = cur->s_sibling;
+
+		/* go to the deepest child */
+		while (sysfs_type(cur) == SYSFS_DIR && cur->s_dir.children)
+			cur = cur->s_dir.children;
+	} else {
+		/* this subtree is done, go up */
+		cur = cur->s_parent;
+	}
+
+	return cur;
+}
 
-static void __sysfs_remove_dir(struct sysfs_dirent *dir_sd)
+/**
+ *	__sysfs_remove - remove a sysfs_dirent
+ *	@sd: target sysfs_dirent to be removed
+ *	@recurse: recurse into subdirectories
+ *
+ *	Remove @sd.  If @sd is a directory, all its leaf children are
+ *	removed.  If @recurse is not zero, all the directory children
+ *	are recursively removed too.
+ *
+ *	This is an internal function to be used to implement
+ *	sysfs_remove() and sysfs_remove_dir().  @recurse is necessary
+ *	to support the original sysfs_remove_dir() semantics which
+ *	didn't remove subdirectories.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
+ */
+void __sysfs_remove(struct sysfs_dirent *sd, int recurse)
 {
 	struct sysfs_addrm_cxt acxt;
-	struct sysfs_dirent **pos;
+	struct sysfs_dirent *cur, *next;
 
-	if (!dir_sd)
+	/* noop on NULL */
+	if (!sd)
 		return;
 
-	pr_debug("sysfs %s: removing dir\n", dir_sd->s_name);
 	sysfs_addrm_start(&acxt);
-	pos = &dir_sd->s_dir.children;
-	while (*pos) {
-		struct sysfs_dirent *sd = *pos;
 
-		if (sysfs_type(sd) != SYSFS_DIR)
-			sysfs_remove_one(&acxt, sd);
-		else
-			pos = &(*pos)->s_sibling;
-	}
-	sysfs_addrm_finish(&acxt);
+	cur = sysfs_tree_walk_next(sd, NULL); /* prime walk */
+	do {
+		/* find out @next before removing @cur */
+		next = sysfs_tree_walk_next(sd, cur);
 
-	remove_dir(dir_sd);
+		/* if ! recursing, delete only direct leaf children and self */
+		if (!recurse && cur != sd &&
+		    (sysfs_type(cur) == SYSFS_DIR || cur->s_parent != sd))
+			continue;
+
+		sysfs_remove_one(&acxt, cur);
+	} while ((cur = next));
+
+	sysfs_addrm_finish(&acxt);
 }
 
 /**
- *	sysfs_remove_dir - remove an object's directory.
- *	@kobj:	object.
+ *	sysfs_remove - remove a sysfs_dirent and all its children recursively
+ *	@sd: target sysfs_dirent to be removed
  *
- *	The only thing special about this is that we remove any files in
- *	the directory before we remove the directory, and we've inlined
- *	what used to be sysfs_rmdir() below, instead of calling separately.
+ *	Remove @sd and all its children recursively.
+ *
+ *	LOCKING:
+ *	Kernel thread context (may sleep).
  */
-
-void sysfs_remove_dir(struct kobject * kobj)
+void sysfs_remove(struct sysfs_dirent *sd)
 {
-	struct sysfs_dirent *sd = kobj->sd;
-
-	spin_lock(&sysfs_assoc_lock);
-	kobj->sd = NULL;
-	spin_unlock(&sysfs_assoc_lock);
-
-	__sysfs_remove_dir(sd);
+	__sysfs_remove(sd, 1);
 }
+EXPORT_SYMBOL_GPL(sysfs_remove);
 
 int sysfs_rename_dir(struct kobject * kobj, const char *new_name)
 {
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index fb77d54..1faba5f 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -681,39 +681,4 @@ int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
 }
 EXPORT_SYMBOL_GPL(sysfs_chmod_file);
 
-
-/**
- *	sysfs_remove_file - remove an object attribute.
- *	@kobj:	object we're acting for.
- *	@attr:	attribute descriptor.
- *
- *	Hash the attribute name and kill the victim.
- */
-
-void sysfs_remove_file(struct kobject * kobj, const struct attribute * attr)
-{
-	sysfs_hash_and_remove(kobj->sd, attr->name);
-}
-
-
-/**
- * sysfs_remove_file_from_group - remove an attribute file from a group.
- * @kobj: object we're acting for.
- * @attr: attribute descriptor.
- * @group: group name.
- */
-void sysfs_remove_file_from_group(struct kobject *kobj,
-		const struct attribute *attr, const char *group)
-{
-	struct sysfs_dirent *dir_sd;
-
-	dir_sd = sysfs_get_dirent(kobj->sd, group);
-	if (dir_sd) {
-		sysfs_hash_and_remove(dir_sd, attr->name);
-		sysfs_put(dir_sd);
-	}
-}
-EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
-
 EXPORT_SYMBOL_GPL(sysfs_create_file);
-EXPORT_SYMBOL_GPL(sysfs_remove_file);
diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
index d197237..cef0376 100644
--- a/fs/sysfs/group.c
+++ b/fs/sysfs/group.c
@@ -57,7 +57,7 @@ int sysfs_create_group(struct kobject * kobj,
 	error = create_files(sd, grp);
 	if (error) {
 		if (grp->name)
-			sysfs_remove_subdir(sd);
+			sysfs_remove(sd);
 	}
 	sysfs_put(sd);
 	return error;
@@ -77,7 +77,7 @@ void sysfs_remove_group(struct kobject * kobj,
 
 	remove_files(sd, grp);
 	if (grp->name)
-		sysfs_remove_subdir(sd);
+		sysfs_remove(sd);
 
 	sysfs_put(sd);
 }
diff --git a/fs/sysfs/kobject.c b/fs/sysfs/kobject.c
index 5ebd755..9415f18 100644
--- a/fs/sysfs/kobject.c
+++ b/fs/sysfs/kobject.c
@@ -13,3 +13,95 @@
 
 #include <linux/sysfs.h>
 #include <linux/sysfs-kobject.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include "sysfs.h"
+
+static int sysfs_remove_child(struct sysfs_dirent *parent, const char *name)
+{
+	struct sysfs_dirent *sd;
+
+	sd = sysfs_find_child(parent, name);
+	if (!sd)
+		return -ENOENT;
+
+	sysfs_remove(sd);
+	return 0;
+}
+
+/**
+ *	sysfs_remove_dir - remove an object's directory.
+ *	@kobj:	object.
+ *
+ *	Remove sysfs directory associated with @kobj.  All children
+ *	which are leaf are removed but subdirectories are left alone.
+ */
+void sysfs_remove_dir(struct kobject * kobj)
+{
+	struct sysfs_dirent *sd = kobj->sd;
+
+	spin_lock(&sysfs_assoc_lock);
+	kobj->sd = NULL;
+	spin_unlock(&sysfs_assoc_lock);
+
+	__sysfs_remove(sd, 0);
+}
+
+/**
+ *	sysfs_remove_file - remove an object attribute.
+ *	@kobj:	object we're acting for.
+ *	@attr:	attribute descriptor.
+ *
+ *	Hash the attribute name and kill the victim.
+ */
+void sysfs_remove_file(struct kobject *kobj, const struct attribute *attr)
+{
+	sysfs_remove_child(kobj->sd, attr->name);
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_file);
+
+/**
+ *	sysfs_remove_bin_file - remove binary file for object.
+ *	@kobj:	object.
+ *	@attr:	attribute descriptor.
+ */
+void sysfs_remove_bin_file(struct kobject * kobj, struct bin_attribute * attr)
+{
+	if (sysfs_remove_child(kobj->sd, attr->attr.name) < 0) {
+		printk(KERN_ERR "%s: "
+		       "bad dentry or inode or no such file: \"%s\"\n",
+		       __FUNCTION__, attr->attr.name);
+		dump_stack();
+	}
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_bin_file);
+
+/**
+ *	sysfs_remove_link - remove symlink in object's directory.
+ *	@kobj:	object we're acting for.
+ *	@name:	name of the symlink to remove.
+ */
+void sysfs_remove_link(struct kobject * kobj, const char * name)
+{
+	sysfs_remove_child(kobj->sd, name);
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_link);
+
+/**
+ * sysfs_remove_file_from_group - remove an attribute file from a group.
+ * @kobj: object we're acting for.
+ * @attr: attribute descriptor.
+ * @group: group name.
+ */
+void sysfs_remove_file_from_group(struct kobject *kobj,
+		const struct attribute *attr, const char *group)
+{
+	struct sysfs_dirent *dir_sd;
+
+	dir_sd = sysfs_get_dirent(kobj->sd, group);
+	if (dir_sd) {
+		sysfs_remove_child(dir_sd, attr->name);
+		sysfs_put(dir_sd);
+	}
+}
+EXPORT_SYMBOL_GPL(sysfs_remove_file_from_group);
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 897cc2f..9c15a32 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -105,18 +105,6 @@ int sysfs_create_link(struct kobject * kobj, struct kobject * target, const char
 	return error;
 }
 
-
-/**
- *	sysfs_remove_link - remove symlink in object's directory.
- *	@kobj:	object we're acting for.
- *	@name:	name of the symlink to remove.
- */
-
-void sysfs_remove_link(struct kobject * kobj, const char * name)
-{
-	sysfs_hash_and_remove(kobj->sd, name);
-}
-
 static int sysfs_get_target_path(struct sysfs_dirent * parent_sd,
 				 struct sysfs_dirent * target_sd, char *path)
 {
@@ -178,4 +166,3 @@ const struct inode_operations sysfs_symlink_inode_operations = {
 
 
 EXPORT_SYMBOL_GPL(sysfs_create_link);
-EXPORT_SYMBOL_GPL(sysfs_remove_link);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 1f3915f..9494f3d 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -109,11 +109,12 @@ struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
 				      const unsigned char *name);
 struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type);
 
+void __sysfs_remove(struct sysfs_dirent *sd, int recurse);
+
 void release_sysfs_dirent(struct sysfs_dirent *sd);
 
 int sysfs_create_subdir(struct kobject *kobj, const char *name,
 			struct sysfs_dirent **p_sd);
-void sysfs_remove_subdir(struct sysfs_dirent *sd);
 
 static inline struct sysfs_dirent *sysfs_get(struct sysfs_dirent *sd)
 {
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f030dc6..4ad2874 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -18,6 +18,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 
+struct sysfs_dirent;
 struct vm_area_struct;
 
 /*
@@ -34,6 +35,7 @@ struct vm_area_struct;
 
 struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 				      const char *name);
+void sysfs_remove(struct sysfs_dirent *sd);
 
 int __must_check sysfs_init(void);
 
@@ -45,6 +47,10 @@ static inline struct sysfs_dirent *sysfs_find_child(struct sysfs_dirent *parent,
 	return NULL;
 }
 
+static inline void sysfs_remove(struct sysfs_dirent *sd)
+{
+}
+
 static inline int __must_check sysfs_init(void)
 {
 	return 0;
-- 
1.5.0.3


