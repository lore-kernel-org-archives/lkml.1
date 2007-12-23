Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbXLWBwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbXLWBwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756743AbXLWBwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:52:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbXLWBwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:52:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=r/ehUFKOEyxWDVONuyp2odHK3iA0pt/YTpQJ/kS7BKdsQ7yfYVAdBbO5Hk6sWVgwCobpmkzq22HOumCZoB+Pf0MZd5Q33mu8LiUHP8BItom5zOaBXZewaun83IeYOhR/64ttv0Mg40hqifCoMGbnfKZ3O3vJ8aO/1OsYaXvSB9U=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 08/24] udf: convert UDF_SB_ANCHOR macro to udf_sb_anchor function
Date: Sun, 23 Dec 2007 02:50:58 +0100
Message-Id: <1198374674-12128-9-git-send-email-marcin.slusarz@gmail.com>
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
 fs/udf/super.c  |   44 ++++++++++++++++++++++----------------------
 fs/udf/udf_sb.h |    6 +++++-
 2 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 903c0ec..0120ac6 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -677,20 +677,20 @@ static void udf_find_anchor(struct super_block *sb)
 			if (ident == TAG_IDENT_AVDP) {
 				if (location == last[i] - udf_sb_session(sb)) {
 					lastblock = last[i] - udf_sb_session(sb);
-					UDF_SB_ANCHOR(sb)[0] = lastblock;
-					UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
+					udf_sb_anchor(sb)[0] = lastblock;
+					udf_sb_anchor(sb)[1] = lastblock - 256;
 				} else if (location == udf_variable_to_fixed(last[i]) - udf_sb_session(sb)) {
 					UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
 					lastblock = udf_variable_to_fixed(last[i]) - udf_sb_session(sb);
-					UDF_SB_ANCHOR(sb)[0] = lastblock;
-					UDF_SB_ANCHOR(sb)[1] = lastblock - 256 - udf_sb_session(sb);
+					udf_sb_anchor(sb)[0] = lastblock;
+					udf_sb_anchor(sb)[1] = lastblock - 256 - udf_sb_session(sb);
 				} else {
 					udf_debug("Anchor found at block %d, location mismatch %d.\n",
 						  last[i], location);
 				}
 			} else if (ident == TAG_IDENT_FE || ident == TAG_IDENT_EFE) {
 				lastblock = last[i];
-				UDF_SB_ANCHOR(sb)[3] = 512;
+				udf_sb_anchor(sb)[3] = 512;
 			} else {
 				ident = location = 0;
 				if (last[i] >= 256) {
@@ -706,7 +706,7 @@ static void udf_find_anchor(struct super_block *sb)
 				if (ident == TAG_IDENT_AVDP &&
 				    location == last[i] - 256 - udf_sb_session(sb)) {
 					lastblock = last[i];
-					UDF_SB_ANCHOR(sb)[1] = last[i] - 256;
+					udf_sb_anchor(sb)[1] = last[i] - 256;
 				} else {
 					ident = location = 0;
 					if (last[i] >= 312 + udf_sb_session(sb)) {
@@ -723,7 +723,7 @@ static void udf_find_anchor(struct super_block *sb)
 					    location == udf_variable_to_fixed(last[i]) - 256) {
 						UDF_SET_FLAG(sb, UDF_FLAG_VARCONV);
 						lastblock = udf_variable_to_fixed(last[i]);
-						UDF_SB_ANCHOR(sb)[1] = lastblock - 256;
+						udf_sb_anchor(sb)[1] = lastblock - 256;
 					}
 				}
 			}
@@ -744,17 +744,17 @@ static void udf_find_anchor(struct super_block *sb)
 		}
 	}
 
