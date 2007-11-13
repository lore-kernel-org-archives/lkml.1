Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbXKMKL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbXKMKL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbXKMKKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:10:55 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:50687 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739AbXKMKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:10:51 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 7/9] Unionfs: remove unnecessary lower atime updates
Date: Tue, 13 Nov 2007 05:10:26 -0500
Message-Id: <11949486312861-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
References: <11949486283697-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No need for this because our readpage calls vfs_read on the lower objects,
which would update the atime as/if needed.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c |    8 --------
 fs/unionfs/mmap.c |    6 ------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 126df5e..809e0f1 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -31,10 +31,6 @@ static ssize_t unionfs_read(struct file *file, char __user *buf,
 
 	err = do_sync_read(file, buf, count, ppos);
 
-	if (err >= 0)
-		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
-			    unionfs_lower_dentry(file->f_path.dentry));
-
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	unionfs_check_file(file);
@@ -58,10 +54,6 @@ static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	if (err == -EIOCBQUEUED)
 		err = wait_on_sync_kiocb(iocb);
 
-	if (err >= 0)
-		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
-			    unionfs_lower_dentry(file->f_path.dentry));
-
 out:
 	unionfs_read_unlock(file->f_path.dentry->d_sb);
 	unionfs_check_file(file);
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index bb00fd5..34fd8aa 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -212,12 +212,6 @@ static int unionfs_readpage(struct file *file, struct page *page)
 
 	err = unionfs_do_readpage(file, page);
 
-	if (!err) {
-		touch_atime(unionfs_lower_mnt(file->f_path.dentry),
-			    unionfs_lower_dentry(file->f_path.dentry));
-		unionfs_copy_attr_times(file->f_path.dentry->d_inode);
-	}
-
 	/*
 	 * we have to unlock our page, b/c we _might_ have gotten a locked
 	 * page.  but we no longer have to wakeup on our page here, b/c
-- 
1.5.2.2

