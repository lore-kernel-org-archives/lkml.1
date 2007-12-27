Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbXL0W6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbXL0W6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 17:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXL0W60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 17:58:26 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2641 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXL0W6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 17:58:25 -0500
Subject: Re: [PATCH] SH/Dreamcast - add support for GD-Rom device
From: Joe Perches <joe@perches.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>
In-Reply-To: <1198774339.6170.11.camel@localhost.localdomain>
References: <1198774339.6170.11.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 27 Dec 2007 14:58:01 -0800
Message-Id: <1198796281.4833.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-27 at 16:52 +0000, Adrian McMenamin wrote:
> This patch adds support for the CD-Rom drive on the SEGA Dreamcast.

Because it was already so close, might as well make it checkpatch clean.

I also added a function gdrom_is_busy() to make a couple of tests
fit on a single line and perhaps easier to read.

Signed-off-by: Joe Perches <joe@perches.com>

--- a/drivers/cdrom/gdrom.c	2007-12-27 14:49:27.000000000 -0800
+++ b/drivers/cdrom/gdrom.c	2007-12-27 14:46:20.000000000 -0800
@@ -86,7 +86,8 @@
 	{MEDIUM_ERROR, "GDROM: Disk not ready"},
 	{HARDWARE_ERROR, "GDROM: Hardware error"},
 	{ILLEGAL_REQUEST, "GDROM: Command has failed"},
-	{UNIT_ATTENTION, "GDROM: Device needs attention - disk may have been changed"},
+	{UNIT_ATTENTION, "GDROM: Device needs attention - "
+			 "disk may have been changed"},
 	{DATA_PROTECT, "GDROM: Data protection error"},
 	{ABORTED_COMMAND, "GDROM: Command aborted"},
 };
@@ -130,14 +131,20 @@
 };
 
 static int gdrom_getsense(short *bufstring);
-static int gdrom_packetcommand(struct cdrom_device_info *cd_info, struct packet_command *command);
+static int gdrom_packetcommand(struct cdrom_device_info *cd_info,
+			       struct packet_command *command);
 static int gdrom_hardreset(struct cdrom_device_info *cd_info);
 
+static bool gdrom_is_busy(void)
+{
+	return (ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) != 0;
+}
+
 static void gdrom_wait_clrbusy(void)
 {
 	/* long timeouts - typical for a CD Rom */
 	unsigned long timeout = jiffies + HZ * 60;
-	while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) && (time_before(jiffies, timeout)))
+	while (gdrom_is_busy() && (time_before(jiffies, timeout)))
 		cpu_relax();
 }
 
@@ -146,7 +153,7 @@
 	unsigned long timeout;
 	/* Wait to get busy first */
 	timeout = jiffies + HZ * 60;
-	while (((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) == 0) && (time_before(jiffies, timeout)))
+	while (!gdrom_is_busy() && (time_before(jiffies, timeout)))
 		cpu_relax();
 	/* Now wait for busy to clear */
 	gdrom_wait_clrbusy();
@@ -216,7 +223,8 @@
 	gd.pending = 1;
 	gdrom_packetcommand(gd.cd_info, spin_command);
 	/* 60 second timeout */
-	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
+	wait_event_interruptible_timeout(command_queue,
+					 gd.pending == 0, HZ * 60);
 	gd.pending = 0;
 	kfree(spin_command);
 	if (gd.status & 0x01) {
@@ -249,7 +257,8 @@
 	toc_command->buflen = tocsize;
 	gd.pending = 1;
 	gdrom_packetcommand(gd.cd_info, toc_command);
-	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
+	wait_event_interruptible_timeout(command_queue,
+					 gd.pending == 0, HZ * 60);
 	gd.pending = 0;
 	insw(PHYSADDR(GDROM_DATA_REG), toc, tocsize/2);
 	kfree(toc_command);
@@ -274,7 +283,8 @@
 	return (track & 0x0000ff00) >> 8;
 }
 
-static int gdrom_get_last_session(struct cdrom_device_info *cd_info, struct cdrom_multisession *ms_info)
+static int gdrom_get_last_session(struct cdrom_device_info *cd_info,
+				  struct cdrom_multisession *ms_info)
 {
 	int fentry, lentry, track, data, tocuse, err;
 	if (!gd.toc)
@@ -287,7 +297,8 @@
 		tocuse = 0;
 		err = gdrom_readtoc_cmd(gd.toc, 0);
 		if (err) {
-			printk(KERN_INFO "GDROM: Could not get CD table of contents\n");
+			printk(KERN_INFO "GDROM: Could not get CD "
+			       "table of contents\n");
 			return -ENXIO;
 		}
 	}
