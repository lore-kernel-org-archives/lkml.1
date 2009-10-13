Return-Path: <linux-kernel-owner+w=401wt.eu-S934132AbZJMTXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132AbZJMTXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 15:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934121AbZJMTXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 15:23:01 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:21906 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934096AbZJMTW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 15:22:58 -0400
Subject: [PATCH v2 5/9] PCI: trivial bridge resource factorization
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Date: Tue, 13 Oct 2009 13:22:20 -0600
Message-ID: <20091013192220.22336.51436.stgit@bob.kio>
In-Reply-To: <20091013192040.22336.84876.stgit@bob.kio>
References: <20091013192040.22336.84876.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a temporary "res" so we don't have to repeat, e.g.,
"bus->resource[0]".  The next patch adds more uses of "res".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 drivers/pci/setup-bus.c |   39 ++++++++++++++++++++++++---------------
 1 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 0959430..fd66a89 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -71,13 +71,15 @@ static void pbus_assign_resources_sorted(const struct pci_bus *bus)
 void pci_setup_cardbus(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
+	struct resource *res;
 	struct pci_bus_region region;
 
 	dev_info(&bridge->dev, "CardBus bridge, secondary bus %04x:%02x\n",
 		 pci_domain_nr(bus), bus->number);
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
-	if (bus->resource[0]->flags & IORESOURCE_IO) {
+	res = bus->resource[0];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_IO) {
 		/*
 		 * The IO resource is allocated a range twice as large as it
 		 * would normally need.  This allows us to set both IO regs.
@@ -91,8 +93,9 @@ void pci_setup_cardbus(struct pci_bus *bus)
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
-	if (bus->resource[1]->flags & IORESOURCE_IO) {
+	res = bus->resource[1];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_IO) {
 		dev_info(&bridge->dev, "  IO window: %#08lx-%#08lx\n",
 		       (unsigned long)region.start,
 		       (unsigned long)region.end);
@@ -102,8 +105,9 @@ void pci_setup_cardbus(struct pci_bus *bus)
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
-	if (bus->resource[2]->flags & IORESOURCE_MEM) {
+	res = bus->resource[2];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_MEM) {
 		dev_info(&bridge->dev, "  PREFETCH window: %#08lx-%#08lx\n",
 		       (unsigned long)region.start,
 		       (unsigned long)region.end);
@@ -113,8 +117,9 @@ void pci_setup_cardbus(struct pci_bus *bus)
 					region.end);
 	}
 
-	pcibios_resource_to_bus(bridge, &region, bus->resource[3]);
-	if (bus->resource[3]->flags & IORESOURCE_MEM) {
+	res = bus->resource[3];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_MEM) {
 		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
 		       (unsigned long)region.start,
 		       (unsigned long)region.end);
@@ -140,6 +145,7 @@ EXPORT_SYMBOL(pci_setup_cardbus);
 static void pci_setup_bridge(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
+	struct resource *res;
 	struct pci_bus_region region;
 	u32 l, bu, lu, io_upper16;
 	int pref_mem64;
@@ -151,8 +157,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
 		 pci_domain_nr(bus), bus->number);
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
-	pcibios_resource_to_bus(bridge, &region, bus->resource[0]);
-	if (bus->resource[0]->flags & IORESOURCE_IO) {
+	res = bus->resource[0];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_IO) {
 		pci_read_config_dword(bridge, PCI_IO_BASE, &l);
 		l &= 0xffff0000;
 		l |= (region.start >> 8) & 0x00f0;
@@ -178,8 +185,9 @@ static void pci_setup_bridge(struct pci_bus *bus)
 
 	/* Set up the top and bottom of the PCI Memory segment
 	   for this bus. */
-	pcibios_resource_to_bus(bridge, &region, bus->resource[1]);
-	if (bus->resource[1]->flags & IORESOURCE_MEM) {
+	res = bus->resource[1];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		dev_info(&bridge->dev, "  MEM window: %#08lx-%#08lx\n",
@@ -200,12 +208,13 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	/* Set up PREF base/limit. */
 	pref_mem64 = 0;
 	bu = lu = 0;
-	pcibios_resource_to_bus(bridge, &region, bus->resource[2]);
-	if (bus->resource[2]->flags & IORESOURCE_PREFETCH) {
+	res = bus->resource[2];
+	pcibios_resource_to_bus(bridge, &region, res);
+	if (res->flags & IORESOURCE_PREFETCH) {
 		int width = 8;
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
-		if (bus->resource[2]->flags & IORESOURCE_MEM_64) {
+		if (res->flags & IORESOURCE_MEM_64) {
 			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);

