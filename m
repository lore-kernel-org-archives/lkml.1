Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbZEEP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbZEEP57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 11:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZEEP5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 11:57:48 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:23233 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZEEP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 11:57:47 -0400
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <4A0061F3.5030506@tremplin-utc.net>
Date: Tue, 05 May 2009 17:57:39 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] Clean up messages related to initramfs unpacking
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the removal of duplicate unpack_to_rootfs() (commit
df52092f3c97788592ef72501a43fb7ac6a3cfe0) the messages displayed do not
actually correspond to what the kernel is doing. In addition, depending
if ramdisks are supported or not, the messages are not at all the same.

So keep the messages more in sync with what is really doing the kernel,
and only display a second message in case of failure. This also ensure
that the printk message cannot be split by other printk's.

Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
---
 init/initramfs.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index 9ee7b78..4c00edc 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -574,11 +574,10 @@ static int __init populate_rootfs(void)
 	if (initrd_start) {
 #ifdef CONFIG_BLK_DEV_RAM
 		int fd;
-		printk(KERN_INFO "checking if image is initramfs...\n");
+		printk(KERN_INFO "Trying to unpack rootfs image as initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
 		if (!err) {
-			printk(KERN_INFO "rootfs image is initramfs; unpacking...\n");
 			free_initrd();
 			return 0;
 		} else {
@@ -596,15 +595,11 @@ static int __init populate_rootfs(void)
 			free_initrd();
 		}
 #else
-		printk(KERN_INFO "Unpacking initramfs...");
+		printk(KERN_INFO "Unpacking initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
 			initrd_end - initrd_start);
-		if (err) {
-			printk(" failed!\n");
-			printk(KERN_EMERG "%s\n", err);
-		} else {
-			printk(" done\n");
-		}
+		if (err)
+			printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
 		free_initrd();
 #endif
 	}
-- 
1.6.2.4


