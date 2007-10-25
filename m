Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbXJYRJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbXJYRJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbXJYRJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:09:14 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:50203 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbXJYRJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:09:12 -0400
Subject: Re: [PATCH 1/2]  i_version update - vfs part
From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Reply-To: jean-noel.cordenner@bull.net
To: linux-ext4@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1191598088.24615.45.camel@frecb002711.frec.bull.fr>
References: <1191598088.24615.45.camel@frecb002711.frec.bull.fr>
Organization: BULL S.A.
Date: Thu, 25 Oct 2007 19:04:30 +0200
Message-Id: <1193331870.5487.31.camel@frecb002711.frec.bull.fr>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/10/2007 19:15:49,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 25/10/2007 19:15:50,
	Serialize complete at 25/10/2007 19:15:50
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an update of the previous patches on the ext4 git tree, the 2
coming patches applies at the end of the current ext4-patch-queue, and
replaces the inode-version related patches:
64-bit-i_version.patch
i_version_hi.patch
ext4_i_version_hi_2.patch
i_version_update_ext4.patch

The first part deals with the vfs part. 
The i_version field of the inode is changed to be a 64-bit counter that
is set on every inode creation and that is incremented every time the
inode data is modified (similarly to the "ctime" time-stamp). 
The aim is to fulfill a NFSv4 requirement for rfc3530.
This first part concerns the vfs, it converts the 32-bit i_version in
the generic inode to a 64-bit, a flag is added in the super block in
order to check if the feature is enabled and the i_version is
incremented in the vfs.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Jean Noel Cordenner <jean-noel.cordenner@bull.net>
Signed-off-by: Kalpak Shah <kalpak@clusterfs.com>
---
 fs/inode.c         |   22 ++++++++++++++++++++++
 include/linux/fs.h |    5 ++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

Index: linux-2.6.23-ext4-1/include/linux/fs.h
===================================================================
--- linux-2.6.23-ext4-1.orig/include/linux/fs.h	2007-10-25
16:25:23.000000000 +0200
+++ linux-2.6.23-ext4-1/include/linux/fs.h	2007-10-25 16:25:53.000000000
+0200
@@ -123,6 +123,7 @@
 #define MS_SLAVE	(1<<19)	/* change to slave */
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
+#define MS_I_VERSION	(1<<22)	/* Update inode I_version field */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -172,6 +173,7 @@
 					((inode)->i_flags & (S_SYNC|S_DIRSYNC)))
 #define IS_MANDLOCK(inode)	__IS_FLG(inode, MS_MANDLOCK)
 #define IS_NOATIME(inode)   __IS_FLG(inode, MS_RDONLY|MS_NOATIME)
+#define IS_I_VERSION(inode)   __IS_FLG(inode, MS_I_VERSION)
 
 #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
@@ -541,7 +543,7 @@
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
-	unsigned long		i_version;
+	u64			i_version;
 	loff_t			i_size;
 #ifdef __NEED_I_SIZE_ORDERED
 	seqcount_t		i_size_seqcount;
@@ -1284,6 +1286,7 @@
 	mark_inode_dirty(inode);
 }
 
+extern void inode_inc_iversion(struct inode *inode);
 extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
 static inline void file_accessed(struct file *file)
 {
Index: linux-2.6.23-ext4-1/fs/inode.c
===================================================================
--- linux-2.6.23-ext4-1.orig/fs/inode.c	2007-10-25 16:15:52.000000000
+0200
+++ linux-2.6.23-ext4-1/fs/inode.c	2007-10-25 16:25:53.000000000 +0200
@@ -1216,6 +1216,24 @@
 EXPORT_SYMBOL(touch_atime);
 
 /**
+ *     inode_inc_iversion      -       increments i_version
+ *     @inode: inode that need to be updated
+ *
+ *     Every time the inode is modified, the i_version field
+ *     will be incremented.
+ *     The filesystem has to be mounted with i_version flag
+ *
+ */
+
+void inode_inc_iversion(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	inode->i_version++;
+	spin_unlock(&inode->i_lock);
+}
+
+/**
  *	file_update_time	-	update mtime and ctime time
  *	@file: file accessed
  *
@@ -1249,6 +1267,11 @@
 		sync_it = 1;
 	}
 
+	if (IS_I_VERSION(inode)) {
+		inode_inc_iversion(inode);
+		sync_it = 1;
+	}
+
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
 }


