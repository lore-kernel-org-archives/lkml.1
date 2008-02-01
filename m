Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbYBARIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbYBARIq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759585AbYBARIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:08:37 -0500
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:19205 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbYBARIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:08:36 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <20080201608.475239056@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org,
       mel@csn.ul.ie
Subject: [PATCH] [1/2] Move NUMAQ io handling into arch/x86/pci/numa.c
Date: Fri,  1 Feb 2008 18:08:33 +0100 (CET)
X-OriginalArrivalTime: 01 Feb 2008 17:02:16.0042 (UTC) FILETIME=[326644A0:01C864F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


numa.c is the only user of the {in,out}*_quad functions. And it has only a few call
sites. Change them to open code the magic NUMAQ port access.

Only compile tested

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/x86/pci/numa.c
===================================================================
--- linux.orig/arch/x86/pci/numa.c
+++ linux/arch/x86/pci/numa.c
@@ -5,36 +5,62 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/nodemask.h>
+#include <mach_apic.h>
 #include "pci.h"
 
+#define XQUAD_PORTIO_BASE 0xfe400000
+#define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
+
 #define BUS2QUAD(global) (mp_bus_id_to_node[global])
 #define BUS2LOCAL(global) (mp_bus_id_to_local[global])
 #define QUADLOCAL2BUS(quad,local) (quad_local_to_mp_bus_id[quad][local])
 
+extern void *xquad_portio;    /* Where the IO area was mapped */
+#define XQUAD_PORT_ADDR(port, quad) (xquad_portio + (XQUAD_PORTIO_QUAD*quad) + port)
+
 #define PCI_CONF1_MQ_ADDRESS(bus, devfn, reg) \
 	(0x80000000 | (BUS2LOCAL(bus) << 16) | (devfn << 8) | (reg & ~3))
 
+static void write_cf8(unsigned bus, unsigned devfn, unsigned reg)
+{
+	unsigned val = PCI_CONF1_MQ_ADDRESS(bus, devfn, reg);
+	if (xquad_portio)
+		writel(val, XQUAD_PORT_ADDR(0xcf8, BUS2QUAD(bus)));
+	else
+		outl(val, 0xCF8);
+}
+
 static int pci_conf1_mq_read(unsigned int seg, unsigned int bus,
 			     unsigned int devfn, int reg, int len, u32 *value)
 {
 	unsigned long flags;
+	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
 
 	if (!value || (bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255))
 		return -EINVAL;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
 
-	outl_quad(PCI_CONF1_MQ_ADDRESS(bus, devfn, reg), 0xCF8, BUS2QUAD(bus));
+	write_cf8(bus, devfn, reg);
 
 	switch (len) {
 	case 1:
-		*value = inb_quad(0xCFC + (reg & 3), BUS2QUAD(bus));
+		if (xquad_portio)
+			*value = readb(adr + (reg & 3));
+		else
+			*value = inb(0xCFC + (reg & 3));
 		break;
 	case 2:
-		*value = inw_quad(0xCFC + (reg & 2), BUS2QUAD(bus));
+		if (xquad_portio)
+			*value = readw(adr + (reg & 2));
+		else
+			*value = inw(0xCFC + (reg & 2));
 		break;
 	case 4:
-		*value = inl_quad(0xCFC, BUS2QUAD(bus));
+		if (xquad_portio)
+			*value = readl(adr);
+		else
+			*value = inl(0xCFC);
 		break;
 	}
 
@@ -47,23 +73,33 @@ static int pci_conf1_mq_write(unsigned i
 			      unsigned int devfn, int reg, int len, u32 value)
 {
 	unsigned long flags;
+	void *adr __iomem = XQUAD_PORT_ADDR(0xcfc, BUS2QUAD(bus));
 
 	if ((bus >= MAX_MP_BUSSES) || (devfn > 255) || (reg > 255)) 
 		return -EINVAL;
 
 	spin_lock_irqsave(&pci_config_lock, flags);
 
-	outl_quad(PCI_CONF1_MQ_ADDRESS(bus, devfn, reg), 0xCF8, BUS2QUAD(bus));
+	write_cf8(bus, devfn, reg);
 
 	switch (len) {
 	case 1:
-		outb_quad((u8)value, 0xCFC + (reg & 3), BUS2QUAD(bus));
+		if (xquad_portio)
+			writeb(value, adr + (reg & 3));
+		else
+			outb((u8)value, 0xCFC + (reg & 3));
 		break;
 	case 2:
-		outw_quad((u16)value, 0xCFC + (reg & 2), BUS2QUAD(bus));
+		if (xquad_portio)
+			writew(value, adr + (reg & 2));
+		else
+			outw((u16)value, 0xCFC + (reg & 2));
 		break;
 	case 4:
-		outl_quad((u32)value, 0xCFC, BUS2QUAD(bus));
+		if (xquad_portio)
+			writel(value, adr + reg);
+		else
+			outl((u32)value, 0xCFC);
 		break;
 	}
 
Index: linux/include/asm-x86/mach-numaq/mach_apic.h
===================================================================
--- linux.orig/include/asm-x86/mach-numaq/mach_apic.h
+++ linux/include/asm-x86/mach-numaq/mach_apic.h
@@ -109,6 +109,8 @@ static inline int mpc_apic_id(struct mpc
 	return logical_apicid;
 }
 
+extern void *xquad_portio;
+
 static inline void setup_portio_remap(void)
 {
 	int num_quads = num_online_nodes();
