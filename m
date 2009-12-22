Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZLVXGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZLVXGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 18:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755549AbZLVXFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 18:05:41 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:61943 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbZLVXDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 18:03:48 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 22 Dec 2009 15:02:21 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/14] pci: separate pci_setup_bridge to small functions
In-reply-to: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1261522954-12591-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.0.2
References: <1261522954-12591-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to use those small functions according to resource type later

-v2: remove pref_mem64 typo, it should be removed

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/pci/setup-bus.c |   66 +++++++++++++++++++++++++++++++++++-----------
 1 files changed, 50 insertions(+), 16 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c48cd37..1bd41ac 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -134,18 +134,12 @@ EXPORT_SYMBOL(pci_setup_cardbus);
    config space writes, so it's quite possible that an I/O window of
    the bridge will have some undesirable address (e.g. 0) after the
    first write. Ditto 64-bit prefetchable MMIO.  */
-static void pci_setup_bridge(struct pci_bus *bus)
+static void pci_setup_bridge_io(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
 	struct resource *res;
 	struct pci_bus_region region;
-	u32 l, bu, lu, io_upper16;
-
-	if (pci_is_enabled(bridge))
-		return;
-
-	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
-		 bus->secondary, bus->subordinate);
+	u32 l, io_upper16;
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
 	res = bus->resource[0];
@@ -158,8 +152,7 @@ static void pci_setup_bridge(struct pci_bus *bus)
 		/* Set up upper 16 bits of I/O base/limit. */
 		io_upper16 = (region.end & 0xffff0000) | (region.start >> 16);
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
-	}
-	else {
+	} else {
 		/* Clear upper 16 bits of I/O base/limit. */
 		io_upper16 = 0;
 		l = 0x00f0;
@@ -171,21 +164,35 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	pci_write_config_dword(bridge, PCI_IO_BASE, l);
 	/* Update upper 16 bits of I/O base/limit. */
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, io_upper16);
+}
+
+static void pci_setup_bridge_mmio(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	struct resource *res;
+	struct pci_bus_region region;
+	u32 l;
 
-	/* Set up the top and bottom of the PCI Memory segment
-	   for this bus. */
+	/* Set up the top and bottom of the PCI Memory segment for this bus. */
 	res = bus->resource[1];
 	pcibios_resource_to_bus(bridge, &region, res);
 	if (res->flags & IORESOURCE_MEM) {
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
-	}
-	else {
+	} else {
 		l = 0x0000fff0;
 		dev_info(&bridge->dev, "  bridge window [mem disabled]\n");
 	}
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
+}
+
+static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	struct resource *res;
+	struct pci_bus_region region;
+	u32 l, bu, lu;
 
 	/* Clear out the upper 32 bits of PREF limit.
 	   If PCI_PREF_BASE_UPPER32 was non-zero, this temporarily
@@ -204,8 +211,7 @@ static void pci_setup_bridge(struct pci_bus *bus)
 			lu = upper_32_bits(region.end);
 		}
 		dev_info(&bridge->dev, "  bridge window %pR\n", res);
-	}
-	else {
+	} else {
 		l = 0x0000fff0;
 		dev_info(&bridge->dev, "  bridge window [mem pref disabled]\n");
 	}
@@ -214,10 +220,38 @@ static void pci_setup_bridge(struct pci_bus *bus)
 	/* Set the upper 32 bits of PREF base & limit. */
 	pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
 	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
+}
+
+static void __pci_setup_bridge(struct pci_bus *bus, unsigned long type)
+{
+	struct pci_dev *bridge = bus->self;
+
+	if (pci_is_enabled(bridge))
+		return;
+
+	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
+		 bus->secondary, bus->subordinate);
+
+	if (type & IORESOURCE_IO)
+		pci_setup_bridge_io(bus);
+
+	if (type & IORESOURCE_MEM)
+		pci_setup_bridge_mmio(bus);
+
+	if (type & IORESOURCE_PREFETCH)
+		pci_setup_bridge_mmio_pref(bus);
 
 	pci_write_config_word(bridge, PCI_BRIDGE_CONTROL, bus->bridge_ctl);
 }
 
+static void pci_setup_bridge(struct pci_bus *bus)
+{
+	unsigned long type = IORESOURCE_IO | IORESOURCE_MEM |
+				  IORESOURCE_PREFETCH;
+
+	__pci_setup_bridge(bus, type);
+}
+
 /* Check whether the bridge supports optional I/O and
    prefetchable memory ranges. If not, the respective
    base/limit registers must be read-only and read as 0. */
-- 
1.6.0.2

