Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZGXJoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZGXJoV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 05:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbZGXJoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 05:44:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:24316 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZGXJoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 05:44:18 -0400
From: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp, Jorg Schummer <ext-jorg.2.schummer@nokia.com>
Subject: [PATCH take 2][RFC] fat: Save FAT root directory timestamps to volume label
Date: Fri, 24 Jul 2009 12:43:55 +0300
Message-Id: <1248428635-26073-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
References: <1248274841-3586-1-git-send-email-ext-jorg.2.schummer@nokia.com>
X-OriginalArrivalTime: 24 Jul 2009 09:43:59.0243 (UTC) FILETIME=[44F06DB0:01CA0C43]
X-Nokia-AV: Clean
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
                    reset to 0 (1/1/1970). This is the default.

  "rootts=load"     only tries to load the root directory's timestamps from
                    a volume label entry when mounting.

  "rootts=preserve" tries to load and save the root directory's timestamps
                    if a volume label entry exists.

  "rootts=save"     tries to load and save the root directory's timestamps.
                    If the root directory was accessed but no volume label
                    entry exists, the label "NO NAME" is created.

Signed-off-by: Jorg Schummer <ext-jorg.2.schummer@nokia.com>
---
 Documentation/filesystems/vfat.txt |   10 +++
 fs/fat/dir.c                       |   44 +++++++++++
 fs/fat/fat.h                       |   27 +++++++
 fs/fat/inode.c                     |  141 +++++++++++++++++++++++++-----------
 fs/fat/misc.c                      |   27 +++++++
 5 files changed, 207 insertions(+), 42 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index b58b84b..aa048e5 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -137,6 +137,16 @@ errors=panic|continue|remount-ro
 		 without doing anything or remount the partition in
 		 read-only mode (default behavior).
 
+rootts=ignore|load|preserve|save
+	      -- Specify whether to load/store the root dir timestamps as the
+		 timestamp of the volume label entry.
+		 ignore:   do not load or store root dir ts (default).
+		 load:     only try to load the root dir ts.
+		 preserve: load the root dir ts, store them only if a volume
+			   label already exists.
+		 save:     load and store the root dir ts, create a volume label
+			   if the ts have changed but no label is present.
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 530b4ca..1a9b1e7 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1362,3 +1362,47 @@ error_remove:
 }
 
 EXPORT_SYMBOL_GPL(fat_add_entries);
+
+int fat_get_label_entry(struct inode *root_inode, struct buffer_head **bh,
+			struct msdos_dir_entry **de)
+{
+	loff_t pos;
+
+	BUG_ON(root_inode->i_ino != MSDOS_ROOT_INO);
+
+	pos = 0;
+	*bh = NULL;
+	while (fat_get_entry(root_inode, &pos, bh, de) >= 0) {
+		/* volume label: note that it is not enough to check only
+		   whether the ATTR_VOLUME bit is set, since this would yield
+		   true on any vfat extended entry */
+		if ((*de)->attr != ATTR_EXT && ((*de)->attr & ATTR_VOLUME))
+			return 0;
+	}
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(fat_get_label_entry);
+
+int fat_create_label_entry(struct inode *root_inode,
+			   const unsigned char *name)
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
+	fat_time_inode2de(MSDOS_SB(root_inode->i_sb), root_inode, &de);
+
+	err = fat_add_entries(root_inode, &de, 1, &sinfo);
+	brelse(sinfo.bh);
+	return err;
+}
+EXPORT_SYMBOL_GPL(fat_create_label_entry);
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index adb0e72..69a91f9 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -21,6 +21,19 @@
 #define FAT_ERRORS_PANIC	2      /* panic on error */
 #define FAT_ERRORS_RO		3      /* remount r/o on error */
 
