Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYF0FMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYF0FMU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 01:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYF0FML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 01:12:11 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:34695 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYF0FMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 01:12:09 -0400
Message-ID: <486476A5.7040801@skyrush.com>
Date: Thu, 26 Jun 2008 23:12:05 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org
Subject: [PATCH] UTC timestamp option for FAT filesystems
References: <4861D685.4070308@skyrush.com> <87od5pqh4o.fsf@basil.nowhere.org>	<4862DB28.3050001@skyrush.com> <48630286.2050006@skyrush.com>	<87wskck5wi.fsf@devron.myhome.or.jp> <48639863.808@skyrush.com>	<877iccxnwi.fsf@devron.myhome.or.jp> <4863B9AF.4080105@skyrush.com> <87zlp8w4br.fsf@devron.myhome.or.jp> <4863D037.90504@skyrush.com>
In-Reply-To: <4863D037.90504@skyrush.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000304020001030806080104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000304020001030806080104
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Andrew,

Attached is a patch to provide a new mount option ("tz=UTC") for DOS
(vfat/msdos) filesystems, allowing timestamps to be in coordinated
universal time (UTC) rather than local time in applications where
doing this is advantageous.

In particular, portable devices that use fat/vfat (such as digital
cameras) can benefit from using UTC in their internal clocks, thus
avoiding daylight saving time errors and general time ambiguity issues.
 The user of the device does not have to worry about changing the time
when moving from place or when daylight saving changes.

The new mount option, when set, disables the counter-adjustment that
Linux currently makes to FAT timestamp info in anticipation of the
normal userspace time zone correction.  When used in this new mode, all
daylight saving time and time zone handling is done in userspace as is
normal for many other filesystems (like ext3).  The default mode, which
remains unchanged, is still appropriate when mounting volumes written in
Windows (because of its use of local time).

(I originally based this patch on one submitted last year by Paul
Collins, but I updated it to work with current source and changed
variable/option naming.  Ogawa Hirofumi (who maintains these
filesystems) and I discussed this patch at length on lkml, and he
suggested using the option name in the attached version of the patch.
Barry Bouwsma pointed out a good addition to the patch as well.)

						-Thanks, Joe

--------------000304020001030806080104
Content-Type: text/x-patch;
 name="utc-timestamp-option-for-fat-filesystems.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="utc-timestamp-option-for-fat-filesystems.patch"

New mount option ("tz=UTC") for FAT (vfat/msdos) filesystems allowing
timestamps to be in coordinated universal time (UTC) rather than
local time in applications where doing this is advantageous (like
digital cameras, etc.)

Signed-off-by: Joe Peterson <joe@skyrush.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

diff -puNr a/fs/fat/dir.c b/fs/fat/dir.c
--- a/fs/fat/dir.c	2008-06-25 08:53:35.676901351 -0600
+++ b/fs/fat/dir.c	2008-06-26 12:58:56.096272279 -0600
@@ -1082,7 +1082,7 @@ int fat_alloc_new_dir(struct inode *dir,
 		goto error_free;
 	}
 
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
 
 	de = (struct msdos_dir_entry *)bhs[0]->b_data;
 	/* filling the new directory slots ("." and ".." entries) */
diff -puNr a/fs/fat/inode.c b/fs/fat/inode.c
--- a/fs/fat/inode.c	2008-06-25 08:53:35.676901351 -0600
+++ b/fs/fat/inode.c	2008-06-26 14:57:07.087942764 -0600
@@ -382,17 +382,20 @@ static int fat_fill_inode(struct inode *
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 	inode->i_mtime.tv_sec =
-		date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date));
+		date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date),
+			      sbi->options.tz_utc);
 	inode->i_mtime.tv_nsec = 0;
 	if (sbi->options.isvfat) {
 		int secs = de->ctime_cs / 100;
 		int csecs = de->ctime_cs % 100;
 		inode->i_ctime.tv_sec  =
 			date_dos2unix(le16_to_cpu(de->ctime),
-				      le16_to_cpu(de->cdate)) + secs;
+				      le16_to_cpu(de->cdate),
+				      sbi->options.tz_utc) + secs;
 		inode->i_ctime.tv_nsec = csecs * 10000000;
 		inode->i_atime.tv_sec =
-			date_dos2unix(0, le16_to_cpu(de->adate));
+			date_dos2unix(0, le16_to_cpu(de->adate),
+				      sbi->options.tz_utc);
 		inode->i_atime.tv_nsec = 0;
 	} else
 		inode->i_ctime = inode->i_atime = inode->i_mtime;
@@ -592,11 +595,14 @@ retry:
 	raw_entry->attr = fat_attr(inode);
 	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
 	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
-	fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time, &raw_entry->date);
+	fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time,
+			  &raw_entry->date, sbi->options.tz_utc);
 	if (sbi->options.isvfat) {
 		__le16 atime;
-		fat_date_unix2dos(inode->i_ctime.tv_sec,&raw_entry->ctime,&raw_entry->cdate);
-		fat_date_unix2dos(inode->i_atime.tv_sec,&atime,&raw_entry->adate);
+		fat_date_unix2dos(inode->i_ctime.tv_sec, &raw_entry->ctime,
+				  &raw_entry->cdate, sbi->options.tz_utc);
+		fat_date_unix2dos(inode->i_atime.tv_sec, &atime,
+				  &raw_entry->adate, sbi->options.tz_utc);
 		raw_entry->ctime_cs = (inode->i_ctime.tv_sec & 1) * 100 +
 			inode->i_ctime.tv_nsec / 10000000;
 	}
