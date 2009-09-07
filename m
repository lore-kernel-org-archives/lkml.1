Return-Path: <linux-kernel-owner+w=401wt.eu-S1752503AbZIGVFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503AbZIGVFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZIGVFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:05:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54963 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbZIGVFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:05:06 -0400
Date: Mon, 7 Sep 2009 14:04:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Filesystem Mailing List <linux-fsdevel@vger.kernel.org>
cc: Eric Paris <eparis@redhat.com>, Mimi Zohar <zohar@us.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 5/8] Make 'check_acl()' a first-class filesystem op
In-Reply-To: <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0909071403390.3419@localhost.localdomain>
References: <alpine.LFD.2.01.0909071337510.3419@localhost.localdomain> <alpine.LFD.2.01.0909071401210.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402220.3419@localhost.localdomain> <alpine.LFD.2.01.0909071402510.3419@localhost.localdomain>
 <alpine.LFD.2.01.0909071403110.3419@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Aug 2009 11:51:25 -0700

This is stage one in flattening out the callchains for the common
permission testing.  Rather than have most filesystem implemnt their
inode->i_op->permission own function that just calls back down to the
VFS layers 'generic_permission()' with the per-filesystem ACL checking
function, the filesystem can just expose its 'check_acl' function
directly, and let the VFS layer do everything for it.

This is all just preparatory - no filesystem actually enables this yet.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/namei.c         |   62 +++++++++++++++++++++++++++++----------------------
 include/linux/fs.h |    1 +
 2 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 7959e70..5953913 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -169,19 +169,10 @@ void putname(const char *name)
 EXPORT_SYMBOL(putname);
 #endif
 
-
-/**
- * generic_permission  -  check for access rights on a Posix-like filesystem
- * @inode:	inode to check access rights for
- * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
- * @check_acl:	optional callback to check for Posix ACLs
- *
- * Used to check for read/write/execute permissions on a file.
- * We use "fsuid" for this, letting us set arbitrary permissions
- * for filesystem access without changing the "normal" uids which
- * are used for other things..
+/*
+ * This does basic POSIX ACL permission checking
  */
-int generic_permission(struct inode *inode, int mask,
+static int acl_permission_check(struct inode *inode, int mask,
 		int (*check_acl)(struct inode *inode, int mask))
 {
 	umode_t			mode = inode->i_mode;
@@ -193,9 +184,7 @@ int generic_permission(struct inode *inode, int mask,
 	else {
 		if (IS_POSIXACL(inode) && (mode & S_IRWXG) && check_acl) {
 			int error = check_acl(inode, mask);
-			if (error == -EACCES)
-				goto check_capabilities;
-			else if (error != -EAGAIN)
+			if (error != -EAGAIN)
 				return error;
 		}
 
@@ -208,8 +197,32 @@ int generic_permission(struct inode *inode, int mask,
 	 */
 	if ((mask & ~mode) == 0)
 		return 0;
+	return -EACCES;
+}
+
+/**
+ * generic_permission  -  check for access rights on a Posix-like filesystem
+ * @inode:	inode to check access rights for
+ * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC)
+ * @check_acl:	optional callback to check for Posix ACLs
+ *
+ * Used to check for read/write/execute permissions on a file.
+ * We use "fsuid" for this, letting us set arbitrary permissions
+ * for filesystem access without changing the "normal" uids which
+ * are used for other things..
+ */
+int generic_permission(struct inode *inode, int mask,
+		int (*check_acl)(struct inode *inode, int mask))
+{
+	int ret;
+
+	/*
+	 * Do the basic POSIX ACL permission checks.
+	 */
+	ret = acl_permission_check(inode, mask, check_acl);
+	if (ret != -EACCES)
+		return ret;
 
- check_capabilities:
 	/*
 	 * Read/write DACs are always overridable.
 	 * Executable DACs are overridable if at least one exec bit is set.
@@ -262,7 +275,7 @@ int inode_permission(struct inode *inode, int mask)
 	if (inode->i_op->permission)
 		retval = inode->i_op->permission(inode, mask);
 	else
-		retval = generic_permission(inode, mask, NULL);
+		retval = generic_permission(inode, mask, inode->i_op->check_acl);
 
 	if (retval)
 		return retval;
@@ -432,27 +445,22 @@ static struct dentry * cached_lookup(struct dentry * parent, struct qstr * name,
  */
 static int exec_permission_lite(struct inode *inode)
 {
-	umode_t	mode = inode->i_mode;
+	int ret;
 
 	if (inode->i_op->permission) {
-		int ret = inode->i_op->permission(inode, MAY_EXEC);
+		ret = inode->i_op->permission(inode, MAY_EXEC);
 		if (!ret)
 			goto ok;
 		return ret;
 	}
-
-	if (current_fsuid() == inode->i_uid)
-		mode >>= 6;
-	else if (in_group_p(inode->i_gid))
-		mode >>= 3;
-
-	if (mode & MAY_EXEC)
+	ret = acl_permission_check(inode, MAY_EXEC, inode->i_op->check_acl);
+	if (!ret)
 		goto ok;
 
 	if (capable(CAP_DAC_OVERRIDE) || capable(CAP_DAC_READ_SEARCH))
 		goto ok;
 
-	return -EACCES;
+	return ret;
 ok:
 	return security_inode_permission(inode, MAY_EXEC);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 73e9b64..c1f9935 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1528,6 +1528,7 @@ struct inode_operations {
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
 	int (*permission) (struct inode *, int);
+	int (*check_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
 	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-- 
1.6.4.1.209.g74b8

