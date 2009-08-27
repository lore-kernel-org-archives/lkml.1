Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbZH0BDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbZH0BDg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 21:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZH0BDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 21:03:35 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:62795 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbZH0BDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 21:03:35 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, ericvh@gmail.com
Subject: [PATCH 1/2] 9p: Use the i_size_[read,write]() macros instead of using inode->i_size directly.
Date: Wed, 26 Aug 2009 19:03:42 -0600
Message-Id: <1251335023-8615-1-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all occurrence of inode->i_size with i_size_read() or i_size_write()
as appropriate.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
 fs/9p/vfs_file.c  |    8 ++++----
 fs/9p/vfs_inode.c |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 68bf2af..de7690e 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -72,7 +72,7 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 			return err;
 		}
 		if (omode & P9_OTRUNC) {
-			inode->i_size = 0;
+			i_size_write(inode, 0);
 			inode->i_blocks = 0;
 		}
 		if ((file->f_flags & O_APPEND) && (!v9fs_extended(v9ses)))
@@ -239,9 +239,9 @@ v9fs_file_write(struct file *filp, const char __user * data,
 		*offset += total;
 	}
 
-	if (*offset > inode->i_size) {
-		inode->i_size = *offset;
-		inode->i_blocks = (inode->i_size + 512 - 1) >> 9;
+	if (*offset > i_size_read(inode)) {
+		i_size_write(inode, *offset);
+		inode->i_blocks = (i_size_read(inode) + 512 - 1) >> 9;
 	}
 
 	if (n < 0)
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 06a223d..f3bfa87 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -872,10 +872,10 @@ v9fs_stat2inode(struct p9_wstat *stat, struct inode *inode,
 	} else
 		inode->i_rdev = 0;
 
-	inode->i_size = stat->length;
+	i_size_write(inode, stat->length);
 
 	/* not real number of blocks, but 512 byte ones ... */
-	inode->i_blocks = (inode->i_size + 512 - 1) >> 9;
+	inode->i_blocks = (i_size_read(inode) + 512 - 1) >> 9;
 }
 
 /**
-- 
1.6.3.3

