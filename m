Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbXLWBwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbXLWBwW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:52:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbXLWBwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:52:08 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbXLWBwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=xLA9CrWhzA+FHLwJz1mbSt5/OlY6pdV72+XxOsIKg5efgPHNnAtpWqFITkWCemcaHzQ9cRk6VxhBtJUlCATe1wVif6/uK7Oc+00pKttqBJ1k+23tZR3mexZ2goGtz7WSiHuT1dp4lT6Z2WaC9mshdEG46QLq0rIvkTqgYnKhw+M=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 07/24] udf: convert UDF_SB_SESSION macro to udf_sb_session function
Date: Sun, 23 Dec 2007 02:50:57 +0100
Message-Id: <1198374674-12128-8-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/misc.c   |    8 ++++----
 fs/udf/super.c  |   28 ++++++++++++++--------------
 fs/udf/udf_sb.h |    6 +++++-
 3 files changed, 23 insertions(+), 19 deletions(-)

diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 15297de..95baad5 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -197,10 +197,10 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 	if (block == 0xFFFFFFFF)
 		return NULL;
 
-	bh = udf_tread(sb, block + UDF_SB_SESSION(sb));
+	bh = udf_tread(sb, block + udf_sb_session(sb));
 	if (!bh) {
 		udf_debug("block=%d, location=%d: read failed\n",
-			  block + UDF_SB_SESSION(sb), location);
+			  block + udf_sb_session(sb), location);
 		return NULL;
 	}
 
@@ -210,7 +210,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 
 	if (location != le32_to_cpu(tag_p->tagLocation)) {
 		udf_debug("location mismatch block %u, tag %u != %u\n",
-			  block + UDF_SB_SESSION(sb), le32_to_cpu(tag_p->tagLocation), location);
+			  block + udf_sb_session(sb), le32_to_cpu(tag_p->tagLocation), location);
 		goto error_out;
 	}
 
@@ -240,7 +240,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
 		return bh;
 	}
 	udf_debug("Crc failure block %d: crc = %d, crclen = %d\n",
-		  block + UDF_SB_SESSION(sb), le16_to_cpu(tag_p->descCRC),
+		  block + udf_sb_session(sb), le16_to_cpu(tag_p->descCRC),
 		  le16_to_cpu(tag_p->descCRCLength));
 
 error_out:
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 452e6f6..903c0ec 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -548,7 +548,7 @@ static int udf_vrs(struct super_block *sb, int silent)
 	else
 		sectorsize = sb->s_blocksize;
 
-	sector += (UDF_SB_SESSION(sb) << sb->s_blocksize_bits);
+	sector += (udf_sb_session(sb) << sb->s_blocksize_bits);
 
 	udf_debug("Starting at sector %u (%ld byte sectors)\n",
 		  (sector >> sb->s_blocksize_bits), sb->s_blocksize);
@@ -614,7 +614,7 @@ static int udf_vrs(struct super_block *sb, int silent)
 		return nsr03;
 	else if (nsr02)
 		return nsr02;
-	else if (sector - (UDF_SB_SESSION(sb) << sb->s_blocksize_bits) == 32768)
+	else if (sector - (udf_sb_session(sb) << sb->s_blocksize_bits) == 32768)
 		return -1;
 	else
 		return 0;
@@ -675,15 +675,15 @@ static void udf_find_anchor(struct super_block *sb)
 			}
 
 			if (ident == TAG_IDENT_AVDP) {
-				if (location == last[i] - UDF_SB_SESSION(sb)) {
-					lastblock = last[i] - UDF_SB_SESSION(sb);
+				if (location == last[i] - udf_sb_session(sb)) {
+					lastblock = last[i] - udf_sb_session(sb);
 					UDF_SB_ANCHOR(sb)[0] = lastblock;
 					UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
-				} else if (location == udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb)) {
+				} else if (location == udf_variable_to_fixed(last[i]) - udf_sb_session(sb)) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
-					lastblock = udf_variable_to_fixed(last[i]) - UDF_SB_SESSION(sb);
+					lastblock = udf_variable_to_fixed(last[i]) - udf_sb_session(sb);
 					UDF_SB_ANCHOR(sb)[0] = lastblock;
-					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - UDF_SB_SESSION(sb);
+					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - udf_sb_session(sb);
 				} else {
 					udf_debug("Anchor found at block %d, location mismatch %d.\n",
 						  last[i], location);
@@ -704,13 +704,13 @@ static void udf_find_anchor(struct super_block *sb)
 				}
 
 				if (ident == TAG_IDENT_AVDP &&
-				    location == last[i] - 256 - UDF_SB_SESSION(sb)) {
+				    location == last[i] - 256 - udf_sb_session(sb)) {
 					lastblock = last[i];
 					UDF_SB_ANCHOR(sb)[1] = last[i] - 256;
 				} else {
 					ident = location = 0;
-					if (last[i] >= 312 + UDF_SB_SESSION(sb)) {
-						bh = sb_bread(sb, last[i] - 312 - UDF_SB_SESSION(sb));
+					if (last[i] >= 312 + udf_sb_session(sb)) {
+						bh = sb_bread(sb, last[i] - 312 - udf_sb_session(sb));
 						if (bh) {
 							tag *t = (tag *)bh->b_data;
 							ident = le16_to_cpu(t->tagIdent);
@@ -732,7 +732,7 @@ static void udf_find_anchor(struct super_block *sb)
 
 	if (!lastblock) {
 		/* We haven't found the lastblock. check 312 */
-		bh = sb_bread(sb, 312 + UDF_SB_SESSION(sb));
+		bh = sb_bread(sb, 312 + udf_sb_session(sb));
 		if (bh) {
 			tag *t = (tag *)bh->b_data;
 			ident = le16_to_cpu(t->tagIdent);
@@ -1506,11 +1506,11 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 
 	if (uopt.session == 0xFFFFFFFF)
-		UDF_SB_SESSION(sb) = udf_get_last_session(sb);
+		udf_sb(sb)->s_session = udf_get_last_session(sb);
 	else
-		UDF_SB_SESSION(sb) = uopt.session;
+		udf_sb(sb)->s_session = uopt.session;
 
-	udf_debug("Multi-session=%d\n", UDF_SB_SESSION(sb));
+	udf_debug("Multi-session=%d\n", udf_sb_session(sb));
 
 	UDF_SB_LASTBLOCK(sb) = uopt.lastblock;
 	UDF_SB_ANCHOR(sb)[0] = UDF_SB_ANCHOR(sb)[1] = 0;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 6eb9ef4..f33d38e 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -70,6 +70,11 @@ static inline __u16 udf_sb_partition(struct super_block *sb)
 	return udf_sb(sb)->s_partition;
 }
 
+static inline __s32 udf_sb_session(struct super_block *sb)
+{
+	return udf_sb(sb)->s_session;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -134,7 +139,6 @@ static inline __u16 udf_sb_partition(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_SESSION(X)			( udf_sb(X)->s_session )
 #define UDF_SB_ANCHOR(X)			( udf_sb(X)->s_anchor )
 #define UDF_SB_LASTBLOCK(X)			( udf_sb(X)->s_lastblock )
 #define UDF_SB_LVIDBH(X)			( udf_sb(X)->s_lvidbh )
-- 
1.5.3.4