@@ -305,7 +316,8 @@
 
 	if ((track > 100) || (track < get_entry_track(gd.toc->first))) {
 		gdrom_getsense(NULL);
-		printk(KERN_INFO "GDROM: No data on the last session of the CD\n");
+		printk(KERN_INFO "GDROM: No data on the last session "
+		       "of the CD\n");
 		return -ENXIO;
 	}
 
@@ -355,8 +367,10 @@
 	return 0;
 }
 
-/* keep the function looking like the universal CD Rom specification - returning int*/
-static int gdrom_packetcommand(struct cdrom_device_info *cd_info, struct packet_command *command)
+/* keep the function looking like the universal CD Rom specification -
+ * returning int */
+static int gdrom_packetcommand(struct cdrom_device_info *cd_info,
+			       struct packet_command *command)
 {
 	gdrom_spicommand(&command->cmd, command->buflen);
 	return 0;
@@ -388,7 +402,8 @@
 	gd.pending = 1;
 	gdrom_packetcommand(gd.cd_info, sense_command);
 	/* 60 second timeout */
-	wait_event_interruptible_timeout(command_queue, gd.pending == 0, HZ * 60);
+	wait_event_interruptible_timeout(command_queue,
+					 gd.pending == 0, HZ * 60);
 	gd.pending = 0;
 	kfree(sense_command);
 	insw(PHYSADDR(GDROM_DATA_REG), &sense, 5);
@@ -400,7 +415,8 @@
 	printk(KERN_INFO "%s\n", sense_texts[sense_key].text);
 
 	if (bufstring)
-		memcpy(bufstring, &sense[4], 2); /* return additional sense data */
+		memcpy(bufstring, &sense[4], 2);
+					/* return additional sense data */
 
 	if (sense_key < 2)
 		return 0;
@@ -434,7 +450,8 @@
 	return cdrom_media_changed(gd.cd_info);
 }
 
-static int gdrom_bdops_ioctl(struct inode *inode, struct file *file, unsigned cmd, unsigned long arg)
+static int gdrom_bdops_ioctl(struct inode *inode, struct file *file,
+			     unsigned cmd, unsigned long arg)
 {
 	return cdrom_ioctl(file, gd.cd_info, inode, cmd, arg);
 }
@@ -471,11 +488,13 @@
 {
 	int err;
 	init_waitqueue_head(&command_queue);
-	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt, IRQF_DISABLED, "gdrom_command", &gd);
+	err = request_irq(HW_EVENT_GDROM_CMD, gdrom_command_interrupt,
+			  IRQF_DISABLED, "gdrom_command", &gd);
 	if (err)
 		return err;
 	init_waitqueue_head(&request_queue);
-	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt, IRQF_DISABLED, "gdrom_dma", &gd);
+	err = request_irq(HW_EVENT_GDROM_DMA, gdrom_dma_interrupt,
+			  IRQF_DISABLED, "gdrom_dma", &gd);
 	if (err)
 		free_irq(HW_EVENT_GDROM_CMD, &gd);
 	return err;
@@ -531,27 +550,30 @@
 		ctrl_outb(0, GDROM_INTSEC_REG);
 		/* In multiple DMA transfers need to wait */
 		timeout = jiffies + HZ / 2;
-		while ((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x80) && (time_before(jiffies, timeout)))
+		while (gdrom_is_busy() && (time_before(jiffies, timeout)))
 			cpu_relax();
 		ctrl_outb(GDROM_COM_PACKET, GDROM_STATUSCOMMAND_REG);
 		timeout = jiffies + HZ / 2;
