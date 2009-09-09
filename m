Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbZIISZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbZIISZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbZIISZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:25:46 -0400
Received: from msux-gh1-uea01.nsa.gov ([63.239.67.1]:45432 "EHLO
	msux-gh1-uea01.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZIISZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:25:45 -0400
Subject: [PATCH 3/3] sysfs: Add labeling support for sysfs
From: Stephen Smalley <sds@tycho.nsa.gov>
To: James Morris <jmorris@namei.org>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, casey@schaufler-ca.com,
       gregkh@suse.de, ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org>
References: <1252002358-6612-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1252002358-6612-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <alpine.LRH.2.00.0909071147100.2538@tundra.namei.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Wed, 09 Sep 2009 14:25:37 -0400
Message-Id: <1252520737.13634.833.camel@moss-pluto.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  David P. Quigley <dpquigl@tycho.nsa.gov>

This patch adds a setxattr handler to the file, directory, and symlink
inode_operations structures for sysfs. The patch uses hooks introduced in the
previous patch to handle the getting and setting of security information for
the sysfs inodes. As was suggested by Eric Biederman the struct iattr in the
sysfs_dirent structure has been replaced by a structure which contains the
iattr, secdata and secdata length to allow the changes to persist in the event
that the inode representing the sysfs_dirent is evicted. Because sysfs only
stores this information when a change is made all the optional data is moved
into one dynamically allocated field.

This patch addresses an issue where SELinux was denying virtd access to the PCI
configuration entries in sysfs. The lack of setxattr handlers for sysfs
required that a single label be assigned to all entries in sysfs. Granting virtd
access to every entry in sysfs is not an acceptable solution so fine grained
labeling of sysfs is required such that individual entries can be labeled
appropriately.

[sds:  Fixed compile-time warnings, coding style, and setting of inode security init flags.]

Signed-off-by: David P. Quigley <dpquigl@tycho.nsa.gov>
Signed-off-by: Stephen D. Smalley <sds@tycho.nsa.gov>

---
 fs/sysfs/dir.c             |    1 
 fs/sysfs/inode.c           |  134 ++++++++++++++++++++++++++++++++-------------
 fs/sysfs/symlink.c         |    2 
 fs/sysfs/sysfs.h           |   12 +++-
 security/selinux/hooks.c   |    5 +
 security/smack/smack_lsm.c |    1 
 6 files changed, 118 insertions(+), 37 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 14f2d71..0050fc4 100644
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
index 555f0ff..d4f5bda 100644
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -18,6 +18,8 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/xattr.h>
+#include <linux/security.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
@@ -35,6 +37,7 @@ static struct backing_dev_info sysfs_backing_dev_info = {
 
 static const struct inode_operations sysfs_inode_operations ={
 	.setattr	= sysfs_setattr,
+	.setxattr	= sysfs_setxattr,
 };
 
 int __init sysfs_inode_init(void)
@@ -42,18 +45,37 @@ int __init sysfs_inode_init(void)
 	return bdi_init(&sysfs_backing_dev_info);
 }
 
+struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
+{
+	struct sysfs_inode_attrs *attrs;
+	struct iattr *iattrs;
+
+	attrs = kzalloc(sizeof(struct sysfs_inode_attrs), GFP_KERNEL);
+	if (!attrs)
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
+	struct sysfs_inode_attrs *sd_attrs;
+	struct iattr *iattrs;
 	unsigned int ia_valid = iattr->ia_valid;
 	int error;
 
 	if (!sd)
 		return -EINVAL;
 
-	sd_iattr = sd->s_iattr;
+	sd_attrs = sd->s_iattr;
 
 	error = inode_change_ok(inode, iattr);
 	if (error)
@@ -65,42 +87,77 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
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
+		/* attributes were changed at least once in past */
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
+	struct sysfs_inode_attrs *iattrs;
+	void *secdata;
+	int error;
+	u32 secdata_len = 0;
+
+	if (!sd)
+		return -EINVAL;
+	if (!sd->s_iattr)
+		sd->s_iattr = sysfs_init_inode_attrs(sd);
+	if (!sd->s_iattr)
+		return -ENOMEM;
+
+	iattrs = sd->s_iattr;
+
+	if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
+		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
+		error = security_inode_setsecurity(dentry->d_inode, suffix,
+						value, size, flags);
+		if (error)
+			goto out;
+		error = security_inode_getsecctx(dentry->d_inode,
+						&secdata, &secdata_len);
+		if (error)
+			goto out;
+		if (iattrs->ia_secdata)
+			security_release_secctx(iattrs->ia_secdata,
+						iattrs->ia_secdata_len);
+		iattrs->ia_secdata = secdata;
+		iattrs->ia_secdata_len = secdata_len;
 
+	} else
+		return -EINVAL;
+out:
 	return error;
 }
 
@@ -146,6 +203,7 @@ static int sysfs_count_nlink(struct sysfs_dirent *sd)
 static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
 {
 	struct bin_attribute *bin_attr;
+	struct sysfs_inode_attrs *iattrs;
 
 	inode->i_private = sysfs_get(sd);
 	inode->i_mapping->a_ops = &sysfs_aops;
@@ -154,16 +212,20 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
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
+		if (iattrs->ia_secdata)
+			security_inode_notifysecctx(inode,
+						iattrs->ia_secdata,
+						iattrs->ia_secdata_len);
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
index 3fa0d98..af4c4e7 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -8,6 +8,8 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/fs.h>
+
 struct sysfs_open_dirent;
 
 /* type-specific structures for sysfs_dirent->s_* union members */
@@ -31,6 +33,12 @@ struct sysfs_elem_bin_attr {
 	struct hlist_head	buffers;
 };
 
+struct sysfs_inode_attrs {
+	struct iattr	ia_iattr;
+	void		*ia_secdata;
+	u32		ia_secdata_len;
+};
+
 /*
  * sysfs_dirent - the building block of sysfs hierarchy.  Each and
  * every sysfs node is represented by single sysfs_dirent.
@@ -56,7 +64,7 @@ struct sysfs_dirent {
 	unsigned int		s_flags;
 	ino_t			s_ino;
 	umode_t			s_mode;
-	struct iattr		*s_iattr;
+	struct sysfs_inode_attrs *s_iattr;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
@@ -148,6 +156,8 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
+int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+		size_t size, int flags);
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 7118be2..417f7c9 100644
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
 
@@ -2923,6 +2927,7 @@ static int selinux_inode_setsecurity(struct inode *inode, const char *name,
 		return rc;
 
 	isec->sid = newsid;
+	isec->initialized = 1;
 	return 0;
 }
 
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 7dc13c3..61df146 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -1666,6 +1666,7 @@ static int smack_inode_setsecurity(struct inode *inode, const char *name,
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
 		nsp->smk_inode = sp;
+		nsp->smk_flags |= SMK_INODE_INSTANT;
 		return 0;
 	}
 	/*

-- 
Stephen Smalley
National Security Agency

