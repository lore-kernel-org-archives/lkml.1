Return-Path: <linux-kernel-owner+w=401wt.eu-S1754108AbZKSSNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbZKSSNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 13:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbZKSSNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 13:13:33 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:65055 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZKSSNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 13:13:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=xDDfWpWsWt0mNn7WuVBnXXMTe7azhfEOflzmEgNNMxN9yekJGdQrL+kZivA9QDuCGo
         mT5qPG+gPuzSWV0pubr3Q/QXr/CY7V7IGkYLjU9bfNxJIKqntngS7ETGaa5F4TL5Zh0I
         AjLt+3FwaLExIZeVwUQ/U47eMI/b1sIxzFxLY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH 2/2] pata_hpt37x: unify ->pre_reset methods
Date: Thu, 19 Nov 2009 19:12:24 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191912.24663.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can use the same ->pre_reset method for all HPT37x chipsets now.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_hpt37x.c |   23 ++---------------------
 1 file changed, 2 insertions(+), 21 deletions(-)

Index: b/drivers/ata/pata_hpt37x.c
===================================================================
--- a/drivers/ata/pata_hpt37x.c
+++ b/drivers/ata/pata_hpt37x.c
@@ -360,7 +360,7 @@ static int hpt374_fn1_cable_detect(struc
  *	@link: ATA link to reset
  *	@deadline: deadline jiffies for the operation
  *
- *	Perform the initial reset handling for the 370/372 and 374 func 0
+ *	Perform the initial reset handling for the HPT37x.
  */
 
 static int hpt37x_pre_reset(struct ata_link *link, unsigned long deadline)
@@ -381,25 +381,6 @@ static int hpt37x_pre_reset(struct ata_l
 	return ata_sff_prereset(link, deadline);
 }
 
-static int hpt374_fn1_pre_reset(struct ata_link *link, unsigned long deadline)
-{
-	static const struct pci_bits hpt37x_enable_bits[] = {
-		{ 0x50, 1, 0x04, 0x04 },
-		{ 0x54, 1, 0x04, 0x04 }
-	};
-	struct ata_port *ap = link->ap;
-	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-
-	if (!pci_test_config_bits(pdev, &hpt37x_enable_bits[ap->port_no]))
-		return -ENOENT;
-
-	/* Reset the state machine */
-	pci_write_config_byte(pdev, 0x50 + 4 * ap->port_no, 0x37);
-	udelay(100);
-
-	return ata_sff_prereset(link, deadline);
-}
-
 /**
  *	hpt370_set_piomode		-	PIO setup
  *	@ap: ATA interface
@@ -646,7 +627,7 @@ static struct ata_port_operations hpt372
 static struct ata_port_operations hpt374_fn1_port_ops = {
 	.inherits	= &hpt372_port_ops,
 	.cable_detect	= hpt374_fn1_cable_detect,
-	.prereset	= hpt374_fn1_pre_reset,
+	.prereset	= hpt37x_pre_reset,
 };
 
 /**
