Return-Path: <linux-kernel-owner+w=401wt.eu-S1765863AbYBOWmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765863AbYBOWmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:42:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764029AbYBOWho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:44 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35861 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762301AbYBOWhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:35 -0500
Subject: [PATCH 08/30] r/o bind mounts: create helper to drop file write access
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:31 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223731.EF3A91FA@kernel>
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
Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---

 linux-2.6.git-dave/fs/file_table.c      |   19 ++++++++++++++++++-
 linux-2.6.git-dave/fs/nfsd/nfs4state.c  |    3 ++-
 linux-2.6.git-dave/include/linux/file.h |    1 +
 3 files changed, 21 insertions(+), 2 deletions(-)

diff -puN fs/file_table.c~create-file_drop_write_access-helper fs/file_table.c
--- linux-2.6.git/fs/file_table.c~create-file_drop_write_access-helper	2008-02-15 13:25:46.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2008-02-15 13:25:46.000000000 -0800
@@ -211,6 +211,23 @@ void fput(struct file *file)
 
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
@@ -237,7 +254,7 @@ void __fput(struct file *file)
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
 	if (file->f_mode & FMODE_WRITE)
-		put_write_access(inode);
+		drop_file_write_access(file);
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN fs/nfsd/nfs4state.c~create-file_drop_write_access-helper fs/nfsd/nfs4state.c
--- linux-2.6.git/fs/nfsd/nfs4state.c~create-file_drop_write_access-helper	2008-02-15 13:25:46.000000000 -0800
+++ linux-2.6.git-dave/fs/nfsd/nfs4state.c	2008-02-15 13:25:46.000000000 -0800
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
--- linux-2.6.git/include/linux/file.h~create-file_drop_write_access-helper	2008-02-15 13:25:46.000000000 -0800
+++ linux-2.6.git-dave/include/linux/file.h	2008-02-15 13:25:46.000000000 -0800
@@ -61,6 +61,7 @@ extern struct kmem_cache *filp_cachep;
 
 extern void __fput(struct file *);
 extern void fput(struct file *);
+extern void drop_file_write_access(struct file *file);
 
 struct file_operations;
 struct vfsmount;
_
