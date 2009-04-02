Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbZDBOtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbZDBOtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 10:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760220AbZDBOsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:48:53 -0400
Received: from ottawa-hs-64-26-147-143.d-ip.magma.ca ([64.26.147.143]:38952
	"EHLO gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760045AbZDBOsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:48:51 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com
Cc: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 5/5] libata: Add support for TRIM
Date: Thu,  2 Apr 2009 10:37:27 -0400
Message-Id: <1238683047-13588-5-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238683047-13588-4-git-send-email-willy@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
 <1238683047-13588-2-git-send-email-willy@linux.intel.com>
 <1238683047-13588-3-git-send-email-willy@linux.intel.com>
 <1238683047-13588-4-git-send-email-willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/ata/libata-scsi.c |   46 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9747fa..d4c8b8b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1029,6 +1029,46 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
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
@@ -1077,6 +1117,9 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
+	if (ata_id_has_trim(dev->id))
+		blk_queue_set_discard(sdev->request_queue, ata_discard_fn);
+
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
@@ -2385,6 +2428,9 @@ static unsigned int ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *rbuf)
 		/* sector size */
 		rbuf[10] = ATA_SECT_SIZE >> 8;
 		rbuf[11] = ATA_SECT_SIZE & 0xff;
+
+		if (ata_id_has_trim(args->id))
+			rbuf[14] = 0x80;
 	}
 
 	return 0;
-- 
1.6.2.1

