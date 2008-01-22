Return-Path: <linux-kernel-owner+w=401wt.eu-S1757009AbYAVDDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbYAVDDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYAVDC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:02:57 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64681 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754977AbYAVDCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:02:55 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Takashi Sato <sho@tnes.nec.co.jp>, Mingming Cao <cmm@us.ibm.com>
Subject: [PATCH 01/49] ext4:  Support large blocksize up to PAGESIZE
Date: Mon, 21 Jan 2008 22:01:40 -0500
Message-Id: <1200970948-17903-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-1-git-send-email-tytso@mit.edu>
References: <1200970948-17903-1-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Sato <sho@tnes.nec.co.jp>

This patch set supports large block size(>4k, <=64k) in ext4,
just enlarging the block size limit. But it is NOT possible to have 64kB
blocksize on ext4 without some changes to the directory handling
code.  The reason is that an empty 64kB directory block would have a
rec_len == (__u16)2^16 == 0, and this would cause an error to be hit in
the filesystem.  The proposed solution is treat 64k rec_len
with a an impossible value like rec_len = 0xffff to handle this.

The Patch-set consists of the following 2 patches.
  [1/2]  ext4: enlarge blocksize
         - Allow blocksize up to pagesize

  [2/2]  ext4: fix rec_len overflow
         - prevent rec_len from overflow with 64KB blocksize

Now on 64k page ppc64 box runs with this patch set we could create a 64k
block size ext4dev, and able to handle empty directory block.

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/super.c         |    5 +++++
 include/linux/ext4_fs.h |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 1ca0f54..ab7010d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1624,6 +1624,11 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
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
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 97dd409..dfe4487 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -73,8 +73,8 @@
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
1.5.4.rc3.31.g1271-dirty

