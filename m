Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbYAMHY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbYAMHY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 02:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYAMHYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 02:24:19 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33682 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYAMHYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 02:24:17 -0500
Date: Sun, 13 Jan 2008 00:24:15 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>,
       Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080113072415.GB18741@parisc-linux.org>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <1200208085.6896.134.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200208085.6896.134.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 06:08:05PM +1100, Benjamin Herrenschmidt wrote:
> On Sat, 2008-01-12 at 17:40 +0300, Ivan Kokshaysky wrote:
> > Actually I'm strongly against Arjan's patch. First, it's based on
> > assumption that the MMCONFIG thing is sort of fundamentally broken
> > on some systems, but none of the facts we have so far does confirm
> > that.
> > And second, I really don't like the implementation as it breaks all
> > non-x86 arches (or forces them to add a set of totally meaningless
> > PCI functions).
> 
> I agree, I quite dislike it too. Even If the breakage on x86 makes us
> want to totally disable it there, it can be done within the existing PCI
> ops I believe.
> 
> I think Arjan's problem is to try to do it per-device since the
> "standard" PCI ops don't get a pci_dev structure (for obvious reasons).

Here's a patch (on top of Ivan's) to improve things further.

One of Arjan's big problems with Ivan's patch is the hardcoding of conf1
as the fallback.  So I took an idea from Arjan's patch, crossed it
with an idea of my own and came up with this.  It gets rid of the
raw_pci_ops as a generic idea, and makes it private to the x86 arch.
It also makes the whole select-which-ops private to the x86 arch without
touching the pci layer at all.

Only compile-tested on x86-64.

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 488e48a..ffaf02b 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -43,8 +43,7 @@
 #define PCI_SAL_EXT_ADDRESS(seg, bus, devfn, reg)	\
 	(((u64) seg << 28) | (bus << 20) | (devfn << 12) | (reg))
 
-static int
-pci_sal_read (unsigned int seg, unsigned int bus, unsigned int devfn,
+int raw_pci_read(unsigned int seg, unsigned int bus, unsigned int devfn,
 	      int reg, int len, u32 *value)
 {
 	u64 addr, data = 0;
@@ -68,8 +67,7 @@ pci_sal_read (unsigned int seg, unsigned int bus, unsigned int devfn,
 	return 0;
 }
 
-static int
-pci_sal_write (unsigned int seg, unsigned int bus, unsigned int devfn,
+int raw_pci_write(unsigned int seg, unsigned int bus, unsigned int devfn,
 	       int reg, int len, u32 value)
 {
 	u64 addr;
@@ -91,24 +89,17 @@ pci_sal_write (unsigned int seg, unsigned int bus, unsigned int devfn,
 	return 0;
 }
 
-static struct pci_raw_ops pci_sal_ops = {
-	.read =		pci_sal_read,
-	.write =	pci_sal_write
-};
-
-struct pci_raw_ops *raw_pci_ops = &pci_sal_ops;
-
-static int
-pci_read (struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
+static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
+							int size, u32 *value)
 {
-	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+	return raw_pci_read(pci_domain_nr(bus), bus->number,
 				 devfn, where, size, value);
 }
 
-static int
-pci_write (struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
+static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
+							int size, u32 value)
 {
-	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+	return raw_pci_write(pci_domain_nr(bus), bus->number,
 				  devfn, where, size, value);
 }
 
diff --git a/arch/ia64/sn/pci/tioce_provider.c b/arch/ia64/sn/pci/tioce_provider.c
index e1a3e19..f6df212 100644
--- a/arch/ia64/sn/pci/tioce_provider.c
+++ b/arch/ia64/sn/pci/tioce_provider.c
@@ -752,13 +752,13 @@ tioce_kern_init(struct tioce_common *tioce_common)
 	 * Determine the secondary bus number of the port2 logical PPB.
 	 * This is used to decide whether a given pci device resides on
 	 * port1 or port2.  Note:  We don't have enough plumbing set up
-	 * here to use pci_read_config_xxx() so use the raw_pci_ops vector.
+	 * here to use pci_read_config_xxx() so use raw_pci_read().
 	 */
 
 	seg = tioce_common->ce_pcibus.bs_persist_segment;
 	bus = tioce_common->ce_pcibus.bs_persist_busnum;
 
-	raw_pci_ops->read(seg, bus, PCI_DEVFN(2, 0), PCI_SECONDARY_BUS, 1,&tmp);
+	raw_pci_read(seg, bus, PCI_DEVFN(2, 0), PCI_SECONDARY_BUS, 1,&tmp);
 	tioce_kern->ce_port1_secondary = (u8) tmp;
 
 	/*
@@ -799,11 +799,11 @@ tioce_kern_init(struct tioce_common *tioce_common)
 
 		/* mem base/limit */
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_MEMORY_BASE, 2, &tmp);
 		base = (u64)tmp << 16;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_MEMORY_LIMIT, 2, &tmp);
 		limit = (u64)tmp << 16;
 		limit |= 0xfffffUL;
@@ -817,21 +817,21 @@ tioce_kern_init(struct tioce_common *tioce_common)
 		 * attributes.
 		 */
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_MEMORY_BASE, 2, &tmp);
 		base = ((u64)tmp & PCI_PREF_RANGE_MASK) << 16;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_BASE_UPPER32, 4, &tmp);
 		base |= (u64)tmp << 32;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_MEMORY_LIMIT, 2, &tmp);
 
 		limit = ((u64)tmp & PCI_PREF_RANGE_MASK) << 16;
 		limit |= 0xfffffUL;
 
