Return-Path: <linux-kernel-owner+w=401wt.eu-S1759241AbZFKM1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759241AbZFKM1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 08:27:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759342AbZFKM0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 08:26:07 -0400
Received: from smtp.nokia.com ([192.100.105.134]:49456 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761600AbZFKM0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 08:26:04 -0400
From: Denis Karpov <ext-denis.2.karpov@nokia.com>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       adrian.hunter@nokia.com, artem.bityutskiy@nokia.com,
       akpm@linux-foundation.org, kay.sievers@vrfy.org
Subject: [PATCH 1/5] FAT: add basic sysfs support
Date: Thu, 11 Jun 2009 15:24:45 +0300
Message-Id: <8b77851877f5aeea0bee653ca1dcdb30840449ab.1244729458.git.ext-denis.2.karpov@nokia.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
References: <1244723089-1145-1-git-send-email-ext-denis.2.karpov@nokia.com>
X-OriginalArrivalTime: 11 Jun 2009 12:24:54.0240 (UTC) FILETIME=[A000CE00:01C9EA8F]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic sysfs support so that information about the mounted
filesystem can be accessed via /sys/fs/fat/<dev>/*.

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/fat/fat.h   |    6 +++
 fs/fat/inode.c |  138 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 144 insertions(+), 0 deletions(-)

diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index ea440d6..d1cec33 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -72,6 +72,9 @@ struct msdos_sb_info {
 	int dir_per_block;	     /* dir entries per block */
 	int dir_per_block_bits;	     /* log2(dir_per_block) */
 
+	struct kobject s_kobj;	     /* kobject corresponfing to fs volume */
+	struct completion s_kobj_unregister;
+
 	int fatent_shift;
 	struct fatent_operations *fatent_ops;
 
@@ -309,6 +312,9 @@ extern int fat_fill_super(struct super_block *sb, void *data, int silent,
 
 extern int fat_flush_inodes(struct super_block *sb, struct inode *i1,
 		            struct inode *i2);
+extern int fat_sbi_attr_set_notify(struct msdos_sb_info *sbi,
+			unsigned long offset, unsigned long val);
+
 /* fat/misc.c */
 extern void fat_fs_panic(struct super_block *s, const char *fmt, ...)
 	__attribute__ ((format (printf, 2, 3))) __cold;
diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 296785a..82708fc 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -27,6 +27,7 @@
 #include <linux/writeback.h>
 #include <linux/log2.h>
 #include <linux/hash.h>
+#include <linux/ctype.h>
 #include <asm/unaligned.h>
 #include "fat.h"
 
@@ -35,6 +36,8 @@
 #define CONFIG_FAT_DEFAULT_IOCHARSET	""
 #endif
 
+static struct kset *fat_kset;
+
 static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
 static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
 
@@ -451,6 +454,7 @@ static void fat_put_super(struct super_block *sb)
 {
 	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 
+	kobject_del(&sbi->s_kobj);
 	if (sbi->nls_disk) {
 		unload_nls(sbi->nls_disk);
 		sbi->nls_disk = NULL;
@@ -466,6 +470,10 @@ static void fat_put_super(struct super_block *sb)
 	}
 
 	sb->s_fs_info = NULL;
+
+	kobject_put(&sbi->s_kobj);
+	wait_for_completion(&sbi->s_kobj_unregister);
+
 	kfree(sbi);
 }
 
@@ -1168,6 +1176,126 @@ static int fat_read_root(struct inode *inode)
 	return 0;
 }
 
+/* sysfs support */
+
+struct fat_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct fat_attr *, struct msdos_sb_info *, char *);
+	ssize_t (*store)(struct fat_attr *, struct msdos_sb_info *,
+			 const char *, size_t);
+	unsigned short offset;
+};
+
+static ssize_t fat_sbi_attr_show(struct fat_attr *a, struct msdos_sb_info *sbi,
+				char *buf)
+{
+	unsigned long attr_val = *(unsigned long *)(((char *) sbi) + a->offset);
+	return snprintf(buf, PAGE_SIZE, "%lu\n", attr_val);
+}
+
+static ssize_t fat_sbi_attr_store(struct fat_attr *a,
+					struct msdos_sb_info *sbi,
+					const char *buf, size_t count)
+{
+	unsigned long *attr_val = (unsigned long *)(((char *) sbi) + a->offset);
+
+	if (strict_strtoul(buf, 10, attr_val))
+		return -EINVAL;
+
+	return count;
+}
+
+#define FAT_SBI_ATTR(_name, _mode, _show, _store) \
+static struct fat_attr fat_attr_##_name = {			\
+	.attr = {.name = __stringify(_name), .mode = _mode },	\
+	.show	= _show,					\
+	.store	= _store,					\
+	.offset = offsetof(struct msdos_sb_info, _name),	\
+}
+#define FAT_SBI_RO_ATTR(name) FAT_SBI_ATTR(name, 0444, \
+				fat_sbi_attr_show, NULL)
+#define FAT_SBI_RW_ATTR(name) FAT_SBI_ATTR(name, 0644 \
+				fat_sbi_attr_show, fat_sbi_attr_store)
+
+#define ATTR_LIST(name) (&fat_attr_ ##name.attr)
+
+static struct attribute *fat_attrs[] = {
+	NULL
+};
+
+static struct attribute *find_attr_by_offset(struct kobject *kobj,
+					unsigned long offset)
+{
+	struct fat_attr **a = (struct fat_attr **)kobj->ktype->default_attrs;
+
+	for (; *a && (*a)->offset != offset; a++)
+		;
+
+	return (struct attribute *)*a;
+}
+
+int fat_sbi_attr_set_notify(struct msdos_sb_info *sbi,
+			unsigned long offset,
+			unsigned long val)
+{
+	struct fat_attr *a =
+		(struct fat_attr *) find_attr_by_offset(&sbi->s_kobj, offset);
+	unsigned long *attr_val;
+
+	if (!a)
+		return -EINVAL;
+
+	attr_val = (unsigned long *) (((char *) sbi) + a->offset);
+	if (*attr_val == val)
+		return 0;
+
+	*attr_val = val;
+
+	sysfs_notify(&sbi->s_kobj, NULL, a->attr.name);
+
+	return 0;
+}
+EXPORT_SYMBOL(fat_sbi_attr_set_notify);
+
+static ssize_t fat_attr_show(struct kobject *kobj, struct attribute *attr,
+				char *buf)
+{
+	struct msdos_sb_info *sbi = container_of(kobj, struct msdos_sb_info,
+						s_kobj);
+	struct fat_attr *a = container_of(attr, struct fat_attr, attr);
+
+	return a->show ? a->show(a, sbi, buf) : 0;
+}
+
+static ssize_t fat_attr_store(struct kobject *kobj,
+			       struct attribute *attr,
+			       const char *buf, size_t len)
+{
+	struct msdos_sb_info *sbi = container_of(kobj, struct msdos_sb_info,
+						s_kobj);
+	struct fat_attr *a = container_of(attr, struct fat_attr, attr);
+
+	return a->store ? a->store(a, sbi, buf, len) : 0;
+}
+
+static void fat_sb_release(struct kobject *kobj)
+{
+	struct msdos_sb_info *sbi = container_of(kobj, struct msdos_sb_info,
+						s_kobj);
+	complete(&sbi->s_kobj_unregister);
+}
+
+static struct sysfs_ops fat_attr_ops = {
+	.show	= fat_attr_show,
+	.store	= fat_attr_store,
+};
+
+static struct kobj_type fat_ktype = {
+	.default_attrs	= fat_attrs,
+	.sysfs_ops	= &fat_attr_ops,
+	.release	= fat_sb_release,
+};
+
 /*
  * Read the super block of an MS-DOS FS.
  */
@@ -1430,6 +1558,11 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
 		goto out_fail;
 	}
 
+	sbi->s_kobj.kset = fat_kset;
+	init_completion(&sbi->s_kobj_unregister);
+	error = kobject_init_and_add(&sbi->s_kobj, &fat_ktype, NULL,
+				   "%s", sb->s_id);
+
 	return 0;
 
 out_invalid:
@@ -1508,6 +1641,10 @@ static int __init init_fat_fs(void)
 {
 	int err;
 
+	fat_kset = kset_create_and_add("fat", NULL, fs_kobj);
+	if (!fat_kset)
+		return -ENOMEM;
+
 	err = fat_cache_init();
 	if (err)
 		return err;
@@ -1527,6 +1664,7 @@ static void __exit exit_fat_fs(void)
 {
 	fat_cache_destroy();
 	fat_destroy_inodecache();
+	kset_unregister(fat_kset);
 }
 
 module_init(init_fat_fs)
-- 
1.6.3.1

