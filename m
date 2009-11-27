Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZK0S6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZK0S6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZK0S6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:58:18 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:11529 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169AbZK0S6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:58:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=LlJ0c2JS/J/e35uwgwVSmA/z/aCLDyvFALbx/ydzA8iAor7QW9VtV4NnKq3emmveD7
         WqOgetWE4C6dmQDBlHbZ1gWak46yIFYDnwoInyY83UDLt6UyUsYnNmX/WppDE9t6K46Y
         0cnw++PPCESAt27hrLPLTe8hd0YKcZlH1MVmU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] pata_hpt366: add enablebits checking
Date: Fri, 27 Nov 2009 19:53:51 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <200911271953.51400.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on Sergei's older work on IDE hpt366 host driver.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_hpt366.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

Index: b/drivers/ata/pata_hpt366.c
===================================================================
--- a/drivers/ata/pata_hpt366.c
+++ b/drivers/ata/pata_hpt366.c
@@ -204,6 +204,37 @@ static int hpt36x_cable_detect(struct at
 	return ATA_CBL_PATA80;
 }
 
+/**
+ *	hpt36x_prereset	-	perform reset handling
+ *	@link: ATA link to reset
+ *	@deadline: deadline jiffies for the operation
+ *
+ *	Perform the initial reset handling for the HPT36x.
+ */
+
+static int hpt36x_prereset(struct ata_link *link, unsigned long deadline)
+{
+	static const struct pci_bits hpt36x_enable_bits[] = {
+		{ 0x50, 1, 0x10, 0x10 },
+		{ 0x50, 1, 0x20, 0x20 }
+	};
+
+	struct ata_port *ap = link->ap;
+	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
+
+	/*
+	 * HPT36x chips have one channel per function and have
+	 * both channel enable bits located differently and visible
+	 * to both functions -- really stupid design decision... :-(
+	 * Bit 4 is for the primary channel, bit 5 for the secondary.
+	 */
+	if (!pci_test_config_bits(pdev,
+			&hpt36x_enable_bits[PCI_FUNC(pdev->devfn) & 1]))
+		return -ENOENT;
+
+	return ata_sff_prereset(link, deadline);
+}
+
 static void hpt366_set_mode(struct ata_port *ap, struct ata_device *adev,
 			    u8 mode)
 {
@@ -284,6 +315,7 @@ static struct scsi_host_template hpt36x_
 
 static struct ata_port_operations hpt366_port_ops = {
 	.inherits	= &ata_bmdma32_port_ops,
+	.prereset	= hpt36x_prereset,
 	.cable_detect	= hpt36x_cable_detect,
 	.mode_filter	= hpt366_filter,
 	.set_piomode	= hpt366_set_piomode,
