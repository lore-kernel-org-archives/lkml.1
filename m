Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZGOOZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZGOOZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZGOOZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:25:39 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:55609 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807AbZGOOZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:25:37 -0400
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: jmorris@namei.org, sds@tycho.nsa.gov, gregkh@susa.de,
       casey@schaufler-ca.com, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs files, directories, and symlinks.
Date: Wed, 15 Jul 2009 09:48:41 -0400
Message-Id: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a setxattr handler to the file, directory, and symlink
inode_operations structures for sysfs. This handler uses two new LSM hooks. The
first hook takes the xattr name and value and turns the context into a secid.
The second hook allows for the secid to be taken from the sysfs_dirent and be
pushed into the inode structure as the actual secid for the inode. As was
suggested by Eric Biederman the struct iattr in the sysfs_dirent structure has
been replaced by a structure which contains the iattr and secid to allow the
changes to persist in the event that the inode representing the sysfs_dirent is
evicted. Because sysfs only stores this information when a change is made all
the optional data is moved into one dynamically allocated field.

This patch addresses an issue where SELinux was denying virtd access to the PCI
configuration entries in sysfs. The lack of setxattr handlers for sysfs
required that a single label be assigned to all entries in sysfs. Granting virtd
access to every entry in sysfs is not an acceptable solution so fine grained
labeling of sysfs is required such that individual entries can be labeled
appropriately.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/sysfs/dir.c             |    1 +
 fs/sysfs/inode.c           |  112 ++++++++++++++++++++++++++++++--------------
 fs/sysfs/symlink.c         |    2 +
 fs/sysfs/sysfs.h           |   11 ++++-
 include/linux/security.h   |   16 ++++++
 security/capability.c      |   12 +++++
 security/security.c        |   11 ++++
 security/selinux/hooks.c   |   24 +++++++++
 security/smack/smack_lsm.c |   42 ++++++++++++++++-
 9 files changed, 193 insertions(+), 38 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index d88d0fa..fc21682 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -760,6 +760,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
 const struct inode_operations sysfs_dir_inode_operations = {
 	.lookup		= sysfs_lookup,
 	.setattr	= sysfs_setattr,
+	.setxattr	= sysfs_setxattr,
 };
 
 static void remove_dir(struct sysfs_dirent *sd)
diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
index 555f0ff..9bb1ce7 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -18,6 +18,7 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/security.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
@@ -35,6 +36,7 @@ static struct backing_dev_info sysfs_backing_dev_info = {
 
 static const struct inode_operations sysfs_inode_operations ={
 	.setattr	= sysfs_setattr,
+	.setxattr	= sysfs_setxattr,
 };
 
 int __init sysfs_inode_init(void)
@@ -42,18 +44,37 @@ int __init sysfs_inode_init(void)
 	return bdi_init(&sysfs_backing_dev_info);
 }
 
