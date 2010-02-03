Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab0BCXjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:39:40 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:9462 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757940Ab0BCXjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:39:33 -0500
Subject: [PATCH v1 7/7] PCI: reference bridge window resources explicitly
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 03 Feb 2010 16:39:31 -0700
Message-ID: <20100203233931.10803.39854.stgit@bob.kio>
In-Reply-To: <20100203233617.10803.92102.stgit@bob.kio>
References: <20100203233617.10803.92102.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; just be more explicit about this mapping for
bridge resources:

  bridge->res[PCI_BRIDGE_RESOURCES+0]: I/O window (or CB I/O 0 window)
  bridge->res[PCI_BRIDGE_RESOURCES+1]: mem window (or CB I/O 1 window)
  bridge->res[PCI_BRIDGE_RESOURCES+2]: pref mem window (or CB mem 0 window)
  bridge->res[PCI_BRIDGE_RESOURCES+3]: CB mem 1 window

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/probe.c           |    6 ++--
 drivers/pci/quirks.c          |    4 +--
 drivers/pci/setup-bus.c       |   55 +++++++++++++++++++++++------------------
 drivers/pcmcia/yenta_socket.c |   39 +++++++++++++++++------------
 include/linux/pci.h           |   11 +++++++-
 5 files changed, 69 insertions(+), 46 deletions(-)


diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index b2d2e1e..1d8aa11 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -289,7 +289,7 @@ static void __devinit pci_read_bridge_io(struct pci_bus *child)
 	unsigned long base, limit;
 	struct resource *res;
 
-	res = &dev->resource[PCI_BRIDGE_RESOURCES + 0];
+	res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
 
 	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
 	pci_read_config_byte(dev, PCI_IO_LIMIT, &io_limit_lo);
@@ -321,7 +321,7 @@ static void __devinit pci_read_bridge_mmio(struct pci_bus *child)
 	unsigned long base, limit;
 	struct resource *res;
 
-	res = &dev->resource[PCI_BRIDGE_RESOURCES + 1];
+	res = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
 
 	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_MEMORY_LIMIT, &mem_limit_lo);
@@ -342,7 +342,7 @@ static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
 	unsigned long base, limit;
 	struct resource *res;
 
-	res = &dev->resource[PCI_BRIDGE_RESOURCES + 2];
+	res = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
 
 	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
 	pci_read_config_word(dev, PCI_PREF_MEMORY_LIMIT, &mem_limit_lo);
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 213acf6..d6f76cb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1890,7 +1890,7 @@ static void __devinit quirk_p64h2_1k_io(struct pci_dev *dev)
 	u16 en1k;
 	u8 io_base_lo, io_limit_lo;
 	unsigned long base, limit;
-	struct resource *res = dev->resource + PCI_BRIDGE_RESOURCES;
+	struct resource *res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
 
 	pci_read_config_word(dev, 0x40, &en1k);
 
@@ -1917,7 +1917,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL,	0x1460,		quirk_p64h2_1k_io);
 static void __devinit quirk_p64h2_1k_io_fix_iobl(struct pci_dev *dev)
 {
 	u16 en1k, iobl_adr, iobl_adr_1k;
-	struct resource *res = dev->resource + PCI_BRIDGE_RESOURCES;
+	struct resource *res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
 
 	pci_read_config_word(dev, 0x40, &en1k);
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 1dbff3a..72ff801 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -257,8 +257,7 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
 	struct pci_dev *bridge = bus->self;
 	struct resource *b_res;
 
-	b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
-	b_res[1].flags |= IORESOURCE_MEM;
+	bridge->resource[PCI_BRIDGE_MEM_WINDOW].flags |= IORESOURCE_MEM;
 
 	pci_read_config_word(bridge, PCI_IO_BASE, &io);
 	if (!io) {
@@ -267,12 +266,15 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
  		pci_write_config_word(bridge, PCI_IO_BASE, 0x0);
  	}
  	if (io)
-		b_res[0].flags |= IORESOURCE_IO;
+		bridge->resource[PCI_BRIDGE_IO_WINDOW].flags |= IORESOURCE_IO;
+
 	/*  DECchip 21050 pass 2 errata: the bridge may miss an address
 	    disconnect boundary by one PCI data phase.
 	    Workaround: do not use prefetching on this device. */
 	if (bridge->vendor == PCI_VENDOR_ID_DEC && bridge->device == 0x0001)
 		return;
+
+	b_res = &bridge->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
 	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &pmem);
 	if (!pmem) {
 		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE,
@@ -281,13 +283,13 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
 		pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, 0x0);
 	}
 	if (pmem) {
-		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
+		b_res->flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		if ((pmem & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64)
-			b_res[2].flags |= IORESOURCE_MEM_64;
+			b_res->flags |= IORESOURCE_MEM_64;
 	}
 
 	/* double check if bridge does support 64 bit pref */
-	if (b_res[2].flags & IORESOURCE_MEM_64) {
+	if (b_res->flags & IORESOURCE_MEM_64) {
 		u32 mem_base_hi, tmp;
 		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32,
 					 &mem_base_hi);
@@ -295,7 +297,7 @@ static void pci_bridge_check_ranges(struct pci_bus *bus)
 					       0xffffffff);
 		pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &tmp);
 		if (!tmp)
