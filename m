Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYEMLn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYEMLn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 07:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753371AbYEMLnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 07:43:24 -0400
Received: from yugo.dsd.sztaki.hu ([195.111.2.114]:52992 "EHLO
	yugo.frugalware.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851AbYEMLnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 07:43:21 -0400
From: Miklos Vajna <vmiklos@frugalware.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] x86: janitor work in irq.c
Date: Tue, 13 May 2008 13:35:27 +0200
Message-Id: <3b7c2a481a341e549024f8672f5752332356855a.1210678238.git.vmiklos@frugalware.org>
X-Mailer: git-send-email 1.5.5.1.211.g65ea3.dirty
In-Reply-To: <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
 <fe3003f39869f8773950d23bb73efe42b5cf07a5.1210678238.git.vmiklos@frugalware.org>
In-Reply-To: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
References: <8779a478ff43d6ed589279078d2abbab789a2dc9.1210678238.git.vmiklos@frugalware.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrapped long lines, removed trailing whitespaces, fixed case indentation
inside switch and so.

Signed-off-by: Miklos Vajna <vmiklos@frugalware.org>
---
 arch/x86/pci/irq.c |  503 +++++++++++++++++++++++++++++-----------------------
 1 files changed, 283 insertions(+), 220 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 0908fca..81fb67d 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -11,8 +11,8 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/dmi.h>
-#include <asm/io.h>
-#include <asm/smp.h>
+#include <linux/io.h>
+#include <linux/smp.h>
 #include <asm/io_apic.h>
 #include <linux/irq.h>
 #include <linux/acpi.h>
@@ -45,7 +45,8 @@ struct irq_router {
 	char *name;
 	u16 vendor, device;
 	int (*get)(struct pci_dev *router, struct pci_dev *dev, int pirq);
-	int (*set)(struct pci_dev *router, struct pci_dev *dev, int pirq, int new);
+	int (*set)(struct pci_dev *router, struct pci_dev *dev, int pirq,
+		int new);
 };
 
 struct irq_router_handler {
@@ -61,7 +62,7 @@ void (*pcibios_disable_irq)(struct pci_dev *dev) = NULL;
  *  and perform checksum verification.
  */
 
-static inline struct irq_routing_table * pirq_check_routing_table(u8 *addr)
+static inline struct irq_routing_table *pirq_check_routing_table(u8 *addr)
 {
 	struct irq_routing_table *rt;
 	int i;
@@ -74,10 +75,11 @@ static inline struct irq_routing_table * pirq_check_routing_table(u8 *addr)
 	    rt->size < sizeof(struct irq_routing_table))
 		return NULL;
 	sum = 0;
-	for (i=0; i < rt->size; i++)
+	for (i = 0; i < rt->size; i++)
 		sum += addr[i];
 	if (!sum) {
-		DBG(KERN_DEBUG "PCI: Interrupt Routing Table found at 0x%p\n", rt);
+		DBG(KERN_DEBUG "PCI: Interrupt Routing Table found at 0x%p\n",
+			rt);
 		return rt;
 	}
 	return NULL;
@@ -100,7 +102,8 @@ static struct irq_routing_table * __init pirq_find_routing_table(void)
 			return rt;
 		printk(KERN_WARNING "PCI: PIRQ table NOT found at pirqaddr\n");
 	}
