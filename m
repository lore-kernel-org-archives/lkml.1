Return-Path: <linux-kernel-owner+w=401wt.eu-S1759921AbYJKGpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921AbYJKGpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYJKGha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:37:30 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:39166 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYJKGhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:11 -0400
Date: Sat, 11 Oct 2008 02:36:22 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 62/85] PNPACPI: use dev_printk when possible
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <958a1fdd3904b009c926cb840be48ce3c5f2389e.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Use dev_printk() when possible for more informative error messages.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/pnp/pnpacpi/rsparser.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index 95015cb..0461d4b 100644
--- a/drivers/pnp/pnpacpi/rsparser.c
+++ b/drivers/pnp/pnpacpi/rsparser.c
@@ -132,7 +132,8 @@ static void pnpacpi_parse_allocated_irqresource(struct pnp_dev *dev,
 	pnp_add_irq_resource(dev, irq, flags);
 }
 
-static int dma_flags(int type, int bus_master, int transfer)
+static int dma_flags(struct pnp_dev *dev, int type, int bus_master,
+		     int transfer)
 {
 	int flags = 0;
 
@@ -154,7 +155,7 @@ static int dma_flags(int type, int bus_master, int transfer)
 	default:
 		/* Set a default value ? */
 		flags |= IORESOURCE_DMA_COMPATIBLE;
-		pnp_err("Invalid DMA type");
+		dev_err(&dev->dev, "invalid DMA type %d\n", type);
 	}
 	switch (transfer) {
 	case ACPI_TRANSFER_8:
@@ -169,7 +170,7 @@ static int dma_flags(int type, int bus_master, int transfer)
 	default:
 		/* Set a default value ? */
 		flags |= IORESOURCE_DMA_8AND16BIT;
-		pnp_err("Invalid DMA transfer type");
+		dev_err(&dev->dev, "invalid DMA transfer type %d\n", transfer);
 	}
 
 	return flags;
@@ -336,7 +337,7 @@ static acpi_status pnpacpi_allocated_resource(struct acpi_resource *res,
 	case ACPI_RESOURCE_TYPE_DMA:
 		dma = &res->data.dma;
 		if (dma->channel_count > 0 && dma->channels[0] != (u8) -1)
-			flags = dma_flags(dma->type, dma->bus_master,
+			flags = dma_flags(dev, dma->type, dma->bus_master,
 					  dma->transfer);
 		else
 			flags = IORESOURCE_DISABLED;
@@ -477,7 +478,7 @@ static __init void pnpacpi_parse_dma_option(struct pnp_dev *dev,
 	for (i = 0; i < p->channel_count; i++)
 		map |= 1 << p->channels[i];
 
-	flags = dma_flags(p->type, p->bus_master, p->transfer);
+	flags = dma_flags(dev, p->type, p->bus_master, p->transfer);
 	pnp_register_dma_resource(dev, option_flags, map, flags);
 }
 
@@ -608,8 +609,8 @@ static __init void pnpacpi_parse_address_option(struct pnp_dev *dev,
 	unsigned char flags = 0;
 
 	status = acpi_resource_to_address64(r, p);
-	if (!ACPI_SUCCESS(status)) {
-		pnp_warn("PnPACPI: failed to convert resource type %d",
+	if (ACPI_FAILURE(status)) {
+		dev_warn(&dev->dev, "can't convert resource type %d\n",
 			 r->type);
 		return;
 	}
-- 
1.5.5.1

