Return-Path: <linux-kernel-owner+w=401wt.eu-S933423AbYBOWnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423AbYBOWnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:43:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764144AbYBOWhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:48 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35936 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763704AbYBOWhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:40 -0500
Subject: [PATCH 12/30] r/o bind mounts: elevate mnt_writers for unlink callers
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:37 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223737.0C17BC2D@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c   |    4 ++++
 linux-2.6.git-dave/ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers fs/namei.c
--- linux-2.6.git/fs/namei.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers	2008-02-15 13:25:48.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:48.000000000 -0800
@@ -2280,7 +2280,11 @@ static long do_unlinkat(int dfd, const c
 		inode = dentry->d_inode;
 		if (inode)
 			atomic_inc(&inode->i_count);
+		error = mnt_want_write(nd.path.mnt);
+		if (error)
+			goto exit2;
 		error = vfs_unlink(nd.path.dentry->d_inode, dentry);
+		mnt_drop_write(nd.path.mnt);
 	exit2:
 		dput(dentry);
 	}
diff -puN ipc/mqueue.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers ipc/mqueue.c
--- linux-2.6.git/ipc/mqueue.c~r-o-bind-mounts-elevate-mnt-writers-for-vfs_unlink-callers	2008-02-15 13:25:48.000000000 -0800
+++ linux-2.6.git-dave/ipc/mqueue.c	2008-02-15 13:25:48.000000000 -0800
@@ -742,8 +742,11 @@ asmlinkage long sys_mq_unlink(const char
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
