Return-Path: <linux-kernel-owner+w=401wt.eu-S936151AbYEURUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936151AbYEURUm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbYEURQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:16:15 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33082 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765837AbYEURQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:16:08 -0400
Message-Id: <20080521171557.399850407@szeredi.hu>
References: <20080521171458.077908538@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 21 May 2008 19:15:09 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [patch 11/14] vfs: move executable checking into ->permission()
Content-Disposition: inline; filename=permission_exec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

For execute permission on a regular files we need to check if file has
any execute bits at all, regardless of capabilites.

This check is normally performed by generic_permission() but was also
added to the case when the filesystem defines its own ->permission()
method.  In the latter case the filesystem should be responsible for
performing this check.

So create a helper function exec_permission() that checks returns
-EACCESS if MAY_EXEC is present, the inode is a regular file and no
execute bits are present in inode->i_mode.

Call this function from filesystems which don't call
generic_permission() from their ->permission() methods and which
aren't already performing this check.  Also remove the check from
dentry_permission().

The new code should be equivalent to the old.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cifs/cifsfs.c      |    2 +-
 fs/coda/dir.c         |    4 ++++
 fs/coda/pioctl.c      |    2 +-
 fs/hfs/inode.c        |    2 +-
 fs/namei.c            |   38 +++++++++++++++++++++++---------------
 fs/nfs/dir.c          |    3 +++
 fs/proc/proc_sysctl.c |    3 +++
 fs/smbfs/file.c       |    6 +++---
 include/linux/fs.h    |    1 +
 9 files changed, 40 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/cifs/cifsfs.c	2008-05-21 13:41:36.000000000 +0200
@@ -276,7 +276,7 @@ static int cifs_permission(struct dentry
 	cifs_sb = CIFS_SB(inode->i_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
-		return 0;
+		return exec_permission(inode, mask);
 	else /* file mode might have been restricted at mount time
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/coda/dir.c	2008-05-21 13:41:36.000000000 +0200
@@ -145,6 +145,10 @@ int coda_permission(struct dentry *dentr
 	if (!mask)
 		return 0; 
 
+	error = exec_permission(inode, mask);
+	if (error)
+		return error;
+
 	lock_kernel();
 
 	if (coda_cache_check(inode, mask))
Index: linux-2.6/fs/coda/pioctl.c
===================================================================
--- linux-2.6.orig/fs/coda/pioctl.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/coda/pioctl.c	2008-05-21 13:41:36.000000000 +0200
@@ -43,7 +43,7 @@ const struct file_operations coda_ioctl_
 /* the coda pioctl inode ops */
 static int coda_ioctl_permission(struct dentry *dentry, int mask, int flags)
 {
-        return 0;
+	return exec_permission(dentry->d_inode, mask);
 }
 
 static int coda_pioctl(struct inode * inode, struct file * filp, 
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/hfs/inode.c	2008-05-21 13:41:36.000000000 +0200
@@ -516,7 +516,7 @@ static int hfs_permission(struct dentry 
 	struct inode *inode = dentry->d_inode;
 
 	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC)
-		return 0;
+		return exec_permission(inode, mask);
 	return generic_permission(inode, mask, NULL);
 }
 
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/nfs/dir.c	2008-05-21 13:41:36.000000000 +0200
@@ -1975,6 +1975,9 @@ force_lookup:
 		res = PTR_ERR(cred);
 	unlock_kernel();
 out:
+	if (res == 0)
+		res = exec_permission(inode, mask);
+
 	dfprintk(VFS, "NFS: permission(%s/%ld), mask=0x%x, res=%d\n",
 		inode->i_sb->s_id, inode->i_ino, mask, res);
 	return res;
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/proc/proc_sysctl.c	2008-05-21 13:41:36.000000000 +0200
@@ -390,6 +390,9 @@ static int proc_sys_permission(struct de
 	error = sysctl_perm(head->root, table, mask);
 out:
 	sysctl_head_finish(head);
+	if (!error)
+		error = exec_permission(inode, mask);
+
 	return error;
 }
 
Index: linux-2.6/fs/smbfs/file.c
===================================================================
--- linux-2.6.orig/fs/smbfs/file.c	2008-05-21 13:41:30.000000000 +0200
+++ linux-2.6/fs/smbfs/file.c	2008-05-21 13:41:36.000000000 +0200
@@ -411,15 +411,15 @@ static int
 smb_file_permission(struct dentry *dentry, int mask, int flags)
 {
 	int mode = dentry->d_inode->i_mode;
-	int error = 0;
 
 	VERBOSE("mode=%x, mask=%x\n", mode, mask);
 
 	/* Look at user permissions */
 	mode >>= 6;
 	if ((mode & 7 & mask) != mask)
-		error = -EACCES;
-	return error;
+		return -EACCES;
+
+	return exec_permission(dentry->d_inode, mask);
 }
 
 const struct file_operations smb_file_operations =
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-05-21 13:41:34.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-05-21 13:41:36.000000000 +0200
@@ -226,6 +226,26 @@ int generic_permission(struct inode *ino
 	return -EACCES;
 }
 
+/**
+ * exec_permission - check for general execute permission on file
+ * @inode:	inode to check access rights for
+ * @mask:	right to check for
+ *
+ * Exec permission on a regular file is denied if none of the execute
+ * bits are set.
+ *
+ * This needs to be called by filesystems which define a
+ * ->permission() method, and don't call generic_permission().
+ */
+int exec_permission(struct inode *inode, int mask)
+{
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
+	    !(inode->i_mode & S_IXUGO))
+		return -EACCES;
+
+	return 0;
+}
+
 int dentry_permission(struct dentry *dentry, int mask, int flags)
 {
 	struct inode *inode = dentry->d_inode;
@@ -250,23 +270,11 @@ int dentry_permission(struct dentry *den
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
 	submask = mask & ~MAY_APPEND;
-	if (inode->i_op && inode->i_op->permission) {
+	if (inode->i_op && inode->i_op->permission)
 		retval = inode->i_op->permission(dentry, submask, flags);
-		if (!retval) {
-			/*
-			 * Exec permission on a regular file is denied if none
-			 * of the execute bits are set.
-			 *
-			 * This check should be done by the ->permission()
-			 * method.
-			 */
-			if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
-			    !(inode->i_mode & S_IXUGO))
-				return -EACCES;
-		}
-	} else {
+	else
 		retval = generic_permission(inode, submask, NULL);
-	}
+
 	if (retval)
 		return retval;
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-21 13:41:34.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-21 13:41:36.000000000 +0200
@@ -1761,6 +1761,7 @@ extern int path_setattr(struct path *, s
 extern int dentry_permission(struct dentry *, int, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
+extern int exec_permission(struct inode *, int);
 
 extern int get_write_access(struct inode *);
 extern int deny_write_access(struct file *);

--
