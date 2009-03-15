Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZCOS0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZCOS0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 14:26:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbZCOSZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 14:25:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:42368 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbZCOSZA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 14:25:00 -0400
Date: Sun, 15 Mar 2009 11:25:33 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH] fastboot: remove duplicate unpack_to_rootfs()
Message-ID: <20090315112533.61dee10e@infradead.org>
In-Reply-To: <20090315112345.764fc4ac@infradead.org>
References: <20090315112345.764fc4ac@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4ea6c5331652555dcc96b86e078b7dceaa38005b Mon Sep 17 00:00:00 2001
From: Li, Shaohua <shaohua.li@intel.com>
Date: Wed, 13 Aug 2008 17:26:01 +0800
Subject: [PATCH] fastboot: remove duplicate unpack_to_rootfs()

we check if initrd is initramfs first and then do the real unpack. The check
isn't required, we can directly do unpack.  If the initrd isn't an
initramfs, we can remove the garbage.  In my laptop, this saves 0.1s boot
time.

This patch penalizes non-initramfs initrd case, but nowadays, initramfs is
the most widely used method for initrds.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/initramfs.c |   71 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index d9c941c..d3c56fc 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -5,6 +5,7 @@
 #include <linux/fcntl.h>
 #include <linux/delay.h>
 #include <linux/string.h>
+#include <linux/dirent.h>
 #include <linux/syscalls.h>
 #include <linux/utime.h>
 
@@ -166,8 +167,6 @@ static __initdata char *victim;
 static __initdata unsigned count;
 static __initdata loff_t this_header, next_header;
 
-static __initdata int dry_run;
-
 static inline void __init eat(unsigned n)
 {
 	victim += n;
@@ -229,10 +228,6 @@ static int __init do_header(void)
 	parse_header(collected);
 	next_header = this_header + N_ALIGN(name_len) + body_len;
 	next_header = (next_header + 3) & ~3;
-	if (dry_run) {
-		read_into(name_buf, N_ALIGN(name_len), GotName);
-		return 0;
-	}
 	state = SkipIt;
 	if (name_len <= 0 || name_len > PATH_MAX)
 		return 0;
@@ -303,8 +298,6 @@ static int __init do_name(void)
 		free_hash();
 		return 0;
 	}
-	if (dry_run)
-		return 0;
 	clean_path(collected, mode);
 	if (S_ISREG(mode)) {
 		int ml = maybe_link();
@@ -476,10 +469,9 @@ static void __init flush_window(void)
 	outcnt = 0;
 }
 
-static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
+static char * __init unpack_to_rootfs(char *buf, unsigned len)
 {
 	int written;
-	dry_run = check_only;
 	header_buf = kmalloc(110, GFP_KERNEL);
 	symlink_buf = kmalloc(PATH_MAX + N_ALIGN(PATH_MAX) + 1, GFP_KERNEL);
 	name_buf = kmalloc(N_ALIGN(PATH_MAX), GFP_KERNEL);
@@ -574,10 +566,57 @@ skip:
 	initrd_end = 0;
 }
 
+#define BUF_SIZE 1024
+static void __init clean_rootfs(void)
+{
+	int fd;
+	void *buf;
+	struct linux_dirent64 *dirp;
+	int count;
+
+	fd = sys_open("/", O_RDONLY, 0);
+	WARN_ON(fd < 0);
+	if (fd < 0)
+		return;
+	buf = kzalloc(BUF_SIZE, GFP_KERNEL);
+	WARN_ON(!buf);
+	if (!buf) {
+		sys_close(fd);
+		return;
+	}
+
+	dirp = buf;
+	count = sys_getdents64(fd, dirp, BUF_SIZE);
+	while (count > 0) {
+		while (count > 0) {
+			struct stat st;
+			int ret;
+
+			ret = sys_newlstat(dirp->d_name, &st);
+			WARN_ON_ONCE(ret);
+			if (!ret) {
+				if (S_ISDIR(st.st_mode))
+					sys_rmdir(dirp->d_name);
+				else
+					sys_unlink(dirp->d_name);
+			}
+
+			count -= dirp->d_reclen;
+			dirp = (void *)dirp + dirp->d_reclen;
+		}
+		dirp = buf;
+		memset(buf, 0, BUF_SIZE);
+		count = sys_getdents64(fd, dirp, BUF_SIZE);
+	}
+
+	sys_close(fd);
+	kfree(buf);
+}
+
 static int __init populate_rootfs(void)
 {
 	char *err = unpack_to_rootfs(__initramfs_start,
-			 __initramfs_end - __initramfs_start, 0);
+			 __initramfs_end - __initramfs_start);
 	if (err)
 		panic(err);
 	if (initrd_start) {
@@ -585,13 +624,15 @@ static int __init populate_rootfs(void)
 		int fd;
 		printk(KERN_INFO "checking if image is initramfs...");
 		err = unpack_to_rootfs((char *)initrd_start,
-			initrd_end - initrd_start, 1);
+			initrd_end - initrd_start);
 		if (!err) {
 			printk(" it is\n");
-			unpack_to_rootfs((char *)initrd_start,
-				initrd_end - initrd_start, 0);
 			free_initrd();
 			return 0;
+		} else {
+			clean_rootfs();
+			unpack_to_rootfs(__initramfs_start,
+				 __initramfs_end - __initramfs_start);
 		}
 		printk("it isn't (%s); looks like an initrd\n", err);
 		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
@@ -604,7 +645,7 @@ static int __init populate_rootfs(void)
 #else
 		printk(KERN_INFO "Unpacking initramfs...");
 		err = unpack_to_rootfs((char *)initrd_start,
-			initrd_end - initrd_start, 0);
+			initrd_end - initrd_start);
 		if (err)
 			panic(err);
 		printk(" done\n");
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
