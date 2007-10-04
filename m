Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbXJDF7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbXJDF7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758636AbXJDFwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:52:09 -0400
Received: from THUNK.ORG ([69.25.196.29]:44849 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbXJDFvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:51:11 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, "Jose R. Santos" <jrs@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] This feature relaxes check restrictions on where each block groups meta
Date: Thu,  4 Oct 2007 01:50:46 -0400
Message-Id: <1191477059-5357-12-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.3.2.81.g17ed
In-Reply-To: <1191477059-5357-11-git-send-email-tytso@mit.edu>
References: <1191477059-5357-1-git-send-email-tytso@mit.edu>
 <1191477059-5357-2-git-send-email-tytso@mit.edu>
 <1191477059-5357-3-git-send-email-tytso@mit.edu>
 <1191477059-5357-4-git-send-email-tytso@mit.edu>
 <1191477059-5357-5-git-send-email-tytso@mit.edu>
 <1191477059-5357-6-git-send-email-tytso@mit.edu>
 <1191477059-5357-7-git-send-email-tytso@mit.edu>
 <1191477059-5357-8-git-send-email-tytso@mit.edu>
 <1191477059-5357-9-git-send-email-tytso@mit.edu>
 <1191477059-5357-10-git-send-email-tytso@mit.edu>
 <1191477059-5357-11-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

data is located within the storage media.  This allows for the allocation
of bitmaps or inode tables outside the block group boundaries in cases
where bad blocks forces us to look for new blocks which the owning block
group can not satisfy.  This will also allow for new meta-data allocation
schemes to improve performance and scalability.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 fs/ext4/super.c         |    9 +++++++--
 include/linux/ext4_fs.h |    4 +++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b59610d..619db84 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1287,13 +1287,17 @@ static int ext4_check_descriptors (struct super_block * sb)
 	ext4_fsblk_t inode_table;
 	struct ext4_group_desc * gdp = NULL;
 	int desc_block = 0;
+	int flexbg_flag = 0;
 	int i;
 
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		flexbg_flag = 1;
+
 	ext4_debug ("Checking group descriptors");
 
 	for (i = 0; i < sbi->s_groups_count; i++)
 	{
-		if (i == sbi->s_groups_count - 1)
+		if (i == sbi->s_groups_count - 1 || flexbg_flag)
 			last_block = ext4_blocks_count(sbi->s_es) - 1;
 		else
 			last_block = first_block +
@@ -1338,7 +1342,8 @@ static int ext4_check_descriptors (struct super_block * sb)
 				   le16_to_cpu(gdp->bg_checksum));
 			return 0;
 		}
-		first_block += EXT4_BLOCKS_PER_GROUP(sb);
+		if (!flexbg_flag)
+			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 		gdp = (struct ext4_group_desc *)
 			((__u8 *)gdp + EXT4_DESC_SIZE(sb));
 	}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 722d4ef..46b304d 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -682,13 +682,15 @@ static inline int ext4_valid_inum(struct super_block *sb, unsigned long ino)
 #define EXT4_FEATURE_INCOMPAT_META_BG		0x0010
 #define EXT4_FEATURE_INCOMPAT_EXTENTS		0x0040 /* extents support */
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 
 #define EXT4_FEATURE_COMPAT_SUPP	EXT2_FEATURE_COMPAT_EXT_ATTR
 #define EXT4_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
 					 EXT4_FEATURE_INCOMPAT_RECOVER| \
 					 EXT4_FEATURE_INCOMPAT_META_BG| \
 					 EXT4_FEATURE_INCOMPAT_EXTENTS| \
-					 EXT4_FEATURE_INCOMPAT_64BIT)
+					 EXT4_FEATURE_INCOMPAT_64BIT| \
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
-- 
1.5.3.2.81.g17ed

