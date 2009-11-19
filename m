Return-Path: <linux-kernel-owner+w=401wt.eu-S1753967AbZKSSNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbZKSSNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909AbZKSSNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:13:32 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:65465 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbZKSSNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=KYpoNdxgbbAnLwnqOXL+2WTHMqGmVpm7XjzOpmdVL/O0oAz/EQNPjQ7zRH/gMiOCvM
         qYavMY3MZeWLpV95LnbeK/A+mPdpb+QPZWvVqkKtLTuyIOfYxsd/2HkkfX4HYEWfQzA+
         NC3e5FDWBZzXC+RNtmWEHKu745BGiTTkORiQg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 1/2] pata_hpt37x: add proper cable detection methods
Date: Thu, 19 Nov 2009 19:10:44 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191910.44609.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_hpt37x.c |   86 +++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 30 deletions(-)

Index: b/drivers/ata/pata_hpt37x.c
===================================================================
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -303,6 +303,59 @@ static unsigned long hpt370a_filter(stru
 }
 
 /**
+ *	hpt37x_cable_detect	-	Detect the cable type
+ *	@ap: ATA port to detect on
+ *
+ *	Return the cable type attached to this port
+ */
+
+static int hpt37x_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	u8 scr2, ata66;
+
+	pci_read_config_byte(pdev, 0x5B, &scr2);
+	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
+	/* Cable register now active */
+	pci_read_config_byte(pdev, 0x5A, &ata66);
+	/* Restore state */
+	pci_write_config_byte(pdev, 0x5B, scr2);
+
+	if (ata66 & (2 >> ap->port_no))
+		return ATA_CBL_PATA40;
+	else
+		return ATA_CBL_PATA80;
+}
+
+/**
+ *	hpt374_fn1_cable_detect	-	Detect the cable type
+ *	@ap: ATA port to detect on
+ *
+ *	Return the cable type attached to this port
+ */
+
+static int hpt374_fn1_cable_detect(struct ata_port *ap)
+{
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+	unsigned int mcrbase = 0x50 + 4 * ap->port_no;
+	u16 mcr3;
+	u8 ata66;
+
+	/* Do the extra channel work */
+	pci_read_config_word(pdev, mcrbase + 2, &mcr3);
+	/* Set bit 15 of 0x52 to enable TCBLID as input */
+	pci_write_config_word(pdev, mcrbase + 2, mcr3 | 0x8000);
+	pci_read_config_byte(pdev, 0x5A, &ata66);
+	/* Reset TCBLID/FCBLID to output */
+	pci_write_config_word(pdev, mcrbase + 2, mcr3);
+
+	if (ata66 & (2 >> ap->port_no))
+		return ATA_CBL_PATA40;
+	else
+		return ATA_CBL_PATA80;
+}
+
+/**
  *	hpt37x_pre_reset	-	reset the hpt37x bus
  *	@link: ATA link to reset
  *	@deadline: deadline jiffies for the operation
@@ -312,7 +365,6 @@ static unsigned long hpt370a_filter(stru
 
 static int hpt37x_pre_reset(struct ata_link *link, unsigned long deadline)
 {
-	u8 scr2, ata66;
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	static const struct pci_bits hpt37x_enable_bits[] = {
@@ -322,18 +374,6 @@ static int hpt37x_pre_reset(struct ata_l
 	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	pci_read_config_byte(pdev, 0x5B, &scr2);
-	pci_write_config_byte(pdev, 0x5B, scr2 & ~0x01);
-	/* Cable register now active */
-	pci_read_config_byte(pdev, 0x5A, &ata66);
-	/* Restore state */
-	pci_write_config_byte(pdev, 0x5B, scr2);
-
-	if (ata66 & (2 >> ap->port_no))
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
-
 	/* Reset the state machine */
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
@@ -347,29 +387,12 @@ static int hpt374_fn1_pre_reset(struct a
 		{ 0x50, 1, 0x04, 0x04 },
 		{ 0x54, 1, 0x04, 0x04 }
 	};
-	u16 mcr3;
-	u8 ata66;
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	unsigned int mcrbase = 0x50 + 4 * ap->port_no;
 
 	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	/* Do the extra channel work */
-	pci_read_config_word(pdev, mcrbase + 2, &mcr3);
-	/* Set bit 15 of 0x52 to enable TCBLID as input
-	 */
-	pci_write_config_word(pdev, mcrbase + 2, mcr3 | 0x8000);
-	pci_read_config_byte(pdev, 0x5A, &ata66);
-	/* Reset TCBLID/FCBLID to output */
-	pci_write_config_word(pdev, mcrbase + 2, mcr3);
-
-	if (ata66 & (2 >> ap->port_no))
-		ap->cbl = ATA_CBL_PATA40;
-	else
-		ap->cbl = ATA_CBL_PATA80;
-
 	/* Reset the state machine */
 	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
 	udelay(100);
@@ -584,6 +607,7 @@ static struct ata_port_operations hpt370
 	.bmdma_stop	= hpt370_bmdma_stop,
 
 	.mode_filter	= hpt370_filter,
+	.cable_detect	= hpt37x_cable_detect,
 	.set_piomode	= hpt370_set_piomode,
 	.set_dmamode	= hpt370_set_dmamode,
 	.prereset	= hpt37x_pre_reset,
@@ -608,6 +632,7 @@ static struct ata_port_operations hpt372
 
 	.bmdma_stop	= hpt37x_bmdma_stop,
 
+	.cable_detect	= hpt37x_cable_detect,
 	.set_piomode	= hpt372_set_piomode,
 	.set_dmamode	= hpt372_set_dmamode,
 	.prereset	= hpt37x_pre_reset,
@@ -620,6 +645,7 @@ static struct ata_port_operations hpt372
 
 static struct ata_port_operations hpt374_fn1_port_ops = {
 	.inherits	= &hpt372_port_ops,
+	.cable_detect	= hpt374_fn1_cable_detect,
 	.prereset	= hpt374_fn1_pre_reset,
 };
 
