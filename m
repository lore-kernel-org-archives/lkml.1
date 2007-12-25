Return-Path: <linux-kernel-owner+w=401wt.eu-S1752475AbXLYL15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475AbXLYL15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 06:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXLYL1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 06:27:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37639 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbXLYL1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 06:27:46 -0500
Date: Tue, 25 Dec 2007 03:26:05 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       inux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
 opt-in
Message-ID: <20071225032605.29147200@laptopd505.fenrus.org>
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


From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in

On PCs, PCI extended configuration space (4Kb) is riddled with problems 
associated with the memory mapped access method (MMCONFIG). At the same
time, there are very few machines that actually need or use this extended
configuration space. 

At this point in time, the only sensible action is to make access to the
extended configuration space an opt-in operation for those device drivers
that need/want access to this space, as well as for those userland 
diagnostics utilities that (on admin request) want to access this space.

It's inevitable that this is done per device rather than per bus; we'll
be needing per device PCI quirks to turn this extended config space off 
over time no matter what; in addition, it gives the least amount of surprise:
loading a driver for a device only impacts that one device, not a whole bus
worth of devices (although it'll be common to have one physical device per
bus on PCI-E).

The (desireable) side-effect of this patch is that all enumeration is done
using normal configuration cycles.

The patch below splits the lower level PCI config space operation (which
operate on a bus) in two: one that normally only operates on traditional 
space, and one that gets used after the driver has opted in to using the
extended configuration space. This has lead to a little code duplication,
but it's not all that bad (most of it is prototypes in headers and such).

Architectures that have a solid reliable way to get to extended configuration
space can just keep doing what they do now and allow extended space access
from the "traditional" bus ops, and just not fill in the new bus ops.
(This could include x86 for, say, BIOS year 2009 and later, but doesn't
right now)

