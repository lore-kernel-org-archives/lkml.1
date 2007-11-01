Return-Path: <linux-kernel-owner+w=401wt.eu-S1761869AbXKAXMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761869AbXKAXMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbXKAXIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:50 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42621 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758083AbXKAXIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:48 -0400
Subject: [PATCH 14/27] r-o-bind-mounts-elevate-write-count-for-file_update_time
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:45 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230845.297764DE@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 linux-2.6.git-dave/fs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time fs/inode.c
--- linux-2.6.git/fs/inode.c~r-o-bind-mounts-elevate-write-count-for-file_update_time	2007-11-01 14:46:13.000000000 -0700
+++ linux-2.6.git-dave/fs/inode.c	2007-11-01 14:46:13.000000000 -0700
@@ -1263,10 +1263,19 @@ void file_update_time(struct file *file)
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
@@ -1282,6 +1291,8 @@ void file_update_time(struct file *file)
 
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
+	if (file->f_vfsmnt)
+		mnt_drop_write(file->f_vfsmnt);
 }
 
 EXPORT_SYMBOL(file_update_time);
_
