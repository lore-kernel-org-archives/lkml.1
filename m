Return-Path: <linux-kernel-owner+w=401wt.eu-S1946306AbXBPXjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946306AbXBPXjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 18:39:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946310AbXBPXjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 18:39:37 -0500
Received: from cantor.suse.de ([195.135.220.2]:39553 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946306AbXBPXjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 18:39:12 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/10] debugfs: implement symbolic links
Date: Fri, 16 Feb 2007 15:37:32 -0800
Message-Id: <1171669073246-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0
In-Reply-To: <11716690692008-git-send-email-gregkh@suse.de>
References: <20070216233553.GC14708@kroah.com> <11716690562249-git-send-email-gregkh@suse.de> <11716690591400-git-send-email-gregkh@suse.de> <11716690633694-git-send-email-gregkh@suse.de> <11716690662679-git-send-email-gregkh@suse.de> <11716690692008-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

debugfs: implement symbolic links

Implement a new function debugfs_create_symlink() which can be used
to create symbolic links in debugfs. This function can be useful
for people moving functionality from /proc to debugfs (e.g. the
gcov-kernel patch).

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/file.c       |   12 +++++++
 fs/debugfs/inode.c      |   76 ++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/debugfs.h |   10 ++++++
 3 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 8d130cc..682f928 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/pagemap.h>
