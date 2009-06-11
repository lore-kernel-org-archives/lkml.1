Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbZFKM0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbZFKM0t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761647AbZFKM0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:26:04 -0400
Received: from smtp.nokia.com ([192.100.122.233]:17736 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758816AbZFKM0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:26:02 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org, kay.sievers@vrfy.org
Subject: [PATCH 4/5] FAT: notify userspace of fs errors with uevents
Date: Thu, 11 Jun 2009 15:24:48 +0300
Message-Id: <5dac59b1ab6cfd9b5f3d86dd18a3e9ab901f76f6.1244729458.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <6fadbb49517504006fae38b81346eac06d7e24c4.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
 <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
 <ab9ac124f4c0821eb0d03135252754e83410b2ba.1244729458.git.ext-denis.2.karpov@nokia.com>
 <6fadbb49517504006fae38b81346eac06d7e24c4.1244729458.git.ext-denis.2.karpov@nokia.com>
In-Reply-To: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
References: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 11 Jun 2009 12:24:58.0927 (UTC) FILETIME=[A2CBFBF0:01C9EA8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mechnism to optionally notify userspace about fs errors with
uevents associated with fs kobject's attribute:
	/sys/fs/fat/<part_bdev>/fs_fault

uevent's type is KOBJ_CHANGE, uevent's environment variable FS_FAULT=1.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/fat/fat.h   |    6 +++---
 fs/fat/inode.c |   37 +++++++++++++++++++++++++++++++------
 fs/fat/misc.c  |    4 ++--
 3 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index 480be11..ebf4c62 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -87,9 +87,9 @@ struct msdos_sb_info {
 #define FAT_CACHE_VALID	0	/* special case for valid cache */
 
 /* Mark FAT run-time errors  */
-#define FAT_FS_FAULT_SET(sbi, val) \
+#define FAT_FS_FAULT_SET(sbi, val, notify) \
 	fat_sbi_attr_set_notify(sbi, offsetof(struct msdos_sb_info, fs_fault), \
-				val)
+				val, notify)
 
 /*
  * MS-DOS file system inode data in memory
@@ -320,7 +320,7 @@ extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
 extern int fat_sbi_attr_set_notify(struct msdos_sb_info *sbi,
-			unsigned long offset, unsigned long val);
+			unsigned long offset, unsigned long val, int notify);
 
 /* fat/misc.c */
 extern void fat_fs_error(struct super_block *s, const char *function,
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 4613343..b1a0c8d 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -527,7 +527,7 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
-	FAT_FS_FAULT_SET(sbi, 0);
+	FAT_FS_FAULT_SET(sbi, 0, 0);
 	return 0;
 }
 
@@ -1185,6 +1185,7 @@ struct fat_attr {
 	ssize_t (*store)(struct fat_attr *, struct msdos_sb_info *,
 			 const char *, size_t);
 	unsigned short offset;
+	unsigned short uevent;
 };
 
 static ssize_t fat_sbi_attr_show(struct fat_attr *a, struct msdos_sb_info *sbi,
@@ -1206,17 +1207,22 @@ static ssize_t fat_sbi_attr_store(struct fat_attr *a,
 	return count;
 }
 
-#define FAT_SBI_ATTR(_name, _mode, _show, _store) \
+#define FAT_SBI_ATTR(_name, _mode, _show, _store, _uevent) \
 static struct fat_attr fat_attr_##_name = {			\
 	.attr = {.name = __stringify(_name), .mode = _mode },	\
 	.show	= _show,					\
 	.store	= _store,					\
 	.offset = offsetof(struct msdos_sb_info, _name),	\
+	.uevent = _uevent,					\
 }
 #define FAT_SBI_RO_ATTR(name) FAT_SBI_ATTR(name, 0444, \
-				fat_sbi_attr_show, NULL)
+				fat_sbi_attr_show, NULL, 0)
 #define FAT_SBI_RW_ATTR(name) FAT_SBI_ATTR(name, 0644 \
-				fat_sbi_attr_show, fat_sbi_attr_store)
+				fat_sbi_attr_show, fat_sbi_attr_store, 0)
+#define FAT_SBI_RO_ATTR_NOTIFY(name) FAT_SBI_ATTR(name, 0444, \
+				fat_sbi_attr_show, NULL, 1)
+#define FAT_SBI_RW_ATTR_NOTIFY(name) FAT_SBI_ATTR(name, 0644, \
+				fat_sbi_attr_show, fat_sbi_attr_store, 1)
 
 #define ATTR_LIST(name) (&fat_attr_ ##name.attr)
 
@@ -1240,11 +1246,15 @@ static struct attribute *find_attr_by_offset(struct kobject *kobj,
 
 int fat_sbi_attr_set_notify(struct msdos_sb_info *sbi,
 			unsigned long offset,
-			unsigned long val)
+			unsigned long val,
+			int notify)
 {
 	struct fat_attr *a =
 		(struct fat_attr *) find_attr_by_offset(&sbi->s_kobj, offset);
 	unsigned long *attr_val;
+	int ev_len;
+	char *t_str;
+	char *envp[] = { NULL, NULL };
 
 	if (!a)
 		return -EINVAL;
@@ -1257,6 +1267,21 @@ int fat_sbi_attr_set_notify(struct msdos_sb_info *sbi,
 
 	sysfs_notify(&sbi->s_kobj, NULL, a->attr.name);
 
+	if (!notify || !a->uevent)
+		return 0;
+
+	/* dec MAX_UINT == 10 char string */
+	ev_len = strlen(a->attr.name) + 1 + 10 + 1;
+	envp[0] = t_str = kzalloc(ev_len, GFP_KERNEL);
+	if (!t_str)
+		return -ENOMEM;
+
+	snprintf(t_str, ev_len, "%s=%lu", a->attr.name, val);
+	while ((*t_str++ = toupper(*t_str)))
+		;
+	kobject_uevent_env(&sbi->s_kobj, KOBJ_CHANGE, envp);
+	kfree(envp[0]);
+
 	return 0;
 }
 EXPORT_SYMBOL(fat_sbi_attr_set_notify);
@@ -1573,7 +1598,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		printk(KERN_ERR "FAT: create fs kobject failed\n");
 		goto out_fail;
 	}
-	FAT_FS_FAULT_SET(sbi, 0);
+	FAT_FS_FAULT_SET(sbi, 0, 0);
 
 	return 0;
 
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index ce478be..8cdefd8 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -35,7 +35,7 @@ void fat_fs_error(struct super_block *s, const char *function,
 		printk(KERN_ERR "    File system has been set read-only\n");
 	}
 
-	FAT_FS_FAULT_SET(sbi, 1);
+	FAT_FS_FAULT_SET(sbi, 1, 0);
 }
 EXPORT_SYMBOL_GPL(fat_fs_error);
 
@@ -58,7 +58,7 @@ void fat_fs_warning(struct super_block *s, const char * function,
 	printk("\n");
 	va_end(args);
 
-	FAT_FS_FAULT_SET(sbi, 1);
+	FAT_FS_FAULT_SET(sbi, 1, 0);
 }
 EXPORT_SYMBOL_GPL(fat_fs_warning);
 
-- 
1.6.3.1

