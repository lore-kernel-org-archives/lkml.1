Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbXITUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbXITUAz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753049AbXITTxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:51481 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXITTxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:21 -0400
Subject: [PATCH 22/25] elevate mnt writers for vfs_unlink() callers
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:17 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195317.5F01FBE0@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c   |    4 ++++
 lxc-dave/ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~elevate-mnt-writers-for-vfs-unlink-callers fs/namei.c
--- lxc/fs/namei.c~elevate-mnt-writers-for-vfs-unlink-callers	2007-09-20 12:16:21.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-20 12:16:21.000000000 -0700
@@ -2228,7 +2228,11 @@ static long do_unlinkat(int dfd, const c
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
--- lxc/ipc/mqueue.c~elevate-mnt-writers-for-vfs-unlink-callers	2007-09-20 12:16:21.000000000 -0700
+++ lxc-dave/ipc/mqueue.c	2007-09-20 12:16:21.000000000 -0700
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
