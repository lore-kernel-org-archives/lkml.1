Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZERQLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZERQLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbZERQLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:11:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:41547 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 20/32] union-mount: Changes to the namespace handling
Date: Mon, 18 May 2009 18:09:16 +0200
Message-Id: <1242662968-11684-21-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Creates the proper struct union_mount when mounting something into a
union. If the topmost filesystem isn't capable of handling the white-out
filetype it could only be mount read-only.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namespace.c        |    7 ++++++
 fs/union.c            |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    3 ++
 include/linux/union.h |   10 +++++++-
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4128d99..22aabc5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -131,6 +131,9 @@ struct vfsmount *alloc_vfsmnt(const char *name)
 		INIT_LIST_HEAD(&mnt->mnt_share);
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
+#ifdef CONFIG_UNION_MOUNT
+		INIT_LIST_HEAD(&mnt->mnt_unions);
+#endif
 		atomic_set(&mnt->__mnt_writers, 0);
 	}
 	return mnt;
@@ -476,6 +479,7 @@ static void __touch_mnt_namespace(struct mnt_namespace *ns)
 
 static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
 {
+	detach_mnt_union(mnt);
 	old_path->dentry = mnt->mnt_mountpoint;
 	old_path->mnt = mnt->mnt_parent;
 	mnt->mnt_parent = mnt;
@@ -499,6 +503,7 @@ static void attach_mnt(struct vfsmount *mnt, struct path *path)
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 			hash(path->mnt, path->dentry));
 	list_add_tail(&mnt->mnt_child, &path->mnt->mnt_mounts);
+	attach_mnt_union(mnt, path->mnt, path->dentry);
 }
 
 /*
@@ -521,6 +526,7 @@ static void commit_tree(struct vfsmount *mnt)
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 				hash(parent, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	attach_mnt_union(mnt, mnt->mnt_parent, mnt->mnt_mountpoint);
 	touch_mnt_namespace(n);
 }
 
@@ -996,6 +1002,7 @@ void release_mounts(struct list_head *head)
 			struct dentry *dentry;
 			struct vfsmount *m;
 			spin_lock(&vfsmount_lock);
+			detach_mnt_union(mnt);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
diff --git a/fs/union.c b/fs/union.c
index dd8a8cb..6e220bd 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -112,6 +112,7 @@ struct union_mount *union_alloc(struct dentry *this, struct vfsmount *this_mnt,
 
 	atomic_set(&um->u_count, 1);
 	INIT_LIST_HEAD(&um->u_unions);
+	INIT_LIST_HEAD(&um->u_list);
 	INIT_HLIST_NODE(&um->u_hash);
 	INIT_HLIST_NODE(&um->u_rhash);
 
@@ -255,6 +256,7 @@ int append_to_union(struct vfsmount *mnt, struct dentry *dentry,
 		union_put(this);
 		return 0;
 	}
+	list_add(&this->u_list, &mnt->mnt_unions);
 	list_add(&this->u_unions, &dentry->d_unions);
 	dest_dentry->d_unionized++;
 	__union_hash(this);
@@ -364,6 +366,7 @@ repeat:
 	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
 		BUG_ON(!hlist_unhashed(&this->u_hash));
 		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
 		spin_unlock(&union_lock);
@@ -392,6 +395,7 @@ repeat:
 
 		BUG_ON(!hlist_unhashed(&this->u_hash));
 		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
 		spin_unlock(&union_lock);
@@ -403,3 +407,56 @@ repeat:
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
diff --git a/include/linux/mount.h b/include/linux/mount.h
index bd35fb8..6f7dda7 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -53,6 +53,9 @@ struct vfsmount {
 	struct list_head mnt_slave_list;/* list of slave mounts */
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
+#ifdef CONFIG_UNION_MOUNT
+	struct list_head mnt_unions;	/* list of union_mount structures */
+#endif
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
 	int mnt_group_id;		/* peer group identifier */
diff --git a/include/linux/union.h b/include/linux/union.h
index b035a82..0b6f356 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -30,8 +30,9 @@ struct union_mount {
 	atomic_t u_count;		/* reference count */
 	struct mutex u_mutex;
 	struct list_head u_unions;	/* list head for d_unions */
-	struct hlist_node u_hash;	/* list head for searching */
-	struct hlist_node u_rhash;	/* list head for reverse searching */
+	struct list_head u_list;	/* list head for mnt_unions */
+	struct hlist_node u_hash;	/* list head for seaching */
+	struct hlist_node u_rhash;	/* list head for reverse seaching */
 
 	struct path u_this;		/* this is me */
 	struct path u_next;		/* this is what I overlay */
@@ -49,6 +50,9 @@ extern int follow_union_mount(struct vfsmount **, struct dentry **);
 extern void __d_drop_unions(struct dentry *);
 extern void shrink_d_unions(struct dentry *);
 extern void __shrink_d_unions(struct dentry *, struct list_head *);
+extern int attach_mnt_union(struct vfsmount *, struct vfsmount *,
+			    struct dentry *);
+extern void detach_mnt_union(struct vfsmount *);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -61,6 +65,8 @@ extern void __shrink_d_unions(struct dentry *, struct list_head *);
 #define __d_drop_unions(x)		do { } while (0)
 #define shrink_d_unions(x)		do { } while (0)
 #define __shrink_d_unions(x,y)		do { } while (0)
+#define attach_mnt_union(x, y, z)	do { } while (0)
+#define detach_mnt_union(x)		do { } while (0)
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.1.3

