Return-Path: <linux-kernel-owner+w=401wt.eu-S1756092AbZFAOgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092AbZFAOgS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 10:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbZFAOgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 10:36:07 -0400
Received: from smtp.nokia.com ([192.100.122.233]:39141 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZFAOgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 10:36:06 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] FAT: add 'notify' mount option
Date: Mon,  1 Jun 2009 17:34:50 +0300
Message-Id: <48030b162e63c73026f767111411e1ec4bf2719d.1243863850.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <7a3581d74ad9c623891133c8f0d85765eb11417c.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <1243866891-18713-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
 <7ed7ce4308999530ac3b69690ccd0e649970800d.1243863850.git.ext-denis.2.karpov@nokia.com>
 <7a3581d74ad9c623891133c8f0d85765eb11417c.1243863850.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
References: <d5dd6887ad284b7528bf70aa21bd33dd9c98eb4c.1243863850.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 01 Jun 2009 14:34:58.0668 (UTC) FILETIME=[23AC82C0:01C9E2C6]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement FAT fs mount option 'notify'. The effect of this option
is that a notification is sent to userspace on errors that indicate
filesystem damage/inconsistency. Generic filesystem corruption
notification mechnism is used.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/fat/fat.h   |    3 ++-
 fs/fat/inode.c |   12 ++++++++++--
 fs/fat/misc.c  |    7 +++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index d6fd6ab..1fb22ec 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -44,7 +44,8 @@ struct fat_mount_options {
 		 usefree:1,	  /* Use free_clusters for FAT32 */
 		 tz_utc:1,	  /* Filesystem timestamps are in UTC */
 		 rodir:1,	  /* allow ATTR_RO for directory */
-		 errors:3;	  /* On error: continue, panic, go ro */
+		 errors:3,	  /* On error: continue, panic, go ro */
+		 err_notify:1;	  /* Notify userspace on fs errors */
 };
 
 #define FAT_HASH_BITS	8
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 40fcf97..08b68bd 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -840,7 +840,9 @@ static int fat_show_options(struct seq_file *m, struct vfsmount *mnt)
 	if (opts->errors & FAT_ERRORS_PANIC)
 		seq_puts(m, ",errors=panic");
 	if (opts->errors & FAT_ERRORS_RO)
-		seq_puts(m, ",errors=ro");
+		seq_puts(m, ",errors=remount-ro");
+	if (opts->err_notify)
+		seq_puts(m, ",notify");
 
 	return 0;
 }
@@ -854,7 +856,7 @@ enum {
 	Opt_shortname_winnt, Opt_shortname_mixed, Opt_utf8_no, Opt_utf8_yes,
 	Opt_uni_xl_no, Opt_uni_xl_yes, Opt_nonumtail_no, Opt_nonumtail_yes,
 	Opt_obsolate, Opt_flush, Opt_tz_utc, Opt_rodir, Opt_err_cont,
-	Opt_err_panic, Opt_err_ro, Opt_err,
+	Opt_err_panic, Opt_err_ro, Opt_err_notify, Opt_err,
 };
 
 static const match_table_t fat_tokens = {
@@ -893,6 +895,7 @@ static const match_table_t fat_tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_err_notify, "notify"},
 	{Opt_err, NULL},
 };
 static const match_table_t msdos_tokens = {
@@ -903,6 +906,7 @@ static const match_table_t msdos_tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_err_notify, "notify"},
 	{Opt_err, NULL}
 };
 static const match_table_t vfat_tokens = {
@@ -936,6 +940,7 @@ static const match_table_t vfat_tokens = {
 	{Opt_err_cont, "errors=continue"},
 	{Opt_err_panic, "errors=panic"},
 	{Opt_err_ro, "errors=remount-ro"},
+	{Opt_err_notify, "notify"},
 	{Opt_err, NULL}
 };
 
@@ -1069,6 +1074,9 @@ static int parse_options(char *options, int is_vfat, int silent, int *debug,
 		case Opt_err_ro:
 			opts->errors = FAT_ERRORS_RO;
 			break;
+		case Opt_err_notify:
+			opts->err_notify = 1;
+			break;
 
 		/* msdos specific */
 		case Opt_dots:
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 1120094..3143a25 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/buffer_head.h>
+#include <linux/genhd.h>
 #include "fat.h"
 
 /*
@@ -41,6 +42,8 @@ void fat_fs_error(struct super_block *s, const char * function,
 		s->s_flags |= MS_RDONLY;
 		printk(KERN_ERR "    File system has been set read-only\n");
 	}
+	if (sbi->options.err_notify)
+		notify_part_fs_unclean(part_to_dev(s->s_bdev->bd_part), 1);
 }
 EXPORT_SYMBOL_GPL(fat_fs_error);
 
@@ -52,6 +55,7 @@ void fat_fs_warning(struct super_block *s, const char * function,
 			const char *fmt, ...)
 {
 	va_list args;
+	struct msdos_sb_info *sbi = MSDOS_SB(s);
 
 	printk(KERN_ERR "FAT: Filesystem warning (dev %s): %s:\n", s->s_id,
 		function);
@@ -61,6 +65,9 @@ void fat_fs_warning(struct super_block *s, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+
+	if (sbi->options.err_notify)
+		notify_part_fs_unclean(part_to_dev(s->s_bdev->bd_part), 1);
 }
 EXPORT_SYMBOL_GPL(fat_fs_warning);
 
-- 
1.6.0.4

