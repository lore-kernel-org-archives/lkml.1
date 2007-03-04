Return-Path: <linux-kernel-owner+w=401wt.eu-S1751341AbXCDAwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbXCDAwJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 19:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbXCDAwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 19:52:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:60784 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXCDAwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 19:52:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=bPRHu1/AKghOaZE2PzEZGEqqc7VFQcghrjStYnONZBjOcZb1bEszgUOq3FixLaT6e1j+hWbCPi9NoHbRnmwimpgmOLiy5Df+1jP04qe0uVB7E9afIQPxV6/J5yfbjS8V4/4FKxnDAQ8rcNo1oc5RPejDySiwvTSaFgSGb8EsatA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>
Subject: [PATCH][libata] pata_pdc202xx_old: fix data corruption and other problems
Date: Sun, 4 Mar 2007 01:58:43 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703040158.43471.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


[PATCH] pata_pdc202xx_old: fix data corruption and other problems

Fix wrong "port" calculations in pdc202xx_configure_piomode()
and pdc202xx_set_dmamode(), it was horribly broken which resulted
in major havoc on all configurations except one (master device on
primary channel, no other devices) as code was writing PIO/DMA
timings and device settings to wrong registers (including
reserved ones),

ap->port_no / ap->devno / used regs / correct regs:

0 0 0x60-0x62 0x60-0x62
0 1 0x62-0x64 0x64-0x66
1 0 0x64-0x66 0x68-0x6a
1 1 0x66-0x68 0x6c-0x6e

Also forward port recent fixes from drivers/ide pdc202xx_old driver:

* fix XFER_MW_DMA0 timings (they were overclocked, use the official ones)

* fix bitmasks for clearing bits of register B:

  - when programming DMA mode bit 0x10 of register B was cleared which
    resulted in overclocked PIO timing setting (iff PIO0 was used)

  - when programming PIO mode bits 0x18 weren't cleared so suboptimal
    timings were used for PIO1-4 if PIO0 was previously set (bit 0x10)
    and for PIO0/3/4 if PIO1/2 was previously set (bit 0x08)

and finally bump driver version.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---

 drivers/ata/pata_pdc202xx_old.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

Index: b/drivers/ata/pata_pdc202xx_old.c
===================================================================
--- a/drivers/ata/pata_pdc202xx_old.c
+++ b/drivers/ata/pata_pdc202xx_old.c
@@ -2,13 +2,14 @@
  * pata_pdc202xx_old.c 	- Promise PDC202xx PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@redhat.com>
+ *			  (C) 2007 Bartlomiej Zolnierkiewicz
  *
  * Based in part on linux/drivers/ide/pci/pdc202xx_old.c
  *
  * First cut with LBA48/ATAPI
  *
  * TODO:
- *	Channel interlock/reset on both required ?
+ *	Channel interlock/reset on both required
  */
 
 #include <linux/kernel.h>
@@ -21,7 +22,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_pdc202xx_old"
-#define DRV_VERSION "0.3.0"
+#define DRV_VERSION "0.4.0"
 
 /**
  *	pdc2024x_pre_reset		-	probe begin
@@ -76,7 +77,7 @@ static void pdc2026x_error_handler(struc
 static void pdc202xx_configure_piomode(struct ata_port *ap, struct ata_device *adev, int pio)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 4 * ap->port_no + 2 * adev->devno;
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u16 pio_timing[5] = {
 		0x0913, 0x050C , 0x0308, 0x0206, 0x0104
 	};
@@ -85,7 +86,7 @@ static void pdc202xx_configure_piomode(s
 	pci_read_config_byte(pdev, port, &r_ap);
 	pci_read_config_byte(pdev, port + 1, &r_bp);
 	r_ap &= ~0x3F;	/* Preserve ERRDY_EN, SYNC_IN */
-	r_bp &= ~0x07;
+	r_bp &= ~0x1F;
 	r_ap |= (pio_timing[pio] >> 8);
 	r_bp |= (pio_timing[pio] & 0xFF);
 
@@ -123,7 +124,7 @@ static void pdc202xx_set_piomode(struct 
 static void pdc202xx_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	int port = 0x60 + 4 * ap->port_no + 2 * adev->devno;
+	int port = 0x60 + 8 * ap->port_no + 4 * adev->devno;
 	static u8 udma_timing[6][2] = {
 		{ 0x60, 0x03 },	/* 33 Mhz Clock */
 		{ 0x40, 0x02 },
@@ -132,12 +133,17 @@ static void pdc202xx_set_dmamode(struct 
 		{ 0x20, 0x01 },
 		{ 0x20, 0x01 }
 	};
+	static u8 mdma_timing[3][2] = {
+		{ 0x60, 0x03 },
+		{ 0x60, 0x04 },
+		{ 0xe0, 0x0f },
+	};
 	u8 r_bp, r_cp;
 
 	pci_read_config_byte(pdev, port + 1, &r_bp);
 	pci_read_config_byte(pdev, port + 2, &r_cp);
 
-	r_bp &= ~0xF0;
+	r_bp &= ~0xE0;
 	r_cp &= ~0x0F;
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
@@ -147,8 +153,8 @@ static void pdc202xx_set_dmamode(struct 
 
 	} else {
 		int speed = adev->dma_mode - XFER_MW_DMA_0;
-		r_bp |= 0x60;
-		r_cp |= (5 - speed);
+		r_bp |= mdma_timing[speed][0];
+		r_cp |= mdma_timing[speed][1];
 	}
 	pci_write_config_byte(pdev, port + 1, r_bp);
 	pci_write_config_byte(pdev, port + 2, r_cp);
