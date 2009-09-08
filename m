Return-Path: <linux-kernel-owner+w=401wt.eu-S1751043AbZIHOeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043AbZIHOeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZIHOeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:34:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:53328 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZIHOeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:34:20 -0400
From: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       ext-jorg.2.schummer@nokia.com
Subject: [PATCH take 3][RFC] fat: Save FAT root directory timestamps to volume label
Date: Tue,  8 Sep 2009 17:34:08 +0300
Message-Id: <1252420448-7282-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1252420131.5782.2.camel@jorg-desktop>
References: <1252420131.5782.2.camel@jorg-desktop>
X-OriginalArrivalTime: 08 Sep 2009 14:34:13.0112 (UTC) FILETIME=[6F6A7780:01CA3091]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standard FAT implementations cannot store any of the FAT root directory's
timestamps. This commit adds the mount option 'rootts', which allows saving
the FAT root directory timestamps as the timestamps of the FAT volume label
directory entry. At least Mac OS X is known to support the same mechanism
and interoperate with this commit.

When mounting, the following values can be specified for the 'rootts' mount
option:

  "rootts=ignore"   ignores root directory timestamps. All timestamps are
                    reset to 0 (1/1/1970). This has been the FAT behaviour
                    prior to this patch.

  "rootts=preserve" tries to load and save the root directory's timestamps
                    if a volume label entry exists. The mtime and atime are
                    corrected based on root directory entries' ctime. This
                    is the default.

  "rootts=save"     tries to load and save the root directory's timestamps.
                    The mtime and atime are corrected based on root
                    directory entries' ctime. If the root directory was
                    accessed but no volume label entry exists, the label
                    "NO NAME" is created.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
---
 Documentation/filesystems/vfat.txt |    9 ++
 fs/fat/dir.c                       |   75 ++++++++++++++
 fs/fat/fat.h                       |   19 ++++
 fs/fat/inode.c                     |  192 +++++++++++++++++++++++++-----------
 4 files changed, 239 insertions(+), 56 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index b58b84b..64f6509 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -137,6 +137,15 @@ errors=panic|continue|remount-ro
 		 without doing anything or remount the partition in
 		 read-only mode (default behavior).
 
+rootts=ignore|preserve|save
+	      -- Specify whether to load/store the root dir timestamps as the
+		 timestamp of the volume label entry.
+		 ignore:   do not load or store root dir ts.
+		 preserve: load the root dir ts, store them only if a volume
+			   label already exists. This is the default.
+		 save:     load and store the root dir ts, create a volume label
+			   if the ts have changed but no label is present.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 530b4ca..114e748 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1362,3 +1362,78 @@ error_remove:
 }
 
 EXPORT_SYMBOL_GPL(fat_add_entries);
