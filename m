Return-Path: <linux-kernel-owner+w=401wt.eu-S934883AbXGKXdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883AbXGKXdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 19:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933099AbXGKXcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 19:32:54 -0400
Received: from ns1.suse.de ([195.135.220.2]:33544 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849AbXGKXcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 19:32:53 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 02/61] debugfs: add rename for debugfs files
Date: Wed, 11 Jul 2007 16:31:21 -0700
Message-Id: <11841967493890-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11841967403365-git-send-email-gregkh@suse.de>
References: <20070711233021.GA5253@kroah.com>
 <11841967403365-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Implement debugfs_rename() to allow renaming files/directories in debugfs.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/debugfs/inode.c      |   63 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/debugfs.h |    9 ++++++
 2 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index ec8896b..1d533a2 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -368,6 +368,69 @@ void debugfs_remove(struct dentry *dentry)
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
+/**
+ * debugfs_rename - rename a file/directory in the debugfs filesystem
+ * @old_dir: a pointer to the parent dentry for the renamed object. This
+ *          should be a directory dentry.
+ * @old_dentry: dentry of an object to be renamed.
+ * @new_dir: a pointer to the parent dentry where the object should be
+ *          moved. This should be a directory dentry.
+ * @new_name: a pointer to a string containing the target name.
+ *
+ * This function renames a file/directory in debugfs.  The target must not
+ * exist for rename to succeed.
+ *
+ * This function will return a pointer to old_dentry (which is updated to
+ * reflect renaming) if it succeeds. If an error occurs, %NULL will be
+ * returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
+		struct dentry *new_dir, const char *new_name)
+{
+	int error;
+	struct dentry *dentry = NULL, *trap;
+	const char *old_name;
+
+	trap = lock_rename(new_dir, old_dir);
+	/* Source or destination directories don't exist? */
+	if (!old_dir->d_inode || !new_dir->d_inode)
+		goto exit;
+	/* Source does not exist, cyclic rename, or mountpoint? */
+	if (!old_dentry->d_inode || old_dentry == trap ||
+	    d_mountpoint(old_dentry))
+		goto exit;
+	dentry = lookup_one_len(new_name, new_dir, strlen(new_name));
+	/* Lookup failed, cyclic rename or target exists? */
+	if (IS_ERR(dentry) || dentry == trap || dentry->d_inode)
+		goto exit;
+
+	old_name = fsnotify_oldname_init(old_dentry->d_name.name);
+
+	error = simple_rename(old_dir->d_inode, old_dentry, new_dir->d_inode,
+		dentry);
+	if (error) {
+		fsnotify_oldname_free(old_name);
+		goto exit;
+	}
+	d_move(old_dentry, dentry);
+	fsnotify_move(old_dir->d_inode, new_dir->d_inode, old_name,
+		old_dentry->d_name.name, S_ISDIR(old_dentry->d_inode->i_mode),
+		NULL, old_dentry->d_inode);
+	fsnotify_oldname_free(old_name);
+	unlock_rename(new_dir, old_dir);
+	dput(dentry);
+	return old_dentry;
+exit:
+	if (dentry && !IS_ERR(dentry))
+		dput(dentry);
+	unlock_rename(new_dir, old_dir);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(debugfs_rename);
+
 static decl_subsys(debug, NULL, NULL);
 
 static int __init debugfs_init(void)
diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
index 5a9c495..104e51e 100644
--- a/include/linux/debugfs.h
+++ b/include/linux/debugfs.h
@@ -38,6 +38,9 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 
 void debugfs_remove(struct dentry *dentry);
 
+struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
+                struct dentry *new_dir, const char *new_name);
+
 struct dentry *debugfs_create_u8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value);
 struct dentry *debugfs_create_u16(const char *name, mode_t mode,
@@ -85,6 +88,12 @@ static inline struct dentry *debugfs_create_symlink(const char *name,
 static inline void debugfs_remove(struct dentry *dentry)
 { }
 
+static inline struct dentry *debugfs_rename(struct dentry *old_dir, struct dentry *old_dentry,
+                struct dentry *new_dir, char *new_name)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline struct dentry *debugfs_create_u8(const char *name, mode_t mode,
 					       struct dentry *parent,
 					       u8 *value)
-- 
1.5.2.2

