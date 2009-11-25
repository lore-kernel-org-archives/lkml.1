Return-Path: <linux-kernel-owner+w=401wt.eu-S1759180AbZKYRFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759180AbZKYRFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:05:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759105AbZKYRFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:05:03 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759033AbZKYRFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:05:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=h3CVATKNQKyQ3eSDA2u3UNIsvro0UTnepzygDaBIMcHdbgSVQTlu8+L0FVRMeJCy8D
         Bna8HIbwohtknHsnbvMnFPd6BxX3zeyA1/CRlT5u9Z7mIdOjg1MGALEPzxT7yQizKU6n
         kgoqFeFtDcx1j9nEWdJ3YuUJons1yGJVqUoN8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:04:22 +0100
Message-Id: <20091125170422.5446.10637.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 17/86] pata_efar: fix register naming used in efar_set_piomode()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_efar: fix register naming used in efar_set_piomode()

Rename 'idetm_port' and 'idetm_data' variables to 'master_port'
and 'master_data' respectively to match register naming used in
efar_set_dma_mode() and in ata_piix.c.

Fix efar_set_piomode() documentation and 'master_port' type
while at it.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_efar.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

Index: b/drivers/ata/pata_efar.c
===================================================================
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -71,7 +71,7 @@ static int efar_cable_detect(struct ata_
 /**
  *	efar_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
- *	@adev: um
+ *	@adev: Device to program
  *
  *	Set PIO mode for device, in host controller PCI config space.
  *
@@ -83,8 +83,8 @@ static void efar_set_piomode (struct ata
 {
 	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
-	unsigned int idetm_port= ap->port_no ? 0x42 : 0x40;
-	u16 idetm_data;
+	u8 master_port		= ap->port_no ? 0x42 : 0x40;
+	u16 master_data;
 	int control = 0;
 
 	/*
@@ -107,20 +107,20 @@ static void efar_set_piomode (struct ata
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE */
 
-	pci_read_config_word(dev, idetm_port, &idetm_data);
+	pci_read_config_word(dev, master_port, &master_data);
 
 	/* Set PPE, IE, and TIME as appropriate */
 	if (adev->devno == 0) {
-		idetm_data &= 0xCCF0;
-		idetm_data |= control;
-		idetm_data |= (timings[pio][0] << 12) |
+		master_data &= 0xCCF0;
+		master_data |= control;
+		master_data |= (timings[pio][0] << 12) |
 			(timings[pio][1] << 8);
 	} else {
 		int shift = 4 * ap->port_no;
 		u8 slave_data;
 
-		idetm_data &= 0xFF0F;
-		idetm_data |= (control << 4);
+		master_data &= 0xFF0F;
+		master_data |= (control << 4);
 
 		/* Slave timing in separate register */
 		pci_read_config_byte(dev, 0x44, &slave_data);
@@ -129,8 +129,8 @@ static void efar_set_piomode (struct ata
 		pci_write_config_byte(dev, 0x44, slave_data);
 	}
 
-	idetm_data |= 0x4000;	/* Ensure SITRE is set */
-	pci_write_config_word(dev, idetm_port, idetm_data);
+	master_data |= 0x4000;	/* Ensure SITRE is set */
+	pci_write_config_word(dev, master_port, master_data);
 }
 
 /**
