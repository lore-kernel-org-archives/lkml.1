Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbYH2BbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbYH2BbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 21:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbYH2Bau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 21:30:50 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:27157 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbYH2Bat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 21:30:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=xDKxahXL0r30e8TAfoZgtGe9ebpWrqN5Vfobu69BWbjPv6PfARNfOXXdHlnPqFKvCZ
         itKoQ6Pg4K23JEZVMnEFsSLxv/5SOPSMgDTHL6wMy8sG65M5n5T7nnJxJB1Ff0524Yvq
         B5QC/Q/EBN17oFJYc22qDxTTdxn0nhbFAtExk=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: split e820 reserved entries record to late v4
Date: Thu, 28 Aug 2008 18:29:51 -0700
Message-Id: <1219973391-9580-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus said we should register some entries in e820 later,
so could let BAR res register at first, or even pnp?

this one replace
| commit a2bd7274b47124d2fc4dfdb8c0591f545ba749dd
| Author: Yinghai Lu <yhlu.kernel@gmail.com>
| Date:   Mon Aug 25 00:56:08 2008 -0700
|
|    x86: fix HPET regression in 2.6.26 versus 2.6.25, check hpet against BAR, v3

v2: insert e820 reserve resources before pnp_system_init
v3: fix merging problem in tip/x86/core
    please drop the one in tip/x86/core use this one instead
v4: address Linus's review about comments and condition in _late()

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   24 +++++++++++++++++++++++-
 arch/x86/pci/i386.c    |    3 +++
 include/asm-x86/e820.h |    1 +
 3 files changed, 27 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1271,6 +1271,7 @@ static inline const char *e820_type_to_s
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
+static struct resource __initdata *e820_res;
 void __init e820_reserve_resources(void)
 {
 	int i;
@@ -1278,6 +1279,7 @@ void __init e820_reserve_resources(void)
 	u64 end;
 
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
@@ -1291,7 +1293,14 @@ void __init e820_reserve_resources(void)
 		res->end = end;
 
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		insert_resource(&iomem_resource, res);
+
+		/*
+		 * don't register the region that could be conflicted with
+		 * pci device BAR resource and insert them later in
+		 * pcibios_resource_survey()
+		 */
+		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
+			insert_resource(&iomem_resource, res);
 		res++;
 	}
 
@@ -1303,6 +1312,19 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+void __init e820_reserve_resources_late(void)
+{
+	int i;
+	struct resource *res;
+
+	res = e820_res;
+	for (i = 0; i < e820.nr_map; i++) {
+		if (!res->parent && res->end)
+			insert_resource(&iomem_resource, res);
+		res++;
+	}
+}
+
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
Index: linux-2.6/arch/x86/pci/i386.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/i386.c
+++ linux-2.6/arch/x86/pci/i386.c
@@ -33,6 +33,7 @@
 #include <linux/bootmem.h>
 
 #include <asm/pat.h>
+#include <asm/e820.h>
 
 #include "pci.h"
 
@@ -230,6 +231,8 @@ void __init pcibios_resource_survey(void
 	pcibios_allocate_bus_resources(&pci_root_buses);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
+
+	e820_reserve_resources_late();
 }
 
 /**
Index: linux-2.6/include/asm-x86/e820.h
===================================================================
--- linux-2.6.orig/include/asm-x86/e820.h
+++ linux-2.6/include/asm-x86/e820.h
@@ -122,6 +122,7 @@ extern void e820_register_active_regions
 extern u64 e820_hole_size(u64 start, u64 end);
 extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
+extern void e820_reserve_resources_late(void);
 extern void setup_memory_map(void);
 extern char *default_machine_specific_memory_setup(void);
 extern char *machine_specific_memory_setup(void);
