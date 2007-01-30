Return-Path: <linux-kernel-owner+w=401wt.eu-S965679AbXA3SKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965679AbXA3SKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 13:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965678AbXA3SKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 13:10:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965676AbXA3SKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 13:10:47 -0500
Date: Tue, 30 Jan 2007 13:09:59 -0500
Message-Id: <200701301809.l0UI9xfn028590@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
To: akpm@osdl.org
Cc: dev@sw.ru, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH] revert changes to pipefs for i_ino uniqueness
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since posting that patch to add i_ino uniqueness to pipefs, I've gotten some
comments that have convinced me that we should probably leave it as is for
now (at least until someone we a good reason).

So, please back out that patch from -mm.

The patch below should revert pipefs to its original state.

Thanks,

Signed-off-by: Jeff Layton <jlayton@redhat.com>

diff --git a/fs/pipe.c b/fs/pipe.c
index 9b3cb34..68090e8 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -871,8 +871,6 @@ static struct inode * get_pipe_inode(void)
 	inode->i_uid = current->fsuid;
 	inode->i_gid = current->fsgid;
 	inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
-	inode->i_ino = iunique(pipe_mnt->mnt_sb, 1);
-	insert_inode_hash(inode);
 
 	return inode;
 
@@ -1005,11 +1003,6 @@ int do_pipe(int *fd)
 	return error;
 }
 
-static struct super_operations pipefs_sops = {
-	.statfs		= simple_statfs,
-	.drop_inode	= generic_delete_inode,
-};
-
 /*
  * pipefs should _never_ be mounted by userland - too much of security hassle,
  * no real gain from having the whole whorehouse mounted. So we don't need
@@ -1020,7 +1013,7 @@ static int pipefs_get_sb(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data,
 			 struct vfsmount *mnt)
 {
-	return get_sb_pseudo(fs_type, "pipe:", &pipefs_sops, PIPEFS_MAGIC, mnt);
+	return get_sb_pseudo(fs_type, "pipe:", NULL, PIPEFS_MAGIC, mnt);
 }
 
 static struct file_system_type pipe_fs_type = {
