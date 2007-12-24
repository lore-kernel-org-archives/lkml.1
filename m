Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbXLXAKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbXLXAKq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 19:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbXLXAKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 19:10:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:36145 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbXLXAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 19:10:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Zk/ncUwxp5Zqg3kb4JZiJ52pdTNnWy/kKO+fEnk8ZPZb4/kLt51VvHLpClESHSN8K2rrAJSKZ+ENraQRbzhj+GVl62YJVBOoFrQSKbO1VpLKOmx6AHoGFMpS2hHrftbRK7+1X9UcEUlK7rVVHQZ6uuQC789pni7HpK6AotAQhjg=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 3/6] udf: convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
Date: Mon, 24 Dec 2007 01:10:19 +0100
Message-Id: <1198455022-27674-4-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198455022-27674-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- convert UDF_SB_ALLOC_PARTMAPS macro to udf_sb_alloc_partition_maps function
- convert kmalloc + memset to kzalloc
- check if kzalloc failed (partially)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>
---
 fs/udf/super.c  |   20 ++++++++++++++++++--
 fs/udf/udf_sb.h |   13 -------------
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 246868c..0ea34c5 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -53,6 +53,7 @@
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
 #include <asm/byteorder.h>
+#include <linux/errno.h>
 
 #include <linux/udf_fs.h>
 #include "udf_sb.h"
@@ -226,6 +227,19 @@ static void __exit exit_udf_fs(void)
 module_init(init_udf_fs)
 module_exit(exit_udf_fs)
 
+static int __must_check udf_sb_alloc_partition_maps(struct super_block *sb, __u32 count)
+{
+	struct udf_sb_info *sbi = UDF_SB(sb);
+	sbi->s_partmaps = kzalloc(sizeof(struct udf_part_map) * count, GFP_KERNEL);
+	if (sbi->s_partmaps != NULL)
+		sbi->s_partitions = count;
+	else {
+		sbi->s_partitions = 0;
+		udf_error(sb, __FUNCTION__, "Unable to allocate space for %d partition maps", count);
+	}
+	return sbi->s_partmaps != NULL ? 0 : -ENOMEM;
+}
+
 /*
  * udf_parse_options
  *
@@ -1037,7 +1051,9 @@ static int udf_load_logicalvol(struct super_block *sb, struct buffer_head *bh,
 
 	lvd = (struct logicalVolDesc *)bh->b_data;
 
-	UDF_SB_ALLOC_PARTMAPS(sb, le32_to_cpu(lvd->numPartitionMaps));
+	i = udf_sb_alloc_partition_maps(sb, le32_to_cpu(lvd->numPartitionMaps));
+	if (i != 0)
+		return i;
 
 	for (i = 0, offset = 0;
 	     i < sbi->s_partitions && offset < le32_to_cpu(lvd->mapTableLength);
@@ -1242,7 +1258,7 @@ static int udf_process_sequence(struct super_block *sb, long block,
 			if (i == VDS_POS_PRIMARY_VOL_DESC) {
 				udf_load_pvoldesc(sb, bh);
 			} else if (i == VDS_POS_LOGICAL_VOL_DESC) {
-				udf_load_logicalvol(sb, bh, fileset);
+				udf_load_logicalvol(sb, bh, fileset); /* TODO: check return value */
 			} else if (i == VDS_POS_PARTITION_DESC) {
 				struct buffer_head *bh2 = NULL;
 				if (udf_load_partdesc(sb, bh)) {
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 92e6d75..4d3bd77 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -43,19 +43,6 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
 
 struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);
 
-#define UDF_SB_ALLOC_PARTMAPS(X,Y)\
-{\
-	struct udf_sb_info *sbi = UDF_SB(X);\
-	sbi->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
-	if (sbi->s_partmaps != NULL) {\
-		sbi->s_partitions = Y;\
-		memset(sbi->s_partmaps, 0x00, sizeof(struct udf_part_map) * Y);\
-	} else {\
-		sbi->s_partitions = 0;\
-		udf_error(X, __FUNCTION__, "Unable to allocate space for %d partition maps", Y);\
-	}\
-}
-
 #define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
 {\
 	struct udf_sb_info *sbi = UDF_SB(X);\
-- 
1.5.3.4

