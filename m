Return-Path: <linux-kernel-owner+w=401wt.eu-S1761839AbXHVMvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761839AbXHVMvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 08:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758821AbXHVMvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 08:51:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:41354 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758414AbXHVMvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 08:51:01 -0400
Date: Wed, 22 Aug 2007 15:09:32 +0200
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] UDF: handle wrong superblock better
Message-ID: <20070822130932.GB2868@duck.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  attached is a patch for UDF to better handle (i.e. don't Oops) the case when
we are not able to load table with extents of used / free space. This could
actually be considered a DOS... Andrew, please apply.
									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

--Dxnq1zWXvFF0Q93v
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="udf-2.6.23-rc3-mount_fix.diff"

If UDF superblock is incorrect, we can fail to find a table of free /
allocated space and consequently Oops. Handle this situation more
gracefully by ignoring the broken UDF partition.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.23-rc3-1-udf_fix/fs/udf/super.c linux-2.6.23-rc3-2-udf_mount_fix/fs/udf/super.c
--- linux-2.6.23-rc3-1-udf_fix/fs/udf/super.c	2007-08-21 14:11:44.000000000 +0200
+++ linux-2.6.23-rc3-2-udf_mount_fix/fs/udf/super.c	2007-08-21 18:29:40.000000000 +0200
@@ -89,7 +89,7 @@ static int udf_find_fileset(struct super
 static void udf_load_pvoldesc(struct super_block *, struct buffer_head *);
 static void udf_load_fileset(struct super_block *, struct buffer_head *,
 			     kernel_lb_addr *);
-static void udf_load_partdesc(struct super_block *, struct buffer_head *);
+static int udf_load_partdesc(struct super_block *, struct buffer_head *);
 static void udf_open_lvid(struct super_block *);
 static void udf_close_lvid(struct super_block *);
 static unsigned int udf_count_free(struct super_block *);
@@ -877,7 +877,7 @@ static void udf_load_fileset(struct supe
 		  root->logicalBlockNum, root->partitionReferenceNum);
 }
 
-static void udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
+static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
 {
 	struct partitionDesc *p;
 	int i;
@@ -912,6 +912,11 @@ static void udf_load_partdesc(struct sup
 
 					UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table =
 						udf_iget(sb, loc);
+					if (!UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table) {
+						udf_debug("cannot load unallocSpaceTable (part %d)\n",
+							i);
+						return 1;
+					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_UNALLOC_TABLE;
 					udf_debug("unallocSpaceTable (part %d) @ %ld\n",
 						  i, UDF_SB_PARTMAPS(sb)[i].s_uspace.s_table->i_ino);
@@ -938,6 +943,11 @@ static void udf_load_partdesc(struct sup
 
 					UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table =
 						udf_iget(sb, loc);
+					if (!UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table) {
+						udf_debug("cannot load freedSpaceTable (part %d)\n",
+							i);
+						return 1;
+					}
 					UDF_SB_PARTFLAGS(sb,i) |= UDF_PART_FLAG_FREED_TABLE;
 					udf_debug("freedSpaceTable (part %d) @ %ld\n",
 						  i, UDF_SB_PARTMAPS(sb)[i].s_fspace.s_table->i_ino);
@@ -966,6 +976,7 @@ static void udf_load_partdesc(struct sup
 			  le16_to_cpu(p->partitionNumber), i, UDF_SB_PARTTYPE(sb,i),
 			  UDF_SB_PARTROOT(sb,i), UDF_SB_PARTLEN(sb,i));
 	}
+	return 0;
 }
 
 static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
@@ -1177,12 +1188,19 @@ static int udf_process_sequence(struct s
 				udf_load_logicalvol(sb, bh, fileset);
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
-				udf_load_partdesc(sb, bh);
+				if (udf_load_partdesc(sb, bh)) {
+					brelse(bh);
+					return 1;
+				}
 				for (j = vds[i].block + 1; j <  vds[VDS_POS_TERMINATING_DESC].block; j++) {
 					bh2 = udf_read_tagged(sb, j, j, &ident);
 					gd = (struct generic_desc *)bh2->b_data;
 					if (ident == TAG_IDENT_PD)
-						udf_load_partdesc(sb, bh2);
+						if (udf_load_partdesc(sb, bh2)) {
+							brelse(bh);
+							brelse(bh2);
+							return 1;
+						}
 					brelse(bh2);
 				}
 			}

--Dxnq1zWXvFF0Q93v--
