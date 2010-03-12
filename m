Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab0CLKZT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 05:25:19 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:37066 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab0CLKZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 05:25:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=h1ghq1gg8vLQWnTfthHBYeG0OEGNJKh2v+yaJB/7P8FhVDLusP5GEql0g+Fl0zJsxL
         6v+s6FTQ5+gsJK9htAA98nLWbzRdtXF821CpH0o2FnAzx1APLoRblfnNuWIv/ME4m72o
         BKlhvpL4E+z7jGoN6cKZJ5wGg/HeqOvyK05lU=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: kay.sievers@vrfy.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] devtmpfs: support !CONFIG_TMPFS
Date: Fri, 12 Mar 2010 11:25:04 +0100
Message-Id: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make devtmpfs available on (embedded) configurations without SHMEM/TMPFS,
using ramfs instead.

Saves ~15KB.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/base/Kconfig    |    2 +-
 drivers/base/devtmpfs.c |    5 +++++
 fs/ramfs/inode.c        |    2 +-
 include/linux/ramfs.h   |    2 ++
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index fd52c48..7e33b16 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -18,7 +18,7 @@ config UEVENT_HELPER_PATH
 
 config DEVTMPFS
 	bool "Maintain a devtmpfs filesystem to mount at /dev"
-	depends on HOTPLUG && SHMEM && TMPFS
+	depends on HOTPLUG
 	help
 	  This creates a tmpfs filesystem instance early at bootup.
 	  In this filesystem, the kernel driver core maintains device
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index dac478c..6927262 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -20,6 +20,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include <linux/shmem_fs.h>
+#include <linux/ramfs.h>
 #include <linux/cred.h>
 #include <linux/sched.h>
 #include <linux/init_task.h>
@@ -44,7 +45,11 @@ __setup("devtmpfs.mount=", mount_param);
 static int dev_get_sb(struct file_system_type *fs_type, int flags,
 		      const char *dev_name, void *data, struct vfsmount *mnt)
 {
+#ifdef CONFIG_TMPFS
 	return get_sb_single(fs_type, flags, data, shmem_fill_super, mnt);
+#else
+	return get_sb_single(fs_type, flags, data, ramfs_fill_super, mnt);
+#endif
 }
 
 static struct file_system_type dev_fs_type = {
diff --git a/fs/ramfs/inode.c b/fs/ramfs/inode.c
index a6090aa..1a5259a 100644
--- a/fs/ramfs/inode.c
+++ b/fs/ramfs/inode.c
@@ -213,7 +213,7 @@ static int ramfs_parse_options(char *data, struct ramfs_mount_opts *opts)
 	return 0;
 }
 
-static int ramfs_fill_super(struct super_block * sb, void * data, int silent)
+int ramfs_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct ramfs_fs_info *fsi;
 	struct inode *inode = NULL;
diff --git a/include/linux/ramfs.h b/include/linux/ramfs.h
index 4e768dd..8600508 100644
--- a/include/linux/ramfs.h
+++ b/include/linux/ramfs.h
@@ -20,4 +20,6 @@ extern const struct file_operations ramfs_file_operations;
 extern const struct vm_operations_struct generic_file_vm_ops;
 extern int __init init_rootfs(void);
 
+int ramfs_fill_super(struct super_block *sb, void *data, int silent);
+
 #endif
-- 
1.7.0

