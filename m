Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYCMV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYCMV3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbYCMV1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:27:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51621 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYCMV1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:27:49 -0400
Message-Id: <20080313212735.741834181@szeredi.hu>
References: <20080313212641.989467982@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 13 Mar 2008 22:26:44 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/6] vfs: mountinfo stable peer group id
Content-Disposition: inline; filename=mountinfo_stable_peer_group_id.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a stable identifier for shared mounts.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 Documentation/filesystems/proc.txt |   12 +------
 fs/namespace.c                     |    7 ++--
 fs/pnode.c                         |   63 ++++++++++++++++++++++++-------------
 fs/pnode.h                         |    1 
 include/linux/mount.h              |    1 
 5 files changed, 52 insertions(+), 32 deletions(-)

Index: linux/fs/pnode.c
===================================================================
--- linux.orig/fs/pnode.c	2008-03-13 20:45:49.000000000 +0100
+++ linux/fs/pnode.c	2008-03-13 20:45:50.000000000 +0100
@@ -9,8 +9,12 @@
 #include <linux/mnt_namespace.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/idr.h>
 #include "pnode.h"
 
+static DEFINE_SPINLOCK(mnt_pgid_lock);
+static DEFINE_IDA(mnt_pgid_ida);
+
 /* return the next shared peer mount of @p */
 static inline struct vfsmount *next_peer(struct vfsmount *p)
 {
@@ -27,47 +31,58 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }
 
-void set_mnt_shared(struct vfsmount *mnt)
+static void __set_mnt_shared(struct vfsmount *mnt)
 {
 	mnt->mnt_flags &= ~MNT_PNODE_MASK;
 	mnt->mnt_flags |= MNT_SHARED;
 }
 
-void clear_mnt_shared(struct vfsmount *mnt)
+void set_mnt_shared(struct vfsmount *mnt)
 {
-	mnt->mnt_flags &= ~MNT_SHARED;
+	int res;
+
+ retry:
+	spin_lock(&mnt_pgid_lock);
+	if (IS_MNT_SHARED(mnt)) {
+		spin_unlock(&mnt_pgid_lock);
+		return;
+	}
+
+	res = ida_get_new(&mnt_pgid_ida, &mnt->mnt_pgid);
+	spin_unlock(&mnt_pgid_lock);
+	if (res == -EAGAIN) {
+		if (ida_pre_get(&mnt_pgid_ida, GFP_KERNEL))
+			goto retry;
+	}
+	__set_mnt_shared(mnt);
 }
 
-static int __peer_group_id(struct vfsmount *mnt)
+void clear_mnt_shared(struct vfsmount *mnt)
 {
-	struct vfsmount *m;
-	int id = mnt->mnt_id;
-
-	for (m = next_peer(mnt); m != mnt; m = next_peer(m))
-		id = min(id, m->mnt_id);
+	if (IS_MNT_SHARED(mnt)) {
+		mnt->mnt_flags &= ~MNT_SHARED;
+		mnt->mnt_pgid = -1;
+	}
+}
 
-	return id;
+void make_mnt_peer(struct vfsmount *old, struct vfsmount *mnt)
+{
+	mnt->mnt_pgid = old->mnt_pgid;
+	list_add(&mnt->mnt_share, &old->mnt_share);
+	__set_mnt_shared(mnt);
 }
 
-/* return the smallest ID within the peer group */
 int get_peer_group_id(struct vfsmount *mnt)
 {
-	int id;
-
-	spin_lock(&vfsmount_lock);
-	id = __peer_group_id(mnt);
-	spin_unlock(&vfsmount_lock);
-
-	return id;
+	return mnt->mnt_pgid;
 }
 
