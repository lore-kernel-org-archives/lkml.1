Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbZBYU33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbZBYU33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 15:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbZBYU3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 15:29:19 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:62942 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbZBYU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 15:29:18 -0500
X-Greylist: delayed 1987 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Feb 2009 15:29:16 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=gIR6FBYWJkAE82NeIMvFa/RRjqLEvib6Nzpt32tD6T3v/qv4OjkiH3cv39iOv+864F
         vhWr9EdIzNqFMtT+B0YOepzCwThZDxfdTUzrJs9lnANJjj39rVoHNc4Fz+kZ92HS2x1e
         MJv5WGSoFp/xWDB5VGvBxbHO0IrZHOH0mZjm8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for February 24 (ide-atapi/ide-cd build errors)
Date: Wed, 25 Feb 2009 21:29:04 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc6-next-20090225; KDE/4.2.0; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
References: <20090224212949.0dacb59f.sfr@canb.auug.org.au> <49A426C8.1000409@oracle.com>
In-Reply-To: <49A426C8.1000409@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902252129.06035.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009, Randy Dunlap wrote:
> drivers/ide/ide-atapi.c:336: error: implicit declaration of function 'ide_dma_unmap_sg'
> (config-r1136)
> 
> or
> 
> drivers/ide/ide-cd.c:643: error: implicit declaration of function 'ide_dma_unmap_sg'
> (config-r1139)

Fixed (in the guilty patch + few other patches needed to be refreshed).

This should be the last CONFIG_BLK_DEV_IDEDMA=n fallout
(thanks for patience and sorry for that).

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: destroy DMA mappings after ending DMA (v2)

Move ide_destroy_dmatable() call out from ->dma_end method to
{ide_pc,cdrom_newpc,ide_dma}_intr(), ide_dma_timeout_retry()
and sgiioc4_resetproc().

This causes minor/safe behavior changes w.r.t.:
* cmd64x.c::cmd64{8,x}_dma_end()
* cs5536.c::cs5536_dma_end()
* icside.c::icside_dma_end()
* it821x.c::it821x_dma_end()
* scc_pata.c::__scc_dma_end()
* sl82c105.c::sl82c105_dma_end()
* tx4939ide.c::tx4939ide_dma_end()

v2:
* Fix build for CONFIG_BLK_DEV_IDEDMA=n (reported by Randy Dunlap).

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/au1xxx-ide.c  |    2 --
 drivers/ide/cmd64x.c      |    2 --
 drivers/ide/icside.c      |    3 ---
 drivers/ide/ide-atapi.c   |    7 +++++--
 drivers/ide/ide-cd.c      |    1 +
 drivers/ide/ide-dma-sff.c |    2 --
 drivers/ide/ide-dma.c     |    3 +++
 drivers/ide/ns87415.c     |    2 --
 drivers/ide/pmac.c        |    2 --
 drivers/ide/sc1200.c      |    1 -
 drivers/ide/scc_pata.c    |    2 --
 drivers/ide/sgiioc4.c     |    2 +-
 drivers/ide/trm290.c      |    3 +--
 drivers/ide/tx4939ide.c   |    4 +---
 include/linux/ide.h       |    1 +
 15 files changed, 13 insertions(+), 24 deletions(-)

