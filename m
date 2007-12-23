Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbXLWBz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbXLWBz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXLWBzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:55:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbXLWBzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:55:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Q6KQGJiJBeRToUO+sM12o5ZPm7iREbB4/SD0yJqFoEki/6gg6vtHnygJEPZHKjXRst/r1jTwwOfKgDk39d/qcVXTexKrokXfAQQYrHQ6Hl8sbNtqQ3eCZDiAn8zYKA45i9MIse4oOJPgAniBa7b1q40FDAiKr3VT/cgFSI8S+Q0=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 15/24] udf: convert UDF_SB_SERIALNUM macro to udf_sb_serial_number function
Date: Sun, 23 Dec 2007 02:51:05 +0100
Message-Id: <1198374674-12128-16-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change UDF_SB_SERIALNUM macro to udf_sb_serial_number inline function
- rename s_serialnum field to s_serial_number

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/inode.c            |    2 +-
 fs/udf/misc.c             |    2 +-
 fs/udf/super.c            |    2 +-
 fs/udf/udf_sb.h           |    6 +++++-
 include/linux/udf_fs_sb.h |    2 +-
 5 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 8c725e2..46cf40c 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1541,7 +1541,7 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 		fe->descTag.descVersion = cpu_to_le16(3);
 	else
 		fe->descTag.descVersion = cpu_to_le16(2);
-	fe->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
+	fe->descTag.tagSerialNum = cpu_to_le16(udf_sb_serial_number(inode->i_sb));
 	fe->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 	crclen += UDF_I_LENEATTR(inode) + UDF_I_LENALLOC(inode) - sizeof(tag);
 	fe->descTag.descCRCLength = cpu_to_le16(crclen);
diff --git a/fs/udf/misc.c b/fs/udf/misc.c
index 95baad5..42d731a 100644
--- a/fs/udf/misc.c
+++ b/fs/udf/misc.c
@@ -88,7 +88,7 @@ struct genericFormat *udf_add_extendedattr(struct inode *inode, uint32_t size,
 				eahd->descTag.descVersion = cpu_to_le16(3);
 			else
 				eahd->descTag.descVersion = cpu_to_le16(2);
-			eahd->descTag.tagSerialNum = cpu_to_le16(UDF_SB_SERIALNUM(inode->i_sb));
+			eahd->descTag.tagSerialNum = cpu_to_le16(udf_sb_serial_number(inode->i_sb));
 			eahd->descTag.tagLocation = cpu_to_le32(UDF_I_LOCATION(inode).logicalBlockNum);
 			eahd->impAttrLocation = cpu_to_le32(0xFFFFFFFF);
 			eahd->appAttrLocation = cpu_to_le32(0xFFFFFFFF);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index eb01f25..5a2c474 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -894,7 +894,7 @@ static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
 
 	*root = lelb_to_cpu(fset->rootDirectoryICB.extLocation);
 
-	UDF_SB_SERIALNUM(sb) = le16_to_cpu(fset->descTag.tagSerialNum);
+	udf_sb(sb)->s_serial_number = le16_to_cpu(fset->descTag.tagSerialNum);
 
 	udf_debug("Rootdir at block=%d, partition=%d\n",
 		  root->logicalBlockNum, root->partitionReferenceNum);
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index e9346c2..bae6a74 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -108,6 +108,11 @@ static inline struct timespec udf_sb_record_time(struct super_block *sb)
 	return udf_sb(sb)->s_record_time;
 }
 
+static inline __u16 udf_sb_serial_number(struct super_block *sb)
+{
+	return udf_sb(sb)->s_serial_number;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -172,7 +177,6 @@ static inline struct timespec udf_sb_record_time(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_SERIALNUM(X)			( udf_sb(X)->s_serialnum )
 #define UDF_SB_UDFREV(X)			( udf_sb(X)->s_udfrev )
 #define UDF_SB_VAT(X)				( udf_sb(X)->s_vat )
 
diff --git a/include/linux/udf_fs_sb.h b/include/linux/udf_fs_sb.h
index adfecc6..dd16deb 100644
--- a/include/linux/udf_fs_sb.h
+++ b/include/linux/udf_fs_sb.h
@@ -97,7 +97,7 @@ struct udf_sb_info
 	struct timespec		s_record_time;
 
 	/* Fileset Info */
-	__u16			s_serialnum;
+	__u16			s_serial_number;
 
 	/* highest UDF revision we have recorded to this media */
 	__u16			s_udfrev;
-- 
1.5.3.4

