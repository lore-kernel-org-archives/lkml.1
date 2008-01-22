Return-Path: <linux-kernel-owner+w=401wt.eu-S1759039AbYAVDKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039AbYAVDKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 22:10:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759066AbYAVDFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 22:05:35 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:65372 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757501AbYAVDFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 22:05:31 -0500
From: "Theodore Ts'o" <tytso@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 17/49] ext3: Fix the max file size for ext3 file system.
Date: Mon, 21 Jan 2008 22:01:56 -0500
Message-Id: <1200970948-17903-18-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.4.rc3.31.g1271-dirty
In-Reply-To: <1200970948-17903-17-git-send-email-tytso@mit.edu>
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
 <1200970948-17903-17-git-send-email-tytso@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The max file size for ext3 file system is now calculated
with hardcoded 4K block size. The patch fixes it to be
calculated with the right block size.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext3/super.c |   32 ++++++++++++++++++++++++++++----
 1 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cb14de1..f3675cc 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1436,11 +1436,31 @@ static void ext3_orphan_cleanup (struct super_block * sb,
 static loff_t ext3_max_size(int bits)
 {
 	loff_t res = EXT3_NDIR_BLOCKS;
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
@@ -1448,6 +1468,10 @@ static loff_t ext3_max_size(int bits)
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