@@ -836,6 +842,8 @@ static int fat_show_options(struct seq_f
 	}
 	if (sbi->options.flush)
 		seq_puts(m, ",flush");
+	if (opts->tz_utc)
+		seq_puts(m, ",tz=UTC");
 
 	return 0;
 }
@@ -848,7 +856,7 @@ enum {
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_err,
+	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_err,
 };
 
 static match_table_t fat_tokens = {
@@ -883,6 +891,7 @@ static match_table_t fat_tokens = {
 	{Opt_obsolate, "cvf_options=%100s"},
 	{Opt_obsolate, "posix"},
 	{Opt_flush, "flush"},
+	{Opt_tz_utc, "tz=UTC"},
 	{Opt_err, NULL},
 };
 static match_table_t msdos_tokens = {
@@ -947,6 +956,7 @@ static int parse_options(char *options, 
 	opts->utf8 = opts->unicode_xlate = 0;
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
+	opts->tz_utc = 0;
 	*debug = 0;
 
 	if (!options)
@@ -1036,6 +1046,9 @@ static int parse_options(char *options, 
 		case Opt_flush:
 			opts->flush = 1;
 			break;
+		case Opt_tz_utc:
+			opts->tz_utc = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
diff -puNr a/fs/fat/misc.c b/fs/fat/misc.c
--- a/fs/fat/misc.c	2008-06-25 08:53:35.676901351 -0600
+++ b/fs/fat/misc.c	2008-06-26 12:59:08.627376422 -0600
@@ -142,7 +142,7 @@ static int day_n[] = {
 };
 
 /* Convert a MS-DOS time/date pair to a UNIX date (seconds since 1 1 70). */
-int date_dos2unix(unsigned short time, unsigned short date)
+int date_dos2unix(unsigned short time, unsigned short date, int tz_utc)
 {
 	int month, year, secs;
 
@@ -156,16 +156,18 @@ int date_dos2unix(unsigned short time, u
 	    ((date & 31)-1+day_n[month]+(year/4)+year*365-((year & 3) == 0 &&
 	    month < 2 ? 1 : 0)+3653);
 			/* days since 1.1.70 plus 80's leap day */
-	secs += sys_tz.tz_minuteswest*60;
+	if (!tz_utc)
+		secs += sys_tz.tz_minuteswest*60;
 	return secs;
 }
 
 /* Convert linear UNIX date to a MS-DOS time/date pair. */
-void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date)
+void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date, int tz_utc)
 {
 	int day, year, nl_day, month;
 
-	unix_date -= sys_tz.tz_minuteswest*60;
+	if (!tz_utc)
+		unix_date -= sys_tz.tz_minuteswest*60;
 
 	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
 	if (unix_date < 315532800)
diff -puNr a/fs/msdos/namei.c b/fs/msdos/namei.c
--- a/fs/msdos/namei.c	2008-06-25 08:53:35.696902410 -0600
+++ b/fs/msdos/namei.c	2008-06-26 12:58:42.255055811 -0600
@@ -243,6 +243,7 @@ static int msdos_add_entry(struct inode 
 			   int is_dir, int is_hid, int cluster,
 			   struct timespec *ts, struct fat_slot_info *sinfo)
 {
+	struct msdos_sb_info *sbi = MSDOS_SB(dir->i_sb);
 	struct msdos_dir_entry de;
 	__le16 time, date;
 	int err;
@@ -252,7 +253,7 @@ static int msdos_add_entry(struct inode 
 	if (is_hid)
 		de.attr |= ATTR_HIDDEN;
 	de.lcase = 0;
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
 	de.cdate = de.adate = 0;
 	de.ctime = 0;
 	de.ctime_cs = 0;
diff -puNr a/fs/vfat/namei.c b/fs/vfat/namei.c
--- a/fs/vfat/namei.c	2008-06-25 08:53:35.686902663 -0600
+++ b/fs/vfat/namei.c	2008-06-26 12:58:27.073724049 -0600
@@ -621,7 +621,7 @@ shortname:
 	memcpy(de->name, msdos_name, MSDOS_NAME);
 	de->attr = is_dir ? ATTR_DIR : ATTR_ARCH;
 	de->lcase = lcase;
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.tz_utc);
 	de->time = de->ctime = time;
 	de->date = de->cdate = de->adate = date;
 	de->ctime_cs = 0;
diff -puNr a/include/linux/msdos_fs.h b/include/linux/msdos_fs.h
--- a/include/linux/msdos_fs.h	2008-06-25 08:53:17.435303045 -0600
+++ b/include/linux/msdos_fs.h	2008-06-26 14:58:40.626135522 -0600
@@ -205,7 +205,8 @@ struct fat_mount_options {
 		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
 		 flush:1,	  /* write things quickly */
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
-		 usefree:1;	  /* Use free_clusters for FAT32 */
+		 usefree:1,	  /* Use free_clusters for FAT32 */
+		 tz_utc:1;	  /* Filesystem timestamps are in UTC */
 };
 
 #define FAT_HASH_BITS	8
@@ -428,8 +429,9 @@ extern int fat_flush_inodes(struct super
 extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
-extern int date_dos2unix(unsigned short time, unsigned short date);
-extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date);
+extern int date_dos2unix(unsigned short time, unsigned short date, int tz_utc);
+extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date,
+			      int tz_utc);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
 
 int fat_cache_init(void);

--------------000304020001030806080104--
