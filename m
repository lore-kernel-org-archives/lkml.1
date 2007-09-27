Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXI0Sxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXI0Sxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758046AbXI0Sw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:52:26 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36195 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757699AbXI0SwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:52:24 -0400
Subject: [RFC][PATCH 3/5] move mnt_want_write() out of may_open()
To: linux-kernel@vger.kernel.org
Cc: miklos@szeredi.hu, hch@infradead.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 27 Sep 2007 11:52:12 -0700
References: <20070927185210.FD980C90@kernel>
In-Reply-To: <20070927185210.FD980C90@kernel>
Message-Id: <20070927185212.B9CD77E6@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


may_open() can fail in a lot of ways.  It is also named
such that it doesn't appear to be _taking_ action, just
checking a bunch of conditions.

So, it makes a poor place to take and release the mnt
writer count.  This moves the burder of taking the
mnt writer counts into the callers.  The callers have
the advantage of much more visibility of the filp.
Since we rely on the __fput(filp) to release the mnt
writer count, this is a good thing.

---

 lxc-dave/fs/namei.c  |   41 +++++++++++++++++++++++------------------
 lxc-dave/fs/nfsctl.c |   20 ++++++++++++++++++--
 2 files changed, 41 insertions(+), 20 deletions(-)

diff -puN fs/namei.c~move-mnt_want_write-out-of-may_open fs/namei.c
--- lxc/fs/namei.c~move-mnt_want_write-out-of-may_open	2007-09-27 11:51:32.000000000 -0700
+++ lxc-dave/fs/namei.c	2007-09-27 11:51:32.000000000 -0700
@@ -1621,14 +1621,6 @@ int may_open(struct nameidata *nd, int a
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (flag & FMODE_WRITE) {
-		/*
-		 * effectively: !special_file()
-		 * balanced by __fput()
-		 */
-		error = mnt_want_write(nd->mnt);
-		if (error)
-			return error;
 	}
 
 	error = vfs_permission(nd, acc_mode);
@@ -1687,10 +1679,8 @@ static int open_namei_create(struct name
 	struct dentry *dir = nd->dentry;
 
 	/*
-	 * This ensures that the mnt stays writable
-	 * over the vfs_create() call to may_open(),
-	 * which takes a more persistent
-	 * mnt_want_write().
+	 * This mnt_want_write() is potentially persistent,
+	 * and balanced in __fput()
 	 */
 	error = mnt_want_write(nd->mnt);
 	if (error) {
@@ -1710,14 +1700,18 @@ static int open_namei_create(struct name
 	/* Don't check for write permission, don't truncate */
 	error = may_open(nd, 0, flag & ~O_TRUNC);
 out:
-	/*
-	 * if needed, may_open() has taken a write
-	 * on the mnt for us, so we can release ours.
-	 */
-	mnt_drop_write(nd->mnt);
+	if (error)
+		mnt_drop_write(nd->mnt);
 	return error;
 }
 
+static inline int write_may_occur_to_file(struct inode *inode, int acc_mode)
+{
+	if (special_file(inode->i_mode))
+		return 0;
+	return (acc_mode & FMODE_WRITE);
+}
+
 /*
  *	open_namei()
  *
@@ -1831,9 +1825,20 @@ do_last:
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
-	error = may_open(nd, acc_mode, flag);
+	/*
+	 * This mnt_want_write() is potentially persistent,
+	 * and balanced in __fput()
+	 */
+	if (write_may_occur_to_file(nd->dentry->d_inode, acc_mode))
+		error = mnt_want_write(nd->mnt);
 	if (error)
 		goto exit;
+	error = may_open(nd, acc_mode, flag);
+	if (error) {
+		if (write_may_occur_to_file(nd->dentry->d_inode, acc_mode))
+			mnt_drop_write(nd->mnt);
+		goto exit;
+	}
 	return 0;
 
 exit_mutex_unlock:
diff -puN fs/nfsctl.c~move-mnt_want_write-out-of-may_open fs/nfsctl.c
--- lxc/fs/nfsctl.c~move-mnt_want_write-out-of-may_open	2007-09-27 11:51:32.000000000 -0700
+++ lxc-dave/fs/nfsctl.c	2007-09-27 11:51:32.000000000 -0700
@@ -22,6 +22,7 @@
 
 static struct file *do_open(char *name, int flags)
 {
+	struct file *filp;
 	struct nameidata nd;
 	struct vfsmount *mnt;
 	int error;
@@ -35,14 +36,29 @@ static struct file *do_open(char *name, 
 	if (error)
 		return ERR_PTR(error);
 
+	/*
+	 * This is balanced when you __fput() the 'struct file'
+	 * returned by dentry_open() below.  If the may_open()
+	 * ever stops containing FMODE_WRITE, this needs to
+	 * be changed.
+	 */
+	error = mnt_want_write(mnt);
+	if (error)
+		return ERR_PTR(error);
 	if (flags == O_RDWR)
 		error = may_open(&nd,MAY_READ|MAY_WRITE,FMODE_READ|FMODE_WRITE);
 	else
 		error = may_open(&nd, MAY_WRITE, FMODE_WRITE);
 
-	if (!error)
-		return dentry_open(nd.dentry, nd.mnt, flags);
+	if (error)
+		goto out;
 
+	filp = dentry_open(nd.dentry, nd.mnt, flags);
+	if (!IS_ERR(filp))
+		return filp;
+	error = PTR_ERR(error);
+out:
+	mnt_drop_write(mnt);
 	path_release(&nd);
 	return ERR_PTR(error);
 }
_
