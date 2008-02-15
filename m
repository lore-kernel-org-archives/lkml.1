Return-Path: <linux-kernel-owner+w=401wt.eu-S934794AbYBOWx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934794AbYBOWx3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932181AbYBOWiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:38:14 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36379 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932132AbYBOWiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:38:05 -0500
Subject: [PATCH 29/30] r/o bind mounts: honor mount writer counts at remount
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:38:00 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223800.323B2B5B@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Originally from: Herbert Poetzl <herbert@13thfloor.at>

This is the core of the read-only bind mount patch set.

Note that this does _not_ add a "ro" option directly to the bind mount
operation.  If you require such a mount, you must first do the bind, then
follow it up with a 'mount -o remount,ro' operation:

If you wish to have a r/o bind mount of /foo on bar:

	mount --bind /foo /bar
	mount -o remount,ro /bar

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namespace.c        |   50 ++++++++++++++++++++++++++-----
 linux-2.6.git-dave/include/linux/mount.h |    1 
 2 files changed, 44 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time fs/namespace.c
--- linux-2.6.git/fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time	2008-02-15 13:25:59.000000000 -0800
+++ linux-2.6.git-dave/fs/namespace.c	2008-02-15 13:25:59.000000000 -0800
@@ -105,7 +105,11 @@ struct vfsmount *alloc_vfsmnt(const char
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
 
@@ -299,7 +303,7 @@ void mnt_drop_write(struct vfsmount *mnt
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
-int mnt_make_readonly(struct vfsmount *mnt)
+static int mnt_make_readonly(struct vfsmount *mnt)
 {
 	int ret = 0;
 
@@ -312,15 +316,25 @@ int mnt_make_readonly(struct vfsmount *m
 		goto out;
 	}
 	/*
-	 * actually set mount's r/o flag here to make
-	 * __mnt_is_readonly() true, which keeps anyone
-	 * from doing a successful mnt_want_write().
+	 * nobody can do a successful mnt_want_write() with all
+	 * of the counts in MNT_DENIED_WRITE and the locks held.
 	 */
+	spin_lock(&vfsmount_lock);
+	if (!ret)
+		mnt->mnt_flags |= MNT_READONLY;
+	spin_unlock(&vfsmount_lock);
 out:
 	unlock_mnt_writers();
 	return ret;
 }
 
+static void __mnt_unmake_readonly(struct vfsmount *mnt)
+{
+	spin_lock(&vfsmount_lock);
+	mnt->mnt_flags &= ~MNT_READONLY;
+	spin_unlock(&vfsmount_lock);
+}
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -683,7 +697,7 @@ static int show_vfsmnt(struct seq_file *
 		seq_putc(m, '.');
 		mangle(m, mnt->mnt_sb->s_subtype);
 	}
-	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
+	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
@@ -1277,6 +1291,23 @@ out:
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
@@ -1299,7 +1330,10 @@ static noinline int do_remount(struct na
 		return -EINVAL;
 
 	down_write(&sb->s_umount);
-	err = do_remount_sb(sb, flags, data, 0);
+	if (flags & MS_BIND)
+		err = change_mount_flags(nd->path.mnt, flags);
+	else
+		err = do_remount_sb(sb, flags, data, 0);
 	if (!err)
 		nd->path.mnt->mnt_flags = mnt_flags;
 	up_write(&sb->s_umount);
@@ -1752,6 +1786,8 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
diff -puN include/linux/mount.h~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time	2008-02-15 13:25:59.000000000 -0800
+++ linux-2.6.git-dave/include/linux/mount.h	2008-02-15 13:25:59.000000000 -0800
@@ -29,6 +29,7 @@ struct mnt_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_READONLY	0x40	/* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */
_
