Return-Path: <linux-kernel-owner+w=401wt.eu-S1761189AbYCZVWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761189AbYCZVWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756662AbYCZVV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:21:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58468 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300AbYCZVVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:21:55 -0400
Message-Id: <20080326212140.382840664@szeredi.hu>
References: <20080326211131.705321084@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 26 Mar 2008 22:11:35 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/7] vfs: mountinfo: add mount peer group ID
Content-Disposition: inline; filename=mountinfo_mnt_group_id.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a unique ID to each peer group using the IDR infrastructure.  The
identifiers are reused after the peer group dissolves.

The IDR structures are protected by holding namepspace_sem for write
while allocating or deallocating ID's.

ID's are allocated when a previously unshared vfsmount becomes the
first member of a peer group.  When a new member is added to an
existing group, the ID is copied from one of the old members.

ID's are freed when the last member of a peer group is unshared.

Setting the MNT_SHARED flag on members of a subtree is done as a
separate step, after all the ID's have been allocated.  This way an
allocation failure can be cleaned up easilty, without affecting the
propagation state.

Based on design sketch by Al Viro.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |  100 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/pnode.c            |   11 +++--
 fs/pnode.h            |    1 
 include/linux/mount.h |    1 
 4 files changed, 106 insertions(+), 7 deletions(-)

Index: vfs-2.6/fs/namespace.c
===================================================================
--- vfs-2.6.orig/fs/namespace.c	2008-03-26 21:39:47.000000000 +0100
+++ vfs-2.6/fs/namespace.c	2008-03-26 21:46:35.000000000 +0100
@@ -41,6 +41,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLO
 
 static int event;
 static DEFINE_IDA(mnt_id_ida);
+static DEFINE_IDA(mnt_group_ida);
 
 static struct list_head *mount_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
@@ -83,6 +84,35 @@ static void mnt_free_id(struct vfsmount 
 	spin_unlock(&vfsmount_lock);
 }
 
+/*
+ * Allocate a new peer group ID
+ *
+ * mnt_group_ida is protected by namespace_sem
+ */
+static int mnt_alloc_group_id(struct vfsmount *mnt)
+{
+	int res;
+
+	WARN_ON(mnt->mnt_group_id != 0);
+ retry:
+	res = ida_get_new_above(&mnt_group_ida, 1, &mnt->mnt_group_id);
+	if (res == -EAGAIN) {
+		if (ida_pre_get(&mnt_group_ida, GFP_KERNEL))
+			goto retry;
+		res = -ENOMEM;
+	}
+	return res;
+}
+
+/*
+ * Release a peer group ID
+ */
+void mnt_release_group_id(struct vfsmount *mnt)
+{
+	ida_remove(&mnt_group_ida, mnt->mnt_group_id);
+	mnt->mnt_group_id = 0;
+}
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
@@ -533,6 +563,17 @@ static struct vfsmount *clone_mnt(struct
 	struct vfsmount *mnt = alloc_vfsmnt(old->mnt_devname);
 
 	if (mnt) {
+		if (flag & (CL_SLAVE | CL_PRIVATE))
+			mnt->mnt_group_id = 0; /* not a peer of original */
+		else
+			mnt->mnt_group_id = old->mnt_group_id;
+
+		if ((flag & CL_MAKE_SHARED) && !mnt->mnt_group_id) {
+			int err = mnt_alloc_group_id(mnt);
+			if (err)
+				goto out_free;
+		}
+
 		mnt->mnt_flags = old->mnt_flags;
 		atomic_inc(&sb->s_active);
 		mnt->mnt_sb = sb;
@@ -562,6 +603,10 @@ static struct vfsmount *clone_mnt(struct
 		}
 	}
 	return mnt;
+
+ out_free:
+	free_vfsmnt(mnt);
+	return NULL;
 }
 
 static inline void __mntput(struct vfsmount *mnt)
@@ -1142,6 +1187,33 @@ void drop_collected_mounts(struct vfsmou
 	release_mounts(&umount_list);
 }
 
