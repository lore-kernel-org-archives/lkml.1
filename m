Return-Path: <linux-kernel-owner+w=401wt.eu-S937699AbXGLAV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937699AbXGLAV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 20:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937539AbXGLARg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 20:17:36 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36377 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937451AbXGLARa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 20:17:30 -0400
Subject: [PATCH 13/23] elevate write count for file_update_time()
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 11 Jul 2007 17:17:27 -0700
References: <20070712001710.654CD9ED@kernel>
In-Reply-To: <20070712001710.654CD9ED@kernel>
Message-Id: <20070712001727.27A432E6@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/inode.c~elevate-write-count-for-file_update_time fs/inode.c
--- lxc/fs/inode.c~elevate-write-count-for-file_update_time	2007-07-10 12:46:10.000000000 -0700
+++ lxc-dave/fs/inode.c	2007-07-10 12:46:10.000000000 -0700
@@ -1221,10 +1221,19 @@ void file_update_time(struct file *file)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
 	int sync_it = 0;
+	int err = 0;
 
 	if (IS_NOCMTIME(inode))
 		return;
-	if (IS_RDONLY(inode))
+	/*
+	 * Ideally, we want to guarantee that 'f_vfsmnt'
+	 * is non-NULL here.  But, NFS exports need to
+	 * be fixed up before we can do that.  So, check
+	 * it for now. - Dave Hansen
+	 */
+	if (file->f_vfsmnt)
+		err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		return;
 
 	now = current_fs_time(inode->i_sb);
@@ -1240,6 +1249,8 @@ void file_update_time(struct file *file)
 
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
+	if (file->f_vfsmnt)
+		mnt_drop_write(file->f_vfsmnt);
 }
 
 EXPORT_SYMBOL(file_update_time);
_
