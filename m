Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZHRDzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZHRDzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbZHRDzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:55:07 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:20259 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751894AbZHRDzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:55:05 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: q8ydGFYVM1n2KY_CqC4kZ.xLSTDKOlIlIihZF6.RbIVtP7EK0s3EVVNP37TdUiDNYevVvz05qyDvOvr5lUck7mSbFxRii0PfDdQnNcvNajpu5n4.6sK1xmi22N1Wj3ZEutVjdqt63uUWJm_HQM3Ag85GrVpxb5i_WWZOxB2bThHWEz_LH7ncU6expRBMTUiHoG41vtBFapshWvhc6fZu7Xjm6RW47Wb8vAw4pLyqs.8IjSJir.BTpysvPnly1p45KCKtvH2dfU26R4p7hkVLVqL6UpfmOUHlU4dxFLfez2qaoEdduN7KG3YnWCSOGd7.aisfuRzf01OHe4qukKVuV5jxlmACSOJ4C7.YT2r8BNxNehFJ2_t1LQuvhIYViwk-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A8A2616.8020809@schaufler-ca.com>
Date: Mon, 17 Aug 2009 20:55:02 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       Stephen Smalley <sds@tycho.nsa.gov>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] Security/sysfs: v2 - Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	<4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>	<4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>	<4A864008.50907@schaufler-ca.com> <m1my61sjie.fsf@fess.ebiederm.org>
In-Reply-To: <m1my61sjie.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Casey Schaufler <casey@schaufler-ca.com>

Another approach to limited xattr support in sysfs.

I tried to listen to the objections to a linked list representation
and I think that I understand that there isn't really any interest
in supporting xattrs for real, only for those maintained by LSMs.
I also looked carefully into the claims that memory usage is
critical and that the code I had before was duplicating effort.

This version lets the surrounding code do as much of the work as
possible. Unlike the initial proposal for sysfs xattrs, it does not
introduce any new LSM hooks, it uses hooks that already exist. It
does not support any attributes on its own, it only provides for
the attribute advertised by security_inode_listsecurity(). It could
easily be used by other filesystems to provide the same LSM xattr
support. It could also be extended to do the list based support for
arbitrary xattrs without too much effort.

Probably the oddest bit is that the inode_getsecurity hooks need to
check to see if they are getting called before the inode is instantiated
and return -ENODATA in that event. It would be possible to do a
filesystem specific check instead, but this way provides for generally
correct behavior at small cost.

This has been tested with Smack, but not SELinux. I think that
SELinux will work correctly, but it could be that a labeling
behavior that is different than the "usual" instantiation labeling
is actually desired. That would be an easy change.

As always, let me know if I missed something obvious or if there's a
fatal flaw in the scheme.

Thank you


Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>

---

 fs/sysfs/Makefile          |    2 
 fs/sysfs/dir.c             |    4 +
 fs/sysfs/inode.c           |    4 +
 fs/sysfs/symlink.c         |   10 +++-
 fs/sysfs/sysfs.h           |   10 ++++
 fs/sysfs/xattr.c           |   71 +++++++++++++++++++++++++++++++++++
 security/selinux/hooks.c   |    6 ++
 security/smack/smack_lsm.c |   11 ++++-
 8 files changed, 113 insertions(+), 5 deletions(-)

diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/fs/sysfs/dir.c linux-0816/fs/sysfs/dir.c
--- linux-2.6/fs/sysfs/dir.c	2009-08-11 16:22:20.000000000 -0700
+++ linux-0816/fs/sysfs/dir.c	2009-08-16 10:48:23.000000000 -0700
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
diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/fs/sysfs/inode.c linux-0816/fs/sysfs/inode.c
--- linux-2.6/fs/sysfs/inode.c	2009-03-28 13:47:33.000000000 -0700
+++ linux-0816/fs/sysfs/inode.c	2009-08-16 10:43:44.000000000 -0700
@@ -35,6 +35,10 @@ static struct backing_dev_info sysfs_bac
 
 static const struct inode_operations sysfs_inode_operations ={
 	.setattr	= sysfs_setattr,
+	.setxattr	= sysfs_setxattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
+	.removexattr	= sysfs_removexattr,
 };
 
 int __init sysfs_inode_init(void)
diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/fs/sysfs/Makefile linux-0816/fs/sysfs/Makefile
--- linux-2.6/fs/sysfs/Makefile	2009-02-11 09:05:29.000000000 -0800
+++ linux-0816/fs/sysfs/Makefile	2009-08-16 09:41:53.000000000 -0700
@@ -3,4 +3,4 @@
 #
 
 obj-y		:= inode.o file.o dir.o symlink.o mount.o bin.o \
-		   group.o
+		   group.o xattr.o
diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/fs/sysfs/symlink.c linux-0816/fs/sysfs/symlink.c
--- linux-2.6/fs/sysfs/symlink.c	2009-06-24 20:10:07.000000000 -0700
+++ linux-0816/fs/sysfs/symlink.c	2009-08-16 10:41:39.000000000 -0700
@@ -209,9 +209,13 @@ static void sysfs_put_link(struct dentry
 }
 
 const struct inode_operations sysfs_symlink_inode_operations = {
-	.readlink = generic_readlink,
-	.follow_link = sysfs_follow_link,
-	.put_link = sysfs_put_link,
+	.readlink	= generic_readlink,
+	.follow_link	= sysfs_follow_link,
+	.put_link	= sysfs_put_link,
+	.setxattr	= sysfs_setxattr,
+	.getxattr	= sysfs_getxattr,
+	.listxattr	= sysfs_listxattr,
+	.removexattr	= sysfs_removexattr,
 };
 
 
diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/fs/sysfs/sysfs.h linux-0816/fs/sysfs/sysfs.h
--- linux-2.6/fs/sysfs/sysfs.h	2009-03-28 13:47:33.000000000 -0700
+++ linux-0816/fs/sysfs/sysfs.h	2009-08-16 10:46:43.000000000 -0700
@@ -171,3 +171,13 @@ void unmap_bin_file(struct sysfs_dirent 
  * symlink.c
  */
 extern const struct inode_operations sysfs_symlink_inode_operations;
+
+/*
+ * xattr.c
+ */
+int sysfs_setxattr(struct dentry *dentry, const char *name,
+			const void *value, size_t size, int flags);
+ssize_t sysfs_getxattr(struct dentry *dentry, const char *name,
+			void *value, size_t size);
+ssize_t sysfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
+int sysfs_removexattr(struct dentry *dentry, const char *name);
diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/fs/sysfs/xattr.c linux-0816/fs/sysfs/xattr.c
--- linux-2.6/fs/sysfs/xattr.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-0816/fs/sysfs/xattr.c	2009-08-17 08:42:44.000000000 -0700
@@ -0,0 +1,71 @@
+/*
+ * fs/sysfs/xattr.c - Support for sysfs extended attributes.
+ *
+ * Copyright (c) 2007 Casey Schaufler <casey@scahufler-ca.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/pagemap.h>
+#include <linux/namei.h>
+#include <linux/backing-dev.h>
+#include <linux/capability.h>
+#include <linux/security.h>
+#include <linux/errno.h>
+#include <linux/sched.h>
+#include <linux/xattr.h>
+#include "sysfs.h"
+
+/*
+ * For setting and getting let the LSM decide what to do with
+ * the xattr. If it isn't an xattr the LSM cares about, don't
+ * accept it.
+ */
+int sysfs_setxattr(struct dentry *dentry, const char *name,
+			const void *value, size_t size, int flags)
+{
+	int rc;
+
+	if (strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN))
+		return -ENODATA;
+
+	name += XATTR_SECURITY_PREFIX_LEN;
+	rc = security_inode_setsecurity(dentry->d_inode, name, value,
+						size, flags);
+
+	return rc;
+}
+
+ssize_t sysfs_getxattr(struct dentry *dentry, const char *name,
+			void *value, size_t size)
+{
+	void *buffer;
+	int len;
+
+	if (strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN))
+		return -ENODATA;
+
+	name += XATTR_SECURITY_PREFIX_LEN;
+	len = security_inode_getsecurity(dentry->d_inode, name, &buffer, true);
+
+	if (len > 0)
+		memcpy(value, buffer, len);
+
+	security_release_secctx(buffer, len);
+
+	return len;
+}
+
+ssize_t sysfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
+{
+	ssize_t rc;
+
+	rc = security_inode_listsecurity(dentry->d_inode, buffer, size);
+
+	return rc;
+}
+
+int sysfs_removexattr(struct dentry *dentry, const char *name)
+{
+	return -ENODATA;
+}
diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/security/selinux/hooks.c linux-0816/security/selinux/hooks.c
--- linux-2.6/security/selinux/hooks.c	2009-08-11 16:22:21.000000000 -0700
+++ linux-0816/security/selinux/hooks.c	2009-08-16 19:30:38.000000000 -0700
@@ -2870,6 +2870,12 @@ static int selinux_inode_getsecurity(con
 		return -EOPNOTSUPP;
 
 	/*
+	 * This can happen for memory based file systems.
+	 */
+	if (!isec->initialized)
+		return -ENODATA;
+
+	/*
 	 * If the caller has CAP_MAC_ADMIN, then get the raw context
 	 * value even if it is not defined by current policy; otherwise,
 	 * use the in-core value under current policy.
diff -uprN -X linux-2.6//Documentation/dontdiff linux-2.6/security/smack/smack_lsm.c linux-0816/security/smack/smack_lsm.c
--- linux-2.6/security/smack/smack_lsm.c	2009-06-24 20:10:34.000000000 -0700
+++ linux-0816/security/smack/smack_lsm.c	2009-08-16 20:06:13.000000000 -0700
@@ -796,10 +796,19 @@ static int smack_inode_getsecurity(const
 	struct socket *sock;
 	struct super_block *sbp;
 	struct inode *ip = (struct inode *)inode;
+	struct inode_smack *blobp = inode->i_security;
 	char *isp;
 	int ilen;
 	int rc = 0;
 
+	/*
+	 * If this is an uninstantiated inode the file system code
+	 * must have decided to ask the LSM what the label on the
+	 * file is. Respond with an indication to that effect.
+	 */
+	if ((blobp->smk_flags & SMK_INODE_INSTANT) == 0)
+		return -ENODATA;
+
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
 		isp = smk_of_inode(inode);
 		ilen = strlen(isp) + 1;
@@ -848,7 +857,7 @@ static int smack_inode_getsecurity(const
 static int smack_inode_listsecurity(struct inode *inode, char *buffer,
 				    size_t buffer_size)
 {
-	int len = strlen(XATTR_NAME_SMACK);
+	int len = strlen(XATTR_NAME_SMACK) + 1;
 
 	if (buffer != NULL && len <= buffer_size) {
 		memcpy(buffer, XATTR_NAME_SMACK, len);

