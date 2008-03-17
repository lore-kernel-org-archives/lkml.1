Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbYCQUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbYCQUGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755106AbYCQUCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:02:22 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51448 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYCQUCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:02:19 -0400
Message-Id: <20080317200146.080681921@szeredi.hu>
References: <20080317200053.447640802@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 21:00:55 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 02/11] unprivileged mounts: allow unprivileged umount
Content-Disposition: inline; filename=unprivileged-mounts-allow-unprivileged-umount.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The owner doesn't need sysadmin capabilities to call umount().

Similar behavior as umount(8) on mounts having "user=UID" option in /etc/mtab.
The difference is that umount also checks /etc/fstab, presumably to exclude
another mount on the same mountpoint.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/namespace.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-17 20:55:42.000000000 +0100
+++ linux/fs/namespace.c	2008-03-17 20:55:44.000000000 +0100
@@ -1074,6 +1074,27 @@ static int do_umount(struct vfsmount *mn
 	return retval;
 }
 
+static bool is_mount_owner(struct vfsmount *mnt, uid_t uid)
+{
+	return (mnt->mnt_flags & MNT_USER) && mnt->mnt_uid == uid;
+}
+
+/*
+ * umount is permitted for
+ *  - sysadmin
+ *  - mount owner, if not forced umount
+ */
+static bool permit_umount(struct vfsmount *mnt, int flags)
+{
+	if (capable(CAP_SYS_ADMIN))
+		return true;
+
+	if (flags & MNT_FORCE)
+		return false;
+
+	return is_mount_owner(mnt, current->fsuid);
+}
+
 /*
  * Now umount can handle mount points as well as block devices.
  * This is important for filesystems which use unnamed block devices.
@@ -1097,7 +1118,7 @@ asmlinkage long sys_umount(char __user *
 		goto dput_and_out;
 
 	retval = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
+	if (!permit_umount(nd.path.mnt, flags))
 		goto dput_and_out;
 
 	retval = do_umount(nd.path.mnt, flags);

--
