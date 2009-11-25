Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbZKYRKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbZKYRKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758890AbZKYRKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:10:09 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37967 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933512AbZKYRKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:10:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=P4vX8GkLv84xjpnxzRFymrD6LfpbI3m8korRs4pujH7bWDh6ywogSqwnmt64jl6Zwi
         fSd+gmD6qeQ1rxEX7h2s5BJ3gIy1WakhN2yPaglxiPMjqZ21KG/jczZ4BWS3Ps3WD110
         PdO1ze3vkMbhJe950w4vA35O83JcRwcHvhSD0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:09:25 +0100
Message-Id: <20091125170925.5446.32918.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 59/86] pata_pdc2027x: add Power Management support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_pdc2027x: add Power Management support

There shouldn't be any problems with it as IDE pdc202xx_new host driver
has been supporting Power Management for over year now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_pdc2027x.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

Index: b/drivers/ata/pata_pdc2027x.c
===================================================================
--- a/drivers/ata/pata_pdc2027x.c
+++ b/drivers/ata/pata_pdc2027x.c
@@ -63,6 +63,7 @@ enum {
 };
 
 static int pdc2027x_init_one(struct pci_dev *pdev, const struct pci_device_id *ent);
+static int pdc2027x_reinit_one(struct pci_dev *pdev);
 static int pdc2027x_prereset(struct ata_link *link, unsigned long deadline);
 static void pdc2027x_set_piomode(struct ata_port *ap, struct ata_device *adev);
 static void pdc2027x_set_dmamode(struct ata_port *ap, struct ata_device *adev);
@@ -126,6 +127,10 @@ static struct pci_driver pdc2027x_pci_dr
 	.id_table		= pdc2027x_pci_tbl,
 	.probe			= pdc2027x_init_one,
 	.remove			= ata_pci_remove_one,
+#ifdef CONFIG_PM
+	.suspend		= ata_pci_device_suspend,
+	.resume			= pdc2027x_reinit_one,
+#endif
 };
 
 static struct scsi_host_template pdc2027x_sht = {
@@ -758,6 +763,31 @@ static int __devinit pdc2027x_init_one(s
 				 IRQF_SHARED, &pdc2027x_sht);
 }
 
+#ifdef CONFIG_PM
+static int pdc2027x_reinit_one(struct pci_dev *pdev)
+{
+	struct ata_host *host = dev_get_drvdata(&pdev->dev);
+	unsigned int board_idx;
+	int rc;
+
+	rc = ata_pci_device_do_resume(pdev);
+	if (rc)
+		return rc;
+
+	if (pdev->device == PCI_DEVICE_ID_PROMISE_20268 ||
+	    pdev->device == PCI_DEVICE_ID_PROMISE_20270)
+		board_idx = PDC_UDMA_100;
+	else
+		board_idx = PDC_UDMA_133;
+
+	if (pdc_hardware_init(host, board_idx))
+		return -EIO;
+
+	ata_host_resume(host);
+	return 0;
+}
+#endif
+
 /**
  * pdc2027x_init - Called after this module is loaded into the kernel.
  */
