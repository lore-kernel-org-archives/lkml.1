Return-Path: <linux-kernel-owner+w=401wt.eu-S1755684AbZFAOfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755684AbZFAOfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZFAOfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:35:34 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64705 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZFAOfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:35:33 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] FAT: generalize errors and warning printing
Date: Mon,  1 Jun 2009 17:34:49 +0300
Message-Id: <7a3581d74ad9c623891133c8f0d85765eb11417c.1243863850.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <7ed7ce4308999530ac3b69690ccd0e649970800d.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
 <7ed7ce4308999530ac3b69690ccd0e649970800d.1243863850.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 01 Jun 2009 14:34:57.0222 (UTC) FILETIME=[22CFDE60:01C9E2C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize FAT errors and warnings reporting through
fat_fs_error() and fat_fs_warning().

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/fat/cache.c       |   14 ++++----
 fs/fat/dir.c         |   11 ++++---
 fs/fat/fat.h         |    8 ++++-
 fs/fat/fatent.c      |   15 +++++----
 fs/fat/file.c        |    6 ++--
 fs/fat/inode.c       |   81 ++++++++++++++++++++++++++++---------------------
 fs/fat/misc.c        |   41 +++++++++++++++++++-----
 fs/fat/namei_msdos.c |    6 ++--
 fs/fat/namei_vfat.c  |    6 ++--
 9 files changed, 115 insertions(+), 73 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 923990e..b1cf11d 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -241,9 +241,9 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 	while (*fclus < cluster) {
 		/* prevent the infinite loop of cluster chain */
 		if (*fclus > limit) {
-			fat_fs_error(sb, "%s: detected the cluster chain loop"
-				     " (i_pos %lld)", __func__,
-				     MSDOS_I(inode)->i_pos);
+			fat_fs_error(sb, __func__, "detected the cluster "
+				"chain loop (i_pos %lld)",
+				MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
 		}
@@ -252,8 +252,8 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 		if (nr < 0)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
-			fat_fs_error(sb, "%s: invalid cluster chain"
-				     " (i_pos %lld)", __func__,
+			fat_fs_error(sb, __func__, "invalid cluster chain"
+				     " (i_pos %lld)",
 				     MSDOS_I(inode)->i_pos);
 			nr = -EIO;
 			goto out;
@@ -285,8 +285,8 @@ static int fat_bmap_cluster(struct inode *inode, int cluster)
 	if (ret < 0)
 		return ret;
 	else if (ret == FAT_ENT_EOF) {
-		fat_fs_error(sb, "%s: request beyond EOF (i_pos %lld)",
-			     __func__, MSDOS_I(inode)->i_pos);
+		fat_fs_error(sb, __func__, "request beyond EOF (i_pos %lld)",
+			MSDOS_I(inode)->i_pos);
 		return -EIO;
 	}
 	return dclus;
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 7e7924c..390a984 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -85,8 +85,9 @@ next:
 
 	*bh = sb_bread(sb, phys);
 	if (*bh == NULL) {
-		printk(KERN_ERR "FAT: Directory bread(block %llu) failed\n",
-		       (llu)phys);
+		fat_fs_warning(sb, __func__, "Directory bread(block %llu) "
+			"failed",
+			(llu)phys);
 		/* skip this block */
 		*pos = (iblock + 1) << sb->s_blocksize_bits;
 		goto next;
@@ -1269,8 +1270,8 @@ int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 		if (sbi->fat_bits != 32)
 			goto error;
 	} else if (MSDOS_I(dir)->i_start == 0) {
-		printk(KERN_ERR "FAT: Corrupted directory (i_pos %lld)\n",
-		       MSDOS_I(dir)->i_pos);
+		fat_fs_warning(sb, __func__, "Corrupted directory (i_pos %lld)",
+			MSDOS_I(dir)->i_pos);
 		err = -EIO;
 		goto error;
 	}
@@ -1334,7 +1335,7 @@ found:
 			goto error_remove;
 		}
 		if (dir->i_size & (sbi->cluster_size - 1)) {
-			fat_fs_error(sb, "Odd directory size");
+			fat_fs_error(sb, __func__, "Odd directory size");
 			dir->i_size = (dir->i_size + sbi->cluster_size - 1)
 				& ~((loff_t)sbi->cluster_size - 1);
 		}
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 80d83c1..d6fd6ab 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -315,8 +315,12 @@ extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void fat_fs_error(struct super_block *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3))) __cold;
+extern void fat_fs_error(struct super_block *s, const char *function,
+			const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4))) __cold;
+extern void fat_fs_warning(struct super_block *s, const char *function,
+			const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4))) __cold;
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 60c31f7..13f2de9 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -93,7 +93,8 @@ static int fat12_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 err_brelse:
 	brelse(bhs[0]);
 err:
