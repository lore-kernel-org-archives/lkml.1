Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbZAEL1N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbZAEL1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:27:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZAEL04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:26:56 -0500
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:62091 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbZAEL04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:26:56 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: [PATCH V3 09/17] Squashfs: uid/gid lookup operations
Message-Id: <E1LJnJn-0002Lh-TS@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Mon, 05 Jan 2009 11:08:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/id.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 94 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/id.c b/fs/squashfs/id.c
new file mode 100644
index 0000000..3795b83
--- /dev/null
+++ b/fs/squashfs/id.c
@@ -0,0 +1,94 @@
+/*
+ * Squashfs - a compressed read only filesystem for Linux
+ *
+ * Copyright (c) 2002, 2003, 2004, 2005, 2006, 2007, 2008
+ * Phillip Lougher <phillip@lougher.demon.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2,
+ * or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
+ *
+ * id.c
+ */
+
+/*
+ * This file implements code to handle uids and gids.
+ *
+ * For space efficiency regular files store uid and gid indexes, which are
+ * converted to 32-bit uids/gids using an id look up table.  This table is
+ * stored compressed into metadata blocks.  A second index table is used to
+ * locate these.  This second index table for speed of access (and because it
+ * is small) is read at mount time and cached in memory.
+ */
+
+#include <linux/fs.h>
+#include <linux/vfs.h>
+#include <linux/slab.h>
+#include <linux/zlib.h>
+
+#include "squashfs_fs.h"
+#include "squashfs_fs_sb.h"
+#include "squashfs_fs_i.h"
+#include "squashfs.h"
+
+/*
+ * Map uid/gid index into real 32-bit uid/gid using the id look up table
+ */
+int squashfs_get_id(struct super_block *sb, unsigned int index,
+					unsigned int *id)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	int block = SQUASHFS_ID_BLOCK(index);
+	int offset = SQUASHFS_ID_BLOCK_OFFSET(index);
+	u64 start_block = le64_to_cpu(msblk->id_table[block]);
+	__le32 disk_id;
+	int err;
+
+	err = squashfs_read_metadata(sb, &disk_id, &start_block, &offset,
+							sizeof(disk_id));
+	if (err < 0)
+		return err;
+
+	*id = le32_to_cpu(disk_id);
+	return 0;
+}
+
+
+/*
+ * Read uncompressed id lookup table indexes from disk into memory
+ */
+__le64 *squashfs_read_id_index_table(struct super_block *sb,
+			u64 id_table_start, unsigned short no_ids)
+{
+	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
+	__le64 *id_table;
+	int err;
+
+	TRACE("In read_id_index_table, length %d\n", length);
+
+	/* Allocate id lookup table indexes */
+	id_table = kmalloc(length, GFP_KERNEL);
+	if (id_table == NULL) {
+		ERROR("Failed to allocate id index table\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	err = squashfs_read_table(sb, id_table, id_table_start, length);
+	if (err < 0) {
+		ERROR("unable to read id index table\n");
+		kfree(id_table);
+		return ERR_PTR(err);
+	}
+
+	return id_table;
+}
-- 
1.5.6.3

