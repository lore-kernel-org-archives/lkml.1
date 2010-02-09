Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0BITkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:40:46 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54604 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/35] x86/pci: enable pci root res read out for 32bit too
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

should be good for 32bit too.

-v3: cast res->start
-v4: according to Linus, to use %pR instead of cast

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/Makefile   |    3 +--
 arch/x86/pci/amd_bus.c  |   18 ++----------------
 arch/x86/pci/bus_numa.h |    4 ++--
 arch/x86/pci/i386.c     |    4 ----
 4 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 39fba37..0b7d3e9 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -14,8 +14,7 @@ obj-$(CONFIG_X86_VISWS)		+= visws.o
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 
 obj-y				+= common.o early.o
-obj-y				+= amd_bus.o
-obj-$(CONFIG_X86_64)		+= bus_numa.o
+obj-y				+= amd_bus.o bus_numa.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 9bcb6fe..badef12 100644
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
@@ -339,24 +335,14 @@ static int __init early_fill_mp_bus_info(void)
 		       info->bus_min, info->bus_max, info->node, info->link);
 		for (j = 0; j < res_num; j++) {
 			res = &info->res[j];
-			printk(KERN_DEBUG "bus: %02x index %x %s: [%llx, %llx]\n",
-			       busnum, j,
-			       (res->flags & IORESOURCE_IO)?"io port":"mmio",
-			       res->start, res->end);
+			printk(KERN_DEBUG "bus: %02x index %x %pR\n",
+				       busnum, j, res);
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
index f63e802..08d8e15 100644
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
-- 
1.6.4.2

