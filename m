Return-Path: <linux-kernel-owner+w=401wt.eu-S1759749AbZFKMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749AbZFKMZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZFKMZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:25:40 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49405 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZFKMZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:25:39 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org, kay.sievers@vrfy.org
Subject: [PATCH 5/5] FAT: add 'notify' mount option
Date: Thu, 11 Jun 2009 15:24:49 +0300
Message-Id: <b2000d94220c7641d37aef27b08d0b1be69c88b1.1244729458.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <5dac59b1ab6cfd9b5f3d86dd18a3e9ab901f76f6.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
 <ab9ac124f4c0821eb0d03135252754e83410b2ba.1244729458.git.ext-denis.2.karpov@nokia.com>
 <6fadbb49517504006fae38b81346eac06d7e24c4.1244729458.git.ext-denis.2.karpov@nokia.com>
 <5dac59b1ab6cfd9b5f3d86dd18a3e9ab901f76f6.1244729458.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 11 Jun 2009 12:25:00.0647 (UTC) FILETIME=[A3D26F70:01C9EA8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement FAT fs mount option 'notify'. The effect of this option
is that user space is notified of file system's run-rime errors
with an uevent.
The uevent is associated with fs kobject's attribute value 'fs_fault'
(/sys/fs/fat/<partition>/fs_fault).

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 Documentation/filesystems/vfat.txt |    4 ++++
 fs/fat/fat.h                       |    3 ++-
 fs/fat/inode.c                     |   11 +++++++++--
 fs/fat/misc.c                      |    4 ++--
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
index 3a5ddc9..16cfcb3 100644
--- a/Documentation/filesystems/vfat.txt
+++ b/Documentation/filesystems/vfat.txt
@@ -132,6 +132,10 @@ rodir	      -- FAT has the ATTR_RO (read-only) attribute. But on Windows,
 		 If you want to use ATTR_RO as read-only flag even for
 		 the directory, set this option.
 
+notify	      -- notify userspace of filesystem faults using sysfs interface
+		 /sys/fs/fat/<partition>/fs_fault and uevent
+		 (KOBJ_CHANGE, uevent's environment variable FS_FAULT=1).
+
 <bool>: 0,1,yes,no,true,false
 
 TODO
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index ebf4c62..84030ac 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -39,7 +39,8 @@ struct fat_mount_options {
 		 nocase:1,	  /* Does this need case conversion? 0=need case conversion*/
 		 usefree:1,	  /* Use free_clusters for FAT32 */
 		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
-		 rodir:1;	  /* allow ATTR_RO for directory */
+		 rodir:1,	  /* allow ATTR_RO for directory */
+		 err_notify:1;	  /* Notify userspace on fs errors */
 };
 
 #define FAT_HASH_BITS	8
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index b1a0c8d..559ccea 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -844,6 +844,8 @@ static int fat_show_options(struct seq_file *m, struct vfsmount *mnt)
 		seq_puts(m, ",flush");
 	if (opts->tz_utc)
 		seq_puts(m, ",tz=UTC");
+	if (opts->err_notify)
+		seq_puts(m, ",notify");
 
 	return 0;
 }
@@ -856,7 +858,7 @@ enum {
 	Opt_charset, Opt_shortname_lower, Opt_shortname_win95,
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
-	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err,
+	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_notify, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -892,6 +894,7 @@ static const match_table_t fat_tokens = {
 	{Opt_obsolate, "posix"},
 	{Opt_flush, "flush"},
 	{Opt_tz_utc, "tz=UTC"},
+	{Opt_err_notify, "notify"},
 	{Opt_err, NULL},
 };
 static const match_table_t msdos_tokens = {
@@ -961,6 +964,7 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 	opts->numtail = 1;
 	opts->usefree = opts->nocase = 0;
 	opts->tz_utc = 0;
+	opts->err_notify = 0;
 	*debug = 0;
 
 	if (!options)
@@ -1053,6 +1057,9 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		case Opt_tz_utc:
 			opts->tz_utc = 1;
 			break;
+		case Opt_err_notify:
+			opts->err_notify = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
@@ -1226,7 +1233,7 @@ static struct fat_attr fat_attr_##_name = {			\
 
 #define ATTR_LIST(name) (&fat_attr_ ##name.attr)
 
-FAT_SBI_RO_ATTR(fs_fault);
+FAT_SBI_RO_ATTR_NOTIFY(fs_fault);
 
 static struct attribute *fat_attrs[] = {
 	ATTR_LIST(fs_fault),
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 8cdefd8..7a84104 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -35,7 +35,7 @@ void fat_fs_error(struct super_block *s, const char *function,
 		printk(KERN_ERR "    File system has been set read-only\n");
 	}
 
-	FAT_FS_FAULT_SET(sbi, 1, 0);
+	FAT_FS_FAULT_SET(sbi, 1, sbi->options.err_notify);
 }
 EXPORT_SYMBOL_GPL(fat_fs_error);
 
@@ -58,7 +58,7 @@ void fat_fs_warning(struct super_block *s, const char * function,
 	printk("\n");
 	va_end(args);
 
-	FAT_FS_FAULT_SET(sbi, 1, 0);
+	FAT_FS_FAULT_SET(sbi, 1, sbi->options.err_notify);
 }
 EXPORT_SYMBOL_GPL(fat_fs_warning);
 
-- 
1.6.3.1

