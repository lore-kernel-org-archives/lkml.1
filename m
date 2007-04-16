Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbXDPLGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbXDPLGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 07:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753089AbXDPLGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 07:06:03 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:34217 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbXDPLF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 07:05:58 -0400
Message-Id: <20070416110409.741907051@szeredi.hu>
References: <20070416110308.739051445@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 16 Apr 2007 13:03:12 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 04/10] allow per-mount flags to be set/cleared individually
Content-Disposition: inline; filename=set_clear_mount_flags.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With MS_REMOUNT, it is difficult to change mount flags individually,
without touching other mount flags or options, having to parse
/proc/mounts to get the old flag values and options.

It is also difficult to change a mount flag recursively, having to
walk the mount tree in userspace.

This patch solves this problem by generalizing do_change_type() so
that not only the propagation property can be changed, but mnt_flags
can be set/cleared individually.

From: Miklos Szeredi <mszeredi@suse.cz>

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-04-13 13:04:04.000000000 +0200
+++ linux/fs/namespace.c	2007-04-13 13:04:29.000000000 +0200
@@ -955,19 +956,28 @@ out_unlock:
 /*
  * recursively change the type of the mountpoint.
  */
-static int do_change_type(struct nameidata *nd, int flag)
+static int do_change_mnt(struct nameidata *nd, int flag, int mnt_flags)
 {
 	struct vfsmount *m, *mnt = nd->mnt;
 	int recurse = flag & MS_REC;
-	int type = flag & ~MS_REC;
+	int type = flag & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE);
 
 	if (nd->dentry != nd->mnt->mnt_root)
 		return -EINVAL;
 
 	down_write(&namespace_sem);
 	spin_lock(&vfsmount_lock);
-	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
-		change_mnt_propagation(m, type);
+	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL)) {
+		if (type)
+			change_mnt_propagation(m, type);
+
+		if (flag & (MS_SETFLAGS | MS_CLEARFLAGS))
+			m->mnt_flags = mnt_flags;
+		else if (flag & MS_SETFLAGS)
+			m->mnt_flags |= mnt_flags;
+		else if (flag & MS_CLEARFLAGS)
+			m->mnt_flags &= ~mnt_flags;
+	}
 	spin_unlock(&vfsmount_lock);
 	up_write(&namespace_sem);
 	return 0;
@@ -1514,8 +1526,9 @@ long do_mount(char *dev_name, char *dir_
 				    data_page);
 	else if (flags & MS_BIND)
 		retval = do_loopback(&nd, dev_name, flags);
-	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
-		retval = do_change_type(&nd, flags);
+	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE |
+			  MS_SETFLAGS | MS_CLEARFLAGS))
+		retval = do_change_mnt(&nd, flags, mnt_flags);
 	else if (flags & MS_MOVE)
 		retval = do_move_mount(&nd, dev_name);
 	else
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-04-13 13:04:04.000000000 +0200
+++ linux/include/linux/fs.h	2007-04-13 13:04:29.000000000 +0200
@@ -127,6 +127,9 @@ extern int dir_notify_enable;
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_SETUSER	(1<<22) /* set mnt_uid to current user */
+#define MS_SETFLAGS	(1<<23) /* set specified mount flags */
+#define MS_CLEARFLAGS	(1<<24) /* clear specified mount flags */
+/* MS_SETFLAGS | MS_CLEARFLAGS: change mount flags to specified */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 

--
