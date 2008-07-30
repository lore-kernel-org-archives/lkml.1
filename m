Return-Path: <linux-kernel-owner+w=401wt.eu-S1760638AbYG3NCW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760638AbYG3NCW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 09:02:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbYG3NCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 09:02:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51090 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbYG3NCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:02:10 -0400
To: viro@ZenIV.linux.org.uk
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch resend] vfs: move executable checking into ->permission()
Message-Id: <E1KOBJb-0005L0-RF@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jul 2008 15:02:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A ->permission() API cleanup patch that I missed resending...

Please apply to 2.6.27 or .28 at your discretion.

Thanks,
Miklos

----
From: Miklos Szeredi <mszeredi@suse.cz>

For execute permission on a regular files we need to check if file has
any execute bits at all, regardless of capabilites.

This check is normally performed by generic_permission() but was also
added to the case when the filesystem defines its own ->permission()
method.  In the latter case the filesystem should be responsible for
performing this check.

So create a helper function check_execute() that returns -EACCESS if
MAY_EXEC is present, the inode is a regular file and no execute bits
are present in inode->i_mode.

Call this function from filesystems which don't call
generic_permission() from their ->permission() methods and which
aren't already performing this check.  Also remove the check from
dentry_permission().

The new code should be equivalent to the old.

[Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>: export
check_execute() to modules]

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cifs/cifsfs.c      |    2 +-
 fs/coda/dir.c         |    4 ++++
 fs/coda/pioctl.c      |    2 +-
 fs/hfs/inode.c        |    2 +-
 fs/namei.c            |   39 ++++++++++++++++++++++++---------------
 fs/nfs/dir.c          |    3 +++
 fs/proc/proc_sysctl.c |    3 +++
 fs/smbfs/file.c       |    6 +++---
 include/linux/fs.h    |    1 +
 9 files changed, 41 insertions(+), 21 deletions(-)

Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2008-07-30 14:38:22.000000000 +0200
+++ linux-2.6/fs/cifs/cifsfs.c	2008-07-30 14:39:31.000000000 +0200
@@ -274,7 +274,7 @@ static int cifs_permission(struct inode 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
-		return 0;
+		return check_execute(inode, mask);
 	else /* file mode might have been restricted at mount time
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2008-07-30 14:38:22.000000000 +0200
+++ linux-2.6/fs/coda/dir.c	2008-07-30 14:39:31.000000000 +0200
@@ -146,6 +146,10 @@ int coda_permission(struct inode *inode,
 	if (!mask)
 		return 0; 
 
+	error = check_execute(inode, mask);
+	if (error)
+		return error;
+
 	lock_kernel();
 
 	if (coda_cache_check(inode, mask))
Index: linux-2.6/fs/coda/pioctl.c
===================================================================
--- linux-2.6.orig/fs/coda/pioctl.c	2008-07-30 14:38:22.000000000 +0200
+++ linux-2.6/fs/coda/pioctl.c	2008-07-30 14:39:31.000000000 +0200
@@ -43,7 +43,7 @@ const struct file_operations coda_ioctl_
 /* the coda pioctl inode ops */
 static int coda_ioctl_permission(struct inode *inode, int mask)
 {
-        return 0;
+	return check_execute(dentry->d_inode, mask);
 }
 
 static int coda_pioctl(struct inode * inode, struct file * filp, 
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2008-07-30 14:38:22.000000000 +0200
+++ linux-2.6/fs/hfs/inode.c	2008-07-30 14:39:31.000000000 +0200
@@ -514,7 +514,7 @@ void hfs_clear_inode(struct inode *inode
 static int hfs_permission(struct inode *inode, int mask)
 {
 	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC)
-		return 0;
+		return check_execute(inode, mask);
 	return generic_permission(inode, mask, NULL);
 }
 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-30 14:39:31.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-30 14:39:31.000000000 +0200
@@ -227,6 +227,27 @@ int generic_permission(struct inode *ino
 	return -EACCES;
 }
 
+/**
+ * check_execute - check for general execute permission on file
+ * @inode:	inode to check access rights for
+ * @mask:	right to check for
+ *
+ * Exec permission on a regular file is denied if none of the execute
+ * bits are set.
+ *
+ * This needs to be called by filesystems which define a
+ * ->permission() method, and don't call generic_permission().
+ */
+int check_execute(struct inode *inode, int mask)
+{
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode) &&
+	    !(inode->i_mode & S_IXUGO))
+		return -EACCES;
+
+	return 0;
+}
+EXPORT_SYMBOL(check_execute);
+
 int inode_permission(struct inode *inode, int mask)
 {
 	int retval;
@@ -249,23 +270,11 @@ int inode_permission(struct inode *inode
 	}
 
 	/* Ordinary permission routines do not understand MAY_APPEND. */
-	if (inode->i_op && inode->i_op->permission) {
+	if (inode->i_op && inode->i_op->permission)
 		retval = inode->i_op->permission(inode, mask);
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
 		retval = generic_permission(inode, mask, NULL);
-	}
+
 	if (retval)
 		return retval;
 
Index: linux-2.6/fs/nfs/dir.c
===================================================================
--- linux-2.6.orig/fs/nfs/dir.c	2008-07-30 14:38:22.000000000 +0200
+++ linux-2.6/fs/nfs/dir.c	2008-07-30 14:39:31.000000000 +0200
@@ -1949,6 +1949,9 @@ force_lookup:
 	} else
 		res = PTR_ERR(cred);
 out:
+	if (res == 0)
+		res = check_execute(inode, mask);
+
 	dfprintk(VFS, "NFS: permission(%s/%ld), mask=0x%x, res=%d\n",
 		inode->i_sb->s_id, inode->i_ino, mask, res);
 	return res;
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2008-07-30 14:38:22.000000000 +0200
+++ linux-2.6/fs/proc/proc_sysctl.c	2008-07-30 14:39:31.000000000 +0200
@@ -311,6 +311,9 @@ static int proc_sys_permission(struct in
 		error = sysctl_perm(head->root, table, mask);
 
 	sysctl_head_finish(head);
+	if (!error)
+		error = check_execute(inode, mask);
+
 	return error;
 }
 
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-07-30 14:39:31.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-07-30 14:39:31.000000000 +0200
@@ -1777,6 +1777,7 @@ extern int notify_change(struct dentry *
 extern int inode_permission(struct inode *, int);
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
+extern int check_execute(struct inode *, int);
 
 extern int get_write_access(struct inode *);
 extern int deny_write_access(struct file *);
Index: linux-2.6/fs/smbfs/file.c
===================================================================
--- linux-2.6.orig/fs/smbfs/file.c	2008-07-30 14:38:22.000000000 +0200
+++ linux-2.6/fs/smbfs/file.c	2008-07-30 14:39:31.000000000 +0200
@@ -411,15 +411,15 @@ static int
 smb_file_permission(struct inode *inode, int mask)
 {
 	int mode = inode->i_mode;
-	int error = 0;
 
 	VERBOSE("mode=%x, mask=%x\n", mode, mask);
 
 	/* Look at user permissions */
 	mode >>= 6;
 	if (mask & ~mode & (MAY_READ | MAY_WRITE | MAY_EXEC))
-		error = -EACCES;
-	return error;
+		return -EACCES;
+
+	return check_execute(inode, mask);
 }
 
 static loff_t smb_remote_llseek(struct file *file, loff_t offset, int origin)
