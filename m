Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbZGFTY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbZGFTY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbZGFTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:24:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38299 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbZGFTYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:24:46 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20090706924.495556466@firstfloor.org>
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] [1/2] Optimization for touch_atime
Date: Mon,  6 Jul 2009 21:24:46 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some benchmark testing shows touch_atime to be high up in profile
logs for IO intensive workloads. Most likely that's due to the lock
in mnt_want_write().  Unfortunately touch_atime first takes the lock,
and then does all the other tests that could avoid atime updates (like
noatime or relatime).

Do it the other way round -- first try to avoid the update and only
then if that didn't succeed take the lock. That works because none of
the atime avoidance tests rely on locking.

This also eliminates a goto.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/inode.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.30-ak/fs/inode.c
===================================================================
--- linux-2.6.30-ak.orig/fs/inode.c
+++ linux-2.6.30-ak/fs/inode.c
@@ -1361,31 +1361,31 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (mnt_want_write(mnt))
-		return;
 	if (inode->i_flags & S_NOATIME)
-		goto out;
+		return;
 	if (IS_NOATIME(inode))
-		goto out;
+		return;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
-		goto out;
+		return;
 
 	if (mnt->mnt_flags & MNT_NOATIME)
-		goto out;
+		return;
 	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
-		goto out;
+		return;
 
 	now = current_fs_time(inode->i_sb);
 
 	if (!relatime_need_update(mnt, inode, now))
-		goto out;
+		return;
 
 	if (timespec_equal(&inode->i_atime, &now))
-		goto out;
+		return;
+
+	if (mnt_want_write(mnt))
+		return;
 
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
-out:
 	mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
