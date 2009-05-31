Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbZEaOew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbZEaOew (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 10:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbZEaOeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 10:34:18 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49478 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbZEaOeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 10:34:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=R1hYCvym6tza8Srj9Kt/6qYFMHXw9WMLlCwo+Atx7SaTQVYKnx1LVzjkxUsaRIj8DN
         u7Utln2x0op68YS6hCsjC6q7UBKaL+xPLXCiAN2/AjVV8R7vD1n/L7ZiNUM2kPMRBkmo
         hlFYwDQ8DYxsPhWTaMgq9ddhep+EewYckgoBQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Date: Sun, 31 May 2009 16:39:31 +0200
Message-Id: <20090531143931.7164.96956.sendpatchset@localhost.localdomain>
In-Reply-To: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain>
Subject: [PATCH 3/4] ide-gd: implement block device ->set_capacity method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide-gd: implement block device ->set_capacity method

* Use ->probed_capacity to store native device capacity for ATA disks.

* Add ->set_capacity method to struct ide_disk_ops.

* Implement disk device ->set_capacity method for ATA disks.

* Implement block device ->set_capacity method.

Together with the previous patch adding ->set_capacity block device
method this allows automatic disabling of Host Protected Area (HPA)
if any partitions overlapping HPA are detected.

Cc: Robert Hancock <hancockrwd@gmail.com>
Cc: Frans Pop <elendil@planet.nl>
Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |   19 ++++++++++++++++++-
 drivers/ide/ide-gd.c   |   14 ++++++++++++++
 include/linux/ide.h    |    4 ++--
 3 files changed, 34 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -323,6 +323,8 @@ static void idedisk_check_hpa(ide_drive_
 	if (set_max <= capacity)
 		return;
 
+	drive->probed_capacity = set_max;
+
 	printk(KERN_INFO "%s: Host Protected Area detected.\n"
 			 "\tcurrent capacity is %llu sectors (%llu MB)\n"
 			 "\tnative  capacity is %llu sectors (%llu MB)\n",
@@ -358,6 +360,8 @@ static int ide_disk_get_capacity(ide_dri
 		drive->capacity64 = drive->cyl * drive->head * drive->sect;
 	}
 
+	drive->probed_capacity = drive->capacity64;
+
 	if (lba) {
 		drive->dev_flags |= IDE_DFLAG_LBA;
 
@@ -376,7 +380,7 @@ static int ide_disk_get_capacity(ide_dri
 		       "%llu sectors (%llu MB)\n",
 		       drive->name, (unsigned long long)drive->capacity64,
 		       sectors_to_MB(drive->capacity64));
-		drive->capacity64 = 1ULL << 28;
+		drive->probed_capacity = drive->capacity64 = 1ULL << 28;
 	}
 
 	if ((drive->hwif->host_flags & IDE_HFLAG_NO_LBA48_DMA) &&
@@ -392,6 +396,18 @@ static int ide_disk_get_capacity(ide_dri
 	return 0;
 }
 
+static u64 ide_disk_set_capacity(ide_drive_t *drive, u64 capacity)
+{
+	u64 set = min(capacity, drive->probed_capacity);
+	int lba48 = ata_id_lba48_enabled(drive->id);
+
+	capacity = idedisk_set_max_address(drive, set, lba48);
+	if (capacity)
+		drive->capacity64 = capacity;
+
+	return drive->capacity64;
+}
+
 static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 {
 	ide_drive_t *drive = q->queuedata;
@@ -740,6 +756,7 @@ static int ide_disk_set_doorlock(ide_dri
 
 const struct ide_disk_ops ide_ata_disk_ops = {
 	.check		= ide_disk_check,
+	.set_capacity	= ide_disk_set_capacity,
 	.get_capacity	= ide_disk_get_capacity,
 	.setup		= ide_disk_setup,
 	.flush		= ide_disk_flush,
Index: b/drivers/ide/ide-gd.c
===================================================================
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -287,6 +287,19 @@ static int ide_gd_media_changed(struct g
 	return ret;
 }
 
+static unsigned long long ide_gd_set_capacity(struct gendisk *disk,
+					      unsigned long long capacity)
+{
+	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
+	ide_drive_t *drive = idkp->drive;
+	const struct ide_disk_ops *disk_ops = drive->disk_ops;
+
+	if (disk_ops->set_capacity)
+		return disk_ops->set_capacity(drive, capacity);
+
+	return drive->capacity64;
+}
+
 static int ide_gd_revalidate_disk(struct gendisk *disk)
 {
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
@@ -315,6 +328,7 @@ static struct block_device_operations id
 	.locked_ioctl		= ide_gd_ioctl,
 	.getgeo			= ide_gd_getgeo,
 	.media_changed		= ide_gd_media_changed,
+	.set_capacity		= ide_gd_set_capacity,
 	.revalidate_disk	= ide_gd_revalidate_disk
 };
 
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -381,6 +381,7 @@ struct ide_drive_s;
 struct ide_disk_ops {
 	int		(*check)(struct ide_drive_s *, const char *);
 	int		(*get_capacity)(struct ide_drive_s *);
+	u64		(*set_capacity)(struct ide_drive_s *, u64);
 	void		(*setup)(struct ide_drive_s *);
 	void		(*flush)(struct ide_drive_s *);
 	int		(*init_media)(struct ide_drive_s *, struct gendisk *);
@@ -552,8 +553,7 @@ struct ide_drive_s {
 	unsigned int	drive_data;	/* used by set_pio_mode/dev_select() */
 	unsigned int	failures;	/* current failure count */
 	unsigned int	max_failures;	/* maximum allowed failure count */
-	u64		probed_capacity;/* initial reported media capacity (ide-cd only currently) */
-
+	u64		probed_capacity;/* initial/native media capacity */
 	u64		capacity64;	/* total number of sectors */
 
 	int		lun;		/* logical unit */
