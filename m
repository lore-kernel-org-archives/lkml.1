Return-Path: <linux-kernel-owner+w=401wt.eu-S1763412AbXEXAli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763412AbXEXAli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761705AbXEXAhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:37:03 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40253 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbXEXAg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:59 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 11/21] Unionfs: Combine unionfs_write with __unionfs_write.
Date: Wed, 23 May 2007 20:36:01 -0400
Message-Id: <11799669732061-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The __unionfs_write helper function was used only by unionfs_write, and
there is really no reason why they should not be combined.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/file.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 1dfcfcb..2e5ec42 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -77,17 +77,20 @@ out:
 	return err;
 }
 
-/* helper function to unionfs_write */
-static ssize_t __unionfs_write(struct file *file, const char __user *buf,
-			       size_t count, loff_t *ppos)
+static ssize_t unionfs_write(struct file *file, const char __user *buf,
+			     size_t count, loff_t *ppos)
 {
-	int err = -EINVAL;
+	int err;
 	struct file *hidden_file = NULL;
 	struct inode *inode;
 	struct inode *hidden_inode;
 	loff_t pos = *ppos;
 	int bstart, bend;
 
+	unionfs_read_lock(file->f_dentry->d_sb);
+	if ((err = unionfs_file_revalidate(file, 1)))
+		goto out;
+
 	inode = file->f_dentry->d_inode;
 
 	bstart = fbstart(file);
@@ -98,8 +101,10 @@ static ssize_t __unionfs_write(struct file *file, const char __user *buf,
 	hidden_file = unionfs_lower_file(file);
 	hidden_inode = hidden_file->f_dentry->d_inode;
 
-	if (!hidden_file->f_op || !hidden_file->f_op->write)
+	if (!hidden_file->f_op || !hidden_file->f_op->write) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	/* adjust for append -- seek to the end of the file */
 	if (file->f_flags & O_APPEND)
@@ -120,21 +125,6 @@ static ssize_t __unionfs_write(struct file *file, const char __user *buf,
 	if (pos > inode->i_size)
 		inode->i_size = pos;
 out:
-	return err;
-}
-
-static ssize_t unionfs_write(struct file *file, const char __user *buf,
-			     size_t count, loff_t *ppos)
-{
-	int err = 0;
-
-	unionfs_read_lock(file->f_dentry->d_sb);
-	if ((err = unionfs_file_revalidate(file, 1)))
-		goto out;
-
-	err = __unionfs_write(file, buf, count, ppos);
-
-out:
 	unionfs_read_unlock(file->f_dentry->d_sb);
 	return err;
 }
-- 
1.5.2.rc1.165.gaf9b

