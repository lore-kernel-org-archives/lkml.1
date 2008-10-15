Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbYJOOJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbYJOOJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYJOOFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:05:01 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45117 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbYJOOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:48 -0400
Subject: [PATCH 21/21] fat: i_blocks warning fix
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:01 +0900
Message-ID: <26b742873e848f5f6e92122369.ps@mail.parknet.co.jp>
References: <b4c7cd913e848f5f6e3122369.ps@mail.parknet.co.jp>
	<4e3b7e0f3e848f5f6e4222369.ps@mail.parknet.co.jp>
	<0f24bbb03e848f5f6e5322369.ps@mail.parknet.co.jp>
	<2dbbb6ea3e848f5f6e5422369.ps@mail.parknet.co.jp>
	<3adb30833e848f5f6e5522369.ps@mail.parknet.co.jp>
	<a36c25243e848f5f6e5622369.ps@mail.parknet.co.jp>
	<091baa8f3e848f5f6e6722369.ps@mail.parknet.co.jp>
	<649ecd633e848f5f6e6822369.ps@mail.parknet.co.jp>
	<2f7c69713e848f5f6e6922369.ps@mail.parknet.co.jp>
	<db8ca48d3e848f5f6e71022369.ps@mail.parknet.co.jp>
	<6caa18733e848f5f6e71122369.ps@mail.parknet.co.jp>
	<c862f7d73e848f5f6e71222369.ps@mail.parknet.co.jp>
	<5cfc12333e848f5f6e71322369.ps@mail.parknet.co.jp>
	<6b812e3e3e848f5f6e81422369.ps@mail.parknet.co.jp>
	<cd30496c3e848f5f6e81522369.ps@mail.parknet.co.jp>
	<056ecdb93e848f5f6e81622369.ps@mail.parknet.co.jp>
	<9562d38c3e848f5f6e81722369.ps@mail.parknet.co.jp>
	<e24598993e848f5f6e91822369.ps@mail.parknet.co.jp>
	<01d62c0f3e848f5f6e91922369.ps@mail.parknet.co.jp>
	<ed5d0b893e848f5f6e92022369.ps@mail.parknet.co.jp>
In-Reply-To: <ed5d0b893e848f5f6e92022369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


blkcnt_t type depends on CONFIG_LSF. Use unsigned long long always for
printk().  But lazy to type it, so add "llu" and use it.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/dir.c    |    2 +-
 fs/fat/fat.h    |    3 +++
 fs/fat/fatent.c |    5 ++---
 fs/fat/misc.c   |    5 +++--
 4 files changed, 9 insertions(+), 6 deletions(-)

diff -puN fs/fat/misc.c~fat-i_blocks-warn-fix fs/fat/misc.c
--- linux-2.6/fs/fat/misc.c~fat-i_blocks-warn-fix	2008-10-13 02:02:50.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/misc.c	2008-10-13 02:13:16.000000000 +0900
@@ -124,8 +124,9 @@ int fat_chain_add(struct inode *inode, i
 			mark_inode_dirty(inode);
 	}
 	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
-		fat_fs_panic(sb, "clusters badly computed (%d != %lu)",
-			new_fclus, inode->i_blocks >> (sbi->cluster_bits - 9));
+		fat_fs_panic(sb, "clusters badly computed (%d != %llu)",
+			     new_fclus,
+			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
 		fat_cache_inval_inode(inode);
 	}
 	inode->i_blocks += nr_cluster << (sbi->cluster_bits - 9);
diff -puN fs/fat/fat.h~fat-i_blocks-warn-fix fs/fat/fat.h
--- linux-2.6/fs/fat/fat.h~fat-i_blocks-warn-fix	2008-10-13 02:14:12.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fat.h	2008-10-13 02:17:52.000000000 +0900
@@ -323,4 +323,7 @@ extern int fat_sync_bhs(struct buffer_he
 int fat_cache_init(void);
 void fat_cache_destroy(void);
 
+/* helper for printk */
+typedef unsigned long long	llu;
+
 #endif /* !_FAT_H */
diff -puN fs/fat/dir.c~fat-i_blocks-warn-fix fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat-i_blocks-warn-fix	2008-10-13 02:15:43.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-10-13 02:15:50.000000000 +0900
@@ -86,7 +86,7 @@ next:
 	*bh = sb_bread(sb, phys);
 	if (*bh == NULL) {
 		printk(KERN_ERR "FAT: Directory bread(block %llu) failed\n",
-		       (unsigned long long)phys);
+		       (llu)phys);
 		/* skip this block */
 		*pos = (iblock + 1) << sb->s_blocksize_bits;
 		goto next;
diff -puN fs/fat/fatent.c~fat-i_blocks-warn-fix fs/fat/fatent.c
--- linux-2.6/fs/fat/fatent.c~fat-i_blocks-warn-fix	2008-10-13 02:16:13.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fatent.c	2008-10-13 02:16:26.000000000 +0900
@@ -93,8 +93,7 @@ static int fat12_ent_bread(struct super_
 err_brelse:
 	brelse(bhs[0]);
 err:
-	printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n",
-	       (unsigned long long)blocknr);
+	printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n", (llu)blocknr);
 	return -EIO;
 }
 
@@ -107,7 +106,7 @@ static int fat_ent_bread(struct super_bl
 	fatent->bhs[0] = sb_bread(sb, blocknr);
 	if (!fatent->bhs[0]) {
 		printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n",
-		       (unsigned long long)blocknr);
+		       (llu)blocknr);
 		return -EIO;
 	}
 	fatent->nr_bhs = 1;
_
