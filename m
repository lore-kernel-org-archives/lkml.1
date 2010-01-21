Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756Ab0AUG3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0AUG3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 01:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753481Ab0AUG3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 01:29:05 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38769 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab0AUG3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 01:29:01 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 20 Jan 2010 22:27:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/36] x86/pci: enable pci root res read out for 32bit too
In-reply-to: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1264055303-15123-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1264055303-15123-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

should be good for 32bit too.

-v3: cast res->start

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/Makefile    |    3 +--
 arch/x86/pci/amd_bus.c   |   14 +-------------
 arch/x86/pci/bus_numa.h  |    4 ++--
 arch/x86/pci/i386.c      |    4 ----
 arch/x86/pci/intel_bus.c |    2 +-
 5 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 564b008..30e55d7 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -14,8 +14,7 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
 obj-y				+= common.o early.o
-obj-y				+= amd_bus.o
-obj-$(CONFIG_X86_64)		+= bus_numa.o intel_bus.o
+obj-y				+= amd_bus.o bus_numa.o intel_bus.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 66a5d5a..6221720 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
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
@@ -341,21 +337,13 @@ static int __init early_fill_mp_bus_info(void)
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
diff --git a/arch/x86/pci/bus_numa.h b/arch/x86/pci/bus_numa.h
index adbc23f..66d4ea0 100644
--- a/arch/x86/pci/bus_numa.h
+++ b/arch/x86/pci/bus_numa.h
@@ -1,5 +1,5 @@
-#ifdef CONFIG_X86_64
-
+#ifndef __BUS_NUMA_H
+#define __BUS_NUMA_H
 /*
  * sub bus (transparent) will use entres from 3 to store extra from
  * root, so need to make sure we have enough slot there, Should we
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5dc9e8c..f4e8481 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -257,10 +257,6 @@ void __init pcibios_resource_survey(void)
  */
 fs_initcall(pcibios_assign_resources);
 
-void __weak x86_pci_root_bus_res_quirks(struct pci_bus *b)
-{
-}
-
 /*
  *  If we set up a device for bus mastering, we need to check the latency
  *  timer as certain crappy BIOSes forget to set it properly.
diff --git a/arch/x86/pci/intel_bus.c b/arch/x86/pci/intel_bus.c
index 145e0dd..603b9ab 100644
--- a/arch/x86/pci/intel_bus.c
+++ b/arch/x86/pci/intel_bus.c
@@ -30,7 +30,7 @@ static inline void print_ioh_resources(struct pci_root_info *info)
 			busnum, i,
 			(res->flags & IORESOURCE_IO) ? "io port" :
 							"mmio",
-			res->start, res->end);
+			(u64)res->start, (u64)res->end);
 	}
 }
 
-- 
1.6.4.2

