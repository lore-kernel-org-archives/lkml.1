Return-Path: <linux-kernel-owner+w=401wt.eu-S1755700AbXD0MJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbXD0MJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 08:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755682AbXD0MI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 08:08:59 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:54096 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706AbXD0MIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 08:08:54 -0400
Message-Id: <20070427120601.765071874@szeredi.hu>
References: <20070427120417.110164241@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 27 Apr 2007 14:04:26 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com, kzak@redhat.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 09/10] unprivileged mounts: propagation: inherit owner from parent
Content-Disposition: inline; filename=unprivileged-mounts-propagation-inherit-owner-from-parent.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

On mount propagation, let the owner of the clone be inherited from the
parent into which it has been propagated.  Also if the parent has the
"nosuid" flag, set this flag for the child as well.

This makes sense for example, when propagation is set up from the
initial namespace into a per-user namespace, where some or all of the
mounts may be owned by the user.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-04-27 12:57:01.000000000 +0200
+++ linux/fs/namespace.c	2007-04-27 12:57:11.000000000 +0200
@@ -250,10 +250,10 @@ static int reserve_user_mount(void)
 	return err;
 }
 
-static void __set_mnt_user(struct vfsmount *mnt)
+static void __set_mnt_user(struct vfsmount *mnt, uid_t owner)
 {
 	BUG_ON(mnt->mnt_flags & MNT_USER);
-	mnt->mnt_uid = current->fsuid;
+	mnt->mnt_uid = owner;
 	mnt->mnt_flags |= MNT_USER;
 
 	if (!capable(CAP_SETUID))
@@ -264,7 +264,7 @@ static void __set_mnt_user(struct vfsmou
 
 static void set_mnt_user(struct vfsmount *mnt)
 {
-	__set_mnt_user(mnt);
+	__set_mnt_user(mnt, current->fsuid);
 	spin_lock(&vfsmount_lock);
 	nr_user_mounts++;
 	spin_unlock(&vfsmount_lock);
@@ -280,7 +280,7 @@ static void clear_mnt_user(struct vfsmou
 }
 
 static struct vfsmount *clone_mnt(struct vfsmount *old, struct dentry *root,
-					int flag)
+					int flag, uid_t owner)
 {
 	struct super_block *sb = old->mnt_sb;
 	struct vfsmount *mnt;
@@ -304,7 +304,10 @@ static struct vfsmount *clone_mnt(struct
 	/* don't copy the MNT_USER flag */
 	mnt->mnt_flags &= ~MNT_USER;
 	if (flag & CL_SETUSER)
-		__set_mnt_user(mnt);
+		__set_mnt_user(mnt, owner);
+
+	if (flag & CL_NOSUID)
+		mnt->mnt_flags |= MNT_NOSUID;
 
 	if (flag & CL_SLAVE) {
 		list_add(&mnt->mnt_slave, &old->mnt_slave_list);
@@ -822,7 +825,7 @@ static int lives_below_in_same_fs(struct
 }
 
 struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
-					int flag)
+					int flag, uid_t owner)
 {
 	struct vfsmount *res, *p, *q, *r, *s;
 	struct nameidata nd;
@@ -830,7 +833,7 @@ struct vfsmount *copy_tree(struct vfsmou
 	if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(mnt))
 		return ERR_PTR(-EPERM);
 
-	res = q = clone_mnt(mnt, dentry, flag);
+	res = q = clone_mnt(mnt, dentry, flag, owner);
 	if (IS_ERR(q))
 		goto error;
 	q->mnt_mountpoint = mnt->mnt_mountpoint;
@@ -852,7 +855,7 @@ struct vfsmount *copy_tree(struct vfsmou
 			p = s;
 			nd.mnt = q;
 			nd.dentry = p->mnt_mountpoint;
-			q = clone_mnt(p, p->mnt_root, flag);
+			q = clone_mnt(p, p->mnt_root, flag, owner);
 			if (IS_ERR(q))
 				goto error;
 			spin_lock(&vfsmount_lock);
@@ -1028,7 +1031,8 @@ static int do_change_type(struct nameida
  */
 static int do_loopback(struct nameidata *nd, char *old_name, int flags)
 {
-	int clone_flags;
+	int clone_flags = 0;
+	uid_t owner = 0;
 	struct nameidata old_nd;
 	struct vfsmount *mnt = NULL;
 	int err;
@@ -1049,11 +1053,15 @@ static int do_loopback(struct nameidata 
 	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
 		goto out;
 
-	clone_flags = (flags & MS_SETUSER) ? CL_SETUSER : 0;
+	if (flags & MS_SETUSER) {
+		clone_flags |= CL_SETUSER;
+		owner = current->fsuid;
+	}
+
 	if (flags & MS_REC)
-		mnt = copy_tree(old_nd.mnt, old_nd.dentry, clone_flags);
+		mnt = copy_tree(old_nd.mnt, old_nd.dentry, clone_flags, owner);
 	else
-		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, clone_flags);
+		mnt = clone_mnt(old_nd.mnt, old_nd.dentry, clone_flags, owner);
 
 	err = PTR_ERR(mnt);
 	if (IS_ERR(mnt))
@@ -1227,7 +1235,7 @@ static int do_new_mount(struct nameidata
 	}
 
 	if (flags & MS_SETUSER)
-		__set_mnt_user(mnt);
+		__set_mnt_user(mnt, current->fsuid);
 
 	return do_add_mount(mnt, nd, mnt_flags, NULL);
 
@@ -1620,7 +1628,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	down_write(&namespace_sem);
 	/* First pass: copy the tree topology */
 	new_ns->root = copy_tree(mnt_ns->root, mnt_ns->root->mnt_root,
-					CL_COPY_ALL | CL_EXPIRE);
+					CL_COPY_ALL | CL_EXPIRE, 0);
 	if (IS_ERR(new_ns->root)) {
 		up_write(&namespace_sem);
 		kfree(new_ns);
Index: linux/fs/pnode.c
===================================================================
--- linux.orig/fs/pnode.c	2007-04-27 12:57:00.000000000 +0200
+++ linux/fs/pnode.c	2007-04-27 12:57:11.000000000 +0200
@@ -179,15 +179,28 @@ int propagate_mnt(struct vfsmount *dest_
 
 	for (m = propagation_next(dest_mnt, dest_mnt); m;
 			m = propagation_next(m, dest_mnt)) {
-		int type;
+		int clflags;
+		uid_t owner = 0;
 		struct vfsmount *source;
 
 		if (IS_MNT_NEW(m))
 			continue;
 
-		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &type);
+		source =  get_source(m, prev_dest_mnt, prev_src_mnt, &clflags);
 
-		child = copy_tree(source, source->mnt_root, type);
+		if (m->mnt_flags & MNT_USER) {
+			clflags |= CL_SETUSER;
+			owner = m->mnt_uid;
+
+			/*
+			 * If propagating into a user mount which doesn't
+			 * allow suid, then make sure, the child(ren) won't
+			 * allow suid either
+			 */
+			if (m->mnt_flags & MNT_NOSUID)
+				clflags |= CL_NOSUID;
+		}
+		child = copy_tree(source, source->mnt_root, clflags, owner);
 		if (IS_ERR(child)) {
 			ret = PTR_ERR(child);
 			list_splice(tree_list, tmp_list.prev);
Index: linux/fs/pnode.h
===================================================================
--- linux.orig/fs/pnode.h	2007-04-27 12:57:00.000000000 +0200
+++ linux/fs/pnode.h	2007-04-27 12:57:11.000000000 +0200
@@ -23,6 +23,7 @@
 #define CL_MAKE_SHARED 		0x08
 #define CL_PROPAGATION 		0x10
 #define CL_SETUSER		0x20
+#define CL_NOSUID		0x40
 
 static inline void set_mnt_shared(struct vfsmount *mnt)
 {
@@ -35,4 +36,6 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+struct vfsmount *copy_tree(struct vfsmount *, struct dentry *, int, uid_t);
+
 #endif /* _LINUX_PNODE_H */
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-04-27 12:57:01.000000000 +0200
+++ linux/include/linux/fs.h	2007-04-27 12:57:11.000000000 +0200
@@ -1467,7 +1467,6 @@ extern int may_umount(struct vfsmount *)
 extern void umount_tree(struct vfsmount *, int, struct list_head *);
 extern void release_mounts(struct list_head *);
 extern long do_mount(char *, char *, char *, unsigned long, void *);
-extern struct vfsmount *copy_tree(struct vfsmount *, struct dentry *, int);
 extern void mnt_set_mountpoint(struct vfsmount *, struct dentry *,
 				  struct vfsmount *);
 

--
