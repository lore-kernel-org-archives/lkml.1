Return-Path: <linux-kernel-owner+w=401wt.eu-S1761487AbYAVDJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761487AbYAVDJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbYAVDFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:05:33 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65372 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758982AbYAVDFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:05:30 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 16/49] ext2: Fix the max file size for ext2 file system.
Date: Mon, 21 Jan 2008 22:01:55 -0500
Message-Id: <1200970948-17903-17-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-16-git-send-email-tytso@mit.edu>
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
 <1200970948-17903-14-git-send-email-tytso@mit.edu>
 <1200970948-17903-15-git-send-email-tytso@mit.edu>
 <1200970948-17903-16-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The max file size for ext2 file system is now calculated
with hardcoded 4K block size. The patch fixes it to be
calculated with the right block size.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext2/super.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 154e25f..6abaf75 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -680,11 +680,31 @@ static int ext2_check_descriptors (struct super_block * sb)
 static loff_t ext2_max_size(int bits)
 {
 	loff_t res = EXT2_NDIR_BLOCKS;
-	/* This constant is calculated to be the largest file size for a
-	 * dense, 4k-blocksize file such that the total number of
+	int meta_blocks;
+	loff_t upper_limit;
+
+	/* This is calculated to be the largest file size for a
+	 * dense, file such that the total number of
 	 * sectors in the file, including data and all indirect blocks,
-	 * does not exceed 2^32. */
-	const loff_t upper_limit = 0x1ff7fffd000LL;
+	 * does not exceed 2^32 -1
+	 * __u32 i_blocks representing the total number of
+	 * 512 bytes blocks of the file
+	 */
+	upper_limit = (1LL << 32) - 1;
+
+	/* total blocks in file system block size */
+	upper_limit >>= (bits - 9);
+
+
+	/* indirect blocks */
+	meta_blocks = 1;
+	/* double indirect blocks */
+	meta_blocks += 1 + (1LL << (bits-2));
+	/* tripple indirect blocks */
+	meta_blocks += 1 + (1LL << (bits-2)) + (1LL << (2*(bits-2)));
+
+	upper_limit -= meta_blocks;
+	upper_limit <<= bits;
 
 	res += 1LL << (bits-2);
 	res += 1LL << (2*(bits-2));
@@ -692,6 +712,10 @@ static loff_t ext2_max_size(int bits)
 	res <<= bits;
 	if (res > upper_limit)
 		res = upper_limit;
+
+	if (res > MAX_LFS_FILESIZE)
+		res = MAX_LFS_FILESIZE;
+
 	return res;
 }
 
-- 
1.5.4.rc3.31.g1271-dirty

