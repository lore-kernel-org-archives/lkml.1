Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbZLRULM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbZLRULM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932636AbZLRULH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:11:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:55334 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932632AbZLRULA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:11:00 -0500
Message-ID: <4B2BE191.9050702@kernel.org>
Date: Fri, 18 Dec 2009 12:09:53 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 6/7] x86/pci: enable pci root res read out for 32bit too -v3
References: <4B2BE063.4040704@kernel.org>
In-Reply-To: <4B2BE063.4040704@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


should be good for 32bit too.

-v3: cast res->start

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/Makefile    |    3 +--
 arch/x86/pci/amd_bus.c   |   14 +-------------
 arch/x86/pci/bus_numa.h  |    4 ++--
 arch/x86/pci/i386.c      |    4 ----
 arch/x86/pci/intel_bus.c |    2 +-
 5 files changed, 5 insertions(+), 22 deletions(-)

Index: linux-2.6/arch/x86/pci/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/pci/Makefile
+++ linux-2.6/arch/x86/pci/Makefile
@@ -14,8 +14,7 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
 obj-y				+= common.o early.o
-obj-y				+= amd_bus.o
-obj-$(CONFIG_X86_64)		+= bus_numa.o intel_bus.o
+obj-y				+= amd_bus.o bus_numa.o intel_bus.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
Index: linux-2.6/arch/x86/pci/amd_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/amd_bus.c
+++ linux-2.6/arch/x86/pci/amd_bus.c
@@ -6,9 +6,7 @@
 
 #include <asm/pci_x86.h>
 
-#ifdef CONFIG_X86_64
 #include <asm/pci-direct.h>
-#endif
 
 #include "bus_numa.h"
 
@@ -17,8 +15,6 @@
  * also get peer root bus resource for io,mmio
  */
 
-#ifdef CONFIG_X86_64
-
 struct pci_hostbridge_probe {
 	u32 bus;
 	u32 slot;
@@ -342,21 +338,13 @@ static int __init early_fill_mp_bus_info
 			printk(KERN_DEBUG "bus: %02x index %x %s: [%llx, %llx]\n",
 			       busnum, j,
 			       (res->flags & IORESOURCE_IO)?"io port":"mmio",
-			       res->start, res->end);
+			       (u64)res->start, (u64)res->end);
 		}
 	}
 
 	return 0;
 }
 
-#else  /* !CONFIG_X86_64 */
-
-static int __init early_fill_mp_bus_info(void) { return 0; }
-
-#endif /* !CONFIG_X86_64 */
-
-/* common 32/64 bit code */
-
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
 static void enable_pci_io_ecs(void *unused)
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -257,10 +257,6 @@ void __init pcibios_resource_survey(void
  */
 fs_initcall(pcibios_assign_resources);
 
-void __weak x86_pci_root_bus_res_quirks(struct pci_bus *b)
-{
-}
-
 /*
  *  If we set up a device for bus mastering, we need to check the latency
  *  timer as certain crappy BIOSes forget to set it properly.
Index: linux-2.6/arch/x86/pci/bus_numa.h
===================================================================
--- linux-2.6.orig/arch/x86/pci/bus_numa.h
+++ linux-2.6/arch/x86/pci/bus_numa.h
@@ -1,5 +1,5 @@
-#ifdef CONFIG_X86_64
-
+#ifndef __BUS_NUMA_H
+#define __BUS_NUMA_H
 /*
  * sub bus (transparent) will use entres from 3 to store extra from
  * root, so need to make sure we have enough slot there, Should we
Index: linux-2.6/arch/x86/pci/intel_bus.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/intel_bus.c
+++ linux-2.6/arch/x86/pci/intel_bus.c
@@ -30,7 +30,7 @@ static inline void print_ioh_resources(s
 			busnum, i,
 			(res->flags & IORESOURCE_IO) ? "io port" :
 							"mmio",
-			res->start, res->end);
+			(u64)res->start, (u64)res->end);
 	}
 }
 

