Return-Path: <linux-kernel-owner+w=401wt.eu-S1755170AbYFUTYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755170AbYFUTYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 15:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754055AbYFUTWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 15:22:37 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:56041 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbYFUTWe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 15:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=NSkcUjI/2iY5LvfdF7TxoRvJ8GsUFq+CDOlxwdNy7qHAEdJ7PDvt7vkIKQl7ySmvNm
         QcNJ7c4yT/LKu6fkDM9RfuFzd+nzWUVXmITiNmnbxINjUDBekrS7qgBW1lsE57DnC7gS
         23NKHgoGxh6+XRX1zUr+MyP8AfNhT2r7Lov48=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 4/4] ide: filter out "default" transfer mode values in set_xfer_rate()
Date: Sat, 21 Jun 2008 21:21:22 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806212121.22191.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Filter out "default" transfer mode values (0x00 - default PIO mode,
  0x01 - default PIO mode w/ IORDY disabled) in write handler for obsoleted
  /proc/ide/hd?/settings:current_speed setting.

  Allowing "default" transfer mode values is a dangerous thing to do as
  we don't support programming controller to the "default" transfer mode
  and devices often use different values for the default and maximum PIO
  mode (i.e. PIO2 default and PIO4 maximum) so the controller will stay
  programmed for higher PIO mode while device will use the lower PIO mode.

  There is no functionality loss as by using special IOCTLs device can
  still be programmed to "default" transfer modes (it is only useful for
  debugging/testing purposes anyway).

* Remove no longer needed IDE_HFLAG_ABUSE_SET_DMA_MODE host flag, it was
  previously used by few host drivers to program the controller to PIO0
  timings for "default" transfer mode == 0x01 (although some host drivers
  would program invalid PIO timings instead).

* Cleanup ide_set_xfer_rate() and add BUG_ON().

Suggested-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Sergei, IIRC that it is what you were suggesting some time ago.

 drivers/ide/ide-lib.c          |   15 ++-------------
 drivers/ide/ide-proc.c         |    4 ++--
 drivers/ide/pci/aec62xx.c      |    5 -----
 drivers/ide/pci/amd74xx.c      |    1 -
 drivers/ide/pci/cs5520.c       |    3 +--
 drivers/ide/pci/cs5535.c       |    3 +--
 drivers/ide/pci/hpt34x.c       |    1 -
 drivers/ide/pci/hpt366.c       |    1 -
 drivers/ide/pci/pdc202xx_old.c |    1 -
 drivers/ide/pci/serverworks.c  |    4 +---
 drivers/ide/pci/tc86c001.c     |    3 +--
 drivers/ide/pci/via82cxxx.c    |    1 -
 include/linux/ide.h            |    1 -
 13 files changed, 8 insertions(+), 35 deletions(-)

Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -266,22 +266,11 @@ int ide_set_xfer_rate(ide_drive_t *drive
 
 	rate = ide_rate_filter(drive, rate);
 
+	BUG_ON(rate < XFER_PIO_0);
+
 	if (rate >= XFER_PIO_0 && rate <= XFER_PIO_5)
 		return ide_set_pio_mode(drive, rate);
 
-	/*
-	 * TODO: transfer modes 0x00-0x07 passed from the user-space are
-	 * currently handled here which needs fixing (please note that such
-	 * case could happen iff the transfer mode has already been set on
-	 * the device by ide-proc.c::set_xfer_rate()).
-	 */
-	if (rate < XFER_PIO_0) {
-		if (hwif->host_flags & IDE_HFLAG_ABUSE_SET_DMA_MODE)
-			return ide_set_dma_mode(drive, rate);
-		else
-			return ide_config_drive_speed(drive, rate);
-	}
-
 	return ide_set_dma_mode(drive, rate);
 }
 