-		raw_pci_ops->read(seg, bus, PCI_DEVFN(dev, 0),
+		raw_pci_read(seg, bus, PCI_DEVFN(dev, 0),
 				  PCI_PREF_LIMIT_UPPER32, 4, &tmp);
 		limit |= (u64)tmp << 32;
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index fab30e1..b92d2e6 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -27,7 +27,7 @@ static void __devinit quirk_intel_irqbalance(struct pci_dev *dev)
 	pci_write_config_byte(dev, 0xf4, config|0x2);
 
 	/* read xTPR register */
-	raw_pci_ops->read(0, 0, 0x40, 0x4c, 2, &word);
+	raw_pci_read(0, 0, 0x40, 0x4c, 2, &word);
 
 	if (!(word & (1 << 13))) {
 		printk(KERN_INFO "Intel E7520/7320/7525 detected. "
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 8627463..65a6c55 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -26,16 +26,37 @@ int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
+struct pci_raw_ops *raw_pci_ext_ops;
+
+int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 *val)
+{
+	if (reg < 256)
+		return raw_pci_ops->read(domain, bus, devfn, reg, len, val);
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->read(domain, bus, devfn, reg, len, val);
+	return -EINVAL;
+}
+
+int raw_pci_write(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 val)
+{
+	if (reg < 256)
+		return raw_pci_ops->write(domain, bus, devfn, reg, len, val);
+	if (raw_pci_ext_ops)
+		return raw_pci_ext_ops->write(domain, bus, devfn, reg, len, val);
+	return -EINVAL;
+}
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
-	return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+	return raw_pci_read(pci_domain_nr(bus), bus->number,
 				 devfn, where, size, value);
 }
 
 static int pci_write(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
 {
-	return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+	return raw_pci_write(pci_domain_nr(bus), bus->number,
 				  devfn, where, size, value);
 }
 
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 431c9a5..42f3e4c 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -14,7 +14,7 @@
 #define PCI_CONF1_ADDRESS(bus, devfn, reg) \
 	(0x80000000 | (bus << 16) | (devfn << 8) | (reg & ~3))
 
-int pci_conf1_read(unsigned int seg, unsigned int bus,
+static int pci_conf1_read(unsigned int seg, unsigned int bus,
 			  unsigned int devfn, int reg, int len, u32 *value)
 {
 	unsigned long flags;
@@ -45,7 +45,7 @@ int pci_conf1_read(unsigned int seg, unsigned int bus,
 	return 0;
 }
 
-int pci_conf1_write(unsigned int seg, unsigned int bus,
+static int pci_conf1_write(unsigned int seg, unsigned int bus,
 			   unsigned int devfn, int reg, int len, u32 value)
 {
 	unsigned long flags;
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 6cff66d..c222a1f 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -215,7 +215,8 @@ static int quirk_aspm_offset[MAX_PCIEROOT << 3];
 
 static int quirk_pcie_aspm_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
-	return raw_pci_ops->read(0, bus->number, devfn, where, size, value);
+	return raw_pci_read(pci_domain_nr(bus), bus->number,
+						devfn, where, size, value);
 }
 
 /*
@@ -231,7 +232,8 @@ static int quirk_pcie_aspm_write(struct pci_bus *bus, unsigned int devfn, int wh
 	if ((offset) && (where == offset))
 		value = value & 0xfffffffc;
 	
-	return raw_pci_ops->write(0, bus->number, devfn, where, size, value);
+	return raw_pci_write(pci_domain_nr(bus), bus->number,
+						devfn, where, size, value);
 }
 
 static struct pci_ops quirk_pcie_aspm_ops = {
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 5565d70..b008765 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -22,7 +22,7 @@ static void __devinit pcibios_fixup_peer_bridges(void)
 		if (pci_find_bus(0, n))
 			continue;
 		for (devfn = 0; devfn < 256; devfn += 8) {
-			if (!raw_pci_ops->read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
+			if (!raw_pci_read(0, n, devfn, PCI_VENDOR_ID, 2, &l) &&
 			    l != 0x0000 && l != 0xffff) {
 				DBG("Found device at %02x:%02x [%04x]\n", n, devfn, l);
 				printk(KERN_INFO "PCI: Discovered peer bus %02x\n", n);
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 6b521d3..8d54df4 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -28,7 +28,7 @@ static int __initdata pci_mmcfg_resources_inserted;
 static const char __init *pci_mmcfg_e7520(void)
 {
 	u32 win;
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
+	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0xce, 2, &win);
 
 	win = win & 0xf000;
 	if(win == 0x0000 || win == 0xf000)
@@ -53,7 +53,7 @@ static const char __init *pci_mmcfg_intel_945(void)
 
 	pci_mmcfg_config_num = 1;
 
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
+	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0x48, 4, &pciexbar);
 
 	/* Enable bit */
 	if (!(pciexbar & 1))
@@ -118,7 +118,7 @@ static int __init pci_mmcfg_check_hostbridge(void)
 	int i;
 	const char *name;
 
-	pci_conf1_read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
+	pci_direct_conf1.read(0, 0, PCI_DEVFN(0,0), 0, 4, &l);
 	vendor = l & 0xffff;
 	device = (l >> 16) & 0xffff;
 
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index 7b75e65..37a00fb 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -68,9 +68,6 @@ err:		*value = -1;
 		return -EINVAL;
 	}
 
-	if (reg < 256)
-		return pci_conf1_read(seg,bus,devfn,reg,len,value);
-
 	base = get_base_addr(seg, bus, devfn);
 	if (!base)
 		goto err;
@@ -104,9 +101,6 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if ((bus > 255) || (devfn > 255) || (reg > 4095))
 		return -EINVAL;
 
-	if (reg < 256)
-		return pci_conf1_write(seg,bus,devfn,reg,len,value);
-
 	base = get_base_addr(seg, bus, devfn);
 	if (!base)
 		return -EINVAL;
@@ -140,5 +134,6 @@ int __init pci_mmcfg_arch_init(void)
 {
 	printk(KERN_INFO "PCI: Using MMCONFIG\n");
 	raw_pci_ops = &pci_mmcfg;
+	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index c4cf318..6bf47e9 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -58,9 +58,6 @@ err:		*value = -1;
 		return -EINVAL;
 	}
 
-	if (reg < 256)
-		return pci_conf1_read(seg,bus,devfn,reg,len,value);
-
 	addr = pci_dev_base(seg, bus, devfn);
 	if (!addr)
 		goto err;
@@ -89,9 +86,6 @@ static int pci_mmcfg_write(unsigned int seg, unsigned int bus,
 	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
 		return -EINVAL;
 
-	if (reg < 256)
-		return pci_conf1_write(seg,bus,devfn,reg,len,value);
-
 	addr = pci_dev_base(seg, bus, devfn);
 	if (!addr)
 		return -EINVAL;
@@ -151,5 +145,6 @@ int __init pci_mmcfg_arch_init(void)
 		}
 	}
 	raw_pci_ops = &pci_mmcfg;
+	raw_pci_ext_ops = &pci_mmcfg;
 	return 1;
 }
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
index 36cb44c..3431518 100644
--- a/arch/x86/pci/pci.h
+++ b/arch/x86/pci/pci.h
@@ -85,10 +85,17 @@ extern spinlock_t pci_config_lock;
 extern int (*pcibios_enable_irq)(struct pci_dev *dev);
 extern void (*pcibios_disable_irq)(struct pci_dev *dev);
 
-extern int pci_conf1_write(unsigned int seg, unsigned int bus,
-			   unsigned int devfn, int reg, int len, u32 value);
-extern int pci_conf1_read(unsigned int seg, unsigned int bus,
-			  unsigned int devfn, int reg, int len, u32 *value);
+struct pci_raw_ops {
+	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 *val);
+	int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
+						int reg, int len, u32 val);
+};
+
+extern struct pci_raw_ops *raw_pci_ops;
+extern struct pci_raw_ops *raw_pci_ext_ops;
+
+extern struct pci_raw_ops pci_direct_conf1;
 
 extern int pci_direct_probe(void);
 extern void pci_direct_init(int type);
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 8ecb1c7..c2df4e9 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -13,9 +13,6 @@
 
 #include "pci.h"
 
