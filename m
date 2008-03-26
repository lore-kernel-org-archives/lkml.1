Return-Path: <linux-kernel-owner+w=401wt.eu-S1760318AbYCZVYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760318AbYCZVYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 17:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759486AbYCZVWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 17:22:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51797 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759343AbYCZVWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 17:22:15 -0400
Message-Id: <20080326212139.187837394@szeredi.hu>
References: <20080326211131.705321084@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 26 Mar 2008 22:11:34 +0100
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
 fs/namespace.c        |   34 ++++++++++++++++++++++++++++++++++
 include/linux/mount.h |    1 +
 2 files changed, 35 insertions(+)

Index: vfs-2.6/fs/namespace.c
===================================================================
--- vfs-2.6.orig/fs/namespace.c	2008-03-26 21:37:06.000000000 +0100
+++ vfs-2.6/fs/namespace.c	2008-03-26 21:37:40.000000000 +0100
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
@@ -58,10 +60,41 @@ static inline unsigned long hash(struct 
 
 #define MNT_WRITER_UNDERFLOW_LIMIT -(1<<16)
 
+static int mnt_alloc_id(struct vfsmount *mnt)
+{
+	int res;
+
+ retry:
+	spin_lock(&vfsmount_lock);
+	res = ida_get_new(&mnt_id_ida, &mnt->mnt_id);
+	spin_unlock(&vfsmount_lock);
+	if (res == -EAGAIN) {
+		if (ida_pre_get(&mnt_id_ida, GFP_KERNEL))
+			goto retry;
+		res = -ENOMEM;
+	}
+	return res;
+}
+
+static void mnt_free_id(struct vfsmount *mnt)
+{
+	spin_lock(&vfsmount_lock);
+	ida_remove(&mnt_id_ida, mnt->mnt_id);
+	spin_unlock(&vfsmount_lock);
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
@@ -353,6 +386,7 @@ EXPORT_SYMBOL(simple_set_mnt);
 void free_vfsmnt(struct vfsmount *mnt)
 {
 	kfree(mnt->mnt_devname);
+	mnt_free_id(mnt);
 	kmem_cache_free(mnt_cache, mnt);
 }
 
Index: vfs-2.6/include/linux/mount.h
===================================================================
--- vfs-2.6.orig/include/linux/mount.h	2008-03-26 21:37:06.000000000 +0100
+++ vfs-2.6/include/linux/mount.h	2008-03-26 21:37:40.000000000 +0100
@@ -56,6 +56,7 @@ struct vfsmount {
 	struct list_head mnt_slave;	/* slave list entry */
 	struct vfsmount *mnt_master;	/* slave is on master->mnt_slave_list */
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
+	int mnt_id;			/* mount identifier */
 	/*
 	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
 	 * to let these frequently modified fields in a separate cache line

--
