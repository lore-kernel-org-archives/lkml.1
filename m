Return-Path: <linux-kernel-owner+w=401wt.eu-S1759584AbYGKLJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759584AbYGKLJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 07:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755613AbYGKLCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 07:02:53 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:37263 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbYGKLCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 07:02:51 -0400
X-BigFish: VPS25(zzzz10d3izz5a6ciz32i87il43j67h)
X-Spam-TCS-SCL: 6:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3U9CB-02-S0T-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 1/2] x86/pci: renamed: numa.c -> numaq_32.c
Date: Fri, 11 Jul 2008 12:18:40 +0200
Message-ID: <1215771521-6848-2-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1215771521-6848-1-git-send-email-robert.richter@amd.com>
References: <1215771521-6848-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Jul 2008 11:02:35.0820 (UTC) FILETIME=[A01776C0:01C8E345]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/pci/Makefile   |    2 +-
 arch/x86/pci/numa.c     |  178 -----------------------------------------------
 arch/x86/pci/numaq_32.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 179 insertions(+), 179 deletions(-)
 delete mode 100644 arch/x86/pci/numa.c
 create mode 100644 arch/x86/pci/numaq_32.c

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 28451f4..d49202e 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -11,7 +11,7 @@ obj-y				+= legacy.o irq.o
 
 obj-$(CONFIG_X86_VISWS)		+= visws.o
 
-obj-$(CONFIG_X86_NUMAQ)		+= numa.o
+obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
 obj-y				+= common.o early.o
 obj-y				+= amd_bus.o
