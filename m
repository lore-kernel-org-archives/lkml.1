Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZDPOcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZDPOcV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZDPOcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:32:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45760 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579AbZDPOcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:32:10 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: npiggin@suse.de, Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext2: Add support for reliable mmap
Date: Thu, 16 Apr 2009 16:32:07 +0200
Message-Id: <1239892327-9636-3-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add necessary callbacks to ext2 so that page faults fail when there's not
enough space on the filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext2/file.c  |   26 +++++++++++++++++++++++++-
 fs/ext2/inode.c |    1 +
 2 files changed, 26 insertions(+), 1 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 45ed071..74b2c3d 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -19,6 +19,8 @@
  */
 
 #include <linux/time.h>
+#include <linux/mm.h>
+#include <linux/buffer_head.h>
 #include "ext2.h"
 #include "xattr.h"
 #include "acl.h"
@@ -38,6 +40,28 @@ static int ext2_release_file (struct inode * inode, struct file * filp)
 	return 0;
 }
 
+static int ext2_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return block_page_mkwrite(vma, vmf, ext2_get_block);
+}
+
+static struct vm_operations_struct ext2_file_vm_ops = {
+	.fault		= filemap_fault,
+	.page_mkwrite	= ext2_page_mkwrite,
+};
+
+static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct address_space *mapping = file->f_mapping;
+
+	if (!mapping->a_ops->readpage)
+		return -ENOEXEC;
+	file_accessed(file);
+	vma->vm_ops = &ext2_file_vm_ops;
+	vma->vm_flags |= VM_CAN_NONLINEAR;
+	return 0;
+}
+
 /*
  * We have mostly NULL's here: the current defaults are ok for
  * the ext2 filesystem.
@@ -52,7 +76,7 @@ const struct file_operations ext2_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext2_file_mmap,
 	.open		= generic_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_sync_file,
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index acf6788..8217219 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -816,6 +816,7 @@ const struct address_space_operations ext2_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext2_write_begin,
 	.write_end		= generic_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext2_bmap,
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
-- 
1.6.0.2

