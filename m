Return-Path: <linux-kernel-owner+w=401wt.eu-S933137AbYD2TBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137AbYD2TBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYD2S7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 14:59:51 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50406 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYD2S7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 14:59:49 -0400
Subject: [RFC][PATCH 2/5] introduce simple_set_mnt_no_get() helper for NFS
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       trond.myklebust@fys.uio.no, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 29 Apr 2008 11:59:45 -0700
References: <20080429185943.3BA6A050@kernel>
In-Reply-To: <20080429185943.3BA6A050@kernel>
Message-Id: <20080429185945.8D7AD196@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The next patch will introduce a list of all mounts for a given
superblock.  In order to keep the list, we need to make sure
all filesystems attaching a mount to a superblock get added
to this list.

NFS currently bypasses the simple_set_mnt() function, and sets
mnt_sb directly.  This patch makes it use a helper function,
instead.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c     |   11 +++++++++--
 linux-2.6.git-dave/fs/nfs/super.c     |   10 +++++-----
 linux-2.6.git-dave/include/linux/fs.h |    1 +
 3 files changed, 15 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~introduce_simple_set_mnt_no_get_helper_for_NFS fs/namespace.c
--- linux-2.6.git/fs/namespace.c~introduce_simple_set_mnt_no_get_helper_for_NFS	2008-04-29 11:56:39.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2008-04-29 11:56:39.000000000 -0700
@@ -402,12 +402,19 @@ static void __mnt_unmake_readonly(struct
 	spin_unlock(&vfsmount_lock);
 }
 
-int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
+int simple_set_mnt_no_get(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
-	mnt->mnt_root = dget(sb->s_root);
+	add_mount_to_sb_list(mnt, sb);
 	return 0;
 }
+EXPORT_SYMBOL(simple_set_mnt_no_get);
+
+int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
+{
+	mnt->mnt_root = dget(sb->s_root);
+	return simple_set_mnt_no_get(mnt, sb);
+}
 
 EXPORT_SYMBOL(simple_set_mnt);
 
diff -puN fs/nfs/super.c~introduce_simple_set_mnt_no_get_helper_for_NFS fs/nfs/super.c
--- linux-2.6.git/fs/nfs/super.c~introduce_simple_set_mnt_no_get_helper_for_NFS	2008-04-29 11:56:39.000000000 -0700
+++ linux-2.6.git-dave/fs/nfs/super.c	2008-04-29 11:56:39.000000000 -0700
@@ -1635,7 +1635,7 @@ static int nfs_get_sb(struct file_system
 		goto error_splat_root;
 
 	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
+	simple_set_mnt_no_get(mnt, s);
 	mnt->mnt_root = mntroot;
 	error = 0;
 
@@ -1727,7 +1727,7 @@ static int nfs_xdev_get_sb(struct file_s
 	}
 
 	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
+	simple_set_mnt_no_get(mnt, s);
 	mnt->mnt_root = mntroot;
 
 	/* clone any lsm security options from the parent to the new sb */
@@ -1998,7 +1998,7 @@ static int nfs4_get_sb(struct file_syste
 	}
 
 	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
+	simple_set_mnt_no_get(mnt, s);
 	mnt->mnt_root = mntroot;
 	error = 0;
 
@@ -2089,7 +2089,7 @@ static int nfs4_xdev_get_sb(struct file_
 	}
 
 	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
+	simple_set_mnt_no_get(mnt, s);
 	mnt->mnt_root = mntroot;
 
 	dprintk("<-- nfs4_xdev_get_sb() = 0\n");
@@ -2168,7 +2168,7 @@ static int nfs4_referral_get_sb(struct f
 	}
 
 	s->s_flags |= MS_ACTIVE;
-	mnt->mnt_sb = s;
+	simple_set_mnt_no_get(mnt, s);
 	mnt->mnt_root = mntroot;
 
 	dprintk("<-- nfs4_referral_get_sb() = 0\n");
diff -puN include/linux/fs.h~introduce_simple_set_mnt_no_get_helper_for_NFS include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~introduce_simple_set_mnt_no_get_helper_for_NFS	2008-04-29 11:56:39.000000000 -0700
+++ linux-2.6.git-dave/include/linux/fs.h	2008-04-29 11:56:39.000000000 -0700
@@ -1521,6 +1521,7 @@ extern int get_sb_pseudo(struct file_sys
 	const struct super_operations *ops, unsigned long,
 	struct vfsmount *mnt);
 extern int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
+extern int simple_set_mnt_no_get(struct vfsmount *mnt, struct super_block *sb);
 int __put_super(struct super_block *sb);
 int __put_super_and_need_restart(struct super_block *sb);
 void unnamed_dev_init(void);
_
