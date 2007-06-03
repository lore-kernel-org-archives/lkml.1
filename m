Return-Path: <linux-kernel-owner+w=401wt.eu-S1751251AbXFCUOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbXFCUOn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXFCUOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:14:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:39031 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbXFCUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=r7KcGF9yED6lIcYwlHS/J3LXoGfcqTl7mxNJPOEw3nLKX5QE46xDfwhnShkh9siAY30ML1MSkXlsLSHyjSZJBaHzLhTeA+a0ADd0OCz52fRlixn6dwPsBF2qq9DvYzS4cvye1i3m4i3F0Gxf+GdKZYm9VnjbDJSG3WAGnopZLXY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/2] serverworks: always tune CSB6
Date: Sun, 3 Jun 2007 22:23:48 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706032223.49063.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[ yeah, this is a follow-up to yesterdays' patches thus #3/2 ]

Switch the driver to always program DMA/PIO timings and set device transfer
mode instead of trusting BIOS on CSB6 controllers (libata pata_serverworks.c
driver is also doing things this way and there were no problems reported so
far).  While doing conversion I noticed that the old code had many issues:

* the code was assuming that hwif->dma_status is always valid
  (which obviously isn't true if hwif->dma_base == NULL)

* value of "(ultra_timing >> (4*unit)) & ~(0xF0)" expression wasn't checked
  to fit into udma_modes[5]

* code validating DMA timings didn't validate corresponding PIO timings

* extra CSB5 PIO register wasn't validated et all

* hwif->ide_dma_off_quietly() is always called before ide_set_dma() (which in
  turn calls hwif->speedproc() method - svwks_tune_chipset() in this case)
  so the code depending on DMA capable bit of DMA status to be set was never
  executed (=> the code was never validating DMA timings despite actually
  enabling DMA if the PIO timings were OK!)

* on resume driver dependend entirely on BIOS to restore timings and set
  transfer mode on the device

While at it:

There is no need to read PIO/MWDMA timings now so don't do it.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/serverworks.c |   77 +-----------------------------------------
 1 file changed, 2 insertions(+), 75 deletions(-)

Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -1,5 +1,5 @@
 /*
- * linux/drivers/ide/pci/serverworks.c		Version 0.11	Jun 2 2007
+ * linux/drivers/ide/pci/serverworks.c		Version 0.20	Jun 3 2007
  *
  * Copyright (C) 1998-2000 Michel Aubry
  * Copyright (C) 1998-2000 Andrzej Krzysztofowicz
@@ -151,84 +151,11 @@ static int svwks_tune_chipset (ide_drive
 	if(dev->device == PCI_DEVICE_ID_SERVERWORKS_OSB4 &&
 		drive->media == ide_disk && speed >= XFER_UDMA_0)
 			BUG();
-			
-	pci_read_config_byte(dev, drive_pci[drive->dn], &pio_timing);
-	pci_read_config_byte(dev, drive_pci2[drive->dn], &dma_timing);
+
 	pci_read_config_byte(dev, (0x56|hwif->channel), &ultra_timing);
 	pci_read_config_word(dev, 0x4A, &csb5_pio);
 	pci_read_config_byte(dev, 0x54, &ultra_enable);
 
-	/* If we are in RAID mode (eg AMI MegaIDE) then we can't it
-	   turns out trust the firmware configuration */
-
-	if ((dev->class >> 8) != PCI_CLASS_STORAGE_IDE)
-		goto oem_setup_failed;
-
-	/* Per Specified Design by OEM, and ASIC Architect */
-	if ((dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE) ||
-	    (dev->device == PCI_DEVICE_ID_SERVERWORKS_CSB6IDE2)) {
-		if (!drive->init_speed) {
-			u8 dma_stat = inb(hwif->dma_status);
-
-			if (((ultra_enable << (7-drive->dn) & 0x80) == 0x80) &&
-			    ((dma_stat & (1<<(5+unit))) == (1<<(5+unit)))) {
-				drive->current_speed = drive->init_speed = XFER_UDMA_0 + udma_modes[(ultra_timing >> (4*unit)) & ~(0xF0)];
-				return 0;
-			} else if ((dma_timing) &&
-				   ((dma_stat&(1<<(5+unit)))==(1<<(5+unit)))) {
-				u8 dmaspeed;
-
-				switch (dma_timing & 0x77) {
-				case 0x20:
-					dmaspeed = XFER_MW_DMA_2;
-					break;
-				case 0x21:
-					dmaspeed = XFER_MW_DMA_1;
-					break;
-				case 0x77:
-					dmaspeed = XFER_MW_DMA_0;
-					break;
-				default:
-					goto dma_pio;
-				}
-
-				drive->current_speed = drive->init_speed = dmaspeed;
-				return 0;
-			}
-dma_pio:
-			if (pio_timing) {
-				u8 piospeed;
-
-				switch (pio_timing & 0x7f) {
-				case 0x20:
-					piospeed = XFER_PIO_4;
-					break;
-				case 0x22:
-					piospeed = XFER_PIO_3;
-					break;
-				case 0x34:
-					piospeed = XFER_PIO_2;
-					break;
-				case 0x47:
-					piospeed = XFER_PIO_1;
-					break;
-				case 0x5d:
-					piospeed = XFER_PIO_0;
-					break;
-				default:
-					goto oem_setup_failed;
-				}
-
-				drive->current_speed = drive->init_speed = piospeed;
-				return 0;
-			}
-		}
-	}
-
-oem_setup_failed:
-
-	pio_timing	= 0;
-	dma_timing	= 0;
 	ultra_timing	&= ~(0x0F << (4*unit));
 	ultra_enable	&= ~(0x01 << drive->dn);
 	csb5_pio	&= ~(0x0F << (4*drive->dn));