+/*
+ * fat root directory timestamp backup
+ */
+#define FAT_ROOT_TS_READ        0x01 /* read root dir ts from volume label ts */
+#define FAT_ROOT_TS_WRITE       0x02 /* write root dir ts to volume label ts */
+#define FAT_ROOT_TS_CREATE      0x04 /* create volume label if there is none */
+
+#define FAT_ROOT_TS_IGNORE      0
+#define FAT_ROOT_TS_LOAD        FAT_ROOT_TS_READ
+#define FAT_ROOT_TS_PRESERVE    (FAT_ROOT_TS_READ | FAT_ROOT_TS_WRITE)
+#define FAT_ROOT_TS_SAVE        (FAT_ROOT_TS_READ | FAT_ROOT_TS_WRITE | \
+				 FAT_ROOT_TS_CREATE)
+
 struct fat_mount_options {
 	uid_t fs_uid;
 	gid_t fs_gid;
@@ -32,6 +45,8 @@ struct fat_mount_options {
 	unsigned char name_check; /* r = relaxed, n = normal, s = strict */
 	unsigned char errors;	  /* On error: continue, panic, remount-ro */
 	unsigned short allow_utime;/* permission for setting the [am]time */
+	unsigned short root_ts;   /* root dir timestamps:
+				       ignore, load, preserve, save */
 	unsigned quiet:1,         /* set = fake successful chmods and chowns */
 		 showexec:1,      /* set = only set x bit for com/exe/bat */
 		 sys_immutable:1, /* set = system files are immutable */
@@ -50,6 +65,8 @@ struct fat_mount_options {
 #define FAT_HASH_BITS	8
 #define FAT_HASH_SIZE	(1UL << FAT_HASH_BITS)
 
+#define FAT_LABEL_NONAME "NO NAME    "
+
 /*
  * MS-DOS file system in-core superblock data
  */
@@ -247,6 +264,12 @@ extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
 			   struct fat_slot_info *sinfo);
 extern int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo);
 
+extern int fat_get_label_entry(struct inode *root_inode,
+			       struct buffer_head **bh,
+			       struct msdos_dir_entry **de);
+extern int fat_create_label_entry(struct inode *root_inode,
+				  const unsigned char *name);
+
 /* fat/fatent.c */
 struct fat_entry {
 	int entry;
@@ -329,6 +352,10 @@ extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
 			      __le16 __time, __le16 __date, u8 time_cs);
 extern void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
 			      __le16 *time, __le16 *date, u8 *time_cs);
+extern void fat_time_de2inode(struct msdos_sb_info *sbi, struct inode *inode,
+			      struct msdos_dir_entry *de);
+extern void fat_time_inode2de(struct msdos_sb_info *sbi, struct inode *inode,
+			      struct msdos_dir_entry *de);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
 
 int fat_cache_init(void);
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 8970d8c..818ba3e 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -384,13 +384,7 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 
-	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
-	if (sbi->options.isvfat) {
-		fat_time_fat2unix(sbi, &inode->i_ctime, de->ctime,
-				  de->cdate, de->ctime_cs);
-		fat_time_fat2unix(sbi, &inode->i_atime, 0, de->adate, 0);
-	} else
-		inode->i_ctime = inode->i_atime = inode->i_mtime;
+	fat_time_de2inode(sbi, inode, de);
 
 	return 0;
 }
@@ -590,45 +584,67 @@ static int fat_write_inode(struct inode *inode, int wait)
 	loff_t i_pos;
 	int err;
 
