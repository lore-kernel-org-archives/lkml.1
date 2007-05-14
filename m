Return-Path: <linux-kernel-owner+w=401wt.eu-S1030591AbXENJew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591AbXENJew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933884AbXENJed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:34:33 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:41651 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933862AbXENJeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:34:31 -0400
Date: Mon, 14 May 2007 15:11:50 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  7/14] Union-mount mounting
Message-ID: <20070514094150.GI4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070514093722.GB4139@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Union-mount mounting

Adds union mount support to mount() and umount() system calls.
Sets up the union stack during mount and destroys it during unmount.

TODO: bind and move mounts aren't yet supported with union mounts.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/namespace.c        |   90 ++++++++++++++++++++++++++++++++++++++++++++++----
 fs/union.c            |   71 +++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h    |    3 +
 include/linux/union.h |   33 ++++++++++++++++++
 4 files changed, 190 insertions(+), 7 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -169,7 +169,7 @@ void mnt_set_mountpoint(struct vfsmount 
 			struct vfsmount *child_mnt)
 {
 	child_mnt->mnt_parent = mntget(mnt);
-	child_mnt->mnt_mountpoint = dget(dentry);
+	child_mnt->mnt_mountpoint = __dget(dentry);
 	dentry->d_mounted++;
 }
 
