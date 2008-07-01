Return-Path: <linux-kernel-owner+w=401wt.eu-S1757808AbYGANPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808AbYGANPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYGANPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:15:07 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:48082 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664AbYGANPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:15:04 -0400
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Greg KH <greg@kroah.com>
Subject: [PATCH v2 1/4] debugfs: Implement debugfs_remove_recursive()
Date: Tue,  1 Jul 2008 15:14:51 +0200
Message-Id: <1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 01 Jul 2008 13:14:57.0454 (UTC) FILETIME=[758B24E0:01C8DB7C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_remove_recursive() will remove a dentry and all its children.
Drivers can use this to zap their whole debugfs tree so that they don't
need to keep track of every single debugfs dentry they created.

It may fail to remove the whole tree in certain cases:

sh-3.2# rmmod atmel-mci < /sys/kernel/debug/mmc0/ios/clock
mmc0: card b368 removed
atmel_mci atmel_mci.0: Lost dma0chan1, falling back to PIO
sh-3.2# ls /sys/kernel/debug/mmc0/
ios

But I'm not sure if that case can be handled in any sane manner.

Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Greg KH <greg@kroah.com>
---
Resending this because the rest of the series depends on it.

 fs/debugfs/inode.c      |  114 +++++++++++++++++++++++++++++++++++++++-------
 include/linux/debugfs.h |    4 ++
 2 files changed, 100 insertions(+), 18 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index e9602d8..08e28c9 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -309,6 +309,31 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 
+static void __debugfs_remove(struct dentry *dentry, struct dentry *parent)
+{
+	int ret = 0;
+
+	if (debugfs_positive(dentry)) {
+		if (dentry->d_inode) {
+			dget(dentry);
+			switch (dentry->d_inode->i_mode & S_IFMT) {
+			case S_IFDIR:
+				ret = simple_rmdir(parent->d_inode, dentry);
+				break;
+			case S_IFLNK:
+				kfree(dentry->d_inode->i_private);
+				/* fall through */
+			default:
+				simple_unlink(parent->d_inode, dentry);
+				break;
+			}
+			if (!ret)
+				d_delete(dentry);
+			dput(dentry);
+		}
+	}
+}
+
 /**
  * debugfs_remove - removes a file or directory from the debugfs filesystem
  * @dentry: a pointer to a the dentry of the file or directory to be
@@ -325,7 +350,6 @@ EXPORT_SYMBOL_GPL(debugfs_create_symlink);
 void debugfs_remove(struct dentry *dentry)
 {
 	struct dentry *parent;
-	int ret = 0;
 	
 	if (!dentry)
 		return;
@@ -335,29 +359,83 @@ void debugfs_remove(struct dentry *dentry)
 		return;
 
 	mutex_lock(&parent->d_inode->i_mutex);
-	if (debugfs_positive(dentry)) {
-		if (dentry->d_inode) {
-			dget(dentry);
-			switch (dentry->d_inode->i_mode & S_IFMT) {
-			case S_IFDIR:
-				ret = simple_rmdir(parent->d_inode, dentry);
-				break;
-			case S_IFLNK:
-				kfree(dentry->d_inode->i_private);
-				/* fall through */
-			default:
-				simple_unlink(parent->d_inode, dentry);
+	__debugfs_remove(dentry, parent);
+	mutex_unlock(&parent->d_inode->i_mutex);
+	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+}
+EXPORT_SYMBOL_GPL(debugfs_remove);
+
+/**
+ * debugfs_remove_recursive - recursively removes a directory
+ * @dentry: a pointer to a the dentry of the directory to be removed.
+ *
+ * This function recursively removes a directory tree in debugfs that
+ * was previously created with a call to another debugfs function
+ * (like debugfs_create_file() or variants thereof.)
+ *
+ * This function is required to be called in order for the file to be
+ * removed, no automatic cleanup of files will happen when a module is
+ * removed, you are responsible here.
+ */
+void debugfs_remove_recursive(struct dentry *dentry)
+{
+	struct dentry *child;
+	struct dentry *parent;
+
+	if (!dentry)
+		return;
+
+	parent = dentry->d_parent;
+	if (!parent || !parent->d_inode)
+		return;
+
+	parent = dentry;
+	mutex_lock(&parent->d_inode->i_mutex);
+
+	while (1) {
+		/*
+		 * When all dentries under "parent" has been removed,
+		 * walk up the tree until we reach our starting point.
+		 */
+		if (list_empty(&parent->d_subdirs)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			if (parent == dentry)
 				break;
-			}
-			if (!ret)
-				d_delete(dentry);
-			dput(dentry);
+			parent = parent->d_parent;
+			mutex_lock(&parent->d_inode->i_mutex);
+		}
+		child = list_entry(parent->d_subdirs.next, struct dentry,
+				d_u.d_child);
+
+		/*
+		 * If "child" isn't empty, walk down the tree and
+		 * remove all its descendants first.
+		 */
+		if (!list_empty(&child->d_subdirs)) {
+			mutex_unlock(&parent->d_inode->i_mutex);
+			parent = child;
+			mutex_lock(&parent->d_inode->i_mutex);
+			continue;
 		}
+		__debugfs_remove(child, parent);
+		if (parent->d_subdirs.next == &child->d_u.d_child) {
+			/*
+			 * Avoid infinite loop if we fail to remove
+			 * one dentry.
+			 */
+			mutex_unlock(&parent->d_inode->i_mutex);
+			break;
+		}
+		simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	}
+
+	parent = dentry->d_parent;
+	mutex_lock(&parent->d_inode->i_mutex);
+	__debugfs_remove(dentry, parent);
 	mutex_unlock(&parent->d_inode->i_mutex);
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 }
-EXPORT_SYMBOL_GPL(debugfs_remove);
+EXPORT_SYMBOL_GPL(debugfs_remove_recursive);
 
 /**
  * debugfs_rename - rename a file/directory in the debugfs filesystem
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 7266124..b67b375 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -42,6 +42,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 				      const char *dest);
 
 void debugfs_remove(struct dentry *dentry);
+void debugfs_remove_recursive(struct dentry *dentry);
 
 struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, const char *new_name);
@@ -99,6 +100,9 @@ static inline struct dentry *debugfs_create_symlink(const char *name,
 static inline void debugfs_remove(struct dentry *dentry)
 { }
 
+static inline void debugfs_remove_recursive(struct dentry *dentry)
+{ }
+
 static inline struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
                 struct dentry *new_dir, char *new_name)
 {
-- 
1.5.6

