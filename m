Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbYBOWpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbYBOWpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765569AbYBOWhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:52 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60314 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764039AbYBOWho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:44 -0500
Subject: [PATCH 15/30] r/o bind mounts: write counts for time functions
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:41 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223741.D03D77E0@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/inode.c |   45 ++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff -puN fs/inode.c~r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime fs/inode.c
--- linux-2.6.git/fs/inode.c~r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime	2008-02-15 13:25:50.000000000 -0800
+++ linux-2.6.git-dave/fs/inode.c	2008-02-15 13:25:50.000000000 -0800
@@ -1199,42 +1199,37 @@ void touch_atime(struct vfsmount *mnt, s
 	struct inode *inode = dentry->d_inode;
 	struct timespec now;
 
-	if (inode->i_flags & S_NOATIME)
+	if (mnt_want_write(mnt))
 		return;
+	if (inode->i_flags & S_NOATIME)
+		goto out;
 	if (IS_NOATIME(inode))
-		return;
+		goto out;
 	if ((inode->i_sb->s_flags & MS_NODIRATIME) && S_ISDIR(inode->i_mode))
-		return;
+		goto out;
 
-	/*
-	 * We may have a NULL vfsmount when coming from NFSD
-	 */
-	if (mnt) {
-		if (mnt->mnt_flags & MNT_NOATIME)
-			return;
-		if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
-			return;
-
-		if (mnt->mnt_flags & MNT_RELATIME) {
-			/*
-			 * With relative atime, only update atime if the
-			 * previous atime is earlier than either the ctime or
-			 * mtime.
-			 */
-			if (timespec_compare(&inode->i_mtime,
-						&inode->i_atime) < 0 &&
-			    timespec_compare(&inode->i_ctime,
-						&inode->i_atime) < 0)
-				return;
-		}
+	if (mnt->mnt_flags & MNT_NOATIME)
+		goto out;
+	if ((mnt->mnt_flags & MNT_NODIRATIME) && S_ISDIR(inode->i_mode))
+		goto out;
+	if (mnt->mnt_flags & MNT_RELATIME) {
+		/*
+		 * With relative atime, only update atime if the previous
+		 * atime is earlier than either the ctime or mtime.
+		 */
+		if (timespec_compare(&inode->i_mtime, &inode->i_atime) < 0 &&
+		    timespec_compare(&inode->i_ctime, &inode->i_atime) < 0)
+			goto out;
 	}
 
 	now = current_fs_time(inode->i_sb);
 	if (timespec_equal(&inode->i_atime, &now))
-		return;
+		goto out;
 
 	inode->i_atime = now;
 	mark_inode_dirty_sync(inode);
+out:
+	mnt_drop_write(mnt);
 }
 EXPORT_SYMBOL(touch_atime);
 
_
