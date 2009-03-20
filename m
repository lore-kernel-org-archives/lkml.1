Return-Path: <linux-kernel-owner+w=401wt.eu-S1756924AbZCTUf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbZCTUf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 16:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZCTUfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 16:35:16 -0400
Received: from viefep12-int.chello.at ([62.179.121.32]:38810 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZCTUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 16:35:15 -0400
X-Greylist: delayed 1024 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2009 16:35:14 EDT
X-SourceIP: 84.113.196.60
From: Simon Kitching <skitching@apache.org>
To: linux-kernel@vger.kernel.org
Cc: Simon Kitching <skitching@apache.org>
Subject: [PATCH] initramfs: prevent initramfs printk message being split by messages from other code.
Date: Fri, 20 Mar 2009 21:18:05 +0100
Message-Id: <1237580285-25792-1-git-send-email-skitching@apache.org>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initramfs uses printk without a linefeed, then does some work, then uses printk
to finish the message off. However if some other code does a printk in between,
then the messages get mixed together. Better for each message to be an independent
line...

  Example of problem that this fixes:
    checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
    Switched to high resolution mode on CPU 0
    it is

Signed-off-by: Simon Kitching <skitching@apache.org>
---
 init/initramfs.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index d9c941c..948a2c6 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -583,17 +583,18 @@ static int __init populate_rootfs(void)
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
-		printk(KERN_INFO "checking if image is initramfs...");
+		printk(KERN_INFO "Checking if rootfs image is initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start, 1);
 		if (!err) {
-			printk(" it is\n");
+			printk(KERN_INFO "rootfs image is initramfs; unpacking...\n");
 			unpack_to_rootfs((char *)initrd_start,
 				initrd_end - initrd_start, 0);
 			free_initrd();
 			return 0;
 		}
-		printk("it isn't (%s); looks like an initrd\n", err);
+		printk(KERN_INFO "rootfs image is not initramfs (%s)"
+			"; looks like an initrd\n", err);
 		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);
 		if (fd >= 0) {
 			sys_write(fd, (char *)initrd_start,
-- 
1.6.0.4

