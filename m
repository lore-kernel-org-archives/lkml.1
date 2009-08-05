Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbZHEXuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbZHEXuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZHEXuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:50:11 -0400
Received: from gold.linx.net ([195.66.232.40]:44470 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbZHEXuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:50:10 -0400
From: Tony Vroon <tony@linx.net>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       Robert Hancock <hancockrwd@gmail.com>
Subject: [PATCH 2.6.32 v3] Conditional MSI support for sata_nv
Message-Id: <20090805235009.88C091007F@gold.linx.net>
Date: Thu,  6 Aug 2009 00:50:09 +0100 (BST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least the nVidia MCP55 controller quite happily supports MSI.
This adds an option to use it. It is disabled by default.
As per feedback by Robert Hancock, it will honour the user 
request as the kernel will not enable MSI where the controller 
or the specific system configuration do not support it.

Signed-off-by: Tony Vroon <tony@linx.net>
Cc: Robert Hancock <hancockrwd@gmail.com>

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index b2d11f3..4598f19 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -602,6 +602,7 @@ MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled;
 static int swncq_enabled = 1;
+static int msi_enabled;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -2459,6 +2460,12 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else if (type == SWNCQ)
 		nv_swncq_host_init(host);
 
+	if (msi_enabled) {
+		dev_printk(KERN_NOTICE, &pdev->dev, "Using MSI\n");
+		pci_enable_msi(pdev);
+	}
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
 				 IRQF_SHARED, ipriv->sht);
@@ -2558,4 +2565,6 @@ module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: false)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
 MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
+module_param_named(msi, msi_enabled, bool, 0444);
+MODULE_PARM_DESC(msi, "Enable use of MSI (Default: false)");
 
