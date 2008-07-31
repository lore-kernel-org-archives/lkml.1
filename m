Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbYGaLmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbYGaLmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 07:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbYGaLmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 07:42:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57615 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYGaLmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 07:42:08 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080731003332.GJ28946@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 31 Jul 2008 01:33:32 +0100)
Subject: Re: [patch resend] vfs: move executable checking into
	->permission()
References: <E1KOBJb-0005L0-RF@pomaz-ex.szeredi.hu> <20080731003332.GJ28946@ZenIV.linux.org.uk>
Message-Id: <E1KOWXe-0008Dl-ET@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 31 Jul 2008 13:41:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2008, Al Viro wrote:
> On Wed, Jul 30, 2008 at 03:02:03PM +0200, Miklos Szeredi wrote:
> >  static int coda_ioctl_permission(struct inode *inode, int mask)
> >  {
> > -        return 0;
> > +	return check_execute(dentry->d_inode, mask);
> >  }
> 
> Er?
> 	a) mismerge from dentry-based variant

Yeah, crappy patch.  Agree on all other comments as well, thanks for
the review.

Here's an updated one.

Miklos
----

Subject: vfs: move executable checking into ->permission()

From: Miklos Szeredi <mszeredi@suse.cz>

For execute permission on a regular files we need to check if file has
any execute bits at all, regardless of capabilites.

This check is normally performed by generic_permission() but was also
added to the case when the filesystem defines its own ->permission()
method.  In the latter case the filesystem should be responsible for
performing this check.

Move the check from inode_permission() inside filesystems which are
not calling generic_permission().

Create a helper function execute_ok() that returns true if the inode
is a directory or if any execute bits are present in i_mode.

Also fix up the following code:

 - coda control file is never executable
 - sysctl files are never executable
 - hfs_permission seems broken on MAY_EXEC, remove
 - hfsplus_permission is eqivalent to generic_permission(), remove

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/cifs/cifsfs.c      |    9 ++++++---
 fs/coda/dir.c         |    3 +++
 fs/coda/pioctl.c      |    2 +-
 fs/hfs/inode.c        |    8 --------
 fs/hfsplus/inode.c    |   13 -------------
 fs/namei.c            |   21 ++++-----------------
 fs/nfs/dir.c          |    3 +++
 fs/proc/proc_sysctl.c |   10 ++++++++--
 include/linux/fs.h    |    5 +++++
 9 files changed, 30 insertions(+), 44 deletions(-)

