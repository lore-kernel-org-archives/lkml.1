Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834Ab0APX7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0APX7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 18:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071Ab0APX7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 18:59:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:31424 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0APX6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 18:58:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=Vi7LZTnbl3FNUnO2Z8biDyKm8HI3phzciaAZbawVBn6QUGHte/3576oMdXjE+rT4Cf
         nlKIKf1FiMBY3xpZ7yb1s+LjiNMxyAoJVvH2F18pt3y9WRzGx1guBPwgMSOPBDYjtXvr
         74TpFMpZ2WEcHKHNv7oLz5DsSrOpq0xZL72b4=
Message-Id: <20100116235849.969478053@gmail.com>
References: <20100116235653.898098245@gmail.com>
User-Agent: quilt/0.46-1
Date: Sun, 17 Jan 2010 00:56:54 +0100
From: Bart Hartgers <bart.hartgers@gmail.com>
To: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, Bart Hartgers <bart.hartgers@gmail.com>
Subject: [patch 1/2] sata_via: Correctly setup PIO/DMA for pata slave on vt6421.
Content-Disposition: inline; filename=sata_via/vt6421-pata-slave.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before only the timings for master were set. Datasheet can be found
here: ftp://ftp.vtbridge.org/Docs/Storage/DS_VT6421A_100_CCPL.PDF
Surprisingly, a slave drive works without this patch. According to the
datasheet, the controller by default derives the DMA mode from the 
Set Features command issued to a drive. Not sure about the PIO
timings, though. The real problem is that the timings for the master
effectively are the ones tuned for the slave. If these support
different UDMA-settings, there is trouble, especially when the slave
supports a higher UDMA than the master. 

Anyhow, using the same mechanism for both master and slave seems like 
a good idea.

Signed-off-by: Bart Hartgers <bart.hartgers@gmail.com>
---
Index: linux-2.6.33-rc4/drivers/ata/sata_via.c
===================================================================
--- linux-2.6.33-rc4.orig/drivers/ata/sata_via.c	2010-01-16 22:28:13.000000000 +0100
+++ linux-2.6.33-rc4/drivers/ata/sata_via.c	2010-01-16 22:29:30.000000000 +0100
@@ -44,7 +44,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"sata_via"
-#define DRV_VERSION	"2.4"
+#define DRV_VERSION	"2.5"
 
 /*
  * vt8251 is different from other sata controllers of VIA.  It has two
@@ -392,14 +392,16 @@ static void vt6421_set_pio_mode(struct a
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const u8 pio_bits[] = { 0xA8, 0x65, 0x65, 0x31, 0x20 };
-	pci_write_config_byte(pdev, PATA_PIO_TIMING, pio_bits[adev->pio_mode - XFER_PIO_0]);
+	pci_write_config_byte(pdev, PATA_PIO_TIMING - adev->devno,
+			      pio_bits[adev->pio_mode - XFER_PIO_0]);
 }
 
 static void vt6421_set_dma_mode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const u8 udma_bits[] = { 0xEE, 0xE8, 0xE6, 0xE4, 0xE2, 0xE1, 0xE0, 0xE0 };
-	pci_write_config_byte(pdev, PATA_UDMA_TIMING, udma_bits[adev->dma_mode - XFER_UDMA_0]);
+	pci_write_config_byte(pdev, PATA_UDMA_TIMING - adev->devno,
+			      udma_bits[adev->dma_mode - XFER_UDMA_0]);
 }
 
 static const unsigned int svia_bar_sizes[] = {

-- 