-	if (inode->i_ino == MSDOS_ROOT_INO)
-		return 0;
+	if (inode->i_ino == MSDOS_ROOT_INO) {
+		if (!(sbi->options.root_ts & FAT_ROOT_TS_WRITE))
+			return 0;
+
+		/* Write the timestamps of a FAT file system's root directory
+		 * as the timestamps of the file system's label dir entry. */
+
+		spin_lock(&sbi->inode_hash_lock);
+		err = fat_get_label_entry(inode, &bh, &raw_entry);
+		if (err) {
+			if (err == -ENOENT) {
+				if (sbi->options.root_ts & FAT_ROOT_TS_CREATE) {
+
+					printk(KERN_INFO "FAT: creating volume"
+					       " label on %s to save root dir"
+					       " timestamps\n", sb->s_id);
+					err = fat_create_label_entry(inode,
+								     NULL);
+				} else {
+					/* No label present, but CREATE flag is
+					   not set. Thus not complaining. */
+					err = 0;
+				}
+			}
+			spin_unlock(&sbi->inode_hash_lock);
+			return err;
+		}
+
+	} else { /* inodes other than root directory */
 
 retry:
-	i_pos = fat_i_pos_read(sbi, inode);
-	if (!i_pos)
-		return 0;
+		i_pos = fat_i_pos_read(sbi, inode);
+		if (!i_pos)
+			return 0;
 
-	bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
-	if (!bh) {
-		printk(KERN_ERR "FAT: unable to read inode block "
-		       "for updating (i_pos %lld)\n", i_pos);
-		return -EIO;
-	}
-	spin_lock(&sbi->inode_hash_lock);
-	if (i_pos != MSDOS_I(inode)->i_pos) {
-		spin_unlock(&sbi->inode_hash_lock);
-		brelse(bh);
-		goto retry;
-	}
+		bh = sb_bread(sb, i_pos >> sbi->dir_per_block_bits);
+		if (!bh) {
+			printk(KERN_ERR "FAT: unable to read inode block "
+			       "for updating (i_pos %lld)\n", i_pos);
+			return -EIO;
+		}
+		spin_lock(&sbi->inode_hash_lock);
+		if (i_pos != MSDOS_I(inode)->i_pos) {
+			spin_unlock(&sbi->inode_hash_lock);
+			brelse(bh);
+			goto retry;
+		}
 
-	raw_entry = &((struct msdos_dir_entry *) (bh->b_data))
-	    [i_pos & (sbi->dir_per_block - 1)];
-	if (S_ISDIR(inode->i_mode))
-		raw_entry->size = 0;
-	else
-		raw_entry->size = cpu_to_le32(inode->i_size);
-	raw_entry->attr = fat_make_attrs(inode);
-	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
-	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
-	fat_time_unix2fat(sbi, &inode->i_mtime, &raw_entry->time,
-			  &raw_entry->date, NULL);
-	if (sbi->options.isvfat) {
-		__le16 atime;
-		fat_time_unix2fat(sbi, &inode->i_ctime, &raw_entry->ctime,
-				  &raw_entry->cdate, &raw_entry->ctime_cs);
-		fat_time_unix2fat(sbi, &inode->i_atime, &atime,
-				  &raw_entry->adate, NULL);
+		raw_entry = &((struct msdos_dir_entry *) (bh->b_data))
+			[i_pos & (sbi->dir_per_block - 1)];
+		if (S_ISDIR(inode->i_mode))
+			raw_entry->size = 0;
+		else
+			raw_entry->size = cpu_to_le32(inode->i_size);
+		raw_entry->attr = fat_make_attrs(inode);
+		raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
+		raw_entry->starthi =
+			cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
 	}
+
+	fat_time_inode2de(sbi, inode, raw_entry);
 	spin_unlock(&sbi->inode_hash_lock);
 	mark_buffer_dirty(bh);
 	err = 0;
@@ -863,6 +879,17 @@ static int fat_show_options(struct seq_file *m, struct vfsmount *mnt)
 	else
 		seq_puts(m, ",errors=remount-ro");
 
+	switch (opts->root_ts) {
+	case FAT_ROOT_TS_LOAD:
+		seq_puts(m, ",rootts=load");
+		break;
+	case FAT_ROOT_TS_PRESERVE:
+		seq_puts(m, ",rootts=preserve");
+		break;
+	case FAT_ROOT_TS_SAVE:
+		seq_puts(m, ",rootts=save");
+		break;
+	}
 	return 0;
 }
 
