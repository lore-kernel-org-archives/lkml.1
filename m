Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbZKYR0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbZKYR0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759240AbZKYR0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:26:18 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759084AbZKYRF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:05:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=MA5jXBhndn4OoNghwc5dBeq0OMJnEsg2zqa3WB5F9sqVu5+243srueL+ZNUxm2cinS
         ghbnRi63egTyrWdHUoZ+9QYpT1xce4qSHYks5MuuvF0zrV5joQ+RK8pxlCdNM4t86p86
         Hex7RtP1Q4jzEytyXGgu4X31hTMvBOpr8cpbA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:04:50 +0100
Message-Id: <20091125170450.5446.70158.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 21/86] pata_cmd64x: add enablebits checking
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_cmd64x: add enablebits checking

There shouldn't be any problems with it as IDE cmd64x host driver
has been supporting enablebits checking for years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_cmd64x.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: b/drivers/ata/pata_cmd64x.c
===================================================================
--- a/drivers/ata/pata_cmd64x.c
+++ b/drivers/ata/pata_cmd64x.c
@@ -2,6 +2,7 @@
  * pata_cmd64x.c 	- CMD64x PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
  *			  Alan Cox <alan@lxorguk.ukuu.org.uk>
+ *			  (C) 2009 Bartlomiej Zolnierkiewicz
  *
  * Based upon
  * linux/drivers/ide/pci/cmd64x.c		Version 1.30	Sept 10, 2002
@@ -88,6 +89,40 @@ static int cmd648_cable_detect(struct at
 }
 
 /**
+ *	cmd64x_prereset	-	perform reset handling
+ *	@link: ATA link
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Reset sequence checking enable bits to see which ports are
+ *	active.
+ */
+
+static int cmd64x_prereset(struct ata_link *link, unsigned long deadline)
+{
+	static const struct pci_bits cmd64x_enable_bits[] = {
+		{ 0x51, 1, 0x04, 0x04 },
+		{ 0x51, 1, 0x08, 0x08 }
+	};
+
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	/*
+	 * The original PCI0643 and PCI0646 didn't have the primary
+	 * channel enable bit, it appeared starting with PCI0646U
+	 * (i.e. revision ID 3).
+	 */
+	if (pdev->device == PCI_DEVICE_ID_CMD_643 ||
+	    (pdev->device == PCI_DEVICE_ID_CMD_646 && pdev->revision < 3))
+		goto out;
+
+	if (!pci_test_config_bits(pdev, &cmd64x_enable_bits[ap->port_no]))
+		return -ENOENT;
+out:
+	return ata_sff_prereset(link, deadline);
+}
+
+/**
  *	cmd64x_set_piomode	-	set PIO and MWDMA timing
  *	@ap: ATA interface
  *	@adev: ATA device
@@ -278,6 +313,7 @@ static const struct ata_port_operations
 static struct ata_port_operations cmd64x_port_ops = {
 	.inherits	= &cmd64x_base_ops,
 	.cable_detect	= ata_cable_40wire,
+	.prereset	= cmd64x_prereset,
 };
 
 static struct ata_port_operations cmd646r1_port_ops = {