-
-extern struct pci_raw_ops pci_direct_conf1;
-
 static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
 static void pci_visws_disable_irq(struct pci_dev *dev) { }
 
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e3a673a..ea68ef1 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -139,15 +139,6 @@ acpi_status __init acpi_os_initialize(void)
 
 acpi_status acpi_os_initialize1(void)
 {
-	/*
-	 * Initialize PCI configuration space access, as we'll need to access
-	 * it while walking the namespace (bus 0 and root bridges w/ _BBNs).
-	 */
-	if (!raw_pci_ops) {
-		printk(KERN_ERR PREFIX
-		       "Access to PCI configuration space unavailable\n");
-		return AE_NULL_ENTRY;
-	}
 	kacpid_wq = create_singlethread_workqueue("kacpid");
 	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
 	BUG_ON(!kacpid_wq);
@@ -498,11 +489,9 @@ acpi_os_read_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
 		return AE_ERROR;
 	}
 
-	BUG_ON(!raw_pci_ops);
-
-	result = raw_pci_ops->read(pci_id->segment, pci_id->bus,
-				   PCI_DEVFN(pci_id->device, pci_id->function),
-				   reg, size, value);
+	result = raw_pci_read(pci_id->segment, pci_id->bus,
+				PCI_DEVFN(pci_id->device, pci_id->function),
+				reg, size, value);
 
 	return (result ? AE_ERROR : AE_OK);
 }
