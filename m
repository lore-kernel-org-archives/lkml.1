Return-Path: <linux-kernel-owner+w=401wt.eu-S1946220AbXBIWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946220AbXBIWzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946160AbXBIWy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:27 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42463 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423370AbXBIWxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:43 -0500
Subject: [PATCH 15/22] elevate write count for do_sys_utime() and touch_atime()
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:40 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225340.27939943@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/inode.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN fs/inode.c~17-24-elevate-write-count-for-do-sys-utime-and-touch-atime fs/inode.c
--- lxc/fs/inode.c~17-24-elevate-write-count-for-do-sys-utime-and-touch-atime	2007-02-09 14:26:56.000000000 -0800
+++ lxc-dave/fs/inode.c	2007-02-09 14:26:56.000000000 -0800
@@ -1170,22 +1170,23 @@ void touch_atime(struct vfsmount *mnt, s
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
@@ -1196,16 +1197,19 @@ void touch_atime(struct vfsmount *mnt, s
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
