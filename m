Return-Path: <linux-kernel-owner+w=401wt.eu-S1755710AbXJBRzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbXJBRzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbXJBRzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:55:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45536 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbXJBRzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:55:18 -0400
Date: Tue, 2 Oct 2007 19:55:16 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, linux-fsdevel@vger.kernel.org
Subject: [patch 2/2] getattr - fill the size of FIFOs
In-Reply-To: <Pine.LNX.4.64.0710021952450.7130@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710021954550.7130@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710021952450.7130@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH]: Fill the size of FIFOs

Instead of reporting 0 in size when stating() a pipe, we give the number of
queued bytes. This might avoid using ioctl(FIONREAD) to get this information.

References: http://lkml.org/lkml/2007/4/2/138
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 fs/pipe.c                 |   20 +++-----------------
 fs/stat.c                 |   14 ++++++++++----
 include/linux/pipe_fs_i.h |    2 ++
 3 files changed, 15 insertions(+), 21 deletions(-)

Index: linux-2.6.23/fs/pipe.c
===================================================================
--- linux-2.6.23.orig/fs/pipe.c
+++ linux-2.6.23/fs/pipe.c
@@ -577,14 +577,15 @@ bad_pipe_w(struct file *filp, const char
 	return -EBADF;
 }
 
-static unsigned int pipe_size(struct inode *inode)
+unsigned int pipe_size(struct inode *inode)
 {
 	struct pipe_inode_info *pipe;
 	unsigned int count, buf;
 	int nrbufs;
 
+	if ((pipe = inode->i_pipe) == NULL)
+		return 0;
 	mutex_lock(&inode->i_mutex);
-	pipe   = inode->i_pipe;
 	count  = 0;
 	buf    = pipe->curbuf;
 	nrbufs = pipe->nrbufs;
@@ -923,20 +924,6 @@ static struct dentry_operations pipefs_d
 	.d_dname	= pipefs_dname,
 };
 
-int pipe_getattr(struct vfsmount *mnt, struct dentry *dentry,
-                 struct kstat *stat)
-{
-	struct inode *inode = dentry->d_inode;
-
-	generic_fillattr(inode, stat);
-	stat->size = pipe_size(inode);
-	return 0;
-}
-
-const struct inode_operations pipe_inode_operations = {
-	.getattr = pipe_getattr,
-};
-
 static struct inode * get_pipe_inode(void)
 {
 	struct inode *inode = new_inode(pipe_mnt->mnt_sb);
@@ -950,7 +937,6 @@ static struct inode * get_pipe_inode(voi
 		goto fail_iput;
 	inode->i_pipe = pipe;
 
-	inode->i_op = &pipe_inode_operations;
 	pipe->readers = pipe->writers = 1;
 	inode->i_fop = &rdwr_pipe_fops;
 
Index: linux-2.6.23/fs/stat.c
===================================================================
--- linux-2.6.23.orig/fs/stat.c
+++ linux-2.6.23/fs/stat.c
@@ -11,6 +11,7 @@
 #include <linux/highuid.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
+#include <linux/pipe_fs_i.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/pagemap.h>
@@ -46,11 +47,16 @@ int vfs_getattr(struct vfsmount *mnt, st
 	if (retval)
 		return retval;
 
-	if (inode->i_op->getattr)
-		return inode->i_op->getattr(mnt, dentry, stat);
+	if (inode->i_op->getattr) {
+		retval = inode->i_op->getattr(mnt, dentry, stat);
+	} else {
+		generic_fillattr(inode, stat);
+		retval = 0;
+	}
 
-	generic_fillattr(inode, stat);
-	return 0;
+	if (retval == 0 && S_ISFIFO(inode->i_mode))
+		stat->size = pipe_size(inode);
+	return retval;
 }
 
 EXPORT_SYMBOL(vfs_getattr);
Index: linux-2.6.23/include/linux/pipe_fs_i.h
===================================================================
--- linux-2.6.23.orig/include/linux/pipe_fs_i.h
+++ linux-2.6.23/include/linux/pipe_fs_i.h
@@ -134,6 +134,8 @@ struct pipe_buf_operations {
    memory allocation, whereas PIPE_BUF makes atomicity guarantees.  */
 #define PIPE_SIZE		PAGE_SIZE
 
+extern unsigned int pipe_size(struct inode *);
+
 /* Drop the inode semaphore and wait for a pipe event, atomically */
 void pipe_wait(struct pipe_inode_info *pipe);
 
