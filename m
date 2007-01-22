Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXAVUN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXAVUN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 15:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXAVUN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 15:13:27 -0500
Received: from allen.werkleitz.de ([80.190.251.108]:53803 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbXAVUN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 15:13:26 -0500
Date: Mon, 22 Jan 2007 21:13:17 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Jeff Dike <jdike@karaya.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Message-ID: <20070122201317.GA8594@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 84.190.171.25
Subject: [PATCH] [UML] fix mknod
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I was playing with user-mode Linux and found that mknod creates
devices node in hostfs with wrong major/minor numbers.
The patch below fixes it for me.

Johannes


---
mknod() is broken on UML because userspace has differernt
dev_t size and encoding than kernel.

Signed-off-by: Johannes Stezenbach <js@linuxtv.org>


diff -rup linux-2.6.19.orig/fs/hostfs/hostfs.h linux-2.6.19/fs/hostfs/hostfs.h
--- linux-2.6.19.orig/fs/hostfs/hostfs.h	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.19/fs/hostfs/hostfs.h	2007-01-22 20:53:23.000000000 +0100
@@ -76,7 +76,17 @@ extern int make_symlink(const char *from
 extern int unlink_file(const char *file);
 extern int do_mkdir(const char *file, int mode);
 extern int do_rmdir(const char *file);
-extern int do_mknod(const char *file, int mode, int dev);
+
+/* gnu_dev_makedev from glibc's sys/sysmacros.h */
+static inline unsigned long long makedev(unsigned int major, unsigned int minor)
+{
+	return ((minor & 0xff) | ((major & 0xfff) << 8)
+		| (((unsigned long long int) (minor & ~0xff)) << 12)
+		| (((unsigned long long int) (major & ~0xfff)) << 32));
+
+}
+
+extern int do_mknod(const char *file, int mode, unsigned long long dev);
 extern int link_file(const char *from, const char *to);
 extern int do_readlink(char *file, char *buf, int size);
 extern int rename_file(char *from, char *to);
diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_kern.c linux-2.6.19/fs/hostfs/hostfs_kern.c
--- linux-2.6.19.orig/fs/hostfs/hostfs_kern.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.19/fs/hostfs/hostfs_kern.c	2007-01-22 20:57:58.000000000 +0100
@@ -740,6 +740,7 @@ int hostfs_mknod(struct inode *dir, stru
 	struct inode *inode;
 	char *name;
 	int err = -ENOMEM;
+	unsigned long long udev;
 
 	inode = iget(dir->i_sb, 0);
 	if(inode == NULL)
@@ -755,7 +756,9 @@ int hostfs_mknod(struct inode *dir, stru
 		goto out_put;
 
 	init_special_inode(inode, mode, dev);
-	err = do_mknod(name, mode, dev);
+	/* userspace has different dev_t encoding than kernel... */
+	udev = makedev(MAJOR(dev), MINOR(dev));
+	err = do_mknod(name, mode, udev);
 	if(err)
 		goto out_free;
 
diff -rup linux-2.6.19.orig/fs/hostfs/hostfs_user.c linux-2.6.19/fs/hostfs/hostfs_user.c
--- linux-2.6.19.orig/fs/hostfs/hostfs_user.c	2006-11-29 22:57:37.000000000 +0100
+++ linux-2.6.19/fs/hostfs/hostfs_user.c	2007-01-22 20:54:37.000000000 +0100
@@ -295,7 +295,7 @@ int do_rmdir(const char *file)
 	return(0);
 }
 
-int do_mknod(const char *file, int mode, int dev)
+int do_mknod(const char *file, int mode, unsigned long long dev)
 {
 	int err;
 