-		while (((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8) && (time_before(jiffies, timeout)))
+		while (((ctrl_inb(GDROM_ALTSTATUS_REG) & 0x88) != 8) &&
+		       (time_before(jiffies, timeout)))
 			cpu_relax(); /* wait for DRQ to be set to 1 */
 		gd.pending = 1;
 		gd.transfer = 1;
 		outsw(PHYSADDR(GDROM_DATA_REG), &read_command->cmd, 6);
 		timeout = jiffies + HZ / 2;
-		while ((ctrl_inb(GDROM_DMA_STATUS_REG)) && (time_before(jiffies, timeout)))
+		while ((ctrl_inb(GDROM_DMA_STATUS_REG)) &&
+		       (time_before(jiffies, timeout)))
 			cpu_relax();
 		ctrl_outb(1, GDROM_DMA_STATUS_REG);
 		/* 5 second error margin here seems more reasonable */
-		wait_event_interruptible_timeout(request_queue, gd.transfer == 0, HZ * 5);
+		wait_event_interruptible_timeout(request_queue,
+						 gd.transfer == 0, HZ * 5);
 		err = ctrl_inb(GDROM_DMA_STATUS_REG);
 		err = gd.transfer;
 		gd.transfer = 0;
 		gd.pending = 0;
 		/* now seek to take the request spinlock
- 		 * before handling ending the request */
+		 * before handling ending the request */
 		spin_lock(&gdrom_lock);
 		list_del_init(&req->queuelist);
 		blk_requeue_request(gd.gdrom_rq, req);
@@ -567,7 +589,7 @@
 static void gdrom_request_handler_dma(struct request *req)
 {
 	/* dequeue, add to list of deferred work
- 	 * and then schedule workqueue */
+	 * and then schedule workqueue */
 	blkdev_dequeue_request(req);
 	list_add_tail(&req->queuelist, &gdrom_deferred);
 	schedule_work(&work);
@@ -582,7 +604,8 @@
 			end_request(req, 0);
 		}
 		if (rq_data_dir(req) != READ) {
-			printk(KERN_NOTICE "GDROM: Read only device - write request ignored\n");
+			printk(KERN_NOTICE "GDROM: Read only device - "
+			       "write request ignored\n");
 			end_request(req, 0);
 		}
 		if (req->nr_sectors)
@@ -612,7 +635,8 @@
 	firmw_ver = kstrndup(id->firmver, 16, GFP_KERNEL);
 	if (!firmw_ver)
 		goto free_manuf_name;
-	printk(KERN_INFO "GDROM: %s from %s with firmware %s\n", model_name, manuf_name, firmw_ver);
+	printk(KERN_INFO "GDROM: %s from %s with firmware %s\n",
+	       model_name, manuf_name, firmw_ver);
 	err = 0;
 	kfree(firmw_ver);
 free_manuf_name:
@@ -641,7 +665,8 @@
 	gd.cd_info->ops = &gdrom_ops;
 	gd.cd_info->capacity = 1;
 	strcpy(gd.cd_info->name, GDROM_DEV_NAME);
-	gd.cd_info->mask = CDC_CLOSE_TRAY|CDC_OPEN_TRAY|CDC_LOCK|CDC_SELECT_DISC;
+	gd.cd_info->mask = CDC_CLOSE_TRAY | CDC_OPEN_TRAY |
+			   CDC_LOCK | CDC_SELECT_DISC;
 }
 
 static void __devinit probe_gdrom_setupdisk(void)
@@ -671,7 +696,7 @@
 {
 	int err;
 	if (gdrom_execute_diagnostic() != 1) {
-		printk(KERN_WARNING "GDROM: ATA Probe for GDROM failed.\n");
+		printk(KERN_WARNING "GDROM: ATA Probe for GDROM failed\n");
 		return -ENODEV;
 	}
 	if (gdrom_outputversion())
@@ -679,7 +704,8 @@
 	gdrom_major = register_blkdev(0, GDROM_DEV_NAME);
 	if (gdrom_major <= 0)
 		return gdrom_major;
-	printk(KERN_INFO "GDROM: Block device is registered with major number %d\n", gdrom_major);
+	printk(KERN_INFO "GDROM: Block device is registered "
+	       "with major number %d\n", gdrom_major);
 	gd.cd_info = kzalloc(sizeof(struct cdrom_device_info), GFP_KERNEL);
 	if (!gd.cd_info) {
 		err = -ENOMEM;
@@ -724,7 +750,8 @@
 	unregister_blkdev(gdrom_major, GDROM_DEV_NAME);
 	gdrom_major = 0;
 probe_fail_no_mem:
-	printk(KERN_WARNING "GDROM: Could not probe for device - error is 0x%X\n", err);
+	printk(KERN_WARNING "GDROM: Could not probe for device - "
+	       "error is 0x%X\n", err);
 	return err;
 }
 