-	for(addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000); addr += 16) {
+	for (addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000);
+		addr += 16) {
 		rt = pirq_check_routing_table(addr);
 		if (rt)
 			return rt;
@@ -122,20 +125,23 @@ static void __init pirq_peer_trick(void)
 	struct irq_info *e;
 
 	memset(busmap, 0, sizeof(busmap));
-	for(i=0; i < (rt->size - sizeof(struct irq_routing_table)) / sizeof(struct irq_info); i++) {
+	for (i = 0; i < (rt->size - sizeof(struct irq_routing_table)) /
+		sizeof(struct irq_info); i++) {
 		e = &rt->slots[i];
 #ifdef DEBUG
 		{
 			int j;
-			DBG(KERN_DEBUG "%02x:%02x slot=%02x", e->bus, e->devfn/8, e->slot);
-			for(j=0; j<4; j++)
-				DBG(" %d:%02x/%04x", j, e->irq[j].link, e->irq[j].bitmap);
+			DBG(KERN_DEBUG "%02x:%02x slot=%02x", e->bus,
+				e->devfn/8, e->slot);
+			for (j = 0; j < 4; j++)
+				DBG(" %d:%02x/%04x", j, e->irq[j].link,
+					e->irq[j].bitmap);
 			DBG("\n");
 		}
 #endif
 		busmap[e->bus] = 1;
 	}
-	for(i = 1; i < 256; i++) {
+	for (i = 1; i < 256; i++) {
 		int node;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
@@ -174,7 +180,8 @@ void eisa_set_level_irq(unsigned int irq)
  * Common IRQ routing practice: nibbles in config space,
  * offset by some magic constant.
  */
-static unsigned int read_config_nybble(struct pci_dev *router, unsigned offset, unsigned nr)
+static unsigned int read_config_nybble(struct pci_dev *router, unsigned offset,
+	unsigned nr)
 {
 	u8 x;
 	unsigned reg = offset + (nr >> 1);
@@ -183,7 +190,8 @@ static unsigned int read_config_nybble(struct pci_dev *router, unsigned offset,
 	return (nr & 1) ? (x >> 4) : (x & 0xf);
 }
 
-static void write_config_nybble(struct pci_dev *router, unsigned offset, unsigned nr, unsigned int val)
+static void write_config_nybble(struct pci_dev *router, unsigned offset,
+	unsigned nr, unsigned int val)
 {
 	u8 x;
 	unsigned reg = offset + (nr >> 1);
@@ -200,15 +208,18 @@ static void write_config_nybble(struct pci_dev *router, unsigned offset, unsigne
  */
 static int pirq_ali_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 {
-	static const unsigned char irqmap[16] = { 0, 9, 3, 10, 4, 5, 7, 6, 1, 11, 0, 12, 0, 14, 0, 15 };
+	static const unsigned char irqmap[16] = { 0, 9, 3, 10, 4, 5, 7, 6, 1,
+		11, 0, 12, 0, 14, 0, 15 };
 
 	WARN_ON_ONCE(pirq > 16);
 	return irqmap[read_config_nybble(router, 0x48, pirq-1)];
 }
 
-static int pirq_ali_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_ali_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+	int irq)
 {
-	static const unsigned char irqmap[16] = { 0, 8, 0, 2, 4, 5, 7, 6, 0, 1, 3, 9, 11, 0, 13, 15 };
+	static const unsigned char irqmap[16] = { 0, 8, 0, 2, 4, 5, 7, 6, 0, 1,
+		3, 9, 11, 0, 13, 15 };
 	unsigned int val = irqmap[irq];
 
 	WARN_ON_ONCE(pirq > 16);
@@ -231,7 +242,8 @@ static int pirq_piix_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	return (x < 16) ? x : 0;
 }
 
-static int pirq_piix_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_piix_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+	int irq)
 {
 	pci_write_config_byte(router, pirq, irq);
 	return 1;
@@ -247,7 +259,8 @@ static int pirq_via_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	return read_config_nybble(router, 0x55, pirq == 4 ? 5 : pirq);
 }
 
-static int pirq_via_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_via_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+	int irq)
 {
 	write_config_nybble(router, 0x55, pirq == 4 ? 5 : pirq, irq);
 	return 1;
@@ -258,7 +271,8 @@ static int pirq_via_set(struct pci_dev *router, struct pci_dev *dev, int pirq, i
  * but without the ugly irq number munging.
  * However, for 82C586, nibble map is different .
  */
-static int pirq_via586_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
+static int pirq_via586_get(struct pci_dev *router, struct pci_dev *dev,
+	int pirq)
 {
 	static const unsigned int pirqmap[5] = { 3, 2, 5, 1, 1 };
 
@@ -266,7 +280,8 @@ static int pirq_via586_get(struct pci_dev *router, struct pci_dev *dev, int pirq
 	return read_config_nybble(router, 0x55, pirqmap[pirq-1]);
 }
 
-static int pirq_via586_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_via586_set(struct pci_dev *router, struct pci_dev *dev,
+	int pirq, int irq)
 {
 	static const unsigned int pirqmap[5] = { 3, 2, 5, 1, 1 };
 
@@ -285,10 +300,11 @@ static int pirq_ite_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	static const unsigned char pirqmap[4] = { 1, 0, 2, 3 };
 
 	WARN_ON_ONCE(pirq > 4);
-	return read_config_nybble(router,0x43, pirqmap[pirq-1]);
+	return read_config_nybble(router, 0x43, pirqmap[pirq-1]);
 }
 
-static int pirq_ite_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_ite_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+	int irq)
 {
 	static const unsigned char pirqmap[4] = { 1, 0, 2, 3 };
 
@@ -306,7 +322,8 @@ static int pirq_opti_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	return read_config_nybble(router, 0xb8, pirq >> 4);
 }
 
-static int pirq_opti_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_opti_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+		int irq)
 {
 	write_config_nybble(router, 0xb8, pirq >> 4, irq);
 	return 1;
@@ -314,7 +331,7 @@ static int pirq_opti_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
 
 /*
  * Cyrix: nibble offset 0x5C
- * 0x5C bits 7:4 is INTB bits 3:0 is INTA 
+ * 0x5C bits 7:4 is INTB bits 3:0 is INTA
  * 0x5D bits 7:4 is INTD bits 3:0 is INTC
  */
 static int pirq_cyrix_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
@@ -322,7 +339,8 @@ static int pirq_cyrix_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	return read_config_nybble(router, 0x5C, (pirq-1)^1);
 }
 
-static int pirq_cyrix_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_cyrix_set(struct pci_dev *router, struct pci_dev *dev,
+	int pirq, int irq)
 {
 	write_config_nybble(router, 0x5C, (pirq-1)^1, irq);
 	return 1;
@@ -350,7 +368,7 @@ static int pirq_cyrix_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
  *	Apparently there are systems implementing PCI routing table using
  *	link values 0x01-0x04 and others using 0x41-0x44 for PCI INTA..D.
  *	We try our best to handle both link mappings.
- *	
+ *
  *	Currently (2003-05-21) it appears most SiS chipsets follow the
  *	definition of routing registers from the SiS-5595 southbridge.
  *	According to the SiS 5595 datasheets the revision id's of the
@@ -370,7 +388,7 @@ static int pirq_cyrix_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
  *
  *	0x62:	USBIRQ:
  *		bit 6 OHCI function disabled (0), enabled (1)
- *	
+ *
  *	0x6a:	ACPI/SCI IRQ: bits 4-6 reserved
  *
  *	0x7e:	Data Acq. Module IRQ - bits 4-6 reserved
@@ -405,7 +423,8 @@ static int pirq_sis_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	return (x & PIRQ_SIS_IRQ_DISABLE) ? 0 : (x & PIRQ_SIS_IRQ_MASK);
 }
 
-static int pirq_sis_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_sis_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+	int irq)
 {
 	u8 x;
 	int reg;
@@ -439,7 +458,8 @@ static int pirq_vlsi_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
 	return read_config_nybble(router, 0x74, pirq-1);
 }
 
-static int pirq_vlsi_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_vlsi_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+	int irq)
 {
 	WARN_ON_ONCE(pirq >= 9);
 	if (pirq > 8) {
@@ -461,13 +481,15 @@ static int pirq_vlsi_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
  * 0x00 for ACPI (SCI), 0x01 for USB, 0x02 for IDE0, 0x04 for IDE1,
  * and 0x03 for SMBus.
  */
-static int pirq_serverworks_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
+static int pirq_serverworks_get(struct pci_dev *router, struct pci_dev *dev,
+	int pirq)
 {
 	outb(pirq, 0xc00);
 	return inb(0xc01) & 0xf;
 }
 
-static int pirq_serverworks_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_serverworks_set(struct pci_dev *router, struct pci_dev *dev,
+	int pirq, int irq)
 {
 	outb(pirq, 0xc00);
 	outb(irq, 0xc01);
@@ -482,27 +504,25 @@ static int pirq_serverworks_set(struct pci_dev *router, struct pci_dev *dev, int
  * offset 0x56 0-3 PIRQA  4-7  PIRQB
  * offset 0x57 0-3 PIRQC  4-7  PIRQD
  */
-static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev, int pirq)
+static int pirq_amd756_get(struct pci_dev *router, struct pci_dev *dev,
+	int pirq)
 {
 	u8 irq;
 	irq = 0;
 	if (pirq <= 4)
-	{
 		irq = read_config_nybble(router, 0x56, pirq - 1);
-	}
-	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d get irq : %2d\n",
-		dev->vendor, dev->device, pirq, irq);
+	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d "
+		"get irq : %2d\n", dev->vendor, dev->device, pirq, irq);
 	return irq;
 }
 
-static int pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_amd756_set(struct pci_dev *router, struct pci_dev *dev,
+	int pirq, int irq)
 {
-	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d SET irq : %2d\n", 
-		dev->vendor, dev->device, pirq, irq);
+	printk(KERN_INFO "AMD756: dev %04x:%04x, router pirq : %d "
+		"SET irq : %2d\n", dev->vendor, dev->device, pirq, irq);
 	if (pirq <= 4)
-	{
 		write_config_nybble(router, 0x56, pirq - 1, irq);
-	}
 	return 1;
 }
 
@@ -528,7 +548,8 @@ static int pirq_pico_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
 
 #ifdef CONFIG_PCI_BIOS
 
-static int pirq_bios_set(struct pci_dev *router, struct pci_dev *dev, int pirq, int irq)
+static int pirq_bios_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
+	int irq)
 {
 	struct pci_dev *bridge;
 	int pin = pci_get_interrupt_pin(dev, &bridge);
@@ -537,11 +558,14 @@ static int pirq_bios_set(struct pci_dev *router, struct pci_dev *dev, int pirq,
 
 #endif
 
-static __init int intel_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int intel_router_probe(struct irq_router *r,
+	struct pci_dev *router, u16 device)
 {
 	static struct pci_device_id __initdata pirq_440gx[] = {
-		{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443GX_0) },
-		{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443GX_2) },
+		{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
+			PCI_DEVICE_ID_INTEL_82443GX_0) },
+		{ PCI_DEVICE(PCI_VENDOR_ID_INTEL,
+			PCI_DEVICE_ID_INTEL_82443GX_2) },
 		{ },
 	};
 
@@ -549,50 +573,49 @@ static __init int intel_router_probe(struct irq_router *r, struct pci_dev *route
 	if (pci_dev_present(pirq_440gx))
 		return 0;
 
-	switch(device)
-	{
-		case PCI_DEVICE_ID_INTEL_82371FB_0:
-		case PCI_DEVICE_ID_INTEL_82371SB_0:
-		case PCI_DEVICE_ID_INTEL_82371AB_0:
-		case PCI_DEVICE_ID_INTEL_82371MX:
-		case PCI_DEVICE_ID_INTEL_82443MX_0:
-		case PCI_DEVICE_ID_INTEL_82801AA_0:
-		case PCI_DEVICE_ID_INTEL_82801AB_0:
-		case PCI_DEVICE_ID_INTEL_82801BA_0:
-		case PCI_DEVICE_ID_INTEL_82801BA_10:
-		case PCI_DEVICE_ID_INTEL_82801CA_0:
-		case PCI_DEVICE_ID_INTEL_82801CA_12:
-		case PCI_DEVICE_ID_INTEL_82801DB_0:
-		case PCI_DEVICE_ID_INTEL_82801E_0:
-		case PCI_DEVICE_ID_INTEL_82801EB_0:
-		case PCI_DEVICE_ID_INTEL_ESB_1:
-		case PCI_DEVICE_ID_INTEL_ICH6_0:
-		case PCI_DEVICE_ID_INTEL_ICH6_1:
-		case PCI_DEVICE_ID_INTEL_ICH7_0:
-		case PCI_DEVICE_ID_INTEL_ICH7_1:
-		case PCI_DEVICE_ID_INTEL_ICH7_30:
-		case PCI_DEVICE_ID_INTEL_ICH7_31:
-		case PCI_DEVICE_ID_INTEL_ESB2_0:
-		case PCI_DEVICE_ID_INTEL_ICH8_0:
-		case PCI_DEVICE_ID_INTEL_ICH8_1:
-		case PCI_DEVICE_ID_INTEL_ICH8_2:
-		case PCI_DEVICE_ID_INTEL_ICH8_3:
-		case PCI_DEVICE_ID_INTEL_ICH8_4:
-		case PCI_DEVICE_ID_INTEL_ICH9_0:
-		case PCI_DEVICE_ID_INTEL_ICH9_1:
-		case PCI_DEVICE_ID_INTEL_ICH9_2:
-		case PCI_DEVICE_ID_INTEL_ICH9_3:
-		case PCI_DEVICE_ID_INTEL_ICH9_4:
-		case PCI_DEVICE_ID_INTEL_ICH9_5:
-		case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
-		case PCI_DEVICE_ID_INTEL_ICH10_0:
-		case PCI_DEVICE_ID_INTEL_ICH10_1:
-		case PCI_DEVICE_ID_INTEL_ICH10_2:
-		case PCI_DEVICE_ID_INTEL_ICH10_3:
-			r->name = "PIIX/ICH";
-			r->get = pirq_piix_get;
-			r->set = pirq_piix_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_INTEL_82371FB_0:
+	case PCI_DEVICE_ID_INTEL_82371SB_0:
+	case PCI_DEVICE_ID_INTEL_82371AB_0:
+	case PCI_DEVICE_ID_INTEL_82371MX:
+	case PCI_DEVICE_ID_INTEL_82443MX_0:
+	case PCI_DEVICE_ID_INTEL_82801AA_0:
+	case PCI_DEVICE_ID_INTEL_82801AB_0:
+	case PCI_DEVICE_ID_INTEL_82801BA_0:
+	case PCI_DEVICE_ID_INTEL_82801BA_10:
+	case PCI_DEVICE_ID_INTEL_82801CA_0:
+	case PCI_DEVICE_ID_INTEL_82801CA_12:
+	case PCI_DEVICE_ID_INTEL_82801DB_0:
+	case PCI_DEVICE_ID_INTEL_82801E_0:
+	case PCI_DEVICE_ID_INTEL_82801EB_0:
+	case PCI_DEVICE_ID_INTEL_ESB_1:
+	case PCI_DEVICE_ID_INTEL_ICH6_0:
+	case PCI_DEVICE_ID_INTEL_ICH6_1:
+	case PCI_DEVICE_ID_INTEL_ICH7_0:
+	case PCI_DEVICE_ID_INTEL_ICH7_1:
+	case PCI_DEVICE_ID_INTEL_ICH7_30:
+	case PCI_DEVICE_ID_INTEL_ICH7_31:
+	case PCI_DEVICE_ID_INTEL_ESB2_0:
+	case PCI_DEVICE_ID_INTEL_ICH8_0:
+	case PCI_DEVICE_ID_INTEL_ICH8_1:
+	case PCI_DEVICE_ID_INTEL_ICH8_2:
+	case PCI_DEVICE_ID_INTEL_ICH8_3:
+	case PCI_DEVICE_ID_INTEL_ICH8_4:
+	case PCI_DEVICE_ID_INTEL_ICH9_0:
+	case PCI_DEVICE_ID_INTEL_ICH9_1:
+	case PCI_DEVICE_ID_INTEL_ICH9_2:
+	case PCI_DEVICE_ID_INTEL_ICH9_3:
+	case PCI_DEVICE_ID_INTEL_ICH9_4:
+	case PCI_DEVICE_ID_INTEL_ICH9_5:
+	case PCI_DEVICE_ID_INTEL_TOLAPAI_0:
+	case PCI_DEVICE_ID_INTEL_ICH10_0:
+	case PCI_DEVICE_ID_INTEL_ICH10_1:
+	case PCI_DEVICE_ID_INTEL_ICH10_2:
+	case PCI_DEVICE_ID_INTEL_ICH10_3:
+		r->name = "PIIX/ICH";
+		r->get = pirq_piix_get;
+		r->set = pirq_piix_set;
+		return 1;
 	}
 	return 0;
 }
@@ -606,7 +629,7 @@ static __init int via_router_probe(struct irq_router *r,
 	 * workarounds for some buggy BIOSes
 	 */
 	if (device == PCI_DEVICE_ID_VIA_82C586_0) {
-		switch(router->device) {
+		switch (router->device) {
 		case PCI_DEVICE_ID_VIA_82C686:
 			/*
 			 * Asus k7m bios wrongly reports 82C686A
@@ -624,7 +647,7 @@ static __init int via_router_probe(struct irq_router *r,
 		}
 	}
 
-	switch(device) {
+	switch (device) {
 	case PCI_DEVICE_ID_VIA_82C586_0:
 		r->name = "VIA";
 		r->get = pirq_via586_get;
@@ -645,88 +668,89 @@ static __init int via_router_probe(struct irq_router *r,
 	return 0;
 }
 
-static __init int vlsi_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int vlsi_router_probe(struct irq_router *r,
+	struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_VLSI_82C534:
-			r->name = "VLSI 82C534";
-			r->get = pirq_vlsi_get;
-			r->set = pirq_vlsi_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_VLSI_82C534:
+		r->name = "VLSI 82C534";
+		r->get = pirq_vlsi_get;
+		r->set = pirq_vlsi_set;
+		return 1;
 	}
 	return 0;
 }
 
 
-static __init int serverworks_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int serverworks_router_probe(struct irq_router *r,
+		struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_SERVERWORKS_OSB4:
-		case PCI_DEVICE_ID_SERVERWORKS_CSB5:
-			r->name = "ServerWorks";
-			r->get = pirq_serverworks_get;
-			r->set = pirq_serverworks_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_SERVERWORKS_OSB4:
+	case PCI_DEVICE_ID_SERVERWORKS_CSB5:
+		r->name = "ServerWorks";
+		r->get = pirq_serverworks_get;
+		r->set = pirq_serverworks_set;
+		return 1;
 	}
 	return 0;
 }
 
-static __init int sis_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int sis_router_probe(struct irq_router *r, struct pci_dev *router,
+	u16 device)
 {
 	if (device != PCI_DEVICE_ID_SI_503)
 		return 0;
-		
+
 	r->name = "SIS";
 	r->get = pirq_sis_get;
 	r->set = pirq_sis_set;
 	return 1;
 }
 
-static __init int cyrix_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int cyrix_router_probe(struct irq_router *r,
+	struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_CYRIX_5520:
-			r->name = "NatSemi";
-			r->get = pirq_cyrix_get;
-			r->set = pirq_cyrix_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_CYRIX_5520:
+		r->name = "NatSemi";
+		r->get = pirq_cyrix_get;
+		r->set = pirq_cyrix_set;
+		return 1;
 	}
 	return 0;
 }
 
-static __init int opti_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int opti_router_probe(struct irq_router *r,
+	struct pci_dev *router, u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_OPTI_82C700:
-			r->name = "OPTI";
-			r->get = pirq_opti_get;
-			r->set = pirq_opti_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_OPTI_82C700:
+		r->name = "OPTI";
+		r->get = pirq_opti_get;
+		r->set = pirq_opti_set;
+		return 1;
 	}
 	return 0;
 }
 
-static __init int ite_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int ite_router_probe(struct irq_router *r, struct pci_dev *router,
+	u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_ITE_IT8330G_0:
-			r->name = "ITE";
-			r->get = pirq_ite_get;
-			r->set = pirq_ite_set;
-			return 1;
+	switch (device) {
+	case PCI_DEVICE_ID_ITE_IT8330G_0:
+		r->name = "ITE";
+		r->get = pirq_ite_get;
+		r->set = pirq_ite_set;
+		return 1;
 	}
 	return 0;
 }
 
-static __init int ali_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int ali_router_probe(struct irq_router *r, struct pci_dev *router,
+	u16 device)
 {
-	switch(device)
-	{
+	switch (device) {
 	case PCI_DEVICE_ID_AL_M1533:
 	case PCI_DEVICE_ID_AL_M1563:
 		printk(KERN_DEBUG "PCI: Using ALI IRQ Router\n");
@@ -738,28 +762,29 @@ static __init int ali_router_probe(struct irq_router *r, struct pci_dev *router,
 	return 0;
 }
 
-static __init int amd_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+static __init int amd_router_probe(struct irq_router *r, struct pci_dev *router,
+	u16 device)
 {
-	switch(device)
-	{
-		case PCI_DEVICE_ID_AMD_VIPER_740B:
-			r->name = "AMD756";
-			break;
-		case PCI_DEVICE_ID_AMD_VIPER_7413:
-			r->name = "AMD766";
-			break;
-		case PCI_DEVICE_ID_AMD_VIPER_7443:
-			r->name = "AMD768";
-			break;
-		default:
-			return 0;
+	switch (device) {
+	case PCI_DEVICE_ID_AMD_VIPER_740B:
+		r->name = "AMD756";
+		break;
+	case PCI_DEVICE_ID_AMD_VIPER_7413:
+		r->name = "AMD766";
+		break;
+	case PCI_DEVICE_ID_AMD_VIPER_7443:
+		r->name = "AMD768";
+		break;
+	default:
+		return 0;
 	}
 	r->get = pirq_amd756_get;
 	r->set = pirq_amd756_set;
 	return 1;
 }
-		
-static __init int pico_router_probe(struct irq_router *r, struct pci_dev *router, u16 device)
+
+static __init int pico_router_probe(struct irq_router *r,
+	struct pci_dev *router, u16 device)
 {
 	switch (device) {
 	case PCI_DEVICE_ID_PICOPOWER_PT86C523:
@@ -800,7 +825,7 @@ static struct pci_dev *pirq_router_dev;
  *	FIXME: should we have an option to say "generic for
  *	chipset" ?
  */
- 
+
 static void __init pirq_find_router(struct irq_router *r)
 {
 	struct irq_routing_table *rt = pirq_table;
@@ -819,7 +844,7 @@ static void __init pirq_find_router(struct irq_router *r)
 	r->name = "default";
 	r->get = NULL;
 	r->set = NULL;
-	
+
 	DBG(KERN_DEBUG "PCI: Attempting to find IRQ router for %04x:%04x\n",
 	    rt->rtr_vendor, rt->rtr_device);
 
@@ -830,12 +855,14 @@ static void __init pirq_find_router(struct irq_router *r)
 		return;
 	}
 
-	for( h = pirq_routers; h->vendor; h++) {
+	for (h = pirq_routers; h->vendor; h++) {
 		/* First look for a router match */
-		if (rt->rtr_vendor == h->vendor && h->probe(r, pirq_router_dev, rt->rtr_device))
+		if (rt->rtr_vendor == h->vendor &&
+			h->probe(r, pirq_router_dev, rt->rtr_device))
 			break;
 		/* Fall back to a device match */
-		if (pirq_router_dev->vendor == h->vendor && h->probe(r, pirq_router_dev, pirq_router_dev->device))
+		if (pirq_router_dev->vendor == h->vendor &&
+			h->probe(r, pirq_router_dev, pirq_router_dev->device))
 			break;
 	}
 	printk(KERN_INFO "PCI: Using IRQ router %s [%04x/%04x] at %s\n",
@@ -850,11 +877,13 @@ static void __init pirq_find_router(struct irq_router *r)
 static struct irq_info *pirq_get_info(struct pci_dev *dev)
 {
 	struct irq_routing_table *rt = pirq_table;
-	int entries = (rt->size - sizeof(struct irq_routing_table)) / sizeof(struct irq_info);
+	int entries = (rt->size - sizeof(struct irq_routing_table)) /
+		sizeof(struct irq_info);
 	struct irq_info *info;
 
 	for (info = rt->slots; entries--; info++)
-		if (info->bus == dev->bus->number && PCI_SLOT(info->devfn) == PCI_SLOT(dev->devfn))
+		if (info->bus == dev->bus->number &&
+			PCI_SLOT(info->devfn) == PCI_SLOT(dev->devfn))
 			return info;
 	return NULL;
 }
@@ -882,7 +911,7 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 
 	if (!pirq_table)
 		return 0;
-	
+
 	DBG(KERN_DEBUG "IRQ for %s[%c]", pci_name(dev), 'A' + pin);
 	info = pirq_get_info(dev);
 	if (!info) {
@@ -895,7 +924,8 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 		DBG(" -> not routed\n" KERN_DEBUG);
 		return 0;
 	}
-	DBG(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask, pirq_table->exclusive_irqs);
+	DBG(" -> PIRQ %02x, mask %04x, excl %04x", pirq, mask,
+		pirq_table->exclusive_irqs);
 	mask &= pcibios_irq_mask;
 
 	/* Work around broken HP Pavilion Notebooks which assign USB to
@@ -908,7 +938,8 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 	}
 
 	/* same for Acer Travelmate 360, but with CB and irq 11 -> 10 */
-	if (acer_tm360_irqrouting && dev->irq == 11 && dev->vendor == PCI_VENDOR_ID_O2) {
+	if (acer_tm360_irqrouting && dev->irq == 11 &&
+		dev->vendor == PCI_VENDOR_ID_O2) {
 		pirq = 0x68;
 		mask = 0x400;
 		dev->irq = r->get(pirq_router_dev, dev, pirq);
@@ -921,17 +952,20 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 	 */
 	newirq = dev->irq;
 	if (newirq && !((1 << newirq) & mask)) {
-		if ( pci_probe & PCI_USE_PIRQ_MASK) newirq = 0;
-		else printk("\n" KERN_WARNING
-			"PCI: IRQ %i for device %s doesn't match PIRQ mask "
-			"- try pci=usepirqmask\n" KERN_DEBUG, newirq,
-			pci_name(dev));
+		if (pci_probe & PCI_USE_PIRQ_MASK)
+			newirq = 0;
+		else
+			printk("\n" KERN_WARNING
+				"PCI: IRQ %i for device %s doesn't match PIRQ "
+				"mask - try pci=usepirqmask\n" KERN_DEBUG,
+				newirq, pci_name(dev));
 	}
 	if (!newirq && assign) {
 		for (i = 0; i < 16; i++) {
 			if (!(mask & (1 << i)))
 				continue;
-			if (pirq_penalty[i] < pirq_penalty[newirq] && can_request_irq(i, IRQF_SHARED))
+			if (pirq_penalty[i] < pirq_penalty[newirq] &&
+				can_request_irq(i, IRQF_SHARED))
 				newirq = i;
 		}
 	}
@@ -942,12 +976,13 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 		irq = pirq & 0xf;
 		DBG(" -> hardcoded IRQ %d\n", irq);
 		msg = "Hardcoded";
-	} else if ( r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
-	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask)) ) {
+	} else if (r->get && (irq = r->get(pirq_router_dev, dev, pirq)) && \
+	((!(pci_probe & PCI_USE_PIRQ_MASK)) || ((1 << irq) & mask))) {
 		DBG(" -> got IRQ %d\n", irq);
 		msg = "Found";
 		eisa_set_level_irq(irq);
-	} else if (newirq && r->set && (dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
+	} else if (newirq && r->set &&
+		(dev->class >> 8) != PCI_CLASS_DISPLAY_VGA) {
 		DBG(" -> assigning IRQ %d", newirq);
 		if (r->set(pirq_router_dev, dev, pirq, newirq)) {
 			eisa_set_level_irq(newirq);
@@ -965,7 +1000,8 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 		} else
 			return 0;
 	}
-	printk(KERN_INFO "PCI: %s IRQ %d for device %s\n", msg, irq, pci_name(dev));
+	printk(KERN_INFO "PCI: %s IRQ %d for device %s\n", msg, irq,
+		pci_name(dev));
 
 	/* Update IRQ for all devices with the same pirq value */
 	while ((dev2 = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev2)) != NULL) {
@@ -977,20 +1013,23 @@ static int pcibios_lookup_irq(struct pci_dev *dev, int assign)
 		if (!info)
 			continue;
 		if (info->irq[pin].link == pirq) {
-			/* We refuse to override the dev->irq information. Give a warning! */
-		    	if ( dev2->irq && dev2->irq != irq && \
+			/* We refuse to override the dev->irq
+			 * information. Give a warning! */
+			if (dev2->irq && dev2->irq != irq && \
 			(!(pci_probe & PCI_USE_PIRQ_MASK) || \
-			((1 << dev2->irq) & mask)) ) {
+			((1 << dev2->irq) & mask))) {
 #ifndef CONFIG_PCI_MSI
-		    		printk(KERN_INFO "IRQ routing conflict for %s, have irq %d, want irq %d\n",
-				       pci_name(dev2), dev2->irq, irq);
+				printk(KERN_INFO "IRQ routing conflict for %s, "
+					"have irq %d, want irq %d\n",
+					pci_name(dev2), dev2->irq, irq);
 #endif
-		    		continue;
-		    	}
+				continue;
+			}
 			dev2->irq = irq;
 			pirq_penalty[irq]++;
 			if (dev != dev2)
-				printk(KERN_INFO "PCI: Sharing IRQ %d with %s\n", irq, pci_name(dev2));
+				printk(KERN_INFO "PCI: Sharing IRQ %d "
+					"with %s\n", irq, pci_name(dev2));
 		}
 	}
 	return 1;
@@ -1004,15 +1043,19 @@ static void __init pcibios_fixup_irqs(void)
 	DBG(KERN_DEBUG "PCI: IRQ fixup\n");
 	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
 		/*
-		 * If the BIOS has set an out of range IRQ number, just ignore it.
-		 * Also keep track of which IRQ's are already in use.
+		 * If the BIOS has set an out of range IRQ number, just
+		 * ignore it.  Also keep track of which IRQ's are
+		 * already in use.
 		 */
 		if (dev->irq >= 16) {
-			DBG(KERN_DEBUG "%s: ignoring bogus IRQ %d\n", pci_name(dev), dev->irq);
+			DBG(KERN_DEBUG "%s: ignoring bogus IRQ %d\n",
+				pci_name(dev), dev->irq);
 			dev->irq = 0;
 		}
-		/* If the IRQ is already assigned to a PCI device, ignore its ISA use penalty */
-		if (pirq_penalty[dev->irq] >= 100 && pirq_penalty[dev->irq] < 100000)
+		/* If the IRQ is already assigned to a PCI device,
+		 * ignore its ISA use penalty */
+		if (pirq_penalty[dev->irq] >= 100 &&
+				pirq_penalty[dev->irq] < 100000)
 			pirq_penalty[dev->irq] = 0;
 		pirq_penalty[dev->irq]++;
 	}
@@ -1024,31 +1067,38 @@ static void __init pcibios_fixup_irqs(void)
 		/*
 		 * Recalculate IRQ numbers if we use the I/O APIC.
 		 */
-		if (io_apic_assign_pci_irqs)
-		{
+		if (io_apic_assign_pci_irqs) {
 			int irq;
 
 			if (pin) {
-				pin--;		/* interrupt pins are numbered starting from 1 */
-				irq = IO_APIC_get_PCI_irq_vector(dev->bus->number, PCI_SLOT(dev->devfn), pin);
+				pin--; /* interrupt pins are numbered
+					  starting from 1 */
+				irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
+					PCI_SLOT(dev->devfn), pin);
 	/*
 	 * Busses behind bridges are typically not listed in the MP-table.
 	 * In this case we have to look up the IRQ based on the parent bus,
 	 * parent slot, and pin number. The SMP code detects such bridged
 	 * busses itself so we should get into this branch reliably.
 	 */
-				if (irq < 0 && dev->bus->parent) { /* go back to the bridge */
-					struct pci_dev * bridge = dev->bus->self;
+				if (irq < 0 && dev->bus->parent) {
+					/* go back to the bridge */
+					struct pci_dev *bridge = dev->bus->self;
 
 					pin = (pin + PCI_SLOT(dev->devfn)) % 4;
-					irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number, 
-							PCI_SLOT(bridge->devfn), pin);
+					irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
+							PCI_SLOT(bridge->devfn),
+							pin);
 					if (irq >= 0)
-						printk(KERN_WARNING "PCI: using PPB %s[%c] to get irq %d\n",
-							pci_name(bridge), 'A' + pin, irq);
+						printk(KERN_WARNING "PCI: "
+							"using PPB %s[%c] to "
+							"get irq %d\n",
+							pci_name(bridge),
+							'A' + pin, irq);
 				}
 				if (irq >= 0) {
-					printk(KERN_INFO "PCI->APIC IRQ transform: %s[%c] -> IRQ %d\n",
+					printk(KERN_INFO "PCI->APIC IRQ "
+						"transform: %s[%c] -> IRQ %d\n",
 						pci_name(dev), 'A' + pin, irq);
 					dev->irq = irq;
 				}
@@ -1071,7 +1121,8 @@ static int __init fix_broken_hp_bios_irq9(const struct dmi_system_id *d)
 {
 	if (!broken_hp_bios_irq9) {
 		broken_hp_bios_irq9 = 1;
-		printk(KERN_INFO "%s detected - fixing broken IRQ routing\n", d->ident);
+		printk(KERN_INFO "%s detected - fixing broken IRQ routing\n",
+			d->ident);
 	}
 	return 0;
 }
@@ -1084,7 +1135,8 @@ static int __init fix_acer_tm360_irqrouting(const struct dmi_system_id *d)
 {
 	if (!acer_tm360_irqrouting) {
 		acer_tm360_irqrouting = 1;
-		printk(KERN_INFO "%s detected - fixing broken IRQ routing\n", d->ident);
+		printk(KERN_INFO "%s detected - fixing broken IRQ routing\n",
+			d->ident);
 	}
 	return 0;
 }
@@ -1096,7 +1148,8 @@ static struct dmi_system_id __initdata pciirq_dmi_table[] = {
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
 			DMI_MATCH(DMI_BIOS_VERSION, "GE.M1.03"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "HP Pavilion Notebook Model GE"),
+			DMI_MATCH(DMI_PRODUCT_VERSION,
+				"HP Pavilion Notebook Model GE"),
 			DMI_MATCH(DMI_BOARD_VERSION, "OmniBook N32N-736"),
 		},
 	},
@@ -1131,11 +1184,12 @@ static int __init pcibios_irq_init(void)
 		pirq_find_router(&pirq_router);
 		if (pirq_table->exclusive_irqs) {
 			int i;
-			for (i=0; i<16; i++)
+			for (i = 0; i < 16; i++)
 				if (!(pirq_table->exclusive_irqs & (1 << i)))
 					pirq_penalty[i] += 100;
 		}
-		/* If we're using the I/O APIC, avoid using the PCI IRQ routing table */
+		/* If we're using the I/O APIC, avoid using the PCI IRQ
+		 * routing table */
 		if (io_apic_assign_pci_irqs)
 			pirq_table = NULL;
 	}
@@ -1182,34 +1236,41 @@ static int pirq_enable_irq(struct pci_dev *dev)
 	if (pin && !pcibios_lookup_irq(dev, 1) && !dev->irq) {
 		char *msg = "";
 
-		pin--;		/* interrupt pins are numbered starting from 1 */
+		pin--; /* interrupt pins are numbered starting from 1 */
 
 		if (io_apic_assign_pci_irqs) {
 			int irq;
 
-			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number, PCI_SLOT(dev->devfn), pin);
+			irq = IO_APIC_get_PCI_irq_vector(dev->bus->number,
+				PCI_SLOT(dev->devfn), pin);
 			/*
-			 * Busses behind bridges are typically not listed in the MP-table.
-			 * In this case we have to look up the IRQ based on the parent bus,
-			 * parent slot, and pin number. The SMP code detects such bridged
-			 * busses itself so we should get into this branch reliably.
+			 * Busses behind bridges are typically not
+			 * listed in the MP-table.  In this case we have
+			 * to look up the IRQ based on the parent bus,
+			 * parent slot, and pin number. The SMP code
+			 * detects such bridged busses itself so we
+			 * should get into this branch reliably.
 			 */
 			temp_dev = dev;
-			while (irq < 0 && dev->bus->parent) { /* go back to the bridge */
-				struct pci_dev * bridge = dev->bus->self;
+			while (irq < 0 && dev->bus->parent) {
+				/* go back to the bridge */
+				struct pci_dev *bridge = dev->bus->self;
 
 				pin = (pin + PCI_SLOT(dev->devfn)) % 4;
-				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number, 
+				irq = IO_APIC_get_PCI_irq_vector(bridge->bus->number,
 						PCI_SLOT(bridge->devfn), pin);
 				if (irq >= 0)
-					printk(KERN_WARNING "PCI: using PPB %s[%c] to get irq %d\n",
-						pci_name(bridge), 'A' + pin, irq);
+					printk(KERN_WARNING "PCI: using PPB "
+						"%s[%c] to get irq %d\n",
+						pci_name(bridge),
+						'A' + pin, irq);
 				dev = bridge;
 			}
 			dev = temp_dev;
 			if (irq >= 0) {
-				printk(KERN_INFO "PCI->APIC IRQ transform: %s[%c] -> IRQ %d\n",
-					pci_name(dev), 'A' + pin, irq);
+				printk(KERN_INFO "PCI->APIC IRQ transform: "
+					"%s[%c] -> IRQ %d\n", pci_name(dev),
+					'A' + pin, irq);
 				dev->irq = irq;
 				return 0;
 			} else
@@ -1219,12 +1280,14 @@ static int pirq_enable_irq(struct pci_dev *dev)
 		else
 			msg = " Please try using pci=biosirq.";
 
-		/* With IDE legacy devices the IRQ lookup failure is not a problem.. */
-		if (dev->class >> 8 == PCI_CLASS_STORAGE_IDE && !(dev->class & 0x5))
+		/* With IDE legacy devices the IRQ lookup failure is not
+		 * a problem.. */
+		if (dev->class >> 8 == PCI_CLASS_STORAGE_IDE &&
+				!(dev->class & 0x5))
 			return 0;
 
-		printk(KERN_WARNING "PCI: No IRQ known for interrupt pin %c of device %s.%s\n",
-		       'A' + pin, pci_name(dev), msg);
+		printk(KERN_WARNING "PCI: No IRQ known for interrupt pin "
+		       "%c of device %s.%s\n", 'A' + pin, pci_name(dev), msg);
 	}
 	return 0;
 }
-- 
1.5.4.3

