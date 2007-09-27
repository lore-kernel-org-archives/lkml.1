Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbXI0SxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbXI0SxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757139AbXI0SwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:52:21 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38403 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890AbXI0SwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:52:20 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 27 Sep 2007 11:52:18 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] anon-inodes use open coded atomic_inc for the shared inode
Message-ID: <Pine.LNX.4.64.0709271147300.763@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since we know the shared inode count is always >0, we can avoid igrab() 
and use an open coded atomic_inc().


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 fs/anon_inodes.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

Index: linux-2.6.mod/fs/anon_inodes.c
===================================================================
--- linux-2.6.mod.orig/fs/anon_inodes.c	2007-09-27 11:26:57.000000000 -0700
+++ linux-2.6.mod/fs/anon_inodes.c	2007-09-27 11:51:42.000000000 -0700
@@ -76,7 +76,6 @@
 {
 	struct qstr this;
 	struct dentry *dentry;
-	struct inode *inode;
 	struct file *file;
 	int error, fd;
 
@@ -86,15 +85,9 @@
 	if (!file)
 		return -ENFILE;
 
-	inode = igrab(anon_inode_inode);
-	if (IS_ERR(inode)) {
-		error = PTR_ERR(inode);
-		goto err_put_filp;
-	}
-
 	error = get_unused_fd();
 	if (error < 0)
-		goto err_iput;
+		goto err_put_filp;
 	fd = error;
 
 	/*
@@ -108,14 +101,22 @@
 	dentry = d_alloc(anon_inode_mnt->mnt_sb->s_root, &this);
 	if (!dentry)
 		goto err_put_unused_fd;
+
+	/*
+	 * We know the anon_inode inode count is always greater than zero,
+	 * so we can avoid doing an igrab() and we can use an open-coded
+	 * atomic_inc().
+	 */
+	atomic_inc(&anon_inode_inode->i_count);
+
 	dentry->d_op = &anon_inodefs_dentry_operations;
 	/* Do not publish this dentry inside the global dentry hash table */
 	dentry->d_flags &= ~DCACHE_UNHASHED;
-	d_instantiate(dentry, inode);
+	d_instantiate(dentry, anon_inode_inode);
 
 	file->f_path.mnt = mntget(anon_inode_mnt);
 	file->f_path.dentry = dentry;
-	file->f_mapping = inode->i_mapping;
+	file->f_mapping = anon_inode_inode->i_mapping;
 
 	file->f_pos = 0;
 	file->f_flags = O_RDWR;
@@ -127,14 +128,12 @@
 	fd_install(fd, file);
 
 	*pfd = fd;
-	*pinode = inode;
+	*pinode = anon_inode_inode;
 	*pfile = file;
 	return 0;
 
 err_put_unused_fd:
 	put_unused_fd(fd);
-err_iput:
-	iput(inode);
 err_put_filp:
 	put_filp(file);
 	return error;
