Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXKIVF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXKIVF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 16:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXKIVFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 16:05:12 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:53040 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbXKIVFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 16:05:10 -0500
Subject: [PATCH 1/2] create file_drop_write_access() helper
To: ezk@cs.sunysb.edu
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 09 Nov 2007 13:04:39 -0800
Message-Id: <20071109210439.122065A3@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These should fix the bug that Erez Zadok <ezk@cs.sunysb.edu>
reported:

Stopping RPC idmapd:

kernel: __fput() of writeable file with no mnt_want_write()
kernel: WARNING: at fs/file_table.c:262 __fput()
kernel:  [<c010283e>] show_trace_log_lvl+0x12/0x25
kernel:  [<c0103042>] show_trace+0xd/0x10
...

The actual bug was a missed mnt_want_write() when a
filp was allocated with get_empty_filp() and then
made writable.  Using alloc_file(), instead, fixes
that.

--

If someone decides to demote a file from r/w to just
r/o, they can use this same code as __fput().

NFS does just that, and will use this in the next
patch.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/file_table.c      |   46 +++++++++++++++++++++-----------
 linux-2.6.git-dave/include/linux/file.h |    1 
 2 files changed, 32 insertions(+), 15 deletions(-)

diff -puN fs/file_table.c~create-file_drop_write_access fs/file_table.c
--- linux-2.6.git/fs/file_table.c~create-file_drop_write_access	2007-11-09 12:12:44.000000000 -0800
+++ linux-2.6.git-dave/fs/file_table.c	2007-11-09 12:39:27.000000000 -0800
@@ -223,6 +223,34 @@ void fastcall fput(struct file *file)
 
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
+	struct vfsmount *mnt = file->f_path.mnt;
+	struct inode *inode = dentry->d_inode;
+
+	put_write_access(inode);
+	if (!special_file(inode->i_mode)) {
+		if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
+			mnt_drop_write(mnt);
+			file->f_mnt_write_state |= FILE_MNT_WRITE_RELEASED;
+		} else {
+			printk(KERN_WARNING "dropping write access on "
+					"file with no mnt_want_write()\n");
+			WARN_ON(1);
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(drop_file_write_access);
+
 /* __fput is called from task context when aio completion releases the last
  * last use of a struct file *.  Do not use otherwise.
  */
@@ -248,21 +276,9 @@ void fastcall __fput(struct file *file)
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
 	fops_put(file->f_op);
-	if (file->f_mode & FMODE_WRITE) {
-		put_write_access(inode);
-		if (!special_file(inode->i_mode)) {
-			if (file->f_mnt_write_state == FILE_MNT_WRITE_TAKEN) {
-				mnt_drop_write(mnt);
-				file->f_mnt_write_state |=
-					FILE_MNT_WRITE_RELEASED;
-			} else {
-				printk(KERN_WARNING "__fput() of writeable "
-						"file with no "
-						"mnt_want_write()\n");
-				WARN_ON(1);
-			}
-		}
-	}
+	if (file->f_mode & FMODE_WRITE)
+		drop_file_write_access(file);
+
 	put_pid(file->f_owner.pid);
 	file_kill(file);
 	file->f_path.dentry = NULL;
diff -puN include/linux/file.h~create-file_drop_write_access include/linux/file.h
--- linux-2.6.git/include/linux/file.h~create-file_drop_write_access	2007-11-09 12:12:44.000000000 -0800
+++ linux-2.6.git-dave/include/linux/file.h	2007-11-09 12:12:44.000000000 -0800
@@ -61,6 +61,7 @@ extern struct kmem_cache *filp_cachep;
 
 extern void FASTCALL(__fput(struct file *));
 extern void FASTCALL(fput(struct file *));
+extern void drop_file_write_access(struct file *file);
 
 struct file_operations;
 struct vfsmount;
_
