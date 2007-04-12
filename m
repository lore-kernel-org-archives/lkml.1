Return-Path: <linux-kernel-owner+w=401wt.eu-S965578AbXDLQ4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965578AbXDLQ4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 12:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964934AbXDLQ4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 12:56:10 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:40222 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030357AbXDLQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 12:56:08 -0400
Message-Id: <20070412164609.993152209@szeredi.hu>
References: <20070412164541.580374744@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 12 Apr 2007 18:45:43 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 02/10] allow unprivileged umount
Content-Disposition: inline; filename=unprivileged_umount.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

The owner doesn't need sysadmin capabilities to call umount().

Similar behavior as umount(8) on mounts having "user=UID" option in
/etc/mtab.  The difference is that umount also checks /etc/fstab,
presumably to exclude another mount on the same mountpoint.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-04-11 20:07:51.000000000 +0200
+++ linux/fs/namespace.c	2007-04-11 20:08:05.000000000 +0200
@@ -659,6 +659,25 @@ static int do_umount(struct vfsmount *mn
 }
 
 /*
+ * umount is permitted for
+ *  - sysadmin
+ *  - mount owner, if not forced umount
+ */
+static bool permit_umount(struct vfsmount *mnt, int flags)
+{
+	if (capable(CAP_SYS_ADMIN))
+		return true;
+
+	if (!(mnt->mnt_flags & MNT_USER))
+		return false;
+
+	if (flags & MNT_FORCE)
+		return false;
+
+	return mnt->mnt_uid == current->uid;
+}
+
+/*
  * Now umount can handle mount points as well as block devices.
  * This is important for filesystems which use unnamed block devices.
  *
@@ -681,7 +700,7 @@ asmlinkage long sys_umount(char __user *
 		goto dput_and_out;
 
 	retval = -EPERM;
-	if (!capable(CAP_SYS_ADMIN))
+	if (!permit_umount(nd.mnt, flags))
 		goto dput_and_out;
 
 	retval = do_umount(nd.mnt, flags);

--
