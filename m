Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbXLWBw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbXLWBw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:52:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755052AbXLWBws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:52:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388AbXLWBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:52:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=yEwxjgGs8l8XieTOIfgL0/nTxx0iYXnWnbuqx+wz+sVEqiZjJqGMo761kbbx1IAXnCODn2N+Kkw/bLjefzEzcsSFHGymac4RuL6htVqJhWVmN8rkmwgooAU1tNMbaoyeYKl6oHlFVvy8nzFgPSYJqOh4uStCs1LSgg6u0Yzvl2Y=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 09/24] udf: convert UDF_SB_LASTBLOCK macro to udf_sb_last_block function
Date: Sun, 23 Dec 2007 02:50:59 +0100
Message-Id: <1198374674-12128-10-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change UDF_SB_LASTBLOCK macro to udf_sb_last_block inline function
- rename s_lastblock field to s_last_block

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/super.c            |   20 ++++++++++----------
 fs/udf/udf_sb.h           |    6 +++++-
 include/linux/udf_fs_sb.h |    2 +-
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 0120ac6..e641d8f 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -639,7 +639,7 @@ static int udf_vrs(struct super_block *sb, int silent)
  */
 static void udf_find_anchor(struct super_block *sb)
 {
-	int lastblock = UDF_SB_LASTBLOCK(sb);
+	int lastblock = udf_sb_last_block(sb);
 	struct buffer_head *bh = NULL;
 	uint16_t ident;
 	uint32_t location;
@@ -759,7 +759,7 @@ static void udf_find_anchor(struct super_block *sb)
 		}
 	}
 
-	UDF_SB_LASTBLOCK(sb) = lastblock;
+	udf_sb(sb)->s_last_block = lastblock;
 }
 
 static int udf_find_fileset(struct super_block *sb,
@@ -1261,8 +1261,8 @@ static int udf_check_valid(struct super_block *sb, int novrs, int silent)
 		if (block == -1) {
 			udf_debug("Failed to read byte 32768. Assuming open "
 				  "disc. Skipping validity check\n");
-			if (!UDF_SB_LASTBLOCK(sb))
-				UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
+			if (!udf_sb_last_block(sb))
+				udf_sb(sb)->s_last_block = udf_get_last_block(sb);
 			return 0;
 		} else
 			return !block;
@@ -1319,12 +1319,12 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 		switch (UDF_SB_PARTTYPE(sb, i)) {
 		case UDF_VIRTUAL_MAP15:
 		case UDF_VIRTUAL_MAP20:
-			if (!UDF_SB_LASTBLOCK(sb)) {
-				UDF_SB_LASTBLOCK(sb) = udf_get_last_block(sb);
+			if (!udf_sb_last_block(sb)) {
+				udf_sb(sb)->s_last_block = udf_get_last_block(sb);
 				udf_find_anchor(sb);
 			}
 
-			if (!UDF_SB_LASTBLOCK(sb)) {
+			if (!udf_sb_last_block(sb)) {
 				udf_debug("Unable to determine Lastblock (For "
 					  "Virtual Partition)\n");
 				return 1;
@@ -1335,7 +1335,7 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 				    UDF_SB_PARTVSN(sb, i) == UDF_SB_PARTVSN(sb, j) &&
 				    UDF_SB_PARTNUM(sb, i) == UDF_SB_PARTNUM(sb, j)) {
 					ino.partitionReferenceNum = j;
-					ino.logicalBlockNum = UDF_SB_LASTBLOCK(sb) - UDF_SB_PARTROOT(sb, j);
+					ino.logicalBlockNum = udf_sb_last_block(sb) - UDF_SB_PARTROOT(sb, j);
 					break;
 				}
 			}
@@ -1512,7 +1512,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 	udf_debug("Multi-session=%d\n", udf_sb_session(sb));
 
-	UDF_SB_LASTBLOCK(sb) = uopt.lastblock;
+	udf_sb(sb)->s_last_block = uopt.lastblock;
 	udf_sb_anchor(sb)[0] = udf_sb_anchor(sb)[1] = 0;
 	udf_sb_anchor(sb)[2] = uopt.anchor;
 	udf_sb_anchor(sb)[3] = 256;
@@ -1537,7 +1537,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 
-	udf_debug("Lastblock=%d\n", UDF_SB_LASTBLOCK(sb));
+	udf_debug("Lastblock=%d\n", udf_sb_last_block(sb));
 
 	if (UDF_SB_LVIDBH(sb)) {
 		uint16_t minUDFReadRev = le16_to_cpu(UDF_SB_LVIDIU(sb)->minUDFReadRev);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index f00524f..ea4ec0f 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -80,6 +80,11 @@ static inline __u32 *udf_sb_anchor(struct super_block *sb)
 	return udf_sb(sb)->s_anchor;
 }
 
+static inline __u32 udf_sb_last_block(struct super_block *sb)
+{
+	return udf_sb(sb)->s_last_block;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -144,7 +149,6 @@ static inline __u32 *udf_sb_anchor(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_LASTBLOCK(X)			( udf_sb(X)->s_lastblock )
 #define UDF_SB_LVIDBH(X)			( udf_sb(X)->s_lvidbh )
 #define UDF_SB_LVID(X)				( (struct logicalVolIntegrityDesc *)UDF_SB_LVIDBH(X)->b_data )
 #define UDF_SB_LVIDIU(X)			( (struct logicalVolIntegrityDescImpUse *)&(UDF_SB_LVID(X)->impUse[le32_to_cpu(UDF_SB_LVID(X)->numOfPartitions) * 2 * sizeof(uint32_t)/sizeof(uint8_t)]) )
diff --git a/include/linux/udf_fs_sb.h b/include/linux/udf_fs_sb.h
index a1addf6..2f46ce6 100644
--- a/include/linux/udf_fs_sb.h
+++ b/include/linux/udf_fs_sb.h
@@ -84,7 +84,7 @@ struct udf_sb_info
 	/* Sector headers */
 	__s32			s_session;
 	__u32			s_anchor[4];
-	__u32			s_lastblock;
+	__u32			s_last_block;
 
 	struct buffer_head	*s_lvidbh;
 
-- 
1.5.3.4