+struct sysfs_inode_attrs * sysfs_init_inode_attrs(struct sysfs_dirent * sd)
+{
+	struct sysfs_inode_attrs * attrs;
+	struct iattr * iattrs;
+
+	attrs = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
+	if(!attrs)
+		return NULL;
+	iattrs = &attrs->ia_iattr;
+	
+	/* assign default attributes */
+	iattrs->ia_mode = sd->s_mode;
+	iattrs->ia_uid = 0;
+	iattrs->ia_gid = 0;
+	iattrs->ia_atime = iattrs->ia_mtime = iattrs->ia_ctime = CURRENT_TIME;
+	
+	return attrs;	
+}
 int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 {
 	struct inode * inode = dentry->d_inode;
 	struct sysfs_dirent * sd = dentry->d_fsdata;
-	struct iattr * sd_iattr;
+	struct sysfs_inode_attrs * sd_attrs;
+	struct iattr * iattrs;
 	unsigned int ia_valid = iattr->ia_valid;
 	int error;
 
 	if (!sd)
 		return -EINVAL;
 
-	sd_iattr = sd->s_iattr;
+	sd_attrs = sd->s_iattr;
 
 	error = inode_change_ok(inode, iattr);
 	if (error)
@@ -65,41 +86,57 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	if (error)
 		return error;
 
-	if (!sd_iattr) {
+	if (!sd_attrs) {
 		/* setting attributes for the first time, allocate now */
-		sd_iattr = kzalloc(sizeof(struct iattr), GFP_KERNEL);
-		if (!sd_iattr)
+		sd_attrs = sysfs_init_inode_attrs(sd);
+		if (!sd_attrs)
 			return -ENOMEM;
-		/* assign default attributes */
-		sd_iattr->ia_mode = sd->s_mode;
-		sd_iattr->ia_uid = 0;
-		sd_iattr->ia_gid = 0;
-		sd_iattr->ia_atime = sd_iattr->ia_mtime = sd_iattr->ia_ctime = CURRENT_TIME;
-		sd->s_iattr = sd_iattr;
+		sd->s_iattr = sd_attrs;
+	} else {
+		/* attributes were changed atleast once in past */
+		iattrs = &sd_attrs->ia_iattr;
+
+		if (ia_valid & ATTR_UID)
+			iattrs->ia_uid = iattr->ia_uid;
+		if (ia_valid & ATTR_GID)
+			iattrs->ia_gid = iattr->ia_gid;
+		if (ia_valid & ATTR_ATIME)
+			iattrs->ia_atime = timespec_trunc(iattr->ia_atime,
+					inode->i_sb->s_time_gran);
+		if (ia_valid & ATTR_MTIME)
+			iattrs->ia_mtime = timespec_trunc(iattr->ia_mtime,
+					inode->i_sb->s_time_gran);
+		if (ia_valid & ATTR_CTIME)
+			iattrs->ia_ctime = timespec_trunc(iattr->ia_ctime,
+					inode->i_sb->s_time_gran);
+		if (ia_valid & ATTR_MODE) {
+			umode_t mode = iattr->ia_mode;
+
+			if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
+				mode &= ~S_ISGID;
+			iattrs->ia_mode = sd->s_mode = mode;
+		}
 	}
+	return error;
+}
 
-	/* attributes were changed atleast once in past */
-
-	if (ia_valid & ATTR_UID)
-		sd_iattr->ia_uid = iattr->ia_uid;
-	if (ia_valid & ATTR_GID)
-		sd_iattr->ia_gid = iattr->ia_gid;
-	if (ia_valid & ATTR_ATIME)
-		sd_iattr->ia_atime = timespec_trunc(iattr->ia_atime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MTIME)
-		sd_iattr->ia_mtime = timespec_trunc(iattr->ia_mtime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_CTIME)
-		sd_iattr->ia_ctime = timespec_trunc(iattr->ia_ctime,
-						inode->i_sb->s_time_gran);
-	if (ia_valid & ATTR_MODE) {
-		umode_t mode = iattr->ia_mode;
-
-		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
-			mode &= ~S_ISGID;
-		sd_iattr->ia_mode = sd->s_mode = mode;
-	}
+int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	
+	int error;
+	u32 secid;
+
+	if (!sd)
+		return -EINVAL;
+	if (!sd->s_iattr)
+		sd->s_iattr = sysfs_init_inode_attrs(sd);
+	if (!sd->s_iattr)
+		return -ENOMEM;
+	error = security_xattr_to_secid(name, value, size, &secid);
+	if (!error)
+		sd->s_iattr->ia_secid = secid;
 
 	return error;
 }
@@ -146,6 +183,7 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	struct bin_attribute *bin_attr;
+	struct sysfs_inode_attrs * iattrs;
 
 	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
@@ -154,16 +192,18 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 	inode->i_ino = sd->s_ino;
 	lockdep_set_class(&inode->i_mutex, &sysfs_inode_imutex_key);
 
