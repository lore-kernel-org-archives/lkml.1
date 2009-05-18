Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbZERQRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbZERQRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbZERQNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:13:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022AbZERQJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:30 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 19/32] union-mount: Some checks during namespace changes
Date: Mon, 18 May 2009 18:09:15 +0200
Message-Id: <1242662968-11684-20-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some additional checks when mounting something into an union.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/namespace.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 53998f2..4128d99 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -27,6 +27,7 @@
 #include <linux/ramfs.h>
 #include <linux/log2.h>
 #include <linux/idr.h>
+#include <linux/union.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -1442,6 +1443,10 @@ static int do_change_type(struct path *path, int flag)
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't change the type of union mounts */
+	if (IS_MNT_UNION(path->mnt))
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
@@ -1493,6 +1498,18 @@ static int do_loopback(struct path *path, char *old_name, int recurse,
 	if (!mnt)
 		goto out;
 
+	/*
+	 * Unions couldn't be writable if the filesystem doesn't know about
+	 * whiteouts
+	 */
+	err = -ENOTSUPP;
+	if ((mnt_flags & MNT_UNION) &&
+	    !(mnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
+		goto out;
+
+	if (mnt_flags & MNT_UNION)
+		mnt->mnt_flags |= MNT_UNION;
+
 	err = graft_tree(mnt, path);
 	if (err) {
 		LIST_HEAD(umount_list);
@@ -1586,6 +1603,13 @@ static int do_move_mount(struct path *path, char *old_name)
 	if (err)
 		return err;
 
+	/* moving to or from a union mount is not supported */
+	err = -EINVAL;
+	if (IS_MNT_UNION(path->mnt))
+		goto exit;
+	if (IS_MNT_UNION(old_path.mnt))
+		goto exit;
+
 	down_write(&namespace_sem);
 	while (d_mountpoint(path->dentry) &&
 	       follow_down(&path->mnt, &path->dentry))
@@ -1643,6 +1667,7 @@ out:
 	up_write(&namespace_sem);
 	if (!err)
 		path_put(&parent_path);
+exit:
 	path_put(&old_path);
 	return err;
 }
@@ -1698,6 +1723,15 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
 	if (S_ISLNK(newmnt->mnt_root->d_inode->i_mode))
 		goto unlock;
 
+	/*
+	 * Unions couldn't be writable if the filesystem doesn't know about
+	 * whiteouts
+	 */
+	err = -ENOTSUPP;
+	if ((mnt_flags & MNT_UNION) &&
+	    !(newmnt->mnt_sb->s_flags & (MS_WHITEOUT|MS_RDONLY)))
+		goto unlock;
+
 	newmnt->mnt_flags = mnt_flags;
 	if ((err = graft_tree(newmnt, path)))
 		goto unlock;
-- 
1.6.1.3

