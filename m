Return-Path: <linux-kernel-owner+w=401wt.eu-S1758207AbZERQOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758207AbZERQOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757602AbZERQMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:12:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:41529 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420AbZERQJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:34 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 16/32] union-mount: Introduce MNT_UNION and MS_UNION flags
Date: Mon, 18 May 2009 18:09:12 +0200
Message-Id: <1242662968-11684-17-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add per mountpoint flag for Union Mount support. You need additional patches
to util-linux for that to work - see:

git://git.kernel.org/pub/scm/utils/util-linux-ng/val/util-linux-ng.git

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namespace.c        |    6 +++++-
 include/linux/fs.h    |    1 +
 include/linux/mount.h |    1 +
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f0a5ce7..53998f2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -780,6 +780,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -1934,9 +1935,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_KERNMOUNT |
+		   MS_UNION);
 
 	/* ... and get the mountpoint */
 	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f5ca398..7f07768 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -125,6 +125,7 @@ struct inodes_stat_t {
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
diff --git a/include/linux/mount.h b/include/linux/mount.h
index cab2a85..bd35fb8 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -34,6 +34,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;
-- 
1.6.1.3

