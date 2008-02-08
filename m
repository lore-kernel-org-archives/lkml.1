Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbYBHWgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbYBHWgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYBHW1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:23 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36612 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757772AbYBHW1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:15 -0500
Subject: [RFC][PATCH 18/30] r/o bind mounts: write counts for link/symlink
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:27:11 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222711.90093286@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls	2008-02-08 13:04:54.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-08 13:04:54.000000000 -0800
@@ -2363,7 +2363,12 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_symlink(nd.dentry->d_inode, dentry, from, S_IALLUGO);
+	mnt_drop_write(nd.mnt);
+out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
@@ -2458,7 +2463,12 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_link(old_nd.dentry, nd.dentry->d_inode, new_dentry);
+	mnt_drop_write(nd.mnt);
+out_dput:
 	dput(new_dentry);
 out_unlock:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
_
