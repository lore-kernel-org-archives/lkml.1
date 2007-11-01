Return-Path: <linux-kernel-owner+w=401wt.eu-S1762026AbXKAXRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762026AbXKAXRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbXKAXJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:09:11 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58563 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbXKAXJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:09:05 -0400
Subject: [PATCH 26/27] r-o-bind-mounts-honor-r-w-changes-at-do_remount-time
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:09:01 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230901.2CCBBEFA@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Originally from: Herbert Poetzl <herbert@13thfloor.at>

This is the core of the read-only bind mount patch set.

Note that this does _not_ add a "ro" option directly to the bind mount
operation.  If you require such a mount, you must first do the bind, then
follow it up with a 'mount -o remount,ro' operation.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namespace.c        |   46 ++++++++++++++++++++++++++-----
 linux-2.6.git-dave/include/linux/mount.h |    1 
 2 files changed, 40 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time fs/namespace.c
--- linux-2.6.git/fs/namespace.c~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time	2007-11-01 14:46:22.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2007-11-01 14:46:22.000000000 -0700
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
 
@@ -277,7 +281,7 @@ void mnt_drop_write(struct vfsmount *mnt
 }
 EXPORT_SYMBOL_GPL(mnt_drop_write);
 
-int mnt_make_readonly(struct vfsmount *mnt)
+static int mnt_make_readonly(struct vfsmount *mnt)
 {
 	int ret = 0;
 
@@ -290,15 +294,21 @@ int mnt_make_readonly(struct vfsmount *m
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
@@ -607,7 +617,7 @@ static int show_vfsmnt(struct seq_file *
 		seq_putc(m, '.');
 		mangle(m, mnt->mnt_sb->s_subtype);
 	}
-	seq_puts(m, mnt->mnt_sb->s_flags & MS_RDONLY ? " ro" : " rw");
+	seq_puts(m, __mnt_is_readonly(mnt) ? " ro" : " rw");
 	for (fs_infop = fs_info; fs_infop->flag; fs_infop++) {
 		if (mnt->mnt_sb->s_flags & fs_infop->flag)
 			seq_puts(m, fs_infop->str);
@@ -1195,6 +1205,23 @@ out:
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
@@ -1216,7 +1243,10 @@ static int do_remount(struct nameidata *
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
@@ -1660,6 +1690,8 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
diff -puN include/linux/mount.h~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~r-o-bind-mounts-honor-r-w-changes-at-do_remount-time	2007-11-01 14:46:22.000000000 -0700
+++ linux-2.6.git-dave/include/linux/mount.h	2007-11-01 14:46:22.000000000 -0700
@@ -29,6 +29,7 @@ struct mnt_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_READONLY	0x40	/* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
 
_
