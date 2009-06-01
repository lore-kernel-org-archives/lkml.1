Return-Path: <linux-kernel-owner+w=401wt.eu-S1757983AbZFAOha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983AbZFAOha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:37:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZFAOgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:36:38 -0400
Received: from smtp.nokia.com ([192.100.122.230]:64834 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbZFAOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:36:36 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] FAT: add 'errors' mount option
Date: Mon,  1 Jun 2009 17:34:47 +0300
Message-Id: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
References: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 01 Jun 2009 14:34:54.0675 (UTC) FILETIME=[214B3A30:01C9E2C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On severe errors FAT remounts itself in read-only mode. Allow to
specify FAT fs desired behavior through 'errors' mount option:
panic, continue or remount read-only.

`mount -t [fat|vfat] -o errors=[panic,remount-ro,continue] \
	<bdev> <mount point>`

This is analog to ext2 fs 'errors' mount option.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 Documentation/filesystems/vfat.txt |    5 +++++
 fs/fat/cache.c                     |    6 +++---
 fs/fat/dir.c                       |    2 +-
 fs/fat/fat.h                       |    9 +++++++--
 fs/fat/fatent.c                    |    4 ++--
 fs/fat/file.c                      |    2 +-
 fs/fat/inode.c                     |   32 ++++++++++++++++++++++++++++++--
 fs/fat/misc.c                      |   23 +++++++++++++++--------
 fs/fat/namei_msdos.c               |    2 +-
 fs/fat/namei_vfat.c                |    2 +-
 10 files changed, 66 insertions(+), 21 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index 3a5ddc9..76d6286 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -132,6 +132,11 @@ rodir	      -- FAT has the ATTR_RO (read-only) attribute. But on Windows,
 		 If you want to use ATTR_RO as read-only flag even for
 		 the directory, set this option.
 
+errors=panic|continue|remount-ro
+	      -- specify FAT behavior on critical errors: panic, continue
+		 without doing anything or remopunt the partition in
+		 read-only mode (default behavior).
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index b426022..923990e 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -241,7 +241,7 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 	while (*fclus < cluster) {
 		/* prevent the infinite loop of cluster chain */
 		if (*fclus > limit) {
-			fat_fs_panic(sb, "%s: detected the cluster chain loop"
+			fat_fs_error(sb, "%s: detected the cluster chain loop"
 				     " (i_pos %lld)", __func__,
 				     MSDOS_I(inode)->i_pos);
 			nr = -EIO;
@@ -252,7 +252,7 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 		if (nr < 0)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
-			fat_fs_panic(sb, "%s: invalid cluster chain"
+			fat_fs_error(sb, "%s: invalid cluster chain"
 				     " (i_pos %lld)", __func__,
 				     MSDOS_I(inode)->i_pos);
 			nr = -EIO;
@@ -285,7 +285,7 @@ static int fat_bmap_cluster(struct inode *inode, int cluster)
 	if (ret < 0)
 		return ret;
 	else if (ret == FAT_ENT_EOF) {
-		fat_fs_panic(sb, "%s: request beyond EOF (i_pos %lld)",
+		fat_fs_error(sb, "%s: request beyond EOF (i_pos %lld)",
 			     __func__, MSDOS_I(inode)->i_pos);
 		return -EIO;
 	}
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 3a7f603..7e7924c 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1334,7 +1334,7 @@ found:
 			goto error_remove;
 		}
 		if (dir->i_size & (sbi->cluster_size - 1)) {
-			fat_fs_panic(sb, "Odd directory size");
+			fat_fs_error(sb, "Odd directory size");
 			dir->i_size = (dir->i_size + sbi->cluster_size - 1)
 				& ~((loff_t)sbi->cluster_size - 1);
 		}
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index ea440d6..80d83c1 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -17,6 +17,10 @@
 #define VFAT_SFN_CREATE_WIN95	0x0100 /* emulate win95 rule for create */
 #define VFAT_SFN_CREATE_WINNT	0x0200 /* emulate winnt rule for create */
 
+#define FAT_ERRORS_CONT		0x1
+#define FAT_ERRORS_PANIC	0x2
+#define FAT_ERRORS_RO		0x4
+
 struct fat_mount_options {
 	uid_t fs_uid;
 	gid_t fs_gid;
@@ -39,7 +43,8 @@ struct fat_mount_options {
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1,	  /* Use free_clusters for FAT32 */
 		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
-		 rodir:1;	  /* allow ATTR_RO for directory */
+		 rodir:1,	  /* allow ATTR_RO for directory */
+		 errors:3;	  /* On error: continue, panic, go ro */
 };
 
 #define FAT_HASH_BITS	8
@@ -310,7 +315,7 @@ extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 /* fat/misc.c */
-extern void fat_fs_panic(struct super_block *s, const char *fmt, ...)
+extern void fat_fs_error(struct super_block *s, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3))) __cold;
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index da6eea4..60c31f7 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -345,7 +345,7 @@ int fat_ent_read(struct inode *inode, struct fat_entry *fatent, int entry)
 
 	if (entry < FAT_START_ENT || sbi->max_cluster <= entry) {
 		fatent_brelse(fatent);
-		fat_fs_panic(sb, "invalid access to FAT (entry 0x%08x)", entry);
+		fat_fs_error(sb, "invalid access to FAT (entry 0x%08x)", entry);
 		return -EIO;
 	}
 
@@ -557,7 +557,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 			err = cluster;
 			goto error;
 		} else if (cluster == FAT_ENT_FREE) {
-			fat_fs_panic(sb, "%s: deleting FAT entry beyond EOF",
+			fat_fs_error(sb, "%s: deleting FAT entry beyond EOF",
 				     __func__);
 			err = -EIO;
 			goto error;
diff --git a/fs/fat/file.c b/fs/fat/file.c
index 0a7f4a9..6214287 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -213,7 +213,7 @@ static int fat_free(struct inode *inode, int skip)
 			fatent_brelse(&fatent);
 			return 0;
 		} else if (ret == FAT_ENT_FREE) {
-			fat_fs_panic(sb,
+			fat_fs_error(sb,
 				     "%s: invalid cluster chain (i_pos %lld)",
 				     __func__, MSDOS_I(inode)->i_pos);
 			ret = -EIO;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 296785a..56340b3 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -76,7 +76,7 @@ static inline int __fat_get_block(struct inode *inode, sector_t iblock,
 		return 0;
 
 	if (iblock != MSDOS_I(inode)->mmu_private >> sb->s_blocksize_bits) {
-		fat_fs_panic(sb, "corrupted file size (i_pos %lld, %lld)",
+		fat_fs_error(sb, "corrupted file size (i_pos %lld, %lld)",
 			MSDOS_I(inode)->i_pos, MSDOS_I(inode)->mmu_private);
 		return -EIO;
 	}
@@ -834,6 +834,12 @@ static int fat_show_options(struct seq_file *m, struct vfsmount *mnt)
 		seq_puts(m, ",flush");
 	if (opts->tz_utc)
 		seq_puts(m, ",tz=UTC");
+	if (opts->errors & FAT_ERRORS_CONT)
+		seq_puts(m, ",errors=continue");
+	if (opts->errors & FAT_ERRORS_PANIC)
+		seq_puts(m, ",errors=panic");
+	if (opts->errors & FAT_ERRORS_RO)
+		seq_puts(m, ",errors=ro");
 
 	return 0;
 }
@@ -846,7 +852,8 @@ enum {
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err,
+	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
+	Opt_err_panic, Opt_err_ro, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -882,6 +889,9 @@ static const match_table_t fat_tokens = {
 	{Opt_obsolate, "posix"},
 	{Opt_flush, "flush"},
 	{Opt_tz_utc, "tz=UTC"},
+	{Opt_err_cont, "errors=continue"},
+	{Opt_err_panic, "errors=panic"},
+	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_err, NULL},
 };
 static const match_table_t msdos_tokens = {
@@ -889,6 +899,9 @@ static const match_table_t msdos_tokens = {
 	{Opt_nodots, "dotsOK=no"},
 	{Opt_dots, "dots"},
 	{Opt_dots, "dotsOK=yes"},
+	{Opt_err_cont, "errors=continue"},
+	{Opt_err_panic, "errors=panic"},
+	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_err, NULL}
 };
 static const match_table_t vfat_tokens = {
@@ -919,6 +932,9 @@ static const match_table_t vfat_tokens = {
 	{Opt_nonumtail_yes, "nonumtail=true"},
 	{Opt_nonumtail_yes, "nonumtail"},
 	{Opt_rodir, "rodir"},
+	{Opt_err_cont, "errors=continue"},
+	{Opt_err_panic, "errors=panic"},
+	{Opt_err_ro, "errors=remount-ro"},
 	{Opt_err, NULL}
 };
 
@@ -1043,6 +1059,15 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		case Opt_tz_utc:
 			opts->tz_utc = 1;
 			break;
+		case Opt_err_cont:
+			opts->errors = FAT_ERRORS_CONT;
+			break;
+		case Opt_err_panic:
+			opts->errors = FAT_ERRORS_PANIC;
+			break;
+		case Opt_err_ro:
+			opts->errors = FAT_ERRORS_RO;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1128,6 +1153,9 @@ out:
 		opts->allow_utime = ~opts->fs_dmask & (S_IWGRP | S_IWOTH);
 	if (opts->unicode_xlate)
 		opts->utf8 = 0;
+	/* Default behavior on fs errors - go r/o */
+	if (!opts->errors)
+		opts->errors = FAT_ERRORS_RO;
 
 	return 0;
 }
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index ac39ebc..7e78618 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -12,14 +12,19 @@
 #include "fat.h"
 
 /*
- * fat_fs_panic reports a severe file system problem and sets the file system
- * read-only. The file system can be made writable again by remounting it.
+ * fat_fs_error reports a file system problem that might indicate fa data
+ * corruption/inconsistency. Depending on 'errors' mount option the
+ * panic() is called, or error message is printed FAT and nothing is done,
+ * or filesystem is remounted read-only (default behavior).
+ * In case the file system is remounted read-only, it can be made writable
+ * again by remounting it.
  */
-void fat_fs_panic(struct super_block *s, const char *fmt, ...)
+void fat_fs_error(struct super_block *s, const char *fmt, ...)
 {
 	va_list args;
+	struct msdos_sb_info *sbi = MSDOS_SB(s);
 
-	printk(KERN_ERR "FAT: Filesystem panic (dev %s)\n", s->s_id);
+	printk(KERN_ERR "FAT: Filesystem error (dev %s)\n", s->s_id);
 
 	printk(KERN_ERR "    ");
 	va_start(args, fmt);
@@ -27,13 +32,15 @@ void fat_fs_panic(struct super_block *s, const char *fmt, ...)
 	va_end(args);
 	printk("\n");
 
-	if (!(s->s_flags & MS_RDONLY)) {
+	if (sbi->options.errors & FAT_ERRORS_PANIC)
+		panic("    FAT fs panic from previous error\n");
+	if ((sbi->options.errors & FAT_ERRORS_RO) &&
+				!(s->s_flags & MS_RDONLY)) {
 		s->s_flags |= MS_RDONLY;
 		printk(KERN_ERR "    File system has been set read-only\n");
 	}
 }
-
-EXPORT_SYMBOL_GPL(fat_fs_panic);
+EXPORT_SYMBOL_GPL(fat_fs_error);
 
 /* Flushes the number of free clusters on FAT32 */
 /* XXX: Need to write one per FSINFO block.  Currently only writes 1 */
@@ -124,7 +131,7 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 			mark_inode_dirty(inode);
 	}
 	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
-		fat_fs_panic(sb, "clusters badly computed (%d != %llu)",
+		fat_fs_error(sb, "clusters badly computed (%d != %llu)",
 			     new_fclus,
 			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
 		fat_cache_inval_inode(inode);
diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
index da3f361..72f5c64 100644
--- a/fs/fat/namei_msdos.c
+++ b/fs/fat/namei_msdos.c
@@ -608,7 +608,7 @@ error_inode:
 		sinfo.bh = NULL;
 	}
 	if (corrupt < 0) {
-		fat_fs_panic(new_dir->i_sb,
+		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
 			     __func__, sinfo.i_pos);
 	}
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index a0e00e3..cb6ddb8 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -1030,7 +1030,7 @@ error_inode:
 		sinfo.bh = NULL;
 	}
 	if (corrupt < 0) {
-		fat_fs_panic(new_dir->i_sb,
+		fat_fs_error(new_dir->i_sb,
 			     "%s: Filesystem corrupted (i_pos %lld)",
 			     __func__, sinfo.i_pos);
 	}
-- 
1.6.0.4

