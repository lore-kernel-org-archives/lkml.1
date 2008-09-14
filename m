Return-Path: <linux-kernel-owner+w=401wt.eu-S1757806AbYINTRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbYINTRR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 15:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755811AbYINTKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 15:10:30 -0400
Received: from sh.osrg.net ([192.16.179.4]:53343 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755750AbYINTJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 15:09:30 -0400
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
       Yoshiji Amagai <amagai.yoshiji@lab.ntt.co.jp>
Subject: [PATCH 12/27] nilfs2: inode map file
Date: Mon, 15 Sep 2008 04:08:09 +0900
Message-Id: <1221419304-18572-13-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1221419304-18572-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-4-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-5-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-6-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-8-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-9-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-10-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-11-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
 <1221419304-18572-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a meta data file which stores on-disk inodes in its data
blocks.

Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Yoshiji Amagai <amagai.yoshiji@lab.ntt.co.jp>
---
 fs/nilfs2/ifile.c |  150 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/nilfs2/ifile.h |   53 +++++++++++++++++++
 2 files changed, 203 insertions(+), 0 deletions(-)
 create mode 100644 fs/nilfs2/ifile.c
 create mode 100644 fs/nilfs2/ifile.h

diff --git a/fs/nilfs2/ifile.c b/fs/nilfs2/ifile.c
new file mode 100644
index 0000000..de86401
--- /dev/null
+++ b/fs/nilfs2/ifile.c
@@ -0,0 +1,150 @@
+/*
+ * ifile.c - NILFS inode file
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Amagai Yoshiji <amagai@osrg.net>.
+ * Revised by Ryusuke Konishi <ryusuke@osrg.net>.
+ *
+ */
+
+#include <linux/types.h>
+#include <linux/buffer_head.h>
+#include "nilfs.h"
+#include "mdt.h"
+#include "alloc.h"
+#include "ifile.h"
+
+/**
+ * nilfs_ifile_create_inode - create a new disk inode
+ * @ifile: ifile inode
+ * @out_ino: pointer to a variable to store inode number
+ * @out_bh: buffer_head contains newly allocated disk inode
+ *
+ * Return Value: On success, 0 is returned and the newly allocated inode
+ * number is stored in the place pointed by @ino, and buffer_head pointer
+ * that contains newly allocated disk inode structure is stored in the
+ * place pointed by @out_bh
+ * On error, one of the following negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOSPC - No inode left.
+ */
+int nilfs_ifile_create_inode(struct inode *ifile, ino_t *out_ino,
+			     struct buffer_head **out_bh)
+{
+	struct nilfs_palloc_req req;
+	int ret;
+
+	req.pr_entry_nr = 0;  /* 0 says find free inode from beginning of
+				 a group. dull code!! */
+	req.pr_entry_bh = NULL;
+
+	ret = nilfs_palloc_prepare_alloc_entry(ifile, &req);
+	if (!ret) {
+		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 1,
+						   &req.pr_entry_bh);
+		if (ret < 0)
+			nilfs_palloc_abort_alloc_entry(ifile, &req);
+	}
+	if (ret < 0) {
+		brelse(req.pr_entry_bh);
+		return ret;
+	}
+	nilfs_palloc_commit_alloc_entry(ifile, &req);
+	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
+	nilfs_mdt_mark_dirty(ifile);
+	*out_ino = (ino_t)req.pr_entry_nr;
+	*out_bh = req.pr_entry_bh;
+	return 0;
+}
+
+/**
+ * nilfs_ifile_delete_inode - delete a disk inode
+ * @ifile: ifile inode
+ * @ino: inode number
+ *
+ * Return Value: On success, 0 is returned. On error, one of the following
+ * negative error codes is returned.
+ *
+ * %-EIO - I/O error.
+ *
+ * %-ENOMEM - Insufficient amount of memory available.
+ *
+ * %-ENOENT - The inode number @ino have not been allocated.
+ */
+int nilfs_ifile_delete_inode(struct inode *ifile, ino_t ino)
+{
+	struct nilfs_palloc_req req = {
+		.pr_entry_nr = ino, .pr_entry_bh = NULL
+	};
+	struct nilfs_inode *raw_inode;
+	void *kaddr;
+	int ret;
+
+	ret = nilfs_palloc_prepare_free_entry(ifile, &req);
+	if (!ret) {
+		ret = nilfs_palloc_get_entry_block(ifile, req.pr_entry_nr, 0,
+						   &req.pr_entry_bh);
+		if (ret < 0)
+			nilfs_palloc_abort_free_entry(ifile, &req);
+	}
+	if (ret < 0) {
+		brelse(req.pr_entry_bh);
+		return ret;
+	}
+
+	kaddr = kmap_atomic(req.pr_entry_bh->b_page, KM_USER0);
+	raw_inode = nilfs_palloc_block_get_entry(ifile, req.pr_entry_nr,
+						 req.pr_entry_bh, kaddr);
+	raw_inode->i_flags = 0;
+	kunmap_atomic(kaddr, KM_USER0);
+
+	nilfs_mdt_mark_buffer_dirty(req.pr_entry_bh);
+	brelse(req.pr_entry_bh);
+
+	nilfs_palloc_commit_free_entry(ifile, &req);
+
+	return 0;
+}
+
+int nilfs_ifile_get_inode_block(struct inode *ifile, ino_t ino,
+				struct buffer_head **out_bh)
+{
+	struct super_block *sb = ifile->i_sb;
+	int err;
+
+	if (unlikely(!NILFS_VALID_INODE(sb, ino))) {
+		nilfs_error(sb, __func__, "bad inode number: %lu",
+			    (unsigned long) ino);
+		return -EINVAL;
+	}
+
+	err = nilfs_palloc_get_entry_block(ifile, ino, 0, out_bh);
+	if (unlikely(err)) {
+		if (err == -EINVAL)
+			nilfs_error(sb, __func__, "ifile is broken");
+		else
+			nilfs_warning(sb, __func__,
+				      "unable to read inode: %lu",
+				      (unsigned long) ino);
+	}
+	return err;
+}
diff --git a/fs/nilfs2/ifile.h b/fs/nilfs2/ifile.h
new file mode 100644
index 0000000..5d30a35
--- /dev/null
+++ b/fs/nilfs2/ifile.h
@@ -0,0 +1,53 @@
+/*
+ * ifile.h - NILFS inode file
+ *
+ * Copyright (C) 2006-2008 Nippon Telegraph and Telephone Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * Written by Amagai Yoshiji <amagai@osrg.net>
+ * Revised by Ryusuke Konishi <ryusuke@osrg.net>
+ *
+ */
+
+#ifndef _NILFS_IFILE_H
+#define _NILFS_IFILE_H
+
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <linux/nilfs2_fs.h>
+#include "mdt.h"
+#include "alloc.h"
+
+#define NILFS_IFILE_GFP  NILFS_MDT_GFP
+
+static inline struct nilfs_inode *
+nilfs_ifile_map_inode(struct inode *ifile, ino_t ino, struct buffer_head *ibh)
+{
+	void *kaddr = kmap(ibh->b_page);
+	return nilfs_palloc_block_get_entry(ifile, ino, ibh, kaddr);
+}
+
+static inline void nilfs_ifile_unmap_inode(struct inode *ifile, ino_t ino,
+					   struct buffer_head *ibh)
+{
+	kunmap(ibh->b_page);
+}
+
+int nilfs_ifile_create_inode(struct inode *, ino_t *, struct buffer_head **);
+int nilfs_ifile_delete_inode(struct inode *, ino_t);
+int nilfs_ifile_get_inode_block(struct inode *, ino_t, struct buffer_head **);
+
+#endif	/* _NILFS_IFILE_H */
-- 
1.5.6.3

