Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbYJRU0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbYJRU0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYJRU0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:26:25 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:52400 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYJRU0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:26:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=TU0yQMhnDy7SB2IdOfu4kigpUtYvgTCAhxdMbQoLiIhfx9GUesfkkW5k1feSP/3PrF
         We7JrvJjpUC57w8cdzc3cc1b97ZGrG5OjVucpoY6K7MaoPKQo0DhK1zvKX7PBOrsGwNo
         ULKT8D+CMsYkzpdmWZTEhiE0pYCvxv+osU97o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide-disk: set non-rotational queue flag for SSD and CF devices
Date: Sat, 18 Oct 2008 22:23:54 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810182223.54590.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-disk.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -600,6 +600,7 @@ static int ide_disk_check(ide_drive_t *d
 static void ide_disk_setup(ide_drive_t *drive)
 {
 	struct ide_disk_obj *idkp = drive->driver_data;
+	struct request_queue *q = drive->queue;
 	ide_hwif_t *hwif = drive->hwif;
 	u16 *id = drive->id;
 	char *m = (char *)&id[ATA_ID_PROD];
@@ -626,11 +627,14 @@ static void ide_disk_setup(ide_drive_t *
 		if (max_s > hwif->rqsize)
 			max_s = hwif->rqsize;
 
-		blk_queue_max_sectors(drive->queue, max_s);
+		blk_queue_max_sectors(q, max_s);
 	}
 
 	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
-			 drive->queue->max_sectors / 2);
+		q->max_sectors / 2);
+
+	if (ata_id_is_ssd(id) || ata_id_is_cfa(id))
+		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 
 	/* calculate drive capacity, and select LBA if possible */
 	ide_disk_get_capacity(drive);
