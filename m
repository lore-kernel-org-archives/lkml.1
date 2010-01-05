Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661Ab0AEUJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0AEUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755623Ab0AEUJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:09:42 -0500
Received: from kroah.org ([198.145.64.141]:50037 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497Ab0AEUGV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:21 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:02 2010
Message-Id: <20100105200302.477162944@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:23 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Jan Kara <jack@suse.cz>
Subject: [27/39] udf: Try harder when looking for VAT inode
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit e971b0b9e0dd50d9ceecb67a6a6ab80a80906033 upstream.

Some disks do not contain VAT inode in the last recorded block as required
by the standard but a few blocks earlier (or the number of recorded blocks
is wrong). So look for the VAT inode a bit before the end of the media.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/udf/super.c |   32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1078,21 +1078,39 @@ static int udf_fill_partdesc_info(struct
 	return 0;
 }
 
-static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
+static void udf_find_vat_block(struct super_block *sb, int p_index,
+			       int type1_index, sector_t start_block)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map = &sbi->s_partmaps[p_index];
+	sector_t vat_block;
 	struct kernel_lb_addr ino;
+
+	/*
+	 * VAT file entry is in the last recorded block. Some broken disks have
+	 * it a few blocks before so try a bit harder...
+	 */
+	ino.partitionReferenceNum = type1_index;
+	for (vat_block = start_block;
+	     vat_block >= map->s_partition_root &&
+	     vat_block >= start_block - 3 &&
+	     !sbi->s_vat_inode; vat_block--) {
+		ino.logicalBlockNum = vat_block - map->s_partition_root;
+		sbi->s_vat_inode = udf_iget(sb, &ino);
+	}
+}
+
+static int udf_load_vat(struct super_block *sb, int p_index, int type1_index)
+{
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	struct udf_part_map *map = &sbi->s_partmaps[p_index];
 	struct buffer_head *bh = NULL;
 	struct udf_inode_info *vati;
 	uint32_t pos;
 	struct virtualAllocationTable20 *vat20;
 	sector_t blocks = sb->s_bdev->bd_inode->i_size >> sb->s_blocksize_bits;
 
-	/* VAT file entry is in the last recorded block */
-	ino.partitionReferenceNum = type1_index;
-	ino.logicalBlockNum = sbi->s_last_block - map->s_partition_root;
-	sbi->s_vat_inode = udf_iget(sb, &ino);
+	udf_find_vat_block(sb, p_index, type1_index, sbi->s_last_block);
 	if (!sbi->s_vat_inode &&
 	    sbi->s_last_block != blocks - 1) {
 		printk(KERN_NOTICE "UDF-fs: Failed to read VAT inode from the"
@@ -1100,9 +1118,7 @@ static int udf_load_vat(struct super_blo
 		       "block of the device (%lu).\n",
 		       (unsigned long)sbi->s_last_block,
 		       (unsigned long)blocks - 1);
-		ino.partitionReferenceNum = type1_index;
-		ino.logicalBlockNum = blocks - 1 - map->s_partition_root;
-		sbi->s_vat_inode = udf_iget(sb, &ino);
+		udf_find_vat_block(sb, p_index, type1_index, blocks - 1);
 	}
 	if (!sbi->s_vat_inode)
 		return 1;


