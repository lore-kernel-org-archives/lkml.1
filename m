Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbYFYFYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbYFYFYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 01:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYFYFYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 01:24:25 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:40212 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbYFYFYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 01:24:24 -0400
Message-ID: <4861D685.4070308@skyrush.com>
Date: Tue, 24 Jun 2008 23:24:21 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080620)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UTC timestamp option for FAT filesystems
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------010008090906060502010307"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010008090906060502010307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

(This patch is based on one submitted last year by Paul Collins, but it
is updated to work with current source, and it uses a different option
name.)

Attached is a patch to provide a new mount option ("utc") for DOS
(vfat/msdos) filesystems, allowing timestamps to be in universal
coordinated time (UTC) rather than local time in applications where
doing this is advantageous.

Since DOS filesystems do not contain time zone information, and
timestamps are typically in local time, a file written in one time
zone will be wrong when read in a different time zone.  When interacting
with filesystems written or read in Windows, using local time is
often necessary, but there are other situations in which the
problems with using local time can be avoided.

Many digital cameras and other portable devices use vfat, and when
traveling across time zones it is inconvenient and confusing to
change the clock setting, but downloading files to a computer in
a different time zone will result in erroneous timestamps.  Also,
it is often necessary to remember to manually change the clock at
daylight saving time changes.  Forgetting to do this also results
in incorrect timestamps.

Setting the clock to UTC is an obvious solution, eliminating
these issues, but Linux is currently hard-coded to always offset the
timestamps by sys_tz.tz_minuteswest in order to interpret them as
local time only.  The new mount option removed this limitation.

						-Joe

--------------010008090906060502010307
Content-Type: text/x-patch;
 name="utc-timestamp-option-for-fat-filesystems.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="utc-timestamp-option-for-fat-filesystems.patch"

New mount option ("utc") for DOS (vfat/msdos) filesystems allowing
timestamps to be in universal coordinated time (UTC) rather than
local time in applications where doing this is advantageous (like
digital cameras, etc.)

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -ur linux-2.6.26-rc7-git1.old/fs/fat/dir.c linux-2.6.26-rc7-git1/fs/fat/dir.c
--- linux-2.6.26-rc7-git1.old/fs/fat/dir.c	2008-06-24 13:46:02.000000000 -0600
+++ linux-2.6.26-rc7-git1/fs/fat/dir.c	2008-06-24 14:12:56.000000000 -0600
@@ -1082,7 +1082,7 @@
 		goto error_free;
 	}
 
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.utc);
 
 	de = (struct msdos_dir_entry *)bhs[0]->b_data;
 	/* filling the new directory slots ("." and ".." entries) */
diff -ur linux-2.6.26-rc7-git1.old/fs/fat/inode.c linux-2.6.26-rc7-git1/fs/fat/inode.c
--- linux-2.6.26-rc7-git1.old/fs/fat/inode.c	2008-06-24 13:46:02.000000000 -0600
+++ linux-2.6.26-rc7-git1/fs/fat/inode.c	2008-06-24 14:40:52.000000000 -0600
@@ -382,17 +382,20 @@
 	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
 			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
 	inode->i_mtime.tv_sec =
-		date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date));
+		date_dos2unix(le16_to_cpu(de->time), le16_to_cpu(de->date),
+			      sbi->options.utc);
 	inode->i_mtime.tv_nsec = 0;
 	if (sbi->options.isvfat) {
 		int secs = de->ctime_cs / 100;
 		int csecs = de->ctime_cs % 100;
 		inode->i_ctime.tv_sec  =
 			date_dos2unix(le16_to_cpu(de->ctime),
-				      le16_to_cpu(de->cdate)) + secs;
+				      le16_to_cpu(de->cdate),
+				      sbi->options.utc) + secs;
 		inode->i_ctime.tv_nsec = csecs * 10000000;
 		inode->i_atime.tv_sec =
-			date_dos2unix(0, le16_to_cpu(de->adate));
+			date_dos2unix(0, le16_to_cpu(de->adate),
+				      sbi->options.utc);
 		inode->i_atime.tv_nsec = 0;
 	} else
 		inode->i_ctime = inode->i_atime = inode->i_mtime;
@@ -592,11 +595,11 @@
 	raw_entry->attr = fat_attr(inode);
 	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
 	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
-	fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time, &raw_entry->date);
+	fat_date_unix2dos(inode->i_mtime.tv_sec, &raw_entry->time, &raw_entry->date, sbi->options.utc);
 	if (sbi->options.isvfat) {
 		__le16 atime;
-		fat_date_unix2dos(inode->i_ctime.tv_sec,&raw_entry->ctime,&raw_entry->cdate);
-		fat_date_unix2dos(inode->i_atime.tv_sec,&atime,&raw_entry->adate);
+		fat_date_unix2dos(inode->i_ctime.tv_sec,&raw_entry->ctime,&raw_entry->cdate, sbi->options.utc);
+		fat_date_unix2dos(inode->i_atime.tv_sec,&atime,&raw_entry->adate, sbi->options.utc);
 		raw_entry->ctime_cs = (inode->i_ctime.tv_sec & 1) * 100 +
 			inode->i_ctime.tv_nsec / 10000000;
 	}
