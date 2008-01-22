Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYAVRMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYAVRMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 12:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752534AbYAVRMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 12:12:22 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49585 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYAVRMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:12:21 -0500
Date: Tue, 22 Jan 2008 17:11:12 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeff Garzik <jeff@garzik.org>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: [PATCH rc8-mm1] hotfix libata-scsi corruption
Message-ID: <Pine.LNX.4.64.0801221706320.5832@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-rc8-mm1 is corrupting.  smartd does some sg_ioctl into its stack,
and depending on how its stack randomization worked out, this is liable
to end up writing into the adjacent physical page too.  If you're lucky
you have highmem, and ioread16_rep oopses on the virtual address beyond
what ata_pio_sector's kmap_atomic set up; when you're unlucky, it'll go
ahead and corrupt the next page more obscurely.

Bisect led to scsi-misc-2.6.git's 465ff3185e0cb76d46137335a4d21d0d9d3ac8a2
[SCSI] relax scsi dma alignment, and the patch below is good for a hot-fix.
Though I doubt it'll be the final fix, since it appears to undo the whole
point of blk_queue_update_dma_alignment: perhaps libata is at fault to be
going through sectory code for unsectory I/O - I wouldn't know.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 drivers/ata/libata-scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.24-rc8-mm1/drivers/ata/libata-scsi.c	2008-01-17 16:49:47.000000000 +0000
+++ linux/drivers/ata/libata-scsi.c	2008-01-22 15:45:40.000000000 +0000
@@ -826,7 +826,7 @@ static void ata_scsi_sdev_config(struct 
 	sdev->max_device_blocked = 1;
 
 	/* set the min alignment */
-	blk_queue_update_dma_alignment(sdev->request_queue, ATA_DMA_PAD_SZ - 1);
+	blk_queue_update_dma_alignment(sdev->request_queue, ATA_SECT_SIZE - 1);
 }
 
 static void ata_scsi_dev_config(struct scsi_device *sdev,