-	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i]) {
-			bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
-					     UDF_SB_ANCHOR(sb)[i], &ident);
+	for (i = 0; i < ARRAY_SIZE(udf_sb(sb)->s_anchor); i++) {
+		if (udf_sb_anchor(sb)[i]) {
+			bh = udf_read_tagged(sb, udf_sb_anchor(sb)[i],
+					     udf_sb_anchor(sb)[i], &ident);
 			if (!bh)
-				UDF_SB_ANCHOR(sb)[i] = 0;
+				udf_sb_anchor(sb)[i] = 0;
 			else {
 				brelse(bh);
 				if ((ident != TAG_IDENT_AVDP) &&
 				    (i || (ident != TAG_IDENT_FE && ident != TAG_IDENT_EFE)))
-					UDF_SB_ANCHOR(sb)[i] = 0;
+					udf_sb_anchor(sb)[i] = 0;
 			}
 		}
 	}
@@ -1280,10 +1280,10 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 	if (!sb)
 		return 1;
 
-	for (i = 0; i < ARRAY_SIZE(UDF_SB_ANCHOR(sb)); i++) {
-		if (UDF_SB_ANCHOR(sb)[i] &&
-		    (bh = udf_read_tagged(sb, UDF_SB_ANCHOR(sb)[i],
-					  UDF_SB_ANCHOR(sb)[i], &ident))) {
+	for (i = 0; i < ARRAY_SIZE(udf_sb(sb)->s_anchor); i++) {
+		if (udf_sb_anchor(sb)[i] &&
+		    (bh = udf_read_tagged(sb, udf_sb_anchor(sb)[i],
+					  udf_sb_anchor(sb)[i], &ident))) {
 			anchor = (struct anchorVolDescPtr *)bh->b_data;
 
 			/* Locate the main sequence */
@@ -1308,11 +1308,11 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
 		}
 	}
 
-	if (i == ARRAY_SIZE(UDF_SB_ANCHOR(sb))) {
+	if (i == ARRAY_SIZE(udf_sb(sb)->s_anchor)) {
 		udf_debug("No Anchor block found\n");
 		return 1;
 	} else
-		udf_debug("Using anchor in block %d\n", UDF_SB_ANCHOR(sb)[i]);
+		udf_debug("Using anchor in block %d\n", udf_sb_anchor(sb)[i]);
 
 	for (i = 0; i < udf_sb_num_parts(sb); i++) {
 		kernel_lb_addr uninitialized_var(ino);
@@ -1513,9 +1513,9 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	udf_debug("Multi-session=%d\n", udf_sb_session(sb));
 
 	UDF_SB_LASTBLOCK(sb) = uopt.lastblock;
-	UDF_SB_ANCHOR(sb)[0] = UDF_SB_ANCHOR(sb)[1] = 0;
-	UDF_SB_ANCHOR(sb)[2] = uopt.anchor;
-	UDF_SB_ANCHOR(sb)[3] = 256;
+	udf_sb_anchor(sb)[0] = udf_sb_anchor(sb)[1] = 0;
+	udf_sb_anchor(sb)[2] = uopt.anchor;
+	udf_sb_anchor(sb)[3] = 256;
 
 	if (udf_check_valid(sb, uopt.novrs, silent)) {
 		/* read volume recognition sequences */
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index f33d38e..f00524f 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -75,6 +75,11 @@ static inline __s32 udf_sb_session(struct super_block *sb)
 	return udf_sb(sb)->s_session;
 }
 
+static inline __u32 *udf_sb_anchor(struct super_block *sb)
+{
+	return udf_sb(sb)->s_anchor;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -139,7 +144,6 @@ static inline __s32 udf_sb_session(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_ANCHOR(X)			( udf_sb(X)->s_anchor )
 #define UDF_SB_LASTBLOCK(X)			( udf_sb(X)->s_lastblock )
 #define UDF_SB_LVIDBH(X)			( udf_sb(X)->s_lvidbh )
 #define UDF_SB_LVID(X)				( (struct logicalVolIntegrityDesc *)UDF_SB_LVIDBH(X)->b_data )
-- 
1.5.3.4

