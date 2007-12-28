Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbXL1UpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbXL1UpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXL1Unl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:43:41 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37098 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671AbXL1Uni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:43:38 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 12/30] Unionfs: remove custom read/write methods
Date: Fri, 28 Dec 2007 15:42:46 -0500
Message-Id: <11988745911631-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having them results in lockdep warnings about having locks and grabbing the
same class locks in do_sync_read/write which were called from
unionfs_read/write.  All they did was revalidate out file object sooner,
which will now be deferred till a bit later.  Instead, use generic
do_sync_read and do_sync_write.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c |   46 ++--------------------------------------------
 1 files changed, 2 insertions(+), 44 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index c922173..94784c3 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -18,48 +18,6 @@
 
 #include "union.h"
 
-static ssize_t unionfs_read(struct file *file, char __user *buf,
-			    size_t count, loff_t *ppos)
-{
-	int err;
-
-	unionfs_read_lock(file->f_path.dentry->d_sb);
-	err = unionfs_file_revalidate(file, false);
-	if (unlikely(err))
-		goto out;
-	unionfs_check_file(file);
-
-	err = do_sync_read(file, buf, count, ppos);
-
-out:
-	unionfs_check_file(file);
-	unionfs_read_unlock(file->f_path.dentry->d_sb);
-	return err;
-}
-
-static ssize_t unionfs_write(struct file *file, const char __user *buf,
-			     size_t count, loff_t *ppos)
-{
-	int err = 0;
-
-	unionfs_read_lock(file->f_path.dentry->d_sb);
-	err = unionfs_file_revalidate(file, true);
-	if (unlikely(err))
-		goto out;
-	unionfs_check_file(file);
-
-	err = do_sync_write(file, buf, count, ppos);
-	/* update our inode times upon a successful lower write */
-	if (err >= 0) {
-		unionfs_copy_attr_times(file->f_path.dentry->d_inode);
-		unionfs_check_file(file);
-	}
-
-out:
-	unionfs_read_unlock(file->f_path.dentry->d_sb);
-	return err;
-}
-
 static int unionfs_file_readdir(struct file *file, void *dirent,
 				filldir_t filldir)
 {
@@ -210,9 +168,9 @@ out:
 
 struct file_operations unionfs_main_fops = {
 	.llseek		= generic_file_llseek,
-	.read		= unionfs_read,
+	.read		= do_sync_read,
 	.aio_read	= generic_file_aio_read,
-	.write		= unionfs_write,
+	.write		= do_sync_write,
 	.aio_write	= generic_file_aio_write,
 	.readdir	= unionfs_file_readdir,
 	.unlocked_ioctl	= unionfs_ioctl,
-- 
1.5.2.2

