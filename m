Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbYAJWJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbYAJWJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759966AbYAJWJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:09:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:37438 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759963AbYAJWJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=VHuSnCrs+rTsBsCGlI4D+utFh5pTeLeEzm9R+N+Ny2jfX5PT7QNDyPmvax5O2ydcCRPsmdEn8a+Pvb0a7+6u9+NfUmNsfmc3ZxYFRsSpFea9oRyn90U7QWZMQPbMddx1aD3BN4Uj22iLhsYyiTpQ6Jlj1DS2qRJt0YE1keEdcAM=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 11/16] udf: replace loops coded with goto to real loops
Date: Thu, 10 Jan 2008 23:06:27 +0100
Message-Id: <1200002792-8449-12-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/balloc.c |  118 +++++++++++++++++++++++++++---------------------------
 1 files changed, 59 insertions(+), 59 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 78dbf1d..df55d9f 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -183,46 +183,46 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 	block = bloc.logicalBlockNum + offset +
 		(sizeof(struct spaceBitmapDesc) << 3);
 
-do_more:
-	overflow = 0;
-	block_group = block >> (sb->s_blocksize_bits + 3);
-	bit = block % (sb->s_blocksize << 3);
+	do {
+		overflow = 0;
+		block_group = block >> (sb->s_blocksize_bits + 3);
+		bit = block % (sb->s_blocksize << 3);
 
-	/*
-	 * Check to see if we are freeing blocks across a group boundary.
-	 */
-	if (bit + count > (sb->s_blocksize << 3)) {
-		overflow = bit + count - (sb->s_blocksize << 3);
-		count -= overflow;
-	}
-	bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
-	if (bitmap_nr < 0)
-		goto error_return;
+		/*
+		* Check to see if we are freeing blocks across a group boundary.
+		*/
+		if (bit + count > (sb->s_blocksize << 3)) {
+			overflow = bit + count - (sb->s_blocksize << 3);
+			count -= overflow;
+		}
+		bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
+		if (bitmap_nr < 0)
+			goto error_return;
 
-	bh = bitmap->s_block_bitmap[bitmap_nr];
-	for (i = 0; i < count; i++) {
-		if (udf_set_bit(bit + i, bh->b_data)) {
-			udf_debug("bit %ld already set\n", bit + i);
-			udf_debug("byte=%2x\n",
-				  ((char *)bh->b_data)[(bit + i) >> 3]);
-		} else {
-			if (inode)
-				DQUOT_FREE_BLOCK(inode, 1);
-			udf_inc_free_space(sbi, sbi->s_partition, 1);
+		bh = bitmap->s_block_bitmap[bitmap_nr];
+		for (i = 0; i < count; i++) {
+			if (udf_set_bit(bit + i, bh->b_data)) {
+				udf_debug("bit %ld already set\n", bit + i);
+				udf_debug("byte=%2x\n",
+					((char *)bh->b_data)[(bit + i) >> 3]);
+			} else {
+				if (inode)
+					DQUOT_FREE_BLOCK(inode, 1);
+				udf_inc_free_space(sbi, sbi->s_partition, 1);
+			}
 		}
-	}
-	mark_buffer_dirty(bh);
-	if (overflow) {
-		block += count;
-		count = overflow;
-		goto do_more;
-	}
+		mark_buffer_dirty(bh);
+		if (overflow) {
+			block += count;
+			count = overflow;
+		}
+	} while (overflow);
+
 error_return:
 	sb->s_dirt = 1;
 	if (sbi->s_lvid_bh)
 		mark_buffer_dirty(sbi->s_lvid_bh);
 	mutex_unlock(&sbi->s_alloc_mutex);
-	return;
 }
 
 static int udf_bitmap_prealloc_blocks(struct super_block *sb,
@@ -246,37 +246,37 @@ static int udf_bitmap_prealloc_blocks(struct super_block *sb,
 	if (first_block + block_count > part_len)
 		block_count = part_len - first_block;
 
-repeat:
-	nr_groups = udf_compute_nr_groups(sb, partition);
-	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
-	block_group = block >> (sb->s_blocksize_bits + 3);
-	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
+	do {
+		nr_groups = udf_compute_nr_groups(sb, partition);
+		block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
+		block_group = block >> (sb->s_blocksize_bits + 3);
+		group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
 
-	bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
-	if (bitmap_nr < 0)
-		goto out;
-	bh = bitmap->s_block_bitmap[bitmap_nr];
+		bitmap_nr = load_block_bitmap(sb, bitmap, block_group);
+		if (bitmap_nr < 0)
+			goto out;
+		bh = bitmap->s_block_bitmap[bitmap_nr];
 
-	bit = block % (sb->s_blocksize << 3);
+		bit = block % (sb->s_blocksize << 3);
 
-	while (bit < (sb->s_blocksize << 3) && block_count > 0) {
-		if (!udf_test_bit(bit, bh->b_data)) {
-			goto out;
-		} else if (DQUOT_PREALLOC_BLOCK(inode, 1)) {
-			goto out;
-		} else if (!udf_clear_bit(bit, bh->b_data)) {
-			udf_debug("bit already cleared for block %d\n", bit);
-			DQUOT_FREE_BLOCK(inode, 1);
-			goto out;
+		while (bit < (sb->s_blocksize << 3) && block_count > 0) {
+			if (!udf_test_bit(bit, bh->b_data))
+				goto out;
+			else if (DQUOT_PREALLOC_BLOCK(inode, 1))
+				goto out;
+			else if (!udf_clear_bit(bit, bh->b_data)) {
+				udf_debug("bit already cleared for block %d\n", bit);
+				DQUOT_FREE_BLOCK(inode, 1);
+				goto out;
+			}
+			block_count--;
+			alloc_count++;
+			bit++;
+			block++;
 		}
-		block_count--;
-		alloc_count++;
-		bit++;
-		block++;
-	}
-	mark_buffer_dirty(bh);
-	if (block_count > 0)
-		goto repeat;
+		mark_buffer_dirty(bh);
+	} while (block_count > 0);
+
 out:
 	if (udf_inc_free_space(sbi, partition, -alloc_count))
 		mark_buffer_dirty(sbi->s_lvid_bh);
-- 
1.5.3.7

