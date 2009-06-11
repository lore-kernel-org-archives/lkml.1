Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbZFKM0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbZFKM0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbZFKMZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:25:47 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49411 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbZFKMZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:25:41 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org, kay.sievers@vrfy.org
Subject: [PATCH 2/5] FAT: generalize errors and warning printing
Date: Thu, 11 Jun 2009 15:24:46 +0300
Message-Id: <ab9ac124f4c0821eb0d03135252754e83410b2ba.1244729458.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 11 Jun 2009 12:24:55.0960 (UTC) FILETIME=[A1074180:01C9EA8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generalize FAT errors and warnings reporting through
fat_fs_error() and fat_fs_warning().

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/fat/cache.c       |   14 ++++++------
 fs/fat/dir.c         |   11 +++++----
 fs/fat/fat.h         |    8 +++++-
 fs/fat/fatent.c      |   15 ++++++++-----
 fs/fat/file.c        |    6 ++--
 fs/fat/inode.c       |   51 ++++++++++++++++++++++++++-----------------------
 fs/fat/misc.c        |   42 +++++++++++++++++++++++++++++++---------
 fs/fat/namei_msdos.c |    6 ++--
 fs/fat/namei_vfat.c  |    6 ++--
 9 files changed, 96 insertions(+), 63 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index b426022..b1cf11d 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -241,9 +241,9 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 	while (*fclus < cluster) {
 		/* prevent the infinite loop of cluster chain */
 		if (*fclus > limit) {
-			fat_fs_panic(sb, "%s: detected the cluster chain loop"
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
-			fat_fs_panic(sb, "%s: invalid cluster chain"
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
-		fat_fs_panic(sb, "%s: request beyond EOF (i_pos %lld)",
-			     __func__, MSDOS_I(inode)->i_pos);
+		fat_fs_error(sb, __func__, "request beyond EOF (i_pos %lld)",
+			MSDOS_I(inode)->i_pos);
 		return -EIO;
 	}
 	return dclus;
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 3a7f603..390a984 100644
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
-			fat_fs_panic(sb, "Odd directory size");
+			fat_fs_error(sb, __func__, "Odd directory size");
 			dir->i_size = (dir->i_size + sbi->cluster_size - 1)
 				& ~((loff_t)sbi->cluster_size - 1);
 		}
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index d1cec33..1b64bae 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -316,8 +316,12 @@ extern int fat_sbi_attr_set_notify(struct msdos_sb_info *sbi,
 			unsigned long offset, unsigned long val);
 
 /* fat/misc.c */
-extern void fat_fs_panic(struct super_block *s, const char *fmt, ...)
-	__attribute__ ((format (printf, 2, 3))) __cold;
+extern void fat_fs_error(struct super_block *s, const char *function,
+		const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4))) __cold;
+extern void fat_fs_warning(struct super_block *s, const char *function,
+		const char *fmt, ...)
+	__attribute__ ((format (printf, 3, 4))) __cold;
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
 extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index da6eea4..13f2de9 100644
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
-		fat_fs_panic(sb, "invalid access to FAT (entry 0x%08x)", entry);
+		fat_fs_error(sb, __func__, "invalid access to FAT "
+			"(entry 0x%08x)", entry);
 		return -EIO;
 	}
 
@@ -557,8 +560,8 @@ int fat_free_clusters(struct inode *inode, int cluster)
 			err = cluster;
 			goto error;
 		} else if (cluster == FAT_ENT_FREE) {
-			fat_fs_panic(sb, "%s: deleting FAT entry beyond EOF",
-				     __func__);
+			fat_fs_error(sb, __func__, "deleting FAT entry beyond "
+				"EOF");
 			err = -EIO;
 			goto error;
 		}
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 0a7f4a9..df65446 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -213,9 +213,9 @@ static int fat_free(struct inode *inode, int skip)
 			fatent_brelse(&fatent);
 			return 0;
 		} else if (ret == FAT_ENT_FREE) {
-			fat_fs_panic(sb,
-				     "%s: invalid cluster chain (i_pos %lld)",
-				     __func__, MSDOS_I(inode)->i_pos);
+			fat_fs_error(sb, __func__,
+				     "invalid cluster chain (i_pos %lld)",
+				     MSDOS_I(inode)->i_pos);
 			ret = -EIO;
 		} else if (ret > 0) {
 			err = fat_ent_write(inode, &fatent, FAT_ENT_EOF, wait);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 82708fc..61d52d1 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -79,7 +79,8 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 		return 0;
 
 	if (iblock != MSDOS_I(inode)->mmu_private >> sb->s_blocksize_bits) {
-		fat_fs_panic(sb, "corrupted file size (i_pos %lld, %lld)",
+		fat_fs_error(sb, __func__, "corrupted file size "
+			"(i_pos %lld, %lld)",
 			MSDOS_I(inode)->i_pos, MSDOS_I(inode)->mmu_private);
 		return -EIO;
 	}
@@ -587,8 +588,8 @@ retry:
 
 	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
 	if (!bh) {
-		printk(KERN_ERR "FAT: unable to read inode block "
-		       "for updating (i_pos %lld)\n", i_pos);
+		fat_fs_warning(sb, __func__, "unable to read inode block "
+		       "for updating (i_pos %lld)", i_pos);
 		return -EIO;
 	}
 	spin_lock(&sbi->inode_hash_lock);
@@ -1115,9 +1116,8 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
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
@@ -1126,9 +1126,9 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
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
@@ -1345,7 +1345,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	b = (struct fat_boot_sector *) bh->b_data;
 	if (!b->reserved) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus number of reserved sectors\n");
+			printk(KERN_ERR "FAT: bogus number of reserved "
+					"sectors\n");
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1365,7 +1366,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	if (!fat_valid_media(media)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: invalid media value (0x%02x)\n",
-			       media);
+					media);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1375,7 +1376,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	    || (logical_sector_size > 4096)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus logical sector size %u\n",
-			       logical_sector_size);
+					logical_sector_size);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1383,14 +1384,15 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	if (!is_power_of_2(sbi->sec_per_clus)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: bogus sectors per cluster %u\n",
-			       sbi->sec_per_clus);
+					sbi->sec_per_clus);
 		brelse(bh);
 		goto out_invalid;
 	}
 
 	if (logical_sector_size < sb->s_blocksize) {
 		printk(KERN_ERR "FAT: logical sector size too small for device"
-		       " (logical sector size = %u)\n", logical_sector_size);
+				" (logical sector size = %u)\n",
+				logical_sector_size);
 		brelse(bh);
 		goto out_fail;
 	}
