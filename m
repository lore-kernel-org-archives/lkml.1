Return-Path: <linux-kernel-owner+w=401wt.eu-S1755978AbYCRBKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbYCRBKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYCRBJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:09:45 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:29992 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbYCRBJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:09:38 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080318209.039112899@firstfloor.org>
In-Reply-To: <20080318209.039112899@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH prototype] [2/8] Add support to override mmap exec write protection with O_FORCEWRITE
Message-Id: <20080318010936.489811B41E1@basil.firstfloor.org>
Date: Tue, 18 Mar 2008 02:09:36 +0100 (CET)
X-OriginalArrivalTime: 18 Mar 2008 01:03:01.0580 (UTC) FILETIME=[D044D0C0:01C88893]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


pbitmaps need to write to files mapped as executable, so add 
a way to bypass the normal write protection using a new O_FORCEWRITE
flag.

Right now the flag can be set from user space too. If have not
made up my mind if that is a good or a bad thing (I don't think
it has any real security implications). Probably it's more bad
than good. 

Signed-off-by: Andi Kleen <andi@firstfloor.org>

---
 fs/namei.c                  |    9 +++++++--
 fs/open.c                   |    2 +-
 include/asm-generic/fcntl.h |    4 ++++
 include/linux/fs.h          |    1 +
 4 files changed, 13 insertions(+), 3 deletions(-)

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c
+++ linux/fs/namei.c
@@ -334,10 +334,10 @@ int file_permission(struct file *file, i
  * the inode->i_lock spinlock.
  */
 
-int get_write_access(struct inode * inode)
+int __get_write_access(struct inode * inode, int flags)
 {
 	spin_lock(&inode->i_lock);
-	if (atomic_read(&inode->i_writecount) < 0) {
+	if (atomic_read(&inode->i_writecount) < 0 && !(flags&O_FORCEWRITE)) {
 		spin_unlock(&inode->i_lock);
 		return -ETXTBSY;
 	}
@@ -347,6 +347,11 @@ int get_write_access(struct inode * inod
 	return 0;
 }
 
+int get_write_access(struct inode * inode)
+{
+	return __get_write_access(inode, 0);
+}
+
 int deny_write_access(struct file * file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
Index: linux/fs/open.c
===================================================================
--- linux.orig/fs/open.c
+++ linux/fs/open.c
@@ -742,7 +742,7 @@ static struct file *__dentry_open(struct
 				FMODE_PREAD | FMODE_PWRITE;
 	inode = dentry->d_inode;
 	if (f->f_mode & FMODE_WRITE) {
-		error = get_write_access(inode);
+		error = __get_write_access(inode, f->f_flags & O_FORCEWRITE);
 		if (error)
 			goto cleanup_file;
 	}
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h
+++ linux/include/linux/fs.h
@@ -1720,6 +1720,7 @@ extern int generic_permission(struct ino
 		int (*check_acl)(struct inode *, int));
 
 extern int get_write_access(struct inode *);
+extern int __get_write_access(struct inode *i, int flags);
 extern int deny_write_access(struct file *);
 static inline void put_write_access(struct inode * inode)
 {
Index: linux/include/asm-generic/fcntl.h
===================================================================
--- linux.orig/include/asm-generic/fcntl.h
+++ linux/include/asm-generic/fcntl.h
@@ -54,6 +54,10 @@
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
+/* ignore ETXTBSY -- should probably hide it from user space */
+#ifndef O_FORCEWRITE
+#define O_FORCEWRITE    02000000
+#endif
 
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
