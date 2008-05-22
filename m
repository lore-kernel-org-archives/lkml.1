Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbYEVWI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbYEVWI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbYEVWIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:08:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754877AbYEVWIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:08:18 -0400
Date: Thu, 22 May 2008 22:55:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: vandrove@vc.cvut.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] ncpfs: Push the BKL for ioctls down into the fs
Message-ID: <20080522225548.38fa0966@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/fs/ncpfs/dir.c b/fs/ncpfs/dir.c
index 011ef0b..d1c4dc7 100644
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -52,7 +52,7 @@ const struct file_operations ncp_dir_operations =
 {
 	.read		= generic_read_dir,
 	.readdir	= ncp_readdir,
-	.ioctl		= ncp_ioctl,
+	.unlocked_ioctl	= ncp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ncp_compat_ioctl,
 #endif
diff --git a/fs/ncpfs/file.c b/fs/ncpfs/file.c
index 2b145de..83e67e4 100644
--- a/fs/ncpfs/file.c
+++ b/fs/ncpfs/file.c
@@ -286,7 +286,7 @@ const struct file_operations ncp_file_operations =
 	.llseek		= remote_llseek,
 	.read		= ncp_file_read,
 	.write		= ncp_file_write,
-	.ioctl		= ncp_ioctl,
+	.unlocked_ioctl	= ncp_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ncp_compat_ioctl,
 #endif
diff --git a/fs/ncpfs/ioctl.c b/fs/ncpfs/ioctl.c
index 3a97c95..f0f7887 100644
--- a/fs/ncpfs/ioctl.c
+++ b/fs/ncpfs/ioctl.c
@@ -262,9 +262,10 @@ ncp_get_charsets(struct ncp_server* server, struct ncp_nls_ioctl __user *arg)
 }
 #endif /* CONFIG_NCPFS_NLS */
 
-static int __ncp_ioctl(struct inode *inode, struct file *filp,
-	      unsigned int cmd, unsigned long arg)
+static long __ncp_ioctl(struct file *filp, unsigned int cmd,
+							unsigned long arg)
 {
+	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct ncp_server *server = NCP_SERVER(inode);
 	int result;
 	struct ncp_ioctl_request request;
@@ -852,11 +853,12 @@ static int ncp_ioctl_need_write(unsigned int cmd)
 	}
 }
 
-int ncp_ioctl(struct inode *inode, struct file *filp,
+long ncp_ioctl(struct file *filp,
 	      unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
+	lock_kernel();
 	if (ncp_ioctl_need_write(cmd)) {
 		/*
 		 * inside the ioctl(), any failures which
@@ -864,24 +866,26 @@ int ncp_ioctl(struct inode *inode, struct file *filp,
 		 * -EACCESS, so it seems consistent to keep
 		 *  that here.
 		 */
-		if (mnt_want_write(filp->f_path.mnt))
+		if (mnt_want_write(filp->f_path.mnt)) {
+			unlock_kernel();
 			return -EACCES;
+		}
 	}
-	ret = __ncp_ioctl(inode, filp, cmd, arg);
+	ret = __ncp_ioctl(filp, cmd, arg);
 	if (ncp_ioctl_need_write(cmd))
 		mnt_drop_write(filp->f_path.mnt);
+	unlock_kernel();
 	return ret;
 }
 
 #ifdef CONFIG_COMPAT
 long ncp_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int ret;
 
 	lock_kernel();
 	arg = (unsigned long) compat_ptr(arg);
-	ret = ncp_ioctl(inode, file, cmd, arg);
+	ret = ncp_ioctl(file, cmd, arg);
 	unlock_kernel();
 	return ret;
 }
