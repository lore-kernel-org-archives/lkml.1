Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab0BXIIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:08:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:58631 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab0BXIII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:08:08 -0500
Date: Wed, 24 Feb 2010 08:07:39 GMT
From: tip-bot for Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D08@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D08@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86/PCI: Moorestown PCI support
Message-ID: <tip-a712ffbc199849364c46e9112b93b66de08e2c26@git.kernel.org>
Git-Commit-ID: a712ffbc199849364c46e9112b93b66de08e2c26
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:07:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a712ffbc199849364c46e9112b93b66de08e2c26
Gitweb:     http://git.kernel.org/tip/a712ffbc199849364c46e9112b93b66de08e2c26
Author:     Jesse Barnes <jbarnes@virtuousgeek.org>
AuthorDate: Thu, 4 Feb 2010 10:59:27 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:14:47 -0800

x86/PCI: Moorestown PCI support

The Moorestown platform only has a few devices that actually support
PCI config cycles.  The rest of the devices use an in-RAM MCFG space
for the purposes of device enumeration and initialization.

There are a few uglies in the fake support, like BAR sizes that aren't
a power of two, sizing detection, and writes to the real devices, but
other than that it's pretty straightforward.

Another way to think of this is not really as PCI at all, but just a
table in RAM describing which devices are present, their capabilities
and their offsets in MMIO space.  This could have been done with a
special new firmware table on this platform, but given that we do have
some real PCI devices too, simply describing things in an MCFG type
space was pretty simple.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D08@orsmsx508.amr.corp.intel.com>
Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/pci/Makefile    |    2 +-
 arch/x86/pci/mrst.c      |  258 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci_regs.h |    1 +
 3 files changed, 260 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 39fba37..4753ebc 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
-obj-y				+= common.o early.o
+obj-y				+= common.o early.o mrst.o
 obj-y				+= amd_bus.o
 obj-$(CONFIG_X86_64)		+= bus_numa.o
 
diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
new file mode 100644
index 0000000..6e9e1a3
--- /dev/null
+++ b/arch/x86/pci/mrst.c
@@ -0,0 +1,258 @@
+/*
+ * Moorestown PCI support
+ *   Copyright (c) 2008 Intel Corporation
+ *     Jesse Barnes <jesse.barnes@intel.com>
+ *
+ * Moorestown has an interesting PCI implementation:
+ *   - configuration space is memory mapped (as defined by MCFG)
+ *   - Lincroft devices also have a real, type 1 configuration space
+ *   - Early Lincroft silicon has a type 1 access bug that will cause
+ *     a hang if non-existent devices are accessed
+ *   - some devices have the "fixed BAR" capability, which means
+ *     they can't be relocated or modified; check for that during
+ *     BAR sizing
+ *
+ * So, we use the MCFG space for all reads and writes, but also send
+ * Lincroft writes to type 1 space.  But only read/write if the device
+ * actually exists, otherwise return all 1s for reads and bit bucket
+ * the writes.
+ */
+
+#include <linux/sched.h>
+#include <linux/pci.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/dmi.h>
+
+#include <asm/acpi.h>
+#include <asm/segment.h>
+#include <asm/io.h>
+#include <asm/smp.h>
+#include <asm/pci_x86.h>
+#include <asm/hw_irq.h>
+#include <asm/io_apic.h>
+
+#define PCIE_CAP_OFFSET	0x100
+
+/* Fixed BAR fields */
+#define PCIE_VNDR_CAP_ID_FIXED_BAR 0x00	/* Fixed BAR (TBD) */
+#define PCI_FIXED_BAR_0_SIZE	0x04
+#define PCI_FIXED_BAR_1_SIZE	0x08
+#define PCI_FIXED_BAR_2_SIZE	0x0c
+#define PCI_FIXED_BAR_3_SIZE	0x10
+#define PCI_FIXED_BAR_4_SIZE	0x14
+#define PCI_FIXED_BAR_5_SIZE	0x1c
+
+/**
+ * fixed_bar_cap - return the offset of the fixed BAR cap if found
+ * @bus: PCI bus
+ * @devfn: device in question
+ *
+ * Look for the fixed BAR cap on @bus and @devfn, returning its offset
+ * if found or 0 otherwise.
+ */
+static int fixed_bar_cap(struct pci_bus *bus, unsigned int devfn)
+{
+	int pos;
+	u32 pcie_cap = 0, cap_data;
+
+	pos = PCIE_CAP_OFFSET;
+	while (pos) {
+		if (raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
+					  devfn, pos, 4, &pcie_cap))
+			return 0;
+
+		if (pcie_cap == 0xffffffff)
+			return 0;
+
+		if (PCI_EXT_CAP_ID(pcie_cap) == PCI_EXT_CAP_ID_VNDR) {
+			raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
+					      devfn, pos + 4, 4, &cap_data);
+			if ((cap_data & 0xffff) == PCIE_VNDR_CAP_ID_FIXED_BAR)
+				return pos;
+		}
+
+		pos = pcie_cap >> 20;
+	}
+
+	return 0;
+}
+
+static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
+				   int reg, int len, u32 val, int offset)
+{
+	u32 size;
+	unsigned int domain, busnum;
+	int bar = (reg - PCI_BASE_ADDRESS_0) >> 2;
+
+	domain = pci_domain_nr(bus);
+	busnum = bus->number;
+
+	if (val == ~0 && len == 4) {
+		unsigned long decode;
+
+		raw_pci_ext_ops->read(domain, busnum, devfn,
+			       offset + 8 + (bar * 4), 4, &size);
+
+		/* Turn the size into a decode pattern for the sizing code */
+		if (size) {
+			decode = size - 1;
+			decode |= decode >> 1;
+			decode |= decode >> 2;
+			decode |= decode >> 4;
+			decode |= decode >> 8;
+			decode |= decode >> 16;
+			decode++;
+			decode = ~(decode - 1);
+		} else {
+			decode = ~0;
+		}
+
+		/*
+		 * If val is all ones, the core code is trying to size the reg,
+		 * so update the mmconfig space with the real size.
+		 *
+		 * Note: this assumes the fixed size we got is a power of two.
+		 */
+		return raw_pci_ext_ops->write(domain, busnum, devfn, reg, 4,
+				       decode);
+	}
+
+	/* This is some other kind of BAR write, so just do it. */
+	return raw_pci_ext_ops->write(domain, busnum, devfn, reg, len, val);
+}
+
+/**
+ * type1_access_ok - check whether to use type 1
+ * @bus: bus number
+ * @devfn: device & function in question
+ *
+ * If the bus is on a Lincroft chip and it exists, or is not on a Lincroft at
+ * all, the we can go ahead with any reads & writes.  If it's on a Lincroft,
+ * but doesn't exist, avoid the access altogether to keep the chip from
+ * hanging.
+ */
+static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
+{
+	/* This is a workaround for A0 LNC bug where PCI status register does
+	 * not have new CAP bit set. can not be written by SW either.
+	 *
+	 * PCI header type in real LNC indicates a single function device, this
+	 * will prevent probing other devices under the same function in PCI
+	 * shim. Therefore, use the header type in shim instead.
+	 */
+	if (reg >= 0x100 || reg == PCI_STATUS || reg == PCI_HEADER_TYPE)
+		return 0;
+	if (bus == 0 && (devfn == PCI_DEVFN(2, 0) || devfn == PCI_DEVFN(0, 0)))
+		return 1;
+	return 0; /* langwell on others */
+}
+
+static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
+		    int size, u32 *value)
+{
+	if (type1_access_ok(bus->number, devfn, where))
+		return pci_direct_conf1.read(pci_domain_nr(bus), bus->number,
+					devfn, where, size, value);
+	return raw_pci_ext_ops->read(pci_domain_nr(bus), bus->number,
+			      devfn, where, size, value);
+}
+
+static int pci_write(struct pci_bus *bus, unsigned int devfn, int where,
+		     int size, u32 value)
+{
+	int offset;
+
+	/* On MRST, there is no PCI ROM BAR, this will cause a subsequent read
+	 * to ROM BAR return 0 then being ignored.
+	 */
+	if (where == PCI_ROM_ADDRESS)
+		return 0;
+
+	/*
+	 * Devices with fixed BARs need special handling:
+	 *   - BAR sizing code will save, write ~0, read size, restore
+	 *   - so writes to fixed BARs need special handling
+	 *   - other writes to fixed BAR devices should go through mmconfig
+	 */
+	offset = fixed_bar_cap(bus, devfn);
+	if (offset &&
+	    (where >= PCI_BASE_ADDRESS_0 && where <= PCI_BASE_ADDRESS_5)) {
+		return pci_device_update_fixed(bus, devfn, where, size, value,
+					       offset);
+	}
+
+	/*
+	 * On Moorestown update both real & mmconfig space
+	 * Note: early Lincroft silicon can't handle type 1 accesses to
+	 *       non-existent devices, so just eat the write in that case.
+	 */
+	if (type1_access_ok(bus->number, devfn, where))
+		return pci_direct_conf1.write(pci_domain_nr(bus), bus->number,
+					      devfn, where, size, value);
+	return raw_pci_ext_ops->write(pci_domain_nr(bus), bus->number, devfn,
+			       where, size, value);
+}
+
+static int mrst_pci_irq_enable(struct pci_dev *dev)
+{
+	u8 pin;
+	struct io_apic_irq_attr irq_attr;
+
+	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
+
+	/* MRST only have IOAPIC, the PCI irq lines are 1:1 mapped to
+	 * IOAPIC RTE entries, so we just enable RTE for the device.
+	 */
+	irq_attr.ioapic = mp_find_ioapic(dev->irq);
+	irq_attr.ioapic_pin = dev->irq;
+	irq_attr.trigger = 1; /* level */
+	irq_attr.polarity = 1; /* active low */
+	io_apic_set_pci_routing(&dev->dev, dev->irq, &irq_attr);
+
+	return 0;
+}
+
+struct pci_ops pci_mrst_ops = {
+	.read = pci_read,
+	.write = pci_write,
+};
+
+/**
+ * pci_mrst_init - installs pci_mrst_ops
+ *
+ * Moorestown has an interesting PCI implementation (see above).
+ * Called when the early platform detection installs it.
+ */
+int __init pci_mrst_init(void)
+{
+	printk(KERN_INFO "Moorestown platform detected, using MRST PCI ops\n");
+	pci_mmcfg_late_init();
+	pcibios_enable_irq = mrst_pci_irq_enable;
+	pci_root_ops = pci_mrst_ops;
+	/* Continue with standard init */
+	return 1;
+}
+
+/*
+ * Langwell devices reside at fixed offsets, don't try to move them.
+ */
+static void __devinit pci_fixed_bar_fixup(struct pci_dev *dev)
+{
+	unsigned long offset;
+	u32 size;
+	int i;
+
+	/* Fixup the BAR sizes for fixed BAR devices and make them unmoveable */
+	offset = fixed_bar_cap(dev->bus, dev->devfn);
+	if (!offset || PCI_DEVFN(2, 0) == dev->devfn ||
+	    PCI_DEVFN(2, 2) == dev->devfn)
+		return;
+
+	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
+		pci_read_config_dword(dev, offset + 8 + (i * 4), &size);
+		dev->resource[i].end = dev->resource[i].start + size - 1;
+		dev->resource[i].flags |= IORESOURCE_PCI_FIXED;
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_ANY_ID, pci_fixed_bar_fixup);
diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
index 9f2ad0a..c8f3029 100644
--- a/include/linux/pci_regs.h
+++ b/include/linux/pci_regs.h
@@ -507,6 +507,7 @@
 #define PCI_EXT_CAP_ID_VC	2
 #define PCI_EXT_CAP_ID_DSN	3
 #define PCI_EXT_CAP_ID_PWR	4
+#define PCI_EXT_CAP_ID_VNDR	11
 #define PCI_EXT_CAP_ID_ACS	13
 #define PCI_EXT_CAP_ID_ARI	14
 #define PCI_EXT_CAP_ID_ATS	15
