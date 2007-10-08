Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbXJHQM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbXJHQM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 12:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbXJHQMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 12:12:46 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:19323 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbXJHQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 12:12:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=QgOHK02nfCE9kVIJ6srXkAC7XUILbhh4ZvbhWgMoowTHIyZ89erVQNxYKs4eHJOmHwyreX1ElJrlVy8g2ga8vqVY6BdXjLQ0jHspZSNNhe8i4e1uMITdHAj8mabEaIDLh6KiM3icjefEr/zqm/tKuZynyFsbJTFw3duL4lpF6hE=
Date: Tue, 9 Oct 2007 00:12:40 +0800
From: "peerchen" <peerchen@gmail.com>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-ide" <linux-ide@vger.kernel.org>
Cc: "akpm" <akpm@linux-foundation.org>, "jeff" <jeff@garzik.org>
Subject: [PATCH] sata_nv: add the wildcard support for ahci legacy mode
Message-ID: <200710090012317183997@gmail.com>
X-mailer: Foxmail 6, 6, 105, 21 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add the wildcard support to sata_nv driver for those new ahci controllers being configured
as IDE/RAID mode and also their DIDs haven't been added into ahci driver.

The patch base on kernel 2.6.23-rc9

Signed-off-by: Peer Chen <peerchen@gmail.com>
---
--- linux-2.6.23-rc9/drivers/ata/sata_nv.c.orig	2007-10-08 10:32:52.000000000 -0400
+++ linux-2.6.23-rc9/drivers/ata/sata_nv.c	2007-10-08 10:33:04.000000000 -0400
@@ -266,6 +266,7 @@ static void nv_adma_tf_read(struct ata_p
 enum nv_host_type
 {
 	GENERIC,
+	AHCI_LEG,
 	NFORCE2,
 	NFORCE3 = NFORCE2,	/* NF2 == NF3 as far as sata_nv is concerned */
 	CK804,
@@ -287,6 +288,12 @@ static const struct pci_device_id nv_pci
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA2), GENERIC },
 	{ PCI_VDEVICE(NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP61_SATA3), GENERIC },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+		PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_RAID<<8, 0xffff00, AHCI_LEG },
+	{ PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID,
+		PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_STORAGE_IDE<<8, 0xffff00, AHCI_LEG },
 
 	{ } /* terminate list */
 };
@@ -365,6 +372,30 @@ static const struct ata_port_operations 
 	.port_start		= ata_port_start,
 };
 
+static const struct ata_port_operations nv_ahci_leg_ops = {
+	.port_disable		= ata_port_disable,
+	.tf_load		= ata_tf_load,
+	.tf_read		= ata_tf_read,
+	.exec_command		= ata_exec_command,
+	.check_status		= ata_check_status,
+	.dev_select		= ata_std_dev_select,
+	.bmdma_setup		= ata_bmdma_setup,
+	.bmdma_start		= ata_bmdma_start,
+	.bmdma_stop		= ata_bmdma_stop,
+	.bmdma_status		= ata_bmdma_status,
+	.qc_prep		= ata_qc_prep,
+	.qc_issue		= ata_qc_issue_prot,
+	.freeze			= ata_bmdma_freeze,
+	.thaw			= ata_bmdma_thaw,
+	.error_handler		= nv_error_handler,
+	.post_internal_cmd	= ata_bmdma_post_internal_cmd,
+	.data_xfer		= ata_data_xfer,
+	.irq_clear		= ata_bmdma_irq_clear,
+	.irq_on			= ata_irq_on,
+	.irq_ack		= ata_irq_ack,
+	.port_start		= ata_port_start,
+};
+
 static const struct ata_port_operations nv_nf2_ops = {
 	.port_disable		= ata_port_disable,
 	.tf_load		= ata_tf_load,
@@ -463,6 +494,17 @@ static const struct ata_port_info nv_por
 		.port_ops	= &nv_generic_ops,
 		.irq_handler	= nv_generic_interrupt,
 	},
+	/* ahci legacy */
+	{
+		.sht		= &nv_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_SLAVE_POSS |
+				  ATA_FLAG_HRST_TO_RESUME,
+		.pio_mask	= NV_PIO_MASK,
+		.mwdma_mask	= NV_MWDMA_MASK,
+		.udma_mask	= NV_UDMA_MASK,
+		.port_ops	= &nv_ahci_leg_ops,
+		.irq_handler	= nv_generic_interrupt,
+	},
 	/* nforce2/3 */
 	{
 		.sht		= &nv_sht,
-

