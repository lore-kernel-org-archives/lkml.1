Return-Path: <linux-kernel-owner+w=401wt.eu-S932618AbZE3QEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbZE3QEk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759595AbZE3QEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 12:04:32 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:58976 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759539AbZE3QEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 12:04:32 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "linux-kernel" <linux-kernel@vger.kernel.org>, mingo@elte.hu
Subject: [PATCH] Fix floppy hibernation
Date: Sat, 30 May 2009 18:04:25 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905301804.26762.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
floppy driver was always missing hibernation support. After resume, floppy did
not work (until a couple of disk reinserts and retries), producing errors like
this:
end_request: I/O error, dev fd0, sector 0

Ingo Molnar tried to fix it in 2006: http://lkml.org/lkml/2006/11/12/92




Based on Ingo Molnar's patch from 2006, this makes the floppy work after
resume from hibernation, at least on my machine.


Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

--- linux-2.6.29.4-orig/drivers/block/floppy.c	2009-05-30 14:38:29.000000000 +0200
+++ linux/drivers/block/floppy.c	2009-05-30 17:50:32.000000000 +0200
@@ -4148,6 +4148,24 @@
 {
 }
 
+static int floppy_resume(struct platform_device *dev)
+{
+	int i;
+
+	for (i = 0; i < N_FDC; i++)
+		if (FDCS->address != -1)
+			user_reset_fdc(-1, FD_RESET_ALWAYS, 0);
+
+	return 0;
+}
+
+static struct platform_driver floppy_driver = {
+	.resume = floppy_resume,
+	.driver = {
+		.name = "floppy",
+	},
+};
+
 static struct platform_device floppy_device[N_DRIVE];
 
 static struct kobject *floppy_find(dev_t dev, int *part, void *data)
@@ -4196,10 +4214,14 @@
 	if (err)
 		goto out_put_disk;
 
+	err = platform_driver_register(&floppy_driver);
+	if (err)
+		goto out_unreg_blkdev;
+
 	floppy_queue = blk_init_queue(do_fd_request, &floppy_lock);
 	if (!floppy_queue) {
 		err = -ENOMEM;
-		goto out_unreg_blkdev;
+		goto out_unreg_driver;
 	}
 	blk_queue_max_sectors(floppy_queue, 64);
 
@@ -4346,6 +4368,8 @@
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	blk_cleanup_queue(floppy_queue);
+out_unreg_driver:
+	platform_driver_unregister(&floppy_driver);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
@@ -4566,6 +4590,7 @@
 
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
+	platform_driver_unregister(&floppy_driver);
 
 	for (drive = 0; drive < N_DRIVE; drive++) {
 		del_timer_sync(&motor_off_timer[drive]);


-- 
Ondrej Zary
