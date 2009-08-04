Return-Path: <linux-kernel-owner+w=401wt.eu-S932471AbZHDUeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbZHDUeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932442AbZHDUeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:34:13 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:29488 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932395AbZHDUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:34:13 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] init/initramfs.c: fix "symbol shadows an earlier one" noise
Date: Tue, 4 Aug 2009 13:34:13 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908041334.13758.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol 'count' is a static global variable used when unpacking the
rootfs.  Function clean_rootfs() uses this same symbol name locally
while walking the directory entries to clean the rootfs.  This results in
the following sparse warnings:

init/initramfs.c:526:13: warning: symbol 'count' shadows an earlier one
init/initramfs.c:167:28: originally declared here

Fix this by renaming the symbol in clean_rootfs().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/init/initramfs.c b/init/initramfs.c
index 4c00edc..893d0b4 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -523,7 +523,7 @@ static void __init clean_rootfs(void)
 	int fd;
 	void *buf;
 	struct linux_dirent64 *dirp;
-	int count;
+	int dents_count;
 
 	fd = sys_open("/", O_RDONLY, 0);
 	WARN_ON(fd < 0);
@@ -537,9 +537,9 @@ static void __init clean_rootfs(void)
 	}
 
 	dirp = buf;
-	count = sys_getdents64(fd, dirp, BUF_SIZE);
-	while (count > 0) {
-		while (count > 0) {
+	dents_count = sys_getdents64(fd, dirp, BUF_SIZE);
+	while (dents_count > 0) {
+		while (dents_count > 0) {
 			struct stat st;
 			int ret;
 
@@ -552,12 +552,12 @@ static void __init clean_rootfs(void)
 					sys_unlink(dirp->d_name);
 			}
 
-			count -= dirp->d_reclen;
+			dents_count -= dirp->d_reclen;
 			dirp = (void *)dirp + dirp->d_reclen;
 		}
 		dirp = buf;
 		memset(buf, 0, BUF_SIZE);
-		count = sys_getdents64(fd, dirp, BUF_SIZE);
+		dents_count = sys_getdents64(fd, dirp, BUF_SIZE);
 	}
 
 	sys_close(fd);
