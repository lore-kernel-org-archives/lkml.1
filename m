Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0BCXjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 18:39:17 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:25537 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab0BCXjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 18:39:13 -0500
Subject: [PATCH v1 3/7] PCI: split up pci_read_bridge_bases()
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Tony Luck <tony.luck@intel.com>,
       linux-pci@vger.kernel.org, Peter Haight <peterh@sapros.com>,
       Gary Hade <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>
Date: Wed, 03 Feb 2010 16:39:11 -0700
Message-ID: <20100203233910.10803.74241.stgit@bob.kio>
In-Reply-To: <20100203233617.10803.92102.stgit@bob.kio>
References: <20100203233617.10803.92102.stgit@bob.kio>
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
index 7264ad4..1d498cd 100644
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
@@ -324,6 +310,14 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 			res->end = limit + 0xfff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
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
@@ -336,6 +330,14 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
 		res->end = limit + 0xfffff;
 		dev_printk(KERN_DEBUG, &dev->dev, "  bridge window %pR\n", res);
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
@@ -377,6 +379,28 @@ void __devinit pci_read_bridge_bases(struct pci_bus *child)
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

