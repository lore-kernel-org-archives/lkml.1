Return-Path: <linux-kernel-owner+w=401wt.eu-S1754436AbYHMF7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbYHMF7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 01:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYHMF7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 01:59:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:44088 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYHMF7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 01:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,199,1217833200"; 
   d="scan'208";a="428761016"
Subject: [patch]fastboot: remove duplicate unpack_to_rootfs()
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain
Date: Wed, 13 Aug 2008 14:07:49 +0800
Message-ID: <1218607669.3463.9.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we check if initrd is initramfs first and then do real unpack. The check
isn't required, we can directly do unpack. If initrd isn't initramfs, we
can remove garbage. In my laptop, this saves 0.1s boot time. This
penalizes non-initramfs case, but now initramfs is mostly widely used.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/init/initramfs.c b/init/initramfs.c
index 644fc01..e51c92b 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -5,6 +5,7 @@
 #include <linux/fcntl.h>
 #include <linux/delay.h>
 #include <linux/string.h>
+#include <linux/dirent.h>
 #include <linux/syscalls.h>
 
 static __initdata char *message;
@@ -520,6 +521,37 @@ skip:
 	initrd_end = 0;
 }
 
+static void __init clean_rootfs(void)
+{
+	int fd = sys_open("/", O_RDONLY, 0);
+	void *buf = malloc(1024);
+	struct linux_dirent64 *dirp = buf;
+	int count;
+
+	memset(buf, 0, PAGE_SIZE);
+	count = sys_getdents64(fd, dirp, PAGE_SIZE);
+	while (count > 0) {
+		while (count > 0) {
+			struct stat st;
+
+			sys_newlstat(dirp->d_name, &st);
+			if (S_ISDIR(st.st_mode))
+				sys_rmdir(dirp->d_name);
+			else
+				sys_unlink(dirp->d_name);
+
+			count -= dirp->d_reclen;
+			dirp = (void *)dirp + dirp->d_reclen;
+		}
+		dirp = buf;
+		memset(buf, 0, 1024);
+		count = sys_getdents64(fd, dirp, PAGE_SIZE);
+	}
+
+	sys_close(fd);
+	free(buf);
+}
+
 static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start,
@@ -531,13 +563,15 @@ static int __init populate_rootfs(void)
 		int fd;
 		printk(KERN_INFO "checking if image is initramfs...");
 		err = unpack_to_rootfs((char *)initrd_start,
-			initrd_end - initrd_start, 1);
+			initrd_end - initrd_start, 0);
 		if (!err) {
 			printk(" it is\n");
-			unpack_to_rootfs((char *)initrd_start,
-				initrd_end - initrd_start, 0);
 			free_initrd();
 			return 0;
+		} else {
+			clean_rootfs();
+			unpack_to_rootfs(__initramfs_start,
+				 __initramfs_end - __initramfs_start, 0);
 		}
 		printk("it isn't (%s); looks like an initrd\n", err);
 		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);


