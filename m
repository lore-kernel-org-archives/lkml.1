Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZEUJY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZEUJY3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754081AbZEUJXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:23:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50333 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZEUJXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:23:30 -0400
Message-Id: <20090521092246.999286876@szeredi.hu>
References: <20090521092231.979256687@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 21 May 2009 11:22:32 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jblunck@suse.de, bharata@in.ibm.com, vaurora@redhat.com,
       viro@zeniv.linux.org.uk
Subject: [patch 1/5] union-directory: Introduce MNT_UNION and MS_UNION flags
Content-Disposition: inline; filename=union-mount-mount_flag.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add per mountpoint flag for Union Mount support. You need additional patches
to util-linux for that to work (ftp.suse.com/pub/people/jblunck/union-mount).

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/namespace.c        |    5 ++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/fs/namespace.c
===================================================================
--- linux-2.6.orig/fs/namespace.c	2009-05-20 15:05:15.000000000 +0200
+++ linux-2.6/fs/namespace.c	2009-05-20 15:07:46.000000000 +0200
@@ -796,6 +796,7 @@ static void show_mnt_opts(struct seq_fil
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_STRICTATIME, ",strictatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -1952,10 +1953,12 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME);
+		   MS_STRICTATIME | MS_UNION);
 
 	/* ... and get the mountpoint */
 	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-05-20 15:05:15.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-05-20 15:07:46.000000000 +0200
@@ -188,6 +188,7 @@ struct inodes_stat_t {
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
Index: linux-2.6/include/linux/mount.h
===================================================================
--- linux-2.6.orig/include/linux/mount.h	2009-05-20 15:05:15.000000000 +0200
+++ linux-2.6/include/linux/mount.h	2009-05-20 15:07:46.000000000 +0200
@@ -35,6 +35,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;

--
