Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYCQUC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYCQUC3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 16:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYCQUCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 16:02:17 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51446 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYCQUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 16:02:16 -0400
Message-Id: <20080317200157.872688735@szeredi.hu>
References: <20080317200053.447640802@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Mon, 17 Mar 2008 21:01:03 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 10/11] unprivileged mounts: add "no submounts" flag
Content-Disposition: inline; filename=unprivileged-mounts-add-no-submounts-flag.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new mount flag "nosubmnt", which denies submounts for the owner.
This would be useful, if we want to support traditional /etc/fstab
based user mounts.

In this case mount(8) would still have to be suid-root, to check the
mountpoint against the user/users flag in /etc/fstab, but /etc/mtab
would no longer be mandatory for storing the actual owner of the
mount.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 fs/namespace.c        |   10 ++++++++--
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2008-03-17 20:55:52.000000000 +0100
+++ linux/fs/namespace.c	2008-03-17 20:55:53.000000000 +0100
@@ -810,6 +810,7 @@ static void show_mnt_opts(struct seq_fil
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_NOSUBMNT, ",nosubmnt" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -1230,6 +1231,9 @@ static bool permit_mount(struct nameidat
 	if (S_ISLNK(inode->i_mode))
 		return false;
 
+	if (nd->path.mnt->mnt_flags & MNT_NOSUBMNT)
+		return false;
+
 	if (!is_mount_owner(nd->path.mnt, current->fsuid))
 		return false;
 
@@ -2082,9 +2086,11 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
+	if (flags & MS_NOSUBMNT)
+		mnt_flags |= MNT_NOSUBMNT;
 
-	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
+	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_NOATIME |
+		   MS_NODIRATIME | MS_RELATIME | MS_KERNMOUNT | MS_NOSUBMNT);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2008-03-17 20:55:52.000000000 +0100
+++ linux/include/linux/fs.h	2008-03-17 20:55:53.000000000 +0100
@@ -129,6 +129,7 @@ extern int dir_notify_enable;
 #define MS_KERNMOUNT	(1<<22) /* this is a kern_mount call */
 #define MS_I_VERSION	(1<<23) /* Update inode I_version field */
 #define MS_SETUSER	(1<<24) /* set mnt_uid to current user */
+#define MS_NOSUBMNT	(1<<25) /* don't allow unprivileged submounts */
 #define MS_ACTIVE	(1<<30)
 #define MS_NOUSER	(1<<31)
 
Index: linux/include/linux/mount.h
===================================================================
--- linux.orig/include/linux/mount.h	2008-03-17 20:55:42.000000000 +0100
+++ linux/include/linux/mount.h	2008-03-17 20:55:53.000000000 +0100
@@ -30,6 +30,7 @@ struct mnt_namespace;
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
 #define MNT_READONLY	0x40	/* does the user want this to be r/o? */
+#define MNT_NOSUBMNT	0x80
 
 #define MNT_SHRINKABLE	0x100
 #define MNT_IMBALANCED_WRITE_COUNT	0x200 /* just for debugging */

--
