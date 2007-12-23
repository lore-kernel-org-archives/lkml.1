Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbXLWBvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbXLWBvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 20:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756254AbXLWBvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 20:51:05 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:51028 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249AbXLWBvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 20:51:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=ImXRh62LD0ET1CkUuyZMPac8qb9gquI1d+x1+tI87CmFoqXlVg/jcE+DLptuenRdJO7b6TXML7wFziMxdYA53w6jZsIyaijWOhnad97ncTVskTLLcubr1+S8V9Gd0j9l/ftDflVRGrwapmMNO2NZm7zwjzfpqNTfZrplY2AudG0=
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 04/24] udf: convert UDF_SB_VOLIDENT macro to udf_sb_volume_ident function
Date: Sun, 23 Dec 2007 02:50:54 +0100
Message-Id: <1198374674-12128-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com>
From: marcin.slusarz@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- change UDF_SB_VOLIDENT macro to udf_sb_volume_ident inline function
- rename s_volident field to s_volume_ident

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
CC: Jan Kara <jack@suse.cz>
---
 fs/udf/file.c             |    2 +-
 fs/udf/super.c            |    6 +++---
 fs/udf/udf_sb.h           |    6 +++++-
 include/linux/udf_fs_sb.h |    2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/udf/file.c b/fs/udf/file.c
index 7c7a1b3..7b61dae 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -192,7 +192,7 @@ int udf_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 	switch (cmd) {
 	case UDF_GETVOLIDENT:
 		return copy_to_user((char __user *)arg,
-				    UDF_SB_VOLIDENT(inode->i_sb), 32) ? -EFAULT : 0;
+				    udf_sb_volume_ident(inode->i_sb), 32) ? -EFAULT : 0;
 	case UDF_RELOCATE_BLOCKS:
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 2c68272..42de326 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -873,9 +873,9 @@ static void udf_load_pvoldesc(struct super_block *sb, struct buffer_head *bh)
 
 	if (!udf_build_ustr(&instr, pvoldesc->volIdent, 32)) {
 		if (udf_CS0toUTF8(&outstr, &instr)) {
-			strncpy(UDF_SB_VOLIDENT(sb), outstr.u_name,
+			strncpy(udf_sb_volume_ident(sb), outstr.u_name,
 				outstr.u_len > 31 ? 31 : outstr.u_len);
-			udf_debug("volIdent[] = '%s'\n", UDF_SB_VOLIDENT(sb));
+			udf_debug("volIdent[] = '%s'\n", udf_sb_volume_ident(sb));
 		}
 	}
 
@@ -1582,7 +1582,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		udf_info("UDF %s (%s) Mounting volume '%s', "
 			 "timestamp %04u/%02u/%02u %02u:%02u (%x)\n",
 			 UDFFS_VERSION, UDFFS_DATE,
-			 UDF_SB_VOLIDENT(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
+			 udf_sb_volume_ident(sb), ts.year, ts.month, ts.day, ts.hour, ts.minute,
 			 ts.typeAndTimezone);
 	}
 	if (!(sb->s_flags & MS_RDONLY))
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 46ddfb0..fa7fdff 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -55,6 +55,11 @@ static inline void udf_sb_free(struct super_block *sb)
 	}
 }
 
+static inline __u8 *udf_sb_volume_ident(struct super_block *sb)
+{
+	return udf_sb(sb)->s_volume_ident;
+}
+
 #define UDF_SB_ALLOC_PARTMAPS(X,Y)\
 {\
 	udf_sb(X)->s_partmaps = kmalloc(sizeof(struct udf_part_map) * Y, GFP_KERNEL);\
@@ -119,7 +124,6 @@ static inline void udf_sb_free(struct super_block *sb)
 #define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
 #define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
 
-#define UDF_SB_VOLIDENT(X)			( udf_sb(X)->s_volident )
 #define UDF_SB_NUMPARTS(X)			( udf_sb(X)->s_partitions )
 #define UDF_SB_PARTITION(X)			( udf_sb(X)->s_partition )
 #define UDF_SB_SESSION(X)			( udf_sb(X)->s_session )
diff --git a/include/linux/udf_fs_sb.h b/include/linux/udf_fs_sb.h
index 80ae9ef..a1addf6 100644
--- a/include/linux/udf_fs_sb.h
+++ b/include/linux/udf_fs_sb.h
@@ -75,7 +75,7 @@ struct udf_part_map
 struct udf_sb_info
 {
 	struct udf_part_map	*s_partmaps;
-	__u8			s_volident[32];
+	__u8			s_volume_ident[32];
 
 	/* Overall info */
 	__u16			s_partitions;
-- 
1.5.3.4

