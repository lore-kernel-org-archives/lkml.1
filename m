Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYDTS3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYDTS3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 14:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753966AbYDTS3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 14:29:35 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40069 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbYDTS3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 14:29:34 -0400
Subject: [PATCH 5/9] fat: Update free_clusters even if it is untrusted
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, hirofumi@mail.parknet.co.jp
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 21 Apr 2008 03:13:27 +0900
Message-ID: <89121f633e8480b87c755695.ps@mail.parknet.co.jp>
References: <60d0156a3e8480b87c215695.ps@mail.parknet.co.jp>
	<5cb1b5773e8480b87c425695.ps@mail.parknet.co.jp>
	<954304cc3e8480b87c535695.ps@mail.parknet.co.jp>
	<f6f833103e8480b87c645695.ps@mail.parknet.co.jp>
In-Reply-To: <f6f833103e8480b87c645695.ps@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, free_clusters is not updated until it is trusted, because
Windows doesn't update it correctly.

But if user is using FAT driver of Linux, it updates free_clusters
correctly.  Instead, this updates it even if it's untrusted, so if
free_clustes is correct, now keep correct value.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/fat/fatent.c          |    7 +++++--
 fs/fat/inode.c           |    7 ++++---
 include/linux/msdos_fs.h |    1 +
 3 files changed, 10 insertions(+), 5 deletions(-)

diff -puN include/linux/msdos_fs.h~fat_fix-free_clusters-check include/linux/msdos_fs.h
--- linux-2.6/include/linux/msdos_fs.h~fat_fix-free_clusters-check	2008-03-14 05:38:40.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/msdos_fs.h	2008-03-14 05:38:40.000000000 +0900
@@ -233,6 +233,7 @@ struct msdos_sb_info {
 	struct mutex fat_lock;
 	unsigned int prev_free;      /* previously allocated cluster number */
 	unsigned int free_clusters;  /* -1 if undefined */
+	unsigned int free_clus_valid; /* is free_clusters valid? */
 	struct fat_mount_options options;
 	struct nls_table *nls_disk;  /* Codepage used on disk */
 	struct nls_table *nls_io;    /* Charset used for input and display */
diff -puN fs/fat/inode.c~fat_fix-free_clusters-check fs/fat/inode.c
--- linux-2.6/fs/fat/inode.c~fat_fix-free_clusters-check	2008-03-14 05:38:40.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/inode.c	2008-03-14 05:38:40.000000000 +0900
@@ -537,7 +537,7 @@ static int fat_statfs(struct dentry *den
 	struct msdos_sb_info *sbi = MSDOS_SB(dentry->d_sb);
 
 	/* If the count of free cluster is still unknown, counts it here. */
-	if (sbi->free_clusters == -1) {
+	if (sbi->free_clusters == -1 || !sbi->free_clus_valid) {
 		int err = fat_count_free_clusters(dentry->d_sb);
 		if (err)
 			return err;
@@ -1274,6 +1274,7 @@ int fat_fill_super(struct super_block *s
 	sbi->fat_length = le16_to_cpu(b->fat_length);
 	sbi->root_cluster = 0;
 	sbi->free_clusters = -1;	/* Don't know yet */
+	sbi->free_clus_valid = 0;
 	sbi->prev_free = FAT_START_ENT;
 
 	if (!sbi->fat_length && b->fat32_length) {
@@ -1309,8 +1310,8 @@ int fat_fill_super(struct super_block *s
 			       sbi->fsinfo_sector);
 		} else {
 			if (sbi->options.usefree)
-				sbi->free_clusters =
-					le32_to_cpu(fsinfo->free_clusters);
+				sbi->free_clus_valid = 1;
+			sbi->free_clusters = le32_to_cpu(fsinfo->free_clusters);
 			sbi->prev_free = le32_to_cpu(fsinfo->next_cluster);
 		}
 
diff -puN fs/fat/fatent.c~fat_fix-free_clusters-check fs/fat/fatent.c
--- linux-2.6/fs/fat/fatent.c~fat_fix-free_clusters-check	2008-03-14 05:38:40.000000000 +0900
+++ linux-2.6-hirofumi/fs/fat/fatent.c	2008-03-14 05:38:40.000000000 +0900
@@ -450,7 +450,8 @@ int fat_alloc_clusters(struct inode *ino
 	BUG_ON(nr_cluster > (MAX_BUF_PER_PAGE / 2));	/* fixed limit */
 
 	lock_fat(sbi);
-	if (sbi->free_clusters != -1 && sbi->free_clusters < nr_cluster) {
+	if (sbi->free_clusters != -1 && sbi->free_clus_valid &&
+	    sbi->free_clusters < nr_cluster) {
 		unlock_fat(sbi);
 		return -ENOSPC;
 	}
@@ -504,6 +505,7 @@ int fat_alloc_clusters(struct inode *ino
 
 	/* Couldn't allocate the free entries */
 	sbi->free_clusters = 0;
+	sbi->free_clus_valid = 1;
 	sb->s_dirt = 1;
 	err = -ENOSPC;
 
@@ -615,7 +617,7 @@ int fat_count_free_clusters(struct super
 	int err = 0, free;
 
 	lock_fat(sbi);
-	if (sbi->free_clusters != -1)
+	if (sbi->free_clusters != -1 && sbi->free_clus_valid)
 		goto out;
 
 	reada_blocks = FAT_READA_SIZE >> sb->s_blocksize_bits;
@@ -643,6 +645,7 @@ int fat_count_free_clusters(struct super
 		} while (fat_ent_next(sbi, &fatent));
 	}
 	sbi->free_clusters = free;
+	sbi->free_clus_valid = 1;
 	sb->s_dirt = 1;
 	fatent_brelse(&fatent);
 out:
_
