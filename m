Return-Path: <linux-kernel-owner+w=401wt.eu-S1754711AbXITT71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbXITT71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbXITTx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60614 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbXITTxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:18 -0400
Subject: [PATCH 20/25] elevate write count for do_sys_utime() and touch_atime()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:15 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195315.66C046E9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/inode.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/inode.c~elevate-write-count-for-do-sys-utime-and-touch-atime fs/inode.c
--- lxc/fs/inode.c~elevate-write-count-for-do-sys-utime-and-touch-atime	2007-09-20 12:16:20.000000000 -0700
+++ lxc-dave/fs/inode.c	2007-09-20 12:16:20.000000000 -0700
@@ -1176,22 +1176,23 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (inode->i_flags & S_NOATIME)
+	if (mnt && mnt_want_write(mnt))
 		return;
+	if (inode->i_flags & S_NOATIME)
+		goto out;
 	if (IS_NOATIME(inode))
-		return;
+		goto out;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
-		return;
+		goto out;
 
 	/*
 	 * We may have a NULL vfsmount when coming from NFSD
 	 */
 	if (mnt) {
 		if (mnt->mnt_flags & MNT_NOATIME)
-			return;
+			goto out;
 		if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
-			return;
-
+			goto out;
 		if (mnt->mnt_flags & MNT_RELATIME) {
 			/*
 			 * With relative atime, only update atime if the
@@ -1202,16 +1203,19 @@ void touch_atime(struct vfsmount *mnt, s
 						&inode->i_atime) < 0 &&
 			    timespec_compare(&inode->i_ctime,
 						&inode->i_atime) < 0)
-				return;
+				goto out;
 		}
 	}
 
 	now = current_fs_time(inode->i_sb);
 	if (timespec_equal(&inode->i_atime, &now))
-		return;
+		goto out;
 
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
+out:
+	if (mnt)
+		mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
 
_
