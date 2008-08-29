Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbYH2Amg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbYH2Amg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 20:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYH2Am1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 20:42:27 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:21622 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbYH2Am0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 20:42:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=a3li0HRA+645chtb2AawkG+2QqPcCaX8LQ1B8JNUD6QtipNXCiBqz2QOc3WhfhdUME
         HN9QkHGCs8OR/CwCSbKOEyBa/Eemn19KZPnnZGHOixUagcLqWh7ohmTV0oY/ntjwjBro
         9e0rKnAEsY0C5u2g6qokK061B3nsxOwZqEm2o=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: split e820 reserved entries record to late v3
Date: Thu, 28 Aug 2008 17:41:29 -0700
Message-Id: <1219970489-1615-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could let BAR res register at first, or even pnp?

v2: insert e820 reserve resources before pnp_system_init
v3: fix merging problem in tip/x86/core
    please drop the one in tip/x86/core use this one instead

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/e820.c |   20 ++++++++++++++++++--
 arch/x86/pci/i386.c    |    3 +++
 include/asm-x86/e820.h |    1 +
 3 files changed, 22 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1271,13 +1271,15 @@ static inline const char *e820_type_to_s
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
+struct resource __initdata *e820_res;
 void __init e820_reserve_resources(void)
 {
 	int i;
-	struct resource *res;
 	u64 end;
+	struct resource *res;
 
 	res = alloc_bootmem_low(sizeof(struct resource) * e820.nr_map);
+	e820_res = res;
 	for (i = 0; i < e820.nr_map; i++) {
 		end = e820.map[i].addr + e820.map[i].size - 1;
 #ifndef CONFIG_RESOURCES_64BIT
@@ -1291,7 +1293,8 @@ void __init e820_reserve_resources(void)
 		res->end = end;
 
 		res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
-		insert_resource(&iomem_resource, res);
+		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20))
+			insert_resource(&iomem_resource, res);
 		res++;
 	}
 
@@ -1303,6 +1306,19 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+void __init e820_reserve_resources_late(void)
+{
+	int i;
+	struct resource *res;
+
+	res = e820_res;
+	for (i = 0; i < e820.nr_map; i++) {
+		if (e820.map[i].type == E820_RESERVED && res->start >= (1ULL<<20))
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
