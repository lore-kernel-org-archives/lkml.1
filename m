Return-Path: <linux-kernel-owner+w=401wt.eu-S935136AbZLKXln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935136AbZLKXln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935126AbZLKXlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:41:00 -0500
Received: from hera.kernel.org ([140.211.167.34]:57313 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934703AbZLKXgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:36:48 -0500
Message-ID: <4B22D74D.4020201@kernel.org>
Date: Fri, 11 Dec 2009 15:35:41 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 6/7] x86/pci: enable pci root res read out for 32bit too
References: <4B22D4DA.2000104@kernel.org>
In-Reply-To: <4B22D4DA.2000104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


should be good for 32bit too.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/pci/Makefile   |    3 +--
 arch/x86/pci/amd_bus.c  |   17 +++--------------
 arch/x86/pci/bus_numa.h |    4 ++--
 arch/x86/pci/i386.c     |    4 ----
 4 files changed, 6 insertions(+), 22 deletions(-)

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
@@ -207,7 +203,7 @@ static int __init early_fill_mp_bus_info
 	address = MSR_K8_TOP_MEM1;
 	rdmsrl(address, val);
 	end = (val & 0xffffff800000ULL);
-	printk(KERN_INFO "TOM: %016lx aka %ldM\n", end, end>>20);
+	printk(KERN_INFO "TOM: %016llx aka %lldM\n", (u64)end, (u64)end>>20);
 	if (end < (1ULL<<32))
 		subtract_range(range, RANGE_NUM, 0, end - 1);
 
@@ -301,7 +297,8 @@ static int __init early_fill_mp_bus_info
 		address = MSR_K8_TOP_MEM2;
 		rdmsrl(address, val);
 		end = (val & 0xffffff800000ULL);
-		printk(KERN_INFO "TOM2: %016lx aka %ldM\n", end, end>>20);
+		printk(KERN_INFO "TOM2: %016llx aka %lldM\n", (u64)end,
+							 (u64)end>>20);
 		subtract_range(range, RANGE_NUM, 1ULL<<32, end - 1);
 	}
 
@@ -347,14 +344,6 @@ static int __init early_fill_mp_bus_info
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


