Return-Path: <linux-kernel-owner+w=401wt.eu-S1754413AbYFCNXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413AbYFCNXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751999AbYFCNW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:22:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49036
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbYFCNW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:22:56 -0400
Date: Tue, 03 Jun 2008 06:22:53 -0700 (PDT)
Message-Id: <20080603.062253.17158135.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 broke X on SPARC Ultra5
From: David Miller <davem@davemloft.net>
In-Reply-To: <18500.62552.958244.633204@harpo.it.uu.se>
References: <18500.62552.958244.633204@harpo.it.uu.se>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Tue, 3 Jun 2008 09:35:52 +0200

> Fatal server error:
> xf86MapPciMem: Could not mmap PCI memory [base=0xe2000000,hostbase=0xe2000000,size=2000] (No such file or directory)
> 
> I'll start digging through 2.6.25->2.6.26-rc1 later today,
> meanwhile I've put Xorg.0.log, Xorg strace, dmesg, and .config
> files for 2.6.25 (working) and 2.6.26-rc4 (failing) in
> <http://user.it.uu.se/~mikpe/linux/sparc64-2.6.26-rcN-xorg-bug/>.

It's likely this change below.  Unfortunately older versions of X
seemingly cannot cope with a lack of PCI host controller in the PCI
hierarchy exported by the kernel.

That's really a bug in X, current libpciaccess based X servers work
fine, and the bug fixed by this changeset is not solvable in any other
reasonable way.  So unfortunately older X verions will stay not
working.  Sorry.

commit c26d3c0138970778fabe114df99dffb34a04b1d7
Author: David S. Miller <davem@davemloft.net>
Date:   Thu May 1 01:12:40 2008 -0700

    sparc64: Stop creating dummy root PCI host controller devices.
    
    It just creates confusion, errors, and bugs.
    
    For one thing, this can cause dup sysfs or procfs nodes to get
    created:
    
    [    1.198015] proc_dir_entry '00.0' already registered
    [    1.198036] Call Trace:
    [    1.198052]  [00000000004f2534] create_proc_entry+0x7c/0x98
    [    1.198092]  [00000000005719e4] pci_proc_attach_device+0xa4/0xd4
    [    1.198126]  [00000000007d991c] pci_proc_init+0x64/0x88
    [    1.198158]  [00000000007c62a4] kernel_init+0x190/0x330
    [    1.198183]  [0000000000426cf8] kernel_thread+0x38/0x48
    [    1.198210]  [00000000006a0d90] rest_init+0x18/0x5c
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/arch/sparc64/kernel/pci.c b/arch/sparc64/kernel/pci.c
index dbf2fc2..112b09f 100644
--- a/arch/sparc64/kernel/pci.c
+++ b/arch/sparc64/kernel/pci.c
@@ -350,8 +350,7 @@ static void pci_parse_of_addrs(struct of_device *op,
 
 struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 				  struct device_node *node,
-				  struct pci_bus *bus, int devfn,
-				  int host_controller)
+				  struct pci_bus *bus, int devfn)
 {
 	struct dev_archdata *sd;
 	struct pci_dev *dev;
@@ -390,43 +389,28 @@ struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	dev->devfn = devfn;
 	dev->multifunction = 0;		/* maybe a lie? */
 
-	if (host_controller) {
-		if (tlb_type != hypervisor) {
-			pci_read_config_word(dev, PCI_VENDOR_ID,
-					     &dev->vendor);
-			pci_read_config_word(dev, PCI_DEVICE_ID,
-					     &dev->device);
-		} else {
-			dev->vendor = PCI_VENDOR_ID_SUN;
-			dev->device = 0x80f0;
-		}
-		dev->cfg_size = 256;
-		dev->class = PCI_CLASS_BRIDGE_HOST << 8;
-		sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
-			0x00, PCI_SLOT(devfn), PCI_FUNC(devfn));
-	} else {
-		dev->vendor = of_getintprop_default(node, "vendor-id", 0xffff);
-		dev->device = of_getintprop_default(node, "device-id", 0xffff);
-		dev->subsystem_vendor =
-			of_getintprop_default(node, "subsystem-vendor-id", 0);
-		dev->subsystem_device =
-			of_getintprop_default(node, "subsystem-id", 0);
-
-		dev->cfg_size = pci_cfg_space_size(dev);
-
-		/* We can't actually use the firmware value, we have
-		 * to read what is in the register right now.  One
-		 * reason is that in the case of IDE interfaces the
-		 * firmware can sample the value before the the IDE
-		 * interface is programmed into native mode.
-		 */
-		pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
-		dev->class = class >> 8;
-		dev->revision = class & 0xff;
+	dev->vendor = of_getintprop_default(node, "vendor-id", 0xffff);
+	dev->device = of_getintprop_default(node, "device-id", 0xffff);
+	dev->subsystem_vendor =
+		of_getintprop_default(node, "subsystem-vendor-id", 0);
+	dev->subsystem_device =
+		of_getintprop_default(node, "subsystem-id", 0);
+
+	dev->cfg_size = pci_cfg_space_size(dev);
+
+	/* We can't actually use the firmware value, we have
+	 * to read what is in the register right now.  One
+	 * reason is that in the case of IDE interfaces the
+	 * firmware can sample the value before the the IDE
+	 * interface is programmed into native mode.
+	 */
+	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
+	dev->class = class >> 8;
+	dev->revision = class & 0xff;
+
+	sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
+		dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
-		sprintf(pci_name(dev), "%04x:%02x:%02x.%d", pci_domain_nr(bus),
-			dev->bus->number, PCI_SLOT(devfn), PCI_FUNC(devfn));
-	}
 	if (ofpci_verbose)
 		printk("    class: 0x%x device name: %s\n",
 		       dev->class, pci_name(dev));
