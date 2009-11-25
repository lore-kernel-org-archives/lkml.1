Return-Path: <linux-kernel-owner+w=401wt.eu-S1759095AbZKYRE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759095AbZKYRE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758994AbZKYREX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:23 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:53682 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759082AbZKYREW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Gi2UIu42K0EozT4GXC1E1GXQ9xIeZqmiJJS1Cwl5D4WRYqUNhBZie8SRJW3wvAgRSL
         6q2K2btq9iuqysbGdSyKbjjQgiMEmoxw/774JS1EBmq+AgEpeOAktDx+h7WQjCR87hx2
         gpeOqA2vPTRtKLGHtmyqa50pCFl/m+EPX+64s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:03:44 +0100
Message-Id: <20091125170344.5446.54715.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 12/86] pata_atiixp: add proper ->prereset method
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: add proper ->prereset method

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |   35 ++++++++++++++++++++++++++---------
 1 file changed, 26 insertions(+), 9 deletions(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -47,6 +47,31 @@ static int atiixp_cable_detect(struct at
 }
 
 /**
+ *	atiixp_prereset	-	perform reset handling
+ *	@link: ATA link
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Reset sequence checking enable bits to see which ports are
+ *	active.
+ */
+
+static int atiixp_prereset(struct ata_link *link, unsigned long deadline)
+{
+	static const struct pci_bits atiixp_enable_bits[] = {
+		{ 0x48, 1, 0x01, 0x00 },
+		{ 0x48, 1, 0x08, 0x00 }
+	};
+
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
+		return -ENOENT;
+
+	return ata_sff_prereset(link, deadline);
+}
+
+/**
  *	atiixp_set_pio_timing	-	set initial PIO mode data
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -151,6 +176,7 @@ static struct ata_port_operations atiixp
 
 	.qc_prep 	= ata_sff_dumb_qc_prep,
 
+	.prereset	= atiixp_prereset,
 	.cable_detect	= atiixp_cable_detect,
 	.set_piomode	= atiixp_set_piomode,
 	.set_dmamode	= atiixp_set_dmamode,
@@ -165,16 +191,7 @@ static int atiixp_init_one(struct pci_de
 		.udma_mask = ATA_UDMA5,
 		.port_ops = &atiixp_port_ops
 	};
-	static const struct pci_bits atiixp_enable_bits[] = {
-		{ 0x48, 1, 0x01, 0x00 },
-		{ 0x48, 1, 0x08, 0x00 }
-	};
 	const struct ata_port_info *ppi[] = { &info, &info };
-	int i;
-
-	for (i = 0; i < 2; i++)
-		if (!pci_test_config_bits(pdev, &atiixp_enable_bits[i]))
-			ppi[i] = &ata_dummy_port_info;
 
 	return ata_pci_sff_init_one(pdev, ppi, &atiixp_sht, NULL);
 }
