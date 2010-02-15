Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450Ab0BOMLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:11:19 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:46214 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab0BOMLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:11:17 -0500
To: viro@ZenIV.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH resend] vfs: add NOFOLLOW flag to umount(2)
Message-Id: <E1NgznF-0001sb-3M@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 15 Feb 2010 13:11:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al,

Could you please add this to the VFS tree?

Thanks,
Miklos

----
From: Miklos Szeredi <mszeredi@suse.cz>

Add a new UMOUNT_NOFOLLOW flag to umount(2).  This is needed to prevent
symlink attacks in unprivileged unmounts (fuse, samba, ncpfs).

Additionally, return -EINVAL if an unknown flag is used (and specify
an explicitly unused flag: UMOUNT_UNUSED).  This makes it possible for
the caller to determine if a flag is supported or not.

CC: Eugene Teo <eugene@redhat.com>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c     |    9 ++++++++-
 include/linux/fs.h |    2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-02-08 12:00:02.000000000 +0100
+++ linux-2.6/fs/namespace.c	2010-02-09 13:38:03.000000000 +0100
@@ -1121,8 +1121,15 @@ SYSCALL_DEFINE2(umount, char __user *, n
 {
 	struct path path;
 	int retval;
+	int lookup_flags = 0;
 
-	retval = user_path(name, &path);
+	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | UMOUNT_NOFOLLOW))
+		return -EINVAL;
+
+	if (!(flags & UMOUNT_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+
+	retval = user_path_at(AT_FDCWD, name, lookup_flags, &path);
 	if (retval)
 		goto out;
 	retval = -EINVAL;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-02-08 12:00:03.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2010-02-09 13:35:47.000000000 +0100
@@ -1305,6 +1305,8 @@ extern int send_sigurg(struct fown_struc
 #define MNT_FORCE	0x00000001	/* Attempt to forcibily umount */
 #define MNT_DETACH	0x00000002	/* Just detach from the tree */
 #define MNT_EXPIRE	0x00000004	/* Mark for expiry */
+#define UMOUNT_NOFOLLOW	0x00000008	/* Don't follow symlink on umount */
+#define UMOUNT_UNUSED	0x80000000	/* Flag guaranteed to be unused */
 
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;

