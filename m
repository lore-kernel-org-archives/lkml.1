Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbYBOWri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbYBOWri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764127AbYBOWh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:56 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39361 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764215AbYBOWht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:49 -0500
Subject: [PATCH 18/30] r/o bind mounts: write counts for link/symlink
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:45 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223745.73F93FFA@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-write-count-for-link-and-symlink-calls	2008-02-15 13:25:52.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:52.000000000 -0800
@@ -2365,7 +2365,12 @@ asmlinkage long sys_symlinkat(const char
 	if (IS_ERR(dentry))
 		goto out_unlock;
 
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_symlink(nd.path.dentry->d_inode, dentry, from, S_IALLUGO);
+	mnt_drop_write(nd.path.mnt);
+out_dput:
 	dput(dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
@@ -2460,7 +2465,12 @@ asmlinkage long sys_linkat(int olddfd, c
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out_unlock;
+	error = mnt_want_write(nd.path.mnt);
+	if (error)
+		goto out_dput;
 	error = vfs_link(old_nd.path.dentry, nd.path.dentry->d_inode, new_dentry);
+	mnt_drop_write(nd.path.mnt);
+out_dput:
 	dput(new_dentry);
 out_unlock:
 	mutex_unlock(&nd.path.dentry->d_inode->i_mutex);
_
