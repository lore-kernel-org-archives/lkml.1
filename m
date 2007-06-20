Return-Path: <linux-kernel-owner+w=401wt.eu-S932149AbXFTFpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbXFTFpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 01:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760580AbXFTFpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 01:45:22 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:58353 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760544AbXFTFpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 01:45:19 -0400
Date: Wed, 20 Jun 2007 11:22:41 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC PATCH 2/4] Mount changes to support union mount.
Message-ID: <20070620055241.GD4267@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070620055050.GB4267@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620055050.GB4267@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: Mount changes to support union mount.

Adds union mount support.

This patch adds a new mount type for union mount (MNT_UNION) and changes
the mount path to build a union stack during mount. The routines for
supporting the creation, traversal and destruction of union stacks are
also included here.

Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/namespace.c        |  164 ++++++++++++++++++++++++++++++++++++++++++++++----
 include/linux/fs.h    |    1 
 include/linux/mount.h |   17 +++++
 3 files changed, 172 insertions(+), 10 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -35,6 +35,7 @@ __cacheline_aligned_in_smp DEFINE_SPINLO
 static int event;
 
 static struct list_head *mount_hashtable __read_mostly;
+static struct list_head *union_mount_hashtable;
 static int hash_mask __read_mostly, hash_bits __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
 static struct rw_semaphore namespace_sem;
@@ -54,6 +55,89 @@ static inline unsigned long hash(struct 
 	return tmp & hash_mask;
 }
 
