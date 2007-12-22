Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbXLVMcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbXLVMcu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 07:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbXLVMcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 07:32:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58653 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLVMck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 07:32:40 -0500
Date: Sat, 22 Dec 2007 04:31:39 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz
Subject: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
Message-ID: <20071222043139.0cd59804@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus really wants the extended (4Kb) PCI configuration space (using MCFG acpi table etc) to be opt-in, since there's many issues with it and most drivers don't even use/need it. The idea behind opt-in is that if you don't use it, you don't get to suffer the bugs...

Booted on my 64 bit test machine; sadly it has a defunct BIOS that doesn't have a working MCFG.


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Make MMCONFIG space a driver opt-in

There are many issues with using the extended PCI configuration space 
(CPU, Chipset and most of all BIOS bugs). This while the vast majority of drivers
and devices don't even use/need to use the memory mapped access methods since they
don't use the config space beyond the traditional 256 bytes.

This patch makes accessing the extended config space a driver choice, via the

pci_enable_ext_config(pdev)

API function; drivers that want/need the extended configuration space should call this.
(a separate patch will be posted to add this function call to the driver that uses this)


On the implementation side, the pci device structure grows a member variable that sets the
current mode (default is "off", pci_enable_ext_config() turns it on; but quirks can force it off 
so that even pci_enable_ext_config() won't enable it).
Unfortunately, this meant duplicating a bit of the PCI infrastructure since in the PCI layer, all the
config access stuff is based on bus, not device. The implementation basically expands the bus operations
to have 2 new operations, for reading/writing extended space. The pci_read_config_byte() and co functions
now check the flag in the pdev structure, and use either the traditional or the extended bus operation methods.

This lead to a tiny bit of duplication in code, but it's not all that bad, and imo greatly offsets all the 
pain we have with extended configuration space.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>



Index: linux-2.6.24-rc5/arch/x86/pci/common.c
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/pci/common.c
+++ linux-2.6.24-rc5/arch/x86/pci/common.c
@@ -26,6 +26,7 @@ int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
+struct pci_raw_ops *raw_pci_ops_extcfg;
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
 {
@@ -39,9 +40,31 @@ static int pci_write(struct pci_bus *bus
 				  devfn, where, size, value);
 }
 
+static int pci_read_ext(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *value)
+{
+	if (raw_pci_ops_extcfg)
+		return raw_pci_ops_extcfg->read(pci_domain_nr(bus), bus->number,
+				 devfn, where, size, value);
+	else
+		return raw_pci_ops->read(pci_domain_nr(bus), bus->number,
+				 devfn, where, size, value);
+}
+
+static int pci_write_ext(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 value)
+{
+	if (raw_pci_ops_extcfg)
+		return raw_pci_ops_extcfg->write(pci_domain_nr(bus), bus->number,
+				  devfn, where, size, value);
+	else
+		return raw_pci_ops->write(pci_domain_nr(bus), bus->number,
+				  devfn, where, size, value);
+}
+
 struct pci_ops pci_root_ops = {
 	.read = pci_read,
 	.write = pci_write,
+	.readext = pci_read_ext,
+	.writeext = pci_write_ext,
 };
 
 /*
Index: linux-2.6.24-rc5/drivers/pci/pci.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/pci/pci.c
+++ linux-2.6.24-rc5/drivers/pci/pci.c
@@ -752,6 +752,27 @@ int pci_enable_device(struct pci_dev *de
 	return pci_enable_device_bars(dev, (1 << PCI_NUM_RESOURCES) - 1);
 }
 
+/**
+ * pci_enable_ext_config - Enable extended (4K) config space accesses
+ * @dev: PCI device to be changed
+ *
+ *  Enable extended (4Kb) configuration space accesses for a device.
+ *  Extended config space is available for PCI-E devices and can
+ *  be used for things like PCI AER and other features. However,
+ *  due to various stability issues, this can only be done on demand.
+ *
+ * Returns: -1 on failure, 0 on success
+ */
+
+int pci_enable_ext_config(struct pci_dev *dev)
+{
+	if (dev->ext_cfg_space < 0)
+		return -1;
+	dev->ext_cfg_space = 1;
+	return 1;
+}
+EXPORT_SYMBOL_GPL(pci_enable_ext_config);
+
 /*
  * Managed PCI resources.  This manages device on/off, intx/msi/msix
  * on/off and BAR regions.  pci_dev itself records msi/msix status, so
Index: linux-2.6.24-rc5/include/linux/pci.h
===================================================================
--- linux-2.6.24-rc5.orig/include/linux/pci.h
+++ linux-2.6.24-rc5/include/linux/pci.h
@@ -174,6 +174,15 @@ struct pci_dev {
 	int		cfg_size;	/* Size of configuration space */
 
 	/*
+	 * ext_cfg_space gets set by drivers/quirks to device if
+	 * extended (4K) config space is desired.
+	 * negative values -- hard disabled (quirk etc)
+	 * zero            -- disabled
+	 * positive values -- enable
+	 */
+	int		ext_cfg_space;
+
+	/*
 	 * Instead of touching interrupt line and base address registers
 	 * directly, use the values stored here. They might be different!
 	 */
@@ -302,6 +311,8 @@ struct pci_bus {
 struct pci_ops {
 	int (*read)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
 	int (*write)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
+	int (*readext)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 *val);
+	int (*writeext)(struct pci_bus *bus, unsigned int devfn, int where, int size, u32 val);
 };
 
 struct pci_raw_ops {
@@ -521,28 +532,47 @@ int pci_bus_write_config_byte (struct pc
 int pci_bus_write_config_word (struct pci_bus *bus, unsigned int devfn, int where, u16 val);
 int pci_bus_write_config_dword (struct pci_bus *bus, unsigned int devfn, int where, u32 val);
 
+int pci_bus_read_extconfig_byte (struct pci_bus *bus, unsigned int devfn, int where, u8 *val);
+int pci_bus_read_extconfig_word (struct pci_bus *bus, unsigned int devfn, int where, u16 *val);
+int pci_bus_read_extconfig_dword (struct pci_bus *bus, unsigned int devfn, int where, u32 *val);
+int pci_bus_write_extconfig_byte (struct pci_bus *bus, unsigned int devfn, int where, u8 val);
+int pci_bus_write_extconfig_word (struct pci_bus *bus, unsigned int devfn, int where, u16 val);
+int pci_bus_write_extconfig_dword (struct pci_bus *bus, unsigned int devfn, int where, u32 val);
+
 static inline int pci_read_config_byte(struct pci_dev *dev, int where, u8 *val)
 {
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_read_extconfig_byte (dev->bus, dev->devfn, where, val);
 	return pci_bus_read_config_byte (dev->bus, dev->devfn, where, val);
 }
 static inline int pci_read_config_word(struct pci_dev *dev, int where, u16 *val)
 {
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_read_extconfig_word (dev->bus, dev->devfn, where, val);
 	return pci_bus_read_config_word (dev->bus, dev->devfn, where, val);
 }
 static inline int pci_read_config_dword(struct pci_dev *dev, int where, u32 *val)
 {
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_read_extconfig_dword (dev->bus, dev->devfn, where, val);
 	return pci_bus_read_config_dword (dev->bus, dev->devfn, where, val);
 }
 static inline int pci_write_config_byte(struct pci_dev *dev, int where, u8 val)
 {
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_write_extconfig_byte (dev->bus, dev->devfn, where, val);
 	return pci_bus_write_config_byte (dev->bus, dev->devfn, where, val);
 }
 static inline int pci_write_config_word(struct pci_dev *dev, int where, u16 val)
 {
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_write_extconfig_word (dev->bus, dev->devfn, where, val);
 	return pci_bus_write_config_word (dev->bus, dev->devfn, where, val);
 }
 static inline int pci_write_config_dword(struct pci_dev *dev, int where, u32 val)
 {
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_write_extconfig_dword (dev->bus, dev->devfn, where, val);
 	return pci_bus_write_config_dword (dev->bus, dev->devfn, where, val);
 }
 
@@ -693,6 +723,9 @@ void ht_destroy_irq(unsigned int irq);
 extern void pci_block_user_cfg_access(struct pci_dev *dev);
 extern void pci_unblock_user_cfg_access(struct pci_dev *dev);
 
+extern int pci_enable_ext_config(struct pci_dev *dev);
+
+
 /*
  * PCI domain support.  Sometimes called PCI segment (eg by ACPI),
  * a PCI domain is defined to be a set of PCI busses which share
@@ -789,6 +822,8 @@ static inline struct pci_dev *pci_get_bu
 						unsigned int devfn)
 { return NULL; }
 
+static inline int pci_enable_ext_config(struct pci_dev *dev) { return -1; }
+
 #endif /* CONFIG_PCI */
 
 /* Include architecture-dependent settings and functions */
Index: linux-2.6.24-rc5/arch/x86/pci/mmconfig_32.c
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/pci/mmconfig_32.c
+++ linux-2.6.24-rc5/arch/x86/pci/mmconfig_32.c
@@ -143,6 +143,6 @@ int __init pci_mmcfg_arch_reachable(unsi
 int __init pci_mmcfg_arch_init(void)
 {
 	printk(KERN_INFO "PCI: Using MMCONFIG\n");
-	raw_pci_ops = &pci_mmcfg;
+	raw_pci_ops_extcfg = &pci_mmcfg;
 	return 1;
 }
Index: linux-2.6.24-rc5/arch/x86/pci/mmconfig_64.c
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/pci/mmconfig_64.c
+++ linux-2.6.24-rc5/arch/x86/pci/mmconfig_64.c
@@ -152,6 +152,6 @@ int __init pci_mmcfg_arch_init(void)
 			return 0;
 		}
 	}
-	raw_pci_ops = &pci_mmcfg;
+	raw_pci_ops_extcfg = &pci_mmcfg;
 	return 1;
 }
Index: linux-2.6.24-rc5/drivers/pci/access.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/pci/access.c
+++ linux-2.6.24-rc5/drivers/pci/access.c
@@ -51,6 +51,41 @@ int pci_bus_write_config_##size \
 	return res;							\
 }
 
