Return-Path: <linux-kernel-owner+w=401wt.eu-S1760496AbYBHWbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760496AbYBHWbO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbYBHW1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:27:07 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:55369 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113AbYBHW1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:27:01 -0500
Subject: [RFC][PATCH 08/30] r/o bind mounts: create helper to drop file write access
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, viro@ZenIV.linux.org.uk, viro@ftp.linux.org.uk,
       miklos@szeredi.hu, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 08 Feb 2008 14:26:57 -0800
References: <20080208222641.6024A7CC@kernel>
In-Reply-To: <20080208222641.6024A7CC@kernel>
Message-Id: <20080208222657.0CA60A96@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If someone decides to demote a file from r/w to just
r/o, they can use this same code as __fput().

NFS does just that, and will use this in the next
patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/file_table.c      |   19 ++++++++++++++++++-
 linux-2.6.git-dave/fs/nfsd/nfs4state.c  |    3 ++-
 linux-2.6.git-dave/include/linux/file.h |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff -puN fs/file_table.c~create-file_drop_write_access-helper fs/file_table.c
--- linux-2.6.git/fs/file_table.c~create-file_drop_write_access-helper	2008-02-08 13:04:48.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2008-02-08 13:04:48.000000000 -0800
@@ -211,6 +211,23 @@ void fastcall fput(struct file *file)
 
 EXPORT_SYMBOL(fput);
 
+/**
+ * drop_file_write_access - give up ability to write to a file
+ * @file: the file to which we will stop writing
+ *
+ * This is a central place which will give up the ability
+ * to write to @file, along with access to write through
+ * its vfsmount.
+ */
+void drop_file_write_access(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct inode *inode = dentry->d_inode;
+
+	put_write_access(inode);
+}
+EXPORT_SYMBOL_GPL(drop_file_write_access);
+
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
@@ -237,7 +254,7 @@ void fastcall __fput(struct file *file)
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE)
-		put_write_access(inode);
+		drop_file_write_access(file);
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN fs/nfsd/nfs4state.c~create-file_drop_write_access-helper fs/nfsd/nfs4state.c
--- linux-2.6.git/fs/nfsd/nfs4state.c~create-file_drop_write_access-helper	2008-02-08 13:04:48.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/nfs4state.c	2008-02-08 13:04:48.000000000 -0800
@@ -41,6 +41,7 @@
 #include <linux/sunrpc/svc.h>
 #include <linux/nfsd/nfsd.h>
 #include <linux/nfsd/cache.h>
+#include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/workqueue.h>
 #include <linux/smp_lock.h>
@@ -1239,7 +1240,7 @@ static inline void
 nfs4_file_downgrade(struct file *filp, unsigned int share_access)
 {
 	if (share_access & NFS4_SHARE_ACCESS_WRITE) {
-		put_write_access(filp->f_path.dentry->d_inode);
+		drop_file_write_access(filp);
 		filp->f_mode = (filp->f_mode | FMODE_READ) & ~FMODE_WRITE;
 	}
 }
diff -puN include/linux/file.h~create-file_drop_write_access-helper include/linux/file.h
--- linux-2.6.git/include/linux/file.h~create-file_drop_write_access-helper	2008-02-08 13:04:48.000000000 -0800
+++ linux-2.6.git-dave/include/linux/file.h	2008-02-08 13:04:48.000000000 -0800
@@ -61,6 +61,7 @@ extern struct kmem_cache *filp_cachep;
 
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
+extern void drop_file_write_access(struct file *file);
 
 struct file_operations;
 struct vfsmount;
_
