Return-Path: <linux-kernel-owner+w=401wt.eu-S1759070AbYC0M0k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759070AbYC0M0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:26:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbYC0MY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:24:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33814 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbYC0MYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:24:13 -0400
Message-Id: <20080327122400.595798095@szeredi.hu>
References: <20080327120619.031944658@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 27 Mar 2008 13:06:26 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 7/7] vfs: mountinfo: show dominating group id
Content-Disposition: inline; filename=mountinfo_dominator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Show peer group ID of nearest dominating group that has intersection
with the mount's namespace.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/proc.txt |    6 ++++
 fs/namespace.c                     |    9 +++++-
 fs/pnode.c                         |   51 +++++++++++++++++++++++++++++++++++++
 fs/pnode.h                         |    1 
 4 files changed, 65 insertions(+), 2 deletions(-)

Index: vfs-2.6/Documentation/filesystems/proc.txt
===================================================================
--- vfs-2.6.orig/Documentation/filesystems/proc.txt	2008-03-27 12:06:15.000000000 +0100
+++ vfs-2.6/Documentation/filesystems/proc.txt	2008-03-27 12:06:17.000000000 +0100
@@ -2374,8 +2374,14 @@ possible optional fields are:
 
 shared:X  mount is shared in peer group X
 master:X  mount is slave to peer group X
+propagate_from:X  mount is slave and receives propagation from peer group X (*)
 unbindable  mount is unbindable
 
+(*) X is the closest dominant peer group under the process's root.  If
+X is the immediate master of the mount, or if there's no dominant peer
+group under the same root, then only the "master:X" field is present
+and not the "propagate_from:X" field.
+
 For more information on mount propagation see:
 
   Documentation/filesystems/sharedsubtree.txt
Index: vfs-2.6/fs/namespace.c
===================================================================
--- vfs-2.6.orig/fs/namespace.c	2008-03-27 12:06:15.000000000 +0100
+++ vfs-2.6/fs/namespace.c	2008-03-27 12:06:17.000000000 +0100
@@ -836,8 +836,13 @@ static int show_mountinfo(struct seq_fil
 	/* Tagged fields ("foo:X" or "bar") */
 	if (IS_MNT_SHARED(mnt))
 		seq_printf(m, " shared:%i", mnt->mnt_group_id);
-	if (IS_MNT_SLAVE(mnt))
-		seq_printf(m, " master:%i", mnt->mnt_master->mnt_group_id);
+	if (IS_MNT_SLAVE(mnt)) {
+		int master = mnt->mnt_master->mnt_group_id;
+		int dom = get_dominating_id(mnt, &p->root);
+		seq_printf(m, " master:%i", master);
+		if (dom && dom != master)
+			seq_printf(m, " propagate_from:%i", dom);
+	}
 	if (IS_MNT_UNBINDABLE(mnt))
 		seq_puts(m, " unbindable");
 
Index: vfs-2.6/fs/pnode.c
===================================================================
--- vfs-2.6.orig/fs/pnode.c	2008-03-27 12:06:10.000000000 +0100
+++ vfs-2.6/fs/pnode.c	2008-03-27 12:06:17.000000000 +0100
@@ -28,6 +28,57 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }
 
+/*
+ * Return true if path is reachable from root
+ *
+ * namespace_sem is held, and mnt is attached
+ */
+static bool is_path_reachable(struct vfsmount *mnt, struct dentry *dentry,
+			 const struct path *root)
+{
+	while (mnt != root->mnt && mnt->mnt_parent != mnt) {
+		dentry = mnt->mnt_mountpoint;
+		mnt = mnt->mnt_parent;
+	}
+	return mnt == root->mnt && is_subdir(dentry, root->dentry);
+}
+
+static struct vfsmount *get_peer_under_root(struct vfsmount *mnt,
+					    struct mnt_namespace *ns,
+					    const struct path *root)
+{
+	struct vfsmount *m = mnt;
+
+	do {
+		/* Check the namespace first for optimization */
+		if (m->mnt_ns == ns && is_path_reachable(m, m->mnt_root, root))
+			return m;
+
+		m = next_peer(m);
+	} while (m != mnt);
+
+	return NULL;
+}
+
+/*
+ * Get ID of closest dominating peer group having a representative
+ * under the given root.
+ *
+ * Caller must hold namespace_sem
+ */
+int get_dominating_id(struct vfsmount *mnt, const struct path *root)
+{
+	struct vfsmount *m;
+
+	for (m = mnt->mnt_master; m != NULL; m = m->mnt_master) {
+		struct vfsmount *d = get_peer_under_root(m, mnt->mnt_ns, root);
+		if (d)
+			return d->mnt_group_id;
+	}
+
+	return 0;
+}
+
 static int do_make_slave(struct vfsmount *mnt)
 {
 	struct vfsmount *peer_mnt = mnt, *master = mnt->mnt_master;
Index: vfs-2.6/fs/pnode.h
===================================================================
--- vfs-2.6.orig/fs/pnode.h	2008-03-27 12:06:10.000000000 +0100
+++ vfs-2.6/fs/pnode.h	2008-03-27 12:06:17.000000000 +0100
@@ -36,4 +36,5 @@ int propagate_mnt(struct vfsmount *, str
 int propagate_umount(struct list_head *);
 int propagate_mount_busy(struct vfsmount *, int);
 void mnt_release_group_id(struct vfsmount *);
+int get_dominating_id(struct vfsmount *mnt, const struct path *root);
 #endif /* _LINUX_PNODE_H */

--
