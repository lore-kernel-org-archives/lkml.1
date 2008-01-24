Return-Path: <linux-kernel-owner+w=401wt.eu-S1754674AbYAXTkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbYAXTkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 14:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYAXTew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 14:34:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46530 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbYAXTe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:34:29 -0500
Message-Id: <20080124193417.722190833@szeredi.hu>
References: <20080124193341.166753833@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 24 Jan 2008 20:33:43 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 02/26] mount options: add generic_show_options()
Content-Disposition: inline; filename=generic_show_options.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new s_options field to struct super_block.  Filesystems can save
mount options passed to them in mount or remount.  It is automatically
freed when the superblock is destroyed.

A new helper function, generic_show_options() is introduced, which uses
this field to display the mount options in /proc/mounts.

Another helper function, save_mount_options() may be used by
filesystems to save the options in the super block.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-01-24 17:07:46.000000000 +0100
+++ linux/fs/namespace.c	2008-01-24 17:34:50.000000000 +0100
@@ -575,6 +575,50 @@ void mnt_unpin(struct vfsmount *mnt)
 
 EXPORT_SYMBOL(mnt_unpin);
 
+static inline void mangle(struct seq_file *m, const char *s)
+{
+	seq_escape(m, s, " \t\n\\");
+}
+
+/*
+ * Simple .show_options callback for filesystems which don't want to
+ * implement more complex mount option showing.
+ *
+ * See also save_mount_options().
+ */
+int generic_show_options(struct seq_file *m, struct vfsmount *mnt)
+{
+	const char *options = mnt->mnt_sb->s_options;
+
+	if (options != NULL && options[0]) {
+		seq_putc(m, ',');
+		mangle(m, options);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(generic_show_options);
+
+/*
+ * If filesystem uses generic_show_options(), this function should be
+ * called from the fill_super() callback.
+ *
+ * The .remount_fs callback usually needs to be handled in a special
+ * way, to make sure, that previous options are not overwritten if the
+ * remount fails.
+ *
+ * Also note, that if the filesystem's .remount_fs function doesn't
+ * reset all options to their default value, but changes only newly
+ * given options, then the displayed options will not reflect reality
+ * any more.
+ */
+void save_mount_options(struct super_block *sb, char *options)
+{
+	kfree(sb->s_options);
+	sb->s_options = kstrdup(options, GFP_KERNEL);
+}
+EXPORT_SYMBOL(save_mount_options);
+
 /* iterator */
 static void *m_start(struct seq_file *m, loff_t *pos)
 {
@@ -596,11 +640,6 @@ static void m_stop(struct seq_file *m, v
 	up_read(&namespace_sem);
 }
 
-static inline void mangle(struct seq_file *m, const char *s)
-{
-	seq_escape(m, s, " \t\n\\");
-}
-
 static int show_vfsmnt(struct seq_file *m, void *v)
 {
 	struct vfsmount *mnt = list_entry(v, struct vfsmount, mnt_list);
Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c	2008-01-24 17:07:46.000000000 +0100
+++ linux/fs/super.c	2008-01-24 17:12:33.000000000 +0100
@@ -105,6 +105,7 @@ static inline void destroy_super(struct 
 {
 	security_sb_free(s);
 	kfree(s->s_subtype);
+	kfree(s->s_options);
 	kfree(s);
 }
 
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2008-01-24 17:07:46.000000000 +0100
+++ linux/include/linux/fs.h	2008-01-24 17:12:33.000000000 +0100
@@ -1042,6 +1042,12 @@ struct super_block {
 	 * in /proc/mounts will be "type.subtype"
 	 */
 	char *s_subtype;
+
+	/*
+	 * Saved mount options for lazy filesystems using
+	 * generic_show_options()
+	 */
+	char *s_options;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
@@ -1992,6 +1998,9 @@ extern int __must_check inode_setattr(st
 
 extern void file_update_time(struct file *file);
 
+extern int generic_show_options(struct seq_file *m, struct vfsmount *mnt);
+extern void save_mount_options(struct super_block *sb, char *options);
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;

--
