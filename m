Return-Path: <linux-kernel-owner+w=401wt.eu-S935930AbYEVWFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935930AbYEVWFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758473AbYEVWFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:05:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51516 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756479AbYEVWFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:05:33 -0400
Date: Thu, 22 May 2008 22:52:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, sfrench@samba.org
Subject: [PATCH] cifs: Push the BKL down into the fs ioctl code
Message-ID: <20080522225243.0da12b58@core>
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

Switch to unlocked_ioctl. Wrap the ioctl handler internally with
lock_kernel until someone can prove it isn't needed or fix it so it isn't.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 427a7c6..b6436b8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -657,7 +657,7 @@ const struct file_operations cifs_file_ops = {
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl	= cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -677,7 +677,7 @@ const struct file_operations cifs_file_direct_ops = {
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -697,7 +697,7 @@ const struct file_operations cifs_file_nobrl_ops = {
 	.splice_read = generic_file_splice_read,
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl	= cifs_ioctl,
+	.unlocked_ioctl	= cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -716,7 +716,7 @@ const struct file_operations cifs_file_direct_nobrl_ops = {
 	.flush = cifs_flush,
 	.splice_read = generic_file_splice_read,
 #ifdef CONFIG_CIFS_POSIX
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl  = cifs_ioctl,
 #endif /* CONFIG_CIFS_POSIX */
 	.llseek = cifs_llseek,
 #ifdef CONFIG_CIFS_EXPERIMENTAL
@@ -731,7 +731,7 @@ const struct file_operations cifs_dir_ops = {
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	.dir_notify = cifs_dir_notify,
 #endif /* CONFIG_CIFS_EXPERIMENTAL */
-	.ioctl  = cifs_ioctl,
+	.unlocked_ioctl  = cifs_ioctl,
 };
 
 static void
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index cd1301a..1312ae7 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -95,8 +95,8 @@ extern int 	cifs_setxattr(struct dentry *, const char *, const void *,
 			size_t, int);
 extern ssize_t	cifs_getxattr(struct dentry *, const char *, void *, size_t);
 extern ssize_t	cifs_listxattr(struct dentry *, char *, size_t);
-extern int cifs_ioctl(struct inode *inode, struct file *filep,
-		       unsigned int command, unsigned long arg);
+extern long cifs_ioctl(struct file *filep, unsigned int command,
+							unsigned long arg);
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 extern const struct export_operations cifs_export_ops;
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 5c792df..396811f 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/smp_lock.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -30,9 +31,9 @@
 
 #define CIFS_IOC_CHECKUMOUNT _IO(0xCF, 2)
 
-int cifs_ioctl(struct inode *inode, struct file *filep,
-		unsigned int command, unsigned long arg)
+long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 {
+	struct inode *inode = filep->f_path.dentry->d_inode;
 	int rc = -ENOTTY; /* strange error - but the precedent */
 	int xid;
 	struct cifs_sb_info *cifs_sb;
@@ -45,6 +46,8 @@ int cifs_ioctl(struct inode *inode, struct file *filep,
 		(struct cifsFileInfo *)filep->private_data;
 #endif /* CONFIG_CIFS_POSIX */
 
+	lock_kernel();
+
 	xid = GetXid();
 
 	cFYI(1, ("ioctl file %p  cmd %u  arg %lu", filep, command, arg));
@@ -58,6 +61,7 @@ int cifs_ioctl(struct inode *inode, struct file *filep,
 	else {
 		rc = -EIO;
 		FreeXid(xid);
+		unlock_kernel();
 		return -EIO;
 	}
 #endif /* CONFIG_CIFS_POSIX */
@@ -106,5 +110,6 @@ int cifs_ioctl(struct inode *inode, struct file *filep,
 	}
 
 	FreeXid(xid);
+	unlock_kernel();
 	return rc;
 }
