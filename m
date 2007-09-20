Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbXITT6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbXITT6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751381AbXITTxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:53:23 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38536 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbXITTxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:53:14 -0400
Subject: [PATCH 14/25] elevate write count for file_update_time()
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 20 Sep 2007 12:53:06 -0700
References: <20070920195249.852667D5@kernel>
In-Reply-To: <20070920195249.852667D5@kernel>
Message-Id: <20070920195306.C855ABDD@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Acked-by: Christoph Hellwig <hch@infradead.org>
---

 lxc-dave/fs/inode.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff -puN fs/inode.c~elevate-write-count-for-file_update_time fs/inode.c
--- lxc/fs/inode.c~elevate-write-count-for-file_update_time	2007-09-20 12:16:16.000000000 -0700
+++ lxc-dave/fs/inode.c	2007-09-20 12:16:16.000000000 -0700
@@ -1232,10 +1232,19 @@ void file_update_time(struct file *file)
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
@@ -1251,6 +1260,8 @@ void file_update_time(struct file *file)
 
 	if (sync_it)
 		mark_inode_dirty_sync(inode);
+	if (file->f_vfsmnt)
+		mnt_drop_write(file->f_vfsmnt);
 }
 
 EXPORT_SYMBOL(file_update_time);
_
