Return-Path: <linux-kernel-owner+w=401wt.eu-S1756541AbYERSiG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541AbYERSiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:38:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755976AbYERShY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:24 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:17569 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbYERShV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=TD8gd3/3aoyJREwfxuiuI3LJxTANajC61FABupSOyqRXEuEXWjYXjGS4m5nHUA2s9hg5j25l25VWKj00Vd/2z5OqT510clYNzFZzNjFXii/TVpV1/OR63vSq2MPs/Ma6T4wjT+1ZElAcuWf10LsvnOU7IzEw1tX5+7ZKkY1PBxU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:54:45 +0200
Message-Id: <20080518185445.5636.51099.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/40] ide-scsi: fix DRQ checking for DMA transfers in idescsi_pc_intr()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If DRQ bit of Status Register is not cleared it is an error condition
and should be handled accordingly (disable DMA + reset the device).

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -388,7 +388,6 @@ static ide_startstop_t idescsi_pc_intr (
 		return ide_stopped;
 	}
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 #if IDESCSI_DEBUG_LOG
 		printk ("ide-scsi: %s: DMA complete\n", drive->name);
 #endif /* IDESCSI_DEBUG_LOG */
@@ -404,12 +403,20 @@ static ide_startstop_t idescsi_pc_intr (
 		if (test_bit(IDESCSI_LOG_CMD, &scsi->log))
 			printk(KERN_INFO "Packet command completed, %d bytes"
 					" transferred\n", pc->xferred);
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
 		local_irq_enable_in_hardirq();
 		if (stat & ERR_STAT)
 			rq->errors++;
 		idescsi_end_request (drive, 1, 0);
 		return ide_stopped;
 	}
+	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
+		pc->flags &= ~PC_FLAG_DMA_IN_PROGRESS;
+		printk(KERN_ERR "%s: The device wants to issue more interrupts "
+				"in DMA mode\n", drive->name);
+		ide_dma_off(drive);
+		return ide_do_reset(drive);
+	}
 	bcount = (hwif->INB(hwif->io_ports.lbah_addr) << 8) |
 		  hwif->INB(hwif->io_ports.lbam_addr);
 	ireason = hwif->INB(hwif->io_ports.nsect_addr);
