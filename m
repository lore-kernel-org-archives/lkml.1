Return-Path: <linux-kernel-owner+w=401wt.eu-S1762930AbXIKGQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762930AbXIKGQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762434AbXIKGFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:05:49 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:50593 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761815AbXIKGEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:04:35 -0400
Message-Id: <20070911060433.947172893@sgi.com>
References: <20070911060349.993975297@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 10 Sep 2007 23:04:26 -0700
From: Christoph Lameter <clameter@sgi.com>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Takashi Sato <sho@tnes.nec.co.jp>, Mingming Cao <cmm@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>
Cc: William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Badari Pulavarty <pbadari@gmail.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>
Cc: swin wang <wangswin@gmail.com>, totty.lu@gmail.com, hugh@veritas.com
Cc: joern@lazybastard.org
Subject: [36/41] 64k block size support for Ext2/3/4
Content-Disposition: inline; filename=0038-Large-Blocksize-support-for-Ext2-3-4.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The next 4 patches support large block size (up to PAGESIZE, max 64KB)
for ext2/3/4, originally from Takashi Sato.
http://marc.info/?l=linux-ext4&m=115768873518400&w=2

It's quite simple to support large block size in ext2/3/4, mostly just
enlarge the block size limit.  But it is NOT possible to have 64kB
blocksize on ext2/3/4 without some changes to the directory handling
code.  The reason is that an empty 64kB directory block would have a
rec_len == (__u16)2^16 == 0, and this would cause an error to be hit in
the filesystem.  The proposed solution is to put 2 empty records in such
a directory, or to special-case an impossible value like rec_len =
0xffff to handle this.

The Patch-set consists of the following 4 patches.
  [1/4]  ext2/3/4: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/4]  ext2: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

  [3/4]  ext3: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

  [4/4]  ext4: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Just rebase to 2.6.23-rc4 and against the ext4 patch queue. Compile tested only.

Next steps:
Need a e2fsprogs changes to able test this feature. As mkfs needs to be
educated not assuming rec_len to be blocksize all the time.
Will try it with Christoph Lameter's large block patch next.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 fs/ext2/super.c         |    2 +-
 fs/ext3/super.c         |    5 ++++-
 fs/ext4/super.c         |    5 +++++
 include/linux/ext2_fs.h |    4 ++--
 include/linux/ext3_fs.h |    4 ++--
 include/linux/ext4_fs.h |    4 ++--
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 639a32c..c149ded 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -775,7 +775,7 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, blocksize)) {
-			printk(KERN_ERR "EXT2-fs: blocksize too small for device.\n");
+			printk(KERN_ERR "EXT2-fs: bad blocksize %d.\n", blocksize);
 			goto failed_sbi;
 		}
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 22cfdd6..8f7d6a1 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1549,7 +1549,10 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		}
 
 		brelse (bh);
-		sb_set_blocksize(sb, blocksize);
+		if (!sb_set_blocksize(sb, blocksize)) {
+			printk(KERN_ERR "EXT3-fs: bad blocksize %d.\n", blocksize);
+			goto out_fail;
+		}
 		logic_sb_block = (sb_block * EXT3_MIN_BLOCK_SIZE) / blocksize;
 		offset = (sb_block * EXT3_MIN_BLOCK_SIZE) % blocksize;
 		bh = sb_bread(sb, logic_sb_block);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 4550b83..c504022 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1496,6 +1496,11 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
 		goto out_fail;
 	}
 
+	if (!sb_set_blocksize(sb, blocksize)) {
+		printk(KERN_ERR "EXT4-fs: bad blocksize %d.\n", blocksize);
+		goto out_fail;
+	}
+
 	/*
 	 * The ext4 superblock will not be buffer aligned for other than 1kB
 	 * block sizes.  We need to calculate the offset from buffer start.
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 153d755..910a705 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -86,8 +86,8 @@ static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
  * Macro-instructions used to manage several block sizes
  */
 #define EXT2_MIN_BLOCK_SIZE		1024
-#define	EXT2_MAX_BLOCK_SIZE		4096
-#define EXT2_MIN_BLOCK_LOG_SIZE		  10
+#define EXT2_MAX_BLOCK_SIZE		65536
+#define EXT2_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT2_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index ece49a8..7aa5556 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -76,8 +76,8 @@
  * Macro-instructions used to manage several block sizes
  */
 #define EXT3_MIN_BLOCK_SIZE		1024
-#define	EXT3_MAX_BLOCK_SIZE		4096
-#define EXT3_MIN_BLOCK_LOG_SIZE		  10
+#define	EXT3_MAX_BLOCK_SIZE		65536
+#define EXT3_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT3_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index cdee7aa..9e4518b 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -77,8 +77,8 @@
  * Macro-instructions used to manage several block sizes
  */
 #define EXT4_MIN_BLOCK_SIZE		1024
-#define	EXT4_MAX_BLOCK_SIZE		4096
-#define EXT4_MIN_BLOCK_LOG_SIZE		  10
+#define	EXT4_MAX_BLOCK_SIZE		65536
+#define EXT4_MIN_BLOCK_LOG_SIZE		10
 #ifdef __KERNEL__
 # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
-- 
1.5.2.5

-- 
