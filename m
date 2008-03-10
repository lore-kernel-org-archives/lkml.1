Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbYCJUV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbYCJUV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbYCJUVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:21:50 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:44825 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbYCJUVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:21:49 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] Block: floppy, fix rmmod lockup
Date: Mon, 10 Mar 2008 21:20:55 +0100
Message-Id: <1205180455-3330-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

floppy rmmod locks up when no such hardware was initialized, since there is
nobody to wake the remove code up. Remove the completion, because release
is called during platform_unregister anyway.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/block/floppy.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 32c79a5..7652e87 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -217,7 +217,6 @@ static int use_virtual_dma;
  */
 
 static DEFINE_SPINLOCK(floppy_lock);
-static struct completion device_release;
 
 static unsigned short virtual_dma_port = 0x3f0;
 irqreturn_t floppy_interrupt(int irq, void *dev_id);
@@ -4144,7 +4143,6 @@ DEVICE_ATTR(cmos,S_IRUGO,floppy_cmos_show,NULL);
 
 static void floppy_device_release(struct device *dev)
 {
-	complete(&device_release);
 }
 
 static struct platform_device floppy_device[N_DRIVE];
@@ -4539,7 +4537,6 @@ void cleanup_module(void)
 {
 	int drive;
 
-	init_completion(&device_release);
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 
@@ -4564,8 +4561,6 @@ void cleanup_module(void)
 
 	/* eject disk, if any */
 	fd_eject(0);
-
-	wait_for_completion(&device_release);
 }
 
 module_param(floppy, charp, 0);
-- 
1.5.4.1

