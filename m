Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbXBLLu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbXBLLu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 06:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964878AbXBLLu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 06:50:58 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:43947 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964874AbXBLLu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 06:50:57 -0500
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Szakacsits Szabolcs <szaka@sienet.hu>
Subject: [RFC PATCH] add filesystem subtype support
Message-Id: <E1HGZhm-0003eb-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 12 Feb 2007 12:50:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's a slight problem with filesystem type representation in fuse
based filesystems.

>From the kernel's view, there are just two filesystem types: fuse and
fuseblk.  From the user's view there are lots of different filesystem
types.  The user is not even much concerned if the filesystem is fuse
based or not.  So there's a conflict of interest in how this should be
represented in fstab, mtab and /proc/mounts.

The current scheme is to encode the real filesystem type in the mount
source.  So an sshfs mount looks like this:

  sshfs#user@server:/   /mnt/server    fuse   rw,nosuid,nodev,...

This url-ish syntax works OK for sshfs and similar filesystems.
However for block device based filesystems (ntfs-3g, zfs) it doesn't
work, since the kernel expects the mount source to be a real device
name.

A possibly better scheme would be to encode the real type in the type
field as "type.subtype".  So fuse mounts would look like this:

  /dev/hda1       /mnt/windows   fuseblk.ntfs-3g   rw,...
  user@server:/   /mnt/server    fuse.sshfs        rw,nosuid,nodev,...

This patch adds the necessary code to the kernel so that this can be
correctly displayed in /proc/mounts.

---
Index: linux/fs/filesystems.c
===================================================================
--- linux.orig/fs/filesystems.c	2007-02-12 12:42:55.000000000 +0100
+++ linux/fs/filesystems.c	2007-02-12 12:43:00.000000000 +0100
@@ -42,11 +42,12 @@ void put_filesystem(struct file_system_t
 	module_put(fs->owner);
 }
 
-static struct file_system_type **find_filesystem(const char *name)
+static struct file_system_type **find_filesystem(const char *name, unsigned len)
 {
 	struct file_system_type **p;
 	for (p=&file_systems; *p; p=&(*p)->next)
-		if (strcmp((*p)->name,name) == 0)
+		if (strlen((*p)->name) == len &&
+		    strncmp((*p)->name, name, len) == 0)
 			break;
 	return p;
 }
