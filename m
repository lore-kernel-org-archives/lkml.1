Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbYIEMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbYIEMGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 08:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbYIEMGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 08:06:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:28969 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYIEMGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 08:06:05 -0400
Message-Id: <48C13CE0.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Fri, 05 Sep 2008 13:06:24 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix printk format compiler warnings
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%llx and the like cannot be used on u64-derived data types - they must
be cast to long long explicitly for arch-es where u64 is a typedef of
unsigned long (ia64 is where I observed the problem).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/pci/probe.c     |   16 +++++++++++++---
 drivers/pci/setup-bus.c |    6 +++++-
 2 files changed, 18 insertions(+), 4 deletions(-)

--- linux-2.6.27-rc5/drivers/pci/probe.c	2008-08-21 14:37:32.000000000 +0200
+++ 2.6.27-rc5-pci-probe-print/drivers/pci/probe.c	2008-09-02 15:18:08.000000000 +0200
@@ -383,7 +383,10 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s io port: [%Lx, %Lx]\n",
+		       pci_name(dev),
+		       (unsigned long long)res->start,
+		       (unsigned long long)res->end);
 	}
 
 	res = child->resource[1];
@@ -395,7 +398,10 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%Lx, %Lx]\n",
+		       pci_name(dev),
+		       (unsigned long long)res->start,
+		       (unsigned long long)res->end);
 	}
 
 	res = child->resource[2];
@@ -431,7 +437,11 @@ void __devinit pci_read_bridge_bases(str
 		res->flags = (mem_base_lo & PCI_MEMORY_RANGE_TYPE_MASK) | IORESOURCE_MEM | IORESOURCE_PREFETCH;
 		res->start = base;
 		res->end = limit + 0xfffff;
-		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n", pci_name(dev), (res->flags & PCI_PREF_RANGE_TYPE_64)?"64":"32",res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s %dbit mmio pref: [%Lx, %Lx]\n",
+		       pci_name(dev),
+		       res->flags & PCI_PREF_RANGE_TYPE_64 ? 64 : 32,
+		       (unsigned long long)res->start,
+		       (unsigned long long)res->end);
 	}
 }
 
--- linux-2.6.27-rc5/drivers/pci/setup-bus.c	2008-08-21 14:37:32.000000000 +0200
+++ 2.6.27-rc5-pci-probe-print/drivers/pci/setup-bus.c	2008-09-02 15:18:20.000000000 +0200
@@ -539,7 +539,11 @@ static void pci_bus_dump_res(struct pci_
                 if (!res)
                         continue;
 
-		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
+		printk(KERN_INFO "bus: %02x index %x %s: [%Lx, %Lx]\n",
+		       bus->number, i,
+		       res->flags & IORESOURCE_IO ? "io port" : "mmio",
+		       (unsigned long long)res->start,
+		       (unsigned long long)res->end);
         }
 }
 