-/* return the smallest ID within the master's peer group */
 int get_master_id(struct vfsmount *mnt)
 {
 	int id;
 
 	spin_lock(&vfsmount_lock);
-	id = __peer_group_id(mnt->mnt_master);
+	id = get_peer_group_id(mnt->mnt_master);
 	spin_unlock(&vfsmount_lock);
 
 	return id;
@@ -91,7 +106,13 @@ static int do_make_slave(struct vfsmount
 		if (peer_mnt == mnt)
 			peer_mnt = NULL;
 	}
-	list_del_init(&mnt->mnt_share);
+	if (!list_empty(&mnt->mnt_share))
+		list_del_init(&mnt->mnt_share);
+	else if (IS_MNT_SHARED(mnt)) {
+		spin_lock(&mnt_pgid_lock);
+		ida_remove(&mnt_pgid_ida, mnt->mnt_pgid);
+		spin_unlock(&mnt_pgid_lock);
+	}
 
 	if (peer_mnt)
 		master = peer_mnt;
Index: linux/include/linux/mount.h
===================================================================
--- linux.orig/include/linux/mount.h	2008-03-13 20:45:15.000000000 +0100
+++ linux/include/linux/mount.h	2008-03-13 20:45:50.000000000 +0100
@@ -57,6 +57,7 @@ struct vfsmount {
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	int mnt_id;			/* mount identifier */
+	int mnt_pgid;			/* peer group identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-13 20:45:49.000000000 +0100
+++ linux/fs/namespace.c	2008-03-13 20:45:50.000000000 +0100
@@ -95,6 +95,7 @@ struct vfsmount *alloc_vfsmnt(const char
 			return NULL;
 		}
 
+		mnt->mnt_pgid = -1;
 		atomic_set(&mnt->mnt_count, 1);
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
@@ -539,8 +540,10 @@ static struct vfsmount *clone_mnt(struct
 			mnt->mnt_master = old;
 			clear_mnt_shared(mnt);
 		} else if (!(flag & CL_PRIVATE)) {
-			if ((flag & CL_PROPAGATION) || IS_MNT_SHARED(old))
-				list_add(&mnt->mnt_share, &old->mnt_share);
+			if (flag & CL_PROPAGATION)
+				set_mnt_shared(old);
+			if (IS_MNT_SHARED(old))
+				make_mnt_peer(old, mnt);
 			if (IS_MNT_SLAVE(old))
 				list_add(&mnt->mnt_slave, &old->mnt_slave);
 			mnt->mnt_master = old->mnt_master;
Index: linux/Documentation/filesystems/proc.txt
===================================================================
--- linux.orig/Documentation/filesystems/proc.txt	2008-03-13 20:45:15.000000000 +0100
+++ linux/Documentation/filesystems/proc.txt	2008-03-13 20:45:50.000000000 +0100
@@ -2367,18 +2367,12 @@ MNTOPTS: per mount options
 SBOPTS: per super block options
 PROPAGATION: propagation type
 
-propagation type: <propagation_flag>[:<mntid>][,...]
-	note: 'shared' flag is followed by the mntid of its peer mount
-	      'slave' flag is followed by the mntid of its master mount
+propagation type: <propagation_flag>[:<peergrpid>][,...]
+	note: 'shared' flag is followed by the id of this mount's peer group
+	      'slave' flag is followed by the peer group id of its master mount
 	      'private' flag stands by itself
 	      'unbindable' flag stands by itself
 
-The 'mntid' used in the propagation type is a canonical ID of the peer
-group (currently the smallest ID within the group is used for this
-purpose, but this should not be relied on).  Since mounts can be added
-or removed from the peer group, this ID only guaranteed to stay the
-same on a static propagation tree.
-
 For more information see:
 
   Documentation/filesystems/sharedsubtree.txt
Index: linux/fs/pnode.h
===================================================================
--- linux.orig/fs/pnode.h	2008-03-13 20:45:49.000000000 +0100
+++ linux/fs/pnode.h	2008-03-13 20:45:50.000000000 +0100
@@ -25,6 +25,7 @@
 
 void set_mnt_shared(struct vfsmount *);
 void clear_mnt_shared(struct vfsmount *);
+void make_mnt_peer(struct vfsmount *, struct vfsmount *);
 void change_mnt_propagation(struct vfsmount *, int);
 int propagate_mnt(struct vfsmount *, struct dentry *, struct vfsmount *,
 		struct list_head *);

--
