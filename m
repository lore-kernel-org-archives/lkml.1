Return-Path: <linux-kernel-owner+w=401wt.eu-S1756104AbXITUBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbXITUBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXITTxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:34 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60812 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbXITTxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:24 -0400
Subject: [PATCH 25/25] honor r/w changes at do_remount() time
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:21 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195321.4E5FEFB4@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Originally from: Herbert Poetzl <herbert@13thfloor.at>

This is the core of the read-only bind mount patch set.

Note that this does _not_ add a "ro" option directly to
the bind mount operation.  If you require such a mount,
you must first do the bind, then follow it up with a
'mount -o remount,ro' operation.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namespace.c        |   46 ++++++++++++++++++++++++++++++++++-------
 lxc-dave/include/linux/mount.h |    1 
 2 files changed, 40 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~honor-r-w-changes-at-do-remount-time fs/namespace.c
--- lxc/fs/namespace.c~honor-r-w-changes-at-do-remount-time	2007-09-20 12:16:23.000000000 -0700
+++ lxc-dave/fs/namespace.c	2007-09-20 12:16:23.000000000 -0700
@@ -102,7 +102,11 @@ struct vfsmount *alloc_vfsmnt(const char
  */
 int __mnt_is_readonly(struct vfsmount *mnt)
 {
-	return (mnt->mnt_sb->s_flags & MS_RDONLY);
+	if (mnt->mnt_flags & MNT_READONLY)
+		return 1;
+	if (mnt->mnt_sb->s_flags & MS_RDONLY)
+		return 1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(__mnt_is_readonly);
 
@@ -275,7 +279,7 @@ void mnt_drop_write(struct vfsmount *mnt
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
-int mnt_make_readonly(struct vfsmount *mnt)
+static int mnt_make_readonly(struct vfsmount *mnt)
 {
 	int ret = 0;
 
@@ -288,15 +292,21 @@ int mnt_make_readonly(struct vfsmount *m
 		goto out;
 	}
 	/*
-	 * actually set mount's r/o flag here to make
-	 * __mnt_is_readonly() true, which keeps anyone
-	 * from doing a successful mnt_want_write().
+	 * nobody can do a successful mnt_want_write() with all
+	 * of the counts in MNT_DENIED_WRITE and the locks held.
 	 */
+	if (!ret)
+		mnt->mnt_flags |= MNT_READONLY;
 out:
 	mnt_unlock_cpus();
 	return ret;
 }
 
+static void __mnt_unmake_readonly(struct vfsmount *mnt)
+{
+	mnt->mnt_flags &= ~MNT_READONLY;
+}
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -605,7 +615,7 @@ static int show_vfsmnt(struct seq_file *
 		seq_putc(m, '.');
 		mangle(m, mnt->mnt_sb->s_subtype);
 	}
-	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
+	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
@@ -1173,6 +1183,23 @@ out:
 	return err;
 }
 
+static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
+{
+	int error = 0;
+	int readonly_request = 0;
+
+	if (ms_flags & MS_RDONLY)
+		readonly_request = 1;
+	if (readonly_request == __mnt_is_readonly(mnt))
+		return 0;
+
+	if (readonly_request)
+		error = mnt_make_readonly(mnt);
+	else
+		__mnt_unmake_readonly(mnt);
+	return error;
+}
+
 /*
  * change filesystem flags. dir should be a physical root of filesystem.
  * If you've mounted a non-root directory somewhere and want to do remount
@@ -1194,7 +1221,10 @@ static int do_remount(struct nameidata *
 		return -EINVAL;
 
 	down_write(&sb->s_umount);
-	err = do_remount_sb(sb, flags, data, 0);
+	if (flags & MS_BIND)
+		err = change_mount_flags(nd->mnt, flags);
+	else
+		err = do_remount_sb(sb, flags, data, 0);
 	if (!err)
 		nd->mnt->mnt_flags = mnt_flags;
 	up_write(&sb->s_umount);
@@ -1638,6 +1668,8 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
diff -puN include/linux/mount.h~honor-r-w-changes-at-do-remount-time include/linux/mount.h
--- lxc/include/linux/mount.h~honor-r-w-changes-at-do-remount-time	2007-09-20 12:16:23.000000000 -0700
+++ lxc-dave/include/linux/mount.h	2007-09-20 12:16:23.000000000 -0700
@@ -29,6 +29,7 @@ struct mnt_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_READONLY	0x40 /* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
 
_
