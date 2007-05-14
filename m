Return-Path: <linux-kernel-owner+w=401wt.eu-S1762150AbXENJbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762150AbXENJbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757407AbXENJbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:31:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44364 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756236AbXENJbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:31:35 -0400
Date: Mon, 14 May 2007 15:09:02 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: [RFC][PATCH  2/14] Add a new mount flag (MNT_UNION) for union mount
Message-ID: <20070514093902.GD4139@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514093722.GB4139@in.ibm.com>
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
 fs/namespace.c        |   14 +++++++++++++-
 include/linux/fs.h    |    2 ++
 include/linux/mount.h |    1 +
 3 files changed, 16 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -442,6 +442,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_NOMNT, ",nomnt" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -1256,6 +1257,14 @@ int do_add_mount(struct vfsmount *newmnt
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
 	/* some flags may have been set earlier */
 	newmnt->mnt_flags |= mnt_flags;
 	if ((err = graft_tree(newmnt, nd)))
@@ -1562,9 +1571,12 @@ long do_mount(char *dev_name, char *dir_
 		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_NOMNT)
 		mnt_flags |= MNT_NOMNT;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_NOMNT |
+		   MS_UNION);
 
 	/* ... and get the mountpoint */
 	retval = path_lookup(dir_name, LOOKUP_FOLLOW, &nd);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -97,6 +97,7 @@ extern int dir_notify_enable;
 #define FS_BINARY_MOUNTDATA 2
 #define FS_HAS_SUBTYPE 4
 #define FS_SAFE 8		/* Safe to mount by unprivileged users */
+#define FS_WHT	16
 #define FS_REVAL_DOT	16384	/* Check the paths ".", ".." for staleness */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move()
 					 * during rename() internally.
@@ -113,6 +114,7 @@ extern int dir_notify_enable;
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256	/* Union mount */
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -36,6 +36,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propogation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;
