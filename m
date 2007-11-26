Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbXKZQsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbXKZQsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 11:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbXKZQpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 11:45:52 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52804 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbXKZQpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:45:42 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 16/16] Unionfs: use generic_file_aio_read/write
Date: Mon, 26 Nov 2007 11:44:13 -0500
Message-Id: <1196095460975-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
References: <11960954531503-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's no apparent need to define our own aio_read/write methods.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c |   27 ++-------------------------
 1 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index b7d0d55..c922173 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -37,29 +37,6 @@ out:
 	return err;
 }
 
-static ssize_t unionfs_aio_read(struct kiocb *iocb, const struct iovec *iov,
-				unsigned long nr_segs, loff_t pos)
-{
-	int err = 0;
-	struct file *file = iocb->ki_filp;
-
-	unionfs_read_lock(file->f_path.dentry->d_sb);
-	err = unionfs_file_revalidate(file, false);
-	if (unlikely(err))
-		goto out;
-	unionfs_check_file(file);
-
-	err = generic_file_aio_read(iocb, iov, nr_segs, pos);
-
-	if (err == -EIOCBQUEUED)
-		err = wait_on_sync_kiocb(iocb);
-
-out:
-	unionfs_check_file(file);
-	unionfs_read_unlock(file->f_path.dentry->d_sb);
-	return err;
-}
-
 static ssize_t unionfs_write(struct file *file, const char __user *buf,
 			     size_t count, loff_t *ppos)
 {
@@ -234,9 +211,9 @@ out:
 struct file_operations unionfs_main_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= unionfs_read,
-	.aio_read       = unionfs_aio_read,
+	.aio_read	= generic_file_aio_read,
 	.write		= unionfs_write,
-	.aio_write      = generic_file_aio_write,
+	.aio_write	= generic_file_aio_write,
 	.readdir	= unionfs_file_readdir,
 	.unlocked_ioctl	= unionfs_ioctl,
 	.mmap		= unionfs_mmap,
-- 
1.5.2.2

