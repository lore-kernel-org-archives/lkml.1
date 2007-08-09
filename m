Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbXHIPak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbXHIPak (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937890AbXHIP3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:29:46 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:40606 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756917AbXHIP3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:29:43 -0400
Message-Id: <20070809152905.362102628@szeredi.hu>
References: <20070809152744.519270818@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 09 Aug 2007 17:27:47 +0200
From: miklos@szeredi.hu
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@ftp.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>
Subject: [RFC PATCH 3/4] allow filesystems to implement atomic open+truncate
Content-Disposition: inline; filename=vfs_atomic_open_truncate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
initiated by open() due to the O_TRUNC flag".

This way filesystems wanting to implement truncation within their
->open() method can ignore such truncate requests.

This is a quick & dirty hack, but it comes for free.

When (if) we implement a proper low-level open+create+truncate inode
operation, this can go away.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c	2007-08-09 16:47:30.000000000 +0200
+++ linux/fs/namei.c	2007-08-09 16:49:07.000000000 +0200
@@ -1655,8 +1655,10 @@ int may_open(struct nameidata *nd, int a
 		error = locks_verify_locked(inode);
 		if (!error) {
 			DQUOT_INIT(inode);
-			
-			error = do_truncate(dentry, 0, ATTR_MTIME|ATTR_CTIME, NULL);
+
+			error = do_truncate(dentry, 0,
+					    ATTR_MTIME|ATTR_CTIME|ATTR_OPEN,
+					    NULL);
 		}
 		put_write_access(inode);
 		if (error)
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-08-09 16:48:45.000000000 +0200
+++ linux/include/linux/fs.h	2007-08-09 16:49:07.000000000 +0200
@@ -335,6 +335,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SUID	2048
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
+#define ATTR_OPEN	16384	/* Truncating from open(O_TRUNC) */
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
@@ -1521,7 +1522,7 @@ static inline int break_lease(struct ino
 
 /* fs/open.c */
 
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
+extern int do_truncate(struct dentry *, loff_t start, unsigned int attrs,
 		       struct file *filp);
 extern long do_sys_open(int fdf, const char __user *filename, int flags,
 			int mode);
Index: linux/fs/open.c
===================================================================
--- linux.orig/fs/open.c	2007-08-09 16:48:43.000000000 +0200
+++ linux/fs/open.c	2007-08-09 16:49:07.000000000 +0200
@@ -194,7 +194,7 @@ out:
 	return error;
 }
 
-int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
+int do_truncate(struct dentry *dentry, loff_t length, unsigned int attrs,
 	struct file *filp)
 {
 	int err;
@@ -205,7 +205,7 @@ int do_truncate(struct dentry *dentry, l
 		return -EINVAL;
 
 	newattrs.ia_size = length;
-	newattrs.ia_valid = ATTR_SIZE | time_attrs;
+	newattrs.ia_valid = ATTR_SIZE | attrs;
 	if (filp) {
 		newattrs.ia_file = filp;
 		newattrs.ia_valid |= ATTR_FILE;

--
