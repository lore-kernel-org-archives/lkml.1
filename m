Return-Path: <linux-kernel-owner+w=401wt.eu-S1762537AbYD2TCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762537AbYD2TCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760803AbYD2TAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:00:10 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59306 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755418AbYD2S7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:59:50 -0400
Subject: [RFC][PATCH 3/5] reintroduce list of vfsmounts over superblock
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       trond.myklebust@fys.uio.no, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2008 11:59:47 -0700
References: <20080429185943.3BA6A050@kernel>
In-Reply-To: <20080429185943.3BA6A050@kernel>
Message-Id: <20080429185947.BB8609C2@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're moving a big chunk of the burden of keeping people from
writing to r/o filesystems from the superblock into the
vfsmount.  This requires that we consult the superblock's
vfsmounts when things like remounts occur.

So, introduce a list of vfsmounts hanging off the superblock.
We'll use this in a bit.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c        |   12 ++++++++++++
 linux-2.6.git-dave/fs/super.c            |    1 +
 linux-2.6.git-dave/include/linux/fs.h    |    1 +
 linux-2.6.git-dave/include/linux/mount.h |    1 +
 4 files changed, 15 insertions(+)

diff -puN fs/namespace.c~reintroduce_list_of_vfsmounts_over_superblock fs/namespace.c
--- linux-2.6.git/fs/namespace.c~reintroduce_list_of_vfsmounts_over_superblock	2008-04-29 11:56:40.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2008-04-29 11:56:40.000000000 -0700
@@ -402,6 +402,13 @@ static void __mnt_unmake_readonly(struct
 	spin_unlock(&vfsmount_lock);
 }
 
+void add_mount_to_sb_list(struct vfsmount *mnt, struct super_block *sb)
+{
+	spin_lock(&vfsmount_lock);
+	list_add(&mnt->mnt_sb_list, &sb->s_vfsmounts);
+	spin_unlock(&vfsmount_lock);
+}
+
 int simple_set_mnt_no_get(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -420,6 +427,10 @@ EXPORT_SYMBOL(simple_set_mnt);
 
 void free_vfsmnt(struct vfsmount *mnt)
 {
+	spin_lock(&vfsmount_lock);
+	if (mnt->mnt_sb)
+		list_del(&mnt->mnt_sb_list);
+	spin_unlock(&vfsmount_lock);
 	kfree(mnt->mnt_devname);
 	mnt_free_id(mnt);
 	kmem_cache_free(mnt_cache, mnt);
@@ -585,6 +596,7 @@ static struct vfsmount *clone_mnt(struct
 		mnt->mnt_root = dget(root);
 		mnt->mnt_mountpoint = mnt->mnt_root;
 		mnt->mnt_parent = mnt;
+		add_mount_to_sb_list(mnt, sb);
 
 		if (flag & CL_SLAVE) {
 			list_add(&mnt->mnt_slave, &old->mnt_slave_list);
diff -puN fs/super.c~reintroduce_list_of_vfsmounts_over_superblock fs/super.c
--- linux-2.6.git/fs/super.c~reintroduce_list_of_vfsmounts_over_superblock	2008-04-29 11:56:40.000000000 -0700
+++ linux-2.6.git-dave/fs/super.c	2008-04-29 11:56:40.000000000 -0700
@@ -67,6 +67,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LIST_HEAD(&s->s_more_io);
 		INIT_LIST_HEAD(&s->s_files);
+		INIT_LIST_HEAD(&s->s_vfsmounts);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
diff -puN include/linux/fs.h~reintroduce_list_of_vfsmounts_over_superblock include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~reintroduce_list_of_vfsmounts_over_superblock	2008-04-29 11:56:40.000000000 -0700
+++ linux-2.6.git-dave/include/linux/fs.h	2008-04-29 11:56:40.000000000 -0700
@@ -1058,6 +1058,7 @@ struct super_block {
 	struct list_head	s_io;		/* parked for writeback */
 	struct list_head	s_more_io;	/* parked for more writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
+	struct list_head	s_vfsmounts;
 	struct list_head	s_files;
 
 	struct block_device	*s_bdev;
diff -puN include/linux/mount.h~reintroduce_list_of_vfsmounts_over_superblock include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~reintroduce_list_of_vfsmounts_over_superblock	2008-04-29 11:56:40.000000000 -0700
+++ linux-2.6.git-dave/include/linux/mount.h	2008-04-29 11:56:40.000000000 -0700
@@ -44,6 +44,7 @@ struct vfsmount {
 	struct dentry *mnt_mountpoint;	/* dentry of mountpoint */
 	struct dentry *mnt_root;	/* root of the mounted tree */
 	struct super_block *mnt_sb;	/* pointer to superblock */
+	struct list_head mnt_sb_list;	/* list of all mounts on same sb */
 	struct list_head mnt_mounts;	/* list of children, anchored here */
 	struct list_head mnt_child;	/* and going through their mnt_child */
 	int mnt_flags;
_