-	printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n", (llu)blocknr);
+	fat_fs_warning(sb, __func__, "FAT read failed (blocknr %llu)",
+		(llu)blocknr);
 	return -EIO;
 }
 
@@ -105,8 +106,9 @@ static int fat_ent_bread(struct super_block *sb, struct fat_entry *fatent,
 	WARN_ON(blocknr < MSDOS_SB(sb)->fat_start);
 	fatent->bhs[0] = sb_bread(sb, blocknr);
 	if (!fatent->bhs[0]) {
-		printk(KERN_ERR "FAT: FAT read failed (blocknr %llu)\n",
-		       (llu)blocknr);
+		fat_fs_warning(sb, __func__, "FAT: FAT read failed "
+			"(blocknr %llu)",
+			(llu)blocknr);
 		return -EIO;
 	}
 	fatent->nr_bhs = 1;
@@ -345,7 +347,8 @@ int fat_ent_read(struct inode *inode, struct fat_entry *fatent, int entry)
 
 	if (entry < FAT_START_ENT || sbi->max_cluster <= entry) {
 		fatent_brelse(fatent);
-		fat_fs_error(sb, "invalid access to FAT (entry 0x%08x)", entry);
+		fat_fs_error(sb, __func__, "invalid access to FAT "
+			"(entry 0x%08x)", entry);
 		return -EIO;
 	}
 
@@ -557,8 +560,8 @@ int fat_free_clusters(struct inode *inode, int cluster)
 			err = cluster;
 			goto error;
 		} else if (cluster == FAT_ENT_FREE) {
-			fat_fs_error(sb, "%s: deleting FAT entry beyond EOF",
-				     __func__);
+			fat_fs_error(sb, __func__, "deleting FAT entry beyond "
+				"EOF");
 			err = -EIO;
 			goto error;
 		}
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 6214287..df65446 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -213,9 +213,9 @@ static int fat_free(struct inode *inode, int skip)
 			fatent_brelse(&fatent);
 			return 0;
 		} else if (ret == FAT_ENT_FREE) {
-			fat_fs_error(sb,
-				     "%s: invalid cluster chain (i_pos %lld)",
-				     __func__, MSDOS_I(inode)->i_pos);
+			fat_fs_error(sb, __func__,
+				     "invalid cluster chain (i_pos %lld)",
+				     MSDOS_I(inode)->i_pos);
 			ret = -EIO;
 		} else if (ret > 0) {
 			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, wait);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 56340b3..40fcf97 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -76,7 +76,8 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 		return 0;
 
 	if (iblock != MSDOS_I(inode)->mmu_private >> sb->s_blocksize_bits) {
-		fat_fs_error(sb, "corrupted file size (i_pos %lld, %lld)",
+		fat_fs_error(sb, __func__, "corrupted file size "
+			"(i_pos %lld, %lld)",
 			MSDOS_I(inode)->i_pos, MSDOS_I(inode)->mmu_private);
 		return -EIO;
 	}
@@ -579,8 +580,8 @@ retry:
 
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
 	if (!bh) {
-		printk(KERN_ERR "FAT: unable to read inode block "
-		       "for updating (i_pos %lld)\n", i_pos);
+		fat_fs_warning(sb, __func__, "unable to read inode block "
+		       "for updating (i_pos %lld)", i_pos);
 		return -EIO;
 	}
 	spin_lock(&sbi->inode_hash_lock);
@@ -1132,9 +1133,8 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		/* unknown option */
 		default:
 			if (!silent) {
-				printk(KERN_ERR
-				       "FAT: Unrecognized mount option \"%s\" "
-				       "or missing value\n", p);
+				printk(KERN_ERR "FAT: Unrecognized mount "
+					"option \"%s\" or missing value\n", p);
 			}
 			return -EINVAL;
 		}
@@ -1143,9 +1143,9 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 out:
 	/* UTF-8 doesn't provide FAT semantics */
 	if (!strcmp(opts->iocharset, "utf8")) {
-		printk(KERN_ERR "FAT: utf8 is not a recommended IO charset"
-		       " for FAT filesystems, filesystem will be "
-		       "case sensitive!\n");
+		printk(KERN_WARNING "FAT: utf8 is not a recommended IO "
+			"charset for FAT filesystems, filesystem will be "
+			"case sensitive!");
 	}
 
 	/* If user doesn't specify allow_utime, it's initialized from dmask. */
