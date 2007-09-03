Return-Path: <linux-kernel-owner+w=401wt.eu-S934202AbXICCfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbXICCfx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbXICC0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:15 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57701 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbXICCZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:15 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 15/32] Unionfs: implement f/async
Date: Sun,  2 Sep 2007 22:20:38 -0400
Message-Id: <11887860572565-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Unionfs needs its own fsync and fasync instead of calling the generic
file_fsync, because it may have to sync multiple writable lower branches
(not just one).  This also allows Unionfs to compile with CONFIG_BLOCK=n.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/dirfops.c |    2 +
 fs/unionfs/file.c    |   91 +++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/unionfs/union.h   |    3 ++
 3 files changed, 95 insertions(+), 1 deletions(-)

diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 8503411..0e93bd7 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -273,4 +273,6 @@ struct file_operations unionfs_dir_fops = {
 	.open		= unionfs_open,
 	.release	= unionfs_file_release,
 	.flush		= unionfs_flush,
+	.fsync		= unionfs_fsync,
+	.fasync		= unionfs_fasync,
 };
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 47b63f3..0555b6c 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -135,6 +135,94 @@ out:
 	return err;
 }
 
+int unionfs_fsync(struct file *file, struct dentry *dentry, int datasync)
+{
+	int bindex, bstart, bend;
+	struct file *lower_file;
+	struct dentry *lower_dentry;
+	struct inode *lower_inode, *inode;
+	int err = -EINVAL;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb);
+	if ((err = unionfs_file_revalidate(file, 1)))
+		goto out;
+
+	bstart = fbstart(file);
+	bend = fbend(file);
+	if (bstart < 0 || bend < 0)
+		goto out;
+
+	inode = dentry->d_inode;
+	if (!inode) {
+		printk(KERN_ERR
+		       "unionfs: null lower inode in unionfs_fsync\n");
+		goto out;
+	}
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode || !lower_inode->i_fop->fsync)
+			continue;
+		lower_file = unionfs_lower_file_idx(file, bindex);
+		lower_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		mutex_lock(&lower_inode->i_mutex);
+		err = lower_inode->i_fop->fsync(lower_file,
+						lower_dentry,
+						datasync);
+		mutex_unlock(&lower_inode->i_mutex);
+		if (err)
+			goto out;
+	}
+
+	unionfs_copy_attr_times(inode);
+
+out:
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
+int unionfs_fasync(int fd, struct file *file, int flag)
+{
+	int bindex, bstart, bend;
+	struct file *lower_file;
+	struct dentry *dentry;
+	struct inode *lower_inode, *inode;
+	int err = 0;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb);
+	if ((err = unionfs_file_revalidate(file, 1)))
+		goto out;
+
+	bstart = fbstart(file);
+	bend = fbend(file);
+	if (bstart < 0 || bend < 0)
+		goto out;
+
+	dentry = file->f_path.dentry;
+	inode = dentry->d_inode;
+	if (!inode) {
+		printk(KERN_ERR
+		       "unionfs: null lower inode in unionfs_fasync\n");
+		goto out;
+	}
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		lower_inode = unionfs_lower_inode_idx(inode, bindex);
+		if (!lower_inode || !lower_inode->i_fop->fasync)
+			continue;
+		lower_file = unionfs_lower_file_idx(file, bindex);
+		mutex_lock(&lower_inode->i_mutex);
+		err = lower_inode->i_fop->fasync(fd, lower_file, flag);
+		mutex_unlock(&lower_inode->i_mutex);
+		if (err)
+			goto out;
+	}
+
+	unionfs_copy_attr_times(inode);
+
+out:
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
 struct file_operations unionfs_main_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= unionfs_read,
@@ -147,6 +235,7 @@ struct file_operations unionfs_main_fops = {
 	.open		= unionfs_open,
 	.flush		= unionfs_flush,
 	.release	= unionfs_file_release,
-	.fsync		= file_fsync,
+	.fsync		= unionfs_fsync,
+	.fasync		= unionfs_fasync,
 	.splice_read	= generic_file_splice_read,
 };
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index f8a9cd2..ec33155 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -312,6 +312,9 @@ extern int unionfs_file_release(struct inode *inode, struct file *file);
 extern int unionfs_flush(struct file *file, fl_owner_t id);
 extern long unionfs_ioctl(struct file *file, unsigned int cmd,
 			  unsigned long arg);
+extern int unionfs_fsync(struct file *file, struct dentry *dentry,
+			 int datasync);
+extern int unionfs_fasync(int fd, struct file *file, int flag);
 
 /* Inode operations */
 extern int unionfs_rename(struct inode *old_dir, struct dentry *old_dentry,
-- 
1.5.2.2.238.g7cbf2f2

