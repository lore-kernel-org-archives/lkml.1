Return-Path: <linux-kernel-owner+w=401wt.eu-S933905AbYBOWrO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbYBOWrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:47:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765586AbYBOWhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:55 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39347 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763694AbYBOWhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:47 -0500
Subject: [PATCH 17/30] r/o bind mounts: write count for file_update_time()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:43 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223743.27CB92C5@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time fs/inode.c
--- linux-2.6.git/fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time	2008-02-15 13:25:51.000000000 -0800
+++ linux-2.6.git-dave/fs/inode.c	2008-02-15 13:25:51.000000000 -0800
@@ -1250,10 +1250,13 @@ void file_update_time(struct file *file)
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct timespec now;
 	int sync_it = 0;
+	int err;
 
 	if (IS_NOCMTIME(inode))
 		return;
-	if (IS_RDONLY(inode))
+
+	err = mnt_want_write(file->f_vfsmnt);
+	if (err)
 		return;
 
 	now = current_fs_time(inode->i_sb);
@@ -1274,6 +1277,7 @@ void file_update_time(struct file *file)
 
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
+	mnt_drop_write(file->f_vfsmnt);
 }
 
 EXPORT_SYMBOL(file_update_time);
_