diff --git a/arch/x86/pci/numa.c b/arch/x86/pci/numa.c
deleted file mode 100644
index 8b5ca19..0000000
--- a/arch/x86/pci/numa.c
+++ /dev/null
@@ -1,178 +0,0 @@
-/*
- * numa.c - Low-level PCI access for NUMA-Q machines
- */
-
-#include <linux/pci.h>
-#include <linux/init.h>
-#include <linux/nodemask.h>
-#include <mach_apic.h>
-#include <asm/mpspec.h>
-#include "pci.h"
-
-#define XQUAD_PORTIO_BASE 0xfe400000
-#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
-
-#define BUS2QUAD(global) (mp_bus_id_to_node[global])
-
-#define BUS2LOCAL(global) (mp_bus_id_to_local[global])
-
-#define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
-
-/* Where the IO area was mapped on multiquad, always 0 otherwise */
-void *xquad_portio;
-EXPORT_SYMBOL(xquad_portio);
-
-#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
-
-#define PCI_CONF1_MQ_ADDRESS(bus, devfn, reg) \
-	(0x80000000 | (BUS2LOCAL(bus) << 16) | (devfn << 8) | (reg & ~3))
-
-static void write_cf8(unsigned bus, unsigned devfn, unsigned reg)
-{
-	unsigned val = PCI_CONF1_MQ_ADDRESS(bus, devfn, reg);
-	if (xquad_portio)
-		writel(val, XQUAD_PORT_ADDR(0xcf8, BUS2QUAD(bus)));
-	else
-		outl(val, 0xCF8);
-}
-
-static int pci_conf1_mq_read(unsigned int seg, unsigned int bus,
-			     unsigned int devfn, int reg, int len, u32 *value)
-{
-	unsigned long flags;
-	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
-
-	if (!value || (bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255))
-		return -EINVAL;
-
-	spin_lock_irqsave(&pci_config_lock, flags);
-
-	write_cf8(bus, devfn, reg);
-
-	switch (len) {
-	case 1:
-		if (xquad_portio)
-			*value = readb(adr + (reg & 3));
-		else
-			*value = inb(0xCFC + (reg & 3));
-		break;
-	case 2:
-		if (xquad_portio)
-			*value = readw(adr + (reg & 2));
-		else
-			*value = inw(0xCFC + (reg & 2));
-		break;
-	case 4:
-		if (xquad_portio)
-			*value = readl(adr);
-		else
-			*value = inl(0xCFC);
-		break;
-	}
-
-	spin_unlock_irqrestore(&pci_config_lock, flags);
-
-	return 0;
-}
-
-static int pci_conf1_mq_write(unsigned int seg, unsigned int bus,
-			      unsigned int devfn, int reg, int len, u32 value)
-{
-	unsigned long flags;
-	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
-
-	if ((bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255)) 
-		return -EINVAL;
-
-	spin_lock_irqsave(&pci_config_lock, flags);
-
-	write_cf8(bus, devfn, reg);
-
-	switch (len) {
-	case 1:
-		if (xquad_portio)
-			writeb(value, adr + (reg & 3));
-		else
-			outb((u8)value, 0xCFC + (reg & 3));
-		break;
-	case 2:
-		if (xquad_portio)
-			writew(value, adr + (reg & 2));
-		else
-			outw((u16)value, 0xCFC + (reg & 2));
-		break;
-	case 4:
-		if (xquad_portio)
-			writel(value, adr + reg);
-		else
-			outl((u32)value, 0xCFC);
-		break;
-	}
-
-	spin_unlock_irqrestore(&pci_config_lock, flags);
-
-	return 0;
-}
-
-#undef PCI_CONF1_MQ_ADDRESS
-
-static struct pci_raw_ops pci_direct_conf1_mq = {
-	.read	= pci_conf1_mq_read,
-	.write	= pci_conf1_mq_write
-};
-
-
-static void __devinit pci_fixup_i450nx(struct pci_dev *d)
-{
-	/*
-	 * i450NX -- Find and scan all secondary buses on all PXB's.
-	 */
-	int pxb, reg;
-	u8 busno, suba, subb;
-	int quad = BUS2QUAD(d->bus->number);
-
-	printk("PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
-	reg = 0xd0;
-	for(pxb=0; pxb<2; pxb++) {
-		pci_read_config_byte(d, reg++, &busno);
-		pci_read_config_byte(d, reg++, &suba);
-		pci_read_config_byte(d, reg++, &subb);
-		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
-		if (busno) {
-			/* Bus A */
-			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, busno));
-		}
-		if (suba < subb) {
-			/* Bus B */
-			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, suba+1));
-		}
-	}
-	pcibios_last_bus = -1;
-}
-DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82451NX, pci_fixup_i450nx);
-
-int __init pci_numa_init(void)
-{
-	int quad;
-
-	if (!found_numaq)
-		return 0;
-
-	raw_pci_ops = &pci_direct_conf1_mq;
-
-	if (pcibios_scanned++)
-		return 0;
-
-	pci_root_bus = pcibios_scan_root(0);
-	if (pci_root_bus)
-		pci_bus_add_devices(pci_root_bus);
-	if (num_online_nodes() > 1)
-		for_each_online_node(quad) {
-			if (quad == 0)
-				continue;
-			printk("Scanning PCI bus %d for quad %d\n", 
-				QUADLOCAL2BUS(quad,0), quad);
-			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, 0));
-		}
-	return 0;
-}
diff --git a/arch/x86/pci/numaq_32.c b/arch/x86/pci/numaq_32.c
new file mode 100644
index 0000000..8b5ca19
--- /dev/null
+++ b/arch/x86/pci/numaq_32.c
@@ -0,0 +1,178 @@
+/*
+ * numa.c - Low-level PCI access for NUMA-Q machines
+ */
+
+#include <linux/pci.h>
+#include <linux/init.h>
+#include <linux/nodemask.h>
+#include <mach_apic.h>
+#include <asm/mpspec.h>
+#include "pci.h"
+
+#define XQUAD_PORTIO_BASE 0xfe400000
+#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
+
+#define BUS2QUAD(global) (mp_bus_id_to_node[global])
+
+#define BUS2LOCAL(global) (mp_bus_id_to_local[global])
+
+#define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
+
+/* Where the IO area was mapped on multiquad, always 0 otherwise */
+void *xquad_portio;
+EXPORT_SYMBOL(xquad_portio);
+
+#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
+
+#define PCI_CONF1_MQ_ADDRESS(bus, devfn, reg) \
+	(0x80000000 | (BUS2LOCAL(bus) << 16) | (devfn << 8) | (reg & ~3))
+
+static void write_cf8(unsigned bus, unsigned devfn, unsigned reg)
+{
+	unsigned val = PCI_CONF1_MQ_ADDRESS(bus, devfn, reg);
+	if (xquad_portio)
+		writel(val, XQUAD_PORT_ADDR(0xcf8, BUS2QUAD(bus)));
+	else
+		outl(val, 0xCF8);
+}
+
+static int pci_conf1_mq_read(unsigned int seg, unsigned int bus,
+			     unsigned int devfn, int reg, int len, u32 *value)
+{
+	unsigned long flags;
+	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
+
+	if (!value || (bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255))
+		return -EINVAL;
+
+	spin_lock_irqsave(&pci_config_lock, flags);
+
+	write_cf8(bus, devfn, reg);
+
+	switch (len) {
+	case 1:
+		if (xquad_portio)
+			*value = readb(adr + (reg & 3));
+		else
+			*value = inb(0xCFC + (reg & 3));
+		break;
+	case 2:
+		if (xquad_portio)
+			*value = readw(adr + (reg & 2));
+		else
+			*value = inw(0xCFC + (reg & 2));
+		break;
+	case 4:
+		if (xquad_portio)
+			*value = readl(adr);
+		else
+			*value = inl(0xCFC);
+		break;
+	}
+
+	spin_unlock_irqrestore(&pci_config_lock, flags);
+
+	return 0;
+}
+
+static int pci_conf1_mq_write(unsigned int seg, unsigned int bus,
+			      unsigned int devfn, int reg, int len, u32 value)
+{
+	unsigned long flags;
+	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
+
+	if ((bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255)) 
+		return -EINVAL;
+
+	spin_lock_irqsave(&pci_config_lock, flags);
+
+	write_cf8(bus, devfn, reg);
+
+	switch (len) {
+	case 1:
+		if (xquad_portio)
+			writeb(value, adr + (reg & 3));
+		else
+			outb((u8)value, 0xCFC + (reg & 3));
+		break;
+	case 2:
+		if (xquad_portio)
+			writew(value, adr + (reg & 2));
+		else
+			outw((u16)value, 0xCFC + (reg & 2));
+		break;
+	case 4:
+		if (xquad_portio)
+			writel(value, adr + reg);
+		else
+			outl((u32)value, 0xCFC);
+		break;
+	}
+
+	spin_unlock_irqrestore(&pci_config_lock, flags);
+
+	return 0;
+}
+
+#undef PCI_CONF1_MQ_ADDRESS
+
+static struct pci_raw_ops pci_direct_conf1_mq = {
+	.read	= pci_conf1_mq_read,
+	.write	= pci_conf1_mq_write
+};
+
+
+static void __devinit pci_fixup_i450nx(struct pci_dev *d)
+{
+	/*
+	 * i450NX -- Find and scan all secondary buses on all PXB's.
+	 */
+	int pxb, reg;
+	u8 busno, suba, subb;
+	int quad = BUS2QUAD(d->bus->number);
+
+	printk("PCI: Searching for i450NX host bridges on %s\n", pci_name(d));
+	reg = 0xd0;
+	for(pxb=0; pxb<2; pxb++) {
+		pci_read_config_byte(d, reg++, &busno);
+		pci_read_config_byte(d, reg++, &suba);
+		pci_read_config_byte(d, reg++, &subb);
+		DBG("i450NX PXB %d: %02x/%02x/%02x\n", pxb, busno, suba, subb);
+		if (busno) {
+			/* Bus A */
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, busno));
+		}
+		if (suba < subb) {
+			/* Bus B */
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, suba+1));
+		}
+	}
+	pcibios_last_bus = -1;
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82451NX, pci_fixup_i450nx);
+
+int __init pci_numa_init(void)
+{
+	int quad;
+
+	if (!found_numaq)
+		return 0;
+
+	raw_pci_ops = &pci_direct_conf1_mq;
+
+	if (pcibios_scanned++)
+		return 0;
+
+	pci_root_bus = pcibios_scan_root(0);
+	if (pci_root_bus)
+		pci_bus_add_devices(pci_root_bus);
+	if (num_online_nodes() > 1)
+		for_each_online_node(quad) {
+			if (quad == 0)
+				continue;
+			printk("Scanning PCI bus %d for quad %d\n", 
+				QUADLOCAL2BUS(quad,0), quad);
+			pci_scan_bus_with_sysdata(QUADLOCAL2BUS(quad, 0));
+		}
+	return 0;
+}
-- 
1.5.5.4


