Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbXITTzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbXITTzy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXITTxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50918 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXITTxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:07 -0400
Subject: [PATCH 12/25] elevate write count for link and symlink calls
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:04 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195304.182F501B@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN fs/namei.c~elevate-write-count-for-link-and-symlink-calls fs/namei.c
--- lxc/fs/namei.c~elevate-write-count-for-link-and-symlink-calls	2007-09-20 12:16:15.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-20 12:16:15.000000000 -0700
@@ -2299,7 +2299,12 @@ asmlinkage long sys_symlinkat(const char
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
@@ -2394,7 +2399,12 @@ asmlinkage long sys_linkat(int olddfd, c
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
