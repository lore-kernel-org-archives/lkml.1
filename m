Return-Path: <linux-kernel-owner+w=401wt.eu-S1751653AbXA3Piy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbXA3Piy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXA3Piy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:38:54 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbXA3Piw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:38:52 -0500
Date: Tue, 30 Jan 2007 10:38:25 -0500
Message-Id: <200701301538.l0UFcPkb027719@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 2/2] make pipefs do lazy i_ino assignment and hashing
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dada1@cosmosbay.com, dev@openvz.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates pipefs to do defer assigning an i_ino value to its inodes
until someone actually tries to stat it. This allows us to have unique i_ino
values for the inodes here, without the performance impact for anyone who
doesn't actually care about it.

Since we don't have an i_ino value at pipe creation time, we need something
else to stuff into the dentry name. Here, I'm using the pointer address of
the inode xor'ed with a random value. There are certainly better hashing
schemes, so if someone wants to propose a better way to do this, then I'm
open to looking at it (maybe halfmd4?).

This patch should apply cleanly to the current -mm.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/pipe.c b/fs/pipe.c
index 9b3cb34..76dc0e1 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -16,6 +16,7 @@
 #include <linux/uio.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/random.h>
 
 #include <asm/uaccess.h>
 #include <asm/ioctls.h>
@@ -35,6 +36,8 @@
  * -- Manfred Spraul <manfred@colorfullife.com> 2002-05-09
  */
 
+static unsigned long pipefs_dname_obfuscator;
+
 /* Drop the inode semaphore and wait for a pipe event, atomically */
 void pipe_wait(struct pipe_inode_info *pipe)
 {
@@ -844,6 +847,10 @@ static struct dentry_operations pipefs_dentry_operations = {
 	.d_delete	= pipefs_delete_dentry,
 };
 
+static struct inode_operations pipefs_inode_operations = {
+	.getattr	= lazy_getattr,
+};
+
 static struct inode * get_pipe_inode(void)
 {
 	struct inode *inode = new_inode(pipe_mnt->mnt_sb);
@@ -859,6 +866,7 @@ static struct inode * get_pipe_inode(void)
 
 	pipe->readers = pipe->writers = 1;
 	inode->i_fop = &rdwr_pipe_fops;
+	inode->i_op = &pipefs_inode_operations;
 
 	/*
 	 * Mark the inode dirty from the very beginning,
@@ -871,8 +879,7 @@ static struct inode * get_pipe_inode(void)
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	inode->i_ino = iunique(pipe_mnt->mnt_sb, 1);
-	insert_inode_hash(inode);
+	inode->i_ino = 0;
 
 	return inode;
 
@@ -900,7 +907,8 @@ struct file *create_write_pipe(void)
 	if (!inode)
 		goto err_file;
 
-	this.len = sprintf(name, "[%lu]", inode->i_ino);
+	this.len = sprintf(name, "[%lu]",
+		   (unsigned long) inode ^ pipefs_dname_obfuscator);
 	this.name = name;
 	this.hash = 0;
 	err = -ENOMEM;
@@ -1033,6 +1041,8 @@ static int __init init_pipe_fs(void)
 {
 	int err = register_filesystem(&pipe_fs_type);
 
+	get_random_bytes(&pipefs_dname_obfuscator, sizeof(unsigned long));
+
 	if (!err) {
 		pipe_mnt = kern_mount(&pipe_fs_type);
 		if (IS_ERR(pipe_mnt)) {
