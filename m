Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbZDBPEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbZDBPEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 11:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762218AbZDBO6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 10:58:53 -0400
Received: from ottawa-hs-64-26-147-143.d-ip.magma.ca ([64.26.147.143]:41823
	"EHLO gonzo.int.wil.cx" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762195AbZDBO6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 10:58:51 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       jgarzik@redhat.com
Cc: David Woodhouse <David.Woodhouse@intel.com>,
       Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 4/5] ide: Add support for TRIM
Date: Thu,  2 Apr 2009 10:37:26 -0400
Message-Id: <1238683047-13588-4-git-send-email-willy@linux.intel.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238683047-13588-3-git-send-email-willy@linux.intel.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
 <1238683047-13588-2-git-send-email-willy@linux.intel.com>
 <1238683047-13588-3-git-send-email-willy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <David.Woodhouse@intel.com>

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
[modified to reduce amount of special casing needed for discard]
Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/ide/ide-disk.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index c998cf8..ed34bd3 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -404,6 +404,52 @@ static void idedisk_prepare_flush(struct request_queue *q, struct request *rq)
 	rq->special = cmd;
 }
 
+static int idedisk_prepare_discard(struct request_queue *q, struct request *rq,
+							struct bio *bio)
+{
+	ide_task_t *task;
+	unsigned size;
+	struct page *page = alloc_page(GFP_KERNEL);
+	if (!page)
+		goto error;
+
+	/* FIXME: map struct ide_taskfile on rq->cmd[] */
+	task = kzalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		goto free_page;
+
+	size = ata_set_lba_range_entries(page_address(page), PAGE_SIZE,
+					bio->bi_sector, bio_sectors(bio));
+	bio->bi_size = 0;
+	if (bio_add_pc_page(q, bio, page, size, 0) < size)
+		goto free_task;
+
+	task->tf.command = ATA_CMD_DSM;
+	task->tf.feature = ATA_DSM_TRIM;
+	task->tf.hob_feature = 0x00;
+	task->tf.nsect = size / 512;
+	task->tf.hob_nsect = (size / 512) >> 8;
+
+	task->tf_flags   = IDE_TFLAG_LBA48 | IDE_TFLAG_OUT_HOB |
+			   IDE_TFLAG_OUT_TF | IDE_TFLAG_OUT_DEVICE |
+			   IDE_TFLAG_DYN;
+	task->data_phase = TASKFILE_OUT_DMA;
+
+	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
+	rq->special = task;
+	rq->nr_sectors = size / 512;
+
+	return 0;
+
+ free_task:
+	kfree(task);
+ free_page:
+	__free_page(page);
+ error:
+	return -ENOMEM;
+}
+
+
 ide_devset_get(multcount, mult_count);
 
 /*
@@ -521,6 +567,9 @@ static int set_wcache(ide_drive_t *drive, int arg)
 
 	update_ordered(drive);
 
+	if (ata_id_has_trim(drive->id))
+		blk_queue_set_discard(drive->queue, idedisk_prepare_discard);
+
 	return err;
 }
 
-- 
1.6.2.1

