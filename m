Return-Path: <linux-kernel-owner+w=401wt.eu-S1765089AbXJTKLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765089AbXJTKLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 06:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756453AbXJTKLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 06:11:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:38555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755647AbXJTKK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 06:10:58 -0400
Message-Id: <20071020101327.544544965@X40.localnet>
References: <20071020100903.717837398@X40.localnet>
User-Agent: quilt/0.46-62.1
Date: Sat, 20 Oct 2007 12:09:04 +0200
From: Jan Blunck <jblunck@suse.de>
To: Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: [RFC 1/2] i_op->readdir: Change readdir() to be an inode operation
Content-Disposition: inline; filename=vfs/readdir-inode_operation.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new readdir() inode operation. The purpose of this patch is
to enable the VFS to support directory reading on a stack of directories. The
new interface isn't passing the struct file to the filesystem implementation
anymore. Normally the filesystem implementation shouldn't depend on any
information in struct file except for the dentry, the cookie (f_pos) and the
users credentials.

The new interface for the readdir inode operation is as follows:

int (*readdir) (struct dentry *dentry, loff_t *pos, void *private,
                filldir_t filler, void *dirent);

@dentry: the dentry of the directory
@pos: pointer to the cookie
@private: the credentials (at the moment it is still filp->private_data
@filler: the filldir to call
@dirent: the dirent buffer

Signed-off-by: Jan Blunck <jblunck@suse.de>
---
 fs/readdir.c       |   14 ++++++++++++--
 include/linux/fs.h |    2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

Index: b/fs/readdir.c
===================================================================
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -16,6 +16,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
+#include <linux/kallsyms.h>
 
 #include <asm/uaccess.h>
 
@@ -23,7 +24,8 @@ int vfs_readdir(struct file *file, filld
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
-	if (!file->f_op || !file->f_op->readdir)
+	if ((!file->f_op || !file->f_op->readdir) &&
+	    (!inode->i_op || !inode->i_op->readdir))
 		goto out;
 
 	res = security_file_permission(file, MAY_READ);
@@ -33,7 +35,15 @@ int vfs_readdir(struct file *file, filld
 	mutex_lock(&inode->i_mutex);
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
-		res = file->f_op->readdir(file, buf, filler);
+		if (inode->i_op->readdir) {
+			printk(KERN_DEBUG "i_op->readdir @ ");
+			print_ip_sym((unsigned long)inode->i_op);
+			res = inode->i_op->readdir(file->f_path.dentry,
+						   &file->f_pos,
+						   file->private_data,
+						   filler, buf);
+		} else
+			res = file->f_op->readdir(file, buf, filler);
 		file_accessed(file);
 	}
 	mutex_unlock(&inode->i_mutex);
Index: b/include/linux/fs.h
===================================================================
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1214,6 +1214,8 @@ struct inode_operations {
 	int (*mkdir) (struct inode *,struct dentry *,int);
 	int (*rmdir) (struct inode *,struct dentry *);
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
+	/* readdir(dentry, position, private/credential, filler, buffer) */
+	int (*readdir) (struct dentry *, loff_t *, void *, filldir_t, void *);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
 	int (*readlink) (struct dentry *, char __user *,int);

-- 

