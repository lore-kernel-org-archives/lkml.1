Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbYCMV2I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbYCMV2I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:28:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753486AbYCMV1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:27:49 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51619 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYCMV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:27:48 -0400
Message-Id: <20080313212733.921047238@szeredi.hu>
References: <20080313212641.989467982@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 13 Mar 2008 22:26:43 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/6] vfs: pnode cleanup
Content-Disposition: inline; filename=pnode_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Clean up mnt->mnt_slave_list being initialized too many times.

Move set_mnt_shared from pnode.h to pnode.c.  Change
CLEAR_MNT_SHARED() to clear_mnt_shared() function, and move to
pnode.c.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c |    2 +-
 fs/pnode.c     |   23 ++++++++++++++++-------
 fs/pnode.h     |    9 ++-------
 3 files changed, 19 insertions(+), 15 deletions(-)

Index: linux/fs/pnode.c
===================================================================
--- linux.orig/fs/pnode.c	2008-03-13 20:45:15.000000000 +0100
+++ linux/fs/pnode.c	2008-03-13 20:45:49.000000000 +0100
@@ -27,6 +27,17 @@ static inline struct vfsmount *next_slav
 	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
 }
 
+void set_mnt_shared(struct vfsmount *mnt)
+{
+	mnt->mnt_flags &= ~MNT_PNODE_MASK;
+	mnt->mnt_flags |= MNT_SHARED;
+}
+
+void clear_mnt_shared(struct vfsmount *mnt)
+{
+	mnt->mnt_flags &= ~MNT_SHARED;
+}
+
 static int __peer_group_id(struct vfsmount *mnt)
 {
 	struct vfsmount *m;
@@ -89,20 +100,18 @@ static int do_make_slave(struct vfsmount
 		list_for_each_entry(slave_mnt, &mnt->mnt_slave_list, mnt_slave)
 			slave_mnt->mnt_master = master;
 		list_move(&mnt->mnt_slave, &master->mnt_slave_list);
-		list_splice(&mnt->mnt_slave_list, master->mnt_slave_list.prev);
-		INIT_LIST_HEAD(&mnt->mnt_slave_list);
+		list_splice_init(&mnt->mnt_slave_list,
+				 master->mnt_slave_list.prev);
 	} else {
-		struct list_head *p = &mnt->mnt_slave_list;
-		while (!list_empty(p)) {
-                        slave_mnt = list_first_entry(p,
+		while (!list_empty(&mnt->mnt_slave_list)) {
+			slave_mnt = list_first_entry(&mnt->mnt_slave_list,
 					struct vfsmount, mnt_slave);
 			list_del_init(&slave_mnt->mnt_slave);
 			slave_mnt->mnt_master = NULL;
 		}
 	}
 	mnt->mnt_master = master;
-	CLEAR_MNT_SHARED(mnt);
-	INIT_LIST_HEAD(&mnt->mnt_slave_list);
+	clear_mnt_shared(mnt);
 	return 0;
 }
 
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-13 20:45:49.000000000 +0100
+++ linux/fs/namespace.c	2008-03-13 20:45:49.000000000 +0100
@@ -537,7 +537,7 @@ static struct vfsmount *clone_mnt(struct
 		if (flag & CL_SLAVE) {
 			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
 			mnt->mnt_master = old;
-			CLEAR_MNT_SHARED(mnt);
+			clear_mnt_shared(mnt);
 		} else if (!(flag & CL_PRIVATE)) {
 			if ((flag & CL_PROPAGATION) || IS_MNT_SHARED(old))
 				list_add(&mnt->mnt_share, &old->mnt_share);
Index: linux/fs/pnode.h
===================================================================
--- linux.orig/fs/pnode.h	2008-03-13 20:45:15.000000000 +0100
+++ linux/fs/pnode.h	2008-03-13 20:45:49.000000000 +0100
@@ -14,7 +14,6 @@
 #define IS_MNT_SHARED(mnt) (mnt->mnt_flags & MNT_SHARED)
 #define IS_MNT_SLAVE(mnt) (mnt->mnt_master)
 #define IS_MNT_NEW(mnt)  (!mnt->mnt_ns)
-#define CLEAR_MNT_SHARED(mnt) (mnt->mnt_flags &= ~MNT_SHARED)
 #define IS_MNT_UNBINDABLE(mnt) (mnt->mnt_flags & MNT_UNBINDABLE)
 
 #define CL_EXPIRE    		0x01
@@ -24,12 +23,8 @@
 #define CL_PROPAGATION 		0x10
 #define CL_PRIVATE 		0x20
 
-static inline void set_mnt_shared(struct vfsmount *mnt)
-{
-	mnt->mnt_flags &= ~MNT_PNODE_MASK;
-	mnt->mnt_flags |= MNT_SHARED;
-}
-
+void set_mnt_shared(struct vfsmount *);
+void clear_mnt_shared(struct vfsmount *);
 void change_mnt_propagation(struct vfsmount *, int);
 int propagate_mnt(struct vfsmount *, struct dentry *, struct vfsmount *,
 		struct list_head *);

--
