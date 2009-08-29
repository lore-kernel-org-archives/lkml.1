Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbZH2XMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbZH2XMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 19:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZH2XLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 19:11:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58939 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZH2XLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 19:11:21 -0400
Message-Id: <20090829231122.067717674@bombadil.infradead.org>
User-Agent: quilt/0.47-1
Date: Sat, 29 Aug 2009 19:03:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: liml@rtr.ca, jens.axboe@oracle.com, matthew@wil.cx, dwmw2@infradead.org,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 5/7] libata: Add support for TRIM
References: <20090829230332.017137693@bombadil.infradead.org>
Content-Disposition: inline; filename=discard-add-libata-trim-support
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Wilcox <willy@linux.intel.com>

libata: Add support for TRIM

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---

Index: linux-2.6/drivers/ata/libata-scsi.c
===================================================================
--- linux-2.6.orig/drivers/ata/libata-scsi.c	2009-08-29 15:53:44.851841524 -0300
+++ linux-2.6/drivers/ata/libata-scsi.c	2009-08-29 19:25:16.319344322 -0300
@@ -1051,6 +1051,46 @@ static void ata_gen_ata_sense(struct ata
 	desc[11] = block;
 }
 
+static int ata_discard_fn(struct request_queue *q, struct request *req,
+							struct bio *bio)
+{
+	unsigned size;
+	struct page *page = alloc_page(GFP_KERNEL);
+	if (!page)
+		goto error;
+
+	size = ata_set_lba_range_entries(page_address(page), PAGE_SIZE / 8,
+					bio->bi_sector, bio_sectors(bio));
+	bio->bi_size = 0;
+	if (bio_add_pc_page(q, bio, page, size, 0) < size)
+		goto free_page;
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_len = 16;
+	req->cmd[0] = ATA_16;
+	req->cmd[1] = (6 << 1) | 1;		/* dma, 48-bit */
+	req->cmd[2] = 0x6;			/* length, direction */
+	req->cmd[3] = 0;			/* feature high */
+	req->cmd[4] = ATA_DSM_TRIM;		/* feature low */
+	req->cmd[5] = (size / 512) >> 8;	/* nsect high */
+	req->cmd[6] = size / 512;		/* nsect low */
+	req->cmd[7] = 0;			/* lba */
+	req->cmd[8] = 0;			/* lba */
+	req->cmd[9] = 0;			/* lba */
+	req->cmd[10] = 0;			/* lba */
+	req->cmd[11] = 0;			/* lba */
+	req->cmd[12] = 0;			/* lba */
+	req->cmd[13] = ATA_LBA;			/* device */
+	req->cmd[14] = ATA_CMD_DSM;		/* command */
+	req->cmd[15] = 0;			/* control */
+
+	return 0;
+ free_page:
+	__free_page(page);
+ error:
+	return -ENOMEM;
+}
+
 static void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
@@ -1099,6 +1139,9 @@ static int ata_scsi_dev_config(struct sc
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
+	if (ata_id_has_trim(dev->id))
+		blk_queue_set_discard(sdev->request_queue, ata_discard_fn);
+
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
@@ -2431,6 +2474,8 @@ static unsigned int ata_scsiop_read_cap(
 		rbuf[15] = lowest_aligned;
 	}
 
+	if (ata_id_has_trim(args->id))
+		rbuf[14] = 0x80;
 	return 0;
 }
 