@@ -294,6 +294,10 @@ static struct vfsmount *clone_mnt(struct
 	if (!mnt)
 		goto alloc_failed;
 
+	/*
+	 * As of now, cloning of union mounted mnt isn't permitted.
+	 */
+	BUG_ON(mnt->mnt_flags & MNT_UNION);
 	mnt->mnt_flags = old->mnt_flags;
 	atomic_inc(&sb->s_active);
 	mnt->mnt_sb = sb;
@@ -579,16 +583,20 @@ void release_mounts(struct list_head *he
 		mnt = list_first_entry(head, struct vfsmount, mnt_hash);
 		list_del_init(&mnt->mnt_hash);
 		if (mnt->mnt_parent != mnt) {
-			struct dentry *dentry;
-			struct vfsmount *m;
+			struct path old_nd;
 			spin_lock(&vfsmount_lock);
-			dentry = mnt->mnt_mountpoint;
-			m = mnt->mnt_parent;
+			old_nd.dentry = mnt->mnt_mountpoint;
+			old_nd.mnt = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
 			mnt->mnt_parent = mnt;
+			detach_mnt_union(mnt, &old_nd);
 			spin_unlock(&vfsmount_lock);
-			dput(dentry);
-			mntput(m);
+			if (mnt->mnt_flags & MNT_UNION) {
+				UM_DEBUG("shrink the mountpoint's dcache\n");
+				shrink_dcache_sb(old_nd.dentry->d_sb);
+			}
+			__dput(old_nd.dentry);
+			mntput(old_nd.mnt);
 		}
 		mntput(mnt);
 	}
@@ -621,6 +629,9 @@ static int do_umount(struct vfsmount *mn
 	struct super_block *sb = mnt->mnt_sb;
 	int retval;
 	LIST_HEAD(umount_list);
+#ifdef CONFIG_UNION_MOUNT
+	struct union_info *uinfo = NULL;
+#endif
 
 	retval = security_sb_umount(mnt, flags);
 	if (retval)
@@ -685,6 +696,14 @@ static int do_umount(struct vfsmount *mn
 	}
 
 	down_write(&namespace_sem);
+#ifdef CONFIG_UNION_MOUNT
+	/*
+	 * Grab a reference to the union_info which gets detached
+	 * from the dentries in release_mounts().
+	 */
+	if (mnt->mnt_flags & MNT_UNION)
+		uinfo = union_lock_and_get(mnt->mnt_root);
+#endif
 	spin_lock(&vfsmount_lock);
 	event++;
 
@@ -699,6 +718,15 @@ static int do_umount(struct vfsmount *mn
 		security_sb_umount_busy(mnt);
 	up_write(&namespace_sem);
 	release_mounts(&umount_list);
+#ifdef CONFIG_UNION_MOUNT
+	if (uinfo) {
+		if (atomic_read(&uinfo->u_count) == 1)
+			/* We are the last user of this union_info */
+			union_release(uinfo);
+		else
+			union_put_and_unlock(uinfo);
+	}
+#endif
 	return retval;
 }
 
@@ -941,6 +969,9 @@ static int attach_recursive_mnt(struct v
 			set_mnt_shared(p);
 	}
 
+	if (source_mnt->mnt_flags & MNT_UNION)
+		union_alloc_dentry(nd->dentry);
+
 	spin_lock(&vfsmount_lock);
 	if (parent_nd) {
 		detach_mnt(source_mnt, parent_nd);
@@ -948,6 +979,7 @@ static int attach_recursive_mnt(struct v
 		touch_mnt_namespace(current->nsproxy->mnt_ns);
 	} else {
 		mnt_set_mountpoint(dest_mnt, dest_dentry, source_mnt);
+		attach_mnt_union(source_mnt, nd);
 		commit_tree(source_mnt);
 	}
 
@@ -956,6 +988,7 @@ static int attach_recursive_mnt(struct v
 		commit_tree(child);
 	}
 	spin_unlock(&vfsmount_lock);
+	union_unlock(nd->dentry);
 	return 0;
 }
 
@@ -1003,6 +1036,12 @@ static int do_change_type(struct nameida
 	if (nd->dentry != nd->mnt->mnt_root)
 		return -EINVAL;
 
+	/*
+	 * Don't change the type of union mounts
+	 */
+	if (nd->mnt->mnt_flags & MNT_UNION)
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	spin_lock(&vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
@@ -1031,6 +1070,15 @@ static int do_loopback(struct nameidata 
 	if (err)
 		return err;
 
+	/*
+	 * bind mounting to or from union mounts is not supported
+	 */
+	err = -EINVAL;
+	if (nd->mnt->mnt_flags & MNT_UNION)
+		goto out_unlocked;
+	if (old_nd.mnt->mnt_flags & MNT_UNION)
+		goto out_unlocked;
+
 	down_write(&namespace_sem);
 	err = -EINVAL;
 	if (IS_MNT_UNBINDABLE(old_nd.mnt))
@@ -1064,6 +1112,7 @@ static int do_loopback(struct nameidata 
 
 out:
 	up_write(&namespace_sem);
+out_unlocked:
 	path_release(&old_nd);
 	return err;
 }
@@ -1125,6 +1174,15 @@ static int do_move_mount(struct nameidat
 	if (err)
 		return err;
 
+	/*
+	 * moving to or from a union mount is not supported
+	 */
+	err = -EINVAL;
+	if (nd->mnt->mnt_flags & MNT_UNION)
+		goto exit;
+	if (old_nd.mnt->mnt_flags & MNT_UNION)
+		goto exit;
+
 	down_write(&namespace_sem);
 	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
 		;
@@ -1180,6 +1238,7 @@ out:
 	up_write(&namespace_sem);
 	if (!err)
 		path_release(&parent_nd);
+exit:
 	path_release(&old_nd);
 	return err;
 }
@@ -1223,6 +1282,9 @@ static int do_new_mount(struct nameidata
 	if (flags & MS_SETUSER)
 		__set_mnt_user(mnt, current->fsuid);
 
+	UM_DEBUG("dentry=%s, device=%s\n", nd->dentry->d_name.name,
+	       mnt->mnt_devname);
+
 	return do_add_mount(mnt, nd, mnt_flags, NULL);
 
  out_put_filesystem:
@@ -1257,6 +1319,12 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	/* Unions couldn't include shared mounts */
+	err = -EINVAL;
+	if ((mnt_flags & MNT_UNION) &&
+	    IS_MNT_SHARED(nd->mnt))
+		goto unlock;
+
 	/* Unions couldn't be writable if the filesystem
 	 * doesn't know about whiteouts */
 	err = -ENOTSUPP;
@@ -1276,6 +1344,14 @@ int do_add_mount(struct vfsmount *newmnt
 		list_add_tail(&newmnt->mnt_expire, fslist);
 		spin_unlock(&vfsmount_lock);
 	}
+
+	UM_DEBUG("mntpoint->d_count=%d/%p\n",
+		 atomic_read(&nd->dentry->d_count),
+		 &nd->dentry->d_count);
+	UM_DEBUG("mntroot->d_count=%d/%p\n",
+		 atomic_read(&newmnt->mnt_root->d_count),
+		 &newmnt->mnt_root->d_count);
+
 	up_write(&namespace_sem);
 	return 0;
 
--- a/fs/union.c
+++ b/fs/union.c
@@ -299,3 +299,74 @@ void __dput_union(struct dentry *dentry)
 
 	return;
 }
+
+void attach_mnt_union(struct vfsmount *mnt, struct nameidata *nd)
+{
+	struct dentry *tmp;
+
+	if (!(mnt->mnt_flags & MNT_UNION))
+		return;
+
+	UM_DEBUG("MNT_UNION set for dentry \"%s\", devname=%s\n",
+		 mnt->mnt_root->d_name.name, mnt->mnt_devname);
+	UM_DEBUG("mountpoint \"%s\", inode=%p\n",
+		 nd->dentry->d_name.name, nd->dentry->d_inode);
+
+	spin_lock(&mnt->mnt_root->d_lock);
+	mnt->mnt_root->d_overlaid = __dget(nd->dentry);
+	mnt->mnt_root->d_topmost = NULL;
+	mnt->mnt_root->d_union = union_get(nd->dentry->d_union);
+	spin_unlock(&mnt->mnt_root->d_lock);
+
+	tmp = nd->dentry;
+	while (tmp) {
+		tmp->d_topmost = mnt->mnt_root;
+		tmp = tmp->d_overlaid;
+	}
+}
+
+void detach_mnt_union(struct vfsmount *mnt, struct path *path)
+{
+	struct dentry *tmp;
+
+	if (!(mnt->mnt_flags & MNT_UNION))
+		return;
+
+	UM_DEBUG("MNT_UNION set for dentry \"%s\", devname=%s\n",
+		 mnt->mnt_root->d_name.name, mnt->mnt_devname);
+	UM_DEBUG("mountpoint \"%s\", inode=%p\n",
+		 path->dentry->d_name.name, path->dentry->d_inode);
+	BUG_ON(mnt->mnt_root->d_topmost);
+
+	/* put reference to the underlying union stack */
+	__dput(mnt->mnt_root->d_overlaid);
+	spin_lock(&mnt->mnt_root->d_lock);
+	mnt->mnt_root->d_overlaid = NULL;
+	union_put(mnt->mnt_root->d_union);
+	mnt->mnt_root->d_union = NULL;
+	spin_unlock(&mnt->mnt_root->d_lock);
+
+	/* rearrange the union stack */
+	path->dentry->d_topmost = NULL;
+	tmp = path->dentry->d_overlaid;
+	while (tmp) {
+		tmp->d_topmost = path->dentry;
+		tmp = tmp->d_overlaid;
+	}
+
+	/* If the mount point is the last component in the union,
+	 * put the reference to the union struct */
+	if (!path->dentry->d_overlaid) {
+		spin_lock(&path->dentry->d_lock);
+		union_put(path->dentry->d_union);
+		path->dentry->d_union = NULL;
+		spin_unlock(&path->dentry->d_lock);
+	}
+
+	/* when we looked up the mountpoint to be unmounted
+	 * we dget() a union-mount dentry struct so we have
+	 * to dput() parts of it by hand before we remove the
+	 * topmost dentry (which is mnt->mnt_root) from the
+	 * union stack */
+	__dput(path->dentry);
+}
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1984,6 +1984,9 @@ static inline ino_t parent_ino(struct de
 /* kernel/fork.c */
 extern int unshare_files(void);
 
+/* fs/union.c */
+#include <linux/union.h>
+
 /* Transaction based IO helpers */
 
 /*
--- /dev/null
+++ b/include/linux/union.h
@@ -0,0 +1,33 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright © 2004-2007 IBM Corporation
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+#ifndef __LINUX_UNION_H
+#define __LINUX_UNION_H
+#ifdef __KERNEL__
+
+#ifdef CONFIG_UNION_MOUNT
+
+#include <linux/fs_struct.h>
+
+/* namespace stuff used at mount time */
+extern void attach_mnt_union(struct vfsmount *, struct nameidata *);
+extern void detach_mnt_union(struct vfsmount *, struct path *);
+
+#else	/* CONFIG_UNION_MOUNT */
+
+#define attach_mnt_union(mnt,nd) do { /* empty */ } while (0)
+#define detach_mnt_union(mnt,nd) do { /* empty */ } while (0)
+
+#endif	/* CONFIG_UNION_MOUNT */
+
+#endif	/* __KERNEL __ */
+#endif	/* __LINUX_UNION_H */
