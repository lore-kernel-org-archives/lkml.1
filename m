Return-Path: <linux-kernel-owner+w=401wt.eu-S939209AbXG3QQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939209AbXG3QQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938201AbXG3QOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:14:20 -0400
Received: from mx1.suse.de ([195.135.220.2]:40565 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765177AbXG3QOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:14:06 -0400
Message-Id: <20070730161324.744758479@weierstrass.suse.de>
References: <20070730161323.100048969@weierstrass.suse.de>
User-Agent: quilt/0.46-62.2
Date: Mon, 30 Jul 2007 18:13:40 +0200
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [RFC 17/26] union-mount: Drive the union cache via dcache
Content-Disposition: inline; filename=um/union-mount-dentry-refcount.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If a dentry is removed from dentry cache because its usage count drops to
zero, the references to the underlying layer of the unions the dentry is in
are droped too. Therefore the union cache is driven by the dentry cache.

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/dcache.c            |    8 +++++
 fs/union.c             |   72 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    8 +++++
 include/linux/union.h  |    6 ++++
 4 files changed, 94 insertions(+)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/union.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -142,11 +143,14 @@ static struct dentry *__d_kill(struct de
 		list_add(&dentry->d_lru, list);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
+		__shrink_d_unions(dentry, list);
 		return NULL;
 	}
 
 	/* drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
+	/* If the dentry was in an union delete them */
+	shrink_d_unions(dentry);
 	parent = dentry->d_parent;
 	d_free(dentry);
 	return dentry == parent ? NULL : parent;
@@ -721,6 +725,7 @@ static void shrink_dcache_for_umount_sub
 					iput(inode);
 			}
 
+			shrink_d_unions(dentry);
 			d_free(dentry);
 
 			/* finished when we fall off the top of the tree,
@@ -1464,7 +1469,9 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (atomic_read(&dentry->d_count) == 1) {
+		__d_drop_unions(dentry);
 		dentry_iput(dentry);
+		shrink_d_unions(dentry);
 		fsnotify_nameremove(dentry, isdir);
 
 		/* remove this and other inotify debug checks after 2.6.18 */
@@ -1478,6 +1485,7 @@ void d_delete(struct dentry * dentry)
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
+	shrink_d_unions(dentry);
 	fsnotify_nameremove(dentry, isdir);
 }
 
--- a/fs/union.c
+++ b/fs/union.c
@@ -258,6 +258,8 @@ int append_to_union(struct vfsmount *mnt
 		union_put(this);
 		return 0;
 	}
+	list_add(&this->u_unions, &dentry->d_unions);
+	dest_dentry->d_unionized++;
 	__union_hash(this);
 	spin_unlock(&union_lock);
 	return 0;
@@ -333,3 +335,73 @@ int follow_union_mount(struct vfsmount *
 
 	return res;
 }
+
+/*
+ * This must be called when unhashing a dentry. This is called with dcache_lock
+ * and unhashes all unions this dentry is in.
+ */
+void __d_drop_unions(struct dentry *dentry)
+{
+	struct union_mount *this, *next;
+
+	spin_lock(&union_lock);
+	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions)
+		__union_unhash(this);
+	spin_unlock(&union_lock);
+}
+
+/*
+ * This must be called after __d_drop_unions() without holding any locks.
+ * Note: The dentry might still be reachable via a lookup but at that time it
+ * already a negative dentry. Otherwise it would be unhashed. The union_mount
+ * structure itself is still reachable through mnt->mnt_unions (which we
+ * protect against with union_lock).
+ */
+void shrink_d_unions(struct dentry *dentry)
+{
+	struct union_mount *this, *next;
+
+repeat:
+	spin_lock(&union_lock);
+	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
+		BUG_ON(!hlist_unhashed(&this->u_hash));
+		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_unions);
+		this->u_next.dentry->d_unionized--;
+		spin_unlock(&union_lock);
+		union_put(this);
+		goto repeat;
+	}
+	spin_unlock(&union_lock);
+}
+
+extern void __dput(struct dentry *, struct list_head *);
+
+/*
+ * This is the special variant for use in dput() only.
+ */
+void __shrink_d_unions(struct dentry *dentry, struct list_head *list)
+{
+	struct union_mount *this, *next;
+
+	BUG_ON(!d_unhashed(dentry));
+
+repeat:
+	spin_lock(&union_lock);
+	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
+		struct dentry *n_dentry = this->u_next.dentry;
+		struct vfsmount *n_mnt = this->u_next.mnt;
+
+		BUG_ON(!hlist_unhashed(&this->u_hash));
+		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_unions);
+		this->u_next.dentry->d_unionized--;
+		spin_unlock(&union_lock);
+		if (__union_put(this)) {
+			__dput(n_dentry, list);
+			mntput(n_mnt);
+		}
+		goto repeat;
+	}
+	spin_unlock(&union_lock);
+}
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -204,12 +204,20 @@ extern spinlock_t dcache_lock;
  * __d_drop requires dentry->d_lock.
  */
 
+#ifdef CONFIG_UNION_MOUNT
+extern void __d_drop_unions(struct dentry *);
+#endif
+
 static inline void __d_drop(struct dentry *dentry)
 {
 	if (!(dentry->d_flags & DCACHE_UNHASHED)) {
 		dentry->d_flags |= DCACHE_UNHASHED;
 		hlist_del_rcu(&dentry->d_hash);
 	}
+#ifdef CONFIG_UNION_MOUNT
+	/* remove dentry from the union hashtable */
+	__d_drop_unions(dentry);
+#endif
 }
 
 static inline void d_drop(struct dentry *dentry)
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -46,6 +46,9 @@ extern int append_to_union(struct vfsmou
 			   struct vfsmount *, struct dentry *);
 extern int follow_union_down(struct vfsmount **, struct dentry **);
 extern int follow_union_mount(struct vfsmount **, struct dentry **);
+extern void __d_drop_unions(struct dentry *);
+extern void shrink_d_unions(struct dentry *);
+extern void __shrink_d_unions(struct dentry *, struct list_head *);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -55,6 +58,9 @@ extern int follow_union_mount(struct vfs
 #define append_to_union(x1, y1, x2, y2)	({ BUG(); (0); })
 #define follow_union_down(x, y)		({ (0); })
 #define follow_union_mount(x, y)	({ (0); })
+#define __d_drop_unions(x)		do { } while (0)
+#define shrink_d_unions(x)		do { } while (0)
+#define __shrink_d_unions(x)		do { } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */

-- 

