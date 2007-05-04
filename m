Return-Path: <linux-kernel-owner+w=401wt.eu-S1031033AbXEDQfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031033AbXEDQfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031187AbXEDQfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:35:52 -0400
Received: from styx.suse.cz ([82.119.242.94]:33287 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031033AbXEDQfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:35:51 -0400
Date: Fri, 4 May 2007 18:45:34 +0200
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jbenc@suse.cz, greg@kroah.com
Subject: [PATCH] Implement renaming for debugs (version 2)
Message-ID: <20070504164534.GB32264@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xgyAXRrhYN0wYx8y"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  attached patch implements renaming for debugfs. I was asked for this
feature by WLAN guys and I guess it makes sence (they have some debug info
in the directory identified by interface name and that can change...).
Thanks.

                                                          Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--xgyAXRrhYN0wYx8y
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="debugfs-2.6.21-rc6-1-rename2.diff"

Implement debugfs_rename() to allow renaming files/directories in debugfs.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/fs/debugfs/inode.c linux-2.6.21-rc6-1-debugfs_rename_string/fs/debugfs/inode.c
--- linux-2.6.21-rc6/fs/debugfs/inode.c	2007-04-10 17:09:55.000000000 +0200
+++ linux-2.6.21-rc6-1-debugfs_rename_string/fs/debugfs/inode.c	2007-05-04 18:15:42.000000000 +0200
@@ -368,6 +368,71 @@ void debugfs_remove(struct dentry *dentr
 }
 EXPORT_SYMBOL_GPL(debugfs_remove);
 
+/**
+ * debugfs_rename - rename a file/directory in the debugfs filesystem
+ * @old_dir: a pointer to the parent dentry for the renamed object. This
+ *          should be a directory dentry.
+ * @old_name: a pointer to a string containing name of an object to be renamed.
+ * @new_dir: a pointer to the parent dentry where the object should be
+ *          moved. This should be a directory dentry.
+ * @new_name: a pointer to a string containing the target name.
+ *
+ * This function renames a file/directory in debugfs.  The target must not
+ * exist for rename to succeed.
+ *
+ * This function will return a pointer to a dentry if it succeeds.
+ * If an error occurs, %NULL will be returned.
+ *
+ * If debugfs is not enabled in the kernel, the value -%ENODEV will be
+ * returned.
+ */
+struct dentry *debugfs_rename(struct dentry *old_dir, const char *old_name,
+		struct dentry *new_dir, const char *new_name)
+{
+	int error;
+	struct dentry *dentry = NULL, *trap, *old_dentry = NULL;
+
+	error = simple_pin_fs(&debug_fs_type, &debugfs_mount,
+			      &debugfs_mount_count);
+	if (error)
+		return NULL;
+	trap = lock_rename(new_dir, old_dir);
+	/* Source or destination directories don't exist? */
+	if (!old_dir->d_inode || !new_dir->d_inode)
+		goto exit;
+	old_dentry = lookup_one_len(old_name, old_dir, strlen(old_name));
+	/* Source does not exist, cyclic rename, or mountpoint? */
+	if (IS_ERR(old_dentry) || !old_dentry->d_inode || old_dentry == trap
+	    || d_mountpoint(old_dentry))
+		goto exit;
+	dentry = lookup_one_len(new_name, new_dir, strlen(new_name));
+	/* Lookup failed, cyclic rename or target exists? */
+	if (IS_ERR(dentry) || dentry == trap || dentry->d_inode)
+		goto exit;
+
+	error = simple_rename(old_dir->d_inode, old_dentry, new_dir->d_inode,
+		dentry);
+	if (error)
+		goto exit;
+	/* Assigns old_dentry the new name and destroy dentry... */
+	d_move(old_dentry, dentry);
+	fsnotify_move(old_dir->d_inode, new_dir->d_inode, old_name,
+		old_dentry->d_name.name, S_ISDIR(dentry->d_inode->i_mode),
+		dentry->d_inode, old_dentry->d_inode);
+	unlock_rename(new_dir, old_dir);
+	dput(dentry);
+	return old_dentry;
+exit:
+	if (old_dentry && !IS_ERR(old_dentry))
+		dput(old_dentry);
+	if (dentry && !IS_ERR(dentry))
+		dput(dentry);
+	unlock_rename(new_dir, old_dir);
+	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(debugfs_rename);
+
 static decl_subsys(debug, NULL, NULL);
 
 static int __init debugfs_init(void)
diff -rupX /home/jack/.kerndiffexclude linux-2.6.21-rc6/include/linux/debugfs.h linux-2.6.21-rc6-1-debugfs_rename_string/include/linux/debugfs.h
--- linux-2.6.21-rc6/include/linux/debugfs.h	2007-04-10 17:09:58.000000000 +0200
+++ linux-2.6.21-rc6-1-debugfs_rename_string/include/linux/debugfs.h	2007-05-04 18:09:25.000000000 +0200
@@ -38,6 +38,9 @@ struct dentry *debugfs_create_symlink(co
 
 void debugfs_remove(struct dentry *dentry);
 
+struct dentry *debugfs_rename(struct dentry *old_dir, const char *old_name,
+                struct dentry *new_dir, const char *new_name);
+
 struct dentry *debugfs_create_u8(const char *name, mode_t mode,
 				 struct dentry *parent, u8 *value);
 struct dentry *debugfs_create_u16(const char *name, mode_t mode,
@@ -83,6 +86,12 @@ static inline struct dentry *debugfs_cre
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

--xgyAXRrhYN0wYx8y--
