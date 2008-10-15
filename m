Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYJOOGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYJOOGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 10:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbYJOOEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 10:04:53 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:45120 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYJOOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 10:04:48 -0400
Subject: [PATCH 19/21] fat: mmu_private race fix
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Wed, 15 Oct 2008 22:58:01 +0900
Message-ID: <01d62c0f3e848f5f6e91922369.ps@mail.parknet.co.jp>
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
In-Reply-To: <e24598993e848f5f6e91822369.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mmu_private is 64bits value, hence it's not atomic to update.

So, the access rule for mmu_private is we must hold ->i_mutex.  But,
fat_get_block() path doesn't follow the rule on non-allocation path.

This fixes by using i_size instead if non-allocation path.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/cache.c |   23 ++++++++++++++++++-----
 fs/fat/dir.c   |    2 +-
 fs/fat/fat.h   |    6 ++++--
 fs/fat/inode.c |    4 ++--
 4 files changed, 25 insertions(+), 10 deletions(-)

diff -puN fs/fat/cache.c~fat-mmu_private-race-fix fs/fat/cache.c
--- linux-2.6/fs/fat/cache.c~fat-mmu_private-race-fix	2008-09-29 13:58:53.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/cache.c	2008-09-29 19:08:39.000000000 +0900
@@ -293,10 +293,12 @@ static int fat_bmap_cluster(struct inode
 }
 
 int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
-	     unsigned long *mapped_blocks)
+	     unsigned long *mapped_blocks, int create)
 {
 	struct super_block *sb = inode->i_sb;
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
+	const unsigned long blocksize = sb->s_blocksize;
+	const unsigned char blocksize_bits = sb->s_blocksize_bits;
 	sector_t last_block;
 	int cluster, offset;
 
@@ -309,10 +311,21 @@ int fat_bmap(struct inode *inode, sector
 		}
 		return 0;
 	}
-	last_block = (MSDOS_I(inode)->mmu_private + (sb->s_blocksize - 1))
-		>> sb->s_blocksize_bits;
-	if (sector >= last_block)
-		return 0;
+
+	last_block = (i_size_read(inode) + (blocksize - 1)) >> blocksize_bits;
+	if (sector >= last_block) {
+		if (!create)
+			return 0;
+
+		/*
+		 * ->mmu_private can access on only allocation path.
+		 * (caller must hold ->i_mutex)
+		 */
+		last_block = (MSDOS_I(inode)->mmu_private + (blocksize - 1))
+			>> blocksize_bits;
+		if (sector >= last_block)
+			return 0;
+	}
 
 	cluster = sector >> (sbi->cluster_bits - sb->s_blocksize_bits);
 	offset  = sector & (sbi->sec_per_clus - 1);
diff -puN fs/fat/dir.c~fat-mmu_private-race-fix fs/fat/dir.c
--- linux-2.6/fs/fat/dir.c~fat-mmu_private-race-fix	2008-09-29 13:58:53.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/dir.c	2008-09-29 19:08:39.000000000 +0900
@@ -77,7 +77,7 @@ next:
 
 	*bh = NULL;
 	iblock = *pos >> sb->s_blocksize_bits;
-	err = fat_bmap(dir, iblock, &phys, &mapped_blocks);
+	err = fat_bmap(dir, iblock, &phys, &mapped_blocks, 0);
 	if (err || !phys)
 		return -1;	/* beyond EOF or error */
 
diff -puN fs/fat/fat.h~fat-mmu_private-race-fix fs/fat/fat.h
--- linux-2.6/fs/fat/fat.h~fat-mmu_private-race-fix	2008-09-29 13:58:53.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fat.h	2008-09-29 19:14:24.000000000 +0900
@@ -91,7 +91,9 @@ struct msdos_inode_info {
 	/* for avoiding the race between fat_free() and fat_get_cluster() */
 	unsigned int cache_valid_id;
 
-	loff_t mmu_private;
+	/* NOTE: mmu_private is 64bits, so must hold ->i_mutex to access */
+	loff_t mmu_private;	/* physically allocated size */
+
 	int i_start;		/* first cluster or 0 */
 	int i_logstart;		/* logical first cluster */
 	int i_attrs;		/* unused attribute bits */
@@ -222,7 +224,7 @@ extern void fat_cache_inval_inode(struct
 extern int fat_get_cluster(struct inode *inode, int cluster,
 			   int *fclus, int *dclus);
 extern int fat_bmap(struct inode *inode, sector_t sector, sector_t *phys,
-		    unsigned long *mapped_blocks);
+		    unsigned long *mapped_blocks, int create);
 
 /* fat/dir.c */
 extern const struct file_operations fat_dir_operations;
diff -puN fs/fat/inode.c~fat-mmu_private-race-fix fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat-mmu_private-race-fix	2008-09-29 13:58:53.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-09-29 19:08:40.000000000 +0900
@@ -64,7 +64,7 @@ static inline int __fat_get_block(struct
 	sector_t phys;
 	int err, offset;
 
-	err = fat_bmap(inode, iblock, &phys, &mapped_blocks);
+	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
 		return err;
 	if (phys) {
@@ -94,7 +94,7 @@ static inline int __fat_get_block(struct
 	*max_blocks = min(mapped_blocks, *max_blocks);
 	MSDOS_I(inode)->mmu_private += *max_blocks << sb->s_blocksize_bits;
 
-	err = fat_bmap(inode, iblock, &phys, &mapped_blocks);
+	err = fat_bmap(inode, iblock, &phys, &mapped_blocks, create);
 	if (err)
 		return err;
 
_
