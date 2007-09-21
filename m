Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbXIUMei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbXIUMei (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXIUMeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:34:04 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:45011 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbXIUMeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:34:01 -0400
Message-Id: <20070921123334.643828369@szeredi.hu>
References: <20070921122343.307289079@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 21 Sep 2007 14:23:47 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [patch 4/5] VFS: allow filesystems to implement atomic open+truncate
Content-Disposition: inline; filename=vfs_atomic_open_truncate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new attribute flag ATTR_OPEN, with the meaning: "truncation was
initiated by open() due to the O_TRUNC flag".

This way filesystems wanting to implement truncation within their
->open() method can ignore such truncate requests.

This is a quick & dirty hack, but it comes for free.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c	2007-09-21 13:44:53.000000000 +0200
+++ linux/fs/namei.c	2007-09-21 13:45:14.000000000 +0200
@@ -1656,8 +1656,10 @@ int may_open(struct nameidata *nd, int a
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
--- linux.orig/include/linux/fs.h	2007-09-21 13:45:11.000000000 +0200
+++ linux/include/linux/fs.h	2007-09-21 13:45:14.000000000 +0200
@@ -337,6 +337,7 @@ typedef void (dio_iodone_t)(struct kiocb
 #define ATTR_KILL_SGID	4096
 #define ATTR_FILE	8192
 #define ATTR_KILL_PRIV	16384
+#define ATTR_OPEN	32768	/* Truncating from open(O_TRUNC) */
 
 /*
  * This is the Inode Attributes structure, used for notify_change().  It
@@ -1526,7 +1527,7 @@ static inline int break_lease(struct ino
 
 /* fs/open.c */
 
-extern int do_truncate(struct dentry *, loff_t start, unsigned int time_attrs,
+extern int do_truncate(struct dentry *, loff_t start, unsigned int attrs,
 		       struct file *filp);
 extern long do_sys_open(int fdf, const char __user *filename, int flags,
 			int mode);
Index: linux/fs/open.c
===================================================================
--- linux.orig/fs/open.c	2007-09-21 13:45:04.000000000 +0200
+++ linux/fs/open.c	2007-09-21 13:45:14.000000000 +0200
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
