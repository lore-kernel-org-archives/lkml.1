Return-Path: <linux-kernel-owner+w=401wt.eu-S1946474AbXBIWzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946474AbXBIWzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946157AbXBIWyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:19 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42479 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423373AbXBIWxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:45 -0500
Subject: [PATCH 17/22] elevate mnt writers for vfs_unlink() callers
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:41 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225341.75EBB290@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org




Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c   |    4 ++++
 lxc-dave/ipc/mqueue.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/namei.c~19-24-elevate-mnt-writers-for-vfs-unlink-callers fs/namei.c
--- lxc/fs/namei.c~19-24-elevate-mnt-writers-for-vfs-unlink-callers	2007-02-09 14:26:57.000000000 -0800
+++ lxc-dave/fs/namei.c	2007-02-09 14:26:57.000000000 -0800
@@ -2181,7 +2181,11 @@ static long do_unlinkat(int dfd, const c
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
diff -puN ipc/mqueue.c~19-24-elevate-mnt-writers-for-vfs-unlink-callers ipc/mqueue.c
--- lxc/ipc/mqueue.c~19-24-elevate-mnt-writers-for-vfs-unlink-callers	2007-02-09 14:26:57.000000000 -0800
+++ lxc-dave/ipc/mqueue.c	2007-02-09 14:26:57.000000000 -0800
@@ -749,8 +749,11 @@ asmlinkage long sys_mq_unlink(const char
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
