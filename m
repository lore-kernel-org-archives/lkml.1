Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZGFTZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZGFTZL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754146AbZGFTYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:24:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38300 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbZGFTYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:24:46 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090706924.495556466@firstfloor.org>
In-Reply-To: <20090706924.495556466@firstfloor.org>
To: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [PATCH] [2/2] Optimize touch_time too
Message-Id: <20090706192447.9D0531D024A@basil.firstfloor.org>
Date: Mon,  6 Jul 2009 21:24:47 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Do a similar optimization as earlier for touch_atime. Getting
the lock in mnt_get_write is relatively costly, so try all
avenues to avoid it first.

This patch is careful to still only update inode fields
inside the lock region.

This didn't show up in benchmarks, but it's easy enough
to do.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/inode.c |   43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

Index: linux-2.6.31-rc1-ak/fs/inode.c
===================================================================
--- linux-2.6.31-rc1-ak.orig/fs/inode.c
+++ linux-2.6.31-rc1-ak/fs/inode.c
@@ -1431,34 +1431,37 @@ void file_update_time(struct file *file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
-	int sync_it = 0;
-	int err;
+	enum { S_MTIME = 1, S_CTIME = 2, S_VERSION = 4 } sync_it = 0;
 
+	/* First try to exhause all avenues to not sync */
 	if (IS_NOCMTIME(inode))
 		return;
 
-	err = mnt_want_write_file(file);
-	if (err)
-		return;
-
 	now = current_fs_time(inode->i_sb);
-	if (!timespec_equal(&inode->i_mtime, &now)) {
-		inode->i_mtime = now;
-		sync_it = 1;
-	}
+	if (!timespec_equal(&inode->i_mtime, &now))
+		sync_it = S_MTIME;
 
-	if (!timespec_equal(&inode->i_ctime, &now)) {
-		inode->i_ctime = now;
-		sync_it = 1;
-	}
+	if (!timespec_equal(&inode->i_ctime, &now))
+		sync_it |= S_CTIME;
 
-	if (IS_I_VERSION(inode)) {
-		inode_inc_iversion(inode);
-		sync_it = 1;
-	}
+	if (IS_I_VERSION(inode))
+		sync_it |= S_VERSION;
+
+	if (!sync_it)
+		return;
+
+	/* Finally allowed to write? Takes lock. */
+	if (!mnt_want_write_file(file))
+		return;
 
-	if (sync_it)
-		mark_inode_dirty_sync(inode);
+	/* Only change inode inside the lock region */
+	if (sync_it & S_VERSION)
+		inode_inc_iversion(inode);
+	if (sync_it & S_CTIME)
+		inode->i_ctime = now;
+	if (sync_it & S_MTIME)
+		inode->i_mtime = now;
+	mark_inode_dirty_sync(inode);
 	mnt_drop_write(file->f_path.mnt);
 }
 EXPORT_SYMBOL(file_update_time);
