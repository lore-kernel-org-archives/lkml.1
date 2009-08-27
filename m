Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZH0BDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZH0BDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 21:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754399AbZH0BDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 21:03:38 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:44731 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbZH0BDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 21:03:36 -0400
From: Abhishek Kulkarni <adkulkar@umail.iu.edu>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net, ericvh@gmail.com
Subject: [PATCH 2/2] 9p: Fix the incorrect update of inode size in v9fs_file_write()
Date: Wed, 26 Aug 2009 19:03:43 -0600
Message-Id: <1251335023-8615-2-git-send-email-adkulkar@umail.iu.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1251335023-8615-1-git-send-email-adkulkar@umail.iu.edu>
References: <1251335023-8615-1-git-send-email-adkulkar@umail.iu.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using the cache=loose flags, the inode's size was not being
updated correctly on a remote write. Thus subsequent reads of
the whole file resulted in a truncated read. Fix it.

Signed-off-by: Abhishek Kulkarni <adkulkar@umail.iu.edu>
---
 fs/9p/vfs_file.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index de7690e..cafaa46 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -32,6 +32,7 @@
 #include <linux/string.h>
 #include <linux/inet.h>
 #include <linux/list.h>
+#include <linux/pagemap.h>
 #include <asm/uaccess.h>
 #include <linux/idr.h>
 #include <net/9p/9p.h>
@@ -210,6 +211,7 @@ v9fs_file_write(struct file *filp, const char __user * data,
 	struct p9_client *clnt;
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	int origin = *offset;
+	unsigned long pg_start, pg_end;
 
 	P9_DPRINTK(P9_DEBUG_VFS, "data %p count %d offset %x\n", data,
 		(int)count, (int)*offset);
@@ -225,7 +227,7 @@ v9fs_file_write(struct file *filp, const char __user * data,
 		if (count < rsize)
 			rsize = count;
 
-		n = p9_client_write(fid, NULL, data+total, *offset+total,
+		n = p9_client_write(fid, NULL, data+total, origin+total,
 									rsize);
 		if (n <= 0)
 			break;
@@ -234,13 +236,12 @@ v9fs_file_write(struct file *filp, const char __user * data,
 	} while (count > 0);
 
 	if (total > 0) {
-		invalidate_inode_pages2_range(inode->i_mapping, origin,
-								origin+total);
+		pg_start = origin >> PAGE_CACHE_SHIFT;
+		pg_end = (origin + total - 1) >> PAGE_CACHE_SHIFT;
+		invalidate_inode_pages2_range(inode->i_mapping, pg_start,
+								pg_end);
 		*offset += total;
-	}
-
-	if (*offset > i_size_read(inode)) {
-		i_size_write(inode, *offset);
+		i_size_write(inode, i_size_read(inode) + total);
 		inode->i_blocks = (i_size_read(inode) + 512 - 1) >> 9;
 	}
 
-- 
1.6.3.3

