Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbYC0MYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbYC0MYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbYC0MYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:24:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33808 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739AbYC0MYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:24:08 -0400
Message-Id: <20080327122355.594127612@szeredi.hu>
References: <20080327120619.031944658@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 27 Mar 2008 13:06:22 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/7] vfs: mountinfo: add mount ID
Content-Disposition: inline; filename=mountinfo_mnt_id.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a unique ID to each vfsmount using the IDR infrastructure.  The
identifiers are reused after the vfsmount is freed.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |   20 ++++++++++++++++++++
 include/linux/mount.h |    1 +
 2 files changed, 21 insertions(+)

Index: vfs-2.6/fs/namespace.c
===================================================================
--- vfs-2.6.orig/fs/namespace.c	2008-03-27 12:05:55.000000000 +0100
+++ vfs-2.6/fs/namespace.c	2008-03-27 12:06:08.000000000 +0100
@@ -27,6 +27,7 @@
 #include <linux/mount.h>
 #include <linux/ramfs.h>
 #include <linux/log2.h>
+#include <linux/idr.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -39,6 +40,7 @@
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(vfsmount_lock);
 
 static int event;
+static DEFINE_IDA(mnt_id_ida);
 
 static struct list_head *mount_hashtable __read_mostly;
 static struct kmem_cache *mnt_cache __read_mostly;
@@ -58,10 +60,26 @@ static inline unsigned long hash(struct 
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
+static int mnt_alloc_id(struct vfsmount *mnt)
+{
+	if (!ida_pre_get(&mnt_id_ida, GFP_KERNEL))
+		return -ENOMEM;
+
+	return ida_get_new_above(&mnt_id_ida, 1, &mnt->mnt_id);
+}
+
 struct vfsmount *alloc_vfsmnt(const char *name)
 {
 	struct vfsmount *mnt = kmem_cache_zalloc(mnt_cache, GFP_KERNEL);
 	if (mnt) {
+		int err;
+
+		err = mnt_alloc_id(mnt);
+		if (err) {
+			kmem_cache_free(mnt_cache, mnt);
+			return NULL;
+		}
+
 		atomic_set(&mnt->mnt_count, 1);
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
@@ -866,6 +884,8 @@ void umount_tree(struct vfsmount *mnt, i
 			p->mnt_mountpoint->d_mounted--;
 		}
 		change_mnt_propagation(p, MS_PRIVATE);
+		ida_remove(&mnt_id_ida, p->mnt_id);
+		p->mnt_id = 0;
 	}
 }
 
Index: vfs-2.6/include/linux/mount.h
===================================================================
--- vfs-2.6.orig/include/linux/mount.h	2008-03-27 12:05:55.000000000 +0100
+++ vfs-2.6/include/linux/mount.h	2008-03-27 12:06:08.000000000 +0100
@@ -56,6 +56,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	int mnt_id;			/* mount identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line

--