@@ -441,26 +425,21 @@ struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	dev->current_state = 4;		/* unknown power state */
 	dev->error_state = pci_channel_io_normal;
 
-	if (host_controller) {
+	if (!strcmp(type, "pci") || !strcmp(type, "pciex")) {
+		/* a PCI-PCI bridge */
 		dev->hdr_type = PCI_HEADER_TYPE_BRIDGE;
 		dev->rom_base_reg = PCI_ROM_ADDRESS1;
-		dev->irq = PCI_IRQ_NONE;
+	} else if (!strcmp(type, "cardbus")) {
+		dev->hdr_type = PCI_HEADER_TYPE_CARDBUS;
 	} else {
-		if (!strcmp(type, "pci") || !strcmp(type, "pciex")) {
-			/* a PCI-PCI bridge */
-			dev->hdr_type = PCI_HEADER_TYPE_BRIDGE;
-			dev->rom_base_reg = PCI_ROM_ADDRESS1;
-		} else if (!strcmp(type, "cardbus")) {
-			dev->hdr_type = PCI_HEADER_TYPE_CARDBUS;
-		} else {
-			dev->hdr_type = PCI_HEADER_TYPE_NORMAL;
-			dev->rom_base_reg = PCI_ROM_ADDRESS;
+		dev->hdr_type = PCI_HEADER_TYPE_NORMAL;
+		dev->rom_base_reg = PCI_ROM_ADDRESS;
 
-			dev->irq = sd->op->irqs[0];
-			if (dev->irq == 0xffffffff)
-				dev->irq = PCI_IRQ_NONE;
-		}
+		dev->irq = sd->op->irqs[0];
+		if (dev->irq == 0xffffffff)
+			dev->irq = PCI_IRQ_NONE;
 	}
+
 	pci_parse_of_addrs(sd->op, node, dev);
 
 	if (ofpci_verbose)
@@ -749,7 +728,7 @@ static void __devinit pci_of_scan_bus(struct pci_pbm_info *pbm,
 		prev_devfn = devfn;
 
 		/* create a new pci_dev for this device */
-		dev = of_create_pci_dev(pbm, child, bus, devfn, 0);
+		dev = of_create_pci_dev(pbm, child, bus, devfn);
 		if (!dev)
 			continue;
 		if (ofpci_verbose)
@@ -796,48 +775,9 @@ static void __devinit pci_bus_register_of_sysfs(struct pci_bus *bus)
 		pci_bus_register_of_sysfs(child_bus);
 }
 
-int pci_host_bridge_read_pci_cfg(struct pci_bus *bus_dev,
-				 unsigned int devfn,
-				 int where, int size,
-				 u32 *value)
-{
-	static u8 fake_pci_config[] = {
-		0x8e, 0x10, /* Vendor: 0x108e (Sun) */
-		0xf0, 0x80, /* Device: 0x80f0 (Fire) */
-		0x46, 0x01, /* Command: 0x0146 (SERR, PARITY, MASTER, MEM) */
-		0xa0, 0x22, /* Status: 0x02a0 (DEVSEL_MED, FB2B, 66MHZ) */
-		0x00, 0x00, 0x00, 0x06, /* Class: 0x06000000 host bridge */
-		0x00, /* Cacheline: 0x00 */
-		0x40, /* Latency: 0x40 */
-		0x00, /* Header-Type: 0x00 normal */
-	};
-
-	*value = 0;
-	if (where >= 0 && where < sizeof(fake_pci_config) &&
-	    (where + size) >= 0 &&
-	    (where + size) < sizeof(fake_pci_config) &&
-	    size <= sizeof(u32)) {
-		while (size--) {
-			*value <<= 8;
-			*value |= fake_pci_config[where + size];
-		}
-	}
-
-	return PCIBIOS_SUCCESSFUL;
-}
-
-int pci_host_bridge_write_pci_cfg(struct pci_bus *bus_dev,
-				  unsigned int devfn,
-				  int where, int size,
-				  u32 value)
-{
-	return PCIBIOS_SUCCESSFUL;
-}
-
 struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm)
 {
 	struct device_node *node = pbm->prom_node;
-	struct pci_dev *host_pdev;
 	struct pci_bus *bus;
 
 	printk("PCI: Scanning PBM %s\n", node->full_name);
@@ -855,10 +795,6 @@ struct pci_bus * __devinit pci_scan_one_pbm(struct pci_pbm_info *pbm)
 	bus->resource[0] = &pbm->io_space;
 	bus->resource[1] = &pbm->mem_space;
 
-	/* Create the dummy host bridge and link it in.  */
-	host_pdev = of_create_pci_dev(pbm, node, bus, 0x00, 1);
-	bus->self = host_pdev;
-
 	pci_of_scan_bus(pbm, node, bus);
 	pci_bus_add_devices(bus);
 	pci_bus_register_of_sysfs(bus);
diff --git a/arch/sparc64/kernel/pci_common.c b/arch/sparc64/kernel/pci_common.c
index 923e0bc..19fa621 100644
--- a/arch/sparc64/kernel/pci_common.c
+++ b/arch/sparc64/kernel/pci_common.c
@@ -264,9 +264,6 @@ static int sun4v_read_pci_cfg(struct pci_bus *bus_dev, unsigned int devfn,
 	unsigned int func = PCI_FUNC(devfn);
 	unsigned long ret;
 
-	if (!bus && devfn == 0x00)
-		return pci_host_bridge_read_pci_cfg(bus_dev, devfn, where,
-						    size, value);
 	if (config_out_of_range(pbm, bus, devfn, where)) {
 		ret = ~0UL;
 	} else {
@@ -300,9 +297,6 @@ static int sun4v_write_pci_cfg(struct pci_bus *bus_dev, unsigned int devfn,
 	unsigned int func = PCI_FUNC(devfn);
 	unsigned long ret;
 
-	if (!bus && devfn == 0x00)
-		return pci_host_bridge_write_pci_cfg(bus_dev, devfn, where,
-						     size, value);
 	if (config_out_of_range(pbm, bus, devfn, where)) {
 		/* Do nothing. */
 	} else {
diff --git a/arch/sparc64/kernel/pci_impl.h b/arch/sparc64/kernel/pci_impl.h
index 218bac4..c385d12 100644
--- a/arch/sparc64/kernel/pci_impl.h
+++ b/arch/sparc64/kernel/pci_impl.h
@@ -167,15 +167,6 @@ extern void pci_get_pbm_props(struct pci_pbm_info *pbm);
 extern struct pci_bus *pci_scan_one_pbm(struct pci_pbm_info *pbm);
 extern void pci_determine_mem_io_space(struct pci_pbm_info *pbm);
 
-extern int pci_host_bridge_read_pci_cfg(struct pci_bus *bus_dev,
-					unsigned int devfn,
-					int where, int size,
-					u32 *value);
-extern int pci_host_bridge_write_pci_cfg(struct pci_bus *bus_dev,
-					 unsigned int devfn,
-					 int where, int size,
-					 u32 value);
-
 /* Error reporting support. */
 extern void pci_scan_for_target_abort(struct pci_pbm_info *, struct pci_bus *);
 extern void pci_scan_for_master_abort(struct pci_pbm_info *, struct pci_bus *);
