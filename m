Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119Ab0BURni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 12:43:38 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:33896 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab0BURng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 12:43:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=Z//JscX+Nm1mPP2yiyM2LnpRolk3P6f9o+UudXnf4Us3CN0G2MHIkd2DIAfugE/Yu2
         GLn/gaJ7k3EN5cF6qF+ewXvdmCGPyaUOAy50huC7APlLgdu7W0SISkQdMxBIC5+PYdqP
         gXaJH3p7/EgMfF+cohTm6eY8s69Zb+6PViW+I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [git patch] atang tree: enhanced SSD detection
Date: Sun, 21 Feb 2010 18:41:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002211841.24936.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DISCLAIMER: the fact of getting patches merged into atang tree means
that from now on they will be getting updates for changes happening
in atang tree and it should not be treated as an indication regarding
decisions taken by 'upstream' kernel trees


Improve SSD detection so block layer optimizations can be applied
to many more SSD devices.


The following changes since commit 17c619273d412ed7b6120e448f87b2329457fc90:
  Bartlomiej Zolnierkiewicz (1):
        pata_oldpiix: enable parallel scan

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.7

Bartlomiej Zolnierkiewicz (1):
      libata: enhanced SSD detection

 drivers/ata/libata-core.c |    3 +++
 drivers/ata/libata-scsi.c |   18 ++++++++++--------
 include/linux/libata.h    |    1 +
 3 files changed, 14 insertions(+), 8 deletions(-)


commit ded92e0d01fbb7f27bec7a35606847a2547e95e0
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sun Feb 21 18:31:18 2010 +0100

    libata: enhanced SSD detection
    
    Many SSD devices predate or just don't implement non-rotational
    media type advertisement through the word 217 of the id block so
    check also the product id for 'SSD' substring to automatically
    detect SSD devices and apply relevant block layer optimizations.
    
    This is based on earlier Jeff Garzik's patch from April 2009:
    http://lkml.org/lkml/2009/4/7/495
    
    While at it:
    - cleanup ata_scsi_dev_config() a bit
    
    Tested with ASUS-PHISON SSD devices found in Asus Eee 901.
    
    Cc: Jeff Garzik <jeff@garzik.org>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 984d7bc..743ac77 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2485,6 +2485,9 @@ int ata_dev_configure(struct ata_device *dev)
 					dev->multi_count = cnt;
 		}
 
+		if (strstr(modelbuf, "SSD"))
+			dev->flags |= ATA_DFLAG_NONROT;
+
 		if (ata_id_has_lba(id)) {
 			const char *lba_desc;
 			char ncq_desc[24];
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 62e6b9e..df4a963 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1093,21 +1093,20 @@ static int atapi_drain_needed(struct request *rq)
 static int ata_scsi_dev_config(struct scsi_device *sdev,
 			       struct ata_device *dev)
 {
+	struct request_queue *q = sdev->request_queue;
+
 	if (!ata_id_has_unload(dev->id))
 		dev->flags |= ATA_DFLAG_NO_UNLOAD;
 
 	/* configure max sectors */
-	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
+	blk_queue_max_sectors(q, dev->max_sectors);
 
 	if (dev->class == ATA_DEV_ATAPI) {
-		struct request_queue *q = sdev->request_queue;
 		void *buf;
 
 		/* set the min alignment and padding */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_DMA_PAD_SZ - 1);
-		blk_queue_update_dma_pad(sdev->request_queue,
-					 ATA_DMA_PAD_SZ - 1);
+		blk_queue_update_dma_alignment(q, ATA_DMA_PAD_SZ - 1);
+		blk_queue_update_dma_pad(q, ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
 		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
@@ -1120,9 +1119,12 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
 		/* ATA devices must be sector aligned */
-		blk_queue_update_dma_alignment(sdev->request_queue,
-					       ATA_SECT_SIZE - 1);
+		blk_queue_update_dma_alignment(q, ATA_SECT_SIZE - 1);
+
 		sdev->manage_start_stop = 1;
+
+		if (dev->flags & ATA_DFLAG_NONROT)
+			queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
 	}
 
 	if (dev->flags & ATA_DFLAG_AN)
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d06e293..1e3b106 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -146,6 +146,7 @@ enum {
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
 	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
+	ATA_DFLAG_NONROT        = (1 << 18), /* is non-rotational media, SSD */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),
