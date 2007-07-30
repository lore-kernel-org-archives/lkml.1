Return-Path: <linux-kernel-owner+w=401wt.eu-S939157AbXG3QSD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939157AbXG3QSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:18:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938482AbXG3QOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:40564 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765115AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161324.806938495@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:41 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 18/26] union-mount: Changes to the namespace handling
Content-Disposition: inline; filename=um/union-mount-mount-changes.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Creates the proper struct union_mount when mounting something into a
union. If the topmost filesystem isn't capable of handling the white-out
filetype it could only be mount read-only.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/namespace.c        |   46 ++++++++++++++++++++++++++++++++++++++--
 fs/union.c            |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    3 ++
 include/linux/union.h |    6 +++++
 4 files changed, 110 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -25,6 +25,7 @@
 #include <linux/security.h>
 #include <linux/mount.h>
 #include <linux/ramfs.h>
+#include <linux/union.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -68,6 +69,9 @@ struct vfsmount *alloc_vfsmnt(const char
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+#ifdef CONFIG_UNION_MOUNT
+		INIT_LIST_HEAD(&mnt->mnt_unions);
+#endif
 		if (name) {
 			int size = strlen(name) + 1;
 			char *newname = kmalloc(size, GFP_KERNEL);
@@ -157,6 +161,7 @@ static void __touch_mnt_namespace(struct
 
 static void detach_mnt(struct vfsmount *mnt, struct nameidata *old_nd)
 {
+	detach_mnt_union(mnt);
 	old_nd->dentry = mnt->mnt_mountpoint;
 	old_nd->mnt = mnt->mnt_parent;
 	mnt->mnt_parent = mnt;
@@ -180,6 +185,7 @@ static void attach_mnt(struct vfsmount *
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 			hash(nd->mnt, nd->dentry));
 	list_add_tail(&mnt->mnt_child, &nd->mnt->mnt_mounts);
+	attach_mnt_union(mnt, nd->mnt, nd->dentry);
 }
 
 /*
@@ -202,6 +208,7 @@ static void commit_tree(struct vfsmount 
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 				hash(parent, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	attach_mnt_union(mnt, mnt->mnt_parent, mnt->mnt_mountpoint);
 	touch_mnt_namespace(n);
 }
 
@@ -577,6 +584,7 @@ void release_mounts(struct list_head *he
 			struct dentry *dentry;
 			struct vfsmount *m;
 			spin_lock(&vfsmount_lock);
+			detach_mnt_union(mnt);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
@@ -999,6 +1007,10 @@ static int do_change_type(struct nameida
 	if (nd->dentry != nd->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't change the type of union mounts */
+	if (IS_MNT_UNION(nd->mnt))
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	spin_lock(&vfsmount_lock);
 	for (m = mnt; m; m = (recurse ? next_mnt(m, mnt) : NULL))
@@ -1011,7 +1023,8 @@ static int do_change_type(struct nameida
 /*
  * do loopback mount.
  */
-static int do_loopback(struct nameidata *nd, char *old_name, int flags)
+static int do_loopback(struct nameidata *nd, char *old_name, int flags,
+		       int mnt_flags)
 {
 	int clone_flags = 0;
 	uid_t owner = 0;
@@ -1049,6 +1062,18 @@ static int do_loopback(struct nameidata 
 	if (IS_ERR(mnt))
 		goto out;
 
+	/*
+	 * Unions couldn't be writable if the filesystem doesn't know about
+	 * whiteouts
+	 */
+	err = -ENOTSUPP;
+	if ((mnt_flags & MNT_UNION) &&
+	    !(mnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
+		goto out;
+
+	if (mnt_flags & MNT_UNION)
+		mnt->mnt_flags |= MNT_UNION;
+
 	err = graft_tree(mnt, nd);
 	if (err) {
 		LIST_HEAD(umount_list);
@@ -1121,6 +1146,13 @@ static int do_move_mount(struct nameidat
 	if (err)
 		return err;
 
+	/* moving to or from a union mount is not supported */
+	err = -EINVAL;
+	if (IS_MNT_UNION(nd->mnt))
+		goto exit;
+	if (IS_MNT_UNION(old_nd.mnt))
+		goto exit;
+
 	down_write(&namespace_sem);
 	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
 		;
@@ -1176,6 +1208,7 @@ out:
 	up_write(&namespace_sem);
 	if (!err)
 		path_release(&parent_nd);
+exit:
 	path_release(&old_nd);
 	return err;
 }
@@ -1253,6 +1286,15 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	/*
+	 * Unions couldn't be writable if the filesystem doesn't know about
+	 * whiteouts
+	 */
+	err = -ENOTSUPP;
+	if ((mnt_flags & MNT_UNION) &&
+	    !(newmnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
+		goto unlock;
+
 	/* some flags may have been set earlier */
 	newmnt->mnt_flags |= mnt_flags;
 	if ((err = graft_tree(newmnt, nd)))
@@ -1579,7 +1621,7 @@ long do_mount(char *dev_name, char *dir_
 		retval = do_remount(&nd, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&nd, dev_name, flags);
+		retval = do_loopback(&nd, dev_name, flags, mnt_flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&nd, flags);
 	else if (flags & MS_MOVE)
--- a/fs/union.c
+++ b/fs/union.c
@@ -114,6 +114,7 @@ struct union_mount *union_alloc(struct d
 
 	atomic_set(&um->u_count, 1);
 	INIT_LIST_HEAD(&um->u_unions);
+	INIT_LIST_HEAD(&um->u_list);
 	INIT_HLIST_NODE(&um->u_hash);
 	INIT_HLIST_NODE(&um->u_rhash);
 
@@ -258,6 +259,7 @@ int append_to_union(struct vfsmount *mnt
 		union_put(this);
 		return 0;
 	}
+	list_add(&this->u_list, &mnt->mnt_unions);
 	list_add(&this->u_unions, &dentry->d_unions);
 	dest_dentry->d_unionized++;
 	__union_hash(this);
@@ -366,6 +368,7 @@ repeat:
 	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
 		BUG_ON(!hlist_unhashed(&this->u_hash));
 		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
 		spin_unlock(&union_lock);
@@ -394,6 +397,7 @@ repeat:
 
 		BUG_ON(!hlist_unhashed(&this->u_hash));
 		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
 		spin_unlock(&union_lock);
@@ -405,3 +409,56 @@ repeat:
 	}
 	spin_unlock(&union_lock);
 }
+
+/*
+ * Remove all union_mounts structures belonging to this vfsmount from the
+ * union lookup hashtable and so on ...
+ */
+void shrink_mnt_unions(struct vfsmount *mnt)
+{
+	struct union_mount *this, *next;
+
+repeat:
+	spin_lock(&union_lock);
+	list_for_each_entry_safe(this, next, &mnt->mnt_unions, u_list) {
+		if (this->u_this.dentry == mnt->mnt_root)
+			continue;
+		__union_unhash(this);
+		list_del(&this->u_list);
+		list_del(&this->u_unions);
+		this->u_next.dentry->d_unionized--;
+		spin_unlock(&union_lock);
+		union_put(this);
+		goto repeat;
+	}
+	spin_unlock(&union_lock);
+}
+
+int attach_mnt_union(struct vfsmount *mnt, struct vfsmount *dest_mnt,
+		     struct dentry *dest_dentry)
+{
+	if (!IS_MNT_UNION(mnt))
+		return 0;
+
+	return append_to_union(mnt, mnt->mnt_root, dest_mnt, dest_dentry);
+}
+
+void detach_mnt_union(struct vfsmount *mnt)
+{
+	struct union_mount *um;
+
+	if (!IS_MNT_UNION(mnt))
+		return;
+
+	shrink_mnt_unions(mnt);
+
+	spin_lock(&union_lock);
+	um = union_lookup(mnt->mnt_root, mnt);
+	__union_unhash(um);
+	list_del(&um->u_list);
+	list_del(&um->u_unions);
+	um->u_next.dentry->d_unionized--;
+	spin_unlock(&union_lock);
+	union_put(um);
+	return;
+}
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -56,6 +56,9 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+#ifdef CONFIG_UNION_MOUNT
+	struct list_head mnt_unions;	/* list of union_mount structures */
+#endif
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -30,6 +30,7 @@ struct union_mount {
 	atomic_t u_count;		/* reference count */
 	struct mutex u_mutex;
 	struct list_head u_unions;	/* list head for d_unions */
+	struct list_head u_list;	/* list head for mnt_unions */
 	struct hlist_node u_hash;	/* list head for seaching */
 	struct hlist_node u_rhash;	/* list head for reverse seaching */
 
@@ -49,6 +50,9 @@ extern int follow_union_mount(struct vfs
 extern void __d_drop_unions(struct dentry *);
 extern void shrink_d_unions(struct dentry *);
 extern void __shrink_d_unions(struct dentry *, struct list_head *);
+extern int attach_mnt_union(struct vfsmount *, struct vfsmount *,
+			    struct dentry *);
+extern void detach_mnt_union(struct vfsmount *);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -61,6 +65,8 @@ extern void __shrink_d_unions(struct den
 #define __d_drop_unions(x)		do { } while (0)
 #define shrink_d_unions(x)		do { } while (0)
 #define __shrink_d_unions(x)		do { } while (0)
+#define attach_mnt_union(x, y, z)	do { } while (0)
+#define detach_mnt_union(x)		do { } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */

-- 

