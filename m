Return-Path: <linux-kernel-owner+w=401wt.eu-S1755384AbZBDDHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384AbZBDDHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 22:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbZBDDG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 22:06:58 -0500
Received: from lon1-post-2.mail.demon.net ([195.173.77.149]:38757 "EHLO
	lon1-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752751AbZBDDG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 22:06:57 -0500
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, snakebyte@gmx.de, sliedes@cc.hut.fi
Subject: [PATCH] Squashfs: Fix oops when reading fsfuzzer corrupted filesystems
Cc: phillip@lougher.demon.co.uk
Message-Id: <E1LUY7A-0006q4-LB@dylan.lougher.demon.co.uk>
From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 04 Feb 2009 03:07:48 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch should fix a couple of reported oopses when mounting
fsfuzzer corrupted filesystems.

These oopses have been raised in this thread
http://marc.info/?l=linux-fsdevel&m=123212794425497&w=2

and on the kernel bug tracker
http://bugzilla.kernel.org/show_bug.cgi?id=12479

The patch is also available in the squashfs git tree here
git://git.kernel.org/pub/scm/linux/kernel/git/pkl/squashfs-linus.git

Feedback to confirm they fix the reported oopses welcome.

Thanks

Phillip

From: Phillip Lougher <phillip@lougher.demon.co.uk>
Date: Wed, 4 Feb 2009 02:31:29 +0000
Subject: [PATCH] Squashfs: Fix oops when reading fsfuzzer corrupted filesystems

This fixes a code regression caused by the recent mainlining changes.
Zlib sometimes tries to output more data than expected when
decompressing corrupted data.   The recent code changes call
zlib_inflate repeatedly, decompressing into separate 4K buffers, this
code didn't check for the possibility that zlib_inflate might ask
for too many buffers.

Signed-off-by: Phillip Lougher <phillip@lougher.demon.co.uk>
---
 fs/squashfs/block.c    |   12 ++++++++++--
 fs/squashfs/cache.c    |    4 ++--
 fs/squashfs/squashfs.h |    2 +-
 fs/squashfs/super.c    |    2 +-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/squashfs/block.c b/fs/squashfs/block.c
index c837dfc..1edd836 100644
--- a/fs/squashfs/block.c
+++ b/fs/squashfs/block.c
@@ -80,7 +80,7 @@ static struct buffer_head *get_block_length(struct super_block *sb,
  * generated a larger block - this does occasionally happen with zlib).
  */
 int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
-			int length, u64 *next_index, int srclength)
+			int length, u64 *next_index, int srclength, int pages)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct buffer_head **bh;
@@ -185,6 +185,14 @@ int squashfs_read_data(struct super_block *sb, void **buffer, u64 index,
 			}
 
 			if (msblk->stream.avail_out == 0) {
+				if (page == pages) {
+					ERROR("zlib_inflate tried to "
+						"decompress too much data, "
+						"expected %d bytes.  Zlib "
+						"data probably corrupt\n",
+						srclength);
+					goto release_mutex;
+				}
 				msblk->stream.next_out = buffer[page++];
 				msblk->stream.avail_out = PAGE_CACHE_SIZE;
 			}
@@ -268,7 +276,7 @@ block_release:
 		put_bh(bh[k]);
 
 read_failure:
-	ERROR("sb_bread failed reading block 0x%llx\n", cur_index);
+	ERROR("squashfs_read_data failed to read block 0x%llx\n", index);
 	kfree(bh);
 	return -EIO;
 }
diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index f29eda1..1c4739e 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -119,7 +119,7 @@ struct squashfs_cache_entry *squashfs_cache_get(struct super_block *sb,
 
 			entry->length = squashfs_read_data(sb, entry->data,
 				block, length, &entry->next_index,
-				cache->block_size);
+				cache->block_size, cache->pages);
 
 			spin_lock(&cache->lock);
 
@@ -406,7 +406,7 @@ int squashfs_read_table(struct super_block *sb, void *buffer, u64 block,
 	for (i = 0; i < pages; i++, buffer += PAGE_CACHE_SIZE)
 		data[i] = buffer;
 	res = squashfs_read_data(sb, data, block, length |
-		SQUASHFS_COMPRESSED_BIT_BLOCK, NULL, length);
+		SQUASHFS_COMPRESSED_BIT_BLOCK, NULL, length, pages);
 	kfree(data);
 	return res;
 }
diff --git a/fs/squashfs/squashfs.h b/fs/squashfs/squashfs.h
index 6b2515d..0e9feb6 100644
--- a/fs/squashfs/squashfs.h
+++ b/fs/squashfs/squashfs.h
@@ -34,7 +34,7 @@ static inline struct squashfs_inode_info *squashfs_i(struct inode *inode)
 
 /* block.c */
 extern int squashfs_read_data(struct super_block *, void **, u64, int, u64 *,
-				int);
+				int, int);
 
 /* cache.c */
 extern struct squashfs_cache *squashfs_cache_init(char *, int, int);
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index a0466d7..f0d82a9 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -388,7 +388,7 @@ static int __init init_squashfs_fs(void)
 		return err;
 	}
 
-	printk(KERN_INFO "squashfs: version 4.0 (2009/01/03) "
+	printk(KERN_INFO "squashfs: version 4.0 (2009/01/31) "
 		"Phillip Lougher\n");
 
 	return 0;
-- 
1.5.6.3