@@ -1238,20 +1238,22 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sb_min_blocksize(sb, 512);
 	bh = sb_bread(sb, 0);
 	if (bh == NULL) {
-		printk(KERN_ERR "FAT: unable to read boot sector\n");
+		fat_fs_warning(sb, __func__, "unable to read boot sector");
 		goto out_fail;
 	}
 
 	b = (struct fat_boot_sector *) bh->b_data;
 	if (!b->reserved) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus number of reserved sectors\n");
+			fat_fs_warning(sb, __func__, "bogus number of reserved "
+					"sectors");
 		brelse(bh);
 		goto out_invalid;
 	}
 	if (!b->fats) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus number of FAT structure\n");
+			fat_fs_warning(sb, __func__, "bogus number of FAT "
+					"structure");
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1264,8 +1266,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	media = b->media;
 	if (!fat_valid_media(media)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: invalid media value (0x%02x)\n",
-			       media);
+			fat_fs_warning(sb, __func__, "invalid media value "
+				"(0x%02x)",
+				media);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1274,23 +1277,26 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	    || (logical_sector_size < 512)
 	    || (logical_sector_size > 4096)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus logical sector size %u\n",
-			       logical_sector_size);
+			fat_fs_warning(sb, __func__, "bogus logical sector "
+				"size %u",
+				logical_sector_size);
 		brelse(bh);
 		goto out_invalid;
 	}
 	sbi->sec_per_clus = b->sec_per_clus;
 	if (!is_power_of_2(sbi->sec_per_clus)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus sectors per cluster %u\n",
-			       sbi->sec_per_clus);
+			fat_fs_warning(sb, __func__, "bogus sectors per "
+				"cluster %u",
+				sbi->sec_per_clus);
 		brelse(bh);
 		goto out_invalid;
 	}
 
 	if (logical_sector_size < sb->s_blocksize) {
-		printk(KERN_ERR "FAT: logical sector size too small for device"
-		       " (logical sector size = %u)\n", logical_sector_size);
+		fat_fs_warning(sb, __func__, "logical sector size too small "
+			"for device"
+		       " (logical sector size = %u)", logical_sector_size);
 		brelse(bh);
 		goto out_fail;
 	}
@@ -1298,15 +1304,16 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		brelse(bh);
 
 		if (!sb_set_blocksize(sb, logical_sector_size)) {
-			printk(KERN_ERR "FAT: unable to set blocksize %u\n",
-			       logical_sector_size);
+			fat_fs_warning(sb, __func__, "unable to set "
+				"blocksize %u",
+				logical_sector_size);
 			goto out_fail;
 		}
 		bh = sb_bread(sb, 0);
 		if (bh == NULL) {
-			printk(KERN_ERR "FAT: unable to read boot sector"
-			       " (logical sector size = %lu)\n",
-			       sb->s_blocksize);
+			fat_fs_warning(sb, __func__, "unable to read "
+				"boot sector (logical sector size = %lu)",
+				sb->s_blocksize);
 			goto out_fail;
 		}
 		b = (struct fat_boot_sector *) bh->b_data;
@@ -1341,8 +1348,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 
 		fsinfo_bh = sb_bread(sb, sbi->fsinfo_sector);
 		if (fsinfo_bh == NULL) {
-			printk(KERN_ERR "FAT: bread failed, FSINFO block"
-			       " (sector = %lu)\n", sbi->fsinfo_sector);
+			fat_fs_warning(sb, __func__, "bread failed, FSINFO "
+				"block (sector = %lu)",
+				sbi->fsinfo_sector);
 			brelse(bh);
 			goto out_fail;
 		}
@@ -1371,8 +1379,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus directroy-entries per block"
-			       " (%u)\n", sbi->dir_entries);
+			fat_fs_warning(sb, __func__, "bogus directroy-entries"
+				" per block (%u)",
+				sbi->dir_entries);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1394,8 +1403,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	total_clusters = min(total_clusters, fat_clusters - FAT_START_ENT);
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: count of clusters too big (%u)\n",
-			       total_clusters);
+			fat_fs_warning(sb, __func__, "count of clusters too "
+				"big (%u)",
+				total_clusters);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1427,7 +1437,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sprintf(buf, "cp%d", sbi->options.codepage);
 	sbi->nls_disk = load_nls(buf);
 	if (!sbi->nls_disk) {
-		printk(KERN_ERR "FAT: codepage %s not found\n", buf);
+		fat_fs_warning(sb, __func__, "codepage %s not found", buf);
 		goto out_fail;
 	}
 
