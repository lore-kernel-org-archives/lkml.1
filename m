Return-Path: <linux-kernel-owner+w=401wt.eu-S1752871AbZK1HkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbZK1HkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 02:40:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZK1HkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 02:40:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:34550 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbZK1HkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 02:40:01 -0500
Message-ID: <4B10D29F.2000800@kernel.org>
Date: Fri, 27 Nov 2009 23:34:55 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Alex Chiang <achiang@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: [PATCH 1/9] pci: separate pci_setup_bridge to small functions
References: <4ADEB601.8020200@kernel.org>	<4AE55D12.30403@kernel.org>	<4AE57976.4060107@jp.fujitsu.com>	<4AE5E37F.8070707@kernel.org>	<4AE5EFDB.2060908@kernel.org>	<4AE80170.6030402@jp.fujitsu.com>	<4AE88305.8020207@kernel.org>	<m1ljivibrt.fsf@fess.ebiederm.org>	<4AE899A0.3020006@kernel.org>	<4AE95247.8080401@jp.fujitsu.com>	<4AE952B9.1010603@kernel.org>	<4AE9588E.90708@jp.fujitsu.com>	<4AE9657F.7010302@kernel.org>	<4AE965D9.9040702@kernel.org> <20091104093044.17ab628a@jbarnes-piketon> <4AF1CD79.4010602@kernel.org> <4AF22CF1.1020508@kernel.org> <4AF22D26.4070500@kernel.org> <4AF508F0.9060105@kernel.org> <4AF91F54.10507@jp.fujitsu.com> <4AF936DB.1030309@kernel.org> <4AFCF7D8.1090207@jp.fujitsu.com> <4AFCFC0D.4030002@kernel.org> <4AFD19DA.7010602@jp.fujitsu.com> <4AFE6F39.5080505@kernel.org> <4B0B321E.4010103@jp.fujitsu.com> <4B0B335E.1070809@kernel.org> <4B0B3C13.9030502@jp.fujit! su.com> <4B0C69AD.3030106@kernel. org> <4B0D13EB.9010403@jp.fujitsu.com> <4B10D084.8070608@kerne!
 l.org>
In-Reply-To: <4B10D084.8070608@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


prepare to use those small functions according to resource type later

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/setup-bus.c |   54 +++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 44 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -134,19 +134,12 @@ EXPORT_SYMBOL(pci_setup_cardbus);
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
-	int pref_mem64;
-
-	if (pci_is_enabled(bridge))
-		return;
-
-	dev_info(&bridge->dev, "PCI bridge to [bus %02x-%02x]\n",
-		 bus->secondary, bus->subordinate);
+	u32 l, io_upper16;
 
 	/* Set up the top and bottom of the PCI I/O segment for this bus. */
 	res = bus->resource[0];
@@ -172,7 +165,13 @@ static void pci_setup_bridge(struct pci_
 	pci_write_config_dword(bridge, PCI_IO_BASE, l);
 	/* Update upper 16 bits of I/O base/limit. */
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, io_upper16);
-
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
@@ -187,6 +186,14 @@ static void pci_setup_bridge(struct pci_
 		dev_info(&bridge->dev, "  bridge window [mem disabled]\n");
 	}
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
+}
+static void pci_setup_bridge_mmio_pref(struct pci_bus *bus)
+{
+	struct pci_dev *bridge = bus->self;
+	struct resource *res;
+	struct pci_bus_region region;
+	u32 l, bu, lu;
+	int pref_mem64;
 
 	/* Clear out the upper 32 bits of PREF limit.
 	   If PCI_PREF_BASE_UPPER32 was non-zero, this temporarily
@@ -219,10 +226,37 @@ static void pci_setup_bridge(struct pci_
 		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
 		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
 	}
+}
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

