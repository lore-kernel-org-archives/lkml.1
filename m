Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbYBMFpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbYBMFpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 00:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbYBMFpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 00:45:31 -0500
Received: from smtp-out.google.com ([216.239.33.17]:54583 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYBMFpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 00:45:30 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=drTUj/oWFA/hmyqgaX9LIr/543c51ZbAgTsXBenfYFIFu+GcAcNGPCPSvcTF81Q6K
	jEeNXfkZ8PmOj9Y6hgSdg==
Message-ID: <47B283EB.8070209@google.com>
Date: Tue, 12 Feb 2008 21:45:15 -0800
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Add MS_BIND_FLAGS mount flag
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Menage <menage@google.com>

Add a new mount() flag, MS_BIND_FLAGS.

MS_BIND_FLAGS indicates that a bind mount should take its per-mount flags
from the arguments passed to mount() rather than from the source
mountpoint.

This flag allows you to create a bind mount with the desired per-mount
flags in a single operation, rather than having to do a bind mount
followed by a remount, which is fiddly and can block for non-trivial
periods of time (on sb->s_umount?).

For recursive bind mounts, only the root of the tree being bound
inherits the per-mount flags from the mount() arguments; sub-mounts
inherit their per-mount flags from the source tree as usual.

Signed-off-by: Paul Menage <menage@google.com>


---
 fs/namespace.c     |   36 +++++++++++++++++++++++++-----------
 include/linux/fs.h |    2 ++
 2 files changed, 27 insertions(+), 11 deletions(-)

Index: 2.6.24-mm1-bindflags/fs/namespace.c
===================================================================
--- 2.6.24-mm1-bindflags.orig/fs/namespace.c
+++ 2.6.24-mm1-bindflags/fs/namespace.c
@@ -512,13 +512,13 @@ static struct vfsmount *skip_mnt_tree(st
 }
 
 static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
-					int flag)
+				  int flag, int mnt_flags)
 {
 	struct super_block *sb = old->mnt_sb;
 	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
 
 	if (mnt) {
-		mnt->mnt_flags = old->mnt_flags;
+		mnt->mnt_flags = mnt_flags;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
 		mnt->mnt_root = dget(root);
@@ -1095,8 +1095,9 @@ static int lives_below_in_same_fs(struct
 	}
 }
 
-struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
-					int flag)
+static struct vfsmount *
+__copy_tree(struct vfsmount *mnt, struct dentry *dentry,
+	    int flag, int mnt_flags)
 {
 	struct vfsmount *res, *p, *q, *r, *s;
 	struct nameidata nd;
@@ -1104,7 +1105,7 @@ struct vfsmount *copy_tree(struct vfsmou
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
 		return NULL;
 
-	res = q = clone_mnt(mnt, dentry, flag);
+	res = q = clone_mnt(mnt, dentry, flag, mnt_flags);
 	if (!q)
 		goto Enomem;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
@@ -1126,7 +1127,7 @@ struct vfsmount *copy_tree(struct vfsmou
 			p = s;
 			nd.path.mnt = q;
 			nd.path.dentry = p->mnt_mountpoint;
-			q = clone_mnt(p, p->mnt_root, flag);
+			q = clone_mnt(p, p->mnt_root, flag, p->mnt_flags);
 			if (!q)
 				goto Enomem;
 			spin_lock(&vfsmount_lock);
@@ -1146,6 +1147,11 @@ Enomem:
 	}
 	return NULL;
 }
+struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
+			   int flag)
+{
+	return __copy_tree(mnt, dentry, flag, mnt->mnt_flags);
+}
 
 struct vfsmount *collect_mounts(struct vfsmount *mnt, struct dentry *dentry)
 {
@@ -1320,7 +1326,8 @@ static int do_change_type(struct nameida
 /*
  * do loopback mount.
  */
-static int do_loopback(struct nameidata *nd, char *old_name, int recurse)
+static int do_loopback(struct nameidata *nd, char *old_name, int flags,
+		       int mnt_flags)
 {
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
@@ -1342,10 +1349,15 @@ static int do_loopback(struct nameidata 
 		goto out;
 
 	err = -ENOMEM;
-	if (recurse)
-		mnt = copy_tree(old_nd.path.mnt, old_nd.path.dentry, 0);
+	/* Use the source mount flags unless the user passed MS_BIND_FLAGS */
+	if (!(flags & MS_BIND_FLAGS))
+		mnt_flags = old_nd.path.mnt->mnt_flags;
+	if (flags & MS_REC)
+		mnt = __copy_tree(old_nd.path.mnt, old_nd.path.dentry, 0,
+				  mnt_flags);
 	else
-		mnt = clone_mnt(old_nd.path.mnt, old_nd.path.dentry, 0);
+		mnt = clone_mnt(old_nd.path.mnt, old_nd.path.dentry, 0,
+				mnt_flags);
 
 	if (!mnt)
 		goto out;
@@ -1874,7 +1886,9 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_remount(&nd, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&nd, dev_name, flags & MS_REC);
+		retval = do_loopback(&nd, dev_name,
+				     flags & (MS_REC | MS_BIND_FLAGS),
+				     mnt_flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&nd, flags);
 	else if (flags & MS_MOVE)
Index: 2.6.24-mm1-bindflags/include/linux/fs.h
===================================================================
--- 2.6.24-mm1-bindflags.orig/include/linux/fs.h
+++ 2.6.24-mm1-bindflags/include/linux/fs.h
@@ -125,6 +125,8 @@ extern int dir_notify_enable;
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
+#define MS_BIND_FLAGS	(1<<24) /* For MS_BIND, take mnt_flags from
+				 * args, not from source mountpoint */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
