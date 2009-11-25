Return-Path: <linux-kernel-owner+w=401wt.eu-S1758971AbZKYRDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758971AbZKYRDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbZKYRDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:03:41 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948AbZKYRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=cwWq0C80FGhNQB4yI0nnB2zkgrtit5XWhIPqMr+nXvMVGT8AGFEfSQekh+e9B/XyJr
         rmS21rN42KkOV3ZVa4m7nvwixhlT81wdKhFxTLGdK3KsBxNBnx+7q/Z2NOTyWjZT2CEK
         yGb14edhNk7OSryTdXI2lHAV6F3ZDd1TYHFn4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:03:00 +0100
Message-Id: <20091125170300.5446.25122.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 06/86] pata_artop: unify ->prereset methods
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_artop: unify ->prereset methods

We can use the same ->prereset method for ATP850 and ATP86xR chipsets.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_artop.c |   28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

Index: b/drivers/ata/pata_artop.c
===================================================================
--- a/drivers/ata/pata_artop.c
+++ b/drivers/ata/pata_artop.c
@@ -39,30 +39,15 @@
 
 static int clock = 0;
 
-static int atp850_pre_reset(struct ata_link *link, unsigned long deadline)
-{
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	const struct pci_bits artop_enable_bits[] = {
-		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
-		{ 0x4AU, 1U, 0x04UL, 0x04UL },	/* port 1 */
-	};
-
-	if (!pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	return ata_sff_prereset(link, deadline);
-}
-
 /**
- *	atp86x_pre_reset	-	probe begin
+ *	atp8xx_prereset	-	probe begin
  *	@link: link
  *	@deadline: deadline jiffies for the operation
  *
  *	Nothing complicated needed here.
  */
 
-static int atp86x_pre_reset(struct ata_link *link, unsigned long deadline)
+static int atp8xx_prereset(struct ata_link *link, unsigned long deadline)
 {
 	static const struct pci_bits artop_enable_bits[] = {
 		{ 0x4AU, 1U, 0x02UL, 0x02UL },	/* port 0 */
@@ -72,8 +57,9 @@ static int atp86x_pre_reset(struct ata_l
 	struct ata_port *ap = link->ap;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 
-	/* Odd numbered device ids are the units with enable bits (the -R cards) */
-	if (pdev->device % 1 && !pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
+	/* Odd numbered device ids are the units with enable bits. */
+	if (pdev->device % 1 &&
+	    !pci_test_config_bits(pdev, &artop_enable_bits[ap->port_no]))
 		return -ENOENT;
 
 	return ata_sff_prereset(link, deadline);
@@ -317,7 +303,7 @@ static struct ata_port_operations atp850
 	.cable_detect		= ata_cable_40wire,
 	.set_piomode		= atp850_set_piomode,
 	.set_dmamode		= atp850_set_dmamode,
-	.prereset		= atp850_pre_reset,
+	.prereset		= atp8xx_prereset,
 	.qc_defer		= atp850_qc_defer,
 };
 
@@ -326,7 +312,7 @@ static struct ata_port_operations atp86x
 	.cable_detect		= atp86x_cable_detect,
 	.set_piomode		= atp86x_set_piomode,
 	.set_dmamode		= atp86x_set_dmamode,
-	.prereset		= atp86x_pre_reset,
+	.prereset		= atp8xx_prereset,
 };
 
 static void atp8xx_fixup(struct pci_dev *pdev)
