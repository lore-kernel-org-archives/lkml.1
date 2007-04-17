Return-Path: <linux-kernel-owner+w=401wt.eu-S1754003AbXDQNJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbXDQNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 09:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754015AbXDQNJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 09:09:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59000 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbXDQNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 09:09:55 -0400
Date: Tue, 17 Apr 2007 18:47:15 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  2/15] Add a new mount flag (MNT_UNION) for union mount
Message-ID: <20070417131715.GC4001@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070417131459.GA4001@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417131459.GA4001@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <j.blunck@tu-harburg.de>
Subject: Add a new mount flag (MNT_UNION) for union mount.

Introduce MNT_UNION, MS_UNION and FS_WHT flags. There are the necessary flags
for doing

    mount /dev/hda3 /mnt -o union

You need additional patches for util-linux for that to work.

Signed-off-by: Jan Blunck <j.blunck@tu-harburg.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
---
 fs/namespace.c        |   13 ++++++++++++-
 include/linux/fs.h    |    2 ++
 include/linux/mount.h |    1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -376,6 +376,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -1127,6 +1128,14 @@ int do_add_mount(struct vfsmount *newmnt
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	/* Unions couldn't be writable if the filesystem
+	 * doesn't know about whiteouts */
+	err = -ENOTSUPP;
+	if ((mnt_flags & MNT_UNION) &&
+	    !(newmnt->mnt_sb->s_flags & MS_RDONLY) &&
+	    !(newmnt->mnt_sb->s_type->fs_flags & FS_WHT))
+		goto unlock;
+
 	newmnt->mnt_flags = mnt_flags;
 	if ((err = graft_tree(newmnt, nd)))
 		goto unlock;
@@ -1430,9 +1439,11 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_NODIRATIME;
 	if (flags & MS_RELATIME)
 		mnt_flags |= MNT_RELATIME;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_UNION);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -93,6 +93,7 @@ extern int dir_notify_enable;
 #define FS_REQUIRES_DEV 1 
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
+#define FS_WHT		8
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
@@ -109,6 +110,7 @@ extern int dir_notify_enable;
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256	/* Union mount */
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -34,6 +34,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propogation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;
