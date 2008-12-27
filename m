Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbYL0NEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbYL0NEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 08:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYL0NE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 08:04:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:33175 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbYL0NE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 08:04:28 -0500
Subject: [PATCH] move arch/x86/pci/pci.h to arch/x86/include/asm/pci_x86.h
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mj@ucw.cz
Content-Type: text/plain
Date: Sat, 27 Dec 2008 18:32:28 +0530
Message-Id: <1230382948.3373.1.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, arch/x86/pci/pci.h -> arch/x86/include/asm/pci_x86.h

Tested on: X86_32_UP, X86_32_SMP and X86_64_SMP

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/pci_x86.h     |  165 ++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/mmconf-fam10h_64.c |    3 +-
 arch/x86/kernel/reboot.c           |    3 +-
 arch/x86/pci/acpi.c                |    2 +-
 arch/x86/pci/amd_bus.c             |    2 +-
 arch/x86/pci/common.c              |    3 +-
 arch/x86/pci/direct.c              |    2 +-
 arch/x86/pci/early.c               |    2 +-
 arch/x86/pci/fixup.c               |    3 +-
 arch/x86/pci/i386.c                |    2 +-
 arch/x86/pci/init.c                |    2 +-
 arch/x86/pci/irq.c                 |    3 +-
 arch/x86/pci/legacy.c              |    2 +-
 arch/x86/pci/mmconfig-shared.c     |    3 +-
 arch/x86/pci/mmconfig_32.c         |    2 +-
 arch/x86/pci/mmconfig_64.c         |    3 +-
 arch/x86/pci/numaq_32.c            |    2 +-
 arch/x86/pci/olpc.c                |    2 +-
 arch/x86/pci/pcbios.c              |    5 +-
 arch/x86/pci/pci.h                 |  162 -----------------------------------
 arch/x86/pci/visws.c               |    3 +-
 21 files changed, 185 insertions(+), 191 deletions(-)
 create mode 100644 arch/x86/include/asm/pci_x86.h
 delete mode 100644 arch/x86/pci/pci.h

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
new file mode 100644
index 0000000..e60fd3e
--- /dev/null
+++ b/arch/x86/include/asm/pci_x86.h
@@ -0,0 +1,165 @@
+/*
+ *	Low-Level PCI Access for i386 machines.
+ *
+ *	(c) 1999 Martin Mares <mj@ucw.cz>
+ */
+
+#undef DEBUG
+
+#ifdef DEBUG
+#define DBG(x...) printk(x)
+#else
+#define DBG(x...)
+#endif
+
+#define PCI_PROBE_BIOS		0x0001
+#define PCI_PROBE_CONF1		0x0002
+#define PCI_PROBE_CONF2		0x0004
+#define PCI_PROBE_MMCONF	0x0008
+#define PCI_PROBE_MASK		0x000f
+#define PCI_PROBE_NOEARLY	0x0010
+
+#define PCI_NO_CHECKS		0x0400
+#define PCI_USE_PIRQ_MASK	0x0800
+#define PCI_ASSIGN_ROMS		0x1000
+#define PCI_BIOS_IRQ_SCAN	0x2000
+#define PCI_ASSIGN_ALL_BUSSES	0x4000
+#define PCI_CAN_SKIP_ISA_ALIGN	0x8000
+#define PCI_USE__CRS		0x10000
+#define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
+#define PCI_HAS_IO_ECS		0x40000
+#define PCI_NOASSIGN_ROMS	0x80000
+
+extern unsigned int pci_probe;
+extern unsigned long pirq_table_addr;
+
+enum pci_bf_sort_state {
+	pci_bf_sort_default,
+	pci_force_nobf,
+	pci_force_bf,
+	pci_dmi_bf,
+};
+
+/* pci-i386.c */
+
+extern unsigned int pcibios_max_latency;
+
+void pcibios_resource_survey(void);
+
+/* pci-pc.c */
+
+extern int pcibios_last_bus;
+extern struct pci_bus *pci_root_bus;
+extern struct pci_ops pci_root_ops;
+
+/* pci-irq.c */
+
+struct irq_info {
+	u8 bus, devfn;			/* Bus, device and function */
+	struct {
+		u8 link;		/* IRQ line ID, chipset dependent,
+					   0 = not routed */
+		u16 bitmap;		/* Available IRQs */
+	} __attribute__((packed)) irq[4];
+	u8 slot;			/* Slot number, 0=onboard */
+	u8 rfu;
+} __attribute__((packed));
+
+struct irq_routing_table {
+	u32 signature;			/* PIRQ_SIGNATURE should be here */
+	u16 version;			/* PIRQ_VERSION */
+	u16 size;			/* Table size in bytes */
+	u8 rtr_bus, rtr_devfn;		/* Where the interrupt router lies */
+	u16 exclusive_irqs;		/* IRQs devoted exclusively to
+					   PCI usage */
+	u16 rtr_vendor, rtr_device;	/* Vendor and device ID of
+					   interrupt router */
+	u32 miniport_data;		/* Crap */
+	u8 rfu[11];
+	u8 checksum;			/* Modulo 256 checksum must give 0 */
+	struct irq_info slots[0];
+} __attribute__((packed));
+
+extern unsigned int pcibios_irq_mask;
+
+extern int pcibios_scanned;
+extern spinlock_t pci_config_lock;
+
+extern int (*pcibios_enable_irq)(struct pci_dev *dev);
+extern void (*pcibios_disable_irq)(struct pci_dev *dev);
+
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
+extern bool port_cf9_safe;
+
+/* arch_initcall level */
+extern int pci_direct_probe(void);
+extern void pci_direct_init(int type);
+extern void pci_pcbios_init(void);
+extern int pci_olpc_init(void);
+extern void __init dmi_check_pciprobe(void);
+extern void __init dmi_check_skip_isa_align(void);
+
+/* some common used subsys_initcalls */
+extern int __init pci_acpi_init(void);
+extern int __init pcibios_irq_init(void);
+extern int __init pci_visws_init(void);
+extern int __init pci_numaq_init(void);
+extern int __init pcibios_init(void);
+
+/* pci-mmconfig.c */
+
+extern int __init pci_mmcfg_arch_init(void);
+extern void __init pci_mmcfg_arch_free(void);
+
+/*
+ * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
+ * on their northbrige except through the * %eax register. As such, you MUST
+ * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
+ * accessor functions.
+ * In fact just use pci_config_*, nothing else please.
+ */
+static inline unsigned char mmio_config_readb(void __iomem *pos)
+{
+	u8 val;
+	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline unsigned short mmio_config_readw(void __iomem *pos)
+{
+	u16 val;
+	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline unsigned int mmio_config_readl(void __iomem *pos)
+{
+	u32 val;
+	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline void mmio_config_writeb(void __iomem *pos, u8 val)
+{
+	asm volatile("movb %%al,(%1)" : : "a" (val), "r" (pos) : "memory");
+}
+
+static inline void mmio_config_writew(void __iomem *pos, u16 val)
+{
+	asm volatile("movw %%ax,(%1)" : : "a" (val), "r" (pos) : "memory");
+}
+
+static inline void mmio_config_writel(void __iomem *pos, u32 val)
+{
+	asm volatile("movl %%eax,(%1)" : : "a" (val), "r" (pos) : "memory");
+}
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index efc2f36..666e43d 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -13,8 +13,7 @@
 #include <asm/msr.h>
 #include <asm/acpi.h>
 #include <asm/mmconfig.h>
-
-#include "../pci/pci.h"
+#include <asm/pci_x86.h>
 
 struct pci_hostbridge_probe {
 	u32 bus;
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f39e871..16b2c74 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -12,6 +12,7 @@
 #include <asm/proto.h>
 #include <asm/reboot_fixups.h>
 #include <asm/reboot.h>
+#include <asm/pci_x86.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/dmi.h>
@@ -22,8 +23,6 @@
 #endif
 
 #include <mach_ipi.h>
-#include "../pci/pci.h"
-
 
 /*
  * Power off function, if any
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 1d88d2b..9e5752f 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -4,7 +4,7 @@
 #include <linux/irq.h>
 #include <linux/dmi.h>
 #include <asm/numa.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 struct pci_root_info {
 	char *name;
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index f27eada..5f23426 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -2,7 +2,7 @@
 #include <linux/pci.h>
 #include <linux/topology.h>
 #include <linux/cpu.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/pci-direct.h>
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index bb1a01f..62ddb73 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -14,8 +14,7 @@
 #include <asm/segment.h>
 #include <asm/io.h>
 #include <asm/smp.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
 				PCI_PROBE_MMCONF;
diff --git a/arch/x86/pci/direct.c b/arch/x86/pci/direct.c
index 9a5af6c..bd13c3e 100644
--- a/arch/x86/pci/direct.c
+++ b/arch/x86/pci/direct.c
@@ -5,7 +5,7 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/dmi.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /*
  * Functions for accessing PCI base (first 256 bytes) and extended
diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
index 86631cc..f6adf2c 100644
--- a/arch/x86/pci/early.c
+++ b/arch/x86/pci/early.c
@@ -2,7 +2,7 @@
 #include <linux/pci.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* Direct PCI access. This is used for PCI accesses in early boot before
    the PCI subsystem works. */
diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 2051dc9..7d388d5 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -6,8 +6,7 @@
 #include <linux/dmi.h>
 #include <linux/pci.h>
 #include <linux/init.h>
-#include "pci.h"
-
+#include <asm/pci_x86.h>
 
 static void __devinit pci_fixup_i450nx(struct pci_dev *d)
 {
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 844df0c..e51bf2c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -34,8 +34,8 @@
 
 #include <asm/pat.h>
 #include <asm/e820.h>
+#include <asm/pci_x86.h>
 
-#include "pci.h"
 
 static int
 skip_isa_ioresource_align(struct pci_dev *dev) {
diff --git a/arch/x86/pci/init.c b/arch/x86/pci/init.c
index d6c950f..bec3b04 100644
--- a/arch/x86/pci/init.c
+++ b/arch/x86/pci/init.c
@@ -1,6 +1,6 @@
 #include <linux/pci.h>
 #include <linux/init.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* arch_initcall has too random ordering, so call the initializers
    in the right sequence from here. */
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index bf69dbe..373b9af 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -16,8 +16,7 @@
 #include <asm/io_apic.h>
 #include <linux/irq.h>
 #include <linux/acpi.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 #define PIRQ_SIGNATURE	(('$' << 0) + ('P' << 8) + ('I' << 16) + ('R' << 24))
 #define PIRQ_VERSION 0x0100
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index b722dd4..f1065b1 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -3,7 +3,7 @@
  */
 #include <linux/init.h>
 #include <linux/pci.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /*
  * Discover remaining PCI buses in case there are peer host bridges.
diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 654a223..89bf924 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -15,8 +15,7 @@
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <asm/e820.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* aperture is up to 256MB but BIOS may reserve less */
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
diff --git a/arch/x86/pci/mmconfig_32.c b/arch/x86/pci/mmconfig_32.c
index f3c761d..8b2d561 100644
--- a/arch/x86/pci/mmconfig_32.c
+++ b/arch/x86/pci/mmconfig_32.c
@@ -13,7 +13,7 @@
 #include <linux/init.h>
 #include <linux/acpi.h>
 #include <asm/e820.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* Assume systems with more busses have correct MCFG */
 #define mmcfg_virt_addr ((void __iomem *) fix_to_virt(FIX_PCIE_MCFG))
diff --git a/arch/x86/pci/mmconfig_64.c b/arch/x86/pci/mmconfig_64.c
index a199416..30007ff 100644
--- a/arch/x86/pci/mmconfig_64.c
+++ b/arch/x86/pci/mmconfig_64.c
@@ -10,8 +10,7 @@
 #include <linux/acpi.h>
 #include <linux/bitmap.h>
 #include <asm/e820.h>
-
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /* Static virtual mapping of the MMCONFIG aperture */
 struct mmcfg_virt {
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
index 1177845..2089354 100644
--- a/arch/x86/pci/numaq_32.c
+++ b/arch/x86/pci/numaq_32.c
@@ -7,7 +7,7 @@
 #include <linux/nodemask.h>
 #include <mach_apic.h>
 #include <asm/mpspec.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 #define XQUAD_PORTIO_BASE 0xfe400000
 #define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index e11e9e8..b889d82 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -29,7 +29,7 @@
 #include <linux/init.h>
 #include <asm/olpc.h>
 #include <asm/geode.h>
-#include "pci.h"
+#include <asm/pci_x86.h>
 
 /*
  * In the tables below, the first two line (8 longwords) are the
diff --git a/arch/x86/pci/pcbios.c b/arch/x86/pci/pcbios.c
index 37472fc..b82cae9 100644
--- a/arch/x86/pci/pcbios.c
+++ b/arch/x86/pci/pcbios.c
@@ -6,9 +6,8 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
-#include "pci.h"
-#include "pci-functions.h"
-
+#include <asm/pci_x86.h>
+#include <asm/mach-default/pci-functions.h>
 
 /* BIOS32 signature: "_32_" */
 #define BIOS32_SIGNATURE	(('_' << 0) + ('3' << 8) + ('2' << 16) + ('_' << 24))
diff --git a/arch/x86/pci/pci.h b/arch/x86/pci/pci.h
deleted file mode 100644
index 1959018..0000000
--- a/arch/x86/pci/pci.h
+++ /dev/null
@@ -1,162 +0,0 @@
-/*
- *	Low-Level PCI Access for i386 machines.
- *
- *	(c) 1999 Martin Mares <mj@ucw.cz>
- */
-
-#undef DEBUG
-
-#ifdef DEBUG
-#define DBG(x...) printk(x)
-#else
-#define DBG(x...)
-#endif
-
-#define PCI_PROBE_BIOS		0x0001
-#define PCI_PROBE_CONF1		0x0002
-#define PCI_PROBE_CONF2		0x0004
-#define PCI_PROBE_MMCONF	0x0008
-#define PCI_PROBE_MASK		0x000f
-#define PCI_PROBE_NOEARLY	0x0010
-
-#define PCI_NO_CHECKS		0x0400
-#define PCI_USE_PIRQ_MASK	0x0800
-#define PCI_ASSIGN_ROMS		0x1000
-#define PCI_BIOS_IRQ_SCAN	0x2000
-#define PCI_ASSIGN_ALL_BUSSES	0x4000
-#define PCI_CAN_SKIP_ISA_ALIGN	0x8000
-#define PCI_USE__CRS		0x10000
-#define PCI_CHECK_ENABLE_AMD_MMCONF	0x20000
-#define PCI_HAS_IO_ECS		0x40000
-#define PCI_NOASSIGN_ROMS	0x80000
-
-extern unsigned int pci_probe;
-extern unsigned long pirq_table_addr;
-
-enum pci_bf_sort_state {
-	pci_bf_sort_default,
-	pci_force_nobf,
-	pci_force_bf,
-	pci_dmi_bf,
-};
-
-/* pci-i386.c */
-
-extern unsigned int pcibios_max_latency;
-
-void pcibios_resource_survey(void);
-
-/* pci-pc.c */
-
-extern int pcibios_last_bus;
-extern struct pci_bus *pci_root_bus;
-extern struct pci_ops pci_root_ops;
-
-/* pci-irq.c */
-
-struct irq_info {
-	u8 bus, devfn;			/* Bus, device and function */
-	struct {
-		u8 link;		/* IRQ line ID, chipset dependent, 0=not routed */
-		u16 bitmap;		/* Available IRQs */
-	} __attribute__((packed)) irq[4];
-	u8 slot;			/* Slot number, 0=onboard */
-	u8 rfu;
-} __attribute__((packed));
-
-struct irq_routing_table {
-	u32 signature;			/* PIRQ_SIGNATURE should be here */
-	u16 version;			/* PIRQ_VERSION */
-	u16 size;			/* Table size in bytes */
-	u8 rtr_bus, rtr_devfn;		/* Where the interrupt router lies */
-	u16 exclusive_irqs;		/* IRQs devoted exclusively to PCI usage */
-	u16 rtr_vendor, rtr_device;	/* Vendor and device ID of interrupt router */
-	u32 miniport_data;		/* Crap */
-	u8 rfu[11];
-	u8 checksum;			/* Modulo 256 checksum must give zero */
-	struct irq_info slots[0];
-} __attribute__((packed));
-
-extern unsigned int pcibios_irq_mask;
-
-extern int pcibios_scanned;
-extern spinlock_t pci_config_lock;
-
-extern int (*pcibios_enable_irq)(struct pci_dev *dev);
-extern void (*pcibios_disable_irq)(struct pci_dev *dev);
-
-struct pci_raw_ops {
-	int (*read)(unsigned int domain, unsigned int bus, unsigned int devfn,
-						int reg, int len, u32 *val);
-	int (*write)(unsigned int domain, unsigned int bus, unsigned int devfn,
-						int reg, int len, u32 val);
-};
-
-extern struct pci_raw_ops *raw_pci_ops;
-extern struct pci_raw_ops *raw_pci_ext_ops;
-
-extern struct pci_raw_ops pci_direct_conf1;
-extern bool port_cf9_safe;
-
-/* arch_initcall level */
-extern int pci_direct_probe(void);
-extern void pci_direct_init(int type);
-extern void pci_pcbios_init(void);
-extern int pci_olpc_init(void);
-extern void __init dmi_check_pciprobe(void);
-extern void __init dmi_check_skip_isa_align(void);
-
-/* some common used subsys_initcalls */
-extern int __init pci_acpi_init(void);
-extern int __init pcibios_irq_init(void);
-extern int __init pci_visws_init(void);
-extern int __init pci_numaq_init(void);
-extern int __init pcibios_init(void);
-
-/* pci-mmconfig.c */
-
-extern int __init pci_mmcfg_arch_init(void);
-extern void __init pci_mmcfg_arch_free(void);
-
-/*
- * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
- * on their northbrige except through the * %eax register. As such, you MUST
- * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
- * accessor functions.
- * In fact just use pci_config_*, nothing else please.
- */
-static inline unsigned char mmio_config_readb(void __iomem *pos)
-{
-	u8 val;
-	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline unsigned short mmio_config_readw(void __iomem *pos)
-{
-	u16 val;
-	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline unsigned int mmio_config_readl(void __iomem *pos)
-{
-	u32 val;
-	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline void mmio_config_writeb(void __iomem *pos, u8 val)
-{
-	asm volatile("movb %%al,(%1)" :: "a" (val), "r" (pos) : "memory");
-}
-
-static inline void mmio_config_writew(void __iomem *pos, u16 val)
-{
-	asm volatile("movw %%ax,(%1)" :: "a" (val), "r" (pos) : "memory");
-}
-
-static inline void mmio_config_writel(void __iomem *pos, u32 val)
-{
-	asm volatile("movl %%eax,(%1)" :: "a" (val), "r" (pos) : "memory");
-}
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 42f4cb1..16d0c0e 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -9,11 +9,10 @@
 #include <linux/init.h>
 
 #include <asm/setup.h>
+#include <asm/pci_x86.h>
 #include <asm/visws/cobalt.h>
 #include <asm/visws/lithium.h>
 
-#include "pci.h"
-
 static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
 static void pci_visws_disable_irq(struct pci_dev *dev) { }
 
-- 
1.5.5.1