Index: b/drivers/ide/au1xxx-ide.c
===================================================================
--- a/drivers/ide/au1xxx-ide.c
+++ b/drivers/ide/au1xxx-ide.c
@@ -280,8 +280,6 @@ static int auide_build_dmatable(ide_driv
 
 static int auide_dma_end(ide_drive_t *drive)
 {
-	ide_destroy_dmatable(drive);
-
 	return 0;
 }
 
Index: b/drivers/ide/cmd64x.c
===================================================================
--- a/drivers/ide/cmd64x.c
+++ b/drivers/ide/cmd64x.c
@@ -327,8 +327,6 @@ static int cmd646_1_dma_end(ide_drive_t 
 	outb(dma_cmd & ~1, hwif->dma_base + ATA_DMA_CMD);
 	/* clear the INTR & ERROR bits */
 	outb(dma_stat | 6, hwif->dma_base + ATA_DMA_STATUS);
-	/* and free any DMA resources */
-	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
 	return (dma_stat & 7) != 4;
 }
Index: b/drivers/ide/icside.c
===================================================================
--- a/drivers/ide/icside.c
+++ b/drivers/ide/icside.c
@@ -291,9 +291,6 @@ static int icside_dma_end(ide_drive_t *d
 
 	disable_dma(ec->dma);
 
-	/* Teardown mappings after DMA has completed. */
-	ide_destroy_dmatable(drive);
-
 	return get_dma_residue(ec->dma) != 0;
 }
 
Index: b/drivers/ide/ide-atapi.c
===================================================================
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -328,8 +328,11 @@ static ide_startstop_t ide_pc_intr(ide_d
 	stat = tp_ops->read_status(hwif);
 
 	if (pc->flags & PC_FLAG_DMA_IN_PROGRESS) {
-		if (hwif->dma_ops->dma_end(drive) ||
-		    (drive->media == ide_tape && (stat & ATA_ERR))) {
+		int rc = hwif->dma_ops->dma_end(drive);
+
+		ide_destroy_dmatable(drive);
+
+		if (rc || (drive->media == ide_tape && (stat & ATA_ERR))) {
 			if (drive->media == ide_floppy)
 				printk(KERN_ERR "%s: DMA %s error\n",
 					drive->name, rq_data_dir(pc->rq)
Index: b/drivers/ide/ide-cd.c
===================================================================
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -639,6 +639,7 @@ static ide_startstop_t cdrom_newpc_intr(
 	if (dma) {
 		drive->dma = 0;
 		dma_error = hwif->dma_ops->dma_end(drive);
+		ide_destroy_dmatable(drive);
 		if (dma_error) {
 			printk(KERN_ERR PFX "%s: DMA %s error\n", drive->name,
 					write ? "write" : "read");
Index: b/drivers/ide/ide-dma-sff.c
===================================================================
--- a/drivers/ide/ide-dma-sff.c
+++ b/drivers/ide/ide-dma-sff.c
@@ -310,8 +310,6 @@ int ide_dma_end(ide_drive_t *drive)
 	/* clear INTR & ERROR bits */
 	ide_dma_sff_write_status(hwif, dma_stat | ATA_DMA_ERR | ATA_DMA_INTR);
 
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
 	wmb();
 
 	/* verify good DMA status */
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -92,6 +92,7 @@ ide_startstop_t ide_dma_intr(ide_drive_t
 	u8 stat = 0, dma_stat = 0;
 
 	dma_stat = hwif->dma_ops->dma_end(drive);
+	ide_destroy_dmatable(drive);
 	stat = hwif->tp_ops->read_status(hwif);
 
 	if (OK_STAT(stat, DRIVE_READY, drive->bad_wstat | ATA_DRQ)) {
@@ -479,6 +480,7 @@ ide_startstop_t ide_dma_timeout_retry(id
 	if (error < 0) {
 		printk(KERN_WARNING "%s: DMA timeout error\n", drive->name);
 		(void)dma_ops->dma_end(drive);
+		ide_destroy_dmatable(drive);
 		ret = ide_error(drive, "dma timeout error",
 				hwif->tp_ops->read_status(hwif));
 	} else {
@@ -490,6 +492,7 @@ ide_startstop_t ide_dma_timeout_retry(id
 			ide_dump_status(drive, "DMA timeout",
 					hwif->tp_ops->read_status(hwif));
 			(void)dma_ops->dma_end(drive);
+			ide_destroy_dmatable(drive);
 		}
 	}
 
Index: b/drivers/ide/ns87415.c
===================================================================
--- a/drivers/ide/ns87415.c
+++ b/drivers/ide/ns87415.c
@@ -210,8 +210,6 @@ static int ns87415_dma_end(ide_drive_t *
 	/* from ERRATA: clear the INTR & ERROR bits */
 	dma_cmd = inb(hwif->dma_base + ATA_DMA_CMD);
 	outb(dma_cmd | 6, hwif->dma_base + ATA_DMA_CMD);
-	/* and free any DMA resources */
-	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
 	return (dma_stat & 7) != 4;
 }
Index: b/drivers/ide/pmac.c
===================================================================
--- a/drivers/ide/pmac.c
+++ b/drivers/ide/pmac.c
@@ -1562,8 +1562,6 @@ pmac_ide_dma_end (ide_drive_t *drive)
 	dstat = readl(&dma->status);
 	writel(((RUN|WAKE|DEAD) << 16), &dma->control);
 
-	ide_destroy_dmatable(drive);
-
 	/* verify good dma status. we don't check for ACTIVE beeing 0. We should...
 	 * in theory, but with ATAPI decices doing buffer underruns, that would
 	 * cause us to disable DMA, which isn't what we want
Index: b/drivers/ide/sc1200.c
===================================================================
--- a/drivers/ide/sc1200.c
+++ b/drivers/ide/sc1200.c
@@ -184,7 +184,6 @@ static int sc1200_dma_end(ide_drive_t *d
 	outb(inb(dma_base)&~1, dma_base);	/* !! DO THIS HERE !! stop DMA */
 
 	drive->waiting_for_dma = 0;
-	ide_destroy_dmatable(drive);		/* purge DMA mappings */
 
 	return (dma_stat & 7) != 4;		/* verify good DMA status */
 }
Index: b/drivers/ide/scc_pata.c
===================================================================
--- a/drivers/ide/scc_pata.c
+++ b/drivers/ide/scc_pata.c
@@ -365,8 +365,6 @@ static int __scc_dma_end(ide_drive_t *dr
 	dma_stat = scc_dma_sff_read_status(hwif);
 	/* clear the INTR & ERROR bits */
 	scc_ide_outb(dma_stat | 6, hwif->dma_base + 4);
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
 	/* verify good DMA status */
 	wmb();
 	return (dma_stat & 7) != 4 ? (0x10 | dma_stat) : 0;
Index: b/drivers/ide/sgiioc4.c
===================================================================
--- a/drivers/ide/sgiioc4.c
+++ b/drivers/ide/sgiioc4.c
@@ -259,7 +259,6 @@ static int sgiioc4_dma_end(ide_drive_t *
 	}
 
 	drive->waiting_for_dma = 0;
-	ide_destroy_dmatable(drive);
 
 	return dma_stat;
 }
@@ -284,6 +283,7 @@ static void
 sgiioc4_resetproc(ide_drive_t * drive)
 {
 	sgiioc4_dma_end(drive);
+	ide_destroy_dmatable(drive);
 	sgiioc4_clearirq(drive);
 }
 
Index: b/drivers/ide/trm290.c
===================================================================
--- a/drivers/ide/trm290.c
+++ b/drivers/ide/trm290.c
@@ -216,8 +216,7 @@ static int trm290_dma_end(ide_drive_t *d
 	u16 status;
 
 	drive->waiting_for_dma = 0;
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
+
 	status = inw(drive->hwif->dma_base + 2);
 
 	return status != 0x00ff;
Index: b/drivers/ide/tx4939ide.c
===================================================================
--- a/drivers/ide/tx4939ide.c
+++ b/drivers/ide/tx4939ide.c
@@ -335,11 +335,9 @@ static int tx4939ide_dma_end(ide_drive_t
 	/* read and clear the INTR & ERROR bits */
 	dma_stat = tx4939ide_clear_dma_status(base);
 
-	/* purge DMA mappings */
-	ide_destroy_dmatable(drive);
-	/* verify good DMA status */
 	wmb();
 
+	/* verify good DMA status */
 	if ((dma_stat & (ATA_DMA_INTR | ATA_DMA_ERR | ATA_DMA_ACTIVE)) == 0 &&
 	    (ctl & (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST)) ==
 	    (TX4939IDE_INT_XFEREND | TX4939IDE_INT_HOST))
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1477,6 +1477,7 @@ static inline ide_startstop_t ide_dma_ti
 static inline void ide_release_dma_engine(ide_hwif_t *hwif) { ; }
 static inline int ide_build_sglist(ide_drive_t *drive,
 				   struct ide_cmd *cmd) { return 0; }
+static inline void ide_destroy_dmatable(ide_drive_t *drive) { ; }
 #endif /* CONFIG_BLK_DEV_IDEDMA */
 
 #ifdef CONFIG_BLK_DEV_IDEACPI
