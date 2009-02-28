Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZB1VZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZB1VZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 16:25:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZB1VYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 16:24:53 -0500
Received: from verein.lst.de ([213.95.11.210]:34821 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011AbZB1VYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 16:24:52 -0500
Date: Sat, 28 Feb 2009 22:24:39 +0100
From: Christoph Hellwig <hch@lst.de>
To: jdike@addtoit.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ubd: stop defintining MAJOR_NR
Message-ID: <20090228212439.GB24377@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAJOR_NR isn't needed anymore since very early 2.5 kernels.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/arch/um/drivers/ubd_kern.c
===================================================================
--- linux-2.6.orig/arch/um/drivers/ubd_kern.c	2009-02-27 17:42:27.624286635 +0100
+++ linux-2.6/arch/um/drivers/ubd_kern.c	2009-02-27 17:43:04.858165103 +0100
@@ -17,7 +17,6 @@
  * James McMechan
  */
 
-#define MAJOR_NR UBD_MAJOR
 #define UBD_SHIFT 4
 
 #include "linux/kernel.h"
@@ -115,7 +114,7 @@ static struct block_device_operations ub
 };
 
 /* Protected by ubd_lock */
-static int fake_major = MAJOR_NR;
+static int fake_major = UBD_MAJOR;
 static struct gendisk *ubd_gendisk[MAX_DEV];
 static struct gendisk *fake_gendisk[MAX_DEV];
 
@@ -299,7 +298,7 @@ static int ubd_setup_common(char *str, i
 		}
 
 		mutex_lock(&ubd_lock);
-		if(fake_major != MAJOR_NR){
+		if(fake_major != UBD_MAJOR){
 			*error_out = "Can't assign a fake major twice";
 			goto out1;
 		}
@@ -818,13 +817,13 @@ static int ubd_disk_register(int major, 
 	disk->first_minor = unit << UBD_SHIFT;
 	disk->fops = &ubd_blops;
 	set_capacity(disk, size / 512);
-	if(major == MAJOR_NR)
+	if(major == UBD_MAJOR)
 		sprintf(disk->disk_name, "ubd%c", 'a' + unit);
 	else
 		sprintf(disk->disk_name, "ubd_fake%d", unit);
 
 	/* sysfs register (not for ide fake devices) */
-	if (major == MAJOR_NR) {
+	if (major == UBD_MAJOR) {
 		ubd_devs[unit].pdev.id   = unit;
 		ubd_devs[unit].pdev.name = DRIVER_NAME;
 		ubd_devs[unit].pdev.dev.release = ubd_device_release;
@@ -871,13 +870,13 @@ static int ubd_add(int n, char **error_o
 	ubd_dev->queue->queuedata = ubd_dev;
 
 	blk_queue_max_hw_segments(ubd_dev->queue, MAX_SG);
-	err = ubd_disk_register(MAJOR_NR, ubd_dev->size, n, &ubd_gendisk[n]);
+	err = ubd_disk_register(UBD_MAJOR, ubd_dev->size, n, &ubd_gendisk[n]);
 	if(err){
 		*error_out = "Failed to register device";
 		goto out_cleanup;
 	}
 
-	if(fake_major != MAJOR_NR)
+	if(fake_major != UBD_MAJOR)
 		ubd_disk_register(fake_major, ubd_dev->size, n,
 				  &fake_gendisk[n]);
 
@@ -1059,10 +1058,10 @@ static int __init ubd_init(void)
 	char *error;
 	int i, err;
 
-	if (register_blkdev(MAJOR_NR, "ubd"))
+	if (register_blkdev(UBD_MAJOR, "ubd"))
 		return -1;
 
-	if (fake_major != MAJOR_NR) {
+	if (fake_major != UBD_MAJOR) {
 		char name[sizeof("ubd_nnn\0")];
 
 		snprintf(name, sizeof(name), "ubd_%d", fake_major);