This patch also adds a sysfs property for each device into which root can
write a '1' to enable extended configuration space. The kernel will print
a notice into dmesg when this happens (including the name of the app) so that
if the system crashes as a result of this action, the user can know what
action/tool caused it.


Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 arch/x86/pci/common.c      |   23 ++++++++++++++++++++++
 arch/x86/pci/init.c        |   10 +++++++++
 arch/x86/pci/mmconfig_32.c |    2 -
 arch/x86/pci/mmconfig_64.c |    2 -
 arch/x86/pci/pci.h         |    2 +
 drivers/pci/access.c       |   46 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/pci-sysfs.c    |   31 +++++++++++++++++++++++++++++
 drivers/pci/pci.c          |   28 ++++++++++++++++++++++++++
 include/linux/pci.h        |   47 +++++++++++++++++++++++++++++++++++++++------
 9 files changed, 183 insertions(+), 8 deletions(-)

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
@@ -752,6 +752,34 @@ int pci_enable_device(struct pci_dev *de
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
+	if (dev->ext_cfg_space > 0)
+		return 0;
+	dev->ext_cfg_space = 1;
+	/*
+	 * now that we enabled large accesse, we
+	 * need to update the config space size variable
+	 */
+	dev->cfg_size = pci_cfg_space_size(dev);
+	return 0;
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
@@ -521,29 +532,48 @@ int pci_bus_write_config_byte (struct pc
 int pci_bus_write_config_word (struct pci_bus *bus, unsigned int devfn, int where, u16 val);
 int pci_bus_write_config_dword (struct pci_bus *bus, unsigned int devfn, int where, u32 val);
 
+int pci_bus_read_extconfig_byte(struct pci_bus *bus, unsigned int devfn, int where, u8 *val);
+int pci_bus_read_extconfig_word(struct pci_bus *bus, unsigned int devfn, int where, u16 *val);
+int pci_bus_read_extconfig_dword(struct pci_bus *bus, unsigned int devfn, int where, u32 *val);
+int pci_bus_write_extconfig_byte(struct pci_bus *bus, unsigned int devfn, int where, u8 val);
+int pci_bus_write_extconfig_word(struct pci_bus *bus, unsigned int devfn, int where, u16 val);
+int pci_bus_write_extconfig_dword(struct pci_bus *bus, unsigned int devfn, int where, u32 val);
+
 static inline int pci_read_config_byte(struct pci_dev *dev, int where, u8 *val)
 {
-	return pci_bus_read_config_byte (dev->bus, dev->devfn, where, val);
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_read_extconfig_byte(dev->bus, dev->devfn, where, val);
+	return pci_bus_read_config_byte(dev->bus, dev->devfn, where, val);
 }
 static inline int pci_read_config_word(struct pci_dev *dev, int where, u16 *val)
 {
-	return pci_bus_read_config_word (dev->bus, dev->devfn, where, val);
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_read_extconfig_word(dev->bus, dev->devfn, where, val);
+	return pci_bus_read_config_word(dev->bus, dev->devfn, where, val);
 }
 static inline int pci_read_config_dword(struct pci_dev *dev, int where, u32 *val)
 {
-	return pci_bus_read_config_dword (dev->bus, dev->devfn, where, val);
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_read_extconfig_dword(dev->bus, dev->devfn, where, val);
+	return pci_bus_read_config_dword(dev->bus, dev->devfn, where, val);
 }
 static inline int pci_write_config_byte(struct pci_dev *dev, int where, u8 val)
 {
-	return pci_bus_write_config_byte (dev->bus, dev->devfn, where, val);
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_write_extconfig_byte(dev->bus, dev->devfn, where, val);
+	return pci_bus_write_config_byte(dev->bus, dev->devfn, where, val);
 }
 static inline int pci_write_config_word(struct pci_dev *dev, int where, u16 val)
 {
-	return pci_bus_write_config_word (dev->bus, dev->devfn, where, val);
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_write_extconfig_word(dev->bus, dev->devfn, where, val);
+	return pci_bus_write_config_word(dev->bus, dev->devfn, where, val);
 }
 static inline int pci_write_config_dword(struct pci_dev *dev, int where, u32 val)
 {
-	return pci_bus_write_config_dword (dev->bus, dev->devfn, where, val);
+	if (dev->ext_cfg_space > 0)
+		return pci_bus_write_extconfig_dword(dev->bus, dev->devfn, where, val);
+	return pci_bus_write_config_dword(dev->bus, dev->devfn, where, val);
 }
 
 int __must_check pci_enable_device(struct pci_dev *dev);
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
@@ -51,6 +51,45 @@ int pci_bus_write_config_##size \
 	return res;							\
 }
 
+#define PCI_OP_READ_EXT(size, type, len) \
+int pci_bus_read_extconfig_##size \
+	(struct pci_bus *bus, unsigned int devfn, int pos, type *value)	\
+{									\
+	int res;							\
+	unsigned long flags;						\
+	u32 data = 0;							\
+	if (PCI_##size##_BAD)						\
+		return PCIBIOS_BAD_REGISTER_NUMBER;			\
+	spin_lock_irqsave(&pci_lock, flags);				\
+	if (bus->ops->readext)						\
+		res = bus->ops->readext(bus, devfn, pos, len, &data);	\
+	else								\
+		res = bus->ops->read(bus, devfn, pos, len, &data);	\
+	*value = (type)data;						\
+	spin_unlock_irqrestore(&pci_lock, flags);			\
+	return res;							\
+}									\
+EXPORT_SYMBOL(pci_bus_read_extconfig_##size);
+
+#define PCI_OP_WRITE_EXT(size, type, len) \
+int pci_bus_write_extconfig_##size \
+	(struct pci_bus *bus, unsigned int devfn, int pos, type value)	\
+{									\
+	int res;							\
+	unsigned long flags;						\
+	if (PCI_##size##_BAD)						\
+		return PCIBIOS_BAD_REGISTER_NUMBER;			\
+	spin_lock_irqsave(&pci_lock, flags);				\
+	if (bus->ops->writeext)						\
+		res = bus->ops->writeext(bus, devfn, pos, len, value);	\
+	else								\
+		res = bus->ops->write(bus, devfn, pos, len, value);	\
+	spin_unlock_irqrestore(&pci_lock, flags);			\
+	return res;							\
+}									\
+EXPORT_SYMBOL(pci_bus_write_extconfig_##size);
+
+
 PCI_OP_READ(byte, u8, 1)
 PCI_OP_READ(word, u16, 2)
 PCI_OP_READ(dword, u32, 4)
@@ -58,6 +97,13 @@ PCI_OP_WRITE(byte, u8, 1)
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
Index: linux-2.6.24-rc5/arch/x86/pci/init.c
===================================================================
--- linux-2.6.24-rc5.orig/arch/x86/pci/init.c
+++ linux-2.6.24-rc5/arch/x86/pci/init.c
@@ -14,6 +14,16 @@ static __init int pci_access_init(void)
 #ifdef CONFIG_PCI_MMCONFIG
 	pci_mmcfg_init(type);
 #endif
+	/* if we ONLY have MMCONFIG, we need to use it always */
+	if (!raw_pci_ops && raw_pci_ops_extcfg) {
+		printk(KERN_INFO "No direct PCI access, using MMCONFIG always\n");
+		raw_pci_ops = raw_pci_ops_extcfg;
+	}
+
+	/*
+	 * we've found a usable method; this means we can skip
+	 * the potentially dangerous BIOS based methods
+	 */
 	if (raw_pci_ops)
 		return 0;
 #ifdef CONFIG_PCI_BIOS
Index: linux-2.6.24-rc5/drivers/pci/pci-sysfs.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/pci/pci-sysfs.c
+++ linux-2.6.24-rc5/drivers/pci/pci-sysfs.c
@@ -143,6 +143,35 @@ static ssize_t is_enabled_show(struct de
 	return sprintf (buf, "%u\n", atomic_read(&pdev->enable_cnt));
 }
 
+static ssize_t extended_config_space_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	ssize_t result = -EINVAL;
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	/* this can crash the machine when done on the "wrong" device */
+	if (!capable(CAP_SYS_ADMIN))
+		return count;
+
+	if (*buf == '1') {
+		printk(KERN_WARNING "Application %s enabled extended config space for device %s\n",
+			current->comm,  pci_name(pdev));
+		result = pci_enable_ext_config(pdev);
+	}
+
+	return result < 0 ? result : count;
+}
+
+static ssize_t extended_config_space_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev;
+
+	pdev = to_pci_dev(dev);
+	return sprintf(buf, "%u\n", pdev->ext_cfg_space);
+}
+
 #ifdef CONFIG_NUMA
 static ssize_t
 numa_node_show(struct device *dev, struct device_attribute *attr, char *buf)
@@ -206,6 +235,8 @@ struct device_attribute pci_dev_attrs[] 
 	__ATTR_RO(numa_node),
 #endif
 	__ATTR(enable, 0600, is_enabled_show, is_enabled_store),
+	__ATTR(extended_config_space, 0600, extended_config_space_show,
+		extended_config_space_store),
 	__ATTR(broken_parity_status,(S_IRUGO|S_IWUSR),
 		broken_parity_status_show,broken_parity_status_store),
 	__ATTR(msi_bus, 0644, msi_bus_show, msi_bus_store),
