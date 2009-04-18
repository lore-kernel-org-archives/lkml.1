Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbZDRQSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbZDRQSl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 12:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756928AbZDRQSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 12:18:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64492 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbZDRQSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 12:18:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:user-agent:cc:mime-version:content-disposition:date
         :content-type:content-transfer-encoding:message-id;
        b=WtQBJgQfHqmqH5MSQwtl0zya6+9IxW5QXVeb/XLd8iduB/LrLyPzHMGCI4pjWkfBDi
         xnFbuUVP6BCXREuNhLakSL2WwlqYY2mtMD+ZFavCR6lCASOr8xjQqwjsGCiH/emvDLhn
         i2zCrajP28ssHUDcGzfiEgtJzO45xfrCf7Ybc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git pull] IDE fixes
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Date: Sat, 18 Apr 2009 18:09:38 +0200
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200904181809.40031.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Linus, please pull from 'for-linus' branch of:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus

to receive the following updates:

 drivers/ide/cs5536.c |    1 +
 drivers/ide/hpt366.c |   14 ++++++++------
 drivers/ide/ide-io.c |   11 +++++++----
 drivers/ide/pmac.c   |    2 +-
 4 files changed, 17 insertions(+), 11 deletions(-)


Bartlomiej Zolnierkiewicz (1):
      ide: fix barriers support

Jack Stone (1):
      ide: Remove void casts

Sergei Shtylyov (3):
      hpt366: fix HPT370 DMA timeouts
      hpt366: use ATA_DMA_* constants
      cs5536: define dma_sff_read_status() method


diff --git a/drivers/ide/cs5536.c b/drivers/ide/cs5536.c
index 353a35b..0332a95 100644
--- a/drivers/ide/cs5536.c
+++ b/drivers/ide/cs5536.c
@@ -236,6 +236,7 @@ static const struct ide_dma_ops cs5536_dma_ops = {
 	.dma_test_irq		= ide_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
 	.dma_timer_expiry	= ide_dma_sff_timer_expiry,
+	.dma_sff_read_status	= ide_dma_sff_read_status,
 };
 
 static const struct ide_port_info cs5536_info = {
diff --git a/drivers/ide/hpt366.c b/drivers/ide/hpt366.c
index a0eb87f..0feb66c 100644
--- a/drivers/ide/hpt366.c
+++ b/drivers/ide/hpt366.c
@@ -3,7 +3,7 @@
  * Portions Copyright (C) 2001	        Sun Microsystems, Inc.
  * Portions Copyright (C) 2003		Red Hat Inc
  * Portions Copyright (C) 2007		Bartlomiej Zolnierkiewicz
- * Portions Copyright (C) 2005-2008	MontaVista Software, Inc.
+ * Portions Copyright (C) 2005-2009	MontaVista Software, Inc.
  *
  * Thanks to HighPoint Technologies for their assistance, and hardware.
  * Special Thanks to Jon Burchmore in SanDiego for the deep pockets, his
@@ -114,6 +114,8 @@
  *   the register setting lists into the table indexed by the clock selected
  * - set the correct hwif->ultra_mask for each individual chip
  * - add Ultra and MW DMA mode filtering for the HPT37[24] based SATA cards
+ * - stop resetting HPT370's state machine before each DMA transfer as that has
+ *   caused more harm than good
  *	Sergei Shtylyov, <sshtylyov@ru.mvista.com> or <source@mvista.com>
  */
 
@@ -133,7 +135,7 @@
 #define DRV_NAME "hpt366"
 
 /* various tuning parameters */
-#define HPT_RESET_STATE_ENGINE
+#undef	HPT_RESET_STATE_ENGINE
 #undef	HPT_DELAY_INTERRUPT
 
 static const char *quirk_drives[] = {
@@ -808,7 +810,7 @@ static void hpt370_irq_timeout(ide_drive_t *drive)
 	/* get DMA command mode */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	/* stop DMA */
-	outb(dma_cmd & ~0x1, hwif->dma_base + ATA_DMA_CMD);
+	outb(dma_cmd & ~ATA_DMA_START, hwif->dma_base + ATA_DMA_CMD);
 	hpt370_clear_engine(drive);
 }
 
@@ -825,11 +827,11 @@ static int hpt370_dma_end(ide_drive_t *drive)
 	ide_hwif_t *hwif	= drive->hwif;
 	u8  dma_stat		= inb(hwif->dma_base + ATA_DMA_STATUS);
 
-	if (dma_stat & 0x01) {
+	if (dma_stat & ATA_DMA_ACTIVE) {
 		/* wait a little */
 		udelay(20);
 		dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
-		if (dma_stat & 0x01)
+		if (dma_stat & ATA_DMA_ACTIVE)
 			hpt370_irq_timeout(drive);
 	}
 	return ide_dma_end(drive);
@@ -851,7 +853,7 @@ static int hpt374_dma_test_irq(ide_drive_t *drive)
 
 	dma_stat = inb(hwif->dma_base + ATA_DMA_STATUS);
 	/* return 1 if INTR asserted */
-	if (dma_stat & 4)
+	if (dma_stat & ATA_DMA_INTR)
 		return 1;
 
 	return 0;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 2ae02b8..35dc38d 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -102,11 +102,14 @@ void ide_complete_cmd(ide_drive_t *drive, struct ide_cmd *cmd, u8 stat, u8 err)
 			drive->dev_flags |= IDE_DFLAG_PARKED;
 	}
 
-	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
-		memcpy(rq->special, cmd, sizeof(*cmd));
+	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+		struct ide_cmd *orig_cmd = rq->special;
 
-	if (cmd->tf_flags & IDE_TFLAG_DYN)
-		kfree(cmd);
+		if (cmd->tf_flags & IDE_TFLAG_DYN)
+			kfree(orig_cmd);
+		else
+			memcpy(orig_cmd, cmd, sizeof(*cmd));
+	}
 }
 
 /* obsolete, blk_rq_bytes() should be used instead */
diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
index 052b9bf..f76e4e6 100644
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1682,7 +1682,7 @@ static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
 	 * The +2 is +1 for the stop command and +1 to allow for
 	 * aligning the start address to a multiple of 16 bytes.
 	 */
-	pmif->dma_table_cpu = (struct dbdma_cmd*)pci_alloc_consistent(
+	pmif->dma_table_cpu = pci_alloc_consistent(
 		dev,
 		(MAX_DCMDS + 2) * sizeof(struct dbdma_cmd),
 		&hwif->dmatable_dma);
