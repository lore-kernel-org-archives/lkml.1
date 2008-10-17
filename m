Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYJQPoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYJQPoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755687AbYJQPnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:43:08 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:36836 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbYJQPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:43:00 -0400
To: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Subject: [PATCH 08/16] Squashfs: fragment block operations
Message-Id: <E1KqrTX-0001xj-19@dylan>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Fri, 17 Oct 2008 16:42:51 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/fragment.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/fs/squashfs/fragment.c b/fs/squashfs/fragment.c
new file mode 100644
index 0000000..4a23e83
--- /dev/null
+++ b/fs/squashfs/fragment.c
@@ -0,0 +1,89 @@
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
+#include <linux/squashfs_fs.h>
+#include <linux/squashfs_fs_sb.h>
+#include <linux/squashfs_fs_i.h>
+
+#include "squashfs.h"
+
+int get_fragment_location(struct super_block *s, unsigned int fragment,
+				long long *fragment_block)
+{
+	struct squashfs_sb_info *msblk = s->s_fs_info;
+	int block = SQUASHFS_FRAGMENT_INDEX(fragment);
+	int offset = SQUASHFS_FRAGMENT_INDEX_OFFSET(fragment);
+	long long start_block = le64_to_cpu(msblk->fragment_index[block]);
+	struct squashfs_fragment_entry fragment_entry;
+	int size = 0;
+
+	if (!squashfs_read_metadata(s, &fragment_entry, start_block, offset,
+				 sizeof(fragment_entry), &start_block, &offset))
+		goto out;
+
+	*fragment_block = le64_to_cpu(fragment_entry.start_block);
+	size = le32_to_cpu(fragment_entry.size);
+
+out:
+	return size;
+}
+
+
+__le64 *read_fragment_index_table(struct super_block *s,
+	long long fragment_table_start, unsigned int fragments)
+{
+	unsigned int length = SQUASHFS_FRAGMENT_INDEX_BYTES(fragments);
+	__le64 *fragment_index;
+
+	/* Allocate fragment index table */
+	fragment_index = kmalloc(length, GFP_KERNEL);
+	if (fragment_index == NULL) {
+		ERROR("Failed to allocate fragment index table\n");
+		return NULL;
+	}
+
+	if (!squashfs_read_data(s, fragment_index, fragment_table_start,
+			length | SQUASHFS_COMPRESSED_BIT_BLOCK, NULL, length)) {
+		ERROR("unable to read fragment index table\n");
+		kfree(fragment_index);
+		return NULL;
+	}
+
+	return fragment_index;
+}
-- 
1.5.2.5

