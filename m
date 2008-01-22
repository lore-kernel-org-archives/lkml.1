Return-Path: <linux-kernel-owner+w=401wt.eu-S1762848AbYAVDQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762848AbYAVDQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758021AbYAVDHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:07:04 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:33003 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758296AbYAVDHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:07:00 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 13/49] ext4: different maxbytes functions for bitmap & extent	files
Date: Mon, 21 Jan 2008 22:01:52 -0500
Message-Id: <1200970948-17903-14-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-13-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
 <1200970948-17903-2-git-send-email-tytso@mit.edu>
 <1200970948-17903-3-git-send-email-tytso@mit.edu>
 <1200970948-17903-4-git-send-email-tytso@mit.edu>
 <1200970948-17903-5-git-send-email-tytso@mit.edu>
 <1200970948-17903-6-git-send-email-tytso@mit.edu>
 <1200970948-17903-7-git-send-email-tytso@mit.edu>
 <1200970948-17903-8-git-send-email-tytso@mit.edu>
 <1200970948-17903-9-git-send-email-tytso@mit.edu>
 <1200970948-17903-10-git-send-email-tytso@mit.edu>
 <1200970948-17903-11-git-send-email-tytso@mit.edu>
 <1200970948-17903-12-git-send-email-tytso@mit.edu>
 <1200970948-17903-13-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

use 2 different maxbytes functions for bitmapped & extent-based
files.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 fs/ext4/super.c |   45 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 64067de..c79e46b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1600,19 +1600,58 @@ static void ext4_orphan_cleanup (struct super_block * sb,
 #endif
 	sb->s_flags = s_flags; /* Restore MS_RDONLY status */
 }
+/*
+ * Maximal extent format file size.
+ * Resulting logical blkno at s_maxbytes must fit in our on-disk
+ * extent format containers, within a sector_t, and within i_blocks
+ * in the vfs.  ext4 inode has 48 bits of i_block in fsblock units,
+ * so that won't be a limiting factor.
+ *
+ * Note, this does *not* consider any metadata overhead for vfs i_blocks.
+ */
+static loff_t ext4_max_size(int blkbits)
+{
+	loff_t res;
+	loff_t upper_limit = MAX_LFS_FILESIZE;
+
+	/* small i_blocks in vfs inode? */
+	if (sizeof(blkcnt_t) < sizeof(u64)) {
+		/*
+		 * CONFIG_LSF is not enabled implies the inode
+		 * i_block represent total blocks in 512 bytes
+		 * 32 == size of vfs inode i_blocks * 8
+		 */
+		upper_limit = (1LL << 32) - 1;
+
+		/* total blocks in file system block size */
+		upper_limit >>= (blkbits - 9);
+		upper_limit <<= blkbits;
+	}
+
+	/* 32-bit extent-start container, ee_block */
+	res = 1LL << 32;
+	res <<= blkbits;
+	res -= 1;
+
+	/* Sanity check against vm- & vfs- imposed limits */
+	if (res > upper_limit)
+		res = upper_limit;
+
+	return res;
+}
 
 /*
- * Maximal file size.  There is a direct, and {,double-,triple-}indirect
+ * Maximal bitmap file size.  There is a direct, and {,double-,triple-}indirect
  * block limit, and also a limit of (2^48 - 1) 512-byte sectors in i_blocks.
  * We need to be 1 filesystem block less than the 2^48 sector limit.
  */
-static loff_t ext4_max_size(int bits)
+static loff_t ext4_max_bitmap_size(int bits)
 {
 	loff_t res = EXT4_NDIR_BLOCKS;
 	int meta_blocks;
 	loff_t upper_limit;
 	/* This is calculated to be the largest file size for a
-	 * dense, file such that the total number of
+	 * dense, bitmapped file such that the total number of
 	 * sectors in the file, including data and all indirect blocks,
 	 * does not exceed 2^48 -1
 	 * __u32 i_blocks_lo and _u16 i_blocks_high representing the
-- 
1.5.4.rc3.31.g1271-dirty

