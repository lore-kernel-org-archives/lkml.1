Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531Ab0AUE1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0AUE1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418Ab0AUE0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:26:46 -0500
Received: from kroah.org ([198.145.64.141]:60150 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab0AUEW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:22:59 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041834.949640153@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:40 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Stefan Bader <stefan.bader@canonical.com>
Subject: [19/30] PCI/cardbus: Add a fixup hook and fix powerpc
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 2d1c861871d767153538a77c498752b36d4bb4b8 upstream

The cardbus code creates PCI devices without ever going through the
necessary fixup bits and pieces that normal PCI devices go through.

There's in fact a commented out call to pcibios_fixup_bus() in there,
it's commented because ... it doesn't work.

I could make pcibios_fixup_bus() do the right thing on powerpc easily
but I felt it cleaner instead to provide a specific hook pci_fixup_cardbus
for which a weak empty implementation is provided by the PCI core.

This fixes cardbus on powerbooks and probably all other PowerPC
platforms which was broken completely for ever on some platforms and
since 2.6.31 on others such as PowerBooks when we made the DMA ops
mandatory (since those are setup by the fixups).

Acked-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/pci-common.c |   13 +++++++++++++
 drivers/pci/pci.c                |    5 +++++
 drivers/pcmcia/cardbus.c         |    2 +-
 include/linux/pci.h              |    3 +++
 4 files changed, 22 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/pci-common.c
+++ b/arch/powerpc/kernel/pci-common.c
@@ -1107,6 +1107,12 @@ void __devinit pcibios_setup_bus_devices
 	list_for_each_entry(dev, &bus->devices, bus_list) {
 		struct dev_archdata *sd = &dev->dev.archdata;
 
+		/* Cardbus can call us to add new devices to a bus, so ignore
+		 * those who are already fully discovered
+		 */
+		if (dev->is_added)
+			continue;
+
 		/* Setup OF node pointer in archdata */
 		sd->of_node = pci_device_to_OF_node(dev);
 
@@ -1147,6 +1153,13 @@ void __devinit pcibios_fixup_bus(struct 
 }
 EXPORT_SYMBOL(pcibios_fixup_bus);
 
+void __devinit pci_fixup_cardbus(struct pci_bus *bus)
+{
+	/* Now fixup devices on that bus */
+	pcibios_setup_bus_devices(bus);
+}
+
+
 static int skip_isa_ioresource_align(struct pci_dev *dev)
 {
 	if ((ppc_pci_flags & PPC_PCI_CAN_SKIP_ISA_ALIGN) &&
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2723,6 +2723,11 @@ int __attribute__ ((weak)) pci_ext_cfg_a
 	return 1;
 }
 
+void __weak pci_fixup_cardbus(struct pci_bus *bus)
+{
+}
+EXPORT_SYMBOL(pci_fixup_cardbus);
+
 static int __init pci_setup(char *str)
 {
 	while (str) {
--- a/drivers/pcmcia/cardbus.c
+++ b/drivers/pcmcia/cardbus.c
@@ -214,7 +214,7 @@ int __ref cb_alloc(struct pcmcia_socket 
 	unsigned int max, pass;
 
 	s->functions = pci_scan_slot(bus, PCI_DEVFN(0, 0));
-//	pcibios_fixup_bus(bus);
+	pci_fixup_cardbus(bus);
 
 	max = bus->secondary;
 	for (pass = 0; pass < 2; pass++)
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -564,6 +564,9 @@ void pcibios_align_resource(void *, stru
 				resource_size_t);
 void pcibios_update_irq(struct pci_dev *, int irq);
 
+/* Weak but can be overriden by arch */
+void pci_fixup_cardbus(struct pci_bus *);
+
 /* Generic PCI functions used internally */
 
 extern struct pci_bus *pci_find_bus(int domain, int busnr);


