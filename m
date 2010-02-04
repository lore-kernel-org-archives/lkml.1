Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab0BDR6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:58:13 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50210 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab0BDR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:58:10 -0500
X-Greylist: delayed 1296 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Feb 2010 12:58:10 EST
To: viro@ZenIV.linux.org.uk
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [RFC PATCH] vfs: add MNT_NOFOLLOW flag to umount(2)
Message-Id: <E1Nd5cu-0001vz-9U@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 04 Feb 2010 18:36:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new MNT_NOFOLLOW flag to umount(2).  This is needed to prevent
symlink attacks in unprivileged unmounts (fuse, samba, ncpfs).

Additionally, return -EINVAL if an unknown flag is encountered.  This
makes it possible for the caller to determine if a flag is supported
or not (at least on kernels with this patch).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c     |    9 ++++++++-
 include/linux/fs.h |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2010-01-29 09:21:45.000000000 +0100
+++ linux-2.6/fs/namespace.c	2010-02-04 10:03:08.000000000 +0100
@@ -1121,8 +1121,15 @@ SYSCALL_DEFINE2(umount, char __user *, n
 {
 	struct path path;
 	int retval;
+	int lookup_flags = 0;
 
-	retval = user_path(name, &path);
+	if (flags & ~(MNT_FORCE | MNT_DETACH | MNT_EXPIRE | MNT_NOFOLLOW))
+		return -EINVAL;
+
+	if (!(flags & MNT_NOFOLLOW))
+		lookup_flags |= LOOKUP_FOLLOW;
+
+	retval = user_path_at(AT_FDCWD, name, lookup_flags, &path);
 	if (retval)
 		goto out;
 	retval = -EINVAL;
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2010-01-22 08:46:57.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2010-02-04 09:57:39.000000000 +0100
@@ -1305,6 +1305,7 @@ extern int send_sigurg(struct fown_struc
 #define MNT_FORCE	0x00000001	/* Attempt to forcibily umount */
 #define MNT_DETACH	0x00000002	/* Just detach from the tree */
 #define MNT_EXPIRE	0x00000004	/* Mark for expiry */
+#define MNT_NOFOLLOW	0x00000008	/* Don't follow symlink on umount */
 
 extern struct list_head super_blocks;
 extern spinlock_t sb_lock;
