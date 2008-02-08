Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbYBHWel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbYBHWel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:34:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759287AbYBHW1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:19 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56894 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759294AbYBHW1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:10 -0500
Subject: [RFC][PATCH 15/30] r/o bind mounts: write counts for time functions
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:27:07 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222707.B518271F@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/inode.c |   45 ++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff -puN fs/inode.c~r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime fs/inode.c
--- linux-2.6.git/fs/inode.c~r-o-bind-mounts-elevate-write-count-for-do_sys_utime-and-touch_atime	2008-02-08 13:04:52.000000000 -0800
+++ linux-2.6.git-dave/fs/inode.c	2008-02-08 13:04:52.000000000 -0800
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
