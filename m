Return-Path: <linux-kernel-owner+w=401wt.eu-S1758007AbYDLSwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbYDLSwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 14:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYDLSvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 14:51:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:18134 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYDLSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 14:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZZtWpBctWw/mr6JQ2Q0rk7OwfRIzh1xvPQw3vMkq4rvt8D259UudUUsptIezpVqiW8cixWhL5jXFj58prfhlEhmK71jO937tk/5ZDlju83Qhy+jESPKGykF7LR7CEa24mIkkoHI8RSiSsR6wAWv5/CyRxZNNkCgAyfO1oqZe0qs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/5] scc_pata: add ->dma_host_set and ->dma_start methods
Date: Sat, 12 Apr 2008 21:04:26 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804122104.26846.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ->dma_host_set and ->dma_start methods (+ __scc_dma_end() helper)
so scc_ide_{in,out}b() can be used directly.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/scc_pata.c |   54 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 50 insertions(+), 4 deletions(-)

Index: b/drivers/ide/pci/scc_pata.c
===================================================================
--- a/drivers/ide/pci/scc_pata.c
+++ b/drivers/ide/pci/scc_pata.c
@@ -260,6 +260,20 @@ static void scc_set_dma_mode(ide_drive_t
 	out_be32((void __iomem *)udenvt_port, reg);
 }
 
+static void scc_dma_host_set(ide_drive_t *drive, int on)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 unit = (drive->select.b.unit & 0x01);
+	u8 dma_stat = scc_ide_inb(hwif->dma_status);
+
+	if (on)
+		dma_stat |= (1 << (5 + unit));
+	else
+		dma_stat &= ~(1 << (5 + unit));
+
+	scc_ide_outb(dma_stat, hwif->dma_status);
+}
+
 /**
  *	scc_ide_dma_setup	-	begin a DMA phase
  *	@drive: target device
@@ -304,13 +318,45 @@ static int scc_dma_setup(ide_drive_t *dr
 	return 0;
 }
 
+static void scc_dma_start(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_cmd = scc_ide_inb(hwif->dma_command);
+
+	/* start DMA */
+	scc_ide_outb(dma_cmd | 1, hwif->dma_command);
+	hwif->dma = 1;
+	wmb();
+}
+
+static int __scc_dma_end(ide_drive_t *drive)
+{
+	ide_hwif_t *hwif = drive->hwif;
+	u8 dma_stat, dma_cmd;
+
+	drive->waiting_for_dma = 0;
+	/* get DMA command mode */
+	dma_cmd = scc_ide_inb(hwif->dma_command);
+	/* stop DMA */
+	scc_ide_outb(dma_cmd & ~1, hwif->dma_command);
+	/* get DMA status */
+	dma_stat = scc_ide_inb(hwif->dma_status);
+	/* clear the INTR & ERROR bits */
+	scc_ide_outb(dma_stat | 6, hwif->dma_status);
+	/* purge DMA mappings */
+	ide_destroy_dmatable(drive);
+	/* verify good DMA status */
+	hwif->dma = 0;
+	wmb();
+	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
+}
 
 /**
  *	scc_dma_end	-	Stop DMA
  *	@drive: IDE drive
  *
  *	Check and clear INT Status register.
- *      Then call __ide_dma_end().
+ *	Then call __scc_dma_end().
  */
 
 static int scc_dma_end(ide_drive_t *drive)
@@ -414,7 +460,7 @@ static int scc_dma_end(ide_drive_t *driv
 		break;
 	}
 
-	dma_stat = __ide_dma_end(drive);
+	dma_stat = __scc_dma_end(drive);
 	if (data_loss)
 		dma_stat |= 2; /* emulate DMA error (to retry command) */
 	return dma_stat;
@@ -777,10 +823,10 @@ static const struct ide_port_ops scc_por
 };
 
 static const struct ide_dma_ops scc_dma_ops = {
-	.dma_host_set		= ide_dma_host_set,
+	.dma_host_set		= scc_dma_host_set,
 	.dma_setup		= scc_dma_setup,
 	.dma_exec_cmd		= ide_dma_exec_cmd,
-	.dma_start		= ide_dma_start,
+	.dma_start		= scc_dma_start,
 	.dma_end		= scc_dma_end,
 	.dma_test_irq		= scc_dma_test_irq,
 	.dma_lost_irq		= ide_dma_lost_irq,
