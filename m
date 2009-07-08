Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZGHRt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZGHRt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 13:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZGHRtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 13:49:18 -0400
Received: from mummy.ncsc.mil ([144.51.88.129]:53582 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086AbZGHRtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 13:49:17 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jul 2009 13:49:16 EDT
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: jmorris@namei.org, gregkh@suse.de, sds@tycho.nsa.gov
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>
Subject: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs files, directories, and symlinks.
Date: Wed,  8 Jul 2009 13:28:26 -0400
Message-Id: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a setxattr handler to the file, directory, and symlink
inode_operations structures for sysfs. This handler uses two new LSM hooks. The
first hook takes the xattr name and value and turns the context into a secid.
This is embedded into the sysfs_dirent structure so it remains persistent even
if the inode structures are evicted from the cache. The second hook allows for
the secid to be taken from the sysfs_dirent and be pushed into the inode
structure as the actual secid for the inode.

This patch addresses an issue where SELinux was denying KVM access to the PCI
configuration entries in sysfs. The lack of setxattr handlers for sysfs
required that a single label be assigned to all entries in sysfs. Granting KVM
access to every entry in sysfs is not an acceptable solution so fine grained
labeling of sysfs is required such that individual entries can be labeled
appropriately.

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
---
 fs/sysfs/dir.c             |    1 +
 fs/sysfs/inode.c           |   21 +++++++++++++++++++++
 fs/sysfs/symlink.c         |    2 ++
 fs/sysfs/sysfs.h           |    3 +++
 include/linux/security.h   |   16 ++++++++++++++++
 security/capability.c      |   12 ++++++++++++
 security/security.c        |   11 +++++++++++
 security/selinux/hooks.c   |   24 ++++++++++++++++++++++++
 security/smack/smack_lsm.c |   42 +++++++++++++++++++++++++++++++++++++++++-
 9 files changed, 131 insertions(+), 1 deletions(-)

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
index 555f0ff..9f8b760 100644
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
@@ -104,6 +106,23 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
 	return error;
 }
 
+int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	int error;
+	u32 secid;
+
+	if (!sd)
+		return -EINVAL;
+
+	error = security_xattr_to_secid(name, value, size, &secid);
+	if (!error)
+		sd->s_secid = secid;
+
+	return error;
+}
+
 static inline void set_default_inode_attr(struct inode * inode, mode_t mode)
 {
 	inode->i_mode = mode;
@@ -163,6 +182,8 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 	} else
 		set_default_inode_attr(inode, sd->s_mode);
 
+	if (sd->s_secid)
+		security_inode_setsecid(inode, sd->s_secid);
 
 	/* initialize inode according to type */
 	switch (sysfs_type(sd)) {
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
index 3fa0d98..732d183 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -57,6 +57,7 @@ struct sysfs_dirent {
 	ino_t			s_ino;
 	umode_t			s_mode;
 	struct iattr		*s_iattr;
+	u32			s_secid;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
@@ -148,6 +149,8 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
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

