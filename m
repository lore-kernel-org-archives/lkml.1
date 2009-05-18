Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZERQR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZERQR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758126AbZERQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:14:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56869 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZERQJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:29 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 18/32] union-mount: Drive the union cache via dcache
Date: Mon, 18 May 2009 18:09:14 +0200
Message-Id: <1242662968-11684-19-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a dentry is removed from dentry cache because its usage count drops to
zero, the references to the underlying layer of the unions the dentry is in
are droped too. Therefore the union cache is driven by the dentry cache.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/dcache.c            |   10 ++++++-
 fs/union.c             |   74 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dcache.h |    8 +++++
 include/linux/union.h  |    6 ++++
 4 files changed, 97 insertions(+), 1 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 37e286e..b6fb688 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -19,6 +19,7 @@
 #include <linux/mm.h>
 #include <linux/fdtable.h>
 #include <linux/fs.h>
+#include <linux/union.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -188,11 +189,14 @@ static struct dentry *__d_kill(struct dentry *dentry, struct list_head *list,
 		list_add(&dentry->d_lru, list);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&dcache_lock);
+		__shrink_d_unions(dentry, list);
 		return NULL;
 	}
 
-	/*drops the locks, at that point nobody can reach this dentry */
+	/* drops the locks, at that point nobody can reach this dentry */
 	dentry_iput(dentry);
+	/* If the dentry was in an union delete them */
+	__shrink_d_unions(dentry, list);
 	if (IS_ROOT(dentry))
 		parent = NULL;
 	else
@@ -784,6 +788,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 					iput(inode);
 			}
 
+			shrink_d_unions(dentry);
 			d_free(dentry);
 
 			/* finished when we fall off the top of the tree,
@@ -1626,7 +1631,9 @@ void d_delete(struct dentry * dentry)
 	spin_lock(&dentry->d_lock);
 	isdir = S_ISDIR(dentry->d_inode->i_mode);
 	if (atomic_read(&dentry->d_count) == 1) {
+		__d_drop_unions(dentry);
 		dentry_iput(dentry);
+		shrink_d_unions(dentry);
 		fsnotify_nameremove(dentry, isdir);
 		return;
 	}
@@ -1637,6 +1644,7 @@ void d_delete(struct dentry * dentry)
 	spin_unlock(&dentry->d_lock);
 	spin_unlock(&dcache_lock);
 
+	shrink_d_unions(dentry);
 	fsnotify_nameremove(dentry, isdir);
 }
 
diff --git a/fs/union.c b/fs/union.c
index f53ef5f..dd8a8cb 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -14,6 +14,7 @@
 
 #include <linux/bootmem.h>
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/types.h>
 #include <linux/hash.h>
 #include <linux/fs.h>
@@ -254,6 +255,8 @@ int append_to_union(struct vfsmount *mnt, struct dentry *dentry,
 		union_put(this);
 		return 0;
 	}
+	list_add(&this->u_unions, &dentry->d_unions);
+	dest_dentry->d_unionized++;
 	__union_hash(this);
 	spin_unlock(&union_lock);
 	return 0;
@@ -329,3 +332,74 @@ int follow_union_mount(struct vfsmount **mnt, struct dentry **dentry)
 
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
+EXPORT_SYMBOL_GPL(__d_drop_unions);
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
+extern void __dput(struct dentry *, struct list_head *, int);
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
+			__dput(n_dentry, list, 0);
+			mntput(n_mnt);
+		}
+		goto repeat;
+	}
+	spin_unlock(&union_lock);
+}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 056b356..7930b07 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -212,12 +212,20 @@ extern seqlock_t rename_lock;
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
diff --git a/include/linux/union.h b/include/linux/union.h
index 0c85312..b035a82 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -46,6 +46,9 @@ extern int append_to_union(struct vfsmount *, struct dentry *,
 			   struct vfsmount *, struct dentry *);
 extern int follow_union_down(struct vfsmount **, struct dentry **);
 extern int follow_union_mount(struct vfsmount **, struct dentry **);
+extern void __d_drop_unions(struct dentry *);
+extern void shrink_d_unions(struct dentry *);
+extern void __shrink_d_unions(struct dentry *, struct list_head *);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -55,6 +58,9 @@ extern int follow_union_mount(struct vfsmount **, struct dentry **);
 #define append_to_union(x1, y1, x2, y2)	({ BUG(); (0); })
 #define follow_union_down(x, y)		({ (0); })
 #define follow_union_mount(x, y)	({ (0); })
+#define __d_drop_unions(x)		do { } while (0)
+#define shrink_d_unions(x)		do { } while (0)
+#define __shrink_d_unions(x,y)		do { } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.1.3

