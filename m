Return-Path: <linux-kernel-owner+w=401wt.eu-S1759464AbZCRSAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464AbZCRSAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZCRSAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:00:00 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:17584 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753183AbZCRR77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 13:59:59 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/8] exofs: file and file_inode operations
Date: Wed, 18 Mar 2009 19:58:47 +0200
Message-Id: <1237399127-29206-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <49C1331D.1080805@panasas.com>
References: <49C1331D.1080805@panasas.com>
X-OriginalArrivalTime: 18 Mar 2009 17:59:56.0151 (UTC) FILETIME=[58904070:01C9A7F3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

implementation of the file_operations and inode_operations for
regular data files.

Most file_operations are generic vfs implementations except:
- exofs_truncate will truncate the OSD object as well
- Generic file_fsync is not good for none_bd devices so open code it
- The default for .flush in Linux is todo nothing so call exofs_fsync
  on the file.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/Kbuild  |    2 +-
 fs/exofs/exofs.h |   14 +++++
 fs/exofs/file.c  |   82 ++++++++++++++++++++++++++++++
 fs/exofs/inode.c |  148 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 245 insertions(+), 1 deletions(-)
 create mode 100644 fs/exofs/file.c
 create mode 100644 fs/exofs/inode.c

diff --git a/fs/exofs/Kbuild b/fs/exofs/Kbuild
index 63d822c..269281f 100644
--- a/fs/exofs/Kbuild
+++ b/fs/exofs/Kbuild
@@ -26,5 +26,5 @@ KBUILD_CPPFLAGS := -I$(OSD_INC) $(KBUILD_CPPFLAGS)
 
 endif
 
-exofs-y := osd.o
+exofs-y := osd.o inode.o file.o
 obj-$(CONFIG_EXOFS_FS) += exofs.o
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 304e052..28deb67 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -124,4 +124,18 @@ static inline struct exofs_i_info *exofs_i(struct inode *inode)
 	return container_of(inode, struct exofs_i_info, vfs_inode);
 }
 
+/*************************
+ * function declarations *
+ *************************/
+/* inode.c               */
+void exofs_truncate(struct inode *inode);
+int exofs_setattr(struct dentry *, struct iattr *);
+
+/*********************
+ * operation vectors *
+ *********************/
+/* file.c            */
+extern const struct inode_operations exofs_file_inode_operations;
+extern const struct file_operations exofs_file_operations;
+
 #endif
