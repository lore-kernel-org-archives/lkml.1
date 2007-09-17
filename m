Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXIQSeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXIQSeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbXIQS1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:39446 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789AbXIQS1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:49 -0400
Subject: [PATCH 21/24] elevate mnt writers for vfs_unlink() callers
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:46 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182746.7B3BBFCC@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c   |    4 ++++
 lxc-dave/ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~elevate-mnt-writers-for-vfs-unlink-callers fs/namei.c
--- lxc/fs/namei.c~elevate-mnt-writers-for-vfs-unlink-callers	2007-09-17 09:44:08.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-17 09:44:08.000000000 -0700
@@ -2253,7 +2253,11 @@ static long do_unlinkat(int dfd, const c
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
--- lxc/ipc/mqueue.c~elevate-mnt-writers-for-vfs-unlink-callers	2007-09-17 09:44:08.000000000 -0700
+++ lxc-dave/ipc/mqueue.c	2007-09-17 09:44:08.000000000 -0700
@@ -747,8 +747,11 @@ asmlinkage long sys_mq_unlink(const char
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
