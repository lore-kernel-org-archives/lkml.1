Return-Path: <linux-kernel-owner+w=401wt.eu-S939398AbXG3QRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939398AbXG3QRl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938436AbXG3QO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:40572 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765683AbXG3QOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:07 -0400
Message-Id: <20070730161324.628215686@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:39 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 16/26] union-mount: Introduce union_mount structure
Content-Disposition: inline; filename=um/union-mount-union-stack.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the basic structures of VFS based union mounts. It is a new
implementation based on some of my old idea's that influenced Bharata B Rao
<bharata@linux.vnet.ibm.com> who came up with the proposal to let the
union_mount struct only point to the next layer in the union stack. I rewrote
nearly all of the central patches around lookup and the dcache interaction.

Advantages of the new implementation:
- the new union stack is no longer tied directly to one dentry
- the union stack enables dentries to be part of more than one union
  (bind mounts)
- it is unnecessary to traverse the union stack when de/referencing a dentry
- caching of union stack information still driven by dentry cache

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/Kconfig             |    8 +
 fs/Makefile            |    2 
 fs/dcache.c            |    4 
 fs/union.c             |  335 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    9 +
 include/linux/union.h  |   61 ++++++++
 6 files changed, 419 insertions(+)

--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -551,6 +551,14 @@ config INOTIFY_USER
 
 	  If unsure, say Y.
 