diff --git a/fs/exofs/file.c b/fs/exofs/file.c
new file mode 100644
index 0000000..4738c3f
--- /dev/null
+++ b/fs/exofs/file.c
@@ -0,0 +1,82 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ * Copyright (C) 2008, 2009
+ * Boaz Harrosh <bharrosh@panasas.com>
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/buffer_head.h>
+
+#include "exofs.h"
+
+static int exofs_release_file(struct inode *inode, struct file *filp)
+{
+	return 0;
+}
+
+static int exofs_file_fsync(struct file *filp, struct dentry *dentry,
+			    int datasync)
+{
+	int ret1, ret2;
+	struct address_space *mapping = filp->f_mapping;
+
+	ret1 = filemap_write_and_wait(mapping);
+	ret2 = file_fsync(filp, dentry, datasync);
+
+	return ret1 ? ret1 : ret2;
+}
+
+static int exofs_flush(struct file *file, fl_owner_t id)
+{
+	exofs_file_fsync(file, file->f_path.dentry, 1);
+	/* TODO: Flush the OSD target */
+	return 0;
+}
+
+const struct file_operations exofs_file_operations = {
+	.llseek		= generic_file_llseek,
+	.read		= do_sync_read,
+	.write		= do_sync_write,
+	.aio_read	= generic_file_aio_read,
+	.aio_write	= generic_file_aio_write,
+	.mmap		= generic_file_mmap,
+	.open		= generic_file_open,
+	.release	= exofs_release_file,
+	.fsync		= exofs_file_fsync,
+	.flush		= exofs_flush,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
+};
+
+const struct inode_operations exofs_file_inode_operations = {
+	.truncate	= exofs_truncate,
+	.setattr	= exofs_setattr,
+};
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
new file mode 100644
index 0000000..b0bda1e
--- /dev/null
+++ b/fs/exofs/inode.c
@@ -0,0 +1,148 @@
+/*
+ * Copyright (C) 2005, 2006
+ * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
+ * Copyright (C) 2005, 2006
+ * International Business Machines
+ * Copyright (C) 2008, 2009
+ * Boaz Harrosh <bharrosh@panasas.com>
+ *
+ * Copyrights for code taken from ext2:
+ *     Copyright (C) 1992, 1993, 1994, 1995
+ *     Remy Card (card@masi.ibp.fr)
+ *     Laboratoire MASI - Institut Blaise Pascal
+ *     Universite Pierre et Marie Curie (Paris VI)
+ *     from
+ *     linux/fs/minix/inode.c
+ *     Copyright (C) 1991, 1992  Linus Torvalds
+ *
+ * This file is part of exofs.
+ *
+ * exofs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.  Since it is based on ext2, and the only
+ * valid version of GPL for the Linux kernel is version 2, the only valid
+ * version of GPL for exofs is version 2.
+ *
+ * exofs is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with exofs; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/writeback.h>
+#include <linux/buffer_head.h>
+
+#include "exofs.h"
+
+#ifdef CONFIG_EXOFS_DEBUG
+#  define EXOFS_DEBUG_OBJ_ISIZE 1
+#endif
+
+/******************************************************************************
+ * INODE OPERATIONS
+ *****************************************************************************/
+
+/*
+ * Test whether an inode is a fast symlink.
+ */
+static inline int exofs_inode_is_fast_symlink(struct inode *inode)
+{
+	struct exofs_i_info *oi = exofs_i(inode);
+
+	return S_ISLNK(inode->i_mode) && (oi->i_data[0] != 0);
+}
+
+/*
+ * get_block_t - Fill in a buffer_head
+ * An OSD takes care of block allocation so we just fake an allocation by
+ * putting in the inode's sector_t in the buffer_head.
+ * TODO: What about the case of create==0 and @iblock does not exist in the
+ * object?
+ */
+static int exofs_get_block(struct inode *inode, sector_t iblock,
+		    struct buffer_head *bh_result, int create)
+{
+	map_bh(bh_result, inode->i_sb, iblock);
+	return 0;
+}
+
+const struct osd_attr g_attr_logical_length = ATTR_DEF(
+	OSD_APAGE_OBJECT_INFORMATION, OSD_ATTR_OI_LOGICAL_LENGTH, 8);
+
+/*
+ * Truncate a file to the specified size - all we have to do is set the size
+ * attribute.  We make sure the object exists first.
+ */
+void exofs_truncate(struct inode *inode)
+{
+	struct exofs_sb_info *sbi = inode->i_sb->s_fs_info;
+	struct exofs_i_info *oi = exofs_i(inode);
+	struct osd_obj_id obj = {sbi->s_pid, inode->i_ino + EXOFS_OBJ_OFF};
+	struct osd_request *or;
+	struct osd_attr attr;
+	loff_t isize = i_size_read(inode);
+	__be64 newsize;
+	int ret;
+
+	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)
+	     || S_ISLNK(inode->i_mode)))
+		return;
+	if (exofs_inode_is_fast_symlink(inode))
+		return;
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return;
+	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
+
+	nobh_truncate_page(inode->i_mapping, isize, exofs_get_block);
+
+	or = osd_start_request(sbi->s_dev, GFP_KERNEL);
+	if (unlikely(!or)) {
+		EXOFS_ERR("ERROR: exofs_truncate: osd_start_request failed\n");
+		goto fail;
+	}
+
+	osd_req_set_attributes(or, &obj);
+
+	newsize = cpu_to_be64((u64)isize);
+	attr = g_attr_logical_length;
+	attr.val_ptr = &newsize;
+	osd_req_add_set_attr_list(or, &attr, 1);
+
+	/* if we are about to truncate an object, and it hasn't been
+	 * created yet, wait
+	 */
+	if (unlikely(wait_obj_created(oi)))
+		goto fail;
+
+	ret = exofs_sync_op(or, sbi->s_timeout, oi->i_cred);
+	osd_end_request(or);
+	if (ret)
+		goto fail;
+
+out:
+	mark_inode_dirty(inode);
+	return;
+fail:
+	make_bad_inode(inode);
+	goto out;
+}
+
+/*
+ * Set inode attributes - just call generic functions.
+ */
+int exofs_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
+
+	error = inode_change_ok(inode, iattr);
+	if (error)
+		return error;
+
+	error = inode_setattr(inode, iattr);
+	return error;
+}
-- 
1.6.2.1

