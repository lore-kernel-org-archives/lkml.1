Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbZIOTPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbZIOTPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758527AbZIOTPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:15:09 -0400
Received: from kroah.org ([198.145.64.141]:33047 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758446AbZIOTO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:14:59 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 06/20] mem_class: use minor as index instead of searching the array
Date: Tue, 15 Sep 2009 12:12:42 -0700
Message-Id: <1253041976-1111-6-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090915181247.GA32167@kroah.com>
References: <20090915181247.GA32167@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Declare the device list with the minor numbers as the index, which saves us from
searching for a matching list entry. Remove old devfs permissions declaration.

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/mem.c |   82 +++++++++++++++++++++++++--------------------------
 1 files changed, 40 insertions(+), 42 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 645237b..bed3503 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -864,71 +864,67 @@ static const struct file_operations kmsg_fops = {
 	.write =	kmsg_write,
 };
 
-static const struct {
-	unsigned int		minor;
-	char			*name;
-	umode_t			mode;
-	const struct file_operations	*fops;
-	struct backing_dev_info	*dev_info;
-} devlist[] = { /* list of minor devices */
-	{1, "mem",     S_IRUSR | S_IWUSR | S_IRGRP, &mem_fops,
-		&directly_mappable_cdev_bdi},
+static const struct memdev {
+	const char *name;
+	const struct file_operations *fops;
+	struct backing_dev_info *dev_info;
+} devlist[] = {
+	[ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },
 #ifdef CONFIG_DEVKMEM
-	{2, "kmem",    S_IRUSR | S_IWUSR | S_IRGRP, &kmem_fops,
-		&directly_mappable_cdev_bdi},
+	[ 2] = { "kmem", &kmem_fops, &directly_mappable_cdev_bdi },
 #endif
-	{3, "null",    S_IRUGO | S_IWUGO,           &null_fops, NULL},
+	[ 3] = {"null", &null_fops, NULL },
 #ifdef CONFIG_DEVPORT
-	{4, "port",    S_IRUSR | S_IWUSR | S_IRGRP, &port_fops, NULL},
+	[ 4] = { "port", &port_fops, NULL },
 #endif
-	{5, "zero",    S_IRUGO | S_IWUGO,           &zero_fops, &zero_bdi},
-	{7, "full",    S_IRUGO | S_IWUGO,           &full_fops, NULL},
-	{8, "random",  S_IRUGO | S_IWUSR,           &random_fops, NULL},
-	{9, "urandom", S_IRUGO | S_IWUSR,           &urandom_fops, NULL},
-	{11,"kmsg",    S_IRUGO | S_IWUSR,           &kmsg_fops, NULL},
+	[ 5] = { "zero", &zero_fops, &zero_bdi },
+	[ 6] = { "full", &full_fops, NULL },
+	[ 7] = { "random", &random_fops, NULL },
+	[ 9] = { "urandom", &urandom_fops, NULL },
+	[11] = { "kmsg", &kmsg_fops, NULL },
 #ifdef CONFIG_CRASH_DUMP
-	{12,"oldmem",    S_IRUSR | S_IWUSR | S_IRGRP, &oldmem_fops, NULL},
+	[12] = { "oldmem", &oldmem_fops, NULL },
 #endif
 };
 
 static int memory_open(struct inode *inode, struct file *filp)
 {
-	int ret = 0;
-	int i;
+	int minor;
+	const struct memdev *dev;
+	int ret = -ENXIO;
 
 	lock_kernel();
 
-	for (i = 0; i < ARRAY_SIZE(devlist); i++) {
-		if (devlist[i].minor == iminor(inode)) {
-			filp->f_op = devlist[i].fops;
-			if (devlist[i].dev_info) {
-				filp->f_mapping->backing_dev_info =
-					devlist[i].dev_info;
-			}
+	minor = iminor(inode);
+	if (minor >= ARRAY_SIZE(devlist))
+		goto out;
 
-			break;
-		}
-	}
+	dev = &devlist[minor];
+	if (!dev->fops)
+		goto out;
 
-	if (i == ARRAY_SIZE(devlist))
-		ret = -ENXIO;
-	else
-		if (filp->f_op && filp->f_op->open)
-			ret = filp->f_op->open(inode, filp);
+	filp->f_op = dev->fops;
+	if (dev->dev_info)
+		filp->f_mapping->backing_dev_info = dev->dev_info;
 
+	if (dev->fops->open)
+		ret = dev->fops->open(inode, filp);
+	else
+		ret = 0;
+out:
 	unlock_kernel();
 	return ret;
 }
 
 static const struct file_operations memory_fops = {
-	.open		= memory_open,	/* just a selector for the real open */
+	.open		= memory_open,
 };
 
 static struct class *mem_class;
 
 static int __init chr_dev_init(void)
 {
-	int i;
+	int minor;
 	int err;
 
 	err = bdi_init(&zero_bdi);
@@ -939,10 +935,12 @@ static int __init chr_dev_init(void)
 		printk("unable to get major %d for memory devs\n", MEM_MAJOR);
 
 	mem_class = class_create(THIS_MODULE, "mem");
-	for (i = 0; i < ARRAY_SIZE(devlist); i++)
-		device_create(mem_class, NULL,
-			      MKDEV(MEM_MAJOR, devlist[i].minor), NULL,
-			      devlist[i].name);
+	for (minor = 1; minor < ARRAY_SIZE(devlist); minor++) {
+		if (!devlist[minor].name)
+			continue;
+		device_create(mem_class, NULL, MKDEV(MEM_MAJOR, minor),
+			      NULL, devlist[minor].name);
+	}
 
 	return 0;
 }
-- 
1.6.4.2