@@ -1399,14 +1401,14 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 
 		if (!sb_set_blocksize(sb, logical_sector_size)) {
 			printk(KERN_ERR "FAT: unable to set blocksize %u\n",
-			       logical_sector_size);
+				logical_sector_size);
 			goto out_fail;
 		}
 		bh = sb_bread(sb, 0);
 		if (bh == NULL) {
-			printk(KERN_ERR "FAT: unable to read boot sector"
-			       " (logical sector size = %lu)\n",
-			       sb->s_blocksize);
+			printk(KERN_ERR "FAT: unable to read boot sector "
+					"(logical sector size = %lu)\n",
+					sb->s_blocksize);
 			goto out_fail;
 		}
 		b = (struct fat_boot_sector *) bh->b_data;
@@ -1441,8 +1443,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 
 		fsinfo_bh = sb_bread(sb, sbi->fsinfo_sector);
 		if (fsinfo_bh == NULL) {
-			printk(KERN_ERR "FAT: bread failed, FSINFO block"
-			       " (sector = %lu)\n", sbi->fsinfo_sector);
+			printk(KERN_ERR "FAT: bread failed, FSINFO "
+					"block (sector = %lu)\n",
+					sbi->fsinfo_sector);
 			brelse(bh);
 			goto out_fail;
 		}
@@ -1471,8 +1474,8 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	sbi->dir_entries = get_unaligned_le16(&b->dir_entries);
 	if (sbi->dir_entries & (sbi->dir_per_block - 1)) {
 		if (!silent)
-			printk(KERN_ERR "FAT: bogus directroy-entries per block"
-			       " (%u)\n", sbi->dir_entries);
+			printk(KERN_ERR "FAT: bogus directroy-entries"
+					" per block (%u)\n", sbi->dir_entries);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1495,7 +1498,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	if (total_clusters > MAX_FAT(sb)) {
 		if (!silent)
 			printk(KERN_ERR "FAT: count of clusters too big (%u)\n",
-			       total_clusters);
+					total_clusters);
 		brelse(bh);
 		goto out_invalid;
 	}
@@ -1536,7 +1539,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		sbi->nls_io = load_nls(sbi->options.iocharset);
 		if (!sbi->nls_io) {
 			printk(KERN_ERR "FAT: IO charset %s not found\n",
-			       sbi->options.iocharset);
+					sbi->options.iocharset);
 			goto out_fail;
 		}
 	}
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index ac39ebc..be9cb03 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -15,11 +15,13 @@
  * fat_fs_panic reports a severe file system problem and sets the file system
  * read-only. The file system can be made writable again by remounting it.
  */
-void fat_fs_panic(struct super_block *s, const char *fmt, ...)
+void fat_fs_error(struct super_block *s, const char *function,
+		const char *fmt, ...)
 {
 	va_list args;
 
-	printk(KERN_ERR "FAT: Filesystem panic (dev %s)\n", s->s_id);
+	printk(KERN_ERR "FAT: Filesystem error (dev %s): %s:\n", s->s_id,
+		function);
 
 	printk(KERN_ERR "    ");
 	va_start(args, fmt);
@@ -32,8 +34,27 @@ void fat_fs_panic(struct super_block *s, const char *fmt, ...)
 		printk(KERN_ERR "    File system has been set read-only\n");
 	}
 }
+EXPORT_SYMBOL_GPL(fat_fs_error);
 
-EXPORT_SYMBOL_GPL(fat_fs_panic);
+/*
+ * fat_fs_warning reports a file system non-critical problem that stil
+ * might indicate fs data corruption/inconsistency.
+ */
+void fat_fs_warning(struct super_block *s, const char * function,
+		const char *fmt, ...)
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
 
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
@@ -48,15 +69,15 @@ void fat_clusters_flush(struct super_block *sb)
 
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
@@ -124,10 +145,11 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 			mark_inode_dirty(inode);
 	}
 	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
-		fat_fs_panic(sb, "clusters badly computed (%d != %llu)",
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
index da3f361..964f378 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -608,9 +608,9 @@ error_inode:
 		sinfo.bh = NULL;
 	}
 	if (corrupt < 0) {
-		fat_fs_panic(new_dir->i_sb,
-			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+		fat_fs_error(new_dir->i_sb, __func__,
+			     "Filesystem corrupted (i_pos %lld)",
+			     sinfo.i_pos);
 	}
 	goto out;
 }
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index a0e00e3..91601d6 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1030,9 +1030,9 @@ error_inode:
 		sinfo.bh = NULL;
 	}
 	if (corrupt < 0) {
-		fat_fs_panic(new_dir->i_sb,
-			     "%s: Filesystem corrupted (i_pos %lld)",
-			     __func__, sinfo.i_pos);
+		fat_fs_error(new_dir->i_sb, __func__,
+			     "Filesystem corrupted (i_pos %lld)",
+			     sinfo.i_pos);
 	}
 	goto out;
 }
-- 
1.6.3.1

