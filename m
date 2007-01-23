Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXAWQL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXAWQL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 11:11:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933042AbXAWQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 11:11:26 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39915 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036AbXAWQLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 11:11:25 -0500
Date: Tue, 23 Jan 2007 11:11:18 -0500
Message-Id: <200701231611.l0NGBIfB031051@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
To: akpm@osdl.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] replacement patch for pipefs and sockfs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
   I sent a set of 3 patches to you a week or so ago. This patch is a
replacement for the third one in the set. Either one will work, but I think
this is a better approach. The main differences here are:

1) pipefs declares its drop_inode function to be generic_delete_inode, which
obviates the need to have the fs make certain that i_nlink is properly set
at drop_inode time.

2) this makes also makes sockfs use unique i_ino values.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/pipe.c b/fs/pipe.c
index 68090e8..9b3cb34 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -871,6 +871,8 @@ static struct inode * get_pipe_inode(void)
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+	inode->i_ino = iunique(pipe_mnt->mnt_sb, 1);
+	insert_inode_hash(inode);
 
 	return inode;
 
@@ -1003,6 +1005,11 @@ int do_pipe(int *fd)
 	return error;
 }
 
+static struct super_operations pipefs_sops = {
+	.statfs		= simple_statfs,
+	.drop_inode	= generic_delete_inode,
+};
+
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
@@ -1013,7 +1020,7 @@ static int pipefs_get_sb(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data,
 			 struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "pipe:", NULL, PIPEFS_MAGIC, mnt);
+	return get_sb_pseudo(fs_type, "pipe:", &pipefs_sops, PIPEFS_MAGIC, mnt);
 }
 
 static struct file_system_type pipe_fs_type = {
diff --git a/net/socket.c b/net/socket.c
index 4e39631..20193a8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -284,6 +284,7 @@ static int init_inodecache(void)
 static struct super_operations sockfs_ops = {
 	.alloc_inode =	sock_alloc_inode,
 	.destroy_inode =sock_destroy_inode,
+	.drop_inode =	generic_delete_inode,
 	.statfs =	simple_statfs,
 };
 
@@ -495,6 +496,8 @@ static struct socket *sock_alloc(void)
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
+	inode->i_ino = iunique(sock_mnt->mnt_sb, 1);
+	insert_inode_hash(inode);
 
 	get_cpu_var(sockets_in_use)++;
 	put_cpu_var(sockets_in_use);