@@ -69,11 +70,12 @@ int register_filesystem(struct file_syst
 	int res = 0;
 	struct file_system_type ** p;
 
+	BUG_ON(strchr(fs->name, '.'));
 	if (fs->next)
 		return -EBUSY;
 	INIT_LIST_HEAD(&fs->fs_supers);
 	write_lock(&file_systems_lock);
-	p = find_filesystem(fs->name);
+	p = find_filesystem(fs->name, strlen(fs->name));
 	if (*p)
 		res = -EBUSY;
 	else
@@ -216,19 +218,26 @@ int get_filesystem_list(char * buf)
 struct file_system_type *get_fs_type(const char *name)
 {
 	struct file_system_type *fs;
+	const char *dot = strchr(name, '.');
+	unsigned len = dot ? dot - name : strlen(name);
 
 	read_lock(&file_systems_lock);
-	fs = *(find_filesystem(name));
+	fs = *(find_filesystem(name, len));
 	if (fs && !try_module_get(fs->owner))
 		fs = NULL;
 	read_unlock(&file_systems_lock);
-	if (!fs && (request_module("%s", name) == 0)) {
+	if (!fs && (request_module("%.*s", len, name) == 0)) {
 		read_lock(&file_systems_lock);
-		fs = *(find_filesystem(name));
+		fs = *(find_filesystem(name, len));
 		if (fs && !try_module_get(fs->owner))
 			fs = NULL;
 		read_unlock(&file_systems_lock);
 	}
+
+	if (dot && fs && !(fs->fs_flags & FS_HAS_SUBTYPE)) {
+		put_filesystem(fs);
+		fs = NULL;
+	}
 	return fs;
 }
 
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-02-12 12:42:55.000000000 +0100
+++ linux/fs/fuse/inode.c	2007-02-12 12:43:00.000000000 +0100
@@ -634,6 +634,7 @@ static int fuse_get_sb(struct file_syste
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
+	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb,
 	.kill_sb	= kill_anon_super,
 };
@@ -650,6 +651,7 @@ static int fuse_get_sb_blk(struct file_s
 static struct file_system_type fuseblk_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuseblk",
+	.fs_flags	= FS_HAS_SUBTYPE,
 	.get_sb		= fuse_get_sb_blk,
 	.kill_sb	= kill_block_super,
 	.fs_flags	= FS_REQUIRES_DEV,
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-02-12 12:42:55.000000000 +0100
+++ linux/fs/namespace.c	2007-02-12 12:43:00.000000000 +0100
@@ -378,6 +378,10 @@ static int show_vfsmnt(struct seq_file *
 	seq_path(m, mnt, mnt->mnt_root, " \t\n\\");
 	seq_putc(m, ' ');
 	mangle(m, mnt->mnt_sb->s_type->name);
+	if (mnt->mnt_sb->s_subtype && mnt->mnt_sb->s_subtype[0]) {
+		seq_putc(m, '.');
+		mangle(m, mnt->mnt_sb->s_subtype);
+	}
 	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
Index: linux/fs/super.c
===================================================================
--- linux.orig/fs/super.c	2007-02-12 12:42:55.000000000 +0100
+++ linux/fs/super.c	2007-02-12 12:43:00.000000000 +0100
@@ -107,6 +107,7 @@ out:
 static inline void destroy_super(struct super_block *s)
 {
 	security_sb_free(s);
+	kfree(s->s_subtype);
 	kfree(s);
 }
 
@@ -919,6 +920,29 @@ out:
 
 EXPORT_SYMBOL_GPL(vfs_kern_mount);
 
+static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
+{
+	int err;
+	const char *subtype = strchr(fstype, '.');
+	if (subtype) {
+		subtype++;
+		err = -EINVAL;
+		if (!subtype[0])
+			goto err;
+	} else
+		subtype = "";
+
+	mnt->mnt_sb->s_subtype = kstrdup(subtype, GFP_KERNEL);
+	err = -ENOMEM;
+	if (!mnt->mnt_sb->s_subtype)
+		goto err;
+	return mnt;
+
+ err:
+	mntput(mnt);
+	return ERR_PTR(err);
+}
+
 struct vfsmount *
 do_kern_mount(const char *fstype, int flags, const char *name, void *data)
 {
@@ -927,6 +951,9 @@ do_kern_mount(const char *fstype, int fl
 	if (!type)
 		return ERR_PTR(-ENODEV);
 	mnt = vfs_kern_mount(type, flags, name, data);
+	if (!IS_ERR(mnt) && (type->fs_flags & FS_HAS_SUBTYPE) &&
+	    !mnt->mnt_sb->s_subtype)
+		mnt = fs_set_subtype(mnt, fstype);
 	put_filesystem(type);
 	return mnt;
 }
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-02-12 12:42:55.000000000 +0100
+++ linux/include/linux/fs.h	2007-02-12 12:43:00.000000000 +0100
@@ -91,6 +91,7 @@ extern int dir_notify_enable;
 /* public flags for file_system_type */
 #define FS_REQUIRES_DEV 1 
 #define FS_BINARY_MOUNTDATA 2
+#define FS_HAS_SUBTYPE 4
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
@@ -950,6 +951,12 @@ struct super_block {
 	/* Granularity of c/m/atime in ns.
 	   Cannot be worse than a second */
 	u32		   s_time_gran;
+
+	/*
+	 * Filesystem subtype.  If non-empty the filesystem type field
+	 * in /proc/mounts will be "type.subtype"
+	 */
+	char *s_subtype;
 };
 
 extern struct timespec current_fs_time(struct super_block *sb);
