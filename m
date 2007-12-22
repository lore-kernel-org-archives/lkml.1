Return-Path: <linux-kernel-owner+w=401wt.eu-S1755354AbXLVWoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbXLVWoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 17:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbXLVWo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 17:44:29 -0500
Received: from outbound05.telus.net ([199.185.220.224]:61118 "EHLO
	outbound05.telus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbXLVWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 17:44:29 -0500
X-Greylist: delayed 5667 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 17:44:28 EST
From: Steven Cavanagh <steven.cavanagh@secretlab.ca>
Subject: [PATCH] fat: Editions to support fat_fallocate()
Date: Sat, 22 Dec 2007 14:09:58 -0700
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca
Message-Id: <20071222210958.9351.35913.stgit@jpe-laptop>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Cavanagh <steven.cavanagh@secretlab.ca>

Added support for fallocate for a msdos fat driver. This allows
preallocation of clusters to an inode before writes to reduce
file fragmentation

Signed-off-by: Steven.Cavanagh <steven.cavanagh@secretlab.ca>
---

 fs/fat/file.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index 69a83b5..f753c6a 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -15,6 +15,7 @@ #include <linux/buffer_head.h>
 #include <linux/writeback.h>
 #include <linux/backing-dev.h>
 #include <linux/blkdev.h>
+#include <linux/falloc.h>
 
 int fat_generic_ioctl(struct inode *inode, struct file *filp,
 		      unsigned int cmd, unsigned long arg)
@@ -312,8 +313,52 @@ int fat_getattr(struct vfsmount *mnt, st
 }
 EXPORT_SYMBOL_GPL(fat_getattr);
 
+/*
+ * preallocate space for a file. This implements fat fallocate inode
+ * operation, which gets called from sys_fallocate system call. User
+ * space requests len bytes at offset.
+ */
+long fat_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
+{
+	int ret = 0;
+	loff_t filesize = inode->i_size;
+
+	/* preallocation to directories is currently not supported */
+	if (S_ISDIR(inode->i_mode)) {
+		printk(KERN_ERR
+		"fat_fallocate(): Directory prealloc not supported\n");
+		return -ENODEV;
+	}
+
+	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
+		printk(KERN_INFO
+			"fat_fallocate():Blocks already allocated\n");
+			return 0;
+	}
+
+	if ((offset + len) > MSDOS_I(inode)->mmu_private) {
+
+		mutex_lock(&inode->i_mutex);
+		ret = fat_cont_expand(inode, (offset + len));
+		if (ret) {
+			printk(KERN_ERR
+				"fat_fallocate():fat_cont_expand() error\n");
+			mutex_unlock(&inode->i_mutex);
+			return ret;
+		}
+		mutex_unlock(&inode->i_mutex);
+	}
+	if (mode & FALLOC_FL_KEEP_SIZE) {
+		mutex_lock(&inode->i_mutex);
+		i_size_write(inode, filesize);
+		mutex_unlock(&inode->i_mutex);
+	}
+	return ret;
+}
+
 const struct inode_operations fat_file_inode_operations = {
 	.truncate	= fat_truncate,
 	.setattr	= fat_notify_change,
 	.getattr	= fat_getattr,
+	.fallocate	= fat_fallocate,
 };
