Return-Path: <linux-kernel-owner+w=401wt.eu-S1762259AbYEVVYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbYEVVYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935353AbYEVVXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:23:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45197 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764722AbYEVVXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:23:32 -0400
Date: Thu, 22 May 2008 22:10:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, dwmw2@redhat.com
Subject: [PATCH] jffs2: eliminate BKL on ioctl
Message-ID: <20080522221050.0a251a9e@core>
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

As the ioctl does nothing right now its easy to get the locking right 8)

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index c0c141f..dd784df 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -36,10 +36,10 @@ static int jffs2_rename (struct inode *, struct dentry *,
 
 const struct file_operations jffs2_dir_operations =
 {
-	.read =		generic_read_dir,
-	.readdir =	jffs2_readdir,
-	.ioctl =	jffs2_ioctl,
-	.fsync =	jffs2_fsync
+	.read		=	generic_read_dir,
+	.readdir	=	jffs2_readdir,
+	.unlocked_ioctl =	jffs2_ioctl,
+	.fsync		=	jffs2_fsync
 };
 
 
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 5e92034..5b298b9 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -46,7 +46,7 @@ const struct file_operations jffs2_file_operations =
  	.aio_read =	generic_file_aio_read,
  	.write =	do_sync_write,
  	.aio_write =	generic_file_aio_write,
-	.ioctl =	jffs2_ioctl,
+	.unlocked_ioctl = jffs2_ioctl,
 	.mmap =		generic_file_readonly_mmap,
 	.fsync =	jffs2_fsync,
 	.splice_read =	generic_file_splice_read,
diff --git a/fs/jffs2/ioctl.c b/fs/jffs2/ioctl.c
index e217721..9d41f43 100644
--- a/fs/jffs2/ioctl.c
+++ b/fs/jffs2/ioctl.c
@@ -12,8 +12,7 @@
 #include <linux/fs.h>
 #include "nodelist.h"
 
-int jffs2_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-		unsigned long arg)
+long jffs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	/* Later, this will provide for lsattr.jffs2 and chattr.jffs2, which
 	   will include compression support etc. */
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index 2cc866c..5e194a5 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -167,7 +167,7 @@ int jffs2_fsync(struct file *, struct dentry *, int);
 int jffs2_do_readpage_unlock (struct inode *inode, struct page *pg);
 
 /* ioctl.c */
-int jffs2_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+long jffs2_ioctl(struct file *, unsigned int, unsigned long);
 
 /* symlink.c */
 extern const struct inode_operations jffs2_symlink_inode_operations;
