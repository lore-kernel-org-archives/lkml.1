Return-Path: <linux-kernel-owner+w=401wt.eu-S1762925AbZFKM0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762925AbZFKM0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZFKMZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:25:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:19596 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075AbZFKMZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:25:46 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org, kay.sievers@vrfy.org
Subject: [PATCH 3/5] FAT: notify userspace of fs errors through sysfs
Date: Thu, 11 Jun 2009 15:24:47 +0300
Message-Id: <6fadbb49517504006fae38b81346eac06d7e24c4.1244729458.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <ab9ac124f4c0821eb0d03135252754e83410b2ba.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
 <ab9ac124f4c0821eb0d03135252754e83410b2ba.1244729458.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 11 Jun 2009 12:24:57.0380 (UTC) FILETIME=[A1DFEE40:01C9EA8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Report file system' errors through fs kobject's sysfs interface:
/sys/fs/fat/<part_bdev>/fs_fault.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/fat/fat.h   |    7 +++++++
 fs/fat/inode.c |    9 +++++++++
 fs/fat/misc.c  |    6 ++++++
 3 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 1b64bae..480be11 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -72,6 +72,8 @@ struct msdos_sb_info {
 	int dir_per_block;	     /* dir entries per block */
 	int dir_per_block_bits;	     /* log2(dir_per_block) */
 
+	unsigned long fs_fault;	     /* Mark filesystem's run-time errors */
+
 	struct kobject s_kobj;	     /* kobject corresponfing to fs volume */
 	struct completion s_kobj_unregister;
 
@@ -84,6 +86,11 @@ struct msdos_sb_info {
 
 #define FAT_CACHE_VALID	0	/* special case for valid cache */
 
+/* Mark FAT run-time errors  */
+#define FAT_FS_FAULT_SET(sbi, val) \
+	fat_sbi_attr_set_notify(sbi, offsetof(struct msdos_sb_info, fs_fault), \
+				val)
+
 /*
  * MS-DOS file system inode data in memory
  */
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 61d52d1..4613343 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -527,6 +527,7 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
+	FAT_FS_FAULT_SET(sbi, 0);
 	return 0;
 }
 
@@ -1219,7 +1220,10 @@ static struct fat_attr fat_attr_##_name = {			\
 
 #define ATTR_LIST(name) (&fat_attr_ ##name.attr)
 
+FAT_SBI_RO_ATTR(fs_fault);
+
 static struct attribute *fat_attrs[] = {
+	ATTR_LIST(fs_fault),
 	NULL
 };
 
@@ -1565,6 +1569,11 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 	init_completion(&sbi->s_kobj_unregister);
 	error = kobject_init_and_add(&sbi->s_kobj, &fat_ktype, NULL,
 				   "%s", sb->s_id);
+	if (error) {
+		printk(KERN_ERR "FAT: create fs kobject failed\n");
+		goto out_fail;
+	}
+	FAT_FS_FAULT_SET(sbi, 0);
 
 	return 0;
 
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index be9cb03..ce478be 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -19,6 +19,7 @@ void fat_fs_error(struct super_block *s, const char *function,
 		const char *fmt, ...)
 {
 	va_list args;
+	struct msdos_sb_info *sbi = MSDOS_SB(s);
 
 	printk(KERN_ERR "FAT: Filesystem error (dev %s): %s:\n", s->s_id,
 		function);
@@ -33,6 +34,8 @@ void fat_fs_error(struct super_block *s, const char *function,
 		s->s_flags |= MS_RDONLY;
 		printk(KERN_ERR "    File system has been set read-only\n");
 	}
+
+	FAT_FS_FAULT_SET(sbi, 1);
 }
 EXPORT_SYMBOL_GPL(fat_fs_error);
 
@@ -44,6 +47,7 @@ void fat_fs_warning(struct super_block *s, const char * function,
 		const char *fmt, ...)
 {
 	va_list args;
+	struct msdos_sb_info *sbi = MSDOS_SB(s);
 
 	printk(KERN_ERR "FAT: Filesystem warning (dev %s): %s:\n", s->s_id,
 		function);
@@ -53,6 +57,8 @@ void fat_fs_warning(struct super_block *s, const char * function,
 	vprintk(fmt, args);
 	printk("\n");
 	va_end(args);
+
+	FAT_FS_FAULT_SET(sbi, 1);
 }
 EXPORT_SYMBOL_GPL(fat_fs_warning);
 
-- 
1.6.3.1

