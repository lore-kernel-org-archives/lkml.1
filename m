Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbYIJTnM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbYIJTnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:43:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYIJTm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:42:57 -0400
Received: from aun.it.uu.se ([130.238.12.36]:64831 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYIJTm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:42:56 -0400
Date: Wed, 10 Sep 2008 21:42:50 +0200 (MEST)
Message-Id: <200809101942.m8AJgoXx029414@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: yhlu.kernel@gmail.com
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: [PATCH 2.6.27-rc6] pci: fix resource_size_t type errors
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix type errors introduced by commits 9bf8a1a79d549a0cf3b26c88d1ac8cdf07deafee
and 76fbc263ff7e42ce8b21b8aee176e3c74b45f81a, "pci: debug extra pci resources range"
and "pci: debug extra pci bus resources".

These commits added printks of resource_size_t values using "%llx" formats.
This is wrong for two reasons:
- resource_size_t may be u32 or u64, depending on arch and config options,
  but "%llx" only works with 64-bit integers; if there is a size mismatch,
  printk's argument pointer will move past the corresponding parameters on
  the stack (undefined behaviour)
- even if resource_size_t is u64, that type may be unsigned long or
  unsigned long long, depending on arch; if resource_size_t isn't unsigned
  long long, the compiler will generate type mismatch warnings

On my 32-bit x86 laptop, the first problem is visible in obviously bogus
kernel messages:

PCI: bridge 0000:00:01.0 io port: [2fff00002000, f787964000000300]
PCI: bridge 0000:00:01.0 32bit mmio: [d01fffffd0100000, f787964000000300]
PCI: bridge 0000:00:01.0 32bit mmio pref: [dfffffffd8000000, cf7879640]
...
bus: 00 index 0 io port: [ffff00000000, f7887c00]
bus: 00 index 1 mmio: [ffffffff00000000, f7887c00]
bus: 01 index 0 io port: [2fff00002000, f7887c14f7879400]
bus: 01 index 1 mmio: [d01fffffd0100000, f7887c14f7879400]
bus: 01 index 2 mmio: [dfffffffd8000000, f7887c14f7879400]
bus: 01 index 3 mmio: [0, f7887c14f7879400]
bus: 02 index 0 io port: [30ff00003000, f7887c14f7879000]
bus: 02 index 1 io port: [34ff00003400, f7887c14f7879000]
bus: 02 index 2 mmio: [73ffffff70000000, f7887c14f7879000]
bus: 02 index 3 mmio: [77ffffff74000000, f7887c14f7879000]

These aren't just cosmetic, that's printk running off the stack and
printing return addresses, kernel pointers, and similar nonsense.

The second problem is obvious from the warnings gcc-4.3.2 throws:

drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:386: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'
drivers/pci/probe.c:398: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 4 has type 'resource_size_t'
drivers/pci/probe.c:434: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/setup-bus.c:543: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'resource_size_t'
drivers/pci/setup-bus.c:543: warning: format '%llx' expects type 'long long unsigned int', but argument 6 has type 'resource_size_t'

The only correct type to pass to a "%llx" format is unsigned long long,
so this patch fixes the errors by adding (unsigned long long) casts to
the offending printk parameters.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
 drivers/pci/probe.c     |   16 +++++++++++++---
 drivers/pci/setup-bus.c |    6 +++++-
 2 files changed, 18 insertions(+), 4 deletions(-)

diff -rupN linux-2.6.27-rc6/drivers/pci/probe.c linux-2.6.27-rc6.resource_size_t-printks/drivers/pci/probe.c
--- linux-2.6.27-rc6/drivers/pci/probe.c	2008-09-10 19:19:26.000000000 +0200
+++ linux-2.6.27-rc6.resource_size_t-printks/drivers/pci/probe.c	2008-09-10 20:22:28.000000000 +0200
@@ -383,7 +383,10 @@ void __devinit pci_read_bridge_bases(str
 			res->start = base;
 		if (!res->end)
 			res->end = limit + 0xfff;
-		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n", pci_name(dev), res->start, res->end);
+		printk(KERN_INFO "PCI: bridge %s io port: [%llx, %llx]\n",
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
+		printk(KERN_INFO "PCI: bridge %s 32bit mmio: [%llx, %llx]\n",
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
+		printk(KERN_INFO "PCI: bridge %s %sbit mmio pref: [%llx, %llx]\n",
+		       pci_name(dev),
+		       (res->flags & PCI_PREF_RANGE_TYPE_64) ? "64" : "32",
+		       (unsigned long long)res->start,
+		       (unsigned long long)res->end);
 	}
 }
 
diff -rupN linux-2.6.27-rc6/drivers/pci/setup-bus.c linux-2.6.27-rc6.resource_size_t-printks/drivers/pci/setup-bus.c
--- linux-2.6.27-rc6/drivers/pci/setup-bus.c	2008-09-10 19:19:26.000000000 +0200
+++ linux-2.6.27-rc6.resource_size_t-printks/drivers/pci/setup-bus.c	2008-09-10 20:23:30.000000000 +0200
@@ -540,7 +540,11 @@ static void pci_bus_dump_res(struct pci_
                 if (!res)
                         continue;
 
-		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n", bus->number, i, (res->flags & IORESOURCE_IO)? "io port":"mmio", res->start, res->end);
+		printk(KERN_INFO "bus: %02x index %x %s: [%llx, %llx]\n",
+		       bus->number, i,
+		       (res->flags & IORESOURCE_IO) ? "io port" : "mmio",
+		       (unsigned long long)res->start,
+		       (unsigned long long)res->end);
         }
 }
 
