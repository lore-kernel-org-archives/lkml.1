Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYHSWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYHSWyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbYHSWxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:25 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:29025 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbYHSWxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:23 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 2/8] PNPACPI: use dev_printk when possible
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, Adam M Belay <abelay@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Ben Collins <bcollins@ubuntu.com>, Dann Frazier <dannf@debian.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 19 Aug 2008 16:53:21 -0600
Message-ID: <20080819225321.28206.70872.stgit@tigger.helgaas>
In-Reply-To: <20080819225310.28206.1011.stgit@tigger.helgaas>
References: <20080819225310.28206.1011.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use dev_printk() when possible for more informative error messages.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pnp/pnpacpi/rsparser.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)


diff --git a/drivers/pnp/pnpacpi/rsparser.c b/drivers/pnp/pnpacpi/rsparser.c
index d7e9f21..10a0d97 100644
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
@@ -479,7 +480,7 @@ static __init void pnpacpi_parse_dma_option(struct pnp_dev *dev,
 	for (i = 0; i < p->channel_count; i++)
 		map |= 1 << p->channels[i];
 
-	flags = dma_flags(p->type, p->bus_master, p->transfer);
+	flags = dma_flags(dev, p->type, p->bus_master, p->transfer);
 	pnp_register_dma_resource(dev, option_flags, map, flags);
 }
 
@@ -610,8 +611,8 @@ static __init void pnpacpi_parse_address_option(struct pnp_dev *dev,
 	unsigned char flags = 0;
 
 	status = acpi_resource_to_address64(r, p);
-	if (!ACPI_SUCCESS(status)) {
-		pnp_warn("PnPACPI: failed to convert resource type %d",
+	if (ACPI_FAILURE(status)) {
+		dev_warn(&dev->dev, "can't convert resource type %d\n",
 			 r->type);
 		return;
 	}

