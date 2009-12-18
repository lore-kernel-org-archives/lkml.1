Return-Path: <linux-kernel-owner+w=401wt.eu-S932708AbZLRUzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932708AbZLRUzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbZLRUzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:55:53 -0500
Received: from hera.kernel.org ([140.211.167.34]:52608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbZLRUzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:55:52 -0500
Message-ID: <4B2BEC16.5060203@kernel.org>
Date: Fri, 18 Dec 2009 12:54:46 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 1/12] pci: separate pci_setup_bridge to small functions
References: <4B2BE9DD.3040504@kernel.org>
In-Reply-To: <4B2BE9DD.3040504@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prepare to use those small functions according to resource type later

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   54 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
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
@@ -171,7 +165,14 @@ static void pci_setup_bridge(struct pci_
 	pci_write_config_dword(bridge, PCI_IO_BASE, l);
 	/* Update upper 16 bits of I/O base/limit. */
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, io_upper16);
+}
 
+static void pci_setup_bridge_mmio(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	struct resource *res;
+	struct pci_bus_region region;
+	u32 l;
 	/* Set up the top and bottom of the PCI Memory segment
 	   for this bus. */
 	res = bus->resource[1];
@@ -186,6 +187,14 @@ static void pci_setup_bridge(struct pci_
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
@@ -200,6 +209,7 @@ static void pci_setup_bridge(struct pci_
 		l = (region.start >> 16) & 0xfff0;
 		l |= region.end & 0xfff00000;
 		if (res->flags & IORESOURCE_MEM_64) {
+			pref_mem64 = 1;
 			bu = upper_32_bits(region.start);
 			lu = upper_32_bits(region.end);
 		}
@@ -214,10 +224,38 @@ static void pci_setup_bridge(struct pci_
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