@@ -529,11 +518,9 @@ acpi_os_write_pci_configuration(struct acpi_pci_id * pci_id, u32 reg,
 		return AE_ERROR;
 	}
 
-	BUG_ON(!raw_pci_ops);
-
-	result = raw_pci_ops->write(pci_id->segment, pci_id->bus,
-				    PCI_DEVFN(pci_id->device, pci_id->function),
-				    reg, size, value);
+	result = raw_pci_write(pci_id->segment, pci_id->bus,
+				PCI_DEVFN(pci_id->device, pci_id->function),
+				reg, size, value);
 
 	return (result ? AE_ERROR : AE_OK);
 }
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0dd93bb..75029d3 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -304,14 +304,14 @@ struct pci_ops {
 	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
 };
 
-struct pci_raw_ops {
-	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
-		    int reg, int len, u32 *val);
-	int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
-		     int reg, int len, u32 val);
-};
-
-extern struct pci_raw_ops *raw_pci_ops;
+/*
+ * ACPI needs to be able to access PCI config space before we've done a
+ * PCI bus scan and created pci_bus structures.
+ */
+extern int raw_pci_read(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 *val);
+extern int raw_pci_write(unsigned int domain, unsigned int bus,
+			unsigned int devfn, int reg, int len, u32 val);
 
 struct pci_bus_region {
 	unsigned long start;

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
