Return-Path: <linux-kernel-owner+w=401wt.eu-S1753694AbYH2MgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbYH2MgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 08:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYH2Mf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 08:35:59 -0400
Received: from aun.it.uu.se ([130.238.12.36]:53982 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456AbYH2Mf6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 08:35:58 -0400
Date: Fri, 29 Aug 2008 14:35:53 +0200 (MEST)
Message-Id: <200808291235.m7TCZr6o007209@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: jbarnes@virtuousgeek.org
Subject: [PATCH 2.6.27-rc5] pci: fix resource_size_t printk bugs
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling 2.6.27-rc5 on 32-bit x86 with CONFIG_RESOURCES_64BIT=n
results in numerous warnings from drivers/pci:

drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/setup-bus.c:542: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/setup-bus.c:542: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'

resource_size_t can be u32 or u64 (see include/linux/types.h) but the printk
formats always say "%llx" which expects u64, resulting in general badness.

This patch fixes it by casting the offending printk parameters to u64.

(I would have preferred to make linux/types.h #define a proper format string
for resource_size_t, like <inttypes.h> does in user-space, but there doesn't
seem to be a precedent for that in the Linux kernel, so I used casts instead.)

The effect of this bug can be seen in this partial diff between a dmesg log
from a vanilla 2.6.27-rc5 and one with the fix applied:

--- dmesg-2.6.27-rc5.bad	2008-08-29 13:50:58.000000000 +0200
+++ dmesg-2.6.27-rc5	2008-08-29 14:09:20.000000000 +0200
@@ -159,16 +159,16 @@
 pci 0000:01:00.0: supports D2
 pci 0000:01:00.1: supports D1
 pci 0000:01:00.1: supports D2
-PCI: bridge 0000:00:01.0 io port: [bfff00009000, f78e9e5000000380]
-PCI: bridge 0000:00:01.0 32bit mmio: [ff8fffffff800000, f78e9e5000000380]
-PCI: bridge 0000:00:01.0 64bit mmio pref: [dfefffffbff00000, f78e9e50]
+PCI: bridge 0000:00:01.0 io port: [9000, bfff]
+PCI: bridge 0000:00:01.0 32bit mmio: [ff800000, ff8fffff]
+PCI: bridge 0000:00:01.0 64bit mmio pref: [bff00000, dfefffff]
 pci 0000:02:02.0: supports D1
 pci 0000:02:02.0: supports D2
 pci 0000:02:02.0: PME# supported from D1 D2 D3hot D3cold
 pci 0000:02:02.0: PME# disabled
 pci 0000:00:1e.0: transparent bridge
-PCI: bridge 0000:00:1e.0 io port: [cfff0000c000, f78eba5000000200]
-PCI: bridge 0000:00:1e.0 32bit mmio: [ff9fffffff900000, f78eba5000000200]
+PCI: bridge 0000:00:1e.0 io port: [c000, cfff]
+PCI: bridge 0000:00:1e.0 32bit mmio: [ff900000, ff9fffff]
 bus 00 -> node 0
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
 ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 drivers/pci/probe.c     |    6 +++---
 drivers/pci/setup-bus.c |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

--- linux-2.6.27-rc5/drivers/pci/probe.c.~1~	2008-08-29 13:08:53.000000000 +0200
+++ linux-2.6.27-rc5/drivers/pci/probe.c	2008-08-29 13:58:38.000000000 +0200
@@ -383,7 +383,7 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), (u64)res->start, (u64)res->end);
 	}
 
 	res = child->resource[1];
@@ -395,7 +395,7 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), (u64)res->start, (u64)res->end);
 	}
 
 	res = child->resource[2];
@@ -431,7 +431,7 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32", (u64)res->start, (u64)res->end);
 	}
 }
 
--- linux-2.6.27-rc5/drivers/pci/setup-bus.c.~1~	2008-08-29 13:08:53.000000000 +0200
+++ linux-2.6.27-rc5/drivers/pci/setup-bus.c	2008-08-29 13:59:00.000000000 +0200
@@ -539,7 +539,7 @@ static void pci_bus_dump_res(struct pci_
                 if (!res)
                         continue;
 
-		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
+		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", (u64)res->start, (u64)res->end);
         }
 }
 