+static void cleanup_group_ids(struct vfsmount *mnt, struct vfsmount *end)
+{
+	struct vfsmount *p;
+
+	for (p = mnt; p != end; p = next_mnt(p, mnt)) {
+		if (list_empty(&p->mnt_share) && !IS_MNT_SHARED(p))
+			mnt_release_group_id(p);
+	}
+}
+
+static int invent_group_ids(struct vfsmount *mnt, bool recurse)
+{
+	struct vfsmount *p;
+
+	for (p = mnt; p; p = recurse ? next_mnt(p, mnt) : NULL) {
+		if (list_empty(&p->mnt_share) && !IS_MNT_SHARED(p)) {
+			int err = mnt_alloc_group_id(p);
+			if (err) {
+				cleanup_group_ids(mnt, p);
+				return err;
+			}
+		}
+	}
+
+	return 0;
+}
+
 /*
  *  @source_mnt : mount tree to be attached
  *  @nd         : place the mount tree @source_mnt is attached
@@ -1212,9 +1284,16 @@ static int attach_recursive_mnt(struct v
 	struct vfsmount *dest_mnt = path->mnt;
 	struct dentry *dest_dentry = path->dentry;
 	struct vfsmount *child, *p;
+	int err;
 
-	if (propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list))
-		return -EINVAL;
+	if (IS_MNT_SHARED(dest_mnt)) {
+		err = invent_group_ids(source_mnt, true);
+		if (err)
+			goto out;
+	}
+	err = propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list);
+	if (err)
+		goto out_cleanup_ids;
 
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
@@ -1237,6 +1316,12 @@ static int attach_recursive_mnt(struct v
 	}
 	spin_unlock(&vfsmount_lock);
 	return 0;
+
+ out_cleanup_ids:
+	if (IS_MNT_SHARED(dest_mnt))
+		cleanup_group_ids(source_mnt, NULL);
+ out:
+	return err;
 }
 
 static int graft_tree(struct vfsmount *mnt, struct path *path)
@@ -1277,6 +1362,7 @@ static noinline int do_change_type(struc
 	struct vfsmount *m, *mnt = nd->path.mnt;
 	int recurse = flag & MS_REC;
 	int type = flag & ~MS_REC;
+	int err = 0;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1285,12 +1371,20 @@ static noinline int do_change_type(struc
 		return -EINVAL;
 
 	down_write(&namespace_sem);
+	if (type == MS_SHARED) {
+		err = invent_group_ids(mnt, recurse);
+		if (err)
+			goto out_unlock;
+	}
+
 	spin_lock(&vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
 		change_mnt_propagation(m, type);
 	spin_unlock(&vfsmount_lock);
+
+ out_unlock:
 	up_write(&namespace_sem);
-	return 0;
+	return err;
 }
 
 /*
Index: vfs-2.6/fs/pnode.c
===================================================================
--- vfs-2.6.orig/fs/pnode.c	2008-03-26 21:37:53.000000000 +0100
+++ vfs-2.6/fs/pnode.c	2008-03-26 21:46:35.000000000 +0100
@@ -46,7 +46,11 @@ static int do_make_slave(struct vfsmount
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
+	if (IS_MNT_SHARED(mnt) && list_empty(&mnt->mnt_share))
+		mnt_release_group_id(mnt);
+
 	list_del_init(&mnt->mnt_share);
+	mnt->mnt_group_id = 0;
 
 	if (peer_mnt)
 		master = peer_mnt;
@@ -58,9 +62,9 @@ static int do_make_slave(struct vfsmount
 		list_splice(&mnt->mnt_slave_list, master->mnt_slave_list.prev);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 	} else {
-		struct list_head *p = &mnt->mnt_slave_list;
-		while (!list_empty(p)) {
-                        slave_mnt = list_first_entry(p,
+		struct list_head *slaves = &mnt->mnt_slave_list;
+		while (!list_empty(slaves)) {
+                        slave_mnt = list_first_entry(slaves,
 					struct vfsmount, mnt_slave);
 			list_del_init(&slave_mnt->mnt_slave);
 			slave_mnt->mnt_master = NULL;
@@ -68,7 +72,6 @@ static int do_make_slave(struct vfsmount
 	}
 	mnt->mnt_master = master;
 	CLEAR_MNT_SHARED(mnt);
-	INIT_LIST_HEAD(&mnt->mnt_slave_list);
 	return 0;
 }
 
Index: vfs-2.6/fs/pnode.h
===================================================================
--- vfs-2.6.orig/fs/pnode.h	2008-03-26 21:37:52.000000000 +0100
+++ vfs-2.6/fs/pnode.h	2008-03-26 21:46:35.000000000 +0100
@@ -35,4 +35,5 @@ int propagate_mnt(struct vfsmount *, str
 		struct list_head *);
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
+void mnt_release_group_id(struct vfsmount *);
 #endif /* _LINUX_PNODE_H */
Index: vfs-2.6/include/linux/mount.h
===================================================================
--- vfs-2.6.orig/include/linux/mount.h	2008-03-26 21:39:47.000000000 +0100
+++ vfs-2.6/include/linux/mount.h	2008-03-26 21:39:49.000000000 +0100
@@ -57,6 +57,7 @@ struct vfsmount {
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
+	int mnt_group_id;		/* peer group identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line

--
