Return-Path: <linux-kernel-owner+w=401wt.eu-S932512AbZJUT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512AbZJUT0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932483AbZJUT0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:26:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbZJUTVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:03 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: [PATCH 23/41] union-mount: Changes to the namespace handling
Date: Wed, 21 Oct 2009 12:19:21 -0700
Message-Id: <1256152779-10054-24-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-23-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
 <1256152779-10054-23-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Creates the proper struct union_mount when mounting something into a
union. If the topmost filesystem isn't capable of handling the white-out
filetype it could only be mount read-only.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c        |    7 ++++++
 fs/union.c            |   57 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    3 ++
 include/linux/union.h |   10 +++++++-
 4 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index dc01385..0280e5b 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -158,6 +158,9 @@ struct vfsmount *alloc_vfsmnt(const char *name)
 #else
 		mnt->mnt_writers = 0;
 #endif
+#ifdef CONFIG_UNION_MOUNT
+		INIT_LIST_HEAD(&mnt->mnt_unions);
+#endif
 	}
 	return mnt;
 
@@ -470,6 +473,7 @@ static void __touch_mnt_namespace(struct mnt_namespace *ns)
 
 static void detach_mnt(struct vfsmount *mnt, struct path *old_path)
 {
+	detach_mnt_union(mnt);
 	old_path->dentry = mnt->mnt_mountpoint;
 	old_path->mnt = mnt->mnt_parent;
 	mnt->mnt_parent = mnt;
@@ -493,6 +497,7 @@ static void attach_mnt(struct vfsmount *mnt, struct path *path)
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 			hash(path->mnt, path->dentry));
 	list_add_tail(&mnt->mnt_child, &path->mnt->mnt_mounts);
+	attach_mnt_union(mnt, path->mnt, path->dentry);
 }
 
 /*
@@ -515,6 +520,7 @@ static void commit_tree(struct vfsmount *mnt)
 	list_add_tail(&mnt->mnt_hash, mount_hashtable +
 				hash(parent, mnt->mnt_mountpoint));
 	list_add_tail(&mnt->mnt_child, &parent->mnt_mounts);
+	attach_mnt_union(mnt, mnt->mnt_parent, mnt->mnt_mountpoint);
 	touch_mnt_namespace(n);
 }
 
@@ -986,6 +992,7 @@ void release_mounts(struct list_head *head)
 			struct dentry *dentry;
 			struct vfsmount *m;
 			spin_lock(&vfsmount_lock);
+			detach_mnt_union(mnt);
 			dentry = mnt->mnt_mountpoint;
 			m = mnt->mnt_parent;
 			mnt->mnt_mountpoint = mnt->mnt_root;
diff --git a/fs/union.c b/fs/union.c
index 6b99393..341fc03 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -113,6 +113,7 @@ struct union_mount *union_alloc(struct dentry *this, struct vfsmount *this_mnt,
 
 	atomic_set(&um->u_count, 1);
 	INIT_LIST_HEAD(&um->u_unions);
+	INIT_LIST_HEAD(&um->u_list);
 	INIT_HLIST_NODE(&um->u_hash);
 	INIT_HLIST_NODE(&um->u_rhash);
 
@@ -256,6 +257,7 @@ int append_to_union(struct vfsmount *mnt, struct dentry *dentry,
 		union_put(this);
 		return 0;
 	}
+	list_add(&this->u_list, &mnt->mnt_unions);
 	list_add(&this->u_unions, &dentry->d_unions);
 	dest_dentry->d_unionized++;
 	__union_hash(this);
@@ -365,6 +367,7 @@ repeat:
 	list_for_each_entry_safe(this, next, &dentry->d_unions, u_unions) {
 		BUG_ON(!hlist_unhashed(&this->u_hash));
 		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
 		spin_unlock(&union_lock);
@@ -393,6 +396,7 @@ repeat:
 
 		BUG_ON(!hlist_unhashed(&this->u_hash));
 		BUG_ON(!hlist_unhashed(&this->u_rhash));
+		list_del(&this->u_list);
 		list_del(&this->u_unions);
 		this->u_next.dentry->d_unionized--;
 		spin_unlock(&union_lock);
@@ -404,3 +408,56 @@ repeat:
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
index e175c47..70c4f1f 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -54,6 +54,9 @@ struct vfsmount {
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
1.6.3.3