-			b_res[2].flags &= ~IORESOURCE_MEM_64;
+			b_res->flags &= ~IORESOURCE_MEM_64;
 		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32,
 				       mem_base_hi);
 	}
@@ -464,20 +466,22 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 static void pci_bus_size_cardbus(struct pci_bus *bus)
 {
 	struct pci_dev *bridge = bus->self;
-	struct resource *b_res = &bridge->resource[PCI_BRIDGE_RESOURCES];
+	struct resource *b_res;
 	u16 ctrl;
 
 	/*
 	 * Reserve some resources for CardBus.  We reserve
 	 * a fixed amount of bus space for CardBus bridges.
 	 */
-	b_res[0].start = 0;
-	b_res[0].end = pci_cardbus_io_size - 1;
-	b_res[0].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
+	b_res = &bridge->resource[PCI_CB_BRIDGE_IO_0_WINDOW];
+	b_res->start = 0;
+	b_res->end = pci_cardbus_io_size - 1;
+	b_res->flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
 
-	b_res[1].start = 0;
-	b_res[1].end = pci_cardbus_io_size - 1;
-	b_res[1].flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
+	b_res = &bridge->resource[PCI_CB_BRIDGE_IO_1_WINDOW];
+	b_res->start = 0;
+	b_res->end = pci_cardbus_io_size - 1;
+	b_res->flags |= IORESOURCE_IO | IORESOURCE_SIZEALIGN;
 
 	/*
 	 * Check whether prefetchable memory is supported
@@ -496,17 +500,20 @@ static void pci_bus_size_cardbus(struct pci_bus *bus)
 	 * twice the size.
 	 */
 	if (ctrl & PCI_CB_BRIDGE_CTL_PREFETCH_MEM0) {
-		b_res[2].start = 0;
-		b_res[2].end = pci_cardbus_mem_size - 1;
-		b_res[2].flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
-
-		b_res[3].start = 0;
-		b_res[3].end = pci_cardbus_mem_size - 1;
-		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
+		b_res = &bridge->resource[PCI_CB_BRIDGE_MEM_0_WINDOW];
+		b_res->start = 0;
+		b_res->end = pci_cardbus_mem_size - 1;
+		b_res->flags |= IORESOURCE_MEM | IORESOURCE_PREFETCH | IORESOURCE_SIZEALIGN;
+
+		b_res = &bridge->resource[PCI_CB_BRIDGE_MEM_1_WINDOW];
+		b_res->start = 0;
+		b_res->end = pci_cardbus_mem_size - 1;
+		b_res->flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
 	} else {
-		b_res[3].start = 0;
-		b_res[3].end = pci_cardbus_mem_size * 2 - 1;
-		b_res[3].flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
+		b_res = &bridge->resource[PCI_CB_BRIDGE_MEM_1_WINDOW];
+		b_res->start = 0;
+		b_res->end = pci_cardbus_mem_size * 2 - 1;
+		b_res->flags |= IORESOURCE_MEM | IORESOURCE_SIZEALIGN;
 	}
 }
 
diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 9c5a80e..dc55592 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -673,7 +673,7 @@ static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type
 	struct pci_bus_region region;
 	unsigned mask;
 
-	res = dev->resource + PCI_BRIDGE_RESOURCES + nr;
+	res = &dev->resource[nr];
 	/* Already allocated? */
 	if (res->parent)
 		return 0;