+/* Must be called with vfsmount_lock held */
+static struct union_mount *find_union_mount(struct vfsmount *mnt,
+		struct dentry *dentry)
+{
+	struct list_head *head;
+	struct union_mount *u;
+
+	if (!IS_MNT_UNION(mnt))
+		return NULL;
+
+	head = union_mount_hashtable + hash(mnt, dentry);
+	list_for_each_entry(u, head, hash)
+		if (u->src_mnt == mnt && u->src_dentry == dentry)
+			return u;
+	return NULL;
+}
+
+/*
+ * When propagating mount events to peer group, this is called under
+ * vfsmount_lock. Hence using GFP_ATOMIC for kmalloc here.
+ * TODO: Can we use a separate kmem cache for union_mount ?
+ */
+struct union_mount *alloc_union_mount(struct vfsmount *src_mnt,
+	struct dentry *src_dentry, struct vfsmount *dst_mnt,
+	struct dentry *dst_dentry)
+{
+	struct union_mount *u;
+	u = kmalloc(sizeof(struct union_mount), GFP_ATOMIC);
+	if (!u)
+		return u;
+	u->dst_mnt = mntget(dst_mnt);
+	u->dst_dentry = dget(dst_dentry);
+	u->src_mnt = src_mnt;
+	u->src_dentry = dget(src_dentry);
+	INIT_LIST_HEAD(&u->hash);
+	INIT_LIST_HEAD(&u->list);
+	return u;
+}
+
+/* Must be called with vfsmount_lock held */
+void attach_mnt_union(struct union_mount *u)
+{
+	if (!u)
+		return;
+
+	list_add_tail(&u->hash, union_mount_hashtable +
+			hash(u->src_mnt, u->src_dentry));
+	list_add_tail(&u->list, &u->src_mnt->mnt_union);
+}
+
+/*
+ * Finds the next (vfsmount, dentry) in the union stack. If found, returns
+ * it via @nd and returns true. Else doesn't modify @nd, but returns false.
+ */
+int next_union_mount(struct nameidata *nd)
+{
+	struct union_mount *u;
+
+	spin_lock(&vfsmount_lock);
+	u = find_union_mount(nd->mnt, nd->dentry);
+	spin_unlock(&vfsmount_lock);
+	if (u) {
+		nd->mnt = u->dst_mnt;
+		nd->dentry = u->dst_dentry;
+		return 1;
+	}
+	return 0;
+}
+
+/* Check if next element of the union stack exists. @nd isn't modified. */
+int next_union_mount_exists(struct vfsmount *mnt, struct dentry *dentry)
+{
+	struct union_mount *u;
+
+	spin_lock(&vfsmount_lock);
+	u = find_union_mount(mnt, dentry);
+	spin_unlock(&vfsmount_lock);
+	if (u)
+		return 1;
+	else
+		return 0;
+}
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
@@ -67,6 +151,7 @@ struct vfsmount *alloc_vfsmnt(const char
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+		INIT_LIST_HEAD(&mnt->mnt_union);
 		if (name) {
 			int size = strlen(name) + 1;
 			char *newname = kmalloc(size, GFP_KERNEL);
@@ -173,18 +258,20 @@ void mnt_set_mountpoint(struct vfsmount 
 	dentry->d_mounted++;
 }
 
-static void attach_mnt(struct vfsmount *mnt, struct nameidata *nd)
+static void attach_mnt(struct vfsmount *mnt, struct nameidata *nd,
+		struct union_mount *u)
 {
 	mnt_set_mountpoint(nd->mnt, nd->dentry, mnt);
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 			hash(nd->mnt, nd->dentry));
 	list_add_tail(&mnt->mnt_child, &nd->mnt->mnt_mounts);
+	attach_mnt_union(u);
 }
 
 /*
  * the caller must hold vfsmount_lock
  */
-static void commit_tree(struct vfsmount *mnt)
+static void commit_tree(struct vfsmount *mnt, struct union_mount *u)
 {
 	struct vfsmount *parent = mnt->mnt_parent;
 	struct vfsmount *m;
@@ -201,6 +288,7 @@ static void commit_tree(struct vfsmount 
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 				hash(parent, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	attach_mnt_union(u);
 	touch_mnt_namespace(n);
 }
 
@@ -342,8 +430,18 @@ static struct vfsmount *clone_mnt(struct
 static inline void __mntput(struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
+	struct union_mount *u, *next;
+
 	dput(mnt->mnt_root);
 	clear_mnt_user(mnt);
+
+	list_for_each_entry_safe(u, next, &mnt->mnt_union, list) {
+		list_del_init(&u->list);
+		dput(u->src_dentry);
+		mntput(u->dst_mnt);
+		dput(u->dst_dentry);
+		kfree(u);
+	}
 	free_vfsmnt(mnt);
 	deactivate_super(sb);
 }
@@ -352,6 +450,17 @@ void mntput_no_expire(struct vfsmount *m
 {
 repeat:
 	if (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
+		struct union_mount *u;
+
+		/*
+		 * Remove all union_mounts under this mnt from the
+		 * union_mount_hashtable. This needs to be be done with
+		 * vfsmount_lock held. The rest of the cleanup is done
+		 * outside of the lock.
+		 */
+		list_for_each_entry(u, &mnt->mnt_union, list)
+			list_del_init(&u->hash);
+
 		if (likely(!mnt->mnt_pinned)) {
 			spin_unlock(&vfsmount_lock);
 			__mntput(mnt);
@@ -436,6 +545,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_NOMNT, ",nomnt" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -839,7 +949,11 @@ struct vfsmount *copy_tree(struct vfsmou
 				goto error;
 			spin_lock(&vfsmount_lock);
 			list_add_tail(&q->mnt_list, &res->mnt_list);
-			attach_mnt(q, &nd);
+			/*
+			 * TODO: Understand and pass appropriate union_mount
+			 * argument here.
+			 */
+			attach_mnt(q, &nd, NULL);
 			spin_unlock(&vfsmount_lock);
 		}
 	}
@@ -925,10 +1039,16 @@ static int attach_recursive_mnt(struct v
 	struct vfsmount *dest_mnt = nd->mnt;
 	struct dentry *dest_dentry = nd->dentry;
 	struct vfsmount *child, *p;
+	struct union_mount *u = NULL;
 
 	if (propagate_mnt(dest_mnt, dest_dentry, source_mnt, &tree_list))
 		return -EINVAL;
 
+	if (IS_MNT_UNION(source_mnt))
+		if (!(u = alloc_union_mount(source_mnt, source_mnt->mnt_root,
+					dest_mnt, dest_dentry)))
+			return -ENOMEM;
+
 	if (IS_MNT_SHARED(dest_mnt)) {
 		for (p = source_mnt; p; p = next_mnt(p, source_mnt))
 			set_mnt_shared(p);
@@ -937,18 +1057,26 @@ static int attach_recursive_mnt(struct v
 	spin_lock(&vfsmount_lock);
 	if (parent_nd) {
 		detach_mnt(source_mnt, parent_nd);
-		attach_mnt(source_mnt, nd);
+		attach_mnt(source_mnt, nd, u);
 		touch_mnt_namespace(current->nsproxy->mnt_ns);
 	} else {
 		mnt_set_mountpoint(dest_mnt, dest_dentry, source_mnt);
-		commit_tree(source_mnt);
+		commit_tree(source_mnt, u);
 	}
 
 	list_for_each_entry_safe(child, p, &tree_list, mnt_hash) {
 		list_del_init(&child->mnt_hash);
-		commit_tree(child);
+		if (IS_MNT_UNION(child)) {
+			u = alloc_union_mount(child, child->mnt_root,
+				child->mnt_parent, child->mnt_mountpoint);
+			/* FIXME: It is too late to fail from here */
+			if (!u)
+				printk(KERN_ERR "attach_recursive_mnt: ENOMEM\n");
+		}
+		commit_tree(child, u);
 	}
 	spin_unlock(&vfsmount_lock);
+
 	return 0;
 }
 
@@ -1556,9 +1684,12 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_NOMNT)
 		mnt_flags |= MNT_NOMNT;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT |
+		   MS_UNION);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
@@ -1888,8 +2019,9 @@ asmlinkage long sys_pivot_root(const cha
 		goto out3;
 	detach_mnt(new_nd.mnt, &parent_nd);
 	detach_mnt(user_nd.mnt, &root_parent);
-	attach_mnt(user_nd.mnt, &old_nd);     /* mount old root on put_old */
-	attach_mnt(new_nd.mnt, &root_parent); /* mount new_root on / */
+	/* TODO: Understand and pass appropriate union_mount argument here. */
+	attach_mnt(user_nd.mnt, &old_nd, NULL);	 /* mount old root on put_old */
+	attach_mnt(new_nd.mnt, &root_parent, NULL); /* mount new_root on / */
 	touch_mnt_namespace(current->nsproxy->mnt_ns);
 	spin_unlock(&vfsmount_lock);
 	chroot_fs_refs(&user_nd, &new_nd);
@@ -1940,7 +2072,7 @@ static void __init init_mount_tree(void)
 
 void __init mnt_init(unsigned long mempages)
 {
-	struct list_head *d;
+	struct list_head *d, *e;
 	unsigned int nr_hash;
 	int i;
 	int err;
@@ -1976,12 +2108,24 @@ void __init mnt_init(unsigned long mempa
 
 	printk("Mount-cache hash table entries: %d\n", nr_hash);
 
+	/*
+	 * Use the same nr_hash for union mount hashtable also.
+	 * TODO: This might need a bigger hash table.
+	 */
+	union_mount_hashtable = (struct list_head *)__get_free_page(GFP_ATOMIC);
+
+	if (!union_mount_hashtable)
+		panic("Failed to allocate union mount hash table\n");
+
 	/* And initialize the newly allocated array */
 	d = mount_hashtable;
+	e = union_mount_hashtable;
 	i = nr_hash;
 	do {
 		INIT_LIST_HEAD(d);
+		INIT_LIST_HEAD(e);
 		d++;
+		e++;
 		i--;
 	} while (i);
 	err = sysfs_init();
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -113,6 +113,7 @@ extern int dir_notify_enable;
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256	/* Union mount */
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -36,6 +36,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;
@@ -53,6 +54,7 @@ struct vfsmount {
 	struct list_head mnt_share;	/* circular list of shared mounts */
 	struct list_head mnt_slave_list;/* list of slave mounts */
 	struct list_head mnt_slave;	/* slave list entry */
+	struct list_head mnt_union;	/* list of union_mounts */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	/*
@@ -107,5 +109,20 @@ extern void shrink_submounts(struct vfsm
 extern spinlock_t vfsmount_lock;
 extern dev_t name_to_dev_t(char *name);
 
+#define IS_MNT_UNION(mnt) (mnt->mnt_flags & MNT_UNION)
+
+struct union_mount {
+	struct vfsmount *src_mnt, *dst_mnt;
+	struct dentry *src_dentry, *dst_dentry;
+	struct list_head hash, list;
+};
+
+extern void attach_mnt_union(struct union_mount *u);
+extern struct union_mount *alloc_union_mount(struct vfsmount *src_mnt,
+	struct dentry *src_dentry, struct vfsmount *dst_mnt,
+	struct dentry *dst_dentry);
+extern int next_union_mount(struct nameidata *nd);
+extern int next_union_mount_exists(struct vfsmount *mnt, struct dentry *dentry);
+
 #endif
 #endif /* _LINUX_MOUNT_H */