Index: linux-2.6/fs/cifs/cifsfs.c
===================================================================
--- linux-2.6.orig/fs/cifs/cifsfs.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/cifs/cifsfs.c	2008-07-31 13:28:11.000000000 +0200
@@ -273,9 +273,12 @@ static int cifs_permission(struct inode 
 
 	cifs_sb = CIFS_SB(inode->i_sb);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
-		return 0;
-	else /* file mode might have been restricted at mount time
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM) {
+		if ((mask & MAY_EXEC) && !execute_ok(inode))
+			return -EACCES;
+		else
+			return 0;
+	} else /* file mode might have been restricted at mount time
 		on the client (above and beyond ACL on servers) for
 		servers which do not support setting and viewing mode bits,
 		so allowing client to check permissions is useful */
Index: linux-2.6/fs/coda/dir.c
===================================================================
--- linux-2.6.orig/fs/coda/dir.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/coda/dir.c	2008-07-31 13:28:11.000000000 +0200
@@ -146,6 +146,9 @@ int coda_permission(struct inode *inode,
 	if (!mask)
 		return 0; 
 
+	if ((mask & MAY_EXEC) && !execute_ok(inode))
+		return -EACCES;
+
 	lock_kernel();
 
 	if (coda_cache_check(inode, mask))
Index: linux-2.6/fs/coda/pioctl.c
===================================================================
--- linux-2.6.orig/fs/coda/pioctl.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/coda/pioctl.c	2008-07-31 13:28:11.000000000 +0200
@@ -43,7 +43,7 @@ const struct file_operations coda_ioctl_
 /* the coda pioctl inode ops */
 static int coda_ioctl_permission(struct inode *inode, int mask)
 {
-        return 0;
+	return (mask & MAY_EXEC) ? -EACCES : 0;
 }
 
 static int coda_pioctl(struct inode * inode, struct file * filp, 
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/namei.c	2008-07-31 13:28:11.000000000 +0200
@@ -212,8 +212,7 @@ int generic_permission(struct inode *ino
 	 * Read/write DACs are always overridable.
 	 * Executable DACs are overridable if at least one exec bit is set.
 	 */
-	if (!(mask & MAY_EXEC) ||
-	    (inode->i_mode & S_IXUGO) || S_ISDIR(inode->i_mode))
+	if (!(mask & MAY_EXEC) || execute_ok(inode))
 		if (capable(CAP_DAC_OVERRIDE))
 			return 0;
 
@@ -249,23 +248,11 @@ int inode_permission(struct inode *inode
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
--- linux-2.6.orig/fs/nfs/dir.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/nfs/dir.c	2008-07-31 13:28:11.000000000 +0200
@@ -1949,6 +1949,9 @@ force_lookup:
 	} else
 		res = PTR_ERR(cred);
 out:
+	if (!res && (mask & MAY_EXEC) && !execute_ok(inode))
+		res = -EACCES;
+
 	dfprintk(VFS, "NFS: permission(%s/%ld), mask=0x%x, res=%d\n",
 		inode->i_sb->s_id, inode->i_ino, mask, res);
 	return res;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-07-31 13:28:11.000000000 +0200
@@ -1776,6 +1776,11 @@ extern int inode_permission(struct inode
 extern int generic_permission(struct inode *, int,
 		int (*check_acl)(struct inode *, int));
 
+static inline bool execute_ok(struct inode *inode)
+{
+	return (inode->i_mode & S_IXUGO) || S_ISDIR(inode->i_mode);
+}
+
 extern int get_write_access(struct inode *);
 extern int deny_write_access(struct file *);
 static inline void put_write_access(struct inode * inode)
Index: linux-2.6/fs/hfs/inode.c
===================================================================
--- linux-2.6.orig/fs/hfs/inode.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/hfs/inode.c	2008-07-31 13:28:21.000000000 +0200
@@ -511,13 +511,6 @@ void hfs_clear_inode(struct inode *inode
 	}
 }
 
-static int hfs_permission(struct inode *inode, int mask)
-{
-	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC)
-		return 0;
-	return generic_permission(inode, mask, NULL);
-}
-
 static int hfs_file_open(struct inode *inode, struct file *file)
 {
 	if (HFS_IS_RSRC(inode))
@@ -616,7 +609,6 @@ static const struct inode_operations hfs
 	.lookup		= hfs_file_lookup,
 	.truncate	= hfs_file_truncate,
 	.setattr	= hfs_inode_setattr,
-	.permission	= hfs_permission,
 	.setxattr	= hfs_setxattr,
 	.getxattr	= hfs_getxattr,
 	.listxattr	= hfs_listxattr,
Index: linux-2.6/fs/hfsplus/inode.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/inode.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/hfsplus/inode.c	2008-07-31 13:28:25.000000000 +0200
@@ -238,18 +238,6 @@ static void hfsplus_set_perms(struct ino
 	perms->dev = cpu_to_be32(HFSPLUS_I(inode).dev);
 }
 
-static int hfsplus_permission(struct inode *inode, int mask)
-{
-	/* MAY_EXEC is also used for lookup, if no x bit is set allow lookup,
-	 * open_exec has the same test, so it's still not executable, if a x bit
-	 * is set fall back to standard permission check.
-	 */
-	if (S_ISREG(inode->i_mode) && mask & MAY_EXEC && !(inode->i_mode & 0111))
-		return 0;
-	return generic_permission(inode, mask, NULL);
-}
-
-
 static int hfsplus_file_open(struct inode *inode, struct file *file)
 {
 	if (HFSPLUS_IS_RSRC(inode))
@@ -279,7 +267,6 @@ static int hfsplus_file_release(struct i
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.lookup		= hfsplus_file_lookup,
 	.truncate	= hfsplus_file_truncate,
-	.permission	= hfsplus_permission,
 	.setxattr	= hfsplus_setxattr,
 	.getxattr	= hfsplus_getxattr,
 	.listxattr	= hfsplus_listxattr,
Index: linux-2.6/fs/proc/proc_sysctl.c
===================================================================
--- linux-2.6.orig/fs/proc/proc_sysctl.c	2008-07-31 13:27:44.000000000 +0200
+++ linux-2.6/fs/proc/proc_sysctl.c	2008-07-31 13:28:32.000000000 +0200
@@ -298,13 +298,19 @@ static int proc_sys_permission(struct in
 	 * sysctl entries that are not writeable,
 	 * are _NOT_ writeable, capabilities or not.
 	 */
-	struct ctl_table_header *head = grab_header(inode);
-	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+	struct ctl_table_header *head;
+	struct ctl_table *table;
 	int error;
 
+	/* Executable files are not allowed under /proc/sys/ */
+	if ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))
+		return -EACCES;
+
+	head = grab_header(inode);
 	if (IS_ERR(head))
 		return PTR_ERR(head);
 
+	table = PROC_I(inode)->sysctl_entry;
 	if (!table) /* global root - r-xr-xr-x */
 		error = mask & MAY_WRITE ? -EACCES : 0;
 	else /* Use the permissions on the sysctl table entry */