+
+int fat_get_label_entry(struct inode *root_inode, struct buffer_head **bh,
+			struct msdos_dir_entry **de, loff_t *i_pos)
+{
+	loff_t offset;
+
+	BUG_ON(root_inode->i_ino != MSDOS_ROOT_INO);
+
+	offset = 0;
+	*bh = NULL;
+	while (fat_get_entry(root_inode, &offset, bh, de) >= 0) {
+		/* not free and volume label */
+		if (!IS_FREE((*de)->name) && (*de)->attr != ATTR_EXT &&
+		    ((*de)->attr & ATTR_VOLUME)) {
+			*i_pos = fat_make_i_pos(root_inode->i_sb, *bh, *de);
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(fat_get_label_entry);
+
+int fat_add_label_entry(struct inode *root_inode, const unsigned char *name)
+{
+	struct msdos_dir_entry de;
+	struct fat_slot_info sinfo;
+	int err;
+
+	BUG_ON(root_inode->i_ino != MSDOS_ROOT_INO);
+
+	memcpy(de.name,
+	       (name) ? name : (const unsigned char *) FAT_LABEL_NONAME,
+	       MSDOS_NAME);
+	de.attr = ATTR_VOLUME;
+	de.lcase = 0;
+	de.start = de.starthi = 0;
+	de.size = 0;
+	de.time = de.ctime = 0;
+	de.ctime_cs = 0;
+	de.date = de.adate = de.cdate = 0;
+
+	err = fat_add_entries(root_inode, &de, 1, &sinfo);
+	brelse(sinfo.bh);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(fat_add_label_entry);
+
+void fat_correct_root_ts(struct inode *root_inode)
+{
+	struct msdos_sb_info *sbi = MSDOS_SB(root_inode->i_sb);
+	struct buffer_head *bh;
+	struct msdos_dir_entry *de;
+	struct timespec ts;
+	loff_t offset;
+
+	BUG_ON(root_inode->i_ino != MSDOS_ROOT_INO);
+
+	offset = 0;
+	bh = NULL;
+	while (fat_get_entry(root_inode, &offset, &bh, &de) >= 0) {
+		/* not free and short entry, not a volume label */
+		if (!IS_FREE(de->name) &&
+		    de->attr != ATTR_EXT && !(de->attr & ATTR_VOLUME)) {
+			fat_time_fat2unix(sbi, &ts, de->ctime,
+					  de->cdate, de->ctime_cs);
+			if (timespec_compare(&root_inode->i_mtime, &ts) < 0)
+				root_inode->i_mtime = ts;
+		}
+	}
+
+	if (timespec_compare(&root_inode->i_mtime, &root_inode->i_atime) > 0)
+		root_inode->i_atime = root_inode->i_mtime;
+}
+EXPORT_SYMBOL_GPL(fat_correct_root_ts);
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index adb0e72..27bc46d 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -21,6 +21,14 @@
 #define FAT_ERRORS_PANIC	2      /* panic on error */
 #define FAT_ERRORS_RO		3      /* remount r/o on error */
 
+/*
+ * fat root directory timestamp backup
+ */
+#define FAT_ROOT_TS_IGNORE      1 /* do not read or write root dir ts */
+#define FAT_ROOT_TS_PRESERVE    2 /* read and write root dir ts as volume label
+				     timestamp */
+#define FAT_ROOT_TS_SAVE        3 /* create volume label if there is none */
+
 struct fat_mount_options {
 	uid_t fs_uid;
 	gid_t fs_gid;
@@ -32,6 +40,8 @@ struct fat_mount_options {
 	unsigned char name_check; /* r = relaxed, n = normal, s = strict */
 	unsigned char errors;	  /* On error: continue, panic, remount-ro */
 	unsigned short allow_utime;/* permission for setting the [am]time */
+	unsigned short root_ts;   /* root dir timestamps:
+				       ignore, preserve, save */
 	unsigned quiet:1,         /* set = fake successful chmods and chowns */
 		 showexec:1,      /* set = only set x bit for com/exe/bat */
 		 sys_immutable:1, /* set = system files are immutable */
@@ -50,6 +60,8 @@ struct fat_mount_options {
 #define FAT_HASH_BITS	8
 #define FAT_HASH_SIZE	(1UL << FAT_HASH_BITS)
 
+#define FAT_LABEL_NONAME "NO NAME    "
+
 /*
  * MS-DOS file system in-core superblock data
  */
@@ -247,6 +259,13 @@ extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
 extern int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo);
 
+extern int fat_get_label_entry(struct inode *root_inode,
+			       struct buffer_head **bh,
+			       struct msdos_dir_entry **de, loff_t *i_pos);
+extern int fat_add_label_entry(struct inode *root_inode,
+			       const unsigned char *name);
+extern void fat_correct_root_ts(struct inode *root_inode);
+
 /* fat/fatent.c */
 struct fat_entry {
 	int entry;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8970d8c..0ba0e0c 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -330,35 +330,62 @@ static int fat_calc_dir_size(struct inode *inode)
 	return 0;
 }
 
-/* doesn't deal with root inode */
+/* nowadays, this deals also with the root inode */
 static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int error;
+	__u8 attr;
+	int is_root = (inode->i_ino == MSDOS_ROOT_INO);
+
+	if (is_root)
+		attr = ATTR_DIR;
+	else
+		attr = de->attr;
 
 	MSDOS_I(inode)->i_pos = 0;
 	inode->i_uid = sbi->options.fs_uid;
 	inode->i_gid = sbi->options.fs_gid;
 	inode->i_version++;
-	inode->i_generation = get_seconds();
+	if (is_root)
+		inode->i_generation = 0;
+	else
+		inode->i_generation = get_seconds();
 
-	if ((de->attr & ATTR_DIR) && !IS_FREE(de->name)) {
-		inode->i_generation &= ~1;
-		inode->i_mode = fat_make_mode(sbi, de->attr, S_IRWXUGO);
+	if ((attr & ATTR_DIR) && (is_root || !IS_FREE(de->name))) {
+		if (!is_root)
+			inode->i_generation &= ~1;
+		inode->i_mode = fat_make_mode(sbi, attr, S_IRWXUGO);
 		inode->i_op = sbi->dir_ops;
 		inode->i_fop = &fat_dir_operations;
 
-		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
-		if (sbi->fat_bits == 32)
-			MSDOS_I(inode)->i_start |= (le16_to_cpu(de->starthi) << 16);
-
-		MSDOS_I(inode)->i_logstart = MSDOS_I(inode)->i_start;
-		error = fat_calc_dir_size(inode);
+		if (is_root) {
+			if (sbi->fat_bits == 32) {
+				MSDOS_I(inode)->i_start = sbi->root_cluster;
+				error = fat_calc_dir_size(inode);
+			} else {
+				MSDOS_I(inode)->i_start = 0;
+				inode->i_size = sbi->dir_entries *
+					sizeof(struct msdos_dir_entry);
+				error = 0;
+			}
+			MSDOS_I(inode)->i_logstart = 0;
+		} else {
+			MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
+			if (sbi->fat_bits == 32)
+				MSDOS_I(inode)->i_start |=
+					(le16_to_cpu(de->starthi) << 16);
+			MSDOS_I(inode)->i_logstart = MSDOS_I(inode)->i_start;
+			error = fat_calc_dir_size(inode);
+		}
 		if (error < 0)
 			return error;
 		MSDOS_I(inode)->mmu_private = inode->i_size;
 
 		inode->i_nlink = fat_subdirs(inode);
+		if (is_root)
+			inode->i_nlink += 2;
+
 	} else { /* not a directory */
 		inode->i_generation |= 1;
 		inode->i_mode = fat_make_mode(sbi, de->attr,
@@ -375,22 +402,30 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 		inode->i_mapping->a_ops = &fat_aops;
 		MSDOS_I(inode)->mmu_private = inode->i_size;
 	}
-	if (de->attr & ATTR_SYS) {
+	if (attr & ATTR_SYS) {
 		if (sbi->options.sys_immutable)
 			inode->i_flags |= S_IMMUTABLE;
 	}
-	fat_save_attrs(inode, de->attr);
+	fat_save_attrs(inode, attr);
 
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 
-	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
-	if (sbi->options.isvfat) {
-		fat_time_fat2unix(sbi, &inode->i_ctime, de->ctime,
-				  de->cdate, de->ctime_cs);
-		fat_time_fat2unix(sbi, &inode->i_atime, 0, de->adate, 0);
-	} else
-		inode->i_ctime = inode->i_atime = inode->i_mtime;
+	if (!de) {
+		inode->i_mtime.tv_sec = inode->i_atime.tv_sec =
+			inode->i_ctime.tv_sec = 0;
+		inode->i_mtime.tv_nsec = inode->i_atime.tv_nsec =
+			inode->i_ctime.tv_nsec = 0;
+	} else {
+		fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
+		if (sbi->options.isvfat) {
+			fat_time_fat2unix(sbi, &inode->i_ctime, de->ctime,
+					  de->cdate, de->ctime_cs);
+			fat_time_fat2unix(sbi, &inode->i_atime, 0,
+					  de->adate, 0);
+		} else
+			inode->i_ctime = inode->i_atime = inode->i_mtime;
+	}
 
 	return 0;
 }
@@ -590,8 +625,41 @@ static int fat_write_inode(struct inode *inode, int wait)
 	loff_t i_pos;
 	int err;
 
-	if (inode->i_ino == MSDOS_ROOT_INO)
-		return 0;
+	if (inode->i_ino == MSDOS_ROOT_INO) {
+		if (sbi->options.root_ts == FAT_ROOT_TS_IGNORE)
+			return 0;
+
+		/* Write the timestamps of a FAT file system's root directory
+		 * as the timestamps of the file system's label dir entry. */
+
+		if (!MSDOS_I(inode)->i_pos) {
+			struct buffer_head *bh;
+			struct msdos_dir_entry *de;
+			loff_t i_pos;
+
+			if (sbi->options.root_ts != FAT_ROOT_TS_SAVE)
+				/* No label present, but we should not
+				   create one. Thus not complaining. */
+				return 0;
+
+			printk(KERN_INFO "FAT: creating volume label "
+			       "on %s to save root dir timestamps\n",
+			       sb->s_id);
+
+			err = fat_add_label_entry(inode, NULL);
+			if (err)
+				return err;
+
+			err = fat_get_label_entry(inode, &bh, &de, &i_pos);
+			if (err)
+				return err;
+
+			remove_inode_hash(inode);
+			fat_attach(inode, i_pos);
+			insert_inode_hash(inode);
+			brelse(bh);
+		}
+	}
 
 retry:
 	i_pos = fat_i_pos_read(sbi, inode);
@@ -613,13 +681,17 @@ retry:
 
 	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))
 	    [i_pos & (sbi->dir_per_block - 1)];
-	if (S_ISDIR(inode->i_mode))
-		raw_entry->size = 0;
-	else
-		raw_entry->size = cpu_to_le32(inode->i_size);
-	raw_entry->attr = fat_make_attrs(inode);
-	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
-	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
+
+	if (inode->i_ino != MSDOS_ROOT_INO) {
+		if (S_ISDIR(inode->i_mode))
+			raw_entry->size = 0;
+		else
+			raw_entry->size = cpu_to_le32(inode->i_size);
+		raw_entry->attr = fat_make_attrs(inode);
+		raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
+		raw_entry->starthi =
+			cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
+	}
 	fat_time_unix2fat(sbi, &inode->i_mtime, &raw_entry->time,
 			  &raw_entry->date, NULL);
 	if (sbi->options.isvfat) {
@@ -875,7 +947,8 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_rootts_ignore, Opt_rootts_preserve,
+	Opt_rootts_save, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -903,6 +976,9 @@ static const match_table_t fat_tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_rootts_ignore, "rootts=ignore"},
+	{Opt_rootts_preserve, "rootts=preserve"},
+	{Opt_rootts_save, "rootts=save"},
 	{Opt_obsolate, "conv=binary"},
 	{Opt_obsolate, "conv=text"},
 	{Opt_obsolate, "conv=auto"},
@@ -984,6 +1060,7 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 	opts->usefree = opts->nocase = 0;
 	opts->tz_utc = 0;
 	opts->errors = FAT_ERRORS_RO;
+	opts->root_ts = FAT_ROOT_TS_PRESERVE;
 	*debug = 0;
 
 	if (!options)
@@ -1085,6 +1162,15 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		case Opt_err_ro:
 			opts->errors = FAT_ERRORS_RO;
 			break;
+		case Opt_rootts_ignore:
+			opts->root_ts = FAT_ROOT_TS_IGNORE;
+			break;
+		case Opt_rootts_preserve:
+			opts->root_ts = FAT_ROOT_TS_PRESERVE;
+			break;
+		case Opt_rootts_save:
+			opts->root_ts = FAT_ROOT_TS_SAVE;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1180,34 +1266,28 @@ static int fat_read_root(struct inode *inode)
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	int error;
 
-	MSDOS_I(inode)->i_pos = 0;
-	inode->i_uid = sbi->options.fs_uid;
-	inode->i_gid = sbi->options.fs_gid;
-	inode->i_version++;
-	inode->i_generation = 0;
-	inode->i_mode = fat_make_mode(sbi, ATTR_DIR, S_IRWXUGO);
-	inode->i_op = sbi->dir_ops;
-	inode->i_fop = &fat_dir_operations;
-	if (sbi->fat_bits == 32) {
-		MSDOS_I(inode)->i_start = sbi->root_cluster;
-		error = fat_calc_dir_size(inode);
-		if (error < 0)
-			return error;
-	} else {
-		MSDOS_I(inode)->i_start = 0;
-		inode->i_size = sbi->dir_entries * sizeof(struct msdos_dir_entry);
-	}
-	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
-			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
-	MSDOS_I(inode)->i_logstart = 0;
-	MSDOS_I(inode)->mmu_private = inode->i_size;
+	error = fat_fill_inode(inode, NULL);
+
+	/* Try to restore the root dir's timestamps from the FAT volume label
+	   entry */
+	if (!error && sbi->options.root_ts != FAT_ROOT_TS_IGNORE) {
+		struct buffer_head *bh;
+		struct msdos_dir_entry *de;
+		loff_t i_pos;
 
-	fat_save_attrs(inode, ATTR_DIR);
-	inode->i_mtime.tv_sec = inode->i_atime.tv_sec = inode->i_ctime.tv_sec = 0;
-	inode->i_mtime.tv_nsec = inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = 0;
-	inode->i_nlink = fat_subdirs(inode)+2;
+		error = fat_get_label_entry(inode, &bh, &de, &i_pos);
+		if (!error) {
+			error = fat_fill_inode(inode, de);
+			if (!error)
+				fat_attach(inode, i_pos);
+			brelse(bh);
+		} else if (error == -ENOENT)
+			error = 0;
 
-	return 0;
+		fat_correct_root_ts(inode);
+	}
+
+	return error;
 }
 
 /*
-- 
1.5.4.3

