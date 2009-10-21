Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbZJUT0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbZJUT0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 15:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932253AbZJUTVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 15:21:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215AbZJUTVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 15:21:04 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>, Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 22/41] union-mount: Some checks during namespace changes
Date: Wed, 21 Oct 2009 12:19:20 -0700
Message-Id: <1256152779-10054-23-git-send-email-vaurora@redhat.com>
In-Reply-To: <1256152779-10054-22-git-send-email-vaurora@redhat.com>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com>
 <1256152779-10054-2-git-send-email-vaurora@redhat.com>
 <1256152779-10054-3-git-send-email-vaurora@redhat.com>
 <1256152779-10054-4-git-send-email-vaurora@redhat.com>
 <1256152779-10054-5-git-send-email-vaurora@redhat.com>
 <1256152779-10054-6-git-send-email-vaurora@redhat.com>
 <1256152779-10054-7-git-send-email-vaurora@redhat.com>
 <1256152779-10054-8-git-send-email-vaurora@redhat.com>
 <1256152779-10054-9-git-send-email-vaurora@redhat.com>
 <1256152779-10054-10-git-send-email-vaurora@redhat.com>
 <1256152779-10054-11-git-send-email-vaurora@redhat.com>
 <1256152779-10054-12-git-send-email-vaurora@redhat.com>
 <1256152779-10054-13-git-send-email-vaurora@redhat.com>
 <1256152779-10054-14-git-send-email-vaurora@redhat.com>
 <1256152779-10054-15-git-send-email-vaurora@redhat.com>
 <1256152779-10054-16-git-send-email-vaurora@redhat.com>
 <1256152779-10054-17-git-send-email-vaurora@redhat.com>
 <1256152779-10054-18-git-send-email-vaurora@redhat.com>
 <1256152779-10054-19-git-send-email-vaurora@redhat.com>
 <1256152779-10054-20-git-send-email-vaurora@redhat.com>
 <1256152779-10054-21-git-send-email-vaurora@redhat.com>
 <1256152779-10054-22-git-send-email-vaurora@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

Add some additional checks when mounting something into an union.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Valerie Aurora <vaurora@redhat.com>
---
 fs/namespace.c |   34 ++++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 81b3188..dc01385 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/idr.h>
 #include <linux/fs_struct.h>
+#include <linux/union.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 #include "pnode.h"
@@ -1427,6 +1428,10 @@ static int do_change_type(struct path *path, int flag)
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't change the type of union mounts */
+	if (IS_MNT_UNION(path->mnt))
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
@@ -1478,6 +1483,18 @@ static int do_loopback(struct path *path, char *old_name, int recurse,
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
@@ -1571,6 +1588,13 @@ static int do_move_mount(struct path *path, char *old_name)
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
 	       follow_down(path))
@@ -1628,6 +1652,7 @@ out:
 	up_write(&namespace_sem);
 	if (!err)
 		path_put(&parent_path);
+exit:
 	path_put(&old_path);
 	return err;
 }
@@ -1685,6 +1710,15 @@ int do_add_mount(struct vfsmount *newmnt, struct path *path,
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
1.6.3.3