@@ -1435,8 +1445,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	if (sbi->options.isvfat) {
 		sbi->nls_io = load_nls(sbi->options.iocharset);
 		if (!sbi->nls_io) {
-			printk(KERN_ERR "FAT: IO charset %s not found\n",
-			       sbi->options.iocharset);
+			fat_fs_warning(sb, __func__, "IO charset %s not "
+				"found",
+				sbi->options.iocharset);
 			goto out_fail;
 		}
 	}
@@ -1454,7 +1465,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	insert_inode_hash(root_inode);
 	sb->s_root = d_alloc_root(root_inode);
 	if (!sb->s_root) {
-		printk(KERN_ERR "FAT: get root inode failed\n");
+		fat_fs_warning(sb, __func__, "get root inode failed");
 		goto out_fail;
 	}
 
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 7e78618..1120094 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -19,12 +19,14 @@
  * In case the file system is remounted read-only, it can be made writable
  * again by remounting it.
  */
-void fat_fs_error(struct super_block *s, const char *fmt, ...)
+void fat_fs_error(struct super_block *s, const char * function,
+			const char *fmt, ...)
 {
 	va_list args;
 	struct msdos_sb_info *sbi = MSDOS_SB(s);
 
-	printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
+	printk(KERN_ERR "FAT: Filesystem error (dev %s): %s:\n", s->s_id,
+		function);
 
 	printk(KERN_ERR "    ");
 	va_start(args, fmt);
@@ -42,6 +44,26 @@ void fat_fs_error(struct super_block *s, const char *fmt, ...)
 }
 EXPORT_SYMBOL_GPL(fat_fs_error);
 
+/*
+ * fat_fs_warning reports a file system non-critical problem that still
+ * might indicate fs data corruption/inconsistency.
+ */
+void fat_fs_warning(struct super_block *s, const char * function,
+			const char *fmt, ...)
+{
+	va_list args;
+
+	printk(KERN_ERR "FAT: Filesystem warning (dev %s): %s:\n", s->s_id,
+		function);
+
+	printk(KERN_ERR "    ");
+	va_start(args, fmt);
+	vprintk(fmt, args);
+	printk("\n");
+	va_end(args);
+}
+EXPORT_SYMBOL_GPL(fat_fs_warning);
+
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
 void fat_clusters_flush(struct super_block *sb)
@@ -55,15 +77,15 @@ void fat_clusters_flush(struct super_block *sb)
 
 	bh = sb_bread(sb, sbi->fsinfo_sector);
 	if (bh == NULL) {
-		printk(KERN_ERR "FAT: bread failed in fat_clusters_flush\n");
+		fat_fs_warning(sb, __func__, "bread failed");
 		return;
 	}
 
 	fsinfo = (struct fat_boot_fsinfo *)bh->b_data;
 	/* Sanity check */
 	if (!IS_FSINFO(fsinfo)) {
-		printk(KERN_ERR "FAT: Invalid FSINFO signature: "
-		       "0x%08x, 0x%08x (sector = %lu)\n",
+		fat_fs_warning(sb, __func__, "Invalid FSINFO signature: "
+		       "0x%08x, 0x%08x (sector = %lu)",
 		       le32_to_cpu(fsinfo->signature1),
 		       le32_to_cpu(fsinfo->signature2),
 		       sbi->fsinfo_sector);
@@ -131,10 +153,11 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 			mark_inode_dirty(inode);
 	}
 	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
-		fat_fs_error(sb, "clusters badly computed (%d != %llu)",
-			     new_fclus,
-			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
-		fat_cache_inval_inode(inode);
+		fat_fs_error(sb, __func__, "clusters badly computed "
+			"(%d != %llu)",
+			new_fclus,
+			(llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
+			fat_cache_inval_inode(inode);
 	}
 	inode->i_blocks += nr_cluster << (sbi->cluster_bits - 9);
 
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index 72f5c64..964f378 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -608,9 +608,9 @@ error_inode:
 		sinfo.bh = NULL;
 	}
 	if (corrupt < 0) {
-		fat_fs_error(new_dir->i_sb,
-			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+		fat_fs_error(new_dir->i_sb, __func__,
+			     "Filesystem corrupted (i_pos %lld)",
+			     sinfo.i_pos);
 	}
 	goto out;
 }
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index cb6ddb8..91601d6 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1030,9 +1030,9 @@ error_inode:
 		sinfo.bh = NULL;
 	}
 	if (corrupt < 0) {
-		fat_fs_error(new_dir->i_sb,
-			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+		fat_fs_error(new_dir->i_sb, __func__,
+			     "Filesystem corrupted (i_pos %lld)",
+			     sinfo.i_pos);
 	}
 	goto out;
 }
-- 
1.6.0.4

