Return-Path: <linux-kernel-owner+w=401wt.eu-S935020AbXGLA0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935020AbXGLA0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964938AbXGLASK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:18:10 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:36312 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964882AbXGLARo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:44 -0400
Subject: [PATCH 22/23] elevate mnt writers for vfs_unlink() callers
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:40 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001740.DCBCA563@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c   |    4 ++++
 lxc-dave/ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~elevate-mnt-writers-for-vfs-unlink-callers fs/namei.c
--- lxc/fs/namei.c~elevate-mnt-writers-for-vfs-unlink-callers	2007-07-10 12:46:16.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-07-10 12:46:16.000000000 -0700
@@ -2195,7 +2195,11 @@ static long do_unlinkat(int dfd, const c
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
diff -puN ipc/mqueue.c~elevate-mnt-writers-for-vfs-unlink-callers ipc/mqueue.c
--- lxc/ipc/mqueue.c~elevate-mnt-writers-for-vfs-unlink-callers	2007-07-10 12:46:16.000000000 -0700
+++ lxc-dave/ipc/mqueue.c	2007-07-10 12:46:16.000000000 -0700
@@ -750,8 +750,11 @@ asmlinkage long sys_mq_unlink(const char
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
