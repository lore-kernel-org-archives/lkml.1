Return-Path: <linux-kernel-owner+w=401wt.eu-S1761590AbXGaUFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761590AbXGaUFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 16:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbXGaUEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 16:04:54 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:6011 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbXGaUEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 16:04:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=cXvTG6yFai7DEqU0wb/feScX1ZvYPKrZD+FabZNlF6KHxn/j3nzl4E9Hs3amMmywKOY1rIUo/FwrSQcWtzeejvpiexVKDqiJGEuG+//VJMQasCI44gjNtgOr/OCD9gxnPqVfbNpvbFS7Ye5VQp/z5QDEKHaqqyKB4J+ZGxuwD6s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] pata_sis: fix MWDMA for <= UDMA66 chipsets and UDMA for UDMA33 chipsets
Date: Tue, 31 Jul 2007 22:02:41 +0200
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200707312202.41856.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Fix MWDMA timings setup in sis_old_set_dmamode() and sis_66_set_dmamode().

  The old timings were overclocked (even worse behavior than sis5513 IDE driver
  which depends on BIOS to program correct timings), the new timings are taken
  from the datasheet (they match timings from ATA spec).

* Fix UDMA timings setup in sis_old_set_dmamode().

  Misplaced pci_write_config_word() call resulted in UDMA timings never
  being set.

* Fix comments for sis_133_early_set_dmamode() and sis_133_set_dmamode():
  - only the former function handles early SiS 961 bridges
  - both functions lack MWDMA timings setup

* Fix typos in sis_100_set_piomode() and sis_133_set_piomode() comments.

* Bump driver version.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
Sergei: Yes, I'm working on sis5513 IDE driver. :)

 drivers/ata/pata_sis.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

Index: b/drivers/ata/pata_sis.c
===================================================================
--- a/drivers/ata/pata_sis.c
+++ b/drivers/ata/pata_sis.c
@@ -2,6 +2,7 @@
  *    pata_sis.c - SiS ATA driver
  *
  *	(C) 2005 Red Hat <alan@redhat.com>
+ *	(C) 2007 Bartlomiej Zolnierkiewicz
  *
  *    Based upon linux/drivers/ide/pci/sis5513.c
  * Copyright (C) 1999-2000	Andre Hedrick <andre@linux-ide.org>
@@ -35,7 +36,7 @@
 #include "sis.h"
 
 #define DRV_NAME	"pata_sis"
-#define DRV_VERSION	"0.5.1"
+#define DRV_VERSION	"0.5.2"
 
 struct sis_chipset {
 	u16 device;				/* PCI host ID */
@@ -237,7 +238,7 @@ static void sis_old_set_piomode (struct 
 }
 
 /**
- *	sis_100_set_pioode - Initialize host controller PATA PIO timings
+ *	sis_100_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring for.
  *
@@ -262,7 +263,7 @@ static void sis_100_set_piomode (struct 
 }
 
 /**
- *	sis_133_set_pioode - Initialize host controller PATA PIO timings
+ *	sis_133_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
  *	@adev: Device we are configuring for.
  *
@@ -334,7 +335,7 @@ static void sis_old_set_dmamode (struct 
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
-	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
+	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
 	const u16 udma_bits[]  = { 0xE000, 0xC000, 0xA000 };
 
 	pci_read_config_word(pdev, drive_pci, &timing);
@@ -342,15 +343,15 @@ static void sis_old_set_dmamode (struct 
 	if (adev->dma_mode < XFER_UDMA_0) {
 		/* bits 3-0 hold recovery timing bits 8-10 active timing and
 		   the higer bits are dependant on the device */
-		timing &= ~ 0x870F;
+		timing &= ~0x870F;
 		timing |= mwdma_bits[speed];
-		pci_write_config_word(pdev, drive_pci, timing);
 	} else {
 		/* Bit 15 is UDMA on/off, bit 13-14 are cycle time */
 		speed = adev->dma_mode - XFER_UDMA_0;
 		timing &= ~0x6000;
 		timing |= udma_bits[speed];
 	}
+	pci_write_config_word(pdev, drive_pci, timing);
 }
 
 /**
@@ -373,7 +374,7 @@ static void sis_66_set_dmamode (struct a
 	int drive_pci = sis_old_port_base(adev);
 	u16 timing;
 
-	const u16 mwdma_bits[] = { 0x707, 0x202, 0x202 };
+	const u16 mwdma_bits[] = { 0x008, 0x302, 0x301 };
 	const u16 udma_bits[]  = { 0xF000, 0xD000, 0xB000, 0xA000, 0x9000};
 
 	pci_read_config_word(pdev, drive_pci, &timing);
@@ -432,8 +433,7 @@ static void sis_100_set_dmamode (struct 
  *	@adev: Device to program
  *
  *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	Handles early SiS 961 bridges. Supports MWDMA as well unlike
- *	the old ide/pci driver.
+ *	Handles early SiS 961 bridges.
  *
  *	LOCKING:
  *	None (inherited from caller).
@@ -467,8 +467,6 @@ static void sis_133_early_set_dmamode (s
  *	@adev: Device to program
  *
  *	Set UDMA/MWDMA mode for device, in host controller PCI config space.
- *	Handles early SiS 961 bridges. Supports MWDMA as well unlike
- *	the old ide/pci driver.
  *
  *	LOCKING:
  *	None (inherited from caller).