+#include <linux/namei.h>
 #include <linux/debugfs.h>
 
 static ssize_t default_read_file(struct file *file, char __user *buf,
@@ -44,6 +45,17 @@ const struct file_operations debugfs_file_operations = {
 	.open =		default_open,
 };
 
+static void *debugfs_follow_link(struct dentry *dentry, struct nameidata *nd)
+{
+	nd_set_link(nd, dentry->d_inode->i_private);
+	return NULL;
+}
+
+const struct inode_operations debugfs_link_operations = {
+	.readlink       = generic_readlink,
+	.follow_link    = debugfs_follow_link,
+};
+
 static void debugfs_u8_set(void *data, u64 val)
 {
 	*(u8 *)data = val;
diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index c692487..9c51a9f 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -25,11 +25,13 @@
 #include <linux/namei.h>
 #include <linux/debugfs.h>
 #include <linux/fsnotify.h>
+#include <linux/string.h>
 
 #define DEBUGFS_MAGIC	0x64626720
 
 /* declared over in file.c */
 extern struct file_operations debugfs_file_operations;
+extern struct inode_operations debugfs_link_operations;
 
 static struct vfsmount *debugfs_mount;
 static int debugfs_mount_count;
@@ -51,6 +53,9 @@ static struct inode *debugfs_get_inode(struct super_block *sb, int mode, dev_t d
 		case S_IFREG:
 			inode->i_fop = &debugfs_file_operations;
 			break;
+		case S_IFLNK:
+			inode->i_op = &debugfs_link_operations;
+			break;
 		case S_IFDIR:
 			inode->i_op = &simple_dir_inode_operations;
 			inode->i_fop = &simple_dir_operations;
@@ -96,6 +101,12 @@ static int debugfs_mkdir(struct inode *dir, struct dentry *dentry, int mode)
 	return res;
 }
 
+static int debugfs_link(struct inode *dir, struct dentry *dentry, int mode)
+{
+	mode = (mode & S_IALLUGO) | S_IFLNK;
+	return debugfs_mknod(dir, dentry, mode, 0);
+}
+
 static int debugfs_create(struct inode *dir, struct dentry *dentry, int mode)
 {
 	int res;
@@ -158,10 +169,17 @@ static int debugfs_create_by_name(const char *name, mode_t mode,
 	mutex_lock(&parent->d_inode->i_mutex);
 	*dentry = lookup_one_len(name, parent, strlen(name));
 	if (!IS_ERR(*dentry)) {
-		if ((mode & S_IFMT) == S_IFDIR)
+		switch (mode & S_IFMT) {
+		case S_IFDIR:
 			error = debugfs_mkdir(parent->d_inode, *dentry, mode);
-		else 
+			break;
+		case S_IFLNK:
+			error = debugfs_link(parent->d_inode, *dentry, mode);
+			break;
+		default:
 			error = debugfs_create(parent->d_inode, *dentry, mode);
+			break;
+		}
 		dput(*dentry);
 	} else
 		error = PTR_ERR(*dentry);
@@ -259,6 +277,49 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 EXPORT_SYMBOL_GPL(debugfs_create_dir);
 
 /**
+ * debugfs_create_symlink- create a symbolic link in the debugfs filesystem
+ * @name: a pointer to a string containing the name of the symbolic link to
+ *        create.
+ * @parent: a pointer to the parent dentry for this symbolic link.  This
+ *          should be a directory dentry if set.  If this paramater is NULL,
+ *          then the symbolic link will be created in the root of the debugfs
+ *          filesystem.
+ * @target: a pointer to a string containing the path to the target of the
+ *          symbolic link.
+ *
+ * This function creates a symbolic link with the given name in debugfs that
+ * links to the given target path.
+ *
+ * This function will return a pointer to a dentry if it succeeds.  This
+ * pointer must be passed to the debugfs_remove() function when the symbolic
+ * link is to be removed (no automatic cleanup happens if your module is
+ * unloaded, you are responsible here.)  If an error occurs, %NULL will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.  It is not wise to check for this value, but rather, check for
+ * %NULL or !%NULL instead as to eliminate the need for #ifdef in the calling
+ * code.
+ */
+struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
+				      const char *target)
+{
+	struct dentry *result;
+	char *link;
+
+	link = kstrdup(target, GFP_KERNEL);
+	if (!link)
+		return NULL;
+
+	result = debugfs_create_file(name, S_IFLNK | S_IRWXUGO, parent, link,
+				     NULL);
+	if (!result)
+		kfree(link);
+	return result;
+}
+EXPORT_SYMBOL_GPL(debugfs_create_symlink);
+
+/**
  * debugfs_remove - removes a file or directory from the debugfs filesystem
  * @dentry: a pointer to a the dentry of the file or directory to be
  *          removed.
@@ -287,15 +348,22 @@ void debugfs_remove(struct dentry *dentry)
 	if (debugfs_positive(dentry)) {
 		if (dentry->d_inode) {
 			dget(dentry);
-			if (S_ISDIR(dentry->d_inode->i_mode)) {
+			switch (dentry->d_inode->i_mode & S_IFMT) {
+			case S_IFDIR:
 				ret = simple_rmdir(parent->d_inode, dentry);
 				if (ret)
 					printk(KERN_ERR
 						"DebugFS rmdir on %s failed : "
 						"directory not empty.\n",
 						dentry->d_name.name);
-			} else
+				break;
+			case S_IFLNK:
+				kfree(dentry->d_inode->i_private);
+				/* fall through */
+			default:
 				simple_unlink(parent->d_inode, dentry);
+				break;
+			}
 			if (!ret)
 				d_delete(dentry);
 			dput(dentry);
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 047567d..9fa0983 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -33,6 +33,9 @@ struct dentry *debugfs_create_file(const char *name, mode_t mode,
 
 struct dentry *debugfs_create_dir(const char *name, struct dentry *parent);
 
+struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
+				      const char *dest);
+
 void debugfs_remove(struct dentry *dentry);
 
 struct dentry *debugfs_create_u8(const char *name, mode_t mode,
@@ -70,6 +73,13 @@ static inline struct dentry *debugfs_create_dir(const char *name,
 	return ERR_PTR(-ENODEV);
 }
 
+static inline struct dentry *debugfs_create_symlink(const char *name,
+						    struct dentry *parent,
+						    const char *dest)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline void debugfs_remove(struct dentry *dentry)
 { }
 
-- 
1.5.0

