Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbZAEL2B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbZAEL2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:28:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZAEL1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:27:21 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:55218 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803AbZAEL1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:27:20 -0500
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com, sfr@canb.auug.org.au
Subject: [PATCH V3 08/17] Squashfs: fragment block operations
Message-Id: <E1LJnJn-0002Lc-Rx@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Mon, 05 Jan 2009 11:08:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/fragment.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/fragment.c b/fs/squashfs/fragment.c
new file mode 100644
index 0000000..b5a2c15
--- /dev/null
+++ b/fs/squashfs/fragment.c
@@ -0,0 +1,98 @@
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
+ * fragment.c
+ */
+
+/*
+ * This file implements code to handle compressed fragments (tail-end packed
+ * datablocks).
+ *
+ * Regular files contain a fragment index which is mapped to a fragment
+ * location on disk and compressed size using a fragment lookup table.
+ * Like everything in Squashfs this fragment lookup table is itself stored
+ * compressed into metadata blocks.  A second index table is used to locate
+ * these.  This second index table for speed of access (and because it
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
+ * Look-up fragment using the fragment index table.  Return the on disk
+ * location of the fragment and its compressed size
+ */
+int squashfs_frag_lookup(struct super_block *sb, unsigned int fragment,
+				u64 *fragment_block)
+{
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	int block = SQUASHFS_FRAGMENT_INDEX(fragment);
+	int offset = SQUASHFS_FRAGMENT_INDEX_OFFSET(fragment);
+	u64 start_block = le64_to_cpu(msblk->fragment_index[block]);
+	struct squashfs_fragment_entry fragment_entry;
+	int size;
+
+	size = squashfs_read_metadata(sb, &fragment_entry, &start_block,
+					&offset, sizeof(fragment_entry));
+	if (size < 0)
+		return size;
+
+	*fragment_block = le64_to_cpu(fragment_entry.start_block);
+	size = le32_to_cpu(fragment_entry.size);
+
+	return size;
+}
+
+
+/*
+ * Read the uncompressed fragment lookup table indexes off disk into memory
+ */
+__le64 *squashfs_read_fragment_index_table(struct super_block *sb,
+	u64 fragment_table_start, unsigned int fragments)
+{
+	unsigned int length = SQUASHFS_FRAGMENT_INDEX_BYTES(fragments);
+	__le64 *fragment_index;
+	int err;
+
+	/* Allocate fragment lookup table indexes */
+	fragment_index = kmalloc(length, GFP_KERNEL);
+	if (fragment_index == NULL) {
+		ERROR("Failed to allocate fragment index table\n");
+		return ERR_PTR(-ENOMEM);
+	}
+
+	err = squashfs_read_table(sb, fragment_index, fragment_table_start,
+			length);
+	if (err < 0) {
+		ERROR("unable to read fragment index table\n");
+		kfree(fragment_index);
+		return ERR_PTR(err);
+	}
+
+	return fragment_index;
+}
-- 
1.5.6.3

