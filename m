Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbYDLW7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbYDLW7o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 18:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755769AbYDLW6v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 18:58:51 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:35382 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbYDLW6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 18:58:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/7] omfs: add bitmap routines
Date: Sat, 12 Apr 2008 18:58:39 -0400
Message-Id: <1208041121-26787-6-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Add block allocation and block bitmap management routines for OMFS.

    Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/bitmap.c |  195 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 195 insertions(+), 0 deletions(-)
 create mode 100644 fs/omfs/bitmap.c

diff --git a/fs/omfs/bitmap.c b/fs/omfs/bitmap.c
new file mode 100644
index 0000000..888c1ce
--- /dev/null
+++ b/fs/omfs/bitmap.c
@@ -0,0 +1,195 @@
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/buffer_head.h>
+#include <asm/div64.h>
+#include "omfs.h"
+
+unsigned long omfs_count_free(struct super_block *sb)
+{
+	unsigned int i, j;
+	u64 *map;
+	unsigned long sum = 0;
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+
+	for (i = 0; i < sbi->s_imap_size; i++) {
+		map = (u64 *) sbi->s_imap[i];
+		for (j = 0; j < sb->s_blocksize / 8; j++)
+			sum += hweight64(~map[j]);
+	}
+	return sum;
+}
+
+/*
+ *  Counts the run of zero bits starting at bit up to max.
+ *  It handles the case where a run might spill over a buffer.
+ *  Called with bitmap lock.
+ */
+static int count_run(unsigned long **addr, int nbits,
+		int addrlen, int bit, int max)
+{
+	int count = 0;
+	int x;
+
+	for (; addrlen > 0; addrlen--, addr++) {
+		x = find_next_bit(*addr, nbits, bit);
+		count += x - bit;
+
+		if (x < nbits || count > max)
+			return min(count, max);
+
+		bit = 0;
+	}
+	return min(count, max);
+}
+
+/*
+ * Sets or clears the run of count bits starting with bit.
+ * Called with bitmap lock.
+ */
+static int set_run(struct super_block *sb, int map,
+		int nbits, int bit, int count, int set)
+{
+	int i;
+	struct buffer_head *bh;
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+
+	bh = sb_bread(sb, clus_to_blk(sbi, sbi->s_bitmap_ino) + map);
+	if (!bh)
+		goto nomem;
+
+	for (i = 0; i < count; i++, bit++) {
+		if (bit >= nbits) {
+			bit = 0;
+			map++;
+
+			mark_buffer_dirty(bh);
+			brelse(bh);
+			bh = sb_bread(sb,
+				clus_to_blk(sbi, sbi->s_bitmap_ino) + map);
+			if (!bh)
+				goto nomem;
+		}
+		if (set) {
+			set_bit(bit, sbi->s_imap[map]);
+			set_bit(bit, (long *) bh->b_data);
+		} else {
+			clear_bit(bit, sbi->s_imap[map]);
+			clear_bit(bit, (long *) bh->b_data);
+		}
+	}
+	mark_buffer_dirty(bh);
+	brelse(bh);
+	return 0;
+nomem:
+	return -ENOMEM;
+}
+
+/*
+ * Tries to allocate exactly one block.  Returns true if sucessful.
+ */
+int omfs_allocate_block(struct super_block *sb, u64 block)
+{
+	struct buffer_head *bh;
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+	int bits_per_entry = 8 * sb->s_blocksize;
+	int map, bit;
+	int ret = 1;
+	u64 tmp;
+
+	tmp = block;
+	bit = do_div(tmp, bits_per_entry);
+	map = tmp;
+
+	mutex_lock(&sbi->s_bitmap_lock);
+	if (map >= sbi->s_imap_size ||
+	    test_and_set_bit(bit, sbi->s_imap[map])) {
+		ret = 0;
+		goto out;
+	}
+
+	if (sbi->s_bitmap_ino > 0) {
+		bh = sb_bread(sb, clus_to_blk(sbi, sbi->s_bitmap_ino) + map);
+		if (!bh) {
+			ret = 0;
+			goto out;
+		}
+		set_bit(bit, (long *) bh->b_data);
+		mark_buffer_dirty(bh);
+		brelse(bh);
+	}
+out:
+	mutex_unlock(&sbi->s_bitmap_lock);
+	return ret;
+}
+
+
+/*
+ *  Tries to allocate a set of blocks.	The request size depends on the
+ *  type: for inodes, we must allocate sbi->s_mirrors blocks, and for file
+ *  blocks, we try to allocate sbi->s_clustersize, but can always get away
+ *  with just one block.
+ */
+int omfs_allocate_range(struct super_block *sb,
+			int min_request,
+			int max_request,
+			u64 *return_block,
+			int *return_size)
+{
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+	int bits_per_entry = 8 * sb->s_blocksize;
+	int ret = 0;
+	int i, run, bit;
+
+	mutex_lock(&sbi->s_bitmap_lock);
+	for (i = 0; i < sbi->s_imap_size; i++) {
+		bit = 0;
+		while (bit < bits_per_entry) {
+			bit = find_next_zero_bit(sbi->s_imap[i], bits_per_entry,
+				bit);
+
+			if (bit == bits_per_entry)
+				break;
+
+			run = count_run(&sbi->s_imap[i], bits_per_entry,
+				sbi->s_imap_size-i, bit, max_request);
+
+			if (run >= min_request)
+				goto found;
+			bit += run;
+		}
+	}
+	ret = -ENOSPC;
+	goto out;
+
+found:
+	*return_block = i * bits_per_entry + bit;
+	*return_size = run;
+	ret = set_run(sb, i, bits_per_entry, bit, run, 1);
+
+out:
+	mutex_unlock(&sbi->s_bitmap_lock);
+	return ret;
+}
+
+/*
+ * Clears count bits starting at a given block.
+ */
+int omfs_clear_range(struct super_block *sb, u64 block, int count)
+{
+	struct omfs_sb_info *sbi = OMFS_SB(sb);
+	int bits_per_entry = 8 * sb->s_blocksize;
+	u64 tmp;
+	int map, bit, ret;
+
+	tmp = block;
+	bit = do_div(tmp, bits_per_entry);
+	map = tmp;
+
+	if (map >= sbi->s_imap_size)
+		return 0;
+
+	mutex_lock(&sbi->s_bitmap_lock);
+	ret = set_run(sb, map, bits_per_entry, bit, count, 0);
+	mutex_unlock(&sbi->s_bitmap_lock);
+	return ret;
+}
-- 
1.5.4.2


