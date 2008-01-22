Return-Path: <linux-kernel-owner+w=401wt.eu-S1763206AbYAVDU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763206AbYAVDU0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbYAVDHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:07:46 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33243 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756642AbYAVDHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:07:42 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Jean Noel Cordenner <jean-noel.cordenner@bull.net>,
       Mingming Cao <cmm@us.ibm.com>, Kalpak Shah <kalpak@clusterfs.com>
Subject: [PATCH 34/49] vfs: Add 64 bit i_version support
Date: Mon, 21 Jan 2008 22:02:13 -0500
Message-Id: <1200970948-17903-35-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-34-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
 <1200970948-17903-18-git-send-email-tytso@mit.edu>
 <1200970948-17903-19-git-send-email-tytso@mit.edu>
 <1200970948-17903-20-git-send-email-tytso@mit.edu>
 <1200970948-17903-21-git-send-email-tytso@mit.edu>
 <1200970948-17903-22-git-send-email-tytso@mit.edu>
 <1200970948-17903-23-git-send-email-tytso@mit.edu>
 <1200970948-17903-24-git-send-email-tytso@mit.edu>
 <1200970948-17903-25-git-send-email-tytso@mit.edu>
 <1200970948-17903-26-git-send-email-tytso@mit.edu>
 <1200970948-17903-27-git-send-email-tytso@mit.edu>
 <1200970948-17903-28-git-send-email-tytso@mit.edu>
 <1200970948-17903-29-git-send-email-tytso@mit.edu>
 <1200970948-17903-30-git-send-email-tytso@mit.edu>
 <1200970948-17903-31-git-send-email-tytso@mit.edu>
 <1200970948-17903-32-git-send-email-tytso@mit.edu>
 <1200970948-17903-33-git-send-email-tytso@mit.edu>
 <1200970948-17903-34-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Noel Cordenner <jean-noel.cordenner@bull.net>

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
 fs/afs/dir.c       |    9 +++++----
 fs/afs/inode.c     |    3 ++-
 fs/inode.c         |   22 ++++++++++++++++++++++
 include/linux/fs.h |    5 ++++-
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 33fe39a..0cc3597 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -546,11 +546,11 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 	dentry->d_op = &afs_fs_dentry_operations;
 
 	d_add(dentry, inode);
-	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%lu }",
+	_leave(" = 0 { vn=%u u=%u } -> { ino=%lu v=%llu }",
 	       fid.vnode,
 	       fid.unique,
 	       dentry->d_inode->i_ino,
-	       dentry->d_inode->i_version);
+	       (unsigned long long)dentry->d_inode->i_version);
 
 	return NULL;
 }
@@ -630,9 +630,10 @@ static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 		 * been deleted and replaced, and the original vnode ID has
 		 * been reused */
 		if (fid.unique != vnode->fid.unique) {
-			_debug("%s: file deleted (uq %u -> %u I:%lu)",
+			_debug("%s: file deleted (uq %u -> %u I:%llu)",
 			       dentry->d_name.name, fid.unique,
-			       vnode->fid.unique, dentry->d_inode->i_version);
+			       vnode->fid.unique,
+			       (unsigned long long)dentry->d_inode->i_version);
 			spin_lock(&vnode->lock);
 			set_bit(AFS_VNODE_DELETED, &vnode->flags);
 			spin_unlock(&vnode->lock);
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index d196840..84750c8 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -301,7 +301,8 @@ int afs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 
 	inode = dentry->d_inode;
 
-	_enter("{ ino=%lu v=%lu }", inode->i_ino, inode->i_version);
+	_enter("{ ino=%lu v=%llu }", inode->i_ino,
+		(unsigned long long)inode->i_version);
 
 	generic_fillattr(inode, stat);
 	return 0;
diff --git a/fs/inode.c b/fs/inode.c
index ed35383..b48324a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1243,6 +1243,23 @@ void touch_atime(struct vfsmount *mnt, struct dentry *dentry)
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
@@ -1276,6 +1293,11 @@ void file_update_time(struct file *file)
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
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b3ec4a4..94cf5d8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -124,6 +124,7 @@ extern int dir_notify_enable;
 #define MS_SHARED	(1<<20)	/* change to shared */
 #define MS_RELATIME	(1<<21)	/* Update atime relative to mtime/ctime. */
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
+#define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
@@ -173,6 +174,7 @@ extern int dir_notify_enable;
 					((inode)->i_flags & (S_SYNC|S_DIRSYNC)))
 #define IS_MANDLOCK(inode)	__IS_FLG(inode, MS_MANDLOCK)
 #define IS_NOATIME(inode)   __IS_FLG(inode, MS_RDONLY|MS_NOATIME)
+#define IS_I_VERSION(inode)   __IS_FLG(inode, MS_I_VERSION)
 
 #define IS_NOQUOTA(inode)	((inode)->i_flags & S_NOQUOTA)
 #define IS_APPEND(inode)	((inode)->i_flags & S_APPEND)
@@ -599,7 +601,7 @@ struct inode {
 	uid_t			i_uid;
 	gid_t			i_gid;
 	dev_t			i_rdev;
-	unsigned long		i_version;
+	u64			i_version;
 	loff_t			i_size;
 #ifdef __NEED_I_SIZE_ORDERED
 	seqcount_t		i_size_seqcount;
@@ -1394,6 +1396,7 @@ static inline void inode_dec_link_count(struct inode *inode)
 	mark_inode_dirty(inode);
 }
 
+extern void inode_inc_iversion(struct inode *inode);
 extern void touch_atime(struct vfsmount *mnt, struct dentry *dentry);
 static inline void file_accessed(struct file *file)
 {
-- 
1.5.4.rc3.31.g1271-dirty