+config UNION_MOUNT
+       bool "Union mount support (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       ---help---
+         If you say Y here, you will be able to mount file systems as
+         union mount stacks. This is a VFS based implementation and
+         should work with all file systems. If unsure, say N.
+
 config QUOTA
 	bool "Quota support"
 	help
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -49,6 +49,8 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
+obj-$(CONFIG_UNION_MOUNT)	+= union.o
+
 obj-$(CONFIG_QUOTA)		+= dquot.o
 obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -985,6 +985,10 @@ struct dentry *d_alloc(struct dentry * p
 #ifdef CONFIG_PROFILING
 	dentry->d_cookie = NULL;
 #endif
+#ifdef CONFIG_UNION_MOUNT
+	INIT_LIST_HEAD(&dentry->d_unions);
+	dentry->d_unionized = 0;
+#endif
 	INIT_HLIST_NODE(&dentry->d_hash);
 	INIT_LIST_HEAD(&dentry->d_lru);
 	INIT_LIST_HEAD(&dentry->d_subdirs);
--- /dev/null
+++ b/fs/union.c
@@ -0,0 +1,335 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
+ *
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/bootmem.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/hash.h>
+#include <linux/fs.h>
+#include <linux/union.h>
+
+/*
+ * This is borrowed from fs/inode.c. The hashtable for lookups. Somebody
+ * should try to make this good - I've just made it work.
+ */
+static unsigned int union_hash_mask __read_mostly;
+static unsigned int union_hash_shift __read_mostly;
+static struct hlist_head *union_hashtable __read_mostly;
+static unsigned int union_rhash_mask __read_mostly;
+static unsigned int union_rhash_shift __read_mostly;
+static struct hlist_head *union_rhashtable __read_mostly;
+
+/*
+ * Locking Rules:
+ * - dcache_lock (for union_rlookup() only)
+ * - union_lock
+ */
+DEFINE_SPINLOCK(union_lock);
+
+static struct kmem_cache *union_cache __read_mostly;
+
+static unsigned long hash(struct dentry *dentry, struct vfsmount *mnt)
+{
+	unsigned long tmp;
+
+	tmp = ((unsigned long)mnt * (unsigned long)dentry) ^
+		(GOLDEN_RATIO_PRIME + (unsigned long)mnt) / L1_CACHE_BYTES;
+	tmp = tmp ^ ((tmp ^ GOLDEN_RATIO_PRIME) >> union_hash_shift);
+	return tmp & union_hash_mask;
+}
+
+static __initdata unsigned long union_hash_entries;
+
+static int __init set_union_hash_entries(char *str)
+{
+	if (!str)
+		return 0;
+	union_hash_entries = simple_strtoul(str, &str, 0);
+	return 1;
+}
+
+__setup("union_hash_entries=", set_union_hash_entries);
+
+static int __init init_union(void)
+{
+	int loop;
+
+	union_cache = kmem_cache_create("union_mount",
+					sizeof(struct union_mount), 0,
+					SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+					NULL, NULL);
+
+	union_hashtable = alloc_large_system_hash("Union-cache",
+						  sizeof(struct hlist_head),
+						  union_hash_entries,
+						  14,
+						  0,
+						  &union_hash_shift,
+						  &union_hash_mask,
+						  0);
+
+	for (loop = 0; loop < (1 << union_hash_shift); loop++)
+		INIT_HLIST_HEAD(&union_hashtable[loop]);
+
+
+	union_rhashtable = alloc_large_system_hash("rUnion-cache",
+						  sizeof(struct hlist_head),
+						  union_hash_entries,
+						  14,
+						  0,
+						  &union_rhash_shift,
+						  &union_rhash_mask,
+						  0);
+
+	for (loop = 0; loop < (1 << union_rhash_shift); loop++)
+		INIT_HLIST_HEAD(&union_rhashtable[loop]);
+
+	return 0;
+}
+
+fs_initcall(init_union);
+
+struct union_mount *union_alloc(struct dentry *this, struct vfsmount *this_mnt,
+				struct dentry *next, struct vfsmount *next_mnt)
+{
+	struct union_mount *um;
+
+	BUG_ON(!S_ISDIR(this->d_inode->i_mode));
+	BUG_ON(!S_ISDIR(next->d_inode->i_mode));
+
+	um = kmem_cache_alloc(union_cache, GFP_ATOMIC);
+	if (!um)
+		return NULL;
+
+	atomic_set(&um->u_count, 1);
+	INIT_LIST_HEAD(&um->u_unions);
+	INIT_HLIST_NODE(&um->u_hash);
+	INIT_HLIST_NODE(&um->u_rhash);
+
+	um->u_this.mnt = this_mnt;
+	um->u_this.dentry = this;
+	um->u_next.mnt = mntget(next_mnt);
+	um->u_next.dentry = dget(next);
+
+	return um;
+}
+
+struct union_mount *union_get(struct union_mount *um)
+{
+	BUG_ON(!atomic_read(&um->u_count));
+	atomic_inc(&um->u_count);
+	return um;
+}
+
+static int __union_put(struct union_mount *um)
+{
+	if (!atomic_dec_and_test(&um->u_count))
+		return 0;
+
+	BUG_ON(!hlist_unhashed(&um->u_hash));
+	BUG_ON(!hlist_unhashed(&um->u_rhash));
+
+	kmem_cache_free(union_cache, um);
+	return 1;
+}
+
+void union_put(struct union_mount *um)
+{
+	struct path tmp = um->u_next;
+
+	if (__union_put(um))
+		pathput(&tmp);
+}
+
+static void __union_hash(struct union_mount *um)
+{
+	hlist_add_head(&um->u_hash, union_hashtable +
+		       hash(um->u_this.dentry, um->u_this.mnt));
+	hlist_add_head(&um->u_rhash, union_rhashtable +
+		       hash(um->u_next.dentry, um->u_next.mnt));
+}
+
+static void __union_unhash(struct union_mount *um)
+{
+	hlist_del_init(&um->u_hash);
+	hlist_del_init(&um->u_rhash);
+}
+
+struct union_mount *union_lookup(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct hlist_head *head = union_hashtable + hash(dentry, mnt);
+	struct hlist_node *node;
+	struct union_mount *um;
+
+	hlist_for_each_entry(um, node, head, u_hash) {
+		if ((um->u_this.dentry == dentry) &&
+		    (um->u_this.mnt == mnt))
+			return um;
+	}
+
+	return NULL;
+}
+
+struct union_mount *union_rlookup(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct hlist_head *head = union_rhashtable + hash(dentry, mnt);
+	struct hlist_node *node;
+	struct union_mount *um;
+
+	hlist_for_each_entry(um, node, head, u_rhash) {
+		if ((um->u_next.dentry == dentry) &&
+		    (um->u_next.mnt == mnt))
+			return um;
+	}
+
+	return NULL;
+}
+
+/*
+ * is_unionized - check if a dentry lives on a union mounted file system
+ *
+ * This tests if a dentry is living on an union mounted file system by walking
+ * the file system hierarchy.
+ */
+int is_unionized(struct dentry *dentry, struct vfsmount *mnt)
+{
+	struct path this = { .mnt = mntget(mnt),
+			     .dentry = dget(dentry) };
+	struct vfsmount *tmp;
+
+	do {
+		/* check if there is an union mounted on top of us */
+		spin_lock(&vfsmount_lock);
+		list_for_each_entry(tmp, &this.mnt->mnt_mounts, mnt_child) {
+			if (!(tmp->mnt_flags & MNT_UNION))
+				continue;
+			/* Isn't this a bug? */
+			if (this.dentry->d_sb != tmp->mnt_mountpoint->d_sb)
+				continue;
+			if (lives_below_in_same_fs(this.dentry,
+						   tmp->mnt_mountpoint)) {
+				spin_unlock(&vfsmount_lock);
+				pathput(&this);
+				return 1;
+			}
+		}
+		spin_unlock(&vfsmount_lock);
+
+		/* check our mountpoint next */
+		tmp = mntget(this.mnt->mnt_parent);
+		dput(this.dentry);
+		this.dentry = dget(this.mnt->mnt_mountpoint);
+		mntput(this.mnt);
+		this.mnt = tmp;
+	} while (this.mnt != this.mnt->mnt_parent);
+
+	pathput(&this);
+	return 0;
+}
+
+int append_to_union(struct vfsmount *mnt, struct dentry *dentry,
+		    struct vfsmount *dest_mnt, struct dentry *dest_dentry)
+{
+	struct union_mount *this, *um;
+
+	BUG_ON(!IS_MNT_UNION(mnt));
+
+	this = union_alloc(dentry, mnt, dest_dentry, dest_mnt);
+	if (!this)
+		return -ENOMEM;
+
+	spin_lock(&union_lock);
+	um = union_lookup(dentry, mnt);
+	if (um) {
+		BUG_ON((um->u_next.dentry != dest_dentry) ||
+		       (um->u_next.mnt != dest_mnt));
+		spin_unlock(&union_lock);
+		union_put(this);
+		return 0;
+	}
+	__union_hash(this);
+	spin_unlock(&union_lock);
+	return 0;
+}
+
+/*
+ * follow_union_down - follow the union stack one layer down
+ *
+ * This is called to traverse the union stack from one layer to the next
+ * overlayed one. follow_union_down() is called by various lookup functions
+ * that are aware of union mounts.
+ *
+ * Returns none zero if followed to the next layer, zero otherwise.
+ */
+int follow_union_down(struct vfsmount **mnt, struct dentry **dentry)
+{
+	struct union_mount *um;
+
+	if (!IS_MNT_UNION(*mnt))
+		return 0;
+
+	spin_lock(&union_lock);
+	um = union_lookup(*dentry, *mnt);
+	spin_unlock(&union_lock);
+	if (um) {
+		pathget(&um->u_next);
+		dput(*dentry);
+		*dentry = um->u_next.dentry;
+		mntput(*mnt);
+		*mnt = um->u_next.mnt;
+		return 1;
+	}
+	return 0;
+}
+
+/*
+ * follow_union_mount - follow the union stack to the topmost layer
+ *
+ * This is called to traverse the union stack to the topmost layer. This is
+ * necessary for following parent pointers in an union mount.
+ *
+ * Returns none zero if followed to the topmost layer, zero otherwise.
+ */
+int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
+{
+	struct union_mount *um;
+	int res = 0;
+
+	while (IS_UNION(*dentry)) {
+		spin_lock(&dcache_lock);
+		spin_lock(&union_lock);
+		um = union_rlookup(*dentry, *mnt);
+		if (um)
+			pathget(&um->u_this);
+		spin_unlock(&union_lock);
+		spin_unlock(&dcache_lock);
+
+		/*
+		 * Q: Aaargh, how do I validate the topmost dentry pointer?
+		 * A: Eeeeasy! We took the dcache_lock and union_lock. Since
+		 *    this protects from any dput'ng going on, we know that the
+		 *    dentry is valid since the union is unhashed under
+		 *    dcache_lock too.
+		 */
+		if (!um)
+			break;
+		dput(*dentry);
+		*dentry = um->u_this.dentry;
+		mntput(*mnt);
+		*mnt = um->u_this.mnt;
+		res = 1;
+	}
+
+	return res;
+}
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -93,6 +93,15 @@ struct dentry {
 	struct dentry *d_parent;	/* parent directory */
 	struct qstr d_name;
 
+#ifdef CONFIG_UNION_MOUNT
+	/*
+	 * The following fields are used by the VFS based union mount
+	 * implementation. Both are protected by union_lock!
+	 */
+	struct list_head d_unions;	/* list of union_mount's */
+	unsigned int d_unionized;	/* unions referencing this dentry */
+#endif
+
 	struct list_head d_lru;		/* LRU list */
 	/*
 	 * d_child and d_rcu can share memory
--- /dev/null
+++ b/include/linux/union.h
@@ -0,0 +1,61 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
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
+#include <linux/list.h>
+#include <asm/atomic.h>
+
+struct dentry;
+struct vfsmount;
+
+#ifdef CONFIG_UNION_MOUNT
+
+/*
+ * The new union mount structure.
+ */
+struct union_mount {
+	atomic_t u_count;		/* reference count */
+	struct mutex u_mutex;
+	struct list_head u_unions;	/* list head for d_unions */
+	struct hlist_node u_hash;	/* list head for seaching */
+	struct hlist_node u_rhash;	/* list head for reverse seaching */
+
+	struct path u_this;		/* this is me */
+	struct path u_next;		/* this is what I overlay */
+};
+
+#define IS_UNION(dentry)	(!list_empty(&(dentry)->d_unions) || \
+				 (dentry)->d_unionized)
+#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+
+extern int is_unionized(struct dentry *, struct vfsmount *);
+extern int append_to_union(struct vfsmount *, struct dentry *,
+			   struct vfsmount *, struct dentry *);
+extern int follow_union_down(struct vfsmount **, struct dentry **);
+extern int follow_union_mount(struct vfsmount **, struct dentry **);
+
+#else /* CONFIG_UNION_MOUNT */
+
+#define IS_UNION(x)			(0)
+#define IS_MNT_UNION(x)			(0)
+#define is_unionized(x, y)		(0)
+#define append_to_union(x1, y1, x2, y2)	({ BUG(); (0); })
+#define follow_union_down(x, y)		({ (0); })
+#define follow_union_mount(x, y)	({ (0); })
+
+#endif	/* CONFIG_UNION_MOUNT */
+#endif	/* __KERNEL__ */
+#endif	/* __LINUX_UNION_H */

-- 

