Return-Path: <linux-kernel-owner+w=401wt.eu-S1758857AbXJ3Tm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857AbXJ3Tm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 15:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbXJ3Tlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 15:41:37 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45062 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbXJ3Tlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 15:41:35 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 3/4] VFS: factor out three helpers for FIBMAP/FIONBIO/FIOASYNC file ioctls
Date: Tue, 30 Oct 2007 15:39:58 -0400
Message-Id: <11937732003896-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11937731993134-git-send-email-ezk@cs.sunysb.edu>
References: <11937731993134-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/ioctl.c |  129 +++++++++++++++++++++++++++++++++++-------------------------
 1 files changed, 75 insertions(+), 54 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 1ab7b7d..cd8c1a3 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -53,32 +53,34 @@ long vfs_ioctl(struct file *filp, unsigned int cmd,
 }
 EXPORT_SYMBOL_GPL(vfs_ioctl);
 
+static int ioctl_fibmap(struct file *filp, int __user *p)
+{
+	struct address_space *mapping = filp->f_mapping;
+	int res, block;
+
+	/* do we support this mess? */
+	if (!mapping->a_ops->bmap)
+		return -EINVAL;
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+	res = get_user(block, p);
+	if (res)
+		return res;
+	lock_kernel();
+	res = mapping->a_ops->bmap(mapping, block);
+	unlock_kernel();
+	return put_user(res, p);
+}
+
 static int file_ioctl(struct file *filp, unsigned int cmd,
 		unsigned long arg)
 {
-	int error;
-	int block;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int __user *p = (int __user *)arg;
 
 	switch (cmd) {
 	case FIBMAP:
-	{
-		struct address_space *mapping = filp->f_mapping;
-		int res;
-		/* do we support this mess? */
-		if (!mapping->a_ops->bmap)
-			return -EINVAL;
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		error = get_user(block, p);
-		if (error)
-			return error;
-		lock_kernel();
-		res = mapping->a_ops->bmap(mapping, block);
-		unlock_kernel();
-		return put_user(res, p);
-	}
+		return ioctl_fibmap(filp, p);
 	case FIGETBSZ:
 		return put_user(inode->i_sb->s_blocksize, p);
 	case FIONREAD:
@@ -88,6 +90,57 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 	return vfs_ioctl(filp, cmd, arg);
 }
 
+static int ioctl_fionbio(struct file *filp, int __user *argp)
+{
+	unsigned int flag;
+	int on, error;
+
+	error = get_user(on, argp);
+	if (error)
+		return error;
+	flag = O_NONBLOCK;
+#ifdef __sparc__
+	/* SunOS compatibility item. */
+	if (O_NONBLOCK != O_NDELAY)
+		flag |= O_NDELAY;
+#endif
+	if (on)
+		filp->f_flags |= flag;
+	else
+		filp->f_flags &= ~flag;
+	return error;
+}
+
+static int ioctl_fioasync(unsigned int fd, struct file *filp,
+			  int __user *argp)
+{
+	unsigned int flag;
+	int on, error;
+
+	error = get_user(on, argp);
+	if (error)
+		return error;
+	flag = on ? FASYNC : 0;
+
+	/* Did FASYNC state change ? */
+	if ((flag ^ filp->f_flags) & FASYNC) {
+		if (filp->f_op && filp->f_op->fasync) {
+			lock_kernel();
+			error = filp->f_op->fasync(fd, filp, on);
+			unlock_kernel();
+		} else
+			error = -ENOTTY;
+	}
+	if (error)
+		return error;
+
+	if (on)
+		filp->f_flags |= FASYNC;
+	else
+		filp->f_flags &= ~FASYNC;
+	return error;
+}
+
 /*
  * When you add any new common ioctls to the switches above and below
  * please update compat_sys_ioctl() too.
@@ -98,8 +151,8 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 int do_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 	     unsigned long arg)
 {
-	unsigned int flag;
-	int on, error = 0;
+	int error = 0;
+	int __user *argp = (int __user *)arg;
 
 	switch (cmd) {
 	case FIOCLEX:
@@ -111,43 +164,11 @@ int do_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		break;
 
 	case FIONBIO:
-		error = get_user(on, (int __user *)arg);
-		if (error)
-			break;
-		flag = O_NONBLOCK;
-#ifdef __sparc__
-		/* SunOS compatibility item. */
-		if (O_NONBLOCK != O_NDELAY)
-			flag |= O_NDELAY;
-#endif
-		if (on)
-			filp->f_flags |= flag;
-		else
-			filp->f_flags &= ~flag;
+		error = ioctl_fionbio(filp, argp);
 		break;
 
 	case FIOASYNC:
-		error = get_user(on, (int __user *)arg);
-		if (error)
-			break;
-		flag = on ? FASYNC : 0;
-
-		/* Did FASYNC state change ? */
-		if ((flag ^ filp->f_flags) & FASYNC) {
-			if (filp->f_op && filp->f_op->fasync) {
-				lock_kernel();
-				error = filp->f_op->fasync(fd, filp, on);
-				unlock_kernel();
-			} else
-				error = -ENOTTY;
-		}
-		if (error != 0)
-			break;
-
-		if (on)
-			filp->f_flags |= FASYNC;
-		else
-			filp->f_flags &= ~FASYNC;
+		error = ioctl_fioasync(fd, filp, argp);
 		break;
 
 	case FIOQSIZE:
-- 
1.5.2.2

