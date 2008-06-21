Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbYFUTXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbYFUTXi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752772AbYFUTWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:22:32 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:7903 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbYFUTW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:22:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=uaSeXtvI1WQd9oXYOmHFGlYnEO2eb7Lj6o9W1QgUJpqndj4N17nAauItDaIlMca2uc
         5ugvChl0jzOj8ZPlf71i1gCQhXw5HKoMihnRS7VyzZvBiL2e9KVSwGZO+9lpCNEvZMm8
         mi8m8cAdBbeEghghYPwrgh+MgeoGf+Qa7ljpI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/4] ide: remove dead Virtual DMA support
Date: Sat, 21 Jun 2008 21:18:33 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, TAKADA Yoshihito <takada@mbf.nifty.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806212118.33712.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets remove dead Virtual DMA support for now so it doesn't clutter
core IDE code (it can be bring back when there is a need for it):

* Remove IDE_HFLAG_VDMA host flag.

* Remove ide_drive_t.vdma flag.

* cs5520.c: remove stale FIXMEs, cs5520_dma_host_set() and cs5520_dma_ops
  (also there is no longer a need to set IDE_HFLAG_NO_ATAPI_DMA).

There should be no functional changes caused by this patch.

Cc: TAKADA Yoshihito <takada@mbf.nifty.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
this is against IDE tree + 4 ide-pmac patches + 20 IDE patches from yesterday

 drivers/ide/ide-disk.c   |    2 +-
 drivers/ide/ide-dma.c    |    5 ++---
 drivers/ide/ide-iops.c   |    3 +--
 drivers/ide/pci/cs5520.c |   30 ------------------------------
 include/linux/ide.h      |    3 ---
 5 files changed, 4 insertions(+), 39 deletions(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -158,7 +158,7 @@ static void ide_tf_set_cmd(ide_drive_t *
 	write = (task->tf_flags & IDE_TFLAG_WRITE) ? 1 : 0;
 
 	if (dma)
-		index = drive->vdma ? 4 : 8;
+		index = 8;
 	else
 		index = drive->mult_count ? 0 : 4;
 
Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -756,9 +756,8 @@ static int ide_tune_dma(ide_drive_t *dri
 static int ide_dma_check(ide_drive_t *drive)
 {
 	ide_hwif_t *hwif = drive->hwif;
-	int vdma = (hwif->host_flags & IDE_HFLAG_VDMA)? 1 : 0;
 
-	if (!vdma && ide_tune_dma(drive))
+	if (ide_tune_dma(drive))
 		return 0;
 
 	/* TODO: always do PIO fallback */
@@ -767,7 +766,7 @@ static int ide_dma_check(ide_drive_t *dr
 
 	ide_set_max_pio(drive);
 
-	return vdma ? 0 : -1;
+	return -1;
 }
 
 int ide_id_dma_bug(ide_drive_t *drive)
Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -866,8 +866,7 @@ int ide_config_drive_speed(ide_drive_t *
 
  skip:
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if ((speed >= XFER_SW_DMA_0 || (hwif->host_flags & IDE_HFLAG_VDMA)) &&
-	    drive->using_dma)
+	if (speed >= XFER_SW_DMA_0 && drive->using_dma)
 		hwif->dma_ops->dma_host_set(drive, 1);
 	else if (hwif->dma_ops)	/* check if host supports DMA */
 		ide_dma_off_quietly(drive);
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -62,8 +62,6 @@ static void cs5520_set_pio_mode(ide_driv
 	struct pci_dev *pdev = to_pci_dev(hwif->dev);
 	int controller = drive->dn > 1 ? 1 : 0;
 
-	/* FIXME: if DMA = 1 do we need to set the DMA bit here ? */
-
 	/* 8bit CAT/CRT - 8bit command timing for channel */
 	pci_write_config_byte(pdev, 0x62 + controller, 
 		(cs5520_pio_clocks[pio].recovery << 4) |
@@ -89,45 +87,17 @@ static void cs5520_set_dma_mode(ide_driv
 	cs5520_set_pio_mode(drive, 0);
 }
 
-/*
- *	We wrap the DMA activate to set the vdma flag. This is needed
- *	so that the IDE DMA layer issues PIO not DMA commands over the
- *	DMA channel
- *
- *	ATAPI is harder so disable it for now using IDE_HFLAG_NO_ATAPI_DMA
- */
-
-static void cs5520_dma_host_set(ide_drive_t *drive, int on)
-{
-	drive->vdma = on;
-	ide_dma_host_set(drive, on);
-}
-
 static const struct ide_port_ops cs5520_port_ops = {
 	.set_pio_mode		= cs5520_set_pio_mode,
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
-static const struct ide_dma_ops cs5520_dma_ops = {
-	.dma_host_set		= cs5520_dma_host_set,
-	.dma_setup		= ide_dma_setup,
-	.dma_exec_cmd		= ide_dma_exec_cmd,
-	.dma_start		= ide_dma_start,
-	.dma_end		= __ide_dma_end,
-	.dma_test_irq		= ide_dma_test_irq,
-	.dma_lost_irq		= ide_dma_lost_irq,
-	.dma_timeout		= ide_dma_timeout,
-};
-
-/* FIXME: VDMA is disabled because it caused system hangs */
 #define DECLARE_CS_DEV(name_str)				\
 	{							\
 		.name		= name_str,			\
 		.port_ops	= &cs5520_port_ops,		\
-		.dma_ops	= &cs5520_dma_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
 				  IDE_HFLAG_CS5520 |		\
-				  IDE_HFLAG_NO_ATAPI_DMA |	\
 				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
 		.pio_mask	= ATA_PIO4,			\
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -334,7 +334,6 @@ typedef struct ide_drive_s {
 	unsigned nodma		: 1;	/* disallow DMA */
 	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
-	unsigned vdma		: 1;	/* 1=doing PIO over DMA 0=doing normal DMA */
 	unsigned scsi		: 1;	/* 0=default, 1=ide-scsi emulation */
 	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
 	unsigned post_reset	: 1;
@@ -1083,8 +1082,6 @@ enum {
 	IDE_HFLAG_NO_IO_32BIT		= (1 << 30),
 	/* never unmask IRQs */
 	IDE_HFLAG_NO_UNMASK_IRQS	= (1 << 31),
-	/* host uses VDMA (disabled for now) */
-	IDE_HFLAG_VDMA			= 0,
 };
 
 #ifdef CONFIG_BLK_DEV_OFFBOARD
