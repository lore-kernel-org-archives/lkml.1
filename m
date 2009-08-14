Return-Path: <linux-kernel-owner+w=401wt.eu-S1755938AbZHNFBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938AbZHNFBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 01:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZHNFBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 01:01:06 -0400
Received: from smtp109.prem.mail.sp1.yahoo.com ([98.136.44.54]:43171 "HELO
	smtp109.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755768AbZHNFBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 01:01:02 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: vFkVR_wVM1n7L19.ny6CTPyc36V6EMCmxYlBO5rsxTlpgYPtz6s8c4BaEK2_Mz2z6Zljc3qLV0j4Dwasb_545TdHgHC1RciD3GEGRD4wgxpAG0LPvV1yRAyIaIBFOD48S0MTYnkchgxTTSoPpwX6YCkc4ba6lRQesHQ82Ne8jdSXElin6.UD9gHiEwgvkbSnbRU8yz6ELkOHwwhZlTXivhKzw4x7dTcL7aVFoJA9DNuD3I5h_t3rYSC22vflmK1EVqIAo0kcUyA_T7MuAJtC.3Tu_Nx0wWaSTBhAREkM1YYHAW3pSiScgElYHbIUG9Ku2JNYnBen_qLU8QVdj1zUBkJ0eEL1gtrXSFAxq7Ewn8G0JZ4eLYHYmPB.EyUSCrI-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A84EF1D.8060408@schaufler-ca.com>
Date: Thu, 13 Aug 2009 21:59:09 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: jmorris@namei.org, sds@tycho.nsa.gov, gregkh@susa.de,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov
Subject: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
In-Reply-To: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

This patch is in response to David P. Quigley's proposal from
July of this year. That patch provided special case handling of
LSM xattrs in the security name space.

This patch provides an in memory representation of general
xattrs. It currently only allows xattrs in the security namespace,
but that is only because the support of ACLs is beyond the
day's needs. The list of xattrs for a given file is created on
demand and a system that does not use xattrs should be pretty
well oblivious to the changes. On the down side, this requires
an unpleasant locking scheme. Improvements would of course be
welcome.

This scheme should generalize to any memory based file system,
although I have not attempted to create a generic implementation
here.

Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 fs/sysfs/dir.c     |    4 
 fs/sysfs/inode.c   |  210 +++++++++++++++++++++++++++++++++++++++++++
 fs/sysfs/symlink.c |   10 +-
 fs/sysfs/sysfs.h   |   16 +++
 4 files changed, 237 insertions(+), 3 deletions(-)

diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/fs/sysfs/dir.c linux-0812/fs/sysfs/dir.c
--- linux-2.6/fs/sysfs/dir.c	2009-08-11 16:22:20.000000000 -0700
+++ linux-0812/fs/sysfs/dir.c	2009-08-12 11:10:45.000000000 -0700
@@ -760,6 +760,10 @@ static struct dentry * sysfs_lookup(stru
 const struct inode_operations sysfs_dir_inode_operations = {
 	.lookup		= sysfs_lookup,
 	.setattr	= sysfs_setattr,
+	.setxattr	= sysfs_setxattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
+	.removexattr	= sysfs_removexattr,
 };
 
 static void remove_dir(struct sysfs_dirent *sd)
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/fs/sysfs/inode.c linux-0812/fs/sysfs/inode.c
--- linux-2.6/fs/sysfs/inode.c	2009-03-28 13:47:33.000000000 -0700
+++ linux-0812/fs/sysfs/inode.c	2009-08-12 11:08:28.000000000 -0700
@@ -18,6 +18,7 @@
 #include <linux/capability.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/xattr.h>
 #include "sysfs.h"
 
 extern struct super_block * sysfs_sb;
@@ -35,8 +36,13 @@ static struct backing_dev_info sysfs_bac
 
 static const struct inode_operations sysfs_inode_operations ={
 	.setattr	= sysfs_setattr,
+	.setxattr	= sysfs_setxattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
+	.removexattr	= sysfs_removexattr,
 };
 
+
 int __init sysfs_inode_init(void)
 {
 	return bdi_init(&sysfs_backing_dev_info);
@@ -104,6 +110,210 @@ int sysfs_setattr(struct dentry * dentry
 	return error;
 }
 
+/*
+ * Extended attributes are stored on a list off of the dirent.
+ * The list head itself is allocated when needed so that a file
+ * with no xattrs does not have the overhead of a list head.
+ * Unfortunately, to lock the xattr list for each dentry would
+ * require a lock in each dentry, which would defeat the purpose
+ * of allocating the list head. So one big sysfs xattr lock.
+ *
+ * A better solution would be welcome.
+ */
+static DEFINE_MUTEX(sysfs_xattr_lock);
+
+static struct sysfs_xattr *new_xattr(const char *name, const void *value,
+					size_t size)
+{
+	struct sysfs_xattr *nxattr;
+	void *nvalue;
+	char *nname;
+
+	nxattr = kzalloc(sizeof(*nxattr), GFP_KERNEL);
+	if (!nxattr)
+		return NULL;
+	nvalue = kzalloc(size, GFP_KERNEL);
+	if (!nvalue) {
+		kfree(nxattr);
+		return NULL;
+	}
+	nname = kzalloc(strlen(name) + 1, GFP_KERNEL);
+	if (!nname) {
+		kfree(nxattr);
+		kfree(nvalue);
+		return NULL;
+	}
+	memcpy(nvalue, value, size);
+	strcpy(nname, name);
+	nxattr->sx_name = nname;
+	nxattr->sx_value = nvalue;
+	nxattr->sx_size = size;
+
+	return nxattr;
+}
+
+int sysfs_setxattr(struct dentry *dentry, const char *name,
+			const void *value, size_t size, int flags)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct list_head *xlist;
+	struct sysfs_xattr *nxattr;
+	void *nvalue;
+	int rc = 0;
+
+	/*
+	 * Only support the security namespace.
+	 * Only allow privileged processes to set them.
+	 * It has to be OK with the LSM, if any, as well.
+	 */
+	if (strncmp(name, XATTR_SECURITY_PREFIX,
+			sizeof XATTR_SECURITY_PREFIX - 1))
+		return -ENOTSUPP;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	mutex_lock(&sysfs_xattr_lock);
+
+	if (!sd->s_xattr) {
+		sd->s_xattr = kzalloc(sizeof(*xlist), GFP_KERNEL);
+		if (!sd->s_xattr) {
+			rc = -ENOMEM;
+			goto unlock_out;
+		}
+		INIT_LIST_HEAD(sd->s_xattr);
+	}
+	xlist = sd->s_xattr;
+
+	list_for_each_entry(nxattr, xlist, list) {
+		if (!strcmp(nxattr->sx_name, name)) {
+			if (flags & XATTR_CREATE) {
+				rc = -EEXIST;
+				goto unlock_out;
+			}
+			nvalue = kzalloc(size, GFP_KERNEL);
+			if (!nvalue) {
+				rc = -ENOMEM;
+				goto unlock_out;
+			}
+			memcpy(nvalue, value, size);
+			kfree(nxattr->sx_value);
+			nxattr->sx_value = nvalue;
+			nxattr->sx_size = size;
+			rc = 0;
+			goto unlock_out;
+		}
+	}
+	if (flags & XATTR_REPLACE) {
+		rc = -ENOENT;
+		goto unlock_out;
+	}
+	nxattr = new_xattr(name, value, size);
+	list_add_tail(&nxattr->list, xlist);
+
+unlock_out:
+	mutex_unlock(&sysfs_xattr_lock);
+	return rc;
+}
+
+ssize_t sysfs_getxattr(struct dentry *dentry, const char *name,
+			void *value, size_t size)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct list_head *xlist = sd->s_xattr;
+	struct sysfs_xattr *nxattr;
+	int rc = -ENODATA;
+
+	if (!xlist)
+		return -ENODATA;
+
+	mutex_lock(&sysfs_xattr_lock);
+
+	list_for_each_entry(nxattr, xlist, list) {
+		if (!strcmp(nxattr->sx_name, name)) {
+			if (size <= 0) {
+				rc = nxattr->sx_size;
+				goto unlock_out;
+			}
+			if (nxattr->sx_size > size) {
+				rc = -ERANGE;
+				goto unlock_out;
+			}
+			memcpy(value, nxattr->sx_value, nxattr->sx_size);
+			rc = nxattr->sx_size;
+			goto unlock_out;
+		}
+	}
+
+unlock_out:
+	mutex_unlock(&sysfs_xattr_lock);
+	return rc;
+}
+
+ssize_t sysfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct list_head *xlist = sd->s_xattr;
+	struct sysfs_xattr *nxattr;
+	ssize_t total = 0;
+	char *cp = buffer;
+
+	if (!xlist)
+		return 0;
+
+	mutex_lock(&sysfs_xattr_lock);
+
+	list_for_each_entry(nxattr, xlist, list)
+		total += strlen(nxattr->sx_name) + 1;
+
+	if (total > size) {
+		total = -ERANGE;
+		goto unlock_out;
+	}
+
+	list_for_each_entry(nxattr, xlist, list) {
+		strcpy(cp, nxattr->sx_name);
+		cp += strlen(nxattr->sx_name) + 1;
+	}
+
+unlock_out:
+	mutex_unlock(&sysfs_xattr_lock);
+	return total;
+}
+
+int sysfs_removexattr(struct dentry *dentry, const char *name)
+{
+	struct sysfs_dirent *sd = dentry->d_fsdata;
+	struct list_head *xlist = sd->s_xattr;
+	struct sysfs_xattr *nxattr;
+	int rc = -ENODATA;
+
+	if (!xlist)
+		return -ENODATA;
+
+	mutex_lock(&sysfs_xattr_lock);
+
+	list_for_each_entry(nxattr, xlist, list) {
+		if (!strcmp(nxattr->sx_name, name)) {
+			list_del(&nxattr->list);
+			if (list_empty(xlist)) {
+				kfree(xlist);
+				sd->s_xattr = NULL;
+			}
+			kfree(nxattr->sx_name);
+			kfree(nxattr->sx_value);
+			kfree(nxattr);
+			rc = 0;
+			goto unlock_out;
+		}
+	}
+
+unlock_out:
+	mutex_unlock(&sysfs_xattr_lock);
+	return rc;
+}
+
+
 static inline void set_default_inode_attr(struct inode * inode, mode_t mode)
 {
 	inode->i_mode = mode;
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/fs/sysfs/symlink.c linux-0812/fs/sysfs/symlink.c
--- linux-2.6/fs/sysfs/symlink.c	2009-06-24 20:10:07.000000000 -0700
+++ linux-0812/fs/sysfs/symlink.c	2009-08-12 11:07:52.000000000 -0700
@@ -209,9 +209,13 @@ static void sysfs_put_link(struct dentry
 }
 
 const struct inode_operations sysfs_symlink_inode_operations = {
-	.readlink = generic_readlink,
-	.follow_link = sysfs_follow_link,
-	.put_link = sysfs_put_link,
+	.setxattr	= sysfs_setxattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
+	.removexattr	= sysfs_removexattr,
+	.readlink	= generic_readlink,
+	.follow_link	= sysfs_follow_link,
+	.put_link	= sysfs_put_link,
 };
 
 
diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/fs/sysfs/sysfs.h linux-0812/fs/sysfs/sysfs.h
--- linux-2.6/fs/sysfs/sysfs.h	2009-03-28 13:47:33.000000000 -0700
+++ linux-0812/fs/sysfs/sysfs.h	2009-08-12 11:07:32.000000000 -0700
@@ -31,6 +31,13 @@ struct sysfs_elem_bin_attr {
 	struct hlist_head	buffers;
 };
 
+struct sysfs_xattr {
+	struct list_head	list;
+	char			*sx_name;
+	char			*sx_value;
+	size_t			sx_size;	/* size of value */
+};
+
 /*
  * sysfs_dirent - the building block of sysfs hierarchy.  Each and
  * every sysfs node is represented by single sysfs_dirent.
@@ -57,6 +64,7 @@ struct sysfs_dirent {
 	ino_t			s_ino;
 	umode_t			s_mode;
 	struct iattr		*s_iattr;
+	struct list_head	*s_xattr;
 };
 
 #define SD_DEACTIVATED_BIAS		INT_MIN
@@ -148,6 +156,14 @@ static inline void __sysfs_put(struct sy
 struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
 void sysfs_delete_inode(struct inode *inode);
 int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
+int sysfs_setxattr(struct dentry *dentry, const char *name,
+			const void *value, size_t size, int flags);
+ssize_t sysfs_getxattr(struct dentry *dentry, const char *name,
+			void *value, size_t size);
+ssize_t sysfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
+int sysfs_removexattr(struct dentry *dentry, const char *name);
+
+
 int sysfs_hash_and_remove(struct sysfs_dirent *dir_sd, const char *name);
 int sysfs_inode_init(void);
 