@@ -875,7 +902,8 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_rootts_load, Opt_rootts_preserve,
+	Opt_rootts_save, Opt_rootts_ignore, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -903,6 +931,10 @@ static const match_table_t fat_tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_rootts_load, "rootts=load"},
+	{Opt_rootts_preserve, "rootts=preserve"},
+	{Opt_rootts_save, "rootts=save"},
+	{Opt_rootts_ignore, "rootts=ignore"},
 	{Opt_obsolate, "conv=binary"},
 	{Opt_obsolate, "conv=text"},
 	{Opt_obsolate, "conv=auto"},
@@ -984,6 +1016,7 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 	opts->usefree = opts->nocase = 0;
 	opts->tz_utc = 0;
 	opts->errors = FAT_ERRORS_RO;
+	opts->root_ts = FAT_ROOT_TS_IGNORE;
 	*debug = 0;
 
 	if (!options)
@@ -1085,6 +1118,18 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		case Opt_err_ro:
 			opts->errors = FAT_ERRORS_RO;
 			break;
+		case Opt_rootts_ignore:
+			opts->root_ts = FAT_ROOT_TS_IGNORE;
+			break;
+		case Opt_rootts_load:
+			opts->root_ts = FAT_ROOT_TS_LOAD;
+			break;
+		case Opt_rootts_preserve:
+			opts->root_ts = FAT_ROOT_TS_PRESERVE;
+			break;
+		case Opt_rootts_save:
+			opts->root_ts = FAT_ROOT_TS_SAVE;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1207,6 +1252,18 @@ static int fat_read_root(struct inode *inode)
 	inode->i_mtime.tv_nsec = inode->i_atime.tv_nsec = inode->i_ctime.tv_nsec = 0;
 	inode->i_nlink = fat_subdirs(inode)+2;
 
+	/* Try to restore the root dir's timestamps from the FAT volume label
+	   entry */
+	if (sbi->options.root_ts & FAT_ROOT_TS_READ) {
+		struct buffer_head *bh;
+		struct msdos_dir_entry *de;
+
+		if (!fat_get_label_entry(inode, &bh, &de)) {
+			fat_time_de2inode(sbi, inode, de);
+			brelse(bh);
+		}
+	}
+
 	return 0;
 }
 
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index a6c2047..3652096 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -268,6 +268,33 @@ void fat_time_unix2fat(struct msdos_sb_info *sbi, struct timespec *ts,
 }
 EXPORT_SYMBOL_GPL(fat_time_unix2fat);
 
+void fat_time_de2inode(struct msdos_sb_info *sbi, struct inode *inode,
+		       struct msdos_dir_entry *de)
+{
+	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
+	if (sbi->options.isvfat) {
+		fat_time_fat2unix(sbi, &inode->i_ctime, de->ctime,
+				  de->cdate, de->ctime_cs);
+		fat_time_fat2unix(sbi, &inode->i_atime, 0, de->adate, 0);
+	} else
+		inode->i_ctime = inode->i_atime = inode->i_mtime;
+}
+EXPORT_SYMBOL_GPL(fat_time_de2inode);
+
+void fat_time_inode2de(struct msdos_sb_info *sbi, struct inode *inode,
+		       struct msdos_dir_entry *de)
+{
+	fat_time_unix2fat(sbi, &inode->i_mtime, &de->time, &de->date, NULL);
+	if (sbi->options.isvfat) {
+		__le16 atime;
+		fat_time_unix2fat(sbi, &inode->i_ctime, &de->ctime,
+				  &de->cdate, &de->ctime_cs);
+		fat_time_unix2fat(sbi, &inode->i_atime, &atime,
+				  &de->adate, NULL);
+	}
+}
+EXPORT_SYMBOL_GPL(fat_time_inode2de);
+
 int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs)
 {
 	int i, err = 0;
-- 
1.5.4.3

