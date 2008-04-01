Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbYDAVKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbYDAVKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761480AbYDAVH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:07:57 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:45609 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761248AbYDAVH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:07:56 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 03/14] Unionfs: implement splice_read/write methods directly
Date: Tue,  1 Apr 2008 17:06:45 -0400
Message-Id: <1207084017861-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
References: <12070840162442-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Must implement splice_read/write directly, using VFS helpers, because we can
no longer rely on generic_file_splice_read/write: they need
address_space_operations implemented, which we no longer have.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/file.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/unionfs/union.h |    1 +
 2 files changed, 58 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 0c424f6..1fcaf8e 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -165,6 +165,61 @@ out:
 	return err;
 }
 
+static ssize_t unionfs_splice_read(struct file *file, loff_t *ppos,
+				   struct pipe_inode_info *pipe, size_t len,
+				   unsigned int flags)
+{
+	ssize_t err;
+	struct file *lower_file;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb, UNIONFS_SMUTEX_PARENT);
+	err = unionfs_file_revalidate(file, false);
+	if (unlikely(err))
+		goto out;
+
+	lower_file = unionfs_lower_file(file);
+	err = vfs_splice_to(lower_file, ppos, pipe, len, flags);
+	/* update our inode atime upon a successful lower splice-read */
+	if (err >= 0) {
+		fsstack_copy_attr_atime(file->f_path.dentry->d_inode,
+					lower_file->f_path.dentry->d_inode);
+		unionfs_check_file(file);
+	}
+
+out:
+	unionfs_check_file(file);
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
+static ssize_t unionfs_splice_write(struct pipe_inode_info *pipe,
+				    struct file *file, loff_t *ppos,
+				    size_t len, unsigned int flags)
+{
+	ssize_t err = 0;
+	struct file *lower_file;
+
+	unionfs_read_lock(file->f_path.dentry->d_sb, UNIONFS_SMUTEX_PARENT);
+	err = unionfs_file_revalidate(file, true);
+	if (unlikely(err))
+		goto out;
+
+	lower_file = unionfs_lower_file(file);
+	err = vfs_splice_from(pipe, lower_file, ppos, len, flags);
+	/* update our inode times+sizes upon a successful lower write */
+	if (err >= 0) {
+		fsstack_copy_inode_size(file->f_path.dentry->d_inode,
+					lower_file->f_path.dentry->d_inode);
+		fsstack_copy_attr_times(file->f_path.dentry->d_inode,
+					lower_file->f_path.dentry->d_inode);
+		unionfs_check_file(file);
+	}
+
+out:
+	unionfs_read_unlock(file->f_path.dentry->d_sb);
+	return err;
+}
+
 struct file_operations unionfs_main_fops = {
 	.llseek		= generic_file_llseek,
 	.read		= do_sync_read,
@@ -179,6 +234,6 @@ struct file_operations unionfs_main_fops = {
 	.release	= unionfs_file_release,
 	.fsync		= unionfs_fsync,
 	.fasync		= unionfs_fasync,
-	.splice_read	= generic_file_splice_read,
-	.splice_write	= generic_file_splice_write,
+	.splice_read	= unionfs_splice_read,
+	.splice_write	= unionfs_splice_write,
 };
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 533806c..7b55e33 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -46,6 +46,7 @@
 #include <linux/poison.h>
 #include <linux/mman.h>
 #include <linux/backing-dev.h>
+#include <linux/splice.h>
 
 #include <asm/system.h>
 
-- 
1.5.2.2