Index: b/drivers/ide/ide-proc.c
===================================================================
--- a/drivers/ide/ide-proc.c
+++ b/drivers/ide/ide-proc.c
@@ -345,7 +345,7 @@ static int set_xfer_rate (ide_drive_t *d
 	ide_task_t task;
 	int err;
 
-	if (arg < 0 || (arg > 1 && arg < XFER_PIO_0) || arg > XFER_UDMA_6)
+	if (arg < XFER_PIO_0 || arg > XFER_UDMA_6)
 		return -EINVAL;
 
 	memset(&task, 0, sizeof(task));
@@ -357,7 +357,7 @@ static int set_xfer_rate (ide_drive_t *d
 
 	err = ide_no_data_taskfile(drive, &task);
 
-	if (!err && arg) {
+	if (!err) {
 		ide_set_xfer_rate(drive, (u8) arg);
 		ide_driveid_update(drive);
 	}
Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -195,7 +195,6 @@ static const struct ide_port_info aec62x
 		.host_flags	= IDE_HFLAG_SERIALIZE |
 				  IDE_HFLAG_NO_ATAPI_DMA |
 				  IDE_HFLAG_NO_DSC |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -205,7 +204,6 @@ static const struct ide_port_info aec62x
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA | IDE_HFLAG_NO_AUTODMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -216,7 +214,6 @@ static const struct ide_port_info aec62x
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_NON_BOOTABLE,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -226,7 +223,6 @@ static const struct ide_port_info aec62x
 		.init_chipset	= init_chipset_aec62xx,
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
@@ -237,7 +233,6 @@ static const struct ide_port_info aec62x
 		.enablebits	= {{0x4a,0x02,0x02}, {0x4a,0x04,0x04}},
 		.port_ops	= &atp86x_port_ops,
 		.host_flags	= IDE_HFLAG_NO_ATAPI_DMA |
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 				  IDE_HFLAG_OFF_BOARD,
 		.pio_mask	= ATA_PIO4,
 		.mwdma_mask	= ATA_MWDMA2,
Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -218,7 +218,6 @@ static const struct ide_port_ops amd_por
 
 #define IDE_HFLAGS_AMD \
 	(IDE_HFLAG_PIO_NO_BLACKLIST | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_POST_SET_MODE | \
 	 IDE_HFLAG_IO_32BIT | \
 	 IDE_HFLAG_UNMASK_IRQS)
Index: b/drivers/ide/pci/cs5520.c
===================================================================
--- a/drivers/ide/pci/cs5520.c
+++ b/drivers/ide/pci/cs5520.c
@@ -97,8 +97,7 @@ static const struct ide_port_ops cs5520_
 		.name		= name_str,			\
 		.port_ops	= &cs5520_port_ops,		\
 		.host_flags	= IDE_HFLAG_ISA_PORTS |		\
-				  IDE_HFLAG_CS5520 |		\
-				  IDE_HFLAG_ABUSE_SET_DMA_MODE, \
+				  IDE_HFLAG_CS5520,		\
 		.pio_mask	= ATA_PIO4,			\
 	}
 
Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -171,8 +171,7 @@ static const struct ide_port_ops cs5535_
 static const struct ide_port_info cs5535_chipset __devinitdata = {
 	.name		= "CS5535",
 	.port_ops	= &cs5535_port_ops,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_POST_SET_MODE,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -123,7 +123,6 @@ static const struct ide_port_ops hpt34x_
 #define IDE_HFLAGS_HPT34X \
 	(IDE_HFLAG_NO_ATAPI_DMA | \
 	 IDE_HFLAG_NO_DSC | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_NO_AUTODMA)
 
 static const struct ide_port_info hpt34x_chipsets[] __devinitdata = {
Index: b/drivers/ide/pci/hpt366.c
===================================================================
--- a/drivers/ide/pci/hpt366.c
+++ b/drivers/ide/pci/hpt366.c
@@ -1409,7 +1409,6 @@ static int __devinit hpt36x_init(struct 
 
 #define IDE_HFLAGS_HPT3XX \
 	(IDE_HFLAG_NO_ATAPI_DMA | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_OFF_BOARD)
 
 static const struct ide_port_ops hpt3xx_port_ops = {
Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -312,7 +312,6 @@ static void __devinit pdc202ata4_fixup_i
 
 #define IDE_HFLAGS_PDC202XX \
 	(IDE_HFLAG_ERROR_STOPS_FIFO | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE | \
 	 IDE_HFLAG_OFF_BOARD)
 
 static const struct ide_port_ops pdc20246_port_ops = {
Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -349,9 +349,7 @@ static const struct ide_port_ops svwks_p
 	.cable_detect		= svwks_cable_detect,
 };
 
-#define IDE_HFLAGS_SVWKS \
-	(IDE_HFLAG_LEGACY_IRQS | \
-	 IDE_HFLAG_ABUSE_SET_DMA_MODE)
+#define IDE_HFLAGS_SVWKS IDE_HFLAG_LEGACY_IRQS
 
 static const struct ide_port_info serverworks_chipsets[] __devinitdata = {
 	{	/* 0 */
Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -206,8 +206,7 @@ static const struct ide_port_info tc86c0
 	.init_hwif	= init_hwif_tc86c001,
 	.port_ops	= &tc86c001_port_ops,
 	.dma_ops	= &tc86c001_dma_ops,
-	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE,
+	.host_flags	= IDE_HFLAG_SINGLE | IDE_HFLAG_OFF_BOARD,
 	.pio_mask	= ATA_PIO4,
 	.mwdma_mask	= ATA_MWDMA2,
 	.udma_mask	= ATA_UDMA4,
Index: b/drivers/ide/pci/via82cxxx.c
===================================================================
--- a/drivers/ide/pci/via82cxxx.c
+++ b/drivers/ide/pci/via82cxxx.c
@@ -425,7 +425,6 @@ static const struct ide_port_info via82c
 	.enablebits	= { { 0x40, 0x02, 0x02 }, { 0x40, 0x01, 0x01 } },
 	.port_ops	= &via_port_ops,
 	.host_flags	= IDE_HFLAG_PIO_NO_BLACKLIST |
-			  IDE_HFLAG_ABUSE_SET_DMA_MODE |
 			  IDE_HFLAG_POST_SET_MODE |
 			  IDE_HFLAG_IO_32BIT,
 	.pio_mask	= ATA_PIO5,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1071,7 +1071,6 @@ enum {
 	IDE_HFLAG_IO_32BIT		= (1 << 24),
 	/* unmask IRQs */
 	IDE_HFLAG_UNMASK_IRQS		= (1 << 25),
-	IDE_HFLAG_ABUSE_SET_DMA_MODE	= (1 << 26),
 	/* serialize ports if DMA is possible (for sl82c105) */
 	IDE_HFLAG_SERIALIZE_DMA		= (1 << 27),
 	/* force host out of "simplex" mode */
