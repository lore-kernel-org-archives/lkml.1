Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbXKAXLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbXKAXLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756295AbXKAXIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:44 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44423 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbXKAXIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:42 -0400
Subject: [PATCH 09/27] r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:38 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230838.60E1F941@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/namei.c   |    4 ++++
 linux-2.6.git-dave/ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers	2007-11-01 14:46:10.000000000 -0700
+++ linux-2.6.git-dave/fs/namei.c	2007-11-01 14:46:10.000000000 -0700
@@ -2264,7 +2264,11 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
+		error = mnt_want_write(nd.mnt);
+		if (error)
+			goto exit2;
 		error = vfs_unlink(nd.dentry->d_inode, dentry);
+		mnt_drop_write(nd.mnt);
 	exit2:
 		dput(dentry);
 	}
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers ipc/mqueue.c
--- linux-2.6.git/ipc/mqueue.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers	2007-11-01 14:46:10.000000000 -0700
+++ linux-2.6.git-dave/ipc/mqueue.c	2007-11-01 14:46:10.000000000 -0700
@@ -743,8 +743,11 @@ asmlinkage long sys_mq_unlink(const char
 	inode = dentry->d_inode;
 	if (inode)
 		atomic_inc(&inode->i_count);
-
+	err = mnt_want_write(mqueue_mnt);
+	if (err)
+		goto out_err;
 	err = vfs_unlink(dentry->d_parent->d_inode, dentry);
+	mnt_drop_write(mqueue_mnt);
 out_err:
 	dput(dentry);
 
_
