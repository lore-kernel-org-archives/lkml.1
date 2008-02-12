Return-Path: <linux-kernel-owner+w=401wt.eu-S1762789AbYBLOAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762789AbYBLOAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759577AbYBLOAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:00:06 -0500
Received: from exprod7og104.obsmtp.com ([64.18.2.161]:52269 "EHLO
	exprod7og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034AbYBLOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:00:04 -0500
X-Greylist: delayed 725 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 09:00:04 EST
Date: Tue, 12 Feb 2008 13:47:51 +0000
From: Stephane Chazelas <stephane.chazelas@emerson.com>
To: Joern Engel <joern@lazybastard.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [PATCH 2.6.24] block2mtd: removing a device and typo fixes
Message-ID: <chaz20080212134751.GI30304@artesyncp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Embedded Computing Emerson Network Power
X-URL: http://www.emersonembeddedcomputing.com
User-Agent: Mutt/1.5.16 (2007-09-19)
X-OriginalArrivalTime: 12 Feb 2008 13:47:52.0771 (UTC) FILETIME=[DD179930:01C86D7D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joern,

this patch addresses a number of small issues mainly regarding
the output made by this driver to dmesg:
  - Some of the "blkmtd"'s had not been changed to "block2mtd"
    which caused display problem
  - the parse_err() macro was displaying "block2mtd: " twice

Also, one can add a block2mtd mtd device with things like:

echo /dev/loop3,$((256*1024)) |
  sudo tee /sys/module/block2mtd/parameters/block2mtd

but individual mtds cannot be removed. You can only do a
modprobe -r block2mtd to remove *all* the block2mtd mtds.

This patch proposes to add the cabability with:

echo /dev/loop3,remove |
  sudo tee /sys/module/block2mtd/parameters/block2mtd

Signed-off-by: Stephane Chazelas <stephane.chazelas@emerson.com>

--- drivers/mtd/devices/block2mtd.c~	2007-09-11 03:50:29.000000000 +0100
+++ drivers/mtd/devices/block2mtd.c	2008-02-12 13:30:16.000000000 +0000
@@ -305,7 +305,7 @@ static struct block2mtd_dev *add_device(
 	}
 	list_add(&dev->list, &blkmtd_device_list);
 	INFO("mtd%d: [%s] erase_size = %dKiB [%d]", dev->mtd.index,
-			dev->mtd.name + strlen("blkmtd: "),
+			dev->mtd.name + strlen("block2mtd: "),
 			dev->mtd.erasesize >> 10, dev->mtd.erasesize);
 	return dev;
 
@@ -366,9 +366,9 @@ static inline void kill_final_newline(ch
 }
 
 
-#define parse_err(fmt, args...) do {		\
-	ERROR("block2mtd: " fmt "\n", ## args);	\
-	return 0;				\
+#define parse_err(fmt, args...) do {	\
+	ERROR(fmt, ## args);		\
+	return 0;			\
 } while (0)
 
 #ifndef MODULE
@@ -376,6 +376,31 @@ static int block2mtd_init_called = 0;
 static char block2mtd_paramline[80 + 12]; /* 80 for device, 12 for erase size */
 #endif
 
+static void remove_device_by_name(const char *name)
+{
+	struct list_head *pos, *next;
+	int name_offset = strlen("block2mtd: ");
+
+	list_for_each_safe(pos, next, &blkmtd_device_list) {
+		struct block2mtd_dev *dev = list_entry(pos, typeof(*dev), list);
+		if (!strcmp(name, dev->mtd.name + name_offset)) {
+			int err;
+			block2mtd_sync(&dev->mtd);
+			err = del_mtd_device(&dev->mtd);
+			if (err == 0) {
+				INFO("mtd%d: [%s] removed",
+						dev->mtd.index, name);
+				list_del(&dev->list);
+				block2mtd_free_device(dev);
+			} else
+				ERROR("mtd%d: [%s] cannot remove: %d",
+						dev->mtd.index, name, err);
+
+			return;
+		}
+	}
+	ERROR("no such device: %s", name);
+}
 
 static int block2mtd_setup2(const char *val)
 {
@@ -406,6 +431,10 @@ static int block2mtd_setup2(const char *
 		parse_err("device name too long");
 
 	if (token[1]) {
+		if (!strcmp("remove", token[1])) {
+			remove_device_by_name(name);
+			return 0;
+		}
 		ret = parse_num(&erase_size, token[1]);
 		if (ret) {
 			kfree(name);
@@ -474,7 +503,7 @@ static void __devexit block2mtd_exit(voi
 		block2mtd_sync(&dev->mtd);
 		del_mtd_device(&dev->mtd);
 		INFO("mtd%d: [%s] removed", dev->mtd.index,
-				dev->mtd.name + strlen("blkmtd: "));
+				dev->mtd.name + strlen("block2mtd: "));
 		list_del(&dev->list);
 		block2mtd_free_device(dev);
 	}
