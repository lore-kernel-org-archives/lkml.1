Return-Path: <linux-kernel-owner+w=401wt.eu-S1759052AbXI0Swy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052AbXI0Swy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbXI0SwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:52:21 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51533 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbXI0SwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:52:19 -0400
Subject: [RFC][PATCH 2/5] move mnt_want_write() into open_namei_create()
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 27 Sep 2007 11:52:11 -0700
References: <20070927185210.FD980C90@kernel>
In-Reply-To: <20070927185210.FD980C90@kernel>
Message-Id: <20070927185211.2E05E6A5@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


In a moment, we're going to make may_open() stop doing
the mnt_want/drop_write() pair.  Doing this first makes
the next patch simpler.

---

 lxc-dave/fs/namei.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff -puN fs/namei.c~move-mnt_want_write-into-open_namei_create fs/namei.c
--- lxc/fs/namei.c~move-mnt_want_write-into-open_namei_create	2007-09-27 11:51:32.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-27 11:51:32.000000000 -0700
@@ -1686,6 +1686,19 @@ static int open_namei_create(struct name
 	int error;
 	struct dentry *dir = nd->dentry;
 
+	/*
+	 * This ensures that the mnt stays writable
+	 * over the vfs_create() call to may_open(),
+	 * which takes a more persistent
+	 * mnt_want_write().
+	 */
+	error = mnt_want_write(nd->mnt);
+	if (error) {
+		mutex_unlock(&dir->d_inode->i_mutex);
+		dput(nd->dentry);
+		return error;
+	}
+
 	if (!IS_POSIXACL(dir->d_inode))
 		mode &= ~current->fs->umask;
 	error = vfs_create(dir->d_inode, path->dentry, mode, nd);
@@ -1693,9 +1706,16 @@ static int open_namei_create(struct name
 	dput(nd->dentry);
 	nd->dentry = path->dentry;
 	if (error)
-		return error;
+		goto out;
 	/* Don't check for write permission, don't truncate */
-	return may_open(nd, 0, flag & ~O_TRUNC);
+	error = may_open(nd, 0, flag & ~O_TRUNC);
+out:
+	/*
+	 * if needed, may_open() has taken a write
+	 * on the mnt for us, so we can release ours.
+	 */
+	mnt_drop_write(nd->mnt);
+	return error;
 }
 
 /*
@@ -1778,11 +1798,7 @@ do_last:
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = mnt_want_write(nd->mnt);
-		if (error)
-			goto exit_mutex_unlock;
 		error = open_namei_create(nd, &path, flag, mode);
-		mnt_drop_write(nd->mnt);
 		if (error)
 			goto exit;
 		return 0;
_