@@ -848,7 +851,7 @@
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_err,
+	Opt_obsolate, Opt_flush, Opt_utc, Opt_err,
 };
 
 static match_table_t fat_tokens = {
@@ -883,6 +886,7 @@
 	{Opt_obsolate, "cvf_options=%100s"},
 	{Opt_obsolate, "posix"},
 	{Opt_flush, "flush"},
+	{Opt_utc, "utc"},
 	{Opt_err, NULL},
 };
 static match_table_t msdos_tokens = {
@@ -947,6 +951,7 @@
 	opts->utf8 = opts->unicode_xlate = 0;
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
+	opts->utc = 0;
 	*debug = 0;
 
 	if (!options)
@@ -1036,6 +1041,9 @@
 		case Opt_flush:
 			opts->flush = 1;
 			break;
+		case Opt_utc:
+			opts->utc = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
diff -ur linux-2.6.26-rc7-git1.old/fs/fat/misc.c linux-2.6.26-rc7-git1/fs/fat/misc.c
--- linux-2.6.26-rc7-git1.old/fs/fat/misc.c	2008-04-16 20:49:44.000000000 -0600
+++ linux-2.6.26-rc7-git1/fs/fat/misc.c	2008-06-24 14:44:05.000000000 -0600
@@ -142,7 +142,7 @@
 };
 
 /* Convert a MS-DOS time/date pair to a UNIX date (seconds since 1 1 70). */
-int date_dos2unix(unsigned short time, unsigned short date)
+int date_dos2unix(unsigned short time, unsigned short date, int utc)
 {
 	int month, year, secs;
 
@@ -156,16 +156,18 @@
 	    ((date & 31)-1+day_n[month]+(year/4)+year*365-((year & 3) == 0 &&
 	    month < 2 ? 1 : 0)+3653);
 			/* days since 1.1.70 plus 80's leap day */
-	secs += sys_tz.tz_minuteswest*60;
+	if (!utc)
+		secs += sys_tz.tz_minuteswest*60;
 	return secs;
 }
 
 /* Convert linear UNIX date to a MS-DOS time/date pair. */
-void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date)
+void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date, int utc)
 {
 	int day, year, nl_day, month;
 
-	unix_date -= sys_tz.tz_minuteswest*60;
+	if (!utc)
+		unix_date -= sys_tz.tz_minuteswest*60;
 
 	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
 	if (unix_date < 315532800)
diff -ur linux-2.6.26-rc7-git1.old/fs/msdos/namei.c linux-2.6.26-rc7-git1/fs/msdos/namei.c
--- linux-2.6.26-rc7-git1.old/fs/msdos/namei.c	2008-06-24 13:46:02.000000000 -0600
+++ linux-2.6.26-rc7-git1/fs/msdos/namei.c	2008-06-24 16:32:19.000000000 -0600
@@ -243,6 +243,7 @@
 			   int is_dir, int is_hid, int cluster,
 			   struct timespec *ts, struct fat_slot_info *sinfo)
 {
+	struct msdos_sb_info *sbi = MSDOS_SB(dir->i_sb);
 	struct msdos_dir_entry de;
 	__le16 time, date;
 	int err;
@@ -252,7 +253,7 @@
 	if (is_hid)
 		de.attr |= ATTR_HIDDEN;
 	de.lcase = 0;
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.utc);
 	de.cdate = de.adate = 0;
 	de.ctime = 0;
 	de.ctime_cs = 0;
diff -ur linux-2.6.26-rc7-git1.old/fs/vfat/namei.c linux-2.6.26-rc7-git1/fs/vfat/namei.c
--- linux-2.6.26-rc7-git1.old/fs/vfat/namei.c	2008-06-24 13:46:03.000000000 -0600
+++ linux-2.6.26-rc7-git1/fs/vfat/namei.c	2008-06-24 14:39:34.000000000 -0600
@@ -621,7 +621,7 @@
 	memcpy(de->name, msdos_name, MSDOS_NAME);
 	de->attr = is_dir ? ATTR_DIR : ATTR_ARCH;
 	de->lcase = lcase;
-	fat_date_unix2dos(ts->tv_sec, &time, &date);
+	fat_date_unix2dos(ts->tv_sec, &time, &date, sbi->options.utc);
 	de->time = de->ctime = time;
 	de->date = de->cdate = de->adate = date;
 	de->ctime_cs = 0;
diff -ur linux-2.6.26-rc7-git1.old/include/linux/msdos_fs.h linux-2.6.26-rc7-git1/include/linux/msdos_fs.h
--- linux-2.6.26-rc7-git1.old/include/linux/msdos_fs.h	2008-06-24 13:46:04.000000000 -0600
+++ linux-2.6.26-rc7-git1/include/linux/msdos_fs.h	2008-06-24 15:03:58.000000000 -0600
@@ -205,7 +205,8 @@
 		 atari:1,         /* Use Atari GEMDOS variation of MS-DOS fs */
 		 flush:1,	  /* write things quickly */
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
-		 usefree:1;	  /* Use free_clusters for FAT32 */
+		 usefree:1,	  /* Use free_clusters for FAT32 */
+		 utc:1;		  /* Filesystem timestamps are in UTC */
 };
 
 #define FAT_HASH_BITS	8
@@ -428,8 +429,8 @@
 extern void fat_fs_panic(struct super_block *s, const char *fmt, ...);
 extern void fat_clusters_flush(struct super_block *sb);
 extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
-extern int date_dos2unix(unsigned short time, unsigned short date);
-extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date);
+extern int date_dos2unix(unsigned short time, unsigned short date, int utc);
+extern void fat_date_unix2dos(int unix_date, __le16 *time, __le16 *date, int utc);
 extern int fat_sync_bhs(struct buffer_head **bhs, int nr_bhs);
 
 int fat_cache_init(void);

--------------010008090906060502010307--