@@ -690,7 +690,7 @@ static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type
 	region.end = config_readl(socket, addr_end) | ~mask;
 	if (region.start && region.end > region.start && !override_bios) {
 		pcibios_bus_to_resource(dev, res, &region);
-		if (pci_claim_resource(dev, PCI_BRIDGE_RESOURCES + nr) == 0)
+		if (pci_claim_resource(dev, nr) == 0)
 			return 0;
 		dev_printk(KERN_INFO, &dev->dev,
 			   "Preassigned resource %d busy or not available, "
@@ -731,32 +731,39 @@ static int yenta_allocate_res(struct yenta_socket *socket, int nr, unsigned type
 static void yenta_allocate_resources(struct yenta_socket *socket)
 {
 	int program = 0;
-	program += yenta_allocate_res(socket, 0, IORESOURCE_IO,
-			   PCI_CB_IO_BASE_0, PCI_CB_IO_LIMIT_0);
-	program += yenta_allocate_res(socket, 1, IORESOURCE_IO,
-			   PCI_CB_IO_BASE_1, PCI_CB_IO_LIMIT_1);
-	program += yenta_allocate_res(socket, 2, IORESOURCE_MEM|IORESOURCE_PREFETCH,
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_IO_0_WINDOW,
+			   IORESOURCE_IO, PCI_CB_IO_BASE_0, PCI_CB_IO_LIMIT_0);
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_IO_1_WINDOW,
+			   IORESOURCE_IO, PCI_CB_IO_BASE_1, PCI_CB_IO_LIMIT_1);
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_MEM_0_WINDOW,
+			   IORESOURCE_MEM|IORESOURCE_PREFETCH,
 			   PCI_CB_MEMORY_BASE_0, PCI_CB_MEMORY_LIMIT_0);
-	program += yenta_allocate_res(socket, 3, IORESOURCE_MEM,
+	program += yenta_allocate_res(socket, PCI_CB_BRIDGE_MEM_1_WINDOW,
+			   IORESOURCE_MEM,
 			   PCI_CB_MEMORY_BASE_1, PCI_CB_MEMORY_LIMIT_1);
 	if (program)
 		pci_setup_cardbus(socket->dev->subordinate);
 }
 
+static void yenta_free_resource(struct yenta_socket *socket, int nr)
+{
+	struct resource *res;
+
+	res = &socket->dev->resource[nr];
+	if (res->start != 0 && res->end != 0)
+		release_resource(res);
+	res->start = res->end = res->flags = 0;
+}
 
 /*
  * Free the bridge mappings for the device..
  */
 static void yenta_free_resources(struct yenta_socket *socket)
 {
-	int i;
-	for (i = 0; i < 4; i++) {
-		struct resource *res;
-		res = socket->dev->resource + PCI_BRIDGE_RESOURCES + i;
-		if (res->start != 0 && res->end != 0)
-			release_resource(res);
-		res->start = res->end = res->flags = 0;
-	}
+	yenta_free_resource(socket, PCI_CB_BRIDGE_IO_0_WINDOW);
+	yenta_free_resource(socket, PCI_CB_BRIDGE_IO_1_WINDOW);
+	yenta_free_resource(socket, PCI_CB_BRIDGE_MEM_0_WINDOW);
+	yenta_free_resource(socket, PCI_CB_BRIDGE_MEM_1_WINDOW);
 }
 
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 36743ee..123e92b 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -101,7 +101,16 @@ enum {
 #endif
 
 	/* resources assigned to buses behind the bridge */
-#define PCI_BRIDGE_RESOURCE_NUM 4
+#define PCI_BRIDGE_IO_WINDOW		(PCI_BRIDGE_RESOURCES + 0)
+#define PCI_BRIDGE_MEM_WINDOW		(PCI_BRIDGE_RESOURCES + 1)
+#define PCI_BRIDGE_PREF_MEM_WINDOW	(PCI_BRIDGE_RESOURCES + 2)
+
+#define PCI_CB_BRIDGE_IO_0_WINDOW	(PCI_BRIDGE_RESOURCES + 0)
+#define PCI_CB_BRIDGE_IO_1_WINDOW	(PCI_BRIDGE_RESOURCES + 1)
+#define PCI_CB_BRIDGE_MEM_0_WINDOW	(PCI_BRIDGE_RESOURCES + 2)
+#define PCI_CB_BRIDGE_MEM_1_WINDOW	(PCI_BRIDGE_RESOURCES + 3)
+
+#define PCI_BRIDGE_RESOURCE_NUM 4	/* max of P2P, cardbus */
 
 	PCI_BRIDGE_RESOURCES,
 	PCI_BRIDGE_RESOURCE_END = PCI_BRIDGE_RESOURCES +

