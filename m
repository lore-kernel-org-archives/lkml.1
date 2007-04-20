Return-Path: <linux-kernel-owner+w=401wt.eu-S1423039AbXDTK1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423039AbXDTK1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030515AbXDTK1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:27:44 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:40545 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030848AbXDTK1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:27:43 -0400
Message-Id: <20070420102626.825263599@szeredi.hu>
References: <20070420102532.385211890@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 20 Apr 2007 12:25:34 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, serue@us.ibm.com, viro@ftp.linux.org.uk,
       linuxram@us.ibm.com, ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: [patch 2/8] allow unprivileged umount
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
--- linux.orig/fs/namespace.c	2007-04-20 11:55:05.000000000 +0200
+++ linux/fs/namespace.c	2007-04-20 11:55:06.000000000 +0200
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
