Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0BHWpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 17:45:53 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:30350 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab0BHWof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 17:44:35 -0500
Subject: [PATCH v2 3/7] PCI: split up pci_read_bridge_bases()
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 08 Feb 2010 15:44:33 -0700
Message-ID: <20100208224433.27954.26233.stgit@bob.kio>
In-Reply-To: <20100208224236.27954.4358.stgit@bob.kio>
References: <20100208224236.27954.4358.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No functional change; this breaks up pci_read_bridge_bases() into separate
pieces for the I/O, memory, and prefetchable memory windows, similar to how
Yinghai recently split up pci_setup_bridge() in 68e84ff3bdc.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/pci/probe.c |   54 +++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 39 insertions(+), 15 deletions(-)


diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 8d3df71..8c94650 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -281,26 +281,12 @@ static void pci_read_bases(struct pci_dev *dev, unsigned int howmany, int rom)
 	}
 }
 
-void __devinit pci_read_bridge_bases(struct pci_bus *child)
+static void __devinit pci_read_bridge_io(struct pci_bus *child)
 {
 	struct pci_dev *dev = child->self;
 	u8 io_base_lo, io_limit_lo;
-	u16 mem_base_lo, mem_limit_lo;
 	unsigned long base, limit;
 	struct resource *res;
-	int i;
-
-	if (pci_is_root_bus(child))	/* It's a host bus, nothing to read */
-		return;
-
-	dev_info(&dev->dev, "PCI bridge to [bus %02x-%02x]%s\n",
-		 child->secondary, child->subordinate,
-		 dev->transparent ? " (subtractive decode)": "");
-
-	if (dev->transparent) {
-		for(i = 3; i < PCI_BUS_NUM_RESOURCES; i++)
-			child->resource[i] = child->parent->resource[i - 3];
-	}
 
 	res = child->resource[0];
 	pci_read_config_byte(dev, PCI_IO_BASE, &io_base_lo);
@@ -328,6 +314,14 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			 "  bridge window [io  %#06lx-%#06lx] (disabled)\n",
 				 base, limit);
 	}
+}
+
+static void __devinit pci_read_bridge_mmio(struct pci_bus *child)
+{
+	struct pci_dev *dev = child->self;
+	u16 mem_base_lo, mem_limit_lo;
+	unsigned long base, limit;
+	struct resource *res;
 
 	res = child->resource[1];
 	pci_read_config_word(dev, PCI_MEMORY_BASE, &mem_base_lo);
@@ -344,6 +338,14 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			"  bridge window [mem %#010lx-%#010lx] (disabled)\n",
 					 base, limit + 0xfffff);
 	}
+}
+
+static void __devinit pci_read_bridge_mmio_pref(struct pci_bus *child)
+{
+	struct pci_dev *dev = child->self;
+	u16 mem_base_lo, mem_limit_lo;
+	unsigned long base, limit;
+	struct resource *res;
 
 	res = child->resource[2];
 	pci_read_config_word(dev, PCI_PREF_MEMORY_BASE, &mem_base_lo);
@@ -389,6 +391,28 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 	}
 }
 
+void __devinit pci_read_bridge_bases(struct pci_bus *child)
+{
+	struct pci_dev *dev = child->self;
+	int i;
+
+	if (pci_is_root_bus(child))	/* It's a host bus, nothing to read */
+		return;
+
+	dev_info(&dev->dev, "PCI bridge to [bus %02x-%02x]%s\n",
+		 child->secondary, child->subordinate,
+		 dev->transparent ? " (subtractive decode)": "");
+
+	if (dev->transparent) {
+		for(i = 3; i < PCI_BUS_NUM_RESOURCES; i++)
+			child->resource[i] = child->parent->resource[i - 3];
+	}
+
+	pci_read_bridge_io(child);
+	pci_read_bridge_mmio(child);
+	pci_read_bridge_mmio_pref(child);
+}
+
 static struct pci_bus * pci_alloc_bus(void)
 {
 	struct pci_bus *b;

