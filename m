Return-Path: <linux-kernel-owner+w=401wt.eu-S1765324AbYDYSAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765324AbYDYSAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:00:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764795AbYDYR5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:57:15 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55834 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764771AbYDYR5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:57:00 -0400
Message-Id: <20080425175657.912755144@szeredi.hu>
References: <20080425175520.735386844@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 25 Apr 2008 19:55:23 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [patch 3/5] fuse: fix race in llseek
Content-Disposition: inline; filename=fuse_llseek.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Fuse doesn't use i_mutex to protect setting i_size, and so
generic_file_llseek() can be racy: it doesn't use i_size_read().

So do a fuse specific llseek method, which does use i_size_read().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2008-04-25 19:38:10.000000000 +0200
+++ linux/fs/fuse/file.c	2008-04-25 19:40:11.000000000 +0200
@@ -1425,8 +1425,33 @@ static sector_t fuse_bmap(struct address
 	return err ? 0 : outarg.block;
 }
 
+static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
+{
+	long long retval;
+	struct inode *inode = file->f_path.dentry->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+	switch (origin) {
+	case SEEK_END:
+		offset += i_size_read(inode);
+		break;
+	case SEEK_CUR:
+		offset += file->f_pos;
+	}
+	retval = -EINVAL;
+	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
+		if (offset != file->f_pos) {
+			file->f_pos = offset;
+			file->f_version = 0;
+		}
+		retval = offset;
+	}
+	mutex_unlock(&inode->i_mutex);
+	return retval;
+}
+
 static const struct file_operations fuse_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= fuse_file_llseek,
 	.read		= do_sync_read,
 	.aio_read	= fuse_file_aio_read,
 	.write		= do_sync_write,
@@ -1442,7 +1467,7 @@ static const struct file_operations fuse
 };
 
 static const struct file_operations fuse_direct_io_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= fuse_file_llseek,
 	.read		= fuse_direct_read,
 	.write		= fuse_direct_write,
 	.open		= fuse_open,

--
