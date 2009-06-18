Return-Path: <linux-kernel-owner+w=401wt.eu-S1762888AbZFRGzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762888AbZFRGzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 02:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761117AbZFRGzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 02:55:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:47172 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZFRGzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 02:55:43 -0400
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
Subject: [RFC] O_NOACC: open without any access
Message-Id: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 18 Jun 2009 08:55:37 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a new open flag that doesn't require any access on the file.
It works on any file type including symlinks.

The sole purpose is to help race free "userspace lookup" type
operations.  So fstat, fch*, *at work but nothing else.  Filesystem's
->open() is not called and f_op is set to NULL.

It would be logical to reuse the open_flag=3 value, but that has
historically been used with different semantics so I'm afraid of
touching it.

Not sure if it's a good base for what AFS/pioctl is trying to do, but
it's something that I personally would very much like to see.

Comments?

Thanks,
Miklos

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2009-06-12 09:30:49.000000000 +0200
+++ linux-2.6/fs/namei.c	2009-06-18 08:16:55.000000000 +0200
@@ -1651,6 +1651,38 @@ static int open_will_write_to_fs(int fla
 	return (flag & O_TRUNC);
 }
 
+static struct file *open_noaccess(int dfd, const char *name, int flags)
+{
+	int err;
+	struct nameidata nd;
+	struct file *filp = get_empty_filp();
+	struct inode *inode;
+
+	err = -ENFILE;
+	if (filp == NULL)
+		goto out_err;
+
+	err = do_path_lookup(dfd, name, lookup_flags(flags), &nd);
+	if (err)
+		goto out_put_filp;
+
+	inode = nd.path.dentry->d_inode;
+	filp->f_flags = flags & (O_NOACC | O_NOFOLLOW | O_DIRECTORY);
+	filp->f_mode = 0;
+	filp->f_mapping = inode->i_mapping;
+	filp->f_path = nd.path;
+	filp->f_pos = 0;
+	filp->f_op = NULL;
+	file_move(filp, &inode->i_sb->s_files);
+
+	return filp;
+
+out_put_filp:
+	put_filp(filp);
+out_err:
+	return ERR_PTR(err);
+}
+
 /*
  * Note that the low bits of the passed in "open_flag"
  * are not the same as in the local variable "flag". See
@@ -1668,6 +1700,9 @@ struct file *do_filp_open(int dfd, const
 	int will_write;
 	int flag = open_to_namei_flags(open_flag);
 
+	if (flag & O_NOACC)
+		return open_noaccess(dfd, pathname, open_flag);
+
 	if (!acc_mode)
 		acc_mode = MAY_OPEN | ACC_MODE(flag);
 
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h	2009-05-20 14:12:00.000000000 +0200
+++ linux-2.6/include/asm-generic/fcntl.h	2009-06-18 07:16:29.000000000 +0200
@@ -51,6 +51,9 @@
 #ifndef O_CLOEXEC
 #define O_CLOEXEC	02000000	/* set close_on_exec */
 #endif
+#ifndef O_NOACC
+#define O_NOACC		04000000	/* open without any access */
+#endif
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