-	if (sd->s_iattr) {
+	iattrs = sd->s_iattr;
+	if (iattrs) {
 		/* sysfs_dirent has non-default attributes
 		 * get them for the new inode from persistent copy
 		 * in sysfs_dirent
 		 */
-		set_inode_attr(inode, sd->s_iattr);
+		set_inode_attr(inode, &iattrs->ia_iattr);
+		if (iattrs->ia_secid)
+			security_inode_setsecid(inode, iattrs->ia_secid);
 	} else
 		set_default_inode_attr(inode, sd->s_mode);
 
-
 	/* initialize inode according to type */
 	switch (sysfs_type(sd)) {
 	case SYSFS_DIR:
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index 1d897ad..c5081ad 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -16,6 +16,7 @@
 #include <linux/kobject.h>
 #include <linux/namei.h>
 #include <linux/mutex.h>
+#include <linux/security.h>
 
 #include "sysfs.h"
 
@@ -209,6 +210,7 @@ static void sysfs_put_link(struct dentry *dentry, struct nameidata *nd, void *co
 }
 
 const struct inode_operations sysfs_symlink_inode_operations = {
+	.setxattr = sysfs_setxattr,
 	.readlink = generic_readlink,
 	.follow_link = sysfs_follow_link,
 	.put_link = sysfs_put_link,
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index 3fa0d98..f59a211 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -8,6 +8,8 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/fs.h>
+
 struct sysfs_open_dirent;
 
 /* type-specific structures for sysfs_dirent->s_* union members */
@@ -31,6 +33,11 @@ struct sysfs_elem_bin_attr {
 	struct hlist_head	buffers;
 };
 
+struct sysfs_inode_attrs {
+	struct iattr	ia_iattr;
+	u32		ia_secid;
+};
+
 /*
  * sysfs_dirent - the building block of sysfs hierarchy.  Each and
  * every sysfs node is represented by single sysfs_dirent.
@@ -56,7 +63,7 @@ struct sysfs_dirent {
 	unsigned int		s_flags;
 	ino_t			s_ino;
 	umode_t			s_mode;
-	struct iattr		*s_iattr;
+	struct sysfs_inode_attrs *s_iattr;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
@@ -148,6 +155,8 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
+int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
 
diff --git a/include/linux/security.h b/include/linux/security.h
index 1459091..35ecc8d 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1440,6 +1440,9 @@ struct security_operations {
 	int (*inode_setsecurity) (struct inode *inode, const char *name, const void *value, size_t size, int flags);
 	int (*inode_listsecurity) (struct inode *inode, char *buffer, size_t buffer_size);
 	void (*inode_getsecid) (const struct inode *inode, u32 *secid);
+	void (*inode_setsecid)(struct inode *inode, u32 secid);
+	int (*xattr_to_secid) (const char *name, const void *value,
+			size_t size, u32 *secid);
 
 	int (*file_permission) (struct file *file, int mask);
 	int (*file_alloc_security) (struct file *file);
@@ -1699,6 +1702,9 @@ int security_inode_getsecurity(const struct inode *inode, const char *name, void
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(const struct inode *inode, u32 *secid);
+void security_inode_setsecid(struct inode *inode, u32 secid);
+int security_xattr_to_secid(const char *name, const void *value,
+		size_t size, u32 *secid);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -2172,6 +2178,16 @@ static inline void security_inode_getsecid(const struct inode *inode, u32 *secid
 	*secid = 0;
 }
 
+static inline void security_inode_setsecid(struct inode *inode, u32 secid)
+{
+}
+
+static inline int security_xattr_to_secid(const char *name, const void *value,
+		size_t size, u32 *secid)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
diff --git a/security/capability.c b/security/capability.c
index f218dd3..a3f3d5b 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -263,6 +263,16 @@ static void cap_inode_getsecid(const struct inode *inode, u32 *secid)
 	*secid = 0;
 }
 
+static void cap_inode_setsecid(struct inode *inode, u32 secid)
+{
+}
+
+int cap_xattr_to_secid(const char *name, const void *value,
+		size_t size, u32 *secid)
+{
+     return -EOPNOTSUPP;
+}
+
 #ifdef CONFIG_SECURITY_PATH
 static int cap_path_mknod(struct path *dir, struct dentry *dentry, int mode,
 			  unsigned int dev)
@@ -926,6 +936,8 @@ void security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, inode_setsecurity);
 	set_to_cap_if_null(ops, inode_listsecurity);
 	set_to_cap_if_null(ops, inode_getsecid);
+	set_to_cap_if_null(ops, inode_setsecid);
+	set_to_cap_if_null(ops, xattr_to_secid);
 #ifdef CONFIG_SECURITY_PATH
 	set_to_cap_if_null(ops, path_mknod);
 	set_to_cap_if_null(ops, path_mkdir);
diff --git a/security/security.c b/security/security.c
index 4501c5e..8313e15 100644
--- a/security/security.c
+++ b/security/security.c
@@ -615,6 +615,17 @@ void security_inode_getsecid(const struct inode *inode, u32 *secid)
 	security_ops->inode_getsecid(inode, secid);
 }
 
+void security_inode_setsecid(struct inode *inode, u32 secid)
+{
+	security_ops->inode_setsecid(inode, secid);
+}
+
+int security_xattr_to_secid(const char *name, const void *value,
+		size_t size, u32 *secid)
+{
+	return security_ops->xattr_to_secid(name, value, size, secid);
+}
+
 int security_file_permission(struct file *file, int mask)
 {
 	return security_ops->file_permission(file, mask);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 2081055..395c36d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -448,6 +448,10 @@ static int sb_finish_set_opts(struct super_block *sb)
 	    sbsec->behavior > ARRAY_SIZE(labeling_behaviors))
 		sbsec->flags &= ~SE_SBLABELSUPP;
 
+	/* Special handling for sysfs. Is genfs but also has setxattr handler*/
+	if (strncmp(sb->s_type->name, "sysfs", sizeof("sysfs")) == 0)
+		sbsec->flags |= SE_SBLABELSUPP;
+
 	/* Initialize the root inode. */
 	rc = inode_doinit_with_dentry(root_inode, root);
 
@@ -2931,6 +2935,24 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
 	*secid = isec->sid;
 }
 
+static void selinux_inode_setsecid(struct inode *inode, u32 secid)
+{
+	struct inode_security_struct *isec = inode->i_security;
+	isec->sid = secid;
+}
+
+static int selinux_xattr_to_secid(const char *name, const void *value,
+		size_t size, u32 *secid)
+{
+	if (strcmp(name, XATTR_NAME_SELINUX))
+		return -EOPNOTSUPP;
+
+	if (!value || !size)
+		return -EINVAL;
+
+	return security_context_to_sid((void *)value, size, secid);
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -5372,6 +5394,8 @@ static struct security_operations selinux_ops = {
 	.inode_setsecurity =		selinux_inode_setsecurity,
 	.inode_listsecurity =		selinux_inode_listsecurity,
 	.inode_getsecid =		selinux_inode_getsecid,
+	.inode_setsecid =               selinux_inode_setsecid,
+	.xattr_to_secid =               selinux_xattr_to_secid,
 
 	.file_permission =		selinux_file_permission,
 	.file_alloc_security =		selinux_file_alloc_security,
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 1c9bdbc..be66c8e 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -869,6 +869,44 @@ static void smack_inode_getsecid(const struct inode *inode, u32 *secid)
 	*secid = smack_to_secid(isp->smk_inode);
 }
 
+/**
+ * smack_inode_setsecid - Set inode's security id
+ * @inode: inode to set the info in
+ * @secid: secid to set the inode to
+ */
+static void smack_inode_setsecid(struct inode *inode, u32 secid)
+{
+	struct inode_smack *isp = inode->i_security;
+	
+	isp->smk_inode = smack_from_secid(secid);	
+}
+
+/**
+ * smack_xattr_to_secid - convert a valid xattr into a secid
+ * @name: name of the xattr attempting to be converted
+ * @value: value associated with the xattr
+ * @size: size of value
+ * @secid: location to place resuting secid
+ */
+static int smack_xattr_to_secid(const char *name, const void* value,
+			size_t size, u32 *secid)
+{
+	char *sp;	
+
+	if (strcmp(name, XATTR_NAME_SMACK))
+		return -EOPNOTSUPP;
+
+	if (!value || !size)
+		return -EINVAL;
+
+	sp = smk_import(value, size);
+	if (sp == NULL)
+		return -EINVAL;
+
+	*secid = smack_to_secid(sp);
+}
+
+
 /*
  * File Hooks
  */
@@ -3062,7 +3100,9 @@ struct security_operations smack_ops = {
 	.inode_setsecurity = 		smack_inode_setsecurity,
 	.inode_listsecurity = 		smack_inode_listsecurity,
 	.inode_getsecid =		smack_inode_getsecid,
-
+	.inode_setsecid = 		smack_inode_setsecid,
+	.xattr_to_secid =		smack_xattr_to_secid,
+	
 	.file_permission = 		smack_file_permission,
 	.file_alloc_security = 		smack_file_alloc_security,
 	.file_free_security = 		smack_file_free_security,
-- 
1.5.6.6

