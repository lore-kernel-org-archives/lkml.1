Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567Ab0ARR30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567Ab0ARR30 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997Ab0ARRTR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:19:17 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:39792 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab0ARRTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Hy5mkNFcmlyh9LZOGgQqKF03M5RfTVRdB0fQJLeVgv8OMNw5rY6P16YSfoK3snklYR
         ugbXww6kdxyBfthGQpdD8k6ypNCSP/+dA37j+9KYrbVphqRm/CVvrxamn3NRBE/6E2yy
         rceFF/H+qKRObHAE1DNhgqFza32QhGyIJK0pA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:17:50 +0100
Message-Id: <20100118171750.14623.44548.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 27/64] alim15x3: add ali_fifo_control() helper
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] alim15x3: add ali_fifo_control() helper

Based on libata pata_ali host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/alim15x3.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

Index: b/drivers/ide/alim15x3.c
===================================================================
--- a/drivers/ide/alim15x3.c
+++ b/drivers/ide/alim15x3.c
@@ -48,6 +48,19 @@ static u8 m5229_revision;
 static u8 chip_is_1543c_e;
 static struct pci_dev *isa_dev;
 
+static void ali_fifo_control(ide_hwif_t *hwif, ide_drive_t *drive, int on)
+{
+	struct pci_dev *pdev = to_pci_dev(hwif->dev);
+	int pio_fifo = 0x54 + hwif->channel;
+	u8 fifo;
+	int shift = 4 * (drive->dn & 1);
+
+	pci_read_config_byte(pdev, pio_fifo, &fifo);
+	fifo &= ~(0x0F << shift);
+	fifo |= (on << shift);
+	pci_write_config_byte(pdev, pio_fifo, fifo);
+}
+
 /**
  *	ali_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
@@ -64,8 +77,7 @@ static void ali_set_pio_mode(ide_drive_t
 	int bus_speed = ide_pci_clk ? ide_pci_clk : 33;
 	unsigned long T =  1000000 / bus_speed; /* PCI clock based */
 	int port = hwif->channel ? 0x5c : 0x58;
-	int portFIFO = hwif->channel ? 0x55 : 0x54;
-	u8 cd_dma_fifo = 0, unit = drive->dn & 1;
+	u8 unit = drive->dn & 1;
 	struct ide_timing t;
 
 	ide_timing_compute(drive, XFER_PIO_0 + pio, &t, T, 1);
@@ -79,20 +91,7 @@ static void ali_set_pio_mode(ide_drive_t
 	/* 
 	 * PIO mode => ATA FIFO on, ATAPI FIFO off
 	 */
-	pci_read_config_byte(dev, portFIFO, &cd_dma_fifo);
-	if (drive->media==ide_disk) {
-		if (unit) {
-			pci_write_config_byte(dev, portFIFO, (cd_dma_fifo & 0x0F) | 0x50);
-		} else {
-			pci_write_config_byte(dev, portFIFO, (cd_dma_fifo & 0xF0) | 0x05);
-		}
-	} else {
-		if (unit) {
-			pci_write_config_byte(dev, portFIFO, cd_dma_fifo & 0x0F);
-		} else {
-			pci_write_config_byte(dev, portFIFO, cd_dma_fifo & 0xF0);
-		}
-	}
+	ali_fifo_control(hwif, drive, (drive->media == ide_disk) ? 0x05 : 0x00);
 
 	pci_write_config_byte(dev, port, t.setup);
 	pci_write_config_byte(dev, port + unit + 2,