+#define PCI_OP_READ_EXT(size,type,len) \
+int pci_bus_read_extconfig_##size \
+	(struct pci_bus *bus, unsigned int devfn, int pos, type *value)	\
+{									\
+	int res;							\
+	unsigned long flags;						\
+	u32 data = 0;							\
+	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
+	spin_lock_irqsave(&pci_lock, flags);				\
+	if (bus->ops->readext)						\
+		res = bus->ops->readext(bus, devfn, pos, len, &data);	\
+	else								\
+		res = bus->ops->read(bus, devfn, pos, len, &data);	\
+	*value = (type)data;						\
+	spin_unlock_irqrestore(&pci_lock, flags);			\
+	return res;							\
+}
+
+#define PCI_OP_WRITE_EXT(size,type,len) \
+int pci_bus_write_extconfig_##size \
+	(struct pci_bus *bus, unsigned int devfn, int pos, type value)	\
+{									\
+	int res;							\
+	unsigned long flags;						\
+	if (PCI_##size##_BAD) return PCIBIOS_BAD_REGISTER_NUMBER;	\
+	spin_lock_irqsave(&pci_lock, flags);				\
+	if (bus->ops->writeext)						\
+		res = bus->ops->writeext(bus, devfn, pos, len, value);	\
+	else								\
+		res = bus->ops->write(bus, devfn, pos, len, value);	\
+	spin_unlock_irqrestore(&pci_lock, flags);			\
+	return res;							\
+}
+
+
 PCI_OP_READ(byte, u8, 1)
 PCI_OP_READ(word, u16, 2)
 PCI_OP_READ(dword, u32, 4)
@@ -58,12 +93,25 @@ PCI_OP_WRITE(byte, u8, 1)
 PCI_OP_WRITE(word, u16, 2)
 PCI_OP_WRITE(dword, u32, 4)
 
+PCI_OP_READ_EXT(byte, u8, 1)
+PCI_OP_READ_EXT(word, u16, 2)
+PCI_OP_READ_EXT(dword, u32, 4)
+PCI_OP_WRITE_EXT(byte, u8, 1)
+PCI_OP_WRITE_EXT(word, u16, 2)
+PCI_OP_WRITE_EXT(dword, u32, 4)
+
 EXPORT_SYMBOL(pci_bus_read_config_byte);
 EXPORT_SYMBOL(pci_bus_read_config_word);
 EXPORT_SYMBOL(pci_bus_read_config_dword);
 EXPORT_SYMBOL(pci_bus_write_config_byte);
 EXPORT_SYMBOL(pci_bus_write_config_word);
 EXPORT_SYMBOL(pci_bus_write_config_dword);
+EXPORT_SYMBOL(pci_bus_read_extconfig_byte);
+EXPORT_SYMBOL(pci_bus_read_extconfig_word);
+EXPORT_SYMBOL(pci_bus_read_extconfig_dword);
+EXPORT_SYMBOL(pci_bus_write_extconfig_byte);
+EXPORT_SYMBOL(pci_bus_write_extconfig_word);
+EXPORT_SYMBOL(pci_bus_write_extconfig_dword);
 
 /*
  * The following routines are to prevent the user from accessing PCI config
Index: linux-2.6.24-rc5/arch/x86/pci/pci.h
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/pci/pci.h
+++ linux-2.6.24-rc5/arch/x86/pci/pci.h
@@ -32,6 +32,8 @@
 extern unsigned int pci_probe;
 extern unsigned long pirq_table_addr;
 
+extern struct pci_raw_ops *raw_pci_ops_extcfg;
+
 enum pci_bf_sort_state {
 	pci_bf_sort_default,
 	pci_force_nobf,
